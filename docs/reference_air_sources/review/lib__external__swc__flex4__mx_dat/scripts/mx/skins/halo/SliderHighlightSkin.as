package mx.skins.halo
{
   import mx.skins.Border;
   
   public class SliderHighlightSkin extends Border
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function SliderHighlightSkin()
      {
         super();
      }
      
      override public function get measuredWidth() : Number
      {
         return 1;
      }
      
      override public function get measuredHeight() : Number
      {
         return 2;
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         super.updateDisplayList(w,h);
         var themeColor:int = int(getStyle("themeColor"));
         graphics.clear();
         drawRoundRect(0,0,w,1,0,themeColor,0.7);
         drawRoundRect(0,h - 1,w,1,0,themeColor,1);
         drawRoundRect(0,h - 2,w,1,0,themeColor,0.4);
      }
   }
}

