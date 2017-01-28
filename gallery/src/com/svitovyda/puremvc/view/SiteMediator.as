package com.svitovyda.puremvc.view {

  import com.svitovyda.puremvc.ApplicationFacade;
  import com.svitovyda.puremvc.model.*;
  import com.svitovyda.puremvc.view.component.Site;

  import flash.events.Event;
  import flash.events.IOErrorEvent;

  import org.puremvc.as3.interfaces.*;
  import org.puremvc.as3.patterns.mediator.Mediator;


  public class SiteMediator extends Mediator implements IMediator {
    public static const NAME: String = "SiteMediator";
    private var _ProductsProxy: ProductsProxy;

    public function SiteMediator(viewComponent: Object) {
      super(NAME, viewComponent);

      site.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onResourseLoaded);
      site.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onResourceFailure);
    }

    protected function onResourceFailure(e: IOErrorEvent): void {
      sendNotification(ApplicationFacade.PICTURE_LOADED);
    }

    protected function onResourseLoaded(e: Event): void {
      sendNotification(ApplicationFacade.PICTURE_LOADED);
    }


    override public function listNotificationInterests(): Array {
      return [ApplicationFacade.SECTION_CHANGED];
    }


    override public function handleNotification(note: INotification): void {
      switch (note.getName()) {
        case ApplicationFacade.SECTION_CHANGED : {
          site.updateBody(note.getBody() as ProductVO);
        }
          break;
      }
    }


    protected function get site(): Site {
      return viewComponent as Site;
    }
  }
}
