package mx.controls
{
   import flash.accessibility.AccessibilityProperties;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.system.IME;
   import flash.system.IMEConversionMode;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextLineMetrics;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.EdgeMetrics;
   import mx.core.IDataRenderer;
   import mx.core.IFlexModuleFactory;
   import mx.core.IFontContextComponent;
   import mx.core.IIMESupport;
   import mx.core.IInvalidating;
   import mx.core.IUITextField;
   import mx.core.ScrollControlBase;
   import mx.core.ScrollPolicy;
   import mx.core.UITextField;
   import mx.events.FlexEvent;
   import mx.events.ScrollEvent;
   import mx.events.ScrollEventDetail;
   import mx.events.ScrollEventDirection;
   import mx.managers.IFocusManager;
   import mx.managers.IFocusManagerComponent;
   
   [Alternative(replacement="spark.components.TextArea",since="4.0")]
   [ResourceBundle("controls")]
   [IconFile("TextArea.png")]
   [DefaultTriggerEvent("change")]
   [DefaultBindingProperty(source="text",destination="text")]
   [DataBindingInfo("&quot;focusIn;focusOut&quot;")]
   [Exclude(name="maxVerticalScrollPosition",kind="property")]
   [Exclude(name="maxHorizontalScrollPosition",kind="property")]
   [Style(name="disabledColor",type="uint",format="Color",inherit="yes")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no")]
   [Style(name="paddingRight",type="Number",format="Length",inherit="no")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no")]
   [Event(name="textInput",type="flash.events.TextEvent")]
   [Event(name="link",type="flash.events.TextEvent")]
   [Event(name="dataChange",type="mx.events.FlexEvent")]
   [Event(name="change",type="flash.events.Event")]
   public class TextArea extends ScrollControlBase implements IDataRenderer, IDropInListItemRenderer, IFocusManagerComponent, IIMESupport, IListItemRenderer, IFontContextComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var allowScrollEvent:Boolean = true;
      
      private var textSet:Boolean;
      
      private var selectionChanged:Boolean = false;
      
      private var errorCaught:Boolean = false;
      
      private var _accessibilityProperties:AccessibilityProperties;
      
      private var accessibilityPropertiesChanged:Boolean = false;
      
      private var enabledChanged:Boolean = false;
      
      private var _hScrollPosition:Number;
      
      private var _tabIndex:int = -1;
      
      private var tabIndexChanged:Boolean = false;
      
      protected var textField:IUITextField;
      
      private var _vScrollPosition:Number;
      
      private var _condenseWhite:Boolean = false;
      
      private var condenseWhiteChanged:Boolean = false;
      
      private var _data:Object;
      
      private var _displayAsPassword:Boolean = false;
      
      private var displayAsPasswordChanged:Boolean = false;
      
      private var _editable:Boolean = true;
      
      private var editableChanged:Boolean = false;
      
      private var _htmlText:String = "";
      
      private var htmlTextChanged:Boolean = false;
      
      private var explicitHTMLText:String = null;
      
      private var _imeMode:String = null;
      
      private var _listData:BaseListData;
      
      private var _maxChars:int = 0;
      
      private var maxCharsChanged:Boolean = false;
      
      private var _restrict:String = null;
      
      private var restrictChanged:Boolean = false;
      
      private var _selectable:Boolean = true;
      
      private var selectableChanged:Boolean = false;
      
      private var _selectionBeginIndex:int = 0;
      
      private var _selectionEndIndex:int = 0;
      
      private var styleSheetChanged:Boolean = false;
      
      private var _styleSheet:StyleSheet;
      
      private var _text:String = "";
      
      private var textChanged:Boolean = false;
      
      private var _textHeight:Number;
      
      private var _textWidth:Number;
      
      private var _wordWrap:Boolean = true;
      
      private var wordWrapChanged:Boolean = false;
      
      public function TextArea()
      {
         super();
         _horizontalScrollPolicy = ScrollPolicy.AUTO;
         _verticalScrollPolicy = ScrollPolicy.AUTO;
      }
      
      override public function get accessibilityProperties() : AccessibilityProperties
      {
         return this._accessibilityProperties;
      }
      
      override public function set accessibilityProperties(value:AccessibilityProperties) : void
      {
         if(value == this._accessibilityProperties)
         {
            return;
         }
         this._accessibilityProperties = value;
         this.accessibilityPropertiesChanged = true;
         invalidateProperties();
      }
      
      override public function get baselinePosition() : Number
      {
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         return this.textField.y + this.textField.baselinePosition;
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="true")]
      override public function set enabled(value:Boolean) : void
      {
         if(value == enabled)
         {
            return;
         }
         super.enabled = value;
         this.enabledChanged = true;
         if(Boolean(verticalScrollBar))
         {
            verticalScrollBar.enabled = value;
         }
         if(Boolean(horizontalScrollBar))
         {
            horizontalScrollBar.enabled = value;
         }
         invalidateProperties();
         if(Boolean(border) && border is IInvalidating)
         {
            IInvalidating(border).invalidateDisplayList();
         }
      }
      
      public function get fontContext() : IFlexModuleFactory
      {
         return moduleFactory;
      }
      
      public function set fontContext(moduleFactory:IFlexModuleFactory) : void
      {
         this.moduleFactory = moduleFactory;
      }
      
      [Inspectable(defaultValue="0")]
      [Bindable("viewChanged")]
      [Bindable("scroll")]
      override public function set horizontalScrollPosition(value:Number) : void
      {
         super.horizontalScrollPosition = value;
         this._hScrollPosition = value;
         if(Boolean(this.textField))
         {
            this.textField.scrollH = value;
            this.textField.background = false;
         }
         else
         {
            invalidateProperties();
         }
      }
      
      [Inspectable(enumeration="off,on,auto",defaultValue="auto")]
      override public function get horizontalScrollPolicy() : String
      {
         return height <= 40 ? ScrollPolicy.OFF : _horizontalScrollPolicy;
      }
      
      override public function get maxHorizontalScrollPosition() : Number
      {
         return Boolean(this.textField) ? Number(this.textField.maxScrollH) : 0;
      }
      
      override public function get maxVerticalScrollPosition() : Number
      {
         return Boolean(this.textField) ? this.textField.maxScrollV - 1 : 0;
      }
      
      override public function get tabIndex() : int
      {
         return this._tabIndex;
      }
      
      override public function set tabIndex(value:int) : void
      {
         if(value == this._tabIndex)
         {
            return;
         }
         this._tabIndex = value;
         this.tabIndexChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(defaultValue="0")]
      [Bindable("viewChanged")]
      [Bindable("scroll")]
      override public function set verticalScrollPosition(value:Number) : void
      {
         super.verticalScrollPosition = value;
         this._vScrollPosition = value;
         if(Boolean(this.textField))
         {
            this.textField.scrollV = value + 1;
            this.textField.background = false;
         }
         else
         {
            invalidateProperties();
         }
      }
      
      [Inspectable(enumeration="off,on,auto",defaultValue="auto")]
      override public function get verticalScrollPolicy() : String
      {
         return height <= 40 ? ScrollPolicy.OFF : _verticalScrollPolicy;
      }
      
      [Inspectable(category="General",defaultValue="")]
      [Bindable("condenseWhiteChanged")]
      public function get condenseWhite() : Boolean
      {
         return this._condenseWhite;
      }
      
      public function set condenseWhite(value:Boolean) : void
      {
         if(value == this._condenseWhite)
         {
            return;
         }
         this._condenseWhite = value;
         this.condenseWhiteChanged = true;
         if(this.isHTML)
         {
            this.htmlTextChanged = true;
         }
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("condenseWhiteChanged"));
      }
      
      [Inspectable(environment="none")]
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(value:Object) : void
      {
         var newText:* = undefined;
         this._data = value;
         if(Boolean(this._listData))
         {
            newText = this._listData.label;
         }
         else if(this._data != null)
         {
            if(this._data is String)
            {
               newText = String(this._data);
            }
            else
            {
               newText = this._data.toString();
            }
         }
         if(newText !== undefined && !this.textSet)
         {
            this.text = newText;
            this.textSet = false;
         }
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      [Inspectable(category="General",defaultValue="false")]
      [Bindable("displayAsPasswordChanged")]
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
         dispatchEvent(new Event("displayAsPasswordChanged"));
      }
      
      [Inspectable(category="General",defaultValue="true")]
      [Bindable("editableChanged")]
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
         dispatchEvent(new Event("editableChanged"));
      }
      
      public function get enableIME() : Boolean
      {
         return this.editable;
      }
      
      [NonCommittingChangeEvent("change")]
      [Inspectable(category="General",defaultValue="")]
      [CollapseWhiteSpace]
      [Bindable("htmlTextChanged")]
      public function get htmlText() : String
      {
         return this._htmlText;
      }
      
      public function set htmlText(value:String) : void
      {
         this.textSet = true;
         if(!value)
         {
            value = "";
         }
         this._htmlText = value;
         this.htmlTextChanged = true;
         this._text = null;
         this.explicitHTMLText = value;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("htmlTextChanged"));
      }
      
      public function get imeMode() : String
      {
         return this._imeMode;
      }
      
      public function set imeMode(value:String) : void
      {
         this._imeMode = value;
      }
      
      private function get isHTML() : Boolean
      {
         return this.explicitHTMLText != null;
      }
      
      public function get length() : int
      {
         return this.text != null ? this.text.length : -1;
      }
      
      [Inspectable(environment="none")]
      [Bindable("dataChange")]
      public function get listData() : BaseListData
      {
         return this._listData;
      }
      
      public function set listData(value:BaseListData) : void
      {
         this._listData = value;
      }
      
      [Inspectable(category="General",defaultValue="0")]
      [Bindable("maxCharsChanged")]
      public function get maxChars() : int
      {
         return this._maxChars;
      }
      
      public function set maxChars(value:int) : void
      {
         if(value == this._maxChars)
         {
            return;
         }
         this._maxChars = value;
         this.maxCharsChanged = true;
         invalidateProperties();
         dispatchEvent(new Event("maxCharsChanged"));
      }
      
      [Inspectable(category="General")]
      [Bindable("restrictChanged")]
      public function get restrict() : String
      {
         return this._restrict;
      }
      
      public function set restrict(value:String) : void
      {
         if(value == this._restrict)
         {
            return;
         }
         this._restrict = value;
         this.restrictChanged = true;
         invalidateProperties();
         dispatchEvent(new Event("restrictChanged"));
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get selectable() : Boolean
      {
         return this._selectable;
      }
      
      public function set selectable(value:Boolean) : void
      {
         if(value == this.selectable)
         {
            return;
         }
         this._selectable = value;
         this.selectableChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(defaultValue="0")]
      public function get selectionBeginIndex() : int
      {
         return Boolean(this.textField) ? int(this.textField.selectionBeginIndex) : this._selectionBeginIndex;
      }
      
      public function set selectionBeginIndex(value:int) : void
      {
         this._selectionBeginIndex = value;
         this.selectionChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(defaultValue="0")]
      public function get selectionEndIndex() : int
      {
         return Boolean(this.textField) ? int(this.textField.selectionEndIndex) : this._selectionEndIndex;
      }
      
      public function set selectionEndIndex(value:int) : void
      {
         this._selectionEndIndex = value;
         this.selectionChanged = true;
         invalidateProperties();
      }
      
      public function get styleSheet() : StyleSheet
      {
         return this._styleSheet;
      }
      
      public function set styleSheet(value:StyleSheet) : void
      {
         this._styleSheet = value;
         this.styleSheetChanged = true;
         this.htmlTextChanged = true;
         invalidateProperties();
      }
      
      [NonCommittingChangeEvent("change")]
      [Inspectable(category="General",defaultValue="")]
      [CollapseWhiteSpace]
      [Bindable("textChanged")]
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(value:String) : void
      {
         this.textSet = true;
         if(!value)
         {
            value = "";
         }
         if(!this.isHTML && value == this._text)
         {
            return;
         }
         this._text = value;
         this.textChanged = true;
         this._htmlText = null;
         this.explicitHTMLText = null;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("textChanged"));
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      public function get textHeight() : Number
      {
         return this._textHeight;
      }
      
      public function get textWidth() : Number
      {
         return this._textWidth;
      }
      
      [Inspectable(category="General",defaultValue="true")]
      [Bindable("wordWrapChanged")]
      public function get wordWrap() : Boolean
      {
         return this._wordWrap;
      }
      
      public function set wordWrap(value:Boolean) : void
      {
         if(value == this._wordWrap)
         {
            return;
         }
         this._wordWrap = value;
         this.wordWrapChanged = true;
         invalidateProperties();
         invalidateDisplayList();
         dispatchEvent(new Event("wordWrapChanged"));
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.createTextField(-1);
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(Boolean(hasFontContextChanged()) && this.textField != null)
         {
            this.removeTextField();
            this.createTextField(-1);
            this.accessibilityPropertiesChanged = true;
            this.condenseWhiteChanged = true;
            this.displayAsPasswordChanged = true;
            this.editableChanged = true;
            this.enabledChanged = true;
            this.maxCharsChanged = true;
            this.restrictChanged = true;
            this.selectableChanged = true;
            this.tabIndexChanged = true;
            this.wordWrapChanged = true;
            this.textChanged = true;
            this.selectionChanged = true;
         }
         if(this.accessibilityPropertiesChanged)
         {
            this.textField.accessibilityProperties = this._accessibilityProperties;
            this.accessibilityPropertiesChanged = false;
         }
         if(this.condenseWhiteChanged)
         {
            this.textField.condenseWhite = this._condenseWhite;
            this.condenseWhiteChanged = false;
         }
         if(this.displayAsPasswordChanged)
         {
            this.textField.displayAsPassword = this._displayAsPassword;
            this.displayAsPasswordChanged = false;
         }
         if(this.editableChanged)
         {
            this.textField.type = this._editable && enabled ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
            this.editableChanged = false;
         }
         if(this.enabledChanged)
         {
            this.textField.enabled = enabled;
            this.enabledChanged = false;
         }
         if(this.maxCharsChanged)
         {
            this.textField.maxChars = this._maxChars;
            this.maxCharsChanged = false;
         }
         if(this.restrictChanged)
         {
            this.textField.restrict = this._restrict;
            this.restrictChanged = false;
         }
         if(this.selectableChanged)
         {
            this.textField.selectable = this._selectable;
            this.selectableChanged = false;
         }
         if(this.styleSheetChanged)
         {
            this.textField.styleSheet = this._styleSheet;
            this.styleSheetChanged = false;
         }
         if(this.tabIndexChanged)
         {
            this.textField.tabIndex = this._tabIndex;
            this.tabIndexChanged = false;
         }
         if(this.wordWrapChanged)
         {
            this.textField.wordWrap = this._wordWrap;
            this.wordWrapChanged = false;
         }
         if(this.textChanged || this.htmlTextChanged)
         {
            if(this.isHTML)
            {
               this.textField.htmlText = this.explicitHTMLText;
            }
            else
            {
               this.textField.text = this._text;
            }
            this.textFieldChanged(false,true);
            this.textChanged = false;
            this.htmlTextChanged = false;
         }
         if(this.selectionChanged)
         {
            this.textField.setSelection(this._selectionBeginIndex,this._selectionEndIndex);
            this.selectionChanged = false;
         }
         if(!isNaN(this._hScrollPosition))
         {
            this.horizontalScrollPosition = this._hScrollPosition;
         }
         if(!isNaN(this._vScrollPosition))
         {
            this.verticalScrollPosition = this._vScrollPosition;
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredMinWidth = DEFAULT_MEASURED_MIN_WIDTH;
         measuredWidth = DEFAULT_MEASURED_WIDTH;
         measuredMinHeight = measuredHeight = 2 * DEFAULT_MEASURED_MIN_HEIGHT;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var vm:EdgeMetrics = viewMetrics;
         vm.left += getStyle("paddingLeft");
         vm.top += getStyle("paddingTop");
         vm.right += getStyle("paddingRight");
         vm.bottom += getStyle("paddingBottom");
         this.textField.move(vm.left,vm.top);
         var w:Number = unscaledWidth - vm.left - vm.right;
         var h:Number = unscaledHeight - vm.top - vm.bottom;
         if(vm.top + vm.bottom > 0)
         {
            h++;
         }
         this.textField.setActualSize(Math.max(4,w),Math.max(4,h));
         if(!initialized)
         {
            callLater(invalidateDisplayList);
         }
         else
         {
            callLater(this.adjustScrollBars);
         }
         if(isNaN(this._hScrollPosition))
         {
            this._hScrollPosition = 0;
         }
         if(isNaN(this._vScrollPosition))
         {
            this._vScrollPosition = 0;
         }
         var p:Number = Math.min(this.textField.maxScrollH,this._hScrollPosition);
         if(p != this.textField.scrollH)
         {
            this.horizontalScrollPosition = p;
         }
         p = Math.min(this.textField.maxScrollV - 1,this._vScrollPosition);
         if(p != this.textField.scrollV - 1)
         {
            this.verticalScrollPosition = p;
         }
      }
      
      override public function setFocus() : void
      {
         var vScrollPos:int = verticalScrollPosition;
         this.allowScrollEvent = false;
         this.textField.setFocus();
         this.verticalScrollPosition = vScrollPos;
         this.allowScrollEvent = true;
      }
      
      override protected function isOurFocus(target:DisplayObject) : Boolean
      {
         return target == this.textField || Boolean(super.isOurFocus(target));
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createTextField(childIndex:int) : void
      {
         if(!this.textField)
         {
            this.textField = IUITextField(createInFontContext(UITextField));
            this.textField.autoSize = TextFieldAutoSize.NONE;
            this.textField.enabled = enabled;
            this.textField.ignorePadding = true;
            this.textField.multiline = true;
            this.textField.selectable = true;
            this.textField.styleName = this;
            this.textField.tabEnabled = true;
            this.textField.type = TextFieldType.INPUT;
            this.textField.useRichTextClipboard = true;
            this.textField.wordWrap = true;
            this.textField.addEventListener(Event.CHANGE,this.textField_changeHandler);
            this.textField.addEventListener(Event.SCROLL,this.textField_scrollHandler);
            this.textField.addEventListener(IOErrorEvent.IO_ERROR,this.textField_ioErrorHandler);
            this.textField.addEventListener(TextEvent.TEXT_INPUT,this.textField_textInputHandler);
            this.textField.addEventListener("textFieldStyleChange",this.textField_textFieldStyleChangeHandler);
            this.textField.addEventListener("textFormatChange",this.textField_textFormatChangeHandler);
            this.textField.addEventListener("textInsert",this.textField_textModifiedHandler);
            this.textField.addEventListener("textReplace",this.textField_textModifiedHandler);
            this.textField.addEventListener("textFieldWidthChange",this.textField_textFieldWidthChangeHandler);
            this.textField.addEventListener("nativeDragDrop",this.textField_nativeDragDropHandler);
            if(childIndex == -1)
            {
               addChild(DisplayObject(this.textField));
            }
            else
            {
               addChildAt(DisplayObject(this.textField),childIndex);
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeTextField() : void
      {
         if(Boolean(this.textField))
         {
            this.textField.removeEventListener(Event.CHANGE,this.textField_changeHandler);
            this.textField.removeEventListener(Event.SCROLL,this.textField_scrollHandler);
            this.textField.removeEventListener(IOErrorEvent.IO_ERROR,this.textField_ioErrorHandler);
            this.textField.removeEventListener(TextEvent.TEXT_INPUT,this.textField_textInputHandler);
            this.textField.removeEventListener("textFieldStyleChange",this.textField_textFieldStyleChangeHandler);
            this.textField.removeEventListener("textFormatChange",this.textField_textFormatChangeHandler);
            this.textField.removeEventListener("textInsert",this.textField_textModifiedHandler);
            this.textField.removeEventListener("textReplace",this.textField_textModifiedHandler);
            this.textField.removeEventListener("textFieldWidthChange",this.textField_textFieldWidthChangeHandler);
            this.textField.removeEventListener("nativeDragDrop",this.textField_nativeDragDropHandler);
            removeChild(DisplayObject(this.textField));
            this.textField = null;
         }
      }
      
      public function getLineMetrics(lineIndex:int) : TextLineMetrics
      {
         return Boolean(this.textField) ? this.textField.getLineMetrics(lineIndex) : null;
      }
      
      public function setSelection(beginIndex:int, endIndex:int) : void
      {
         this._selectionBeginIndex = beginIndex;
         this._selectionEndIndex = endIndex;
         this.selectionChanged = true;
         invalidateProperties();
      }
      
      private function textFieldChanged(styleChangeOnly:Boolean, dispatchValueCommitEvent:Boolean) : void
      {
         var changed1:Boolean = false;
         var changed2:Boolean = false;
         if(!styleChangeOnly)
         {
            changed1 = this._text != this.textField.text;
            this._text = this.textField.text;
         }
         changed2 = this._htmlText != this.textField.htmlText;
         this._htmlText = this.textField.htmlText;
         if(changed1)
         {
            dispatchEvent(new Event("textChanged"));
            if(dispatchValueCommitEvent)
            {
               dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
            }
         }
         if(changed2)
         {
            dispatchEvent(new Event("htmlTextChanged"));
         }
         this._textWidth = this.textField.textWidth;
         this._textHeight = this.textField.textHeight;
      }
      
      private function adjustScrollBars() : void
      {
         var visibleRows:Number = this.textField.bottomScrollV - this.textField.scrollV + 1;
         var rows:Number = Number(this.textField.numLines);
         setScrollBarProperties(this.textField.width + this.textField.maxScrollH,this.textField.width,this.textField.numLines,visibleRows);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getTextField() : IUITextField
      {
         return this.textField;
      }
      
      override protected function focusInHandler(event:FocusEvent) : void
      {
         var fm:IFocusManager;
         var message:String = null;
         if(event.target == this)
         {
            systemManager.stage.focus = TextField(this.textField);
         }
         fm = focusManager;
         if(this.editable && Boolean(fm))
         {
            fm.showFocusIndicator = true;
         }
         if(Boolean(fm))
         {
            fm.defaultButtonEnabled = false;
         }
         super.focusInHandler(event);
         if(this._imeMode != null && this._editable)
         {
            try
            {
               if(!this.errorCaught && IME.conversionMode != IMEConversionMode.UNKNOWN)
               {
                  IME.conversionMode = this._imeMode;
               }
               this.errorCaught = false;
            }
            catch(e:Error)
            {
               errorCaught = true;
               message = resourceManager.getString("controls","unsupportedMode",[_imeMode]);
               throw new Error(message);
            }
         }
      }
      
      override protected function focusOutHandler(event:FocusEvent) : void
      {
         var fm:IFocusManager = focusManager;
         if(Boolean(fm))
         {
            fm.defaultButtonEnabled = true;
         }
         super.focusOutHandler(event);
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      override protected function mouseWheelHandler(event:MouseEvent) : void
      {
         event.stopPropagation();
      }
      
      override protected function scrollHandler(event:Event) : void
      {
         if(event is ScrollEvent)
         {
            if(!liveScrolling && ScrollEvent(event).detail == ScrollEventDetail.THUMB_TRACK)
            {
               return;
            }
            super.scrollHandler(event);
            this.textField.scrollH = horizontalScrollPosition;
            this.textField.scrollV = verticalScrollPosition + 1;
            this._vScrollPosition = this.textField.scrollV - 1;
            this._hScrollPosition = this.textField.scrollH;
         }
      }
      
      private function textField_changeHandler(event:Event) : void
      {
         this.textFieldChanged(false,false);
         this.adjustScrollBars();
         this.textChanged = false;
         this.htmlTextChanged = false;
         event.stopImmediatePropagation();
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function textField_scrollHandler(event:Event) : void
      {
         var deltaX:int = 0;
         var deltaY:int = 0;
         var scrollEvent:ScrollEvent = null;
         if(Boolean(initialized) && this.allowScrollEvent)
         {
            deltaX = this.textField.scrollH - horizontalScrollPosition;
            deltaY = this.textField.scrollV - 1 - verticalScrollPosition;
            this.horizontalScrollPosition = this.textField.scrollH;
            this.verticalScrollPosition = this.textField.scrollV - 1;
            if(Boolean(deltaX))
            {
               scrollEvent = new ScrollEvent(ScrollEvent.SCROLL,false,false,null,horizontalScrollPosition,ScrollEventDirection.HORIZONTAL,deltaX);
               dispatchEvent(scrollEvent);
            }
            if(Boolean(deltaY))
            {
               scrollEvent = new ScrollEvent(ScrollEvent.SCROLL,false,false,null,verticalScrollPosition,ScrollEventDirection.VERTICAL,deltaY);
               dispatchEvent(scrollEvent);
            }
         }
      }
      
      private function textField_ioErrorHandler(event:IOErrorEvent) : void
      {
      }
      
      private function textField_nativeDragDropHandler(event:Event) : void
      {
         this.textField_changeHandler(event);
      }
      
      private function textField_textInputHandler(event:TextEvent) : void
      {
         event.stopImmediatePropagation();
         var newEvent:TextEvent = new TextEvent(TextEvent.TEXT_INPUT,false,true);
         newEvent.text = event.text;
         dispatchEvent(newEvent);
         if(newEvent.isDefaultPrevented())
         {
            event.preventDefault();
         }
      }
      
      private function textField_textFieldStyleChangeHandler(event:Event) : void
      {
         this.textFieldChanged(true,false);
      }
      
      private function textField_textFormatChangeHandler(event:Event) : void
      {
         this.textFieldChanged(true,false);
      }
      
      private function textField_textModifiedHandler(event:Event) : void
      {
         this.textFieldChanged(false,true);
      }
      
      private function textField_textFieldWidthChangeHandler(event:Event) : void
      {
         this.textFieldChanged(true,false);
      }
   }
}

