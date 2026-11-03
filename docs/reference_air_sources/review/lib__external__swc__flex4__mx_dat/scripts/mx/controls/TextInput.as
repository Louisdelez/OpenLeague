package mx.controls
{
   import flash.accessibility.AccessibilityProperties;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.TextEvent;
   import flash.system.IME;
   import flash.system.IMEConversionMode;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextLineMetrics;
   import flash.ui.Keyboard;
   import mx.controls.listClasses.BaseListData;
   import mx.core.EdgeMetrics;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.IInvalidating;
   import mx.core.IRectangularBorder;
   import mx.core.ITextInput;
   import mx.core.IUITextField;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.events.FlexEvent;
   import mx.managers.IFocusManager;
   import mx.managers.IFocusManagerComponent;
   import mx.styles.ISimpleStyleClient;
   
   [Exclude(name="chromeColor",kind="style")]
   [Exclude(name="selectionAnchorPosition",kind="method")]
   [Exclude(name="selectionActivePosition",kind="method")]
   [Alternative(replacement="spark.components.TextInput",since="4.0")]
   [ResourceBundle("controls")]
   [IconFile("TextInput.png")]
   [DefaultTriggerEvent("change")]
   [DefaultBindingProperty(source="text",destination="text")]
   [DataBindingInfo("&quot;focusIn;focusOut&quot;")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no")]
   [Style(name="focusColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="cornerRadius",type="Number",format="Length",inherit="no",theme="halo")]
   [Style(name="contentBackgroundColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="contentBackgroundAlpha",type="Number",inherit="yes",theme="spark")]
   [Style(name="textIndent",type="Number",format="Length",inherit="yes")]
   [Style(name="textFieldClass",type="Class",inherit="no")]
   [Style(name="textDecoration",type="String",enumeration="none,underline",inherit="yes")]
   [Style(name="textAlign",type="String",enumeration="left,center,right",inherit="yes")]
   [Style(name="locale",type="String",inherit="yes")]
   [Style(name="letterSpacing",type="Number",inherit="yes")]
   [Style(name="kerning",type="Boolean",inherit="yes")]
   [Style(name="fontWeight",type="String",enumeration="normal,bold",inherit="yes")]
   [Style(name="fontThickness",type="Number",inherit="yes")]
   [Style(name="fontStyle",type="String",enumeration="normal,italic",inherit="yes")]
   [Style(name="fontSize",type="Number",format="Length",inherit="yes")]
   [Style(name="fontSharpness",type="Number",inherit="yes")]
   [Style(name="fontGridFitType",type="String",enumeration="none,pixel,subpixel",inherit="yes")]
   [Style(name="fontFamily",type="String",inherit="yes")]
   [Style(name="fontAntiAliasType",type="String",enumeration="normal,advanced",inherit="yes")]
   [Style(name="disabledColor",type="uint",format="Color",inherit="yes")]
   [Style(name="direction",type="String",enumeration="ltr,rtl,inherit",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Style(name="paddingRight",type="Number",format="Length",inherit="no")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no")]
   [Style(name="focusRoundedCorners",type="String",inherit="no")]
   [Style(name="focusAlpha",type="Number",inherit="no")]
   [Style(name="shadowDistance",type="Number",format="Length",inherit="no",theme="halo")]
   [Style(name="shadowDirection",type="String",enumeration="left,center,right",inherit="no",theme="halo")]
   [Style(name="dropShadowColor",type="uint",format="Color",inherit="yes",theme="halo")]
   [Style(name="dropShadowVisible",type="Boolean",inherit="no",theme="spark")]
   [Style(name="dropShadowEnabled",type="Boolean",inherit="no",theme="halo")]
   [Style(name="borderVisible",type="Boolean",inherit="no",theme="spark")]
   [Style(name="borderThickness",type="Number",format="Length",inherit="no",theme="halo")]
   [Style(name="borderStyle",type="String",enumeration="inset,outset,solid,none",inherit="no")]
   [Style(name="borderSkin",type="Class",inherit="no")]
   [Style(name="borderSides",type="String",inherit="no",theme="halo")]
   [Style(name="borderColor",type="uint",format="Color",inherit="no",theme="halo, spark")]
   [Style(name="borderAlpha",type="Number",inherit="no",theme="spark")]
   [Style(name="backgroundSize",type="String",inherit="no",theme="halo")]
   [Style(name="backgroundImage",type="Object",format="File",inherit="no",theme="halo")]
   [Style(name="backgroundDisabledColor",type="uint",format="Color",inherit="yes",theme="halo")]
   [Style(name="backgroundColor",type="uint",format="Color",inherit="no",theme="halo")]
   [Style(name="backgroundAlpha",type="Number",inherit="no",theme="halo")]
   [Event(name="textInput",type="flash.events.TextEvent")]
   [Event(name="enter",type="mx.events.FlexEvent")]
   [Event(name="dataChange",type="mx.events.FlexEvent")]
   [Event(name="change",type="flash.events.Event")]
   public class TextInput extends UIComponent implements ITextInput
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var border:IFlexDisplayObject;
      
      private var textSet:Boolean;
      
      private var selectionChanged:Boolean = false;
      
      private var errorCaught:Boolean = false;
      
      private var _accessibilityProperties:AccessibilityProperties;
      
      private var accessibilityPropertiesChanged:Boolean = false;
      
      private var enabledChanged:Boolean = false;
      
      private var _tabIndex:int = -1;
      
      private var tabIndexChanged:Boolean = false;
      
      private var _condenseWhite:Boolean = false;
      
      private var condenseWhiteChanged:Boolean = false;
      
      private var _data:Object;
      
      private var _displayAsPassword:Boolean = false;
      
      private var displayAsPasswordChanged:Boolean = false;
      
      private var _editable:Boolean = true;
      
      private var editableChanged:Boolean = false;
      
      private var _horizontalScrollPosition:Number = 0;
      
      private var horizontalScrollPositionChanged:Boolean = false;
      
      private var _htmlText:String = "";
      
      private var htmlTextChanged:Boolean = false;
      
      private var explicitHTMLText:String = null;
      
      private var _imeMode:String = null;
      
      private var _listData:BaseListData;
      
      private var _maxChars:int = 0;
      
      private var maxCharsChanged:Boolean = false;
      
      private var _parentDrawsFocus:Boolean = false;
      
      private var _restrict:String;
      
      private var restrictChanged:Boolean = false;
      
      private var _selectable:Boolean = true;
      
      private var selectableChanged:Boolean = false;
      
      private var _selectionBeginIndex:int = 0;
      
      private var _selectionEndIndex:int = 0;
      
      private var _text:String = "";
      
      private var textChanged:Boolean = false;
      
      protected var textField:IUITextField;
      
      private var _textHeight:Number;
      
      private var _textWidth:Number;
      
      public function TextInput()
      {
         super();
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
         invalidateProperties();
         if(Boolean(this.border) && this.border is IInvalidating)
         {
            IInvalidating(this.border).invalidateDisplayList();
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
            this.textField.setSelection(0,0);
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
      
      [Inspectable(defaultValue="0")]
      [Bindable("horizontalScrollPositionChanged")]
      public function get horizontalScrollPosition() : Number
      {
         return this._horizontalScrollPosition;
      }
      
      public function set horizontalScrollPosition(value:Number) : void
      {
         if(value == this._horizontalScrollPosition)
         {
            return;
         }
         this._horizontalScrollPosition = value;
         this.horizontalScrollPositionChanged = true;
         invalidateProperties();
         dispatchEvent(new Event("horizontalScrollPositionChanged"));
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
      
      public function get maxHorizontalScrollPosition() : Number
      {
         return Boolean(this.textField) ? Number(this.textField.maxScrollH) : 0;
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="false")]
      public function get parentDrawsFocus() : Boolean
      {
         return this._parentDrawsFocus;
      }
      
      public function set parentDrawsFocus(value:Boolean) : void
      {
         this._parentDrawsFocus = value;
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
      
      public function get selectable() : Boolean
      {
         return this._selectable;
      }
      
      public function set selectable(value:Boolean) : void
      {
         if(this._selectable == value)
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
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.createBorder();
         this.createTextField(-1);
      }
      
      override protected function commitProperties() : void
      {
         var childIndex:int = 0;
         super.commitProperties();
         if(Boolean(hasFontContextChanged()) && this.textField != null)
         {
            childIndex = int(getChildIndex(DisplayObject(this.textField)));
            this.removeTextField();
            this.createTextField(childIndex);
            this.accessibilityPropertiesChanged = true;
            this.condenseWhiteChanged = true;
            this.displayAsPasswordChanged = true;
            this.enabledChanged = true;
            this.maxCharsChanged = true;
            this.restrictChanged = true;
            this.tabIndexChanged = true;
            this.textChanged = true;
            this.selectionChanged = true;
            this.horizontalScrollPositionChanged = true;
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
         if(this.enabledChanged || this.editableChanged)
         {
            this.textField.type = enabled && this._editable ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
            if(this.enabledChanged)
            {
               if(this.textField.enabled != enabled)
               {
                  this.textField.enabled = enabled;
               }
               this.enabledChanged = false;
            }
            this.selectableChanged = true;
            this.editableChanged = false;
         }
         if(this.selectableChanged)
         {
            if(this._editable)
            {
               this.textField.selectable = enabled;
            }
            else
            {
               this.textField.selectable = enabled && this._selectable;
            }
            this.selectableChanged = false;
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
         if(this.tabIndexChanged)
         {
            this.textField.tabIndex = this._tabIndex;
            this.tabIndexChanged = false;
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
         if(this.horizontalScrollPositionChanged)
         {
            this.textField.scrollH = this._horizontalScrollPosition;
            this.horizontalScrollPositionChanged = false;
         }
      }
      
      override protected function measure() : void
      {
         var w:Number = NaN;
         var h:Number = NaN;
         var lineMetrics:TextLineMetrics = null;
         super.measure();
         var bm:EdgeMetrics = Boolean(this.border) && this.border is IRectangularBorder ? IRectangularBorder(this.border).borderMetrics : EdgeMetrics.EMPTY;
         measuredWidth = DEFAULT_MEASURED_WIDTH;
         if(Boolean(this.maxChars))
         {
            measuredWidth = Math.min(measuredWidth,measureText("W").width * this.maxChars + bm.left + bm.right + 8);
         }
         if(!this.text || this.text == "")
         {
            w = Number(DEFAULT_MEASURED_MIN_WIDTH);
            h = measureText(" ").height + bm.top + bm.bottom + UITextField.TEXT_HEIGHT_PADDING;
            h += getStyle("paddingTop") + getStyle("paddingBottom");
         }
         else
         {
            lineMetrics = measureText(this.text);
            w = lineMetrics.width + bm.left + bm.right + 8;
            h = lineMetrics.height + bm.top + bm.bottom + UITextField.TEXT_HEIGHT_PADDING;
            w += getStyle("paddingLeft") + getStyle("paddingRight");
            h += getStyle("paddingTop") + getStyle("paddingBottom");
         }
         measuredWidth = Math.max(w,measuredWidth);
         measuredHeight = Math.max(h,DEFAULT_MEASURED_HEIGHT);
         measuredMinWidth = DEFAULT_MEASURED_MIN_WIDTH;
         measuredMinHeight = DEFAULT_MEASURED_MIN_HEIGHT;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var bm:EdgeMetrics = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(Boolean(this.border))
         {
            this.border.setActualSize(unscaledWidth,unscaledHeight);
            bm = this.border is IRectangularBorder ? IRectangularBorder(this.border).borderMetrics : EdgeMetrics.EMPTY;
         }
         else
         {
            bm = EdgeMetrics.EMPTY;
         }
         var paddingLeft:Number = Number(getStyle("paddingLeft"));
         var paddingRight:Number = Number(getStyle("paddingRight"));
         var paddingTop:Number = Number(getStyle("paddingTop"));
         var paddingBottom:Number = Number(getStyle("paddingBottom"));
         var widthPad:Number = bm.left + bm.right;
         var heightPad:Number = bm.top + bm.bottom + 1;
         this.textField.x = bm.left;
         this.textField.y = bm.top;
         this.textField.x += paddingLeft;
         this.textField.y += paddingTop;
         widthPad += paddingLeft + paddingRight;
         heightPad += paddingTop + paddingBottom;
         this.textField.width = Math.max(0,unscaledWidth - widthPad);
         this.textField.height = Math.max(0,unscaledHeight - heightPad);
      }
      
      override public function setFocus() : void
      {
         this.textField.setFocus();
      }
      
      override protected function isOurFocus(target:DisplayObject) : Boolean
      {
         return target == this.textField || Boolean(super.isOurFocus(target));
      }
      
      override public function drawFocus(isFocused:Boolean) : void
      {
         if(this._parentDrawsFocus)
         {
            IFocusManagerComponent(parent).drawFocus(isFocused);
            return;
         }
         super.drawFocus(isFocused);
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var allStyles:Boolean = styleProp == null || styleProp == "styleName";
         super.styleChanged(styleProp);
         if(allStyles || styleProp == "borderSkin")
         {
            if(Boolean(this.border))
            {
               removeChild(DisplayObject(this.border));
               this.border = null;
               this.createBorder();
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createTextField(childIndex:int) : void
      {
         if(!this.textField)
         {
            this.textField = IUITextField(createInFontContext(UITextField));
            this.textField.autoSize = TextFieldAutoSize.NONE;
            this.textField.enabled = enabled;
            this.textField.ignorePadding = false;
            this.textField.multiline = false;
            this.textField.tabEnabled = true;
            this.textField.wordWrap = false;
            this.textField.addEventListener(Event.CHANGE,this.textField_changeHandler);
            this.textField.addEventListener(TextEvent.TEXT_INPUT,this.textField_textInputHandler);
            this.textField.addEventListener(Event.SCROLL,this.textField_scrollHandler);
            this.textField.addEventListener("textFieldStyleChange",this.textField_textFieldStyleChangeHandler);
            this.textField.addEventListener("textFormatChange",this.textField_textFormatChangeHandler);
            this.textField.addEventListener("textInsert",this.textField_textModifiedHandler);
            this.textField.addEventListener("textReplace",this.textField_textModifiedHandler);
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
            this.textField.removeEventListener(TextEvent.TEXT_INPUT,this.textField_textInputHandler);
            this.textField.removeEventListener(Event.SCROLL,this.textField_scrollHandler);
            this.textField.removeEventListener("textFieldStyleChange",this.textField_textFieldStyleChangeHandler);
            this.textField.removeEventListener("textFormatChange",this.textField_textFormatChangeHandler);
            this.textField.removeEventListener("textInsert",this.textField_textModifiedHandler);
            this.textField.removeEventListener("textReplace",this.textField_textModifiedHandler);
            this.textField.removeEventListener("nativeDragDrop",this.textField_nativeDragDropHandler);
            removeChild(DisplayObject(this.textField));
            this.textField = null;
         }
      }
      
      protected function createBorder() : void
      {
         var borderClass:Class = null;
         if(!this.border)
         {
            borderClass = getStyle("borderSkin");
            if(borderClass != null)
            {
               this.border = new borderClass();
               if(this.border is ISimpleStyleClient)
               {
                  ISimpleStyleClient(this.border).styleName = this;
               }
               addChildAt(DisplayObject(this.border),0);
               invalidateDisplayList();
            }
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getTextField() : IUITextField
      {
         return this.textField;
      }
      
      public function get selectionActivePosition() : int
      {
         return this.selectionEndIndex;
      }
      
      public function get selectionAnchorPosition() : int
      {
         return this.selectionBeginIndex;
      }
      
      public function showBorderAndBackground(visible:Boolean) : void
      {
         if(Boolean(this.border))
         {
            this.border.visible = visible;
         }
      }
      
      public function selectRange(anchorIndex:int, activeIndex:int) : void
      {
         this.textField.setSelection(anchorIndex,activeIndex);
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
            if(Boolean(this.textField.selectable) && this._selectionBeginIndex == this._selectionEndIndex)
            {
               this.textField.setSelection(0,this.textField.length);
            }
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
         super.focusOutHandler(event);
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         switch(event.keyCode)
         {
            case Keyboard.ENTER:
               dispatchEvent(new FlexEvent(FlexEvent.ENTER));
               if(this.textChanged || this.htmlTextChanged)
               {
                  validateNow();
               }
         }
      }
      
      private function textField_changeHandler(event:Event) : void
      {
         this.textFieldChanged(false,false);
         this.textChanged = false;
         this.htmlTextChanged = false;
         event.stopImmediatePropagation();
         dispatchEvent(new Event(Event.CHANGE));
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
      
      private function textField_scrollHandler(event:Event) : void
      {
         this._horizontalScrollPosition = this.textField.scrollH;
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
   }
}

