package com.svitovyda.puremvc.view {

  import com.svitovyda.puremvc.ApplicationFacade;
  import com.svitovyda.puremvc.model.*;
  import com.svitovyda.puremvc.view.component.MainNav;

  import flash.events.MouseEvent;

  import org.puremvc.as3.interfaces.*;
  import org.puremvc.as3.patterns.mediator.Mediator;


  public class NavMediator extends Mediator implements IMediator {
    public static const NAME: String = "NavMediator";

    private var _siteDataProxy: ProductsProxy;

    private var _currentSection: int = 0;


    public function NavMediator(viewComponent: Object) {
      super(NAME, viewComponent);

      _siteDataProxy = facade.retrieveProxy(ProductsProxy.NAME) as ProductsProxy;
      nav.button.addEventListener(MouseEvent.CLICK, _onNavButtonPressed);

      _currentSection = 0;
    }


    override public function listNotificationInterests(): Array {
      return [ApplicationFacade.STAGE_RESIZED,
        ApplicationFacade.PICTURE_LOADING,
        ApplicationFacade.PICTURE_LOADED];
    }


    override public function handleNotification(note: INotification): void {
      switch (note.getName()) {
        case ApplicationFacade.STAGE_RESIZED : {
          nav.resize();
        }
          break;

        case ApplicationFacade.PICTURE_LOADING : {
          nav.lock();
        }
          break;

        case ApplicationFacade.PICTURE_LOADED : {
          nav.unlock();
        }
          break;
      }
    }


    public function getSelectedProduct(): ProductVO {
      return _siteDataProxy.getData()[_currentSection];
    }


    private function _onNavButtonPressed(evt: MouseEvent): void {
      ++_currentSection;

      if (_currentSection == _siteDataProxy.count) {
        _currentSection = 0;
      }

      sendNotification(ApplicationFacade.PICTURE_LOADING);
      sendNotification(ApplicationFacade.SECTION_CHANGED, getSelectedProduct());
    }


    protected function get nav(): MainNav {
      return viewComponent as MainNav;
    }
  }
}
