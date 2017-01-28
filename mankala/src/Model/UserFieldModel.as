package Model {

  import Events.GameEvent;


  public final class UserFieldModel extends Model {

    private var _my: Boolean;

    private var _score: ScoreModel;

    private var _isStartedThisTurn: Boolean;
    private var _kalaha: uint = 0;
    private var _pits: Array;

    private var _length: uint;
    private var _toKalaha: Boolean;

    public var opponent: UserFieldModel;

    private var _game: GameModel;


    public function UserFieldModel(game: GameModel, my: Boolean) {
      super();

      _game = game;
      _my = my;
      _score = _game.getScore(_my);

      _length = _settings.pitsPerRow * _settings.rows;

      _score.onGame = _length * _settings.stonesPerPit;
      _score.captured = 0;

      _toKalaha = _settings.capturedToKalaha;
      _pits = new Array(_length);

      for (var i: uint = 0; i < _length; ++i) _pits[i] = _settings.stonesPerPit;
    }


    public function get length(): uint {
      return _length;
    }


    public function get score(): ScoreModel {
      return _score;
    }


    public function startMove(index: uint): void {

      _isStartedThisTurn = true;

      opponent._isStartedThisTurn = false;

      var tmp: uint = _pits[index];
      _score.onGame = _score.onGame - _pits[index];
      _pits[index] = 0;
      _moveStones(index, tmp);
    }


    private function _moveStones(startIndex: int, stones: uint): void {

      var i: int;
      var inKalaha: Boolean = false;

      if (stones > 0 && startIndex == _settings.pitsPerRow - 1 && _isStartedThisTurn) {

        ++_kalaha;
        _score.captured = _score.captured + 1;
        --stones;

        inKalaha = true;
      }

      for (i = startIndex + 1; i < _length && stones > 0; ++i) {

        ++_pits[i];
        _score.onGame = _score.onGame + 1;
        inKalaha = false;
        --stones;

        //-- for two rows mode - the kalaha is inside
        if (stones > 0 && UserFieldModel.nextPit(i, _isStartedThisTurn) == -1) {

          ++_kalaha;
          _score.captured = _score.captured + 1;
          --stones;

          inKalaha = true;
        }
      }

      --i;

      if (stones > 0) {

        if (_settings.singleRow)
          opponent._moveStones(-1, stones);
        else
          _moveStones(inKalaha ? _settings.pitsPerRow - 1 : -1, stones);

      } else {

        if (inKalaha) dispatchEvent(new GameEvent(GameEvent.FREE_TURN, _my));
        else {

          if (_canCapture(i)) _capture(i);

          else dispatchEvent(new GameEvent(GameEvent.CHANGE_TURN, _my));
        }
      }

      if (!_score.onGame || !opponent._score.onGame)
        dispatchEvent(new GameEvent(GameEvent.END_GAME, _my));
    }


    private function _capture(index: uint): void {

      var opp: uint = UserFieldModel.oppositePit(index);
      var count: uint = opponent._pits[opp];

      if (count) {

        if (_settings.capturedToKalaha) {

          _kalaha += count + 1;
          _pits[index] = 0;
          _score.captured = _kalaha;
          _score.onGame = _score.onGame - 1;

        } else {

          _pits[index] += count;
          _score.onGame = _score.onGame + count;
        }

        opponent._score.onGame = opponent._score.onGame - count;

        opponent._pits[opp] = 0;

        dispatchEvent(new GameEvent(GameEvent.CAPTURED, _my, index));

      } else dispatchEvent(new GameEvent(GameEvent.CHANGE_TURN, _my));
    }


    /*
     * returns index of next pit for move.
     * if next is on opponent side - result index is larger on _length
     * if result field is kalaha - return -1
     * Used also by view modules
     */
    public static function nextPit(index: int, myTurn: Boolean): int {

      var pitsPerRow: uint = SettingsModel.getInstance().pitsPerRow;
      var length: uint = SettingsModel.getInstance().pitCount;
      var singleRow: Boolean = SettingsModel.getInstance().singleRow;

      //-- next by Kalaha, if singlerow - go to opponent side, else - stay on same side, next row
      if (index == -1) return singleRow ? length : pitsPerRow;

      //-- if its this user turn, return kalaha, else - opponent start
      if (index == pitsPerRow - 1 && singleRow) return myTurn ? -1 : length;

      //-- if its two rows mode - return kalaha
      if (index == pitsPerRow - 1 && !singleRow) return -1;

      //-- if is last of `two rows per user` board - go to first of same bord
      if (index == pitsPerRow * 2 - 1) return 0;

      //-- "inside" pits - just return next
      return index + 1;
    }


    public static function oppositePit(index: int): uint {
      var sett: SettingsModel = SettingsModel.getInstance();

      return sett.singleRow ? sett.pitsPerRow - 1 - index : sett.pitCount + sett.pitsPerRow - index - 1;
    }


    // takes index of last "stoned" pit
    private function _canCapture(index: uint): Boolean {

      if (!_isStartedThisTurn) return false;
      if (_pits[index] != 1) return false;

      if (!_settings.singleRow && index < _settings.pitsPerRow) return false;

      return true;
    }


    public function getStonesInPit(index: uint): uint {
      return _pits[index];
    }


    /*override public function toString():String {

     var str: String = "" + (_my ? "My Field   - " : "Your field - ") + "Kalaha: " + _kalaha + ", pits: ";

     for (var i:uint = 0; i < _length; ++ i ) str += _pits[i] + ", ";
     str += "captured: " + _score.captured + ", onGame: " + _score.onGame;

     return str;
     }*/

  }

}
