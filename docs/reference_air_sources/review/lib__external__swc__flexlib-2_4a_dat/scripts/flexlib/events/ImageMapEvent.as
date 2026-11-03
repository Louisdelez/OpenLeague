package flexlib.events
{
   import flash.events.Event;
   import flexlib.controls.area;
   
   public class ImageMapEvent extends Event
   {
      
      public static const SHAPE_CLICK:String = "shapeClick";
      
      public static const SHAPE_DOUBLECLICK:String = "shapeDoubleClick";
      
      public static const SHAPE_OVER:String = "shapeOver";
      
      public static const SHAPE_OUT:String = "shapeOut";
      
      public static const SHAPE_DOWN:String = "shapeDown";
      
      public static const SHAPE_UP:String = "shapeUp";
      
      public var href:String;
      
      public var linkTarget:String;
      
      public var item:area;
      
      public function ImageMapEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, href:String = null, item:area = null, target:String = null)
      {
         super(type,bubbles,cancelable);
         this.href = href;
         this.item = item;
         this.linkTarget = target;
      }
   }
}

