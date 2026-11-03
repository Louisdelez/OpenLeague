package spark.events
{
   import flash.events.Event;
   
   public class GridCaretEvent extends Event
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const CARET_CHANGE:String = "caretChange";
      
      public var oldRowIndex:int;
      
      public var oldColumnIndex:int;
      
      public var newRowIndex:int;
      
      public var newColumnIndex:int;
      
      public function GridCaretEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, oldRowIndex:int = -1, oldColumnIndex:int = -1, newRowIndex:int = -1, newColumnIndex:int = -1)
      {
         super(type,bubbles,cancelable);
         this.oldRowIndex = oldRowIndex;
         this.oldColumnIndex = oldColumnIndex;
         this.newRowIndex = newRowIndex;
         this.newColumnIndex = newColumnIndex;
      }
      
      override public function toString() : String
      {
         return formatToString("GridCaretEvent","type","bubbles","cancelable","eventPhase","oldRowIndex","oldColumnIndex","newRowIndex","newColumnIndex");
      }
      
      override public function clone() : Event
      {
         return new GridCaretEvent(type,bubbles,cancelable,this.oldRowIndex,this.oldColumnIndex,this.newRowIndex,this.newColumnIndex);
      }
   }
}

