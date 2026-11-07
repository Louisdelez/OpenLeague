package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import mx.collections.CursorBookmark;
   import mx.collections.IViewCursor;
   import mx.controls.DataGrid;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.DataGridEvent;
   
   use namespace mx_internal;
   
   public class DataGridAccImpl extends ListBaseAccImpl
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const ROLE_SYSTEM_LISTITEM:uint = 34;
      
      private static const STATE_SYSTEM_FOCUSED:uint = 4;
      
      private static const STATE_SYSTEM_INVISIBLE:uint = 32768;
      
      private static const STATE_SYSTEM_OFFSCREEN:uint = 65536;
      
      private static const STATE_SYSTEM_SELECTABLE:uint = 2097152;
      
      private static const STATE_SYSTEM_SELECTED:uint = 2;
      
      private static const EVENT_OBJECT_FOCUS:uint = 32773;
      
      private static const EVENT_OBJECT_SELECTION:uint = 32774;
      
      public function DataGridAccImpl(master:UIComponent)
      {
         super(master);
      }
      
      public static function enableAccessibility() : void
      {
         DataGrid.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      mx_internal static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new DataGridAccImpl(component);
      }
      
      override public function get_accFocus() : uint
      {
         var index:uint = 0;
         var coord:Object = null;
         var row:int = 0;
         var col:int = 0;
         var dataGrid:DataGrid = DataGrid(master);
         if(!dataGrid.editable)
         {
            index = uint(dataGrid.selectedIndex);
            return index >= 0 ? uint(index + 1) : 0;
         }
         coord = dataGrid.editedItemPosition;
         if(!coord)
         {
            return 0;
         }
         row = int(coord.rowIndex);
         col = int(coord.columnIndex);
         return dataGrid.columns.length * row + col + 1;
      }
      
      override protected function getName(childID:uint) : String
      {
         var name:String = null;
         var index:int = 0;
         var row:int = 0;
         var item:Object = null;
         var columns:Array = null;
         var n:int = 0;
         var i:int = 0;
         var col:int = 0;
         var itemName:String = null;
         var headerText:String = null;
         if(childID == 0)
         {
            return "";
         }
         var dataGrid:DataGrid = DataGrid(master);
         if(childID > 0)
         {
            index = childID - 1;
            if(!dataGrid.editable)
            {
               row = index;
               item = getItemAt(index);
               if(item is String)
               {
                  name = "Row " + (row + 1) + " of " + dataGrid.dataProvider.length + " " + item;
               }
               else
               {
                  name = "Row " + (row + 1) + " of " + dataGrid.dataProvider.length;
                  columns = dataGrid.columns;
                  n = int(columns.length);
                  for(i = 0; i < n; i++)
                  {
                     name += " " + columns[i].headerText + " " + columns[i].itemToLabel(item);
                  }
               }
            }
            else
            {
               row = Math.floor(index / dataGrid.columns.length);
               col = index % dataGrid.columns.length;
               item = getItemAt(row);
               if(item is String)
               {
                  name = "Row " + (row + 1) + " of " + dataGrid.dataProvider.length + " " + item;
               }
               else
               {
                  columns = dataGrid.columns;
                  itemName = columns[i].itemToLabel(item);
                  headerText = columns[col].headerText;
                  name = "Row " + (row + 1) + " of " + dataGrid.dataProvider.length;
                  n = int(columns.length);
                  for(i = 0; i < columns.length; i++)
                  {
                     name += " " + columns[i].headerText + " " + columns[i].itemToLabel(item);
                  }
                  name += ", Editing " + headerText + " " + itemName;
               }
            }
         }
         return name;
      }
      
      private function getItemAt(index:int) : Object
      {
         var iterator:IViewCursor = DataGrid(master).collectionIterator;
         iterator.seek(CursorBookmark.FIRST,index);
         return iterator.current;
      }
      
      override public function accLocation(childID:uint) : *
      {
         var row:int = 0;
         var col:int = 0;
         var dataGrid:DataGrid = DataGrid(master);
         var index:int = childID - 1;
         var addHeader:int = dataGrid.headerVisible ? 1 : 0;
         if(!dataGrid.editable)
         {
            row = index + addHeader;
            if(row < dataGrid.verticalScrollPosition || row >= dataGrid.verticalScrollPosition + dataGrid.rowCount)
            {
               return null;
            }
            return dataGrid.indicesToItemRenderer(row - dataGrid.verticalScrollPosition,0);
         }
         row = Math.floor(index / dataGrid.columns.length) + addHeader;
         col = index % dataGrid.columns.length;
         if(row < dataGrid.verticalScrollPosition || row >= dataGrid.verticalScrollPosition + dataGrid.rowCount)
         {
            return null;
         }
         return dataGrid.indicesToItemRenderer(row - dataGrid.verticalScrollPosition,col);
      }
      
      override protected function eventHandler(event:Event) : void
      {
         var index:int = 0;
         var childID:uint = 0;
         var item:int = 0;
         var col:int = 0;
         $eventHandler(event);
         var dataGrid:DataGrid = DataGrid(master);
         switch(event.type)
         {
            case "change":
               if(!dataGrid.editable)
               {
                  index = dataGrid.selectedIndex;
                  if(index >= 0)
                  {
                     childID = index + 1;
                     Accessibility.sendEvent(dataGrid,childID,EVENT_OBJECT_FOCUS);
                     Accessibility.sendEvent(dataGrid,childID,EVENT_OBJECT_SELECTION);
                  }
               }
               break;
            case DataGridEvent.ITEM_FOCUS_IN:
               if(dataGrid.editable)
               {
                  item = DataGridEvent(event).rowIndex;
                  col = DataGridEvent(event).columnIndex;
                  Accessibility.sendEvent(dataGrid,dataGrid.columns.length * item + col + 1,EVENT_OBJECT_FOCUS);
                  Accessibility.sendEvent(dataGrid,dataGrid.columns.length * item + col + 1,EVENT_OBJECT_SELECTION);
               }
         }
      }
      
      override public function getChildIDArray() : Array
      {
         var n:int = 0;
         var dataGrid:DataGrid = DataGrid(master);
         if(Boolean(dataGrid.dataProvider))
         {
            if(!dataGrid.editable)
            {
               n = int(dataGrid.dataProvider.length);
            }
            else
            {
               n = dataGrid.columns.length * dataGrid.dataProvider.length;
            }
         }
         return createChildIDArray(n);
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var row:int = 0;
         var col:int = 0;
         var index:int = 0;
         var renderer:IListItemRenderer = null;
         var coord:Object = null;
         var dataGrid:DataGrid = DataGrid(master);
         var accState:uint = getState(childID);
         if(childID > 0)
         {
            index = childID - 1;
            if(!dataGrid.editable)
            {
               row = index;
               if(row < dataGrid.verticalScrollPosition || row >= dataGrid.verticalScrollPosition + dataGrid.rowCount - (dataGrid.headerVisible ? 1 : 0))
               {
                  accState |= STATE_SYSTEM_OFFSCREEN | STATE_SYSTEM_INVISIBLE;
               }
               else
               {
                  accState |= STATE_SYSTEM_SELECTABLE;
                  renderer = dataGrid.itemToItemRenderer(getItemAt(row));
                  if(Boolean(renderer) && dataGrid.isItemSelected(renderer.data))
                  {
                     accState |= STATE_SYSTEM_SELECTED | STATE_SYSTEM_FOCUSED;
                  }
               }
            }
            else
            {
               row = Math.floor(index / dataGrid.columns.length);
               col = index % dataGrid.columns.length;
               if(row < dataGrid.verticalScrollPosition || row >= dataGrid.verticalScrollPosition + dataGrid.rowCount - (dataGrid.headerVisible ? 1 : 0))
               {
                  accState |= STATE_SYSTEM_OFFSCREEN | STATE_SYSTEM_INVISIBLE;
               }
               else if(Boolean(dataGrid.columns[col].editable))
               {
                  accState |= STATE_SYSTEM_SELECTABLE;
                  coord = dataGrid.editedItemPosition;
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
         var dataGrid:DataGrid = DataGrid(master);
         if(childID > 0)
         {
            index = childID - 1;
            if(!dataGrid.editable)
            {
               dataGrid.selectedIndex = index;
            }
            else
            {
               row = Math.floor(index / dataGrid.columns.length);
               col = index % dataGrid.columns.length;
               dataGrid.editedItemPosition = {
                  "rowIndex":row,
                  "columnIndex":col
               };
            }
         }
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat([DataGridEvent.ITEM_FOCUS_IN]);
      }
      
      override public function get_accRole(childID:uint) : uint
      {
         return childID == 0 ? role : ROLE_SYSTEM_LISTITEM;
      }
   }
}

