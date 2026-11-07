package flash.events
{
   import flash.geom.Rectangle;
   
   [API("661")]
   public class NativeWindowBoundsEvent extends Event
   {
      
      public static const MOVING:String = "moving";
      
      public static const MOVE:String = "move";
      
      public static const RESIZING:String = "resizing";
      
      public static const RESIZE:String = "resize";
      
      private var m_beforeBounds:Rectangle;
      
      private var m_afterBounds:Rectangle;
      
      public function NativeWindowBoundsEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, beforeBounds:Rectangle = null, afterBounds:Rectangle = null)
      {
         super(type,bubbles,cancelable);
         this.m_beforeBounds = beforeBounds;
         this.m_afterBounds = afterBounds;
      }
      
      override public function clone() : Event
      {
         return new NativeWindowBoundsEvent(type,bubbles,cancelable,this.m_beforeBounds,this.m_afterBounds);
      }
      
      public function get beforeBounds() : Rectangle
      {
         return this.m_beforeBounds;
      }
      
      public function get afterBounds() : Rectangle
      {
         return this.m_afterBounds;
      }
      
      override public function toString() : String
      {
         return formatToString("NativeWindowBoundsEvent","type","bubbles","cancelable","beforeBounds","afterBounds");
      }
   }
}

