package flexlib.scheduling.scheduleClasses.layout
{
   import flexlib.scheduling.scheduleClasses.IScheduleEntry;
   import mx.events.CollectionEvent;
   
   public class BestFitLayout extends AbstractEntryLayout implements IEntryLayout
   {
      
      public function BestFitLayout()
      {
         super();
      }
      
      override public function resetItem(event:CollectionEvent) : void
      {
         createLayout();
      }
      
      private function insertNonOverlapping(item:EntryLayoutItem) : void
      {
         var length:Number = NaN;
         var rowIndex:Number = NaN;
         var newRow:Array = null;
         var row:Array = null;
         var index:Number = NaN;
         length = rows.length;
         for(rowIndex = 0; rowIndex < length; rowIndex++)
         {
            row = rows[rowIndex];
            index = findNonOverlappingPosition(row,item);
            if(index >= 0)
            {
               item.row = rowIndex;
               item.y = rowIndex * item.height;
               row.splice(index,0,item);
               saveItemWithRow(item,rowIndex,index);
               return;
            }
         }
         item.row = length;
         item.y = length * item.height;
         newRow = new Array();
         newRow.push(item);
         rows.push(newRow);
         saveItemWithRow(item,length,0);
      }
      
      override public function createLayout() : void
      {
         super.createLayout();
         if(dataProvider == null)
         {
            return;
         }
         createLayoutFor(0,dataProvider.length);
      }
      
      override public function addItem(event:CollectionEvent) : void
      {
         createLayout();
      }
      
      private function addItemToRow(entry:IScheduleEntry) : void
      {
         var x:Number = NaN;
         var width:Number = NaN;
         var layoutItem:EntryLayoutItem = null;
         x = entry.startDate.getTime() - startDate.getTime();
         if(isOffScreenLeftRight(x,totalMilliseconds))
         {
            return;
         }
         width = entry.endDate.getTime() - entry.startDate.getTime();
         if(isTooSmall(width))
         {
            return;
         }
         layoutItem = new EntryLayoutItem();
         layoutItem.x = x;
         layoutItem.width = width;
         layoutItem.height = rowHeight;
         layoutItem.data = entry;
         insertNonOverlapping(layoutItem);
      }
      
      override public function updateItem(event:CollectionEvent) : void
      {
         createLayout();
      }
      
      override public function refreshItem(event:CollectionEvent) : void
      {
         createLayout();
      }
      
      override public function moveItem(event:CollectionEvent) : void
      {
      }
      
      private function findNonOverlappingPosition(row:Array, item:EntryLayoutItem) : Number
      {
         var x:Number = NaN;
         var width:Number = NaN;
         var length:Number = NaN;
         var i:Number = NaN;
         x = item.x;
         width = item.width;
         length = row.length;
         if(length == 0)
         {
            return 0;
         }
         i = 0;
         while(i < length && x > row[i].x)
         {
            i++;
         }
         if(i == length)
         {
            if(x >= row[i - 1].x + row[i - 1].width)
            {
               return length;
            }
            return -1;
         }
         if(x < row[i].x && x + width <= row[i].x)
         {
            if(i == 0)
            {
               return 0;
            }
            if(x > row[i - 1].x + row[i - 1].width)
            {
               return i;
            }
         }
         return -1;
      }
      
      private function createLayoutFor(startIndex:Number, endIndex:Number) : void
      {
         var len:Number = NaN;
         var i:Number = NaN;
         var item:IScheduleEntry = null;
         len = endIndex;
         for(i = startIndex; i < len; i++)
         {
            item = IScheduleEntry(dataProvider.getItemAt(i));
            addItemToRow(item);
         }
         updateLayouterProperties();
      }
      
      override public function removeItem(event:CollectionEvent) : void
      {
         createLayout();
      }
      
      override public function replaceItem(event:CollectionEvent) : void
      {
         createLayout();
      }
   }
}

