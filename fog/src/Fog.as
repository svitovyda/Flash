package {

  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.display.PixelSnapping;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.filters.BitmapFilterQuality;
  import flash.filters.BlurFilter;
  import flash.filters.ColorMatrixFilter;
  import flash.geom.Matrix;
  import flash.geom.Point;


  public final class Fog extends Sprite {
    private var _width: Number;
    private var _height: Number;

    private var _middleWidth: Number;
    private var _middleHeight: Number;

    private const LINE_NUM: uint = 4;
    private var lines: Array = [];

    private var _deformationMap: BitmapData;
    private var _canvas: BitmapData;
    private var _bmp: Bitmap;

    private var _val: Number = 0;

    private var _pointZero: Point = new Point(0, 0);
    private var _pointOffset1: Point = new Point(0, 0);
    private var _pointOffset2: Point = new Point(0, 0);

    public function Fog() {
      addEventListener(Event.ADDED, _onAdded, false, 0, true);
    }

    public function resize(): void {
      _width = stage ? stage.stageWidth : 400;
      _height = stage ? stage.stageHeight : 400;

      _middleWidth = _width * 0.5;
      _middleHeight = _height * 0.5;

      var bmpd: BitmapData = new BitmapData(_width + 10, _height + 10, false, 0xffffff);

      if (lines && lines.length) {
        for (var i: int = 0; i < LINE_NUM; ++i) {
          lines[i].resize(_width, _height);
        }
      }

      if (_canvas) {
        _bmp.bitmapData = null;
        bmpd.draw(_canvas, new Matrix(bmpd.width / _canvas.width, 0, 0, bmpd.height / _canvas.height),
          null, null, null, true);
      }

      _canvas = bmpd;

      if (_bmp) {
        _bmp.bitmapData = _canvas;
      }
    }


    private function _init(): void {
      resize();

      _deformationMap = new BitmapData(50, 50, true, 0);
      _canvas = new BitmapData(_width + 10, _height + 10, false, 0xffffff);

      _bmp = new Bitmap(_canvas, PixelSnapping.AUTO, true);

      _createLines();

      addEventListener(Event.ENTER_FRAME, _doMagic, false, 0, true);

      addChild(_bmp);
    }


    private function _createLines(): void {
      var yCoef: Number = _deformationMap.height / LINE_NUM;

      for (var i: int = 0; i < LINE_NUM; ++i) {
        lines[i] = new CurveLine(_deformationMap, i * yCoef + 1, _width, _height);
      }

      var line: CurveLine;

      for (var j: int = 0; j < 200; ++j) {
        _drawBMPD();

        for (i = 0; i < LINE_NUM; ++i) {
          line = lines[i];
          line.draw();
          _canvas.draw(line, null, null, null, null, true);
        }
        if (j % 10 == 0) {
          _smooze();
        }
      }
    }


    private function _drawBMPD(): void {
      _val += 0.5;
      _pointOffset1.x = _val;
      _pointOffset2.x = _val * 0.1;

      _deformationMap.perlinNoise(_middleWidth, _middleHeight, 3, 6456, true, true, 2 | 1,
        false, [_pointOffset1, _pointOffset2, _pointZero]);
    }


    private function _drawLines(): void {
      var line: CurveLine;

      for (var i: int = 0; i < LINE_NUM; ++i) {
        line = lines[i];
        line.draw();
        _canvas.draw(line, null, null, null, null, true);
      }
    }


    private function _smooze(): void {
      _canvas.applyFilter(_canvas, _canvas.rect, _pointZero, new BlurFilter(3, 2, BitmapFilterQuality.MEDIUM));
      _canvas.applyFilter(_canvas, _canvas.rect, _pointZero, new ColorMatrixFilter([1, 0, 0, 0, 2,
        .004, 1, 0, 0, 1,
        .003, 0, 1, 0, .5,
        0, 0, 0, 1, 0]));
    }


    private function _onAdded(e: Event): void {
      removeEventListener(Event.ADDED, _onAdded);

      _init();
    }


    private function _doMagic(e: Event): void {
      _canvas.lock();
      _drawBMPD();
      _drawLines();
      _smooze();
      _canvas.unlock();
    }
  }
}
