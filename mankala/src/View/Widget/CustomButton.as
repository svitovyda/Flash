
package View.Widget {

	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;


	public class CustomButton extends SimpleButton {

		static public var textShadowFilter:DropShadowFilter;
		static public var btnShadowFilter:DropShadowFilter;

		private var _upColor:uint = 0xFFdf1f;
		private var _overColor:uint = 0xCCFF00;
		private var _downColor:uint = 0x00CCFF;
		private var _deselectedColor:uint = 0xFFefaf;
		private var _selectedColor:uint = 0xfa9a01;
		private var _selectedOverColor:uint = 0xff0f11;

		private var _sizeX:uint;
		private var _sizeY:uint = 25;

		private var _label:String = "";
		private var _selectable:Boolean = false;
		private var _selected:Boolean = false;


		public function CustomButton(text:String, sizeX:uint = 80, selectable:Boolean = false) {

			tabEnabled = false;

			_label = text;
			_sizeX = sizeX;
			_selectable = selectable;

			downState = new ButtonDisplayState(_downColor, sizeX, _sizeY, _label);
			overState = new ButtonDisplayState(_overColor, sizeX, _sizeY, _label);
			upState = new ButtonDisplayState(_selectable ? _deselectedColor : _upColor, _sizeX, _sizeY, _label);
			hitTestState = new ButtonDisplayState(_upColor, _sizeX, _sizeY);

			useHandCursor = false;
			filters = [CustomButton.btnShadowFilter];

			if(_selectable) {
				addEventListener(MouseEvent.MOUSE_DOWN, _onClick);
			}
		}


		public function get label():String {
			return _label;
		}


		public function get selected():Boolean {
			return _selected;
		}
		
		
		public function set selected(sel:Boolean):void {

			_selected = sel;
			enabled = ! _selected;
			_update();
		}


		public static function createTF(sX:uint=80, sY:uint=20, text:String="", color:uint=0xF00101, size:uint=14):TextField {

			var tf:TextField = new TextField();

			tf.width = sX;
			tf.height = sY;
			tf.text = text;
			tf.autoSize = TextFieldAutoSize.NONE;

			tf.embedFonts = true;
			tf.antiAliasType = AntiAliasType.ADVANCED; //change this to normal to see it work
			tf.sharpness = 100;

			tf.background = false;
			tf.border = false;
			tf.wordWrap = true;
			tf.selectable = false;
			tf.multiline = false;
			tf.mouseEnabled = false;

			var format:TextFormat = new TextFormat();
			var font:myComic = new myComic();
			format.font = font.fontName;
			format.color = color;
			format.size = size;
			format.underline = false;
			format.bold = true;
			format.align = TextFormatAlign.CENTER;

			tf.defaultTextFormat = format;
			tf.setTextFormat(format);

			tf.filters = [CustomButton.textShadowFilter];

			return tf;
		}


		private function _onClick(event:MouseEvent):void {

			_selected = ! _selected;
			_update();
		}
		
		
		private function _update():void {

			upState = new ButtonDisplayState(_selected ? _selectedColor : _deselectedColor, _sizeX, _sizeY, _label);
			overState = new ButtonDisplayState(_selected ? _selectedOverColor : _overColor, _sizeX, _sizeY, _label);
		}
	}

}
