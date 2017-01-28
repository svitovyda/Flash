package View {

  import View.Widget.CustomButton;

  import flash.display.MovieClip;
  import flash.events.Event;
  import flash.events.MouseEvent;


  public final class LongIntro extends AbstractScreen {

    private var _graphicsMc: MovieClip;
    private var _skipBtn: CustomButton;


    public function LongIntro(mainController: MankalaGame) {
      super(mainController);

      _skipBtn = new CustomButton("Skip", 40);
      addChild(_skipBtn);

      _skipBtn.addEventListener(MouseEvent.CLICK, _onEnd);
      _draw();
    }


    override protected function _draw(): void {
      _graphicsMc = new shortIntro();

      _graphicsMc.x = _settings.centerX;
      _graphicsMc.y = _settings.centerY;
      _graphicsMc.addEventListener(Event.COMPLETE, _onEnd);

      addChild(_graphicsMc);

      _skipBtn.x = _settings.WIDTH - _skipBtn.width - _settings.margin;
      _skipBtn.y = _settings.HEIGHT - _skipBtn.height - _settings.margin;
    }


    private function _onEnd(event: Event): void {

      _graphicsMc.stop();
      _mainController.showMenu();
      remove();
    }

  }

}
