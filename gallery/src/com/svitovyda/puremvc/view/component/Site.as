package com.svitovyda.puremvc.view.component
{
	import com.svitovyda.puremvc.model.ProductVO;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.text.TextField;

	public class Site extends MovieClip
	{
		public var nav : MainNav = new MainNav();
		private var _body : Sprite = new Sprite();
		private var _title : TextField;
		private var _descriction : TextField;
		public var loader : Loader;


		public function Site()
		{
			x = 0;
			y = 0;

			addChild( _body );
			addChild( nav );

			loader = new Loader();
		}


		public function updateBody( prod : ProductVO ) : void
		{
			_clear();

			_title = TextFieldCreator.createTF( 200, 80, prod.title, 0x000000, 20, true );
			_title.x = 10;
			_title.y = 10;
			_body.addChild( _title );
trace( "---", prod.description )
			_descriction = TextFieldCreator.createTF( 200, 600, prod.name + ",\n" + prod.description,
													0x000000, 14, true );
			_descriction.x = _title.x;
			_descriction.y = _title.y + _title.height + 10;
			_body.addChild( _descriction );

			loader.load( new URLRequest( prod.imageStandart ) );
			loader.x = _title.x + _title.width + 10;
			loader.y = _title.y;
			_body.addChild( loader );
		}


		private function _clear() : void
		{
			if( _title )
			{
				_body.removeChild( _title );
				_title = null;
			}

			if( _descriction )
			{
				_body.removeChild( _descriction );
				_descriction = null;
			}

			if( loader && loader.parent == _body )
			{
				_body.removeChild( loader );
			}
		}
	}
}
