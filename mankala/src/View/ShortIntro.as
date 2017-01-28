package View {

	import flash.display.MovieClip;
	import flash.events.Event;


	public class ShortIntro extends AbstractScreen {

		private var _graphicsMc:MovieClip;


		public function ShortIntro(mainController:MankalaGame) {
			super(mainController);

			_draw();
		}


		override protected function _draw():void {
			_graphicsMc = new shortIntro();

			_graphicsMc.x = _settings.centerX;
			_graphicsMc.y = _settings.centerY;
			_graphicsMc.addEventListener(Event.COMPLETE, _onEnd);
			addChild(_graphicsMc);
		}


		private function _onEnd(event:Event):void {

			_graphicsMc.stop();
			_mainController.showLongIntro();
			remove();
		}

	}
	
}
