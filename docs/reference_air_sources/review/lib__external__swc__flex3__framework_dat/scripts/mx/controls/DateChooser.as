package mx.controls
{
   import flash.display.DisplayObject;
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventPhase;
   import flash.events.KeyboardEvent;
   import flash.geom.Matrix;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   import mx.core.FlexSprite;
   import mx.core.FlexVersion;
   import mx.core.IFlexModuleFactory;
   import mx.core.IFontContextComponent;
   import mx.core.IUITextField;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.core.mx_internal;
   import mx.events.CalendarLayoutChangeEvent;
   import mx.events.DateChooserEvent;
   import mx.events.FlexEvent;
   import mx.graphics.RectangularDropShadow;
   import mx.managers.IFocusManagerComponent;
   import mx.styles.StyleManager;
   import mx.styles.StyleProxy;
   import mx.utils.GraphicsUtil;
   
   use namespace mx_internal;
   
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
   [Style(name="todayColor",type="uint",format="Color",inherit="yes")]
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
   [Style(name="highlightAlphas",type="Array",arrayType="Number",inherit="no")]
   [Style(name="headerStyleName",type="String",inherit="no")]
   [Style(name="headerColors",type="Array",arrayType="uint",format="Color",inherit="yes")]
   [Style(name="fillColors",type="Array",arrayType="uint",format="Color",inherit="no",deprecatedReplacement="nextMonthStyleFilters, prevMonthStyleFilters",deprecatedSince="3.0")]
   [Style(name="fillAlphas",type="Array",arrayType="Number",inherit="no",deprecatedReplacement="nextMonthStyleFilters, prevMonthStyleFilters",deprecatedSince="3.0")]
   [Style(name="cornerRadius",type="Number",format="Length",inherit="no")]
   [Style(name="borderThickness",type="Number",format="Length",inherit="no")]
   [Style(name="borderColor",type="uint",format="Color",inherit="no")]
   [Style(name="backgroundColor",type="uint",format="Color",inherit="no")]
   [Style(name="backgroundAlpha",type="Number",inherit="no")]
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
   [Style(name="leading",type="Number",format="Length",inherit="yes")]
   [Style(name="disabledIconColor",type="uint",format="Color",inherit="yes")]
   [Style(name="iconColor",type="uint",format="Color",inherit="yes")]
   [Style(name="verticalGap",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no")]
   [Style(name="focusRoundedCorners",type="String",inherit="no")]
   [Style(name="focusAlpha",type="Number",inherit="no")]
   [Event(name="scroll",type="mx.events.DateChooserEvent")]
   [Event(name="change",type="mx.events.CalendarLayoutChangeEvent")]
   public class DateChooser extends UIComponent implements IFocusManagerComponent, IFontContextComponent
   {
      
      mx_internal static var createAccessibilityImplementation:Function;
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
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
      
      private var _enabled:Boolean = true;
      
      private var dayNamesChanged:Boolean = false;
      
      mx_internal var calHeader:UIComponent;
      
      mx_internal var downYearButton:Button;
      
      mx_internal var dateGrid:CalendarLayout;
      
      private var displayedYearChanged:Boolean = false;
      
      private var headerHeight:Number = 30;
      
      private var SKIN_WIDTH_PAD:Number = 6;
      
      private var allowMultipleSelectionChanged:Boolean = false;
      
      mx_internal var monthDisplay:IUITextField;
      
      private var selectedRangesChanged:Boolean = false;
      
      private var monthSymbolOverride:String;
      
      mx_internal var fwdMonthButton:Button;
      
      mx_internal var border:UIComponent;
      
      private var selectableRangeChanged:Boolean = false;
      
      private var _allowMultipleSelection:Boolean = false;
      
      private var enabledChanged:Boolean = false;
      
      private var disabledDaysChanged:Boolean = false;
      
      private var _displayedMonth:int = new Date().getMonth();
      
      private var _monthNames:Array;
      
      private var _selectableRange:Object;
      
      private var firstDayOfWeekChanged:Boolean = false;
      
      mx_internal var backMonthButton:Button;
      
      private var _minYear:int = 1900;
      
      private var _dayNames:Array;
      
      private var _firstDayOfWeek:Object;
      
      private var _monthSymbol:String;
      
      private var yearSkinWidth:Number = 10;
      
      private var _disabledRanges:Array = [];
      
      private var monthNamesOverride:Array;
      
      private var _maxYear:int = 2100;
      
      private var _displayedYear:int = new Date().getFullYear();
      
      private var yearNavigationEnabledChanged:Boolean = false;
      
      private var _showToday:Boolean = true;
      
      private var yearSymbolChanged:Boolean = false;
      
      private var _selectedDate:Date;
      
      mx_internal var upYearButton:Button;
      
      private var allowDisjointSelectionChanged:Boolean = false;
      
      private var _yearNavigationEnabled:Boolean = false;
      
      private var _disabledDays:Array = [];
      
      mx_internal var dropShadow:RectangularDropShadow;
      
      private var monthNamesChanged:Boolean = false;
      
      private var dayNamesOverride:Array;
      
      mx_internal var upYearHit:Sprite;
      
      mx_internal var backMonthHit:Sprite;
      
      private var _allowDisjointSelection:Boolean = true;
      
      mx_internal var downYearHit:Sprite;
      
      private var yearSkinHeight:Number = 8;
      
      private var HEADER_WIDTH_PAD:Number = 5;
      
      mx_internal var background:UIComponent;
      
      private var yearSymbolOverride:String;
      
      private var firstDayOfWeekOverride:Object;
      
      private var monthSymbolChanged:Boolean = false;
      
      private var SKIN_HEIGHT_PAD:Number = 4;
      
      private var _selectedRanges:Array = [];
      
      mx_internal var headerDisplay:UIComponent;
      
      private var selectedDateChanged:Boolean = false;
      
      private var YEAR_BUTTONS_PAD:Number = 6;
      
      private var displayedMonthChanged:Boolean = false;
      
      private var monthSkinHeight:Number = 11;
      
      private var monthSkinWidth:Number = 6;
      
      mx_internal var yearDisplay:IUITextField;
      
      mx_internal var fwdMonthHit:Sprite;
      
      private var showTodayChanged:Boolean = false;
      
      private var _yearSymbol:String;
      
      private var disabledRangesChanged:Boolean = false;
      
      private var previousSelectedCellIndex:Number = NaN;
      
      public function DateChooser()
      {
         super();
         tabEnabled = true;
         tabChildren = false;
      }
      
      public function set dayNames(value:Array) : void
      {
         dayNamesOverride = value;
         _dayNames = value != null ? value : resourceManager.getStringArray("controls","dayNamesShortest");
         _dayNames = Boolean(_dayNames) ? _dayNames.slice(0) : null;
         dayNamesChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="General")]
      [Bindable("viewChanged")]
      [Bindable("scroll")]
      public function get displayedMonth() : int
      {
         if(Boolean(dateGrid) && _displayedMonth != dateGrid.displayedMonth)
         {
            return dateGrid.displayedMonth;
         }
         return _displayedMonth;
      }
      
      public function set allowMultipleSelection(value:Boolean) : void
      {
         _allowMultipleSelection = value;
         allowMultipleSelectionChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(defaultValue="")]
      [Bindable("monthSymbolChanged")]
      public function get monthSymbol() : String
      {
         return _monthSymbol;
      }
      
      [Inspectable(defaultValue="")]
      [Bindable("yearSymbolChanged")]
      public function get yearSymbol() : String
      {
         return _yearSymbol;
      }
      
      [Inspectable(category="General",defaultValue="true")]
      [Bindable("showTodayChanged")]
      public function get showToday() : Boolean
      {
         return _showToday;
      }
      
      public function set displayedMonth(value:int) : void
      {
         if(isNaN(value) || displayedMonth == value)
         {
            return;
         }
         _displayedMonth = value;
         displayedMonthChanged = true;
         invalidateProperties();
         if(Boolean(dateGrid))
         {
            dateGrid.displayedMonth = value;
         }
      }
      
      protected function get prevYearStyleFilters() : Object
      {
         return _prevYearStyleFilters;
      }
      
      [Inspectable(defaultValue="null")]
      [Bindable("firstDayOfWeekChanged")]
      public function get firstDayOfWeek() : Object
      {
         return _firstDayOfWeek;
      }
      
      public function get fontContext() : IFlexModuleFactory
      {
         return moduleFactory;
      }
      
      private function getYearNavigationButtons() : void
      {
         if(!upYearButton)
         {
            upYearButton = new Button();
            upYearButton.styleName = new StyleProxy(this,nextYearStyleFilters);
            upYearButton.autoRepeat = true;
            upYearButton.focusEnabled = false;
            upYearButton.upSkinName = "nextYearUpSkin";
            upYearButton.overSkinName = "nextYearOverSkin";
            upYearButton.downSkinName = "nextYearDownSkin";
            upYearButton.disabledSkinName = "nextYearDisabledSkin";
            upYearButton.skinName = "nextYearSkin";
            upYearButton.upIconName = "";
            upYearButton.overIconName = "";
            upYearButton.downIconName = "";
            upYearButton.disabledIconName = "";
            upYearButton.addEventListener(FlexEvent.BUTTON_DOWN,upYearButton_buttonDownHandler);
            addChild(upYearButton);
         }
         if(!downYearButton)
         {
            downYearButton = new Button();
            downYearButton.styleName = new StyleProxy(this,prevYearStyleFilters);
            downYearButton.focusEnabled = false;
            downYearButton.autoRepeat = true;
            downYearButton.upSkinName = "prevYearUpSkin";
            downYearButton.overSkinName = "prevYearOverSkin";
            downYearButton.downSkinName = "prevYearDownSkin";
            downYearButton.disabledSkinName = "prevYearDisabledSkin";
            downYearButton.skinName = "prevYearSkin";
            downYearButton.upIconName = "";
            downYearButton.overIconName = "";
            downYearButton.downIconName = "";
            downYearButton.disabledIconName = "";
            downYearButton.addEventListener(FlexEvent.BUTTON_DOWN,downYearButton_buttonDownHandler);
            addChild(downYearButton);
         }
         if(!upYearHit)
         {
            upYearHit = new FlexSprite();
            upYearHit.name = "upYearHit";
            addChild(upYearHit);
            upYearHit.visible = false;
            upYearButton.hitArea = upYearHit;
         }
         if(!downYearHit)
         {
            downYearHit = new FlexSprite();
            downYearHit.name = "downYearHit";
            addChild(downYearHit);
            downYearHit.visible = false;
            downYearButton.hitArea = downYearHit;
         }
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         if(event.eventPhase != EventPhase.AT_TARGET)
         {
            return;
         }
         if(event.keyCode == Keyboard.PAGE_UP)
         {
            backMonthButton_buttonDownHandler(event);
         }
         else if(event.keyCode == Keyboard.PAGE_DOWN)
         {
            fwdMonthButton_buttonDownHandler(event);
         }
         else if(event.keyCode == 189)
         {
            if(_yearNavigationEnabled)
            {
               downYearButton_buttonDownHandler(event);
            }
         }
         else if(event.keyCode == 187)
         {
            if(_yearNavigationEnabled)
            {
               upYearButton_buttonDownHandler(event);
            }
         }
         dateGrid.dispatchEvent(event);
         event.stopPropagation();
      }
      
      public function set yearSymbol(value:String) : void
      {
         yearSymbolOverride = value;
         _yearSymbol = value != null ? value : resourceManager.getString("controls","yearSymbol");
         yearSymbolChanged = true;
         invalidateProperties();
      }
      
      public function set monthSymbol(value:String) : void
      {
         monthSymbolOverride = value;
         _monthSymbol = value != null ? value : resourceManager.getString("SharedResources","monthSymbol");
         monthSymbolChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(arrayType="Object")]
      [Bindable("disabledRangesChanged")]
      public function get disabledRanges() : Array
      {
         return _disabledRanges;
      }
      
      override public function set enabled(value:Boolean) : void
      {
         if(value == _enabled)
         {
            return;
         }
         _enabled = value;
         super.enabled = value;
         enabledChanged = true;
         invalidateProperties();
      }
      
      [Bindable("selectableRangeChanged")]
      public function get selectableRange() : Object
      {
         return _selectableRange;
      }
      
      public function set showToday(value:Boolean) : void
      {
         _showToday = value;
         showTodayChanged = true;
         invalidateProperties();
      }
      
      private function dateGrid_changeHandler(event:CalendarLayoutChangeEvent) : void
      {
         _selectedDate = CalendarLayout(event.target).selectedDate;
         var e:CalendarLayoutChangeEvent = new CalendarLayoutChangeEvent(CalendarLayoutChangeEvent.CHANGE);
         e.newDate = event.newDate;
         e.triggerEvent = event.triggerEvent;
         dispatchEvent(e);
      }
      
      override public function get baselinePosition() : Number
      {
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            return super.baselinePosition;
         }
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         return monthDisplay.y + monthDisplay.baselinePosition;
      }
      
      mx_internal function removeYearDisplay() : void
      {
         if(Boolean(yearDisplay))
         {
            removeChild(DisplayObject(yearDisplay));
            yearDisplay = null;
         }
      }
      
      public function set selectedRanges(value:Array) : void
      {
         _selectedRanges = scrubTimeValues(value);
         selectedRangesChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(arrayType="String",defaultValue="null")]
      [Bindable("monthNamesChanged")]
      public function get monthNames() : Array
      {
         return _monthNames;
      }
      
      mx_internal function updateDateDisplay() : void
      {
         var monthName:String = Boolean(monthNames) ? monthNames[dateGrid.displayedMonth] : "";
         monthDisplay.text = monthName + monthSymbol;
         yearDisplay.text = displayedYear.toString() + yearSymbol;
      }
      
      public function set firstDayOfWeek(value:Object) : void
      {
         firstDayOfWeekOverride = value;
         _firstDayOfWeek = value != null ? int(value) : resourceManager.getInt("controls","firstDayOfWeek");
         firstDayOfWeekChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="General")]
      [Bindable("viewChanged")]
      [Bindable("scroll")]
      public function get displayedYear() : int
      {
         if(Boolean(dateGrid))
         {
            return dateGrid.displayedYear;
         }
         return _displayedYear;
      }
      
      public function set fontContext(moduleFactory:IFlexModuleFactory) : void
      {
         this.moduleFactory = moduleFactory;
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         dayNames = dayNamesOverride;
         firstDayOfWeek = firstDayOfWeekOverride;
         monthNames = monthNamesOverride;
         monthSymbol = monthSymbolOverride;
         yearSymbol = yearSymbolOverride;
      }
      
      mx_internal function removeMonthDisplay() : void
      {
         if(Boolean(monthDisplay))
         {
            removeChild(DisplayObject(monthDisplay));
            monthDisplay = null;
         }
      }
      
      private function dateGrid_scrollHandler(event:DateChooserEvent) : void
      {
         dispatchEvent(event);
      }
      
      private function backMonthButton_buttonDownHandler(event:Event) : void
      {
         var newDate:Object = null;
         var testDate:Date = null;
         if(minYear > displayedYear - 1 && displayedMonth == 0)
         {
            return;
         }
         if(Boolean(selectableRange) && (dateGrid.selRangeMode == 1 || dateGrid.selRangeMode == 2))
         {
            newDate = CalendarLayout.getNewIncrementDate(displayedYear,displayedMonth,0,-1);
            testDate = new Date(newDate.year,newDate.month,selectableRange.rangeStart.getDate());
            if(selectableRange.rangeStart <= testDate)
            {
               dateGrid.stepDate(0,-1,event);
               invalidateDisplayList();
            }
         }
         else if(dateGrid.selRangeMode != 4 || !selectableRange)
         {
            dateGrid.stepDate(0,-1,event);
            invalidateDisplayList();
         }
      }
      
      public function set disabledRanges(value:Array) : void
      {
         _disabledRanges = scrubTimeValues(value);
         disabledRangesChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="General")]
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedDate() : Date
      {
         return _selectedDate;
      }
      
      protected function get nextMonthStyleFilters() : Object
      {
         return _nextMonthStyleFilters;
      }
      
      protected function get nextYearStyleFilters() : Object
      {
         return _nextYearStyleFilters;
      }
      
      [Inspectable(arrayType="Date")]
      [Bindable("disabledDaysChanged")]
      public function get disabledDays() : Array
      {
         return _disabledDays;
      }
      
      private function downYearButton_buttonDownHandler(event:Event) : void
      {
         var newDate:Object = null;
         var testDate:Date = null;
         if(minYear > displayedYear - 1)
         {
            return;
         }
         if(Boolean(selectableRange) && (dateGrid.selRangeMode == 1 || dateGrid.selRangeMode == 2))
         {
            newDate = CalendarLayout.getNewIncrementDate(displayedYear,displayedMonth,-1,0);
            testDate = new Date(newDate.year,newDate.month,selectableRange.rangeStart.getDate());
            if(selectableRange.rangeStart <= testDate)
            {
               dateGrid.stepDate(-1,0,event);
               invalidateDisplayList();
            }
         }
         else if(dateGrid.selRangeMode != 4 || !selectableRange)
         {
            dateGrid.stepDate(-1,0,event);
            invalidateDisplayList();
         }
      }
      
      [Inspectable(arrayType="String",defaultValue="null")]
      [Bindable("dayNamesChanged")]
      public function get dayNames() : Array
      {
         return _dayNames;
      }
      
      public function set selectableRange(value:Object) : void
      {
         _selectableRange = scrubTimeValue(value);
         selectableRangeChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="General",defaultValue="false")]
      [Bindable("allowMultipleSelectionChanged")]
      public function get allowMultipleSelection() : Boolean
      {
         return _allowMultipleSelection;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!background)
         {
            background = new UIComponent();
            addChild(background);
            UIComponent(background).styleName = this;
         }
         if(!border)
         {
            border = new UIComponent();
            addChild(border);
            UIComponent(border).styleName = this;
         }
         if(!dateGrid)
         {
            dateGrid = new CalendarLayout();
            dateGrid.styleName = new StyleProxy(this,calendarLayoutStyleFilters);
            addChild(dateGrid);
            dateGrid.addEventListener(CalendarLayoutChangeEvent.CHANGE,dateGrid_changeHandler);
            dateGrid.addEventListener(DateChooserEvent.SCROLL,dateGrid_scrollHandler);
         }
         if(!calHeader)
         {
            calHeader = new UIComponent();
            addChild(calHeader);
            UIComponent(calHeader).styleName = this;
         }
         createMonthDisplay(-1);
         createYearDisplay(-1);
         if(_yearNavigationEnabled)
         {
            getYearNavigationButtons();
         }
         if(!fwdMonthButton)
         {
            fwdMonthButton = new Button();
            fwdMonthButton.styleName = new StyleProxy(this,nextMonthStyleFilters);
            fwdMonthButton.autoRepeat = true;
            fwdMonthButton.focusEnabled = false;
            fwdMonthButton.upSkinName = "nextMonthUpSkin";
            fwdMonthButton.overSkinName = "nextMonthOverSkin";
            fwdMonthButton.downSkinName = "nextMonthDownSkin";
            fwdMonthButton.disabledSkinName = "nextMonthDisabledSkin";
            fwdMonthButton.skinName = "nextMonthSkin";
            fwdMonthButton.upIconName = "";
            fwdMonthButton.overIconName = "";
            fwdMonthButton.downIconName = "";
            fwdMonthButton.disabledIconName = "";
            fwdMonthButton.addEventListener(FlexEvent.BUTTON_DOWN,fwdMonthButton_buttonDownHandler);
            addChild(fwdMonthButton);
         }
         if(!backMonthButton)
         {
            backMonthButton = new Button();
            backMonthButton.styleName = new StyleProxy(this,prevMonthStyleFilters);
            backMonthButton.focusEnabled = false;
            backMonthButton.autoRepeat = true;
            backMonthButton.upSkinName = "prevMonthUpSkin";
            backMonthButton.overSkinName = "prevMonthOverSkin";
            backMonthButton.downSkinName = "prevMonthDownSkin";
            backMonthButton.disabledSkinName = "prevMonthDisabledSkin";
            backMonthButton.skinName = "prevMonthSkin";
            backMonthButton.upIconName = "";
            backMonthButton.overIconName = "";
            backMonthButton.downIconName = "";
            backMonthButton.disabledIconName = "";
            backMonthButton.addEventListener(FlexEvent.BUTTON_DOWN,backMonthButton_buttonDownHandler);
            addChild(backMonthButton);
         }
         if(!fwdMonthHit)
         {
            fwdMonthHit = new FlexSprite();
            fwdMonthHit.name = "fwdMonthHit";
            addChild(fwdMonthHit);
            fwdMonthHit.visible = false;
            fwdMonthButton.hitArea = fwdMonthHit;
         }
         if(!backMonthHit)
         {
            backMonthHit = new FlexSprite();
            backMonthHit.name = "backMonthHit";
            addChild(backMonthHit);
            backMonthHit.visible = false;
            backMonthButton.hitArea = backMonthHit;
         }
      }
      
      mx_internal function createYearDisplay(childIndex:int) : void
      {
         var textFormat:TextFormat = null;
         var dateHeaderStyleName:Object = null;
         if(!yearDisplay)
         {
            yearDisplay = IUITextField(createInFontContext(UITextField));
            textFormat = determineTextFormatFromStyles();
            yearDisplay.defaultTextFormat = textFormat;
            yearDisplay.visible = false;
            yearDisplay.selectable = false;
            if(childIndex == -1)
            {
               addChild(DisplayObject(yearDisplay));
            }
            else
            {
               addChildAt(DisplayObject(yearDisplay),childIndex);
            }
            dateHeaderStyleName = getStyle("headerStyleName");
            if(!dateHeaderStyleName)
            {
               dateHeaderStyleName = this;
            }
            yearDisplay.styleName = dateHeaderStyleName;
         }
      }
      
      protected function get calendarLayoutStyleFilters() : Object
      {
         return null;
      }
      
      mx_internal function scrubTimeValue(value:Object) : Object
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
      
      mx_internal function setMonthWidth() : void
      {
         var longestMonth:int = 0;
         var monthName:String = null;
         var tempWidth:Number = 0;
         var longestMonthWidth:Number = 0;
         for(var i:int = 0; i < 12; i++)
         {
            monthName = Boolean(monthNames) ? monthNames[i] : "";
            tempWidth = measureText(monthName + monthSymbol).width;
            if(longestMonthWidth < tempWidth)
            {
               longestMonthWidth = tempWidth;
               longestMonth = i;
            }
         }
         var longestMonthName:String = Boolean(monthNames) ? monthNames[longestMonth] : "";
         var longestMonthText:String = longestMonthName + monthSymbol;
         var longestMonthUITextField:IUITextField = monthDisplay;
         longestMonthUITextField.text = longestMonthText;
         monthDisplay.width = longestMonthWidth * longestMonthUITextField.getExplicitOrMeasuredWidth() / measureText(longestMonthText).width;
      }
      
      mx_internal function createMonthDisplay(childIndex:int) : void
      {
         var textFormat:TextFormat = null;
         var dateHeaderStyleName:Object = null;
         if(!monthDisplay)
         {
            monthDisplay = IUITextField(createInFontContext(UITextField));
            textFormat = determineTextFormatFromStyles();
            monthDisplay.defaultTextFormat = textFormat;
            monthDisplay.visible = false;
            monthDisplay.selectable = false;
            if(childIndex == -1)
            {
               addChild(DisplayObject(monthDisplay));
            }
            else
            {
               addChildAt(DisplayObject(monthDisplay),childIndex);
            }
            dateHeaderStyleName = getStyle("headerStyleName");
            if(!dateHeaderStyleName)
            {
               dateHeaderStyleName = this;
            }
            monthDisplay.styleName = dateHeaderStyleName;
            setMonthWidth();
         }
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="true")]
      [Bindable("enabledChanged")]
      override public function get enabled() : Boolean
      {
         return _enabled;
      }
      
      [Inspectable(arrayType="Date")]
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedRanges() : Array
      {
         _selectedRanges = dateGrid.selectedRanges;
         return _selectedRanges;
      }
      
      public function set monthNames(value:Array) : void
      {
         monthNamesOverride = value;
         _monthNames = value != null ? value : resourceManager.getStringArray("SharedResources","monthNames");
         _monthNames = Boolean(_monthNames) ? monthNames.slice(0) : null;
         monthNamesChanged = true;
         invalidateProperties();
         invalidateSize();
      }
      
      public function set minYear(value:int) : void
      {
         if(_minYear == value)
         {
            return;
         }
         _minYear = value;
      }
      
      override protected function measure() : void
      {
         super.measure();
         updateDateDisplay();
         setMonthWidth();
         var borderThickness:Number = getStyle("borderThickness");
         monthSkinWidth = fwdMonthButton.getExplicitOrMeasuredWidth();
         monthSkinHeight = fwdMonthButton.getExplicitOrMeasuredHeight();
         if(_yearNavigationEnabled)
         {
            yearSkinWidth = upYearButton.getExplicitOrMeasuredWidth();
            yearSkinHeight = upYearButton.getExplicitOrMeasuredHeight();
         }
         else
         {
            yearSkinWidth = 0;
            yearSkinHeight = 0;
         }
         headerHeight = Math.max(monthSkinHeight,monthDisplay.getExplicitOrMeasuredHeight()) + SKIN_HEIGHT_PAD * 2;
         measuredWidth = Math.max(dateGrid.getExplicitOrMeasuredWidth() + borderThickness * 2,monthDisplay.width + yearDisplay.getExplicitOrMeasuredWidth() + HEADER_WIDTH_PAD + yearSkinWidth + YEAR_BUTTONS_PAD + (monthSkinWidth + SKIN_WIDTH_PAD * 2) * 2);
         measuredHeight = headerHeight + dateGrid.getExplicitOrMeasuredHeight() + borderThickness * 2;
         measuredMinWidth = dateGrid.minWidth;
         measuredMinHeight = dateGrid.minHeight + headerHeight;
      }
      
      public function set displayedYear(value:int) : void
      {
         if(isNaN(value) || displayedYear == value)
         {
            return;
         }
         _displayedYear = value;
         displayedYearChanged = true;
         invalidateProperties();
         if(Boolean(dateGrid))
         {
            dateGrid.displayedYear = value;
         }
      }
      
      private function upYearButton_buttonDownHandler(event:Event) : void
      {
         var newDate:Object = null;
         var testDate:Date = null;
         if(maxYear < displayedYear + 1)
         {
            return;
         }
         if(Boolean(selectableRange) && (dateGrid.selRangeMode == 1 || dateGrid.selRangeMode == 3))
         {
            newDate = CalendarLayout.getNewIncrementDate(displayedYear,displayedMonth,1,0);
            testDate = new Date(newDate.year,newDate.month,selectableRange.rangeEnd.getDate());
            if(selectableRange.rangeEnd >= testDate)
            {
               dateGrid.stepDate(1,0,event);
               invalidateDisplayList();
            }
         }
         else if(dateGrid.selRangeMode != 4 || !selectableRange)
         {
            dateGrid.stepDate(1,0,event);
            invalidateDisplayList();
         }
      }
      
      public function set maxYear(value:int) : void
      {
         if(_maxYear == value)
         {
            return;
         }
         _maxYear = value;
      }
      
      private function fwdMonthButton_buttonDownHandler(event:Event) : void
      {
         var newDate:Object = null;
         var testDate:Date = null;
         if(maxYear < displayedYear + 1 && displayedMonth == 11)
         {
            return;
         }
         if(Boolean(selectableRange) && (dateGrid.selRangeMode == 1 || dateGrid.selRangeMode == 3))
         {
            newDate = CalendarLayout.getNewIncrementDate(displayedYear,displayedMonth,0,1);
            testDate = new Date(newDate.year,newDate.month,selectableRange.rangeEnd.getDate());
            if(selectableRange.rangeEnd >= testDate)
            {
               dateGrid.stepDate(0,1,event);
               invalidateDisplayList();
            }
         }
         else if(dateGrid.selRangeMode != 4 || !selectableRange)
         {
            dateGrid.stepDate(0,1,event);
            invalidateDisplayList();
         }
      }
      
      override protected function initializeAccessibility() : void
      {
         if(DateChooser.createAccessibilityImplementation != null)
         {
            DateChooser.createAccessibilityImplementation(this);
         }
      }
      
      public function set yearNavigationEnabled(value:Boolean) : void
      {
         _yearNavigationEnabled = value;
         yearNavigationEnabledChanged = true;
         invalidateProperties();
      }
      
      public function get minYear() : int
      {
         return _minYear;
      }
      
      protected function get prevMonthStyleFilters() : Object
      {
         return _prevMonthStyleFilters;
      }
      
      public function get maxYear() : int
      {
         return _maxYear;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var dateHeaderStyleName:Object = null;
         super.styleChanged(styleProp);
         if(styleProp == null || styleProp == "styleName" || styleProp == "borderColor" || styleProp == "headerColor" || styleProp == "headerColors" || styleProp == "backgroundColor" || styleProp == "horizontalGap" || styleProp == "verticalGap" || styleProp == "backgroundAlpha")
         {
            invalidateDisplayList();
         }
         if(styleProp == null || styleProp == "styleName" || Boolean(styleProp == "headerStyleName") && Boolean(monthDisplay))
         {
            dateHeaderStyleName = getStyle("headerStyleName");
            if(!dateHeaderStyleName)
            {
               dateHeaderStyleName = this;
            }
            if(Boolean(monthDisplay))
            {
               monthDisplay.styleName = dateHeaderStyleName;
            }
            if(Boolean(yearDisplay))
            {
               yearDisplay.styleName = dateHeaderStyleName;
            }
            if(Boolean(backMonthButton))
            {
               backMonthButton.styleName = new StyleProxy(this,prevMonthStyleFilters);
            }
            if(Boolean(fwdMonthButton))
            {
               fwdMonthButton.styleName = new StyleProxy(this,nextMonthStyleFilters);
            }
            if(Boolean(upYearButton))
            {
               upYearButton.styleName = new StyleProxy(this,nextYearStyleFilters);
            }
            if(Boolean(downYearButton))
            {
               downYearButton.styleName = new StyleProxy(this,prevYearStyleFilters);
            }
         }
      }
      
      override protected function commitProperties() : void
      {
         var childIndex:int = 0;
         super.commitProperties();
         if(hasFontContextChanged() && yearDisplay != null)
         {
            childIndex = getChildIndex(DisplayObject(yearDisplay));
            removeYearDisplay();
            createYearDisplay(childIndex);
            childIndex = getChildIndex(DisplayObject(monthDisplay));
            removeMonthDisplay();
            createMonthDisplay(childIndex);
         }
         if(showTodayChanged)
         {
            showTodayChanged = false;
            dateGrid.showToday = _showToday;
            dispatchEvent(new Event("showTodayChanged"));
         }
         if(enabledChanged)
         {
            enabledChanged = false;
            fwdMonthButton.enabled = _enabled;
            backMonthButton.enabled = _enabled;
            monthDisplay.enabled = _enabled;
            yearDisplay.enabled = _enabled;
            if(_yearNavigationEnabled)
            {
               upYearButton.enabled = _enabled;
               downYearButton.enabled = _enabled;
            }
            dateGrid.enabled = _enabled;
            dispatchEvent(new Event("enabledChanged"));
         }
         if(firstDayOfWeekChanged)
         {
            firstDayOfWeekChanged = false;
            dateGrid.firstDayOfWeek = int(_firstDayOfWeek);
            dispatchEvent(new Event("firstDayOfWeekChanged"));
         }
         if(displayedMonthChanged)
         {
            displayedMonthChanged = false;
            dateGrid.displayedMonth = _displayedMonth;
            invalidateDisplayList();
            dispatchEvent(new Event("viewChanged"));
         }
         if(displayedYearChanged)
         {
            displayedYearChanged = false;
            dateGrid.displayedYear = _displayedYear;
            invalidateDisplayList();
            dispatchEvent(new Event("viewChanged"));
         }
         if(dayNamesChanged)
         {
            dayNamesChanged = false;
            dateGrid.dayNames = Boolean(_dayNames) ? _dayNames.slice(0) : null;
            dispatchEvent(new Event("dayNamesChanged"));
         }
         if(disabledDaysChanged)
         {
            disabledDaysChanged = false;
            dateGrid.disabledDays = _disabledDays.slice(0);
            dispatchEvent(new Event("disabledDaysChanged"));
         }
         if(selectableRangeChanged)
         {
            selectableRangeChanged = false;
            dateGrid.selectableRange = _selectableRange is Array ? _selectableRange.slice(0) : _selectableRange;
            dispatchEvent(new Event("selectableRangeChanged"));
            invalidateDisplayList();
         }
         if(disabledRangesChanged)
         {
            disabledRangesChanged = false;
            dateGrid.disabledRanges = _disabledRanges.slice(0);
            dispatchEvent(new Event("disabledRangesChanged"));
         }
         if(selectedDateChanged)
         {
            selectedDateChanged = false;
            dateGrid.selectedDate = _selectedDate;
            invalidateDisplayList();
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
         }
         if(selectedRangesChanged)
         {
            selectedRangesChanged = false;
            dateGrid.selectedRanges = _selectedRanges;
            invalidateDisplayList();
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
         }
         if(allowMultipleSelectionChanged)
         {
            allowMultipleSelectionChanged = false;
            dateGrid.allowMultipleSelection = _allowMultipleSelection;
            invalidateDisplayList();
            dispatchEvent(new Event("allowMultipleSelectionChanged"));
         }
         if(allowDisjointSelectionChanged)
         {
            allowDisjointSelectionChanged = false;
            dateGrid.allowDisjointSelection = _allowDisjointSelection;
            invalidateDisplayList();
            dispatchEvent(new Event("allowDisjointSelectionChanged"));
         }
         if(monthNamesChanged)
         {
            monthNamesChanged = false;
            setMonthWidth();
            invalidateDisplayList();
            dispatchEvent(new Event("monthNamesChanged"));
         }
         if(yearNavigationEnabledChanged)
         {
            if(_yearNavigationEnabled)
            {
               getYearNavigationButtons();
            }
            else if(Boolean(upYearButton) && Boolean(downYearButton))
            {
               removeChild(upYearButton);
               removeChild(downYearButton);
               removeChild(upYearHit);
               removeChild(downYearHit);
               upYearButton = null;
               downYearButton = null;
               upYearHit = null;
               downYearHit = null;
            }
            yearNavigationEnabledChanged = false;
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("yearNavigationEnabledChanged"));
         }
         if(yearSymbolChanged)
         {
            yearSymbolChanged = false;
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("yearSymbolChanged"));
         }
         if(monthSymbolChanged)
         {
            monthSymbolChanged = false;
            setMonthWidth();
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("monthSymbolChanged"));
         }
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
      
      public function set allowDisjointSelection(value:Boolean) : void
      {
         _allowDisjointSelection = value;
         allowDisjointSelectionChanged = true;
         invalidateProperties();
      }
      
      public function set selectedDate(value:Date) : void
      {
         _selectedDate = scrubTimeValue(value) as Date;
         selectedDateChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(defaultValue="false")]
      [Bindable("yearNavigationEnabledChanged")]
      public function get yearNavigationEnabled() : Boolean
      {
         return _yearNavigationEnabled;
      }
      
      mx_internal function scrubTimeValues(values:Array) : Array
      {
         var dates:Array = [];
         for(var i:int = 0; i < values.length; i++)
         {
            dates[i] = scrubTimeValue(values[i]);
         }
         return dates;
      }
      
      public function set disabledDays(value:Array) : void
      {
         _disabledDays = value;
         disabledDaysChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="General",defaultValue="true")]
      [Bindable("allowDisjointSelectionChanged")]
      public function get allowDisjointSelection() : Boolean
      {
         return _allowDisjointSelection;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var yearX:Number = NaN;
         var pointX:Number = NaN;
         var pointY:Number = NaN;
         var upG:Graphics = null;
         var downG:Graphics = null;
         var distance:Number = NaN;
         var direction:String = null;
         var angle:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         updateDateDisplay();
         var borderThickness:Number = getStyle("borderThickness");
         var cornerRadius:Number = getStyle("cornerRadius");
         var borderColor:Number = getStyle("borderColor");
         var w:Number = unscaledWidth - borderThickness * 2;
         var h:Number = unscaledHeight - borderThickness * 2;
         monthSkinWidth = fwdMonthButton.getExplicitOrMeasuredWidth();
         monthSkinHeight = fwdMonthButton.getExplicitOrMeasuredHeight();
         var monthHeight:Number = Number(monthDisplay.getExplicitOrMeasuredHeight());
         var yearWidth:Number = Number(yearDisplay.getExplicitOrMeasuredWidth());
         if(_yearNavigationEnabled)
         {
            yearSkinWidth = upYearButton.getExplicitOrMeasuredWidth();
            yearSkinHeight = upYearButton.getExplicitOrMeasuredHeight();
         }
         var dateFormat:String = resourceManager.getString("SharedResources","dateFormat");
         var swapOrder:Boolean = yearBeforeMonth(dateFormat);
         if(swapOrder)
         {
            yearX = borderThickness + monthSkinWidth + SKIN_WIDTH_PAD + HEADER_WIDTH_PAD;
         }
         else
         {
            yearX = w - (monthSkinWidth + HEADER_WIDTH_PAD + yearSkinWidth + YEAR_BUTTONS_PAD) + borderThickness;
         }
         var dateHeight:Number = borderThickness + (headerHeight - monthHeight) / 2;
         var allPads:Number = HEADER_WIDTH_PAD + yearSkinWidth + (monthSkinWidth + SKIN_WIDTH_PAD * 2) * 2;
         monthDisplay.setActualSize(Math.max(w - allPads - yearWidth,0),monthHeight);
         if(swapOrder)
         {
            monthDisplay.move(yearX + yearWidth + YEAR_BUTTONS_PAD + yearSkinWidth,dateHeight);
         }
         else
         {
            monthDisplay.move(borderThickness + monthSkinWidth + SKIN_WIDTH_PAD + HEADER_WIDTH_PAD,dateHeight);
         }
         monthDisplay.visible = true;
         yearDisplay.setActualSize(yearWidth + YEAR_BUTTONS_PAD,monthHeight);
         if(swapOrder)
         {
            yearDisplay.move(yearX + YEAR_BUTTONS_PAD,dateHeight);
         }
         else
         {
            yearDisplay.move(yearX - yearWidth - YEAR_BUTTONS_PAD,dateHeight);
         }
         yearDisplay.visible = true;
         dateGrid.setActualSize(w,h - headerHeight);
         dateGrid.move(borderThickness,headerHeight + borderThickness);
         var g:Graphics = background.graphics;
         g.clear();
         g.beginFill(16777215);
         g.drawRoundRect(0,0,w,h,cornerRadius * 2,cornerRadius * 2);
         g.endFill();
         background.$visible = true;
         g = border.graphics;
         g.clear();
         g.beginFill(borderColor);
         g.drawRoundRect(0,0,unscaledWidth,unscaledHeight,cornerRadius * 2,cornerRadius * 2);
         g.endFill();
         var bgColor:uint = StyleManager.NOT_A_COLOR;
         bgColor = getStyle("backgroundColor");
         if(bgColor == StyleManager.NOT_A_COLOR)
         {
            bgColor = 16777215;
         }
         var bgAlpha:Number = 1;
         bgAlpha = getStyle("backgroundAlpha");
         g.beginFill(bgColor,bgAlpha);
         g.drawRoundRect(borderThickness,borderThickness,w,h,cornerRadius > 0 ? (cornerRadius - 1) * 2 : 0,cornerRadius > 0 ? (cornerRadius - 1) * 2 : 0);
         g.endFill();
         border.visible = true;
         var headerColors:Array = getStyle("headerColors");
         StyleManager.getColorNames(headerColors);
         var calHG:Graphics = calHeader.graphics;
         calHG.clear();
         var matrix:Matrix = new Matrix();
         matrix.createGradientBox(w,headerHeight,Math.PI / 2,0,0);
         calHG.beginGradientFill(GradientType.LINEAR,headerColors,[1,1],[0,255],matrix);
         GraphicsUtil.drawRoundRectComplex(calHG,borderThickness,borderThickness,w,headerHeight,cornerRadius,cornerRadius,0,0);
         calHG.endFill();
         calHG.lineStyle(borderThickness,borderColor);
         calHG.moveTo(borderThickness,headerHeight + borderThickness);
         calHG.lineTo(w + borderThickness,headerHeight + borderThickness);
         calHeader.$visible = true;
         fwdMonthButton.setActualSize(monthSkinWidth,monthSkinHeight);
         backMonthButton.setActualSize(monthSkinWidth,monthSkinHeight);
         fwdMonthButton.move(w - (monthSkinWidth + HEADER_WIDTH_PAD) + borderThickness,Math.round(borderThickness + (headerHeight - monthSkinHeight) / 2));
         backMonthButton.move(HEADER_WIDTH_PAD + borderThickness,Math.round(borderThickness + (headerHeight - monthSkinHeight) / 2));
         if(_yearNavigationEnabled)
         {
            upYearButton.setActualSize(yearSkinWidth,yearSkinHeight);
            downYearButton.setActualSize(yearSkinWidth,yearSkinHeight);
            upYearButton.x = yearX;
            upYearButton.y = headerHeight / 2 - yearSkinHeight / 2 - 2;
            downYearButton.x = yearX;
            downYearButton.y = headerHeight / 2 + yearSkinHeight / 2 - 2;
            pointX = upYearButton.x - SKIN_WIDTH_PAD / 2;
            pointY = upYearButton.y - SKIN_HEIGHT_PAD / 2;
            upG = upYearHit.graphics;
            upG.clear();
            upG.beginFill(13369344,0);
            upG.moveTo(pointX,pointY);
            upG.lineTo(pointX + yearSkinWidth + SKIN_WIDTH_PAD,pointY);
            upG.lineTo(pointX + yearSkinWidth + SKIN_WIDTH_PAD,pointY + yearSkinHeight + SKIN_HEIGHT_PAD / 2);
            upG.lineTo(pointX,pointY + yearSkinHeight + SKIN_HEIGHT_PAD / 2);
            upG.lineTo(pointX,pointY);
            upG.endFill();
            pointX = downYearButton.x - SKIN_WIDTH_PAD / 2;
            pointY = downYearButton.y;
            downG = downYearHit.graphics;
            downG.clear();
            downG.beginFill(13369344,0);
            downG.moveTo(pointX,pointY);
            downG.lineTo(pointX + yearSkinWidth + SKIN_WIDTH_PAD,pointY);
            downG.lineTo(pointX + yearSkinWidth + SKIN_WIDTH_PAD,pointY + yearSkinHeight + SKIN_HEIGHT_PAD / 2);
            downG.lineTo(pointX,pointY + yearSkinHeight + SKIN_HEIGHT_PAD / 2);
            downG.lineTo(pointX,pointY);
            downG.endFill();
         }
         pointX = fwdMonthButton.x - SKIN_WIDTH_PAD / 2;
         pointY = fwdMonthButton.y - SKIN_HEIGHT_PAD;
         var fwdG:Graphics = fwdMonthHit.graphics;
         fwdG.clear();
         fwdG.beginFill(13369344,0);
         fwdG.moveTo(pointX,pointY);
         fwdG.lineTo(pointX + monthSkinWidth + SKIN_WIDTH_PAD / 2,pointY);
         fwdG.lineTo(pointX + monthSkinWidth + SKIN_WIDTH_PAD / 2,pointY + monthSkinHeight + SKIN_HEIGHT_PAD);
         fwdG.lineTo(pointX,pointY + monthSkinHeight + SKIN_HEIGHT_PAD);
         fwdG.lineTo(pointX,pointY);
         fwdG.endFill();
         pointX = backMonthButton.x - SKIN_WIDTH_PAD / 2;
         pointY = backMonthButton.y - SKIN_HEIGHT_PAD;
         var bkG:Graphics = backMonthHit.graphics;
         bkG.clear();
         bkG.beginFill(13369344,0);
         bkG.moveTo(pointX,pointY);
         bkG.lineTo(pointX + monthSkinWidth + SKIN_WIDTH_PAD / 2,pointY);
         bkG.lineTo(pointX + monthSkinWidth + SKIN_WIDTH_PAD / 2,pointY + monthSkinHeight + SKIN_HEIGHT_PAD);
         bkG.lineTo(pointX,pointY + monthSkinHeight + SKIN_HEIGHT_PAD);
         bkG.lineTo(pointX,pointY);
         bkG.endFill();
         var dsStyle:Object = getStyle("dropShadowEnabled");
         graphics.clear();
         if(dsStyle == true || dsStyle is String && String(dsStyle).toLowerCase() == "true")
         {
            distance = getStyle("shadowDistance");
            direction = getStyle("shadowDirection");
            angle = 90;
            distance = Math.abs(distance) + 2;
            if(!dropShadow)
            {
               dropShadow = new RectangularDropShadow();
            }
            dropShadow.distance = distance;
            dropShadow.angle = angle;
            dropShadow.color = getStyle("dropShadowColor");
            dropShadow.alpha = 0.4;
            dropShadow.tlRadius = cornerRadius;
            dropShadow.trRadius = cornerRadius;
            dropShadow.blRadius = cornerRadius;
            dropShadow.brRadius = cornerRadius;
            dropShadow.drawShadow(graphics,borderThickness,borderThickness,w,h);
         }
      }
   }
}

