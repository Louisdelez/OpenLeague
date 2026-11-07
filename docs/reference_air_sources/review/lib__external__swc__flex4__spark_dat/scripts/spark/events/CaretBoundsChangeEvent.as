package spark.events
{
   import flash.events.Event;
   import flash.geom.Rectangle;
   
   [ExcludeClass]
   public class CaretBoundsChangeEvent extends Event
   {
      
      public static var CARET_BOUNDS_CHANGE:String = "caretBoundsChange";
      
      public var oldCaretBounds:Rectangle;
      
      public var newCaretBounds:Rectangle;
      
      public function CaretBoundsChangeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, oldCaretBounds:Rectangle = null, newCaretBounds:Rectangle = null)
      {
         this.oldCaretBounds = oldCaretBounds;
         this.newCaretBounds = newCaretBounds;
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         return new CaretBoundsChangeEvent(type,bubbles,cancelable,this.oldCaretBounds,this.newCaretBounds);
      }
   }
}

