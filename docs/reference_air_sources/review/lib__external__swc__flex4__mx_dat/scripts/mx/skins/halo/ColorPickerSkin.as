package mx.skins.halo
{
   import flash.display.Graphics;
   import mx.skins.Border;
   
   public class ColorPickerSkin extends Border
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var borderShadowColor:uint = 10132381;
      
      private var borderHighlightColor:uint = 16711422;
      
      private var backgroundColor:uint = 15066855;
      
      private var borderSize:Number = 1;
      
      private var bevelSize:Number = 1;
      
      private var arrowWidth:Number = 7;
      
      private var arrowHeight:Number = 5;
      
      public function ColorPickerSkin()
      {
         super();
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         super.updateDisplayList(w,h);
         var arrowColor:uint = uint(getStyle("iconColor"));
         var arrowX:Number = w - this.arrowWidth - this.bevelSize;
         var arrowY:Number = h - this.arrowHeight - this.bevelSize;
         graphics.clear();
         if(name == "upSkin" || name == "overSkin")
         {
            this.drawFill(x,y,w + this.bevelSize,h + this.bevelSize,13421772,0);
            this.drawBorder(x,y,w,h,this.borderHighlightColor,this.borderShadowColor,this.bevelSize,1);
            this.drawBorder(x + this.bevelSize,y + this.bevelSize,w - this.bevelSize * 2,h - this.bevelSize * 2,this.backgroundColor,this.backgroundColor,this.borderSize,1);
            this.drawBorder(x + this.bevelSize + this.borderSize,y + this.bevelSize + this.borderSize,w - (this.bevelSize + this.borderSize) * 2,h - (this.bevelSize + this.borderSize) * 2,this.borderShadowColor,this.borderHighlightColor,this.bevelSize,1);
            this.drawFill(arrowX,arrowY,this.arrowWidth,this.arrowHeight,this.backgroundColor,1);
            this.drawArrow(arrowX + 1.5,arrowY + 1.5,this.arrowWidth - 3,this.arrowHeight - 3,arrowColor,1);
         }
         else if(name == "downSkin")
         {
            this.drawFill(x,y,w,h,13421772,0);
            this.drawBorder(x,y,w,h,this.borderHighlightColor,13421772,this.bevelSize,1);
            this.drawBorder(x + this.bevelSize,y + this.bevelSize,w - 2 * this.bevelSize,h - 2 * this.bevelSize,this.backgroundColor,this.backgroundColor,this.borderSize,1);
            this.drawBorder(x + this.bevelSize + this.borderSize,y + this.bevelSize + this.borderSize,w - 2 * (this.bevelSize + this.borderSize),h - 2 * (this.bevelSize + this.borderSize),this.borderShadowColor,this.borderHighlightColor,this.bevelSize,1);
            this.drawFill(arrowX,arrowY,this.arrowWidth,this.arrowHeight,this.backgroundColor,1);
            this.drawArrow(arrowX + 1.5,arrowY + 1.5,this.arrowWidth - 3,this.arrowHeight - 3,arrowColor,1);
         }
         else if(name == "disabledSkin")
         {
            arrowColor = uint(getStyle("disabledIconColor"));
            drawRoundRect(x,y,w,h,0,16777215,0.6);
            this.drawFill(x,y,w,h,16777215,0.25);
            this.drawBorder(x,y,w,h,this.borderHighlightColor,13421772,this.bevelSize,1);
            this.drawBorder(x + this.bevelSize,y + this.bevelSize,w - this.bevelSize * 2,h - this.bevelSize * 2,this.backgroundColor,this.backgroundColor,this.borderSize,1);
            this.drawBorder(x + this.bevelSize + this.borderSize,y + this.bevelSize + this.borderSize,w - 2 * (this.bevelSize + this.borderSize),h - 2 * (this.bevelSize + this.borderSize),this.borderShadowColor,this.borderHighlightColor,this.bevelSize,1);
            this.drawFill(arrowX,arrowY,this.arrowWidth,this.arrowHeight,this.backgroundColor,1);
            this.drawArrow(arrowX + 1.5,arrowY + 1.5,this.arrowWidth - 3,this.arrowHeight - 3,arrowColor,1);
         }
      }
      
      private function drawBorder(x:Number, y:Number, w:Number, h:Number, c1:Number, c2:Number, s:Number, a:Number) : void
      {
         this.drawFill(x,y,s,h,c1,a);
         this.drawFill(x,y,w,s,c1,a);
         this.drawFill(x + (w - s),y,s,h,c2,a);
         this.drawFill(x,y + (h - s),w,s,c2,a);
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
   }
}

