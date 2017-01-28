package com.svitovyda.puremvc.view.component
{
	import flash.display.Sprite;

	public class MainNav extends Sprite
	{
		public var button : CustomButton;


		public function MainNav()
		{
			button = new CustomButton( "Next" );
			addChild( button );
		}


		public function resize() : void
		{
			button.x = stage.stageWidth - button.width - 10;
			button.y = stage.stageHeight - button.height - 10;
		}


		public function unlock() : void
		{
			button.mouseEnabled = true;
		}


		public function lock() : void
		{
			button.mouseEnabled = false;
		}
	}
}
