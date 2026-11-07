package mx.events
{
   import flash.events.Event;
   
   public class NumericStepperEvent extends Event
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
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
         return new NumericStepperEvent(type,bubbles,cancelable,this.value);
      }
   }
}

