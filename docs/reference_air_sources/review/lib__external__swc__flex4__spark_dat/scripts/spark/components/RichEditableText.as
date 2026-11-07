package spark.components
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.system.IME;
   import flash.system.IMEConversionMode;
   import flash.text.engine.ElementFormat;
   import flash.text.engine.FontDescription;
   import flash.text.engine.FontLookup;
   import flash.text.engine.TextBlock;
   import flash.text.engine.TextElement;
   import flash.text.engine.TextLine;
   import flash.ui.Keyboard;
   import flashx.textLayout.compose.ISWFContext;
   import flashx.textLayout.container.TextContainerManager;
   import flashx.textLayout.conversion.ConversionType;
   import flashx.textLayout.conversion.ITextExporter;
   import flashx.textLayout.conversion.ITextImporter;
   import flashx.textLayout.conversion.TextConverter;
   import flashx.textLayout.edit.EditManager;
   import flashx.textLayout.edit.EditingMode;
   import flashx.textLayout.edit.IEditManager;
   import flashx.textLayout.edit.ISelectionManager;
   import flashx.textLayout.edit.SelectionState;
   import flashx.textLayout.elements.Configuration;
   import flashx.textLayout.elements.GlobalSettings;
   import flashx.textLayout.elements.InlineGraphicElementStatus;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.events.CompositionCompleteEvent;
   import flashx.textLayout.events.DamageEvent;
   import flashx.textLayout.events.FlowOperationEvent;
   import flashx.textLayout.events.SelectionEvent;
   import flashx.textLayout.events.StatusChangeEvent;
   import flashx.textLayout.factory.StringTextLineFactory;
   import flashx.textLayout.factory.TextFlowTextLineFactory;
   import flashx.textLayout.formats.BlockProgression;
   import flashx.textLayout.formats.Category;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.operations.CopyOperation;
   import flashx.textLayout.operations.CutOperation;
   import flashx.textLayout.operations.DeleteTextOperation;
   import flashx.textLayout.operations.FlowOperation;
   import flashx.textLayout.operations.FlowTextOperation;
   import flashx.textLayout.operations.InsertTextOperation;
   import flashx.textLayout.operations.PasteOperation;
   import flashx.undo.IUndoManager;
   import mx.core.FlexVersion;
   import mx.core.IFlexModuleFactory;
   import mx.core.IIMESupport;
   import mx.core.ISystemCursorClient;
   import mx.core.UIComponent;
   import mx.events.FlexEvent;
   import mx.managers.IFocusManager;
   import mx.managers.IFocusManagerComponent;
   import mx.utils.StringUtil;
   import spark.components.supportClasses.RichEditableTextContainerManager;
   import spark.core.CSSTextLayoutFormat;
   import spark.core.IEditableText;
   import spark.core.IViewport;
   import spark.core.NavigationUnit;
   import spark.events.TextOperationEvent;
   import spark.utils.TextUtil;
   
   [DiscouragedForProfile("mobileDevice")]
   [DefaultTriggerEvent("change")]
   [IconFile("RichEditableText.png")]
   [DefaultProperty("content")]
   [AccessibilityClass(implementation="spark.accessibility.RichEditableTextAccImpl")]
   [Exclude(name="chromeColor",kind="style")]
   [Style(name="backgroundColor",type="uint",format="Color",inherit="no")]
   [Style(name="backgroundAlpha",type="Number",inherit="no")]
   [Style(name="unfocusedTextSelectionColor",type="uint",format="Color",inherit="yes")]
   [Style(name="inactiveTextSelectionColor",type="uint",format="Color",inherit="yes")]
   [Style(name="focusedTextSelectionColor",type="uint",format="Color",inherit="yes")]
   [Style(name="columnWidth",type="Object",inherit="no")]
   [Style(name="columnGap",type="Number",format="Length",inherit="no")]
   [Style(name="columnCount",type="Object",inherit="no")]
   [Style(name="wordSpacing",type="Object",inherit="yes")]
   [Style(name="whiteSpaceCollapse",type="String",enumeration="collapse,preserve",inherit="yes")]
   [Style(name="textRotation",type="String",enumeration="auto,rotate0,rotate90,rotate180,rotate270",inherit="yes")]
   [Style(name="textIndent",type="Number",format="Length",inherit="yes",minValue="0.0")]
   [Style(name="tabStops",type="String",inherit="yes")]
   [Style(name="paragraphStartIndent",type="Number",format="length",inherit="yes")]
   [Style(name="paragraphSpaceBefore",type="Number",format="length",inherit="yes",minValue="0.0")]
   [Style(name="paragraphSpaceAfter",type="Number",format="length",inherit="yes",minValue="0.0")]
   [Style(name="paragraphEndIndent",type="Number",format="length",inherit="yes",minValue="0.0")]
   [Style(name="listStyleType",type="String",enumeration="upperAlpha,lowerAlpha,upperRoman,lowerRoman,none,disc,circle,square,box,check,diamond,hyphen,arabicIndic,bengali,decimal,decimalLeadingZero,devanagari,gujarati,gurmukhi,kannada,persian,thai,urdu,cjkEarthlyBranch,cjkHeavenlyStem,hangul,hangulConstant,hiragana,hiraganaIroha,katakana,katakanaIroha,lowerGreek,lowerLatin,upperGreek,upperLatin",inherit="yes")]
   [Style(name="listStylePosition",type="String",enumeration="inside,outside",inherit="yes")]
   [Style(name="listAutoPadding",type="Number",format="length",inherit="yes",minValue="-1000",maxValue="1000")]
   [Style(name="leadingModel",type="String",enumeration="auto,romanUp,ideographicTopUp,ideographicCenterUp,ideographicTopDown,ideographicCenterDown,ascentDescentUp,box",inherit="yes")]
   [Style(name="firstBaselineOffset",type="Object",inherit="yes")]
   [Style(name="clearFloats",type="String",enumeration="start,end,left,right,both,none",inherit="yes")]
   [Style(name="breakOpportunity",type="String",enumeration="auto,all,any,none",inherit="yes")]
   [Style(name="blockProgression",type="String",enumeration="tb,rl",inherit="yes")]
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
   [Event(name="enter",type="mx.events.FlexEvent")]
   [Event(name="change",type="spark.events.TextOperationEvent")]
   [Event(name="changing",type="spark.events.TextOperationEvent")]
   [Event(name="selectionChange",type="mx.events.FlexEvent")]
   public class RichEditableText extends UIComponent implements IFocusManagerComponent, IIMESupport, ISystemCursorClient, IViewport, IEditableText
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      private static var staticStringFactory:StringTextLineFactory;
      
      private static var staticTextFlowFactory:TextFlowTextLineFactory;
      
      private static var staticPlainTextImporter:ITextImporter;
      
      private static var staticPlainTextExporter:ITextExporter;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var classInitialized:Boolean = false;
      
      private static const ALL_NEWLINES_REGEXP:RegExp = /\n/g;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var unbounded:Rectangle = new Rectangle(0,0,NaN,NaN);
      
      private var hostFormatChanged:Boolean;
      
      private var ascent:Number = NaN;
      
      private var descent:Number = NaN;
      
      private var source:String = "text";
      
      private var lastGeneration:uint = 0;
      
      private var lastContentBoundsGeneration:int = 0;
      
      private var dispatchChangeAndChangingEvents:Boolean = true;
      
      private var inMeasureMethod:Boolean = false;
      
      private var inUpdateDLMethod:Boolean = false;
      
      private var remeasuringText:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var preserveSelectionOnSetText:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var passwordChar:String = "*";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var undoManager:IUndoManager;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var clearUndoOnFocusOut:Boolean = true;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var embeddedFontContext:IFlexModuleFactory;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var batchTextInput:Boolean = true;
      
      private var mouseDown:Boolean = false;
      
      private var priorEditingMode:String;
      
      private var widthConstraint:Number = NaN;
      
      private var heightConstraint:Number = NaN;
      
      private var hasProgrammaticSelectionRange:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var autoSize:Boolean = false;
      
      private var lastMeasuredWidth:Number = NaN;
      
      private var lastMeasuredHeight:Number = NaN;
      
      private var lastUnscaledWidth:Number;
      
      private var lastUnscaledHeight:Number;
      
      private var enabledChanged:Boolean = false;
      
      private var _clipAndEnableScrolling:Boolean = false;
      
      private var clipAndEnableScrollingChanged:Boolean = false;
      
      private var _contentHeight:Number = 0;
      
      private var _contentWidth:Number = 0;
      
      private var _horizontalScrollPosition:Number = 0;
      
      private var horizontalScrollPositionChanged:Boolean = false;
      
      private var _verticalScrollPosition:Number = 0;
      
      private var verticalScrollPositionChanged:Boolean = false;
      
      private var _content:Object;
      
      private var contentChanged:Boolean = false;
      
      private var _displayAsPassword:Boolean = false;
      
      private var displayAsPasswordChanged:Boolean = false;
      
      private var _editable:Boolean = true;
      
      private var editableChanged:Boolean = false;
      
      private var _heightInLines:Number = NaN;
      
      private var heightInLinesChanged:Boolean = false;
      
      private var _imeMode:String = null;
      
      private var _maxChars:int = 0;
      
      private var _multiline:Boolean = true;
      
      private var _restrict:String = null;
      
      private var _selectable:Boolean = true;
      
      private var selectableChanged:Boolean = false;
      
      private var _selectionActivePosition:int = -1;
      
      private var _selectionAnchorPosition:int = -1;
      
      private var _selectionHighlighting:String = "whenFocused";
      
      private var selectionFormatsChanged:Boolean = false;
      
      private var _text:String = "";
      
      private var textChanged:Boolean = false;
      
      private var _textContainerManager:RichEditableTextContainerManager;
      
      private var _textFlow:TextFlow;
      
      private var textFlowChanged:Boolean = false;
      
      private var typicalTextChanged:Boolean;
      
      private var _typicalText:String;
      
      private var _typicalTextFlow:TextFlow;
      
      private var _widthInChars:Number = NaN;
      
      private var widthInCharsChanged:Boolean = true;
      
      public function RichEditableText()
      {
         super();
         initClass();
         this.text = "";
         this._textContainerManager = this.createTextContainerManager();
         addEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStageHandler);
         this._textContainerManager.addEventListener(CompositionCompleteEvent.COMPOSITION_COMPLETE,this.textContainerManager_compositionCompleteHandler);
         this._textContainerManager.addEventListener(DamageEvent.DAMAGE,this.textContainerManager_damageHandler);
         this._textContainerManager.addEventListener(Event.SCROLL,this.textContainerManager_scrollHandler);
         this._textContainerManager.addEventListener(SelectionEvent.SELECTION_CHANGE,this.textContainerManager_selectionChangeHandler);
         this._textContainerManager.addEventListener(FlowOperationEvent.FLOW_OPERATION_BEGIN,this.textContainerManager_flowOperationBeginHandler);
         this._textContainerManager.addEventListener(FlowOperationEvent.FLOW_OPERATION_END,this.textContainerManager_flowOperationEndHandler);
         this._textContainerManager.addEventListener(FlowOperationEvent.FLOW_OPERATION_COMPLETE,this.textContainerManager_flowOperationCompleteHandler);
         this._textContainerManager.addEventListener(StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGE,this.textContainerManager_inlineGraphicStatusChangeHandler);
      }
      
      private static function initClass() : void
      {
         if(classInitialized)
         {
            return;
         }
         GlobalSettings.resourceStringFunction = TextUtil.getResourceString;
         GlobalSettings.resolveFontLookupFunction = TextUtil.resolveFontLookup;
         GlobalSettings.enableDefaultTabStops = !Configuration.playerEnablesArgoFeatures;
         staticPlainTextImporter = TextConverter.getImporter(TextConverter.PLAIN_TEXT_FORMAT);
         staticPlainTextImporter.throwOnError = true;
         staticPlainTextExporter = TextConverter.getExporter(TextConverter.PLAIN_TEXT_FORMAT);
         classInitialized = true;
      }
      
      public static function getNumberOrPercentOf(value:Object, n:Number) : Number
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
      
      private static function splice(str:String, start:int, end:int, strToInsert:String) : String
      {
         return str.substring(0,start) + strToInsert + str.substring(end,str.length);
      }
      
      override public function get baselinePosition() : Number
      {
         return getStyle("paddingTop") + this.ascent;
      }
      
      override public function set enabled(value:Boolean) : void
      {
         if(value == super.enabled)
         {
            return;
         }
         super.enabled = value;
         this.enabledChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      override public function set explicitHeight(value:Number) : void
      {
         super.explicitHeight = value;
         this.heightConstraint = NaN;
         invalidateSize();
         invalidateDisplayList();
      }
      
      override public function set explicitWidth(value:Number) : void
      {
         super.explicitWidth = value;
         this.widthConstraint = NaN;
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get isTruncated() : Boolean
      {
         return false;
      }
      
      override public function set percentHeight(value:Number) : void
      {
         super.percentHeight = value;
         this.heightConstraint = NaN;
         invalidateSize();
         invalidateDisplayList();
      }
      
      override public function set percentWidth(value:Number) : void
      {
         super.percentWidth = value;
         this.widthConstraint = NaN;
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get showSystemCursor() : Boolean
      {
         return this.editable;
      }
      
      public function get clipAndEnableScrolling() : Boolean
      {
         return this._clipAndEnableScrolling;
      }
      
      public function set clipAndEnableScrolling(value:Boolean) : void
      {
         if(value == this._clipAndEnableScrolling)
         {
            return;
         }
         this._clipAndEnableScrolling = value;
         this.clipAndEnableScrollingChanged = true;
         invalidateProperties();
      }
      
      [Bindable("propertyChange")]
      public function get contentHeight() : Number
      {
         return this._contentHeight;
      }
      
      [Bindable("propertyChange")]
      public function get contentWidth() : Number
      {
         return this._contentWidth;
      }
      
      [Inspectable(defaultValue="0",minValue="0.0")]
      [Bindable("propertyChange")]
      public function get horizontalScrollPosition() : Number
      {
         return this._horizontalScrollPosition;
      }
      
      public function set horizontalScrollPosition(value:Number) : void
      {
         if(isNaN(value))
         {
            value = 0;
         }
         if(value == this._horizontalScrollPosition)
         {
            return;
         }
         this._horizontalScrollPosition = value;
         this.horizontalScrollPositionChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(defaultValue="0",minValue="0.0")]
      [Bindable("propertyChange")]
      public function get verticalScrollPosition() : Number
      {
         return this._verticalScrollPosition;
      }
      
      public function set verticalScrollPosition(value:Number) : void
      {
         if(isNaN(value))
         {
            value = 0;
         }
         if(value == this._verticalScrollPosition)
         {
            return;
         }
         this._verticalScrollPosition = value;
         this.verticalScrollPositionChanged = true;
         invalidateProperties();
      }
      
      [RichTextContent]
      public function get content() : Object
      {
         return this.textFlow;
      }
      
      public function set content(value:Object) : void
      {
         if(value == null)
         {
            this.text = "";
            return;
         }
         if(value == this._content)
         {
            return;
         }
         this._content = value;
         this.contentChanged = true;
         this.source = "content";
         this.textChanged = false;
         this.textFlowChanged = false;
         this._text = null;
         this._textFlow = null;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      [Inspectable(category="General",defaultValue="false")]
      public function get displayAsPassword() : Boolean
      {
         return this._displayAsPassword;
      }
      
      public function set displayAsPassword(value:Boolean) : void
      {
         if(value == this._displayAsPassword)
         {
            return;
         }
         this._displayAsPassword = value;
         this.displayAsPasswordChanged = true;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get editable() : Boolean
      {
         return this._editable;
      }
      
      public function set editable(value:Boolean) : void
      {
         if(value == this._editable)
         {
            return;
         }
         this._editable = value;
         this.editableChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      [Inspectable(category="General",defaultValue="readWrite",enumeration="readOnly,readWrite,readSelect")]
      private function get editingMode() : String
      {
         if(this.enabledChanged || this.editableChanged || this.selectableChanged)
         {
            this.updateEditingMode();
            this.enabledChanged = false;
            this.editableChanged = false;
            this.selectableChanged = false;
         }
         return this._textContainerManager.editingMode;
      }
      
      private function set editingMode(value:String) : void
      {
         var selectionManager:ISelectionManager = null;
         var lastEditingMode:String = this._textContainerManager.editingMode;
         if(lastEditingMode == value)
         {
            return;
         }
         this._textContainerManager.editingMode = value;
         if(value != EditingMode.READ_ONLY && this._selectionAnchorPosition != -1 && this._selectionActivePosition != -1)
         {
            selectionManager = this._textContainerManager.beginInteraction();
            selectionManager.selectRange(this._selectionAnchorPosition,this._selectionActivePosition);
            this._textContainerManager.endInteraction();
         }
      }
      
      public function get enableIME() : Boolean
      {
         return this.editable && !this.displayAsPassword;
      }
      
      [Inspectable(category="General",minValue="0.0")]
      public function get heightInLines() : Number
      {
         return this._heightInLines;
      }
      
      public function set heightInLines(value:Number) : void
      {
         if(value == this._heightInLines)
         {
            return;
         }
         this._heightInLines = value;
         this.heightInLinesChanged = true;
         this.heightConstraint = NaN;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get imeMode() : String
      {
         return this._imeMode;
      }
      
      public function set imeMode(value:String) : void
      {
         this._imeMode = value;
      }
      
      [Inspectable(environment="none")]
      public function get lineBreak() : String
      {
         return getStyle("lineBreak");
      }
      
      public function set lineBreak(value:String) : void
      {
         setStyle("lineBreak",value);
      }
      
      [Inspectable(category="General",defaultValue="0")]
      public function get maxChars() : int
      {
         return this._maxChars;
      }
      
      public function set maxChars(value:int) : void
      {
         this._maxChars = value;
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get multiline() : Boolean
      {
         return this._multiline;
      }
      
      public function set multiline(value:Boolean) : void
      {
         this._multiline = value;
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get restrict() : String
      {
         return this._restrict;
      }
      
      public function set restrict(value:String) : void
      {
         this._restrict = value;
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get selectable() : Boolean
      {
         return this._selectable;
      }
      
      public function set selectable(value:Boolean) : void
      {
         if(value == this._selectable)
         {
            return;
         }
         this._selectable = value;
         this.selectableChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      [Inspectable(category="General",defaultValue="-1")]
      [Bindable("selectionChange")]
      public function get selectionActivePosition() : int
      {
         return this._selectionActivePosition;
      }
      
      [Inspectable(category="General",defaultValue="-1")]
      [Bindable("selectionChange")]
      public function get selectionAnchorPosition() : int
      {
         return this._selectionAnchorPosition;
      }
      
      [Inspectable(category="General",enumeration="always,whenActive,whenFocused",defaultValue="whenFocused")]
      public function get selectionHighlighting() : String
      {
         return this._selectionHighlighting;
      }
      
      public function set selectionHighlighting(value:String) : void
      {
         if(value == this._selectionHighlighting)
         {
            return;
         }
         this._selectionHighlighting = value;
         this.selectionFormatsChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      [Inspectable(category="General",defaultValue="")]
      [Bindable("change")]
      public function get text() : String
      {
         if(Boolean(this._textContainerManager && !this.textChanged && !this.textFlowChanged) && Boolean(!this.contentChanged) && !this.displayAsPassword)
         {
            return this._textContainerManager.getText("\n");
         }
         if(this._text == null)
         {
            if(this._content != null)
            {
               this._textFlow = this.createTextFlowFromContent(this._content);
            }
            this._text = staticPlainTextExporter.export(this._textFlow,ConversionType.STRING_TYPE) as String;
         }
         return this._text;
      }
      
      public function set text(value:String) : void
      {
         if(value == null)
         {
            value = "";
         }
         if(this.source == "text" && this.text == value)
         {
            return;
         }
         this._text = value;
         this.textChanged = true;
         this.source = "text";
         this.textFlowChanged = false;
         this.contentChanged = false;
         this._textFlow = null;
         this._content = null;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get textContainerManager() : TextContainerManager
      {
         return this._textContainerManager;
      }
      
      public function get textFlow() : TextFlow
      {
         if(!this._textFlow)
         {
            if(this._content != null)
            {
               this._textFlow = this.createTextFlowFromContent(this._content);
               this._content = null;
            }
            else
            {
               this._textFlow = staticPlainTextImporter.importToFlow(this._text);
            }
            this.textFlowChanged = true;
         }
         if(this.textChanged || this.contentChanged || this.textFlowChanged)
         {
            this._textContainerManager.setTextFlow(this._textFlow);
            this.textChanged = this.contentChanged = this.textFlowChanged = false;
         }
         if(this.editingMode != EditingMode.READ_ONLY)
         {
            this._textContainerManager.beginInteraction();
            this._textContainerManager.endInteraction();
         }
         return this._textFlow;
      }
      
      public function set textFlow(value:TextFlow) : void
      {
         if(value == null)
         {
            this.text = "";
            return;
         }
         if(value == this._textFlow)
         {
            return;
         }
         this._textFlow = value;
         this.textFlowChanged = true;
         this.source = "textFlow";
         this.textChanged = false;
         this.contentChanged = false;
         this._text = null;
         this._content = null;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get typicalText() : String
      {
         return this._typicalText;
      }
      
      public function set typicalText(value:String) : void
      {
         if(value == this._typicalText)
         {
            return;
         }
         this._typicalText = value;
         this.typicalTextChanged = true;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      [Inspectable(category="General",minValue="0.0")]
      public function get widthInChars() : Number
      {
         return this._widthInChars;
      }
      
      public function set widthInChars(value:Number) : void
      {
         if(value == this._widthInChars)
         {
            return;
         }
         this._widthInChars = value;
         this.widthInCharsChanged = true;
         this.widthConstraint = NaN;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      override protected function initializeAccessibility() : void
      {
         if(RichEditableText.createAccessibilityImplementation != null)
         {
            RichEditableText.createAccessibilityImplementation(this);
         }
      }
      
      override public function parentChanged(p:DisplayObjectContainer) : void
      {
         if(Boolean(focusManager))
         {
            focusManager.removeEventListener(FlexEvent.FLEX_WINDOW_ACTIVATE,this._textContainerManager.activateHandler);
            focusManager.removeEventListener(FlexEvent.FLEX_WINDOW_DEACTIVATE,this._textContainerManager.deactivateHandler);
         }
         super.parentChanged(p);
         if(Boolean(focusManager))
         {
            this.addActivateHandlers();
         }
         else if(Boolean(systemManager))
         {
            systemManager.getSandboxRoot().addEventListener(FlexEvent.ADD_FOCUS_MANAGER,this.addFocusManagerHandler,true,0,true);
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
         }
      }
      
      override public function removeChild(child:DisplayObject) : DisplayObject
      {
         if(!child.parent)
         {
            return child;
         }
         if(child.parent == this)
         {
            return super.removeChild(child);
         }
         return child.parent.removeChild(child);
      }
      
      override protected function commitProperties() : void
      {
         var textToDisplay:String = null;
         var selManager:ISelectionManager = null;
         var oldHorizontalScrollPosition:Number = NaN;
         var oldVerticalScrollPosition:Number = NaN;
         super.commitProperties();
         this.updateStylesIfChanged();
         var oldAnchorPosition:int = this._selectionAnchorPosition;
         var oldActivePosition:int = this._selectionActivePosition;
         if(this.enabledChanged || this.selectableChanged || this.editableChanged)
         {
            this.updateEditingMode();
            this.enabledChanged = false;
            this.editableChanged = false;
            this.selectableChanged = false;
         }
         if(this.textChanged)
         {
            if(FlexVersion.compatibilityVersion > FlexVersion.VERSION_4_5)
            {
               this.preserveSelectionOnSetText = true;
            }
            if(this._text.indexOf("\n") != -1 || this._text.indexOf("\r") != -1)
            {
               this._textFlow = staticPlainTextImporter.importToFlow(this._text);
               this._textContainerManager.setTextFlow(this._textFlow);
            }
            else
            {
               this._textContainerManager.setText(this._text);
            }
         }
         else if(this.textFlowChanged)
         {
            this._textContainerManager.setTextFlow(this._textFlow);
         }
         else if(this.contentChanged)
         {
            this._textFlow = this.createTextFlowFromContent(this._content);
            this._textContainerManager.setTextFlow(this._textFlow);
            this._content = null;
         }
         if(this.textChanged || this.textFlowChanged || this.contentChanged)
         {
            this.lastGeneration = Boolean(this._textFlow) ? uint(this._textFlow.generation) : 0;
            this.lastContentBoundsGeneration = 0;
            if(this.displayAsPassword)
            {
               this.displayAsPasswordChanged = true;
            }
            this.widthConstraint = NaN;
            this.heightConstraint = NaN;
            this.textChanged = false;
            this.textFlowChanged = false;
            this.contentChanged = false;
            invalidateSize();
            invalidateDisplayList();
         }
         if(this.displayAsPasswordChanged)
         {
            this.preserveSelectionOnSetText = true;
            if(this.displayAsPassword)
            {
               this._text = this._textContainerManager.getText("\n");
               textToDisplay = StringUtil.repeat(this.passwordChar,this._text.length);
               this._textContainerManager.setText(textToDisplay);
            }
            else
            {
               this._textContainerManager.setText(this._text);
            }
            this._textFlow = null;
            this.lastGeneration = 0;
            this.lastContentBoundsGeneration = 0;
            this.displayAsPasswordChanged = false;
         }
         if(this.preserveSelectionOnSetText)
         {
            this.preserveSelectionOnSetText = false;
            if(oldAnchorPosition != -1)
            {
               selManager = this._textContainerManager.beginInteraction();
               if(Boolean(selManager))
               {
                  selManager.selectRange(oldAnchorPosition,oldActivePosition);
                  this._textContainerManager.endInteraction();
               }
            }
         }
         if(this.clipAndEnableScrollingChanged)
         {
            this._textContainerManager.horizontalScrollPolicy = "auto";
            this._textContainerManager.verticalScrollPolicy = "auto";
            this.clipAndEnableScrollingChanged = false;
         }
         if(this.horizontalScrollPositionChanged)
         {
            oldHorizontalScrollPosition = Number(this._textContainerManager.horizontalScrollPosition);
            this._textContainerManager.horizontalScrollPosition = this._horizontalScrollPosition;
            dispatchPropertyChangeEvent("horizontalScrollPosition",oldHorizontalScrollPosition,this._horizontalScrollPosition);
            this.horizontalScrollPositionChanged = false;
         }
         if(this.verticalScrollPositionChanged)
         {
            oldVerticalScrollPosition = Number(this._textContainerManager.verticalScrollPosition);
            this._textContainerManager.verticalScrollPosition = this._verticalScrollPosition;
            dispatchPropertyChangeEvent("verticalScrollPosition",oldVerticalScrollPosition,this._verticalScrollPosition);
            this.verticalScrollPositionChanged = false;
         }
      }
      
      override protected function canSkipMeasurement() : Boolean
      {
         this.autoSize = false;
         return super.canSkipMeasurement();
      }
      
      override protected function measure() : void
      {
         var bounds:Rectangle = null;
         var composeWidth:Number = NaN;
         var composeHeight:Number = NaN;
         this.inMeasureMethod = true;
         this.lastMeasuredWidth = measuredWidth;
         this.lastMeasuredHeight = measuredHeight;
         super.measure();
         this.updateStylesIfChanged();
         if(this.isMeasureFixed())
         {
            this.autoSize = false;
            if(Boolean(this.typicalText))
            {
               if(this.typicalTextChanged)
               {
                  if(this._typicalText.indexOf("\n") != -1 || this._typicalText.indexOf("\r") != -1)
                  {
                     this._typicalTextFlow = staticPlainTextImporter.importToFlow(this._typicalText);
                     this._typicalTextFlow.hostFormat = this._textContainerManager.hostFormat;
                  }
                  else
                  {
                     this._typicalTextFlow = null;
                  }
                  this.typicalTextChanged = false;
               }
               if(Boolean(this._typicalTextFlow))
               {
                  if(!staticTextFlowFactory)
                  {
                     staticTextFlowFactory = new TextFlowTextLineFactory();
                     staticTextFlowFactory.compositionBounds = this.unbounded;
                  }
                  if(Boolean(this._typicalTextFlow.flowComposer))
                  {
                     this._typicalTextFlow.flowComposer.swfContext = ISWFContext(this.embeddedFontContext);
                  }
                  staticTextFlowFactory.swfContext = ISWFContext(this.embeddedFontContext);
                  staticTextFlowFactory.createTextLines(this.tossTextLine,this._typicalTextFlow);
                  bounds = staticTextFlowFactory.getContentBounds();
               }
               else
               {
                  if(!staticStringFactory)
                  {
                     staticStringFactory = new StringTextLineFactory();
                     staticStringFactory.compositionBounds = this.unbounded;
                  }
                  staticStringFactory.text = this._typicalText;
                  staticStringFactory.textFlowFormat = this._textContainerManager.hostFormat;
                  staticStringFactory.swfContext = ISWFContext(this.embeddedFontContext);
                  staticStringFactory.createTextLines(this.tossTextLine);
                  bounds = staticStringFactory.getContentBounds();
               }
               measuredWidth = Math.ceil(bounds.width);
               measuredHeight = Math.ceil(bounds.height);
            }
            else
            {
               measuredWidth = !isNaN(explicitWidth) ? explicitWidth : Math.ceil(this.calculateWidthInChars());
               measuredHeight = !isNaN(explicitHeight) ? explicitHeight : Math.ceil(this.calculateHeightInLines());
            }
         }
         else
         {
            this.autoSize = true;
            if(!isNaN(this.widthConstraint) || !isNaN(explicitWidth) || !isNaN(this.widthInChars))
            {
               if(!isNaN(this.widthConstraint))
               {
                  composeWidth = this.widthConstraint;
               }
               else if(!isNaN(explicitWidth))
               {
                  composeWidth = explicitWidth;
               }
               else
               {
                  composeWidth = Math.ceil(this.calculateWidthInChars());
               }
               bounds = this.measureTextSize(composeWidth);
               if(!isNaN(explicitWidth) || !isNaN(this.widthInChars))
               {
                  measuredWidth = this.textContainerManager.compositionWidth;
               }
               else
               {
                  measuredWidth = Math.ceil(bounds.width);
               }
               measuredHeight = Math.ceil(bounds.bottom);
            }
            else if(!isNaN(this.heightConstraint) || !isNaN(explicitHeight) || !isNaN(this._heightInLines))
            {
               if(!isNaN(this.heightConstraint))
               {
                  composeHeight = this.heightConstraint;
               }
               else if(!isNaN(explicitHeight))
               {
                  composeHeight = explicitHeight;
               }
               else
               {
                  composeHeight = this.calculateHeightInLines();
               }
               bounds = this.measureTextSize(NaN,composeHeight);
               measuredWidth = Math.ceil(bounds.right);
               measuredHeight = composeHeight;
               if(bounds.bottom > composeHeight)
               {
                  this.autoSize = false;
               }
            }
            else
            {
               bounds = this.measureTextSize(NaN);
               measuredWidth = Math.ceil(bounds.right);
               measuredHeight = Math.ceil(bounds.bottom);
            }
            if(isNaN(explicitHeight))
            {
               if(!isNaN(explicitMinHeight) && measuredHeight < explicitMinHeight)
               {
                  measuredHeight = explicitMinHeight;
               }
               if(!isNaN(explicitMaxHeight) && measuredHeight > explicitMaxHeight)
               {
                  measuredHeight = explicitMaxHeight;
                  this.autoSize = false;
               }
            }
            if(this.autoSize && getStyle("lineBreak") == "toFit")
            {
               this._textContainerManager.horizontalScrollPosition = 0;
               this._textContainerManager.verticalScrollPosition = 0;
            }
            if(this.remeasuringText && this.lastMeasuredWidth == measuredWidth && this.lastMeasuredHeight == measuredHeight)
            {
               this._textContainerManager.updateContainer();
            }
         }
         this.remeasuringText = false;
         this.inMeasureMethod = false;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         this.inUpdateDLMethod = true;
         this.updateStylesIfChanged();
         if(this.autoSize && this.lastUnscaledHeight == unscaledHeight && this.lastUnscaledWidth == unscaledWidth && this.remeasureText(unscaledWidth,unscaledHeight))
         {
            this.inUpdateDLMethod = false;
            return;
         }
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(!this.autoSize)
         {
            this._textContainerManager.compositionWidth = unscaledWidth;
            this._textContainerManager.compositionHeight = unscaledHeight;
         }
         if(this.clipAndEnableScrolling && this._textContainerManager.composeState != TextContainerManager.COMPOSE_COMPOSER)
         {
            this._textContainerManager.convertToTextFlowWithComposer();
         }
         if(this.autoSize && !isNaN(this.lastUnscaledWidth) && (this.lastUnscaledWidth != unscaledWidth || this.lastUnscaledHeight != unscaledHeight))
         {
            if(this._textContainerManager.composeState == TextContainerManager.COMPOSE_COMPOSER)
            {
               this._textContainerManager.getTextFlow().flowComposer.getControllerAt(0).shapesInvalid = true;
            }
            else if(!this._textContainerManager.isDamaged())
            {
               this._textContainerManager.drawBackgroundAndSetScrollRect(0,0);
            }
         }
         this._textContainerManager.updateContainer();
         this.lastUnscaledWidth = unscaledWidth;
         this.lastUnscaledHeight = unscaledHeight;
         this.inUpdateDLMethod = false;
      }
      
      override public function setLayoutBoundsSize(width:Number, height:Number, postLayoutTransform:Boolean = true) : void
      {
         this.heightConstraint = height;
         super.setLayoutBoundsSize(width,height,postLayoutTransform);
         if(this.widthConstraint == width)
         {
            return;
         }
         if(getStyle("lineBreak") == "explicit")
         {
            return;
         }
         if(super.canSkipMeasurement())
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
         if(postLayoutTransform && Boolean(hasComplexLayoutMatrix))
         {
            return;
         }
         this.widthConstraint = width;
         invalidateSize();
      }
      
      override public function stylesInitialized() : void
      {
         super.stylesInitialized();
         this.ascent = NaN;
         this.descent = NaN;
         this.hostFormatChanged = true;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         if(styleProp == null || styleProp == "styleName")
         {
            this.hostFormatChanged = true;
            this.selectionFormatsChanged = true;
            this.ascent = NaN;
            this.descent = NaN;
         }
         else if(styleProp == "focusedTextSelectionColor" || styleProp == "unfocusedTextSelectionColor" || styleProp == "inactiveTextSelectionColor")
         {
            this.selectionFormatsChanged = true;
         }
         else
         {
            this.hostFormatChanged = true;
            if(styleProp.indexOf("font") == 0 || styleProp == "cffHinting")
            {
               this.ascent = NaN;
               this.descent = NaN;
            }
         }
         invalidateProperties();
      }
      
      override public function setFocus() : void
      {
         if(this.editingMode != EditingMode.READ_ONLY && this._textContainerManager.composeState != TextContainerManager.COMPOSE_COMPOSER)
         {
            this._textContainerManager.beginInteraction();
            this._textContainerManager.endInteraction();
         }
         super.setFocus();
      }
      
      override public function drawFocus(isFocused:Boolean) : void
      {
         var fm:IFocusManager = null;
         if(isFocused)
         {
            fm = focusManager;
            if(Boolean(fm) && fm.getFocus() != this)
            {
               return;
            }
         }
         super.drawFocus(isFocused);
      }
      
      public function getHorizontalScrollPositionDelta(navigationUnit:uint) : Number
      {
         var scrollR:Rectangle = scrollRect;
         if(!scrollR)
         {
            return 0;
         }
         var maxDelta:Number = this.contentWidth - scrollR.right;
         var minDelta:Number = -scrollR.left;
         var em:Number = Number(getStyle("fontSize"));
         switch(navigationUnit)
         {
            case NavigationUnit.LEFT:
               return scrollR.left <= 0 ? 0 : Math.max(minDelta,-em);
            case NavigationUnit.RIGHT:
               return scrollR.right >= this.contentWidth ? 0 : Math.min(maxDelta,em);
            case NavigationUnit.PAGE_LEFT:
               return Math.max(minDelta,-scrollR.width);
            case NavigationUnit.PAGE_RIGHT:
               return Math.min(maxDelta,scrollR.width);
            case NavigationUnit.HOME:
               return minDelta;
            case NavigationUnit.END:
               return maxDelta;
            default:
               return 0;
         }
      }
      
      public function getVerticalScrollPositionDelta(navigationUnit:uint) : Number
      {
         var scrollR:Rectangle = scrollRect;
         if(!scrollR)
         {
            return 0;
         }
         var maxDelta:Number = this.contentHeight - scrollR.bottom;
         var minDelta:Number = -scrollR.top;
         switch(navigationUnit)
         {
            case NavigationUnit.UP:
               return this._textContainerManager.getScrollDelta(-1);
            case NavigationUnit.DOWN:
               return this._textContainerManager.getScrollDelta(1);
            case NavigationUnit.PAGE_UP:
               return Math.max(minDelta,-scrollR.height);
            case NavigationUnit.PAGE_DOWN:
               return Math.min(maxDelta,scrollR.height);
            case NavigationUnit.HOME:
               return minDelta;
            case NavigationUnit.END:
               return maxDelta;
            default:
               return 0;
         }
      }
      
      public function insertText(text:String) : void
      {
         this.handleInsertText(text);
      }
      
      public function appendText(text:String) : void
      {
         this.handleInsertText(text,true);
      }
      
      public function scrollToRange(anchorPosition:int, activePosition:int) : void
      {
         validateProperties();
         this.textContainerManager.scrollToRange(anchorPosition,activePosition);
      }
      
      public function selectRange(anchorPosition:int, activePosition:int) : void
      {
         var selectionState:SelectionState = null;
         var selectionEvent:SelectionEvent = null;
         var im:ISelectionManager = null;
         validateProperties();
         if(this.editingMode == EditingMode.READ_ONLY)
         {
            selectionState = new SelectionState(this.textFlow,anchorPosition,activePosition);
            selectionEvent = new SelectionEvent(SelectionEvent.SELECTION_CHANGE,false,false,selectionState);
            this.textContainerManager_selectionChangeHandler(selectionEvent);
         }
         else
         {
            im = this._textContainerManager.beginInteraction();
            im.selectRange(anchorPosition,activePosition);
            im.refreshSelection();
            this._textContainerManager.endInteraction();
         }
         this.hasProgrammaticSelectionRange = anchorPosition != activePosition;
      }
      
      public function selectAll() : void
      {
         this.selectRange(0,int.MAX_VALUE);
      }
      
      public function getFormatOfRange(requestedFormats:Vector.<String> = null, anchorPosition:int = -1, activePosition:int = -1) : TextLayoutFormat
      {
         var p:String = null;
         var category:String = null;
         var containerFormat:ITextLayoutFormat = null;
         var paragraphFormat:ITextLayoutFormat = null;
         var characterFormat:ITextLayoutFormat = null;
         var format:TextLayoutFormat = new TextLayoutFormat();
         validateProperties();
         var description:Object = TextLayoutFormat.description;
         var needContainerFormat:Boolean = false;
         var needParagraphFormat:Boolean = false;
         var needCharacterFormat:Boolean = false;
         if(!requestedFormats)
         {
            requestedFormats = new Vector.<String>();
            for(p in description)
            {
               requestedFormats.push(p);
            }
            needContainerFormat = true;
            needParagraphFormat = true;
            needCharacterFormat = true;
         }
         else
         {
            for each(p in requestedFormats)
            {
               if(p in description)
               {
                  category = description[p].category;
                  if(category == Category.CONTAINER)
                  {
                     needContainerFormat = true;
                  }
                  else if(category == Category.PARAGRAPH)
                  {
                     needParagraphFormat = true;
                  }
                  else if(category == Category.CHARACTER)
                  {
                     needCharacterFormat = true;
                  }
               }
            }
         }
         if(anchorPosition == -1 && activePosition == -1)
         {
            anchorPosition = this._selectionAnchorPosition;
            activePosition = this._selectionActivePosition;
         }
         if(needContainerFormat)
         {
            containerFormat = this._textContainerManager.getCommonContainerFormat();
         }
         if(needParagraphFormat)
         {
            paragraphFormat = this._textContainerManager.getCommonParagraphFormat(anchorPosition,activePosition);
         }
         if(needCharacterFormat)
         {
            characterFormat = this._textContainerManager.getCommonCharacterFormat(anchorPosition,activePosition);
         }
         for each(p in requestedFormats)
         {
            if(p in description)
            {
               category = description[p].category;
               if(category == Category.CONTAINER && Boolean(containerFormat))
               {
                  format[p] = containerFormat[p];
               }
               else if(category == Category.PARAGRAPH && Boolean(paragraphFormat))
               {
                  format[p] = paragraphFormat[p];
               }
               else if(category == Category.CHARACTER && Boolean(characterFormat))
               {
                  format[p] = characterFormat[p];
               }
            }
         }
         return format;
      }
      
      public function setFormatOfRange(format:TextLayoutFormat, anchorPosition:int = -1, activePosition:int = -1) : void
      {
         var containerFormat:TextLayoutFormat = null;
         var paragraphFormat:TextLayoutFormat = null;
         var characterFormat:TextLayoutFormat = null;
         var p:String = null;
         var category:String = null;
         validateProperties();
         var description:Object = TextLayoutFormat.description;
         for(p in description)
         {
            if(format[p] !== undefined)
            {
               category = description[p].category;
               if(category == Category.CONTAINER)
               {
                  if(!containerFormat)
                  {
                     containerFormat = new TextLayoutFormat();
                  }
                  containerFormat[p] = format[p];
               }
               else if(category == Category.PARAGRAPH)
               {
                  if(!paragraphFormat)
                  {
                     paragraphFormat = new TextLayoutFormat();
                  }
                  paragraphFormat[p] = format[p];
               }
               else if(category == Category.CHARACTER)
               {
                  if(!characterFormat)
                  {
                     characterFormat = new TextLayoutFormat();
                  }
                  characterFormat[p] = format[p];
               }
            }
         }
         if(anchorPosition == -1 && activePosition == -1)
         {
            anchorPosition = this._selectionAnchorPosition;
            activePosition = this._selectionActivePosition;
         }
         this._textContainerManager.applyFormatOperation(characterFormat,paragraphFormat,containerFormat,anchorPosition,activePosition);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createTextContainerManager() : RichEditableTextContainerManager
      {
         return new RichEditableTextContainerManager(this);
      }
      
      private function updateStylesIfChanged() : void
      {
         if(this.hostFormatChanged)
         {
            this._textContainerManager.hostFormat = new CSSTextLayoutFormat(this);
            this.hostFormatChanged = false;
         }
         if(isNaN(this.ascent) || isNaN(this.descent))
         {
            this.embeddedFontContext = this.getEmbeddedFontContext();
            this._textContainerManager.swfContext = ISWFContext(this.embeddedFontContext);
            this.calculateFontMetrics();
         }
         if(this.selectionFormatsChanged)
         {
            this._textContainerManager.invalidateSelectionFormats();
            this.selectionFormatsChanged = false;
         }
      }
      
      private function getEmbeddedFontContext() : IFlexModuleFactory
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function isMeasureFixed() : Boolean
      {
         if(!this._textContainerManager.hostFormat)
         {
            this.updateStylesIfChanged();
         }
         if(this._textContainerManager.hostFormat.blockProgression != BlockProgression.TB)
         {
            return true;
         }
         if(this.typicalText != null)
         {
            return true;
         }
         return (!isNaN(explicitWidth) || !isNaN(this._widthInChars) || !isNaN(this.widthConstraint)) && (!isNaN(explicitHeight) || !isNaN(this._heightInLines) || !isNaN(this.heightConstraint));
      }
      
      private function measureTextSize(composeWidth:Number, composeHeight:Number = NaN) : Rectangle
      {
         if(isNaN(explicitWidth) && isNaN(this.widthInChars))
         {
            if(!isNaN(explicitMinWidth) && !isNaN(composeWidth) && composeWidth < minWidth)
            {
               composeWidth = Number(minWidth);
            }
            if(!isNaN(explicitMaxWidth) && isNaN(composeWidth) || composeWidth > maxWidth)
            {
               composeWidth = Number(maxWidth);
            }
         }
         this._textContainerManager.compositionWidth = composeWidth;
         this._textContainerManager.compositionHeight = composeHeight;
         if(this.clipAndEnableScrolling && this._textContainerManager.composeState != TextContainerManager.COMPOSE_COMPOSER)
         {
            this._textContainerManager.convertToTextFlowWithComposer();
         }
         this._textContainerManager.compose();
         var bounds:Rectangle = this._textContainerManager.getContentBounds();
         if(this._textContainerManager.getText("\n").length == 0)
         {
            bounds.width += getStyle("fontSize");
         }
         if(isNaN(explicitWidth) && isNaN(this.widthInChars))
         {
            if(!isNaN(explicitMinWidth) && isNaN(composeWidth) && bounds.width < minWidth)
            {
               bounds.width = minWidth;
            }
         }
         return bounds;
      }
      
      private function remeasureText(width:Number, height:Number) : Boolean
      {
         if(width == measuredWidth && height == measuredHeight)
         {
            return false;
         }
         this.autoSize = false;
         if(width == 0 || height == 0)
         {
            return false;
         }
         if(this.typicalText != null)
         {
            return false;
         }
         if(this._textContainerManager.hostFormat.lineBreak == "explicit")
         {
            return false;
         }
         if(!isNaN(this.widthConstraint))
         {
            if(!isNaN(explicitHeight) || !isNaN(this._heightInLines) || !isNaN(this.heightConstraint))
            {
               return false;
            }
         }
         if(!isNaN(this.heightConstraint))
         {
            if(!isNaN(explicitWidth) || !isNaN(this._widthInChars))
            {
               return false;
            }
         }
         invalidateSize();
         this.remeasuringText = true;
         return true;
      }
      
      private function calculateFontMetrics() : void
      {
         var s:String = null;
         var textLine:TextLine = null;
         var fontDescription:FontDescription = new FontDescription();
         s = getStyle("cffHinting");
         if(s != null)
         {
            fontDescription.cffHinting = s;
         }
         s = getStyle("fontFamily");
         if(s != null)
         {
            fontDescription.fontName = s;
         }
         s = getStyle("fontLookup");
         if(s != null)
         {
            if(s != "device")
            {
               s = TextUtil.resolveFontLookup(this._textContainerManager.swfContext,this._textContainerManager.hostFormat);
            }
            fontDescription.fontLookup = s;
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
         var elementFormat:ElementFormat = new ElementFormat();
         elementFormat.fontDescription = fontDescription;
         elementFormat.fontSize = getStyle("fontSize");
         var textElement:TextElement = new TextElement();
         textElement.elementFormat = elementFormat;
         textElement.text = "M";
         var textBlock:TextBlock = new TextBlock();
         textBlock.content = textElement;
         var swfContext:ISWFContext = ISWFContext(this.embeddedFontContext);
         if(Boolean(swfContext))
         {
            textLine = swfContext.callInContext(textBlock.createTextLine,textBlock,[null,1000]);
         }
         else
         {
            textLine = textBlock.createTextLine(null,1000);
         }
         this.ascent = textLine.ascent;
         this.descent = textLine.descent;
      }
      
      private function calculateWidthInChars() : Number
      {
         var effectiveWidthInChars:int = 0;
         var em:Number = Number(getStyle("fontSize"));
         if(isNaN(this._widthInChars))
         {
            effectiveWidthInChars = isNaN(this._heightInLines) ? 10 : 1;
         }
         else
         {
            effectiveWidthInChars = this._widthInChars;
         }
         return getStyle("paddingLeft") + effectiveWidthInChars * em + getStyle("paddingRight");
      }
      
      private function calculateHeightInLines() : Number
      {
         var effectiveHeightInLines:int = 0;
         var value:Object = null;
         var lineHeight:Number = NaN;
         var height:Number = getStyle("paddingTop") + getStyle("paddingBottom");
         if(this._heightInLines == 0)
         {
            return height;
         }
         if(isNaN(this._heightInLines))
         {
            effectiveHeightInLines = isNaN(this._widthInChars) ? 10 : 1;
         }
         else
         {
            effectiveHeightInLines = this._heightInLines;
         }
         value = getStyle("firstBaselineOffset");
         if(value == lineHeight)
         {
            height += lineHeight;
         }
         else if(value is Number)
         {
            height += Number(value);
         }
         else
         {
            height += this.ascent;
         }
         if(effectiveHeightInLines > 1)
         {
            value = getStyle("lineHeight");
            lineHeight = RichEditableText.getNumberOrPercentOf(value,getStyle("fontSize"));
            if(isNaN(lineHeight))
            {
               lineHeight = getStyle("fontSize") * 1.2;
            }
            height += (effectiveHeightInLines - 1) * lineHeight;
         }
         return height + this.descent;
      }
      
      private function createTextFlowFromContent(content:Object) : TextFlow
      {
         var textFlow:TextFlow = null;
         if(content is TextFlow)
         {
            textFlow = content as TextFlow;
         }
         else if(content is Array)
         {
            textFlow = new TextFlow();
            textFlow.whiteSpaceCollapse = getStyle("whiteSpaceCollapse");
            textFlow.mxmlChildren = content as Array;
            textFlow.whiteSpaceCollapse = undefined;
         }
         else
         {
            textFlow = new TextFlow();
            textFlow.whiteSpaceCollapse = getStyle("whiteSpaceCollapse");
            textFlow.mxmlChildren = [content];
            textFlow.whiteSpaceCollapse = undefined;
         }
         return textFlow;
      }
      
      private function updateEditingMode() : void
      {
         var newEditingMode:String = EditingMode.READ_ONLY;
         if(enabled)
         {
            if(this._editable)
            {
               newEditingMode = EditingMode.READ_WRITE;
            }
            else if(this._selectable)
            {
               newEditingMode = EditingMode.READ_SELECT;
            }
         }
         this.editingMode = newEditingMode;
      }
      
      private function handleInsertText(newText:String, isAppend:Boolean = false) : void
      {
         validateProperties();
         if(isAppend)
         {
            this._selectionAnchorPosition = this.text.length;
            this._selectionActivePosition = this._selectionAnchorPosition;
         }
         else if(this._selectionAnchorPosition == -1 || this._selectionActivePosition == -1)
         {
            return;
         }
         var success:Boolean = this._textContainerManager.insertTextOperation(newText,this._selectionAnchorPosition,this._selectionActivePosition);
         if(success)
         {
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
         }
      }
      
      private function handlePasteOperation(op:PasteOperation) : void
      {
         var hasConstraints:Boolean = Boolean(this.restrict) || Boolean(this.maxChars) || this.displayAsPassword;
         if(!hasConstraints && this.multiline)
         {
            return;
         }
         if(op.textScrap == null || op.textScrap.textFlow == null)
         {
            return;
         }
         var pastedText:String = staticPlainTextExporter.export(op.textScrap.textFlow,ConversionType.STRING_TYPE) as String;
         if(!hasConstraints && pastedText.indexOf("\n") == -1)
         {
            return;
         }
         var textLength:int = pastedText.length;
         if(this._displayAsPassword)
         {
            this._text = splice(this._text,op.absoluteStart,op.absoluteEnd,"");
            this._text = splice(this._text,op.absoluteStart,op.absoluteStart,pastedText);
         }
         if(!this.multiline)
         {
            pastedText = pastedText.replace(ALL_NEWLINES_REGEXP,"");
         }
         var editManager:IEditManager = EditManager(this._textContainerManager.beginInteraction());
         this.dispatchChangeAndChangingEvents = false;
         var selectionState:SelectionState = new SelectionState(op.textFlow,op.absoluteStart,op.absoluteStart + textLength);
         editManager.insertText(pastedText,selectionState);
         this._textContainerManager.endInteraction();
         this.dispatchChangeAndChangingEvents = true;
      }
      
      private function addedToStageHandler(event:Event) : void
      {
         if(event.target == this)
         {
            removeEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
            callLater(this.addActivateHandlers);
         }
      }
      
      private function addActivateHandlers() : void
      {
         if(!focusManager)
         {
            return;
         }
         focusManager.addEventListener(FlexEvent.FLEX_WINDOW_ACTIVATE,this._textContainerManager.activateHandler,false,0,true);
         focusManager.addEventListener(FlexEvent.FLEX_WINDOW_DEACTIVATE,this._textContainerManager.deactivateHandler,false,0,true);
      }
      
      private function addFocusManagerHandler(event:Event) : void
      {
         if(focusManager == event.target["focusManager"])
         {
            systemManager.getSandboxRoot().removeEventListener(FlexEvent.ADD_FOCUS_MANAGER,this.addFocusManagerHandler,true);
            this.addActivateHandlers();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function focusInHandler(event:FocusEvent) : void
      {
         var selectionManager:ISelectionManager = null;
         if(event == null)
         {
            return;
         }
         var fm:IFocusManager = focusManager;
         if(Boolean(fm) && this.editingMode == EditingMode.READ_WRITE)
         {
            fm.showFocusIndicator = true;
         }
         super.focusInHandler(event);
         if(this.editingMode == EditingMode.READ_WRITE)
         {
            if(!this.mouseDown)
            {
               selectionManager = this._textContainerManager.beginInteraction();
               if(this.multiline)
               {
                  if(!selectionManager.hasSelection())
                  {
                     selectionManager.selectRange(0,0);
                  }
               }
               else if(!this.hasProgrammaticSelectionRange)
               {
                  selectionManager.selectAll();
               }
               selectionManager.refreshSelection();
               this._textContainerManager.endInteraction();
            }
            if(this._imeMode != null)
            {
               try
               {
                  if(IME.conversionMode != IMEConversionMode.UNKNOWN)
                  {
                     IME.conversionMode = this._imeMode;
                  }
               }
               catch(e:Error)
               {
               }
            }
         }
         if(Boolean(focusManager) && this.multiline)
         {
            focusManager.defaultButtonEnabled = false;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function focusOutHandler(event:FocusEvent) : void
      {
         super.focusOutHandler(event);
         if(this.clearUndoOnFocusOut && Boolean(this.undoManager))
         {
            this.undoManager.clearAll();
         }
         if(Boolean(focusManager))
         {
            focusManager.defaultButtonEnabled = true;
         }
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function keyDownHandler(event:KeyboardEvent) : void
      {
         if(this.editingMode != EditingMode.READ_WRITE)
         {
            return;
         }
         if(event.keyCode == Keyboard.ENTER)
         {
            if(!this.multiline)
            {
               dispatchEvent(new FlexEvent(FlexEvent.ENTER));
               event.preventDefault();
               return;
            }
            if(this._maxChars != 0 && this.text.length >= this._maxChars)
            {
               event.preventDefault();
               return;
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function mouseDownHandler(event:MouseEvent) : void
      {
         this.mouseDown = true;
         systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP,this.systemManager_mouseUpHandler,true);
      }
      
      private function systemManager_mouseUpHandler(event:MouseEvent) : void
      {
         this.mouseDown = false;
         systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP,this.systemManager_mouseUpHandler,true);
      }
      
      private function removedFromStageHandler(event:Event) : void
      {
         if(event.target == this)
         {
            TextContainerManager.releaseReferences();
         }
      }
      
      private function adjustContentBoundsForScroller(bounds:Rectangle) : void
      {
         if(this._textFlow.generation == this.lastContentBoundsGeneration)
         {
            if(bounds.width <= this._contentWidth)
            {
               if(this._textContainerManager.hostFormat.lineBreak == "toFit")
               {
                  if(bounds.height < this._contentHeight)
                  {
                     bounds.height = this._contentHeight;
                  }
               }
               else
               {
                  bounds.width = this._contentWidth;
               }
            }
         }
         this.lastContentBoundsGeneration = this._textFlow.generation;
      }
      
      private function textContainerManager_compositionCompleteHandler(event:CompositionCompleteEvent) : void
      {
         var oldContentWidth:Number = this._contentWidth;
         var oldContentHeight:Number = this._contentHeight;
         var newContentBounds:Rectangle = this._textContainerManager.getContentBounds();
         newContentBounds.width += newContentBounds.x;
         newContentBounds.height += newContentBounds.y;
         if(Boolean(this._textFlow) && this.clipAndEnableScrolling)
         {
            this.adjustContentBoundsForScroller(newContentBounds);
         }
         var newContentWidth:Number = newContentBounds.width;
         var newContentHeight:Number = newContentBounds.height;
         if(newContentWidth != oldContentWidth)
         {
            this._contentWidth = newContentWidth;
            dispatchPropertyChangeEvent("contentWidth",oldContentWidth,newContentWidth);
         }
         if(newContentHeight != oldContentHeight)
         {
            this._contentHeight = newContentHeight;
            dispatchPropertyChangeEvent("contentHeight",oldContentHeight,newContentHeight);
         }
      }
      
      private function textContainerManager_damageHandler(event:DamageEvent) : void
      {
         if(event.damageLength == 0)
         {
            return;
         }
         if(this.inUpdateDLMethod)
         {
            return;
         }
         if(this.inMeasureMethod)
         {
            invalidateDisplayList();
            return;
         }
         if(Boolean(this._textFlow) && this._textFlow.generation == this.lastGeneration)
         {
            return;
         }
         if(this.textChanged || this.textFlowChanged || this.contentChanged)
         {
            return;
         }
         if(!this.displayAsPassword)
         {
            this._text = null;
         }
         this._content = null;
         this._textFlow = this._textContainerManager.getTextFlow();
         this.lastGeneration = this._textFlow.generation;
         invalidateSize();
         invalidateDisplayList();
      }
      
      private function textContainerManager_scrollHandler(event:Event) : void
      {
         var oldHorizontalScrollPosition:Number = this._horizontalScrollPosition;
         var newHorizontalScrollPosition:Number = Number(this._textContainerManager.horizontalScrollPosition);
         if(newHorizontalScrollPosition != oldHorizontalScrollPosition)
         {
            this._horizontalScrollPosition = newHorizontalScrollPosition;
            dispatchPropertyChangeEvent("horizontalScrollPosition",oldHorizontalScrollPosition,newHorizontalScrollPosition);
         }
         var oldVerticalScrollPosition:Number = this._verticalScrollPosition;
         var newVerticalScrollPosition:Number = Number(this._textContainerManager.verticalScrollPosition);
         if(newVerticalScrollPosition != oldVerticalScrollPosition)
         {
            this._verticalScrollPosition = newVerticalScrollPosition;
            dispatchPropertyChangeEvent("verticalScrollPosition",oldVerticalScrollPosition,newVerticalScrollPosition);
         }
      }
      
      private function textContainerManager_selectionChangeHandler(event:SelectionEvent) : void
      {
         if(this.preserveSelectionOnSetText)
         {
            return;
         }
         var oldAnchor:int = this._selectionAnchorPosition;
         var oldActive:int = this._selectionActivePosition;
         var selectionState:SelectionState = event.selectionState;
         if(Boolean(selectionState))
         {
            this._selectionAnchorPosition = selectionState.anchorPosition;
            this._selectionActivePosition = selectionState.activePosition;
         }
         else
         {
            this._selectionAnchorPosition = -1;
            this._selectionActivePosition = -1;
         }
         this.hasProgrammaticSelectionRange = false;
         var changed:Boolean = oldAnchor != this._selectionAnchorPosition || oldActive != this._selectionActivePosition;
         if(changed)
         {
            dispatchEvent(new FlexEvent(FlexEvent.SELECTION_CHANGE));
         }
      }
      
      private function textContainerManager_flowOperationBeginHandler(event:FlowOperationEvent) : void
      {
         var insertTextOperation:InsertTextOperation = null;
         var textToInsert:String = null;
         var delSelOp:SelectionState = null;
         var delLen:int = 0;
         var length1:int = 0;
         var length2:int = 0;
         var flowTextOperation:FlowTextOperation = null;
         var newEvent:TextOperationEvent = null;
         var op:FlowOperation = event.operation;
         if(op is InsertTextOperation)
         {
            insertTextOperation = InsertTextOperation(op);
            textToInsert = insertTextOperation.text;
            delSelOp = insertTextOperation.deleteSelectionState;
            delLen = delSelOp == null ? 0 : int(delSelOp.absoluteEnd - delSelOp.absoluteStart);
            if(this._restrict != null)
            {
               textToInsert = StringUtil.restrict(textToInsert,this.restrict);
               if(textToInsert.length == 0 && delLen == 0)
               {
                  event.preventDefault();
                  return;
               }
            }
            if(this.maxChars != 0)
            {
               length1 = this.text.length - delLen;
               length2 = textToInsert.length;
               if(length1 + length2 > this.maxChars)
               {
                  textToInsert = textToInsert.substr(0,this.maxChars - length1);
               }
            }
            if(this._displayAsPassword)
            {
               if(delLen > 0)
               {
                  this._text = splice(this._text,delSelOp.absoluteStart,delSelOp.absoluteEnd,"");
               }
               if(textToInsert.length > 0)
               {
                  this._text = splice(this._text,insertTextOperation.absoluteStart,insertTextOperation.absoluteStart,textToInsert);
                  textToInsert = StringUtil.repeat(this.passwordChar,textToInsert.length);
               }
            }
            insertTextOperation.text = textToInsert;
         }
         else if(op is CopyOperation)
         {
            if(this._displayAsPassword)
            {
               event.preventDefault();
               return;
            }
         }
         else if(!(op is PasteOperation))
         {
            if(op is DeleteTextOperation || op is CutOperation)
            {
               flowTextOperation = FlowTextOperation(op);
               if(flowTextOperation.absoluteStart == flowTextOperation.absoluteEnd)
               {
                  event.preventDefault();
                  return;
               }
               if(this._displayAsPassword)
               {
                  if(!(op is DeleteTextOperation))
                  {
                     event.preventDefault();
                     return;
                  }
                  this._text = splice(this._text,flowTextOperation.absoluteStart,flowTextOperation.absoluteEnd,"");
               }
            }
         }
         if(this.dispatchChangeAndChangingEvents && event.level == 0)
         {
            newEvent = new TextOperationEvent(TextOperationEvent.CHANGING);
            newEvent.operation = op;
            dispatchEvent(newEvent);
            if(newEvent.isDefaultPrevented())
            {
               event.preventDefault();
            }
         }
      }
      
      private function textContainerManager_flowOperationEndHandler(event:FlowOperationEvent) : void
      {
         if(event.operation is PasteOperation)
         {
            this.handlePasteOperation(PasteOperation(event.operation));
         }
      }
      
      private function textContainerManager_flowOperationCompleteHandler(event:FlowOperationEvent) : void
      {
         var newEvent:TextOperationEvent = null;
         if(this.dispatchChangeAndChangingEvents && event.level == 0)
         {
            newEvent = new TextOperationEvent(TextOperationEvent.CHANGE);
            newEvent.operation = event.operation;
            dispatchEvent(newEvent);
         }
      }
      
      private function textContainerManager_inlineGraphicStatusChangeHandler(event:StatusChangeEvent) : void
      {
         if(event.status == InlineGraphicElementStatus.READY)
         {
            if(this.autoSize)
            {
               invalidateSize();
            }
         }
         invalidateDisplayList();
      }
      
      private function tossTextLine(textLine:DisplayObject) : void
      {
         TextUtil.recycleTextLine(textLine as TextLine);
      }
   }
}

