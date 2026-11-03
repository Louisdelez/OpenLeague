package mx.events
{
   import flash.events.Event;
   
   public class DateChooserEvent extends Event
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
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
         return new DateChooserEvent(type,bubbles,cancelable,this.detail,this.triggerEvent);
      }
   }
}

