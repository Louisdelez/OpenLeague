package spark.components.supportClasses
{
   import flash.accessibility.Accessibility;
   import flash.accessibility.AccessibilityProperties;
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.events.SoftKeyboardEvent;
   import flash.system.Capabilities;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.events.SelectionEvent;
   import mx.core.FlexGlobals;
   import mx.core.IIMESupport;
   import mx.core.IVisualElement;
   import mx.core.InteractionMode;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.SandboxMouseEvent;
   import mx.events.TouchInteractionEvent;
   import mx.managers.IFocusManagerComponent;
   import mx.utils.BitFlagUtil;
   import spark.components.Application;
   import spark.components.RichEditableText;
   import spark.components.TextSelectionHighlighting;
   import spark.core.IDisplayText;
   import spark.core.IEditableText;
   import spark.core.ISoftKeyboardHintClient;
   import spark.events.TextOperationEvent;
   
   [SkinState("disabledWithPrompt")]
   [SkinState("normalWithPrompt")]
   [SkinState("disabled")]
   [SkinState("normal")]
   [Event(name="textInput",type="flash.events.TextEvent")]
   [Event(name="change",type="spark.events.TextOperationEvent")]
   [Event(name="changing",type="spark.events.TextOperationEvent")]
   [Event(name="selectionChange",type="mx.events.FlexEvent")]
   [Style(name="showPromptWhenFocused",type="Boolean",inherit="yes",theme="mobile")]
   [Style(name="focusColor",type="uint",format="Color",inherit="yes",theme="spark, mobile")]
   [Style(name="focusAlpha",type="Number",inherit="no",theme="spark, mobile",minValue="0.0",maxValue="1.0")]
   [Style(name="contentBackgroundColor",type="uint",format="Color",inherit="yes",theme="spark, mobile")]
   [Style(name="contentBackgroundAlpha",type="Number",inherit="yes",theme="spark, mobile",minValue="0.0",maxValue="1.0")]
   [Style(name="borderVisible",type="Boolean",inherit="no",theme="spark, mobile")]
   [Style(name="borderColor",type="uint",format="Color",inherit="no",theme="spark")]
   [Style(name="borderAlpha",type="Number",inherit="no",theme="spark",minValue="0.0",maxValue="1.0")]
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
   [Style(name="verticalAlign",type="String",enumeration="top,middle,bottom,justify",inherit="no")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no",minValue="0.0",maxValue="1000.0")]
   [Style(name="paddingRight",type="Number",format="Length",inherit="no",minValue="0.0",maxValue="1000.0")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no",minValue="0.0",maxValue="1000.0")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no",minValue="0.0",maxValue="1000.0")]
   [Style(name="lineBreak",type="String",enumeration="toFit,explicit",inherit="no")]
   public class SkinnableTextBase extends SkinnableComponent implements IFocusManagerComponent, IIMESupport, ISoftKeyboardHintClient
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const CONTENT_PROPERTY_FLAG:uint = 1 << 0;
      
      private static const DISPLAY_AS_PASSWORD_PROPERTY_FLAG:uint = 1 << 1;
      
      private static const EDITABLE_PROPERTY_FLAG:uint = 1 << 2;
      
      private static const HEIGHT_IN_LINES_PROPERTY_FLAG:uint = 1 << 3;
      
      private static const IME_MODE_PROPERTY_FLAG:uint = 1 << 4;
      
      private static const MAX_CHARS_PROPERTY_FLAG:uint = 1 << 5;
      
      private static const MAX_WIDTH_PROPERTY_FLAG:uint = 1 << 7;
      
      private static const RESTRICT_PROPERTY_FLAG:uint = 1 << 8;
      
      private static const SELECTABLE_PROPERTY_FLAG:uint = 1 << 9;
      
      private static const SELECTION_HIGHLIGHTING_FLAG:uint = 1 << 10;
      
      private static const TEXT_PROPERTY_FLAG:uint = 1 << 11;
      
      private static const TEXT_FLOW_PROPERTY_FLAG:uint = 1 << 12;
      
      private static const TYPICAL_TEXT_PROPERTY_FLAG:uint = 1 << 13;
      
      private static const WIDTH_IN_CHARS_PROPERTY_FLAG:uint = 1 << 14;
      
      private static const AUTO_CAPITALIZE_FLAG:uint = 1 << 15;
      
      private static const AUTO_CORRECT_FLAG:uint = 1 << 16;
      
      private static const RETURN_KEY_LABEL_FLAG:uint = 1 << 17;
      
      private static const SOFT_KEYBOARD_TYPE_FLAG:uint = 1 << 18;
      
      private static const PROMPT_TEXT_PROPERTY_FLAG:uint = 1;
      
      private static var isIOS:Boolean = Capabilities.version.indexOf("IOS") == 0;
      
      private static var _skinParts:Object = {
         "promptDisplay":false,
         "textDisplay":false
      };
      
      private var touchHandlersAdded:Boolean = false;
      
      private var isMouseDown:Boolean = false;
      
      private var delaySetFocus:Boolean = false;
      
      private var mouseDownTarget:InteractiveObject;
      
      [SkinPart(required="false")]
      public var promptDisplay:IDisplayText;
      
      private var promptDisplayProperties:Object = {};
      
      private var _831827669textDisplay:IEditableText;
      
      private var textDisplayProperties:Object = {};
      
      private var _accessibilityProperties:AccessibilityProperties = null;
      
      private var accessibilityPropertiesChanged:Boolean = false;
      
      private var _tabIndex:int = -1;
      
      public function SkinnableTextBase()
      {
         super();
      }
      
      override public function set accessibilityEnabled(value:Boolean) : void
      {
         if(!Capabilities.hasAccessibility)
         {
            return;
         }
         if(!this.accessibilityProperties)
         {
            this.accessibilityProperties = new AccessibilityProperties();
         }
         this.accessibilityProperties.silent = !value;
         this.accessibilityPropertiesChanged = true;
         invalidateProperties();
      }
      
      override public function set accessibilityDescription(value:String) : void
      {
         if(!Capabilities.hasAccessibility)
         {
            return;
         }
         if(!this.accessibilityProperties)
         {
            this.accessibilityProperties = new AccessibilityProperties();
         }
         this.accessibilityProperties.description = value;
         this.accessibilityPropertiesChanged = true;
         invalidateProperties();
      }
      
      override public function set accessibilityName(value:String) : void
      {
         if(!Capabilities.hasAccessibility)
         {
            return;
         }
         if(!this.accessibilityProperties)
         {
            this.accessibilityProperties = new AccessibilityProperties();
         }
         this.accessibilityProperties.name = value;
         this.accessibilityPropertiesChanged = true;
         invalidateProperties();
      }
      
      override public function get accessibilityProperties() : AccessibilityProperties
      {
         return this._accessibilityProperties;
      }
      
      override public function set accessibilityProperties(value:AccessibilityProperties) : void
      {
         this._accessibilityProperties = value;
         this.accessibilityPropertiesChanged = true;
         invalidateProperties();
      }
      
      override public function set accessibilityShortcut(value:String) : void
      {
         if(!Capabilities.hasAccessibility)
         {
            return;
         }
         if(!this.accessibilityProperties)
         {
            this.accessibilityProperties = new AccessibilityProperties();
         }
         this.accessibilityProperties.shortcut = value;
         this.accessibilityPropertiesChanged = true;
         invalidateProperties();
      }
      
      override public function get baselinePosition() : Number
      {
         return getBaselinePositionForPart(this.textDisplay as IVisualElement);
      }
      
      override public function set enabled(value:Boolean) : void
      {
         if(Boolean(this.textDisplay))
         {
            this.textDisplay.enabled = value;
         }
         if(value == super.enabled)
         {
            return;
         }
         super.enabled = value;
      }
      
      override public function get maxWidth() : Number
      {
         var richEditableText:RichEditableText = this.textDisplay as RichEditableText;
         if(Boolean(richEditableText))
         {
            return richEditableText.maxWidth;
         }
         var v:* = Boolean(this.textDisplay) ? undefined : this.textDisplayProperties.maxWidth;
         return v === undefined ? super.maxWidth : Number(v);
      }
      
      override public function set maxWidth(value:Number) : void
      {
         var richEditableText:RichEditableText = null;
         if(Boolean(this.textDisplay))
         {
            richEditableText = this.textDisplay as RichEditableText;
            if(Boolean(richEditableText))
            {
               richEditableText.maxWidth = value;
            }
            else
            {
               super.maxWidth = value;
            }
            this.textDisplayProperties = BitFlagUtil.update(uint(this.textDisplayProperties),MAX_WIDTH_PROPERTY_FLAG,true);
         }
         else
         {
            this.textDisplayProperties.maxWidth = value;
         }
         invalidateProperties();
      }
      
      [Inspectable(category="General",defaultValue="")]
      public function get prompt() : String
      {
         return this.getPrompt();
      }
      
      public function set prompt(value:String) : void
      {
         this.setPrompt(value);
      }
      
      override public function get tabIndex() : int
      {
         return this._tabIndex;
      }
      
      override public function set tabIndex(value:int) : void
      {
         this._tabIndex = value;
         this.accessibilityPropertiesChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get typicalText() : String
      {
         return this.getTypicalText();
      }
      
      public function set typicalText(value:String) : void
      {
         this.setTypicalText(value);
      }
      
      [Inspectable(category="General",defaultValue="false")]
      public function get displayAsPassword() : Boolean
      {
         if(Boolean(this.textDisplay))
         {
            return this.textDisplay.displayAsPassword;
         }
         var v:* = this.textDisplayProperties.displayAsPassword;
         return v === undefined ? false : Boolean(v);
      }
      
      public function set displayAsPassword(value:Boolean) : void
      {
         if(Boolean(this.textDisplay))
         {
            this.textDisplay.displayAsPassword = value;
            this.textDisplayProperties = BitFlagUtil.update(uint(this.textDisplayProperties),DISPLAY_AS_PASSWORD_PROPERTY_FLAG,true);
         }
         else
         {
            this.textDisplayProperties.displayAsPassword = value;
         }
         invalidateProperties();
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get editable() : Boolean
      {
         if(Boolean(this.textDisplay))
         {
            return this.textDisplay.editable;
         }
         var v:* = this.textDisplayProperties.editable;
         return v === undefined ? true : Boolean(v);
      }
      
      public function set editable(value:Boolean) : void
      {
         if(Boolean(this.textDisplay))
         {
            this.textDisplay.editable = value;
            this.textDisplayProperties = BitFlagUtil.update(uint(this.textDisplayProperties),EDITABLE_PROPERTY_FLAG,true);
         }
         else
         {
            this.textDisplayProperties.editable = value;
         }
         invalidateProperties();
      }
      
      public function get enableIME() : Boolean
      {
         var richEditableText:RichEditableText = this.textDisplay as RichEditableText;
         if(Boolean(richEditableText))
         {
            return richEditableText.enableIME;
         }
         return false;
      }
      
      public function get imeMode() : String
      {
         var richEditableText:RichEditableText = this.textDisplay as RichEditableText;
         if(Boolean(richEditableText))
         {
            return richEditableText.imeMode;
         }
         var v:* = Boolean(this.textDisplay) ? undefined : this.textDisplayProperties.imeMode;
         return v === undefined ? null : v;
      }
      
      public function set imeMode(value:String) : void
      {
         var richEditableText:RichEditableText = this.textDisplay as RichEditableText;
         if(Boolean(this.textDisplay))
         {
            if(Boolean(richEditableText))
            {
               richEditableText.imeMode = value;
            }
            this.textDisplayProperties = BitFlagUtil.update(uint(this.textDisplayProperties),IME_MODE_PROPERTY_FLAG,true);
         }
         else
         {
            this.textDisplayProperties.imeMode = value;
         }
         invalidateProperties();
      }
      
      [Inspectable(category="General",defaultValue="0")]
      public function get maxChars() : int
      {
         if(Boolean(this.textDisplay))
         {
            return this.textDisplay.maxChars;
         }
         var v:* = this.textDisplayProperties.maxChars;
         return v === undefined ? 0 : int(v);
      }
      
      public function set maxChars(value:int) : void
      {
         if(Boolean(this.textDisplay))
         {
            this.textDisplay.maxChars = value;
            this.textDisplayProperties = BitFlagUtil.update(uint(this.textDisplayProperties),MAX_CHARS_PROPERTY_FLAG,true);
         }
         else
         {
            this.textDisplayProperties.maxChars = value;
         }
         invalidateProperties();
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get restrict() : String
      {
         if(Boolean(this.textDisplay))
         {
            return this.textDisplay.restrict;
         }
         var v:* = this.textDisplayProperties.restrict;
         return v === undefined ? null : v;
      }
      
      public function set restrict(value:String) : void
      {
         if(Boolean(this.textDisplay))
         {
            this.textDisplay.restrict = value;
            this.textDisplayProperties = BitFlagUtil.update(uint(this.textDisplayProperties),RESTRICT_PROPERTY_FLAG,true);
         }
         else
         {
            this.textDisplayProperties.restrict = value;
         }
         invalidateProperties();
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get selectable() : Boolean
      {
         if(Boolean(this.textDisplay))
         {
            return this.textDisplay.selectable;
         }
         var v:* = this.textDisplayProperties.selectable;
         return v === undefined ? true : Boolean(v);
      }
      
      public function set selectable(value:Boolean) : void
      {
         if(Boolean(this.textDisplay))
         {
            this.textDisplay.selectable = value;
            this.textDisplayProperties = BitFlagUtil.update(uint(this.textDisplayProperties),SELECTABLE_PROPERTY_FLAG,true);
         }
         else
         {
            this.textDisplayProperties.selectable = value;
         }
         invalidateProperties();
      }
      
      [Bindable("selectionChange")]
      public function get selectionActivePosition() : int
      {
         return Boolean(this.textDisplay) ? this.textDisplay.selectionActivePosition : -1;
      }
      
      [Bindable("selectionChange")]
      public function get selectionAnchorPosition() : int
      {
         return Boolean(this.textDisplay) ? this.textDisplay.selectionAnchorPosition : -1;
      }
      
      [Inspectable(category="General",enumeration="always,whenActive,whenFocused",defaultValue="whenFocused")]
      public function get selectionHighlighting() : String
      {
         var richEditableText:RichEditableText = this.textDisplay as RichEditableText;
         if(Boolean(richEditableText))
         {
            return richEditableText.selectionHighlighting;
         }
         var v:* = Boolean(this.textDisplay) ? undefined : this.textDisplayProperties.selectionHighlighting;
         return v === undefined ? TextSelectionHighlighting.WHEN_FOCUSED : v;
      }
      
      public function set selectionHighlighting(value:String) : void
      {
         var richEditableText:RichEditableText = null;
         if(Boolean(this.textDisplay))
         {
            richEditableText = this.textDisplay as RichEditableText;
            if(Boolean(richEditableText))
            {
               richEditableText.selectionHighlighting = value;
            }
            this.textDisplayProperties = BitFlagUtil.update(uint(this.textDisplayProperties),SELECTION_HIGHLIGHTING_FLAG,true);
         }
         else
         {
            this.textDisplayProperties.selectionHighlighting = value;
         }
         invalidateProperties();
      }
      
      [Inspectable(category="General",defaultValue="")]
      public function get text() : String
      {
         if(Boolean(this.textDisplay))
         {
            return this.textDisplay.text;
         }
         var v:* = this.textDisplayProperties.text;
         return v === undefined ? "" : v;
      }
      
      public function set text(value:String) : void
      {
         if(Boolean(this.textDisplay))
         {
            this.textDisplay.text = value;
            this.textDisplayProperties = BitFlagUtil.update(uint(this.textDisplayProperties),TEXT_PROPERTY_FLAG,true);
         }
         else
         {
            this.textDisplayProperties.text = Boolean(value) ? value : "";
            this.textDisplayProperties.content = undefined;
            this.textDisplayProperties.textFlow = undefined;
         }
         invalidateProperties();
         invalidateSkinState();
      }
      
      [Inspectable(category="General",enumeration="none,word,sentence,all",defaultValue="none")]
      public function get autoCapitalize() : String
      {
         var softKeyboardClient:ISoftKeyboardHintClient = this.textDisplay as ISoftKeyboardHintClient;
         if(Boolean(softKeyboardClient))
         {
            return softKeyboardClient.autoCapitalize;
         }
         var v:* = Boolean(this.textDisplay) ? undefined : this.textDisplayProperties.autoCapitalize;
         return v === undefined ? "none" : v;
      }
      
      public function set autoCapitalize(value:String) : void
      {
         var softKeyboardClient:ISoftKeyboardHintClient = null;
         if(Boolean(this.textDisplay))
         {
            softKeyboardClient = this.textDisplay as ISoftKeyboardHintClient;
            if(Boolean(softKeyboardClient))
            {
               softKeyboardClient.autoCapitalize = value;
            }
            this.textDisplayProperties = BitFlagUtil.update(uint(this.textDisplayProperties),AUTO_CAPITALIZE_FLAG,true);
         }
         else
         {
            this.textDisplayProperties.autoCapitalize = value;
         }
         invalidateProperties();
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get autoCorrect() : Boolean
      {
         var softKeyboardClient:ISoftKeyboardHintClient = this.textDisplay as ISoftKeyboardHintClient;
         if(Boolean(softKeyboardClient))
         {
            return softKeyboardClient.autoCorrect;
         }
         var v:* = Boolean(this.textDisplay) ? undefined : this.textDisplayProperties.autoCorrect;
         return v === undefined ? true : Boolean(v);
      }
      
      public function set autoCorrect(value:Boolean) : void
      {
         var softKeyboardClient:ISoftKeyboardHintClient = null;
         if(Boolean(this.textDisplay))
         {
            softKeyboardClient = this.textDisplay as ISoftKeyboardHintClient;
            if(Boolean(softKeyboardClient))
            {
               softKeyboardClient.autoCorrect = value;
            }
            this.textDisplayProperties = BitFlagUtil.update(uint(this.textDisplayProperties),AUTO_CORRECT_FLAG,true);
         }
         else
         {
            this.textDisplayProperties.autoCorrect = value;
         }
         invalidateProperties();
      }
      
      [Inspectable(category="General",enumeration="default,done,go,next,search",defaultValue="default")]
      public function get returnKeyLabel() : String
      {
         var softKeyboardClient:ISoftKeyboardHintClient = this.textDisplay as ISoftKeyboardHintClient;
         if(Boolean(softKeyboardClient))
         {
            return softKeyboardClient.returnKeyLabel;
         }
         var v:* = Boolean(this.textDisplay) ? undefined : this.textDisplayProperties.returnKeyLabel;
         return v === undefined ? "default" : v;
      }
      
      public function set returnKeyLabel(value:String) : void
      {
         var softKeyboardClient:ISoftKeyboardHintClient = null;
         if(Boolean(this.textDisplay))
         {
            softKeyboardClient = this.textDisplay as ISoftKeyboardHintClient;
            if(Boolean(softKeyboardClient))
            {
               softKeyboardClient.returnKeyLabel = value;
            }
            this.textDisplayProperties = BitFlagUtil.update(uint(this.textDisplayProperties),RETURN_KEY_LABEL_FLAG,true);
         }
         else
         {
            this.textDisplayProperties.returnKeyLabel = value;
         }
         invalidateProperties();
      }
      
      [Inspectable(category="General",enumeration="default,punctuation,url,number,contact,email",defaultValue="default")]
      public function get softKeyboardType() : String
      {
         var softKeyboardClient:ISoftKeyboardHintClient = this.textDisplay as ISoftKeyboardHintClient;
         if(Boolean(softKeyboardClient))
         {
            return softKeyboardClient.softKeyboardType;
         }
         var v:* = Boolean(this.textDisplay) ? undefined : this.textDisplayProperties.softKeyboardType;
         return v === undefined ? "default" : v;
      }
      
      public function set softKeyboardType(value:String) : void
      {
         var softKeyboardClient:ISoftKeyboardHintClient = null;
         if(Boolean(this.textDisplay))
         {
            softKeyboardClient = this.textDisplay as ISoftKeyboardHintClient;
            if(Boolean(softKeyboardClient))
            {
               softKeyboardClient.softKeyboardType = value;
            }
            this.textDisplayProperties = BitFlagUtil.update(uint(this.textDisplayProperties),SOFT_KEYBOARD_TYPE_FLAG,true);
         }
         else
         {
            this.textDisplayProperties.softKeyboardType = value;
         }
         invalidateProperties();
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.accessibilityPropertiesChanged)
         {
            if(Boolean(this.textDisplay))
            {
               this.textDisplay.accessibilityProperties = this._accessibilityProperties;
               this.textDisplay.tabIndex = this._tabIndex;
               if(Capabilities.hasAccessibility)
               {
                  Accessibility.updateProperties();
               }
            }
            this.accessibilityPropertiesChanged = false;
         }
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         if(!styleProp || styleProp == "styleName" || styleProp == "interactionMode")
         {
            if(getStyle("interactionMode") == InteractionMode.TOUCH && !this.touchHandlersAdded)
            {
               addEventListener(MouseEvent.MOUSE_DOWN,this.touchMouseDownHandler);
               addEventListener(TouchInteractionEvent.TOUCH_INTERACTION_START,this.touchInteractionStartHandler);
               this.touchHandlersAdded = true;
            }
            else if(getStyle("interactionMode") == InteractionMode.MOUSE && this.touchHandlersAdded)
            {
               removeEventListener(MouseEvent.MOUSE_DOWN,this.touchMouseDownHandler);
               removeEventListener(TouchInteractionEvent.TOUCH_INTERACTION_START,this.touchInteractionStartHandler);
               this.touchHandlersAdded = false;
            }
         }
      }
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         var newPromptDisplayProperties:uint = 0;
         super.partAdded(partName,instance);
         if(instance == this.promptDisplay)
         {
            newPromptDisplayProperties = 0;
            if(this.promptDisplayProperties.prompt !== undefined)
            {
               this.promptDisplay.text = this.promptDisplayProperties.prompt;
               newPromptDisplayProperties = uint(BitFlagUtil.update(uint(newPromptDisplayProperties),PROMPT_TEXT_PROPERTY_FLAG,true));
            }
            this.promptDisplayProperties = newPromptDisplayProperties;
         }
         if(instance == this.textDisplay)
         {
            this.textDisplayAdded();
            this.textDisplay.focusEnabled = false;
            this.textDisplay.addEventListener(SelectionEvent.SELECTION_CHANGE,this.textDisplay_selectionChangeHandler);
            this.textDisplay.addEventListener(TextOperationEvent.CHANGING,this.textDisplay_changingHandler);
            this.textDisplay.addEventListener(TextOperationEvent.CHANGE,this.textDisplay_changeHandler);
            this.textDisplay.addEventListener(FlexEvent.ENTER,this.textDisplay_enterHandler);
            this.textDisplay.addEventListener(FlexEvent.VALUE_COMMIT,this.textDisplay_valueCommitHandler);
         }
      }
      
      override protected function partRemoved(partName:String, instance:Object) : void
      {
         var newPromptDisplayProperties:Object = null;
         super.partRemoved(partName,instance);
         if(instance == this.textDisplay)
         {
            this.textDisplayRemoved();
            this.textDisplay.removeEventListener(SelectionEvent.SELECTION_CHANGE,this.textDisplay_selectionChangeHandler);
            this.textDisplay.removeEventListener(TextOperationEvent.CHANGING,this.textDisplay_changingHandler);
            this.textDisplay.removeEventListener(TextOperationEvent.CHANGE,this.textDisplay_changeHandler);
            this.textDisplay.removeEventListener(FlexEvent.ENTER,this.textDisplay_enterHandler);
            this.textDisplay.removeEventListener(FlexEvent.VALUE_COMMIT,this.textDisplay_valueCommitHandler);
         }
         if(instance == this.promptDisplay)
         {
            newPromptDisplayProperties = {};
            if(BitFlagUtil.isSet(uint(this.promptDisplayProperties),PROMPT_TEXT_PROPERTY_FLAG))
            {
               newPromptDisplayProperties.prompt = this.promptDisplay.text;
            }
            this.promptDisplayProperties = newPromptDisplayProperties;
         }
      }
      
      override protected function getCurrentSkinState() : String
      {
         var showPromptWhenFocused:Boolean = Boolean(getStyle("showPromptWhenFocused"));
         if((Boolean(showPromptWhenFocused || focusManager && focusManager.getFocus() != focusManager.findFocusManagerComponent(this))) && Boolean(this.prompt != null) && this.prompt != "")
         {
            if(this.text.length == 0)
            {
               if(Boolean(enabled) && Boolean(skin) && Boolean(skin.hasState("normalWithPrompt")))
               {
                  return "normalWithPrompt";
               }
               if(Boolean(!enabled) && Boolean(skin) && Boolean(skin.hasState("disabledWithPrompt")))
               {
                  return "disabledWithPrompt";
               }
            }
         }
         return enabled ? "normal" : "disabled";
      }
      
      override public function setFocus() : void
      {
         var topLevelApp:Application = null;
         var cancelEvent:Boolean = false;
         if(Boolean(this.textDisplay))
         {
            if(this.isMouseDown)
            {
               this.delaySetFocus = true;
               topLevelApp = FlexGlobals.topLevelApplication as Application;
               cancelEvent = !(topLevelApp && topLevelApp.isSoftKeyboardActive);
               if(cancelEvent)
               {
                  addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING,this.softKeyboardActivatingHandler);
               }
               this.textDisplay.setFocus();
               if(cancelEvent)
               {
                  removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING,this.softKeyboardActivatingHandler);
               }
            }
            else
            {
               this.textDisplay.setFocus();
            }
         }
      }
      
      override protected function isOurFocus(target:DisplayObject) : Boolean
      {
         return target == this.textDisplay || Boolean(super.isOurFocus(target));
      }
      
      public function insertText(text:String) : void
      {
         if(!this.textDisplay)
         {
            return;
         }
         this.textDisplay.insertText(text);
         invalidateProperties();
      }
      
      public function appendText(text:String) : void
      {
         if(!this.textDisplay)
         {
            return;
         }
         this.textDisplay.appendText(text);
         invalidateProperties();
      }
      
      public function selectRange(anchorIndex:int, activeIndex:int) : void
      {
         if(!this.textDisplay)
         {
            return;
         }
         this.textDisplay.selectRange(anchorIndex,activeIndex);
         invalidateProperties();
      }
      
      public function selectAll() : void
      {
         if(!this.textDisplay)
         {
            return;
         }
         this.textDisplay.selectAll();
         invalidateProperties();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setContent(value:Object) : void
      {
         var richEditableText:RichEditableText = null;
         if(Boolean(this.textDisplay))
         {
            richEditableText = this.textDisplay as RichEditableText;
            if(Boolean(richEditableText))
            {
               richEditableText.content = value;
               this.textDisplayProperties = BitFlagUtil.update(uint(this.textDisplayProperties),CONTENT_PROPERTY_FLAG,true);
            }
         }
         else
         {
            this.textDisplayProperties.content = value;
            this.textDisplayProperties.text = undefined;
            this.textDisplayProperties.textFlow = undefined;
         }
         invalidateProperties();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getHeightInLines() : Number
      {
         var richEditableText:RichEditableText = this.textDisplay as RichEditableText;
         if(Boolean(richEditableText))
         {
            return richEditableText.heightInLines;
         }
         var v:* = Boolean(this.textDisplay) ? undefined : this.textDisplayProperties.heightInLines;
         return v === undefined ? NaN : Number(v);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setHeightInLines(value:Number) : void
      {
         var richEditableText:RichEditableText = null;
         if(Boolean(this.textDisplay))
         {
            richEditableText = this.textDisplay as RichEditableText;
            if(Boolean(richEditableText))
            {
               richEditableText.heightInLines = value;
            }
            this.textDisplayProperties = BitFlagUtil.update(uint(this.textDisplayProperties),HEIGHT_IN_LINES_PROPERTY_FLAG,true);
         }
         else
         {
            this.textDisplayProperties.heightInLines = value;
         }
         invalidateProperties();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getPrompt() : String
      {
         if(Boolean(this.promptDisplay))
         {
            if(BitFlagUtil.isSet(uint(this.promptDisplayProperties),PROMPT_TEXT_PROPERTY_FLAG))
            {
               return this.promptDisplay.text;
            }
            return null;
         }
         var v:* = Boolean(this.promptDisplay) ? undefined : this.promptDisplayProperties.prompt;
         return v === undefined ? null : v;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setPrompt(value:String) : void
      {
         if(Boolean(this.promptDisplay))
         {
            this.promptDisplay.text = value;
            this.promptDisplayProperties = BitFlagUtil.update(uint(this.promptDisplayProperties),PROMPT_TEXT_PROPERTY_FLAG,true);
         }
         else
         {
            this.promptDisplayProperties.prompt = value;
         }
         invalidateProperties();
         invalidateSkinState();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getTextFlow() : TextFlow
      {
         var richEditableText:RichEditableText = this.textDisplay as RichEditableText;
         if(Boolean(richEditableText))
         {
            return richEditableText.textFlow;
         }
         var v:* = Boolean(this.textDisplay) ? undefined : this.textDisplayProperties.textFlow;
         return v === undefined ? null : v;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setTextFlow(value:TextFlow) : void
      {
         var richEditableText:RichEditableText = null;
         if(Boolean(this.textDisplay))
         {
            richEditableText = this.textDisplay as RichEditableText;
            if(Boolean(richEditableText))
            {
               richEditableText.textFlow = value;
            }
            this.textDisplayProperties = BitFlagUtil.update(uint(this.textDisplayProperties),TEXT_FLOW_PROPERTY_FLAG,true);
         }
         else
         {
            this.textDisplayProperties.textFlow = value;
            this.textDisplayProperties.text = undefined;
            this.textDisplayProperties.content = undefined;
         }
         invalidateProperties();
         invalidateSkinState();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getTypicalText() : String
      {
         var richEditableText:RichEditableText = this.textDisplay as RichEditableText;
         if(Boolean(richEditableText))
         {
            return richEditableText.typicalText;
         }
         var v:* = Boolean(this.textDisplay) ? undefined : this.textDisplayProperties.typicalText;
         return v === undefined ? null : v;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setTypicalText(value:String) : void
      {
         var richEditableText:RichEditableText = null;
         if(Boolean(this.textDisplay))
         {
            richEditableText = this.textDisplay as RichEditableText;
            if(Boolean(richEditableText))
            {
               richEditableText.typicalText = value;
            }
            this.textDisplayProperties = BitFlagUtil.update(uint(this.textDisplayProperties),TYPICAL_TEXT_PROPERTY_FLAG,true);
         }
         else
         {
            this.textDisplayProperties.typicalText = value;
         }
         invalidateProperties();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getWidthInChars() : Number
      {
         var richEditableText:RichEditableText = this.textDisplay as RichEditableText;
         if(Boolean(richEditableText))
         {
            return richEditableText.widthInChars;
         }
         var v:* = Boolean(this.textDisplay) ? undefined : this.textDisplayProperties.widthInChars;
         return v === undefined ? NaN : Number(v);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setWidthInChars(value:Number) : void
      {
         var richEditableText:RichEditableText = null;
         if(Boolean(this.textDisplay))
         {
            richEditableText = this.textDisplay as RichEditableText;
            if(Boolean(richEditableText))
            {
               richEditableText.widthInChars = value;
            }
            this.textDisplayProperties = BitFlagUtil.update(uint(this.textDisplayProperties),WIDTH_IN_CHARS_PROPERTY_FLAG,true);
         }
         else
         {
            this.textDisplayProperties.widthInChars = value;
         }
         invalidateProperties();
      }
      
      private function textDisplayAdded() : void
      {
         var newTextDisplayProperties:uint = 0;
         var richEditableText:RichEditableText = this.textDisplay as RichEditableText;
         if(this.textDisplayProperties.content !== undefined && Boolean(richEditableText))
         {
            richEditableText.content = this.textDisplayProperties.content;
            newTextDisplayProperties = uint(BitFlagUtil.update(uint(newTextDisplayProperties),CONTENT_PROPERTY_FLAG,true));
         }
         if(this.textDisplayProperties.displayAsPassword !== undefined)
         {
            this.textDisplay.displayAsPassword = this.textDisplayProperties.displayAsPassword;
            newTextDisplayProperties = uint(BitFlagUtil.update(uint(newTextDisplayProperties),DISPLAY_AS_PASSWORD_PROPERTY_FLAG,true));
         }
         if(this.textDisplayProperties.editable !== undefined)
         {
            this.textDisplay.editable = this.textDisplayProperties.editable;
            newTextDisplayProperties = uint(BitFlagUtil.update(uint(newTextDisplayProperties),EDITABLE_PROPERTY_FLAG,true));
         }
         if(this.textDisplayProperties.heightInLines !== undefined && Boolean(richEditableText))
         {
            richEditableText.heightInLines = this.textDisplayProperties.heightInLines;
            newTextDisplayProperties = uint(BitFlagUtil.update(uint(newTextDisplayProperties),HEIGHT_IN_LINES_PROPERTY_FLAG,true));
         }
         if(this.textDisplayProperties.imeMode !== undefined && Boolean(richEditableText))
         {
            richEditableText.imeMode = this.textDisplayProperties.imeMode;
            newTextDisplayProperties = uint(BitFlagUtil.update(uint(newTextDisplayProperties),IME_MODE_PROPERTY_FLAG,true));
         }
         if(this.textDisplayProperties.maxChars !== undefined)
         {
            this.textDisplay.maxChars = this.textDisplayProperties.maxChars;
            newTextDisplayProperties = uint(BitFlagUtil.update(uint(newTextDisplayProperties),MAX_CHARS_PROPERTY_FLAG,true));
         }
         if(this.textDisplayProperties.maxWidth !== undefined)
         {
            if(Boolean(richEditableText))
            {
               richEditableText.maxWidth = this.textDisplayProperties.maxWidth;
            }
            else
            {
               super.maxWidth = this.textDisplayProperties.maxWidth;
            }
            newTextDisplayProperties = uint(BitFlagUtil.update(uint(newTextDisplayProperties),MAX_WIDTH_PROPERTY_FLAG,true));
         }
         if(this.textDisplayProperties.restrict !== undefined)
         {
            this.textDisplay.restrict = this.textDisplayProperties.restrict;
            newTextDisplayProperties = uint(BitFlagUtil.update(uint(newTextDisplayProperties),RESTRICT_PROPERTY_FLAG,true));
         }
         if(this.textDisplayProperties.selectable !== undefined)
         {
            this.textDisplay.selectable = this.textDisplayProperties.selectable;
            newTextDisplayProperties = uint(BitFlagUtil.update(uint(newTextDisplayProperties),SELECTABLE_PROPERTY_FLAG,true));
         }
         if(this.textDisplayProperties.selectionHighlighting !== undefined && Boolean(richEditableText))
         {
            richEditableText.selectionHighlighting = this.textDisplayProperties.selectionHighlighting;
            newTextDisplayProperties = uint(BitFlagUtil.update(uint(newTextDisplayProperties),SELECTION_HIGHLIGHTING_FLAG,true));
         }
         if(this.textDisplayProperties.text != null)
         {
            this.textDisplay.text = this.textDisplayProperties.text;
            newTextDisplayProperties = uint(BitFlagUtil.update(uint(newTextDisplayProperties),TEXT_PROPERTY_FLAG,true));
         }
         if(this.textDisplayProperties.textFlow !== undefined && Boolean(richEditableText))
         {
            richEditableText.textFlow = this.textDisplayProperties.textFlow;
            newTextDisplayProperties = uint(BitFlagUtil.update(uint(newTextDisplayProperties),TEXT_FLOW_PROPERTY_FLAG,true));
         }
         if(this.textDisplayProperties.typicalText !== undefined && Boolean(richEditableText))
         {
            richEditableText.typicalText = this.textDisplayProperties.typicalText;
            newTextDisplayProperties = uint(BitFlagUtil.update(uint(newTextDisplayProperties),TYPICAL_TEXT_PROPERTY_FLAG,true));
         }
         if(this.textDisplayProperties.widthInChars !== undefined && Boolean(richEditableText))
         {
            richEditableText.widthInChars = this.textDisplayProperties.widthInChars;
            newTextDisplayProperties = uint(BitFlagUtil.update(uint(newTextDisplayProperties),WIDTH_IN_CHARS_PROPERTY_FLAG,true));
         }
         var softKeyboardClient:ISoftKeyboardHintClient = this.textDisplay as ISoftKeyboardHintClient;
         if(this.textDisplayProperties.autoCapitalize !== undefined && Boolean(softKeyboardClient))
         {
            softKeyboardClient.autoCapitalize = this.textDisplayProperties.autoCapitalize;
            newTextDisplayProperties = uint(BitFlagUtil.update(uint(newTextDisplayProperties),AUTO_CAPITALIZE_FLAG,true));
         }
         if(this.textDisplayProperties.autoCorrect !== undefined && Boolean(softKeyboardClient))
         {
            softKeyboardClient.autoCorrect = this.textDisplayProperties.autoCorrect;
            newTextDisplayProperties = uint(BitFlagUtil.update(uint(newTextDisplayProperties),AUTO_CORRECT_FLAG,true));
         }
         if(this.textDisplayProperties.returnKeyLabel !== undefined && Boolean(softKeyboardClient))
         {
            softKeyboardClient.returnKeyLabel = this.textDisplayProperties.returnKeyLabel;
            newTextDisplayProperties = uint(BitFlagUtil.update(uint(newTextDisplayProperties),RETURN_KEY_LABEL_FLAG,true));
         }
         if(this.textDisplayProperties.softKeyboardType !== undefined && Boolean(softKeyboardClient))
         {
            softKeyboardClient.softKeyboardType = this.textDisplayProperties.softKeyboardType;
            newTextDisplayProperties = uint(BitFlagUtil.update(uint(newTextDisplayProperties),SOFT_KEYBOARD_TYPE_FLAG,true));
         }
         this.textDisplayProperties = newTextDisplayProperties;
      }
      
      private function textDisplayRemoved() : void
      {
         var newTextDisplayProperties:Object = {};
         var richEditableText:RichEditableText = this.textDisplay as RichEditableText;
         if(BitFlagUtil.isSet(uint(this.textDisplayProperties),DISPLAY_AS_PASSWORD_PROPERTY_FLAG))
         {
            newTextDisplayProperties.displayAsPassword = this.textDisplay.displayAsPassword;
         }
         if(BitFlagUtil.isSet(uint(this.textDisplayProperties),EDITABLE_PROPERTY_FLAG))
         {
            newTextDisplayProperties.editable = this.textDisplay.editable;
         }
         if(Boolean(BitFlagUtil.isSet(uint(this.textDisplayProperties),HEIGHT_IN_LINES_PROPERTY_FLAG)) && Boolean(richEditableText))
         {
            newTextDisplayProperties.heightInLines = richEditableText.heightInLines;
         }
         if(Boolean(BitFlagUtil.isSet(uint(this.textDisplayProperties),IME_MODE_PROPERTY_FLAG)) && Boolean(richEditableText))
         {
            newTextDisplayProperties.imeMode = richEditableText.imeMode;
         }
         if(BitFlagUtil.isSet(uint(this.textDisplayProperties),MAX_CHARS_PROPERTY_FLAG))
         {
            newTextDisplayProperties.maxChars = this.textDisplay.maxChars;
         }
         if(BitFlagUtil.isSet(uint(this.textDisplayProperties),MAX_WIDTH_PROPERTY_FLAG))
         {
            newTextDisplayProperties.maxWidth = Boolean(richEditableText) ? richEditableText.maxWidth : super.maxWidth;
         }
         if(BitFlagUtil.isSet(uint(this.textDisplayProperties),RESTRICT_PROPERTY_FLAG))
         {
            newTextDisplayProperties.restrict = this.textDisplay.restrict;
         }
         if(BitFlagUtil.isSet(uint(this.textDisplayProperties),SELECTABLE_PROPERTY_FLAG))
         {
            newTextDisplayProperties.selectable = this.textDisplay.selectable;
         }
         if(Boolean(BitFlagUtil.isSet(uint(this.textDisplayProperties),SELECTION_HIGHLIGHTING_FLAG)) && Boolean(richEditableText))
         {
            newTextDisplayProperties.selectionHighlighting = richEditableText.selectionHighlighting;
         }
         if(BitFlagUtil.isSet(uint(this.textDisplayProperties),TEXT_PROPERTY_FLAG))
         {
            newTextDisplayProperties.text = this.textDisplay.text;
         }
         if(Boolean(BitFlagUtil.isSet(uint(this.textDisplayProperties),TEXT_FLOW_PROPERTY_FLAG)) || Boolean(BitFlagUtil.isSet(uint(this.textDisplayProperties),CONTENT_PROPERTY_FLAG)) && Boolean(richEditableText))
         {
            newTextDisplayProperties.textFlow = richEditableText.textFlow;
         }
         if(Boolean(BitFlagUtil.isSet(uint(this.textDisplayProperties),TYPICAL_TEXT_PROPERTY_FLAG)) && Boolean(richEditableText))
         {
            newTextDisplayProperties.typicalText = richEditableText.typicalText;
         }
         if(Boolean(BitFlagUtil.isSet(uint(this.textDisplayProperties),WIDTH_IN_CHARS_PROPERTY_FLAG)) && Boolean(richEditableText))
         {
            newTextDisplayProperties.widthInChars = richEditableText.widthInChars;
         }
         var softKeyboardClient:ISoftKeyboardHintClient = this.textDisplay as ISoftKeyboardHintClient;
         if(Boolean(BitFlagUtil.isSet(uint(this.textDisplayProperties),AUTO_CAPITALIZE_FLAG)) && Boolean(softKeyboardClient))
         {
            newTextDisplayProperties.autoCapitalize = softKeyboardClient.autoCapitalize;
         }
         if(Boolean(BitFlagUtil.isSet(uint(this.textDisplayProperties),AUTO_CORRECT_FLAG)) && Boolean(softKeyboardClient))
         {
            newTextDisplayProperties.autoCorrect = softKeyboardClient.autoCorrect;
         }
         if(Boolean(BitFlagUtil.isSet(uint(this.textDisplayProperties),RETURN_KEY_LABEL_FLAG)) && Boolean(softKeyboardClient))
         {
            newTextDisplayProperties.returnKeyLabel = softKeyboardClient.returnKeyLabel;
         }
         if(Boolean(BitFlagUtil.isSet(uint(this.textDisplayProperties),SOFT_KEYBOARD_TYPE_FLAG)) && Boolean(softKeyboardClient))
         {
            newTextDisplayProperties.softKeyboardType = softKeyboardClient.softKeyboardType;
         }
         this.textDisplayProperties = newTextDisplayProperties;
      }
      
      override protected function focusInHandler(event:FocusEvent) : void
      {
         var oldShowFocusIndicator:Boolean = false;
         if(event.target == this)
         {
            this.setFocus();
            return;
         }
         if(enabled && this.editable && Boolean(focusManager))
         {
            oldShowFocusIndicator = Boolean(focusManager.showFocusIndicator);
            focusManager.showFocusIndicator = true;
         }
         invalidateSkinState();
         super.focusInHandler(event);
         if(enabled && this.editable && Boolean(focusManager))
         {
            focusManager.showFocusIndicator = oldShowFocusIndicator;
         }
      }
      
      override protected function focusOutHandler(event:FocusEvent) : void
      {
         if(event.target == this)
         {
            return;
         }
         invalidateSkinState();
         super.focusOutHandler(event);
      }
      
      private function touchMouseDownHandler(event:MouseEvent) : void
      {
         this.isMouseDown = true;
         this.mouseDownTarget = event.target as InteractiveObject;
         if(Boolean(focusManager) && focusManager.getFocus() == this)
         {
            this.delaySetFocus = true;
         }
         systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP,this.touchMouseUpHandler,false,0,true);
         systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.touchMouseUpHandler,false,0,true);
      }
      
      private function touchMouseUpHandler(event:Event) : void
      {
         if(event.target is DisplayObject && Boolean(contains(DisplayObject(event.target))) && (this.delaySetFocus || this.mouseDownTarget == this.textDisplay && event.target != this.textDisplay))
         {
            if(Boolean(this.textDisplay))
            {
               this.textDisplay.setFocus();
            }
         }
         this.clearMouseDownState();
      }
      
      private function touchInteractionStartHandler(event:TouchInteractionEvent) : void
      {
         var topLevelApp:Application = FlexGlobals.topLevelApplication as Application;
         if(Boolean(isIOS && topLevelApp) && Boolean(topLevelApp.isSoftKeyboardActive) && this.editable)
         {
            stage.focus = null;
         }
         this.clearMouseDownState();
      }
      
      private function clearMouseDownState() : void
      {
         if(this.isMouseDown)
         {
            systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP,this.touchMouseUpHandler,false);
            systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.touchMouseUpHandler,false);
            this.isMouseDown = false;
            this.delaySetFocus = false;
            this.mouseDownTarget = null;
         }
      }
      
      private function softKeyboardActivatingHandler(event:SoftKeyboardEvent) : void
      {
         event.preventDefault();
      }
      
      private function textDisplay_selectionChangeHandler(event:Event) : void
      {
         dispatchEvent(event);
      }
      
      private function textDisplay_changeHandler(event:Event) : void
      {
         invalidateDisplayList();
         if(Boolean(this.prompt != null && this.prompt != "") && Boolean(skin) && (skin.currentState.indexOf("WithPrompt") != -1 && this.text.length != 0 || skin.currentState.indexOf("WithPrompt") == -1 && this.text.length == 0))
         {
            invalidateSkinState();
         }
         dispatchEvent(event);
      }
      
      private function textDisplay_changingHandler(event:TextOperationEvent) : void
      {
         var newEvent:Event = event.clone();
         dispatchEvent(newEvent);
         if(newEvent.isDefaultPrevented())
         {
            event.preventDefault();
         }
      }
      
      private function textDisplay_enterHandler(event:Event) : void
      {
         dispatchEvent(event);
      }
      
      private function textDisplay_valueCommitHandler(event:Event) : void
      {
         dispatchEvent(event);
      }
      
      [SkinPart(required="false")]
      [Bindable(event="propertyChange")]
      public function get textDisplay() : IEditableText
      {
         return this._831827669textDisplay;
      }
      
      public function set textDisplay(param1:IEditableText) : void
      {
         var _loc2_:Object = this._831827669textDisplay;
         if(_loc2_ !== param1)
         {
            this._831827669textDisplay = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"textDisplay",_loc2_,param1));
            }
         }
      }
   }
}

