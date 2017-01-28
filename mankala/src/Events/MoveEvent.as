package Events {

  import flash.events.Event;


  public class MoveEvent extends Event {

    public static const MOVE_END: String = "moveEnd";
    public static const CAPTURE_END: String = "captureEnd";


    public function MoveEvent(tpe: String, bubbles: Boolean = false, cancelable: Boolean = false) {
      super(tpe, bubbles, cancelable);
    }


    override public function clone(): Event {
      return new MoveEvent(type, bubbles, cancelable);
    }


    override public function toString(): String {
      return formatToString("MoveEvent", "type");
    }

  }

}
