package spark.events
{
   import flash.events.Event;
   
   public class DropDownEvent extends Event
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const CLOSE:String = "close";
      
      public static const OPEN:String = "open";
      
      public var triggerEvent:Event;
      
      public function DropDownEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, triggerEvent:Event = null)
      {
         super(type,bubbles,cancelable);
         this.triggerEvent = triggerEvent;
      }
      
      override public function clone() : Event
      {
         return new DropDownEvent(type,bubbles,cancelable,this.triggerEvent);
      }
   }
}

