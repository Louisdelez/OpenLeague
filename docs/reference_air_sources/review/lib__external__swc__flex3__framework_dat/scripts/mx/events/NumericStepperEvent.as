package mx.events
{
   import flash.events.Event;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class NumericStepperEvent extends Event
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public static const CHANGE:String = "change";
      
      public var value:Number;
      
      public var triggerEvent:Event;
      
      public function NumericStepperEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, value:Number = NaN, triggerEvent:Event = null)
      {
         super(type,bubbles,cancelable);
         this.value = value;
         this.triggerEvent = triggerEvent;
      }
      
      override public function clone() : Event
      {
         return new NumericStepperEvent(type,bubbles,cancelable,value);
      }
   }
}

