package mx.skins.halo
{
   import mx.core.mx_internal;
   import mx.skins.Border;
   import mx.styles.StyleManager;
   import mx.utils.ColorUtil;
   
   use namespace mx_internal;
   
   public class ProgressBarSkin extends Border
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
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
         var barColor:uint = StyleManager.isValidStyleValue(barColorStyle) ? uint(barColorStyle) : uint(getStyle("themeColor"));
         var barColor0:Number = ColorUtil.adjustBrightness2(barColor,40);
         var fillColors:Array = [barColor0,barColor];
         graphics.clear();
         drawRoundRect(0,0,w,h,0,fillColors,0.5,verticalGradientMatrix(0,0,w - 2,h - 2));
         drawRoundRect(1,1,w - 2,h - 2,0,fillColors,1,verticalGradientMatrix(0,0,w - 2,h - 2));
      }
   }
}

