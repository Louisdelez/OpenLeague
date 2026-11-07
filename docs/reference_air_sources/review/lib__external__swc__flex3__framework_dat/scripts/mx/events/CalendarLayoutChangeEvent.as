package mx.events
{
   import flash.events.Event;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class CalendarLayoutChangeEvent extends Event
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public static const CHANGE:String = "change";
      
      public var triggerEvent:Event;
      
      public var newDate:Date;
      
      public function CalendarLayoutChangeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, newDate:Date = null, triggerEvent:Event = null)
      {
         super(type,bubbles,cancelable);
         this.newDate = newDate;
         this.triggerEvent = triggerEvent;
      }
      
      override public function clone() : Event
      {
         return new CalendarLayoutChangeEvent(type,bubbles,cancelable,newDate,triggerEvent);
      }
   }
}

