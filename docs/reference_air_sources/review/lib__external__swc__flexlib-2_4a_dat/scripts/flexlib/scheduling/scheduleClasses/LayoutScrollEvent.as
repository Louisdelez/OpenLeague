package flexlib.scheduling.scheduleClasses
{
   import mx.events.ScrollEvent;
   
   public class LayoutScrollEvent extends ScrollEvent
   {
      
      public static const ITEM_SCROLL:String = "itemScroll";
      
      public static const PIXEL_SCROLL:String = "pixelScroll";
      
      public function LayoutScrollEvent(type:String)
      {
         super(type);
      }
   }
}

