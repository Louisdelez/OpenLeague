package spark.components.supportClasses
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.text.engine.FontLookup;
   import flash.text.engine.TextLine;
   import flash.text.engine.TextLineValidity;
   import flashx.textLayout.compose.TextLineRecycler;
   import mx.core.IFlexModuleFactory;
   import mx.core.UIComponent;
   import mx.events.FlexEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import spark.core.IDisplayText;
   
   [AccessibilityClass(implementation="spark.accessibility.TextBaseAccImpl")]
   [Style(name="backgroundColor",type="uint",format="Color",inherit="no")]
   [Style(name="backgroundAlpha",type="Number",inherit="no",minValue="0.0",maxValue="1.0")]
   public class TextBase extends UIComponent implements IDisplayText
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var truncationIndicatorResource:String;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var bounds:Rectangle = new Rectangle(0,0,NaN,NaN);
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var textLines:Vector.<DisplayObject> = new Vector.<DisplayObject>();
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var isOverset:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var hasScrollRect:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var invalidateCompose:Boolean = true;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _composeWidth:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _composeHeight:Number;
      
      private var _widthConstraint:Number = NaN;
      
      private var _measuredOneTextLine:Boolean = false;
      
      private var _backgroundShape:Shape;
      
      private var visibleChanged:Boolean = false;
      
      private var _isTruncated:Boolean = false;
      
      private var _maxDisplayedLines:int = 0;
      
      private var _showTruncationTip:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _text:String = "";
      
      public function TextBase()
      {
         super();
         mouseChildren = false;
         var resourceManager:IResourceManager = ResourceManager.getInstance();
         if(!truncationIndicatorResource)
         {
            truncationIndicatorResource = resourceManager.getString("core","truncationIndicator");
         }
         addEventListener(FlexEvent.UPDATE_COMPLETE,this.updateCompleteHandler);
         resourceManager.addEventListener(Event.CHANGE,this.resourceManager_changeHandler,false,0,true);
         this._backgroundShape = new Shape();
         addChild(this._backgroundShape);
      }
      
      override protected function initializeAccessibility() : void
      {
         if(TextBase.createAccessibilityImplementation != null)
         {
            TextBase.createAccessibilityImplementation(this);
         }
      }
      
      [Inspectable(category="General")]
      override public function get baselinePosition() : Number
      {
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         if(this.textLines.length == 0)
         {
            this.createEmptyTextLine(this._composeHeight);
         }
         return this.textLines.length > 0 ? this.textLines[0].y : 0;
      }
      
      override public function set visible(value:Boolean) : void
      {
         super.visible = value;
         this.visibleChanged = true;
         invalidateDisplayList();
      }
      
      public function get isTruncated() : Boolean
      {
         return Boolean(this._isTruncated);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setIsTruncated(value:Boolean) : void
      {
         if(this._isTruncated != value)
         {
            this._isTruncated = value;
            if(this.showTruncationTip)
            {
               toolTip = this._isTruncated ? this.text : null;
            }
            dispatchEvent(new Event("isTruncatedChanged"));
         }
      }
      
      [Inspectable(category="General",minValue="-1",defaultValue="0")]
      public function get maxDisplayedLines() : int
      {
         return this._maxDisplayedLines;
      }
      
      public function set maxDisplayedLines(value:int) : void
      {
         if(value != this._maxDisplayedLines)
         {
            this._maxDisplayedLines = value;
            this.invalidateTextLines();
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      [Inspectable(category="General",defaultValue="false")]
      public function get showTruncationTip() : Boolean
      {
         return this._showTruncationTip;
      }
      
      public function set showTruncationTip(value:Boolean) : void
      {
         this._showTruncationTip = value;
         toolTip = this._isTruncated && this._showTruncationTip ? this.text : null;
      }
      
      [Inspectable(category="General",defaultValue="")]
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(value:String) : void
      {
         if(value != this._text)
         {
            this._text = value;
            this.invalidateTextLines();
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      override protected function measure() : void
      {
         var constrainedWidth:Number = !isNaN(this._widthConstraint) ? this._widthConstraint : Number(explicitWidth);
         var fontSize:Number = Number(getStyle("fontSize"));
         var allLinesComposed:Boolean = this.composeTextLines(Math.max(constrainedWidth,fontSize),Math.max(explicitHeight,fontSize));
         invalidateDisplayList();
         var newMeasuredHeight:Number = Math.ceil(this.bounds.bottom);
         if(!isNaN(this._widthConstraint) && measuredHeight == newMeasuredHeight)
         {
            return;
         }
         super.measure();
         measuredWidth = Math.ceil(this.bounds.right);
         measuredHeight = newMeasuredHeight;
         this._measuredOneTextLine = allLinesComposed && this.textLines.length == 1;
      }
      
      override public function setLayoutBoundsSize(width:Number, height:Number, postLayoutTransform:Boolean = true) : void
      {
         super.setLayoutBoundsSize(width,height,postLayoutTransform);
         if(this._widthConstraint == width)
         {
            return;
         }
         if(getStyle("lineBreak") == "explicit")
         {
            return;
         }
         if(canSkipMeasurement())
         {
            return;
         }
         if(!isNaN(explicitHeight))
         {
            return;
         }
         var constrainedWidth:Boolean = !isNaN(width) && width != measuredWidth && width != 0;
         if(!constrainedWidth)
         {
            return;
         }
         if(this._measuredOneTextLine && width > measuredWidth)
         {
            return;
         }
         if(postLayoutTransform && Boolean(hasComplexLayoutMatrix))
         {
            return;
         }
         this._widthConstraint = width;
         invalidateSize();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var compose:Boolean = false;
         var clipText:Boolean = false;
         var contentHeight:Number = Math.ceil(this.bounds.bottom);
         var contentWidth:Number = Math.ceil(this.bounds.right);
         if(this.invalidateCompose || this.composeForAlignStyles(unscaledWidth,unscaledHeight,contentWidth,contentHeight))
         {
            compose = true;
         }
         else if(unscaledHeight != contentHeight)
         {
            if(this.composeOnHeightChange(unscaledHeight,contentHeight))
            {
               compose = true;
            }
            else if(unscaledHeight < contentHeight)
            {
               clipText = true;
            }
         }
         if(!compose && unscaledWidth != contentWidth)
         {
            if(this.composeOnWidthChange(unscaledWidth,contentWidth))
            {
               compose = true;
            }
            else if(getStyle("lineBreak") == "explicit" && unscaledWidth < contentWidth)
            {
               clipText = true;
            }
         }
         if(compose)
         {
            this.composeTextLines(unscaledWidth,unscaledHeight);
         }
         if(this.isOverset)
         {
            clipText = true;
         }
         this.clip(clipText,unscaledWidth,unscaledHeight);
         var backgroundColor:* = getStyle("backgroundColor");
         var backgroundAlpha:Number = Number(getStyle("backgroundAlpha"));
         if(backgroundColor === undefined)
         {
            backgroundColor = 0;
            backgroundAlpha = 0;
         }
         var g:Graphics = this._backgroundShape.graphics;
         g.clear();
         g.beginFill(uint(backgroundColor),backgroundAlpha);
         g.drawRect(0,0,unscaledWidth,unscaledHeight);
         g.endFill();
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         this.invalidateTextLines();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createEmptyTextLine(height:Number = NaN) : void
      {
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function invalidateTextLines() : void
      {
         this.invalidateCompose = true;
      }
      
      private function composeForAlignStyles(unscaledWidth:Number, unscaledHeight:Number, contentWidth:Number, contentHeight:Number) : Boolean
      {
         var direction:String = null;
         var textAlign:String = null;
         var leftAligned:Boolean = false;
         var verticalAlign:String = null;
         var topAligned:Boolean = false;
         var width:Number = isNaN(this._composeWidth) ? contentWidth : this._composeWidth;
         if(unscaledWidth != width)
         {
            direction = getStyle("direction");
            textAlign = getStyle("textAlign");
            leftAligned = textAlign == "left" || textAlign == "start" && direction == "ltr" || textAlign == "end" && direction == "rtl";
            if(!leftAligned)
            {
               return true;
            }
         }
         var height:Number = isNaN(this._composeHeight) ? contentHeight : this._composeHeight;
         if(unscaledHeight != height)
         {
            verticalAlign = getStyle("verticalAlign");
            topAligned = verticalAlign == "top";
            if(!topAligned)
            {
               return true;
            }
         }
         return false;
      }
      
      private function composeOnHeightChange(unscaledHeight:Number, contentHeight:Number) : Boolean
      {
         if(unscaledHeight > contentHeight && (this.isOverset || !isNaN(this._composeHeight)))
         {
            return true;
         }
         if(this.maxDisplayedLines != 0 && getStyle("lineBreak") == "toFit")
         {
            if(this.maxDisplayedLines == -1)
            {
               return true;
            }
            if(this.maxDisplayedLines > 0 && (unscaledHeight < contentHeight || this.textLines.length != this.maxDisplayedLines))
            {
               return true;
            }
         }
         if(getStyle("blockProgression") != "tb")
         {
            return true;
         }
         return false;
      }
      
      private function composeOnWidthChange(unscaledWidth:Number, contentWidth:Number) : Boolean
      {
         if(getStyle("lineBreak") == "toFit")
         {
            if(isNaN(this._composeWidth) || this._composeWidth != unscaledWidth)
            {
               return true;
            }
         }
         if(getStyle("blockProgression") != "tb")
         {
            return true;
         }
         return false;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function composeTextLines(width:Number = NaN, height:Number = NaN) : Boolean
      {
         this._composeWidth = width;
         this._composeHeight = height;
         this.setIsTruncated(false);
         return false;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addTextLines() : void
      {
         var textLine:DisplayObject = null;
         var n:int = int(this.textLines.length);
         if(n == 0)
         {
            return;
         }
         for(var i:int = n - 1; i >= 0; i--)
         {
            textLine = this.textLines[i];
            $addChildAt(textLine,1);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeTextLines() : void
      {
         var textLine:DisplayObject = null;
         var parent:UIComponent = null;
         var n:int = int(this.textLines.length);
         if(n == 0)
         {
            return;
         }
         for(var i:int = 0; i < n; i++)
         {
            textLine = this.textLines[i];
            parent = textLine.parent as UIComponent;
            if(Boolean(parent))
            {
               UIComponent(textLine.parent).$removeChild(textLine);
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function releaseTextLines(textLinesVector:Vector.<DisplayObject> = null) : void
      {
         var textLine:TextLine = null;
         if(!textLinesVector)
         {
            textLinesVector = this.textLines;
         }
         var n:int = int(textLinesVector.length);
         for(var i:int = 0; i < n; i++)
         {
            textLine = textLinesVector[i] as TextLine;
            if(Boolean(textLine))
            {
               if(textLine.validity != TextLineValidity.INVALID && textLine.validity != TextLineValidity.STATIC)
               {
                  textLine.validity = TextLineValidity.INVALID;
               }
               textLine.userData = null;
               TextLineRecycler.addLineForReuse(textLine);
            }
         }
         textLinesVector.length = 0;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function isTextOverset(composeWidth:Number, composeHeight:Number) : Boolean
      {
         var compositionRect:Rectangle = new Rectangle(0,0,composeWidth,composeHeight);
         compositionRect.inflate(0.25,0.25);
         var contentRect:Rectangle = this.bounds;
         return contentRect.top < compositionRect.top || contentRect.left < compositionRect.left || !isNaN(compositionRect.bottom) && contentRect.bottom > compositionRect.bottom || !isNaN(compositionRect.right) && contentRect.right > compositionRect.right;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function clip(clipText:Boolean, w:Number, h:Number) : void
      {
         var r:Rectangle = null;
         if(clipText)
         {
            r = scrollRect;
            if(Boolean(r))
            {
               r.x = 0;
               r.y = 0;
               r.width = w;
               r.height = h;
            }
            else
            {
               r = new Rectangle(0,0,w,h);
            }
            scrollRect = r;
            this.hasScrollRect = true;
         }
         else if(this.hasScrollRect)
         {
            scrollRect = null;
            this.hasScrollRect = false;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getEmbeddedFontContext() : IFlexModuleFactory
      {
         var fontContext:IFlexModuleFactory = null;
         var font:String = null;
         var bold:Boolean = false;
         var italic:Boolean = false;
         var fontLookup:String = getStyle("fontLookup");
         if(fontLookup != FontLookup.DEVICE)
         {
            font = getStyle("fontFamily");
            bold = getStyle("fontWeight") == "bold";
            italic = getStyle("fontStyle") == "italic";
            fontContext = getFontContext(font,bold,italic,true);
         }
         return fontContext;
      }
      
      private function resourceManager_changeHandler(event:Event) : void
      {
         var resourceManager:IResourceManager = ResourceManager.getInstance();
         truncationIndicatorResource = resourceManager.getString("core","truncationIndicator");
         if(this.maxDisplayedLines != 0)
         {
            this.invalidateTextLines();
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      private function updateCompleteHandler(event:FlexEvent) : void
      {
         this._widthConstraint = NaN;
      }
   }
}

