package Model {

  import Events.GameEvent;


  public final class ScoreModel extends Model {

    private var _my: Boolean;
    private var _label: String;

    private var _onGame: uint;
    private var _captured: uint;
    private var _total: uint;


    public function ScoreModel(my: Boolean) {
      super();

      _my = my;

      _label = _my ? (_settings.singleUser ? "Computer" : "Player 2") :
        (_settings.singleUser ? "You" : "Player 1");
    }


    public function get captured(): uint {
      return _captured;
    }


    public function get onGame(): uint {
      return _onGame;
    }


    public function get label(): String {
      return _label;
    }


    public function get total(): uint {
      return _total;
    }


    public function set captured(nv: uint): void {

      _captured = nv;
      _total = _captured + _onGame;
      dispatchEvent(new GameEvent(GameEvent.SCORE_CHANGED, _my));
    }


    public function set onGame(nv: uint): void {

      _onGame = nv;
      _total = _captured + _onGame;
      dispatchEvent(new GameEvent(GameEvent.SCORE_CHANGED, _my));
    }

  }

}
