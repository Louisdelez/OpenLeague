package spark.components
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.geom.Rectangle;
   import flash.text.engine.EastAsianJustifier;
   import flash.text.engine.ElementFormat;
   import flash.text.engine.FontDescription;
   import flash.text.engine.FontLookup;
   import flash.text.engine.FontMetrics;
   import flash.text.engine.Kerning;
   import flash.text.engine.LineJustification;
   import flash.text.engine.SpaceJustifier;
   import flash.text.engine.TextBaseline;
   import flash.text.engine.TextBlock;
   import flash.text.engine.TextElement;
   import flash.text.engine.TextLine;
   import flash.text.engine.TypographicCase;
   import flashx.textLayout.compose.ISWFContext;
   import flashx.textLayout.compose.TextLineRecycler;
   import flashx.textLayout.formats.BaselineShift;
   import flashx.textLayout.formats.TLFTypographicCase;
   import mx.core.IEmbeddedFontRegistry;
   import mx.core.IFlexModuleFactory;
   import mx.core.Singleton;
   import spark.components.supportClasses.TextBase;
   
   [IconFile("Label.png")]
   [DefaultProperty("text")]
   [Style(name="verticalAlign",type="String",enumeration="top,middle,bottom,justify",inherit="no")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no",minValue="0.0",maxValue="1000.0")]
   [Style(name="paddingRight",type="Number",format="Length",inherit="no",minValue="0.0",maxValue="1000.0")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no",minValue="0.0",maxValue="1000.0")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no",minValue="0.0",maxValue="1000.0")]
   [Style(name="lineBreak",type="String",enumeration="toFit,explicit",inherit="no")]
   [Style(name="typographicCase",type="String",enumeration="default,capsToSmallCaps,uppercase,lowercase,lowercaseToSmallCaps",inherit="yes")]
   [Style(name="trackingRight",type="Object",inherit="yes")]
   [Style(name="trackingLeft",type="Object",inherit="yes")]
   [Style(name="textJustify",type="String",enumeration="interWord,distribute",inherit="yes")]
   [Style(name="textDecoration",type="String",enumeration="none,underline",inherit="yes")]
   [Style(name="textAlpha",type="Number",inherit="yes",minValue="0.0",maxValue="1.0")]
   [Style(name="textAlignLast",type="String",enumeration="start,end,left,right,center,justify",inherit="yes")]
   [Style(name="textAlign",type="String",enumeration="start,end,left,right,center,justify",inherit="yes")]
   [Style(name="renderingMode",type="String",enumeration="cff,normal",inherit="yes")]
   [Style(name="locale",type="String",inherit="yes")]
   [Style(name="lineThrough",type="Boolean",inherit="yes")]
   [Style(name="lineHeight",type="Object",inherit="yes")]
   [Style(name="ligatureLevel",type="String",enumeration="common,minimum,uncommon,exotic",inherit="yes")]
   [Style(name="letterSpacing",type="Number",inherit="yes",theme="mobile")]
   [Style(name="leading",type="Number",format="Length",inherit="yes",theme="mobile")]
   [Style(name="kerning",type="String",enumeration="auto,on,off",inherit="yes")]
   [Style(name="justificationStyle",type="String",enumeration="auto,prioritizeLeastAdjustment,pushInKinsoku,pushOutOnly",inherit="yes")]
   [Style(name="justificationRule",type="String",enumeration="auto,space,eastAsian",inherit="yes")]
   [Style(name="fontWeight",type="String",enumeration="normal,bold",inherit="yes")]
   [Style(name="fontStyle",type="String",enumeration="normal,italic",inherit="yes")]
   [Style(name="fontSize",type="Number",format="Length",inherit="yes",minValue="1.0",maxValue="720.0")]
   [Style(name="fontLookup",type="String",enumeration="auto,device,embeddedCFF",inherit="yes")]
   [Style(name="fontFamily",type="String",inherit="yes")]
   [Style(name="dominantBaseline",type="String",enumeration="auto,roman,ascent,descent,ideographicTop,ideographicCenter,ideographicBottom",inherit="yes")]
   [Style(name="direction",type="String",enumeration="ltr,rtl",inherit="yes")]
   [Style(name="digitWidth",type="String",enumeration="default,proportional,tabular",inherit="yes")]
   [Style(name="digitCase",type="String",enumeration="default,lining,oldStyle",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Style(name="cffHinting",type="String",enumeration="horizontalStem,none",inherit="yes")]
   [Style(name="baselineShift",type="Object",inherit="yes")]
   [Style(name="alignmentBaseline",type="String",enumeration="useDominantBaseline,roman,ascent,descent,ideographicTop,ideographicCenter,ideographicBottom",inherit="yes")]
   public class Label extends TextBase
   {
      
      private static var staticTextBlock:TextBlock;
      
      private static var staticTextElement:TextElement;
      
      private static var staticSpaceJustifier:SpaceJustifier;
      
      private static var staticEastAsianJustifier:EastAsianJustifier;
      
      private static var recreateTextLine:Function;
      
      private static var _embeddedFontRegistry:IEmbeddedFontRegistry;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      initClass();
      
      private var embeddedFontContext:IFlexModuleFactory;
      
      private var elementFormat:ElementFormat;
      
      public function Label()
      {
         super();
      }
      
      private static function initClass() : void
      {
         staticTextBlock = new TextBlock();
         staticTextElement = new TextElement();
         staticSpaceJustifier = new SpaceJustifier();
         staticEastAsianJustifier = new EastAsianJustifier();
         if("recreateTextLine" in staticTextBlock)
         {
            recreateTextLine = staticTextBlock["recreateTextLine"];
         }
      }
      
      private static function get embeddedFontRegistry() : IEmbeddedFontRegistry
      {
         if(!_embeddedFontRegistry)
         {
            _embeddedFontRegistry = IEmbeddedFontRegistry(Singleton.getInstance("mx.core::IEmbeddedFontRegistry"));
         }
         return _embeddedFontRegistry;
      }
      
      private static function getNumberOrPercentOf(value:Object, n:Number) : Number
      {
         var len:int = 0;
         var percent:Number = NaN;
         if(value is Number)
         {
            return Number(value);
         }
         if(value is String)
         {
            len = String(value).length;
            if(len >= 1 && value.charAt(len - 1) == "%")
            {
               percent = Number(value.substring(0,len - 1));
               return percent / 100 * n;
            }
         }
         return NaN;
      }
      
      override public function stylesInitialized() : void
      {
         super.stylesInitialized();
         this.elementFormat = null;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         this.elementFormat = null;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function composeTextLines(width:Number = NaN, height:Number = NaN) : Boolean
      {
         super.composeTextLines(width,height);
         if(!this.elementFormat)
         {
            this.elementFormat = this.createElementFormat();
         }
         bounds.x = 0;
         bounds.y = 0;
         bounds.width = width;
         bounds.height = height;
         removeTextLines();
         releaseTextLines();
         var allLinesComposed:Boolean = this.createTextLines(this.elementFormat);
         var lb:String = getStyle("lineBreak");
         if(Boolean(text != null && text.length > 0) && Boolean(maxDisplayedLines) && !this.doesComposedTextFit(height,width,allLinesComposed,maxDisplayedLines,lb))
         {
            this.truncateText(width,height,lb);
         }
         this.releaseLinesFromTextBlock();
         addTextLines();
         isOverset = isTextOverset(width,height);
         invalidateCompose = false;
         return allLinesComposed;
      }
      
      private function createElementFormat() : ElementFormat
      {
         var s:String = null;
         var locale:String = null;
         var lowercaseLocale:String = null;
         this.embeddedFontContext = getEmbeddedFontContext();
         var fontDescription:FontDescription = new FontDescription();
         s = getStyle("cffHinting");
         if(s != null)
         {
            fontDescription.cffHinting = s;
         }
         s = getStyle("fontLookup");
         if(s != null)
         {
            if(s == "auto")
            {
               s = Boolean(this.embeddedFontContext) ? FontLookup.EMBEDDED_CFF : FontLookup.DEVICE;
            }
            else if(s == FontLookup.EMBEDDED_CFF && !this.embeddedFontContext)
            {
               s = FontLookup.DEVICE;
            }
            fontDescription.fontLookup = s;
         }
         s = getStyle("fontFamily");
         if(s != null)
         {
            fontDescription.fontName = s;
         }
         s = getStyle("fontStyle");
         if(s != null)
         {
            fontDescription.fontPosture = s;
         }
         s = getStyle("fontWeight");
         if(s != null)
         {
            fontDescription.fontWeight = s;
         }
         s = getStyle("renderingMode");
         if(s != null)
         {
            fontDescription.renderingMode = s;
         }
         var elementFormat:ElementFormat = new ElementFormat();
         elementFormat.fontSize = getStyle("fontSize");
         s = getStyle("alignmentBaseline");
         if(s != null)
         {
            elementFormat.alignmentBaseline = s;
         }
         elementFormat.alpha = getStyle("textAlpha");
         this.setBaselineShift(elementFormat);
         elementFormat.color = getStyle("color");
         s = getStyle("digitCase");
         if(s != null)
         {
            elementFormat.digitCase = s;
         }
         s = getStyle("digitWidth");
         if(s != null)
         {
            elementFormat.digitWidth = s;
         }
         s = getStyle("dominantBaseline");
         if(s != null)
         {
            if(s == "auto")
            {
               s = TextBaseline.ROMAN;
               locale = getStyle("locale");
               if(locale != null)
               {
                  lowercaseLocale = locale.toLowerCase();
                  if(lowercaseLocale.indexOf("ja") == 0 || lowercaseLocale.indexOf("zh") == 0)
                  {
                     s = TextBaseline.IDEOGRAPHIC_CENTER;
                  }
               }
            }
            elementFormat.dominantBaseline = s;
         }
         elementFormat.fontDescription = fontDescription;
         this.setKerning(elementFormat);
         s = getStyle("ligatureLevel");
         if(s != null)
         {
            elementFormat.ligatureLevel = s;
         }
         s = getStyle("locale");
         if(s != null)
         {
            elementFormat.locale = s;
         }
         this.setTracking(elementFormat);
         this.setTypographicCase(elementFormat);
         return elementFormat;
      }
      
      private function setBaselineShift(elementFormat:ElementFormat) : void
      {
         var fontMetrics:FontMetrics = null;
         var baselineShift:* = getStyle("baselineShift");
         var fontSize:Number = elementFormat.fontSize;
         if(baselineShift == BaselineShift.SUPERSCRIPT || baselineShift == BaselineShift.SUBSCRIPT)
         {
            if(Boolean(this.embeddedFontContext))
            {
               fontMetrics = this.embeddedFontContext.callInContext(elementFormat.getFontMetrics,elementFormat,null);
            }
            else
            {
               fontMetrics = elementFormat.getFontMetrics();
            }
            if(baselineShift == BaselineShift.SUPERSCRIPT)
            {
               elementFormat.baselineShift = fontMetrics.superscriptOffset * fontSize;
               elementFormat.fontSize = fontMetrics.superscriptScale * fontSize;
            }
            else
            {
               elementFormat.baselineShift = fontMetrics.subscriptOffset * fontSize;
               elementFormat.fontSize = fontMetrics.subscriptScale * fontSize;
            }
         }
         else
         {
            baselineShift = getNumberOrPercentOf(baselineShift,fontSize);
            if(!isNaN(baselineShift))
            {
               elementFormat.baselineShift = -baselineShift;
            }
         }
      }
      
      private function setKerning(elementFormat:ElementFormat) : void
      {
         var kerning:Object = getStyle("kerning");
         switch(kerning)
         {
            case "default":
               kerning = Kerning.AUTO;
               break;
            case true:
               kerning = Kerning.ON;
               break;
            case false:
               kerning = Kerning.OFF;
         }
         if(kerning != null)
         {
            elementFormat.kerning = String(kerning);
         }
      }
      
      private function setTracking(elementFormat:ElementFormat) : void
      {
         var value:Number = NaN;
         var trackingLeft:Object = getStyle("trackingLeft");
         var trackingRight:Object = getStyle("trackingRight");
         var fontSize:Number = elementFormat.fontSize;
         value = getNumberOrPercentOf(trackingLeft,fontSize);
         if(!isNaN(value))
         {
            elementFormat.trackingLeft = value;
         }
         value = getNumberOrPercentOf(trackingRight,fontSize);
         if(!isNaN(value))
         {
            elementFormat.trackingRight = value;
         }
      }
      
      private function setTypographicCase(elementFormat:ElementFormat) : void
      {
         var s:String = getStyle("typographicCase");
         if(s != null)
         {
            switch(s)
            {
               case TLFTypographicCase.LOWERCASE_TO_SMALL_CAPS:
                  elementFormat.typographicCase = TypographicCase.CAPS_AND_SMALL_CAPS;
                  break;
               case TLFTypographicCase.CAPS_TO_SMALL_CAPS:
                  elementFormat.typographicCase = TypographicCase.SMALL_CAPS;
                  break;
               default:
                  elementFormat.typographicCase = s;
            }
         }
      }
      
      private function createTextLines(elementFormat:ElementFormat) : Boolean
      {
         var lineJustification:String = null;
         var locale:String = null;
         var lowercaseLocale:String = null;
         var direction:String = getStyle("direction");
         var justificationRule:String = getStyle("justificationRule");
         var justificationStyle:String = getStyle("justificationStyle");
         var textAlign:String = getStyle("textAlign");
         var textAlignLast:String = getStyle("textAlignLast");
         var textJustify:String = getStyle("textJustify");
         if(justificationRule == "auto")
         {
            justificationRule = "space";
            locale = getStyle("locale");
            if(locale != null)
            {
               lowercaseLocale = locale.toLowerCase();
               if(lowercaseLocale.indexOf("ja") == 0 || lowercaseLocale.indexOf("zh") == 0)
               {
                  justificationRule = "eastAsian";
               }
            }
         }
         if(justificationStyle == "auto")
         {
            justificationStyle = "pushInKinsoku";
         }
         staticTextElement.text = text != null && text.length > 0 ? text : " ";
         staticTextElement.elementFormat = elementFormat;
         staticTextBlock.content = staticTextElement;
         staticTextBlock.bidiLevel = direction == "ltr" ? 0 : 1;
         if(textAlign == "justify")
         {
            lineJustification = textAlignLast == "justify" ? LineJustification.ALL_INCLUDING_LAST : LineJustification.ALL_BUT_LAST;
         }
         else
         {
            lineJustification = LineJustification.UNJUSTIFIED;
         }
         if(justificationRule == "space")
         {
            staticSpaceJustifier.lineJustification = lineJustification;
            staticSpaceJustifier.letterSpacing = textJustify == "distribute";
            staticTextBlock.textJustifier = staticSpaceJustifier;
         }
         else
         {
            staticEastAsianJustifier.lineJustification = lineJustification;
            staticEastAsianJustifier.justificationStyle = justificationStyle;
            staticTextBlock.textJustifier = staticEastAsianJustifier;
         }
         return this.createTextLinesFromTextBlock(staticTextBlock,textLines,bounds);
      }
      
      private function createTextLinesFromTextBlock(textBlock:TextBlock, textLines:Vector.<DisplayObject>, bounds:Rectangle) : Boolean
      {
         var actualLineHeight:Number = NaN;
         var nextTextLine:TextLine = null;
         var textLine:TextLine = null;
         var extraLine:Boolean = false;
         var previousTextLine:TextLine = null;
         var len:int = 0;
         var percent:Number = NaN;
         var recycleLine:TextLine = null;
         var elementFormat:ElementFormat = null;
         var fontMetrics:FontMetrics = null;
         var shape:Shape = null;
         var g:Graphics = null;
         releaseTextLines(textLines);
         var direction:String = getStyle("direction");
         var lineBreak:String = getStyle("lineBreak");
         var lineHeight:Object = getStyle("lineHeight");
         var lineThrough:Boolean = Boolean(getStyle("lineThrough"));
         var paddingBottom:Number = Number(getStyle("paddingBottom"));
         var paddingLeft:Number = Number(getStyle("paddingLeft"));
         var paddingRight:Number = Number(getStyle("paddingRight"));
         var paddingTop:Number = Number(getStyle("paddingTop"));
         var textAlign:String = getStyle("textAlign");
         var textAlignLast:String = getStyle("textAlignLast");
         var textDecoration:String = getStyle("textDecoration");
         var verticalAlign:String = getStyle("verticalAlign");
         var innerWidth:Number = bounds.width - paddingLeft - paddingRight;
         var innerHeight:Number = bounds.height - paddingTop - paddingBottom;
         var measureWidth:Boolean = isNaN(innerWidth);
         if(measureWidth)
         {
            innerWidth = Number(maxWidth);
         }
         var maxLineWidth:Number = lineBreak == "explicit" ? TextLine.MAX_LINE_WIDTH : innerWidth;
         if(innerWidth < 0 || innerHeight < 0 || !textBlock)
         {
            bounds.width = 0;
            bounds.height = 0;
            return false;
         }
         var fontSize:Number = staticTextElement.elementFormat.fontSize;
         if(lineHeight is Number)
         {
            actualLineHeight = Number(lineHeight);
         }
         else if(lineHeight is String)
         {
            len = int(lineHeight.length);
            percent = Number(String(lineHeight).substring(0,len - 1));
            actualLineHeight = percent / 100 * fontSize;
         }
         if(isNaN(actualLineHeight))
         {
            actualLineHeight = 1.2 * fontSize;
         }
         var maxTextWidth:Number = 0;
         var totalTextHeight:Number = 0;
         var n:int = 0;
         var nextY:Number = 0;
         var swfContext:ISWFContext = ISWFContext(this.embeddedFontContext);
         var createdAllLines:Boolean = false;
         while(true)
         {
            recycleLine = TextLineRecycler.getLineForReuse();
            if(Boolean(recycleLine))
            {
               if(Boolean(swfContext))
               {
                  nextTextLine = swfContext.callInContext(textBlock["recreateTextLine"],textBlock,[recycleLine,textLine,maxLineWidth]);
               }
               else
               {
                  nextTextLine = recreateTextLine(recycleLine,textLine,maxLineWidth);
               }
            }
            else if(Boolean(swfContext))
            {
               nextTextLine = swfContext.callInContext(textBlock.createTextLine,textBlock,[textLine,maxLineWidth]);
            }
            else
            {
               nextTextLine = textBlock.createTextLine(textLine,maxLineWidth);
            }
            if(!nextTextLine)
            {
               createdAllLines = !extraLine;
               break;
            }
            nextY += n == 0 ? nextTextLine.ascent : actualLineHeight;
            if(verticalAlign == "top" && nextY - nextTextLine.ascent > innerHeight)
            {
               if(extraLine)
               {
                  break;
               }
               extraLine = true;
            }
            textLine = nextTextLine;
            textLines[n++] = textLine;
            textLine.y = nextY;
            maxTextWidth = Math.max(maxTextWidth,textLine.textWidth);
            totalTextHeight += textLine.textHeight;
            if(lineThrough || textDecoration == "underline")
            {
               elementFormat = TextElement(textBlock.content).elementFormat;
               if(Boolean(this.embeddedFontContext))
               {
                  fontMetrics = this.embeddedFontContext.callInContext(elementFormat.getFontMetrics,elementFormat,null);
               }
               else
               {
                  fontMetrics = elementFormat.getFontMetrics();
               }
               shape = new Shape();
               g = shape.graphics;
               if(lineThrough)
               {
                  g.lineStyle(fontMetrics.strikethroughThickness,elementFormat.color,elementFormat.alpha);
                  g.moveTo(0,fontMetrics.strikethroughOffset);
                  g.lineTo(textLine.textWidth,fontMetrics.strikethroughOffset);
               }
               if(textDecoration == "underline")
               {
                  g.lineStyle(fontMetrics.underlineThickness,elementFormat.color,elementFormat.alpha);
                  g.moveTo(0,fontMetrics.underlineOffset);
                  g.lineTo(textLine.textWidth,fontMetrics.underlineOffset);
               }
               textLine.addChild(shape);
            }
         }
         if(n == 0)
         {
            bounds.width = paddingLeft + paddingRight;
            bounds.height = paddingTop + paddingBottom;
            return false;
         }
         if(measureWidth)
         {
            innerWidth = maxTextWidth;
         }
         if(isNaN(bounds.height))
         {
            innerHeight = textLine.y + textLine.descent;
         }
         innerWidth = Math.ceil(innerWidth);
         innerHeight = Math.ceil(innerHeight);
         var leftAligned:Boolean = textAlign == "start" && direction == "ltr" || textAlign == "end" && direction == "rtl" || textAlign == "left" || textAlign == "justify";
         var centerAligned:Boolean = textAlign == "center";
         var rightAligned:Boolean = textAlign == "start" && direction == "rtl" || textAlign == "end" && direction == "ltr" || textAlign == "right";
         var leftOffset:Number = bounds.left + paddingLeft;
         var centerOffset:Number = leftOffset + innerWidth / 2;
         var rightOffset:Number = leftOffset + innerWidth;
         var topOffset:Number = bounds.top + paddingTop;
         var bottomOffset:Number = innerHeight - (textLine.y + textLine.descent);
         var middleOffset:Number = bottomOffset / 2;
         bottomOffset += topOffset;
         middleOffset += topOffset;
         var leading:Number = (innerHeight - totalTextHeight) / (n - 1);
         var y:Number = 0;
         var lastLineIsSpecial:Boolean = textAlign == "justify" && createdAllLines;
         var minX:Number = innerWidth;
         var minY:Number = innerHeight;
         var maxX:Number = 0;
         var clipping:Boolean = Boolean(n) ? textLines[n - 1].y + TextLine(textLines[n - 1]).descent > innerHeight : false;
         for(var i:int = 0; i < n; i++)
         {
            textLine = TextLine(textLines[i]);
            if(lastLineIsSpecial && i == n - 1)
            {
               leftAligned = textAlignLast == "start" && direction == "ltr" || textAlignLast == "end" && direction == "rtl" || textAlignLast == "left" || textAlignLast == "justify";
               centerAligned = textAlignLast == "center";
               rightAligned = textAlignLast == "start" && direction == "rtl" || textAlignLast == "end" && direction == "ltr" || textAlignLast == "right";
            }
            if(leftAligned)
            {
               textLine.x = leftOffset;
            }
            else if(centerAligned)
            {
               textLine.x = centerOffset - textLine.textWidth / 2;
            }
            else if(rightAligned)
            {
               textLine.x = rightOffset - textLine.textWidth;
            }
            if(verticalAlign == "top" || !createdAllLines || clipping)
            {
               textLine.y += topOffset;
            }
            else if(verticalAlign == "middle")
            {
               textLine.y += middleOffset;
            }
            else if(verticalAlign == "bottom")
            {
               textLine.y += bottomOffset;
            }
            else if(verticalAlign == "justify")
            {
               y += i == 0 ? topOffset + textLine.ascent : previousTextLine.descent + leading + textLine.ascent;
               textLine.y = y;
               previousTextLine = textLine;
            }
            minX = Math.min(minX,textLine.x);
            minY = Math.min(minY,textLine.y - textLine.ascent);
            maxX = Math.max(maxX,textLine.x + textLine.textWidth);
         }
         bounds.x = minX - paddingLeft;
         bounds.y = minY - paddingTop;
         bounds.right = maxX + paddingRight;
         bounds.bottom = textLine.y + textLine.descent + paddingBottom;
         return createdAllLines;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createEmptyTextLine(height:Number = NaN) : void
      {
         staticTextElement.text = " ";
         bounds.width = NaN;
         bounds.height = height;
         this.createTextLinesFromTextBlock(staticTextBlock,textLines,bounds);
         this.releaseLinesFromTextBlock();
      }
      
      private function doesComposedTextFit(height:Number, width:Number, createdAllLines:Boolean, lineCountLimit:int, lineBreak:String) : Boolean
      {
         if(!createdAllLines)
         {
            return false;
         }
         if(lineCountLimit != -1 && textLines.length > lineCountLimit)
         {
            return false;
         }
         if(lineBreak == "explicit")
         {
            if(bounds.right > width)
            {
               return false;
            }
         }
         if(textLines.length <= 1 || isNaN(height))
         {
            return true;
         }
         var lastLine:TextLine = TextLine(textLines[textLines.length - 1]);
         var lastLineExtent:Number = lastLine.y + lastLine.descent;
         return lastLineExtent <= height;
      }
      
      private function truncateText(width:Number, height:Number, lineBreak:String) : void
      {
         var extraLine:Boolean = false;
         var indicatorLines:Vector.<DisplayObject> = null;
         var indicatorBounds:Rectangle = null;
         var indicatorFits:Boolean = false;
         var measuredTextLine:TextLine = null;
         var allowedWidth:Number = NaN;
         var truncateAtCharPosition:int = 0;
         var truncText:String = null;
         var createdAllLines:Boolean = false;
         var oldCharPosition:int = 0;
         var paddingBottom:Number = NaN;
         var paddingLeft:Number = NaN;
         var paddingRight:Number = NaN;
         var paddingTop:Number = NaN;
         var lineCountLimit:int = maxDisplayedLines;
         var somethingFit:Boolean = false;
         var truncLineIndex:int = 0;
         if(lineBreak == "explicit")
         {
            this.truncateExplicitLineBreakText(width,height);
            return;
         }
         truncLineIndex = this.computeLastAllowedLineIndex(height,lineCountLimit);
         if(truncLineIndex + 1 < textLines.length)
         {
            truncLineIndex++;
            extraLine = true;
         }
         if(truncLineIndex >= 0)
         {
            staticTextElement.text = truncationIndicatorResource;
            indicatorLines = new Vector.<DisplayObject>();
            indicatorBounds = new Rectangle(0,0,width,NaN);
            indicatorFits = this.createTextLinesFromTextBlock(staticTextBlock,indicatorLines,indicatorBounds);
            this.releaseLinesFromTextBlock();
            truncLineIndex -= indicatorLines.length - 1;
            if(truncLineIndex >= 0 && indicatorFits)
            {
               measuredTextLine = TextLine(indicatorLines[indicatorLines.length - 1]);
               allowedWidth = measuredTextLine.specifiedWidth - measuredTextLine.unjustifiedTextWidth;
               measuredTextLine = null;
               releaseTextLines(indicatorLines);
               truncateAtCharPosition = this.getTruncationPosition(TextLine(textLines[truncLineIndex]),allowedWidth,extraLine);
               do
               {
                  truncText = text.slice(0,truncateAtCharPosition) + truncationIndicatorResource;
                  bounds.x = 0;
                  bounds.y = 0;
                  bounds.width = width;
                  bounds.height = height;
                  staticTextElement.text = truncText;
                  createdAllLines = this.createTextLinesFromTextBlock(staticTextBlock,textLines,bounds);
                  if(this.doesComposedTextFit(height,width,createdAllLines,lineCountLimit,lineBreak))
                  {
                     somethingFit = true;
                     break;
                  }
                  if(truncateAtCharPosition == 0)
                  {
                     break;
                  }
                  oldCharPosition = truncateAtCharPosition;
                  truncateAtCharPosition = this.getNextTruncationPosition(truncLineIndex,truncateAtCharPosition);
                  if(oldCharPosition == truncateAtCharPosition)
                  {
                     break;
                  }
               }
               while(true);
            }
         }
         if(!somethingFit)
         {
            releaseTextLines();
            paddingBottom = Number(getStyle("paddingBottom"));
            paddingLeft = Number(getStyle("paddingLeft"));
            paddingRight = Number(getStyle("paddingRight"));
            paddingTop = Number(getStyle("paddingTop"));
            bounds.x = 0;
            bounds.y = 0;
            bounds.width = paddingLeft + paddingRight;
            bounds.height = paddingTop + paddingBottom;
         }
         setIsTruncated(true);
      }
      
      private function truncateExplicitLineBreakText(width:Number, height:Number) : void
      {
         var line:TextLine = null;
         var lineLength:int = 0;
         var lineStr:String = null;
         var clippedLines:Vector.<DisplayObject> = null;
         staticTextElement.text = truncationIndicatorResource;
         var indicatorLines:Vector.<DisplayObject> = new Vector.<DisplayObject>();
         var indicatorBounds:Rectangle = new Rectangle(0,0,width,NaN);
         this.createTextLinesFromTextBlock(staticTextBlock,indicatorLines,indicatorBounds);
         this.releaseLinesFromTextBlock();
         var n:int = int(textLines.length);
         for(var i:int = 0; i < n; i++)
         {
            line = textLines[i] as TextLine;
            if(line.x + line.width > width)
            {
               lineLength = line.rawTextLength;
               while(--lineLength > 0)
               {
                  lineStr = text.substr(line.textBlockBeginIndex,lineLength);
                  lineStr += truncationIndicatorResource;
                  staticTextElement.text = lineStr;
                  clippedLines = new Vector.<DisplayObject>();
                  this.createTextLinesFromTextBlock(staticTextBlock,clippedLines,indicatorBounds);
                  this.releaseLinesFromTextBlock();
                  if(clippedLines.length == 1 && clippedLines[0].x + clippedLines[0].width <= width)
                  {
                     clippedLines[0].x = line.x;
                     clippedLines[0].y = line.y;
                     textLines[i] = clippedLines[0];
                     break;
                  }
               }
            }
         }
      }
      
      private function computeLastAllowedLineIndex(height:Number, lineCountLimit:int) : int
      {
         var textLine:TextLine = null;
         var truncationLineIndex:int = textLines.length - 1;
         if(truncationLineIndex < 0)
         {
            return truncationLineIndex;
         }
         if(!isNaN(height))
         {
            do
            {
               textLine = TextLine(textLines[truncationLineIndex]);
               if(textLine.y + textLine.descent <= height)
               {
                  break;
               }
               truncationLineIndex--;
            }
            while(truncationLineIndex >= 0);
         }
         if(lineCountLimit != -1 && lineCountLimit <= truncationLineIndex)
         {
            truncationLineIndex = lineCountLimit - 1;
         }
         return truncationLineIndex;
      }
      
      private function getTruncationPosition(line:TextLine, allowedWidth:Number, extraLine:Boolean) : int
      {
         var atomIndex:int = 0;
         var atomBounds:Rectangle = null;
         var consumedWidth:Number = 0;
         var charPosition:int = line.textBlockBeginIndex;
         while(charPosition < line.textBlockBeginIndex + line.rawTextLength)
         {
            atomIndex = line.getAtomIndexAtCharIndex(charPosition);
            if(extraLine)
            {
               if(charPosition != line.textBlockBeginIndex && line.getAtomWordBoundaryOnLeft(atomIndex))
               {
                  break;
               }
            }
            else
            {
               atomBounds = line.getAtomBounds(atomIndex);
               consumedWidth += atomBounds.width;
               if(consumedWidth > allowedWidth)
               {
                  break;
               }
            }
            charPosition = line.getAtomTextBlockEndIndex(atomIndex);
         }
         return charPosition;
      }
      
      private function getNextTruncationPosition(truncationLineIndex:int, truncateAtCharPosition:int) : int
      {
         truncateAtCharPosition--;
         var line:TextLine = TextLine(textLines[truncationLineIndex]);
         while(!(truncateAtCharPosition >= line.textBlockBeginIndex && truncateAtCharPosition < line.textBlockBeginIndex + line.rawTextLength))
         {
            if(truncateAtCharPosition < line.textBlockBeginIndex)
            {
               truncationLineIndex--;
               if(truncationLineIndex < 0)
               {
                  return truncateAtCharPosition;
               }
            }
            else
            {
               truncationLineIndex++;
               if(truncationLineIndex >= textLines.length)
               {
                  return truncateAtCharPosition;
               }
            }
            line = TextLine(textLines[truncationLineIndex]);
            if(false)
            {
               break;
            }
         }
         var atomIndex:int = line.getAtomIndexAtCharIndex(truncateAtCharPosition);
         return line.getAtomTextBlockBeginIndex(atomIndex);
      }
      
      private function releaseLinesFromTextBlock() : void
      {
         var firstLine:TextLine = staticTextBlock.firstLine;
         var lastLine:TextLine = staticTextBlock.lastLine;
         if(Boolean(firstLine))
         {
            staticTextBlock.releaseLines(firstLine,lastLine);
         }
      }
   }
}

