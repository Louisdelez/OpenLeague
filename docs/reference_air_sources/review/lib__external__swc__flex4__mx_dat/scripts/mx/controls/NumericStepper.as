package mx.controls
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextLineMetrics;
   import flash.ui.Keyboard;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.FlexVersion;
   import mx.core.IDataRenderer;
   import mx.core.IIMESupport;
   import mx.core.ITextInput;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.events.FlexEvent;
   import mx.events.NumericStepperEvent;
   import mx.managers.IFocusManager;
   import mx.managers.IFocusManagerComponent;
   import mx.styles.StyleProxy;
   
   [Alternative(replacement="spark.components.NumericStepper",since="4.0")]
   [DefaultTriggerEvent("change")]
   [DefaultBindingProperty(source="value",destination="value")]
   [IconFile("NumericStepper.png")]
   [Style(name="upArrowUpSkin",type="Class",inherit="no")]
   [Style(name="upArrowOverSkin",type="Class",inherit="no")]
   [Style(name="upArrowDownSkin",type="Class",inherit="no")]
   [Style(name="upArrowDisabledSkin",type="Class",inherit="no")]
   [Style(name="upArrowSkin",type="Class",inherit="no",states="up, over, down, disabled")]
   [Style(name="textInputClass",type="Class",inherit="no")]
   [Style(name="symbolColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="highlightAlphas",type="Array",arrayType="Number",inherit="no",theme="halo")]
   [Style(name="focusColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="downArrowUpSkin",type="Class",inherit="no")]
   [Style(name="downArrowOverSkin",type="Class",inherit="no")]
   [Style(name="downArrowDownSkin",type="Class",inherit="no")]
   [Style(name="downArrowDisabledSkin",type="Class",inherit="no")]
   [Style(name="downArrowSkin",type="Class",inherit="no",states="up, over, down, disabled")]
   [Style(name="cornerRadius",type="Number",format="Length",inherit="no",theme="halo, spark")]
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
   [Style(name="leading",type="Number",format="Length",inherit="yes")]
   [Style(name="disabledIconColor",type="uint",format="Color",inherit="yes",theme="halo")]
   [Style(name="iconColor",type="uint",format="Color",inherit="yes",theme="halo")]
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
   [Event(name="dataChange",type="mx.events.FlexEvent")]
   [Event(name="change",type="mx.events.NumericStepperEvent")]
   public class NumericStepper extends UIComponent implements IDataRenderer, IDropInListItemRenderer, IFocusManagerComponent, IIMESupport, IListItemRenderer
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var _downArrowStyleFilters:Object = {
         "borderColor":"borderColor",
         "cornerRadius":"cornerRadius",
         "highlightAlphas":"highlightAlphas",
         "downArrowUpSkin":"downArrowUpSkin",
         "downArrowOverSkin":"downArrowOverSkin",
         "downArrowDownSkin":"downArrowDownSkin",
         "downArrowDisabledSkin":"downArrowDisabledSkin",
         "downArrowSkin":"downArrowSkin",
         "repeatDelay":"repeatDelay",
         "repeatInterval":"repeatInterval"
      };
      
      private static var _inputFieldStyleFilters:Object = {
         "backgroundAlpha":"backgroundAlpha",
         "backgroundColor":"backgroundColor",
         "backgroundImage":"backgroundImage",
         "backgroundDisabledColor":"backgroundDisabledColor",
         "backgroundSize":"backgroundSize",
         "borderAlpha":"borderAlpha",
         "borderColor":"borderColor",
         "borderSides":"borderSides",
         "borderSkin":"borderSkin",
         "borderStyle":"borderStyle",
         "borderThickness":"borderThickness",
         "borderVisible":"borderVisible",
         "dropShadowColor":"dropShadowColor",
         "dropShadowEnabled":"dropShadowEnabled",
         "embedFonts":"embedFonts",
         "focusAlpha":"focusAlpha",
         "focusBlendMode":"focusBlendMode",
         "focusRoundedCorners":"focusRoundedCorners",
         "focusThickness":"focusThickness",
         "paddingLeft":"paddingLeft",
         "paddingRight":"paddingRight",
         "shadowDirection":"shadowDirection",
         "shadowDistance":"shadowDistance",
         "textDecoration":"textDecoration"
      };
      
      private static var _upArrowStyleFilters:Object = {
         "borderColor":"borderColor",
         "cornerRadius":"cornerRadius",
         "highlightAlphas":"highlightAlphas",
         "upArrowUpSkin":"upArrowUpSkin",
         "upArrowOverSkin":"upArrowOverSkin",
         "upArrowDownSkin":"upArrowDownSkin",
         "upArrowDisabledSkin":"upArrowDisabledSkin",
         "upArrowSkin":"upArrowSkin",
         "repeatDelay":"repeatDelay",
         "repeatInterval":"repeatInterval"
      };
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var inputField:ITextInput;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var nextButton:Button;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var prevButton:Button;
      
      private var valueSet:Boolean;
      
      private var enabledChanged:Boolean = false;
      
      private var _tabIndex:int = -1;
      
      private var tabIndexChanged:Boolean = false;
      
      private var _data:Object;
      
      private var _imeMode:String = null;
      
      private var _listData:BaseListData;
      
      private var _maxChars:int = 0;
      
      private var maxCharsChanged:Boolean = false;
      
      private var _maximum:Number = 10;
      
      private var _minimum:Number = 0;
      
      private var _nextValue:Number = 0;
      
      private var _previousValue:Number = 0;
      
      private var _stepSize:Number = 1;
      
      private var _value:Number = 0;
      
      private var lastValue:Number = 0;
      
      private var proposedValue:Number = 0;
      
      private var valueChanged:Boolean = false;
      
      public function NumericStepper()
      {
         super();
      }
      
      override public function get baselinePosition() : Number
      {
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         return this.inputField.y + this.inputField.baselinePosition;
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="true")]
      override public function set enabled(value:Boolean) : void
      {
         super.enabled = value;
         this.enabledChanged = true;
         invalidateProperties();
      }
      
      override public function get enabled() : Boolean
      {
         return super.enabled;
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
      
      [Inspectable(environment="none")]
      [Bindable("dataChange")]
      public function get data() : Object
      {
         if(!this._listData)
         {
            this.data = this.value;
         }
         return this._data;
      }
      
      public function set data(value:Object) : void
      {
         this._data = value;
         if(!this.valueSet)
         {
            this.value = Boolean(this._listData) ? parseFloat(this._listData.label) : Number(this._data);
            this.valueSet = false;
         }
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      protected function get downArrowStyleFilters() : Object
      {
         return _downArrowStyleFilters;
      }
      
      public function get enableIME() : Boolean
      {
         return true;
      }
      
      [Inspectable(defaultValue="")]
      public function get imeMode() : String
      {
         return this._imeMode;
      }
      
      public function set imeMode(value:String) : void
      {
         this._imeMode = value;
         if(Boolean(this.inputField))
         {
            this.inputField.imeMode = this._imeMode;
         }
      }
      
      protected function get inputFieldStyleFilters() : Object
      {
         return _inputFieldStyleFilters;
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
      
      [Inspectable(category="General",defaultValue="10")]
      [Bindable("maximumChanged")]
      public function get maximum() : Number
      {
         return this._maximum;
      }
      
      public function set maximum(value:Number) : void
      {
         this._maximum = value;
         if(!this.valueChanged)
         {
            this.value = this.value;
            this.valueSet = false;
         }
         dispatchEvent(new Event("maximumChanged"));
      }
      
      [Inspectable(category="General",defaultValue="0")]
      [Bindable("minimumChanged")]
      public function get minimum() : Number
      {
         return this._minimum;
      }
      
      public function set minimum(value:Number) : void
      {
         this._minimum = value;
         if(!this.valueChanged)
         {
            this.value = this.value;
            this.valueSet = false;
         }
         dispatchEvent(new Event("minimumChanged"));
      }
      
      public function get nextValue() : Number
      {
         if(this.checkRange(this.value + this.stepSize))
         {
            this._nextValue = this.value + this.stepSize;
         }
         return this._nextValue;
      }
      
      public function get previousValue() : Number
      {
         if(this.checkRange(this._value - this.stepSize))
         {
            this._previousValue = this.value - this.stepSize;
         }
         return this._previousValue;
      }
      
      [Inspectable(category="General",defaultValue="1")]
      [Bindable("stepSizeChanged")]
      public function get stepSize() : Number
      {
         return this._stepSize;
      }
      
      public function set stepSize(value:Number) : void
      {
         this._stepSize = value;
         if(!this.valueChanged)
         {
            this.value = this.value;
            this.valueSet = false;
         }
         dispatchEvent(new Event("stepSizeChanged"));
      }
      
      protected function get upArrowStyleFilters() : Object
      {
         return _upArrowStyleFilters;
      }
      
      [Inspectable(category="General",defaultValue="0")]
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get value() : Number
      {
         return this.valueChanged ? this.proposedValue : this._value;
      }
      
      public function set value(value:Number) : void
      {
         this.valueSet = true;
         this.proposedValue = value;
         this.valueChanged = true;
         invalidateProperties();
         invalidateSize();
      }
      
      override protected function createChildren() : void
      {
         var textInputClass:Class = null;
         super.createChildren();
         if(!this.inputField)
         {
            textInputClass = getStyle("textInputClass");
            if(!textInputClass || FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
            {
               this.inputField = new TextInput();
            }
            else
            {
               this.inputField = new textInputClass();
            }
            this.inputField.styleName = new StyleProxy(this,this.inputFieldStyleFilters);
            this.inputField.focusEnabled = false;
            this.inputField.restrict = "0-9\\-\\.\\,";
            this.inputField.maxChars = this._maxChars;
            this.inputField.text = String(this._value);
            this.inputField.parentDrawsFocus = true;
            this.inputField.imeMode = this._imeMode;
            this.inputField.addEventListener(FocusEvent.FOCUS_IN,this.inputField_focusInHandler);
            this.inputField.addEventListener(FocusEvent.FOCUS_OUT,this.inputField_focusOutHandler);
            this.inputField.addEventListener(KeyboardEvent.KEY_DOWN,this.inputField_keyDownHandler);
            this.inputField.addEventListener(Event.CHANGE,this.inputField_changeHandler);
            addChild(DisplayObject(this.inputField));
         }
         if(!this.nextButton)
         {
            this.nextButton = new Button();
            this.nextButton.styleName = new StyleProxy(this,this.upArrowStyleFilters);
            this.nextButton.upSkinName = "upArrowUpSkin";
            this.nextButton.overSkinName = "upArrowOverSkin";
            this.nextButton.downSkinName = "upArrowDownSkin";
            this.nextButton.disabledSkinName = "upArrowDisabledSkin";
            this.nextButton.skinName = "upArrowSkin";
            this.nextButton.upIconName = "";
            this.nextButton.overIconName = "";
            this.nextButton.downIconName = "";
            this.nextButton.disabledIconName = "";
            this.nextButton.focusEnabled = false;
            this.nextButton.tabEnabled = false;
            this.nextButton.autoRepeat = true;
            this.nextButton.addEventListener(MouseEvent.CLICK,this.buttonClickHandler);
            this.nextButton.addEventListener(FlexEvent.BUTTON_DOWN,this.buttonDownHandler);
            addChild(this.nextButton);
         }
         if(!this.prevButton)
         {
            this.prevButton = new Button();
            this.prevButton.styleName = new StyleProxy(this,this.downArrowStyleFilters);
            this.prevButton.upSkinName = "downArrowUpSkin";
            this.prevButton.overSkinName = "downArrowOverSkin";
            this.prevButton.downSkinName = "downArrowDownSkin";
            this.prevButton.disabledSkinName = "downArrowDisabledSkin";
            this.prevButton.skinName = "downArrowSkin";
            this.prevButton.upIconName = "";
            this.prevButton.overIconName = "";
            this.prevButton.downIconName = "";
            this.prevButton.disabledIconName = "";
            this.prevButton.focusEnabled = false;
            this.prevButton.tabEnabled = false;
            this.prevButton.autoRepeat = true;
            this.prevButton.addEventListener(MouseEvent.CLICK,this.buttonClickHandler);
            this.prevButton.addEventListener(FlexEvent.BUTTON_DOWN,this.buttonDownHandler);
            addChild(this.prevButton);
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.maxCharsChanged)
         {
            this.maxCharsChanged = false;
            this.inputField.maxChars = this._maxChars;
         }
         if(this.valueChanged)
         {
            this.valueChanged = false;
            this.setValue(isNaN(this.proposedValue) ? 0 : this.proposedValue,false);
         }
         if(this.enabledChanged)
         {
            this.enabledChanged = false;
            this.prevButton.enabled = this.enabled;
            this.nextButton.enabled = this.enabled;
            this.inputField.enabled = this.enabled;
         }
         if(this.tabIndexChanged)
         {
            this.inputField.tabIndex = this._tabIndex;
            this.tabIndexChanged = false;
         }
      }
      
      override protected function measure() : void
      {
         var h:Number = NaN;
         var w:Number = NaN;
         super.measure();
         var widestNumber:Number = this.minimum.toString().length > this.maximum.toString().length ? this.minimum : this.maximum;
         widestNumber += this.stepSize;
         var lineMetrics:TextLineMetrics = measureText(this.checkValidValue(widestNumber).toString());
         var textHeight:Number = Number(this.inputField.getExplicitOrMeasuredHeight());
         var buttonHeight:Number = this.prevButton.getExplicitOrMeasuredHeight() + this.nextButton.getExplicitOrMeasuredHeight();
         h = Math.max(textHeight,buttonHeight);
         h = Math.max(DEFAULT_MEASURED_MIN_HEIGHT,h);
         var textWidth:Number = lineMetrics.width + UITextField.TEXT_WIDTH_PADDING;
         var buttonWidth:Number = Math.max(this.prevButton.getExplicitOrMeasuredWidth(),this.nextButton.getExplicitOrMeasuredWidth());
         w = textWidth + buttonWidth + 20;
         w = Math.max(DEFAULT_MEASURED_MIN_WIDTH,w);
         measuredMinWidth = DEFAULT_MEASURED_MIN_WIDTH;
         measuredMinHeight = DEFAULT_MEASURED_MIN_HEIGHT;
         measuredWidth = w;
         measuredHeight = h;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var w:Number = Number(this.nextButton.getExplicitOrMeasuredWidth());
         var h:Number = Math.round(unscaledHeight / 2);
         var h2:Number = unscaledHeight - h;
         this.nextButton.x = unscaledWidth - w;
         this.nextButton.y = 0;
         this.nextButton.setActualSize(w,h);
         this.prevButton.x = unscaledWidth - w;
         this.prevButton.y = h;
         this.prevButton.setActualSize(w,h2);
         this.inputField.setActualSize(unscaledWidth - w,unscaledHeight);
      }
      
      override public function setFocus() : void
      {
         this.inputField.setFocus();
      }
      
      override protected function isOurFocus(target:DisplayObject) : Boolean
      {
         return target == this.inputField || Boolean(super.isOurFocus(target));
      }
      
      private function checkRange(v:Number) : Boolean
      {
         return v >= this.minimum && v <= this.maximum;
      }
      
      private function checkValidValue(value:Number) : Number
      {
         var scale:Number = NaN;
         if(isNaN(value))
         {
            return this.value;
         }
         var closest:Number = this.stepSize * Math.round(value / this.stepSize);
         var parts:Array = new String(1 + this.stepSize).split(".");
         if(parts.length == 2)
         {
            scale = Math.pow(10,parts[1].length);
            closest = Math.round(closest * scale) / scale;
         }
         if(closest > this.maximum)
         {
            return this.maximum;
         }
         if(closest < this.minimum)
         {
            return this.minimum;
         }
         return closest;
      }
      
      private function setValue(value:Number, sendEvent:Boolean = true, trigger:Event = null) : void
      {
         var event:NumericStepperEvent = null;
         var v:Number = this.checkValidValue(value);
         if(v == this.lastValue)
         {
            return;
         }
         this.lastValue = this._value = v;
         this.inputField.text = v.toString();
         if(sendEvent)
         {
            event = new NumericStepperEvent(NumericStepperEvent.CHANGE);
            event.value = this._value;
            event.triggerEvent = trigger;
            dispatchEvent(event);
         }
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      private function takeValueFromTextField(trigger:Event = null) : void
      {
         var newValue:Number = NaN;
         var inputValue:Number = Number(this.inputField.text);
         if(inputValue != this.lastValue && (Math.abs(inputValue - this.lastValue) >= 0.000001 || isNaN(inputValue)) || this.inputField.text == "" || Boolean(this.inputField.text) && Boolean(this.inputField.text.length != this.lastValue.toString().length))
         {
            newValue = this.checkValidValue(Number(this.inputField.text));
            this.inputField.text = newValue.toString();
            this.setValue(newValue,trigger != null,trigger);
         }
      }
      
      private function buttonPress(button:Button, trigger:Event = null) : void
      {
         var oldValue:Number = NaN;
         if(this.enabled)
         {
            this.takeValueFromTextField();
            oldValue = this.lastValue;
            this.setValue(button == this.nextButton ? this.lastValue + this.stepSize : this.lastValue - this.stepSize,true,trigger);
            if(oldValue != this.lastValue)
            {
               this.inputField.selectRange(0,0);
            }
         }
      }
      
      override protected function focusInHandler(event:FocusEvent) : void
      {
         super.focusInHandler(event);
         var fm:IFocusManager = focusManager;
         if(Boolean(fm))
         {
            fm.defaultButtonEnabled = false;
         }
      }
      
      override protected function focusOutHandler(event:FocusEvent) : void
      {
         var fm:IFocusManager = focusManager;
         if(Boolean(fm) && event.target == this)
         {
            fm.defaultButtonEnabled = true;
         }
         super.focusOutHandler(event);
         this.takeValueFromTextField(event);
      }
      
      private function buttonDownHandler(event:FlexEvent) : void
      {
         this.buttonPress(Button(event.currentTarget),event);
      }
      
      private function buttonClickHandler(event:MouseEvent) : void
      {
         this.inputField.setFocus();
         this.inputField.selectRange(0,0);
      }
      
      private function inputField_focusInHandler(event:FocusEvent) : void
      {
         this.focusInHandler(event);
         dispatchEvent(new FocusEvent(event.type,false,false,event.relatedObject,event.shiftKey,event.keyCode));
      }
      
      private function inputField_focusOutHandler(event:FocusEvent) : void
      {
         this.focusOutHandler(event);
         dispatchEvent(new FocusEvent(event.type,false,false,event.relatedObject,event.shiftKey,event.keyCode));
      }
      
      private function inputField_keyDownHandler(event:KeyboardEvent) : void
      {
         var tmpV:Number = NaN;
         var inputValue:Number = NaN;
         var newValue:Number = NaN;
         switch(event.keyCode)
         {
            case Keyboard.DOWN:
               tmpV = this.value - this.stepSize;
               this.setValue(tmpV,true);
               break;
            case Keyboard.UP:
               tmpV = this.stepSize + this.value;
               this.setValue(tmpV,true);
               break;
            case Keyboard.HOME:
               this.inputField.text = this.minimum.toString();
               this.setValue(this.minimum,true);
               break;
            case Keyboard.END:
               this.inputField.text = this.maximum.toString();
               this.setValue(this.maximum,true);
               break;
            case Keyboard.ENTER:
            case Keyboard.TAB:
               inputValue = Number(this.inputField.text);
               if(inputValue != this.lastValue && (Math.abs(inputValue - this.lastValue) >= 0.000001 || isNaN(inputValue)) || Boolean(this.inputField.text) && Boolean(this.inputField.text.length != this.lastValue.toString().length))
               {
                  newValue = this.checkValidValue(Number(this.inputField.text));
                  this.inputField.text = newValue.toString();
                  this.inputField.validateNow();
                  this.setValue(newValue,true);
               }
               event.stopImmediatePropagation();
         }
         dispatchEvent(event);
      }
      
      private function inputField_changeHandler(event:Event) : void
      {
         event.stopImmediatePropagation();
         var inputValue:Number = Number(this.inputField.text);
         if(inputValue != this.value && (Math.abs(inputValue - this.value) >= 0.000001 || isNaN(inputValue)) || this.inputField.text == "")
         {
            this._value = this.checkValidValue(inputValue);
         }
      }
   }
}

