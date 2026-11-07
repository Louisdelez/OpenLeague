package flexlib.scheduling.scheduleClasses.layout
{
   import flexlib.scheduling.scheduleClasses.IScheduleEntry;
   import mx.collections.IList;
   import mx.events.CollectionEvent;
   
   public class SimpleLayout extends AbstractEntryLayout implements IEntryLayout
   {
      
      public function SimpleLayout()
      {
         super();
      }
      
      override public function resetItem(event:CollectionEvent) : void
      {
         createLayout();
      }
      
      override public function moveItem(event:CollectionEvent) : void
      {
      }
      
      override public function refreshItem(event:CollectionEvent) : void
      {
         createLayout();
      }
      
      private function createLayoutFor(startIndex:Number, endIndex:Number) : void
      {
         var len:Number = NaN;
         var i:Number = NaN;
         var rowItems:IList = null;
         len = endIndex;
         for(i = startIndex; i < len; i++)
         {
            rowItems = IList(dataProvider.getItemAt(i));
            addRowItemsToRow(rowItems,i);
         }
         updateLayouterProperties();
      }
      
      override public function removeItem(event:CollectionEvent) : void
      {
         createLayout();
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
      
      private function addRowItemsToRow(rowItems:IList, i:Number) : void
      {
         var rowItemsLength:Number = NaN;
         var j:Number = NaN;
         var item:IScheduleEntry = null;
         var x:Number = NaN;
         var width:Number = NaN;
         var layoutItem:EntryLayoutItem = null;
         rows[i] = new Array();
         rowItemsLength = Number(rowItems.length);
         for(j = 0; j < rowItemsLength; j++)
         {
            item = IScheduleEntry(rowItems.getItemAt(j));
            x = item.startDate.getTime() - startDate.getTime();
            if(!isOffScreenLeftRight(x,totalMilliseconds))
            {
               width = item.endDate.getTime() - item.startDate.getTime();
               if(!isTooSmall(width))
               {
                  layoutItem = new EntryLayoutItem();
                  layoutItem.x = x;
                  layoutItem.y = i * rowHeight;
                  layoutItem.width = width;
                  layoutItem.height = rowHeight;
                  layoutItem.data = item;
                  rows[i][j] = layoutItem;
                  saveItemWithRow(layoutItem,i,j);
               }
            }
         }
      }
      
      override public function replaceItem(event:CollectionEvent) : void
      {
         createLayout();
      }
      
      override public function updateItem(event:CollectionEvent) : void
      {
         createLayout();
      }
   }
}

