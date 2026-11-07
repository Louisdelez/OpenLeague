package mx.controls
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import mx.controls.dataGridClasses.DataGridListData;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.controls.listClasses.ListData;
   import mx.core.ClassFactory;
   import mx.core.IDataRenderer;
   import mx.core.IFactory;
   import mx.core.LayoutDirection;
   import mx.core.UIComponentGlobals;
   import mx.events.CalendarLayoutChangeEvent;
   import mx.events.DateChooserEvent;
   import mx.events.DropdownEvent;
   import mx.events.FlexEvent;
   import mx.events.FlexMouseEvent;
   import mx.events.SandboxMouseEvent;
   import mx.managers.IFocusManagerComponent;
   import mx.managers.ISystemManager;
   import mx.managers.PopUpManager;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleProxy;
   import mx.utils.ObjectUtil;
   
   [ResourceBundle("SharedResources")]
   [ResourceBundle("controls")]
   [RequiresDataBinding("true")]
   [IconFile("DateField.png")]
   [DefaultTriggerEvent("change")]
   [DefaultBindingProperty(source="selectedDate",destination="selectedDate")]
   [AccessibilityClass(implementation="mx.accessibility.DateFieldAccImpl")]
   [Exclude(name="editableDisabledSkin",kind="style")]
   [Exclude(name="editableDownSkin",kind="style")]
   [Exclude(name="editableOverSkin",kind="style")]
   [Exclude(name="editableUpSkin",kind="style")]
   [Exclude(name="borderThickness",kind="style")]
   [Exclude(name="selectedItem",kind="property")]
   [Exclude(name="selectedIndex",kind="property")]
   [Style(name="todayColor",type="uint",format="Color",inherit="yes")]
   [Style(name="skin",type="Class",inherit="no",states=" up, over, down, disabled")]
   [Style(name="selectionColor",type="uint",format="Color",inherit="yes")]
   [Style(name="rollOverColor",type="uint",format="Color",inherit="yes")]
   [Style(name="dateChooserStyleName",type="String",inherit="no")]
   [Style(name="borderThickness",type="Number",format="Length",inherit="no",theme="halo")]
   [Style(name="borderColor",type="uint",format="Color",inherit="no",theme="halo")]
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
   [Event(name="scroll",type="mx.events.DateChooserEvent")]
   [Event(name="open",type="mx.events.DropdownEvent")]
   [Event(name="dataChange",type="mx.events.FlexEvent")]
   [Event(name="close",type="mx.events.DropdownEvent")]
   [Event(name="change",type="mx.events.CalendarLayoutChangeEvent")]
   public class DateField extends ComboBase implements IDataRenderer, IDropInListItemRenderer, IFocusManagerComponent, IListItemRenderer
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var creatingDropdown:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var showingDropdown:Boolean = false;
      
      private var inKeyDown:Boolean = false;
      
      private var isPressed:Boolean;
      
      private var openPos:Number = 0;
      
      private var lastSelectedDate:Date;
      
      private var updateDateFiller:Boolean = false;
      
      private var addedToPopupManager:Boolean = false;
      
      private var isMouseOver:Boolean = false;
      
      private var yearChangedWithKeys:Boolean = false;
      
      private var selectedDateSet:Boolean;
      
      private var _enabled:Boolean = true;
      
      private var enabledChanged:Boolean = false;
      
      private var _data:Object;
      
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
      
      private var _dropdown:DateChooser;
      
      private var _dropdownFactory:IFactory = new ClassFactory(DateChooser);
      
      private var _firstDayOfWeek:Object;
      
      private var firstDayOfWeekChanged:Boolean = false;
      
      [Inspectable(defaultValue="0")]
      [Bindable("firstDayOfWeekChanged")]
      private var firstDayOfWeekOverride:Object;
      
      private var _formatString:String = null;
      
      [Inspectable(defaultValue="null")]
      [Bindable("formatStringChanged")]
      private var formatStringOverride:String;
      
      private var _labelFunction:Function;
      
      private var _listData:BaseListData;
      
      private var _maxYear:int = 2100;
      
      private var maxYearChanged:Boolean = false;
      
      private var _minYear:int = 1900;
      
      private var minYearChanged:Boolean = false;
      
      private var _monthNames:Array;
      
      private var monthNamesChanged:Boolean = false;
      
      private var monthNamesOverride:Array;
      
      private var _monthSymbol:String;
      
      private var monthSymbolChanged:Boolean = false;
      
      private var monthSymbolOverride:String;
      
      private var _parseFunction:Function = DateField.stringToDate;
      
      private var _selectableRange:Object = null;
      
      private var selectableRangeChanged:Boolean = false;
      
      private var _selectedDate:Date = null;
      
      private var selectedDateChanged:Boolean = false;
      
      private var _showToday:Boolean = true;
      
      private var showTodayChanged:Boolean = false;
      
      private var _yearNavigationEnabled:Boolean = false;
      
      private var yearNavigationEnabledChanged:Boolean = false;
      
      private var _yearSymbol:String;
      
      private var yearSymbolChanged:Boolean = false;
      
      private var yearSymbolOverride:String;
      
      public function DateField()
      {
         super();
         addEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStageHandler);
      }
      
      public static function stringToDate(valueString:String, inputFormat:String) : Date
      {
         var mask:String = null;
         var temp:String = null;
         var dateString:String = "";
         var monthString:String = "";
         var yearString:String = "";
         var j:int = 0;
         var n:int = inputFormat.length;
         var i:int = 0;
         while(i < n)
         {
            temp = "" + valueString.charAt(j);
            mask = "" + inputFormat.charAt(i);
            if(mask == "M")
            {
               if(isNaN(Number(temp)) || temp == " ")
               {
                  j--;
               }
               else
               {
                  monthString += temp;
               }
            }
            else if(mask == "D")
            {
               if(isNaN(Number(temp)) || temp == " ")
               {
                  j--;
               }
               else
               {
                  dateString += temp;
               }
            }
            else if(mask == "Y")
            {
               yearString += temp;
            }
            else if(!isNaN(Number(temp)) && temp != " ")
            {
               return null;
            }
            i++;
            j++;
         }
         temp = "" + valueString.charAt(inputFormat.length - i + j);
         if(temp != "" && temp != " ")
         {
            return null;
         }
         var monthNum:Number = Number(monthString);
         var dayNum:Number = Number(dateString);
         var yearNum:Number = Number(yearString);
         if(isNaN(yearNum) || isNaN(monthNum) || isNaN(dayNum))
         {
            return null;
         }
         if(yearString.length == 2 && yearNum < 70)
         {
            yearNum += 2000;
         }
         var newDate:Date = new Date(yearNum,monthNum - 1,dayNum);
         if(dayNum != newDate.getDate() || monthNum - 1 != newDate.getMonth())
         {
            return null;
         }
         return newDate;
      }
      
      public static function dateToString(value:Date, outputFormat:String) : String
      {
         var mask:String = null;
         if(!value)
         {
            return "";
         }
         var date:String = String(value.getDate());
         if(date.length < 2)
         {
            date = "0" + date;
         }
         var month:String = String(value.getMonth() + 1);
         if(month.length < 2)
         {
            month = "0" + month;
         }
         var year:String = String(value.getFullYear());
         var output:String = "";
         var n:int = outputFormat != null ? outputFormat.length : 0;
         for(var i:int = 0; i < n; i++)
         {
            mask = outputFormat.charAt(i);
            if(mask == "M")
            {
               if(outputFormat.charAt(i + 1) == "/" && value.getMonth() < 9)
               {
                  output += month.substring(1) + "/";
               }
               else
               {
                  output += month;
               }
               i++;
            }
            else if(mask == "D")
            {
               if(outputFormat.charAt(i + 1) == "/" && value.getDate() < 10)
               {
                  output += date.substring(1) + "/";
               }
               else
               {
                  output += date;
               }
               i++;
            }
            else if(mask == "Y")
            {
               if(outputFormat.charAt(i + 2) == "Y")
               {
                  output += year;
                  i += 3;
               }
               else
               {
                  output += year.substring(2,4);
                  i++;
               }
            }
            else
            {
               output += mask;
            }
         }
         return output;
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
      
      [Inspectable(environment="none")]
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(value:Object) : void
      {
         var newDate:Date = null;
         this._data = value;
         if(Boolean(this._listData) && this._listData is DataGridListData)
         {
            newDate = this._data[DataGridListData(this._listData).dataField];
         }
         else if(this._listData is ListData && ListData(this._listData).labelField in this._data)
         {
            newDate = this._data[ListData(this._listData).labelField];
         }
         else if(this._data is String)
         {
            newDate = new Date(Date.parse(this.data as String));
         }
         else
         {
            newDate = this._data as Date;
         }
         if(!this.selectedDateSet)
         {
            this.selectedDate = newDate;
            this.selectedDateSet = false;
         }
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
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
      
      [Inspectable(arrayType="int")]
      [Bindable("disabledDaysChanged")]
      public function get disabledDays() : Array
      {
         return this._disabledDays;
      }
      
      public function set disabledDays(value:Array) : void
      {
         this._disabledDays = value;
         this.disabledDaysChanged = true;
         this.updateDateFiller = true;
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
         this.updateDateFiller = true;
         invalidateProperties();
      }
      
      [Inspectable(category="General")]
      [Bindable("displayedMonthChanged")]
      public function get displayedMonth() : int
      {
         if(Boolean(this.dropdown) && this.dropdown.displayedMonth != this._displayedMonth)
         {
            return this.dropdown.displayedMonth;
         }
         return this._displayedMonth;
      }
      
      public function set displayedMonth(value:int) : void
      {
         this._displayedMonth = value;
         this.displayedMonthChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="General")]
      [Bindable("displayedYearChanged")]
      public function get displayedYear() : int
      {
         if(Boolean(this.dropdown) && this.dropdown.displayedYear != this._displayedYear)
         {
            return this.dropdown.displayedYear;
         }
         return this._displayedYear;
      }
      
      public function set displayedYear(value:int) : void
      {
         this._displayedYear = value;
         this.displayedYearChanged = true;
         invalidateProperties();
      }
      
      public function get dropdown() : DateChooser
      {
         return this._dropdown;
      }
      
      [Bindable("dropdownFactoryChanged")]
      public function get dropdownFactory() : IFactory
      {
         return this._dropdownFactory;
      }
      
      public function set dropdownFactory(value:IFactory) : void
      {
         this._dropdownFactory = value;
         dispatchEvent(new Event("dropdownFactoryChanged"));
      }
      
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
      
      public function get formatString() : String
      {
         return this._formatString;
      }
      
      public function set formatString(value:String) : void
      {
         this.formatStringOverride = value;
         this._formatString = value != null ? value : resourceManager.getString("SharedResources","dateFormat");
         this.updateDateFiller = true;
         invalidateProperties();
         invalidateSize();
         dispatchEvent(new Event("formatStringChanged"));
      }
      
      [Inspectable(category="Data")]
      [Bindable("labelFunctionChanged")]
      public function get labelFunction() : Function
      {
         return this._labelFunction;
      }
      
      public function set labelFunction(value:Function) : void
      {
         this._labelFunction = value;
         this.updateDateFiller = true;
         invalidateProperties();
         dispatchEvent(new Event("labelFunctionChanged"));
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
      
      public function get maxYear() : int
      {
         if(Boolean(this.dropdown))
         {
            return this.dropdown.maxYear;
         }
         return this._maxYear;
      }
      
      public function set maxYear(value:int) : void
      {
         if(this._maxYear == value)
         {
            return;
         }
         this._maxYear = value;
         this.maxYearChanged = true;
         invalidateProperties();
      }
      
      public function get minYear() : int
      {
         if(Boolean(this.dropdown))
         {
            return this.dropdown.minYear;
         }
         return this._minYear;
      }
      
      public function set minYear(value:int) : void
      {
         if(this._displayedYear == value)
         {
            return;
         }
         this._minYear = value;
         this.minYearChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="Other",arrayType="String",defaultValue="null")]
      [Bindable("monthNamesChanged")]
      public function get monthNames() : Array
      {
         return this._monthNames;
      }
      
      public function set monthNames(value:Array) : void
      {
         this.monthNamesOverride = value;
         this._monthNames = value != null ? value : resourceManager.getStringArray("SharedResources","monthNames");
         this._monthNames = Boolean(this._monthNames) ? this._monthNames.slice(0) : null;
         this.monthNamesChanged = true;
         invalidateProperties();
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
      
      [Bindable("parseFunctionChanged")]
      public function get parseFunction() : Function
      {
         return this._parseFunction;
      }
      
      public function set parseFunction(value:Function) : void
      {
         this._parseFunction = value;
         dispatchEvent(new Event("parseFunctionChanged"));
      }
      
      [Inspectable(arrayType="Date")]
      [Bindable("selectableRangeChanged")]
      public function get selectableRange() : Object
      {
         return this._selectableRange;
      }
      
      public function set selectableRange(value:Object) : void
      {
         this._selectableRange = this.scrubTimeValue(value);
         this.selectableRangeChanged = true;
         this.updateDateFiller = true;
         invalidateProperties();
      }
      
      [Inspectable(category="General")]
      [Bindable("selectedDateChanged")]
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedDate() : Date
      {
         return this._selectedDate;
      }
      
      public function set selectedDate(value:Date) : void
      {
         if(ObjectUtil.dateCompare(this._selectedDate,value) == 0)
         {
            return;
         }
         this.selectedDateSet = true;
         this._selectedDate = this.scrubTimeValue(value) as Date;
         this.updateDateFiller = true;
         this.selectedDateChanged = true;
         invalidateProperties();
         dispatchEvent(new Event("selectedDateChanged"));
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
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
         if(DateField.createAccessibilityImplementation != null)
         {
            DateField.createAccessibilityImplementation(this);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.createDropdown();
         downArrowButton.setStyle("paddingLeft",0);
         downArrowButton.setStyle("paddingRight",0);
         textInput.editable = false;
         textInput.mouseChildren = true;
         textInput.mouseEnabled = true;
         textInput.addEventListener(TextEvent.TEXT_INPUT,this.textInput_textInputHandler);
         if(Boolean(border))
         {
            border.visible = false;
         }
      }
      
      override protected function commitProperties() : void
      {
         if(this.enabledChanged)
         {
            this.enabledChanged = false;
            dispatchEvent(new Event("enabledChanged"));
         }
         if(this.dayNamesChanged)
         {
            this.dayNamesChanged = false;
            this.dropdown.dayNames = Boolean(this._dayNames) ? this._dayNames.slice(0) : null;
            dispatchEvent(new Event("dayNamesChanged"));
         }
         if(this.disabledDaysChanged)
         {
            this.disabledDaysChanged = false;
            this.dropdown.disabledDays = this._disabledDays.slice(0);
            dispatchEvent(new Event("disabledDaysChanged"));
         }
         if(this.disabledRangesChanged)
         {
            this.disabledRangesChanged = false;
            this.dropdown.disabledRanges = this._disabledRanges.slice(0);
            dispatchEvent(new Event("disabledRangesChanged"));
         }
         if(this.displayedMonthChanged)
         {
            this.displayedMonthChanged = false;
            this.dropdown.displayedMonth = this._displayedMonth;
            dispatchEvent(new Event("displayedMonthChanged"));
         }
         if(this.displayedYearChanged)
         {
            this.displayedYearChanged = false;
            this.dropdown.displayedYear = this._displayedYear;
            dispatchEvent(new Event("displayedYearChanged"));
         }
         if(this.firstDayOfWeekChanged)
         {
            this.firstDayOfWeekChanged = false;
            this.dropdown.firstDayOfWeek = this._firstDayOfWeek;
            dispatchEvent(new Event("firstDayOfWeekChanged"));
         }
         if(this.minYearChanged)
         {
            this.minYearChanged = false;
            this.dropdown.minYear = this._minYear;
         }
         if(this.maxYearChanged)
         {
            this.maxYearChanged = false;
            this.dropdown.maxYear = this._maxYear;
         }
         if(this.monthNamesChanged)
         {
            this.monthNamesChanged = false;
            this.dropdown.monthNames = Boolean(this._monthNames) ? this._monthNames.slice(0) : null;
            dispatchEvent(new Event("monthNamesChanged"));
         }
         if(this.selectableRangeChanged)
         {
            this.selectableRangeChanged = false;
            this.dropdown.selectableRange = this._selectableRange is Array ? this._selectableRange.slice(0) : this._selectableRange;
            dispatchEvent(new Event("selectableRangeChanged"));
         }
         if(this.selectedDateChanged)
         {
            this.selectedDateChanged = false;
            this.dropdown.selectedDate = this._selectedDate;
         }
         if(this.showTodayChanged)
         {
            this.showTodayChanged = false;
            this.dropdown.showToday = this._showToday;
            dispatchEvent(new Event("showTodayChanged"));
         }
         if(this.updateDateFiller)
         {
            this.updateDateFiller = false;
            this.dateFiller(this._selectedDate);
         }
         if(this.yearNavigationEnabledChanged)
         {
            this.yearNavigationEnabledChanged = false;
            this.dropdown.yearNavigationEnabled = this._yearNavigationEnabled;
            dispatchEvent(new Event("yearNavigationEnabledChanged"));
         }
         if(this.yearSymbolChanged)
         {
            this.yearSymbolChanged = false;
            this.dropdown.yearSymbol = this._yearSymbol;
            dispatchEvent(new Event("yearSymbolChanged"));
         }
         if(this.monthSymbolChanged)
         {
            this.monthSymbolChanged = false;
            this.dropdown.monthSymbol = this._monthSymbol;
            dispatchEvent(new Event("monthSymbolChanged"));
         }
         super.commitProperties();
      }
      
      override protected function measure() : void
      {
         var buttonWidth:Number = Number(downArrowButton.getExplicitOrMeasuredWidth());
         var buttonHeight:Number = Number(downArrowButton.getExplicitOrMeasuredHeight());
         var bigDate:Date = new Date(2004,12,31);
         var txt:String = this._labelFunction != null ? this._labelFunction(bigDate) : dateToString(bigDate,this.formatString);
         measuredMinWidth = measuredWidth = measureText(txt).width + 8 + 2 + buttonWidth;
         measuredMinWidth = measuredWidth = measuredWidth + (getStyle("paddingLeft") + getStyle("paddingRight"));
         measuredMinHeight = measuredHeight = textInput.getExplicitOrMeasuredHeight();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var w:Number = unscaledWidth;
         var h:Number = unscaledHeight;
         var arrowWidth:Number = Number(downArrowButton.getExplicitOrMeasuredWidth());
         var arrowHeight:Number = Number(downArrowButton.getExplicitOrMeasuredHeight());
         downArrowButton.setActualSize(arrowWidth,arrowHeight);
         downArrowButton.move(w - arrowWidth,Math.round((h - arrowHeight) / 2));
         textInput.setActualSize(w - arrowWidth - 2,h);
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var dateChooserStyleName:String = null;
         var styleDecl:CSSStyleDeclaration = null;
         super.styleChanged(styleProp);
         if(Boolean(this.dropdown))
         {
            this.dropdown.styleChanged(styleProp);
         }
         if(styleProp == null || styleProp == "styleName" || styleProp == "dateChooserStyleName")
         {
            if(Boolean(this.dropdown))
            {
               dateChooserStyleName = getStyle("dateChooserStyleName");
               if(Boolean(dateChooserStyleName))
               {
                  styleDecl = styleManager.getMergedStyleDeclaration("." + dateChooserStyleName);
                  if(Boolean(styleDecl))
                  {
                     this._dropdown.styleDeclaration = styleDecl;
                     this._dropdown.regenerateStyleCache(true);
                  }
               }
            }
         }
      }
      
      override public function notifyStyleChangeInChildren(styleProp:String, recursive:Boolean) : void
      {
         super.notifyStyleChangeInChildren(styleProp,recursive);
         if(Boolean(this.dropdown))
         {
            this.dropdown.notifyStyleChangeInChildren(styleProp,recursive);
         }
      }
      
      override public function regenerateStyleCache(recursive:Boolean) : void
      {
         super.regenerateStyleCache(recursive);
         if(Boolean(this.dropdown))
         {
            this.dropdown.regenerateStyleCache(recursive);
         }
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         this.dayNames = this.dayNamesOverride;
         this.firstDayOfWeek = this.firstDayOfWeekOverride;
         this.formatString = this.formatStringOverride;
         this.monthNames = this.monthNamesOverride;
         this.monthSymbol = this.monthSymbolOverride;
         this.yearSymbol = this.yearSymbolOverride;
      }
      
      public function open() : void
      {
         this.displayDropdown(true);
      }
      
      public function close() : void
      {
         this.displayDropdown(false);
      }
      
      private function displayDropdown(show:Boolean, triggerEvent:Event = null) : void
      {
         var dd:DateChooser = null;
         var xVal:Number = NaN;
         var yVal:Number = NaN;
         var sm:ISystemManager = null;
         var screen:Rectangle = null;
         if(!this._enabled)
         {
            return;
         }
         if(show == this.showingDropdown)
         {
            return;
         }
         if(!this.addedToPopupManager)
         {
            this.addedToPopupManager = true;
            PopUpManager.addPopUp(this._dropdown,this,false);
         }
         else
         {
            PopUpManager.bringToFront(this._dropdown);
         }
         var xPos:Number = (layoutDirection == LayoutDirection.RTL ? this.dropdown.getExplicitOrMeasuredWidth() : 0) + unscaledWidth - downArrowButton.width;
         var point:Point = new Point(xPos,0);
         point = localToGlobal(point);
         if(show)
         {
            if(this._parseFunction != null)
            {
               this._selectedDate = this._parseFunction(text,this.formatString);
            }
            this.lastSelectedDate = this._selectedDate;
            this.selectedDate_changeHandler(triggerEvent);
            dd = this.dropdown;
            if(Boolean(this._dropdown.selectedDate))
            {
               this._dropdown.displayedMonth = this._dropdown.selectedDate.getMonth();
               this._dropdown.displayedYear = this._dropdown.selectedDate.getFullYear();
            }
            dd.visible = show;
            dd.scaleX = scaleX;
            dd.scaleY = scaleY;
            xVal = point.x;
            yVal = point.y;
            sm = systemManager.topLevelSystemManager;
            screen = sm.getVisibleApplicationRect(null,true);
            if(screen.right > dd.getExplicitOrMeasuredWidth() + point.x && screen.bottom < dd.getExplicitOrMeasuredHeight() + point.y)
            {
               xVal = point.x;
               yVal = point.y - dd.getExplicitOrMeasuredHeight();
               this.openPos = 1;
            }
            else if(screen.right < dd.getExplicitOrMeasuredWidth() + point.x && screen.bottom < dd.getExplicitOrMeasuredHeight() + point.y)
            {
               xVal = point.x - dd.getExplicitOrMeasuredWidth() + downArrowButton.width;
               yVal = point.y - dd.getExplicitOrMeasuredHeight();
               this.openPos = 2;
            }
            else if(screen.right < dd.getExplicitOrMeasuredWidth() + point.x && screen.bottom > dd.getExplicitOrMeasuredHeight() + point.y)
            {
               xVal = point.x - dd.getExplicitOrMeasuredWidth() + downArrowButton.width;
               yVal = point.y + unscaledHeight;
               this.openPos = 3;
            }
            else
            {
               this.openPos = 0;
            }
            xVal = Math.max(screen.left,xVal);
            point.x = xVal;
            point.y = yVal;
            point = dd.parent.globalToLocal(point);
            UIComponentGlobals.layoutManager.validateClient(dd,true);
            dd.move(point.x,point.y);
            Object(dd).setActualSize(dd.getExplicitOrMeasuredWidth(),dd.getExplicitOrMeasuredHeight());
         }
         else
         {
            this._dropdown.visible = false;
         }
         this.showingDropdown = show;
         var event:DropdownEvent = new DropdownEvent(show ? DropdownEvent.OPEN : DropdownEvent.CLOSE);
         event.triggerEvent = triggerEvent;
         dispatchEvent(event);
      }
      
      private function createDropdown() : void
      {
         var styleDecl:CSSStyleDeclaration = null;
         if(this.creatingDropdown)
         {
            return;
         }
         this.creatingDropdown = true;
         this._dropdown = this.dropdownFactory.newInstance();
         this._dropdown.focusEnabled = false;
         this._dropdown.owner = this;
         this._dropdown.moduleFactory = moduleFactory;
         var todaysDate:Date = new Date();
         this._dropdown.displayedMonth = todaysDate.getMonth();
         this._dropdown.displayedYear = todaysDate.getFullYear();
         this._dropdown.styleName = new StyleProxy(this,{});
         var dateChooserStyleName:Object = getStyle("dateChooserStyleName");
         if(Boolean(dateChooserStyleName))
         {
            styleDecl = styleManager.getMergedStyleDeclaration("." + dateChooserStyleName);
            if(Boolean(styleDecl))
            {
               this._dropdown.styleDeclaration = styleDecl;
            }
         }
         this._dropdown.visible = false;
         this._dropdown.addEventListener(CalendarLayoutChangeEvent.CHANGE,this.dropdown_changeHandler);
         this._dropdown.addEventListener(DateChooserEvent.SCROLL,this.dropdown_scrollHandler);
         this._dropdown.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE,this.dropdown_mouseDownOutsideHandler);
         this._dropdown.addEventListener(FlexMouseEvent.MOUSE_WHEEL_OUTSIDE,this.dropdown_mouseDownOutsideHandler);
         this._dropdown.addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,this.dropdown_mouseDownOutsideHandler);
         this._dropdown.addEventListener(SandboxMouseEvent.MOUSE_WHEEL_SOMEWHERE,this.dropdown_mouseDownOutsideHandler);
         this.creatingDropdown = false;
      }
      
      private function dateFiller(value:Date) : void
      {
         if(this._labelFunction != null)
         {
            textInput.text = this.labelFunction(value);
         }
         else
         {
            textInput.text = dateToString(value,this.formatString);
         }
      }
      
      private function scrubTimeValue(value:Object) : Object
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
      
      private function scrubTimeValues(values:Array) : Array
      {
         var dates:Array = [];
         for(var i:int = 0; i < values.length; i++)
         {
            dates[i] = this.scrubTimeValue(values[i]);
         }
         return dates;
      }
      
      override protected function focusOutHandler(event:FocusEvent) : void
      {
         if(this.showingDropdown && event != null && Boolean(this.contains(DisplayObject(event.target))))
         {
            this.displayDropdown(false);
         }
         super.focusOutHandler(event);
         if(this._parseFunction != null)
         {
            this._selectedDate = this._parseFunction(text,this.formatString);
         }
         this.selectedDate_changeHandler(event);
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         if(event.ctrlKey && event.keyCode == Keyboard.DOWN)
         {
            this.displayDropdown(true,event);
            event.stopPropagation();
         }
         else if(event.ctrlKey && event.keyCode == Keyboard.UP)
         {
            if(this.showingDropdown)
            {
               this.selectedDate = this.lastSelectedDate;
            }
            this.displayDropdown(false,event);
            event.stopPropagation();
         }
         else if(event.keyCode == Keyboard.ESCAPE)
         {
            if(this.showingDropdown)
            {
               this.selectedDate = this.lastSelectedDate;
            }
            this.displayDropdown(false,event);
            event.stopPropagation();
         }
         else if(event.keyCode == Keyboard.ENTER)
         {
            if(this.showingDropdown)
            {
               this._selectedDate = this._dropdown.selectedDate;
               this.displayDropdown(false,event);
               event.stopPropagation();
            }
            else if(editable)
            {
               if(this._parseFunction != null)
               {
                  this._selectedDate = this._parseFunction(text,this.formatString);
               }
            }
            this.selectedDate_changeHandler(event);
         }
         else if(event.keyCode == Keyboard.UP || event.keyCode == Keyboard.DOWN || event.keyCode == Keyboard.LEFT || event.keyCode == Keyboard.RIGHT || event.keyCode == Keyboard.PAGE_UP || event.keyCode == Keyboard.PAGE_DOWN || event.keyCode == 189 || event.keyCode == 187 || event.keyCode == Keyboard.HOME || event.keyCode == Keyboard.END)
         {
            if(this.showingDropdown)
            {
               if(this.yearNavigationEnabled && (event.keyCode == 189 || event.keyCode == 187))
               {
                  this.yearChangedWithKeys = true;
               }
               this.inKeyDown = true;
               this.dropdown.dispatchEvent(event);
               this.inKeyDown = false;
               event.stopPropagation();
            }
         }
      }
      
      override protected function downArrowButton_buttonDownHandler(event:FlexEvent) : void
      {
         callLater(this.displayDropdown,[!this.showingDropdown,event]);
         downArrowButton.phase = "up";
      }
      
      override protected function textInput_changeHandler(event:Event) : void
      {
         super.textInput_changeHandler(event);
         var inputDate:Date = this._parseFunction(text,this.formatString);
         if(Boolean(inputDate))
         {
            this._selectedDate = inputDate;
         }
      }
      
      private function removedFromStageHandler(event:Event) : void
      {
         this.addedToPopupManager = false;
         PopUpManager.removePopUp(this._dropdown);
      }
      
      private function dropdown_changeHandler(event:CalendarLayoutChangeEvent) : void
      {
         if(!this.inKeyDown)
         {
            this.displayDropdown(false);
         }
         if(ObjectUtil.dateCompare(this._selectedDate,this.dropdown.selectedDate) == 0)
         {
            return;
         }
         this._selectedDate = this.dropdown.selectedDate;
         if(Boolean(this._selectedDate))
         {
            this.dateFiller(this._selectedDate);
         }
         else
         {
            textInput.text = "";
         }
         var e:CalendarLayoutChangeEvent = new CalendarLayoutChangeEvent(CalendarLayoutChangeEvent.CHANGE);
         e.newDate = event.newDate;
         e.triggerEvent = event.triggerEvent;
         dispatchEvent(e);
      }
      
      private function dropdown_scrollHandler(event:DateChooserEvent) : void
      {
         dispatchEvent(event);
      }
      
      private function dropdown_mouseDownOutsideHandler(event:Event) : void
      {
         var mouseEvent:MouseEvent = null;
         if(event is MouseEvent)
         {
            mouseEvent = MouseEvent(event);
            if(!hitTestPoint(mouseEvent.stageX,mouseEvent.stageY,true))
            {
               this.displayDropdown(false,event);
            }
         }
         else if(event is SandboxMouseEvent)
         {
            this.displayDropdown(false,event);
         }
      }
      
      private function selectedDate_changeHandler(triggerEvent:Event) : void
      {
         if(!this.dropdown.selectedDate && !this._selectedDate)
         {
            return;
         }
         if(Boolean(this._selectedDate))
         {
            this.dateFiller(this._selectedDate);
         }
         if(Boolean(this.dropdown.selectedDate && this._selectedDate && this.dropdown.selectedDate.getFullYear() == this._selectedDate.getFullYear()) && Boolean(this.dropdown.selectedDate.getMonth() == this._selectedDate.getMonth()) && this.dropdown.selectedDate.getDate() == this._selectedDate.getDate())
         {
            return;
         }
         this.dropdown.selectedDate = this._selectedDate;
         var changeEvent:CalendarLayoutChangeEvent = new CalendarLayoutChangeEvent(CalendarLayoutChangeEvent.CHANGE);
         changeEvent.newDate = this._selectedDate;
         changeEvent.triggerEvent = triggerEvent;
         dispatchEvent(changeEvent);
      }
      
      private function textInput_textInputHandler(event:TextEvent) : void
      {
         if(this.yearChangedWithKeys)
         {
            event.preventDefault();
            this.yearChangedWithKeys = false;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function isShowingDropdown() : Boolean
      {
         return this.showingDropdown;
      }
   }
}

