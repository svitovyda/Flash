package com.svitovyda.puremvc.model
{
	import com.svitovyda.puremvc.ApplicationFacade;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class ProductsProxy extends Proxy implements IProxy
	{
		public static const NAME : String = "ProductsProxy";
		public var count : int;


		public function ProductsProxy()
		{
			super( NAME, new Object() );

			var loader : URLLoader = new URLLoader();
			loader.addEventListener( Event.COMPLETE, _onDataLoaded );

			try
			{
				loader.load( new URLRequest( "FLASHCodingTest.xml" ) );
			}
			catch ( error : Error )
			{
				trace( "Unable to load requested document." );
			}
		}


		protected function _parseXML( xml : XML ) : void
		{
			xml.ignoreWhitespace = true;
			var products : XMLList = xml.Product;

			count = products.length();

			for( var i : uint = 0; i < count; ++i )
			{
				var product : XML = products[ i ];

				var vo : ProductVO = new ProductVO();

				vo.description = product.Description;
				vo.title = product.Title;
				vo.name = product.@name;

				vo.imageThumbnail = product.Images.Thumbnail;
				vo.imageStandart = product.Images.Standard;
				vo.imageLarge = product.Images.Large;

				data[ i ] = vo;
			}

			sendNotification( ApplicationFacade.INITIALIZE_SITE );
		}


		private function _onDataLoaded( evt : Event ):void
		{
			evt.target.removeEventListener( Event.COMPLETE, _onDataLoaded );

			_parseXML( new XML( evt.target.data ) );
		}
	}
}
