package flexlib.scheduling.scheduleClasses.layout
{
   import flash.utils.Dictionary;
   import flexlib.scheduling.scheduleClasses.IScheduleEntry;
   import flexlib.scheduling.scheduleClasses.RowLocatorItem;
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.events.CollectionEvent;
   import mx.events.PropertyChangeEvent;
   
   [Event(name="update",type="flexlib.scheduling.scheduleClasses.layout.LayoutUpdateEvent")]
   public class AbstractEntryLayout extends Layout implements IEntryLayout
   {
      
      private var _rowHeight:Number = 50;
      
      private var _xPosition:Number = 0;
      
      private var rowLocator:Dictionary;
      
      private var _dataProvider:IList;
      
      protected var rows:Array;
      
      public function AbstractEntryLayout()
      {
         super();
         createLayout();
      }
      
      public function resetItem(event:CollectionEvent) : void
      {
         throw new Error("Abstract method invoked");
      }
      
      public function deleteRowLocatorItem(entry:IScheduleEntry) : RowLocatorItem
      {
         return rowLocator[entry] = null;
      }
      
      private function set _683600801rowHeight(value:Number) : void
      {
         _rowHeight = value;
      }
      
      public function createLayout() : void
      {
         rows = new Array();
         rowLocator = new Dictionary(true);
      }
      
      [Bindable(event="propertyChange")]
      public function set rowHeight(value:Number) : void
      {
         var oldValue:Object = null;
         oldValue = this.rowHeight;
         if(oldValue !== value)
         {
            this._683600801rowHeight = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rowHeight",oldValue,value));
         }
      }
      
      public function addItem(event:CollectionEvent) : void
      {
         throw new Error("Abstract method invoked");
      }
      
      protected function isTooSmall(width:Number) : Boolean
      {
         var tooSmall:Boolean = false;
         tooSmall = width <= 0;
         if(tooSmall)
         {
         }
         return tooSmall;
      }
      
      public function set dataProvider(value:IList) : void
      {
         _dataProvider = value;
      }
      
      public function updateItem(event:CollectionEvent) : void
      {
         throw new Error("Abstract method invoked");
      }
      
      public function getRowLocatorItem(entry:IScheduleEntry) : RowLocatorItem
      {
         return rowLocator[entry];
      }
      
      override public function set xPosition(value:Number) : void
      {
         var zoom:Number = NaN;
         if(isNaN(value))
         {
            return;
         }
         zoom = totalMilliseconds / contentWidth;
         _xPosition = value * zoom;
      }
      
      public function refreshItem(event:CollectionEvent) : void
      {
         throw new Error("Abstract method invoked");
      }
      
      public function setRowLocatorItem(item:EntryLayoutItem, rowLocatorItem:RowLocatorItem) : void
      {
         rowLocatorItem.layoutItem = item;
         rowLocator[item.data] = rowLocatorItem;
      }
      
      public function moveItem(event:CollectionEvent) : void
      {
         throw new Error("Abstract method invoked");
      }
      
      protected function updateLayouterProperties() : void
      {
         contentHeight = rows.length * rowHeight;
      }
      
      protected function isOffScreenLeftRight(entryStart:Number, viewPortEnd:Number) : Boolean
      {
         var isOff:Boolean = false;
         var isOffScreenOnLeftSide:Boolean = false;
         var isOffScreenOnRightSide:Boolean = false;
         isOffScreenOnLeftSide = entryStart < 0;
         isOffScreenOnRightSide = entryStart > viewPortEnd;
         if(isOffScreenOnLeftSide || isOffScreenOnRightSide)
         {
            isOff = true;
         }
         return isOff;
      }
      
      [Bindable]
      public function get rowHeight() : Number
      {
         return _rowHeight;
      }
      
      public function removeItem(event:CollectionEvent) : void
      {
         throw new Error("Abstract method invoked");
      }
      
      public function get dataProvider() : IList
      {
         return _dataProvider;
      }
      
      override public function get xPosition() : Number
      {
         var zoom:Number = NaN;
         zoom = totalMilliseconds / contentWidth;
         return _xPosition / zoom;
      }
      
      public function update() : void
      {
         calculateItems();
         dispatchEvent(new LayoutUpdateEvent(this));
      }
      
      protected function saveItemWithRow(item:EntryLayoutItem, row:Number, rowItem:Number) : void
      {
         var rowLocatorItem:RowLocatorItem = null;
         rowLocatorItem = new RowLocatorItem();
         rowLocatorItem.row = row;
         rowLocatorItem.rowItem = row;
         setRowLocatorItem(item,rowLocatorItem);
      }
      
      public function replaceItem(event:CollectionEvent) : void
      {
         throw new Error("Abstract method invoked");
      }
      
      public function findLayoutItem(entry:IScheduleEntry) : EntryLayoutItem
      {
         var rowLocatorItem:RowLocatorItem = null;
         rowLocatorItem = getRowLocatorItem(entry);
         if(rowLocatorItem != null)
         {
            if(rowLocatorItem.layoutItem != null)
            {
               return rowLocatorItem.layoutItem;
            }
         }
         return null;
      }
      
      private function calculateItems() : void
      {
         var result:ArrayCollection = null;
         var firstRow:Number = NaN;
         var lastRow:Number = NaN;
         var totalMilliseconds:Number = NaN;
         var zoom:Number = NaN;
         var xStart:Number = NaN;
         var xEnd:Number = NaN;
         var rowIndex:Number = NaN;
         var row:Array = null;
         var item:EntryLayoutItem = null;
         result = new ArrayCollection();
         firstRow = Math.floor(yPosition / rowHeight);
         lastRow = Math.ceil((yPosition + viewportHeight) / rowHeight);
         if(lastRow >= rows.length)
         {
            lastRow = rows.length - 1;
         }
         totalMilliseconds = endDate.getTime() - startDate.getTime();
         zoom = totalMilliseconds / contentWidth;
         xStart = _xPosition;
         xEnd = _xPosition + viewportWidth * zoom;
         for(rowIndex = firstRow; rowIndex <= lastRow; rowIndex++)
         {
            row = rows[rowIndex];
            for each(item in row)
            {
               if(item.x < xEnd && item.x + item.width >= xStart)
               {
                  item.zoom = zoom;
                  item.row = rowIndex;
                  result.addItem(item);
               }
            }
         }
         _items = result;
      }
      
      private function tryToCreateLayout() : void
      {
         if(dataProvider != null && startDate != null && endDate != null && !isNaN(rowHeight))
         {
            createLayout();
         }
      }
   }
}

