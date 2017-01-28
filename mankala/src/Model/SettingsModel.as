package Model {

  public final class SettingsModel {

    static private var _instance: SettingsModel;

    public const WIDTH: uint = 700;
    public const HEIGHT: uint = 500;

    public const margin: uint = 10;
    public const hintRadius: uint = 14;
    public const stoneRadius: uint = 8;

    private var _centerX: uint;
    private var _centerY: uint;

    public const fieldWidth: uint = 600;
    private var _fieldHeight: uint;
    public const pitsPerRow: uint = 6;
    private var _pitCount: uint;

    private var _rows: uint;

    public const pitSize: uint = 60;

    private var _kalahaWidth: uint;
    private var _kalahaHeight: uint;
    private var _pitStartX: uint;

    private var _singleRow: Boolean = true;
    public var capturedToKalaha: Boolean = true;
    public var stonesPerPit: uint = 3;

    public var singleUser: Boolean;

    public const TIME_STEP: uint = 400;


    public function SettingsModel() {

      _centerX = WIDTH >> 1;
      _centerY = HEIGHT >> 1;

      calculate();
    }


    public static function getInstance(): SettingsModel {

      if (SettingsModel._instance == null) {
        SettingsModel._instance = new SettingsModel();
      }

      return SettingsModel._instance;
    }


    public function calculate(): void {

      _rows = _singleRow ? 1 : 2;
      _pitCount = pitsPerRow * _rows;
      _fieldHeight = _singleRow ? 160 : 300;

      _pitStartX = (fieldWidth - pitsPerRow * pitSize - (pitsPerRow - 1) * margin ) >> 1;

      _kalahaWidth = _pitStartX - 4 * margin;
      _kalahaHeight = fieldHeight - 3 * margin;
    }


    public function get centerX(): uint {
      return _centerX;
    }


    public function get centerY(): uint {
      return _centerY;
    }


    public function get fieldHeight(): uint {
      return _fieldHeight;
    }


    public function get rows(): uint {
      return _rows;
    }


    public function get kalahaWidth(): uint {
      return _kalahaWidth;
    }


    public function get kalahaHeight(): uint {
      return _kalahaHeight;
    }


    public function get pitStartX(): uint {
      return _pitStartX;
    }


    public function get singleRow(): Boolean {
      return _singleRow;
    }


    public function get pitCount(): uint {
      return _pitCount;
    }


    public function set singleRow(isSingle: Boolean): void {

      _singleRow = isSingle;
      calculate();
    }

  }

}
