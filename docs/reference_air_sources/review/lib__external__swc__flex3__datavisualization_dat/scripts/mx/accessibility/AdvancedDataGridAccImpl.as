package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import mx.collections.CursorBookmark;
   import mx.collections.ICollectionView;
   import mx.collections.IHierarchicalCollectionView;
   import mx.collections.IViewCursor;
   import mx.controls.AdvancedDataGrid;
   import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
   import mx.controls.advancedDataGridClasses.AdvancedDataGridHeaderInfo;
   import mx.controls.advancedDataGridClasses.SortInfo;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.UIComponent;
   import mx.events.AdvancedDataGridEvent;
   
   public class AdvancedDataGridAccImpl extends ListBaseAccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var accessibilityHooked:Boolean = hookAccessibility();
      
      private static const ROLE_SYSTEM_LISTITEM:uint = 34;
      
      private static const ROLE_SYSTEM_OUTLINEITEM:uint = 36;
      
      private static const STATE_SYSTEM_COLLAPSED:uint = 1024;
      
      private static const STATE_SYSTEM_EXPANDED:uint = 512;
      
      private static const STATE_SYSTEM_FOCUSED:uint = 4;
      
      private static const STATE_SYSTEM_INVISIBLE:uint = 32768;
      
      private static const STATE_SYSTEM_OFFSCREEN:uint = 65536;
      
      private static const STATE_SYSTEM_SELECTABLE:uint = 2097152;
      
      private static const STATE_SYSTEM_SELECTED:uint = 2;
      
      private static const EVENT_OBJECT_FOCUS:uint = 32773;
      
      private static const EVENT_OBJECT_SELECTION:uint = 32774;
      
      private static const EVENT_OBJECT_STATECHANGE:uint = 32778;
      
      public function AdvancedDataGridAccImpl(master:UIComponent)
      {
         super(master);
         var advancedDataGrid:AdvancedDataGrid = AdvancedDataGrid(master);
         role = getRole(advancedDataGrid);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new AdvancedDataGridAccImpl(component);
      }
      
      public static function enableAccessibility() : void
      {
      }
      
      private static function hookAccessibility() : Boolean
      {
         AdvancedDataGrid.createAccessibilityImplementation = createAccessibilityImplementation;
         return true;
      }
      
      override public function get_accFocus() : uint
      {
         var coord:Object = null;
         var index:uint = 0;
         var row:int = 0;
         var col:int = 0;
         var advancedDataGrid:AdvancedDataGrid = AdvancedDataGrid(master);
         if(advancedDataGrid.headerIndex != -1)
         {
            return advancedDataGrid.columns.length * advancedDataGrid.dataProvider.length + advancedDataGrid.headerIndex + 1;
         }
         if(advancedDataGrid.editable.length == 0)
         {
            if(advancedDataGrid.selectionMode == "singleCell" && advancedDataGrid.selectedCells.length > 0)
            {
               coord = advancedDataGrid.selectedCells[0];
               if(Boolean(coord))
               {
                  index = advancedDataGrid.columns.length * coord.rowIndex + coord.columnIndex + 1;
               }
            }
            else
            {
               index = uint(advancedDataGrid.selectedIndex);
            }
            return index >= 0 ? uint(index + 1) : 0;
         }
         coord = advancedDataGrid.editedItemPosition;
         if(!coord)
         {
            return 0;
         }
         row = int(coord.rowIndex);
         col = int(coord.columnIndex);
         return advancedDataGrid.columns.length * row + col + 1;
      }
      
      override protected function getName(childID:uint) : String
      {
         var name:String = null;
         var index:int = 0;
         var row:int = 0;
         var col:int = 0;
         var item:Object = null;
         var columns:Array = null;
         var n:int = 0;
         var i:int = 0;
         var firstColumn:Boolean = false;
         var rowStr:String = null;
         var coord:Object = null;
         var itemName:String = null;
         var headerText:String = null;
         var view:IHierarchicalCollectionView = null;
         var str:String = null;
         var strMOfN:String = null;
         var advancedDataGrid:AdvancedDataGrid = AdvancedDataGrid(master);
         if(childID != 0 && advancedDataGrid.headerIndex != -1)
         {
            return getValueForHeader(advancedDataGrid);
         }
         if(childID == 0 || childID > 100000)
         {
            return "";
         }
         var len:int = 0;
         if(advancedDataGrid.editable.length == 0 || advancedDataGrid.editedItemPosition == null)
         {
            if(advancedDataGrid.selectionMode == "singleCell")
            {
               len = advancedDataGrid.dataProvider.length * advancedDataGrid.columns.length;
            }
            else
            {
               len = int(advancedDataGrid.dataProvider.length);
            }
         }
         else if(advancedDataGrid.editable.length != 0)
         {
            len = advancedDataGrid.dataProvider.length * advancedDataGrid.columns.length;
         }
         if(childID > len)
         {
            return "";
         }
         if(childID > 0)
         {
            index = childID - 1;
            firstColumn = true;
            if(advancedDataGrid.editable.length == 0 || advancedDataGrid.editedItemPosition == null)
            {
               row = index;
               rowStr = ", Row " + (row + 1);
               item = getItemAt(index);
               if(item is String)
               {
                  name = " " + item;
               }
               else
               {
                  name = "";
                  columns = advancedDataGrid.columns;
                  if(advancedDataGrid.selectionMode == "singleCell")
                  {
                     row = Math.floor(index / advancedDataGrid.columns.length);
                     col = index % advancedDataGrid.columns.length;
                     if(row < 0 || col < 0)
                     {
                        coord = advancedDataGrid.selectedCells[0];
                        if(!Boolean(coord))
                        {
                           return "";
                        }
                        row = int(coord.rowIndex);
                        col = int(coord.columnIndex);
                     }
                     rowStr = ", Row " + (row + 1);
                     item = getItemAt(row);
                     if(col != 0)
                     {
                        firstColumn = false;
                        rowStr = "";
                     }
                     name += columns[col].headerText + ": " + columns[col].itemToLabel(item);
                  }
                  else
                  {
                     n = int(columns.length);
                     for(i = 0; i < n; i++)
                     {
                        if(i > 0)
                        {
                           name += ",";
                        }
                        name += " " + columns[i].headerText + ": " + columns[i].itemToLabel(item);
                     }
                  }
               }
            }
            else
            {
               row = Math.floor(index / advancedDataGrid.columns.length);
               col = index % advancedDataGrid.columns.length;
               if(row < 0 || col < 0)
               {
                  coord = advancedDataGrid.editedItemPosition;
                  if(!Boolean(coord))
                  {
                     return "";
                  }
                  row = int(coord.rowIndex);
                  col = int(coord.columnIndex);
               }
               rowStr = ", Row " + (row + 1);
               if(col != 0)
               {
                  firstColumn = false;
                  rowStr = "";
               }
               item = getItemAt(row);
               if(item is String)
               {
                  name = " " + item;
               }
               else
               {
                  columns = advancedDataGrid.columns;
                  itemName = columns[col].itemToLabel(item);
                  headerText = columns[col].headerText;
                  name = "";
                  n = int(columns.length);
                  for(i = 0; i < columns.length; i++)
                  {
                     if(i > 0)
                     {
                        name += ",";
                     }
                     name += " " + columns[i].headerText + ": " + columns[i].itemToLabel(item);
                  }
                  name += ", Editing " + headerText + ": " + itemName;
               }
            }
            if(advancedDataGrid.dataProvider is IHierarchicalCollectionView)
            {
               view = IHierarchicalCollectionView(advancedDataGrid.dataProvider);
               str = "";
               strMOfN = getMOfN(item);
               if(Boolean(item) && view.source.canHaveChildren(item))
               {
                  if(firstColumn)
                  {
                     str = ". Press control shift right arrow to open, control shift left arrow to close";
                     if(advancedDataGrid.editable.length == 0)
                     {
                        name += strMOfN + str;
                     }
                     else
                     {
                        name += strMOfN;
                     }
                  }
                  else
                  {
                     name += rowStr;
                  }
               }
               else if(firstColumn)
               {
                  name += strMOfN;
               }
            }
            else
            {
               name += rowStr;
            }
         }
         return name;
      }
      
      private function getItemAt(index:int) : Object
      {
         var iterator:IViewCursor = AdvancedDataGrid(master).collectionIterator;
         iterator.seek(CursorBookmark.FIRST,index);
         return iterator.current;
      }
      
      private function getMOfN(item:Object) : String
      {
         var childNodes:ICollectionView = null;
         var cursor:IViewCursor = null;
         if(!item)
         {
            return "";
         }
         var advancedDataGrid:AdvancedDataGrid = AdvancedDataGrid(master);
         var i:int = 0;
         var n:int = 0;
         var view:IHierarchicalCollectionView = IHierarchicalCollectionView(advancedDataGrid.dataProvider);
         var parent:Object = advancedDataGrid.getParentItem(item);
         if(Boolean(parent))
         {
            childNodes = view.getChildren(parent);
            if(Boolean(childNodes))
            {
               n = int(childNodes.length);
               for(i = 0; i < n; i++)
               {
                  if(item == childNodes[i])
                  {
                     break;
                  }
               }
            }
         }
         else
         {
            cursor = ICollectionView(advancedDataGrid.collectionIterator.view).createCursor();
            while(!cursor.afterLast)
            {
               if(item == cursor.current)
               {
                  i = n;
               }
               n++;
               cursor.moveNext();
            }
         }
         if(i == n)
         {
            i = 0;
         }
         if(n > 0)
         {
            i++;
         }
         return ", " + i + " of " + n;
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var row:int = 0;
         var col:int = 0;
         var index:int = 0;
         var coord:Object = null;
         var view:IHierarchicalCollectionView = null;
         var item:Object = null;
         var renderer:IListItemRenderer = null;
         var advancedDataGrid:AdvancedDataGrid = AdvancedDataGrid(master);
         var accState:uint = uint(getState(childID));
         if(childID > 0)
         {
            if(advancedDataGrid.headerIndex != -1)
            {
               return uint(accState | (STATE_SYSTEM_SELECTABLE | STATE_SYSTEM_SELECTED | STATE_SYSTEM_FOCUSED));
            }
            index = childID - 1;
            if(advancedDataGrid.editable.length == 0 || advancedDataGrid.editedItemPosition == null)
            {
               row = index;
               if(advancedDataGrid.selectionMode == "singleCell")
               {
                  coord = advancedDataGrid.selectedCells[0];
                  if(Boolean(coord))
                  {
                     row = int(coord.rowIndex);
                  }
               }
               if(row < advancedDataGrid.verticalScrollPosition || row >= advancedDataGrid.verticalScrollPosition + advancedDataGrid.rowCount)
               {
                  accState |= STATE_SYSTEM_OFFSCREEN | STATE_SYSTEM_INVISIBLE;
               }
               else
               {
                  accState |= STATE_SYSTEM_SELECTABLE;
                  renderer = advancedDataGrid.itemToItemRenderer(getItemAt(row));
                  if(advancedDataGrid.dataProvider is IHierarchicalCollectionView)
                  {
                     view = IHierarchicalCollectionView(advancedDataGrid.dataProvider);
                     item = getItemAt(row);
                     if(Boolean(item) && view.source.canHaveChildren(item))
                     {
                        if(advancedDataGrid.selectionMode != "singleCell" || Boolean(coord) && Boolean(coord.columnIndex == advancedDataGrid.treeColumn.colNum))
                        {
                           if(advancedDataGrid.isItemOpen(item))
                           {
                              accState |= STATE_SYSTEM_EXPANDED;
                           }
                           else
                           {
                              accState |= STATE_SYSTEM_COLLAPSED;
                           }
                        }
                     }
                  }
                  if(advancedDataGrid.selectionMode == "singleCell")
                  {
                     row = Math.floor(index / advancedDataGrid.columns.length);
                     col = index % advancedDataGrid.columns.length;
                     if(Boolean(coord) && Boolean(coord.rowIndex == row) && coord.columnIndex == col)
                     {
                        accState |= STATE_SYSTEM_SELECTED | STATE_SYSTEM_FOCUSED;
                     }
                  }
                  else if(Boolean(renderer) && advancedDataGrid.isItemSelected(renderer.data))
                  {
                     accState |= STATE_SYSTEM_SELECTED | STATE_SYSTEM_FOCUSED;
                  }
               }
            }
            else
            {
               row = Math.floor(index / advancedDataGrid.columns.length);
               col = index % advancedDataGrid.columns.length;
               if(row < 0 || col < 0)
               {
                  coord = advancedDataGrid.editedItemPosition;
                  if(Boolean(coord))
                  {
                     row = int(coord.rowIndex);
                     col = int(coord.columnIndex);
                  }
                  else
                  {
                     row = 0;
                     col = 0;
                  }
               }
               if(advancedDataGrid.selectionMode == "singleCell")
               {
                  coord = advancedDataGrid.selectedCells[0];
               }
               if(row < advancedDataGrid.verticalScrollPosition || row >= advancedDataGrid.verticalScrollPosition + advancedDataGrid.rowCount)
               {
                  accState |= STATE_SYSTEM_OFFSCREEN | STATE_SYSTEM_INVISIBLE;
               }
               else if(Boolean(advancedDataGrid.columns[col].editable))
               {
                  accState |= STATE_SYSTEM_SELECTABLE;
                  coord = advancedDataGrid.editedItemPosition;
                  if(advancedDataGrid.dataProvider is IHierarchicalCollectionView)
                  {
                     view = IHierarchicalCollectionView(advancedDataGrid.dataProvider);
                     item = getItemAt(index);
                     if(Boolean(item) && view.source.canHaveChildren(item))
                     {
                        if(advancedDataGrid.selectionMode != "singleCell" || Boolean(coord) && Boolean(coord.columnIndex == 0))
                        {
                           if(advancedDataGrid.isItemOpen(item))
                           {
                              accState |= STATE_SYSTEM_EXPANDED;
                           }
                           else
                           {
                              accState |= STATE_SYSTEM_COLLAPSED;
                           }
                        }
                     }
                  }
                  if(Boolean(coord) && Boolean(coord.rowIndex == row) && coord.columnIndex == col)
                  {
                     accState |= STATE_SYSTEM_SELECTED | STATE_SYSTEM_FOCUSED;
                  }
               }
            }
         }
         return accState;
      }
      
      override public function accDoDefaultAction(childID:uint) : void
      {
         var index:int = 0;
         var row:int = 0;
         var col:int = 0;
         var advancedDataGridEvent:AdvancedDataGridEvent = null;
         var item:Object = null;
         var view:IHierarchicalCollectionView = null;
         var advancedDataGrid:AdvancedDataGrid = AdvancedDataGrid(master);
         if(childID > 0)
         {
            index = childID - 1;
            row = index;
            col = 0;
            if(advancedDataGrid.selectionMode == "singleCell")
            {
               row = Math.floor(index / advancedDataGrid.columns.length);
               col = index % advancedDataGrid.columns.length;
            }
            if(advancedDataGrid.headerIndex != -1)
            {
               advancedDataGridEvent = new AdvancedDataGridEvent(AdvancedDataGridEvent.SORT,false,true);
               advancedDataGridEvent.columnIndex = advancedDataGrid.headerIndex;
               advancedDataGridEvent.dataField = advancedDataGrid.columns[advancedDataGrid.headerIndex].dataField;
               advancedDataGridEvent.multiColumnSort = false;
               advancedDataGridEvent.removeColumnFromSort = false;
               advancedDataGrid.dispatchEvent(advancedDataGridEvent);
               return;
            }
            if(advancedDataGrid.dataProvider is IHierarchicalCollectionView && col == 0)
            {
               if(advancedDataGrid.selectionMode == "singleCell")
               {
                  index = row;
               }
               item = getItemAt(index);
               if(!item)
               {
                  return;
               }
               view = IHierarchicalCollectionView(advancedDataGrid.dataProvider);
               if(view.source.canHaveChildren(item))
               {
                  advancedDataGrid.expandItem(item,!advancedDataGrid.isItemOpen(item));
                  return;
               }
            }
            if(advancedDataGrid.editable.length == 0)
            {
               if(advancedDataGrid.selectionMode == "singleCell")
               {
                  advancedDataGrid.selectedCells = [{
                     "rowIndex":row,
                     "columnIndex":col
                  }];
               }
               else
               {
                  advancedDataGrid.selectedIndex = index;
               }
            }
            else
            {
               advancedDataGrid.editedItemPosition = {
                  "rowIndex":row,
                  "columnIndex":col
               };
            }
         }
      }
      
      private function getRole(advancedDataGrid:AdvancedDataGrid) : uint
      {
         if(advancedDataGrid.dataProvider is IHierarchicalCollectionView)
         {
            return 35;
         }
         return 33;
      }
      
      override public function get_accRole(childID:uint) : uint
      {
         var coord:Object = null;
         var advancedDataGrid:AdvancedDataGrid = AdvancedDataGrid(master);
         if(childID == 0)
         {
            role = getRole(advancedDataGrid);
            return role;
         }
         if(advancedDataGrid.headerIndex != -1)
         {
            return 25;
         }
         if(advancedDataGrid.selectionMode == "singleCell")
         {
            coord = advancedDataGrid.selectedCells[0];
            if(Boolean(coord))
            {
               if(advancedDataGrid.dataProvider is IHierarchicalCollectionView && coord.columnIndex == advancedDataGrid.treeColumn.colNum)
               {
                  return ROLE_SYSTEM_OUTLINEITEM;
               }
               return ROLE_SYSTEM_LISTITEM;
            }
         }
         if(advancedDataGrid.dataProvider is IHierarchicalCollectionView)
         {
            return ROLE_SYSTEM_OUTLINEITEM;
         }
         return ROLE_SYSTEM_LISTITEM;
      }
      
      override protected function eventHandler(event:Event) : void
      {
         var coord:Object = null;
         var index:int = 0;
         var childID:uint = 0;
         var sendEvent:Boolean = false;
         var row:int = 0;
         var col:int = 0;
         var advancedDataGrid:AdvancedDataGrid = AdvancedDataGrid(master);
         switch(event.type)
         {
            case "change":
               sendEvent = false;
               if(advancedDataGrid.headerIndex != -1)
               {
                  if(advancedDataGrid.selectionMode == "singleCell")
                  {
                     childID = advancedDataGrid.columns.length * advancedDataGrid.dataProvider.length + advancedDataGrid.headerIndex + 1;
                  }
                  else
                  {
                     childID = advancedDataGrid.dataProvider.length + advancedDataGrid.headerIndex + 1;
                  }
                  sendEvent = true;
               }
               if(!sendEvent && (advancedDataGrid.editable.length == 0 || advancedDataGrid.editedItemPosition == null))
               {
                  index = advancedDataGrid.selectedIndex;
                  if(advancedDataGrid.selectionMode == "singleCell")
                  {
                     coord = advancedDataGrid.selectedCells[0];
                     if(Boolean(coord))
                     {
                        childID = advancedDataGrid.columns.length * coord.rowIndex + coord.columnIndex + 1;
                        sendEvent = true;
                     }
                  }
                  else if(index >= 0)
                  {
                     childID = index + 1;
                     sendEvent = true;
                  }
               }
               if(sendEvent)
               {
                  Accessibility.sendEvent(advancedDataGrid,childID,EVENT_OBJECT_FOCUS);
                  Accessibility.sendEvent(advancedDataGrid,childID,EVENT_OBJECT_SELECTION);
               }
               break;
            case AdvancedDataGridEvent.ITEM_FOCUS_IN:
               if(advancedDataGrid.editable.length != 0 && advancedDataGrid.editedItemPosition != null)
               {
                  row = AdvancedDataGridEvent(event).rowIndex;
                  col = AdvancedDataGridEvent(event).columnIndex;
                  Accessibility.sendEvent(advancedDataGrid,advancedDataGrid.columns.length * row + col + 1,EVENT_OBJECT_FOCUS);
                  Accessibility.sendEvent(advancedDataGrid,advancedDataGrid.columns.length * row + col + 1,EVENT_OBJECT_SELECTION);
               }
               break;
            case AdvancedDataGridEvent.ITEM_OPEN:
            case AdvancedDataGridEvent.ITEM_CLOSE:
               if(advancedDataGrid.selectionMode == "singleCell")
               {
                  coord = advancedDataGrid.selectedCells[0];
                  if(Boolean(coord))
                  {
                     index = int(coord.rowIndex);
                  }
               }
               else
               {
                  index = advancedDataGrid.selectedIndex;
               }
               if(index >= 0)
               {
                  Accessibility.sendEvent(master,index + 1,EVENT_OBJECT_STATECHANGE);
               }
         }
      }
      
      override public function get_accSelection() : Array
      {
         var n:int = 0;
         var i:int = 0;
         var coord:Object = null;
         var selectedIndices:Array = null;
         var advancedDataGrid:AdvancedDataGrid = AdvancedDataGrid(master);
         var accSelection:Array = [];
         if(advancedDataGrid.editable.length > 0 && advancedDataGrid.editedItemPosition != null)
         {
            coord = advancedDataGrid.editedItemPosition;
            if(!coord)
            {
               return accSelection;
            }
            accSelection[0] = advancedDataGrid.columns.length * coord.rowIndex + coord.columnIndex + 1;
         }
         else if(advancedDataGrid.selectionMode == "singleCell")
         {
            n = int(advancedDataGrid.selectedCells.length);
            for(i = 0; i < n; i++)
            {
               coord = advancedDataGrid.selectedCells[i];
               accSelection[i] = advancedDataGrid.columns.length * coord.rowIndex + coord.columnIndex + 1;
            }
         }
         else
         {
            selectedIndices = AdvancedDataGrid(master).selectedIndices;
            n = int(selectedIndices.length);
            for(i = 0; i < n; i++)
            {
               accSelection[i] = selectedIndices[i] + 1;
            }
         }
         return accSelection;
      }
      
      override public function accLocation(childID:uint) : *
      {
         var row:int = 0;
         var col:int = 0;
         var coord:Object = null;
         var advancedDataGrid:AdvancedDataGrid = AdvancedDataGrid(master);
         var index:int = childID - 1;
         if(advancedDataGrid.headerIndex != -1)
         {
            return advancedDataGrid.selectedHeaderInfo.headerItem;
         }
         if(advancedDataGrid.editable.length == 0 || advancedDataGrid.editedItemPosition == null)
         {
            if(advancedDataGrid.selectionMode == "singleCell" && advancedDataGrid.selectedCells.length > 0)
            {
               coord = advancedDataGrid.selectedCells[0];
               if(Boolean(coord))
               {
                  row = int(coord.rowIndex);
                  col = int(coord.columnIndex);
               }
            }
            else
            {
               row = index;
               col = 0;
            }
            if(row < advancedDataGrid.verticalScrollPosition || row >= advancedDataGrid.verticalScrollPosition + advancedDataGrid.rowCount)
            {
               return null;
            }
            return advancedDataGrid.indicesToItemRenderer(row - advancedDataGrid.verticalScrollPosition,col);
         }
         row = Math.floor(index / advancedDataGrid.columns.length);
         col = index % advancedDataGrid.columns.length;
         if(row < advancedDataGrid.verticalScrollPosition || row >= advancedDataGrid.verticalScrollPosition + advancedDataGrid.rowCount)
         {
            return null;
         }
         return advancedDataGrid.indicesToItemRenderer(row - advancedDataGrid.verticalScrollPosition,col);
      }
      
      override public function getChildIDArray() : Array
      {
         var n:int = 0;
         var i:int = 0;
         var childIDs:Array = [];
         var advancedDataGrid:AdvancedDataGrid = AdvancedDataGrid(master);
         if(Boolean(advancedDataGrid.dataProvider))
         {
            n = 0;
            if((advancedDataGrid.editedItemPosition == null || advancedDataGrid.editable.length == 0) && advancedDataGrid.selectionMode != "singleCell")
            {
               n = int(advancedDataGrid.dataProvider.length);
            }
            else
            {
               n = advancedDataGrid.columns.length * advancedDataGrid.dataProvider.length;
            }
            for(i = 0; i < n; i++)
            {
               childIDs[i] = i + 1;
            }
         }
         return childIDs;
      }
      
      override public function get_accValue(childID:uint) : String
      {
         var item:Object = null;
         var i:int = 0;
         var coord:Object = null;
         var accValue:String = "";
         var advancedDataGrid:AdvancedDataGrid = AdvancedDataGrid(master);
         if(childID != 0 && advancedDataGrid.dataProvider is IHierarchicalCollectionView)
         {
            i = childID - 1;
            if(advancedDataGrid.selectionMode == "singleCell" || advancedDataGrid.editable.length != 0)
            {
               i = Math.floor(i / advancedDataGrid.columns.length);
            }
            item = getItemAt(i);
            if(!item)
            {
               return accValue;
            }
            accValue = advancedDataGrid.getItemDepth(item,i - advancedDataGrid.verticalScrollPosition) + "";
         }
         return accValue;
      }
      
      private function getValueForHeader(advancedDataGrid:AdvancedDataGrid) : String
      {
         var accValue:String = null;
         var str:String = null;
         var sortOrder:String = null;
         var colGrpStr:String = null;
         var headerInfo:AdvancedDataGridHeaderInfo = advancedDataGrid.selectedHeaderInfo;
         var column:AdvancedDataGridColumn = headerInfo.column;
         var sortInfo:SortInfo = advancedDataGrid.getFieldSortInfo(column);
         var str1:String = "ascending";
         if(Boolean(sortInfo))
         {
            sortOrder = sortInfo.sequenceNumber == -1 ? null : ", sort order " + sortInfo.sequenceNumber;
            if(sortInfo.descending)
            {
               str = "descending";
            }
            else
            {
               str = "ascending";
               str1 = "descending";
            }
         }
         var sortStr:String = (Boolean(str) ? " sorted " + str : "") + (Boolean(sortOrder) ? sortOrder : "") + " Press space to sort " + str1 + " on this field. " + " Press control space to add this field to sort";
         accValue = column.headerText + ": Column " + (advancedDataGrid.headerIndex + 1);
         if(advancedDataGrid.columnGrouping)
         {
            colGrpStr = "";
            if(Boolean(headerInfo.children))
            {
               colGrpStr = ", spans " + headerInfo.columnSpan + " columns";
               accValue += colGrpStr;
            }
            else
            {
               accValue += sortStr;
            }
         }
         else
         {
            accValue += sortStr;
         }
         return accValue;
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["change",AdvancedDataGridEvent.ITEM_OPEN,AdvancedDataGridEvent.ITEM_CLOSE,AdvancedDataGridEvent.ITEM_FOCUS_IN]);
      }
      
      override public function accSelect(selFlag:uint, childID:uint) : void
      {
         var advancedDataGrid:AdvancedDataGrid = AdvancedDataGrid(master);
         var index:uint = childID - 1;
         if(index >= 0 && index < advancedDataGrid.dataProvider.length)
         {
            advancedDataGrid.selectedIndex = index;
         }
      }
      
      override public function get_accDefaultAction(childID:uint) : String
      {
         var advancedDataGrid:AdvancedDataGrid = AdvancedDataGrid(master);
         var index:int = childID - 1;
         var row:int = index;
         var col:int = 0;
         if(advancedDataGrid.selectionMode == "singleCell")
         {
            row = Math.floor(index / advancedDataGrid.columns.length);
            col = index % advancedDataGrid.columns.length;
         }
         if(childID == 0)
         {
            return null;
         }
         if(advancedDataGrid.headerIndex != -1)
         {
            return "Click";
         }
         if(!(advancedDataGrid.dataProvider is IHierarchicalCollectionView) || col != advancedDataGrid.treeColumn.colNum)
         {
            return super.get_accDefaultAction(childID);
         }
         var item:Object = getItemAt(row);
         if(!item)
         {
            return null;
         }
         var view:IHierarchicalCollectionView = IHierarchicalCollectionView(advancedDataGrid.dataProvider);
         if(view.source.canHaveChildren(item))
         {
            return advancedDataGrid.isItemOpen(item) ? "Collapse" : "Expand";
         }
         return "Double Click";
      }
   }
}

