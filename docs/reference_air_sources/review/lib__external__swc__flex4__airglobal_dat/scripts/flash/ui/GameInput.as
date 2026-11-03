package flash.ui
{
   import flash.events.EventDispatcher;
   
   [native(cls="GameInputClass",instance="GameInputObject",methods="auto")]
   [API("674")]
   [Event(name="GameInputEvent.DEVICE_REMOVED",type="flash.events.GameInputEvent")]
   [Event(name="GameInputEvent.DEVICE_ADDED",type="flash.events.GameInputEvent")]
   public final class GameInput extends EventDispatcher
   {
      
      public function GameInput()
      {
         super();
      }
      
      public static native function getDeviceAt(param1:int) : GameInputDevice;
      
      public static native function get numDevices() : int;
      
      public static native function get isSupported() : Boolean;
   }
}

