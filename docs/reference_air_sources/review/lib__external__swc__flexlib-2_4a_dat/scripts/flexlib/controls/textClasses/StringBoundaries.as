package flexlib.controls.textClasses
{
   import flash.geom.Rectangle;
   import flash.text.TextField;
   
   public class StringBoundaries
   {
      
      public const Y_CORRECTION:Number = 2;
      
      private var textField:TextField;
      
      private var startIndex:int;
      
      public const X_CORRECTION:Number = 1;
      
      private var xOffset:Number;
      
      private var endLine:int;
      
      private var startLine:int;
      
      private var endIndex:int;
      
      private var yOffset:Number;
      
      public function StringBoundaries(textField:TextField, startIndex:int, endIndex:int, xOffset:Number = 0, yOffset:Number = 0)
      {
         super();
         this.textField = textField;
         this.startLine = textField.getLineIndexOfChar(startIndex);
         this.endLine = textField.getLineIndexOfChar(endIndex);
         this.startIndex = startIndex;
         this.endIndex = endIndex;
         this.xOffset = xOffset;
         this.yOffset = yOffset;
      }
      
      private function getAdjustedCharBoundaries(index:int, applyScrollVOffset:Boolean) : Rectangle
      {
         var rect:Rectangle = null;
         var scrollVOffset:Number = NaN;
         rect = this.textField.getCharBoundaries(index);
         if(rect == null)
         {
            rect = new Rectangle(0,0,0,0);
         }
         else
         {
            scrollVOffset = 0;
            if(applyScrollVOffset)
            {
               scrollVOffset = this.adjustedCharY;
            }
            rect.x += this.X_CORRECTION + this.xOffset;
            rect.y += this.Y_CORRECTION + this.yOffset - scrollVOffset;
         }
         return rect;
      }
      
      private function getLineRects(startIndex:int, endIndex:int) : Array
      {
         var r:Array = null;
         var startLn:int = 0;
         var endLn:int = 0;
         var numLines:int = 0;
         var startLineEndOffset:int = 0;
         var i:int = 0;
         var endLineOffset:int = 0;
         var line:int = 0;
         var ind1:int = 0;
         var ind2:int = 0;
         r = new Array();
         startLn = this.textField.getLineIndexOfChar(startIndex);
         endLn = this.textField.getLineIndexOfChar(endIndex);
         numLines = endLn - startLn;
         startLineEndOffset = this.getLineEndOffset(startLn);
         r.push(this.stringRect(startIndex,startLineEndOffset));
         for(i = 1; i < numLines; i++)
         {
            line = startLn + i;
            ind1 = textField.getLineOffset(line);
            ind2 = this.getLineEndOffset(line);
            r.push(this.stringRect(ind1,ind2));
         }
         endLineOffset = textField.getLineOffset(endLn);
         r.push(this.stringRect(endLineOffset,endIndex));
         return r;
      }
      
      private function getLineEndOffset(lineIndex:int) : int
      {
         return textField.getLineOffset(lineIndex) + textField.getLineLength(lineIndex);
      }
      
      private function stringRect(startIndex:int, endIndex:int) : Rectangle
      {
         var thisLine:int = 0;
         var lineHeight:Number = NaN;
         var rect1:Rectangle = null;
         var rect2:Rectangle = null;
         var r:Rectangle = null;
         var rect:Rectangle = null;
         if(startIndex == endIndex)
         {
            return this.getAdjustedCharBoundaries(startIndex,true);
         }
         thisLine = this.textField.getLineIndexOfChar(startIndex);
         lineHeight = this.textField.getLineMetrics(thisLine).height;
         rect1 = this.getAdjustedCharBoundaries(startIndex,true);
         rect2 = this.getAdjustedCharBoundaries(endIndex,false);
         return new Rectangle(rect1.x,rect1.y,rect2.right - rect1.x,lineHeight);
      }
      
      private function get isMultiline() : Boolean
      {
         if(this.endLine > this.startLine)
         {
            return true;
         }
         return false;
      }
      
      public function get rectangles() : Array
      {
         var rects:Array = null;
         var firstVisibleIndex:int = 0;
         var lastVisibleIndex:int = 0;
         firstVisibleIndex = this.textField.getLineOffset(this.textField.scrollV - 1);
         lastVisibleIndex = this.getLineEndOffset(this.textField.bottomScrollV - 1);
         firstVisibleIndex = Math.max(firstVisibleIndex,this.startIndex);
         lastVisibleIndex = Math.min(lastVisibleIndex,this.endIndex);
         if(this.isMultiline)
         {
            rects = this.getLineRects(firstVisibleIndex,lastVisibleIndex);
         }
         else
         {
            rects = [this.stringRect(firstVisibleIndex,lastVisibleIndex)];
         }
         return rects;
      }
      
      public function get isVisible() : Boolean
      {
         var firstVisibleChar:int = 0;
         var lastVisibleChar:int = 0;
         firstVisibleChar = this.textField.getLineOffset(this.textField.scrollV - 1);
         lastVisibleChar = this.getLineEndOffset(this.textField.bottomScrollV - 1);
         if(this.endIndex >= firstVisibleChar && this.startIndex <= lastVisibleChar)
         {
            return true;
         }
         return false;
      }
      
      private function get adjustedCharY() : int
      {
         var lineIndex:int = 0;
         var ind:int = 0;
         var rect:Rectangle = null;
         var lineHeights:Number = NaN;
         lineIndex = this.textField.scrollV - 1;
         ind = this.textField.getLineOffset(lineIndex);
         rect = this.textField.getCharBoundaries(ind);
         lineHeights = 0;
         while(rect == null)
         {
            lineHeights += this.textField.getLineMetrics(lineIndex).height;
            lineIndex++;
            if(lineIndex == this.textField.maxScrollV + this.textField.bottomScrollV - 1)
            {
               rect = new Rectangle(0,0,0,0);
               break;
            }
            rect = this.textField.getCharBoundaries(this.textField.getLineOffset(lineIndex));
         }
         rect.y -= lineHeights;
         return rect.y;
      }
   }
}

