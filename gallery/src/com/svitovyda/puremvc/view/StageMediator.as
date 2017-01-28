package com.svitovyda.puremvc.view {

  import com.svitovyda.puremvc.ApplicationFacade;
  import com.svitovyda.puremvc.view.component.Site;

  import flash.display.Stage;
  import flash.events.Event;

  import org.puremvc.as3.interfaces.*;
  import org.puremvc.as3.patterns.mediator.Mediator;


  public class StageMediator extends Mediator implements IMediator {
    public static const NAME: String = "StageMediator";


    public function StageMediator(viewComponent: Object) {
      super(NAME, viewComponent);
    }


    override public function listNotificationInterests(): Array {
      return [ApplicationFacade.INITIALIZE_SITE];
    }


    override public function handleNotification(note: INotification): void {
      switch (note.getName()) {
        case ApplicationFacade.INITIALIZE_SITE : {
          _initializeSite();
        }
          break;
      }
    }


    private function _initializeSite(): void {
      stage.addEventListener(Event.RESIZE, _onStageResize);

      var site: Site = new Site();
      stage.addChild(site);

      facade.registerMediator(new SiteMediator(site));
      facade.registerMediator(new NavMediator(site.nav));

      var navMediator: NavMediator = facade.retrieveMediator(NavMediator.NAME) as NavMediator;
      sendNotification(ApplicationFacade.STAGE_RESIZED);
      sendNotification(ApplicationFacade.SECTION_CHANGED, navMediator.getSelectedProduct());
    }


    protected function get stage(): Stage {
      return viewComponent as Stage;
    }


    protected function _onStageResize(e: Event): void {
      sendNotification(ApplicationFacade.STAGE_RESIZED);
    }
  }
}
