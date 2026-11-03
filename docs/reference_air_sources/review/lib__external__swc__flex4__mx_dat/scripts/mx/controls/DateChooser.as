package mx.controls
{
   import flash.display.DisplayObject;
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventPhase;
   import flash.events.KeyboardEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   import flash.utils.getQualifiedClassName;
   import mx.core.FlexSprite;
   import mx.core.FlexVersion;
   import mx.core.IFlexModuleFactory;
   import mx.core.IFontContextComponent;
   import mx.core.IUITextField;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.events.CalendarLayoutChangeEvent;
   import mx.events.DateChooserEvent;
   import mx.events.FlexEvent;
   import mx.graphics.RectangularDropShadow;
   import mx.managers.IFocusManagerComponent;
   import mx.styles.StyleManager;
   import mx.styles.StyleProxy;
   import mx.utils.GraphicsUtil;
   
   [ResourceBundle("SharedResources")]
   [ResourceBundle("controls")]
   [RequiresDataBinding("true")]
   [IconFile("DateChooser.png")]
   [DefaultTriggerEvent("change")]
   [DefaultBindingProperty(source="selectedDate",destination="selectedDate")]
   [AccessibilityClass(implementation="mx.accessibility.DateChooserAccImpl")]
   [Style(name="weekDayStyleName",type="String",inherit="no")]
   [Style(name="todayStyleName",type="String",inherit="no")]
   [Style(name="todayIndicatorSkin",type="Class",inherit="no")]
   [Style(name="todayColor",type="uint",format="Color",inherit="yes",theme="halo, spark")]
   [Style(name="symbolColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="selectionIndicatorSkin",type="Class",inherit="no")]
   [Style(name="selectionColor",type="uint",format="Color",inherit="yes")]
   [Style(name="rollOverIndicatorSkin",type="Class",inherit="no")]
   [Style(name="rollOverColor",type="uint",format="Color",inherit="yes")]
   [Style(name="prevYearUpSkin",type="Class",inherit="no")]
   [Style(name="prevYearOverSkin",type="Class",inherit="no")]
   [Style(name="prevYearDownSkin",type="Class",inherit="no")]
   [Style(name="prevYearDisabledSkin",type="Class",inherit="no")]
   [Style(name="prevYearSkin",type="Class",inherit="no",states="up, over, down, disabled")]
   [Style(name="prevMonthUpSkin",type="Class",inherit="no")]
   [Style(name="prevMonthOverSkin",type="Class",inherit="no")]
   [Style(name="prevMonthDownSkin",type="Class",inherit="no")]
   [Style(name="prevMonthDisabledSkin",type="Class",inherit="no")]
   [Style(name="prevMonthSkin",type="Class",inherit="no",states="up, over, down, disabled")]
   [Style(name="nextYearUpSkin",type="Class",inherit="no")]
   [Style(name="nextYearOverSkin",type="Class",inherit="no")]
   [Style(name="nextYearDownSkin",type="Class",inherit="no")]
   [Style(name="nextYearDisabledSkin",type="Class",inherit="no")]
   [Style(name="nextYearSkin",type="Class",inherit="no",states="up, over, down, disabled")]
   [Style(name="nextMonthUpSkin",type="Class",inherit="no")]
   [Style(name="nextMonthOverSkin",type="Class",inherit="no")]
   [Style(name="nextMonthDownSkin",type="Class",inherit="no")]
   [Style(name="nextMonthDisabledSkin",type="Class",inherit="no")]
   [Style(name="nextMonthSkin",type="Class",inherit="no",states="up, over, down, disabled")]
   [Style(name="highlightAlphas",type="Array",arrayType="Number",inherit="no",theme="halo")]
   [Style(name="headerStyleName",type="String",inherit="no")]
   [Style(name="headerColors",type="Array",arrayType="uint",format="Color",inherit="yes",theme="halo, spark")]
   [Style(name="focusColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="cornerRadius",type="Number",format="Length",inherit="no",theme="halo, spark")]
   [Style(name="contentBackgroundColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="contentBackgroundAlpha",type="Number",inherit="yes",theme="spark")]
   [Style(name="borderVisible",type="Boolean",inherit="no",theme="spark")]
   [Style(name="borderThickness",type="Number",format="Length",inherit="no",theme="halo")]
   [Style(name="borderColor",type="uint",format="Color",inherit="no",theme="halo, spark")]
   [Style(name="borderAlpha",type="Number",inherit="no",theme="spark")]
   [Style(name="backgroundColor",type="uint",format="Color",inherit="no",theme="halo")]
   [Style(name="backgroundAlpha",type="Number",inherit="no",theme="halo")]
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
   [Style(name="leading",type="Number",format="Length",inherit="yes")]
   [Style(name="disabledIconColor",type="uint",format="Color",inherit="yes",theme="halo")]
   [Style(name="iconColor",type="uint",format="Color",inherit="yes",theme="halo")]
   [Style(name="verticalGap",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no")]
   [Style(name="focusRoundedCorners",type="String",inherit="no")]
   [Style(name="focusAlpha",type="Number",inherit="no")]
   [Event(name="scroll",type="mx.events.DateChooserEvent")]
   [Event(name="change",type="mx.events.CalendarLayoutChangeEvent")]
   public class DateChooser extends UIComponent implements IFocusManagerComponent, IFontContextComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var _nextMonthStyleFilters:Object = {
         "highlightAlphas":"highlightAlphas",
         "nextMonthUpSkin":"nextMonthUpSkin",
         "nextMonthOverSkin":"nextMonthOverSkin",
         "nextMonthDownSkin":"nextMonthDownSkin",
         "nextMonthDisabledSkin":"nextMonthDisabledSkin",
         "nextMonthSkin":"nextMonthSkin",
         "repeatDelay":"repeatDelay",
         "repeatInterval":"repeatInterval"
      };
      
      private static var _nextYearStyleFilters:Object = {
         "highlightAlphas":"highlightAlphas",
         "nextYearUpSkin":"nextYearUpSkin",
         "nextYearOverSkin":"nextYearOverSkin",
         "nextYearDownSkin":"nextYearDownSkin",
         "nextYearDisabledSkin":"nextYearDisabledSkin",
         "nextYearSkin":"nextYearSkin",
         "repeatDelay":"repeatDelay",
         "repeatInterval":"repeatInterval"
      };
      
      private static var _prevMonthStyleFilters:Object = {
         "highlightAlphas":"highlightAlphas",
         "prevMonthUpSkin":"prevMonthUpSkin",
         "prevMonthOverSkin":"prevMonthOverSkin",
         "prevMonthDownSkin":"prevMonthDownSkin",
         "prevMonthDisabledSkin":"prevMonthDisabledSkin",
         "prevMonthSkin":"prevMonthSkin",
         "repeatDelay":"repeatDelay",
         "repeatInterval":"repeatInterval"
      };
      
      private static var _prevYearStyleFilters:Object = {
         "highlightAlphas":"highlightAlphas",
         "prevYearUpSkin":"prevYearUpSkin",
         "prevYearOverSkin":"prevYearOverSkin",
         "prevYearDownSkin":"prevYearDownSkin",
         "prevYearDisabledSkin":"prevYearDisabledSkin",
         "prevYearSkin":"prevYearSkin",
         "repeatDelay":"repeatDelay",
         "repeatInterval":"repeatInterval"
      };
      
      private var HEADER_WIDTH_PAD:Number = 5;
      
      private var SKIN_WIDTH_PAD:Number = 6;
      
      private var SKIN_HEIGHT_PAD:Number = 4;
      
      private var YEAR_BUTTONS_PAD:Number = 6;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var background:UIComponent;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var border:UIComponent;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var headerDisplay:UIComponent;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var monthDisplay:IUITextField;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var fwdMonthHit:Sprite;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var backMonthHit:Sprite;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var upYearHit:Sprite;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var downYearHit:Sprite;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var calHeader:UIComponent;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var yearDisplay:IUITextField;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var upYearButton:Button;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var downYearButton:Button;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var fwdMonthButton:Button;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var backMonthButton:Button;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var dateGrid:CalendarLayout;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var dropShadow:RectangularDropShadow;
      
      private var previousSelectedCellIndex:Number = NaN;
      
      private var monthSkinWidth:Number = 6;
      
      private var monthSkinHeight:Number = 11;
      
      private var yearSkinWidth:Number = 10;
      
      private var yearSkinHeight:Number = 8;
      
      private var headerHeight:Number = 30;
      
      private var _enabled:Boolean = true;
      
      private var enabledChanged:Boolean = false;
      
      private var _allowDisjointSelection:Boolean = true;
      
      private var allowDisjointSelectionChanged:Boolean = false;
      
      private var _allowMultipleSelection:Boolean = false;
      
      private var allowMultipleSelectionChanged:Boolean = false;
      
      private var _dayNames:Array;
      
      private var dayNamesChanged:Boolean = false;
      
      private var dayNamesOverride:Array;
      
      private var _disabledDays:Array = [];
      
      private var disabledDaysChanged:Boolean = false;
      
      private var _disabledRanges:Array = [];
      
      private var disabledRangesChanged:Boolean = false;
      
      private var _displayedMonth:int = new Date().getMonth();
      
      private var displayedMonthChanged:Boolean = false;
      
      private var _displayedYear:int = new Date().getFullYear();
      
      private var displayedYearChanged:Boolean = false;
      
      private var _firstDayOfWeek:Object;
      
      private var firstDayOfWeekChanged:Boolean = false;
      
      private var firstDayOfWeekOverride:Object;
      
      private var _maxYear:int = 2100;
      
      private var _minYear:int = 1900;
      
      private var _monthNames:Array;
      
      private var monthNamesChanged:Boolean = false;
      
      private var monthNamesOverride:Array;
      
      private var _monthSymbol:String;
      
      private var monthSymbolChanged:Boolean = false;
      
      private var monthSymbolOverride:String;
      
      private var _selectableRange:Object;
      
      private var selectableRangeChanged:Boolean = false;
      
      private var _selectedDate:Date;
      
      private var selectedDateChanged:Boolean = false;
      
      private var _selectedRanges:Array = [];
      
      private var selectedRangesChanged:Boolean = false;
      
      private var _showToday:Boolean = true;
      
      private var showTodayChanged:Boolean = false;
      
      private var _yearNavigationEnabled:Boolean = false;
      
      private var yearNavigationEnabledChanged:Boolean = false;
      
      private var _yearSymbol:String;
      
      private var yearSymbolChanged:Boolean = false;
      
      private var yearSymbolOverride:String;
      
      public function DateChooser()
      {
         super();
         tabEnabled = true;
         tabFocusEnabled = true;
         tabChildren = false;
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
      }
      
      override public function get baselinePosition() : Number
      {
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         return this.monthDisplay.y + this.monthDisplay.baselinePosition;
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="true")]
      [Bindable("enabledChanged")]
      override public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      override public function set enabled(value:Boolean) : void
      {
         if(value == this._enabled)
         {
            return;
         }
         this._enabled = value;
         super.enabled = value;
         this.enabledChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="General",defaultValue="true")]
      [Bindable("allowDisjointSelectionChanged")]
      public function get allowDisjointSelection() : Boolean
      {
         return this._allowDisjointSelection;
      }
      
      public function set allowDisjointSelection(value:Boolean) : void
      {
         this._allowDisjointSelection = value;
         this.allowDisjointSelectionChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="General",defaultValue="false")]
      [Bindable("allowMultipleSelectionChanged")]
      public function get allowMultipleSelection() : Boolean
      {
         return this._allowMultipleSelection;
      }
      
      public function set allowMultipleSelection(value:Boolean) : void
      {
         this._allowMultipleSelection = value;
         this.allowMultipleSelectionChanged = true;
         invalidateProperties();
      }
      
      protected function get calendarLayoutStyleFilters() : Object
      {
         return null;
      }
      
      [Inspectable(arrayType="String",defaultValue="null")]
      [Bindable("dayNamesChanged")]
      public function get dayNames() : Array
      {
         return this._dayNames;
      }
      
      public function set dayNames(value:Array) : void
      {
         this.dayNamesOverride = value;
         this._dayNames = value != null ? value : resourceManager.getStringArray("controls","dayNamesShortest");
         this._dayNames = Boolean(this._dayNames) ? this._dayNames.slice(0) : null;
         this.dayNamesChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(arrayType="Date")]
      [Bindable("disabledDaysChanged")]
      public function get disabledDays() : Array
      {
         return this._disabledDays;
      }
      
      public function set disabledDays(value:Array) : void
      {
         this._disabledDays = value;
         this.disabledDaysChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(arrayType="Object")]
      [Bindable("disabledRangesChanged")]
      public function get disabledRanges() : Array
      {
         return this._disabledRanges;
      }
      
      public function set disabledRanges(value:Array) : void
      {
         this._disabledRanges = this.scrubTimeValues(value);
         this.disabledRangesChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="General")]
      [Bindable("viewChanged")]
      [Bindable("scroll")]
      public function get displayedMonth() : int
      {
         if(Boolean(this.dateGrid) && this._displayedMonth != this.dateGrid.displayedMonth)
         {
            return this.dateGrid.displayedMonth;
         }
         return this._displayedMonth;
      }
      
      public function set displayedMonth(value:int) : void
      {
         if(isNaN(value) || this.displayedMonth == value)
         {
            return;
         }
         this._displayedMonth = value;
         this.displayedMonthChanged = true;
         invalidateProperties();
         if(Boolean(this.dateGrid))
         {
            this.dateGrid.displayedMonth = value;
         }
      }
      
      [Inspectable(category="General")]
      [Bindable("viewChanged")]
      [Bindable("scroll")]
      public function get displayedYear() : int
      {
         if(Boolean(this.dateGrid))
         {
            return this.dateGrid.displayedYear;
         }
         return this._displayedYear;
      }
      
      public function set displayedYear(value:int) : void
      {
         if(isNaN(value) || this.displayedYear == value)
         {
            return;
         }
         this._displayedYear = value;
         this.displayedYearChanged = true;
         invalidateProperties();
         if(Boolean(this.dateGrid))
         {
            this.dateGrid.displayedYear = value;
         }
      }
      
      [Inspectable(defaultValue="null")]
      [Bindable("firstDayOfWeekChanged")]
      public function get firstDayOfWeek() : Object
      {
         return this._firstDayOfWeek;
      }
      
      public function set firstDayOfWeek(value:Object) : void
      {
         this.firstDayOfWeekOverride = value;
         this._firstDayOfWeek = value != null ? int(value) : resourceManager.getInt("controls","firstDayOfWeek");
         this.firstDayOfWeekChanged = true;
         invalidateProperties();
      }
      
      public function get fontContext() : IFlexModuleFactory
      {
         return moduleFactory;
      }
      
      public function set fontContext(moduleFactory:IFlexModuleFactory) : void
      {
         this.moduleFactory = moduleFactory;
      }
      
      public function get maxYear() : int
      {
         return this._maxYear;
      }
      
      public function set maxYear(value:int) : void
      {
         if(this._maxYear == value)
         {
            return;
         }
         this._maxYear = value;
      }
      
      public function get minYear() : int
      {
         return this._minYear;
      }
      
      public function set minYear(value:int) : void
      {
         if(this._minYear == value)
         {
            return;
         }
         this._minYear = value;
      }
      
      [Inspectable(arrayType="String",defaultValue="null")]
      [Bindable("monthNamesChanged")]
      public function get monthNames() : Array
      {
         return this._monthNames;
      }
      
      public function set monthNames(value:Array) : void
      {
         this.monthNamesOverride = value;
         this._monthNames = value != null ? value : resourceManager.getStringArray("SharedResources","monthNames");
         this._monthNames = Boolean(this._monthNames) ? this.monthNames.slice(0) : null;
         this.monthNamesChanged = true;
         invalidateProperties();
         invalidateSize();
      }
      
      [Inspectable(defaultValue="")]
      [Bindable("monthSymbolChanged")]
      public function get monthSymbol() : String
      {
         return this._monthSymbol;
      }
      
      public function set monthSymbol(value:String) : void
      {
         this.monthSymbolOverride = value;
         this._monthSymbol = value != null ? value : resourceManager.getString("SharedResources","monthSymbol");
         this.monthSymbolChanged = true;
         invalidateProperties();
      }
      
      protected function get nextMonthStyleFilters() : Object
      {
         return _nextMonthStyleFilters;
      }
      
      protected function get nextYearStyleFilters() : Object
      {
         return _nextYearStyleFilters;
      }
      
      protected function get prevMonthStyleFilters() : Object
      {
         return _prevMonthStyleFilters;
      }
      
      protected function get prevYearStyleFilters() : Object
      {
         return _prevYearStyleFilters;
      }
      
      [Bindable("selectableRangeChanged")]
      public function get selectableRange() : Object
      {
         return this._selectableRange;
      }
      
      public function set selectableRange(value:Object) : void
      {
         this._selectableRange = this.scrubTimeValue(value);
         this.selectableRangeChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="General")]
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedDate() : Date
      {
         return this._selectedDate;
      }
      
      public function set selectedDate(value:Date) : void
      {
         this._selectedDate = this.scrubTimeValue(value) as Date;
         this.selectedDateChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(arrayType="Date")]
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedRanges() : Array
      {
         this._selectedRanges = this.dateGrid.selectedRanges;
         return this._selectedRanges;
      }
      
      public function set selectedRanges(value:Array) : void
      {
         this._selectedRanges = this.scrubTimeValues(value);
         this.selectedRangesChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="General",defaultValue="true")]
      [Bindable("showTodayChanged")]
      public function get showToday() : Boolean
      {
         return this._showToday;
      }
      
      public function set showToday(value:Boolean) : void
      {
         this._showToday = value;
         this.showTodayChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(defaultValue="false")]
      [Bindable("yearNavigationEnabledChanged")]
      public function get yearNavigationEnabled() : Boolean
      {
         return this._yearNavigationEnabled;
      }
      
      public function set yearNavigationEnabled(value:Boolean) : void
      {
         this._yearNavigationEnabled = value;
         this.yearNavigationEnabledChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(defaultValue="")]
      [Bindable("yearSymbolChanged")]
      public function get yearSymbol() : String
      {
         return this._yearSymbol;
      }
      
      public function set yearSymbol(value:String) : void
      {
         this.yearSymbolOverride = value;
         this._yearSymbol = value != null ? value : resourceManager.getString("controls","yearSymbol");
         this.yearSymbolChanged = true;
         invalidateProperties();
      }
      
      override protected function initializeAccessibility() : void
      {
         if(DateChooser.createAccessibilityImplementation != null)
         {
            DateChooser.createAccessibilityImplementation(this);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!this.background)
         {
            this.background = new UIComponent();
            addChild(this.background);
            UIComponent(this.background).styleName = this;
         }
         if(!this.border)
         {
            this.border = new UIComponent();
            addChild(this.border);
            UIComponent(this.border).styleName = this;
         }
         if(!this.dateGrid)
         {
            this.dateGrid = new CalendarLayout();
            this.dateGrid.styleName = new StyleProxy(this,this.calendarLayoutStyleFilters);
            addChild(this.dateGrid);
            this.dateGrid.addEventListener(CalendarLayoutChangeEvent.CHANGE,this.dateGrid_changeHandler);
            this.dateGrid.addEventListener(DateChooserEvent.SCROLL,this.dateGrid_scrollHandler);
         }
         if(!this.calHeader)
         {
            this.calHeader = new UIComponent();
            addChild(this.calHeader);
            UIComponent(this.calHeader).styleName = this;
         }
         this.createMonthDisplay(-1);
         this.createYearDisplay(-1);
         if(this._yearNavigationEnabled)
         {
            this.getYearNavigationButtons();
         }
         if(!this.fwdMonthButton)
         {
            this.fwdMonthButton = new Button();
            this.fwdMonthButton.styleName = new StyleProxy(this,this.nextMonthStyleFilters);
            this.fwdMonthButton.autoRepeat = true;
            this.fwdMonthButton.focusEnabled = false;
            this.fwdMonthButton.upSkinName = "nextMonthUpSkin";
            this.fwdMonthButton.overSkinName = "nextMonthOverSkin";
            this.fwdMonthButton.downSkinName = "nextMonthDownSkin";
            this.fwdMonthButton.disabledSkinName = "nextMonthDisabledSkin";
            this.fwdMonthButton.skinName = "nextMonthSkin";
            this.fwdMonthButton.upIconName = "";
            this.fwdMonthButton.overIconName = "";
            this.fwdMonthButton.downIconName = "";
            this.fwdMonthButton.disabledIconName = "";
            this.fwdMonthButton.addEventListener(FlexEvent.BUTTON_DOWN,this.fwdMonthButton_buttonDownHandler);
            addChild(this.fwdMonthButton);
         }
         if(!this.backMonthButton)
         {
            this.backMonthButton = new Button();
            this.backMonthButton.styleName = new StyleProxy(this,this.prevMonthStyleFilters);
            this.backMonthButton.focusEnabled = false;
            this.backMonthButton.autoRepeat = true;
            this.backMonthButton.upSkinName = "prevMonthUpSkin";
            this.backMonthButton.overSkinName = "prevMonthOverSkin";
            this.backMonthButton.downSkinName = "prevMonthDownSkin";
            this.backMonthButton.disabledSkinName = "prevMonthDisabledSkin";
            this.backMonthButton.skinName = "prevMonthSkin";
            this.backMonthButton.upIconName = "";
            this.backMonthButton.overIconName = "";
            this.backMonthButton.downIconName = "";
            this.backMonthButton.disabledIconName = "";
            this.backMonthButton.addEventListener(FlexEvent.BUTTON_DOWN,this.backMonthButton_buttonDownHandler);
            addChild(this.backMonthButton);
         }
         if(!this.fwdMonthHit)
         {
            this.fwdMonthHit = new FlexSprite();
            this.fwdMonthHit.name = "fwdMonthHit";
            addChild(this.fwdMonthHit);
            this.fwdMonthHit.visible = false;
            this.fwdMonthButton.hitArea = this.fwdMonthHit;
         }
         if(!this.backMonthHit)
         {
            this.backMonthHit = new FlexSprite();
            this.backMonthHit.name = "backMonthHit";
            addChild(this.backMonthHit);
            this.backMonthHit.visible = false;
            this.backMonthButton.hitArea = this.backMonthHit;
         }
      }
      
      override protected function commitProperties() : void
      {
         var childIndex:int = 0;
         super.commitProperties();
         if(Boolean(hasFontContextChanged()) && this.yearDisplay != null)
         {
            childIndex = int(getChildIndex(DisplayObject(this.yearDisplay)));
            this.removeYearDisplay();
            this.createYearDisplay(childIndex);
            childIndex = int(getChildIndex(DisplayObject(this.monthDisplay)));
            this.removeMonthDisplay();
            this.createMonthDisplay(childIndex);
         }
         if(this.showTodayChanged)
         {
            this.showTodayChanged = false;
            this.dateGrid.showToday = this._showToday;
            dispatchEvent(new Event("showTodayChanged"));
         }
         if(this.enabledChanged)
         {
            this.enabledChanged = false;
            this.fwdMonthButton.enabled = this._enabled;
            this.backMonthButton.enabled = this._enabled;
            this.monthDisplay.enabled = this._enabled;
            this.yearDisplay.enabled = this._enabled;
            if(this._yearNavigationEnabled)
            {
               this.upYearButton.enabled = this._enabled;
               this.downYearButton.enabled = this._enabled;
            }
            this.dateGrid.enabled = this._enabled;
            dispatchEvent(new Event("enabledChanged"));
         }
         if(this.firstDayOfWeekChanged)
         {
            this.firstDayOfWeekChanged = false;
            this.dateGrid.firstDayOfWeek = int(this._firstDayOfWeek);
            dispatchEvent(new Event("firstDayOfWeekChanged"));
         }
         if(this.displayedMonthChanged)
         {
            this.displayedMonthChanged = false;
            this.dateGrid.displayedMonth = this._displayedMonth;
            invalidateDisplayList();
            dispatchEvent(new Event("viewChanged"));
         }
         if(this.displayedYearChanged)
         {
            this.displayedYearChanged = false;
            this.dateGrid.displayedYear = this._displayedYear;
            invalidateDisplayList();
            dispatchEvent(new Event("viewChanged"));
         }
         if(this.dayNamesChanged)
         {
            this.dayNamesChanged = false;
            this.dateGrid.dayNames = Boolean(this._dayNames) ? this._dayNames.slice(0) : null;
            dispatchEvent(new Event("dayNamesChanged"));
         }
         if(this.disabledDaysChanged)
         {
            this.disabledDaysChanged = false;
            this.dateGrid.disabledDays = this._disabledDays.slice(0);
            dispatchEvent(new Event("disabledDaysChanged"));
         }
         if(this.selectableRangeChanged)
         {
            this.selectableRangeChanged = false;
            this.dateGrid.selectableRange = this._selectableRange is Array ? this._selectableRange.slice(0) : this._selectableRange;
            dispatchEvent(new Event("selectableRangeChanged"));
            invalidateDisplayList();
         }
         if(this.disabledRangesChanged)
         {
            this.disabledRangesChanged = false;
            this.dateGrid.disabledRanges = this._disabledRanges.slice(0);
            dispatchEvent(new Event("disabledRangesChanged"));
         }
         if(this.selectedDateChanged)
         {
            this.selectedDateChanged = false;
            this.dateGrid.selectedDate = this._selectedDate;
            invalidateDisplayList();
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
         }
         if(this.selectedRangesChanged)
         {
            this.selectedRangesChanged = false;
            this.dateGrid.selectedRanges = this._selectedRanges;
            invalidateDisplayList();
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
         }
         if(this.allowMultipleSelectionChanged)
         {
            this.allowMultipleSelectionChanged = false;
            this.dateGrid.allowMultipleSelection = this._allowMultipleSelection;
            invalidateDisplayList();
            dispatchEvent(new Event("allowMultipleSelectionChanged"));
         }
         if(this.allowDisjointSelectionChanged)
         {
            this.allowDisjointSelectionChanged = false;
            this.dateGrid.allowDisjointSelection = this._allowDisjointSelection;
            invalidateDisplayList();
            dispatchEvent(new Event("allowDisjointSelectionChanged"));
         }
         if(this.monthNamesChanged)
         {
            this.monthNamesChanged = false;
            this.setMonthWidth();
            invalidateDisplayList();
            dispatchEvent(new Event("monthNamesChanged"));
         }
         if(this.yearNavigationEnabledChanged)
         {
            if(this._yearNavigationEnabled)
            {
               this.getYearNavigationButtons();
            }
            else if(Boolean(this.upYearButton) && Boolean(this.downYearButton))
            {
               removeChild(this.upYearButton);
               removeChild(this.downYearButton);
               removeChild(this.upYearHit);
               removeChild(this.downYearHit);
               this.upYearButton = null;
               this.downYearButton = null;
               this.upYearHit = null;
               this.downYearHit = null;
            }
            this.yearNavigationEnabledChanged = false;
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("yearNavigationEnabledChanged"));
         }
         if(this.yearSymbolChanged)
         {
            this.yearSymbolChanged = false;
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("yearSymbolChanged"));
         }
         if(this.monthSymbolChanged)
         {
            this.monthSymbolChanged = false;
            this.setMonthWidth();
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("monthSymbolChanged"));
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         this.updateDateDisplay();
         this.setMonthWidth();
         var borderThickness:Number = Number(getStyle("borderThickness"));
         this.monthSkinWidth = this.fwdMonthButton.getExplicitOrMeasuredWidth();
         this.monthSkinHeight = this.fwdMonthButton.getExplicitOrMeasuredHeight();
         if(this._yearNavigationEnabled)
         {
            this.yearSkinWidth = this.upYearButton.getExplicitOrMeasuredWidth();
            this.yearSkinHeight = this.upYearButton.getExplicitOrMeasuredHeight();
         }
         else
         {
            this.yearSkinWidth = 0;
            this.yearSkinHeight = 0;
         }
         this.headerHeight = Math.ceil(Math.max(this.monthSkinHeight,this.monthDisplay.getExplicitOrMeasuredHeight())) + this.SKIN_HEIGHT_PAD * 2;
         measuredWidth = Math.max(this.dateGrid.getExplicitOrMeasuredWidth() + borderThickness * 2,this.monthDisplay.width + this.yearDisplay.getExplicitOrMeasuredWidth() + this.HEADER_WIDTH_PAD + this.yearSkinWidth + this.YEAR_BUTTONS_PAD + (this.monthSkinWidth + this.SKIN_WIDTH_PAD * 2) * 2);
         measuredHeight = this.headerHeight + this.dateGrid.getExplicitOrMeasuredHeight() + borderThickness * 2;
         measuredMinWidth = this.dateGrid.minWidth;
         measuredMinHeight = this.dateGrid.minHeight + this.headerHeight;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var yearX:Number = NaN;
         var pointX:Number = NaN;
         var pointY:Number = NaN;
         var borderSkinClass:Class = null;
         var bgColorObj:* = undefined;
         var bgAlphaObj:* = undefined;
         var chromeColor:uint = 0;
         var defaultColorValue:Number = NaN;
         var defaultColor:Number = NaN;
         var colorTransform:ColorTransform = null;
         var upG:Graphics = null;
         var downG:Graphics = null;
         var distance:Number = NaN;
         var direction:String = null;
         var angle:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         this.updateDateDisplay();
         var borderThickness:Number = Number(getStyle("borderThickness"));
         var cornerRadius:Number = Number(getStyle("cornerRadius"));
         var borderColor:Number = Number(getStyle("borderColor"));
         var borderAlpha:Number = Number(getStyle("borderAlpha"));
         if(FlexVersion.compatibilityVersion >= FlexVersion.VERSION_4_0)
         {
            if(getStyle("borderVisible") == false)
            {
               borderThickness = 0;
            }
         }
         var w:Number = unscaledWidth - borderThickness * 2;
         var h:Number = unscaledHeight - borderThickness * 2;
         this.monthSkinWidth = this.fwdMonthButton.getExplicitOrMeasuredWidth();
         this.monthSkinHeight = this.fwdMonthButton.getExplicitOrMeasuredHeight();
         var monthHeight:Number = Number(this.monthDisplay.getExplicitOrMeasuredHeight());
         var yearWidth:Number = Number(this.yearDisplay.getExplicitOrMeasuredWidth());
         if(this._yearNavigationEnabled)
         {
            this.yearSkinWidth = this.upYearButton.getExplicitOrMeasuredWidth();
            this.yearSkinHeight = this.upYearButton.getExplicitOrMeasuredHeight();
         }
         var dateFormat:String = resourceManager.getString("SharedResources","dateFormat");
         var swapOrder:Boolean = this.yearBeforeMonth(dateFormat);
         if(swapOrder)
         {
            yearX = borderThickness + this.monthSkinWidth + this.SKIN_WIDTH_PAD + this.HEADER_WIDTH_PAD;
         }
         else
         {
            yearX = w - (this.monthSkinWidth + this.HEADER_WIDTH_PAD + this.yearSkinWidth + this.YEAR_BUTTONS_PAD) + borderThickness;
         }
         var dateHeight:Number = borderThickness + (this.headerHeight - monthHeight) / 2;
         var allPads:Number = this.HEADER_WIDTH_PAD + this.yearSkinWidth + (this.monthSkinWidth + this.SKIN_WIDTH_PAD * 2) * 2;
         this.monthDisplay.setActualSize(Math.max(w - allPads - yearWidth,0),monthHeight);
         if(swapOrder)
         {
            this.monthDisplay.move(yearX + yearWidth + this.YEAR_BUTTONS_PAD + this.yearSkinWidth,dateHeight);
         }
         else
         {
            this.monthDisplay.move(borderThickness + this.monthSkinWidth + this.SKIN_WIDTH_PAD + this.HEADER_WIDTH_PAD,dateHeight);
         }
         this.monthDisplay.visible = true;
         this.yearDisplay.setActualSize(yearWidth + this.YEAR_BUTTONS_PAD,monthHeight);
         if(swapOrder)
         {
            this.yearDisplay.move(yearX + this.YEAR_BUTTONS_PAD,dateHeight);
         }
         else
         {
            this.yearDisplay.move(yearX - yearWidth - this.YEAR_BUTTONS_PAD,dateHeight);
         }
         this.yearDisplay.visible = true;
         this.dateGrid.setActualSize(w,h - this.headerHeight);
         this.dateGrid.move(borderThickness,this.headerHeight + borderThickness);
         var backgroundContext:Graphics = this.background.graphics;
         backgroundContext.clear();
         backgroundContext.beginFill(16777215);
         backgroundContext.drawRoundRect(0,0,w,h,cornerRadius * 2,cornerRadius * 2);
         backgroundContext.endFill();
         this.background.$visible = true;
         var borderContext:Graphics = this.border.graphics;
         borderContext.clear();
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
         {
            borderContext.beginFill(borderColor);
         }
         else
         {
            borderContext.beginFill(borderColor,this.enabled ? borderAlpha : borderAlpha / 2);
         }
         borderContext.drawRoundRect(0,0,unscaledWidth,unscaledHeight,cornerRadius * 2,cornerRadius * 2);
         borderContext.drawRoundRect(borderThickness,borderThickness,unscaledWidth - borderThickness * 2,unscaledHeight - borderThickness * 2,cornerRadius * 2,cornerRadius * 2);
         borderContext.endFill();
         var isHalo:Boolean = false;
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
         {
            isHalo = true;
         }
         else
         {
            borderSkinClass = getStyle("borderSkin");
            isHalo = Boolean(borderSkinClass) && getQualifiedClassName(borderSkinClass).indexOf("skins.halo") >= 0;
         }
         var bgColor:uint = uint(StyleManager.NOT_A_COLOR);
         if(isHalo || FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
         {
            bgColor = uint(getStyle("backgroundColor"));
         }
         else
         {
            bgColorObj = getStyle("contentBackgroundColor");
            bgColor = bgColorObj === undefined ? uint(getStyle("backgroundColor")) : uint(bgColorObj);
         }
         var bgAlpha:Number = 1;
         if(isHalo || FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
         {
            bgAlpha = Number(getStyle("backgroundAlpha"));
         }
         else
         {
            bgAlphaObj = getStyle("contentBackgroundAlpha");
            bgAlpha = bgAlphaObj === undefined ? Number(getStyle("backgroundAlpha")) : Number(bgAlphaObj);
         }
         borderContext.beginFill(bgColor,bgAlpha);
         borderContext.drawRoundRect(borderThickness,borderThickness,w,h,cornerRadius > 0 ? (cornerRadius - 1) * 2 : 0,cornerRadius > 0 ? (cornerRadius - 1) * 2 : 0);
         borderContext.endFill();
         this.border.visible = true;
         var headerColors:Array = getStyle("headerColors");
         if(!headerColors)
         {
            headerColors = [16777215,14211288];
         }
         var headerContext:Graphics = this.calHeader.graphics;
         headerContext.clear();
         styleManager.getColorNames(headerColors);
         var matrix:Matrix = new Matrix();
         matrix.createGradientBox(w,this.headerHeight,Math.PI / 2,0,0);
         headerContext.beginGradientFill(GradientType.LINEAR,headerColors,[1,1],[0,255],matrix);
         GraphicsUtil.drawRoundRectComplex(headerContext,borderThickness,borderThickness,w,this.headerHeight,cornerRadius,cornerRadius,0,0);
         headerContext.endFill();
         if(!isHalo && FlexVersion.compatibilityVersion >= FlexVersion.VERSION_4_0)
         {
            chromeColor = uint(getStyle("chromeColor"));
            defaultColorValue = 204;
            defaultColor = 13421772;
            if(chromeColor != defaultColor)
            {
               colorTransform = new ColorTransform();
               colorTransform.redOffset = ((chromeColor & 255 << 16) >> 16) - defaultColorValue;
               colorTransform.greenOffset = ((chromeColor & 255 << 8) >> 8) - defaultColorValue;
               colorTransform.blueOffset = (chromeColor & 0xFF) - defaultColorValue;
               colorTransform.alphaMultiplier = alpha;
               this.calHeader.transform.colorTransform = colorTransform;
            }
            else
            {
               this.calHeader.transform.colorTransform = new ColorTransform();
            }
         }
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
         {
            borderContext.lineStyle(borderThickness,borderColor);
         }
         else
         {
            borderContext.lineStyle(borderThickness,borderColor,this.enabled ? borderAlpha : borderAlpha / 2);
         }
         borderContext.moveTo(borderThickness,this.headerHeight + borderThickness);
         borderContext.lineTo(w + borderThickness,this.headerHeight + borderThickness);
         this.calHeader.$visible = true;
         this.fwdMonthButton.setActualSize(this.monthSkinWidth,this.monthSkinHeight);
         this.backMonthButton.setActualSize(this.monthSkinWidth,this.monthSkinHeight);
         this.fwdMonthButton.move(w - (this.monthSkinWidth + this.HEADER_WIDTH_PAD) + borderThickness,Math.round(borderThickness + (this.headerHeight - this.monthSkinHeight) / 2));
         this.backMonthButton.move(this.HEADER_WIDTH_PAD + borderThickness,Math.round(borderThickness + (this.headerHeight - this.monthSkinHeight) / 2));
         if(this._yearNavigationEnabled)
         {
            this.upYearButton.setActualSize(this.yearSkinWidth,this.yearSkinHeight);
            this.downYearButton.setActualSize(this.yearSkinWidth,this.yearSkinHeight);
            this.upYearButton.x = yearX;
            this.upYearButton.y = Math.floor(this.headerHeight / 2 - this.yearSkinHeight / 2 - 2);
            this.downYearButton.x = yearX;
            this.downYearButton.y = Math.floor(this.headerHeight / 2 + this.yearSkinHeight / 2 - 2);
            pointX = this.upYearButton.x - this.SKIN_WIDTH_PAD / 2;
            pointY = this.upYearButton.y - this.SKIN_HEIGHT_PAD / 2;
            upG = this.upYearHit.graphics;
            upG.clear();
            upG.beginFill(13369344,0);
            upG.moveTo(pointX,pointY);
            upG.lineTo(pointX + this.yearSkinWidth + this.SKIN_WIDTH_PAD,pointY);
            upG.lineTo(pointX + this.yearSkinWidth + this.SKIN_WIDTH_PAD,pointY + this.yearSkinHeight + this.SKIN_HEIGHT_PAD / 2);
            upG.lineTo(pointX,pointY + this.yearSkinHeight + this.SKIN_HEIGHT_PAD / 2);
            upG.lineTo(pointX,pointY);
            upG.endFill();
            pointX = this.downYearButton.x - this.SKIN_WIDTH_PAD / 2;
            pointY = Number(this.downYearButton.y);
            downG = this.downYearHit.graphics;
            downG.clear();
            downG.beginFill(13369344,0);
            downG.moveTo(pointX,pointY);
            downG.lineTo(pointX + this.yearSkinWidth + this.SKIN_WIDTH_PAD,pointY);
            downG.lineTo(pointX + this.yearSkinWidth + this.SKIN_WIDTH_PAD,pointY + this.yearSkinHeight + this.SKIN_HEIGHT_PAD / 2);
            downG.lineTo(pointX,pointY + this.yearSkinHeight + this.SKIN_HEIGHT_PAD / 2);
            downG.lineTo(pointX,pointY);
            downG.endFill();
         }
         pointX = this.fwdMonthButton.x - this.SKIN_WIDTH_PAD / 2;
         pointY = this.fwdMonthButton.y - this.SKIN_HEIGHT_PAD;
         var fwdG:Graphics = this.fwdMonthHit.graphics;
         fwdG.clear();
         fwdG.beginFill(13369344,0);
         fwdG.moveTo(pointX,pointY);
         fwdG.lineTo(pointX + this.monthSkinWidth + this.SKIN_WIDTH_PAD / 2,pointY);
         fwdG.lineTo(pointX + this.monthSkinWidth + this.SKIN_WIDTH_PAD / 2,pointY + this.monthSkinHeight + this.SKIN_HEIGHT_PAD);
         fwdG.lineTo(pointX,pointY + this.monthSkinHeight + this.SKIN_HEIGHT_PAD);
         fwdG.lineTo(pointX,pointY);
         fwdG.endFill();
         pointX = this.backMonthButton.x - this.SKIN_WIDTH_PAD / 2;
         pointY = this.backMonthButton.y - this.SKIN_HEIGHT_PAD;
         var bkG:Graphics = this.backMonthHit.graphics;
         bkG.clear();
         bkG.beginFill(13369344,0);
         bkG.moveTo(pointX,pointY);
         bkG.lineTo(pointX + this.monthSkinWidth + this.SKIN_WIDTH_PAD / 2,pointY);
         bkG.lineTo(pointX + this.monthSkinWidth + this.SKIN_WIDTH_PAD / 2,pointY + this.monthSkinHeight + this.SKIN_HEIGHT_PAD);
         bkG.lineTo(pointX,pointY + this.monthSkinHeight + this.SKIN_HEIGHT_PAD);
         bkG.lineTo(pointX,pointY);
         bkG.endFill();
         var dsStyle:Object = getStyle("dropShadowEnabled");
         var dsvStyle:Object = getStyle("dropShadowVisible");
         graphics.clear();
         if(dsStyle == true || dsvStyle == true)
         {
            distance = Number(getStyle("shadowDistance"));
            direction = getStyle("shadowDirection");
            angle = 90;
            distance = Math.abs(distance) + 2;
            if(!this.dropShadow)
            {
               this.dropShadow = new RectangularDropShadow();
            }
            this.dropShadow.distance = distance;
            this.dropShadow.angle = angle;
            this.dropShadow.color = getStyle("dropShadowColor");
            this.dropShadow.alpha = 0.4;
            this.dropShadow.tlRadius = cornerRadius;
            this.dropShadow.trRadius = cornerRadius;
            this.dropShadow.blRadius = cornerRadius;
            this.dropShadow.brRadius = cornerRadius;
            this.dropShadow.drawShadow(graphics,borderThickness,borderThickness,w,h);
         }
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var dateHeaderStyleName:Object = null;
         super.styleChanged(styleProp);
         if(styleProp == null || styleProp == "styleName" || styleProp == "borderColor" || styleProp == "headerColor" || styleProp == "headerColors" || styleProp == "backgroundColor" || styleProp == "horizontalGap" || styleProp == "verticalGap" || styleProp == "backgroundAlpha")
         {
            invalidateDisplayList();
         }
         if(styleProp == null || styleProp == "styleName" || Boolean(styleProp == "headerStyleName") && Boolean(this.monthDisplay))
         {
            dateHeaderStyleName = getStyle("headerStyleName");
            if(!dateHeaderStyleName)
            {
               dateHeaderStyleName = this;
            }
            if(Boolean(this.monthDisplay))
            {
               this.monthDisplay.styleName = dateHeaderStyleName;
            }
            if(Boolean(this.yearDisplay))
            {
               this.yearDisplay.styleName = dateHeaderStyleName;
            }
            if(Boolean(this.backMonthButton))
            {
               this.backMonthButton.styleName = new StyleProxy(this,this.prevMonthStyleFilters);
            }
            if(Boolean(this.fwdMonthButton))
            {
               this.fwdMonthButton.styleName = new StyleProxy(this,this.nextMonthStyleFilters);
            }
            if(Boolean(this.upYearButton))
            {
               this.upYearButton.styleName = new StyleProxy(this,this.nextYearStyleFilters);
            }
            if(Boolean(this.downYearButton))
            {
               this.downYearButton.styleName = new StyleProxy(this,this.prevYearStyleFilters);
            }
         }
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         this.dayNames = this.dayNamesOverride;
         this.firstDayOfWeek = this.firstDayOfWeekOverride;
         this.monthNames = this.monthNamesOverride;
         this.monthSymbol = this.monthSymbolOverride;
         this.yearSymbol = this.yearSymbolOverride;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createMonthDisplay(childIndex:int) : void
      {
         var textFormat:TextFormat = null;
         var dateHeaderStyleName:Object = null;
         if(!this.monthDisplay)
         {
            this.monthDisplay = IUITextField(createInFontContext(UITextField));
            textFormat = determineTextFormatFromStyles();
            this.monthDisplay.defaultTextFormat = textFormat;
            this.monthDisplay.visible = false;
            this.monthDisplay.selectable = false;
            if(childIndex == -1)
            {
               addChild(DisplayObject(this.monthDisplay));
            }
            else
            {
               addChildAt(DisplayObject(this.monthDisplay),childIndex);
            }
            dateHeaderStyleName = getStyle("headerStyleName");
            if(!dateHeaderStyleName)
            {
               dateHeaderStyleName = this;
            }
            this.monthDisplay.styleName = dateHeaderStyleName;
            this.setMonthWidth();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeMonthDisplay() : void
      {
         if(Boolean(this.monthDisplay))
         {
            removeChild(DisplayObject(this.monthDisplay));
            this.monthDisplay = null;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createYearDisplay(childIndex:int) : void
      {
         var textFormat:TextFormat = null;
         var dateHeaderStyleName:Object = null;
         if(!this.yearDisplay)
         {
            this.yearDisplay = IUITextField(createInFontContext(UITextField));
            textFormat = determineTextFormatFromStyles();
            this.yearDisplay.defaultTextFormat = textFormat;
            this.yearDisplay.visible = false;
            this.yearDisplay.selectable = false;
            if(childIndex == -1)
            {
               addChild(DisplayObject(this.yearDisplay));
            }
            else
            {
               addChildAt(DisplayObject(this.yearDisplay),childIndex);
            }
            dateHeaderStyleName = getStyle("headerStyleName");
            if(!dateHeaderStyleName)
            {
               dateHeaderStyleName = this;
            }
            this.yearDisplay.styleName = dateHeaderStyleName;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeYearDisplay() : void
      {
         if(Boolean(this.yearDisplay))
         {
            removeChild(DisplayObject(this.yearDisplay));
            this.yearDisplay = null;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function updateDateDisplay() : void
      {
         var monthName:String = Boolean(this.monthNames) ? this.monthNames[this.dateGrid.displayedMonth] : "";
         this.monthDisplay.text = monthName + this.monthSymbol;
         this.yearDisplay.text = this.displayedYear.toString() + this.yearSymbol;
      }
      
      private function getYearNavigationButtons() : void
      {
         if(!this.upYearButton)
         {
            this.upYearButton = new Button();
            this.upYearButton.styleName = new StyleProxy(this,this.nextYearStyleFilters);
            this.upYearButton.autoRepeat = true;
            this.upYearButton.focusEnabled = false;
            this.upYearButton.upSkinName = "nextYearUpSkin";
            this.upYearButton.overSkinName = "nextYearOverSkin";
            this.upYearButton.downSkinName = "nextYearDownSkin";
            this.upYearButton.disabledSkinName = "nextYearDisabledSkin";
            this.upYearButton.skinName = "nextYearSkin";
            this.upYearButton.upIconName = "";
            this.upYearButton.overIconName = "";
            this.upYearButton.downIconName = "";
            this.upYearButton.disabledIconName = "";
            this.upYearButton.addEventListener(FlexEvent.BUTTON_DOWN,this.upYearButton_buttonDownHandler);
            addChild(this.upYearButton);
         }
         if(!this.downYearButton)
         {
            this.downYearButton = new Button();
            this.downYearButton.styleName = new StyleProxy(this,this.prevYearStyleFilters);
            this.downYearButton.focusEnabled = false;
            this.downYearButton.autoRepeat = true;
            this.downYearButton.upSkinName = "prevYearUpSkin";
            this.downYearButton.overSkinName = "prevYearOverSkin";
            this.downYearButton.downSkinName = "prevYearDownSkin";
            this.downYearButton.disabledSkinName = "prevYearDisabledSkin";
            this.downYearButton.skinName = "prevYearSkin";
            this.downYearButton.upIconName = "";
            this.downYearButton.overIconName = "";
            this.downYearButton.downIconName = "";
            this.downYearButton.disabledIconName = "";
            this.downYearButton.addEventListener(FlexEvent.BUTTON_DOWN,this.downYearButton_buttonDownHandler);
            addChild(this.downYearButton);
         }
         if(!this.upYearHit)
         {
            this.upYearHit = new FlexSprite();
            this.upYearHit.name = "upYearHit";
            addChild(this.upYearHit);
            this.upYearHit.visible = false;
            this.upYearButton.hitArea = this.upYearHit;
         }
         if(!this.downYearHit)
         {
            this.downYearHit = new FlexSprite();
            this.downYearHit.name = "downYearHit";
            addChild(this.downYearHit);
            this.downYearHit.visible = false;
            this.downYearButton.hitArea = this.downYearHit;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setMonthWidth() : void
      {
         var longestMonth:int = 0;
         var monthName:String = null;
         var tempWidth:Number = 0;
         var longestMonthWidth:Number = 0;
         for(var i:int = 0; i < 12; i++)
         {
            monthName = Boolean(this.monthNames) ? this.monthNames[i] : "";
            tempWidth = Number(measureText(monthName + this.monthSymbol).width);
            if(longestMonthWidth < tempWidth)
            {
               longestMonthWidth = tempWidth;
               longestMonth = i;
            }
         }
         var longestMonthName:String = Boolean(this.monthNames) ? this.monthNames[longestMonth] : "";
         var longestMonthText:String = longestMonthName + this.monthSymbol;
         var longestMonthUITextField:IUITextField = this.monthDisplay;
         longestMonthUITextField.text = longestMonthText;
         this.monthDisplay.width = longestMonthWidth * longestMonthUITextField.getExplicitOrMeasuredWidth() / measureText(longestMonthText).width;
      }
      
      private function yearBeforeMonth(dateFormat:String) : Boolean
      {
         var n:int = dateFormat != null ? dateFormat.length : 0;
         for(var i:int = 0; i < n; i++)
         {
            if(dateFormat.charAt(i) == "M")
            {
               return false;
            }
            if(dateFormat.charAt(i) == "Y")
            {
               return true;
            }
         }
         return false;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function scrubTimeValue(value:Object) : Object
      {
         var range:Object = null;
         if(value is Date)
         {
            return new Date(value.getFullYear(),value.getMonth(),value.getDate());
         }
         if(value is Object)
         {
            range = {};
            if(Boolean(value.rangeStart))
            {
               range.rangeStart = new Date(value.rangeStart.getFullYear(),value.rangeStart.getMonth(),value.rangeStart.getDate());
            }
            if(Boolean(value.rangeEnd))
            {
               range.rangeEnd = new Date(value.rangeEnd.getFullYear(),value.rangeEnd.getMonth(),value.rangeEnd.getDate());
            }
            return range;
         }
         return null;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function scrubTimeValues(values:Array) : Array
      {
         var dates:Array = [];
         for(var i:int = 0; i < values.length; i++)
         {
            dates[i] = this.scrubTimeValue(values[i]);
         }
         return dates;
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         if(event.eventPhase != EventPhase.AT_TARGET)
         {
            return;
         }
         if(event.keyCode == Keyboard.PAGE_UP)
         {
            this.backMonthButton_buttonDownHandler(event);
         }
         else if(event.keyCode == Keyboard.PAGE_DOWN)
         {
            this.fwdMonthButton_buttonDownHandler(event);
         }
         else if(event.keyCode == 189)
         {
            if(this._yearNavigationEnabled)
            {
               this.downYearButton_buttonDownHandler(event);
            }
         }
         else if(event.keyCode == 187)
         {
            if(this._yearNavigationEnabled)
            {
               this.upYearButton_buttonDownHandler(event);
            }
         }
         this.dateGrid.dispatchEvent(event);
         event.stopPropagation();
      }
      
      private function upYearButton_buttonDownHandler(event:Event) : void
      {
         var newDate:Object = null;
         var testDate:Date = null;
         if(this.maxYear < this.displayedYear + 1)
         {
            return;
         }
         if(Boolean(this.selectableRange) && (this.dateGrid.selRangeMode == 1 || this.dateGrid.selRangeMode == 3))
         {
            newDate = CalendarLayout.getNewIncrementDate(this.displayedYear,this.displayedMonth,1,0);
            testDate = new Date(newDate.year,newDate.month,this.selectableRange.rangeEnd.getDate());
            if(this.selectableRange.rangeEnd >= testDate)
            {
               this.dateGrid.stepDate(1,0,event);
               invalidateDisplayList();
            }
         }
         else if(this.dateGrid.selRangeMode != 4 || !this.selectableRange)
         {
            this.dateGrid.stepDate(1,0,event);
            invalidateDisplayList();
         }
      }
      
      private function downYearButton_buttonDownHandler(event:Event) : void
      {
         var newDate:Object = null;
         var testDate:Date = null;
         if(this.minYear > this.displayedYear - 1)
         {
            return;
         }
         if(Boolean(this.selectableRange) && (this.dateGrid.selRangeMode == 1 || this.dateGrid.selRangeMode == 2))
         {
            newDate = CalendarLayout.getNewIncrementDate(this.displayedYear,this.displayedMonth,-1,0);
            testDate = new Date(newDate.year,newDate.month,this.selectableRange.rangeStart.getDate());
            if(this.selectableRange.rangeStart <= testDate)
            {
               this.dateGrid.stepDate(-1,0,event);
               invalidateDisplayList();
            }
         }
         else if(this.dateGrid.selRangeMode != 4 || !this.selectableRange)
         {
            this.dateGrid.stepDate(-1,0,event);
            invalidateDisplayList();
         }
      }
      
      private function fwdMonthButton_buttonDownHandler(event:Event) : void
      {
         var newDate:Object = null;
         var testDate:Date = null;
         if(this.maxYear < this.displayedYear + 1 && this.displayedMonth == 11)
         {
            return;
         }
         if(Boolean(this.selectableRange) && (this.dateGrid.selRangeMode == 1 || this.dateGrid.selRangeMode == 3))
         {
            newDate = CalendarLayout.getNewIncrementDate(this.displayedYear,this.displayedMonth,0,1);
            testDate = new Date(newDate.year,newDate.month,this.selectableRange.rangeEnd.getDate());
            if(this.selectableRange.rangeEnd >= testDate)
            {
               this.dateGrid.stepDate(0,1,event);
               invalidateDisplayList();
            }
         }
         else if(this.dateGrid.selRangeMode != 4 || !this.selectableRange)
         {
            this.dateGrid.stepDate(0,1,event);
            invalidateDisplayList();
         }
      }
      
      private function backMonthButton_buttonDownHandler(event:Event) : void
      {
         var newDate:Object = null;
         var testDate:Date = null;
         if(this.minYear > this.displayedYear - 1 && this.displayedMonth == 0)
         {
            return;
         }
         if(Boolean(this.selectableRange) && (this.dateGrid.selRangeMode == 1 || this.dateGrid.selRangeMode == 2))
         {
            newDate = CalendarLayout.getNewIncrementDate(this.displayedYear,this.displayedMonth,0,-1);
            testDate = new Date(newDate.year,newDate.month,this.selectableRange.rangeStart.getDate());
            if(this.selectableRange.rangeStart <= testDate)
            {
               this.dateGrid.stepDate(0,-1,event);
               invalidateDisplayList();
            }
         }
         else if(this.dateGrid.selRangeMode != 4 || !this.selectableRange)
         {
            this.dateGrid.stepDate(0,-1,event);
            invalidateDisplayList();
         }
      }
      
      private function dateGrid_scrollHandler(event:DateChooserEvent) : void
      {
         dispatchEvent(event);
      }
      
      private function dateGrid_changeHandler(event:CalendarLayoutChangeEvent) : void
      {
         this._selectedDate = CalendarLayout(event.target).selectedDate;
         var e:CalendarLayoutChangeEvent = new CalendarLayoutChangeEvent(CalendarLayoutChangeEvent.CHANGE);
         e.newDate = event.newDate;
         e.triggerEvent = event.triggerEvent;
         dispatchEvent(e);
      }
      
      private function addedToStageHandler(event:Event) : void
      {
         if(scaleX != 1 || scaleY != 1)
         {
            invalidateSize();
         }
      }
   }
}

