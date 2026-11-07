package spark.events
{
   import flash.events.Event;
   
   public class IndexChangeEvent extends Event
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const CHANGE:String = "change";
      
      public static const CHANGING:String = "changing";
      
      public static const CARET_CHANGE:String = "caretChange";
      
      public var newIndex:int;
      
      public var oldIndex:int;
      
      public function IndexChangeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, oldIndex:int = -1, newIndex:int = -1)
      {
         super(type,bubbles,cancelable);
         this.oldIndex = oldIndex;
         this.newIndex = newIndex;
      }
      
      override public function clone() : Event
      {
         return new IndexChangeEvent(type,bubbles,cancelable,this.oldIndex,this.newIndex);
      }
   }
}

