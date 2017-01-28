package View.GameParts {

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	import View.Widget.CustomButton;


	public final class Pit extends Kalaha {

		private var _field:Field;
		private var _tf:TextField;
		private var _enabled:Boolean;
		private var _index:uint;


		public function Pit(sizeX:uint, sizeY:uint, field:Field, index:uint) {
			super(sizeX, sizeY);

			_field = field;
			_index = index;
			_stoneCount = _settings.stonesPerPit;

			_stones = new Array(_stoneCount);
			var stone:Stone;

			for (var i:uint = 0; i < _stoneCount; ++ i) {
				stone = new Stone();
				stone.mouseEnabled = false;
				_stones[i] = stone;
			}

			_draw();
		}


		public function get ingex():uint {
			return _index;
		}
		
		
		public function get stones():Array {
			return _stones;
		}


		private function _draw():void {
			_bg.addEventListener(MouseEvent.CLICK, _onClick);

			/*var tf:TextField = CustomButton.createTF(30, 20, String(_index));

			tf.autoSize = TextFieldAutoSize.RIGHT;
			tf.x = _sizeX - tf.width;
			tf.y = _sizeY - tf.height;*/

			for (var i:uint = 0; i < _stoneCount; ++ i) {

				_stones[i].x = Math.random() * (_sizeX - 4 * _settings.stoneRadius) + _settings.stoneRadius;
				_stones[i].y = Math.random() * (_sizeY - 4 * _settings.stoneRadius) + _settings.stoneRadius;

				addChild(_stones[i]);
			}
			//addChild(tf);
		}


		private function _onClick(event:MouseEvent):void {

			if (_stoneCount && _enabled) {
				_stoneCount = 0;

				_onHideHint();
				_field.moveStones(_index);
			}
		}
		
		
		public function empty():void {

			_stoneCount = 0;
			_stones = [];
		}


		public function enable():void {

			_bg.enable();
			_enabled = true;
		}


		public function disable():void {

			_bg.disable();
			_enabled = false;
		}

	}

}
