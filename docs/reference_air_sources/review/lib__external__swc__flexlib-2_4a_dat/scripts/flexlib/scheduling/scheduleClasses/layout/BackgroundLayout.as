package flexlib.scheduling.scheduleClasses.layout
{
   import flexlib.scheduling.scheduleClasses.BackgroundItem;
   import flexlib.scheduling.timelineClasses.ITimeDescriptor;
   import flexlib.scheduling.timelineClasses.TimeRangeDescriptorUtil;
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   
   [Event(name="update",type="flexlib.scheduling.scheduleClasses.layout.LayoutUpdateEvent")]
   public class BackgroundLayout extends Layout implements IBackgroundLayout
   {
      
      private var _minimumTimeRangeWidth:Number = 80;
      
      private var _contentWidth:Number;
      
      private var _timeRanges:IList;
      
      private var _backgroundItems:IList;
      
      public function BackgroundLayout()
      {
         super();
         timeRanges = TimeRangeDescriptorUtil.getDefaultTimeRangeDescriptor();
      }
      
      public function get timeRanges() : IList
      {
         return _timeRanges;
      }
      
      public function set timeRanges(value:IList) : void
      {
         _timeRanges = value;
      }
      
      private function getTimeDescriptor(totalWidth:Number, totalMilliseconds:Number) : ITimeDescriptor
      {
         var length:Number = NaN;
         var i:Number = NaN;
         var entry:ITimeDescriptor = null;
         var step:Number = NaN;
         var width:Number = NaN;
         length = Number(timeRanges.length);
         for(i = 0; i < length; i++)
         {
            entry = ITimeDescriptor(timeRanges.getItemAt(i));
            step = entry.date.getTime();
            width = step / totalMilliseconds * totalWidth;
            if(width >= minimumTimeRangeWidth)
            {
               return entry;
            }
         }
         return ITimeDescriptor(timeRanges.getItemAt(length - 1));
      }
      
      private function findBackgroundItem(relativeTime:Number) : BackgroundItem
      {
         var result:BackgroundItem = null;
         var i:Number = NaN;
         var colorItem:BackgroundItem = null;
         if(_backgroundItems == null)
         {
            return null;
         }
         result = null;
         for(i = 0; i < _backgroundItems.length; i++)
         {
            colorItem = BackgroundItem(_backgroundItems.getItemAt(i));
            if(relativeTime >= colorItem.startDate.getTime() && relativeTime < colorItem.endDate.getTime())
            {
               result = colorItem;
            }
         }
         return result;
      }
      
      public function set backgroundItems(value:IList) : void
      {
         _backgroundItems = value;
      }
      
      override public function set contentWidth(value:Number) : void
      {
         xPosition *= value / _contentWidth;
         _contentWidth = value;
      }
      
      public function get backgroundItems() : IList
      {
         return _backgroundItems;
      }
      
      public function set minimumTimeRangeWidth(value:Number) : void
      {
         _minimumTimeRangeWidth = value;
      }
      
      public function get minimumTimeRangeWidth() : Number
      {
         return _minimumTimeRangeWidth;
      }
      
      override public function get contentWidth() : Number
      {
         return _contentWidth;
      }
      
      public function update(event:LayoutUpdateEvent) : void
      {
         entryLayout = IEntryLayout(event.layout);
         contentWidth = entryLayout.contentWidth;
         startDate = entryLayout.startDate;
         endDate = entryLayout.endDate;
         viewportWidth = entryLayout.viewportWidth;
         viewportHeight = entryLayout.viewportHeight;
         xPosition = entryLayout.xPosition;
         yPosition = entryLayout.yPosition;
         calculateItems();
         dispatchEvent(new LayoutUpdateEvent(this));
      }
      
      private function calculateItems() : void
      {
         var timeDescriptor:ITimeDescriptor = null;
         var millisecondsPerColumn:Number = NaN;
         var numberOfItems:Number = NaN;
         var columnWidth:Number = NaN;
         var firstIndex:Number = NaN;
         var lastIndex:Number = NaN;
         var i:Number = NaN;
         var item:BackgroundLayoutItem = null;
         var currentTime:Number = NaN;
         var colorItem:BackgroundItem = null;
         var now:Number = NaN;
         var currentIndex:Number = NaN;
         timeDescriptor = getTimeDescriptor(contentWidth,totalMilliseconds);
         millisecondsPerColumn = timeDescriptor.date.getTime();
         numberOfItems = Math.floor(totalMilliseconds / millisecondsPerColumn) + 1;
         columnWidth = contentWidth / numberOfItems;
         if(columnWidth < minimumTimeRangeWidth)
         {
            columnWidth = minimumTimeRangeWidth;
         }
         _items = new ArrayCollection();
         firstIndex = Math.floor(xPosition / columnWidth);
         lastIndex = Math.ceil((xPosition + viewportWidth) / columnWidth);
         for(i = firstIndex; i < lastIndex; i++)
         {
            item = new BackgroundLayoutItem();
            item.width = columnWidth;
            item.height = viewportHeight;
            item.x = i * columnWidth;
            currentTime = (i * columnWidth + columnWidth / 2) * totalMilliseconds / contentWidth;
            colorItem = findBackgroundItem(currentTime);
            if(colorItem != null)
            {
               item.backgroundColor = colorItem.color;
               item.toolTip = colorItem.description;
               now = new Date().getTime() - _startDate;
               currentIndex = Math.floor(now / columnWidth);
               if(i == currentIndex)
               {
                  item.backgroundColor = 16711680;
               }
               _items.addItem(item);
            }
         }
      }
   }
}

