package Model {

  import flash.events.EventDispatcher;


  public class Model extends EventDispatcher {

    protected var _settings: SettingsModel;


    public function Model() {
      _settings = SettingsModel.getInstance();
    }

  }

}
