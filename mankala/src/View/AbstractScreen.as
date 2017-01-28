package View {

	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;

	import Model.SettingsModel;


	public class AbstractScreen extends Sprite {

		static public var bgShadowFilter:DropShadowFilter;

		protected var _isShown:Boolean = false;
		protected var _isEnabled:Boolean = false;

		private var _mask:Sprite;
		protected var _bg:Sprite;
		protected var _sizeX:uint;
		protected var _sizeY:uint;
		

		protected var _settings:SettingsModel;
		protected var _mainController:MankalaGame;


		public function AbstractScreen(mainController:MankalaGame){
			_mainController = mainController;
			_settings = mainController.settings;
		}


		public function get isShown():Boolean {
			return _isShown;
		}


		protected function _draw():void {

			_mask = new Sprite();

			_mask.graphics.beginFill(0xffffff);
			_mask.graphics.drawRect(0, 0, _settings.WIDTH, _settings.HEIGHT);
			_mask.graphics.endFill();
			_mask.alpha = 0.2;

			addChild(_mask);
		}


		protected final function _drawBg(sizeX:uint, sizeY:uint, color:uint=0xffffef):void {

			_sizeX = sizeX;
			_sizeY = sizeY;

			_bg = new Sprite();

			_bg.graphics.beginFill(color);
			_bg.graphics.drawRoundRect(0, 0, _sizeX, _sizeY, 15, 15);
			_bg.graphics.endFill();

			_bg.filters = [AbstractScreen.bgShadowFilter];

			if(_mask) {
				_bg.x = _settings.centerX - _sizeX / 2;
				_bg.y = _settings.centerY - _sizeY / 2;
			}

			addChild(_bg);
		}


		public function get isEnabled():Boolean {
			return _isEnabled;
		}


		public function show():void {
			_isShown = true;
		}


		public function hide():void {
			_isShown = false;
		}


		public function enable():void {
			_isEnabled = true;
			mouseEnabled = true;
		}


		public function disable():void {
			_isEnabled = false;
			mouseEnabled = false;
		}


		public function remove():void {
			parent.removeChild(this);
		}

	}

}
