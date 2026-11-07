package mx.skins.halo
{
   import flash.display.Graphics;
   import mx.collections.IList;
   import mx.core.FlexVersion;
   import mx.core.UIComponent;
   
   public class SwatchSkin extends UIComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var color:uint = 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var colorField:String = "color";
      
      public function SwatchSkin()
      {
         super();
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         super.updateDisplayList(w,h);
         this.updateSkin(this.color);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function updateGrid(dp:IList) : void
      {
         if(name == "swatchGrid")
         {
            graphics.clear();
            this.drawGrid(dp,this.colorField);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function updateSkin(c:Number) : void
      {
         var w:Number = NaN;
         var h:Number = NaN;
         var previewWidth:Number = NaN;
         var previewHeight:Number = NaN;
         var swatchWidth:Number = NaN;
         var swatchHeight:Number = NaN;
         var swatchHighlightColor:uint = 0;
         var swatchHighlightSize:Number = NaN;
         var g:Graphics = graphics;
         switch(name)
         {
            case "colorPickerSwatch":
               w = Number(UIComponent(parent).width);
               h = Number(UIComponent(parent).height);
               if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
               {
                  w /= Math.abs(UIComponent(parent).scaleX);
                  h /= Math.abs(UIComponent(parent).scaleY);
               }
               g.clear();
               this.drawSwatch(0,0,w,h,c);
               break;
            case "swatchPreview":
               previewWidth = Number(getStyle("previewWidth"));
               previewHeight = Number(getStyle("previewHeight"));
               g.clear();
               this.drawSwatch(0,0,previewWidth,previewHeight,c);
               this.drawBorder(0,0,previewWidth,previewHeight,10066329,16777215,1,1);
               break;
            case "swatchHighlight":
               swatchWidth = Number(getStyle("swatchWidth"));
               swatchHeight = Number(getStyle("swatchHeight"));
               swatchHighlightColor = uint(getStyle("swatchHighlightColor"));
               swatchHighlightSize = Number(getStyle("swatchHighlightSize"));
               g.clear();
               this.drawBorder(0,0,swatchWidth,swatchHeight,swatchHighlightColor,swatchHighlightColor,swatchHighlightSize,1);
         }
      }
      
      private function drawGrid(dp:IList, cf:String) : void
      {
         var swatchX:Number = NaN;
         var swatchY:Number = NaN;
         var c:Number = NaN;
         var columnCount:int = int(getStyle("columnCount"));
         var horizontalGap:Number = Number(getStyle("horizontalGap"));
         var previewWidth:Number = Number(getStyle("previewWidth"));
         var swatchGridBackgroundColor:uint = uint(getStyle("swatchGridBackgroundColor"));
         var swatchGridBorderSize:Number = Number(getStyle("swatchGridBorderSize"));
         var swatchHeight:Number = Number(getStyle("swatchHeight"));
         var swatchWidth:Number = Number(getStyle("swatchWidth"));
         var textFieldWidth:Number = Number(getStyle("textFieldWidth"));
         var verticalGap:Number = Number(getStyle("verticalGap"));
         var cellOffset:int = 1;
         var itemOffset:int = 3;
         var length:int = int(dp.length);
         if(columnCount > length)
         {
            columnCount = length;
         }
         var rows:Number = Math.ceil(length / columnCount);
         if(isNaN(rows))
         {
            rows = 0;
         }
         var totalWidth:Number = columnCount * (swatchWidth - cellOffset) + cellOffset + (columnCount - 1) * horizontalGap + 2 * swatchGridBorderSize;
         var totalHeight:Number = rows * (swatchHeight - cellOffset) + cellOffset + (rows - 1) * verticalGap + 2 * swatchGridBorderSize;
         var previewArea:Number = previewWidth + textFieldWidth + itemOffset;
         if(totalWidth < previewArea)
         {
            totalWidth = previewArea;
         }
         this.drawFill(0,0,totalWidth,totalHeight,swatchGridBackgroundColor,100);
         setActualSize(totalWidth,totalHeight);
         var cNum:int = 0;
         var rNum:int = 0;
         for(var n:int = 0; n < length; n++)
         {
            swatchX = swatchGridBorderSize + cNum * (swatchWidth + horizontalGap - cellOffset);
            swatchY = swatchGridBorderSize + rNum * (swatchHeight + verticalGap - cellOffset);
            c = typeof dp.getItemAt(n) != "object" ? Number(dp.getItemAt(n)) : Number(dp.getItemAt(n)[this.colorField]);
            this.drawSwatch(swatchX,swatchY,swatchWidth,swatchHeight,c);
            if(cNum < columnCount - 1)
            {
               cNum++;
            }
            else
            {
               cNum = 0;
               rNum++;
            }
         }
      }
      
      private function drawSwatch(x:Number, y:Number, w:Number, h:Number, c:Number) : void
      {
         var swatchBorderColor:uint = uint(getStyle("swatchBorderColor"));
         var swatchBorderSize:Number = Number(getStyle("swatchBorderSize"));
         if(swatchBorderSize == 0)
         {
            this.drawFill(x,y,w,h,c,1);
         }
         else if(swatchBorderSize < 0 || isNaN(swatchBorderSize))
         {
            this.drawFill(x,y,w,h,swatchBorderColor,1);
            this.drawFill(x + 1,y + 1,w - 2,h - 2,c,1);
         }
         else
         {
            this.drawFill(x,y,w,h,swatchBorderColor,1);
            this.drawFill(x + swatchBorderSize,y + swatchBorderSize,w - 2 * swatchBorderSize,h - 2 * swatchBorderSize,c,1);
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
   }
}

