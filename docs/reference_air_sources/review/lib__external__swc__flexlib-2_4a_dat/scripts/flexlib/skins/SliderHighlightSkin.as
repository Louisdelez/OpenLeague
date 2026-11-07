package flexlib.skins
{
   import mx.skins.Border;
   
   public class SliderHighlightSkin extends Border
   {
      
      public function SliderHighlightSkin()
      {
         super();
      }
      
      override public function get measuredHeight() : Number
      {
         return 2;
      }
      
      override public function get measuredWidth() : Number
      {
         return 1;
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         var themeColor:int = 0;
         super.updateDisplayList(w,h);
         themeColor = int(getStyle("themeColor"));
         graphics.clear();
         drawRoundRect(0,h / 2,w,1,0,themeColor,0.7);
         drawRoundRect(0,h / 2 - 1,w,1,0,themeColor,1);
         drawRoundRect(0,h / 2 - 2,w,1,0,themeColor,0.4);
      }
   }
}

