package mx.skins.halo
{
   import flash.display.GradientType;
   import mx.skins.Border;
   import mx.utils.ColorUtil;
   
   public class ScrollTrackSkin extends Border
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function ScrollTrackSkin()
      {
         super();
      }
      
      override public function get measuredWidth() : Number
      {
         return 16;
      }
      
      override public function get measuredHeight() : Number
      {
         return 1;
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         super.updateDisplayList(w,h);
         var fillColors:Array = getStyle("trackColors");
         styleManager.getColorNames(fillColors);
         var borderColor:uint = uint(ColorUtil.adjustBrightness2(getStyle("borderColor"),-20));
         var borderColorDrk1:uint = uint(ColorUtil.adjustBrightness2(borderColor,-30));
         graphics.clear();
         var fillAlpha:Number = 1;
         if(name == "trackDisabledSkin")
         {
            fillAlpha = 0.2;
         }
         drawRoundRect(0,0,w,h,0,[borderColor,borderColorDrk1],fillAlpha,verticalGradientMatrix(0,0,w,h),GradientType.LINEAR,null,{
            "x":1,
            "y":1,
            "w":w - 2,
            "h":h - 2,
            "r":0
         });
         drawRoundRect(1,1,w - 2,h - 2,0,fillColors,fillAlpha,horizontalGradientMatrix(1,1,w / 3 * 2,h - 2));
      }
   }
}

