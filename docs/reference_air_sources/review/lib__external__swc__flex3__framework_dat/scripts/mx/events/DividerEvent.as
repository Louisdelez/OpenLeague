package mx.events
{
   import flash.events.Event;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class DividerEvent extends Event
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public static const DIVIDER_DRAG:String = "dividerDrag";
      
      public static const DIVIDER_PRESS:String = "dividerPress";
      
      public static const DIVIDER_RELEASE:String = "dividerRelease";
      
      public var delta:Number;
      
      public var dividerIndex:int;
      
      public function DividerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, dividerIndex:int = -1, delta:Number = NaN)
      {
         super(type,bubbles,cancelable);
         this.dividerIndex = dividerIndex;
         this.delta = delta;
      }
      
      override public function clone() : Event
      {
         return new DividerEvent(type,bubbles,cancelable,dividerIndex,delta);
      }
   }
}

