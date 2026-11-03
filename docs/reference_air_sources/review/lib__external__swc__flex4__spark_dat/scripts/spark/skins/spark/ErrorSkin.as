package spark.skins.spark
{
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ErrorSkin extends HighlightBitmapCaptureSkin
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var glowFilter:GlowFilter = new GlowFilter(16711680,0.85,2,2,3,1,false,true);
      
      private static var rect:Rectangle = new Rectangle();
      
      private static var filterPt:Point = new Point();
      
      public function ErrorSkin()
      {
         super();
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      override protected function processBitmap() : void
      {
         rect.x = rect.y = 0;
         rect.width = bitmap.bitmapData.width;
         rect.height = bitmap.bitmapData.height;
         glowFilter.color = target.getStyle("errorColor");
         bitmap.bitmapData.applyFilter(bitmap.bitmapData,rect,filterPt,glowFilter);
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         if(!target)
         {
            return;
         }
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         bitmap.x = bitmap.y = 0;
         bitmap.width = target.width;
         bitmap.height = target.height;
      }
   }
}

