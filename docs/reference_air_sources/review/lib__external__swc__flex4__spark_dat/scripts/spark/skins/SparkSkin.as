package spark.skins
{
   import flash.display.DisplayObject;
   import flash.geom.ColorTransform;
   import spark.components.supportClasses.Skin;
   import spark.primitives.supportClasses.GraphicElement;
   
   public class SparkSkin extends Skin
   {
      
      private static var oldContentBackgroundAlpha:Number;
      
      private static var contentBackgroundAlphaSetLocally:Boolean;
      
      private static const DEFAULT_COLOR_VALUE:uint = 204;
      
      private static const DEFAULT_COLOR:uint = 13421772;
      
      private static const DEFAULT_SYMBOL_COLOR:uint = 0;
      
      private static var colorTransform:ColorTransform = new ColorTransform();
      
      protected var useChromeColor:Boolean = false;
      
      private var colorized:Boolean = false;
      
      public function SparkSkin()
      {
         super();
      }
      
      public function get colorizeExclusions() : Array
      {
         return null;
      }
      
      public function get symbolItems() : Array
      {
         return null;
      }
      
      public function get contentItems() : Array
      {
         return null;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var i:int = 0;
         var symbolColor:uint = 0;
         var contentBackgroundColor:uint = 0;
         var contentBackgroundAlpha:Number = NaN;
         var exclusions:Array = null;
         var exclusionObject:Object = null;
         var symbols:Array = this.symbolItems;
         if(Boolean(symbols) && symbols.length > 0)
         {
            symbolColor = uint(getStyle("symbolColor"));
            for(i = 0; i < symbols.length; i++)
            {
               if(Boolean(this[symbols[i]]))
               {
                  this[symbols[i]].color = symbolColor;
               }
            }
         }
         var content:Array = this.contentItems;
         if(Boolean(content) && content.length > 0)
         {
            contentBackgroundColor = uint(getStyle("contentBackgroundColor"));
            contentBackgroundAlpha = Number(getStyle("contentBackgroundAlpha"));
            for(i = 0; i < content.length; i++)
            {
               if(Boolean(this[content[i]]))
               {
                  this[content[i]].color = contentBackgroundColor;
                  this[content[i]].alpha = contentBackgroundAlpha;
               }
            }
         }
         var chromeColor:uint = uint(getStyle("chromeColor"));
         if((chromeColor != DEFAULT_COLOR || this.colorized) && this.useChromeColor)
         {
            colorTransform.redOffset = ((chromeColor & 255 << 16) >> 16) - DEFAULT_COLOR_VALUE;
            colorTransform.greenOffset = ((chromeColor & 255 << 8) >> 8) - DEFAULT_COLOR_VALUE;
            colorTransform.blueOffset = (chromeColor & 0xFF) - DEFAULT_COLOR_VALUE;
            colorTransform.alphaMultiplier = alpha;
            transform.colorTransform = colorTransform;
            exclusions = this.colorizeExclusions;
            if(Boolean(exclusions) && exclusions.length > 0)
            {
               colorTransform.redOffset = -colorTransform.redOffset;
               colorTransform.greenOffset = -colorTransform.greenOffset;
               colorTransform.blueOffset = -colorTransform.blueOffset;
               for(i = 0; i < exclusions.length; i++)
               {
                  exclusionObject = this[exclusions[i]];
                  if(Boolean(exclusionObject) && (exclusionObject is DisplayObject || exclusionObject is GraphicElement))
                  {
                     colorTransform.alphaMultiplier = exclusionObject.alpha;
                     exclusionObject.transform.colorTransform = colorTransform;
                  }
               }
            }
            this.colorized = true;
         }
         super.updateDisplayList(unscaledWidth,unscaledHeight);
      }
      
      override public function beginHighlightBitmapCapture() : Boolean
      {
         var needRedraw:Boolean = super.beginHighlightBitmapCapture();
         if(getStyle("contentBackgroundAlpha") < 0.5)
         {
            if(Boolean(styleDeclaration) && styleDeclaration.getStyle("contentBackgroundAlpha") !== null)
            {
               contentBackgroundAlphaSetLocally = true;
            }
            else
            {
               contentBackgroundAlphaSetLocally = false;
            }
            oldContentBackgroundAlpha = getStyle("contentBackgroundAlpha");
            setStyle("contentBackgroundAlpha",0.5);
            needRedraw = true;
         }
         return needRedraw;
      }
      
      override public function endHighlightBitmapCapture() : Boolean
      {
         var needRedraw:Boolean = super.endHighlightBitmapCapture();
         if(!isNaN(oldContentBackgroundAlpha))
         {
            if(contentBackgroundAlphaSetLocally)
            {
               setStyle("contentBackgroundAlpha",oldContentBackgroundAlpha);
            }
            else
            {
               clearStyle("contentBackgroundAlpha");
            }
            needRedraw = true;
            oldContentBackgroundAlpha = NaN;
         }
         return needRedraw;
      }
   }
}

