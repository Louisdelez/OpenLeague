package mx.core
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextLineMetrics;
   import flash.text.engine.ElementFormat;
   import flash.text.engine.FontDescription;
   import flash.text.engine.FontLookup;
   import flash.text.engine.FontMetrics;
   import flash.text.engine.FontPosture;
   import flash.text.engine.FontWeight;
   import flash.text.engine.Kerning;
   import flash.text.engine.LineJustification;
   import flash.text.engine.SpaceJustifier;
   import flash.text.engine.TextBlock;
   import flash.text.engine.TextElement;
   import flash.text.engine.TextLine;
   import flash.utils.Dictionary;
   import flashx.textLayout.compose.ISWFContext;
   import flashx.textLayout.compose.TextLineRecycler;
   import flashx.textLayout.formats.LeadingModel;
   import flashx.textLayout.formats.LineBreak;
   import flashx.textLayout.formats.TextDecoration;
   import flashx.textLayout.formats.TextLayoutFormat;
   import mx.managers.SystemManager;
   import mx.managers.SystemManagerGlobals;
   import spark.utils.TextUtil;
   
   public class FTETextField extends Sprite implements IFontContextComponent
   {
      
      private static var staticTextBlockAllButLast:TextBlock;
      
      private static var staticTextBlockUnjustified:TextBlock;
      
      private static var nextLineIndex:int;
      
      private static var invalidFields:Dictionary = new Dictionary();
      
      private static var initialized:Boolean = false;
      
      private static var staticHandlersAdded:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const PADDING_LEFT:Number = 2;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const PADDING_TOP:Number = 2;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const PADDING_RIGHT:Number = 2;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const PADDING_BOTTOM:Number = 2;
      
      private static const ALL_LINEFEEDS:RegExp = /\n/g;
      
      private static const FLAG_BACKGROUND:uint = 1 << 0;
      
      private static const FLAG_BORDER:uint = 1 << 1;
      
      private static const FLAG_CONDENSE_WHITE:uint = 1 << 2;
      
      private static const FLAG_EMBED_FONTS:uint = 1 << 3;
      
      private static const FLAG_MULTILINE:uint = 1 << 4;
      
      private static const FLAG_WORD_WRAP:uint = 1 << 5;
      
      private static const FLAG_TEXT_SET:uint = 1 << 6;
      
      private static const FLAG_HTML_TEXT_SET:uint = 1 << 7;
      
      private static const FLAG_TEXT_LINES_INVALID:uint = 1 << 8;
      
      private static const FLAG_GRAPHICS_INVALID:uint = 1 << 9;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const FLAG_EFFECTIVE_CONDENSE_WHITE:uint = 1 << 10;
      
      private static const FLAG_VALIDATE_IN_PROGRESS:uint = 1 << 11;
      
      private static const FLAG_HAS_SCROLL_RECT:uint = 1 << 12;
      
      private static const ALL_INVALIDATION_FLAGS:uint = FLAG_TEXT_LINES_INVALID | FLAG_GRAPHICS_INVALID;
      
      private static var textField:TextField = new TextField();
      
      private static var staticTextElement:TextElement = new TextElement();
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var clipWidth:Number;
      
      private var _htmlHelper:HTMLHelper;
      
      private var flags:uint = 0;
      
      private var elementFormat:ElementFormat;
      
      private var _height:Number = 100;
      
      private var _width:Number = 100;
      
      private var _autoSize:String = "none";
      
      private var _backgroundColor:uint = 16777215;
      
      private var _borderColor:uint = 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _defaultTextFormat:TextFormat;
      
      private var _text:String = "";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _textHeight:Number = 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _textWidth:Number = 0;
      
      private var _direction:String = "ltr";
      
      private var _fontContext:IFlexModuleFactory;
      
      private var _locale:String = "en";
      
      public function FTETextField()
      {
         super();
         initClass();
         mouseChildren = false;
         doubleClickEnabled = false;
         tabChildren = false;
         this._defaultTextFormat = textField.defaultTextFormat;
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
      }
      
      private static function initClass() : void
      {
         if(initialized)
         {
            return;
         }
         staticTextBlockAllButLast = new TextBlock();
         staticTextBlockAllButLast.textJustifier = new SpaceJustifier("en",LineJustification.ALL_BUT_LAST);
         staticTextBlockUnjustified = new TextBlock();
         staticTextBlockUnjustified.textJustifier = new SpaceJustifier("en",LineJustification.UNJUSTIFIED);
         initialized = true;
      }
      
      private static function addStaticHandlers() : void
      {
         if(staticHandlersAdded)
         {
            return;
         }
         var sm:SystemManager = SystemManagerGlobals.topLevelSystemManagers[0];
         if(Boolean(sm))
         {
            sm.addEventListener(Event.RENDER,staticRenderHandler);
            sm.addEventListener(Event.ENTER_FRAME,staticRenderHandler);
            staticHandlersAdded = true;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function staticRenderHandler(e:Event) : void
      {
         var field:Object = null;
         var count:int = 0;
         for(field in invalidFields)
         {
            (field as FTETextField).validateNow();
            count++;
         }
         if(Boolean(count))
         {
            invalidFields = new Dictionary();
         }
      }
      
      private static function rint(x:Number) : Number
      {
         var i:Number = Math.round(x);
         if(i - 0.5 == x && Boolean(i & 1))
         {
            i--;
         }
         return i;
      }
      
      private static function cloneTextFormat(textFormat:TextFormat) : TextFormat
      {
         var newTextFormat:TextFormat = new TextFormat(textFormat.font,textFormat.size,textFormat.color,textFormat.bold,textFormat.italic,textFormat.underline,textFormat.url,textFormat.target,textFormat.align,textFormat.leftMargin,textFormat.rightMargin,textFormat.indent,textFormat.leading);
         newTextFormat.blockIndent = textFormat.blockIndent;
         newTextFormat.bullet = textFormat.bullet;
         newTextFormat.kerning = textFormat.kerning;
         newTextFormat.letterSpacing = textFormat.letterSpacing;
         newTextFormat.tabStops = textFormat.tabStops;
         return newTextFormat;
      }
      
      private static function applyTextFormat(src:TextFormat, dst:TextFormat) : void
      {
         if(src.align != null)
         {
            dst.align = src.align;
         }
         if(src.blockIndent != null)
         {
            dst.blockIndent = src.blockIndent;
         }
         if(src.bold != null)
         {
            dst.bold = src.bold;
         }
         if(src.bullet != null)
         {
            dst.bullet = src.bullet;
         }
         if(src.color != null)
         {
            dst.color = src.color;
         }
         if(src.font != null)
         {
            dst.font = src.font;
         }
         if(src.indent != null)
         {
            dst.indent = src.indent;
         }
         if(src.italic != null)
         {
            dst.italic = src.italic;
         }
         if(src.kerning != null)
         {
            dst.kerning != src.kerning;
         }
         if(src.leading != null)
         {
            dst.leading = src.leading;
         }
         if(src.leftMargin != null)
         {
            dst.leftMargin = src.leftMargin;
         }
         if(src.letterSpacing != null)
         {
            dst.letterSpacing = src.letterSpacing;
         }
         if(src.rightMargin != null)
         {
            dst.rightMargin = src.rightMargin;
         }
         if(src.size != null)
         {
            dst.size = src.size;
         }
         if(src.tabStops != null)
         {
            dst.tabStops = src.tabStops;
         }
         if(src.target != null)
         {
            dst.target = src.target;
         }
         if(src.underline != null)
         {
            dst.underline = src.underline;
         }
         if(src.url != null)
         {
            dst.url = src.url;
         }
      }
      
      override public function get height() : Number
      {
         if(this.autoSize != TextFieldAutoSize.NONE)
         {
            this.validateNow();
         }
         return this._height;
      }
      
      override public function set height(value:Number) : void
      {
         if(isNaN(value) || value < 0)
         {
            return;
         }
         if(value == this._height)
         {
            return;
         }
         this._height = value;
         this.setFlag(FLAG_TEXT_LINES_INVALID | FLAG_GRAPHICS_INVALID);
         this.invalidate();
      }
      
      override public function get scrollRect() : Rectangle
      {
         return this.testFlag(FLAG_HAS_SCROLL_RECT) ? super.scrollRect : null;
      }
      
      override public function set scrollRect(value:Rectangle) : void
      {
         if(!this.testFlag(FLAG_HAS_SCROLL_RECT) && !value)
         {
            return;
         }
         this.setFlag(FLAG_HAS_SCROLL_RECT);
         super.scrollRect = value;
      }
      
      override public function get width() : Number
      {
         if(this.autoSize != TextFieldAutoSize.NONE)
         {
            this.validateNow();
         }
         return this._width;
      }
      
      override public function set width(value:Number) : void
      {
         if(isNaN(value) || value < 0)
         {
            return;
         }
         if(value == this._width)
         {
            return;
         }
         this._width = value;
         this.setFlag(FLAG_TEXT_LINES_INVALID | FLAG_GRAPHICS_INVALID);
         this.invalidate();
      }
      
      public function get alwaysShowSelection() : Boolean
      {
         throw new Error(this.notImplemented("alwaysShowSelection"));
      }
      
      public function set alwaysShowSelection(value:Boolean) : void
      {
         throw new Error(this.notImplemented("alwaysShowSelection"));
      }
      
      public function get antiAliasType() : String
      {
         return null;
      }
      
      public function set antiAliasType(value:String) : void
      {
      }
      
      public function get autoSize() : String
      {
         return this._autoSize;
      }
      
      public function set autoSize(value:String) : void
      {
         var message:String = null;
         if(value != TextFieldAutoSize.NONE && value != TextFieldAutoSize.LEFT && value != TextFieldAutoSize.CENTER && value != TextFieldAutoSize.RIGHT)
         {
            message = this.getErrorMessage("badParameter","autoSize");
            throw new ArgumentError(message);
         }
         if(value == this.autoSize)
         {
            return;
         }
         this._autoSize = value;
         this.setFlag(FLAG_TEXT_LINES_INVALID | FLAG_GRAPHICS_INVALID);
         this.invalidate();
      }
      
      public function get background() : Boolean
      {
         return this.testFlag(FLAG_BACKGROUND);
      }
      
      public function set background(value:Boolean) : void
      {
         if(value == this.background)
         {
            return;
         }
         this.setFlagToValue(FLAG_BACKGROUND,value);
         this.setFlag(FLAG_GRAPHICS_INVALID);
         this.invalidate();
      }
      
      public function get backgroundColor() : uint
      {
         return this._backgroundColor;
      }
      
      public function set backgroundColor(value:uint) : void
      {
         if(value == this._backgroundColor)
         {
            return;
         }
         this._backgroundColor = value;
         this.setFlag(FLAG_GRAPHICS_INVALID);
         this.invalidate();
      }
      
      public function get border() : Boolean
      {
         return this.testFlag(FLAG_BORDER);
      }
      
      public function set border(value:Boolean) : void
      {
         if(value == this.border)
         {
            return;
         }
         this.setFlagToValue(FLAG_BORDER,value);
         this.setFlag(FLAG_GRAPHICS_INVALID);
         if(this.testFlag(FLAG_TEXT_SET | FLAG_HTML_TEXT_SET))
         {
            this.setFlag(FLAG_TEXT_LINES_INVALID);
         }
         this.invalidate();
      }
      
      public function get borderColor() : uint
      {
         return this._borderColor;
      }
      
      public function set borderColor(value:uint) : void
      {
         if(value == this._borderColor)
         {
            return;
         }
         this._borderColor = value;
         this.setFlag(FLAG_GRAPHICS_INVALID);
         this.invalidate();
      }
      
      public function get bottomScrollV() : int
      {
         throw new Error(this.notImplemented("bottomScrollV"));
      }
      
      public function get caretIndex() : int
      {
         throw new Error(this.notImplemented("caretIndex"));
      }
      
      public function get condenseWhite() : Boolean
      {
         return this.testFlag(FLAG_CONDENSE_WHITE);
      }
      
      public function set condenseWhite(value:Boolean) : void
      {
         this.setFlagToValue(FLAG_CONDENSE_WHITE,value);
      }
      
      public function get defaultTextFormat() : TextFormat
      {
         return cloneTextFormat(this._defaultTextFormat);
      }
      
      public function set defaultTextFormat(value:TextFormat) : void
      {
         var message:String = null;
         if(!value)
         {
            message = this.getErrorMessage("nullParameter","format");
            throw new TypeError(message);
         }
         applyTextFormat(value,this._defaultTextFormat);
         this.elementFormat = null;
         if(Boolean(this._htmlHelper))
         {
            this._htmlHelper.hostFormat = null;
         }
      }
      
      public function get displayAsPassword() : Boolean
      {
         throw new Error(this.notImplemented("displayAsPassword"));
      }
      
      public function set displayAsPassword(value:Boolean) : void
      {
         throw new Error(this.notImplemented("displayAsPassword"));
      }
      
      public function get embedFonts() : Boolean
      {
         return this.testFlag(FLAG_EMBED_FONTS);
      }
      
      public function set embedFonts(value:Boolean) : void
      {
         if(value == this.embedFonts)
         {
            return;
         }
         this.setFlagToValue(FLAG_EMBED_FONTS,value);
         this.elementFormat = null;
         if(Boolean(this._htmlHelper))
         {
            this._htmlHelper.hostFormat = null;
         }
         this.setFlag(FLAG_TEXT_LINES_INVALID | FLAG_GRAPHICS_INVALID);
         this.invalidate();
      }
      
      public function get gridFitType() : String
      {
         return null;
      }
      
      public function set gridFitType(value:String) : void
      {
      }
      
      public function get htmlText() : String
      {
         this.validateNow();
         if(!this._htmlHelper)
         {
            this._htmlHelper = new HTMLHelper(this);
         }
         return this._htmlHelper.getHtmlText(this._text);
      }
      
      public function set htmlText(value:String) : void
      {
         var message:String = null;
         if(value == null)
         {
            message = this.getErrorMessage("nullParameter","text");
            throw new TypeError(message);
         }
         this.setFlagToValue(FLAG_EFFECTIVE_CONDENSE_WHITE,this.testFlag(FLAG_CONDENSE_WHITE));
         if(!this._htmlHelper)
         {
            this._htmlHelper = new HTMLHelper(this);
         }
         this._htmlHelper.htmlText = value;
         this._htmlHelper.explicitHTMLText = value;
         this._text = null;
         this.clearFlag(FLAG_TEXT_SET);
         this.setFlag(FLAG_HTML_TEXT_SET | FLAG_TEXT_LINES_INVALID | FLAG_GRAPHICS_INVALID);
         this.invalidate();
      }
      
      public function get length() : int
      {
         return this.text.length;
      }
      
      public function get maxChars() : int
      {
         throw new Error(this.notImplemented("maxChars"));
      }
      
      public function set maxChars(value:int) : void
      {
         throw new Error(this.notImplemented("maxChars"));
      }
      
      public function get maxScrollH() : int
      {
         throw new Error(this.notImplemented("maxScrollH"));
      }
      
      public function get maxScrollV() : int
      {
         throw new Error(this.notImplemented("maxScrollV"));
      }
      
      public function get mouseWheelEnabled() : Boolean
      {
         return false;
      }
      
      public function set mouseWheelEnabled(value:Boolean) : void
      {
      }
      
      public function get multiline() : Boolean
      {
         return this.testFlag(FLAG_MULTILINE);
      }
      
      public function set multiline(value:Boolean) : void
      {
         this.setFlagToValue(FLAG_MULTILINE,value);
      }
      
      public function get numLines() : int
      {
         this.validateNow();
         return numChildren;
      }
      
      public function get restrict() : String
      {
         throw new Error(this.notImplemented("restrict"));
      }
      
      public function set restrict(value:String) : void
      {
         throw new Error(this.notImplemented("restrict"));
      }
      
      public function get scrollH() : int
      {
         throw new Error(this.notImplemented("scrollH"));
      }
      
      public function set scrollH(value:int) : void
      {
         throw new Error(this.notImplemented("scrollH"));
      }
      
      public function get scrollV() : int
      {
         throw new Error(this.notImplemented("scrollV"));
      }
      
      public function set scrollV(value:int) : void
      {
         throw new Error(this.notImplemented("scrollV"));
      }
      
      public function get selectable() : Boolean
      {
         return false;
      }
      
      public function set selectable(value:Boolean) : void
      {
      }
      
      public function get selectionBeginIndex() : int
      {
         throw new Error(this.notImplemented("selectionBeginIndex"));
      }
      
      public function get selectionEndIndex() : int
      {
         throw new Error(this.notImplemented("selectionEndIndex"));
      }
      
      public function get sharpness() : Number
      {
         return NaN;
      }
      
      public function set sharpness(value:Number) : void
      {
      }
      
      public function get styleSheet() : StyleSheet
      {
         return Boolean(this._htmlHelper) ? this._htmlHelper.styleSheet : null;
      }
      
      public function set styleSheet(value:StyleSheet) : void
      {
         if(!this._htmlHelper)
         {
            this._htmlHelper = new HTMLHelper(this);
         }
         this._htmlHelper.setStyleSheet(value);
         this.setFlag(FLAG_TEXT_LINES_INVALID | FLAG_GRAPHICS_INVALID);
         this.invalidate();
      }
      
      public function get text() : String
      {
         if(this._text == null && Boolean(this._htmlHelper))
         {
            this._text = this._htmlHelper.getText().replace(ALL_LINEFEEDS,"\r");
         }
         return this._text;
      }
      
      public function set text(value:String) : void
      {
         var message:String = null;
         if(value == null)
         {
            message = this.getErrorMessage("nullParameter","text");
            throw new TypeError(message);
         }
         this._text = value.replace(ALL_LINEFEEDS,"\r");
         this.clearFlag(FLAG_HTML_TEXT_SET);
         this.setFlag(FLAG_TEXT_SET | FLAG_TEXT_LINES_INVALID | FLAG_GRAPHICS_INVALID);
         this.invalidate();
      }
      
      public function get textColor() : uint
      {
         return uint(this._defaultTextFormat.color);
      }
      
      public function set textColor(value:uint) : void
      {
         if(value == this.textColor)
         {
            return;
         }
         this._defaultTextFormat.color = value;
         this.elementFormat = null;
         if(Boolean(this._htmlHelper))
         {
            this._htmlHelper.hostFormat = null;
         }
         this.setFlag(FLAG_TEXT_LINES_INVALID);
         this.invalidate();
      }
      
      public function get textHeight() : Number
      {
         this.validateNow();
         return this._textHeight;
      }
      
      public function get textWidth() : Number
      {
         this.validateNow();
         return this._textWidth;
      }
      
      public function get thickness() : Number
      {
         return NaN;
      }
      
      public function set thickness(value:Number) : void
      {
      }
      
      public function get type() : String
      {
         return TextFieldType.DYNAMIC;
      }
      
      public function set type(value:String) : void
      {
         var message:String = null;
         if(value != TextFieldType.DYNAMIC && value != TextFieldType.INPUT)
         {
            message = this.getErrorMessage("badParameter","type");
            throw new ArgumentError(message);
         }
         if(value == TextFieldType.INPUT)
         {
            message = this.getErrorMessage("unsupportedTypeInFTETextField");
            throw new Error(message);
         }
      }
      
      public function get useRichTextClipboard() : Boolean
      {
         throw new Error(this.notImplemented("useRichTextClipboard"));
      }
      
      public function set useRichTextClipboard(value:Boolean) : void
      {
         throw new Error(this.notImplemented("useRichTextClipboard"));
      }
      
      public function get wordWrap() : Boolean
      {
         return this.testFlag(FLAG_WORD_WRAP);
      }
      
      public function set wordWrap(value:Boolean) : void
      {
         if(value == this.wordWrap)
         {
            return;
         }
         this.setFlagToValue(FLAG_WORD_WRAP,value);
         this.elementFormat = null;
         if(Boolean(this._htmlHelper))
         {
            this._htmlHelper.hostFormat = null;
         }
         this.setFlag(FLAG_TEXT_LINES_INVALID | FLAG_GRAPHICS_INVALID);
         this.invalidate();
      }
      
      public function get direction() : String
      {
         return this._direction;
      }
      
      public function set direction(value:String) : void
      {
         var message:String = null;
         if(value != "ltr" && value != "rtl")
         {
            message = this.getErrorMessage("badParameter","direction");
            throw new ArgumentError(message);
         }
         if(value == this._direction)
         {
            return;
         }
         this._direction = value;
         this.elementFormat = null;
         if(Boolean(this._htmlHelper))
         {
            this._htmlHelper.hostFormat = null;
         }
         this.setFlag(FLAG_TEXT_LINES_INVALID | FLAG_GRAPHICS_INVALID);
         this.invalidate();
      }
      
      public function get fontContext() : IFlexModuleFactory
      {
         return this._fontContext;
      }
      
      public function set fontContext(value:IFlexModuleFactory) : void
      {
         if(value == this._fontContext)
         {
            return;
         }
         this._fontContext = value;
         this.setFlag(FLAG_TEXT_LINES_INVALID | FLAG_GRAPHICS_INVALID);
         this.invalidate();
      }
      
      public function get locale() : String
      {
         return this._locale;
      }
      
      public function set locale(value:String) : void
      {
         if(value == this._locale)
         {
            return;
         }
         this._locale = value;
         this.elementFormat = null;
         if(Boolean(this._htmlHelper))
         {
            this._htmlHelper.hostFormat = null;
         }
         this.setFlag(FLAG_TEXT_LINES_INVALID | FLAG_GRAPHICS_INVALID);
         this.invalidate();
      }
      
      private function get leftMargin() : Number
      {
         return this.direction == "ltr" ? Number(this._defaultTextFormat.leftMargin) : Number(this._defaultTextFormat.rightMargin);
      }
      
      private function get rightMargin() : Number
      {
         return this.direction == "ltr" ? Number(this._defaultTextFormat.rightMargin) : Number(this._defaultTextFormat.leftMargin);
      }
      
      public function appendText(newText:String) : void
      {
         throw new Error(this.notImplemented("appendText()"));
      }
      
      public function getCharBoundaries(charIndex:int) : Rectangle
      {
         throw new Error(this.notImplemented("getCharBoundaries()"));
      }
      
      public function getCharIndexAtPoint(x:Number, y:Number) : int
      {
         throw new Error(this.notImplemented("getCharIndexAtPoint()"));
      }
      
      public function getFirstCharInParagraph(charIndex:int) : int
      {
         throw new Error(this.notImplemented("getFirstCharInParagraph()"));
      }
      
      public function getLineIndexAtPoint(x:Number, y:Number) : int
      {
         throw new Error(this.notImplemented("getLineIndexAtPoint()"));
      }
      
      public function getLineIndexOfChar(charIndex:int) : int
      {
         throw new Error(this.notImplemented("getLineIndexOfChar()"));
      }
      
      public function getLineLength(lineIndex:int) : int
      {
         throw new Error(this.notImplemented("getLineLength()"));
      }
      
      public function getLineMetrics(lineIndex:int) : TextLineMetrics
      {
         var message:String = null;
         this.validateNow();
         if(lineIndex < 0 || lineIndex >= numChildren)
         {
            message = this.getErrorMessage("badIndex");
            throw new RangeError(message);
         }
         var textLine:TextLine = TextLine(getChildAt(lineIndex));
         var x:Number = Math.round(textLine.localToGlobal(new Point(0,0)).x);
         var width:Number = Math.round(textLine.textWidth);
         var ascent:Number = Math.round(textLine.ascent) + Math.round(textLine.descent);
         var descent:Number = Math.round(textLine.descent);
         var leading:Number = Math.round(Number(this._defaultTextFormat.leading));
         var height:Number = ascent + descent + leading;
         return new TextLineMetrics(x,width,height,ascent,descent,leading);
      }
      
      public function getLineOffset(lineIndex:int) : int
      {
         throw new Error(this.notImplemented("getLineOffset()"));
      }
      
      public function getLineText(lineIndex:int) : String
      {
         throw new Error(this.notImplemented("getLineText()"));
      }
      
      public function getParagraphLength(charIndex:int) : int
      {
         throw new Error(this.notImplemented("getParagraphLength()"));
      }
      
      public function getTextFormat(beginIndex:int = -1, endIndex:int = -1) : TextFormat
      {
         return cloneTextFormat(this._defaultTextFormat);
      }
      
      public function replaceSelectedText(value:String) : void
      {
         throw new Error(this.notImplemented("replaceSelectedText()"));
      }
      
      public function replaceText(beginIndex:int, endIndex:int, newText:String) : void
      {
         throw new Error(this.notImplemented("replaceText()"));
      }
      
      public function setSelection(beginIndex:int, endIndex:int) : void
      {
         throw new Error(this.notImplemented("setSelection()"));
      }
      
      public function setTextFormat(format:TextFormat, beginIndex:int = -1, endIndex:int = -1) : void
      {
         if(beginIndex == -1 && endIndex == -1)
         {
            this.defaultTextFormat = format;
            this.setFlag(FLAG_TEXT_LINES_INVALID | FLAG_GRAPHICS_INVALID);
            this.validateNow();
         }
      }
      
      public function getImageReference(id:String) : DisplayObject
      {
         throw new Error(this.notImplemented("getImageReference()"));
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function testFlag(mask:uint) : Boolean
      {
         return (this.flags & mask) != 0;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setFlag(mask:uint) : void
      {
         this.flags |= mask;
      }
      
      private function clearFlag(mask:uint) : void
      {
         this.flags &= ~mask;
      }
      
      private function setFlagToValue(mask:uint, value:Boolean) : void
      {
         if(value)
         {
            this.flags |= mask;
         }
         else
         {
            this.flags &= ~mask;
         }
      }
      
      private function invalidate() : void
      {
         if(!staticHandlersAdded)
         {
            addStaticHandlers();
         }
         if(Boolean(stage))
         {
            stage.invalidate();
         }
         invalidFields[this] = 0;
      }
      
      private function validateNow() : void
      {
         var compositionWidth:Number = NaN;
         var compositionHeight:Number = NaN;
         var origX:Number = NaN;
         var origWidth:Number = NaN;
         var origHeight:Number = NaN;
         var blockIndent:Number = NaN;
         var indent:Number = NaN;
         var r:Rectangle = null;
         var g:Graphics = null;
         var w:Number = NaN;
         var h:Number = NaN;
         if(!this.testFlag(ALL_INVALIDATION_FLAGS) || this.testFlag(FLAG_VALIDATE_IN_PROGRESS))
         {
            return;
         }
         this.setFlag(FLAG_VALIDATE_IN_PROGRESS);
         if(this.testFlag(FLAG_TEXT_LINES_INVALID))
         {
            if(this.testFlag(FLAG_HTML_TEXT_SET))
            {
               if(nextLineIndex > 0)
               {
                  nextLineIndex = 0;
                  this.removeExcessTextLines();
               }
            }
            else if(this.testFlag(FLAG_TEXT_SET))
            {
               if(Boolean(this._htmlHelper))
               {
                  this._htmlHelper.clearContainerChildren();
               }
               this._htmlHelper = null;
            }
            this._textWidth = 0;
            this._textHeight = 0;
            this.clipWidth = 0;
            compositionWidth = NaN;
            compositionHeight = NaN;
            if(this._autoSize == TextFieldAutoSize.NONE)
            {
               compositionWidth = this._width;
               compositionHeight = this._height;
            }
            else if(this.wordWrap)
            {
               compositionWidth = this._width;
            }
            if(this.testFlag(FLAG_HTML_TEXT_SET))
            {
               if(!this._htmlHelper.hostFormat)
               {
                  this.createHostFormat();
               }
               this._htmlHelper.composeHTMLText(compositionWidth,compositionHeight);
            }
            else
            {
               if(!this.elementFormat)
               {
                  this.createElementFormat();
               }
               this.composeText(compositionWidth,compositionHeight);
            }
            origX = x;
            origWidth = this._width;
            origHeight = this._height;
            if(this._autoSize != TextFieldAutoSize.NONE)
            {
               this._height = this._textHeight + PADDING_TOP + PADDING_BOTTOM;
               if(!this.wordWrap)
               {
                  this._width = this._textWidth + PADDING_LEFT + PADDING_RIGHT;
                  blockIndent = Number(this._defaultTextFormat.blockIndent);
                  indent = Number(this._defaultTextFormat.indent);
                  if(blockIndent + indent + this.leftMargin > 0)
                  {
                     this._width += blockIndent + indent + this.leftMargin;
                  }
                  this._width += this.rightMargin;
                  if(this.rightMargin > 0)
                  {
                     this.clipWidth = this._width;
                  }
                  else
                  {
                     if(this._width - PADDING_LEFT - PADDING_RIGHT < this._textWidth)
                     {
                        this._width = this._textWidth + PADDING_LEFT + PADDING_RIGHT;
                     }
                     this.clipWidth = origWidth + 1;
                  }
                  if(this._autoSize == TextFieldAutoSize.RIGHT)
                  {
                     x += origWidth - this._width;
                  }
                  else if(this._autoSize == TextFieldAutoSize.CENTER)
                  {
                     x += (origWidth - this._width) / 2;
                  }
               }
               if(this._height != origHeight || this._width != origWidth || x != origX)
               {
                  this.setFlag(FLAG_GRAPHICS_INVALID);
               }
            }
            if(this.clipWidth > origWidth || this._textHeight > origHeight)
            {
               r = this.scrollRect;
               if(!r)
               {
                  r = new Rectangle();
               }
               r.left = 0;
               r.top = 0;
               r.right = this._width;
               r.bottom = this._height;
               if(this.testFlag(FLAG_GRAPHICS_INVALID) && this.border)
               {
                  ++r.width;
                  ++r.height;
               }
               this.scrollRect = r;
            }
            else
            {
               this.scrollRect = null;
            }
         }
         if(this.testFlag(FLAG_GRAPHICS_INVALID))
         {
            g = graphics;
            g.clear();
            w = rint(this._width);
            h = rint(this._height);
            g.beginFill(this.backgroundColor,this.background ? 1 : 0);
            g.drawRect(0,0,w,h);
            g.endFill();
            if(this.border)
            {
               g.lineStyle(1,this.borderColor);
               g.drawRect(0.5,0.5,this._width,this._height);
            }
         }
         this.clearFlag(ALL_INVALIDATION_FLAGS | FLAG_VALIDATE_IN_PROGRESS);
      }
      
      private function createElementFormat() : void
      {
         var fontDescription:FontDescription = new FontDescription();
         fontDescription.fontLookup = this.embedFonts ? FontLookup.EMBEDDED_CFF : FontLookup.DEVICE;
         fontDescription.fontName = this._defaultTextFormat.font;
         fontDescription.fontPosture = Boolean(this._defaultTextFormat.italic) ? FontPosture.ITALIC : FontPosture.NORMAL;
         fontDescription.fontWeight = Boolean(this._defaultTextFormat.bold) ? FontWeight.BOLD : FontWeight.NORMAL;
         this.elementFormat = new ElementFormat();
         this.elementFormat.color = uint(this._defaultTextFormat.color);
         this.elementFormat.fontDescription = fontDescription;
         this.elementFormat.fontSize = Number(this._defaultTextFormat.size);
         this.elementFormat.kerning = Boolean(this._defaultTextFormat.kerning) ? Kerning.AUTO : Kerning.OFF;
         this.elementFormat.locale = this.locale;
         this.elementFormat.trackingRight = Number(this._defaultTextFormat.letterSpacing);
      }
      
      private function createHostFormat() : void
      {
         var hostFormat:TextLayoutFormat = new TextLayoutFormat();
         hostFormat.color = this._defaultTextFormat.color;
         hostFormat.direction = this.direction;
         hostFormat.fontFamily = this._defaultTextFormat.font;
         hostFormat.fontLookup = this.embedFonts ? FontLookup.EMBEDDED_CFF : FontLookup.DEVICE;
         hostFormat.fontSize = this._defaultTextFormat.size;
         hostFormat.fontStyle = Boolean(this._defaultTextFormat.italic) ? FontPosture.ITALIC : FontPosture.NORMAL;
         hostFormat.fontWeight = Boolean(this._defaultTextFormat.bold) ? FontWeight.BOLD : FontWeight.NORMAL;
         hostFormat.kerning = Boolean(this._defaultTextFormat.kerning) ? Kerning.AUTO : Kerning.OFF;
         hostFormat.leadingModel = LeadingModel.APPROXIMATE_TEXT_FIELD;
         hostFormat.lineBreak = this.wordWrap ? LineBreak.TO_FIT : LineBreak.EXPLICIT;
         hostFormat.lineHeight = this._defaultTextFormat.leading;
         hostFormat.locale = this.locale;
         hostFormat.paddingBottom = FTETextField.PADDING_BOTTOM;
         hostFormat.paddingLeft = FTETextField.PADDING_LEFT;
         hostFormat.paddingRight = FTETextField.PADDING_RIGHT;
         hostFormat.paddingTop = FTETextField.PADDING_TOP;
         hostFormat.paragraphEndIndent = this._defaultTextFormat.rightMargin;
         hostFormat.paragraphStartIndent = this._defaultTextFormat.leftMargin;
         hostFormat.textAlign = this._defaultTextFormat.align;
         hostFormat.textAlignLast = this._defaultTextFormat.align;
         hostFormat.textDecoration = Boolean(this._defaultTextFormat.underline) ? TextDecoration.UNDERLINE : TextDecoration.NONE;
         hostFormat.textIndent = this._defaultTextFormat.indent;
         hostFormat.trackingRight = this._defaultTextFormat.letterSpacing;
         this._htmlHelper.hostFormat = hostFormat;
      }
      
      private function removeExcessTextLines() : void
      {
         var textLine:TextLine = null;
         var n:int = numChildren;
         for(var i:int = nextLineIndex; i < n; i++)
         {
            textLine = TextLine(removeChildAt(nextLineIndex));
            TextUtil.recycleTextLine(textLine);
         }
      }
      
      private function composeText(compositionWidth:Number, compositionHeight:Number) : void
      {
         var emBox:Rectangle = null;
         var j:int = 0;
         var paragraphText:String = null;
         var innerWidth:Number = compositionWidth - PADDING_LEFT - PADDING_RIGHT;
         var innerHeight:Number = compositionHeight - PADDING_TOP - PADDING_BOTTOM;
         if(Boolean(this.fontContext))
         {
            emBox = this.fontContext.callInContext(this.elementFormat.getFontMetrics,this.elementFormat,[]).emBox;
         }
         else
         {
            emBox = this.elementFormat.getFontMetrics().emBox;
         }
         var ascent:int = Math.round(-emBox.top) + Math.round(emBox.bottom);
         var descent:int = Math.round(emBox.bottom);
         var leading:Number = Math.round(Number(this._defaultTextFormat.leading));
         var paragraphY:int = 0;
         var n:int = this.text.length;
         var i:int = 0;
         nextLineIndex = 0;
         do
         {
            j = this.text.indexOf("\r",i);
            if(j == -1)
            {
               j = n;
            }
            paragraphText = i == 0 && j == n ? this.text : this.text.substring(i,j);
            paragraphY = this.createTextLines(innerWidth,innerHeight,paragraphText,paragraphY,ascent,descent);
            paragraphY += leading;
            i = j + 1;
         }
         while(j < n);
         this.removeExcessTextLines();
         this.alignTextLines(innerWidth);
         this._textWidth = Math.round(this._textWidth);
         this._textHeight = Math.round(numChildren * (ascent + descent) + (numChildren - 1) * Number(this._defaultTextFormat.leading));
         this.clipWidth = Math.round(this.clipWidth);
      }
      
      private function createTextLines(innerWidth:Number, innerHeight:Number, paragraphText:String, paragraphY:int, ascent:int, descent:int) : int
      {
         var textBlock:TextBlock = this._defaultTextFormat.align == "justify" ? staticTextBlockAllButLast : staticTextBlockUnjustified;
         staticTextElement.text = paragraphText.length > 0 ? paragraphText : " ";
         staticTextElement.elementFormat = this.elementFormat;
         textBlock.content = staticTextElement;
         textBlock.bidiLevel = this.direction == "ltr" ? 0 : 1;
         paragraphY = this.createTextLinesFromTextBlock(innerWidth,innerHeight,textBlock,staticTextElement.text.length,paragraphY,ascent,descent);
         var firstLine:TextLine = textBlock.firstLine;
         if(Boolean(firstLine))
         {
            textBlock.releaseLines(firstLine,textBlock.lastLine);
         }
         return paragraphY;
      }
      
      private function createTextLinesFromTextBlock(innerWidth:Number, innerHeight:Number, textBlock:TextBlock, textLength:int, paragraphY:int, ascent:int, descent:int) : int
      {
         var nextTextLine:TextLine = null;
         var textLine:TextLine = null;
         var recycleLine:TextLine = null;
         var totalIndent:Number = NaN;
         var fontMetrics:FontMetrics = null;
         var shape:Shape = null;
         var g:Graphics = null;
         if(innerWidth < 0 || innerHeight < 0)
         {
            return paragraphY;
         }
         var blockIndent:Number = Number(this._defaultTextFormat.blockIndent);
         var indent:Number = Number(this._defaultTextFormat.indent);
         var maxLineWidthBeforeIndent:Number = this.wordWrap ? innerWidth : TextLine.MAX_LINE_WIDTH;
         var maxLineWidth:Number = maxLineWidthBeforeIndent;
         var n:int = 0;
         var nextY:int = paragraphY;
         var thisLeftMargin:Number = this.leftMargin;
         var thisRightMargin:Number = this.rightMargin;
         var fitSomething:Boolean = true;
         var charsConsumed:int = 0;
         while(charsConsumed < textLength)
         {
            if(n <= 1)
            {
               totalIndent = blockIndent + thisLeftMargin;
               if(n == 0)
               {
                  totalIndent += indent;
               }
               if(totalIndent < 0)
               {
                  totalIndent = 0;
               }
               else if(totalIndent > this._width - PADDING_LEFT - PADDING_RIGHT)
               {
                  totalIndent = this._width - PADDING_LEFT - PADDING_RIGHT;
               }
               maxLineWidth = maxLineWidthBeforeIndent - totalIndent;
               if(this.wordWrap)
               {
                  maxLineWidthBeforeIndent -= thisRightMargin;
               }
               if(maxLineWidth > TextLine.MAX_LINE_WIDTH)
               {
                  maxLineWidth = TextLine.MAX_LINE_WIDTH;
               }
            }
            recycleLine = nextLineIndex < numChildren ? getChildAt(nextLineIndex) as TextLine : TextLineRecycler.getLineForReuse();
            if(Boolean(recycleLine))
            {
               if(Boolean(this.fontContext as ISWFContext))
               {
                  nextTextLine = this.fontContext.callInContext(textBlock.recreateTextLine,textBlock,[recycleLine,textLine,maxLineWidth,0,fitSomething]);
               }
               else
               {
                  nextTextLine = textBlock.recreateTextLine(recycleLine,textLine,maxLineWidth,0,fitSomething);
               }
            }
            else if(Boolean(this.fontContext as ISWFContext))
            {
               nextTextLine = this.fontContext.callInContext(textBlock.createTextLine,textBlock,[textLine,maxLineWidth,0,fitSomething]);
            }
            else
            {
               nextTextLine = textBlock.createTextLine(textLine,maxLineWidth,0,fitSomething);
            }
            nextTextLine.doubleClickEnabled = false;
            charsConsumed += nextTextLine.rawTextLength;
            if(n == 0)
            {
               nextY += ascent;
            }
            else
            {
               nextY += descent + this._defaultTextFormat.leading + ascent;
            }
            textLine = nextTextLine;
            n++;
            textLine.y = nextY;
            textLine.x = totalIndent;
            if(Boolean(this._defaultTextFormat.underline))
            {
               if(Boolean(this.fontContext))
               {
                  fontMetrics = this.fontContext.callInContext(this.elementFormat.getFontMetrics,this.elementFormat,[]);
               }
               else
               {
                  fontMetrics = this.elementFormat.getFontMetrics();
               }
               shape = new Shape();
               g = shape.graphics;
               g.lineStyle(fontMetrics.underlineThickness,this.elementFormat.color,this.elementFormat.alpha);
               g.moveTo(0,fontMetrics.underlineOffset);
               g.lineTo(textLine.textWidth,fontMetrics.underlineOffset);
               textLine.addChild(shape);
            }
            if(nextLineIndex == numChildren)
            {
               addChild(textLine);
            }
            ++nextLineIndex;
         }
         return nextY + descent;
      }
      
      private function alignTextLines(innerWidth:Number) : void
      {
         var textLine:TextLine = null;
         var width:Number = NaN;
         if(isNaN(innerWidth))
         {
            innerWidth = 0;
         }
         var align:String = this._defaultTextFormat.align;
         var leftAligned:Boolean = align == "left" || align == "justify" && this.direction == "ltr";
         var centerAligned:Boolean = align == "center";
         var rightAligned:Boolean = align == "right" || align == "justify" && this.direction == "rtl";
         var leftOffset:Number = PADDING_LEFT;
         var centerOffset:Number = leftOffset + innerWidth / 2;
         var rightOffset:Number = leftOffset + innerWidth;
         var thisRightMargin:Number = this.rightMargin;
         var n:int = numChildren;
         for(var i:int = 0; i < n; i++)
         {
            textLine = TextLine(getChildAt(i));
            this._textWidth = Math.max(this._textWidth,textLine.textWidth);
            width = textLine.x + textLine.textWidth + thisRightMargin;
            if(leftAligned || width >= innerWidth && this.direction == "ltr")
            {
               textLine.x += leftOffset;
            }
            else if(rightAligned || width >= innerWidth && this.direction == "rtl")
            {
               textLine.x += rightOffset - width;
            }
            else if(centerAligned)
            {
               textLine.x += centerOffset - width / 2;
            }
            if(textLine.x < 0)
            {
               this.clipWidth = int.MAX_VALUE;
            }
            else
            {
               this.clipWidth = Math.max(this.clipWidth,textLine.x + textLine.textWidth);
            }
            textLine.y += PADDING_TOP;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getErrorMessage(key:String, param:String = null) : String
      {
         var message:String = "";
         switch(key)
         {
            case "badParameter":
               message = "Parameter " + param + " must be one of the accepted values.";
               break;
            case "nullParameter":
               message = "Parameter " + param + " must be non-null.";
               break;
            case "badIndex":
               message = "The supplied index is out of bounds.";
               break;
            case "notImplementedInFTETextField":
               message = "\'" + param + "\' is not implemented in FTETextField.";
               break;
            case "unsupportedTypeInFTETextField":
               message = "FTETextField does not support setting type to \"input\".";
         }
         return message;
      }
      
      private function notImplemented(name:String) : String
      {
         return this.getErrorMessage("notImplementedInFTETextField",name);
      }
      
      private function addedToStageHandler(event:Event) : void
      {
         this.invalidate();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function inlineGraphicStatusChangeHandler(event:Event) : void
      {
         this.setFlag(FLAG_TEXT_LINES_INVALID | FLAG_GRAPHICS_INVALID);
         this.invalidate();
      }
   }
}

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.events.TextEvent;
import flash.geom.Rectangle;
import flash.text.StyleSheet;
import flash.text.engine.Kerning;
import flashx.textLayout.compose.ISWFContext;
import flashx.textLayout.container.TextContainerManager;
import flashx.textLayout.conversion.ConversionType;
import flashx.textLayout.conversion.ITextExporter;
import flashx.textLayout.conversion.ITextImporter;
import flashx.textLayout.conversion.TextConverter;
import flashx.textLayout.edit.EditingMode;
import flashx.textLayout.elements.Configuration;
import flashx.textLayout.elements.FlowElement;
import flashx.textLayout.elements.IConfiguration;
import flashx.textLayout.elements.IFormatResolver;
import flashx.textLayout.elements.LinkElement;
import flashx.textLayout.elements.ParagraphElement;
import flashx.textLayout.elements.SpanElement;
import flashx.textLayout.elements.TextFlow;
import flashx.textLayout.events.FlowElementMouseEvent;
import flashx.textLayout.events.StatusChangeEvent;
import flashx.textLayout.formats.ITextLayoutFormat;
import flashx.textLayout.formats.TextLayoutFormat;
import mx.core.FTETextField;

class FTETextFieldTextContainerManager extends TextContainerManager
{
   
   public function FTETextFieldTextContainerManager(container:Sprite, configuration:IConfiguration = null)
   {
      super(container,configuration);
   }
   
   override public function drawBackgroundAndSetScrollRect(scrollX:Number, scrollY:Number) : Boolean
   {
      return true;
   }
}

class FTETextFieldStyleResolver implements IFormatResolver
{
   
   private static const textFieldToTLFStyleMap:Object = {
      "leading":"lineHeight",
      "letterSpacing":"trackingRight",
      "marginLeft":"paragraphStartIndent",
      "marginRight":"paragraphEndIndent"
   };
   
   private var _styleSheet:StyleSheet;
   
   public function FTETextFieldStyleResolver(styleSheet:StyleSheet)
   {
      super();
      this._styleSheet = styleSheet;
   }
   
   public function resolveFormat(elem:Object) : ITextLayoutFormat
   {
      var attr:TextLayoutFormat = null;
      if(elem is FlowElement)
      {
         if(elem is TextFlow)
         {
            attr = this.addStyleAttributes(attr,"body");
         }
         else if(elem is ParagraphElement)
         {
            attr = this.addStyleAttributes(attr,"p");
         }
         else if(elem is SpanElement)
         {
            attr = this.addStyleAttributes(attr,"span");
         }
         if(elem.styleName != null)
         {
            attr = this.addStyleAttributes(attr,"." + elem.styleName);
         }
      }
      return attr;
   }
   
   public function resolveUserFormat(elem:Object, userStyle:String) : *
   {
      var attr:TextLayoutFormat = null;
      var flowElem:FlowElement = elem as FlowElement;
      if(Boolean(flowElem))
      {
         if(Boolean(flowElem.styleName))
         {
            attr = this.addStyleAttributes(null,"." + flowElem.styleName);
         }
         else if(flowElem is LinkElement)
         {
            if(userStyle == "linkNormalFormat")
            {
               attr = this.addStyleAttributes(null,"a:link");
            }
            else if(userStyle == "linkHoverFormat")
            {
               attr = this.addStyleAttributes(null,"a:hover");
            }
            else if(userStyle == "linkActiveFormat")
            {
               attr = this.addStyleAttributes(null,"a:active");
            }
         }
         else
         {
            attr = this.addStyleAttributes(null,userStyle);
         }
      }
      return attr != null ? attr : undefined;
   }
   
   public function invalidateAll(tf:TextFlow) : void
   {
   }
   
   public function invalidate(target:Object) : void
   {
   }
   
   public function getResolverForNewFlow(oldFlow:TextFlow, newFlow:TextFlow) : IFormatResolver
   {
      return this;
   }
   
   private function addStyleAttributes(attr:TextLayoutFormat, styleSelector:String) : TextLayoutFormat
   {
      var p:* = undefined;
      var propStyle:Object = null;
      var tlfProp:String = null;
      var color:String = null;
      var foundStyle:Object = this._styleSheet.getStyle(styleSelector);
      if(foundStyle != null)
      {
         for(p in foundStyle)
         {
            propStyle = foundStyle[p];
            if(attr == null)
            {
               attr = new TextLayoutFormat();
            }
            if(Boolean(textFieldToTLFStyleMap[p]))
            {
               tlfProp = textFieldToTLFStyleMap[p];
               attr[tlfProp] = propStyle;
            }
            else if(p == "color")
            {
               color = String(propStyle);
               if(Boolean(color) && color.charAt(0) == "#")
               {
                  attr.color = "0x" + color.substring(1);
               }
            }
            else if(p != "display")
            {
               if(p == "kerning")
               {
                  if(Boolean(propStyle))
                  {
                     attr.kerning = Kerning.ON;
                  }
                  else
                  {
                     attr.kerning = Kerning.OFF;
                  }
               }
               else
               {
                  attr[p] = propStyle;
               }
            }
         }
      }
      return attr;
   }
}

class HTMLHelper
{
   
   private static var plainTextImporter:ITextImporter;
   
   private static var plainTextExporter:ITextExporter;
   
   private static var collapsingHTMLImporter:ITextImporter;
   
   private static var preservingHTMLImporter:ITextImporter;
   
   private static var htmlExporter:ITextExporter;
   
   private var textField:FTETextField;
   
   §§namespace("http://www.adobe.com/2006/flex/mx/internal") var explicitHTMLText:String = null;
   
   §§namespace("http://www.adobe.com/2006/flex/mx/internal") var hostFormat:ITextLayoutFormat;
   
   private var textFlow:TextFlow;
   
   private var textContainerManager:TextContainerManager;
   
   §§namespace("http://www.adobe.com/2006/flex/mx/internal") var htmlText:String = null;
   
   §§namespace("http://www.adobe.com/2006/flex/mx/internal") var styleSheet:StyleSheet = null;
   
   public function HTMLHelper(textField:FTETextField)
   {
      super();
      this.textField = textField;
   }
   
   private function get htmlImporter() : ITextImporter
   {
      var format:TextLayoutFormat = null;
      var config:Configuration = null;
      if(this.textField.testFlag(FTETextField.FLAG_EFFECTIVE_CONDENSE_WHITE))
      {
         if(!collapsingHTMLImporter)
         {
            config = new Configuration();
            format = new TextLayoutFormat(config.textFlowInitialFormat);
            format.whiteSpaceCollapse = "collapse";
            config.textFlowInitialFormat = format;
            collapsingHTMLImporter = TextConverter.getImporter(TextConverter.TEXT_FIELD_HTML_FORMAT,config);
            collapsingHTMLImporter.throwOnError = false;
         }
         return collapsingHTMLImporter;
      }
      if(!preservingHTMLImporter)
      {
         config = new Configuration();
         format = new TextLayoutFormat(config.textFlowInitialFormat);
         format.whiteSpaceCollapse = "preserve";
         config.textFlowInitialFormat = format;
         preservingHTMLImporter = TextConverter.getImporter(TextConverter.TEXT_FIELD_HTML_FORMAT,config);
         preservingHTMLImporter.throwOnError = false;
      }
      return preservingHTMLImporter;
   }
   
   public function clearContainerChildren() : void
   {
      if(Boolean(this.textContainerManager))
      {
         this.textContainerManager.clearContainerChildren(true);
         this.textContainerManager.clearComposedLines();
      }
   }
   
   public function composeHTMLText(compositionWidth:Number, compositionHeight:Number) : void
   {
      this.textFlow = this.htmlImporter.importToFlow(this.explicitHTMLText);
      if(!this.styleSheet)
      {
         this.htmlText = null;
      }
      if(!this.textFlow)
      {
         return;
      }
      this.textFlow.addEventListener(MouseEvent.CLICK,this.linkClickHandler);
      this.textFlow.addEventListener(StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGE,this.textField.inlineGraphicStatusChangeHandler);
      if(!this.textContainerManager)
      {
         this.textContainerManager = new FTETextFieldTextContainerManager(this.textField);
      }
      this.textContainerManager.compositionWidth = compositionWidth;
      this.textContainerManager.compositionHeight = compositionHeight;
      this.textContainerManager.editingMode = EditingMode.READ_ONLY;
      this.textContainerManager.hostFormat = this.hostFormat;
      this.textContainerManager.swfContext = this.textField.fontContext as ISWFContext;
      this.textContainerManager.setTextFlow(this.textFlow);
      if(Boolean(this.styleSheet) && !this.textFlow.formatResolver)
      {
         this.textFlow.formatResolver = new FTETextFieldStyleResolver(this.styleSheet);
         this.textContainerManager.beginInteraction();
         this.textContainerManager.endInteraction();
      }
      this.textContainerManager.updateContainer();
      var bounds:Rectangle = this.textContainerManager.getContentBounds();
      this.textField._textWidth = Math.round(bounds.width);
      this.textField._textHeight = Math.round(bounds.height);
      this.textField.clipWidth = this.textField._textWidth;
   }
   
   private function linkClickHandler(event:FlowElementMouseEvent) : void
   {
      var textEvent:TextEvent = null;
      var href:String = LinkElement(event.flowElement).href;
      if(href.indexOf("event:") == 0)
      {
         textEvent = new TextEvent(TextEvent.LINK);
         textEvent.text = href.substring(6);
         this.textField.dispatchEvent(textEvent);
      }
   }
   
   public function getHtmlText(fieldText:String) : String
   {
      if(this.htmlText == null)
      {
         if(fieldText == "")
         {
            this.htmlText = "";
         }
         else
         {
            if(!this.textFlow)
            {
               if(!plainTextImporter)
               {
                  plainTextImporter = TextConverter.getImporter(TextConverter.PLAIN_TEXT_FORMAT);
               }
               this.textFlow = plainTextImporter.importToFlow(fieldText);
            }
            if(!htmlExporter)
            {
               htmlExporter = TextConverter.getExporter(TextConverter.TEXT_FIELD_HTML_FORMAT);
            }
            this.htmlText = String(htmlExporter.export(this.textFlow,ConversionType.STRING_TYPE));
         }
      }
      return this.htmlText;
   }
   
   public function setStyleSheet(value:StyleSheet) : void
   {
      this.styleSheet = value;
      if(Boolean(this.textFlow) && Boolean(this.textFlow.formatResolver))
      {
         this.textFlow.formatResolver = null;
      }
   }
   
   public function getText() : String
   {
      var rslt:String = null;
      if(!this.textFlow)
      {
         this.textFlow = this.htmlImporter.importToFlow(this.htmlText);
      }
      if(!plainTextExporter)
      {
         plainTextExporter = TextConverter.getExporter(TextConverter.PLAIN_TEXT_FORMAT);
      }
      return String(plainTextExporter.export(this.textFlow,ConversionType.STRING_TYPE));
   }
}
