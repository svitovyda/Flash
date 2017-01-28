package View.GameParts {

	import Events.MoveEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import Model.ComputerModel;
	import Model.GameModel;
	import Model.UserFieldModel;

	import Events.GameEvent;
	import View.AbstractScreen;
	import View.Game;


	public final class Field extends AbstractScreen {

		private var _game:Game;

		private var _yourPits:Array;
		private var _myPits:Array;

		private var _yourKalaha:Kalaha;
		private var _myKalaha:Kalaha;

		private var _myField:Sprite;
		private var _yourField:Sprite;

		private var _stoneMover:StoneMover;

		private var _gameModel:GameModel;
		private var _computer:ComputerModel;

		private var _gameEvent:GameEvent;
		private var _processedEvent:GameEvent;

		private var _myTurn:Boolean;


		public function Field(mainController:MankalaGame, game:Game, myTurn:Boolean) {
			super(mainController);

			_game = game;

			_myTurn = myTurn;

			_myPits = [];
			_yourPits = [];

			_myField = new Sprite();
			_yourField = new Sprite();

			_yourKalaha = new Kalaha(_settings.kalahaWidth, _settings.kalahaHeight);
			_myKalaha = new Kalaha(_settings.kalahaWidth, _settings.kalahaHeight);
			_stoneMover = new StoneMover(_myPits, _yourPits, _myKalaha, _yourKalaha);
			_stoneMover.addEventListener(MoveEvent.MOVE_END, _onEndOfTurn);
			_stoneMover.addEventListener(MoveEvent.CAPTURE_END, _onEndOfTurn);

			_gameModel = new GameModel(onScoreChanged, _onTurnEnd);

			if (_settings.singleUser) {
				_computer = new ComputerModel(_gameModel.computer);
			}

			_draw();
		}


		protected override function _draw():void {

			_drawBg(_settings.fieldWidth, _settings.fieldHeight, 0x0aaa0a);

			var pitMargin:uint = _settings.pitSize + _settings.margin;

			_myField.x = _settings.pitStartX - _settings.margin / 2;
			_myField.y = _settings.margin;

			_yourField.x = _settings.pitStartX + _settings.margin / 2;
			_yourField.y = _sizeY - _settings.rows * pitMargin;

			var pit:Pit;
			var index:uint;

			for (var j:uint = 0; j < _settings.rows; ++ j) {

				for (var i:uint = 0; i < _settings.pitsPerRow; ++ i) {

					index = j == 0 ? _settings.pitsPerRow - i - 1 : _settings.pitsPerRow + i;
					pit = new Pit(_settings.pitSize, _settings.pitSize, this, index);
					_myPits[index] = pit;

					index = j == 0 ? index : i;
					pit.x = pitMargin * i;
					pit.y = pitMargin * j;
					_myField.addChild(pit);

					index = j == 0 ? i : _settings.pitsPerRow * 2 - 1 - i;
					pit = new Pit(_settings.pitSize, _settings.pitSize, this, index);
					_yourPits[index] = pit;

					index = j == 0 ? i : _settings.pitsPerRow - i;
					pit.x = pitMargin * i;
					pit.y = pitMargin * (_settings.rows - 1 - j);

					_yourField.addChild(pit);
				}

				_yourKalaha.x = _sizeX - _yourKalaha.width - _settings.margin;
				_myKalaha.x = _settings.margin;
				_yourKalaha.y = _settings.margin << 1;
				_myKalaha.y = _settings.margin;

				addChild(_myField);
				addChild(_yourField);
				addChild(_yourKalaha);
				addChild(_myKalaha);
				addChild(_stoneMover);
			}
		}


		public function get gameModel():GameModel {
			return _gameModel;
		}


		public function startGame(event:Event):void {
			_nextTurn(_myTurn);
		}


		public function onScoreChanged(event:GameEvent):void {
			_game.setScoreText(event.owner);
		}
		
		
		private function _onTurnEnd(event:GameEvent):void {
			_gameEvent = event;
		}


		private function _nextTurn(myTurn:Boolean):void {

			_myTurn = myTurn;

			_game.setStatusText(" turn...", _myTurn);

			if (_myTurn && _settings.singleUser) {

				moveStones(_computer.makeTurn());
			}

			_enableDisablePits();
		}


		private function _enableDisablePits():void {

			var enabledPits:Array = _myTurn ? _myPits : _yourPits;
			if (_myTurn && _settings.singleUser) enabledPits = null;

			var disabledPits:Array = _myTurn ? _yourPits : _myPits;

			for (var i:uint = 0; i < _settings.pitCount; ++ i ) {
				if (enabledPits) enabledPits[i].enable();
				disabledPits[i].disable();
			}
		}


		public function moveStones(index:uint):void {

			_gameModel.turn(index, _myTurn);
			_stoneMover.moveTurn(index, _myTurn, _gameEvent ? _gameEvent.type == GameEvent.CAPTURED : false);
		}


		private function _doEndOfTurn(event:TimerEvent):void {

			var gameEventType:String = _processedEvent.type;
			var index:uint = _processedEvent.index;
			_processedEvent = null;

			switch (gameEventType) {

				case GameEvent.FREE_TURN:
						_nextTurn(_myTurn);
					break;

				case GameEvent.CHANGE_TURN:
						_nextTurn(!_myTurn);
					break;

				case GameEvent.CAPTURED:
						_moveCaptured(index);
					break;

				case GameEvent.END_GAME:
						_mainController.showScore(_gameModel);
					break;

				default: throw new Error("Error: bad event obtained on end of move!");
			}
		}


		private function _doEndOfCapture(event:TimerEvent):void {
			_nextTurn(!_myTurn);
		}


		private function _onEndOfTurn(event:MoveEvent):void {

			var timer:Timer = new Timer(_settings.TIME_STEP, 1);

			if(event.type == MoveEvent.MOVE_END) {

				if (!_processedEvent && !_gameEvent) {
					throw new Error("Error: no event obtained on end of move!");
				}

				_processedEvent = _gameEvent;
				_gameEvent = null;


				timer.addEventListener(TimerEvent.TIMER_COMPLETE, _doEndOfTurn);

			} else {

				timer.addEventListener(TimerEvent.TIMER_COMPLETE, _doEndOfCapture);
			}

			timer.start();
		}


		private function _moveCaptured(index:uint):void {

			_stoneMover.moveCaptured(index, _myTurn);

		}


		/*override public function toString():String {

			var str:String = "MyField: " + _myKalaha.stoneCount + ", stones: ";

			for (var i:uint = 0; i < _settings.pitCount; ++ i ) {
				str += _myPits[i].stoneCount + ", ";
			}

			str += "\nYourField: " + _yourKalaha.stoneCount + ", stones: ";

			for (i = 0; i < _settings.pitCount; ++ i ) {
				str += _yourPits[i].stoneCount + ", ";
			}

			return str;
		}*/

	}

}
