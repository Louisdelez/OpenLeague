package mx.skins.halo
{
   import flash.display.Graphics;
   import mx.core.mx_internal;
   import mx.skins.Border;
   
   use namespace mx_internal;
   
   public class ColorPickerSkin extends Border
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var borderHighlightColor:uint = 16711422;
      
      private var borderSize:Number = 1;
      
      private var arrowHeight:Number = 5;
      
      private var backgroundColor:uint = 15066855;
      
      private var borderShadowColor:uint = 10132381;
      
      private var bevelSize:Number = 1;
      
      private var arrowWidth:Number = 7;
      
      public function ColorPickerSkin()
      {
         super();
      }
      
      private function drawFill(x:Number, y:Number, w:Number, h:Number, c:Number, a:Number) : void
      {
         var g:Graphics = graphics;
         g.moveTo(x,y);
         g.beginFill(c,a);
         g.lineTo(x + w,y);
         g.lineTo(x + w,h + y);
         g.lineTo(x,h + y);
         g.lineTo(x,y);
         g.endFill();
      }
      
      private function drawArrow(x:Number, y:Number, w:Number, h:Number, c:Number, a:Number) : void
      {
         var g:Graphics = graphics;
         g.moveTo(x,y);
         g.beginFill(c,a);
         g.lineTo(x + w,y);
         g.lineTo(x + w / 2,h + y);
         g.lineTo(x,y);
         g.endFill();
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         super.updateDisplayList(w,h);
         var arrowColor:uint = getStyle("iconColor");
         var arrowX:Number = w - arrowWidth - bevelSize;
         var arrowY:Number = h - arrowHeight - bevelSize;
         graphics.clear();
         if(name == "upSkin" || name == "overSkin")
         {
            drawFill(x,y,w + bevelSize,h + bevelSize,13421772,0);
            drawBorder(x,y,w,h,borderHighlightColor,borderShadowColor,bevelSize,1);
            drawBorder(x + bevelSize,y + bevelSize,w - bevelSize * 2,h - bevelSize * 2,backgroundColor,backgroundColor,borderSize,1);
            drawBorder(x + bevelSize + borderSize,y + bevelSize + borderSize,w - (bevelSize + borderSize) * 2,h - (bevelSize + borderSize) * 2,borderShadowColor,borderHighlightColor,bevelSize,1);
            drawFill(arrowX,arrowY,arrowWidth,arrowHeight,backgroundColor,1);
            drawArrow(arrowX + 1.5,arrowY + 1.5,arrowWidth - 3,arrowHeight - 3,arrowColor,1);
         }
         else if(name == "downSkin")
         {
            drawFill(x,y,w,h,13421772,0);
            drawBorder(x,y,w,h,borderHighlightColor,13421772,bevelSize,1);
            drawBorder(x + bevelSize,y + bevelSize,w - 2 * bevelSize,h - 2 * bevelSize,backgroundColor,backgroundColor,borderSize,1);
            drawBorder(x + bevelSize + borderSize,y + bevelSize + borderSize,w - 2 * (bevelSize + borderSize),h - 2 * (bevelSize + borderSize),borderShadowColor,borderHighlightColor,bevelSize,1);
            drawFill(arrowX,arrowY,arrowWidth,arrowHeight,backgroundColor,1);
            drawArrow(arrowX + 1.5,arrowY + 1.5,arrowWidth - 3,arrowHeight - 3,arrowColor,1);
         }
         else if(name == "disabledSkin")
         {
            arrowColor = getStyle("disabledIconColor");
            drawRoundRect(x,y,w,h,0,16777215,0.6);
            drawFill(x,y,w,h,16777215,0.25);
            drawBorder(x,y,w,h,borderHighlightColor,13421772,bevelSize,1);
            drawBorder(x + bevelSize,y + bevelSize,w - bevelSize * 2,h - bevelSize * 2,backgroundColor,backgroundColor,borderSize,1);
            drawBorder(x + bevelSize + borderSize,y + bevelSize + borderSize,w - 2 * (bevelSize + borderSize),h - 2 * (bevelSize + borderSize),borderShadowColor,borderHighlightColor,bevelSize,1);
            drawFill(arrowX,arrowY,arrowWidth,arrowHeight,backgroundColor,1);
            drawArrow(arrowX + 1.5,arrowY + 1.5,arrowWidth - 3,arrowHeight - 3,arrowColor,1);
         }
      }
      
      private function drawBorder(x:Number, y:Number, w:Number, h:Number, c1:Number, c2:Number, s:Number, a:Number) : void
      {
         drawFill(x,y,s,h,c1,a);
         drawFill(x,y,w,s,c1,a);
         drawFill(x + (w - s),y,s,h,c2,a);
         drawFill(x,y + (h - s),w,s,c2,a);
      }
   }
}

