package Events {

  import flash.events.Event;


  public class GameEvent extends Event {

    public static const CAPTURED: String = "captured";
    public static const FREE_TURN: String = "freeTurn";
    public static const CHANGE_TURN: String = "changeTurn";
    public static const SCORE_CHANGED: String = "scoreChanged";
    public static const END_GAME: String = "end";

    private var _value: uint;

    private var _owner: Boolean;


    public function GameEvent(tpe: String, isMyField: Boolean, value: uint = 0,
                              bubbles: Boolean = false, cancelable: Boolean = false) {

      super(tpe, bubbles, cancelable);

      _owner = isMyField;

      _value = value;
    }


    public function get owner(): Boolean {
      return _owner;
    }


    public function get index(): uint {
      return _value;
    }


    override public function clone(): Event {
      return new GameEvent(type, bubbles, _value, cancelable);
    }


    override public function toString(): String {
      return formatToString("GameEvent", "type", "owner", "index");
    }

  }

}
