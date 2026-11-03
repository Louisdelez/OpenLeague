package mx.controls
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextLineMetrics;
   import flash.ui.Keyboard;
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.IFontContextComponent;
   import mx.core.IUITextField;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.events.CalendarLayoutChangeEvent;
   import mx.events.DateChooserEvent;
   import mx.events.DateChooserEventDetail;
   import mx.managers.IFocusManagerComponent;
   import mx.skins.halo.DateChooserIndicator;
   import mx.styles.ISimpleStyleClient;
   
   [ResourceBundle("controls")]
   [ExcludeClass]
   [Style(name="weekDayStyleName",type="String",inherit="no")]
   [Style(name="todayStyleName",type="String",inherit="no")]
   [Style(name="todayIndicatorSkin",type="Class",inherit="no")]
   [Style(name="todayColor",type="uint",format="Color",inherit="yes")]
   [Style(name="selectionIndicatorSkin",type="Class",inherit="no")]
   [Style(name="rollOverIndicatorSkin",type="Class",inherit="no")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
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
   [Style(name="verticalGap",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no")]
   public class CalendarLayout extends UIComponent implements IFocusManagerComponent, IFontContextComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var dcis:Object = {};
      
      private var todayRow:int = -1;
      
      private var todayColumn:int = -1;
      
      private var enabledDaysInMonth:Array = [];
      
      private var disabledRangeMode:Array;
      
      private var cellHeight:Number = 14;
      
      private var cellWidth:Number = 14;
      
      private var yOffset:Number = -1;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var dayBlocksArray:Array = [];
      
      private var disabledArrays:Array = [];
      
      private var todaysLabelReference:IUITextField = null;
      
      private var selectedMonthYearChanged:Boolean = false;
      
      private var todayIndicator:IFlexDisplayObject;
      
      private var selectionIndicator:Array = [];
      
      private var rollOverIndicator:IFlexDisplayObject;
      
      private var selectedRangeCount:int = 0;
      
      private var lastSelectedDate:Date;
      
      private var rangeStartDate:Date = null;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var selRangeMode:int = 1;
      
      private var _enabled:Boolean = true;
      
      private var enabledChanged:Boolean = false;
      
      private var _allowDisjointSelection:Boolean = true;
      
      private var _allowMultipleSelection:Boolean = false;
      
      private var _dayNames:Array;
      
      private var dayNamesChanged:Boolean = false;
      
      private var dayNamesOverride:Array;
      
      private var _disabledDays:Array = [];
      
      private var _disabledRanges:Array = [];
      
      private var _displayedMonth:int = new Date().getMonth();
      
      private var _proposedDisplayedMonth:int = -1;
      
      private var _displayedYear:int = new Date().getFullYear();
      
      private var _proposedDisplayedYear:int = -1;
      
      private var _firstDayOfWeek:int = 0;
      
      private var _selectableRange:Object = null;
      
      private var _selectedRanges:Array = [];
      
      private var _showToday:Boolean = true;
      
      public function CalendarLayout()
      {
         super();
         addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
         addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function getNewIncrementDate(oldYear:int, oldMonth:int, deltaY:int, deltaM:int) : Object
      {
         var newYear:int = oldYear + deltaY;
         var newMonth:int = oldMonth + deltaM;
         while(newMonth < 0)
         {
            newYear--;
            newMonth += 12;
         }
         while(newMonth > 11)
         {
            newYear++;
            newMonth -= 12;
         }
         return {
            "month":newMonth,
            "year":newYear
         };
      }
      
      private static function isDateChooserIndicator(parent:Object) : Boolean
      {
         var xmllist:XMLList;
         var s:String = null;
         var x:XML = null;
         s = getQualifiedClassName(parent);
         if(dcis[s] == 1)
         {
            return true;
         }
         if(dcis[s] == 0)
         {
            return false;
         }
         if(s == "mx.skins.halo::DateChooserIndicator")
         {
            dcis[s] == 1;
            return true;
         }
         x = describeType(parent);
         xmllist = x.extendsClass.(@type == "mx.skins.halo::DateChooserIndicator");
         if(xmllist.length() == 0)
         {
            dcis[s] = 0;
            return false;
         }
         dcis[s] = 1;
         return true;
      }
      
      [Inspectable(category="General",defaultValue="true")]
      override public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      override public function set enabled(value:Boolean) : void
      {
         super.enabled = value;
         this._enabled = value;
         this.enabledChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get allowDisjointSelection() : Boolean
      {
         return this._allowDisjointSelection;
      }
      
      public function set allowDisjointSelection(value:Boolean) : void
      {
         this._allowDisjointSelection = value;
      }
      
      [Inspectable(category="General",defaultValue="false")]
      public function get allowMultipleSelection() : Boolean
      {
         return this._allowMultipleSelection;
      }
      
      public function set allowMultipleSelection(value:Boolean) : void
      {
         this._allowMultipleSelection = value;
      }
      
      [Inspectable(category="Other",arrayType="String",defaultValue="null")]
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
         invalidateSize();
         invalidateDisplayList();
      }
      
      [Inspectable(category="General",arrayType="int")]
      public function get disabledDays() : Array
      {
         var result:Array = [];
         var i:int = 0;
         var k:int = 0;
         while(i < this._disabledDays.length)
         {
            if(this._disabledDays[i] >= 0 && this._disabledDays[i] <= 6)
            {
               result[k] = this._disabledDays[i];
               k++;
            }
            i++;
         }
         return result;
      }
      
      public function set disabledDays(value:Array) : void
      {
         this._disabledDays = value.slice(0);
         this.selectedMonthYearChanged = true;
         invalidateProperties();
         var selRange:Array = this.selectedRanges;
      }
      
      [Inspectable(category="General",arrayType="Object")]
      public function get disabledRanges() : Array
      {
         return this._disabledRanges.slice(0);
      }
      
      public function set disabledRanges(value:Array) : void
      {
         this._disabledRanges = value.slice(0);
         this.disabledRangeMode = [];
         for(var i:int = 0; i < this._disabledRanges.length; i++)
         {
            if(this._disabledRanges[i] is Date)
            {
               this.disabledRangeMode[i] = 4;
               this._disabledRanges[i] = new Date(value[i].getFullYear(),value[i].getMonth(),value[i].getDate());
            }
            else if(this._disabledRanges[i] is Object)
            {
               this._disabledRanges[i] = {};
               this._disabledRanges[i] = value[i];
               if(!this._disabledRanges[i].rangeStart && Boolean(this._disabledRanges[i].rangeEnd))
               {
                  this.disabledRangeMode[i] = 3;
               }
               else if(Boolean(this._disabledRanges[i].rangeStart) && !this._disabledRanges[i].rangeEnd)
               {
                  this.disabledRangeMode[i] = 2;
               }
               else if(Boolean(this._disabledRanges[i].rangeStart) && Boolean(this._disabledRanges[i].rangeEnd))
               {
                  this.disabledRangeMode[i] = 1;
               }
            }
         }
         this.selectedMonthYearChanged = true;
         invalidateProperties();
         var selRange:Array = this.selectedRanges;
      }
      
      [Inspectable(category="General",defaultValue="0")]
      public function get displayedMonth() : int
      {
         return this._proposedDisplayedMonth == -1 ? this._displayedMonth : this._proposedDisplayedMonth;
      }
      
      public function set displayedMonth(value:int) : void
      {
         if(value < 0 || value > 11)
         {
            return;
         }
         if(value == this._displayedMonth)
         {
            return;
         }
         this._proposedDisplayedMonth = value;
         this.selectedMonthYearChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="General",defaultValue="2006")]
      public function get displayedYear() : int
      {
         return this._proposedDisplayedYear == -1 ? this._displayedYear : this._proposedDisplayedYear;
      }
      
      public function set displayedYear(value:int) : void
      {
         if(value <= 0)
         {
            return;
         }
         if(value == this._displayedYear)
         {
            return;
         }
         this._proposedDisplayedYear = value;
         this.selectedMonthYearChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="General",defaultValue="0")]
      public function get firstDayOfWeek() : int
      {
         return this._firstDayOfWeek;
      }
      
      public function set firstDayOfWeek(value:int) : void
      {
         if(value < 0 || value > 6)
         {
            return;
         }
         if(value == this._firstDayOfWeek)
         {
            return;
         }
         this._firstDayOfWeek = value;
         this.dayNamesChanged = true;
         this.selectedMonthYearChanged = true;
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
      
      [Inspectable(category="General")]
      public function get selectableRange() : Object
      {
         return this._selectableRange;
      }
      
      public function set selectableRange(value:Object) : void
      {
         var callMonth:int = 0;
         var callYear:int = 0;
         if(!value)
         {
            this._selectableRange = null;
            this.selectedMonthYearChanged = true;
            invalidateProperties();
            return;
         }
         var todaysDate:Date = new Date();
         var todaysMonth:int = todaysDate.getMonth();
         var todaysYear:int = todaysDate.getFullYear();
         if(value is Date)
         {
            this.selRangeMode = 4;
            this._selectableRange = new Date(value.getFullYear(),value.getMonth(),value.getDate());
            callMonth = int(value.getMonth());
            callYear = int(value.getFullYear());
         }
         else if(value is Object)
         {
            this._selectableRange = {};
            if(!value.rangeStart && Boolean(value.rangeEnd))
            {
               this.selRangeMode = 3;
               this._selectableRange.rangeEnd = value.rangeEnd;
               if(todaysYear <= this._selectableRange.rangeEnd.getFullYear())
               {
                  if(todaysMonth >= this._selectableRange.rangeEnd.getMonth())
                  {
                     callMonth = int(this._selectableRange.rangeEnd.getMonth());
                     callYear = int(this._selectableRange.rangeEnd.getFullYear());
                  }
                  else if(todaysMonth <= this._selectableRange.rangeEnd.getMonth())
                  {
                     callMonth = todaysMonth;
                     callYear = todaysYear;
                  }
               }
               else if(todaysYear > this._selectableRange.rangeEnd.getFullYear())
               {
                  callMonth = int(this._selectableRange.rangeEnd.getMonth());
                  callYear = int(this._selectableRange.rangeEnd.getFullYear());
               }
            }
            else if(!value.rangeEnd && Boolean(value.rangeStart))
            {
               this.selRangeMode = 2;
               this._selectableRange.rangeStart = value.rangeStart;
               if(todaysYear >= this._selectableRange.rangeStart.getFullYear())
               {
                  if(todaysMonth <= this._selectableRange.rangeStart.getMonth())
                  {
                     callMonth = int(this._selectableRange.rangeStart.getMonth());
                     callYear = int(this._selectableRange.rangeStart.getFullYear());
                  }
                  else if(todaysMonth >= this._selectableRange.rangeStart.getMonth())
                  {
                     callMonth = todaysMonth;
                     callYear = todaysYear;
                  }
               }
               else if(todaysYear < this._selectableRange.rangeStart.getFullYear())
               {
                  callMonth = int(this._selectableRange.rangeStart.getMonth());
                  callYear = int(this._selectableRange.rangeStart.getFullYear());
               }
            }
            else if(Boolean(value.rangeStart) && Boolean(value.rangeEnd))
            {
               this.selRangeMode = 1;
               this._selectableRange.rangeStart = value.rangeStart;
               this._selectableRange.rangeEnd = value.rangeEnd;
               if(todaysDate >= this._selectableRange.rangeStart && todaysDate <= this._selectableRange.rangeEnd)
               {
                  callMonth = todaysMonth;
                  callYear = todaysYear;
               }
               else if(todaysDate < this._selectableRange.rangeStart)
               {
                  callMonth = int(this._selectableRange.rangeStart.getMonth());
                  callYear = int(this._selectableRange.rangeStart.getFullYear());
               }
               else if(todaysDate > this._selectableRange.rangeEnd)
               {
                  callMonth = int(this._selectableRange.rangeEnd.getMonth());
                  callYear = int(this._selectableRange.rangeEnd.getFullYear());
               }
            }
         }
         this._displayedMonth = callMonth;
         this._displayedYear = callYear;
         this.selectedMonthYearChanged = true;
         invalidateProperties();
         var selRange:Array = this.selectedRanges;
      }
      
      [Inspectable(category="General",arrayType="Object")]
      public function get selectedRanges() : Array
      {
         var i:int = 0;
         var minDate:Date = null;
         var maxDate:Date = null;
         var tempDate:Date = null;
         var dayOffset:int = 0;
         if(Boolean(this._selectableRange))
         {
            switch(this.selRangeMode)
            {
               case 1:
                  this.removeRangeFromSelection(null,this._selectableRange.rangeStart);
                  this.removeRangeFromSelection(this._selectableRange.rangeEnd,null);
                  break;
               case 2:
               case 3:
                  this.removeRangeFromSelection(this._selectableRange.rangeEnd,this._selectableRange.rangeStart);
                  break;
               case 4:
                  this.removeRangeFromSelection(null,this._selectableRange as Date);
                  this.removeRangeFromSelection(this._selectableRange as Date,null);
            }
         }
         for(i = 0; i < this._disabledRanges.length; i++)
         {
            switch(this.disabledRangeMode[i])
            {
               case 1:
               case 2:
               case 3:
                  this.removeRangeFromSelection(this._disabledRanges[i].rangeStart,this._disabledRanges[i].rangeEnd);
                  break;
               case 4:
                  this.removeRangeFromSelection(this._disabledRanges[i],this._disabledRanges[i]);
            }
         }
         if(this._disabledDays.length > 0 && Boolean(this.selectedRangeCount))
         {
            minDate = this._selectedRanges[0].rangeStart;
            maxDate = this._selectedRanges[0].rangeEnd;
            for(i = 1; i < this.selectedRangeCount; i++)
            {
               if(minDate > this._selectedRanges[i].rangeStart)
               {
                  minDate = this._selectedRanges[i].rangeStart;
               }
               if(maxDate < this._selectedRanges[i].rangeEnd)
               {
                  maxDate = this._selectedRanges[i].rangeEnd;
               }
            }
            for(i = 0; i < this._disabledDays.length; i++)
            {
               tempDate = minDate;
               dayOffset = this._disabledDays[i] - tempDate.getDay();
               if(dayOffset < 0)
               {
                  dayOffset += 7;
               }
               tempDate = this.incrementDate(tempDate,dayOffset);
               while(tempDate < maxDate)
               {
                  this.removeRangeFromSelection(tempDate,tempDate);
                  tempDate = this.incrementDate(tempDate,7);
               }
            }
         }
         this._selectedRanges.length = this.selectedRangeCount;
         return this._selectedRanges;
      }
      
      public function set selectedRanges(value:Array) : void
      {
         this._selectedRanges = value;
         this.selectedRangeCount = this._selectedRanges.length;
         this.setSelectedIndicators();
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get showToday() : Boolean
      {
         return this._showToday;
      }
      
      public function set showToday(value:Boolean) : void
      {
         if(this._showToday != value)
         {
            this._showToday = value;
         }
         this.selectedMonthYearChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get selectedDate() : Date
      {
         return Boolean(this.selectedRangeCount) ? this._selectedRanges[0].rangeStart : null;
      }
      
      public function set selectedDate(value:Date) : void
      {
         this.selectedRangeCount = 0;
         if(Boolean(value) && !this.checkDateIsDisabled(value))
         {
            this.addToSelected(value);
            this._displayedMonth = value.getMonth();
            this._displayedYear = value.getFullYear();
            this.selectedMonthYearChanged = true;
            invalidateProperties();
         }
         else
         {
            this.setSelectedIndicators();
         }
      }
      
      override protected function createChildren() : void
      {
         var rollOverIndicatorClass:Class = null;
         super.createChildren();
         var labelPosition:Number = 0;
         this.createDayLabels(-1);
         this.createTodayIndicator(0);
         if(!this.rollOverIndicator)
         {
            rollOverIndicatorClass = getStyle("rollOverIndicatorSkin");
            if(!rollOverIndicatorClass)
            {
               rollOverIndicatorClass = DateChooserIndicator;
            }
            this.rollOverIndicator = IFlexDisplayObject(new rollOverIndicatorClass());
            if(isDateChooserIndicator(this.rollOverIndicator))
            {
               Object(this.rollOverIndicator).indicatorColor = "rollOverColor";
            }
            if(this.rollOverIndicator is ISimpleStyleClient)
            {
               ISimpleStyleClient(this.rollOverIndicator).styleName = this;
            }
            addChildAt(DisplayObject(this.rollOverIndicator),0);
            this.rollOverIndicator.visible = false;
         }
         this.dayNamesChanged = true;
         this.selectedMonthYearChanged = true;
      }
      
      override protected function commitProperties() : void
      {
         var childIndex:int = 0;
         var o:int = 0;
         var r:int = 0;
         var proposedDate:Date = null;
         super.commitProperties();
         if(Boolean(hasFontContextChanged()) && this.todayIndicator != null)
         {
            this.removeSelectionIndicators();
            childIndex = int(getChildIndex(DisplayObject(this.todayIndicator)));
            this.removeTodayIndicator();
            this.createTodayIndicator(childIndex);
            childIndex = int(getChildIndex(this.dayBlocksArray[0][0]));
            this.removeDayLabels();
            this.createDayLabels(childIndex);
            this.enabledChanged = true;
            this.dayNamesChanged = true;
            this.selectedMonthYearChanged = true;
         }
         if(this.enabledChanged)
         {
            this.enabledChanged = false;
            for(o = 0; o < 7; o++)
            {
               for(r = 0; r < 7; r++)
               {
                  this.dayBlocksArray[o][r].enabled = this._enabled;
                  this.disabledArrays[o][r] = this._enabled;
               }
            }
            if(!this._enabled)
            {
               if(Boolean(this.todayIndicator))
               {
                  this.todayIndicator.alpha = 0.3;
               }
               removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
               removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
               removeEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
               removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
            }
            else
            {
               if(Boolean(this.todayIndicator))
               {
                  this.todayIndicator.alpha = 1;
               }
               this.selectedMonthYearChanged = true;
               addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
               addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
               addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
               addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
            }
         }
         if(this.dayNamesChanged)
         {
            this.dayNamesChanged = false;
            this.drawDayNames();
         }
         if(this.selectedMonthYearChanged)
         {
            this.selectedMonthYearChanged = false;
            proposedDate = new Date(this._proposedDisplayedYear == -1 ? this._displayedYear : this._proposedDisplayedYear,this._proposedDisplayedMonth == -1 ? this._displayedMonth : this._proposedDisplayedMonth);
            if(this.isDateInRange(proposedDate,this._selectableRange,this.selRangeMode,true))
            {
               this.setSelectedMonthAndYear();
            }
            this._proposedDisplayedYear = -1;
            this._proposedDisplayedMonth = -1;
         }
      }
      
      override protected function measure() : void
      {
         var lineMetrics:TextLineMetrics = null;
         var dayName:String = null;
         super.measure();
         var verticalGap:Number = Number(getStyle("verticalGap"));
         var horizontalGap:Number = Number(getStyle("horizontalGap"));
         var paddingLeft:Number = Number(getStyle("paddingLeft"));
         var paddingRight:Number = Number(getStyle("paddingRight"));
         var paddingBottom:Number = Number(getStyle("paddingBottom"));
         var paddingTop:Number = Number(getStyle("paddingTop"));
         this.cellWidth = 0;
         this.cellHeight = 0;
         for(var dayOfWeek:int = 0; dayOfWeek < 7; dayOfWeek++)
         {
            dayName = Boolean(this.dayNames) ? this.dayNames[dayOfWeek] : "";
            lineMetrics = measureText(dayName);
            if(lineMetrics.width > this.cellWidth)
            {
               this.cellWidth = lineMetrics.width;
            }
            if(lineMetrics.height > this.cellHeight)
            {
               this.cellHeight = lineMetrics.height;
            }
         }
         lineMetrics = measureText("30");
         if(lineMetrics.width > this.cellWidth)
         {
            this.cellWidth = lineMetrics.width;
         }
         if(lineMetrics.height > this.cellHeight)
         {
            this.cellHeight = lineMetrics.height;
         }
         measuredWidth = paddingLeft + horizontalGap * 6 + this.cellWidth * 7 + paddingRight;
         measuredHeight = verticalGap * 6 + this.cellHeight * 7 + paddingBottom + paddingTop;
         measuredMinWidth = this.cellWidth * 7;
         measuredMinHeight = this.cellHeight * 7;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var rowIndex:int = 0;
         var label:IUITextField = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var paddingLeft:Number = Number(getStyle("paddingLeft"));
         var paddingRight:Number = Number(getStyle("paddingRight"));
         var paddingBottom:Number = Number(getStyle("paddingBottom"));
         var paddingTop:Number = Number(getStyle("paddingTop"));
         var blockX:Number = paddingLeft;
         this.cellWidth = Math.max((unscaledWidth - (paddingLeft + paddingRight)) / 7,4);
         this.cellHeight = Math.max((unscaledHeight - paddingBottom) / 7,4);
         var labelPosition:Number = paddingTop;
         this.rollOverIndicator.setActualSize(this.cellWidth,this.cellHeight);
         this.todayIndicator.setActualSize(this.cellWidth,this.cellHeight);
         for(var columnIndex:int = 0; columnIndex < 7; columnIndex++)
         {
            for(rowIndex = 0; rowIndex < 7; rowIndex++)
            {
               label = this.dayBlocksArray[columnIndex][rowIndex];
               if(rowIndex == 0)
               {
                  labelPosition = paddingTop;
               }
               else
               {
                  labelPosition += this.cellHeight;
               }
               label.setActualSize(this.cellWidth,this.cellHeight);
               label.move(blockX,labelPosition);
               if(Boolean(this.selectionIndicator[columnIndex][rowIndex]))
               {
                  this.selectionIndicator[columnIndex][rowIndex].setActualSize(this.cellWidth,this.cellHeight);
                  this.selectionIndicator[columnIndex][rowIndex].move(blockX,labelPosition + this.yOffset);
               }
            }
            blockX += this.cellWidth;
         }
         this.drawDayNames();
         this.setSelectedMonthAndYear();
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var weekDayStyleName:Object = null;
         var i:int = 0;
         var allStyles:Boolean = !styleProp || styleProp == "styleName";
         if(allStyles || styleProp == "todayStyleName")
         {
            this.selectedMonthYearChanged = true;
            invalidateProperties();
         }
         if(allStyles || styleProp == "weekDayStyleName")
         {
            weekDayStyleName = getStyle("weekDayStyleName");
            if(!weekDayStyleName)
            {
               weekDayStyleName = this;
            }
            if(Boolean(this.dayBlocksArray))
            {
               for(i = 0; i < 7; i++)
               {
                  if(Boolean(this.dayBlocksArray[i]) && Boolean(this.dayBlocksArray[i][0]))
                  {
                     this.dayBlocksArray[i][0].styleName = weekDayStyleName;
                  }
               }
            }
         }
         super.styleChanged(styleProp);
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         this.dayNames = this.dayNamesOverride;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createDayLabels(childIndex:int) : void
      {
         var rowIndex:int = 0;
         var label:IUITextField = null;
         var weekDayStyleName:Object = getStyle("weekDayStyleName");
         for(var columnIndex:int = 0; columnIndex < 7; columnIndex++)
         {
            this.dayBlocksArray[columnIndex] = [];
            this.selectionIndicator[columnIndex] = [];
            for(rowIndex = 0; rowIndex < 7; rowIndex++)
            {
               label = this.dayBlocksArray[columnIndex][rowIndex] = IUITextField(createInFontContext(UITextField));
               label.selectable = false;
               label.ignorePadding = true;
               if(childIndex == -1)
               {
                  addChild(DisplayObject(label));
               }
               else
               {
                  addChildAt(DisplayObject(label),childIndex++);
               }
               if(rowIndex == 0)
               {
                  label.styleName = Boolean(weekDayStyleName) ? weekDayStyleName : this;
               }
               else
               {
                  label.styleName = this;
               }
            }
            this.disabledArrays[columnIndex] = new Array(7);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeDayLabels() : void
      {
         var rowIndex:int = 0;
         for(var columnIndex:int = 0; columnIndex < 7; columnIndex++)
         {
            for(rowIndex = 0; rowIndex < 7; rowIndex++)
            {
               removeChild(this.dayBlocksArray[columnIndex][rowIndex]);
               this.dayBlocksArray[columnIndex][rowIndex] = null;
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createTodayIndicator(childIndex:int) : void
      {
         var todayIndicatorClass:Class = null;
         if(!this.todayIndicator)
         {
            todayIndicatorClass = getStyle("todayIndicatorSkin");
            if(!todayIndicatorClass)
            {
               todayIndicatorClass = DateChooserIndicator;
            }
            this.todayIndicator = IFlexDisplayObject(new todayIndicatorClass());
            if(isDateChooserIndicator(this.todayIndicator))
            {
               Object(this.todayIndicator).indicatorColor = "todayColor";
            }
            if(this.todayIndicator is ISimpleStyleClient)
            {
               ISimpleStyleClient(this.todayIndicator).styleName = this;
            }
            addChildAt(DisplayObject(this.todayIndicator),childIndex);
            this.todayIndicator.visible = false;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeTodayIndicator() : void
      {
         if(Boolean(this.todayIndicator))
         {
            removeChild(DisplayObject(this.todayIndicator));
            this.todayIndicator = null;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function drawDayNames() : void
      {
         var dayOfWeek:int = 0;
         var dayName:String = null;
         for(var columnIndex:int = 0; columnIndex < 7; columnIndex++)
         {
            dayOfWeek = (columnIndex + this.firstDayOfWeek) % 7;
            dayName = Boolean(this.dayNames) ? this.dayNames[dayOfWeek] : "";
            this.dayBlocksArray[columnIndex][0].text = dayName;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setSelectedMonthAndYear(monthVal:int = -1, yearVal:int = -1) : void
      {
         var dayNumber:int = 0;
         var columnIndex:int = 0;
         var rowIndex:int = 0;
         var i:int = 0;
         var cellDate:Date = null;
         var todayLabel:IUITextField = null;
         var cellString:String = null;
         var valToPush:Object = null;
         var dRanges:int = 0;
         var tempCalcDate:Number = NaN;
         var tempOffset:Number = NaN;
         var displayTodayInCurrentMonth:Boolean = false;
         var displayDate:Date = null;
         var newMonth:int = monthVal == -1 ? this.displayedMonth : monthVal;
         var newYear:int = yearVal == -1 ? this.displayedYear : yearVal;
         this.enabledDaysInMonth = [];
         var offset:int = this.getOffsetOfMonth(newYear,newMonth);
         var daysInMonth:int = this.getNumberOfDaysInMonth(newYear,newMonth);
         var today:Date = new Date();
         var currentMonthContainsToday:Boolean = today.getFullYear() == newYear && today.getMonth() == newMonth;
         var previousMonth:int = Math.max(newMonth - 1,0);
         var previousMonthDate:Date = new Date(newYear,previousMonth,1);
         dayNumber = this.getNumberOfDaysInMonth(previousMonthDate.getFullYear(),previousMonthDate.getMonth());
         rowIndex = 1;
         for(columnIndex = 0; columnIndex < offset; columnIndex++)
         {
            this.dayBlocksArray[columnIndex][rowIndex].text = "";
            this.disabledArrays[columnIndex][rowIndex] = true;
            this.removeSelectionIndicator(columnIndex,rowIndex);
         }
         for(dayNumber = 1; dayNumber <= daysInMonth; dayNumber++)
         {
            cellDate = new Date(newYear,newMonth,dayNumber);
            i = offset + dayNumber - 1;
            columnIndex = i % 7;
            rowIndex = 1 + Math.floor(i / 7);
            todayLabel = this.dayBlocksArray[columnIndex][rowIndex];
            todayLabel.text = dayNumber.toString();
            if(this._enabled)
            {
               this.disabledArrays[columnIndex][rowIndex] = false;
               todayLabel.enabled = true;
            }
            if(!todayLabel.styleName)
            {
               todayLabel.styleName = this;
            }
            if(currentMonthContainsToday && cellDate.getDate() == today.getDate() && this._showToday)
            {
               this.todayRow = rowIndex;
               this.todayColumn = columnIndex;
               displayTodayInCurrentMonth = true;
               this.todayIndicator.visible = this._showToday;
               todayLabel.styleName = getStyle("todayStyleName");
               this.todayIndicator.move(todayLabel.x,todayLabel.y + this.yOffset);
               this.todaysLabelReference = todayLabel;
            }
            else if(!displayTodayInCurrentMonth)
            {
               if(Boolean(this.todaysLabelReference))
               {
                  this.todaysLabelReference.styleName = this;
               }
               this.todayIndicator.visible = false;
            }
            if(Boolean(this._selectableRange))
            {
               if(!this.isDateInRange(cellDate,this._selectableRange,this.selRangeMode))
               {
                  todayLabel.enabled = false;
                  this.disabledArrays[columnIndex][rowIndex] = true;
               }
            }
            if(this._disabledRanges.length > 0)
            {
               for(dRanges = 0; dRanges < this._disabledRanges.length; dRanges++)
               {
                  if(this.isDateInRange(cellDate,this._disabledRanges[dRanges],this.disabledRangeMode[dRanges]))
                  {
                     todayLabel.enabled = false;
                     this.disabledArrays[columnIndex][rowIndex] = true;
                  }
               }
            }
            valToPush = {};
            if(todayLabel.enabled)
            {
               valToPush.name = todayLabel.name;
               valToPush.text = todayLabel.text;
               valToPush.x = todayLabel.x;
               valToPush.y = todayLabel.y;
            }
            this.enabledDaysInMonth.push(valToPush);
         }
         dayNumber = 1;
         for(i = offset + daysInMonth; i < 42; i++)
         {
            columnIndex = i % 7;
            rowIndex = 1 + Math.floor(i / 7);
            this.dayBlocksArray[columnIndex][rowIndex].text = "";
            this.disabledArrays[columnIndex][rowIndex] = true;
            this.removeSelectionIndicator(columnIndex,rowIndex);
         }
         if(this._disabledDays.length > 0)
         {
            for(i = 0; i < this._disabledDays.length; i++)
            {
               if(this._disabledDays[i] >= 0 && this._disabledDays[i] <= 6 && this._disabledDays[i] != -1)
               {
                  columnIndex = (7 + this._disabledDays[i] - this._firstDayOfWeek) % 7;
                  for(rowIndex = 1; rowIndex < 7; rowIndex++)
                  {
                     this.disabledArrays[columnIndex][rowIndex] = true;
                     tempCalcDate = Number(this.dayBlocksArray[columnIndex][rowIndex].text);
                     if(!isNaN(tempCalcDate))
                     {
                        tempOffset = offset + tempCalcDate % 7;
                        this.enabledDaysInMonth[tempCalcDate - 1] = null;
                     }
                     this.dayBlocksArray[columnIndex][rowIndex].enabled = false;
                  }
               }
            }
         }
         this._displayedMonth = newMonth;
         this._displayedYear = newYear;
         displayDate = new Date(newYear,newMonth,1);
         this.todayIndicator.alpha = Boolean(this.todaysLabelReference) ? (this.todaysLabelReference.enabled == false ? 0.3 : 1) : 1;
         this.setSelectedIndicators();
         invalidateDisplayList();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getOffsetOfMonth(year:int, month:int) : int
      {
         var first:Date = new Date(year,month,1);
         var offset:int = first.getDay() - this._firstDayOfWeek;
         return offset < 0 ? int(offset + 7) : offset;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getNumberOfDaysInMonth(year:int, month:int) : int
      {
         var n:int = 0;
         if(month == 1)
         {
            if(year % 4 == 0 && year % 100 != 0 || year % 400 == 0)
            {
               n = 29;
            }
            else
            {
               n = 28;
            }
         }
         else if(month == 3 || month == 5 || month == 8 || month == 10)
         {
            n = 30;
         }
         else
         {
            n = 31;
         }
         return n;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function stepDate(deltaY:int, deltaM:int, triggerEvent:Event = null) : void
      {
         var oldYear:int = this.displayedYear;
         var oldMonth:int = this.displayedMonth;
         var newDate:Object = getNewIncrementDate(oldYear,oldMonth,deltaY,deltaM);
         var newYear:int = int(newDate.year);
         var newMonth:int = int(newDate.month);
         this._displayedMonth = newMonth;
         this._displayedYear = newYear;
         this.selectedMonthYearChanged = true;
         invalidateProperties();
         var event:DateChooserEvent = new DateChooserEvent(DateChooserEvent.SCROLL);
         event.triggerEvent = triggerEvent;
         if(newYear > oldYear)
         {
            event.detail = DateChooserEventDetail.NEXT_YEAR;
         }
         else if(newYear < oldYear)
         {
            event.detail = DateChooserEventDetail.PREVIOUS_YEAR;
         }
         else if(newMonth > oldMonth)
         {
            event.detail = DateChooserEventDetail.NEXT_MONTH;
         }
         else if(newMonth < oldMonth)
         {
            event.detail = DateChooserEventDetail.PREVIOUS_MONTH;
         }
         dispatchEvent(event);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function dispatchChangeEvent(triggerEvent:Event = null) : void
      {
         var change:CalendarLayoutChangeEvent = new CalendarLayoutChangeEvent(CalendarLayoutChangeEvent.CHANGE);
         change.newDate = this.lastSelectedDate;
         change.triggerEvent = triggerEvent;
         dispatchEvent(change);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function isDateInRange(value:Date, dateRange:Object, rangeMode:int, ignoreDay:Boolean = false) : Boolean
      {
         var dateRangeCopy:Object = null;
         var startDate:Date = null;
         var endDate:Date = null;
         var result:Boolean = true;
         if(Boolean(dateRange))
         {
            if(ignoreDay)
            {
               dateRangeCopy = {};
               if(Boolean(dateRange.rangeStart))
               {
                  startDate = dateRange.rangeStart;
                  dateRangeCopy.rangeStart = new Date(startDate.fullYear,startDate.month,1);
               }
               if(Boolean(dateRange.rangeEnd))
               {
                  endDate = dateRange.rangeEnd;
                  dateRangeCopy.rangeEnd = new Date(endDate.fullYear,endDate.month,this.getNumberOfDaysInMonth(endDate.fullYear,endDate.month));
               }
               dateRange = dateRangeCopy;
            }
            switch(rangeMode)
            {
               case 1:
                  if(value < dateRange.rangeStart || value > dateRange.rangeEnd)
                  {
                     result = false;
                  }
                  break;
               case 2:
                  if(value < dateRange.rangeStart)
                  {
                     result = false;
                  }
                  break;
               case 3:
                  if(value > dateRange.rangeEnd)
                  {
                     result = false;
                  }
                  break;
               case 4:
                  if(value > dateRange || value < dateRange)
                  {
                     result = false;
                  }
            }
         }
         return result;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function checkDateIsDisabled(value:Date) : Boolean
      {
         var dRanges:int = 0;
         var i:int = 0;
         if(!value)
         {
            return false;
         }
         var selectedDateIsDisabled:Boolean = false;
         if(Boolean(this._selectableRange))
         {
            if(!this.isDateInRange(value,this._selectableRange,this.selRangeMode))
            {
               selectedDateIsDisabled = true;
            }
         }
         if(this._disabledRanges.length > 0)
         {
            for(dRanges = 0; dRanges < this._disabledRanges.length; dRanges++)
            {
               if(this.isDateInRange(value,this._disabledRanges[dRanges],this.disabledRangeMode[dRanges]))
               {
                  selectedDateIsDisabled = true;
               }
            }
         }
         if(this._disabledDays.length > 0)
         {
            for(i = 0; i < this._disabledDays.length; i++)
            {
               if(value.getDay() == this._disabledDays[i])
               {
                  selectedDateIsDisabled = true;
               }
            }
         }
         return selectedDateIsDisabled;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addToSelected(newDate:Date, range:Boolean = false) : void
      {
         if(!this.selectedRangeCount)
         {
            this.rangeStartDate = null;
         }
         this.lastSelectedDate = newDate;
         if(range == false)
         {
            this._selectedRanges[this.selectedRangeCount] = {};
            this._selectedRanges[this.selectedRangeCount].rangeStart = new Date(newDate);
            this._selectedRanges[this.selectedRangeCount].rangeEnd = this._selectedRanges[this.selectedRangeCount].rangeStart;
            ++this.selectedRangeCount;
         }
         else
         {
            if(this.selectedRangeCount == 0)
            {
               this._selectedRanges[0] = {};
               this._selectedRanges[0].rangeStart = new Date(newDate);
            }
            else
            {
               this.selectedRangeCount = 1;
               if(!this.rangeStartDate)
               {
                  this.rangeStartDate = this._selectedRanges[0].rangeStart;
               }
               this._selectedRanges[0].rangeStart = new Date(this.rangeStartDate);
               if(newDate < this._selectedRanges[0].rangeStart)
               {
                  this._selectedRanges[0].rangeEnd = this._selectedRanges[0].rangeStart;
                  this._selectedRanges[0].rangeStart = new Date(newDate);
                  return;
               }
            }
            this._selectedRanges[0].rangeEnd = new Date(newDate);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function incrementDate(value:Date, amount:int = 1) : Date
      {
         var newDate:Date = new Date(value);
         var time:Number = newDate.getTime();
         newDate.setTime(time + amount * 86400000);
         return newDate;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function isSelected(newDate:Date) : Boolean
      {
         for(var i:int = 0; i < this.selectedRangeCount; i++)
         {
            if(newDate >= this._selectedRanges[i].rangeStart && newDate <= this._selectedRanges[i].rangeEnd)
            {
               return true;
            }
         }
         return false;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeRangeFromSelection(startDate:Date, endDate:Date) : void
      {
         var s1:int = 0;
         var temp:Date = null;
         for(var n:int = 0; n < this.selectedRangeCount; n++)
         {
            if(!startDate || startDate <= this._selectedRanges[n].rangeStart)
            {
               s1 = 1;
            }
            else if(startDate <= this._selectedRanges[n].rangeEnd)
            {
               s1 = 2;
            }
            else if(startDate > this._selectedRanges[n].rangeEnd)
            {
               s1 = 3;
            }
            if(endDate < this._selectedRanges[n].rangeStart)
            {
               s1 *= 5;
            }
            else if(endDate < this._selectedRanges[n].rangeEnd)
            {
               s1 *= 7;
            }
            else if(!endDate || endDate >= this._selectedRanges[n].rangeEnd)
            {
               s1 *= 11;
            }
            switch(s1)
            {
               case 5:
               case 33:
                  break;
               case 14:
                  temp = this._selectedRanges[n].rangeEnd;
                  this._selectedRanges[n].rangeEnd = this.incrementDate(startDate,-1);
                  this._selectedRanges[this.selectedRangeCount] = {};
                  this._selectedRanges[this.selectedRangeCount].rangeStart = this.incrementDate(endDate);
                  this._selectedRanges[this.selectedRangeCount].rangeEnd = temp;
                  this.selectedRangeCount += 1;
                  break;
               case 7:
                  this._selectedRanges[n].rangeStart = this.incrementDate(endDate);
                  break;
               case 22:
                  this._selectedRanges[n].rangeEnd = this.incrementDate(startDate,-1);
                  break;
               case 11:
                  this._selectedRanges[n] = this._selectedRanges[this.selectedRangeCount - 1];
                  this._selectedRanges[this.selectedRangeCount - 1] = null;
                  this.selectedRangeCount -= 1;
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setSelectedIndicators() : void
      {
         var columnIndex:int = 0;
         var rowIndex:int = 0;
         var i:int = 0;
         var cellDate:Date = null;
         var offset:int = this.getOffsetOfMonth(this.displayedYear,this.displayedMonth);
         var daysInMonth:int = this.getNumberOfDaysInMonth(this.displayedYear,this.displayedMonth);
         for(var dayNumber:int = 1; dayNumber <= daysInMonth; dayNumber++)
         {
            cellDate = new Date(this.displayedYear,this.displayedMonth,dayNumber);
            i = offset + dayNumber - 1;
            columnIndex = i % 7;
            rowIndex = 1 + Math.floor(i / 7);
            if(this.isSelected(cellDate) && this.disabledArrays[columnIndex][rowIndex] == false)
            {
               this.addSelectionIndicator(columnIndex,rowIndex);
            }
            else
            {
               this.removeSelectionIndicator(columnIndex,rowIndex);
            }
         }
         var today:Date = new Date();
         if(this.isSelected(today))
         {
            this.todayIndicator.alpha = 1;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addSelectionIndicator(columnIndex:int, rowIndex:int) : void
      {
         var selectionIndicatorClass:Class = null;
         var selCell:IUITextField = null;
         if(!this.selectionIndicator[columnIndex][rowIndex])
         {
            selectionIndicatorClass = getStyle("selectionIndicatorSkin");
            if(!selectionIndicatorClass)
            {
               selectionIndicatorClass = DateChooserIndicator;
            }
            this.selectionIndicator[columnIndex][rowIndex] = IFlexDisplayObject(new selectionIndicatorClass());
            if(isDateChooserIndicator(this.selectionIndicator[columnIndex][rowIndex]))
            {
               Object(this.selectionIndicator[columnIndex][rowIndex]).indicatorColor = "selectionColor";
            }
            if(this.selectionIndicator[columnIndex][rowIndex] is ISimpleStyleClient)
            {
               ISimpleStyleClient(this.selectionIndicator[columnIndex][rowIndex]).styleName = this;
            }
            addChildAt(DisplayObject(this.selectionIndicator[columnIndex][rowIndex]),0);
            selCell = this.dayBlocksArray[columnIndex][rowIndex];
            this.selectionIndicator[columnIndex][rowIndex].move(selCell.x,selCell.y + this.yOffset);
            this.selectionIndicator[columnIndex][rowIndex].setActualSize(this.cellWidth,this.cellHeight);
         }
         this.selectionIndicator[columnIndex][rowIndex].visible = true;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeSelectionIndicator(columnIndex:int, rowIndex:int) : void
      {
         if(Boolean(this.selectionIndicator[columnIndex][rowIndex]))
         {
            removeChild(this.selectionIndicator[columnIndex][rowIndex]);
            this.selectionIndicator[columnIndex][rowIndex] = null;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeSelectionIndicators() : void
      {
         var rowIndex:int = 0;
         for(var columnIndex:int = 0; columnIndex < 7; columnIndex++)
         {
            for(rowIndex = 0; rowIndex < 7; rowIndex++)
            {
               this.removeSelectionIndicator(columnIndex,rowIndex);
            }
         }
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         var newDate:Date = null;
         var selChanged:Boolean = false;
         var date:int = Boolean(this.lastSelectedDate) ? int(this.lastSelectedDate.getDate()) : 1;
         var daysInMonth:int = this.getNumberOfDaysInMonth(this.displayedYear,this.displayedMonth);
         var keyCode:uint = uint(mapKeycodeForLayoutDirection(event));
         for(var i:uint = 0; i < 31; i++)
         {
            if(keyCode == Keyboard.LEFT)
            {
               if(date <= 1)
               {
                  return;
               }
               date--;
               selChanged = true;
            }
            else if(keyCode == Keyboard.RIGHT)
            {
               if(date >= daysInMonth)
               {
                  return;
               }
               date++;
               selChanged = true;
            }
            else if(keyCode == Keyboard.UP)
            {
               if(date <= 7)
               {
                  return;
               }
               date -= 7;
               selChanged = true;
            }
            else if(keyCode == Keyboard.DOWN)
            {
               if(date + 7 > daysInMonth)
               {
                  return;
               }
               date += 7;
               selChanged = true;
            }
            else if(keyCode == Keyboard.HOME)
            {
               if(i == 0)
               {
                  date = 1;
               }
               else
               {
                  date++;
               }
               selChanged = true;
            }
            else if(keyCode == Keyboard.END)
            {
               if(i == 0)
               {
                  date = daysInMonth;
               }
               else
               {
                  date--;
               }
               selChanged = true;
            }
            else if(Boolean(this.lastSelectedDate) && Boolean(event.shiftKey) && (keyCode == Keyboard.PAGE_UP || keyCode == Keyboard.PAGE_DOWN))
            {
               selChanged = true;
            }
            else if(Boolean(this.lastSelectedDate) && (keyCode == 189 || keyCode == 187))
            {
               selChanged = true;
            }
            if(keyCode >= Keyboard.PAGE_UP && keyCode <= Keyboard.DOWN)
            {
               event.stopPropagation();
            }
            if(selChanged)
            {
               newDate = new Date(this.displayedYear,this.displayedMonth,date);
               if(!(this.checkDateIsDisabled(newDate) && !event.shiftKey))
               {
                  if(!(event.shiftKey && this._allowMultipleSelection))
                  {
                     this.selectedRangeCount = 0;
                  }
                  this.addToSelected(newDate,event.shiftKey && this._allowMultipleSelection);
                  this.setSelectedIndicators();
                  this.dispatchChangeEvent(event);
                  return;
               }
            }
         }
      }
      
      private function mouseOverHandler(event:MouseEvent) : void
      {
         if(Boolean(event.relatedObject) && event.relatedObject.parent != this)
         {
            addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         }
         else
         {
            event.stopImmediatePropagation();
         }
      }
      
      private function mouseOutHandler(event:MouseEvent) : void
      {
         var today:Date = null;
         if(Boolean(event.relatedObject) && event.relatedObject.parent != this)
         {
            removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
            this.rollOverIndicator.visible = false;
            if(this.todayColumn != -1 && this.todayRow != -1 && !this.disabledArrays[this.todayColumn][this.todayRow])
            {
               today = new Date();
               if(!this.isSelected(today))
               {
                  this.todayIndicator.alpha = 1;
               }
            }
         }
         else
         {
            event.stopImmediatePropagation();
         }
      }
      
      private function mouseMoveHandler(event:MouseEvent) : void
      {
         var today:Date = null;
         var paddingLeft:Number = Number(getStyle("paddingLeft"));
         var paddingTop:Number = Number(getStyle("paddingTop"));
         var firstColX:Number = Number(this.dayBlocksArray[0][0].x);
         var lastColX:Number = Number(this.dayBlocksArray[6][0].x);
         var firstRowY:Number = this.dayBlocksArray[6][0].y + this.cellHeight;
         var mousePoint:Point = new Point(event.stageX,event.stageY);
         mousePoint = globalToLocal(mousePoint);
         var mouseY:Number = mousePoint.y;
         var mouseX:Number = mousePoint.x;
         if(mouseX < firstColX || mouseX > lastColX + this.cellWidth || mouseY < firstRowY)
         {
            return;
         }
         var rowIndex:int = Math.floor((mouseY - paddingTop) / this.cellHeight);
         var colIndex:int = Math.floor((mouseX - paddingLeft) / this.cellWidth);
         colIndex = Math.min(colIndex,6);
         rowIndex = Math.min(rowIndex,6);
         var selCell:IUITextField = this.dayBlocksArray[colIndex][rowIndex];
         if(Boolean(this.disabledArrays[colIndex][rowIndex]) || rowIndex == 0)
         {
            return;
         }
         if(mouseY >= selCell.y && mouseY <= selCell.y + this.cellHeight && mouseX >= selCell.x && mouseX <= selCell.x + this.cellWidth)
         {
            this.rollOverIndicator.move(selCell.x,selCell.y + this.yOffset);
            this.rollOverIndicator.visible = true;
            if(Boolean(this.selectionIndicator[colIndex][rowIndex]))
            {
               this.rollOverIndicator.visible = false;
            }
            if(this.todayColumn != -1 && this.todayRow != -1 && !this.disabledArrays[this.todayColumn][this.todayRow])
            {
               today = new Date();
               if(this.rollOverIndicator.x == this.todayIndicator.x && this.rollOverIndicator.y == this.todayIndicator.y)
               {
                  this.todayIndicator.alpha = 0.6;
               }
               else if(!this.isSelected(today))
               {
                  this.todayIndicator.alpha = 1;
               }
            }
         }
      }
      
      private function mouseUpHandler(event:MouseEvent) : void
      {
         var newDate:Date = null;
         var alreadySelected:Boolean = false;
         var todaysDate:Date = null;
         var paddingLeft:Number = Number(getStyle("paddingLeft"));
         var paddingTop:Number = Number(getStyle("paddingTop"));
         var firstColX:Number = Number(this.dayBlocksArray[0][0].x);
         var lastColX:Number = Number(this.dayBlocksArray[6][0].x);
         var firstRowY:Number = this.dayBlocksArray[6][0].y + this.cellHeight;
         var mousePoint:Point = new Point(event.stageX,event.stageY);
         mousePoint = globalToLocal(mousePoint);
         var mouseY:Number = mousePoint.y;
         var mouseX:Number = mousePoint.x;
         if(mouseX < firstColX && mouseX >= lastColX + this.cellWidth || mouseY < firstRowY)
         {
            return;
         }
         var rowIndex:int = Math.floor((mouseY - paddingTop) / this.cellHeight);
         if(rowIndex <= 0)
         {
            return;
         }
         rowIndex = Math.min(rowIndex,6);
         var colIndex:int = Math.floor((mouseX - paddingLeft) / this.cellWidth);
         colIndex = Math.min(colIndex,6);
         var selCell:IUITextField = this.dayBlocksArray[colIndex][rowIndex];
         if(Boolean(this.disabledArrays[colIndex][rowIndex]))
         {
            return;
         }
         if(mouseY >= selCell.y && mouseY <= selCell.y + this.cellHeight && mouseX >= selCell.x && mouseX <= selCell.x + this.cellWidth)
         {
            newDate = new Date(this.displayedYear,this.displayedMonth,int(selCell.text));
            if(event.shiftKey && this._allowMultipleSelection)
            {
               this.addToSelected(newDate,true);
               this.setSelectedIndicators();
            }
            else
            {
               alreadySelected = Boolean(this.selectionIndicator[colIndex][rowIndex]) ? true : false;
               if(event.ctrlKey && this._allowMultipleSelection && this._allowDisjointSelection)
               {
                  if(alreadySelected)
                  {
                     this.removeSelectionIndicator(colIndex,rowIndex);
                     this.removeRangeFromSelection(newDate,newDate);
                  }
                  else
                  {
                     this.addSelectionIndicator(colIndex,rowIndex);
                     this.addToSelected(newDate);
                  }
               }
               else
               {
                  this.rangeStartDate = null;
                  if(alreadySelected)
                  {
                     if(this.selectedRangeCount > 1 || this.selectedRangeCount == 1 && this._selectedRanges[0].rangeStart != this._selectedRanges[0].rangeEnd)
                     {
                        this.selectedRangeCount = 0;
                        this.addSelectionIndicator(colIndex,rowIndex);
                        this.addToSelected(newDate);
                        this.setSelectedIndicators();
                     }
                     else if(event.ctrlKey)
                     {
                        this.removeSelectionIndicator(colIndex,rowIndex);
                        this.removeRangeFromSelection(newDate,newDate);
                     }
                  }
                  else
                  {
                     this.selectedRangeCount = 0;
                     this.addSelectionIndicator(colIndex,rowIndex);
                     this.addToSelected(newDate);
                     this.setSelectedIndicators();
                  }
               }
            }
            this.dispatchChangeEvent(event);
            if(this.todayColumn != -1 && this.todayRow != -1 && !this.disabledArrays[this.todayColumn][this.todayRow])
            {
               todaysDate = new Date();
               this.todayIndicator.alpha = this.isSelected(todaysDate) ? 0.6 : 1;
            }
            if(Boolean(this.selectionIndicator[colIndex][rowIndex]))
            {
               this.rollOverIndicator.visible = false;
            }
         }
      }
   }
}

