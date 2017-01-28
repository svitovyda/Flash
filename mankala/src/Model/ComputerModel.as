package Model {


  public final class ComputerModel extends Model {

    private var _field: UserFieldModel;
    private var _opponent: UserFieldModel;


    public function ComputerModel(field: UserFieldModel) {
      _field = field;
      _opponent = _field.opponent;
    }


    public function makeTurn(): uint {

      //-- try to make "free turn"
      for (var i: int = _settings.pitsPerRow - 1; i >= 0; --i) {
        if (_field.getStonesInPit(i) &&
          _field.getStonesInPit(i) == _settings.pitsPerRow - i)
          return i;
      }

      if (!_settings.singleRow) {
        for (i = _settings.pitCount - 1; i >= _settings.pitsPerRow; --i) {
          if (_field.getStonesInPit(i) &&
            _field.getStonesInPit(i) == _settings.pitCount - i + _settings.pitsPerRow + 1)
            return i;
        }
      }

      //-- try to capture
      var endIndex: int;

      if (_settings.singleRow)

        for (i = 0; i < _settings.pitsPerRow; ++i) {
          if (_field.getStonesInPit(i)) {

            endIndex = i + _field.getStonesInPit(i);

            while (endIndex >= _settings.pitsPerRow) {
              endIndex -= (2 * _settings.pitsPerRow + 1);
            }

            if (endIndex > 0 &&
              _field.getStonesInPit(endIndex) == 0 &&
              _opponent.getStonesInPit(UserFieldModel.oppositePit(endIndex)))
              return i;
          }
        }

      else

        for (i = 0; i < _settings.pitCount; ++i) {
          if (_field.getStonesInPit(i)) {

            endIndex = i + _field.getStonesInPit(i) - uint(i < _settings.pitsPerRow);

            while (endIndex >= _settings.pitCount) {
              endIndex -= (2 * _settings.pitsPerRow + 1);
            }

            if (endIndex >= _settings.pitsPerRow &&
              endIndex > 0 &&
              endIndex < _settings.pitCount &&
              _field.getStonesInPit(endIndex) == 0 &&
              _opponent.getStonesInPit(UserFieldModel.oppositePit(endIndex)))
              return i;
          }
        }

      //-- else return random (and not empty) pit
      var index: int = Math.random() * _settings.pitsPerRow +
        uint(!_settings.singleRow) * _settings.pitsPerRow;

      while (_field.getStonesInPit(index) == 0) {
        --index;
        if (index < 0) index = _field.length - 1;
      }

      return index;
    }

  }

}
