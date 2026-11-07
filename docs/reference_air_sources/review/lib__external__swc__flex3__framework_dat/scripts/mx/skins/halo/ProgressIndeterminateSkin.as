package mx.skins.halo
{
   import flash.display.Graphics;
   import mx.core.mx_internal;
   import mx.skins.Border;
   import mx.styles.StyleManager;
   import mx.utils.ColorUtil;
   
   use namespace mx_internal;
   
   public class ProgressIndeterminateSkin extends Border
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
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
         var barColor:uint = StyleManager.isValidStyleValue(barColorStyle) ? uint(barColorStyle) : uint(getStyle("themeColor"));
         var barColor0:Number = ColorUtil.adjustBrightness2(barColor,60);
         var hatchInterval:Number = getStyle("indeterminateMoveInterval");
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

