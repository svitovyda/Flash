package View.GameParts {

	import flash.display.Sprite;

	import Model.SettingsModel;
	import View.Widget.CustomButton;


	public final class Stone extends Sprite {

		private var _settings:SettingsModel;
		private var _color:uint;


		public function Stone() {

			_settings = SettingsModel.getInstance();

			_color = Math.random() * 0xf0f0f0 + 0x0f0e0e;

			_draw();
		}

		private function _draw():void {

			//graphics.lineStyle(0, 0x000000);
			graphics.beginFill(_color);
			graphics.drawCircle(_settings.stoneRadius, _settings.stoneRadius, _settings.stoneRadius);
			graphics.endFill();

			filters = [CustomButton.btnShadowFilter];
		}

	}

}
