package spark.events
{
   import flash.events.Event;
   import flashx.textLayout.operations.FlowOperation;
   
   public class TextOperationEvent extends Event
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const CHANGING:String = "changing";
      
      public static const CHANGE:String = "change";
      
      public var operation:FlowOperation;
      
      public function TextOperationEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = true, operation:FlowOperation = null)
      {
         super(type,bubbles,cancelable);
         this.operation = operation;
      }
      
      override public function clone() : Event
      {
         return new TextOperationEvent(type,bubbles,cancelable,this.operation);
      }
   }
}

