package flash.display
{
   import flash.events.EventDispatcher;
   import flash.geom.Rectangle;
   
   [API("661")]
   [native(cls="ScreenClass",instance="ScreenObject",methods="auto",construct="native")]
   public final class Screen extends EventDispatcher
   {
      
      public function Screen()
      {
         super();
      }
      
      public static native function get screens() : Array;
      
      public static native function get mainScreen() : Screen;
      
      public static native function getScreensForRectangle(param1:Rectangle) : Array;
      
      public native function get bounds() : Rectangle;
      
      public native function get visibleBounds() : Rectangle;
      
      public native function get colorDepth() : int;
   }
}

