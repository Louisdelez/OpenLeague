package mx.events
{
   import flash.events.Event;
   
   public class DividerEvent extends Event
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
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
         return new DividerEvent(type,bubbles,cancelable,this.dividerIndex,this.delta);
      }
   }
}

