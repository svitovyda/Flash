package View.GameParts {

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import Model.SettingsModel;

	import View.Game;
	import View.Widget.CustomButton;
	import View.Widget.PitBG;


	public class Kalaha extends Sprite {

		protected var _settings:SettingsModel;

		protected var _sizeX:uint;
		protected var _sizeY:uint;

		protected var _bg:PitBG;
		protected var _hint:Sprite = null;
		protected var _stones:Array = [];
		protected var _stoneCount:uint = 0;


		public function Kalaha(sizeX:uint, sizeY:uint) {

			hitArea = null;

			_settings = SettingsModel.getInstance();

			_sizeX = sizeX;
			_sizeY = sizeY;

			_bg = new PitBG(_sizeX, _sizeY);
			_bg.disable();

			_drawBg();
		}


		public function get stoneCount(): uint {
			return _stoneCount;
		}


		protected function _drawBg():void {
			addChild(_bg);

			_bg.addEventListener(MouseEvent.MOUSE_OVER, _onShowHint);
			_bg.addEventListener(MouseEvent.MOUSE_MOVE, _onShowHint);
			_bg.addEventListener(MouseEvent.MOUSE_OUT, _onHideHint);
			
			filters = [CustomButton.btnShadowFilter];
		}


		private function _onShowHint(event:MouseEvent):void {

			if(!_hint) {
				_hint = new Sprite();
				_hint.graphics.beginFill(0x549FFC);
				_hint.graphics.drawCircle(_settings.hintRadius, _settings.hintRadius, _settings.hintRadius);

				var tf:TextField = CustomButton.createTF(
						2 * _settings.hintRadius, 2 * _settings.hintRadius, String(_stoneCount));

				_hint.addChild(tf);
				_hint.alpha = 0.8;
				_hint.mouseEnabled = false;
				_hint.tabEnabled = false;
				_hint.filters = [CustomButton.btnShadowFilter];
				
				addChild(_hint);
			}

			_hint.x = event.localX - _hint.width;
			_hint.x = _hint.x < - _settings.margin ? - _settings.margin : _hint.x;
			_hint.y = event.localY - _hint.height;
			_hint.y = _hint.y < - _settings.margin ? - _settings.margin : _hint.y;
		}


		protected function _onHideHint(event:MouseEvent = null):void {

			if (_hint) removeChild(_hint);
			_hint = null;
		}
		
		
		public function addStone(stone:Stone):void {

			++ _stoneCount;
			_stones.push(stone);
			
			if (_sizeX != _sizeY) {
				stone.y = Math.random() * (_sizeY - 2 * _settings.stoneRadius - _settings.margin * 2) +
						_settings.margin;
			}

			addChild(stone.parent.removeChild(stone));
			_onHideHint();
		}

	}

}
