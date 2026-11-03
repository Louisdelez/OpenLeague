package mx.skins.spark
{
   import flash.display.Graphics;
   import mx.skins.Border;
   
   public class ProgressIndeterminateSkin extends Border
   {
      
      private static var colors:Array = [13421772,8421504];
      
      private static var alphas:Array = [0.85,0.85];
      
      private static var ratios:Array = [0,255];
      
      public function ProgressIndeterminateSkin()
      {
         super();
      }
      
      override public function get measuredWidth() : Number
      {
         return 195;
      }
      
      override public function get measuredHeight() : Number
      {
         return 6;
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         super.updateDisplayList(w,h);
         var hatchInterval:Number = Number(getStyle("indeterminateMoveInterval"));
         if(isNaN(hatchInterval))
         {
            hatchInterval = 28;
         }
         var g:Graphics = graphics;
         g.clear();
         for(var i:int = 0; i < w; i += hatchInterval)
         {
            g.beginGradientFill("linear",colors,alphas,ratios,verticalGradientMatrix(i - 4,2,7,h - 4));
            g.moveTo(i,2);
            g.lineTo(Math.min(i + 7,w),2);
            g.lineTo(Math.min(i + 3,w),h - 2);
            g.lineTo(Math.max(i - 4,0),h - 2);
            g.lineTo(i,2);
            g.endFill();
            g.lineStyle(1,0,0.12);
            g.moveTo(i,2);
            g.lineTo(Math.max(i - 4,0),h - 2);
            g.moveTo(Math.min(i + 7,w),2);
            g.lineTo(Math.min(i + 3,w),h - 2);
         }
      }
   }
}

