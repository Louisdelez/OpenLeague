package mx.skins.halo
{
   import flash.display.Graphics;
   import mx.skins.Border;
   import mx.utils.ColorUtil;
   
   public class ProgressIndeterminateSkin extends Border
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
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
         var barColorStyle:* = getStyle("barColor");
         var barColor:uint = styleManager.isValidStyleValue(barColorStyle) ? uint(barColorStyle) : uint(getStyle("themeColor"));
         var barColor0:Number = Number(ColorUtil.adjustBrightness2(barColor,60));
         var hatchInterval:Number = Number(getStyle("indeterminateMoveInterval"));
         if(isNaN(hatchInterval) || hatchInterval == 0)
         {
            hatchInterval = 28;
         }
         var g:Graphics = graphics;
         g.clear();
         for(var i:int = 0; i < w; i += hatchInterval)
         {
            g.beginFill(barColor0,0.8);
            g.moveTo(i,1);
            g.lineTo(Math.min(i + 14,w),1);
            g.lineTo(Math.min(i + 10,w),h - 1);
            g.lineTo(Math.max(i - 4,0),h - 1);
            g.lineTo(i,1);
            g.endFill();
         }
      }
   }
}

