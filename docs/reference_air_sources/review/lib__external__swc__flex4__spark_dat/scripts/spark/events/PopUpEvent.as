package spark.events
{
   import flash.events.Event;
   
   public class PopUpEvent extends Event
   {
      
      public static const OPEN:String = "open";
      
      public static const CLOSE:String = "close";
      
      public var commit:Boolean;
      
      public var data:*;
      
      public function PopUpEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, commit:Boolean = false, data:* = undefined)
      {
         super(type,bubbles,cancelable);
         this.commit = commit;
         this.data = data;
      }
      
      override public function clone() : Event
      {
         return new PopUpEvent(type,bubbles,cancelable,this.commit,this.data);
      }
   }
}

