package flash.ui
{
   import flash.events.EventDispatcher;
   
   [native(cls="GameInputControlClass",instance="GameInputControlObject",methods="auto")]
   [API("674")]
   [Event(name="Event.CHANGE",type="flash.events.Event")]
   public final class GameInputControl extends EventDispatcher
   {
      
      public function GameInputControl()
      {
         super();
      }
      
      public native function get numValues() : int;
      
      public native function get index() : int;
      
      public native function getValueAt(param1:int = 0) : Number;
      
      public native function get relative() : Boolean;
      
      public native function get type() : String;
      
      public native function get hand() : String;
      
      public native function get finger() : String;
      
      public native function get device() : GameInputDevice;
   }
}

