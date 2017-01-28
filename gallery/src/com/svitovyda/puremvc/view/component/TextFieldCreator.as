package com.svitovyda.puremvc.view.component
{
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * ...
	 * @author Svitovyda
	 */

	public class TextFieldCreator
	{
		public function TextFieldCreator(){}


		public static function createTF( sX : uint = 80, sY : uint = 20,
										text : String = "", color : uint = 0xF00101,
										size : uint = 14, multiline : Boolean = false ) : TextField
		{
			var tf : TextField = new TextField();

			tf.width = sX;
			tf.height = sY;
			tf.text = text;
			tf.autoSize = TextFieldAutoSize.NONE;

			tf.background = false;
			tf.border = false;
			tf.wordWrap = true;
			tf.selectable = false;
			tf.multiline = multiline;
			tf.mouseEnabled = false;

			var format : TextFormat = new TextFormat();

			format.color = color;
			format.size = size;
			format.underline = false;
			format.bold = true;
			format.align = TextFormatAlign.CENTER;

			tf.defaultTextFormat = format;
			tf.setTextFormat( format );

			return tf;
		}
	}
}
