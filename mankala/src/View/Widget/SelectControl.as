package View.Widget  {

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import Model.SettingsModel;


	public final class SelectControl extends Sprite {

		private var _settings:SettingsModel;

		private var _btn1:CustomButton;
		private var _btn2:CustomButton;

		private var _message:TextField;

		private var _size:uint;
		private var _buttonWidth:uint;

		private var _selectedIndex:uint;


		public function SelectControl(label1:String, label2:String, alert:String, selected:uint=0, size:uint = 300) {

			_settings = SettingsModel.getInstance();
			_size = size;
			_selectedIndex = selected;

			_message = CustomButton.createTF(_size - _settings.margin * 2, 20, alert);

			_buttonWidth = _size / 2 - _settings.margin * 3;

			_btn1 = new CustomButton(label1, _buttonWidth, true);
			_btn1.selected = _selectedIndex == 0;
			_btn2 = new CustomButton(label2, _buttonWidth, true);
			_btn2.selected = _selectedIndex != 0;

			_btn1.addEventListener(MouseEvent.MOUSE_DOWN, _onSelect);
			_btn2.addEventListener(MouseEvent.MOUSE_DOWN, _onSelect);

			_draw();
		}


		public function get selectedIndex():uint {
			return _selectedIndex;
		}


		private function _draw():void {

			_message.x = - _message.width / 2;

			_btn1.x = - _buttonWidth - _settings.margin;
			_btn2.x = _settings.margin;
			_btn1.y = _message.y + _message.height + _settings.margin;
			_btn2.y = _message.y + _message.height + _settings.margin;

			addChild(_message);
			addChild(_btn1);
			addChild(_btn2);
		}


		private function _onSelect(event:MouseEvent):void {

			_btn1.selected = event.target.label == _btn1.label;
			_btn2.selected = event.target.label == _btn2.label;
			_selectedIndex = uint(event.target.label == _btn2.label);
		}

	}

}
