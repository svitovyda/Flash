package {

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

public final class Main extends Sprite {
  private var fogEffect: Fog;

  public function Main(): void {
    if (stage) {
      _init();
    }
    else {
      addEventListener(Event.ADDED_TO_STAGE, _onAdded, false, 0, true);
      addEventListener(Event.ADDED, _onAdded, false, 0, true);
    }

    _init();
  }


  private function _init(): void {
    if (fogEffect) {
      return;
    }

    fogEffect = new Fog();
    addChild(fogEffect);

    if (stage) {
      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.align = StageAlign.TOP_LEFT;

      stage.addEventListener(Event.RESIZE, _onStageResizeHandler, false, 0, true);
    }
  }


  protected function _onStageResizeHandler(e: Event): void {
    fogEffect.resize();
  }


  private function _onAdded(e: Event): void {
    removeEventListener(Event.ADDED_TO_STAGE, _onAdded);
    removeEventListener(Event.ADDED, _onAdded);

    if (!fogEffect) {
      _init();
    }
  }
}

}
