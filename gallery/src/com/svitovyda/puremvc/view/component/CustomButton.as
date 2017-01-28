package com.svitovyda.puremvc.view.component
{
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;


	public class CustomButton extends SimpleButton
	{
		private var _upColor : uint = 0xFFdf1f;
		private var _overColor : uint = 0xCCFF00;
		private var _downColor : uint = 0x00CCFF;
		private var _deselectedColor : uint = 0xFFefaf;
		private var _selectedColor : uint = 0xfa9a01;
		private var _selectedOverColor : uint = 0xff0f11;

		private var _sizeX : uint;
		private var _sizeY : uint = 25;

		private var _label : String = "";
		private var _selectable : Boolean = false;
		private var _selected : Boolean = false;


		public function CustomButton(text : String, sizeX : uint = 80, selectable : Boolean = false)
		{
			tabEnabled = false;

			_label = text;
			_sizeX = sizeX;
			_selectable = selectable;

			downState = new ButtonDisplayState( _downColor, sizeX, _sizeY, _label );
			overState = new ButtonDisplayState( _overColor, sizeX, _sizeY, _label );
			upState = new ButtonDisplayState( _selectable ? _deselectedColor : _upColor, _sizeX, _sizeY, _label );
			hitTestState = new ButtonDisplayState( _upColor, _sizeX, _sizeY );

			useHandCursor = false;

			if( _selectable )
			{
				addEventListener( MouseEvent.MOUSE_DOWN, _onClick );
			}
		}


		public function get label() : String
		{
			return _label;
		}


		public function get selected() : Boolean
		{
			return _selected;
		}


		public function set selected( sel : Boolean ) : void
		{
			_selected = sel;
			enabled = ! _selected;
			_update();
		}


		private function _onClick( event : MouseEvent ) : void
		{
			_selected = ! _selected;
			_update();
		}


		private function _update() : void
		{
			upState = new ButtonDisplayState( _selected ? _selectedColor : _deselectedColor, _sizeX, _sizeY, _label );
			overState = new ButtonDisplayState( _selected ? _selectedOverColor : _overColor, _sizeX, _sizeY, _label );
		}
	}

}
