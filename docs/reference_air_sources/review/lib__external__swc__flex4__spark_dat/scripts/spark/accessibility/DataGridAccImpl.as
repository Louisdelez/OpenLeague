package spark.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import mx.accessibility.AccConst;
   import mx.collections.IList;
   import mx.core.UIComponent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import spark.components.DataGrid;
   import spark.components.gridClasses.GridSelectionMode;
   import spark.events.GridCaretEvent;
   import spark.events.GridItemEditorEvent;
   import spark.events.GridSelectionEvent;
   import spark.events.GridSelectionEventKind;
   
   public class DataGridAccImpl extends ListBaseAccImpl
   {
      
      private static var dgAccInfo:ItemAccInfo;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function DataGridAccImpl(master:UIComponent)
      {
         super(master);
         if(!dgAccInfo)
         {
            dgAccInfo = new ItemAccInfo();
         }
      }
      
      public static function enableAccessibility() : void
      {
         DataGrid.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         var accImpl:DataGridAccImpl = new DataGridAccImpl(component);
         DataGrid(component).focusOwner.accessibilityImplementation = accImpl;
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat([GridSelectionEvent.SELECTION_CHANGE,FocusEvent.FOCUS_IN,GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_START,GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_SAVE,GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_CANCEL]);
      }
      
      override public function get_accRole(childID:uint) : uint
      {
         if(childID == 0)
         {
            return role;
         }
         dgAccInfo.setup(master,childID);
         if(dgAccInfo.isInvalid || !dgAccInfo.dataGrid.columns)
         {
            return null;
         }
         if(dgAccInfo.isColumnHeader)
         {
            return AccConst.ROLE_SYSTEM_COLUMNHEADER;
         }
         return AccConst.ROLE_SYSTEM_LISTITEM;
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var isSelected:Boolean = false;
         var accState:uint = uint(getState(childID));
         if(childID == 0 && DataGrid(master).focusOwner == UIComponent(master).getFocus())
         {
            accState |= AccConst.STATE_SYSTEM_FOCUSED;
         }
         if(int(childID) <= 0)
         {
            return accState;
         }
         dgAccInfo.setup(master,childID);
         if(!dgAccInfo.dataGrid.columns)
         {
            return accState;
         }
         if(dgAccInfo.isInvalid)
         {
            return accState;
         }
         if(dgAccInfo.isColumnHeader)
         {
            if(Boolean(dgAccInfo.dataGrid.columnHeaderGroup) && !dgAccInfo.dataGrid.columnHeaderGroup.getHeaderRendererAt(dgAccInfo.columnIndex).visible)
            {
               accState |= AccConst.STATE_SYSTEM_OFFSCREEN;
            }
            return accState & ~(AccConst.STATE_SYSTEM_FOCUSABLE | AccConst.STATE_SYSTEM_SELECTABLE | AccConst.STATE_SYSTEM_FOCUSED | AccConst.STATE_SYSTEM_SELECTED);
         }
         if(childID == this.get_accFocus())
         {
            accState |= AccConst.STATE_SYSTEM_FOCUSED;
         }
         dgAccInfo.setup(master,childID);
         var mode:String = dgAccInfo.dataGrid.selectionMode;
         if(mode != GridSelectionMode.NONE)
         {
            accState |= AccConst.STATE_SYSTEM_SELECTABLE;
            if(dgAccInfo.isMultiSelect)
            {
               accState |= AccConst.STATE_SYSTEM_MULTISELECTABLE;
            }
         }
         if(dgAccInfo.isCellMode)
         {
            isSelected = dgAccInfo.dataGrid.selectionContainsCell(dgAccInfo.rowIndex,dgAccInfo.columnIndex);
         }
         else
         {
            isSelected = dgAccInfo.dataGrid.selectionContainsIndex(dgAccInfo.rowIndex);
         }
         if(isSelected)
         {
            accState |= AccConst.STATE_SYSTEM_SELECTED;
         }
         var rowIndex:int = dgAccInfo.rowIndex;
         var columnIndex:int = dgAccInfo.columnIndex;
         if(!dgAccInfo.isCellMode)
         {
            columnIndex = -1;
         }
         if(!dgAccInfo.dataGrid.grid.isCellVisible(rowIndex,columnIndex))
         {
            accState |= AccConst.STATE_SYSTEM_OFFSCREEN;
         }
         return accState;
      }
      
      override public function get_accDefaultAction(childID:uint) : String
      {
         if(this.get_accRole(childID) == AccConst.ROLE_SYSTEM_COLUMNHEADER)
         {
            return "Click";
         }
         return super.get_accDefaultAction(childID);
      }
      
      override public function accDoDefaultAction(childID:uint) : void
      {
         var columnIndices:Vector.<int> = null;
         dgAccInfo.setup(master,childID);
         if(!dgAccInfo.dataGrid.columns || dgAccInfo.isInvalid)
         {
            return;
         }
         if(dgAccInfo.isColumnHeader)
         {
            if(dgAccInfo.dataGrid.sortableColumns && Boolean(dgAccInfo.dataGrid.columns.getItemAt(dgAccInfo.columnIndex).sortable))
            {
               columnIndices = Vector.<int>([dgAccInfo.columnIndex]);
               dgAccInfo.dataGrid.sortByColumns(columnIndices);
               dgAccInfo.dataGrid.columnHeaderGroup.visibleSortIndicatorIndices = columnIndices;
            }
            return;
         }
         this.accSelect(AccConst.SELFLAG_TAKESELECTION | AccConst.SELFLAG_TAKEFOCUS,childID);
      }
      
      override public function getChildIDArray() : Array
      {
         dgAccInfo.setup(master,0);
         if(!dgAccInfo.dataGrid.columns)
         {
            return null;
         }
         return createChildIDArray(dgAccInfo.maxChildID);
      }
      
      override public function accLocation(childID:uint) : *
      {
         dgAccInfo.setup(master,childID);
         if(!dgAccInfo.dataGrid.columns)
         {
            return null;
         }
         if(dgAccInfo.isInvalid)
         {
            return null;
         }
         return dgAccInfo.boundingRect();
      }
      
      override public function get_accFocus() : uint
      {
         dgAccInfo.setup(master,0);
         if(!dgAccInfo.dataGrid.columns || !dgAccInfo.dataGrid.dataProvider)
         {
            return null;
         }
         return dgAccInfo.childIDFromRowAndColumn(dgAccInfo.dataGrid.grid.caretRowIndex,dgAccInfo.dataGrid.grid.caretColumnIndex);
      }
      
      override protected function getName(childID:uint) : String
      {
         var resourceManager:IResourceManager = null;
         var column:Object = null;
         var headerName:String = null;
         var sortColumnIndices:Vector.<int> = null;
         var sortIndex:int = 0;
         var sortString:String = null;
         var idx:int = 0;
         var c:int = 0;
         if(int(childID) <= 0)
         {
            return null;
         }
         dgAccInfo.setup(master,childID);
         if(dgAccInfo.isInvalid || !dgAccInfo.dataGrid.columns)
         {
            return null;
         }
         if(dgAccInfo.isColumnHeader)
         {
            column = dgAccInfo.dataGrid.columns.getItemAt(dgAccInfo.columnIndex);
            headerName = column.headerText;
            sortColumnIndices = dgAccInfo.dataGrid.columnHeaderGroup.visibleSortIndicatorIndices;
            sortIndex = sortColumnIndices.indexOf(dgAccInfo.columnIndex);
            if(sortIndex < 0)
            {
               return headerName;
            }
            resourceManager = ResourceManager.getInstance();
            if(Boolean(column.sortDescending))
            {
               sortString = resourceManager.getString("components","sortedDescending");
            }
            else
            {
               sortString = resourceManager.getString("components","sortedAscending");
            }
            if(sortColumnIndices.length > 1)
            {
               sortString += resourceManager.getString("components","sortLevel").replace("%1",String(sortIndex + 1));
            }
            return headerName + " " + sortString;
         }
         if(!dgAccInfo.dataGrid.dataProvider)
         {
            return null;
         }
         var rowString:String = this.makeRowString(dgAccInfo);
         var name:String = "";
         var rowObject:Object = dgAccInfo.dataGrid.dataProvider.getItemAt(dgAccInfo.rowIndex);
         var columns:IList = dgAccInfo.dataGrid.columns;
         if(dgAccInfo.isCellMode)
         {
            if(dgAccInfo.headerCount > 0)
            {
               name = columns.getItemAt(dgAccInfo.columnIndex).headerText + ": ";
            }
            name += this.cellName(rowObject,dgAccInfo.columnIndex);
         }
         else if(Boolean(rowObject))
         {
            idx = -1;
            for(c = 0; c < dgAccInfo.reachableColumnCount; c++)
            {
               if(c > 0)
               {
                  name += ", ";
               }
               idx = dgAccInfo.dataGrid.grid.getNextVisibleColumnIndex(idx);
               if(dgAccInfo.headerCount > 0)
               {
                  name += columns.getItemAt(idx).headerText + ": ";
               }
               name += columns.getItemAt(idx).itemToLabel(rowObject);
            }
         }
         if(Boolean(rowString))
         {
            name += ", " + rowString;
         }
         return name;
      }
      
      override public function accSelect(selFlag:uint, childID:uint) : void
      {
         var focusedID:uint = 0;
         var anchorRowIndex:int = 0;
         var anchorColumnIndex:int = 0;
         var adding:Boolean = false;
         dgAccInfo.setup(master,childID);
         if(dgAccInfo.isColumnHeader || dgAccInfo.isInvalid)
         {
            return;
         }
         if(selFlag == AccConst.SELFLAG_TAKEFOCUS)
         {
            selFlag = uint(AccConst.SELFLAG_TAKESELECTION);
         }
         else if(Boolean(selFlag & AccConst.SELFLAG_TAKEFOCUS))
         {
            selFlag -= AccConst.SELFLAG_TAKEFOCUS;
         }
         var settingFocus:Boolean = Boolean(selFlag & AccConst.SELFLAG_TAKEFOCUS);
         if(settingFocus)
         {
            selFlag -= AccConst.SELFLAG_TAKEFOCUS;
         }
         var rowIndex:int = dgAccInfo.rowIndex;
         var columnIndex:int = dgAccInfo.columnIndex;
         if(!dgAccInfo.isCellMode)
         {
            columnIndex = -1;
         }
         var grid:DataGrid = dgAccInfo.dataGrid;
         grid.ensureCellIsVisible(rowIndex,columnIndex);
         if(selFlag == AccConst.SELFLAG_TAKESELECTION)
         {
            if(columnIndex == -1)
            {
               grid.setSelectedIndex(rowIndex);
            }
            else
            {
               grid.setSelectedCell(rowIndex,columnIndex);
            }
         }
         else if(selFlag == AccConst.SELFLAG_ADDSELECTION)
         {
            if(columnIndex == -1)
            {
               grid.addSelectedIndex(rowIndex);
            }
            else
            {
               grid.addSelectedCell(rowIndex,columnIndex);
            }
         }
         else if(selFlag == AccConst.SELFLAG_REMOVESELECTION)
         {
            if(columnIndex == -1)
            {
               grid.removeSelectedIndex(rowIndex);
            }
            else
            {
               grid.removeSelectedCell(rowIndex,columnIndex);
            }
         }
         else if(Boolean(selFlag & AccConst.SELFLAG_EXTENDSELECTION))
         {
            if(Boolean(selFlag & AccConst.SELFLAG_ADDSELECTION) && Boolean(selFlag & AccConst.SELFLAG_REMOVESELECTION))
            {
               return;
            }
            focusedID = this.get_accFocus();
            if(!focusedID)
            {
               return;
            }
            dgAccInfo.setup(master,focusedID);
            if(dgAccInfo.isColumnHeader || dgAccInfo.isInvalid)
            {
               return;
            }
            anchorRowIndex = dgAccInfo.rowIndex;
            anchorColumnIndex = dgAccInfo.columnIndex;
            if(Boolean(selFlag & AccConst.SELFLAG_ADDSELECTION))
            {
               adding = true;
            }
            else if(Boolean(selFlag & AccConst.SELFLAG_REMOVESELECTION))
            {
               adding = false;
            }
            else
            {
               adding = Boolean(this.get_accState(focusedID) & AccConst.STATE_SYSTEM_SELECTED);
            }
            if(columnIndex == -1)
            {
               grid.selectIndices(Math.min(anchorRowIndex,rowIndex),Math.abs(rowIndex - anchorRowIndex) + 1);
            }
            else
            {
               grid.selectCellRegion(Math.min(anchorRowIndex,rowIndex),Math.min(anchorColumnIndex,columnIndex),Math.abs(rowIndex - anchorRowIndex) + 1,Math.abs(columnIndex - anchorColumnIndex) + 1);
            }
         }
         if(settingFocus)
         {
            grid.grid.caretRowIndex = rowIndex;
         }
         grid.grid.caretColumnIndex = columnIndex;
      }
      
      override public function get_accSelection() : Array
      {
         var i:int = 0;
         var n:int = 0;
         var items:Object = null;
         var accSelection:Array = [];
         dgAccInfo.setup(master,0);
         if(!dgAccInfo.dataGrid.columns)
         {
            return null;
         }
         if(dgAccInfo.isCellMode)
         {
            items = dgAccInfo.dataGrid.selectedCells;
            n = int(items.length);
            for(i = 0; i < n; i++)
            {
               accSelection[i] = items[i].rowIndex * dgAccInfo.reachableColumnCount + items[i].columnIndex + dgAccInfo.headerCount + 1;
            }
         }
         else
         {
            items = dgAccInfo.dataGrid.selectedIndices;
            n = int(items.length);
            for(i = 0; i < n; i++)
            {
               accSelection[i] = items[i] + dgAccInfo.headerCount + 1;
            }
         }
         return accSelection;
      }
      
      override protected function eventHandler(event:Event) : void
      {
         var childID:uint = 0;
         var gridSelectionEvent:GridSelectionEvent = null;
         var eventID:int = 0;
         var kind:String = null;
         var editor:Object = null;
         var defaultGridItemEditorClass:Class = null;
         var realEditor:UIComponent = null;
         var edName:String = null;
         var rowString:String = null;
         var columns:IList = null;
         var columnIndex:int = 0;
         $eventHandler(event);
         dgAccInfo.setup(master,0);
         if(!dgAccInfo.dataGrid.columns)
         {
            return;
         }
         switch(event.type)
         {
            case GridCaretEvent.CARET_CHANGE:
               childID = dgAccInfo.childIDFromRowAndColumn(int(GridCaretEvent(event).newRowIndex),int(GridCaretEvent(event).newColumnIndex));
               if(int(childID) > 0)
               {
                  if(!dgAccInfo.dataGrid.itemEditorInstance)
                  {
                     Accessibility.sendEvent(dgAccInfo.dataGrid.focusOwner,childID,AccConst.EVENT_OBJECT_FOCUS);
                  }
                  else
                  {
                     Accessibility.sendEvent(UIComponent(dgAccInfo.dataGrid.itemEditorInstance),0,AccConst.EVENT_OBJECT_FOCUS);
                  }
               }
               break;
            case GridSelectionEvent.SELECTION_CHANGE:
               gridSelectionEvent = GridSelectionEvent(event);
               childID = dgAccInfo.childIDFromRowAndColumn(gridSelectionEvent.selectionChange.rowIndex,gridSelectionEvent.selectionChange.columnIndex);
               if(int(childID) <= 0)
               {
                  return;
               }
               eventID = int(AccConst.EVENT_OBJECT_SELECTION);
               kind = gridSelectionEvent.kind;
               if(kind == GridSelectionEventKind.ADD_CELL || kind == GridSelectionEventKind.ADD_ROW)
               {
                  eventID = int(AccConst.EVENT_OBJECT_SELECTIONADD);
               }
               else if(kind == GridSelectionEventKind.REMOVE_CELL || kind == GridSelectionEventKind.REMOVE_ROW)
               {
                  eventID = int(AccConst.EVENT_OBJECT_SELECTIONREMOVE);
               }
               else if(kind == GridSelectionEventKind.CLEAR_SELECTION || kind == GridSelectionEventKind.SELECT_ALL || kind == GridSelectionEventKind.SET_CELL_REGION || kind == GridSelectionEventKind.SET_ROWS)
               {
                  eventID = int(AccConst.EVENT_OBJECT_SELECTIONWITHIN);
               }
               Accessibility.sendEvent(dgAccInfo.dataGrid.focusOwner,childID,eventID);
               break;
            case FocusEvent.FOCUS_IN:
               if(event.target == DataGrid(master).focusOwner)
               {
                  Accessibility.sendEvent(DataGrid(master).focusOwner,0,AccConst.EVENT_OBJECT_FOCUS);
               }
               break;
            case GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_START:
               dgAccInfo.setup(master,0);
               childID = dgAccInfo.childIDFromRowAndColumn(GridItemEditorEvent(event).rowIndex,GridItemEditorEvent(event).columnIndex);
               editor = event.currentTarget.itemEditorInstance;
               defaultGridItemEditorClass = Class(getDefinition("spark.components.gridClasses.DefaultGridItemEditor",master.moduleFactory));
               if(editor is defaultGridItemEditorClass)
               {
                  try
                  {
                     editor = Object(editor).textArea;
                  }
                  catch(e:Error)
                  {
                  }
               }
               else
               {
                  realEditor = null;
                  try
                  {
                     realEditor = UIComponent(editor.stage.focus);
                  }
                  catch(e:Error)
                  {
                  }
                  if(Boolean(realEditor) && editor != realEditor)
                  {
                     editor = realEditor;
                  }
               }
               if(!editor.accessibilityName)
               {
                  edName = "";
                  if(dgAccInfo.headerCount > 0)
                  {
                     columns = dgAccInfo.dataGrid.columns;
                     columnIndex = GridItemEditorEvent(event).columnIndex;
                     edName += columns.getItemAt(columnIndex).headerText;
                  }
                  dgAccInfo.setup(master,childID);
                  rowString = this.makeRowString(dgAccInfo);
                  if(Boolean(rowString))
                  {
                     edName += " " + rowString;
                  }
                  editor.accessibilityName = edName;
                  Accessibility.updateProperties();
               }
               Accessibility.sendEvent(UIComponent(editor),0,AccConst.EVENT_OBJECT_FOCUS);
               break;
            case GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_SAVE,GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_CANCEL:
               dgAccInfo.setup(master,0);
               childID = dgAccInfo.childIDFromRowAndColumn(GridItemEditorEvent(event).rowIndex,GridItemEditorEvent(event).columnIndex);
               Accessibility.sendEvent(DataGrid(master).focusOwner,childID,AccConst.EVENT_OBJECT_FOCUS);
         }
      }
      
      private function makeRowString(dgAccInfo:ItemAccInfo) : String
      {
         var resourceManager:IResourceManager = null;
         var rowString:String = "";
         if(dgAccInfo.isCellMode && dgAccInfo.reachableColumnIndex == 0 || !dgAccInfo.isCellMode)
         {
            resourceManager = ResourceManager.getInstance();
            rowString = resourceManager.getString("components","rowMofN");
            rowString = rowString.replace("%1",dgAccInfo.reachableRowIndex + 1).replace("%2",dgAccInfo.reachableRowCount);
         }
         return rowString;
      }
      
      private function cellName(rowObject:Object, columnIndex:int) : String
      {
         var item:Object = rowObject;
         var dataGrid:DataGrid = DataGrid(master);
         var columns:IList = dataGrid.columns;
         if(!columns)
         {
            return null;
         }
         var column:Object = columns.getItemAt(columnIndex);
         if(!column)
         {
            return null;
         }
         return column.itemToLabel(rowObject);
      }
   }
}

import flash.geom.Point;
import flash.geom.Rectangle;
import mx.core.UIComponent;
import spark.components.DataGrid;
import spark.components.gridClasses.GridSelectionMode;

class ItemAccInfo
{
   
   public var master:UIComponent;
   
   public var childID:uint;
   
   public var dataGrid:DataGrid;
   
   public var columnCount:int;
   
   public var headerCount:int;
   
   public var rowCount:int;
   
   public var reachableColumnCount:int;
   
   public var reachableHeaderCount:int;
   
   public var reachableRowCount:int;
   
   protected var reachableRowIndices:Vector.<int>;
   
   protected var reachableColumnIndices:Vector.<int>;
   
   public var maxChildID:int;
   
   public var isCellMode:Boolean;
   
   public var isMultiSelect:Boolean;
   
   public var isInvalid:Boolean;
   
   public var isColumnHeader:Boolean;
   
   public var reachableColumnIndex:int;
   
   public var reachableRowIndex:int;
   
   public var columnIndex:int;
   
   public var rowIndex:int;
   
   public function ItemAccInfo()
   {
      super();
   }
   
   public function setup(master:UIComponent, childID:uint) : void
   {
      var somethingIsInvisible:Boolean = false;
      var column:Object = null;
      var i:int = 0;
      this.master = master;
      this.childID = childID;
      this.dataGrid = DataGrid(master);
      this.reachableRowIndices = null;
      this.reachableColumnIndices = null;
      if(Boolean(this.dataGrid.columns))
      {
         this.columnCount = this.dataGrid.columns.length;
         somethingIsInvisible = false;
         for(i = 0; i < this.columnCount; i++)
         {
            column = this.dataGrid.columns.getItemAt(i);
            if(!column.visible)
            {
               somethingIsInvisible = true;
               break;
            }
         }
         if(somethingIsInvisible)
         {
            this.reachableColumnIndices = new Vector.<int>();
            for(i = 0; i < this.columnCount; i++)
            {
               column = this.dataGrid.columns.getItemAt(i);
               if(Boolean(column.visible))
               {
                  this.reachableColumnIndices.push(column.columnIndex);
               }
            }
         }
         this.reachableColumnCount = this.reachableColumnIndices == null ? int(this.columnCount) : int(this.reachableColumnIndices.length);
      }
      else
      {
         this.columnCount = 0;
         this.reachableColumnCount = 0;
      }
      if(Boolean(this.dataGrid.dataProvider))
      {
         this.rowCount = this.dataGrid.dataProvider.length;
         this.reachableRowCount = this.reachableRowIndices == null ? int(this.rowCount) : int(this.reachableRowIndices.length);
      }
      else
      {
         this.rowCount = 0;
         this.reachableRowCount = 0;
      }
      this.headerCount = 0;
      this.reachableHeaderCount = 0;
      this.maxChildID = 0;
      this.isCellMode = false;
      this.isMultiSelect = false;
      this.isInvalid = false;
      this.isColumnHeader = false;
      this.rowIndex = 0;
      this.columnIndex = 0;
      this.reachableRowIndex = 0;
      this.reachableColumnIndex = 0;
      var itemIndex:int = childID - 1;
      if(Boolean(this.dataGrid.columnHeaderGroup) && Boolean(this.dataGrid.columnHeaderGroup.visible))
      {
         itemIndex -= this.reachableColumnCount;
         this.headerCount = this.columnCount;
         this.reachableHeaderCount = this.reachableColumnCount;
      }
      else
      {
         this.headerCount = 0;
         this.reachableHeaderCount = 0;
      }
      var mode:String = this.dataGrid.selectionMode;
      this.isCellMode = mode == GridSelectionMode.SINGLE_CELL || mode == GridSelectionMode.MULTIPLE_CELLS;
      this.isMultiSelect = mode == GridSelectionMode.MULTIPLE_CELLS || mode == GridSelectionMode.MULTIPLE_ROWS;
      this.maxChildID = 0;
      this.maxChildID += this.reachableHeaderCount;
      if(this.isCellMode)
      {
         this.maxChildID += this.reachableRowCount * this.reachableColumnCount;
      }
      else
      {
         this.maxChildID += this.reachableRowCount;
      }
      this.isColumnHeader = false;
      this.isInvalid = false;
      if(this.childIDOutOfBounds(childID))
      {
         this.isInvalid = true;
         this.reachableColumnIndex = -1;
         this.reachableRowIndex = -1;
         itemIndex = -1;
      }
      else if(itemIndex < 0)
      {
         this.isColumnHeader = true;
         this.reachableColumnIndex = itemIndex + this.reachableColumnCount;
         this.reachableRowIndex = -1;
         itemIndex = -1;
      }
      else if(this.isCellMode)
      {
         this.reachableRowIndex = Math.floor(itemIndex / this.reachableColumnCount);
         this.reachableColumnIndex = itemIndex % this.reachableColumnCount;
      }
      else
      {
         this.reachableRowIndex = itemIndex;
         this.reachableColumnIndex = 0;
      }
      this.rowIndex = this.reachableRowIndex;
      this.columnIndex = this.reachableColumnIndex;
      if(Boolean(this.reachableRowIndex >= 0) && Boolean(this.reachableRowIndices) && Boolean(this.reachableRowIndices.length))
      {
         this.rowIndex = this.reachableRowIndices[this.reachableRowIndex];
      }
      if(Boolean(this.reachableColumnIndex >= 0) && Boolean(this.reachableColumnIndices) && Boolean(this.reachableColumnIndices.length))
      {
         this.columnIndex = this.reachableColumnIndices[this.reachableColumnIndex];
      }
   }
   
   protected function childIDFromReachableRowAndColumn(reachableRowIndex:int, reachableColumnIndex:int) : uint
   {
      var childID:int = this.reachableHeaderCount + 1;
      if(reachableRowIndex < 0)
      {
         childID = 0;
      }
      else if(this.isCellMode)
      {
         if(reachableColumnIndex < 0)
         {
            childID = 0;
         }
         else
         {
            childID += reachableRowIndex * this.reachableColumnCount + reachableColumnIndex;
         }
      }
      else
      {
         childID += reachableRowIndex;
      }
      return uint(childID);
   }
   
   public function childIDFromRowAndColumn(rowIndex:int, columnIndex:int) : uint
   {
      return this.childIDFromReachableRowAndColumn(this.reachableRowIndices == null ? rowIndex : int(this.reachableRowIndices.indexOf(rowIndex)),this.reachableColumnIndices == null ? columnIndex : int(this.reachableColumnIndices.indexOf(columnIndex)));
   }
   
   private function childIDOutOfBounds(childID:int) : Boolean
   {
      if(int(childID) <= 0)
      {
         return true;
      }
      if(!this.dataGrid.dataProvider || !this.dataGrid.columns)
      {
         return true;
      }
      if(childID > this.maxChildID)
      {
         return true;
      }
      return false;
   }
   
   public function boundingRect() : Object
   {
      var result:Object = null;
      var r1:Object = null;
      var r2:Object = null;
      var xy:Point = null;
      if(!this.isColumnHeader && (this.rowIndex < 0 || this.rowIndex >= this.rowCount))
      {
         return null;
      }
      if(Boolean(this.isCellMode) && (this.columnIndex < 0 || this.columnIndex >= this.columnCount))
      {
         return null;
      }
      var vri:Vector.<int> = this.dataGrid.grid.getVisibleRowIndices();
      var vci:Vector.<int> = this.dataGrid.grid.getVisibleColumnIndices();
      if(Boolean(this.isColumnHeader) && vci.indexOf(this.columnIndex) < 0)
      {
         return null;
      }
      if(!this.isColumnHeader && vri.indexOf(this.rowIndex) < 0 || Boolean(this.isCellMode) && vci.indexOf(this.columnIndex) < 0)
      {
         return null;
      }
      if(this.isColumnHeader)
      {
         result = this.dataGrid.columnHeaderGroup.getHeaderRendererAt(this.columnIndex);
      }
      else if(this.isCellMode)
      {
         result = this.dataGrid.grid.getItemRendererAt(this.rowIndex,this.columnIndex);
      }
      else
      {
         r1 = this.dataGrid.grid.getItemRendererAt(this.rowIndex,vci[0]);
         r2 = this.dataGrid.grid.getItemRendererAt(this.rowIndex,vci[vci.length - 1]);
         xy = new Point(r1.getLayoutBoundsX(),r1.getLayoutBoundsY());
         xy = this.dataGrid.grid.localToGlobal(xy);
         xy = this.dataGrid.globalToLocal(xy);
         result = new Rectangle(xy.x,xy.y,r2.getLayoutBoundsX() + r2.getLayoutBoundsWidth() - r1.getLayoutBoundsX(),r1.getLayoutBoundsHeight());
      }
      return result;
   }
}
