package View {

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import View.Widget.CustomButton;


	public final class Help extends AbstractScreen {

		private var _closeBtn:CustomButton;
		private const _text:String = "Mancala is played with seven pits - six playing pits plus one score pit, the Kalaha - per player. At the beginning of the game, each of the (12) playing pits contains 3 seeds (or beads or stones or balls or whatever). To play, the player chooses one pit from which to \"sow\" the seeds. Each seed in the pit is then placed, one at a time, into the successive pits, moving counter-clockwise around the board. Seeds placed in a Kalaha are points for that player. Seeds are not sown in the opponent's Kalaha. If the last seed in a play is placed in the player's own Kalaha, they get another turn. If the last seed is placed in an empty pit on their own side of the board, then they Capture  the seeds in the opposite (their opponent's) pit. All captured seeds, as well as the capturing piece, are placed in the player's Kalaha. The game ends when all of the pits on one side of the board are empty. The player with seeds remaining gets to put them into their Kalaha. The winner is the player with the most seeds.";
		private var _tf:TextField;


		public function Help(mainController:MankalaGame) {
			super(mainController);

			_closeBtn = new CustomButton("Close", 70);
			_closeBtn.addEventListener(MouseEvent.CLICK, _onClose);
			
			_draw();
		}


		override protected function _draw():void {
			super._draw();

			_drawBg(430, 420);
			
			_tf = CustomButton.createTF(
				_sizeX - _settings.margin * 2, _sizeY - _settings.margin * 2 - _closeBtn.height, _text);

			_tf.selectable = true;
			_tf.mouseEnabled = true;
			_tf.x = _bg.x + _settings.margin;
			_tf.y = _bg.y + _settings.margin;
			_tf.filters[0].color = 0;

			addChild(_bg);
			addChild(_tf);

			_closeBtn.x = _closeBtn.x = _settings.centerX - _closeBtn.width / 2;
			_closeBtn.y = _bg.y + _sizeY - _closeBtn.height - _settings.margin;
			addChild(_closeBtn);
		}


		private function _onClose(event:MouseEvent):void {

			_mainController.showMenu();
			remove();
		}

	}
	
}
