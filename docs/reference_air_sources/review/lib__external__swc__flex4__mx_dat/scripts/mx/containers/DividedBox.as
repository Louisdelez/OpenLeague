package mx.containers
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import mx.containers.dividedBoxClasses.BoxDivider;
   import mx.core.EdgeMetrics;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.IInvalidating;
   import mx.core.IUIComponent;
   import mx.core.UIComponent;
   import mx.events.ChildExistenceChangedEvent;
   import mx.events.DividerEvent;
   import mx.managers.CursorManager;
   import mx.managers.CursorManagerPriority;
   
   [IconFile("DividedBox.png")]
   [Exclude(name="focusOutEffect",kind="effect")]
   [Exclude(name="focusInEffect",kind="effect")]
   [Exclude(name="focusThickness",kind="style")]
   [Exclude(name="focusSkin",kind="style")]
   [Exclude(name="focusBlendMode",kind="style")]
   [Exclude(name="focusOut",kind="event")]
   [Exclude(name="focusIn",kind="event")]
   [Style(name="verticalDividerCursor",type="Class",inherit="no")]
   [Style(name="horizontalDividerCursor",type="Class",inherit="no")]
   [Style(name="dividerThickness",type="Number",format="Length",inherit="no")]
   [Style(name="dividerSkin",type="Class",inherit="no")]
   [Style(name="dividerColor",type="uint",format="Color",inherit="yes")]
   [Style(name="dividerAlpha",type="Number",inherit="no")]
   [Style(name="dividerAffordance",type="Number",format="Length",inherit="no")]
   [Event(name="dividerRelease",type="mx.events.DividerEvent")]
   [Event(name="dividerPress",type="mx.events.DividerEvent")]
   [Event(name="dividerDrag",type="mx.events.DividerEvent")]
   public class DividedBox extends Box
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const PROXY_DIVIDER_INDEX:int = 999;
      
      private var dividerLayer:UIComponent = null;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var activeDivider:BoxDivider;
      
      private var activeDividerIndex:int = -1;
      
      private var activeDividerStartPosition:Number;
      
      private var dragStartPosition:Number;
      
      private var dragDelta:Number;
      
      private var oldChildSizes:Array;
      
      private var minDelta:Number;
      
      private var maxDelta:Number;
      
      private var dontCoalesceDividers:Boolean;
      
      private var cursorID:int = 0;
      
      private var dbMinWidth:Number;
      
      private var dbMinHeight:Number;
      
      private var dbPreferredWidth:Number;
      
      private var dbPreferredHeight:Number;
      
      private var layoutStyleChanged:Boolean = false;
      
      private var _resizeToContent:Boolean = false;
      
      private var numLayoutChildren:int = 0;
      
      protected var dividerClass:Class = BoxDivider;
      
      [Inspectable(category="General")]
      public var liveDragging:Boolean = false;
      
      private var postLayoutChanges:Array;
      
      public function DividedBox()
      {
         super();
         addEventListener(ChildExistenceChangedEvent.CHILD_ADD,this.childAddHandler);
         addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE,this.childRemoveHandler);
         showInAutomationHierarchy = true;
      }
      
      override public function set moduleFactory(moduleFactory:IFlexModuleFactory) : void
      {
         super.moduleFactory = moduleFactory;
         styleManager.registerSizeInvalidatingStyle("dividerAffordance");
         styleManager.registerSizeInvalidatingStyle("dividerThickness");
      }
      
      override public function set direction(value:String) : void
      {
         var i:int = 0;
         if(super.direction != value)
         {
            super.direction = value;
            if(Boolean(this.dividerLayer))
            {
               for(i = 0; i < this.dividerLayer.numChildren; i++)
               {
                  this.getDividerAt(i).invalidateDisplayList();
               }
            }
         }
      }
      
      public function get numDividers() : int
      {
         if(Boolean(this.dividerLayer))
         {
            if(!this.liveDragging && Boolean(this.activeDivider))
            {
               return this.dividerLayer.numChildren - 1;
            }
            return this.dividerLayer.numChildren;
         }
         return 0;
      }
      
      public function get resizeToContent() : Boolean
      {
         return this._resizeToContent;
      }
      
      public function set resizeToContent(value:Boolean) : void
      {
         if(value != this._resizeToContent)
         {
            this._resizeToContent = value;
            if(value)
            {
               invalidateSize();
            }
         }
      }
      
      override protected function measure() : void
      {
         var wPadding:Number = NaN;
         var hPadding:Number = NaN;
         var child:IUIComponent = null;
         var prefW:Number = NaN;
         var prefH:Number = NaN;
         var minW:Number = NaN;
         var minH:Number = NaN;
         var wFlex:Boolean = false;
         var hFlex:Boolean = false;
         var smallestMinW:Number = NaN;
         var smallestMinH:Number = NaN;
         super.measure();
         if(!isNaN(this.dbPreferredWidth) && !this._resizeToContent && !this.layoutStyleChanged)
         {
            measuredMinWidth = this.dbMinWidth;
            measuredMinHeight = this.dbMinHeight;
            measuredWidth = this.dbPreferredWidth;
            measuredHeight = this.dbPreferredHeight;
            return;
         }
         this.layoutStyleChanged = false;
         var isVertical:Boolean = this.isVertical();
         var minWidth:Number = 0;
         var minHeight:Number = 0;
         var preferredWidth:Number = 0;
         var preferredHeight:Number = 0;
         var n:int = numChildren;
         for(var i:int = 0; i < n; i++)
         {
            child = getLayoutChildAt(i);
            if(child.includeInLayout)
            {
               prefW = Number(child.getExplicitOrMeasuredWidth());
               prefH = Number(child.getExplicitOrMeasuredHeight());
               minW = Number(child.minWidth);
               minH = Number(child.minHeight);
               wFlex = !isNaN(child.percentWidth);
               hFlex = !isNaN(child.percentHeight);
               smallestMinW = Math.min(prefW,minW);
               smallestMinH = Math.min(prefH,minH);
               if(isVertical)
               {
                  minWidth = Math.max(wFlex ? minW : prefW,minWidth);
                  preferredWidth = Math.max(prefW,preferredWidth);
                  minHeight += hFlex ? smallestMinH : prefH;
                  preferredHeight += prefH;
               }
               else
               {
                  minWidth += wFlex ? smallestMinW : prefW;
                  preferredWidth += prefW;
                  minHeight = Math.max(hFlex ? minH : prefH,minHeight);
                  preferredHeight = Math.max(prefH,preferredHeight);
               }
            }
         }
         wPadding = layoutObject.widthPadding(this.numLayoutChildren);
         hPadding = layoutObject.heightPadding(this.numLayoutChildren);
         measuredMinWidth = this.dbMinWidth = minWidth + wPadding;
         measuredMinHeight = this.dbMinHeight = minHeight + hPadding;
         measuredWidth = this.dbPreferredWidth = preferredWidth + wPadding;
         measuredHeight = this.dbPreferredHeight = preferredHeight + hPadding;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var n:int = 0;
         var i:int = 0;
         var child:IUIComponent = null;
         if(!this.liveDragging && Boolean(this.activeDivider))
         {
            n = numChildren;
            for(i = 0; i < n; i++)
            {
               child = getLayoutChildAt(i);
               if(child.includeInLayout)
               {
                  child.measuredMinWidth = 0;
                  child.measuredMinHeight = 0;
               }
            }
            return;
         }
         this.preLayoutAdjustment();
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         this.postLayoutAdjustment();
         if(!this.dividerLayer)
         {
            return;
         }
         var vm:EdgeMetrics = viewMetrics;
         this.dividerLayer.x = vm.left;
         this.dividerLayer.y = vm.top;
         var prevChild:IUIComponent = null;
         var dividerIndex:int = 0;
         n = numChildren;
         for(i = 0; i < n; i++)
         {
            child = UIComponent(getChildAt(i));
            if(child.includeInLayout)
            {
               if(Boolean(prevChild))
               {
                  this.layoutDivider(dividerIndex,unscaledWidth,unscaledHeight,prevChild,child);
                  dividerIndex++;
               }
               prevChild = child;
            }
         }
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var n:int = 0;
         var i:int = 0;
         super.styleChanged(styleProp);
         if(Boolean(this.dividerLayer))
         {
            n = int(this.dividerLayer.numChildren);
            for(i = 0; i < n; i++)
            {
               this.getDividerAt(i).styleChanged(styleProp);
            }
         }
         if(styleManager.isSizeInvalidatingStyle(styleProp))
         {
            this.layoutStyleChanged = true;
         }
      }
      
      override protected function scrollChildren() : void
      {
         super.scrollChildren();
         if(Boolean(contentPane) && Boolean(this.dividerLayer))
         {
            this.dividerLayer.scrollRect = contentPane.scrollRect;
         }
      }
      
      public function getDividerAt(i:int) : BoxDivider
      {
         return BoxDivider(this.dividerLayer.getChildAt(i));
      }
      
      public function moveDivider(i:int, amt:Number) : void
      {
         if(i < 0 || i >= this.numDividers)
         {
            return;
         }
         if(this.activeDividerIndex >= 0)
         {
            return;
         }
         this.activeDividerIndex = i;
         this.cacheChildSizes();
         this.computeMinAndMaxDelta();
         this.dragDelta = this.limitDelta(amt);
         this.adjustChildSizes();
         invalidateSize();
         invalidateDisplayList();
         this.resetDividerTracking();
      }
      
      private function createDivider(i:int) : BoxDivider
      {
         if(!this.dividerLayer)
         {
            this.dividerLayer = UIComponent(rawChildren.addChild(new UIComponent()));
         }
         var divider:BoxDivider = BoxDivider(new this.dividerClass());
         this.dividerLayer.addChild(divider);
         if(i == PROXY_DIVIDER_INDEX)
         {
            rawChildren.setChildIndex(this.dividerLayer,rawChildren.numChildren - 1);
         }
         var basedOn:IFlexDisplayObject = i == PROXY_DIVIDER_INDEX ? this.getDividerAt(this.activeDividerIndex) : this;
         divider.styleName = basedOn;
         divider.owner = this;
         return divider;
      }
      
      private function layoutDivider(i:int, unscaledWidth:Number, unscaledHeight:Number, prevChild:IUIComponent, nextChild:IUIComponent) : void
      {
         var dividerHeight:Number = NaN;
         var dividerWidth:Number = NaN;
         var divider:BoxDivider = BoxDivider(this.getDividerAt(i));
         var vm:EdgeMetrics = viewMetrics;
         var verticalGap:Number = Number(getStyle("verticalGap"));
         var horizontalGap:Number = Number(getStyle("horizontalGap"));
         var thickness:Number = Number(divider.getStyle("dividerThickness"));
         var affordance:Number = Number(divider.getStyle("dividerAffordance"));
         if(isVertical())
         {
            dividerHeight = affordance;
            if(dividerHeight < thickness)
            {
               dividerHeight = thickness;
            }
            if(dividerHeight > verticalGap)
            {
               dividerHeight = verticalGap;
            }
            divider.setActualSize(unscaledWidth - vm.left - vm.right,dividerHeight);
            divider.move(vm.left,Math.round((prevChild.y + prevChild.height + nextChild.y - dividerHeight) / 2));
         }
         else
         {
            dividerWidth = affordance;
            if(dividerWidth < thickness)
            {
               dividerWidth = thickness;
            }
            if(dividerWidth > horizontalGap)
            {
               dividerWidth = horizontalGap;
            }
            divider.setActualSize(dividerWidth,unscaledHeight - vm.top - vm.bottom);
            divider.move(Math.round((prevChild.x + prevChild.width + nextChild.x - dividerWidth) / 2),vm.top);
         }
         divider.invalidateDisplayList();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function changeCursor(divider:BoxDivider) : void
      {
         var cursorClass:Class = null;
         if(this.cursorID == CursorManager.NO_CURSOR)
         {
            cursorClass = isVertical() ? getStyle("verticalDividerCursor") as Class : getStyle("horizontalDividerCursor") as Class;
            this.cursorID = cursorManager.setCursor(cursorClass,CursorManagerPriority.HIGH,0,0);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function restoreCursor() : void
      {
         if(this.cursorID != CursorManager.NO_CURSOR)
         {
            cursorManager.removeCursor(this.cursorID);
            this.cursorID = CursorManager.NO_CURSOR;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getDividerIndex(divider:BoxDivider) : int
      {
         var n:int = numChildren;
         for(var i:int = 0; i < n - 1; i++)
         {
            if(this.getDividerAt(i) == divider)
            {
               return i;
            }
         }
         return -1;
      }
      
      private function getMousePosition(event:MouseEvent) : Number
      {
         var point:Point = new Point(event.stageX,event.stageY);
         point = globalToLocal(point);
         return isVertical() ? point.y : point.x;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function startDividerDrag(divider:BoxDivider, trigger:MouseEvent) : void
      {
         if(this.activeDividerIndex >= 0)
         {
            return;
         }
         this.activeDividerIndex = this.getDividerIndex(divider);
         var event:DividerEvent = new DividerEvent(DividerEvent.DIVIDER_PRESS);
         event.dividerIndex = this.activeDividerIndex;
         dispatchEvent(event);
         if(this.liveDragging)
         {
            this.activeDivider = divider;
         }
         else
         {
            this.activeDivider = this.createDivider(PROXY_DIVIDER_INDEX);
            this.activeDivider.visible = false;
            this.activeDivider.state = DividerState.DOWN;
            this.activeDivider.setActualSize(divider.width,divider.height);
            this.activeDivider.move(divider.x,divider.y);
            this.activeDivider.visible = true;
            divider.state = DividerState.UP;
         }
         if(isVertical())
         {
            this.activeDividerStartPosition = this.activeDivider.y;
         }
         else
         {
            this.activeDividerStartPosition = this.activeDivider.x;
         }
         this.dragStartPosition = this.getMousePosition(trigger);
         this.dragDelta = 0;
         this.cacheChildSizes();
         this.adjustChildSizes();
         this.computeMinAndMaxDelta();
         systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler,true);
         systemManager.deployMouseShields(true);
      }
      
      private function cacheSizes() : void
      {
         var child:IUIComponent = null;
         var sz:Number = NaN;
         var mx:Number = NaN;
         var umn:Number = NaN;
         var mn:Number = NaN;
         var dMin:Number = NaN;
         var dMax:Number = NaN;
         this.oldChildSizes = [];
         var vertical:Boolean = isVertical();
         var smallest:Number = Number.MAX_VALUE;
         var n:int = numChildren;
         for(var i:int = 0; i < n; i++)
         {
            child = getLayoutChildAt(i);
            if(child.includeInLayout)
            {
               sz = vertical ? Number(child.height) : Number(child.width);
               mx = vertical ? Number(child.maxHeight) : Number(child.maxWidth);
               umn = vertical ? Number(child.explicitMinHeight) : Number(child.explicitMinWidth);
               mn = isNaN(umn) ? 0 : umn;
               dMin = Math.max(0,sz - mn);
               dMax = Math.max(0,mx - sz);
               if(sz > 0 && sz < smallest)
               {
                  smallest = sz;
               }
               this.oldChildSizes.push(new ChildSizeInfo(sz,mn,mx,dMin,dMax));
            }
         }
         this.oldChildSizes.push(new ChildSizeInfo(smallest == Number.MAX_VALUE ? 1 : smallest));
      }
      
      private function cacheChildSizes() : void
      {
         this.oldChildSizes = [];
         this.cacheSizes();
      }
      
      private function mouseMoveHandler(event:MouseEvent) : void
      {
         this.dragDelta = this.limitDelta(this.getMousePosition(event) - this.dragStartPosition);
         var dividerEvent:DividerEvent = new DividerEvent(DividerEvent.DIVIDER_DRAG);
         dividerEvent.dividerIndex = this.activeDividerIndex;
         dividerEvent.delta = this.dragDelta;
         dispatchEvent(dividerEvent);
         if(this.liveDragging)
         {
            this.adjustChildSizes();
            invalidateDisplayList();
            this.updateDisplayList(unscaledWidth,unscaledHeight);
         }
         else if(isVertical())
         {
            this.activeDivider.move(0,this.activeDividerStartPosition + this.dragDelta);
         }
         else
         {
            this.activeDivider.move(this.activeDividerStartPosition + this.dragDelta,0);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function stopDividerDrag(divider:BoxDivider, trigger:MouseEvent) : void
      {
         if(Boolean(trigger))
         {
            this.dragDelta = this.limitDelta(this.getMousePosition(trigger) - this.dragStartPosition);
         }
         var event:DividerEvent = new DividerEvent(DividerEvent.DIVIDER_RELEASE);
         event.dividerIndex = this.activeDividerIndex;
         event.delta = this.dragDelta;
         dispatchEvent(event);
         if(!this.liveDragging)
         {
            if(this.dragDelta == 0)
            {
               this.getDividerAt(this.activeDividerIndex).state = DividerState.OVER;
            }
            if(Boolean(this.activeDivider))
            {
               this.dividerLayer.removeChild(this.activeDivider);
            }
            this.activeDivider = null;
            this.adjustChildSizes();
            invalidateSize();
            invalidateDisplayList();
         }
         this.resetDividerTracking();
         systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler,true);
         systemManager.deployMouseShields(false);
      }
      
      private function resetDividerTracking() : void
      {
         this.activeDivider = null;
         this.activeDividerIndex = -1;
         this.activeDividerStartPosition = NaN;
         this.dragStartPosition = NaN;
         this.dragDelta = NaN;
         this.oldChildSizes = null;
         this.minDelta = NaN;
         this.maxDelta = NaN;
      }
      
      private function computeAllowableMovement(at:int) : void
      {
         var i:int = 0;
         var child:ChildSizeInfo = null;
         var deltaMinAbove:Number = 0;
         var deltaMaxAbove:Number = 0;
         var deltaMinBelow:Number = 0;
         var deltaMaxBelow:Number = 0;
         var n:int = this.numLayoutChildren;
         if(at < 0)
         {
            return;
         }
         for(i = at; i >= 0; i--)
         {
            child = ChildSizeInfo(this.oldChildSizes[i]);
            deltaMinAbove += this.dontCoalesceDividers && Boolean(deltaMinAbove) ? 0 : child.deltaMin;
            deltaMaxAbove += this.dontCoalesceDividers && Boolean(deltaMaxAbove) ? 0 : child.deltaMax;
         }
         for(i = at + 1; i < n; i++)
         {
            child = ChildSizeInfo(this.oldChildSizes[i]);
            deltaMinBelow += this.dontCoalesceDividers && Boolean(deltaMinBelow) ? 0 : child.deltaMin;
            deltaMaxBelow += this.dontCoalesceDividers && Boolean(deltaMaxBelow) ? 0 : child.deltaMax;
         }
         var deltaUp:Number = Math.min(deltaMinAbove,deltaMaxBelow);
         var deltaDn:Number = Math.min(deltaMinBelow,deltaMaxAbove);
         this.minDelta = -deltaUp;
         this.maxDelta = deltaDn;
      }
      
      private function computeMinAndMaxDelta() : void
      {
         this.computeAllowableMovement(this.activeDividerIndex);
      }
      
      private function limitDelta(delta:Number) : Number
      {
         if(delta < this.minDelta)
         {
            delta = this.minDelta;
         }
         else if(delta > this.maxDelta)
         {
            delta = this.maxDelta;
         }
         return Math.round(delta);
      }
      
      private function distributeDelta() : void
      {
         var i:int = 0;
         var size:ChildSizeInfo = null;
         var move:Number = NaN;
         var newSize:Number = NaN;
         var child:IUIComponent = null;
         var childSize:Number = NaN;
         if(!this.dragDelta)
         {
            return;
         }
         var vertical:Boolean = isVertical();
         var n:int = this.numLayoutChildren;
         var k:int = this.activeDividerIndex;
         var smallest:Number = this.oldChildSizes[n].size - Math.abs(this.dragDelta);
         if(smallest <= 0 || isNaN(smallest))
         {
            smallest = 1;
         }
         var activeDividerChildIndex:int = -1;
         var dividerIndex:int = -1;
         while(dividerIndex < this.activeDividerIndex)
         {
            if(UIComponent(getChildAt(++activeDividerChildIndex)).includeInLayout)
            {
               dividerIndex++;
            }
         }
         var curChildIndex:int = activeDividerChildIndex;
         var amt:Number = this.dragDelta;
         for(i = k; i >= 0; i--)
         {
            size = ChildSizeInfo(this.oldChildSizes[i]);
            move = amt < 0 ? -Math.min(-amt,size.deltaMin) : Math.min(amt,size.deltaMax);
            newSize = size.size + move;
            amt -= move;
            do
            {
               child = IUIComponent(getChildAt(curChildIndex--));
            }
            while(!child.includeInLayout);
            childSize = newSize / smallest * 100;
            if(vertical)
            {
               child.percentHeight = childSize;
            }
            else
            {
               child.percentWidth = childSize;
            }
            if(child is IInvalidating)
            {
               IInvalidating(child).invalidateSize();
            }
         }
         curChildIndex = activeDividerChildIndex + 1;
         amt = this.dragDelta;
         for(i = k + 1; i < n; i++)
         {
            size = ChildSizeInfo(this.oldChildSizes[i]);
            move = amt < 0 ? Math.min(-amt,size.deltaMax) : -Math.min(amt,size.deltaMin);
            newSize = size.size + move;
            amt += move;
            do
            {
               child = IUIComponent(getChildAt(curChildIndex++));
            }
            while(!child.includeInLayout);
            childSize = newSize / smallest * 100;
            if(vertical)
            {
               child.percentHeight = childSize;
            }
            else
            {
               child.percentWidth = childSize;
            }
            if(child is IInvalidating)
            {
               IInvalidating(child).invalidateSize();
            }
         }
      }
      
      private function adjustChildSizes() : void
      {
         this.distributeDelta();
      }
      
      private function preLayoutAdjustment() : void
      {
         var i:int = 0;
         var child:IUIComponent = null;
         var perc:Number = NaN;
         var changeObject:Object = null;
         var delta:Number = NaN;
         var vertical:Boolean = isVertical();
         var totalPerc:Number = 0;
         var percCount:Number = 0;
         var n:int = numChildren;
         for(i = 0; i < n; i++)
         {
            child = getLayoutChildAt(i);
            if(child.includeInLayout)
            {
               child.measuredMinWidth = 0;
               child.measuredMinHeight = 0;
               perc = vertical ? Number(child.percentHeight) : Number(child.percentWidth);
               if(!isNaN(perc))
               {
                  totalPerc += perc;
                  percCount++;
               }
            }
         }
         this.postLayoutChanges = [];
         if(totalPerc == 0 && percCount == 0)
         {
            for(i = n - 1; i >= 0; i--)
            {
               child = UIComponent(getChildAt(i));
               if(child.includeInLayout)
               {
                  changeObject = {"child":child};
                  if(vertical)
                  {
                     if(Boolean(child.explicitHeight))
                     {
                        changeObject.explicitHeight = child.explicitHeight;
                     }
                     else
                     {
                        changeObject.percentHeight = NaN;
                     }
                     child.percentHeight = 100;
                  }
                  else
                  {
                     if(Boolean(child.explicitWidth))
                     {
                        changeObject.explicitWidth = child.explicitWidth;
                     }
                     else if(Boolean(child.percentWidth))
                     {
                        changeObject.percentWidth = NaN;
                     }
                     child.percentWidth = 100;
                  }
                  this.postLayoutChanges.push(changeObject);
                  break;
               }
            }
         }
         else if(totalPerc < 100)
         {
            delta = Math.ceil((100 - totalPerc) / percCount);
            for(i = 0; i < n; i++)
            {
               child = getLayoutChildAt(i);
               if(child.includeInLayout)
               {
                  changeObject = {"child":child};
                  if(vertical)
                  {
                     perc = Number(child.percentHeight);
                     if(!isNaN(perc))
                     {
                        changeObject.percentHeight = child.percentHeight;
                        this.postLayoutChanges.push(changeObject);
                        child.percentHeight = (perc + delta) * unscaledHeight;
                     }
                  }
                  else
                  {
                     perc = Number(child.percentWidth);
                     if(!isNaN(perc))
                     {
                        changeObject.percentWidth = child.percentWidth;
                        this.postLayoutChanges.push(changeObject);
                        child.percentWidth = (perc + delta) * unscaledWidth;
                     }
                  }
               }
            }
         }
      }
      
      private function postLayoutAdjustment() : void
      {
         var changeObject:Object = null;
         var len:int = int(this.postLayoutChanges.length);
         for(var i:int = 0; i < len; i++)
         {
            changeObject = this.postLayoutChanges[i];
            if(changeObject.percentWidth !== undefined)
            {
               changeObject.child.percentWidth = changeObject.percentWidth;
            }
            if(changeObject.percentHeight !== undefined)
            {
               changeObject.child.percentHeight = changeObject.percentHeight;
            }
            if(changeObject.explicitWidth !== undefined)
            {
               changeObject.child.explicitWidth = changeObject.explicitWidth;
            }
            if(changeObject.explicitHeight !== undefined)
            {
               changeObject.child.explicitHeight = changeObject.explicitHeight;
            }
         }
         this.postLayoutChanges = null;
      }
      
      private function childAddHandler(event:ChildExistenceChangedEvent) : void
      {
         var child:DisplayObject = event.relatedObject;
         child.addEventListener("includeInLayoutChanged",this.child_includeInLayoutChangedHandler);
         if(!IUIComponent(child).includeInLayout)
         {
            return;
         }
         ++this.numLayoutChildren;
         if(this.numLayoutChildren > 1)
         {
            this.createDivider(this.numLayoutChildren - 2);
         }
         this.dbMinWidth = NaN;
         this.dbMinHeight = NaN;
         this.dbPreferredWidth = NaN;
         this.dbPreferredHeight = NaN;
      }
      
      private function childRemoveHandler(event:ChildExistenceChangedEvent) : void
      {
         var child:DisplayObject = event.relatedObject;
         child.removeEventListener("includeInLayoutChanged",this.child_includeInLayoutChangedHandler);
         if(!IUIComponent(child).includeInLayout)
         {
            return;
         }
         --this.numLayoutChildren;
         if(this.numLayoutChildren > 0)
         {
            this.dividerLayer.removeChild(this.getDividerAt(this.numLayoutChildren - 1));
         }
         this.dbMinWidth = NaN;
         this.dbMinHeight = NaN;
         this.dbPreferredWidth = NaN;
         this.dbPreferredHeight = NaN;
         invalidateSize();
      }
      
      private function child_includeInLayoutChangedHandler(event:Event) : void
      {
         var child:UIComponent = UIComponent(event.target);
         if(Boolean(child.includeInLayout) && ++this.numLayoutChildren > 1)
         {
            this.createDivider(this.numLayoutChildren - 2);
         }
         else if(!child.includeInLayout && --this.numLayoutChildren > 0)
         {
            this.dividerLayer.removeChild(this.getDividerAt(this.numLayoutChildren - 1));
         }
         this.dbMinWidth = NaN;
         this.dbMinHeight = NaN;
         this.dbPreferredWidth = NaN;
         this.dbPreferredHeight = NaN;
         invalidateSize();
      }
   }
}

class ChildSizeInfo
{
   
   public var deltaMin:Number;
   
   public var deltaMax:Number;
   
   public var min:Number;
   
   public var max:Number;
   
   public var size:Number;
   
   public function ChildSizeInfo(size:Number, min:Number = 0, max:Number = 0, deltaMin:Number = 0, deltaMax:Number = 0)
   {
      super();
      this.size = size;
      this.min = min;
      this.max = max;
      this.deltaMin = deltaMin;
      this.deltaMax = deltaMax;
   }
}
