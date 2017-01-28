package {

  import flash.display.DisplayObject;
  import flash.display.Loader;
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import flash.events.SecurityErrorEvent;
  import flash.media.Sound;
  import flash.net.URLRequest;
  import flash.net.URLStream;
  import flash.system.ApplicationDomain;
  import flash.system.LoaderContext;
  import flash.utils.ByteArray;
  import flash.utils.Dictionary;


  public class AssetResourcesLoader {
    // ================== Static section ===============================
    // ------------------ Fields -----------------------------------
    public static const ATTEMPTS: int = 3;

    // ------------------ Methods  ---------------------------------
    // ================== Class section ================================
    // ------------------ Fields -----------------------------------
    protected var _loadedSignal: Signal = new Signal(Boolean);
    protected var _result: Dictionary = new Dictionary(true);
    [ArrayElementType("model.Asset")]
    protected var _assets: Array = [];
    [ArrayElementType("String")]
    protected var _urls: Array = [];
    protected var _baseUrl: String = "";
    protected var _urlLoader: URLStream;
    [ArrayElementType("String")]
    protected var _queue: Array = [];
    protected var _attempts: Dictionary = new Dictionary(true);
    protected var _myContext: LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
    protected var _currentUrl: String;
    [ArrayElementType("flash.display.Loader")]
    protected var _loaders: Dictionary;
    protected var _loadersCurrent: int;
    protected var _loadersTotal: int;

    // ------------------ Constructor ------------------------------
    public function AssetResourcesLoader(baseUrl: String = "") {
      super();
      _baseUrl = baseUrl;
    }

    // ------------------ Properties -------------------------------
    public function get loadedSignal(): Signal {
      return _loadedSignal;
    }

    // ------------------ Public methods  --------------------------
    public function add(asset: Asset): void {
      if (!asset) {
        return;
      }

      _assets.push(asset);
      _urls = _urls.concat(asset.urls);
    }

    public function setResourcesOn(asset: Asset): void {
      if (!asset) {
        return;
      }

      var res: Dictionary = new Dictionary(true);
      var ldr: Loader;
      var urls: Array = asset.urls;
      for each(var url: String in urls) {
        if (url) {
          ldr = new Loader();
          ldr.loadBytes(_result[url], _myContext);
          res[url] = ldr;
        }
      }
      asset.resources = res;
    }

    public function getResource(url: String): DisplayObject {
      if (url && url.length && _result && _result[url]) {
        var ldr: Loader = new Loader();
        ldr.loadBytes(_result[url], _myContext);
        return ldr;
      }
      return null;
    }

    public function start(): void {
      if (!_urls || !_urls.length) {
        _loadedSignal.dispatch(true);
      }

      for each(var string: String in _urls) {
        if (string) {
          _queue.push(string);
          _attempts[string] = ATTEMPTS;
        }
      }
      if (_queue.length) {
        _processQueue();
      }
      else {
        _loadedSignal.dispatch(true);
      }
    }

    public function remove(): void {
      _result = null;
      _assets = null;
      _urls = null;
      if (_loadedSignal) {
        _loadedSignal.removeAll();
        _loadedSignal = null;
      }

      _queue = null;
      _attempts = null;
      _loaders = null;
      _clearLoader();
    }

    // ------------------ Protected methods  -----------------------
    protected function _processQueue(): void {
      _clearLoader();
      _currentUrl = _queue.shift();
      _urlLoader = new URLStream();
      _urlLoader.addEventListener(Event.COMPLETE, onCurrentLoaded);
      _urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
      _urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);

      _urlLoader.load(new URLRequest(_baseUrl + _currentUrl));
    }

    protected function _clearLoader(): void {
      _currentUrl = null;
      if (_urlLoader) {
        _urlLoader.removeEventListener(Event.COMPLETE, onCurrentLoaded);
        _urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
        _urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
        _urlLoader.close();
        _urlLoader = null;
      }
    }

    protected function _fillResult(): void {
      _loaders = new Dictionary(true);
      _loadersCurrent = 0;
      _loadersTotal = 0;
      var ldr: Loader;
      var snd: Sound;
      var bArray: ByteArray
      var assetUrls: Array;

      for each(var asset: Asset in _assets) {
        assetUrls = asset ? asset.urls : null;
        if (asset && asset.urls && asset.urls.length) {
          _loaders[asset] = new Dictionary(true);

          for each(var aUrl: String in assetUrls) {
            if (aUrl && aUrl.length && _result[aUrl] && (_result[aUrl] as ByteArray)) {
              snd = null;
              ldr = null;
              bArray = _result[aUrl];

              if (aUrl.indexOf(".mp3") != -1) {
                snd = new Sound();
                snd.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLDRError);
                snd.addEventListener(IOErrorEvent.IO_ERROR, onLDRError);
                _loaders[asset][aUrl] = snd;
                try {
                  snd.loadCompressedDataFromByteArray(bArray, bArray.bytesAvailable);
                }
                catch (error: Error) {
                  trace("Error converting loaded ByteArray to Sound: " + aUrl + "\n" + error.getStackTrace());
                  _loadedSignal.dispatch(false);
                }
              }
              else {
                ++_loadersTotal;
                ldr = new Loader();
                ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadersComplete);
                ldr.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLDRError);
                ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLDRError);
                try {
                  ldr.loadBytes(bArray, _myContext);
                }
                catch (error: Error) {
                  trace("Error converting loaded ByteArray to Loader: " + aUrl + "\n" + error.getStackTrace());
                  _loadedSignal.dispatch(false);
                }

                _loaders[asset][aUrl] = ldr;
              }
            }
          }
        }
      }
    }

    // ------------------ Event handlers ----------------------------
    protected function onError(event: IOErrorEvent): void {
      if (int(_attempts[_currentUrl]) > 0) {
        _attempts[_currentUrl] = int(_attempts[_currentUrl]) - 1;
        _queue.push(_currentUrl);
        trace("Error loading file: " + _currentUrl);
      }
      else {
        trace("Error loading file: " + _currentUrl + " at last attempt, aborting!");
        _loadedSignal.dispatch(false);
      }
      _clearLoader();
    }

    protected function onCurrentLoaded(event: Event): void {
      var inputBytes: ByteArray = new ByteArray();
      _urlLoader.readBytes(inputBytes);
      if (inputBytes && inputBytes.length) {
        _result[_currentUrl] = inputBytes;
        delete _attempts[_currentUrl];
      }

      _clearLoader();

      if (_queue.length) {
        _processQueue();
      }
      else {
        _fillResult();
      }
    }

    protected function onLDRError(event: IOErrorEvent): void {
      event.currentTarget.removeEventListener(Event.COMPLETE, onLoadersComplete);
      event.currentTarget.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLDRError);
      event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, onLDRError);

      trace("Error converting loaded ByteArray to " + event.currentTarget);
      _loadedSignal.dispatch(false);
    }

    private function onLoadersComplete(event: Event): void {
      event.currentTarget.removeEventListener(Event.COMPLETE, onLoadersComplete);
      event.currentTarget.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLDRError);
      event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, onLDRError);

      ++_loadersCurrent;

      if (_loadersCurrent >= _loadersTotal) {
        for each(var asset: Asset in _assets) {
          if (asset) {
            asset.resources = _loaders[asset];
            _loaders[asset] = null;
          }
        }
        _loadedSignal.dispatch(true);
        _loaders = null;
      }
    }
  }
}
