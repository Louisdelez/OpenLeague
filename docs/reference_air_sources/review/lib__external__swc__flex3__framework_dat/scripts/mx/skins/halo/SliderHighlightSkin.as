package mx.skins.halo
{
   import mx.core.mx_internal;
   import mx.skins.Border;
   
   use namespace mx_internal;
   
   public class SliderHighlightSkin extends Border
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
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
         var themeColor:int = getStyle("themeColor");
         graphics.clear();
         drawRoundRect(0,0,w,1,0,themeColor,0.7);
         drawRoundRect(0,h - 1,w,1,0,themeColor,1);
         drawRoundRect(0,h - 2,w,1,0,themeColor,0.4);
      }
   }
}

