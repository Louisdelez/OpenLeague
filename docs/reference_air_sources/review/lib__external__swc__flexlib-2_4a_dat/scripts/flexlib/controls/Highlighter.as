package flexlib.controls
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flexlib.controls.textClasses.Finder;
   import flexlib.controls.textClasses.StringBoundaries;
   
   public class Highlighter
   {
      
      public var field:TextField;
      
      private var boundariesToHighlight:Array;
      
      private var canvas:BitmapData;
      
      private var finder:Finder;
      
      public var highlightColor:uint;
      
      public var xOffset:Number;
      
      public var yOffset:Number;
      
      public var bitmap:Bitmap;
      
      public function Highlighter(textField:TextField, color:uint = 4294901760, xOffset:Number = 0, yOffset:Number = 0)
      {
         var ind:int = 0;
         super();
         this.field = textField;
         this.highlightColor = color;
         this.xOffset = xOffset;
         this.yOffset = yOffset;
         this.boundariesToHighlight = new Array();
         this.canvas = new BitmapData(2000,2000,true,0);
         this.bitmap = new Bitmap(canvas);
         ind = this.field.parent.getChildIndex(this.field);
         this.field.parent.addChildAt(this.bitmap,ind - 1);
         finder = new Finder(this.field);
         this.field.addEventListener(Event.SCROLL,onScroll,false,3,true);
         this.field.parent.addEventListener(Event.RESIZE,onScroll,true,2,true);
      }
      
      public function highlightWordInstances(word:String, caseSensitive:Boolean = true) : void
      {
         var txt:String = null;
         var instances:Array = null;
         var len:int = 0;
         var i:int = 0;
         var bounds:StringBoundaries = null;
         txt = this.field.text;
         instances = this.finder.indexesOf(word,caseSensitive);
         len = word.length - 1;
         for(i = 0; i < instances.length; i++)
         {
            bounds = new StringBoundaries(this.field,instances[i],instances[i] + len,this.xOffset,this.yOffset);
            this.boundariesToHighlight.push(bounds);
         }
         this.highlightVisibleBoundaries();
      }
      
      private function highlightVisibleBoundaries() : void
      {
         var len:int = 0;
         var i:int = 0;
         var str:StringBoundaries = null;
         var rects:Array = null;
         var len2:int = 0;
         var j:int = 0;
         var rect:Rectangle = null;
         len = int(this.boundariesToHighlight.length);
         for(i = 0; i < len; i++)
         {
            str = this.boundariesToHighlight[i];
            if(str.isVisible)
            {
               rects = str.rectangles;
               len2 = int(rects.length);
               for(j = 0; j < len2; j++)
               {
                  rect = rects[j];
                  this.canvas.fillRect(rect,this.highlightColor);
               }
            }
         }
      }
      
      public function highlightPrevious(word:String, caseSensitive:Boolean = true) : void
      {
         var i:int = 0;
         var line:int = 0;
         var len:int = 0;
         var bounds:StringBoundaries = null;
         this.reset();
         i = this.finder.findPrevious(word,caseSensitive);
         line = this.field.getLineIndexOfChar(i);
         this.field.scrollV = line;
         len = word.length - 1;
         bounds = new StringBoundaries(this.field,i,i + len,this.xOffset,this.yOffset);
         this.boundariesToHighlight.push(bounds);
         this.highlightVisibleBoundaries();
      }
      
      public function highlightNext(word:String, caseSensitive:Boolean = true) : void
      {
         var i:int = 0;
         var line:int = 0;
         var len:int = 0;
         var bounds:StringBoundaries = null;
         this.reset();
         i = this.finder.findNext(word,caseSensitive);
         line = this.field.getLineIndexOfChar(i);
         this.field.scrollV = line;
         len = word.length - 1;
         bounds = new StringBoundaries(this.field,i,i + len,this.xOffset,this.yOffset);
         this.boundariesToHighlight.push(bounds);
         this.highlightVisibleBoundaries();
      }
      
      public function reset() : void
      {
         this.clearAllHighlights();
         this.boundariesToHighlight = [];
      }
      
      private function onScroll(evt:Event) : void
      {
         this.clearAllHighlights();
         this.highlightVisibleBoundaries();
      }
      
      private function clearAllHighlights() : void
      {
         this.canvas.fillRect(new Rectangle(0,0,2000,2000),0);
      }
   }
}

