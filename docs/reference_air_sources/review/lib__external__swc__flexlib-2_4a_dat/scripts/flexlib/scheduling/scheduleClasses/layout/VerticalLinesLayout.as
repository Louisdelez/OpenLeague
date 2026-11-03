package flexlib.scheduling.scheduleClasses.layout
{
   import flexlib.scheduling.timelineClasses.ITimeDescriptor;
   import flexlib.scheduling.timelineClasses.TimeRangeDescriptorUtil;
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   
   [Event(name="update",type="flexlib.scheduling.scheduleClasses.layout.LayoutUpdateEvent")]
   public class VerticalLinesLayout extends Layout implements IVerticalLinesLayout
   {
      
      private var _minimumTimeRangeWidth:Number = 80;
      
      private var _contentWidth:Number;
      
      private var _timeRanges:IList;
      
      public function VerticalLinesLayout()
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
         calculateItems(entryLayout);
         dispatchEvent(new LayoutUpdateEvent(this));
      }
      
      override public function set contentWidth(value:Number) : void
      {
         xPosition *= value / _contentWidth;
         _contentWidth = value;
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
      
      protected function calculateItems(entryLayout:IEntryLayout) : void
      {
         var timeDescriptor:ITimeDescriptor = null;
         var millisecondsPerColumn:Number = NaN;
         var numberOfItems:Number = NaN;
         var columnWidth:Number = NaN;
         var firstIndex:Number = NaN;
         var lastIndex:Number = NaN;
         var i:Number = NaN;
         var item:VerticalLinesLayoutItem = null;
         timeDescriptor = getTimeDescriptor(contentWidth,totalMilliseconds);
         millisecondsPerColumn = timeDescriptor.date.getTime();
         numberOfItems = totalMilliseconds / millisecondsPerColumn;
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
            item = new VerticalLinesLayoutItem();
            item.height = viewportHeight;
            item.x = i * columnWidth;
            item.y = 0;
            _items.addItem(item);
         }
      }
   }
}

