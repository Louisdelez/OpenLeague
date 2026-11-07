package spark.layouts.supportClasses
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import mx.core.ILayoutElement;
   import mx.core.IVisualElement;
   import mx.core.UIComponent;
   import mx.core.UIComponentGlobals;
   import mx.events.DragEvent;
   import mx.events.PropertyChangeEvent;
   import mx.managers.ILayoutManagerClient;
   import mx.utils.OnDemandEventDispatcher;
   import spark.components.supportClasses.GroupBase;
   import spark.components.supportClasses.OverlayDepth;
   import spark.core.NavigationUnit;
   
   public class LayoutBase extends OnDemandEventDispatcher
   {
      
      private var _target:GroupBase;
      
      private var _useVirtualLayout:Boolean = false;
      
      private var _horizontalScrollPosition:Number = 0;
      
      private var _verticalScrollPosition:Number = 0;
      
      private var _clipAndEnableScrolling:Boolean = false;
      
      private var _typicalLayoutElement:ILayoutElement = null;
      
      private var _dropIndicator:DisplayObject;
      
      private var _dragScrollTimer:Timer;
      
      private var _dragScrollDelta:Point;
      
      private var _dragScrollEvent:DragEvent;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var dragScrollRegionSizeHorizontal:Number = 20;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var dragScrollRegionSizeVertical:Number = 20;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var dragScrollSpeed:Number = 5;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var dragScrollInitialDelay:int = 250;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var dragScrollInterval:int = 32;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var dragScrollHidesIndicator:Boolean = false;
      
      public function LayoutBase()
      {
         super();
      }
      
      public function get target() : GroupBase
      {
         return this._target;
      }
      
      public function set target(value:GroupBase) : void
      {
         if(this._target == value)
         {
            return;
         }
         this.clearVirtualLayoutCache();
         this._target = value;
      }
      
      [Inspectable(defaultValue="false")]
      public function get useVirtualLayout() : Boolean
      {
         return this._useVirtualLayout;
      }
      
      public function set useVirtualLayout(value:Boolean) : void
      {
         if(this._useVirtualLayout == value)
         {
            return;
         }
         dispatchEvent(new Event("useVirtualLayoutChanged"));
         if(this._useVirtualLayout && !value)
         {
            this.clearVirtualLayoutCache();
         }
         this._useVirtualLayout = value;
         if(Boolean(this.target))
         {
            this.target.invalidateDisplayList();
         }
      }
      
      public function clearVirtualLayoutCache() : void
      {
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get virtualLayoutSupported() : Boolean
      {
         return true;
      }
      
      [Inspectable(category="General",minValue="0.0")]
      [Bindable(event="propertyChange")]
      public function get horizontalScrollPosition() : Number
      {
         return this._horizontalScrollPosition;
      }
      
      private function set _754184102horizontalScrollPosition(value:Number) : void
      {
         if(value == this._horizontalScrollPosition)
         {
            return;
         }
         this._horizontalScrollPosition = value;
         this.scrollPositionChanged();
      }
      
      [Inspectable(category="General",minValue="0.0")]
      [Bindable(event="propertyChange")]
      public function get verticalScrollPosition() : Number
      {
         return this._verticalScrollPosition;
      }
      
      private function set _1010846676verticalScrollPosition(value:Number) : void
      {
         if(value == this._verticalScrollPosition)
         {
            return;
         }
         this._verticalScrollPosition = value;
         this.scrollPositionChanged();
      }
      
      [Inspectable(category="General",enumeration="true,false")]
      public function get clipAndEnableScrolling() : Boolean
      {
         return this._clipAndEnableScrolling;
      }
      
      public function set clipAndEnableScrolling(value:Boolean) : void
      {
         if(value == this._clipAndEnableScrolling)
         {
            return;
         }
         this._clipAndEnableScrolling = value;
         var g:GroupBase = this.target;
         if(Boolean(g))
         {
            this.updateScrollRect(g.width,g.height);
         }
      }
      
      public function get typicalLayoutElement() : ILayoutElement
      {
         if(Boolean(!this._typicalLayoutElement) && Boolean(this.target) && this.target.numElements > 0)
         {
            this._typicalLayoutElement = this.target.getElementAt(0);
         }
         return this._typicalLayoutElement;
      }
      
      public function set typicalLayoutElement(value:ILayoutElement) : void
      {
         if(this._typicalLayoutElement == value)
         {
            return;
         }
         this._typicalLayoutElement = value;
         var g:GroupBase = this.target;
         if(Boolean(g))
         {
            g.invalidateSize();
         }
      }
      
      public function get dropIndicator() : DisplayObject
      {
         return this._dropIndicator;
      }
      
      public function set dropIndicator(value:DisplayObject) : void
      {
         if(Boolean(this._dropIndicator))
         {
            this.target.overlay.removeDisplayObject(this._dropIndicator);
         }
         this._dropIndicator = value;
         if(Boolean(this._dropIndicator))
         {
            this._dropIndicator.visible = false;
            this.target.overlay.addDisplayObject(this._dropIndicator,OverlayDepth.DROP_INDICATOR);
            if(this._dropIndicator is ILayoutManagerClient)
            {
               UIComponentGlobals.layoutManager.validateClient(ILayoutManagerClient(this._dropIndicator),true);
            }
            if(this._dropIndicator is ILayoutElement)
            {
               ILayoutElement(this._dropIndicator).includeInLayout = false;
            }
         }
      }
      
      public function measure() : void
      {
      }
      
      public function updateDisplayList(width:Number, height:Number) : void
      {
      }
      
      public function elementAdded(index:int) : void
      {
      }
      
      public function elementRemoved(index:int) : void
      {
      }
      
      protected function scrollPositionChanged() : void
      {
         var g:GroupBase = this.target;
         if(!g)
         {
            return;
         }
         this.updateScrollRect(g.width,g.height);
      }
      
      public function updateScrollRect(w:Number, h:Number) : void
      {
         var hsp:Number = NaN;
         var vsp:Number = NaN;
         var g:GroupBase = this.target;
         if(!g)
         {
            return;
         }
         if(this.clipAndEnableScrolling)
         {
            hsp = this.horizontalScrollPosition;
            vsp = this.verticalScrollPosition;
            g.scrollRect = new Rectangle(hsp,vsp,w,h);
         }
         else
         {
            g.scrollRect = null;
         }
      }
      
      public function getNavigationDestinationIndex(currentIndex:int, navigationUnit:uint, arrowKeysWrapFocus:Boolean) : int
      {
         if(!this.target || this.target.numElements < 1)
         {
            return -1;
         }
         switch(navigationUnit)
         {
            case NavigationUnit.HOME:
               return 0;
            case NavigationUnit.END:
               return this.target.numElements - 1;
            default:
               return -1;
         }
      }
      
      protected function getScrollRect() : Rectangle
      {
         var g:GroupBase = this.target;
         if(!g || !g.clipAndEnableScrolling)
         {
            return null;
         }
         var vsp:Number = g.verticalScrollPosition;
         var hsp:Number = g.horizontalScrollPosition;
         return new Rectangle(hsp,vsp,g.width,g.height);
      }
      
      public function getElementBounds(index:int) : Rectangle
      {
         var g:GroupBase = this.target;
         if(!g)
         {
            return null;
         }
         var n:int = g.numElements;
         if(index < 0 || index >= n)
         {
            return null;
         }
         var elt:ILayoutElement = g.getElementAt(index);
         if(!elt || !elt.includeInLayout)
         {
            return null;
         }
         var eltX:Number = Number(elt.getLayoutBoundsX());
         var eltY:Number = Number(elt.getLayoutBoundsY());
         var eltW:Number = Number(elt.getLayoutBoundsWidth());
         var eltH:Number = Number(elt.getLayoutBoundsHeight());
         return new Rectangle(eltX,eltY,eltW,eltH);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getChildElementBounds(element:IVisualElement) : Rectangle
      {
         var g:GroupBase = null;
         var posPointStart:Point = null;
         var sizePoint:Point = null;
         var posPoint:Point = null;
         if(!element)
         {
            return new Rectangle(0,0,0,0);
         }
         var parentUIC:UIComponent = element.parent as UIComponent;
         if(Boolean(parentUIC))
         {
            g = this.target;
            posPointStart = new Point(element.getLayoutBoundsX(),element.getLayoutBoundsY());
            sizePoint = new Point(element.getLayoutBoundsWidth(),element.getLayoutBoundsHeight());
            posPoint = parentUIC.localToGlobal(posPointStart);
            posPoint = g.globalToLocal(posPoint);
            return new Rectangle(posPoint.x,posPoint.y,sizePoint.x,sizePoint.y);
         }
         return new Rectangle(0,0,0,0);
      }
      
      private function convertLocalToTarget(element:IVisualElement, elementLocalBounds:Rectangle) : Rectangle
      {
         var g:GroupBase = null;
         var posPointStart:Point = null;
         var posPoint:Point = null;
         if(!element)
         {
            return new Rectangle(0,0,0,0);
         }
         var parentUIC:UIComponent = element.parent as UIComponent;
         if(Boolean(parentUIC))
         {
            g = this.target;
            posPointStart = new Point(element.getLayoutBoundsX() + elementLocalBounds.x,element.getLayoutBoundsY() + elementLocalBounds.y);
            posPoint = parentUIC.localToGlobal(posPointStart);
            posPoint = g.globalToLocal(posPoint);
            return new Rectangle(posPoint.x,posPoint.y,elementLocalBounds.width,elementLocalBounds.height);
         }
         return new Rectangle(0,0,0,0);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function isElementVisible(elt:ILayoutElement) : Boolean
      {
         if(!elt || !elt.includeInLayout)
         {
            return false;
         }
         var g:GroupBase = this.target;
         if(!g || !g.clipAndEnableScrolling)
         {
            return true;
         }
         var vsp:Number = g.verticalScrollPosition;
         var hsp:Number = g.horizontalScrollPosition;
         var targetW:Number = Number(g.width);
         var targetH:Number = Number(g.height);
         var eltX:Number = Number(elt.getLayoutBoundsX());
         var eltY:Number = Number(elt.getLayoutBoundsY());
         var eltW:Number = Number(elt.getLayoutBoundsWidth());
         var eltH:Number = Number(elt.getLayoutBoundsHeight());
         return eltX < hsp + targetW && eltX + eltW > hsp && eltY < vsp + targetH && eltY + eltH > vsp;
      }
      
      protected function getElementBoundsLeftOfScrollRect(scrollRect:Rectangle) : Rectangle
      {
         var bounds:Rectangle = new Rectangle();
         bounds.left = scrollRect.left - 1;
         bounds.right = scrollRect.left;
         return bounds;
      }
      
      protected function getElementBoundsRightOfScrollRect(scrollRect:Rectangle) : Rectangle
      {
         var bounds:Rectangle = new Rectangle();
         bounds.left = scrollRect.right;
         bounds.right = scrollRect.right + 1;
         return bounds;
      }
      
      protected function getElementBoundsAboveScrollRect(scrollRect:Rectangle) : Rectangle
      {
         var bounds:Rectangle = new Rectangle();
         bounds.top = scrollRect.top - 1;
         bounds.bottom = scrollRect.top;
         return bounds;
      }
      
      protected function getElementBoundsBelowScrollRect(scrollRect:Rectangle) : Rectangle
      {
         var bounds:Rectangle = new Rectangle();
         bounds.top = scrollRect.bottom;
         bounds.bottom = scrollRect.bottom + 1;
         return bounds;
      }
      
      public function getHorizontalScrollPositionDelta(navigationUnit:uint) : Number
      {
         var getElementBounds:Rectangle = null;
         var g:GroupBase = this.target;
         if(!g)
         {
            return 0;
         }
         var scrollRect:Rectangle = this.getScrollRect();
         if(!scrollRect)
         {
            return 0;
         }
         if(scrollRect.x == 0 && scrollRect.width >= g.contentWidth)
         {
            return 0;
         }
         var maxDelta:Number = g.contentWidth - scrollRect.right;
         var minDelta:Number = -scrollRect.left;
         switch(navigationUnit)
         {
            case NavigationUnit.LEFT:
            case NavigationUnit.PAGE_LEFT:
               getElementBounds = this.getElementBoundsLeftOfScrollRect(scrollRect);
               break;
            case NavigationUnit.RIGHT:
            case NavigationUnit.PAGE_RIGHT:
               getElementBounds = this.getElementBoundsRightOfScrollRect(scrollRect);
               break;
            case NavigationUnit.HOME:
               return minDelta;
            case NavigationUnit.END:
               return maxDelta;
            default:
               return 0;
         }
         if(!getElementBounds)
         {
            return 0;
         }
         var delta:Number = 0;
         switch(navigationUnit)
         {
            case NavigationUnit.LEFT:
               delta = Math.max(getElementBounds.left - scrollRect.left,-scrollRect.width);
               break;
            case NavigationUnit.RIGHT:
               delta = Math.min(getElementBounds.right - scrollRect.right,scrollRect.width);
               break;
            case NavigationUnit.PAGE_LEFT:
               delta = getElementBounds.right - scrollRect.right;
               if(delta >= 0)
               {
                  delta = Math.max(getElementBounds.left - scrollRect.left,-scrollRect.width);
               }
               break;
            case NavigationUnit.PAGE_RIGHT:
               delta = getElementBounds.left - scrollRect.left;
               if(delta <= 0)
               {
                  delta = Math.min(getElementBounds.right - scrollRect.right,scrollRect.width);
               }
         }
         return Math.min(maxDelta,Math.max(minDelta,delta));
      }
      
      public function getVerticalScrollPositionDelta(navigationUnit:uint) : Number
      {
         var getElementBounds:Rectangle = null;
         var g:GroupBase = this.target;
         if(!g)
         {
            return 0;
         }
         var scrollRect:Rectangle = this.getScrollRect();
         if(!scrollRect)
         {
            return 0;
         }
         if(scrollRect.y == 0 && scrollRect.height >= g.contentHeight)
         {
            return 0;
         }
         var maxDelta:Number = g.contentHeight - scrollRect.bottom;
         var minDelta:Number = -scrollRect.top;
         switch(navigationUnit)
         {
            case NavigationUnit.UP:
            case NavigationUnit.PAGE_UP:
               getElementBounds = this.getElementBoundsAboveScrollRect(scrollRect);
               break;
            case NavigationUnit.DOWN:
            case NavigationUnit.PAGE_DOWN:
               getElementBounds = this.getElementBoundsBelowScrollRect(scrollRect);
               break;
            case NavigationUnit.HOME:
               return minDelta;
            case NavigationUnit.END:
               return maxDelta;
            default:
               return 0;
         }
         if(!getElementBounds)
         {
            return 0;
         }
         var delta:Number = 0;
         switch(navigationUnit)
         {
            case NavigationUnit.UP:
               delta = Math.max(getElementBounds.top - scrollRect.top,-scrollRect.height);
               break;
            case NavigationUnit.DOWN:
               delta = Math.min(getElementBounds.bottom - scrollRect.bottom,scrollRect.height);
               break;
            case NavigationUnit.PAGE_UP:
               delta = getElementBounds.bottom - scrollRect.bottom;
               if(delta >= 0)
               {
                  delta = Math.max(getElementBounds.top - scrollRect.top,-scrollRect.height);
               }
               break;
            case NavigationUnit.PAGE_DOWN:
               delta = getElementBounds.top - scrollRect.top;
               if(delta <= 0)
               {
                  delta = Math.min(getElementBounds.bottom - scrollRect.bottom,scrollRect.height);
               }
         }
         return Math.min(maxDelta,Math.max(minDelta,delta));
      }
      
      public function getScrollPositionDeltaToElement(index:int) : Point
      {
         return this.getScrollPositionDeltaToElementHelper(index);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getScrollPositionDeltaToElementHelper(index:int, topOffset:Number = NaN, bottomOffset:Number = NaN, leftOffset:Number = NaN, rightOffset:Number = NaN) : Point
      {
         var elementR:Rectangle = this.getElementBounds(index);
         return this.getScrollPositionDeltaToElementHelperHelper(elementR,null,true,topOffset,bottomOffset,leftOffset,rightOffset);
      }
      
      protected function getScrollPositionDeltaToElementHelperHelper(elementR:Rectangle, elementLocalBounds:Rectangle, entireElementVisible:Boolean = true, topOffset:Number = NaN, bottomOffset:Number = NaN, leftOffset:Number = NaN, rightOffset:Number = NaN) : Point
      {
         var dxl:Number = NaN;
         var dxr:Number = NaN;
         var dyt:Number = NaN;
         var dyb:Number = NaN;
         if(!elementR)
         {
            return null;
         }
         var scrollR:Rectangle = this.getScrollRect();
         if(!scrollR || !this.target.clipAndEnableScrolling)
         {
            return null;
         }
         if(isNaN(topOffset) && isNaN(bottomOffset) && isNaN(leftOffset) && isNaN(rightOffset) && (scrollR.containsRect(elementR) || !elementLocalBounds && elementR.containsRect(scrollR)))
         {
            return null;
         }
         var dx:Number = 0;
         var dy:Number = 0;
         if(entireElementVisible)
         {
            dxl = elementR.left - scrollR.left;
            dxr = elementR.right - scrollR.right;
            dyt = elementR.top - scrollR.top;
            dyb = elementR.bottom - scrollR.bottom;
            dx = Math.abs(dxl) < Math.abs(dxr) ? dxl : dxr;
            dy = Math.abs(dyt) < Math.abs(dyb) ? dyt : dyb;
            if(!isNaN(topOffset))
            {
               dy = dyt + topOffset;
            }
            else if(!isNaN(bottomOffset))
            {
               dy = dyb - bottomOffset;
            }
            if(!isNaN(leftOffset))
            {
               dx = dxl + leftOffset;
            }
            else if(!isNaN(rightOffset))
            {
               dx = dxr - rightOffset;
            }
            if(elementR.left >= scrollR.left && elementR.right <= scrollR.right)
            {
               dx = 0;
            }
            else if(elementR.bottom <= scrollR.bottom && elementR.top >= scrollR.top)
            {
               dy = 0;
            }
            if(elementR.left <= scrollR.left && elementR.right >= scrollR.right)
            {
               dx = 0;
            }
            else if(elementR.bottom >= scrollR.bottom && elementR.top <= scrollR.top)
            {
               dy = 0;
            }
         }
         if(Boolean(elementLocalBounds))
         {
            if(elementR.width > scrollR.width || !entireElementVisible)
            {
               if(elementLocalBounds.left < scrollR.left)
               {
                  dx = elementLocalBounds.left - scrollR.left;
               }
               else if(elementLocalBounds.right > scrollR.right)
               {
                  dx = elementLocalBounds.right - scrollR.right;
               }
            }
            if(elementR.height > scrollR.height || !entireElementVisible)
            {
               if(elementLocalBounds.bottom > scrollR.bottom)
               {
                  dy = elementLocalBounds.bottom - scrollR.bottom;
               }
               else if(elementLocalBounds.top <= scrollR.top)
               {
                  dy = elementLocalBounds.top - scrollR.top;
               }
            }
         }
         return new Point(dx,dy);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getScrollPositionDeltaToAnyElement(element:IVisualElement, elementLocalBounds:Rectangle = null, entireElementVisible:Boolean = true, topOffset:Number = NaN, bottomOffset:Number = NaN, leftOffset:Number = NaN, rightOffset:Number = NaN) : Point
      {
         var elementR:Rectangle = this.getChildElementBounds(element);
         if(Boolean(elementLocalBounds))
         {
            elementLocalBounds = this.convertLocalToTarget(element,elementLocalBounds);
         }
         return this.getScrollPositionDeltaToElementHelperHelper(elementR,elementLocalBounds,entireElementVisible,topOffset,bottomOffset,leftOffset,rightOffset);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getElementNearestScrollPosition(position:Point, elementComparePoint:String = "center") : int
      {
         var i:int = 0;
         var rect:Rectangle = null;
         var dist:int = 0;
         var elementPoint:Point = null;
         var num:int = this.target.numElements;
         var minDistance:Number = Number.MAX_VALUE;
         var minDistanceElement:int = -1;
         for(i = 0; i < num; i++)
         {
            rect = this.getElementBounds(i);
            if(rect != null)
            {
               elementPoint = null;
               switch(elementComparePoint)
               {
                  case "topLeft":
                     elementPoint = rect.topLeft;
                     break;
                  case "bottomRight":
                     elementPoint = rect.bottomRight;
                     break;
                  case "bottomLeft":
                     elementPoint = new Point(rect.left,rect.bottom);
                     break;
                  case "topRight":
                     elementPoint = new Point(rect.right,rect.top);
                     break;
                  case "center":
                     elementPoint = new Point(rect.left + rect.width / 2,rect.top + rect.height / 2);
               }
               dist = Point.distance(position,elementPoint);
               if(dist < minDistance)
               {
                  minDistance = dist;
                  minDistanceElement = i;
               }
            }
         }
         return minDistanceElement;
      }
      
      public function calculateDropLocation(dragEvent:DragEvent) : DropLocation
      {
         var dropPoint:Point = this.globalToLocal(dragEvent.stageX,dragEvent.stageY);
         var dropIndex:int = this.calculateDropIndex(dropPoint.x,dropPoint.y);
         if(dropIndex == -1)
         {
            return null;
         }
         var dropLocation:DropLocation = new DropLocation();
         dropLocation.dragEvent = dragEvent;
         dropLocation.dropPoint = dropPoint;
         dropLocation.dropIndex = dropIndex;
         return dropLocation;
      }
      
      public function showDropIndicator(dropLocation:DropLocation) : void
      {
         var element:ILayoutElement = null;
         if(!this._dropIndicator)
         {
            return;
         }
         this._dropIndicator.visible = false;
         var dragScrollElapsedTime:int = 0;
         if(Boolean(this._dragScrollTimer))
         {
            dragScrollElapsedTime = this._dragScrollTimer.currentCount * this._dragScrollTimer.delay;
         }
         this._dragScrollDelta = this.calculateDragScrollDelta(dropLocation,dragScrollElapsedTime);
         if(Boolean(this._dragScrollDelta))
         {
            this._dragScrollEvent = dropLocation.dragEvent;
            if(!this.dragScrollingInProgress())
            {
               this.startDragScrolling();
               return;
            }
            if(this.dragScrollHidesIndicator)
            {
               return;
            }
         }
         else
         {
            this.stopDragScrolling();
         }
         var bounds:Rectangle = this.calculateDropIndicatorBounds(dropLocation);
         if(!bounds)
         {
            return;
         }
         if(this._dropIndicator is ILayoutElement)
         {
            element = ILayoutElement(this._dropIndicator);
            element.setLayoutBoundsSize(bounds.width,bounds.height);
            element.setLayoutBoundsPosition(bounds.x,bounds.y);
         }
         else
         {
            this._dropIndicator.width = bounds.width;
            this._dropIndicator.height = bounds.height;
            this._dropIndicator.x = bounds.x;
            this._dropIndicator.y = bounds.y;
         }
         this._dropIndicator.visible = true;
      }
      
      public function hideDropIndicator() : void
      {
         this.stopDragScrolling();
         if(Boolean(this._dropIndicator))
         {
            this._dropIndicator.visible = false;
         }
      }
      
      protected function calculateDropIndex(x:Number, y:Number) : int
      {
         return this.target.numElements;
      }
      
      protected function calculateDropIndicatorBounds(dropLocation:DropLocation) : Rectangle
      {
         return null;
      }
      
      protected function calculateDragScrollDelta(dropLocation:DropLocation, elapsedTime:Number) : Point
      {
         var layoutTarget:GroupBase = this.target;
         if(layoutTarget.numElements == 0)
         {
            return null;
         }
         var scrollRect:Rectangle = this.getScrollRect();
         if(!scrollRect)
         {
            return null;
         }
         var x:Number = dropLocation.dropPoint.x;
         var y:Number = dropLocation.dropPoint.y;
         var horizontalRegionSize:Number = Math.min(this.dragScrollRegionSizeHorizontal,layoutTarget.width / 2);
         var verticalRegionSize:Number = Math.min(this.dragScrollRegionSizeVertical,layoutTarget.height / 2);
         if(scrollRect.left + horizontalRegionSize < x && x < scrollRect.right - horizontalRegionSize && scrollRect.top + verticalRegionSize < y && y < scrollRect.bottom - verticalRegionSize)
         {
            return null;
         }
         if(elapsedTime < this.dragScrollInitialDelay)
         {
            return new Point();
         }
         elapsedTime -= this.dragScrollInitialDelay;
         var timeSpeedUp:Number = Math.min(elapsedTime,2000) / 2000;
         timeSpeedUp *= 3;
         timeSpeedUp += 1;
         timeSpeedUp *= timeSpeedUp * this.dragScrollSpeed * this.dragScrollInterval / 50;
         var minDeltaX:Number = -scrollRect.left;
         var minDeltaY:Number = -scrollRect.top;
         var maxDeltaY:Number = this.target.contentHeight - scrollRect.bottom;
         var maxDeltaX:Number = this.target.contentWidth - scrollRect.right;
         var deltaX:Number = 0;
         var deltaY:Number = 0;
         if(minDeltaX != 0 && x - scrollRect.left < horizontalRegionSize)
         {
            deltaX = 1 - (x - scrollRect.left) / horizontalRegionSize;
            deltaX *= deltaX * timeSpeedUp;
            deltaX = -Math.round(deltaX) - 1;
         }
         else if(maxDeltaX != 0 && scrollRect.right - x < horizontalRegionSize)
         {
            deltaX = 1 - (scrollRect.right - x) / horizontalRegionSize;
            deltaX *= deltaX * timeSpeedUp;
            deltaX = Math.round(deltaX) + 1;
         }
         if(minDeltaY != 0 && y - scrollRect.top < verticalRegionSize)
         {
            deltaY = 1 - (y - scrollRect.top) / verticalRegionSize;
            deltaY *= deltaY * timeSpeedUp;
            deltaY = -Math.round(deltaY) - 1;
         }
         else if(maxDeltaY != 0 && scrollRect.bottom - y < verticalRegionSize)
         {
            deltaY = 1 - (scrollRect.bottom - y) / verticalRegionSize;
            deltaY *= deltaY * timeSpeedUp;
            deltaY = Math.round(deltaY) + 1;
         }
         deltaX = Math.max(minDeltaX,Math.min(maxDeltaX,deltaX));
         deltaY = Math.max(minDeltaY,Math.min(maxDeltaY,deltaY));
         if(deltaX == 0 && deltaY == 0)
         {
            return null;
         }
         return new Point(deltaX,deltaY);
      }
      
      private function dragScrollingInProgress() : Boolean
      {
         return this._dragScrollTimer != null;
      }
      
      private function startDragScrolling() : void
      {
         if(Boolean(this._dragScrollTimer))
         {
            return;
         }
         this._dragScrollTimer = new Timer(this.dragScrollInterval);
         this._dragScrollTimer.addEventListener(TimerEvent.TIMER,this.dragScroll);
         this._dragScrollTimer.start();
         this.dragScroll(null);
      }
      
      private function dragScroll(event:TimerEvent) : void
      {
         this.horizontalScrollPosition += this._dragScrollDelta.x;
         this.verticalScrollPosition += this._dragScrollDelta.y;
         this.target.validateNow();
         var dragEvent:DragEvent = new DragEvent(DragEvent.DRAG_OVER,this._dragScrollEvent.bubbles,this._dragScrollEvent.cancelable,this._dragScrollEvent.dragInitiator,this._dragScrollEvent.dragSource,this._dragScrollEvent.action,this._dragScrollEvent.ctrlKey,this._dragScrollEvent.altKey,this._dragScrollEvent.shiftKey);
         dragEvent.draggedItem = this._dragScrollEvent.draggedItem;
         dragEvent.localX = this._dragScrollEvent.localX;
         dragEvent.localY = this._dragScrollEvent.localY;
         dragEvent.relatedObject = this._dragScrollEvent.relatedObject;
         this._dragScrollEvent.target.dispatchEvent(dragEvent);
      }
      
      private function stopDragScrolling() : void
      {
         if(Boolean(this._dragScrollTimer))
         {
            this._dragScrollTimer.stop();
            this._dragScrollTimer.removeEventListener(TimerEvent.TIMER,this.dragScroll);
            this._dragScrollTimer = null;
         }
         this._dragScrollEvent = null;
         this._dragScrollDelta = null;
      }
      
      private function globalToLocal(x:Number, y:Number) : Point
      {
         var layoutTarget:GroupBase = this.target;
         var parent:DisplayObject = layoutTarget.parent;
         var local:Point = parent.globalToLocal(new Point(x,y));
         local.x -= layoutTarget.x;
         local.y -= layoutTarget.y;
         var scrollRect:Rectangle = this.getScrollRect();
         if(Boolean(scrollRect))
         {
            local.x += scrollRect.x;
            local.y += scrollRect.y;
         }
         return local;
      }
      
      public function set verticalScrollPosition(param1:Number) : void
      {
         var _loc2_:Object = this.verticalScrollPosition;
         if(_loc2_ !== param1)
         {
            this._1010846676verticalScrollPosition = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"verticalScrollPosition",_loc2_,param1));
            }
         }
      }
      
      public function set horizontalScrollPosition(param1:Number) : void
      {
         var _loc2_:Object = this.horizontalScrollPosition;
         if(_loc2_ !== param1)
         {
            this._754184102horizontalScrollPosition = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"horizontalScrollPosition",_loc2_,param1));
            }
         }
      }
   }
}

