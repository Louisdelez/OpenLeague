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
   import mx.core.FlexVersion;
   import mx.core.IDataRenderer;
   import mx.core.IFactory;
   import mx.core.UIComponentGlobals;
   import mx.core.mx_internal;
   import mx.events.CalendarLayoutChangeEvent;
   import mx.events.DateChooserEvent;
   import mx.events.DropdownEvent;
   import mx.events.FlexEvent;
   import mx.events.FlexMouseEvent;
   import mx.events.InterManagerRequest;
   import mx.events.SandboxMouseEvent;
   import mx.managers.IFocusManagerComponent;
   import mx.managers.ISystemManager;
   import mx.managers.PopUpManager;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import mx.styles.StyleProxy;
   import mx.utils.ObjectUtil;
   
   use namespace mx_internal;
   
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
   [Style(name="weekDayStyleName",type="String",inherit="no",deprecatedReplacement="dateChooserStyleName",deprecatedSince="3.0")]
   [Style(name="todayStyleName",type="String",inherit="no",deprecatedReplacement="dateChooserStyleName",deprecatedSince="3.0")]
   [Style(name="todayColor",type="uint",format="Color",inherit="yes")]
   [Style(name="skin",type="Class",inherit="no",states=" up, over, down, disabled")]
   [Style(name="selectionColor",type="uint",format="Color",inherit="yes")]
   [Style(name="rollOverColor",type="uint",format="Color",inherit="yes")]
   [Style(name="highlightAlphas",type="Array",arrayType="Number",inherit="no",deprecatedReplacement="dateChooserStyleName",deprecatedSince="3.0")]
   [Style(name="headerStyleName",type="String",inherit="no",deprecatedReplacement="dateChooserStyleName",deprecatedSince="3.0")]
   [Style(name="headerColors",type="Array",arrayType="uint",format="Color",inherit="yes",deprecatedReplacement="dateChooserStyleName",deprecatedSince="3.0")]
   [Style(name="fillColors",type="Array",arrayType="uint",format="Color",inherit="no",deprecatedReplacement="nextMonthStyleFilters, prevMonthStyleFilters, dateChooserStyleName",deprecatedSince="3.0")]
   [Style(name="fillAlphas",type="Array",arrayType="Number",inherit="no",deprecatedReplacement="nextMonthStyleFilters, prevMonthStyleFilters, dateChooserStyleName",deprecatedSince="3.0")]
   [Style(name="dateChooserStyleName",type="String",inherit="no")]
   [Style(name="cornerRadius",type="Number",format="Length",inherit="no",deprecatedReplacement="dateChooserStyleName",deprecatedSince="3.0")]
   [Style(name="borderThickness",type="Number",format="Length",inherit="no")]
   [Style(name="borderColor",type="uint",format="Color",inherit="no")]
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
   [Event(name="scroll",type="mx.events.DateChooserEvent")]
   [Event(name="open",type="mx.events.DropdownEvent")]
   [Event(name="dataChange",type="mx.events.FlexEvent")]
   [Event(name="close",type="mx.events.DropdownEvent")]
   [Event(name="change",type="mx.events.CalendarLayoutChangeEvent")]
   public class DateField extends ComboBase implements IDataRenderer, IDropInListItemRenderer, IFocusManagerComponent, IListItemRenderer
   {
      
      mx_internal static var createAccessibilityImplementation:Function;
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var _enabled:Boolean = true;
      
      private var minYearChanged:Boolean = false;
      
      private var dayNamesChanged:Boolean = false;
      
      private var monthNamesChanged:Boolean = false;
      
      private var isMouseOver:Boolean = false;
      
      private var displayedYearChanged:Boolean = false;
      
      private var yearSymbolOverride:String;
      
      private var monthSymbolOverride:String;
      
      private var selectableRangeChanged:Boolean = false;
      
      private var enabledChanged:Boolean = false;
      
      [Inspectable(defaultValue="0")]
      [Bindable("firstDayOfWeekChanged")]
      private var firstDayOfWeekOverride:Object;
      
      private var _displayedMonth:int = new Date().getMonth();
      
      private var _monthNames:Array;
      
      private var disabledDaysChanged:Boolean = false;
      
      private var monthSymbolChanged:Boolean = false;
      
      private var firstDayOfWeekChanged:Boolean = false;
      
      private var _selectableRange:Object = null;
      
      private var updateDateFiller:Boolean = false;
      
      private var _dayNames:Array;
      
      private var _dropdown:DateChooser;
      
      private var _firstDayOfWeek:Object;
      
      private var _minYear:int = 1900;
      
      private var _dropdownFactory:IFactory = new ClassFactory(DateChooser);
      
      private var _monthSymbol:String;
      
      private var _data:Object;
      
      private var selectedDateChanged:Boolean = false;
      
      private var monthNamesOverride:Array;
      
      private var displayedMonthChanged:Boolean = false;
      
      private var isPressed:Boolean;
      
      private var addedToPopupManager:Boolean = false;
      
      private var lastSelectedDate:Date;
      
      private var _disabledRanges:Array = [];
      
      private var _parseFunction:Function = DateField.stringToDate;
      
      private var _maxYear:int = 2100;
      
      private var maxYearChanged:Boolean = false;
      
      private var yearChangedWithKeys:Boolean = false;
      
      private var selectedDateSet:Boolean;
      
      private var inKeyDown:Boolean = false;
      
      private var _displayedYear:int = new Date().getFullYear();
      
      private var openPos:Number = 0;
      
      private var _showToday:Boolean = true;
      
      private var yearSymbolChanged:Boolean = false;
      
      private var _listData:BaseListData;
      
      private var _selectedDate:Date = null;
      
      private var yearNavigationEnabledChanged:Boolean = false;
      
      private var _formatString:String = null;
      
      private var _yearNavigationEnabled:Boolean = false;
      
      private var _disabledDays:Array = [];
      
      [Inspectable(defaultValue="null")]
      [Bindable("formatStringChanged")]
      private var formatStringOverride:String;
      
      private var disabledRangesChanged:Boolean = false;
      
      private var _yearSymbol:String;
      
      private var creatingDropdown:Boolean = false;
      
      private var _labelFunction:Function;
      
      mx_internal var showingDropdown:Boolean = false;
      
      private var dayNamesOverride:Array;
      
      private var showTodayChanged:Boolean = false;
      
      public function DateField()
      {
         super();
         addEventListener(Event.REMOVED_FROM_STAGE,removedFromStageHandler);
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
      
      [Inspectable(defaultValue="false")]
      [Bindable("yearNavigationEnabledChanged")]
      public function get yearNavigationEnabled() : Boolean
      {
         return _yearNavigationEnabled;
      }
      
      [Inspectable(arrayType="String",defaultValue="null")]
      [Bindable("dayNamesChanged")]
      public function get dayNames() : Array
      {
         return _dayNames;
      }
      
      public function get dropdown() : DateChooser
      {
         return _dropdown;
      }
      
      override protected function focusOutHandler(event:FocusEvent) : void
      {
         if(showingDropdown && event != null)
         {
            displayDropdown(false);
         }
         super.focusOutHandler(event);
         if(_parseFunction != null)
         {
            _selectedDate = _parseFunction(text,formatString);
         }
         selectedDate_changeHandler(event);
      }
      
      public function set selectableRange(value:Object) : void
      {
         _selectableRange = scrubTimeValue(value);
         selectableRangeChanged = true;
         updateDateFiller = true;
         invalidateProperties();
      }
      
      public function set dayNames(value:Array) : void
      {
         dayNamesOverride = value;
         _dayNames = value != null ? value : resourceManager.getStringArray("controls","dayNamesShortest");
         _dayNames = Boolean(_dayNames) ? _dayNames.slice(0) : null;
         dayNamesChanged = true;
         invalidateProperties();
      }
      
      override public function regenerateStyleCache(recursive:Boolean) : void
      {
         super.regenerateStyleCache(recursive);
         if(Boolean(dropdown))
         {
            dropdown.regenerateStyleCache(recursive);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         createDropdown();
         downArrowButton.setStyle("paddingLeft",0);
         downArrowButton.setStyle("paddingRight",0);
         textInput.editable = false;
         textInput.addEventListener(TextEvent.TEXT_INPUT,textInput_textInputHandler);
         border.visible = false;
      }
      
      override public function notifyStyleChangeInChildren(styleProp:String, recursive:Boolean) : void
      {
         super.notifyStyleChangeInChildren(styleProp,recursive);
         if(Boolean(dropdown))
         {
            dropdown.notifyStyleChangeInChildren(styleProp,recursive);
         }
      }
      
      [Inspectable(category="General")]
      [Bindable("displayedMonthChanged")]
      public function get displayedMonth() : int
      {
         if(Boolean(dropdown) && dropdown.displayedMonth != _displayedMonth)
         {
            return dropdown.displayedMonth;
         }
         return _displayedMonth;
      }
      
      private function dropdown_scrollHandler(event:DateChooserEvent) : void
      {
         dispatchEvent(event);
      }
      
      private function createDropdown() : void
      {
         var styleDecl:CSSStyleDeclaration = null;
         if(creatingDropdown)
         {
            return;
         }
         creatingDropdown = true;
         _dropdown = dropdownFactory.newInstance();
         _dropdown.focusEnabled = false;
         _dropdown.owner = this;
         _dropdown.moduleFactory = moduleFactory;
         var todaysDate:Date = new Date();
         _dropdown.displayedMonth = todaysDate.getMonth();
         _dropdown.displayedYear = todaysDate.getFullYear();
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            _dropdown.styleName = this;
         }
         else
         {
            _dropdown.styleName = new StyleProxy(this,{});
         }
         var dateChooserStyleName:Object = getStyle("dateChooserStyleName");
         if(Boolean(dateChooserStyleName))
         {
            styleDecl = StyleManager.getStyleDeclaration("." + dateChooserStyleName);
            if(Boolean(styleDecl))
            {
               _dropdown.styleDeclaration = styleDecl;
            }
         }
         _dropdown.visible = false;
         _dropdown.addEventListener(CalendarLayoutChangeEvent.CHANGE,dropdown_changeHandler);
         _dropdown.addEventListener(DateChooserEvent.SCROLL,dropdown_scrollHandler);
         _dropdown.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE,dropdown_mouseDownOutsideHandler);
         _dropdown.addEventListener(FlexMouseEvent.MOUSE_WHEEL_OUTSIDE,dropdown_mouseDownOutsideHandler);
         _dropdown.addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,dropdown_mouseDownOutsideHandler);
         _dropdown.addEventListener(SandboxMouseEvent.MOUSE_WHEEL_SOMEWHERE,dropdown_mouseDownOutsideHandler);
         creatingDropdown = false;
      }
      
      [Inspectable(defaultValue="")]
      [Bindable("yearSymbolChanged")]
      public function get yearSymbol() : String
      {
         return _yearSymbol;
      }
      
      private function displayDropdown(show:Boolean, triggerEvent:Event = null) : void
      {
         var dd:DateChooser = null;
         var xVal:Number = NaN;
         var yVal:Number = NaN;
         var sm:ISystemManager = null;
         var sbRoot:DisplayObject = null;
         var screen:Rectangle = null;
         var request:InterManagerRequest = null;
         if(!_enabled)
         {
            return;
         }
         if(show == showingDropdown)
         {
            return;
         }
         if(!addedToPopupManager)
         {
            addedToPopupManager = true;
            PopUpManager.addPopUp(_dropdown,this,false);
         }
         else
         {
            PopUpManager.bringToFront(_dropdown);
         }
         var point:Point = new Point(unscaledWidth - downArrowButton.width,0);
         point = localToGlobal(point);
         if(show)
         {
            if(_parseFunction != null)
            {
               _selectedDate = _parseFunction(text,formatString);
            }
            lastSelectedDate = _selectedDate;
            selectedDate_changeHandler(triggerEvent);
            dd = dropdown;
            if(Boolean(_dropdown.selectedDate))
            {
               _dropdown.displayedMonth = _dropdown.selectedDate.getMonth();
               _dropdown.displayedYear = _dropdown.selectedDate.getFullYear();
            }
            dd.visible = show;
            dd.scaleX = scaleX;
            dd.scaleY = scaleY;
            xVal = point.x;
            yVal = point.y;
            sm = systemManager.topLevelSystemManager;
            sbRoot = sm.getSandboxRoot();
            if(sm != sbRoot)
            {
               request = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST,false,false,"getVisibleApplicationRect");
               sbRoot.dispatchEvent(request);
               screen = Rectangle(request.value);
            }
            else
            {
               screen = sm.getVisibleApplicationRect();
            }
            if(screen.right > dd.getExplicitOrMeasuredWidth() + point.x && screen.bottom < dd.getExplicitOrMeasuredHeight() + point.y)
            {
               xVal = point.x;
               yVal = point.y - dd.getExplicitOrMeasuredHeight();
               openPos = 1;
            }
            else if(screen.right < dd.getExplicitOrMeasuredWidth() + point.x && screen.bottom < dd.getExplicitOrMeasuredHeight() + point.y)
            {
               xVal = point.x - dd.getExplicitOrMeasuredWidth() + downArrowButton.width;
               yVal = point.y - dd.getExplicitOrMeasuredHeight();
               openPos = 2;
            }
            else if(screen.right < dd.getExplicitOrMeasuredWidth() + point.x && screen.bottom > dd.getExplicitOrMeasuredHeight() + point.y)
            {
               xVal = point.x - dd.getExplicitOrMeasuredWidth() + downArrowButton.width;
               yVal = point.y + unscaledHeight;
               openPos = 3;
            }
            else
            {
               openPos = 0;
            }
            point.x = xVal;
            point.y = yVal;
            point = dd.parent.globalToLocal(point);
            UIComponentGlobals.layoutManager.validateClient(dd,true);
            dd.move(point.x,point.y);
            Object(dd).setActualSize(dd.getExplicitOrMeasuredWidth(),dd.getExplicitOrMeasuredHeight());
         }
         else
         {
            _dropdown.visible = false;
         }
         showingDropdown = show;
         var event:DropdownEvent = new DropdownEvent(show ? DropdownEvent.OPEN : DropdownEvent.CLOSE);
         event.triggerEvent = triggerEvent;
         dispatchEvent(event);
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
      
      [Inspectable(defaultValue="")]
      [Bindable("monthSymbolChanged")]
      public function get monthSymbol() : String
      {
         return _monthSymbol;
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="true")]
      [Bindable("enabledChanged")]
      override public function get enabled() : Boolean
      {
         return _enabled;
      }
      
      [Inspectable(category="General",defaultValue="true")]
      [Bindable("showTodayChanged")]
      public function get showToday() : Boolean
      {
         return _showToday;
      }
      
      public function open() : void
      {
         displayDropdown(true);
      }
      
      public function set displayedMonth(value:int) : void
      {
         _displayedMonth = value;
         displayedMonthChanged = true;
         invalidateProperties();
      }
      
      public function set parseFunction(value:Function) : void
      {
         _parseFunction = value;
         dispatchEvent(new Event("parseFunctionChanged"));
      }
      
      public function get firstDayOfWeek() : Object
      {
         return _firstDayOfWeek;
      }
      
      public function set minYear(value:int) : void
      {
         if(_displayedYear == value)
         {
            return;
         }
         _minYear = value;
         minYearChanged = true;
         invalidateProperties();
      }
      
      public function set monthNames(value:Array) : void
      {
         monthNamesOverride = value;
         _monthNames = value != null ? value : resourceManager.getStringArray("SharedResources","monthNames");
         _monthNames = Boolean(_monthNames) ? _monthNames.slice(0) : null;
         monthNamesChanged = true;
         invalidateProperties();
      }
      
      public function set data(value:Object) : void
      {
         var newDate:Date = null;
         _data = value;
         if(Boolean(_listData) && _listData is DataGridListData)
         {
            newDate = _data[DataGridListData(_listData).dataField];
         }
         else if(_listData is ListData && ListData(_listData).labelField in _data)
         {
            newDate = _data[ListData(_listData).labelField];
         }
         else if(_data is String)
         {
            newDate = new Date(Date.parse(data as String));
         }
         else
         {
            newDate = _data as Date;
         }
         if(!selectedDateSet)
         {
            selectedDate = newDate;
            selectedDateSet = false;
         }
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      override protected function measure() : void
      {
         var buttonWidth:Number = downArrowButton.getExplicitOrMeasuredWidth();
         var buttonHeight:Number = downArrowButton.getExplicitOrMeasuredHeight();
         var bigDate:Date = new Date(2004,12,31);
         var txt:String = _labelFunction != null ? _labelFunction(bigDate) : dateToString(bigDate,formatString);
         measuredMinWidth = measuredWidth = measureText(txt).width + 8 + 2 + buttonWidth;
         if(FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0)
         {
            measuredMinWidth = measuredWidth = measuredWidth + (getStyle("paddingLeft") + getStyle("paddingRight"));
         }
         measuredMinHeight = measuredHeight = textInput.getExplicitOrMeasuredHeight();
      }
      
      [Inspectable(environment="none")]
      [Bindable("dataChange")]
      public function get listData() : BaseListData
      {
         return _listData;
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         if(event.ctrlKey && event.keyCode == Keyboard.DOWN)
         {
            displayDropdown(true,event);
            event.stopPropagation();
         }
         else if(event.ctrlKey && event.keyCode == Keyboard.UP)
         {
            if(showingDropdown)
            {
               selectedDate = lastSelectedDate;
            }
            displayDropdown(false,event);
            event.stopPropagation();
         }
         else if(event.keyCode == Keyboard.ESCAPE)
         {
            if(showingDropdown)
            {
               selectedDate = lastSelectedDate;
            }
            displayDropdown(false,event);
            event.stopPropagation();
         }
         else if(event.keyCode == Keyboard.ENTER)
         {
            if(showingDropdown)
            {
               _selectedDate = _dropdown.selectedDate;
               displayDropdown(false,event);
               event.stopPropagation();
            }
            else if(editable)
            {
               if(_parseFunction != null)
               {
                  _selectedDate = _parseFunction(text,formatString);
               }
            }
            selectedDate_changeHandler(event);
         }
         else if(event.keyCode == Keyboard.UP || event.keyCode == Keyboard.DOWN || event.keyCode == Keyboard.LEFT || event.keyCode == Keyboard.RIGHT || event.keyCode == Keyboard.PAGE_UP || event.keyCode == Keyboard.PAGE_DOWN || event.keyCode == 189 || event.keyCode == 187 || event.keyCode == Keyboard.HOME || event.keyCode == Keyboard.END)
         {
            if(showingDropdown)
            {
               if(yearNavigationEnabled && (event.keyCode == 189 || event.keyCode == 187))
               {
                  yearChangedWithKeys = true;
               }
               inKeyDown = true;
               dropdown.dispatchEvent(event);
               inKeyDown = false;
               event.stopPropagation();
            }
         }
      }
      
      public function set yearSymbol(value:String) : void
      {
         yearSymbolOverride = value;
         _yearSymbol = value != null ? value : resourceManager.getString("controls","yearSymbol");
         yearSymbolChanged = true;
         invalidateProperties();
      }
      
      mx_internal function isShowingDropdown() : Boolean
      {
         return showingDropdown;
      }
      
      private function textInput_textInputHandler(event:TextEvent) : void
      {
         if(yearChangedWithKeys)
         {
            event.preventDefault();
            yearChangedWithKeys = false;
         }
      }
      
      public function set dropdownFactory(value:IFactory) : void
      {
         _dropdownFactory = value;
         dispatchEvent(new Event("dropdownFactoryChanged"));
      }
      
      public function set displayedYear(value:int) : void
      {
         _displayedYear = value;
         displayedYearChanged = true;
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
      
      [Inspectable(arrayType="Date")]
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
      
      private function dropdown_mouseDownOutsideHandler(event:Event) : void
      {
         var mouseEvent:MouseEvent = null;
         if(event is MouseEvent)
         {
            mouseEvent = MouseEvent(event);
            if(!hitTestPoint(mouseEvent.stageX,mouseEvent.stageY,true))
            {
               displayDropdown(false,event);
            }
         }
         else if(event is SandboxMouseEvent)
         {
            displayDropdown(false,event);
         }
      }
      
      override protected function initializeAccessibility() : void
      {
         if(DateField.mx_internal::createAccessibilityImplementation != null)
         {
            DateField.mx_internal::createAccessibilityImplementation(this);
         }
      }
      
      [Inspectable(environment="none")]
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return _data;
      }
      
      [Bindable("parseFunctionChanged")]
      public function get parseFunction() : Function
      {
         return _parseFunction;
      }
      
      public function set firstDayOfWeek(value:Object) : void
      {
         firstDayOfWeekOverride = value;
         _firstDayOfWeek = value != null ? int(value) : resourceManager.getInt("controls","firstDayOfWeek");
         firstDayOfWeekChanged = true;
         invalidateProperties();
      }
      
      override protected function downArrowButton_buttonDownHandler(event:FlexEvent) : void
      {
         callLater(displayDropdown,[!showingDropdown,event]);
         downArrowButton.phase = "up";
      }
      
      public function get minYear() : int
      {
         if(Boolean(dropdown))
         {
            return dropdown.minYear;
         }
         return _minYear;
      }
      
      [Inspectable(category="Other",arrayType="String",defaultValue="null")]
      [Bindable("monthNamesChanged")]
      public function get monthNames() : Array
      {
         return _monthNames;
      }
      
      public function set maxYear(value:int) : void
      {
         if(_maxYear == value)
         {
            return;
         }
         _maxYear = value;
         maxYearChanged = true;
         invalidateProperties();
      }
      
      private function removedFromStageHandler(event:Event) : void
      {
         addedToPopupManager = false;
         PopUpManager.removePopUp(_dropdown);
      }
      
      [Inspectable(category="General")]
      [Bindable("displayedYearChanged")]
      public function get displayedYear() : int
      {
         if(Boolean(dropdown) && dropdown.displayedYear != _displayedYear)
         {
            return dropdown.displayedYear;
         }
         return _displayedYear;
      }
      
      [Bindable("dropdownFactoryChanged")]
      public function get dropdownFactory() : IFactory
      {
         return _dropdownFactory;
      }
      
      public function get maxYear() : int
      {
         if(Boolean(dropdown))
         {
            return dropdown.maxYear;
         }
         return _maxYear;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var dateChooserStyleName:String = null;
         var styleDecl:CSSStyleDeclaration = null;
         super.styleChanged(styleProp);
         if(Boolean(dropdown))
         {
            dropdown.styleChanged(styleProp);
         }
         if(styleProp == null || styleProp == "styleName" || styleProp == "dateChooserStyleName")
         {
            if(Boolean(dropdown))
            {
               dateChooserStyleName = getStyle("dateChooserStyleName");
               if(Boolean(dateChooserStyleName))
               {
                  styleDecl = StyleManager.getStyleDeclaration("." + dateChooserStyleName);
                  if(Boolean(styleDecl))
                  {
                     _dropdown.styleDeclaration = styleDecl;
                     _dropdown.regenerateStyleCache(true);
                  }
               }
            }
         }
      }
      
      private function dropdown_changeHandler(event:CalendarLayoutChangeEvent) : void
      {
         if(!inKeyDown)
         {
            displayDropdown(false);
         }
         if(ObjectUtil.dateCompare(_selectedDate,dropdown.selectedDate) == 0)
         {
            return;
         }
         _selectedDate = dropdown.selectedDate;
         if(Boolean(_selectedDate))
         {
            dateFiller(_selectedDate);
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
      
      public function set yearNavigationEnabled(value:Boolean) : void
      {
         _yearNavigationEnabled = value;
         yearNavigationEnabledChanged = true;
         invalidateProperties();
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         dayNames = dayNamesOverride;
         firstDayOfWeek = firstDayOfWeekOverride;
         formatString = formatStringOverride;
         monthNames = monthNamesOverride;
         monthSymbol = monthSymbolOverride;
         yearSymbol = yearSymbolOverride;
      }
      
      public function set listData(value:BaseListData) : void
      {
         _listData = value;
      }
      
      public function set labelFunction(value:Function) : void
      {
         _labelFunction = value;
         updateDateFiller = true;
         invalidateProperties();
         dispatchEvent(new Event("labelFunctionChanged"));
      }
      
      public function set selectedDate(value:Date) : void
      {
         if(ObjectUtil.dateCompare(_selectedDate,value) == 0)
         {
            return;
         }
         selectedDateSet = true;
         _selectedDate = scrubTimeValue(value) as Date;
         updateDateFiller = true;
         selectedDateChanged = true;
         invalidateProperties();
         dispatchEvent(new Event("selectedDateChanged"));
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      override protected function textInput_changeHandler(event:Event) : void
      {
         super.textInput_changeHandler(event);
         var inputDate:Date = _parseFunction(text,formatString);
         if(Boolean(inputDate))
         {
            _selectedDate = inputDate;
         }
      }
      
      private function selectedDate_changeHandler(triggerEvent:Event) : void
      {
         if(!dropdown.selectedDate && !_selectedDate)
         {
            return;
         }
         if(Boolean(_selectedDate))
         {
            dateFiller(_selectedDate);
         }
         if(Boolean(dropdown.selectedDate && _selectedDate && dropdown.selectedDate.getFullYear() == _selectedDate.getFullYear()) && Boolean(dropdown.selectedDate.getMonth() == _selectedDate.getMonth()) && dropdown.selectedDate.getDate() == _selectedDate.getDate())
         {
            return;
         }
         dropdown.selectedDate = _selectedDate;
         var changeEvent:CalendarLayoutChangeEvent = new CalendarLayoutChangeEvent(CalendarLayoutChangeEvent.CHANGE);
         changeEvent.newDate = _selectedDate;
         changeEvent.triggerEvent = triggerEvent;
         dispatchEvent(changeEvent);
      }
      
      private function scrubTimeValues(values:Array) : Array
      {
         var dates:Array = [];
         for(var i:int = 0; i < values.length; i++)
         {
            dates[i] = scrubTimeValue(values[i]);
         }
         return dates;
      }
      
      public function set formatString(value:String) : void
      {
         formatStringOverride = value;
         _formatString = value != null ? value : resourceManager.getString("SharedResources","dateFormat");
         updateDateFiller = true;
         invalidateProperties();
         invalidateSize();
         dispatchEvent(new Event("formatStringChanged"));
      }
      
      public function set disabledRanges(value:Array) : void
      {
         _disabledRanges = scrubTimeValues(value);
         disabledRangesChanged = true;
         updateDateFiller = true;
         invalidateProperties();
      }
      
      public function set disabledDays(value:Array) : void
      {
         _disabledDays = value;
         disabledDaysChanged = true;
         updateDateFiller = true;
         invalidateProperties();
      }
      
      public function get formatString() : String
      {
         return _formatString;
      }
      
      [Inspectable(category="General")]
      [Bindable("selectedDateChanged")]
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedDate() : Date
      {
         return _selectedDate;
      }
      
      private function dateFiller(value:Date) : void
      {
         if(_labelFunction != null)
         {
            textInput.text = labelFunction(value);
         }
         else
         {
            textInput.text = dateToString(value,formatString);
         }
      }
      
      [Inspectable(category="Data")]
      [Bindable("labelFunctionChanged")]
      public function get labelFunction() : Function
      {
         return _labelFunction;
      }
      
      override protected function commitProperties() : void
      {
         if(enabledChanged)
         {
            enabledChanged = false;
            dispatchEvent(new Event("enabledChanged"));
         }
         if(dayNamesChanged)
         {
            dayNamesChanged = false;
            dropdown.dayNames = Boolean(_dayNames) ? _dayNames.slice(0) : null;
            dispatchEvent(new Event("dayNamesChanged"));
         }
         if(disabledDaysChanged)
         {
            disabledDaysChanged = false;
            dropdown.disabledDays = _disabledDays.slice(0);
            dispatchEvent(new Event("disabledDaysChanged"));
         }
         if(disabledRangesChanged)
         {
            disabledRangesChanged = false;
            dropdown.disabledRanges = _disabledRanges.slice(0);
            dispatchEvent(new Event("disabledRangesChanged"));
         }
         if(displayedMonthChanged)
         {
            displayedMonthChanged = false;
            dropdown.displayedMonth = _displayedMonth;
            dispatchEvent(new Event("displayedMonthChanged"));
         }
         if(displayedYearChanged)
         {
            displayedYearChanged = false;
            dropdown.displayedYear = _displayedYear;
            dispatchEvent(new Event("displayedYearChanged"));
         }
         if(firstDayOfWeekChanged)
         {
            firstDayOfWeekChanged = false;
            dropdown.firstDayOfWeek = _firstDayOfWeek;
            dispatchEvent(new Event("firstDayOfWeekChanged"));
         }
         if(minYearChanged)
         {
            minYearChanged = false;
            dropdown.minYear = _minYear;
         }
         if(maxYearChanged)
         {
            maxYearChanged = false;
            dropdown.maxYear = _maxYear;
         }
         if(monthNamesChanged)
         {
            monthNamesChanged = false;
            dropdown.monthNames = Boolean(_monthNames) ? _monthNames.slice(0) : null;
            dispatchEvent(new Event("monthNamesChanged"));
         }
         if(selectableRangeChanged)
         {
            selectableRangeChanged = false;
            dropdown.selectableRange = _selectableRange is Array ? _selectableRange.slice(0) : _selectableRange;
            dispatchEvent(new Event("selectableRangeChanged"));
         }
         if(selectedDateChanged)
         {
            selectedDateChanged = false;
            dropdown.selectedDate = _selectedDate;
         }
         if(showTodayChanged)
         {
            showTodayChanged = false;
            dropdown.showToday = _showToday;
            dispatchEvent(new Event("showTodayChanged"));
         }
         if(updateDateFiller)
         {
            updateDateFiller = false;
            dateFiller(_selectedDate);
         }
         if(yearNavigationEnabledChanged)
         {
            yearNavigationEnabledChanged = false;
            dropdown.yearNavigationEnabled = _yearNavigationEnabled;
            dispatchEvent(new Event("yearNavigationEnabledChanged"));
         }
         if(yearSymbolChanged)
         {
            yearSymbolChanged = false;
            dropdown.yearSymbol = _yearSymbol;
            dispatchEvent(new Event("yearSymbolChanged"));
         }
         if(monthSymbolChanged)
         {
            monthSymbolChanged = false;
            dropdown.monthSymbol = _monthSymbol;
            dispatchEvent(new Event("monthSymbolChanged"));
         }
         super.commitProperties();
      }
      
      [Inspectable(arrayType="int")]
      [Bindable("disabledDaysChanged")]
      public function get disabledDays() : Array
      {
         return _disabledDays;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var w:Number = unscaledWidth;
         var h:Number = unscaledHeight;
         var arrowWidth:Number = downArrowButton.getExplicitOrMeasuredWidth();
         var arrowHeight:Number = downArrowButton.getExplicitOrMeasuredHeight();
         downArrowButton.setActualSize(arrowWidth,arrowHeight);
         downArrowButton.move(w - arrowWidth,Math.round((h - arrowHeight) / 2));
         textInput.setActualSize(w - arrowWidth - 2,h);
      }
      
      public function close() : void
      {
         displayDropdown(false);
      }
   }
}

