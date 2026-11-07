package blix.assets.proxy
{
   import blix.context.IContext;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextLineMetrics;
   
   [Event(name="textInput",type="flash.events.TextEvent")]
   [Event(name="scroll",type="flash.events.Event")]
   [Event(name="link",type="flash.events.TextEvent")]
   [Event(name="change",type="flash.events.Event")]
   public class TextFieldProxy extends InteractiveObjectProxy
   {
      
      protected var _textField:TextField;
      
      protected var _verticalScrollEnabled:Boolean = true;
      
      protected var _horizontalScrollEnabled:Boolean = true;
      
      public function TextFieldProxy(param1:IContext, param2:TextField = null)
      {
         super(param1,param2);
      }
      
      public function getTextField() : TextField
      {
         return this._textField;
      }
      
      override protected function configureAsset(param1:DisplayObject) : void
      {
         super.configureAsset(param1);
         this._textField = param1 as TextField;
      }
      
      public function getVerticalScrollEnabled() : Boolean
      {
         return this._verticalScrollEnabled;
      }
      
      public function setVerticalScrollEnabled(param1:Boolean) : void
      {
         if(this._verticalScrollEnabled == param1)
         {
            return;
         }
         if(!this._verticalScrollEnabled)
         {
            removeEventListener(Event.SCROLL,this.preventVerticalScrollHandler);
         }
         this._verticalScrollEnabled = param1;
         if(!this._verticalScrollEnabled)
         {
            this.setMouseWheelEnabled(false);
            addEventListener(Event.SCROLL,this.preventVerticalScrollHandler,false,100);
         }
      }
      
      protected function preventVerticalScrollHandler(param1:Event) : void
      {
         this.setScrollV(0);
      }
      
      public function getHorizontalScrollEnabled() : Boolean
      {
         return this._horizontalScrollEnabled;
      }
      
      public function setHorizontalScrollEnabled(param1:Boolean) : void
      {
         if(this._horizontalScrollEnabled == param1)
         {
            return;
         }
         if(!this._horizontalScrollEnabled)
         {
            removeEventListener(Event.SCROLL,this.preventHorizontalScrollHandler);
         }
         this._horizontalScrollEnabled = param1;
         if(!this._horizontalScrollEnabled)
         {
            addEventListener(Event.SCROLL,this.preventHorizontalScrollHandler);
         }
      }
      
      protected function preventHorizontalScrollHandler(param1:Event) : void
      {
         this.setScrollH(0);
      }
      
      public function getAlwaysShowSelection() : Boolean
      {
         return assetProxy.alwaysShowSelection;
      }
      
      public function setAlwaysShowSelection(param1:Boolean) : void
      {
         assetProxy.alwaysShowSelection = param1;
      }
      
      public function getAntiAliasType() : String
      {
         return assetProxy.antiAliasType;
      }
      
      public function setAntiAliasType(param1:String) : void
      {
         assetProxy.antiAliasType = param1;
      }
      
      public function getAutoSize() : String
      {
         return assetProxy.autoSize;
      }
      
      public function setAutoSize(param1:String) : void
      {
         assetProxy.autoSize = param1;
         invalidateLayout();
      }
      
      public function getBackground() : Boolean
      {
         return assetProxy.background;
      }
      
      public function setBackground(param1:Boolean) : void
      {
         assetProxy.background = param1;
      }
      
      public function getBackgroundColor() : uint
      {
         return assetProxy.backgroundColor;
      }
      
      public function setBackgroundColor(param1:uint) : void
      {
         assetProxy.backgroundColor = param1;
      }
      
      public function getBorder() : Boolean
      {
         return assetProxy.border;
      }
      
      public function setBorder(param1:Boolean) : void
      {
         assetProxy.border = param1;
      }
      
      public function getBorderColor() : uint
      {
         return assetProxy.borderColor;
      }
      
      public function setBorderColor(param1:uint) : void
      {
         assetProxy.borderColor = param1;
      }
      
      public function getBottomScrollV() : int
      {
         return assetProxy.bottomScrollV;
      }
      
      public function getCaretIndex() : int
      {
         return assetProxy.caretIndex;
      }
      
      public function getCondenseWhite() : Boolean
      {
         return assetProxy.condenseWhite;
      }
      
      public function setCondenseWhite(param1:Boolean) : void
      {
         assetProxy.condenseWhite = param1;
      }
      
      public function getDefaultTextFormat() : TextFormat
      {
         return assetProxy.defaultTextFormat;
      }
      
      public function setDefaultTextFormat(param1:TextFormat) : void
      {
         assetProxy.defaultTextFormat = param1;
      }
      
      public function getDisplayAsPassword() : Boolean
      {
         return assetProxy.displayAsPassword;
      }
      
      public function setDisplayAsPassword(param1:Boolean) : void
      {
         assetProxy.displayAsPassword = param1;
      }
      
      public function getEmbedFonts() : Boolean
      {
         return assetProxy.embedFonts;
      }
      
      public function setEmbedFonts(param1:Boolean) : void
      {
         assetProxy.embedFonts = param1;
      }
      
      public function getGridFitType() : String
      {
         return assetProxy.gridFitType;
      }
      
      public function setGridFitType(param1:String) : void
      {
         assetProxy.gridFitType = param1;
      }
      
      public function getHtmlText() : String
      {
         return assetProxy.htmlText;
      }
      
      public function setHtmlText(param1:String) : void
      {
         delete assetProxy["text"];
         assetProxy.htmlText = param1 || "";
         invalidateLayout();
      }
      
      public function getLength() : int
      {
         return assetProxy.length;
      }
      
      public function getMaxChars() : int
      {
         return assetProxy.maxChars;
      }
      
      public function setMaxChars(param1:int) : void
      {
         assetProxy.maxChars = param1;
         invalidateLayout();
      }
      
      public function getMaxScrollH() : int
      {
         return assetProxy.maxScrollH;
      }
      
      public function getMaxScrollV() : int
      {
         return assetProxy.maxScrollV;
      }
      
      public function getMouseWheelEnabled() : Boolean
      {
         return assetProxy.mouseWheelEnabled;
      }
      
      public function setMouseWheelEnabled(param1:Boolean) : void
      {
         assetProxy.mouseWheelEnabled = param1;
      }
      
      public function getMultiline() : Boolean
      {
         return assetProxy.multiline;
      }
      
      public function setMultiline(param1:Boolean) : void
      {
         assetProxy.multiline = param1;
         invalidateLayout();
      }
      
      public function getNumLines() : int
      {
         return assetProxy.numLines;
      }
      
      public function getRestrict() : String
      {
         return assetProxy.restrict;
      }
      
      public function setRestrict(param1:String) : void
      {
         assetProxy.restrict = param1;
      }
      
      public function getScrollH() : int
      {
         return assetProxy.scrollH;
      }
      
      public function setScrollH(param1:int) : void
      {
         assetProxy.scrollH = param1;
      }
      
      public function getScrollV() : int
      {
         return assetProxy.scrollV;
      }
      
      public function setScrollV(param1:int) : void
      {
         assetProxy.scrollV = param1;
      }
      
      public function getSelectable() : Boolean
      {
         return assetProxy.selectable;
      }
      
      public function setSelectable(param1:Boolean) : void
      {
         assetProxy.selectable = param1;
      }
      
      public function getSelectionBeginIndex() : int
      {
         return assetProxy.selectionBeginIndex;
      }
      
      public function getSelectionEndIndex() : int
      {
         return assetProxy.selectionEndIndex;
      }
      
      public function getSharpness() : Number
      {
         return assetProxy.sharpness;
      }
      
      public function setSharpness(param1:Number) : void
      {
         assetProxy.sharpness = param1;
      }
      
      public function getStyleSheet() : StyleSheet
      {
         return assetProxy.styleSheet;
      }
      
      public function setStyleSheet(param1:StyleSheet) : void
      {
         assetProxy.styleSheet = param1;
         invalidateLayout();
      }
      
      public function getText() : String
      {
         return assetProxy.text;
      }
      
      public function setText(param1:String) : void
      {
         delete assetProxy["htmlText"];
         assetProxy.text = param1 || "";
         invalidateLayout();
      }
      
      public function getTextColor() : uint
      {
         return assetProxy.textColor;
      }
      
      public function setTextColor(param1:uint) : void
      {
         assetProxy.textColor = param1;
      }
      
      public function getTextHeight() : Number
      {
         return assetProxy.textHeight;
      }
      
      public function getTextWidth() : Number
      {
         return assetProxy.textWidth;
      }
      
      public function getThickness() : Number
      {
         return assetProxy.thickness;
      }
      
      public function setThickness(param1:Number) : void
      {
         assetProxy.thickness = param1;
      }
      
      public function getType() : String
      {
         return assetProxy.type;
      }
      
      public function setType(param1:String) : void
      {
         assetProxy.type = param1;
      }
      
      public function getUseRichTextClipboard() : Boolean
      {
         return assetProxy.useRichTextClipboard;
      }
      
      public function setUseRichTextClipboard(param1:Boolean) : void
      {
         assetProxy.useRichTextClipboard = param1;
      }
      
      public function getWordWrap() : Boolean
      {
         return assetProxy.wordWrap;
      }
      
      public function setWordWrap(param1:Boolean) : void
      {
         assetProxy.wordWrap = param1;
         invalidateLayout();
      }
      
      public function appendText(param1:String) : void
      {
         if(this._textField == null)
         {
            addPendingCall("appendText",[param1]);
            return;
         }
         this._textField.appendText(param1);
         invalidateLayout();
      }
      
      public function getCharBoundaries(param1:int) : Rectangle
      {
         if(this._textField == null)
         {
            return null;
         }
         return this._textField.getCharBoundaries(param1);
      }
      
      public function getCharIndexAtPoint(param1:Number, param2:Number) : int
      {
         if(this._textField == null)
         {
            return 0;
         }
         return this._textField.getCharIndexAtPoint(param1,param2);
      }
      
      public function getFirstCharInParagraph(param1:int) : int
      {
         if(this._textField == null)
         {
            return 0;
         }
         return this._textField.getFirstCharInParagraph(param1);
      }
      
      public function getImageReference(param1:String) : DisplayObject
      {
         if(this._textField == null)
         {
            return null;
         }
         return this._textField.getImageReference(param1);
      }
      
      public function getLineIndexAtPoint(param1:Number, param2:Number) : int
      {
         if(this._textField == null)
         {
            return 0;
         }
         return this._textField.getLineIndexAtPoint(param1,param2);
      }
      
      public function getLineIndexOfChar(param1:int) : int
      {
         if(this._textField == null)
         {
            return 0;
         }
         return this._textField.getLineIndexOfChar(param1);
      }
      
      public function getLineLength(param1:int) : int
      {
         if(this._textField == null)
         {
            return 0;
         }
         return this._textField.getLineLength(param1);
      }
      
      public function getLineMetrics(param1:int) : TextLineMetrics
      {
         if(this._textField == null)
         {
            return null;
         }
         return this._textField.getLineMetrics(param1);
      }
      
      public function getLineOffset(param1:int) : int
      {
         if(this._textField == null)
         {
            return 0;
         }
         return this._textField.getLineOffset(param1);
      }
      
      public function getLineText(param1:int) : String
      {
         if(this._textField == null)
         {
            return null;
         }
         return this._textField.getLineText(param1);
      }
      
      public function getParagraphLength(param1:int) : int
      {
         if(this._textField == null)
         {
            return 0;
         }
         return this._textField.getParagraphLength(param1);
      }
      
      public function getTextFormat(param1:int = -1, param2:int = -1) : TextFormat
      {
         if(this._textField == null)
         {
            return null;
         }
         return this._textField.getTextFormat(param1,param2);
      }
      
      public function replaceSelectedText(param1:String) : void
      {
         if(this._textField == null)
         {
            addPendingCall("replaceSelectedText",[param1]);
            return;
         }
         this._textField.replaceSelectedText(param1);
         invalidateLayout();
      }
      
      public function replaceText(param1:int, param2:int, param3:String) : void
      {
         if(this._textField == null)
         {
            addPendingCall("replaceText",[param1,param2,param3]);
            return;
         }
         this._textField.replaceText(param1,param2,param3);
         invalidateLayout();
      }
      
      public function setSelection(param1:int, param2:int) : void
      {
         if(this._textField == null)
         {
            addPendingCall("setSelection",[param1,param2]);
            return;
         }
         this._textField.setSelection(param1,param2);
      }
      
      public function setTextFormat(param1:TextFormat, param2:int = -1, param3:int = -1) : void
      {
         if(this._textField == null)
         {
            addPendingCall("setTextFormat",[param1,param2,param3]);
            return;
         }
         this._textField.setTextFormat(param1,param2,param3);
         invalidateLayout();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         if(!isNaN(param1))
         {
            setWidth(param1);
         }
         if(!isNaN(param2))
         {
            setHeight(param2);
         }
         return _asset.getBounds(null);
      }
   }
}

