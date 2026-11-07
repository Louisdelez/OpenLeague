package mx.skins.halo
{
   import flash.display.Graphics;
   import mx.collections.IList;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class SwatchSkin extends UIComponent
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      mx_internal var color:uint = 0;
      
      mx_internal var colorField:String = "color";
      
      public function SwatchSkin()
      {
         super();
      }
      
      private function drawSwatch(x:Number, y:Number, w:Number, h:Number, c:Number) : void
      {
         var swatchBorderColor:uint = getStyle("swatchBorderColor");
         var swatchBorderSize:Number = getStyle("swatchBorderSize");
         if(swatchBorderSize == 0)
         {
            drawFill(x,y,w,h,c,1);
         }
         else if(swatchBorderSize < 0 || isNaN(swatchBorderSize))
         {
            drawFill(x,y,w,h,swatchBorderColor,1);
            drawFill(x + 1,y + 1,w - 2,h - 2,c,1);
         }
         else
         {
            drawFill(x,y,w,h,swatchBorderColor,1);
            drawFill(x + swatchBorderSize,y + swatchBorderSize,w - 2 * swatchBorderSize,h - 2 * swatchBorderSize,c,1);
         }
      }
      
      mx_internal function updateGrid(dp:IList) : void
      {
         if(name == "swatchGrid")
         {
            graphics.clear();
            drawGrid(dp,colorField);
         }
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
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         super.updateDisplayList(w,h);
         updateSkin(color);
      }
      
      private function drawBorder(x:Number, y:Number, w:Number, h:Number, c1:Number, c2:Number, s:Number, a:Number) : void
      {
         drawFill(x,y,s,h,c1,a);
         drawFill(x,y,w,s,c1,a);
         drawFill(x + (w - s),y,s,h,c2,a);
         drawFill(x,y + (h - s),w,s,c2,a);
      }
      
      private function drawGrid(dp:IList, cf:String) : void
      {
         var swatchX:Number = NaN;
         var swatchY:Number = NaN;
         var c:Number = NaN;
         var columnCount:int = getStyle("columnCount");
         var horizontalGap:Number = getStyle("horizontalGap");
         var previewWidth:Number = getStyle("previewWidth");
         var swatchGridBackgroundColor:uint = getStyle("swatchGridBackgroundColor");
         var swatchGridBorderSize:Number = getStyle("swatchGridBorderSize");
         var swatchHeight:Number = getStyle("swatchHeight");
         var swatchWidth:Number = getStyle("swatchWidth");
         var textFieldWidth:Number = getStyle("textFieldWidth");
         var verticalGap:Number = getStyle("verticalGap");
         var cellOffset:int = 1;
         var itemOffset:int = 3;
         var length:int = dp.length;
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
         drawFill(0,0,totalWidth,totalHeight,swatchGridBackgroundColor,100);
         setActualSize(totalWidth,totalHeight);
         var cNum:int = 0;
         var rNum:int = 0;
         for(var n:int = 0; n < length; n++)
         {
            swatchX = swatchGridBorderSize + cNum * (swatchWidth + horizontalGap - cellOffset);
            swatchY = swatchGridBorderSize + rNum * (swatchHeight + verticalGap - cellOffset);
            c = typeof dp.getItemAt(n) != "object" ? Number(dp.getItemAt(n)) : Number(dp.getItemAt(n)[colorField]);
            drawSwatch(swatchX,swatchY,swatchWidth,swatchHeight,c);
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
      
      mx_internal function updateSkin(c:Number) : void
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
               w = UIComponent(parent).width / Math.abs(UIComponent(parent).scaleX);
               h = UIComponent(parent).height / Math.abs(UIComponent(parent).scaleY);
               g.clear();
               drawSwatch(0,0,w,h,c);
               break;
            case "swatchPreview":
               previewWidth = getStyle("previewWidth");
               previewHeight = getStyle("previewHeight");
               g.clear();
               drawSwatch(0,0,previewWidth,previewHeight,c);
               drawBorder(0,0,previewWidth,previewHeight,10066329,16777215,1,1);
               break;
            case "swatchHighlight":
               swatchWidth = getStyle("swatchWidth");
               swatchHeight = getStyle("swatchHeight");
               swatchHighlightColor = getStyle("swatchHighlightColor");
               swatchHighlightSize = getStyle("swatchHighlightSize");
               g.clear();
               drawBorder(0,0,swatchWidth,swatchHeight,swatchHighlightColor,swatchHighlightColor,swatchHighlightSize,1);
         }
      }
   }
}

