package mx.skins.halo
{
   import mx.core.mx_internal;
   import mx.skins.Border;
   
   use namespace mx_internal;
   
   public class SwatchPanelSkin extends Border
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function SwatchPanelSkin()
      {
         super();
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         var backgroundColor:uint = 0;
         var borderColor:uint = 0;
         var highlightColor:uint = 0;
         var shadowColor:uint = 0;
         var x:Number = NaN;
         var y:Number = NaN;
         super.updateDisplayList(w,h);
         if(name == "swatchPanelBorder")
         {
            backgroundColor = getStyle("backgroundColor");
            borderColor = getStyle("borderColor");
            highlightColor = getStyle("highlightColor");
            shadowColor = getStyle("shadowColor");
            x = 0;
            y = 0;
            graphics.clear();
            drawRoundRect(x,y,w,h,0,borderColor,1);
            drawRoundRect(x + 1,y + 1,w - 1,h - 1,0,shadowColor,1);
            drawRoundRect(x + 1,y + 1,w - 2,h - 2,0,highlightColor,1);
            drawRoundRect(x + 2,y + 2,w - 4,h - 4,0,[backgroundColor,highlightColor],1,verticalGradientMatrix(x + 2,y + 2,w - 4,h - 4));
         }
      }
   }
}

