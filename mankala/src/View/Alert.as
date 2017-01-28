package View {

	import flash.events.MouseEvent;
	import flash.text.TextField;

	import Events.AlertEvent;
	import View.Widget.CustomButton;


	public final class Alert extends AbstractScreen {
		
		private var _yBtn:CustomButton;
		private var _nBtn:CustomButton;
		private var _closeBtn:CustomButton;
		private var _tf:TextField;

		private var _ynMode:Boolean;

		private var _label1:String;
		private var _label2:String;

		private var _alert:String;


		public function Alert(mainController:MankalaGame, text:String="Are You Sure?", yesNo:Boolean=true, label1:String="", label2:String="") {
			super(mainController);

			_alert = text;

			_ynMode = yesNo;

			_label1 = label1;
			_label2 = label2;

			if (!_ynMode) {

				if(!_label1) _label1 = "Ok";

				_closeBtn = new CustomButton(_label1, _label1.length * 9 + 10);

				_closeBtn.addEventListener(MouseEvent.CLICK, _onClick);

			} else {

				if (!_label1) _label1 = "Yes";
				if (!_label2) _label2 = "No";

				_yBtn = new CustomButton(_label1, _label1.length * 9 + _settings.margin);
				_nBtn = new CustomButton(_label2, _label2.length * 9 + _settings.margin);

				_yBtn.addEventListener(MouseEvent.CLICK, _onClick);
				_nBtn.addEventListener(MouseEvent.CLICK, _onClick);
			}

			_draw();
		}


		override protected function _draw():void {
			super._draw();

			_drawBg(150, 110);

			_tf = CustomButton.createTF(
					_sizeX - _settings.margin * 2, _sizeY - _yBtn.height - _settings.margin * 2, _alert);

			_tf.wordWrap = true;
			_tf.selectable = true;

			if (!_ynMode) {

				_closeBtn.x = _settings.centerX - (_closeBtn.width >> 1);
				_closeBtn.y = _bg.y + _sizeY - _closeBtn.height - _settings.margin;

				addChild(_closeBtn);

			} else {

				_yBtn.x = _bg.x + _settings.margin * 2;
				_nBtn.x = _bg.x + _sizeX - _nBtn.width - _settings.margin * 2;

				_yBtn.y = _bg.y + _sizeY - _yBtn.height - _settings.margin;
				_nBtn.y = _bg.y + _sizeY - _nBtn.height - _settings.margin;

				addChild(_yBtn);
				addChild(_nBtn);
			}

			_tf.x = _bg.x + _settings.margin;
			_tf.y = _bg.y + _settings.margin;
			addChild(_tf);
		}


		private function _onClick(event:MouseEvent):void {

			switch(event.target.label) {

				case _label1:

						if (_ynMode) dispatchEvent(new AlertEvent(AlertEvent.YES));
						else dispatchEvent(new AlertEvent(AlertEvent.OK));
					break;

				case _label2:

						if (_ynMode) dispatchEvent(new AlertEvent(AlertEvent.NO));
					break;
			}

			remove();
		}

	}

}
