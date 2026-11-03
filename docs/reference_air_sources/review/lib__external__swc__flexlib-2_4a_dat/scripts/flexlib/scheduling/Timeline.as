package flexlib.scheduling
{
   import flash.events.Event;
   import flexlib.scheduling.timelineClasses.TimelineLayout;
   import flexlib.scheduling.timelineClasses.TimelineViewer;
   import mx.collections.IList;
   import mx.core.IFactory;
   import mx.core.ScrollControlBase;
   import mx.core.ScrollPolicy;
   import mx.core.UIComponent;
   import mx.events.PropertyChangeEvent;
   import mx.events.ScrollEvent;
   import mx.events.ScrollEventDetail;
   import mx.events.ScrollEventDirection;
   
   public class Timeline extends ScrollControlBase
   {
      
      private var content:UIComponent;
      
      private var _zoom:Number;
      
      private var _timeRanges:IList;
      
      private var timelineViewer:TimelineViewer;
      
      private var _minimumTimeRangeWidth:Number;
      
      private var timelineLayout:TimelineLayout;
      
      private var contentWidthOffset:Number;
      
      public function Timeline()
      {
         super();
         horizontalScrollPolicy = ScrollPolicy.AUTO;
         verticalScrollPolicy = ScrollPolicy.OFF;
         contentWidthOffset = 0;
         createTimelineLayout();
      }
      
      [Bindable]
      public function get timeRanges() : IList
      {
         return _timeRanges;
      }
      
      [Bindable(event="propertyChange")]
      public function set timeRanges(value:IList) : void
      {
         var oldValue:Object = null;
         oldValue = this.timeRanges;
         if(oldValue !== value)
         {
            this._746987523timeRanges = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"timeRanges",oldValue,value));
         }
      }
      
      private function onCurrentDateChanged(event:Event) : void
      {
         dispatchEvent(new Event("onCurrentDateChanged"));
      }
      
      [Bindable]
      public function get contentWidth() : Number
      {
         return timelineLayout.contentWidth;
      }
      
      [Bindable(event="currentDateChanged")]
      public function get currentDate() : Date
      {
         return timelineLayout.currentDate;
      }
      
      private function set _260391140minimumTimeRangeWidth(value:Number) : void
      {
         _minimumTimeRangeWidth = value;
         timelineLayout.minimumTimeRangeWidth = _minimumTimeRangeWidth;
         invalidateDisplayList();
      }
      
      [Bindable]
      public function get minimumTimeRangeWidth() : Number
      {
         return _minimumTimeRangeWidth;
      }
      
      [Bindable]
      public function get itemRenderer() : IFactory
      {
         return timelineViewer.itemRenderer;
      }
      
      private function set _3744723zoom(value:Number) : void
      {
         var adjustedValue:Number = NaN;
         _zoom = value;
         adjustedValue = value / 100 * Math.sqrt(width);
         contentWidth = Math.pow(adjustedValue,2);
      }
      
      private function set _2129778896startDate(value:Date) : void
      {
         timelineLayout.startDate = value;
         invalidateDisplayList();
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredHeight = 20;
         measuredMinHeight = 20;
         if(horizontalScrollPolicy != ScrollPolicy.OFF && Boolean(horizontalScrollBar))
         {
            measuredHeight += horizontalScrollBar.minHeight;
            measuredMinHeight += horizontalScrollBar.minHeight;
         }
      }
      
      private function onScroll(event:ScrollEvent) : void
      {
         var position:Number = NaN;
         position = Number(event.position);
         if(event.direction == ScrollEventDirection.HORIZONTAL)
         {
            xPosition = position;
         }
      }
      
      public function set currentDate(value:Date) : void
      {
         timelineLayout.currentDate = value;
      }
      
      [Bindable(event="propertyChange")]
      public function set contentWidth(value:Number) : void
      {
         var oldValue:Object = null;
         oldValue = this.contentWidth;
         if(oldValue !== value)
         {
            this._824110285contentWidth = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"contentWidth",oldValue,value));
         }
      }
      
      [Bindable(event="xPositionChanged")]
      public function get xPosition() : Number
      {
         return timelineLayout.xPosition;
      }
      
      override protected function commitProperties() : void
      {
         if(isNaN(contentWidth) && width != 0)
         {
            contentWidth = width;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set minimumTimeRangeWidth(value:Number) : void
      {
         var oldValue:Object = null;
         oldValue = this.minimumTimeRangeWidth;
         if(oldValue !== value)
         {
            this._260391140minimumTimeRangeWidth = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minimumTimeRangeWidth",oldValue,value));
         }
      }
      
      private function set _133586166itemRenderer(value:IFactory) : void
      {
         if(value != null && value != timelineViewer.itemRenderer)
         {
            timelineViewer.itemRenderer = value;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set itemRenderer(value:IFactory) : void
      {
         var oldValue:Object = null;
         oldValue = this.itemRenderer;
         if(oldValue !== value)
         {
            this._133586166itemRenderer = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"itemRenderer",oldValue,value));
         }
      }
      
      private function set _1607727319endDate(value:Date) : void
      {
         timelineLayout.endDate = value;
         invalidateDisplayList();
      }
      
      private function initializeCompileTimeViewLayers() : void
      {
         timelineViewer = new TimelineViewer();
         timelineLayout.addEventListener("update",timelineViewer.update);
      }
      
      [Bindable(event="propertyChange")]
      public function set endDate(value:Date) : void
      {
         var oldValue:Object = null;
         oldValue = this.endDate;
         if(oldValue !== value)
         {
            this._1607727319endDate = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"endDate",oldValue,value));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set startDate(value:Date) : void
      {
         var oldValue:Object = null;
         oldValue = this.startDate;
         if(oldValue !== value)
         {
            this._2129778896startDate = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"startDate",oldValue,value));
         }
      }
      
      private function onTimelineLayoutChange(event:PropertyChangeEvent) : void
      {
         if(event.property == "xPosition")
         {
            dispatchEvent(new Event("xPositionChanged"));
         }
         else if(event.property == "currentDate")
         {
            dispatchEvent(new Event("currentDateChanged"));
         }
      }
      
      private function createTimelineLayout() : void
      {
         if(timelineLayout == null)
         {
            timelineLayout = new TimelineLayout();
            timelineLayout.addEventListener("propertyChange",onTimelineLayoutChange);
         }
      }
      
      private function setHorizontalScrollPosition(value:Number) : void
      {
         var event:ScrollEvent = null;
         if(value > maxHorizontalScrollPosition)
         {
            value = Number(maxHorizontalScrollPosition);
         }
         event = new ScrollEvent(ScrollEvent.SCROLL);
         event.direction = ScrollEventDirection.HORIZONTAL;
         event.position = value;
         event.delta = horizontalScrollPosition - value;
         event.detail = ScrollEventDetail.THUMB_POSITION;
         horizontalScrollPosition = value;
         dispatchEvent(event);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         addEventListener(ScrollEvent.SCROLL,onScroll);
         content = new UIComponent();
         addChild(content);
         content.mask = maskShape;
         initializeCompileTimeViewLayers();
         content.addChild(timelineViewer);
      }
      
      [Bindable]
      public function get endDate() : Date
      {
         return timelineLayout.endDate;
      }
      
      [Bindable]
      public function get startDate() : Date
      {
         return timelineLayout.startDate;
      }
      
      private function setXPosition(position:Number) : void
      {
         timelineLayout.xPosition = position;
         timelineLayout.update();
      }
      
      public function set xPosition(value:Number) : void
      {
         var overlap:Number = NaN;
         horizontalScrollPosition = value;
         setXPosition(value);
         overlap = timelineLayout.contentWidth - timelineLayout.viewportWidth;
         if(overlap < value)
         {
            contentWidthOffset = value - overlap;
            invalidateDisplayList();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set zoom(value:Number) : void
      {
         var oldValue:Object = null;
         oldValue = this.zoom;
         if(oldValue !== value)
         {
            this._3744723zoom = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"zoom",oldValue,value));
         }
      }
      
      [Bindable]
      public function get zoom() : Number
      {
         return _zoom;
      }
      
      private function set _824110285contentWidth(value:Number) : void
      {
         horizontalScrollPosition *= value / timelineLayout.contentWidth;
         if(isNaN(horizontalScrollPosition))
         {
            horizontalScrollPosition = 0;
         }
         timelineLayout.contentWidth = value;
         invalidateDisplayList();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         timelineLayout.viewportWidth = unscaledWidth;
         timelineLayout.viewportHeight = unscaledHeight;
         timelineLayout.update();
         setScrollBarProperties(timelineLayout.contentWidth + contentWidthOffset,unscaledWidth,timelineLayout.contentHeight,unscaledHeight);
      }
      
      private function set _746987523timeRanges(value:IList) : void
      {
         _timeRanges = value;
         timelineLayout.timeRanges = _timeRanges;
         invalidateDisplayList();
      }
   }
}

