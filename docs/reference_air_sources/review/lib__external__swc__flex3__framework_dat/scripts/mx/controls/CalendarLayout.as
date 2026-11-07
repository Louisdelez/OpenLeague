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
   import mx.core.mx_internal;
   import mx.events.CalendarLayoutChangeEvent;
   import mx.events.DateChooserEvent;
   import mx.events.DateChooserEventDetail;
   import mx.managers.IFocusManagerComponent;
   import mx.skins.halo.DateChooserIndicator;
   import mx.styles.ISimpleStyleClient;
   
   use namespace mx_internal;
   
   [ResourceBundle("controls")]
   [ExcludeClass]
   [Style(name="weekDayStyleName",type="String",inherit="no")]
   [Style(name="todayStyleName",type="String",inherit="no")]
   [Style(name="todayIndicatorSkin",type="Class",inherit="no")]
   [Style(name="selectionIndicatorSkin",type="Class",inherit="no")]
   [Style(name="rollOverIndicatorSkin",type="Class",inherit="no")]
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
   [Style(name="verticalGap",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no")]
   public class CalendarLayout extends UIComponent implements IFocusManagerComponent, IFontContextComponent
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static var dcis:Object = {};
      
      private var _enabled:Boolean = true;
      
      private var enabledDaysInMonth:Array = [];
      
      private var _allowDisjointSelection:Boolean = true;
      
      private var dayNamesChanged:Boolean = false;
      
      private var rollOverIndicator:IFlexDisplayObject;
      
      private var cellHeight:Number = 14;
      
      private var _allowMultipleSelection:Boolean = false;
      
      mx_internal var dayBlocksArray:Array = [];
      
      private var enabledChanged:Boolean = false;
      
      private var _proposedDisplayedMonth:int = -1;
      
      private var _displayedMonth:int = new Date().getMonth();
      
      mx_internal var selRangeMode:int = 1;
      
      private var _selectableRange:Object = null;
      
      private var disabledRangeMode:Array;
      
      private var yOffset:Number = -1;
      
      private var _selectedRanges:Array = [];
      
      private var _dayNames:Array;
      
      private var rangeStartDate:Date = null;
      
      private var _firstDayOfWeek:int = 0;
      
      private var cellWidth:Number = 14;
      
      private var _disabledRanges:Array = [];
      
      private var lastSelectedDate:Date;
      
      private var todaysLabelReference:IUITextField = null;
      
      private var _displayedYear:int = new Date().getFullYear();
      
      private var _showToday:Boolean = true;
      
      private var selectedRangeCount:int = 0;
      
      private var todayIndicator:IFlexDisplayObject;
      
      private var selectedMonthYearChanged:Boolean = false;
      
      private var disabledArrays:Array = [];
      
      private var todayRow:int = -1;
      
      private var _disabledDays:Array = [];
      
      private var selectionIndicator:Array = [];
      
      private var todayColumn:int = -1;
      
      private var dayNamesOverride:Array;
      
      private var _proposedDisplayedYear:int = -1;
      
      public function CalendarLayout()
      {
         super();
         addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
         addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
         addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
      }
      
      mx_internal static function getNewIncrementDate(oldYear:int, oldMonth:int, deltaY:int, deltaM:int) : Object
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
      
      mx_internal function isDateInRange(value:Date, dateRange:Object, rangeMode:int, ignoreDay:Boolean = false) : Boolean
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
                  dateRangeCopy.rangeEnd = new Date(endDate.fullYear,endDate.month,getNumberOfDaysInMonth(endDate.fullYear,endDate.month));
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
      
      private function mouseOverHandler(event:MouseEvent) : void
      {
         if(Boolean(event.relatedObject) && event.relatedObject.parent != this)
         {
            addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
         }
         else
         {
            event.stopImmediatePropagation();
         }
      }
      
      private function mouseUpHandler(event:MouseEvent) : void
      {
         var newDate:Date = null;
         var alreadySelected:Boolean = false;
         var todaysDate:Date = null;
         var paddingLeft:Number = getStyle("paddingLeft");
         var paddingTop:Number = getStyle("paddingTop");
         var firstColX:Number = Number(dayBlocksArray[0][0].x);
         var lastColX:Number = Number(dayBlocksArray[6][0].x);
         var firstRowY:Number = dayBlocksArray[6][0].y + cellHeight;
         var mousePoint:Point = new Point(event.stageX,event.stageY);
         mousePoint = globalToLocal(mousePoint);
         var mouseY:Number = mousePoint.y;
         var mouseX:Number = mousePoint.x;
         if(mouseX < firstColX && mouseX >= lastColX + cellWidth || mouseY < firstRowY)
         {
            return;
         }
         var rowIndex:int = Math.floor((mouseY - paddingTop) / cellHeight);
         if(rowIndex <= 0)
         {
            return;
         }
         rowIndex = Math.min(rowIndex,6);
         var colIndex:int = Math.floor((mouseX - paddingLeft) / cellWidth);
         colIndex = Math.min(colIndex,6);
         var selCell:IUITextField = dayBlocksArray[colIndex][rowIndex];
         if(Boolean(disabledArrays[colIndex][rowIndex]))
         {
            return;
         }
         if(mouseY >= selCell.y && mouseY <= selCell.y + cellHeight && mouseX >= selCell.x && mouseX <= selCell.x + cellWidth)
         {
            newDate = new Date(displayedYear,displayedMonth,int(selCell.text));
            if(event.shiftKey && _allowMultipleSelection)
            {
               addToSelected(newDate,true);
               setSelectedIndicators();
            }
            else
            {
               alreadySelected = Boolean(selectionIndicator[colIndex][rowIndex]) ? true : false;
               if(event.ctrlKey && _allowMultipleSelection && _allowDisjointSelection)
               {
                  if(alreadySelected)
                  {
                     removeSelectionIndicator(colIndex,rowIndex);
                     removeRangeFromSelection(newDate,newDate);
                  }
                  else
                  {
                     addSelectionIndicator(colIndex,rowIndex);
                     addToSelected(newDate);
                  }
               }
               else
               {
                  rangeStartDate = null;
                  if(alreadySelected)
                  {
                     if(selectedRangeCount > 1 || selectedRangeCount == 1 && _selectedRanges[0].rangeStart != _selectedRanges[0].rangeEnd)
                     {
                        selectedRangeCount = 0;
                        addSelectionIndicator(colIndex,rowIndex);
                        addToSelected(newDate);
                        setSelectedIndicators();
                     }
                     else if(event.ctrlKey)
                     {
                        removeSelectionIndicator(colIndex,rowIndex);
                        removeRangeFromSelection(newDate,newDate);
                     }
                  }
                  else
                  {
                     selectedRangeCount = 0;
                     addSelectionIndicator(colIndex,rowIndex);
                     addToSelected(newDate);
                     setSelectedIndicators();
                  }
               }
            }
            dispatchChangeEvent(event);
            if(todayColumn != -1 && todayRow != -1 && !disabledArrays[todayColumn][todayRow])
            {
               todaysDate = new Date();
               todayIndicator.alpha = isSelected(todaysDate) ? 0.6 : 1;
            }
            if(Boolean(selectionIndicator[colIndex][rowIndex]))
            {
               rollOverIndicator.visible = false;
            }
         }
      }
      
      public function set selectableRange(value:Object) : void
      {
         var callMonth:int = 0;
         var callYear:int = 0;
         if(!value)
         {
            _selectableRange = null;
            selectedMonthYearChanged = true;
            invalidateProperties();
            return;
         }
         var todaysDate:Date = new Date();
         var todaysMonth:int = todaysDate.getMonth();
         var todaysYear:int = todaysDate.getFullYear();
         if(value is Date)
         {
            selRangeMode = 4;
            _selectableRange = new Date(value.getFullYear(),value.getMonth(),value.getDate());
            callMonth = int(value.getMonth());
            callYear = int(value.getFullYear());
         }
         else if(value is Object)
         {
            _selectableRange = {};
            if(!value.rangeStart && Boolean(value.rangeEnd))
            {
               selRangeMode = 3;
               _selectableRange.rangeEnd = value.rangeEnd;
               if(todaysYear <= _selectableRange.rangeEnd.getFullYear())
               {
                  if(todaysMonth >= _selectableRange.rangeEnd.getMonth())
                  {
                     callMonth = int(_selectableRange.rangeEnd.getMonth());
                     callYear = int(_selectableRange.rangeEnd.getFullYear());
                  }
                  else if(todaysMonth <= _selectableRange.rangeEnd.getMonth())
                  {
                     callMonth = todaysMonth;
                     callYear = todaysYear;
                  }
               }
               else if(todaysYear > _selectableRange.rangeEnd.getFullYear())
               {
                  callMonth = int(_selectableRange.rangeEnd.getMonth());
                  callYear = int(_selectableRange.rangeEnd.getFullYear());
               }
            }
            else if(!value.rangeEnd && Boolean(value.rangeStart))
            {
               selRangeMode = 2;
               _selectableRange.rangeStart = value.rangeStart;
               if(todaysYear >= _selectableRange.rangeStart.getFullYear())
               {
                  if(todaysMonth <= _selectableRange.rangeStart.getMonth())
                  {
                     callMonth = int(_selectableRange.rangeStart.getMonth());
                     callYear = int(_selectableRange.rangeStart.getFullYear());
                  }
                  else if(todaysMonth >= _selectableRange.rangeStart.getMonth())
                  {
                     callMonth = todaysMonth;
                     callYear = todaysYear;
                  }
               }
               else if(todaysYear < _selectableRange.rangeStart.getFullYear())
               {
                  callMonth = int(_selectableRange.rangeStart.getMonth());
                  callYear = int(_selectableRange.rangeStart.getFullYear());
               }
            }
            else if(Boolean(value.rangeStart) && Boolean(value.rangeEnd))
            {
               selRangeMode = 1;
               _selectableRange.rangeStart = value.rangeStart;
               _selectableRange.rangeEnd = value.rangeEnd;
               if(todaysDate >= _selectableRange.rangeStart && todaysDate <= _selectableRange.rangeEnd)
               {
                  callMonth = todaysMonth;
                  callYear = todaysYear;
               }
               else if(todaysDate < _selectableRange.rangeStart)
               {
                  callMonth = int(_selectableRange.rangeStart.getMonth());
                  callYear = int(_selectableRange.rangeStart.getFullYear());
               }
               else if(todaysDate > _selectableRange.rangeEnd)
               {
                  callMonth = int(_selectableRange.rangeEnd.getMonth());
                  callYear = int(_selectableRange.rangeEnd.getFullYear());
               }
            }
         }
         _displayedMonth = callMonth;
         _displayedYear = callYear;
         selectedMonthYearChanged = true;
         invalidateProperties();
         var selRange:Array = selectedRanges;
      }
      
      [Inspectable(category="Other",arrayType="String",defaultValue="null")]
      public function get dayNames() : Array
      {
         return _dayNames;
      }
      
      public function set dayNames(value:Array) : void
      {
         dayNamesOverride = value;
         _dayNames = value != null ? value : resourceManager.getStringArray("controls","dayNamesShortest");
         _dayNames = Boolean(_dayNames) ? _dayNames.slice(0) : null;
         dayNamesChanged = true;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      [Inspectable(category="General",defaultValue="false")]
      public function get allowMultipleSelection() : Boolean
      {
         return _allowMultipleSelection;
      }
      
      override protected function createChildren() : void
      {
         var rollOverIndicatorClass:Class = null;
         super.createChildren();
         var labelPosition:Number = 0;
         createDayLabels(-1);
         createTodayIndicator(0);
         if(!rollOverIndicator)
         {
            rollOverIndicatorClass = getStyle("rollOverIndicatorSkin");
            if(!rollOverIndicatorClass)
            {
               rollOverIndicatorClass = DateChooserIndicator;
            }
            rollOverIndicator = IFlexDisplayObject(new rollOverIndicatorClass());
            if(isDateChooserIndicator(rollOverIndicator))
            {
               Object(rollOverIndicator).indicatorColor = "rollOverColor";
            }
            if(rollOverIndicator is ISimpleStyleClient)
            {
               ISimpleStyleClient(rollOverIndicator).styleName = this;
            }
            addChildAt(DisplayObject(rollOverIndicator),0);
            rollOverIndicator.visible = false;
         }
         dayNamesChanged = true;
         selectedMonthYearChanged = true;
      }
      
      [Inspectable(category="General",defaultValue="0")]
      public function get displayedMonth() : int
      {
         return _proposedDisplayedMonth == -1 ? _displayedMonth : _proposedDisplayedMonth;
      }
      
      mx_internal function getOffsetOfMonth(year:int, month:int) : int
      {
         var first:Date = new Date(year,month,1);
         var offset:int = first.getDay() - _firstDayOfWeek;
         return offset < 0 ? int(offset + 7) : offset;
      }
      
      public function set allowMultipleSelection(value:Boolean) : void
      {
         _allowMultipleSelection = value;
      }
      
      mx_internal function createDayLabels(childIndex:int) : void
      {
         var rowIndex:int = 0;
         var label:IUITextField = null;
         var weekDayStyleName:Object = getStyle("weekDayStyleName");
         for(var columnIndex:int = 0; columnIndex < 7; columnIndex++)
         {
            dayBlocksArray[columnIndex] = [];
            selectionIndicator[columnIndex] = [];
            for(rowIndex = 0; rowIndex < 7; rowIndex++)
            {
               label = dayBlocksArray[columnIndex][rowIndex] = IUITextField(createInFontContext(UITextField));
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
            disabledArrays[columnIndex] = new Array(7);
         }
      }
      
      [Inspectable(category="General",defaultValue="true")]
      override public function get enabled() : Boolean
      {
         return _enabled;
      }
      
      mx_internal function checkDateIsDisabled(value:Date) : Boolean
      {
         var dRanges:int = 0;
         var i:int = 0;
         if(!value)
         {
            return false;
         }
         var selectedDateIsDisabled:Boolean = false;
         if(Boolean(_selectableRange))
         {
            if(!isDateInRange(value,_selectableRange,selRangeMode))
            {
               selectedDateIsDisabled = true;
            }
         }
         if(_disabledRanges.length > 0)
         {
            for(dRanges = 0; dRanges < _disabledRanges.length; dRanges++)
            {
               if(isDateInRange(value,_disabledRanges[dRanges],disabledRangeMode[dRanges]))
               {
                  selectedDateIsDisabled = true;
               }
            }
         }
         if(_disabledDays.length > 0)
         {
            for(i = 0; i < _disabledDays.length; i++)
            {
               if(value.getDay() == _disabledDays[i])
               {
                  selectedDateIsDisabled = true;
               }
            }
         }
         return selectedDateIsDisabled;
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get showToday() : Boolean
      {
         return _showToday;
      }
      
      public function set displayedMonth(value:int) : void
      {
         if(value < 0 || value > 11)
         {
            return;
         }
         if(value == _displayedMonth)
         {
            return;
         }
         _proposedDisplayedMonth = value;
         selectedMonthYearChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="General",arrayType="Object")]
      public function get selectedRanges() : Array
      {
         var i:int = 0;
         var minDate:Date = null;
         var maxDate:Date = null;
         var tempDate:Date = null;
         var dayOffset:int = 0;
         if(Boolean(_selectableRange))
         {
            switch(selRangeMode)
            {
               case 1:
                  removeRangeFromSelection(null,_selectableRange.rangeStart);
                  removeRangeFromSelection(_selectableRange.rangeEnd,null);
                  break;
               case 2:
               case 3:
                  removeRangeFromSelection(_selectableRange.rangeEnd,_selectableRange.rangeStart);
                  break;
               case 4:
                  removeRangeFromSelection(null,_selectableRange as Date);
                  removeRangeFromSelection(_selectableRange as Date,null);
            }
         }
         for(i = 0; i < _disabledRanges.length; i++)
         {
            switch(disabledRangeMode[i])
            {
               case 1:
               case 2:
               case 3:
                  removeRangeFromSelection(_disabledRanges[i].rangeStart,_disabledRanges[i].rangeEnd);
                  break;
               case 4:
                  removeRangeFromSelection(_disabledRanges[i],_disabledRanges[i]);
            }
         }
         if(_disabledDays.length > 0 && Boolean(selectedRangeCount))
         {
            minDate = _selectedRanges[0].rangeStart;
            maxDate = _selectedRanges[0].rangeEnd;
            for(i = 1; i < selectedRangeCount; i++)
            {
               if(minDate > _selectedRanges[i].rangeStart)
               {
                  minDate = _selectedRanges[i].rangeStart;
               }
               if(maxDate < _selectedRanges[i].rangeEnd)
               {
                  maxDate = _selectedRanges[i].rangeEnd;
               }
            }
            for(i = 0; i < _disabledDays.length; i++)
            {
               tempDate = minDate;
               dayOffset = _disabledDays[i] - tempDate.getDay();
               if(dayOffset < 0)
               {
                  dayOffset += 7;
               }
               tempDate = incrementDate(tempDate,dayOffset);
               while(tempDate < maxDate)
               {
                  removeRangeFromSelection(tempDate,tempDate);
                  tempDate = incrementDate(tempDate,7);
               }
            }
         }
         _selectedRanges.length = selectedRangeCount;
         return _selectedRanges;
      }
      
      private function mouseMoveHandler(event:MouseEvent) : void
      {
         var today:Date = null;
         var paddingLeft:Number = getStyle("paddingLeft");
         var paddingTop:Number = getStyle("paddingTop");
         var firstColX:Number = Number(dayBlocksArray[0][0].x);
         var lastColX:Number = Number(dayBlocksArray[6][0].x);
         var firstRowY:Number = dayBlocksArray[6][0].y + cellHeight;
         var mousePoint:Point = new Point(event.stageX,event.stageY);
         mousePoint = globalToLocal(mousePoint);
         var mouseY:Number = mousePoint.y;
         var mouseX:Number = mousePoint.x;
         if(mouseX < firstColX || mouseX > lastColX + cellWidth || mouseY < firstRowY)
         {
            return;
         }
         var rowIndex:int = Math.floor((mouseY - paddingTop) / cellHeight);
         var colIndex:int = Math.floor((mouseX - paddingLeft) / cellWidth);
         colIndex = Math.min(colIndex,6);
         rowIndex = Math.min(rowIndex,6);
         var selCell:IUITextField = dayBlocksArray[colIndex][rowIndex];
         if(Boolean(disabledArrays[colIndex][rowIndex]) || rowIndex == 0)
         {
            return;
         }
         if(mouseY >= selCell.y && mouseY <= selCell.y + cellHeight && mouseX >= selCell.x && mouseX <= selCell.x + cellWidth)
         {
            rollOverIndicator.move(selCell.x,selCell.y + yOffset);
            rollOverIndicator.visible = true;
            if(Boolean(selectionIndicator[colIndex][rowIndex]))
            {
               rollOverIndicator.visible = false;
            }
            if(todayColumn != -1 && todayRow != -1 && !disabledArrays[todayColumn][todayRow])
            {
               today = new Date();
               if(rollOverIndicator.x == todayIndicator.x && rollOverIndicator.y == todayIndicator.y)
               {
                  todayIndicator.alpha = 0.6;
               }
               else if(!isSelected(today))
               {
                  todayIndicator.alpha = 1;
               }
            }
         }
      }
      
      [Inspectable(category="General",defaultValue="0")]
      public function get firstDayOfWeek() : int
      {
         return _firstDayOfWeek;
      }
      
      override protected function measure() : void
      {
         var lineMetrics:TextLineMetrics = null;
         var dayName:String = null;
         super.measure();
         var verticalGap:Number = getStyle("verticalGap");
         var horizontalGap:Number = getStyle("horizontalGap");
         var paddingLeft:Number = getStyle("paddingLeft");
         var paddingRight:Number = getStyle("paddingRight");
         var paddingBottom:Number = getStyle("paddingBottom");
         var paddingTop:Number = getStyle("paddingTop");
         cellWidth = 0;
         cellHeight = 0;
         for(var dayOfWeek:int = 0; dayOfWeek < 7; dayOfWeek++)
         {
            dayName = Boolean(dayNames) ? dayNames[dayOfWeek] : "";
            lineMetrics = measureText(dayName);
            if(lineMetrics.width > cellWidth)
            {
               cellWidth = lineMetrics.width;
            }
            if(lineMetrics.height > cellHeight)
            {
               cellHeight = lineMetrics.height;
            }
         }
         lineMetrics = measureText("30");
         if(lineMetrics.width > cellWidth)
         {
            cellWidth = lineMetrics.width;
         }
         if(lineMetrics.height > cellHeight)
         {
            cellHeight = lineMetrics.height;
         }
         measuredWidth = paddingLeft + horizontalGap * 6 + cellWidth * 7 + paddingRight;
         measuredHeight = verticalGap * 6 + cellHeight * 7 + paddingBottom + paddingTop;
         measuredMinWidth = cellWidth * 7;
         measuredMinHeight = cellHeight * 7;
      }
      
      mx_internal function setSelectedIndicators() : void
      {
         var columnIndex:int = 0;
         var rowIndex:int = 0;
         var i:int = 0;
         var cellDate:Date = null;
         var offset:int = getOffsetOfMonth(displayedYear,displayedMonth);
         var daysInMonth:int = getNumberOfDaysInMonth(displayedYear,displayedMonth);
         for(var dayNumber:int = 1; dayNumber <= daysInMonth; dayNumber++)
         {
            cellDate = new Date(displayedYear,displayedMonth,dayNumber);
            i = offset + dayNumber - 1;
            columnIndex = i % 7;
            rowIndex = 1 + Math.floor(i / 7);
            if(isSelected(cellDate) && disabledArrays[columnIndex][rowIndex] == false)
            {
               addSelectionIndicator(columnIndex,rowIndex);
            }
            else
            {
               removeSelectionIndicator(columnIndex,rowIndex);
            }
         }
         var today:Date = new Date();
         if(isSelected(today))
         {
            todayIndicator.alpha = 1;
         }
      }
      
      public function get fontContext() : IFlexModuleFactory
      {
         return moduleFactory;
      }
      
      mx_internal function removeRangeFromSelection(startDate:Date, endDate:Date) : void
      {
         var s1:int = 0;
         var temp:Date = null;
         for(var n:int = 0; n < selectedRangeCount; n++)
         {
            if(!startDate || startDate <= _selectedRanges[n].rangeStart)
            {
               s1 = 1;
            }
            else if(startDate <= _selectedRanges[n].rangeEnd)
            {
               s1 = 2;
            }
            else if(startDate > _selectedRanges[n].rangeEnd)
            {
               s1 = 3;
            }
            if(endDate < _selectedRanges[n].rangeStart)
            {
               s1 *= 5;
            }
            else if(endDate < _selectedRanges[n].rangeEnd)
            {
               s1 *= 7;
            }
            else if(!endDate || endDate >= _selectedRanges[n].rangeEnd)
            {
               s1 *= 11;
            }
            switch(s1)
            {
               case 5:
               case 33:
                  break;
               case 14:
                  temp = _selectedRanges[n].rangeEnd;
                  _selectedRanges[n].rangeEnd = incrementDate(startDate,-1);
                  _selectedRanges[selectedRangeCount] = {};
                  _selectedRanges[selectedRangeCount].rangeStart = incrementDate(endDate);
                  _selectedRanges[selectedRangeCount].rangeEnd = temp;
                  selectedRangeCount += 1;
                  break;
               case 7:
                  _selectedRanges[n].rangeStart = incrementDate(endDate);
                  break;
               case 22:
                  _selectedRanges[n].rangeEnd = incrementDate(startDate,-1);
                  break;
               case 11:
                  _selectedRanges[n] = _selectedRanges[selectedRangeCount - 1];
                  _selectedRanges[selectedRangeCount - 1] = null;
                  selectedRangeCount -= 1;
            }
         }
      }
      
      mx_internal function drawDayNames() : void
      {
         var dayOfWeek:int = 0;
         var dayName:String = null;
         for(var columnIndex:int = 0; columnIndex < 7; columnIndex++)
         {
            dayOfWeek = (columnIndex + firstDayOfWeek) % 7;
            dayName = Boolean(dayNames) ? dayNames[dayOfWeek] : "";
            dayBlocksArray[columnIndex][0].text = dayName;
         }
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         var newDate:Date = null;
         var selChanged:Boolean = false;
         var date:int = Boolean(lastSelectedDate) ? int(lastSelectedDate.getDate()) : 1;
         var daysInMonth:int = getNumberOfDaysInMonth(displayedYear,displayedMonth);
         for(var i:uint = 0; i < 31; i++)
         {
            if(event.keyCode == Keyboard.LEFT)
            {
               if(date <= 1)
               {
                  return;
               }
               date--;
               selChanged = true;
            }
            else if(event.keyCode == Keyboard.RIGHT)
            {
               if(date >= daysInMonth)
               {
                  return;
               }
               date++;
               selChanged = true;
            }
            else if(event.keyCode == Keyboard.UP)
            {
               if(date <= 7)
               {
                  return;
               }
               date -= 7;
               selChanged = true;
            }
            else if(event.keyCode == Keyboard.DOWN)
            {
               if(date + 7 > daysInMonth)
               {
                  return;
               }
               date += 7;
               selChanged = true;
            }
            else if(event.keyCode == Keyboard.HOME)
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
            else if(event.keyCode == Keyboard.END)
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
            else if(Boolean(lastSelectedDate) && Boolean(event.shiftKey) && (event.keyCode == Keyboard.PAGE_UP || event.keyCode == Keyboard.PAGE_DOWN))
            {
               selChanged = true;
            }
            else if(Boolean(lastSelectedDate) && (event.keyCode == 189 || event.keyCode == 187))
            {
               selChanged = true;
            }
            if(event.keyCode >= Keyboard.PAGE_UP && event.keyCode <= Keyboard.DOWN)
            {
               event.stopPropagation();
            }
            if(selChanged)
            {
               newDate = new Date(displayedYear,displayedMonth,date);
               if(!(checkDateIsDisabled(newDate) && !event.shiftKey))
               {
                  if(!(event.shiftKey && _allowMultipleSelection))
                  {
                     selectedRangeCount = 0;
                  }
                  addToSelected(newDate,event.shiftKey && _allowMultipleSelection);
                  setSelectedIndicators();
                  dispatchChangeEvent(event);
                  return;
               }
            }
         }
      }
      
      [Inspectable(category="General",arrayType="Object")]
      public function get disabledRanges() : Array
      {
         return _disabledRanges.slice(0);
      }
      
      mx_internal function removeTodayIndicator() : void
      {
         if(Boolean(todayIndicator))
         {
            removeChild(DisplayObject(todayIndicator));
            todayIndicator = null;
         }
      }
      
      override public function set enabled(value:Boolean) : void
      {
         super.enabled = value;
         _enabled = value;
         enabledChanged = true;
         invalidateProperties();
      }
      
      public function set displayedYear(value:int) : void
      {
         if(value <= 0)
         {
            return;
         }
         if(value == _displayedYear)
         {
            return;
         }
         _proposedDisplayedYear = value;
         selectedMonthYearChanged = true;
         invalidateProperties();
      }
      
      mx_internal function addSelectionIndicator(columnIndex:int, rowIndex:int) : void
      {
         var selectionIndicatorClass:Class = null;
         var selCell:IUITextField = null;
         if(!selectionIndicator[columnIndex][rowIndex])
         {
            selectionIndicatorClass = getStyle("selectionIndicatorSkin");
            if(!selectionIndicatorClass)
            {
               selectionIndicatorClass = DateChooserIndicator;
            }
            selectionIndicator[columnIndex][rowIndex] = IFlexDisplayObject(new selectionIndicatorClass());
            if(isDateChooserIndicator(selectionIndicator[columnIndex][rowIndex]))
            {
               Object(selectionIndicator[columnIndex][rowIndex]).indicatorColor = "selectionColor";
            }
            if(selectionIndicator[columnIndex][rowIndex] is ISimpleStyleClient)
            {
               ISimpleStyleClient(selectionIndicator[columnIndex][rowIndex]).styleName = this;
            }
            addChildAt(DisplayObject(selectionIndicator[columnIndex][rowIndex]),0);
            selCell = dayBlocksArray[columnIndex][rowIndex];
            selectionIndicator[columnIndex][rowIndex].move(selCell.x,selCell.y + yOffset);
            selectionIndicator[columnIndex][rowIndex].setActualSize(cellWidth,cellHeight);
         }
         selectionIndicator[columnIndex][rowIndex].visible = true;
      }
      
      [Inspectable(category="General")]
      public function get selectableRange() : Object
      {
         return _selectableRange;
      }
      
      public function set showToday(value:Boolean) : void
      {
         if(_showToday != value)
         {
            _showToday = value;
         }
         selectedMonthYearChanged = true;
         invalidateProperties();
      }
      
      mx_internal function removeDayLabels() : void
      {
         var rowIndex:int = 0;
         for(var columnIndex:int = 0; columnIndex < 7; columnIndex++)
         {
            for(rowIndex = 0; rowIndex < 7; rowIndex++)
            {
               removeChild(dayBlocksArray[columnIndex][rowIndex]);
               dayBlocksArray[columnIndex][rowIndex] = null;
            }
         }
      }
      
      mx_internal function stepDate(deltaY:int, deltaM:int, triggerEvent:Event = null) : void
      {
         var oldYear:int = displayedYear;
         var oldMonth:int = displayedMonth;
         var newDate:Object = getNewIncrementDate(oldYear,oldMonth,deltaY,deltaM);
         var newYear:int = int(newDate.year);
         var newMonth:int = int(newDate.month);
         _displayedMonth = newMonth;
         _displayedYear = newYear;
         selectedMonthYearChanged = true;
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
      
      public function set selectedRanges(value:Array) : void
      {
         _selectedRanges = value;
         selectedRangeCount = _selectedRanges.length;
         setSelectedIndicators();
      }
      
      private function mouseOutHandler(event:MouseEvent) : void
      {
         var today:Date = null;
         if(Boolean(event.relatedObject) && event.relatedObject.parent != this)
         {
            removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
            rollOverIndicator.visible = false;
            if(todayColumn != -1 && todayRow != -1 && !disabledArrays[todayColumn][todayRow])
            {
               today = new Date();
               if(!isSelected(today))
               {
                  todayIndicator.alpha = 1;
               }
            }
         }
         else
         {
            event.stopImmediatePropagation();
         }
      }
      
      public function set firstDayOfWeek(value:int) : void
      {
         if(value < 0 || value > 6)
         {
            return;
         }
         if(value == _firstDayOfWeek)
         {
            return;
         }
         _firstDayOfWeek = value;
         dayNamesChanged = true;
         selectedMonthYearChanged = true;
         invalidateProperties();
      }
      
      mx_internal function removeSelectionIndicator(columnIndex:int, rowIndex:int) : void
      {
         if(Boolean(selectionIndicator[columnIndex][rowIndex]))
         {
            removeChild(selectionIndicator[columnIndex][rowIndex]);
            selectionIndicator[columnIndex][rowIndex] = null;
         }
      }
      
      mx_internal function getNumberOfDaysInMonth(year:int, month:int) : int
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
      
      mx_internal function addToSelected(newDate:Date, range:Boolean = false) : void
      {
         if(!selectedRangeCount)
         {
            rangeStartDate = null;
         }
         lastSelectedDate = newDate;
         if(range == false)
         {
            _selectedRanges[selectedRangeCount] = {};
            _selectedRanges[selectedRangeCount].rangeStart = new Date(newDate);
            _selectedRanges[selectedRangeCount].rangeEnd = _selectedRanges[selectedRangeCount].rangeStart;
            ++selectedRangeCount;
         }
         else
         {
            if(selectedRangeCount == 0)
            {
               _selectedRanges[0] = {};
               _selectedRanges[0].rangeStart = new Date(newDate);
            }
            else
            {
               selectedRangeCount = 1;
               if(!rangeStartDate)
               {
                  rangeStartDate = _selectedRanges[0].rangeStart;
               }
               _selectedRanges[0].rangeStart = new Date(rangeStartDate);
               if(newDate < _selectedRanges[0].rangeStart)
               {
                  _selectedRanges[0].rangeEnd = _selectedRanges[0].rangeStart;
                  _selectedRanges[0].rangeStart = new Date(newDate);
                  return;
               }
            }
            _selectedRanges[0].rangeEnd = new Date(newDate);
         }
      }
      
      mx_internal function incrementDate(value:Date, amount:int = 1) : Date
      {
         var newDate:Date = new Date(value);
         var time:Number = newDate.getTime();
         newDate.setTime(time + amount * 86400000);
         return newDate;
      }
      
      [Inspectable(category="General",defaultValue="2006")]
      public function get displayedYear() : int
      {
         return _proposedDisplayedYear == -1 ? _displayedYear : _proposedDisplayedYear;
      }
      
      public function set fontContext(moduleFactory:IFlexModuleFactory) : void
      {
         this.moduleFactory = moduleFactory;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var weekDayStyleName:Object = null;
         var i:int = 0;
         var allStyles:Boolean = !styleProp || styleProp == "styleName";
         if(allStyles || styleProp == "todayStyleName")
         {
            selectedMonthYearChanged = true;
            invalidateProperties();
         }
         if(allStyles || styleProp == "weekDayStyleName")
         {
            weekDayStyleName = getStyle("weekDayStyleName");
            if(!weekDayStyleName)
            {
               weekDayStyleName = this;
            }
            if(Boolean(dayBlocksArray))
            {
               for(i = 0; i < 7; i++)
               {
                  if(Boolean(dayBlocksArray[i]) && Boolean(dayBlocksArray[i][0]))
                  {
                     dayBlocksArray[i][0].styleName = weekDayStyleName;
                  }
               }
            }
         }
         super.styleChanged(styleProp);
      }
      
      override protected function commitProperties() : void
      {
         var childIndex:int = 0;
         var o:int = 0;
         var r:int = 0;
         var proposedDate:Date = null;
         super.commitProperties();
         if(hasFontContextChanged() && todayIndicator != null)
         {
            removeSelectionIndicators();
            childIndex = getChildIndex(DisplayObject(todayIndicator));
            removeTodayIndicator();
            createTodayIndicator(childIndex);
            childIndex = getChildIndex(dayBlocksArray[0][0]);
            removeDayLabels();
            createDayLabels(childIndex);
            enabledChanged = true;
            dayNamesChanged = true;
            selectedMonthYearChanged = true;
         }
         if(enabledChanged)
         {
            enabledChanged = false;
            for(o = 0; o < 7; o++)
            {
               for(r = 0; r < 7; r++)
               {
                  dayBlocksArray[o][r].enabled = _enabled;
                  disabledArrays[o][r] = _enabled;
               }
            }
            if(!_enabled)
            {
               if(Boolean(todayIndicator))
               {
                  todayIndicator.alpha = 0.3;
               }
               removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
               removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
               removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
               removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
            }
            else
            {
               if(Boolean(todayIndicator))
               {
                  todayIndicator.alpha = 1;
               }
               selectedMonthYearChanged = true;
               addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
               addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
               addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
               addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
            }
         }
         if(dayNamesChanged)
         {
            dayNamesChanged = false;
            drawDayNames();
         }
         if(selectedMonthYearChanged)
         {
            selectedMonthYearChanged = false;
            proposedDate = new Date(_proposedDisplayedYear == -1 ? _displayedYear : _proposedDisplayedYear,_proposedDisplayedMonth == -1 ? _displayedMonth : _proposedDisplayedMonth);
            if(isDateInRange(proposedDate,_selectableRange,selRangeMode,true))
            {
               setSelectedMonthAndYear();
            }
            _proposedDisplayedYear = -1;
            _proposedDisplayedMonth = -1;
         }
      }
      
      mx_internal function removeSelectionIndicators() : void
      {
         var rowIndex:int = 0;
         for(var columnIndex:int = 0; columnIndex < 7; columnIndex++)
         {
            for(rowIndex = 0; rowIndex < 7; rowIndex++)
            {
               removeSelectionIndicator(columnIndex,rowIndex);
            }
         }
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         dayNames = dayNamesOverride;
      }
      
      mx_internal function setSelectedMonthAndYear(monthVal:int = -1, yearVal:int = -1) : void
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
         var newMonth:int = monthVal == -1 ? displayedMonth : monthVal;
         var newYear:int = yearVal == -1 ? displayedYear : yearVal;
         enabledDaysInMonth = [];
         var offset:int = getOffsetOfMonth(newYear,newMonth);
         var daysInMonth:int = getNumberOfDaysInMonth(newYear,newMonth);
         var today:Date = new Date();
         var currentMonthContainsToday:Boolean = today.getFullYear() == newYear && today.getMonth() == newMonth;
         var previousMonth:int = Math.max(newMonth - 1,0);
         var previousMonthDate:Date = new Date(newYear,previousMonth,1);
         dayNumber = getNumberOfDaysInMonth(previousMonthDate.getFullYear(),previousMonthDate.getMonth());
         rowIndex = 1;
         for(columnIndex = 0; columnIndex < offset; columnIndex++)
         {
            dayBlocksArray[columnIndex][rowIndex].text = "";
            disabledArrays[columnIndex][rowIndex] = true;
            removeSelectionIndicator(columnIndex,rowIndex);
         }
         for(dayNumber = 1; dayNumber <= daysInMonth; dayNumber++)
         {
            cellDate = new Date(newYear,newMonth,dayNumber);
            i = offset + dayNumber - 1;
            columnIndex = i % 7;
            rowIndex = 1 + Math.floor(i / 7);
            todayLabel = dayBlocksArray[columnIndex][rowIndex];
            todayLabel.text = dayNumber.toString();
            if(_enabled)
            {
               disabledArrays[columnIndex][rowIndex] = false;
               todayLabel.enabled = true;
            }
            if(!todayLabel.styleName)
            {
               todayLabel.styleName = this;
            }
            if(currentMonthContainsToday && cellDate.getDate() == today.getDate() && _showToday)
            {
               todayRow = rowIndex;
               todayColumn = columnIndex;
               displayTodayInCurrentMonth = true;
               todayIndicator.visible = _showToday;
               todayLabel.styleName = getStyle("todayStyleName");
               todayIndicator.move(todayLabel.x,todayLabel.y + yOffset);
               todaysLabelReference = todayLabel;
            }
            else if(!displayTodayInCurrentMonth)
            {
               if(Boolean(todaysLabelReference))
               {
                  todaysLabelReference.styleName = this;
               }
               todayIndicator.visible = false;
            }
            if(Boolean(_selectableRange))
            {
               if(!isDateInRange(cellDate,_selectableRange,selRangeMode))
               {
                  todayLabel.enabled = false;
                  disabledArrays[columnIndex][rowIndex] = true;
               }
            }
            if(_disabledRanges.length > 0)
            {
               for(dRanges = 0; dRanges < _disabledRanges.length; dRanges++)
               {
                  if(isDateInRange(cellDate,_disabledRanges[dRanges],disabledRangeMode[dRanges]))
                  {
                     todayLabel.enabled = false;
                     disabledArrays[columnIndex][rowIndex] = true;
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
            enabledDaysInMonth.push(valToPush);
         }
         dayNumber = 1;
         for(i = offset + daysInMonth; i < 42; i++)
         {
            columnIndex = i % 7;
            rowIndex = 1 + Math.floor(i / 7);
            dayBlocksArray[columnIndex][rowIndex].text = "";
            disabledArrays[columnIndex][rowIndex] = true;
            removeSelectionIndicator(columnIndex,rowIndex);
         }
         if(_disabledDays.length > 0)
         {
            for(i = 0; i < _disabledDays.length; i++)
            {
               if(_disabledDays[i] >= 0 && _disabledDays[i] <= 6 && _disabledDays[i] != -1)
               {
                  columnIndex = (7 + _disabledDays[i] - _firstDayOfWeek) % 7;
                  for(rowIndex = 1; rowIndex < 7; rowIndex++)
                  {
                     disabledArrays[columnIndex][rowIndex] = true;
                     tempCalcDate = Number(dayBlocksArray[columnIndex][rowIndex].text);
                     if(!isNaN(tempCalcDate))
                     {
                        tempOffset = offset + tempCalcDate % 7;
                        enabledDaysInMonth[tempCalcDate - 1] = null;
                     }
                     dayBlocksArray[columnIndex][rowIndex].enabled = false;
                  }
               }
            }
         }
         _displayedMonth = newMonth;
         _displayedYear = newYear;
         displayDate = new Date(newYear,newMonth,1);
         todayIndicator.alpha = Boolean(todaysLabelReference) ? (todaysLabelReference.enabled == false ? 0.3 : 1) : 1;
         setSelectedIndicators();
         invalidateDisplayList();
      }
      
      public function set allowDisjointSelection(value:Boolean) : void
      {
         _allowDisjointSelection = value;
      }
      
      public function set disabledRanges(value:Array) : void
      {
         _disabledRanges = value.slice(0);
         disabledRangeMode = [];
         for(var i:int = 0; i < _disabledRanges.length; i++)
         {
            if(_disabledRanges[i] is Date)
            {
               disabledRangeMode[i] = 4;
               _disabledRanges[i] = new Date(value[i].getFullYear(),value[i].getMonth(),value[i].getDate());
            }
            else if(_disabledRanges[i] is Object)
            {
               _disabledRanges[i] = {};
               _disabledRanges[i] = value[i];
               if(!_disabledRanges[i].rangeStart && Boolean(_disabledRanges[i].rangeEnd))
               {
                  disabledRangeMode[i] = 3;
               }
               else if(Boolean(_disabledRanges[i].rangeStart) && !_disabledRanges[i].rangeEnd)
               {
                  disabledRangeMode[i] = 2;
               }
               else if(Boolean(_disabledRanges[i].rangeStart) && Boolean(_disabledRanges[i].rangeEnd))
               {
                  disabledRangeMode[i] = 1;
               }
            }
         }
         selectedMonthYearChanged = true;
         invalidateProperties();
         var selRange:Array = selectedRanges;
      }
      
      mx_internal function isSelected(newDate:Date) : Boolean
      {
         for(var i:int = 0; i < selectedRangeCount; i++)
         {
            if(newDate >= _selectedRanges[i].rangeStart && newDate <= _selectedRanges[i].rangeEnd)
            {
               return true;
            }
         }
         return false;
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get allowDisjointSelection() : Boolean
      {
         return _allowDisjointSelection;
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get selectedDate() : Date
      {
         return Boolean(selectedRangeCount) ? _selectedRanges[0].rangeStart : null;
      }
      
      public function set selectedDate(value:Date) : void
      {
         selectedRangeCount = 0;
         if(Boolean(value) && !checkDateIsDisabled(value))
         {
            addToSelected(value);
            _displayedMonth = value.getMonth();
            _displayedYear = value.getFullYear();
            selectedMonthYearChanged = true;
            invalidateProperties();
         }
         else
         {
            setSelectedIndicators();
         }
      }
      
      public function set disabledDays(value:Array) : void
      {
         _disabledDays = value.slice(0);
         selectedMonthYearChanged = true;
         invalidateProperties();
         var selRange:Array = selectedRanges;
      }
      
      mx_internal function createTodayIndicator(childIndex:int) : void
      {
         var todayIndicatorClass:Class = null;
         if(!todayIndicator)
         {
            todayIndicatorClass = getStyle("todayIndicatorSkin");
            if(!todayIndicatorClass)
            {
               todayIndicatorClass = DateChooserIndicator;
            }
            todayIndicator = IFlexDisplayObject(new todayIndicatorClass());
            if(isDateChooserIndicator(todayIndicator))
            {
               Object(todayIndicator).indicatorColor = "todayColor";
            }
            if(todayIndicator is ISimpleStyleClient)
            {
               ISimpleStyleClient(todayIndicator).styleName = this;
            }
            addChildAt(DisplayObject(todayIndicator),childIndex);
            todayIndicator.visible = false;
         }
      }
      
      [Inspectable(category="General",arrayType="int")]
      public function get disabledDays() : Array
      {
         var result:Array = [];
         var i:int = 0;
         var k:int = 0;
         while(i < _disabledDays.length)
         {
            if(_disabledDays[i] >= 0 && _disabledDays[i] <= 6)
            {
               result[k] = _disabledDays[i];
               k++;
            }
            i++;
         }
         return result;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var rowIndex:int = 0;
         var label:IUITextField = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var paddingLeft:Number = getStyle("paddingLeft");
         var paddingRight:Number = getStyle("paddingRight");
         var paddingBottom:Number = getStyle("paddingBottom");
         var paddingTop:Number = getStyle("paddingTop");
         var blockX:Number = paddingLeft;
         cellWidth = Math.max((unscaledWidth - (paddingLeft + paddingRight)) / 7,4);
         cellHeight = Math.max((unscaledHeight - paddingBottom) / 7,4);
         var labelPosition:Number = paddingTop;
         rollOverIndicator.setActualSize(cellWidth,cellHeight);
         todayIndicator.setActualSize(cellWidth,cellHeight);
         for(var columnIndex:int = 0; columnIndex < 7; columnIndex++)
         {
            for(rowIndex = 0; rowIndex < 7; rowIndex++)
            {
               label = dayBlocksArray[columnIndex][rowIndex];
               if(rowIndex == 0)
               {
                  labelPosition = paddingTop;
               }
               else
               {
                  labelPosition += cellHeight;
               }
               label.setActualSize(cellWidth,cellHeight);
               label.move(blockX,labelPosition);
               if(Boolean(selectionIndicator[columnIndex][rowIndex]))
               {
                  selectionIndicator[columnIndex][rowIndex].setActualSize(cellWidth,cellHeight);
                  selectionIndicator[columnIndex][rowIndex].move(blockX,labelPosition + yOffset);
               }
            }
            blockX += cellWidth;
         }
         drawDayNames();
         setSelectedMonthAndYear();
      }
      
      mx_internal function dispatchChangeEvent(triggerEvent:Event = null) : void
      {
         var change:CalendarLayoutChangeEvent = new CalendarLayoutChangeEvent(CalendarLayoutChangeEvent.CHANGE);
         change.newDate = lastSelectedDate;
         change.triggerEvent = triggerEvent;
         dispatchEvent(change);
      }
   }
}

