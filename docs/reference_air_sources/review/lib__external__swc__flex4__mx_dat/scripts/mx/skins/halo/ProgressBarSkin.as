package mx.skins.halo
{
   import mx.skins.Border;
   import mx.utils.ColorUtil;
   
   public class ProgressBarSkin extends Border
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function ProgressBarSkin()
      {
         super();
      }
      
      override public function get measuredWidth() : Number
      {
         return 200;
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
         var barColor0:Number = Number(ColorUtil.adjustBrightness2(barColor,40));
         var fillColors:Array = [barColor0,barColor];
         graphics.clear();
         drawRoundRect(0,0,w,h,0,fillColors,0.5,verticalGradientMatrix(0,0,w - 2,h - 2));
         drawRoundRect(1,1,w - 2,h - 2,0,fillColors,1,verticalGradientMatrix(0,0,w - 2,h - 2));
      }
   }
}

