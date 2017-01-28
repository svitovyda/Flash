package View.Widget  {

	import flash.display.SimpleButton;
	import flash.display.Sprite;


	public final class PitBG extends SimpleButton {

		private var _upColor:uint = 0xffffef;
		private var _overColor:uint = 0xCCFF00;
		private var _downColor:uint = 0x00CCFF;
		private var _disabledColor:uint = 0xE7E6DA;


		private var _sizeX:uint;
		private var _sizeY:uint = 25;


		public function PitBG(sizeX:uint = 0, sizeY:uint = 0) {

			_sizeX = sizeX;
			_sizeY = sizeY;

			useHandCursor = false;

			downState = _getSprite(_downColor);
			overState = _getSprite(_overColor);
			upState = _getSprite(_upColor);
			hitTestState = _getSprite(_upColor);
		}


		private function _getSprite(color:uint):Sprite {

			var sprite:Sprite = new Sprite();

			sprite.graphics.beginFill(color);
			sprite.graphics.drawRoundRect(0, 0, _sizeX, _sizeY, 15, 15);
			sprite.graphics.endFill();

			return sprite;
		}


		public function enable():void {

			downState = _getSprite(_downColor);
			overState = _getSprite(_overColor);
			upState = _getSprite(_upColor);
			hitTestState = _getSprite(_upColor);
		}


		public function disable():void {

			downState = _getSprite(_disabledColor);
			overState = _getSprite(_disabledColor);
			upState = _getSprite(_disabledColor);
			hitTestState = _getSprite(_disabledColor);
		}

	}

}
