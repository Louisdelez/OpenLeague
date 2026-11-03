package spark.components
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.globalization.LocaleID;
   import flash.globalization.NumberFormatter;
   import mx.core.IIMESupport;
   import mx.events.FlexEvent;
   import mx.managers.IFocusManagerComponent;
   
   [DiscouragedForProfile("mobileDevice")]
   [IconFile("NumericStepper.png")]
   [DefaultTriggerEvent("change")]
   [AccessibilityClass(implementation="spark.accessibility.NumericStepperAccImpl")]
   [Style(name="contentBackgroundColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="contentBackgroundAlpha",type="Number",inherit="yes",theme="spark")]
   [Style(name="borderVisible",type="Boolean",inherit="no",theme="spark")]
   [Style(name="borderColor",type="uint",format="Color",inherit="no",theme="spark")]
   [Style(name="borderAlpha",type="Number",inherit="no",theme="spark")]
   [Style(name="unfocusedTextSelectionColor",type="uint",format="Color",inherit="yes")]
   [Style(name="inactiveTextSelectionColor",type="uint",format="Color",inherit="yes")]
   [Style(name="focusedTextSelectionColor",type="uint",format="Color",inherit="yes")]
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
   public class NumericStepper extends Spinner implements IFocusManagerComponent, IIMESupport
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var _skinParts:Object = {
         "incrementButton":false,
         "decrementButton":false,
         "textDisplay":true
      };
      
      [SkinPart(required="true")]
      public var textDisplay:TextInput;
      
      private var dataFormatter:NumberFormatter;
      
      private var maxChanged:Boolean = false;
      
      private var stepSizeChanged:Boolean = false;
      
      private var _maxChars:int = 0;
      
      private var maxCharsChanged:Boolean = false;
      
      private var _valueFormatFunction:Function;
      
      private var valueFormatFunctionChanged:Boolean;
      
      private var _valueParseFunction:Function;
      
      private var valueParseFunctionChanged:Boolean;
      
      private var _imeMode:String = null;
      
      private var imeModeChanged:Boolean = false;
      
      public function NumericStepper()
      {
         super();
         this.maximum = 10;
      }
      
      override public function get baselinePosition() : Number
      {
         return getBaselinePositionForPart(this.textDisplay);
      }
      
      [Inspectable(category="General",defaultValue="10.0")]
      override public function set maximum(value:Number) : void
      {
         this.maxChanged = true;
         super.maximum = value;
      }
      
      [Inspectable(category="General",defaultValue="1.0",minValue="0.0")]
      override public function set stepSize(value:Number) : void
      {
         this.stepSizeChanged = true;
         super.stepSize = value;
      }
      
      public function get enableIME() : Boolean
      {
         if(Boolean(this.textDisplay) && Boolean(this.textDisplay.textDisplay))
         {
            return this.textDisplay.textDisplay.editable;
         }
         return true;
      }
      
      [Inspectable(category="General",defaultValue="0")]
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
      }
      
      public function get valueFormatFunction() : Function
      {
         return this._valueFormatFunction;
      }
      
      public function set valueFormatFunction(value:Function) : void
      {
         this._valueFormatFunction = value;
         this.valueFormatFunctionChanged = true;
         invalidateProperties();
      }
      
      public function get valueParseFunction() : Function
      {
         return this._valueParseFunction;
      }
      
      public function set valueParseFunction(value:Function) : void
      {
         this._valueParseFunction = value;
         this.valueParseFunctionChanged = true;
         invalidateProperties();
      }
      
      public function get imeMode() : String
      {
         return this._imeMode;
      }
      
      public function set imeMode(value:String) : void
      {
         this._imeMode = value;
         this.imeModeChanged = true;
         invalidateProperties();
      }
      
      override protected function initializeAccessibility() : void
      {
         if(NumericStepper.createAccessibilityImplementation != null)
         {
            NumericStepper.createAccessibilityImplementation(this);
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.maxChanged || this.stepSizeChanged || this.valueFormatFunctionChanged)
         {
            this.textDisplay.widthInChars = this.calculateWidestValue();
            this.maxChanged = false;
            this.stepSizeChanged = false;
            if(this.valueFormatFunctionChanged)
            {
               this.applyDisplayFormatFunction();
               this.valueFormatFunctionChanged = false;
            }
         }
         if(this.valueParseFunctionChanged)
         {
            this.commitTextInput(false);
            this.valueParseFunctionChanged = false;
         }
         if(this.maxCharsChanged)
         {
            this.textDisplay.maxChars = this._maxChars;
            this.maxCharsChanged = false;
         }
         if(this.imeModeChanged)
         {
            this.textDisplay.imeMode = this._imeMode;
            this.imeModeChanged = false;
         }
      }
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         super.partAdded(partName,instance);
         if(instance == this.textDisplay)
         {
            this.textDisplay.addEventListener(FlexEvent.ENTER,this.textDisplay_enterHandler);
            this.textDisplay.addEventListener(FocusEvent.FOCUS_OUT,this.textDisplay_focusOutHandler);
            this.textDisplay.focusEnabled = false;
            this.textDisplay.maxChars = this._maxChars;
            this.textDisplay.restrict = "0-9\\-\\.\\,";
            this.textDisplay.text = value.toString();
            this.textDisplay.widthInChars = this.calculateWidestValue();
         }
      }
      
      override protected function partRemoved(partName:String, instance:Object) : void
      {
         super.partRemoved(partName,instance);
         if(instance == this.textDisplay)
         {
            this.textDisplay.removeEventListener(FlexEvent.ENTER,this.textDisplay_enterHandler);
         }
      }
      
      override public function setFocus() : void
      {
         if(Boolean(stage))
         {
            stage.focus = this.textDisplay.textDisplay as InteractiveObject;
            if(Boolean(this.textDisplay.textDisplay) && (this.textDisplay.textDisplay.editable || this.textDisplay.textDisplay.selectable))
            {
               this.textDisplay.textDisplay.selectAll();
            }
         }
      }
      
      override protected function isOurFocus(target:DisplayObject) : Boolean
      {
         return target == this.textDisplay.textDisplay;
      }
      
      override protected function setValue(newValue:Number) : void
      {
         super.setValue(newValue);
         this.applyDisplayFormatFunction();
      }
      
      override public function changeValueByStep(increase:Boolean = true) : void
      {
         this.commitTextInput();
         super.changeValueByStep(increase);
      }
      
      private function commitTextInput(dispatchChange:Boolean = false) : void
      {
         var inputValue:Number = NaN;
         var prevValue:Number = value;
         if(this.valueParseFunction != null)
         {
            inputValue = this.valueParseFunction(this.textDisplay.text);
         }
         else
         {
            if(this.dataFormatter == null)
            {
               this.dataFormatter = new NumberFormatter(LocaleID.DEFAULT);
            }
            inputValue = this.dataFormatter.parseNumber(this.textDisplay.text);
         }
         if(Boolean(this.textDisplay.text && this.textDisplay.text.length != value.toString().length) || Boolean(this.textDisplay.text == "") || inputValue != value && (Math.abs(inputValue - value) >= 0.000001 || isNaN(inputValue)))
         {
            this.setValue(nearestValidValue(inputValue,snapInterval));
            if(value == prevValue && inputValue != prevValue)
            {
               dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
            }
         }
         if(dispatchChange)
         {
            if(value != prevValue)
            {
               dispatchEvent(new Event(Event.CHANGE));
            }
         }
      }
      
      private function calculateWidestValue() : Number
      {
         var widestNumber:Number = minimum.toString().length > maximum.toString().length ? minimum : maximum;
         widestNumber += stepSize;
         if(this.valueFormatFunction != null)
         {
            return this.valueFormatFunction(widestNumber).length;
         }
         return widestNumber.toString().length;
      }
      
      private function applyDisplayFormatFunction() : void
      {
         if(this.valueFormatFunction != null)
         {
            this.textDisplay.text = this.valueFormatFunction(value);
         }
         else
         {
            this.textDisplay.text = value.toString();
         }
      }
      
      override protected function focusInHandler(event:FocusEvent) : void
      {
         super.focusInHandler(event);
         addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler,true);
      }
      
      override protected function focusOutHandler(event:FocusEvent) : void
      {
         super.focusOutHandler(event);
         removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler,true);
      }
      
      private function textDisplay_enterHandler(event:Event) : void
      {
         this.commitTextInput(true);
      }
      
      private function textDisplay_focusOutHandler(event:Event) : void
      {
         this.commitTextInput(true);
      }
   }
}

