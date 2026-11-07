package mx.controls
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextFormatAlign;
   import flash.text.TextLineMetrics;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import mx.controls.dataGridClasses.DataGridListData;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.EdgeMetrics;
   import mx.core.FlexVersion;
   import mx.core.IBorder;
   import mx.core.IButton;
   import mx.core.IDataRenderer;
   import mx.core.IFlexAsset;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.IFontContextComponent;
   import mx.core.IInvalidating;
   import mx.core.ILayoutDirectionElement;
   import mx.core.IProgrammaticSkin;
   import mx.core.IStateClient;
   import mx.core.IUIComponent;
   import mx.core.IUITextField;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.events.FlexEvent;
   import mx.events.MoveEvent;
   import mx.events.SandboxMouseEvent;
   import mx.managers.IFocusManagerComponent;
   import mx.styles.ISimpleStyleClient;
   
   [Alternative(replacement="spark.components.Button",since="4.0")]
   [IconFile("Button.png")]
   [DefaultTriggerEvent("click")]
   [DefaultBindingProperty(source="selected",destination="label")]
   [AccessibilityClass(implementation="mx.accessibility.ButtonAccImpl")]
   [Style(name="selectedDisabledIcon",type="Class",inherit="no")]
   [Style(name="selectedDownIcon",type="Class",inherit="no")]
   [Style(name="selectedOverIcon",type="Class",inherit="no")]
   [Style(name="selectedUpIcon",type="Class",inherit="no")]
   [Style(name="disabledIcon",type="Class",inherit="no")]
   [Style(name="downIcon",type="Class",inherit="no")]
   [Style(name="overIcon",type="Class",inherit="no")]
   [Style(name="upIcon",type="Class",inherit="no")]
   [Style(name="icon",type="Class",inherit="no",states="up, over, down, disabled, selectedUp, selectedOver, selectedDown, selectedDisabled")]
   [Style(name="selectedDisabledSkin",type="Class",inherit="no")]
   [Style(name="selectedDownSkin",type="Class",inherit="no")]
   [Style(name="selectedOverSkin",type="Class",inherit="no")]
   [Style(name="selectedUpSkin",type="Class",inherit="no")]
   [Style(name="emphasizedSkin",type="Class",inherit="no",states="up, over, down, disabled, selectedUp, selectedOver, selectedDown, selectedDisabled")]
   [Style(name="disabledSkin",type="Class",inherit="no")]
   [Style(name="downSkin",type="Class",inherit="no")]
   [Style(name="overSkin",type="Class",inherit="no")]
   [Style(name="upSkin",type="Class",inherit="no")]
   [Style(name="skin",type="Class",inherit="no",states="up, over, down, disabled, selectedUp, selectedOver, selectedDown, selectedDisabled")]
   [Style(name="verticalGap",type="Number",format="Length",inherit="no")]
   [Style(name="textSelectedColor",type="uint",format="Color",inherit="yes")]
   [Style(name="textRollOverColor",type="uint",format="Color",inherit="yes")]
   [Style(name="repeatInterval",type="Number",format="Time",inherit="no")]
   [Style(name="repeatDelay",type="Number",format="Time",inherit="no")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no")]
   [Style(name="labelVerticalOffset",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no")]
   [Style(name="focusColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="accentColor",type="uint",format="Color",inherit="yes",theme="spark")]
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
   [Style(name="highlightAlphas",type="Array",arrayType="Number",inherit="no",theme="halo")]
   [Style(name="fillColors",type="Array",arrayType="uint",format="Color",inherit="no",theme="halo")]
   [Style(name="fillAlphas",type="Array",arrayType="Number",inherit="no",theme="halo")]
   [Style(name="cornerRadius",type="Number",format="Length",inherit="no",theme="halo, spark")]
   [Style(name="borderColor",type="uint",format="Color",inherit="no",theme="halo")]
   [Style(name="paddingRight",type="Number",format="Length",inherit="no")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no")]
   [Style(name="leading",type="Number",format="Length",inherit="yes")]
   [Style(name="focusRoundedCorners",type="String",inherit="no")]
   [Style(name="focusAlpha",type="Number",inherit="no")]
   [Event(name="dataChange",type="mx.events.FlexEvent")]
   [Event(name="change",type="flash.events.Event")]
   [Event(name="buttonDown",type="mx.events.FlexEvent")]
   public class Button extends UIComponent implements IDataRenderer, IDropInListItemRenderer, IFocusManagerComponent, IListItemRenderer, IFontContextComponent, IButton
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var TEXT_WIDTH_PADDING:Number = UITextField.TEXT_WIDTH_PADDING + 1;
      
      private var skins:Array = [];
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var currentSkin:IFlexDisplayObject;
      
      protected var icons:Array = [];
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var currentIcon:IFlexDisplayObject;
      
      private var autoRepeatTimer:Timer;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var buttonOffset:Number = 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var centerContent:Boolean = true;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var extraSpacing:Number = 20;
      
      private var styleChangedFlag:Boolean = true;
      
      private var skinMeasuredWidth:Number;
      
      private var skinMeasuredHeight:Number;
      
      private var oldUnscaledWidth:Number;
      
      private var selectedSet:Boolean;
      
      private var labelSet:Boolean;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var checkedDefaultSkin:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var defaultSkinUsesStates:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var checkedDefaultIcon:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var defaultIconUsesStates:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var skinName:String = "skin";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var emphasizedSkinName:String = "emphasizedSkin";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var upSkinName:String = "upSkin";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var overSkinName:String = "overSkin";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var downSkinName:String = "downSkin";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var disabledSkinName:String = "disabledSkin";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var selectedUpSkinName:String = "selectedUpSkin";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var selectedOverSkinName:String = "selectedOverSkin";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var selectedDownSkinName:String = "selectedDownSkin";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var selectedDisabledSkinName:String = "selectedDisabledSkin";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var iconName:String = "icon";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var upIconName:String = "upIcon";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var overIconName:String = "overIcon";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var downIconName:String = "downIcon";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var disabledIconName:String = "disabledIcon";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var selectedUpIconName:String = "selectedUpIcon";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var selectedOverIconName:String = "selectedOverIcon";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var selectedDownIconName:String = "selectedDownIcon";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var selectedDisabledIconName:String = "selectedDisabledIcon";
      
      private var enabledChanged:Boolean = false;
      
      protected var textField:IUITextField;
      
      private var toolTipSet:Boolean = false;
      
      private var _autoRepeat:Boolean = false;
      
      private var _data:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _emphasized:Boolean = false;
      
      private var emphasizedChanged:Boolean = false;
      
      private var _label:String = "";
      
      private var labelChanged:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _labelPlacement:String = "right";
      
      private var _listData:BaseListData;
      
      private var _phase:String = "up";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var phaseChanged:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _selected:Boolean = false;
      
      public var selectedField:String = null;
      
      private var skinLayoutDirectionSet:Boolean = false;
      
      private var _skinLayoutDirection:String;
      
      public var stickyHighlighting:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _toggle:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var toggleChanged:Boolean = false;
      
      protected var _currentButtonState:String;
      
      public function Button()
      {
         super();
         mouseChildren = false;
         addEventListener(MouseEvent.ROLL_OVER,this.rollOverHandler);
         addEventListener(MouseEvent.ROLL_OUT,this.rollOutHandler);
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
         addEventListener(MouseEvent.CLICK,this.clickHandler);
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
         if(super.enabled == value)
         {
            return;
         }
         super.enabled = value;
         this.enabledChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      [Inspectable(category="General",defaultValue="null")]
      override public function set toolTip(value:String) : void
      {
         super.toolTip = value;
         if(Boolean(value))
         {
            this.toolTipSet = true;
         }
         else
         {
            this.toolTipSet = false;
            invalidateDisplayList();
         }
      }
      
      [Inspectable(defaultValue="false")]
      public function get autoRepeat() : Boolean
      {
         return this._autoRepeat;
      }
      
      public function set autoRepeat(value:Boolean) : void
      {
         this._autoRepeat = value;
         if(value)
         {
            this.autoRepeatTimer = new Timer(1);
         }
         else
         {
            this.autoRepeatTimer = null;
         }
      }
      
      [Inspectable(environment="none")]
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(value:Object) : void
      {
         var newSelected:* = undefined;
         var newLabel:* = undefined;
         this._data = value;
         if(Boolean(this._listData) && Boolean(this._listData is DataGridListData) && DataGridListData(this._listData).dataField != null)
         {
            newSelected = this._data[DataGridListData(this._listData).dataField];
            newLabel = "";
         }
         else if(Boolean(this._listData))
         {
            if(Boolean(this.selectedField))
            {
               newSelected = this._data[this.selectedField];
            }
            newLabel = this._listData.label;
         }
         else
         {
            newSelected = this._data;
         }
         if(newSelected !== undefined && !this.selectedSet)
         {
            this.selected = newSelected as Boolean;
            this.selectedSet = false;
         }
         if(newLabel !== undefined && !this.labelSet)
         {
            this.label = newLabel;
            this.labelSet = false;
         }
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      [Inspectable(category="General",defaultValue="false")]
      public function get emphasized() : Boolean
      {
         return this._emphasized;
      }
      
      public function set emphasized(value:Boolean) : void
      {
         this._emphasized = value;
         this.emphasizedChanged = true;
         invalidateDisplayList();
      }
      
      public function get fontContext() : IFlexModuleFactory
      {
         return moduleFactory;
      }
      
      public function set fontContext(moduleFactory:IFlexModuleFactory) : void
      {
         this.moduleFactory = moduleFactory;
      }
      
      [Inspectable(category="General",defaultValue="")]
      [Bindable("labelChanged")]
      public function get label() : String
      {
         return this._label;
      }
      
      public function set label(value:String) : void
      {
         this.labelSet = true;
         if(this._label != value)
         {
            this._label = value;
            this.labelChanged = true;
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("labelChanged"));
         }
      }
      
      [Inspectable(category="General",enumeration="left,right,top,bottom",defaultValue="right")]
      [Bindable("labelPlacementChanged")]
      public function get labelPlacement() : String
      {
         return this._labelPlacement;
      }
      
      public function set labelPlacement(value:String) : void
      {
         this._labelPlacement = value;
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("labelPlacementChanged"));
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get phase() : String
      {
         return this._phase;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set phase(value:String) : void
      {
         this._phase = value;
         this.phaseChanged = true;
         invalidateSize();
         invalidateProperties();
         invalidateDisplayList();
      }
      
      [Inspectable(category="General",defaultValue="false")]
      [Bindable("valueCommit")]
      [Bindable("click")]
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(value:Boolean) : void
      {
         this.selectedSet = true;
         this.setSelected(value,true);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setSelected(value:Boolean, isProgrammatic:Boolean = false) : void
      {
         if(this._selected != value)
         {
            this._selected = value;
            invalidateDisplayList();
            if(this.toggle && !isProgrammatic)
            {
               dispatchEvent(new Event(Event.CHANGE));
            }
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set skinLayoutDirection(value:String) : void
      {
         this.skinLayoutDirectionSet = true;
         this._skinLayoutDirection = value;
      }
      
      [Inspectable(category="General",defaultValue="false")]
      [Bindable("toggleChanged")]
      public function get toggle() : Boolean
      {
         return this._toggle;
      }
      
      public function set toggle(value:Boolean) : void
      {
         this._toggle = value;
         this.toggleChanged = true;
         invalidateProperties();
         invalidateDisplayList();
         dispatchEvent(new Event("toggleChanged"));
      }
      
      override protected function initializeAccessibility() : void
      {
         if(Button.createAccessibilityImplementation != null)
         {
            Button.createAccessibilityImplementation(this);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!this.textField)
         {
            this.textField = IUITextField(createInFontContext(UITextField));
            this.textField.styleName = this;
            addChild(DisplayObject(this.textField));
         }
      }
      
      override protected function commitProperties() : void
      {
         var prevState:String = null;
         super.commitProperties();
         if(Boolean(hasFontContextChanged()) && this.textField != null)
         {
            removeChild(DisplayObject(this.textField));
            this.textField = null;
         }
         if(!this.textField)
         {
            this.textField = IUITextField(createInFontContext(UITextField));
            this.textField.styleName = this;
            addChild(DisplayObject(this.textField));
            this.enabledChanged = true;
            this.toggleChanged = true;
         }
         if(!initialized)
         {
            this.viewSkin();
            this.viewIcon();
         }
         if(this.enabledChanged)
         {
            this.textField.enabled = enabled;
            if(Boolean(this.currentIcon) && this.currentIcon is IUIComponent)
            {
               IUIComponent(this.currentIcon).enabled = enabled;
            }
            this.enabledChanged = false;
         }
         if(this.toggleChanged)
         {
            if(!this.toggle)
            {
               this.selected = false;
            }
            this.toggleChanged = false;
         }
         if(this.phaseChanged)
         {
            prevState = this._currentButtonState;
            if(prevState != this.getCurrentButtonState())
            {
               stateChanged(prevState,this._currentButtonState,false);
            }
            this.phaseChanged = false;
         }
      }
      
      override protected function measure() : void
      {
         var lineMetrics:TextLineMetrics = null;
         super.measure();
         var textWidth:Number = 0;
         var textHeight:Number = 0;
         if(Boolean(this.label))
         {
            lineMetrics = measureText(this.label);
            textWidth = lineMetrics.width + TEXT_WIDTH_PADDING;
            textHeight = lineMetrics.height + UITextField.TEXT_HEIGHT_PADDING;
         }
         var tempCurrentIcon:IFlexDisplayObject = this.getCurrentIcon();
         var iconWidth:Number = Boolean(tempCurrentIcon) ? Number(tempCurrentIcon.width) : 0;
         var iconHeight:Number = Boolean(tempCurrentIcon) ? Number(tempCurrentIcon.height) : 0;
         var w:Number = 0;
         var h:Number = 0;
         if(this.labelPlacement == ButtonLabelPlacement.LEFT || this.labelPlacement == ButtonLabelPlacement.RIGHT)
         {
            w = textWidth + iconWidth;
            if(Boolean(textWidth) && Boolean(iconWidth))
            {
               w += getStyle("horizontalGap");
            }
            h = Math.max(textHeight,iconHeight);
         }
         else
         {
            w = Math.max(textWidth,iconWidth);
            h = textHeight + iconHeight;
            if(Boolean(textHeight) && Boolean(iconHeight))
            {
               h += getStyle("verticalGap");
            }
         }
         if(Boolean(textWidth) || Boolean(iconWidth))
         {
            w += getStyle("paddingLeft") + getStyle("paddingRight");
            h += getStyle("paddingTop") + getStyle("paddingBottom");
         }
         var bm:EdgeMetrics = Boolean(this.currentSkin) && Boolean(this.currentSkin is IBorder) && !(this.currentSkin is IFlexAsset) ? IBorder(this.currentSkin).borderMetrics : null;
         if(Boolean(bm))
         {
            w += bm.left + bm.right;
            h += bm.top + bm.bottom;
         }
         if(Boolean(this.currentSkin) && (isNaN(this.skinMeasuredWidth) || isNaN(this.skinMeasuredHeight)))
         {
            this.skinMeasuredWidth = this.currentSkin.measuredWidth;
            this.skinMeasuredHeight = this.currentSkin.measuredHeight;
         }
         if(!isNaN(this.skinMeasuredWidth))
         {
            w = Math.max(this.skinMeasuredWidth,w);
         }
         if(!isNaN(this.skinMeasuredHeight))
         {
            h = Math.max(this.skinMeasuredHeight,h);
         }
         measuredMinWidth = measuredWidth = w;
         measuredMinHeight = measuredHeight = h;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var skin:IFlexDisplayObject = null;
         var truncated:Boolean = false;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(this.emphasizedChanged)
         {
            this.changeSkins();
            this.emphasizedChanged = false;
         }
         var n:int = int(this.skins.length);
         for(var i:int = 0; i < n; i++)
         {
            skin = IFlexDisplayObject(this.skins[i]);
            skin.setActualSize(unscaledWidth,unscaledHeight);
         }
         this.viewSkin();
         this.viewIcon();
         this.layoutContents(unscaledWidth,unscaledHeight,this.phase == ButtonPhase.DOWN);
         if(this.oldUnscaledWidth > unscaledWidth || this.textField.text != this.label || this.labelChanged || this.styleChangedFlag)
         {
            this.textField.text = this.label;
            truncated = Boolean(this.textField.truncateToFit());
            if(!this.toolTipSet)
            {
               if(truncated)
               {
                  super.toolTip = this.label;
               }
               else
               {
                  super.toolTip = null;
               }
            }
            this.styleChangedFlag = false;
            this.labelChanged = false;
         }
         this.oldUnscaledWidth = unscaledWidth;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         this.styleChangedFlag = true;
         super.styleChanged(styleProp);
         if(!styleProp || styleProp == "styleName")
         {
            this.changeSkins();
            this.changeIcons();
            if(initialized)
            {
               this.viewSkin();
               this.viewIcon();
            }
         }
         else if(styleProp.toLowerCase().indexOf("skin") != -1)
         {
            this.changeSkins();
         }
         else if(styleProp.toLowerCase().indexOf("icon") != -1)
         {
            this.changeIcons();
            invalidateSize();
         }
      }
      
      override protected function adjustFocusRect(object:DisplayObject = null) : void
      {
         super.adjustFocusRect(!this.currentSkin ? DisplayObject(this.currentIcon) : this);
      }
      
      override protected function get currentCSSState() : String
      {
         return this.getCurrentButtonState();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function viewSkin() : void
      {
         var tempSkinName:String = null;
         if(!enabled)
         {
            tempSkinName = this.selected ? this.selectedDisabledSkinName : this.disabledSkinName;
         }
         else if(this.phase == ButtonPhase.UP)
         {
            tempSkinName = this.selected ? this.selectedUpSkinName : this.upSkinName;
         }
         else if(this.phase == ButtonPhase.OVER)
         {
            tempSkinName = this.selected ? this.selectedOverSkinName : this.overSkinName;
         }
         else if(this.phase == ButtonPhase.DOWN)
         {
            tempSkinName = this.selected ? this.selectedDownSkinName : this.downSkinName;
         }
         this.viewSkinForPhase(tempSkinName,this.getCurrentButtonState());
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function viewSkinForPhase(tempSkinName:String, stateName:String) : void
      {
         var newSkin:IFlexDisplayObject = null;
         var labelColor:Number = NaN;
         var styleableSkin:ISimpleStyleClient = null;
         var newSkinClass:Class = Class(getStyle(tempSkinName));
         if(!newSkinClass)
         {
            newSkinClass = this._emphasized ? Class(getStyle(this.emphasizedSkinName)) : Class(getStyle(this.skinName));
            newSkinClass = !newSkinClass && this._emphasized ? Class(getStyle(this.skinName)) : newSkinClass;
            if(this.defaultSkinUsesStates)
            {
               tempSkinName = this.skinName;
            }
            if(!this.checkedDefaultSkin && Boolean(newSkinClass))
            {
               newSkin = IFlexDisplayObject(new newSkinClass());
               if(!(newSkin is IProgrammaticSkin) && newSkin is IStateClient)
               {
                  this.defaultSkinUsesStates = true;
                  tempSkinName = this.skinName;
               }
               if(Boolean(newSkin))
               {
                  this.checkedDefaultSkin = true;
                  if(newSkin is ILayoutDirectionElement && this.skinLayoutDirectionSet)
                  {
                     ILayoutDirectionElement(newSkin).layoutDirection = this._skinLayoutDirection;
                  }
               }
            }
         }
         newSkin = IFlexDisplayObject(getChildByName(tempSkinName));
         if(!newSkin)
         {
            if(Boolean(newSkinClass))
            {
               newSkin = IFlexDisplayObject(new newSkinClass());
               newSkin.name = tempSkinName;
               styleableSkin = newSkin as ISimpleStyleClient;
               if(Boolean(styleableSkin))
               {
                  styleableSkin.styleName = this;
               }
               if(newSkin is ILayoutDirectionElement && this.skinLayoutDirectionSet)
               {
                  ILayoutDirectionElement(newSkin).layoutDirection = this._skinLayoutDirection;
               }
               addChild(DisplayObject(newSkin));
               newSkin.setActualSize(unscaledWidth,unscaledHeight);
               if(newSkin is IInvalidating && Boolean(initialized))
               {
                  IInvalidating(newSkin).validateNow();
               }
               else if(newSkin is IProgrammaticSkin && Boolean(initialized))
               {
                  IProgrammaticSkin(newSkin).validateDisplayList();
               }
               this.skins.push(newSkin);
            }
         }
         if(Boolean(this.currentSkin))
         {
            this.currentSkin.visible = false;
         }
         this.currentSkin = newSkin;
         if(this.defaultSkinUsesStates && this.currentSkin is IStateClient)
         {
            IStateClient(this.currentSkin).currentState = stateName;
            if(this.currentSkin is IInvalidating)
            {
               IInvalidating(this.currentSkin).validateNow();
            }
         }
         if(Boolean(this.currentSkin))
         {
            this.currentSkin.visible = true;
         }
         if(enabled)
         {
            if(this.phase == ButtonPhase.OVER)
            {
               labelColor = Number(this.textField.getStyle("textRollOverColor"));
            }
            else if(this.phase == ButtonPhase.DOWN)
            {
               labelColor = Number(this.textField.getStyle("textSelectedColor"));
            }
            else
            {
               labelColor = Number(this.textField.getStyle("color"));
            }
            this.textField.setColor(labelColor);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getCurrentIconName() : String
      {
         var tempIconName:String = null;
         if(!enabled)
         {
            tempIconName = this.selected ? this.selectedDisabledIconName : this.disabledIconName;
         }
         else if(this.phase == ButtonPhase.UP)
         {
            tempIconName = this.selected ? this.selectedUpIconName : this.upIconName;
         }
         else if(this.phase == ButtonPhase.OVER)
         {
            tempIconName = this.selected ? this.selectedOverIconName : this.overIconName;
         }
         else if(this.phase == ButtonPhase.DOWN)
         {
            tempIconName = this.selected ? this.selectedDownIconName : this.downIconName;
         }
         return tempIconName;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getCurrentIcon() : IFlexDisplayObject
      {
         var tempIconName:String = this.getCurrentIconName();
         if(!tempIconName)
         {
            return null;
         }
         return this.viewIconForPhase(tempIconName);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function viewIcon() : void
      {
         var tempIconName:String = this.getCurrentIconName();
         this.viewIconForPhase(tempIconName);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function viewIconForPhase(tempIconName:String) : IFlexDisplayObject
      {
         var newIcon:IFlexDisplayObject = null;
         var sizeIcon:Boolean = false;
         var newIconClass:Class = Class(getStyle(tempIconName));
         if(!newIconClass)
         {
            newIconClass = Class(getStyle(this.iconName));
            if(this.defaultIconUsesStates)
            {
               tempIconName = this.iconName;
            }
            if(!this.checkedDefaultIcon && Boolean(newIconClass))
            {
               newIcon = IFlexDisplayObject(new newIconClass());
               if(!(newIcon is IProgrammaticSkin) && newIcon is IStateClient)
               {
                  this.defaultIconUsesStates = true;
                  tempIconName = this.iconName;
               }
               if(Boolean(newIcon))
               {
                  this.checkedDefaultIcon = true;
               }
            }
         }
         newIcon = IFlexDisplayObject(getChildByName(tempIconName));
         if(newIcon == null)
         {
            if(newIconClass != null)
            {
               newIcon = IFlexDisplayObject(new newIconClass());
               newIcon.name = tempIconName;
               if(newIcon is ISimpleStyleClient)
               {
                  ISimpleStyleClient(newIcon).styleName = this;
               }
               addChild(DisplayObject(newIcon));
               sizeIcon = false;
               if(newIcon is IInvalidating)
               {
                  IInvalidating(newIcon).validateNow();
                  sizeIcon = true;
               }
               else if(newIcon is IProgrammaticSkin)
               {
                  IProgrammaticSkin(newIcon).validateDisplayList();
                  sizeIcon = true;
               }
               if(Boolean(newIcon) && newIcon is IUIComponent)
               {
                  IUIComponent(newIcon).enabled = enabled;
               }
               if(sizeIcon)
               {
                  newIcon.setActualSize(newIcon.measuredWidth,newIcon.measuredHeight);
               }
               this.icons.push(newIcon);
            }
         }
         if(this.currentIcon != null)
         {
            this.currentIcon.visible = false;
         }
         this.currentIcon = newIcon;
         if(this.defaultIconUsesStates && this.currentIcon is IStateClient)
         {
            IStateClient(this.currentIcon).currentState = this.getCurrentButtonState();
            if(this.currentIcon is IInvalidating)
            {
               IInvalidating(this.currentIcon).validateNow();
            }
         }
         if(this.currentIcon != null)
         {
            this.currentIcon.visible = true;
         }
         return newIcon;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getCurrentButtonState() : String
      {
         this._currentButtonState = "";
         if(!enabled)
         {
            this._currentButtonState = this.selected ? "selectedDisabled" : "disabled";
         }
         else if(this.phase == ButtonPhase.UP)
         {
            this._currentButtonState = this.selected ? "selectedUp" : "up";
         }
         else if(this.phase == ButtonPhase.OVER)
         {
            this._currentButtonState = this.selected ? "selectedOver" : "over";
         }
         else if(this.phase == ButtonPhase.DOWN)
         {
            this._currentButtonState = this.selected ? "selectedDown" : "down";
         }
         return this._currentButtonState;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function layoutContents(unscaledWidth:Number, unscaledHeight:Number, offset:Boolean) : void
      {
         var lineMetrics:TextLineMetrics = null;
         var moveEvent:MoveEvent = null;
         var labelWidth:Number = 0;
         var labelHeight:Number = 0;
         var labelX:Number = 0;
         var labelY:Number = 0;
         var iconWidth:Number = 0;
         var iconHeight:Number = 0;
         var iconX:Number = 0;
         var iconY:Number = 0;
         var horizontalGap:Number = 0;
         var verticalGap:Number = 0;
         var paddingLeft:Number = Number(getStyle("paddingLeft"));
         var paddingRight:Number = Number(getStyle("paddingRight"));
         var paddingTop:Number = Number(getStyle("paddingTop"));
         var paddingBottom:Number = Number(getStyle("paddingBottom"));
         var textWidth:Number = 0;
         var textHeight:Number = 0;
         if(Boolean(this.label))
         {
            lineMetrics = measureText(this.label);
            textWidth = lineMetrics.width + TEXT_WIDTH_PADDING;
            textHeight = lineMetrics.height + UITextField.TEXT_HEIGHT_PADDING;
         }
         else
         {
            lineMetrics = measureText("Wj");
            textHeight = lineMetrics.height + UITextField.TEXT_HEIGHT_PADDING;
         }
         var n:Number = offset ? this.buttonOffset : 0;
         var textAlign:String = getStyle("textAlign");
         if(textAlign == "start")
         {
            textAlign = TextFormatAlign.LEFT;
         }
         else if(textAlign == "end")
         {
            textAlign = TextFormatAlign.RIGHT;
         }
         var viewWidth:Number = unscaledWidth;
         var viewHeight:Number = unscaledHeight;
         var bm:EdgeMetrics = Boolean(this.currentSkin) && Boolean(this.currentSkin is IBorder) && !(this.currentSkin is IFlexAsset) ? IBorder(this.currentSkin).borderMetrics : null;
         if(Boolean(bm))
         {
            viewWidth -= bm.left + bm.right;
            viewHeight -= bm.top + bm.bottom;
         }
         if(Boolean(this.currentIcon))
         {
            iconWidth = Number(this.currentIcon.width);
            iconHeight = Number(this.currentIcon.height);
         }
         if(this.labelPlacement == ButtonLabelPlacement.LEFT || this.labelPlacement == ButtonLabelPlacement.RIGHT)
         {
            horizontalGap = Number(getStyle("horizontalGap"));
            if(iconWidth == 0 || textWidth == 0)
            {
               horizontalGap = 0;
            }
            if(textWidth > 0)
            {
               this.textField.width = labelWidth = Math.max(Math.min(viewWidth - iconWidth - horizontalGap - paddingLeft - paddingRight,textWidth),0);
            }
            else
            {
               this.textField.width = labelWidth = 0;
            }
            this.textField.height = labelHeight = Math.min(viewHeight,textHeight);
            if(textAlign == "left")
            {
               labelX += paddingLeft;
            }
            else if(textAlign == "right")
            {
               labelX += viewWidth - labelWidth - iconWidth - horizontalGap - paddingRight;
            }
            else
            {
               labelX += (viewWidth - labelWidth - iconWidth - horizontalGap - paddingLeft - paddingRight) / 2 + paddingLeft;
            }
            if(this.labelPlacement == ButtonLabelPlacement.RIGHT)
            {
               labelX += iconWidth + horizontalGap;
               iconX = labelX - (iconWidth + horizontalGap);
            }
            else
            {
               iconX = labelX + labelWidth + horizontalGap;
            }
            iconY = (viewHeight - iconHeight - paddingTop - paddingBottom) / 2 + paddingTop;
            labelY = (viewHeight - labelHeight - paddingTop - paddingBottom) / 2 + paddingTop;
         }
         else
         {
            verticalGap = Number(getStyle("verticalGap"));
            if(iconHeight == 0 || this.label == "")
            {
               verticalGap = 0;
            }
            if(textWidth > 0)
            {
               this.textField.width = labelWidth = Math.max(viewWidth - paddingLeft - paddingRight,0);
               this.textField.height = labelHeight = Math.min(viewHeight - iconHeight - paddingTop - paddingBottom - verticalGap,textHeight);
            }
            else
            {
               this.textField.width = labelWidth = 0;
               this.textField.height = labelHeight = 0;
            }
            labelX = paddingLeft;
            if(textAlign == "left")
            {
               iconX += paddingLeft;
            }
            else if(textAlign == "right")
            {
               iconX += Math.max(viewWidth - iconWidth - paddingRight,paddingLeft);
            }
            else
            {
               iconX += (viewWidth - iconWidth - paddingLeft - paddingRight) / 2 + paddingLeft;
            }
            if(this.labelPlacement == ButtonLabelPlacement.TOP)
            {
               labelY += (viewHeight - labelHeight - iconHeight - paddingTop - paddingBottom - verticalGap) / 2 + paddingTop;
               iconY += labelY + labelHeight + verticalGap;
            }
            else
            {
               iconY += (viewHeight - labelHeight - iconHeight - paddingTop - paddingBottom - verticalGap) / 2 + paddingTop;
               labelY += iconY + iconHeight + verticalGap;
            }
         }
         var buffX:Number = n;
         var buffY:Number = n;
         if(Boolean(bm))
         {
            buffX += bm.left;
            buffY += bm.top;
         }
         if(FlexVersion.compatibilityVersion >= FlexVersion.VERSION_4_0)
         {
            labelY += getStyle("labelVerticalOffset");
         }
         this.textField.x = Math.round(labelX + buffX);
         this.textField.y = Math.round(labelY + buffY);
         if(Boolean(this.currentIcon))
         {
            iconX += buffX;
            iconY += buffY;
            moveEvent = new MoveEvent(MoveEvent.MOVE);
            moveEvent.oldX = this.currentIcon.x;
            moveEvent.oldY = this.currentIcon.y;
            this.currentIcon.x = Math.round(iconX);
            this.currentIcon.y = Math.round(iconY);
            this.currentIcon.dispatchEvent(moveEvent);
         }
         if(Boolean(this.currentSkin))
         {
            setChildIndex(DisplayObject(this.currentSkin),numChildren - 1);
         }
         if(Boolean(this.currentIcon))
         {
            setChildIndex(DisplayObject(this.currentIcon),numChildren - 1);
         }
         if(Boolean(this.textField))
         {
            setChildIndex(DisplayObject(this.textField),numChildren - 1);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function changeSkins() : void
      {
         var n:int = int(this.skins.length);
         for(var i:int = 0; i < n; i++)
         {
            removeChild(this.skins[i]);
         }
         this.skins = [];
         this.skinMeasuredWidth = NaN;
         this.skinMeasuredHeight = NaN;
         this.checkedDefaultSkin = false;
         this.defaultSkinUsesStates = false;
         if(initialized)
         {
            this.viewSkin();
            invalidateSize();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function changeIcons() : void
      {
         var n:int = int(this.icons.length);
         for(var i:int = 0; i < n; i++)
         {
            removeChild(this.icons[i]);
         }
         this.icons = [];
         this.checkedDefaultIcon = false;
         this.defaultIconUsesStates = false;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function buttonPressed() : void
      {
         this.phase = ButtonPhase.DOWN;
         dispatchEvent(new FlexEvent(FlexEvent.BUTTON_DOWN));
         if(this.autoRepeat)
         {
            this.autoRepeatTimer.delay = getStyle("repeatDelay");
            this.autoRepeatTimer.addEventListener(TimerEvent.TIMER,this.autoRepeatTimer_timerDelayHandler);
            this.autoRepeatTimer.start();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function buttonReleased() : void
      {
         systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP,this.systemManager_mouseUpHandler,true);
         systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.stage_mouseLeaveHandler);
         if(Boolean(this.autoRepeatTimer))
         {
            this.autoRepeatTimer.removeEventListener(TimerEvent.TIMER,this.autoRepeatTimer_timerDelayHandler);
            this.autoRepeatTimer.removeEventListener(TimerEvent.TIMER,this.autoRepeatTimer_timerHandler);
            this.autoRepeatTimer.reset();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getTextField() : IUITextField
      {
         return this.textField;
      }
      
      override protected function focusOutHandler(event:FocusEvent) : void
      {
         super.focusOutHandler(event);
         if(this.phase != ButtonPhase.UP)
         {
            this.phase = ButtonPhase.UP;
         }
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         if(!enabled)
         {
            return;
         }
         if(event.keyCode == Keyboard.SPACE)
         {
            this.buttonPressed();
         }
      }
      
      override protected function keyUpHandler(event:KeyboardEvent) : void
      {
         if(!enabled)
         {
            return;
         }
         if(event.keyCode == Keyboard.SPACE)
         {
            this.buttonReleased();
            if(this.phase == ButtonPhase.DOWN)
            {
               dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            }
            this.phase = ButtonPhase.UP;
         }
      }
      
      protected function rollOverHandler(event:MouseEvent) : void
      {
         if(this.phase == ButtonPhase.UP)
         {
            if(event.buttonDown)
            {
               return;
            }
            this.phase = ButtonPhase.OVER;
            event.updateAfterEvent();
         }
         else if(this.phase == ButtonPhase.OVER)
         {
            this.phase = ButtonPhase.DOWN;
            event.updateAfterEvent();
            if(Boolean(this.autoRepeatTimer))
            {
               this.autoRepeatTimer.start();
            }
         }
      }
      
      protected function rollOutHandler(event:MouseEvent) : void
      {
         if(this.phase == ButtonPhase.OVER)
         {
            this.phase = ButtonPhase.UP;
            event.updateAfterEvent();
         }
         else if(this.phase == ButtonPhase.DOWN && !this.stickyHighlighting)
         {
            this.phase = ButtonPhase.OVER;
            event.updateAfterEvent();
            if(Boolean(this.autoRepeatTimer))
            {
               this.autoRepeatTimer.stop();
            }
         }
      }
      
      protected function mouseDownHandler(event:MouseEvent) : void
      {
         if(!enabled)
         {
            return;
         }
         systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP,this.systemManager_mouseUpHandler,true);
         systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.stage_mouseLeaveHandler);
         this.buttonPressed();
         event.updateAfterEvent();
      }
      
      protected function mouseUpHandler(event:MouseEvent) : void
      {
         if(!enabled)
         {
            return;
         }
         this.phase = ButtonPhase.OVER;
         this.buttonReleased();
         if(!this.toggle)
         {
            event.updateAfterEvent();
         }
      }
      
      protected function clickHandler(event:MouseEvent) : void
      {
         if(!enabled)
         {
            event.stopImmediatePropagation();
            return;
         }
         if(this.toggle)
         {
            this.setSelected(!this.selected);
            event.updateAfterEvent();
         }
      }
      
      private function systemManager_mouseUpHandler(event:MouseEvent) : void
      {
         if(contains(DisplayObject(event.target)))
         {
            return;
         }
         this.phase = ButtonPhase.UP;
         this.buttonReleased();
         event.updateAfterEvent();
      }
      
      private function stage_mouseLeaveHandler(event:Event) : void
      {
         this.phase = ButtonPhase.UP;
         this.buttonReleased();
      }
      
      private function autoRepeatTimer_timerDelayHandler(event:Event) : void
      {
         if(!enabled)
         {
            return;
         }
         dispatchEvent(new FlexEvent(FlexEvent.BUTTON_DOWN));
         if(this.autoRepeat)
         {
            this.autoRepeatTimer.reset();
            this.autoRepeatTimer.removeEventListener(TimerEvent.TIMER,this.autoRepeatTimer_timerDelayHandler);
            this.autoRepeatTimer.delay = getStyle("repeatInterval");
            this.autoRepeatTimer.addEventListener(TimerEvent.TIMER,this.autoRepeatTimer_timerHandler);
            this.autoRepeatTimer.start();
         }
      }
      
      private function autoRepeatTimer_timerHandler(event:Event) : void
      {
         if(!enabled)
         {
            return;
         }
         dispatchEvent(new FlexEvent(FlexEvent.BUTTON_DOWN));
      }
   }
}

