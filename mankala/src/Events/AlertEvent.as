package Events {

  import flash.events.Event;


  public class AlertEvent extends Event {

    public static const YES: String = "yes";
    public static const NO: String = "no";
    public static const OK: String = "ok";


    public function AlertEvent(tpe: String, bubbles: Boolean = false, cancelable: Boolean = false) {
      super(tpe, bubbles, cancelable);
    }

    override public function clone(): Event {
      return new AlertEvent(type, bubbles, cancelable);
    }

    override public function toString(): String {
      return formatToString("AlertEvent", "type", "bubbles", "cancelable", "eventPhase");
    }

  }

}
