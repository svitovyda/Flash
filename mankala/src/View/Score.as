package View {

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import Model.GameModel;
	import View.Widget.CustomButton;


	public final class Score extends AbstractScreen {

		private var _closeBtn:CustomButton;
		private const _textWidth:uint = 130;
		private const _textHeight:uint = 24;
		private const _margin:uint = 5;

		private var _tfX:uint;
		private var _tfY:uint;

		private var _myOnGame:uint;
		private var _myCaptured:uint;
		private var _myTotal:uint;
		private var _myLabel:String;

		private var _yourOnGame:uint;
		private var _yourCaptured:uint;
		private var _yourTotal:uint;
		private var _yourLabel:String;


		public function Score(mainController:MankalaGame, game:GameModel) {
			super(mainController);

			_myLabel = game.getScore(true).label;
			_yourLabel = game.getScore(false).label;
			_myOnGame = game.getScore(true).onGame;
			_yourOnGame = game.getScore(false).onGame;
			_myCaptured = game.getScore(true).captured;
			_yourCaptured = game.getScore(false).captured;
			_myTotal = game.getScore(true).total;
			_yourTotal = game.getScore(false).total;


			_closeBtn = new CustomButton("Close", 70);
			_closeBtn.addEventListener(MouseEvent.CLICK, _onClose);

			_draw();
		}

		
		override protected function _draw():void {
			super._draw();
			_drawBg(380, 240);
			addChild(_bg);

			var winner:String = _myTotal > _yourTotal ? _myLabel : _yourLabel;

			_tfX = (_sizeX - _textWidth * 3 - _margin * 2) / 2 + _bg.x;
			_tfY = _bg.y + _settings.margin;

			var tf:TextField = CustomButton.createTF(_textWidth * 2, 26, winner + " won!", 0x0f0f00, 16);
			tf.x = _settings.centerX - _textWidth;
			tf.y = _tfY;
			addChild(tf);

			_tfY += tf.height + _settings.margin;

			tf = CustomButton.createTF(_textWidth, _textHeight, _myLabel);
			tf.x = _tfX + tf.width + _margin;
			tf.y = _tfY;
			addChild(tf);
			
			tf = CustomButton.createTF(_textWidth, _textHeight, _yourLabel);
			tf.x = _tfX + (tf.width + _margin) * 2;
			tf.y = _tfY;
			addChild(tf);

			_tfY += tf.height + _margin;

			tf = CustomButton.createTF(_textWidth, _textHeight, "on game:");
			tf.x = _tfX;
			tf.y = _tfY;
			addChild(tf);

			tf = CustomButton.createTF(_textWidth, _textHeight, String(_myOnGame));
			tf.x = _tfX + tf.width + _margin;
			tf.y = _tfY;
			addChild(tf);

			tf = CustomButton.createTF(_textWidth, _textHeight, String(_yourOnGame));
			tf.x = _tfX + (tf.width + _margin) * 2;
			tf.y = _tfY;
			addChild(tf);

			_tfY += tf.height + _margin;

			tf = CustomButton.createTF(_textWidth, _textHeight, "captured:");
			tf.x = _tfX;
			tf.y = _tfY;
			addChild(tf);

			tf = CustomButton.createTF(_textWidth, _textHeight, String(_myCaptured));
			tf.x = _tfX + tf.width + _margin;
			tf.y = _tfY;
			addChild(tf);

			tf = CustomButton.createTF(_textWidth, _textHeight, String(_yourCaptured));
			tf.x = _tfX + (tf.width + _margin) * 2;
			tf.y = _tfY;
			addChild(tf);

			_tfY += tf.height + _margin;

			tf = CustomButton.createTF(_textWidth, _textHeight, "total:");
			tf.x = _tfX;
			tf.y = _tfY;
			addChild(tf);

			tf = CustomButton.createTF(_textWidth, _textHeight, String(_myTotal));
			tf.x = _tfX + tf.width + _margin;
			tf.y = _tfY;
			addChild(tf);

			tf = CustomButton.createTF(_textWidth, _textHeight, String(_yourTotal));
			tf.x = _tfX + (tf.width + _margin) * 2;
			tf.y = _tfY;
			addChild(tf);

			_closeBtn.x = _settings.centerX - _closeBtn.width / 2;
			_closeBtn.y = _bg.y + _sizeY - _closeBtn.height - _settings.margin;
			addChild(_closeBtn);
		}
		

		private function _onClose(event:MouseEvent):void {

			_mainController.showMenu();
			remove();
		}

	}
	
}
