package {

  import Events.AlertEvent;

  import Model.GameModel;
  import Model.SettingsModel;

  import View.*;
  import View.Widget.CustomButton;

  import flash.display.Sprite;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.filters.DropShadowFilter;


  public class MankalaGame extends Sprite {

    public var settings: SettingsModel;

    private var _isGameStarted: Boolean;
    private var _currentScreen: AbstractScreen;
    public var game: Game;


    public function MankalaGame(): void {

      stage.align = StageAlign.TOP_LEFT;
      stage.scaleMode = StageScaleMode.NO_SCALE;

      settings = SettingsModel.getInstance();

      CustomButton.textShadowFilter = new DropShadowFilter(2, 35);
      CustomButton.textShadowFilter.blurX = 0;
      CustomButton.textShadowFilter.blurY = 0;
      CustomButton.textShadowFilter.color = 0xffff00;

      AbstractScreen.bgShadowFilter = new DropShadowFilter(0);
      AbstractScreen.bgShadowFilter.blurX = 30;
      AbstractScreen.bgShadowFilter.blurY = 30;

      CustomButton.btnShadowFilter = new DropShadowFilter(0);
      CustomButton.btnShadowFilter.blurX = 10;
      CustomButton.btnShadowFilter.blurY = 10;

      _clear();

      showLongIntro();
      //playGame(false);
      //showMenu();
    }


    public function get gameStarted(): Boolean {
      return _isGameStarted;
    }


    private function _clear(): void {

      _isGameStarted = false;
      if (game) game.remove();
      game = null;
    }


    public function showShortIntro(): void {

      _currentScreen = new ShortIntro(this);
      addChild(_currentScreen);
    }


    public function showLongIntro(): void {

      _currentScreen = new LongIntro(this);
      addChild(_currentScreen);
    }


    public function showMenu(): void {

      _currentScreen = new Menu(this);
      addChild(_currentScreen);
    }


    public function showSettings(): void {

      _currentScreen = new Settings(this);
      addChild(_currentScreen);
    }


    public function playGame(single: Boolean = true): void {

      settings.singleUser = single;
      _isGameStarted = true;
      game = new Game(this);
      addChild(game);
    }


    public function restartGame(): void {

      _currentScreen = new Alert(this);
      _currentScreen.addEventListener(AlertEvent.NO, backToGame);
      _currentScreen.addEventListener(AlertEvent.YES, _onRestartConfirmed);

      addChild(_currentScreen);
    }


    public function showHelp(): void {

      _currentScreen = new Help(this);
      addChild(_currentScreen);
    }


    public function showScore(game: GameModel): void {

      _clear();

      _currentScreen = new Score(this, game);
      addChild(_currentScreen);
    }


    private function _onRestartConfirmed(event: AlertEvent): void {

      _clear();
      showMenu();
    }


    public function backToGame(event: AlertEvent = null): void {
      game.enable();
    }

  }

}
