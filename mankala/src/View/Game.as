package View {

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;

	import Model.GameModel;
	import Model.ScoreModel;

	import View.GameParts.Field;
	import View.Widget.CustomButton;
	

	public final class Game extends AbstractScreen {

		private var _menuBtn:CustomButton;

		private var _statusTf:TextField;
		
		private var _myScoreTf:TextField;
		private var _yourScoreTf:TextField;

		private var _field:Field;

		private var _yourStatusString:String;
		private var _myStatusString:String;


		public function Game(mainController:MankalaGame) {
			super(mainController);

			var myTurn:Boolean = Math.random() > 0.5;

			_field = new Field(mainController, this, myTurn);

			_myStatusString =  _field.gameModel.getScore(true).label;
			_yourStatusString = _field.gameModel.getScore(false).label;

			_statusTf = CustomButton.createTF(150, 30, "", 0xffffff, 18);

			_myScoreTf = CustomButton.createTF(350, 24,
					"On Game: " + _settings.pitCount * _settings.stonesPerPit + ",  captured: 0", 0xffffff, 16);

			_yourScoreTf = CustomButton.createTF(350, 24,
					"On Game: " + _settings.pitCount * _settings.stonesPerPit + ",  captured: 0", 0xffffff, 16);

			_draw();

			var timer:Timer = new Timer(100, 1);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER, _field.startGame);
		}


		public function get myLabel():String {
			return _myStatusString;
		}


		public function get yourLabel():String {
			return _yourStatusString;
		}


		override protected function _draw():void {
			
			_field.x = _settings.centerX - (_field.width / 2);
			_field.y = _settings.centerY - (_field.height / 2);
			addChild(_field);

			var myLabel:TextField = CustomButton.createTF(150, 24, _myStatusString, 0xffffff, 16);
			var yourLabel:TextField = CustomButton.createTF(150, 24, _yourStatusString, 0xffffff, 16);
			myLabel.x = yourLabel.x = _settings.centerX - myLabel.width / 2;
			myLabel.y = _field.y - myLabel.height - _settings.margin;
			yourLabel.y = _field.y + _field.height + _settings.margin;

			addChild(myLabel);
			addChild(yourLabel);

			_menuBtn = new CustomButton("Menu", 100);
			_menuBtn.x = _settings.WIDTH - _menuBtn.width - _settings.margin;
			_menuBtn.y = _settings.HEIGHT - _menuBtn.height - _settings.margin;

			_menuBtn.addEventListener(MouseEvent.CLICK, onMenuClick);

			addChild(_menuBtn);

			_statusTf.x = _settings.margin;
			_statusTf.y = _settings.margin;

			var myScoreLabel:TextField = CustomButton.createTF(130, 24, _myStatusString + " score:", 0xf0f000, 16);
			var yourScoreLabel:TextField = CustomButton.createTF(130, 24, _yourStatusString + " score:", 0xf0f000, 16);

			myScoreLabel.x = yourScoreLabel.x = 200;

			_myScoreTf.x = _yourScoreTf.x = 300;

			_myScoreTf.y = myScoreLabel.y = _settings.margin;
			_yourScoreTf.y = yourScoreLabel.y = _myScoreTf.y + _myScoreTf.height;

			addChild(_statusTf);
			addChild(myScoreLabel);
			addChild(yourScoreLabel);
			addChild(_myScoreTf);
			addChild(_yourScoreTf);
		}


		public function setStatusText(msg:String, myTurn:Boolean):void {
			_statusTf.text = (myTurn ? _myStatusString : _yourStatusString) + msg;
		}


		public function setScoreText(_my:Boolean):void {

			if (_field) {

				var tf:TextField = _my ? _myScoreTf : _yourScoreTf;

				tf.text = "On Game: " + _field.gameModel.getScore(_my).onGame +
								",  captured: " + _field.gameModel.getScore(_my).captured +
								", total: " + _field.gameModel.getScore(_my).total;
			}
		}


		public function onMenuClick(event:MouseEvent):void {

			disable();

			_mainController.showMenu();
		}

	}

}
