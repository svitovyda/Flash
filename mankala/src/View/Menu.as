package View {

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import View.Widget.CustomButton;


	public final class Menu extends AbstractScreen {

		private var _menuStartLabels:Array = ["Single Player", "Two Players", "Settings", "Help"];
		private var _menuGameLabels:Array = ["Restart", "Back", "Help"];

		private var _menuLabels:Array;
		private var _menuItems:Array;


		public function Menu(mainController:MankalaGame) {
			super(mainController);

			_menuItems = new Array();
			_menuLabels = _mainController.gameStarted ? _menuGameLabels : _menuStartLabels;

			var item:CustomButton;

			for(var i:uint = 0; i < _menuLabels.length; ++ i) {

				item = new CustomButton(_menuLabels[i], _menuLabels[i].length * 9 + _settings.margin);
				_menuItems.push(item);
			}

			_draw();
		}


		override protected function _draw():void {
			super._draw();

			_drawBg(200, _menuLabels.length * _settings.margin * 4);

			var item:CustomButton;

			for (var i:uint = 0; i < _menuLabels.length; ++ i) {

				item = _menuItems[i];
				item.x = (_settings.WIDTH - item.width) >> 1;
				item.y = _bg.y + (item.height + _settings.margin) * i + _settings.margin;
				item.addEventListener(MouseEvent.CLICK, _onMenuItemClick);
				addChild(item);
			}
		}


		private function _onMenuItemClick(event:MouseEvent):void {

			switch(event.target.label) {

				case "Single Player":
						_mainController.playGame();
					break;

				case "Two Players":
						_mainController.playGame(false);
					break;

				case "Help":
						_mainController.showHelp();
					break;

				case "Restart":
						_mainController.restartGame();
					break;

				case "Settings":
						_mainController.showSettings();
					break;

				case "Back":
						_mainController.backToGame();
					break;
					
				default: throw new Error("Unknown menu field was selected!");
			}

			remove();
		}

	}

}
