package mx.skins.halo
{
   import flash.display.GradientType;
   import mx.skins.Border;
   import mx.utils.ColorUtil;
   
   public class SliderTrackSkin extends Border
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function SliderTrackSkin()
      {
         super();
      }
      
      override public function get measuredWidth() : Number
      {
         return 200;
      }
      
      override public function get measuredHeight() : Number
      {
         return 4;
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         super.updateDisplayList(w,h);
         var borderColor:Number = Number(getStyle("borderColor"));
         var fillAlphas:Array = getStyle("fillAlphas");
         var fillColors:Array = getStyle("trackColors") as Array;
         styleManager.getColorNames(fillColors);
         var borderColorDrk:Number = Number(ColorUtil.adjustBrightness2(borderColor,-50));
         graphics.clear();
         drawRoundRect(0,0,w,h,0,0,0);
         drawRoundRect(1,0,w,h - 1,1.5,borderColorDrk,1,null,GradientType.LINEAR,null,{
            "x":2,
            "y":1,
            "w":w - 2,
            "h":1,
            "r":0
         });
         drawRoundRect(2,1,w - 2,h - 2,1,borderColor,1,null,GradientType.LINEAR,null,{
            "x":2,
            "y":1,
            "w":w - 2,
            "h":1,
            "r":0
         });
         drawRoundRect(2,1,w - 2,1,0,fillColors,Math.max(fillAlphas[1] - 0.3,0),horizontalGradientMatrix(2,1,w - 2,1));
      }
   }
}

