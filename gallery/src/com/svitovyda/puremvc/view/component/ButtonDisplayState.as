
package com.svitovyda.puremvc.view.component
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.filters.DropShadowFilter;


	public class ButtonDisplayState extends Sprite
	{
		private var _bgColor:uint;

		private var _sizeX:uint;
		private var _sizeY:uint;

		private var _text:String;
		private var _tf:TextField;


		public function ButtonDisplayState( bgColor : uint, sizeX : uint = 80, sizeY : uint = 20, text : String = null )
		{
			hitArea = null;

			_bgColor = bgColor;
			_sizeX = sizeX;
			_sizeY = sizeY;
			_text = text;

			_draw();
		}


		private function _draw() : void
		{
			graphics.beginFill( _bgColor );
			graphics.drawRoundRect( 0, 0, _sizeX, _sizeY, 10, 10 );
			graphics.endFill();

			if(_text)
			{
				_tf = TextFieldCreator.createTF( _sizeX, _sizeY, _text );

				addChild(_tf);
			}
		}
	}
}
