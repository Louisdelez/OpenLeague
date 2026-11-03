package mx.skins.halo
{
   import mx.skins.Border;
   import mx.utils.ColorUtil;
   
   public class ProgressTrackSkin extends Border
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function ProgressTrackSkin()
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
         var borderColor:uint = uint(getStyle("borderColor"));
         var fillColors:Array = getStyle("trackColors") as Array;
         styleManager.getColorNames(fillColors);
         var borderColorDrk1:Number = Number(ColorUtil.adjustBrightness2(borderColor,-30));
         graphics.clear();
         drawRoundRect(0,0,w,h,0,[borderColorDrk1,borderColor],1,verticalGradientMatrix(0,0,w,h));
         drawRoundRect(1,1,w - 2,h - 2,0,fillColors,1,verticalGradientMatrix(1,1,w - 2,h - 2));
      }
   }
}

