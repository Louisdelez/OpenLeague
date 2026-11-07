package flexlib.scheduling.timelineClasses
{
   import flash.events.Event;
   import flexlib.scheduling.scheduleClasses.layout.ILayoutProvider;
   import flexlib.scheduling.scheduleClasses.layout.Layout;
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.events.PropertyChangeEvent;
   
   [Event("update")]
   public class TimelineLayout extends Layout implements ILayoutProvider
   {
      
      public var timeRanges:IList;
      
      private var _contentWidth:Number;
      
      public var minimumTimeRangeWidth:Number = 80;
      
      [Bindable]
      private var _600751303currentDate:Date;
      
      public function TimelineLayout()
      {
         super();
         timeRanges = TimeRangeDescriptorUtil.getDefaultTimeRangeDescriptor();
      }
      
      private function calculateItems() : void
      {
         var totalMilliseconds:Number = NaN;
         var entry:ITimeDescriptor = null;
         var millisecondsPerColumn:Number = NaN;
         var numberOfItems:Number = NaN;
         var columnWidth:Number = NaN;
         var firstIndex:Number = NaN;
         var lastIndex:Number = NaN;
         var i:Number = NaN;
         var item:TimelineLayoutItem = null;
         var data:ITimeDescriptor = null;
         totalMilliseconds = _endDate - _startDate;
         entry = getTimeDescriptor(contentWidth,totalMilliseconds);
         millisecondsPerColumn = entry.date.getTime();
         numberOfItems = totalMilliseconds / millisecondsPerColumn;
         columnWidth = contentWidth / numberOfItems;
         if(columnWidth < minimumTimeRangeWidth)
         {
            columnWidth = minimumTimeRangeWidth;
         }
         _items = new ArrayCollection();
         firstIndex = Math.floor(xPosition / columnWidth);
         lastIndex = Math.ceil((xPosition + viewportWidth) / columnWidth);
         for(i = firstIndex; i <= lastIndex; i++)
         {
            item = new TimelineLayoutItem();
            item.width = columnWidth;
            item.height = viewportHeight;
            item.x = i * columnWidth;
            item.y = 0;
            currentDate = new Date(i * millisecondsPerColumn + _startDate);
            data = new SimpleTimeDescriptor();
            data.description = entry.description;
            data.date = currentDate;
            item.data = data;
            _items.addItem(item);
         }
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
      
      [Bindable(event="propertyChange")]
      override public function set contentWidth(value:Number) : void
      {
         var oldValue:Object = null;
         oldValue = this.contentWidth;
         if(oldValue !== value)
         {
            this._824110285contentWidth = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"contentWidth",oldValue,value));
         }
      }
      
      public function set currentDate(value:Date) : void
      {
         var oldValue:Object = null;
         oldValue = this._600751303currentDate;
         if(oldValue !== value)
         {
            this._600751303currentDate = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentDate",oldValue,value));
         }
      }
      
      public function set _824110285contentWidth(value:Number) : void
      {
         xPosition *= value / _contentWidth;
         _contentWidth = value;
      }
      
      [Bindable(event="propertyChange")]
      public function get currentDate() : Date
      {
         return this._600751303currentDate;
      }
      
      [Bindable]
      override public function get contentWidth() : Number
      {
         return _contentWidth;
      }
      
      public function update() : void
      {
         calculateItems();
         dispatchEvent(new Event("update"));
      }
   }
}

