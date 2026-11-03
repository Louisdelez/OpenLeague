package mx.events
{
   import flash.events.Event;
   
   public class CalendarLayoutChangeEvent extends Event
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const CHANGE:String = "change";
      
      public var newDate:Date;
      
      public var triggerEvent:Event;
      
      public function CalendarLayoutChangeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, newDate:Date = null, triggerEvent:Event = null)
      {
         super(type,bubbles,cancelable);
         this.newDate = newDate;
         this.triggerEvent = triggerEvent;
      }
      
      override public function clone() : Event
      {
         return new CalendarLayoutChangeEvent(type,bubbles,cancelable,this.newDate,this.triggerEvent);
      }
   }
}

