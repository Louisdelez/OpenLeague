package mx.events
{
   import flash.events.Event;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class DateChooserEvent extends Event
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public static const SCROLL:String = "scroll";
      
      public var detail:String;
      
      public var triggerEvent:Event;
      
      public function DateChooserEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, detail:String = null, triggerEvent:Event = null)
      {
         super(type,bubbles,cancelable);
         this.detail = detail;
         this.triggerEvent = triggerEvent;
      }
      
      override public function clone() : Event
      {
         return new DateChooserEvent(type,bubbles,cancelable,detail,triggerEvent);
      }
   }
}

