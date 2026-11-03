package mx.events
{
   import flash.events.Event;
   import flash.events.NativeWindowBoundsEvent;
   import flash.geom.Rectangle;
   
   public class FlexNativeWindowBoundsEvent extends NativeWindowBoundsEvent
   {
      
      public static const WINDOW_RESIZE:String = "windowResize";
      
      public static const WINDOW_MOVE:String = "windowMove";
      
      public function FlexNativeWindowBoundsEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, beforeBounds:Rectangle = null, afterBounds:Rectangle = null)
      {
         super(type,bubbles,cancelable,beforeBounds,afterBounds);
      }
      
      override public function clone() : Event
      {
         return new FlexNativeWindowBoundsEvent(type,bubbles,cancelable,beforeBounds,afterBounds);
      }
   }
}

