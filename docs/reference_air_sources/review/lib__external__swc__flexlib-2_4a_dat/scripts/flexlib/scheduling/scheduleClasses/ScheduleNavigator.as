package flexlib.scheduling.scheduleClasses
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flexlib.scheduling.ScheduleViewer;
   import flexlib.scheduling.scheduleClasses.layout.EntryLayoutItem;
   import flexlib.scheduling.scheduleClasses.layout.IEntryLayout;
   import mx.controls.scrollClasses.ScrollBar;
   import mx.core.ScrollPolicy;
   import mx.effects.AnimateProperty;
   import mx.events.EffectEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.ScrollEvent;
   import mx.events.ScrollEventDirection;
   
   use namespace schedule_internal;
   
   [Event(name="invalidateDisplayList",type="flash.events.Event")]
   public class ScheduleNavigator extends EventDispatcher
   {
      
      public static const INVALIDATE_DISPLAY_LIST:String = "invalidateDisplayList";
      
      private var hasPixelScrollWhileAnimating:Boolean;
      
      private var _yPositionWithOffset:Number;
      
      private var _yOffset:Number;
      
      private var _zoom:Number;
      
      public var contentHeightOffset:Number;
      
      private var _xPosition:Number;
      
      private var _yPosition:Number;
      
      public var contentWidthOffset:Number;
      
      private var owner:ScheduleViewer;
      
      private var _xPositionWithOffset:Number;
      
      private var _xOffset:Number;
      
      private var _pixelScrollEnabled:Boolean;
      
      public var entryLayoutImpl:IEntryLayout;
      
      public function ScheduleNavigator(owner:ScheduleViewer)
      {
         super();
         this.owner = owner;
         owner.horizontalScrollPolicy = ScrollPolicy.AUTO;
         owner.verticalScrollPolicy = ScrollPolicy.AUTO;
         pixelScrollEnabled = true;
         _xPosition = 0;
         _yPosition = 0;
         _xPositionWithOffset = 0;
         _yPositionWithOffset = 0;
         _zoom = 100;
         xOffset = 50;
         yOffset = 50;
         contentWidthOffset = 0;
         contentHeightOffset = 0;
      }
      
      [Bindable(event="propertyChange")]
      public function set xPosition(value:Number) : void
      {
         var oldValue:Object = null;
         oldValue = this.xPosition;
         if(oldValue !== value)
         {
            this._1333721663xPosition = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"xPosition",oldValue,value));
         }
      }
      
      private function animateVerticalScrollPosition(position:Number) : void
      {
         var e:AnimateProperty = null;
         if(!pixelScrollEnabled)
         {
            pixelScrollEnabled = true;
            hasPixelScrollWhileAnimating = true;
         }
         e = new AnimateProperty(this);
         e.property = "yPosition";
         e.fromValue = owner.verticalScrollPosition;
         e.toValue = position - owner.yOffset;
         e.duration = owner.getStyle("moveDuration");
         e.easingFunction = owner.getStyle("moveEasingFunction") as Function;
         e.addEventListener(EffectEvent.EFFECT_END,verticalAnimationEnd);
         e.play();
      }
      
      private function isItemScroll() : Boolean
      {
         return owner.verticalScrollBar != null && !pixelScrollEnabled;
      }
      
      [Bindable(event="propertyChange")]
      public function set yPosition(value:Number) : void
      {
         var oldValue:Object = null;
         oldValue = this.yPosition;
         if(oldValue !== value)
         {
            this._1153791170yPosition = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"yPosition",oldValue,value));
         }
      }
      
      private function set _1485313835xOffset(value:Number) : void
      {
         _xOffset = value;
      }
      
      public function onScroll(event:ScrollEvent) : void
      {
         var position:Number = NaN;
         var newIndex:Number = NaN;
         var oldIndex:Number = NaN;
         var delta:Number = NaN;
         var itemScrollEvent:LayoutScrollEvent = null;
         position = Number(event.position);
         if(event.direction == ScrollEventDirection.HORIZONTAL)
         {
            setXPosition(position);
         }
         else
         {
            newIndex = Math.floor(position / owner.rowHeight);
            oldIndex = Math.floor(entryLayoutImpl.yPosition / owner.rowHeight);
            delta = oldIndex - newIndex;
            setYPosition(position);
            if(delta != 0)
            {
               itemScrollEvent = new LayoutScrollEvent(LayoutScrollEvent.ITEM_SCROLL);
               itemScrollEvent.direction = event.direction;
               itemScrollEvent.position = newIndex;
               itemScrollEvent.delta = delta;
               itemScrollEvent.detail = event.detail;
               owner.dispatchEvent(itemScrollEvent);
            }
         }
      }
      
      private function set _1153791170yPosition(position:Number) : void
      {
         var overlap:Number = NaN;
         _yPosition = position;
         setVerticalScrollPosition(position);
         overlap = entryLayoutImpl.contentHeight - entryLayoutImpl.viewportHeight;
         if(overlap < position)
         {
            contentHeightOffset = position - overlap;
            dispatchEvent(new Event(ScheduleNavigator.INVALIDATE_DISPLAY_LIST));
         }
      }
      
      private function setYPosition(position:Number) : void
      {
         entryLayoutImpl.yPosition = position;
         entryLayoutImpl.update();
      }
      
      [Bindable]
      public function get yOffset() : Number
      {
         return _yOffset;
      }
      
      [Bindable]
      public function get xPositionWithOffset() : Number
      {
         return _xPositionWithOffset;
      }
      
      public function moveToTime(milliseconds:Number) : void
      {
         var position:Number = NaN;
         position = milliseconds * entryLayoutImpl.contentWidth / entryLayoutImpl.totalMilliseconds;
         animateHorizontalScrollPosition(position);
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
      
      public function set pixelScrollEnabled(value:Boolean) : void
      {
         _pixelScrollEnabled = value;
         dispatchEvent(new Event(ScheduleNavigator.INVALIDATE_DISPLAY_LIST));
      }
      
      public function moveToEntry(entry:IScheduleEntry) : void
      {
         var milliseconds:Number = NaN;
         var item:EntryLayoutItem = null;
         milliseconds = entry.startDate.getTime() - entryLayoutImpl.startDate.getTime();
         moveToTime(milliseconds);
         item = entryLayoutImpl.findLayoutItem(entry);
         animateVerticalScrollPosition(item.y);
      }
      
      private function set _973577051yPositionWithOffset(position:Number) : void
      {
         _yPositionWithOffset = position - yOffset;
         setVerticalScrollPosition(_yPositionWithOffset);
      }
      
      private function setVerticalScrollPosition(value:Number) : void
      {
         var event:ScrollEvent = null;
         var itemScrollEvent:LayoutScrollEvent = null;
         event = new ScrollEvent(ScrollEvent.SCROLL);
         event.direction = ScrollEventDirection.VERTICAL;
         event.position = value;
         event.delta = owner.verticalScrollPosition - value;
         event.detail = "custom";
         owner.verticalScrollPosition = value;
         owner.dispatchEvent(event);
         itemScrollEvent = new LayoutScrollEvent(LayoutScrollEvent.PIXEL_SCROLL);
         itemScrollEvent.direction = ScrollEventDirection.VERTICAL;
         itemScrollEvent.position = value;
         itemScrollEvent.delta = owner.verticalScrollPosition - value;
         itemScrollEvent.detail = "custom";
         owner.dispatchEvent(itemScrollEvent);
      }
      
      public function mouseWheelHandler(event:MouseEvent) : void
      {
         var verticalScrollBar:ScrollBar = null;
         var oldPosition:Number = NaN;
         var newPos:int = 0;
         var lineScrollSize:Number = NaN;
         var scrollEvent:ScrollEvent = null;
         verticalScrollBar = owner.verticalScrollBar;
         oldPosition = Number(owner.verticalScrollPosition);
         newPos = int(owner.verticalScrollPosition);
         if(!isItemScroll())
         {
            lineScrollSize = owner.rowHeight / 3;
         }
         else
         {
            lineScrollSize = verticalScrollBar.lineScrollSize / 3;
         }
         newPos -= event.delta * lineScrollSize;
         newPos = Math.max(0,Math.min(newPos,verticalScrollBar.maxScrollPosition));
         owner.verticalScrollPosition = newPos;
         if(oldPosition != owner.verticalScrollPosition)
         {
            scrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
            scrollEvent.direction = ScrollEventDirection.VERTICAL;
            scrollEvent.position = getPixelOrItemScroll(owner.verticalScrollPosition);
            scrollEvent.delta = owner.verticalScrollPosition - oldPosition;
            owner.dispatchEvent(scrollEvent);
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
      
      [Bindable(event="propertyChange")]
      public function set xPositionWithOffset(value:Number) : void
      {
         var oldValue:Object = null;
         oldValue = this.xPositionWithOffset;
         if(oldValue !== value)
         {
            this._1818048922xPositionWithOffset = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"xPositionWithOffset",oldValue,value));
         }
      }
      
      public function scrollHandler(event:Event) : void
      {
         var scrollEvent:ScrollEvent = null;
         scrollEvent = ScrollEvent(event);
         if(scrollEvent.direction == ScrollEventDirection.VERTICAL)
         {
            scrollEvent.position = getPixelOrItemScroll(scrollEvent.position);
         }
         onScroll(scrollEvent);
      }
      
      [Bindable]
      public function get xPosition() : Number
      {
         return _xPosition;
      }
      
      [Bindable(event="propertyChange")]
      public function set yPositionWithOffset(value:Number) : void
      {
         var oldValue:Object = null;
         oldValue = this.yPositionWithOffset;
         if(oldValue !== value)
         {
            this._973577051yPositionWithOffset = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"yPositionWithOffset",oldValue,value));
         }
      }
      
      private function set _1333721663xPosition(position:Number) : void
      {
         var overlap:Number = NaN;
         _xPosition = position;
         setHorizontalScrollPosition(position);
         overlap = entryLayoutImpl.contentWidth - entryLayoutImpl.viewportWidth;
         if(overlap < position)
         {
            contentWidthOffset = position - overlap;
            dispatchEvent(new Event(ScheduleNavigator.INVALIDATE_DISPLAY_LIST));
         }
      }
      
      [Bindable]
      public function get yPosition() : Number
      {
         return _yPosition;
      }
      
      public function get pixelScrollEnabled() : Boolean
      {
         return _pixelScrollEnabled;
      }
      
      private function set _3744723zoom(value:Number) : void
      {
         var adjustedValue:Number = NaN;
         _zoom = value;
         adjustedValue = value / 100 * Math.sqrt(owner.width);
         contentWidth = Math.pow(adjustedValue,2);
      }
      
      [Bindable]
      public function get zoom() : Number
      {
         return _zoom;
      }
      
      private function set _824110285contentWidth(value:Number) : void
      {
         owner.horizontalScrollPosition *= value / entryLayoutImpl.contentWidth;
         if(isNaN(owner.horizontalScrollPosition))
         {
            owner.horizontalScrollPosition = 0;
         }
         entryLayoutImpl.contentWidth = value;
         dispatchEvent(new Event(ScheduleNavigator.INVALIDATE_DISPLAY_LIST));
      }
      
      public function gotoEntry(entry:IScheduleEntry) : void
      {
         var milliseconds:Number = NaN;
         var item:EntryLayoutItem = null;
         milliseconds = entry.startDate.getTime() - entryLayoutImpl.startDate.getTime();
         gotoTime(milliseconds);
         item = entryLayoutImpl.findLayoutItem(entry);
         owner.yPosition = item.y;
      }
      
      private function set _1818048922xPositionWithOffset(position:Number) : void
      {
         _xPositionWithOffset = position - xOffset;
         setHorizontalScrollPosition(_xPositionWithOffset);
      }
      
      [Bindable]
      public function get contentWidth() : Number
      {
         return entryLayoutImpl.contentWidth;
      }
      
      [Bindable(event="propertyChange")]
      public function set xOffset(value:Number) : void
      {
         var oldValue:Object = null;
         oldValue = this.xOffset;
         if(oldValue !== value)
         {
            this._1485313835xOffset = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"xOffset",oldValue,value));
         }
      }
      
      private function set _1922149780yOffset(value:Number) : void
      {
         _yOffset = value;
      }
      
      [Bindable]
      public function get yPositionWithOffset() : Number
      {
         return _yPositionWithOffset;
      }
      
      private function setHorizontalScrollPosition(value:Number) : void
      {
         var event:ScrollEvent = null;
         var itemScrollEvent:LayoutScrollEvent = null;
         event = new ScrollEvent(ScrollEvent.SCROLL);
         event.direction = ScrollEventDirection.HORIZONTAL;
         event.position = value;
         event.delta = owner.horizontalScrollPosition - value;
         event.detail = "custom";
         owner.horizontalScrollPosition = value;
         owner.dispatchEvent(event);
         itemScrollEvent = new LayoutScrollEvent(LayoutScrollEvent.PIXEL_SCROLL);
         itemScrollEvent.direction = ScrollEventDirection.HORIZONTAL;
         itemScrollEvent.position = value;
         itemScrollEvent.delta = owner.horizontalScrollPosition - value;
         itemScrollEvent.detail = "custom";
         owner.dispatchEvent(itemScrollEvent);
      }
      
      private function verticalAnimationEnd(event:EffectEvent) : void
      {
         if(hasPixelScrollWhileAnimating)
         {
            pixelScrollEnabled = false;
            hasPixelScrollWhileAnimating = false;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set yOffset(value:Number) : void
      {
         var oldValue:Object = null;
         oldValue = this.yOffset;
         if(oldValue !== value)
         {
            this._1922149780yOffset = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"yOffset",oldValue,value));
         }
      }
      
      public function gotoTime(milliseconds:Number) : void
      {
         var position:Number = NaN;
         position = milliseconds * entryLayoutImpl.contentWidth / entryLayoutImpl.totalMilliseconds;
         owner.xPosition = position;
      }
      
      public function updateItemScroll() : void
      {
         if(isItemScroll())
         {
            owner.yOffset = convertPixelToItemPosition(owner.yOffset);
            owner.verticalScrollBar.lineScrollSize = owner.rowHeight;
         }
      }
      
      private function animateHorizontalScrollPosition(position:Number) : void
      {
         var e:AnimateProperty = null;
         e = new AnimateProperty(this);
         e.property = "xPosition";
         e.fromValue = owner.horizontalScrollPosition;
         e.toValue = position - owner.xOffset;
         e.duration = owner.getStyle("moveDuration");
         e.easingFunction = owner.getStyle("moveEasingFunction") as Function;
         e.play();
      }
      
      [Bindable]
      public function get xOffset() : Number
      {
         return _xOffset;
      }
      
      private function convertPixelToItemPosition(pixelPosition:Number) : Number
      {
         var rowCount:Number = NaN;
         rowCount = pixelPosition / owner.rowHeight;
         return Math.floor(rowCount) * owner.rowHeight;
      }
      
      private function getPixelOrItemScroll(pixelPosition:Number) : Number
      {
         var position:Number = NaN;
         position = pixelPosition;
         if(!pixelScrollEnabled)
         {
            position = convertPixelToItemPosition(position);
         }
         return position;
      }
      
      private function setXPosition(position:Number) : void
      {
         entryLayoutImpl.xPosition = position;
         entryLayoutImpl.update();
      }
   }
}

