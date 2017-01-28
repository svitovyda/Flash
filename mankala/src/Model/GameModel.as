package Model {

  import Events.GameEvent;


  public final class GameModel extends Model {

    private var _myPits: UserFieldModel;
    private var _yourPits: UserFieldModel;
    private var _myScore: ScoreModel;
    private var _yourScore: ScoreModel;


    public function GameModel(scoreListener: Function, gameListener: Function) {
      super();

      _myScore = new ScoreModel(true);
      _yourScore = new ScoreModel(false);

      _myScore.addEventListener(GameEvent.SCORE_CHANGED, scoreListener);
      _yourScore.addEventListener(GameEvent.SCORE_CHANGED, scoreListener);

      _yourPits = new UserFieldModel(this, false);
      _myPits = new UserFieldModel(this, true);
      _yourPits.opponent = _myPits;
      _myPits.opponent = _yourPits;

      _yourPits.addEventListener(GameEvent.CAPTURED, gameListener);
      _yourPits.addEventListener(GameEvent.FREE_TURN, gameListener);
      _yourPits.addEventListener(GameEvent.CHANGE_TURN, gameListener);
      _yourPits.addEventListener(GameEvent.END_GAME, gameListener);

      _myPits.addEventListener(GameEvent.CAPTURED, gameListener);
      _myPits.addEventListener(GameEvent.FREE_TURN, gameListener);
      _myPits.addEventListener(GameEvent.CHANGE_TURN, gameListener);
      _myPits.addEventListener(GameEvent.END_GAME, gameListener);
    }


    public function getScore(my: Boolean): ScoreModel {
      return my ? _myScore : _yourScore;
    }


    public function get computer(): UserFieldModel {
      return _myPits;
    }


    public function turn(index: uint, myTurn: Boolean): void {

      if (myTurn) _myPits.startMove(index);
      else _yourPits.startMove(index);
    }


    /*override public function toString():String {
     return _myPits + "\n" + _yourPits;
     }*/

  }

}
