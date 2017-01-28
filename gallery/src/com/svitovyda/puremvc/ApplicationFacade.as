package com.svitovyda.puremvc {

  import com.svitovyda.puremvc.controller.StartupCommand;

  import org.puremvc.as3.interfaces.IFacade;
  import org.puremvc.as3.patterns.facade.Facade;


  public class ApplicationFacade extends Facade implements IFacade {
    public static const STARTUP: String = "startup";
    public static const INITIALIZE_SITE: String = "initializeSite";
    public static const SECTION_CHANGED: String = "sectionChanged";
    public static const STAGE_RESIZED: String = "stageResized";
    public static const PICTURE_LOADING: String = "pictureLoading";
    public static const PICTURE_LOADED: String = "pictureLoaded";


    public static function getInstance(): ApplicationFacade {
      if (instance == null) {
        instance = new ApplicationFacade();
      }

      return instance as ApplicationFacade;
    }

    override protected function initializeController(): void {
      super.initializeController();

      registerCommand(STARTUP, StartupCommand);
    }

    public function startup(stage: Object): void {
      sendNotification(STARTUP, stage);
    }
  }
}
