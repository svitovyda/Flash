package {

  import flash.events.EventDispatcher;
  import flash.system.Capabilities;
  import flash.utils.Dictionary;


  /// Provides static functions to put in trace useful information in nice format.
  public class Debugger extends EventDispatcher {

    // ================== Static section ===============================

    // ------------------ Fields -----------------------------------

    static public var IS_DEBUG_MODE: Boolean = false;

    // ------------------ Methods  ---------------------------------

    /// Collects all info about FP - version, debug mode etc.
    static public function init(): void {
      Debugger.IS_DEBUG_MODE = isDebugBuild();
    }


    /**
     * Returns true if the user is running the app on a Debug Flash Player.
     * Uses the Capabilities class
     **/
    static public function isDebugPlayer(): Boolean {
      return Capabilities.isDebugger;
    }


    /**
     * Returns true if the swf is built in debug mode
     **/
    static public function isDebugBuild(): Boolean {
      var error: Error = new Error();
      var pattern: RegExp = /[0-9]/;
      var errorStackTrace: String = error.getStackTrace();
      return pattern.test(errorStackTrace);
    }


    /**
     * Returns true if the swf is built in release mode
     **/
    static public function isReleaseBuild(): Boolean {
      return !isDebugBuild();
    }


    /// Returns stackTrace of error, clear from full file path, extra doublicates etc.
    static public function getClearStackTrace(error: Error): String {
      var reg: RegExp = /(Error.*\W).*Debugger.as:\d+\]\W(.*trace\(\).*\W)*/;

      var result: String = error.getStackTrace().replace(reg, "$1");
      reg = /.*at .*\W(\w+\(\)).*\\src\\(.*).as:(\d+)\]/gmx;

      return result.replace(reg, "\tin $1 at $2: $3");
    }

    /// Traces all error information with clear stack trace
    static public function outputError(error: Error): void {
      if (Debugger.IS_DEBUG_MODE) {
        trace("-------------------------");
        trace(error.message);
        trace(Debugger.getClearStackTrace(error));
        trace("-------------------------");
      }
    }

    /// Returns class, function and line number where function from debugger or trace override function was called.
    static public function getStackTraceLine(error: Error): String {
      var reg: RegExp = /.*((Debugger.as:\d+)|(trace\(\)\[\S*))\]\W/s;
      var result: String = error.getStackTrace().replace(reg, "");

      reg = /\tat \S*(\/|\:\:)(\S+\(\))\S*\\(\w+).as:(\d+)\].*/s;

      return result.replace(reg, "in $2, $3.as, #$4:");
    }

    /// Traces args with class, function and line number info, where output() was called.
    static public function output(...args): void {
      if (Debugger.IS_DEBUG_MODE) {
        var error: Error = new Error();
        trace(Debugger.getStackTraceLine(error), args);
      }
    }

    /// Returns String representation of object with hole subobjects. Do not pass flagDict here.
    static public function objToString(obj: Object): String {
      if (obj) {
        return _parseObject(obj);
      }

      return "null";
    }

    /// Recursive function that parses object to string.
    static internal function _parseObject(obj: Object, margin: String = "  ", flagDict: Dictionary = null): String {
      if (!obj) {
        return "null";
      }

      if (!flagDict) {
        flagDict = new Dictionary(true);
      }

      var result: String = "";

      for (var prop: String in obj) {
        result += "\n" + margin + prop + ": ";
        if (obj[prop] is Object && !flagDict[obj[prop]]) {
          flagDict[obj[prop]] = true;
          result += " = " + obj[prop].toString() + Debugger._parseObject(obj[prop], margin + "  ", flagDict);
        } else {
          if (obj[prop]) {
            result += obj[prop].toString();
          } else {
            result += "null";
          }
        }
      }

      return result;
    }

    // ================== Class section ================================
    // ------------------ Fields -----------------------------------
    // ------------------ Constructor ------------------------------

    public function Debugger() {
      //TODO: Screen with debug information
    }

    // ------------------ Properties -------------------------------
    // ------------------ Public methods  --------------------------
    // ------------------ Protected methods  -----------------------
    // ------------------ Private methods  -------------------------
    // ------------------ Interface methods ------------------------
    // ------------------ Event handlers----------------------------
  }
}
