package {

  import flash.display.BitmapData;
  import flash.display.Sprite;


  public final class CurveLine extends Sprite {
    private var _width: Number;
    private var _height: Number;

    private var _scaleMapX: Number;
    private var _scaleMapY: Number;

    private var _deformationMap: BitmapData;

    private var _color: uint;

    private var _beginColorR: uint;
    private var _beginColorG: uint;
    private var _beginColorB: uint;
    private var _endColorR: uint;
    private var _endColorG: uint;
    private var _endColorB: uint;

    private var _colorDelta: Number = ( Math.random() - 0.5 ) * 0.01;
    private var _colorPosition: Number = 40;

    private var _yIndex: uint;
    private var _yLevel: Number;


    public function CurveLine(bmpdMap: BitmapData, j: uint, width: Number, height: Number) {
      _width = width + 30;
      _height = height + 30;
      _deformationMap = bmpdMap;

      _scaleMapX = _width / _deformationMap.width;
      _scaleMapY = _height / 150;

      _yIndex = j;
      _yLevel = Math.random() * j * _height * 0.1;

      _initBeginColor();
      _initEndColor();
    }


    public function resize(newWidth: Number, newHeight: Number): void {
      newWidth += 30;
      newHeight += 30;

      var coefY: Number = newHeight / _height;

      _width = newWidth;
      _height = newHeight;
      _yLevel *= coefY;

      _scaleMapX = _width / _deformationMap.width;
      _scaleMapY = _height / 150;
    }


    public function draw(): void {
      graphics.clear();
      graphics.lineStyle(0.1, _color, 0.3);

      graphics.moveTo(-20, _yLevel);

      var _value: Number;

      for (var w: int = 0; w < _deformationMap.width; ++w) {
        _value = _deformationMap.getPixel(w, _yIndex) * 0.00001;
        graphics.lineTo(w * _scaleMapX, _value * _scaleMapY);
      }

      _changeColor();
    }


    private function _initBeginColor(): void { // "magic numbers" define specific color range
      _beginColorB = Math.random() * 45 + 210;
      _beginColorR = Math.random() * 190 + 65;
      _beginColorG = Math.random() * 145 + 110;
    }


    private function _initEndColor(): void { // "magic numbers" define specific color range
      _endColorB = Math.random() * 95 + 160;
      _endColorR = 275 - _endColorB;
      _endColorG = Math.random() * 145 + 110;
    }


    protected function _changeColor(): void {
      _color = ( _beginColorR + ( _endColorR - _beginColorR ) * _colorPosition ) << 16 |
        ( _beginColorG + ( _endColorG - _beginColorG ) * _colorPosition ) << 8 |
        ( _beginColorB + ( _endColorB - _beginColorB ) * _colorPosition );

      _colorPosition += _colorDelta;

      if (_colorPosition < 0) {
        _colorDelta = -_colorDelta;
        _colorPosition = 0;

        _initEndColor();
      }
      else if (_colorPosition > 1) {
        _colorDelta = -_colorDelta;
        _colorPosition = 1;

        _initBeginColor();
      }
    }
  }
}
