package mx.controls
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextLineMetrics;
   import flash.ui.Keyboard;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.FlexVersion;
   import mx.core.IDataRenderer;
   import mx.core.IIMESupport;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.NumericStepperEvent;
   import mx.managers.IFocusManager;
   import mx.managers.IFocusManagerComponent;
   import mx.styles.StyleProxy;
   
   use namespace mx_internal;
   
   [DefaultTriggerEvent("change")]
   [DefaultBindingProperty(source="value",destination="value")]
   [IconFile("NumericStepper.png")]
   [Style(name="upArrowUpSkin",type="Class",inherit="no")]
   [Style(name="upArrowOverSkin",type="Class",inherit="no")]
   [Style(name="upArrowDownSkin",type="Class",inherit="no")]
   [Style(name="upArrowDisabledSkin",type="Class",inherit="no")]
   [Style(name="upArrowSkin",type="Class",inherit="no",states="up, over, down, disabled")]
   [Style(name="highlightAlphas",type="Array",arrayType="Number",inherit="no")]
   [Style(name="downArrowUpSkin",type="Class",inherit="no")]
   [Style(name="downArrowOverSkin",type="Class",inherit="no")]
   [Style(name="downArrowDownSkin",type="Class",inherit="no")]
   [Style(name="downArrowDisabledSkin",type="Class",inherit="no")]
   [Style(name="downArrowSkin",type="Class",inherit="no",states="up, over, down, disabled")]
   [Style(name="textIndent",type="Number",format="Length",inherit="yes")]
   [Style(name="textDecoration",type="String",enumeration="none,underline",inherit="yes")]
   [Style(name="textAlign",type="String",enumeration="left,center,right",inherit="yes")]
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
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Style(name="paddingRight",type="Number",format="Length",inherit="no")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no")]
   [Style(name="leading",type="Number",format="Length",inherit="yes")]
   [Style(name="disabledIconColor",type="uint",format="Color",inherit="yes")]
   [Style(name="iconColor",type="uint",format="Color",inherit="yes")]
   [Style(name="focusRoundedCorners",type="String",inherit="no")]
   [Style(name="focusAlpha",type="Number",inherit="no")]
   [Style(name="shadowDistance",type="Number",format="Length",inherit="no")]
   [Style(name="shadowDirection",type="String",enumeration="left,center,right",inherit="no")]
   [Style(name="dropShadowColor",type="uint",format="Color",inherit="yes")]
   [Style(name="dropShadowEnabled",type="Boolean",inherit="no")]
   [Style(name="cornerRadius",type="Number",format="Length",inherit="no")]
   [Style(name="borderThickness",type="Number",format="Length",inherit="no")]
   [Style(name="borderStyle",type="String",enumeration="inset,outset,solid,none",inherit="no")]
   [Style(name="borderSkin",type="Class",inherit="no")]
   [Style(name="borderSides",type="String",inherit="no")]
   [Style(name="borderColor",type="uint",format="Color",inherit="no")]
   [Style(name="backgroundSize",type="String",inherit="no")]
   [Style(name="backgroundImage",type="Object",format="File",inherit="no")]
   [Style(name="backgroundDisabledColor",type="uint",format="Color",inherit="yes")]
   [Style(name="backgroundColor",type="uint",format="Color",inherit="no")]
   [Style(name="backgroundAlpha",type="Number",inherit="no")]
   [Event(name="dataChange",type="mx.events.FlexEvent")]
   [Event(name="change",type="mx.events.NumericStepperEvent")]
   public class NumericStepper extends UIComponent implements IDataRenderer, IDropInListItemRenderer, IFocusManagerComponent, IIMESupport, IListItemRenderer
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static var _downArrowStyleFilters:Object = {
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
      
      private var valueChanged:Boolean = false;
      
      mx_internal var nextButton:Button;
      
      private var valueSet:Boolean;
      
      private var enabledChanged:Boolean = false;
      
      mx_internal var prevButton:Button;
      
      private var _maxChars:int = 0;
      
      private var _stepSize:Number = 1;
      
      mx_internal var inputField:TextInput;
      
      private var _value:Number = 0;
      
      private var lastValue:Number = 0;
      
      private var _data:Object;
      
      private var maxCharsChanged:Boolean = false;
      
      private var _tabIndex:int = -1;
      
      private var proposedValue:Number = 0;
      
      private var tabIndexChanged:Boolean = false;
      
      private var _previousValue:Number = 0;
      
      private var _nextValue:Number = 0;
      
      private var _imeMode:String = null;
      
      private var _listData:BaseListData;
      
      private var _minimum:Number = 0;
      
      private var _maximum:Number = 10;
      
      public function NumericStepper()
      {
         super();
         tabChildren = true;
      }
      
      [Inspectable(defaultValue="")]
      public function get imeMode() : String
      {
         return _imeMode;
      }
      
      public function set imeMode(value:String) : void
      {
         _imeMode = value;
         if(Boolean(inputField))
         {
            inputField.imeMode = _imeMode;
         }
      }
      
      [Inspectable(category="General",defaultValue="0")]
      [Bindable("minimumChanged")]
      public function get minimum() : Number
      {
         return _minimum;
      }
      
      override protected function focusOutHandler(event:FocusEvent) : void
      {
         var fm:IFocusManager = focusManager;
         if(Boolean(fm))
         {
            fm.defaultButtonEnabled = true;
         }
         super.focusOutHandler(event);
         takeValueFromTextField(event);
      }
      
      private function checkRange(v:Number) : Boolean
      {
         return v >= minimum && v <= maximum;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!inputField)
         {
            inputField = new TextInput();
            inputField.styleName = new StyleProxy(this,inputFieldStyleFilters);
            inputField.focusEnabled = false;
            inputField.restrict = "0-9\\-\\.\\,";
            inputField.maxChars = _maxChars;
            inputField.text = String(_value);
            inputField.parentDrawsFocus = true;
            inputField.imeMode = _imeMode;
            inputField.addEventListener(FocusEvent.FOCUS_IN,inputField_focusInHandler);
            inputField.addEventListener(FocusEvent.FOCUS_OUT,inputField_focusOutHandler);
            inputField.addEventListener(KeyboardEvent.KEY_DOWN,inputField_keyDownHandler);
            inputField.addEventListener(Event.CHANGE,inputField_changeHandler);
            addChild(inputField);
         }
         if(!nextButton)
         {
            nextButton = new Button();
            nextButton.styleName = new StyleProxy(this,upArrowStyleFilters);
            nextButton.upSkinName = "upArrowUpSkin";
            nextButton.overSkinName = "upArrowOverSkin";
            nextButton.downSkinName = "upArrowDownSkin";
            nextButton.disabledSkinName = "upArrowDisabledSkin";
            nextButton.skinName = "upArrowSkin";
            nextButton.upIconName = "";
            nextButton.overIconName = "";
            nextButton.downIconName = "";
            nextButton.disabledIconName = "";
            nextButton.focusEnabled = false;
            nextButton.autoRepeat = true;
            nextButton.addEventListener(MouseEvent.CLICK,buttonClickHandler);
            nextButton.addEventListener(FlexEvent.BUTTON_DOWN,buttonDownHandler);
            addChild(nextButton);
         }
         if(!prevButton)
         {
            prevButton = new Button();
            prevButton.styleName = new StyleProxy(this,downArrowStyleFilters);
            prevButton.upSkinName = "downArrowUpSkin";
            prevButton.overSkinName = "downArrowOverSkin";
            prevButton.downSkinName = "downArrowDownSkin";
            prevButton.disabledSkinName = "downArrowDisabledSkin";
            prevButton.skinName = "downArrowSkin";
            prevButton.upIconName = "";
            prevButton.overIconName = "";
            prevButton.downIconName = "";
            prevButton.disabledIconName = "";
            prevButton.focusEnabled = false;
            prevButton.autoRepeat = true;
            prevButton.addEventListener(MouseEvent.CLICK,buttonClickHandler);
            prevButton.addEventListener(FlexEvent.BUTTON_DOWN,buttonDownHandler);
            addChild(prevButton);
         }
      }
      
      public function set minimum(value:Number) : void
      {
         _minimum = value;
         if(!valueChanged)
         {
            this.value = this.value;
            valueSet = false;
         }
         dispatchEvent(new Event("minimumChanged"));
      }
      
      [Inspectable(category="General",defaultValue="10")]
      [Bindable("maximumChanged")]
      public function get maximum() : Number
      {
         return _maximum;
      }
      
      private function inputField_focusOutHandler(event:FocusEvent) : void
      {
         focusOutHandler(event);
         dispatchEvent(new FocusEvent(event.type,false,false,event.relatedObject,event.shiftKey,event.keyCode));
      }
      
      private function setValue(value:Number, sendEvent:Boolean = true, trigger:Event = null) : void
      {
         var event:NumericStepperEvent = null;
         var v:Number = checkValidValue(value);
         if(v == lastValue)
         {
            return;
         }
         lastValue = _value = v;
         inputField.text = v.toString();
         if(sendEvent)
         {
            event = new NumericStepperEvent(NumericStepperEvent.CHANGE);
            event.value = _value;
            event.triggerEvent = trigger;
            dispatchEvent(event);
         }
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      protected function get downArrowStyleFilters() : Object
      {
         return _downArrowStyleFilters;
      }
      
      private function takeValueFromTextField(trigger:Event = null) : void
      {
         var newValue:Number = NaN;
         var inputValue:Number = Number(inputField.text);
         if(inputValue != lastValue && (Math.abs(inputValue - lastValue) >= 0.000001 || isNaN(inputValue)) || inputField.text == "")
         {
            newValue = checkValidValue(Number(inputField.text));
            inputField.text = newValue.toString();
            setValue(newValue,trigger != null,trigger);
         }
      }
      
      private function inputField_focusInHandler(event:FocusEvent) : void
      {
         focusInHandler(event);
         dispatchEvent(new FocusEvent(event.type,false,false,event.relatedObject,event.shiftKey,event.keyCode));
      }
      
      override public function get tabIndex() : int
      {
         return _tabIndex;
      }
      
      public function get nextValue() : Number
      {
         if(checkRange(value + stepSize))
         {
            _nextValue = value + stepSize;
         }
         return _nextValue;
      }
      
      public function set maximum(value:Number) : void
      {
         _maximum = value;
         if(!valueChanged)
         {
            this.value = this.value;
            valueSet = false;
         }
         dispatchEvent(new Event("maximumChanged"));
      }
      
      override public function get enabled() : Boolean
      {
         return super.enabled;
      }
      
      override protected function isOurFocus(target:DisplayObject) : Boolean
      {
         return target == inputField || Boolean(super.isOurFocus(target));
      }
      
      private function buttonPress(button:Button, trigger:Event = null) : void
      {
         var oldValue:Number = NaN;
         if(enabled)
         {
            takeValueFromTextField();
            oldValue = lastValue;
            setValue(button == nextButton ? lastValue + stepSize : lastValue - stepSize,true,trigger);
            if(oldValue != lastValue)
            {
               inputField.getTextField().setSelection(0,0);
            }
         }
      }
      
      public function set data(value:Object) : void
      {
         _data = value;
         if(!valueSet)
         {
            this.value = Boolean(_listData) ? parseFloat(_listData.label) : Number(_data);
            valueSet = false;
         }
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      protected function get upArrowStyleFilters() : Object
      {
         return _upArrowStyleFilters;
      }
      
      private function inputField_keyDownHandler(event:KeyboardEvent) : void
      {
         var tmpV:Number = NaN;
         var inputValue:Number = NaN;
         var newValue:Number = NaN;
         switch(event.keyCode)
         {
            case Keyboard.DOWN:
               tmpV = value - stepSize;
               setValue(tmpV,true);
               break;
            case Keyboard.UP:
               tmpV = stepSize + value;
               setValue(tmpV,true);
               break;
            case Keyboard.HOME:
               inputField.text = minimum.toString();
               setValue(minimum,true);
               break;
            case Keyboard.END:
               inputField.text = maximum.toString();
               setValue(maximum,true);
               break;
            case Keyboard.ENTER:
            case Keyboard.TAB:
               inputValue = Number(inputField.text);
               if(inputValue != lastValue && (Math.abs(inputValue - lastValue) >= 0.000001 || isNaN(inputValue)))
               {
                  newValue = checkValidValue(Number(inputField.text));
                  inputField.text = newValue.toString();
                  setValue(newValue,true);
               }
               event.stopImmediatePropagation();
         }
         dispatchEvent(event);
      }
      
      override protected function measure() : void
      {
         var h:Number = NaN;
         var w:Number = NaN;
         super.measure();
         var widestNumber:Number = minimum.toString().length > maximum.toString().length ? minimum : maximum;
         widestNumber += stepSize;
         var lineMetrics:TextLineMetrics = measureText(checkValidValue(widestNumber).toString());
         var textHeight:Number = inputField.getExplicitOrMeasuredHeight();
         var buttonHeight:Number = prevButton.getExplicitOrMeasuredHeight() + nextButton.getExplicitOrMeasuredHeight();
         h = Math.max(textHeight,buttonHeight);
         h = Math.max(DEFAULT_MEASURED_MIN_HEIGHT,h);
         var textWidth:Number = lineMetrics.width + UITextField.TEXT_WIDTH_PADDING;
         var buttonWidth:Number = Math.max(prevButton.getExplicitOrMeasuredWidth(),nextButton.getExplicitOrMeasuredWidth());
         w = textWidth + buttonWidth + 20;
         w = Math.max(DEFAULT_MEASURED_MIN_WIDTH,w);
         measuredMinWidth = DEFAULT_MEASURED_MIN_WIDTH;
         measuredMinHeight = DEFAULT_MEASURED_MIN_HEIGHT;
         measuredWidth = w;
         measuredHeight = h;
      }
      
      [Inspectable(environment="none")]
      [Bindable("dataChange")]
      public function get listData() : BaseListData
      {
         return _listData;
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
      
      [Inspectable(category="General",defaultValue="0")]
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get value() : Number
      {
         return valueChanged ? proposedValue : _value;
      }
      
      protected function get inputFieldStyleFilters() : Object
      {
         return _inputFieldStyleFilters;
      }
      
      override public function set tabIndex(value:int) : void
      {
         if(value == _tabIndex)
         {
            return;
         }
         _tabIndex = value;
         tabIndexChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="true")]
      override public function set enabled(value:Boolean) : void
      {
         super.enabled = value;
         enabledChanged = true;
         invalidateProperties();
      }
      
      override public function get baselinePosition() : Number
      {
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            return Boolean(inputField) ? inputField.baselinePosition : NaN;
         }
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         return inputField.y + inputField.baselinePosition;
      }
      
      override public function setFocus() : void
      {
         if(Boolean(stage))
         {
            stage.focus = TextField(inputField.getTextField());
         }
      }
      
      [Inspectable(environment="none")]
      [Bindable("dataChange")]
      public function get data() : Object
      {
         if(!_listData)
         {
            data = this.value;
         }
         return _data;
      }
      
      public function set maxChars(value:int) : void
      {
         if(value == _maxChars)
         {
            return;
         }
         _maxChars = value;
         maxCharsChanged = true;
         invalidateProperties();
         dispatchEvent(new Event("maxCharsChanged"));
      }
      
      private function buttonDownHandler(event:FlexEvent) : void
      {
         buttonPress(Button(event.currentTarget),event);
      }
      
      public function get previousValue() : Number
      {
         if(checkRange(_value - stepSize))
         {
            _previousValue = value - stepSize;
         }
         return _previousValue;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(maxCharsChanged)
         {
            maxCharsChanged = false;
            inputField.maxChars = _maxChars;
         }
         if(valueChanged)
         {
            valueChanged = false;
            setValue(isNaN(proposedValue) ? 0 : proposedValue,false);
         }
         if(enabledChanged)
         {
            enabledChanged = false;
            prevButton.enabled = enabled;
            nextButton.enabled = enabled;
            inputField.enabled = enabled;
         }
         if(tabIndexChanged)
         {
            inputField.tabIndex = _tabIndex;
            tabIndexChanged = false;
         }
      }
      
      private function inputField_changeHandler(event:Event) : void
      {
         event.stopImmediatePropagation();
         var inputValue:Number = Number(inputField.text);
         if(inputValue != value && (Math.abs(inputValue - value) >= 0.000001 || isNaN(inputValue)) || inputField.text == "")
         {
            _value = checkValidValue(inputValue);
         }
      }
      
      public function set listData(value:BaseListData) : void
      {
         _listData = value;
      }
      
      [Bindable("maxCharsChanged")]
      public function get maxChars() : int
      {
         return _maxChars;
      }
      
      public function set stepSize(value:Number) : void
      {
         _stepSize = value;
         if(!valueChanged)
         {
            this.value = this.value;
            valueSet = false;
         }
         dispatchEvent(new Event("stepSizeChanged"));
      }
      
      public function set value(value:Number) : void
      {
         valueSet = true;
         proposedValue = value;
         valueChanged = true;
         invalidateProperties();
         invalidateSize();
      }
      
      [Inspectable(category="General",defaultValue="1")]
      [Bindable("stepSizeChanged")]
      public function get stepSize() : Number
      {
         return _stepSize;
      }
      
      private function buttonClickHandler(event:MouseEvent) : void
      {
         inputField.setFocus();
         inputField.getTextField().setSelection(0,0);
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var w:Number = nextButton.getExplicitOrMeasuredWidth();
         var h:Number = Math.round(unscaledHeight / 2);
         var h2:Number = unscaledHeight - h;
         nextButton.x = unscaledWidth - w;
         nextButton.y = 0;
         nextButton.setActualSize(w,h2);
         prevButton.x = unscaledWidth - w;
         prevButton.y = unscaledHeight - h;
         prevButton.setActualSize(w,h);
         inputField.setActualSize(unscaledWidth - w,unscaledHeight);
      }
      
      private function checkValidValue(value:Number) : Number
      {
         var scale:Number = NaN;
         if(isNaN(value))
         {
            return this.value;
         }
         var closest:Number = stepSize * Math.round(value / stepSize);
         var parts:Array = new String(1 + stepSize).split(".");
         if(parts.length == 2)
         {
            scale = Math.pow(10,parts[1].length);
            closest = Math.round(closest * scale) / scale;
         }
         if(closest > maximum)
         {
            return maximum;
         }
         if(closest < minimum)
         {
            return minimum;
         }
         return closest;
      }
   }
}

