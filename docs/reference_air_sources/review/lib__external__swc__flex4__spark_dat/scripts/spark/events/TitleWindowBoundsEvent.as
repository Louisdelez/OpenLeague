package spark.events
{
   import flash.events.Event;
   import flash.geom.Rectangle;
   
   public class TitleWindowBoundsEvent extends Event
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const WINDOW_MOVE_START:String = "windowMoveStart";
      
      public static const WINDOW_MOVING:String = "windowMoving";
      
      public static const WINDOW_MOVE:String = "windowMove";
      
      public static const WINDOW_MOVE_END:String = "windowMoveEnd";
      
      public var beforeBounds:Rectangle;
      
      public var afterBounds:Rectangle;
      
      public function TitleWindowBoundsEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, beforeBounds:Rectangle = null, afterBounds:Rectangle = null)
      {
         super(type,bubbles,cancelable);
         this.beforeBounds = beforeBounds;
         this.afterBounds = afterBounds;
      }
      
      override public function clone() : Event
      {
         return new TitleWindowBoundsEvent(type,bubbles,cancelable,this.beforeBounds,this.afterBounds);
      }
   }
}

