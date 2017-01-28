package
{
	import com.svitovyda.puremvc.ApplicationFacade;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	import flash.display.Sprite;

	public class Main extends Sprite
	{
		private var facade : ApplicationFacade;


		public function Main()
		{
			if( stage )
			{
				_init();
			}
			else
			{
				addEventListener( Event.ADDED_TO_STAGE, _onAdded, false, 0, true );
			}
			
		}


		private function _init() : void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			facade = ApplicationFacade.getInstance();

			facade.startup( this.stage );
		}


		protected function _onAdded( e : Event ) : void
		{
			removeEventListener( Event.ADDED_TO_STAGE, _onAdded );

			_init();
		}
	}
}
