package View.GameParts {

	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import Events.MoveEvent;

	import Model.UserFieldModel;
	import Model.SettingsModel;


	public final class StoneMover extends Sprite {

		private var _settings:SettingsModel;
		private var _lineColor:uint;
		
		private var _sizeX:uint;
		private var _sizeY:uint;

		private var _myPits:Array;
		private var _yourPits:Array;
		private var _myKalaha:Kalaha;
		private var _yourKalaha:Kalaha;

		private var _myTurn:Boolean;
		private var _stones:Array;
		private var _pit:Pit;

		private var _timer:Timer;
		private var _targets:Array;
		
		private var _isCapture:Boolean;
		private var _moveEndsCapture:Boolean;


		public function StoneMover(myPits:Array, yourPits:Array, myK:Kalaha, yK:Kalaha) {

			_settings = SettingsModel.getInstance();

			_myPits = myPits;
			_yourPits = yourPits;

			_myKalaha = myK;
			_yourKalaha = yK;

			visible = false;
		}


		private function _draw(pit:Kalaha=null):void {

			graphics.clear();

			if(pit) {

				x = pit.x;
				y = pit.y;

				if (pit.width == pit.height) {

					x += pit.parent.x;
					y += pit.parent.y;
				}
				_sizeX = pit.width;
				_sizeY = pit.height;
			}

			graphics.lineStyle(4, _lineColor);
			graphics.drawEllipse(0, 0, _sizeX, _sizeY);
		}


		private function _prepareMove(index:uint, my:Boolean):void {

			_targets = [];

			_pit = my ? _myPits[index] : _yourPits[index];

			_preparePit();
		}


		private function _preparePit():void {

			_stones = _pit.stones.slice();

			for (var i:uint = 0; i < _stones.length; ++ i ) {
				addChild(_pit.removeChild(_stones[i]));
			}

			_pit.empty();
		}


		public function moveTurn(index:uint, my:Boolean, capture:Boolean=false):void {

			_myTurn = my;
			_isCapture = false;
			_moveEndsCapture = capture;

			_prepareMove(index, my);

			var nextIndex:int = index;
			var pit:Kalaha;
			var currentPits:Array = _myTurn ? _myPits : _yourPits;
			var opponentPits:Array = _myTurn ? _yourPits : _myPits;
			var tmp:Array;

			var kalaha:Kalaha = _myTurn ? _myKalaha : _yourKalaha;
			var startedMove:Boolean = true;

			_lineColor = 0xffff00;
			_draw(_pit);

			for (var i:uint = 0; i < _stones.length; ++ i ) {

				nextIndex = UserFieldModel.nextPit(nextIndex, startedMove);

				if (nextIndex == _settings.pitCount) {

					tmp = currentPits;
					currentPits = opponentPits;
					opponentPits = tmp;
					startedMove = ! startedMove;
					nextIndex = 0;
				}

				pit = nextIndex == -1 ? kalaha : currentPits[nextIndex];
				_targets.push(pit);
			}

			_timer = new Timer(_settings.TIME_STEP, _targets.length + 1);
			_timer.addEventListener(TimerEvent.TIMER, _moveStep);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, _endMove);
			_timer.start();

			visible = true;
		}


		private function _moveStep(event:TimerEvent):void {

			if(_targets.length) {
				var pit:Kalaha = _targets.shift();

				_draw(pit);

				pit.addStone(_stones.pop());
				
				//-- highlight last move
				if (!_targets.length) {
					_lineColor = 0xff0000;
					_draw();
				}

			}
		}


		public function moveCaptured(index:uint, my:Boolean):void {

			_myTurn = my;
			_isCapture = true;

			var opp:uint = UserFieldModel.oppositePit(index);

			_prepareMove(opp, !my);

			_lineColor = 0x00ffff;
			_draw(_pit);

			_targets = [ _myTurn ? _myPits[index] : _yourPits[index] ];

			if (_settings.capturedToKalaha) {
				_targets.push(_myTurn ? _myKalaha : _yourKalaha);
			}

			_timer = new Timer(_settings.TIME_STEP, 3 + uint(_settings.capturedToKalaha));
			_timer.addEventListener(TimerEvent.TIMER, _captureStep);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, _endMove);
			_timer.start();

			visible = true;
		}


		private function _captureStep(event:TimerEvent):void {

			if (_targets.length) {

				var target:Kalaha = _targets.shift();

				while (_stones.length) {
					target.addStone(_stones.pop());
				}

				_draw(target);

				if (_settings.capturedToKalaha && _targets.length) {
					_pit = target as Pit;
					_preparePit();
				}

			} else {
				//-- highlight last move
				_lineColor = 0x0000ff;
				_draw();
			}
		}


		private function _endMove(event:TimerEvent):void {

			_timer = null;

			dispatchEvent(new MoveEvent(_isCapture ? MoveEvent.CAPTURE_END : MoveEvent.MOVE_END));

			if (_moveEndsCapture && ! _isCapture) {

				_lineColor = 0x0000ff;
				_draw();

			} else visible = false;
		}

	}

}
