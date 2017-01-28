package View {

	import flash.events.MouseEvent;
	import flash.text.TextField;

	import View.Widget.CustomButton;
	import View.Widget.SelectControl;


	public final class Settings extends AbstractScreen {

		private var _okBtn:CustomButton;
		private var _cancelBtn:CustomButton;
		
		private var _rowControl:SelectControl;
		private var _captureControl:SelectControl;
		private var _stonesControl:SelectControl;


		public function Settings(mainController:MankalaGame) {
			super(mainController);

			_rowControl = new SelectControl(
					"One Row", "Two Rows", "Count of rows per user:", _settings.singleRow ? 0 : 1);
			_captureControl = new SelectControl(
					"To Kalaha", "To Pit", "Where put captured stones:", _settings.capturedToKalaha ? 0 : 1);
			_stonesControl = new SelectControl(
					"3", "4", "Count of stones per pit:", _settings.stonesPerPit == 3 ? 0 : 1);


			_okBtn = new CustomButton("Save");
			_cancelBtn = new CustomButton("Cancel");

			_okBtn.addEventListener(MouseEvent.MOUSE_DOWN, _onClick);
			_cancelBtn.addEventListener(MouseEvent.MOUSE_DOWN, _onClick);

			_draw();
		}


		override protected function _draw():void {
			super._draw();

			_drawBg(300, 350);

			_rowControl.x = _settings.centerX;
			_captureControl.x = _settings.centerX;
			_stonesControl.x = _settings.centerX;

			_rowControl.y = _bg.y + _settings.margin;
			_captureControl.y = _rowControl.y + _rowControl.height + _settings.margin * 2;
			_stonesControl.y = _captureControl.y + _captureControl.height + _settings.margin * 2;

			_okBtn.x = _bg.x + _settings.margin * 2;
			_cancelBtn.x = _bg.x + _sizeX - _cancelBtn.width - _settings.margin * 2;

			_okBtn.y = _bg.y + _sizeY - _okBtn.height - _settings.margin;
			_cancelBtn.y = _bg.y + _sizeY - _cancelBtn.height - _settings.margin;

			addChild(_rowControl);
			addChild(_captureControl);
			addChild(_stonesControl);

			addChild(_okBtn);
			addChild(_cancelBtn);
		}


		private function _onClick(event:MouseEvent):void {

			if(event.target.label == "Save") {

				_settings.singleRow = _rowControl.selectedIndex == 0;
				_settings.capturedToKalaha = _captureControl.selectedIndex == 0;
				_settings.stonesPerPit = _stonesControl.selectedIndex + 3;
			}

			_mainController.showMenu();
			remove();
		}

	}

}
