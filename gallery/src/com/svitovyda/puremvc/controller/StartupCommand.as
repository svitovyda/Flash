package com.svitovyda.puremvc.controller
{
	import flash.display.Stage;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import com.svitovyda.puremvc.ApplicationFacade;
	import com.svitovyda.puremvc.view.StageMediator;
	import com.svitovyda.puremvc.model.ProductsProxy;


	public class StartupCommand extends SimpleCommand implements ICommand
	{
		override public function execute( note : INotification ) : void
		{
			var stage : Stage = note.getBody() as Stage;

			facade.registerMediator( new StageMediator( stage ) );
			facade.registerProxy( new ProductsProxy() );
		}
	}
}
