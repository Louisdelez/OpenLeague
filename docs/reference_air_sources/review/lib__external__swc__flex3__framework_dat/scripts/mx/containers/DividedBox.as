package mx.containers
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import mx.containers.dividedBoxClasses.BoxDivider;
   import mx.core.EdgeMetrics;
   import mx.core.IFlexDisplayObject;
   import mx.core.IInvalidating;
   import mx.core.IUIComponent;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.ChildExistenceChangedEvent;
   import mx.events.DividerEvent;
   import mx.managers.CursorManager;
   import mx.managers.CursorManagerPriority;
   import mx.styles.StyleManager;
   
   use namespace mx_internal;
   
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
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const PROXY_DIVIDER_INDEX:int = 999;
      
      private static var classInitialized:Boolean = false;
      
      private var postLayoutChanges:Array;
      
      private var minDelta:Number;
      
      private var layoutStyleChanged:Boolean = false;
      
      private var dbPreferredHeight:Number;
      
      private var dbMinWidth:Number;
      
      private var maxDelta:Number;
      
      private var activeDividerStartPosition:Number;
      
      mx_internal var activeDivider:BoxDivider;
      
      private var dbMinHeight:Number;
      
      private var dividerLayer:UIComponent = null;
      
      private var dragStartPosition:Number;
      
      [Inspectable(category="General")]
      public var liveDragging:Boolean = false;
      
      private var oldChildSizes:Array;
      
      protected var dividerClass:Class = BoxDivider;
      
      private var dbPreferredWidth:Number;
      
      private var dragDelta:Number;
      
      private var activeDividerIndex:int = -1;
      
      private var _resizeToContent:Boolean = false;
      
      private var numLayoutChildren:int = 0;
      
      private var cursorID:int = 0;
      
      private var dontCoalesceDividers:Boolean;
      
      public function DividedBox()
      {
         super();
         if(!classInitialized)
         {
            initializeClass();
            classInitialized = true;
         }
         addEventListener(ChildExistenceChangedEvent.CHILD_ADD,childAddHandler);
         addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE,childRemoveHandler);
         showInAutomationHierarchy = true;
      }
      
      private static function initializeClass() : void
      {
         StyleManager.registerSizeInvalidatingStyle("dividerAffordance");
         StyleManager.registerSizeInvalidatingStyle("dividerThickness");
      }
      
      public function set resizeToContent(value:Boolean) : void
      {
         if(value != _resizeToContent)
         {
            _resizeToContent = value;
            if(value)
            {
               invalidateSize();
            }
         }
      }
      
      private function child_includeInLayoutChangedHandler(event:Event) : void
      {
         var child:UIComponent = UIComponent(event.target);
         if(child.includeInLayout && ++numLayoutChildren > 1)
         {
            createDivider(numLayoutChildren - 2);
         }
         else if(!child.includeInLayout && --numLayoutChildren > 0)
         {
            dividerLayer.removeChild(getDividerAt(numLayoutChildren - 1));
         }
         dbMinWidth = NaN;
         dbMinHeight = NaN;
         dbPreferredWidth = NaN;
         dbPreferredHeight = NaN;
         invalidateSize();
      }
      
      private function createDivider(i:int) : BoxDivider
      {
         if(!dividerLayer)
         {
            dividerLayer = UIComponent(rawChildren.addChild(new UIComponent()));
         }
         var divider:BoxDivider = BoxDivider(new dividerClass());
         dividerLayer.addChild(divider);
         if(i == PROXY_DIVIDER_INDEX)
         {
            rawChildren.setChildIndex(dividerLayer,rawChildren.numChildren - 1);
         }
         var basedOn:IFlexDisplayObject = i == PROXY_DIVIDER_INDEX ? getDividerAt(activeDividerIndex) : this;
         divider.styleName = basedOn;
         divider.owner = this;
         return divider;
      }
      
      public function moveDivider(i:int, amt:Number) : void
      {
         if(i < 0 || i >= numDividers)
         {
            return;
         }
         if(activeDividerIndex >= 0)
         {
            return;
         }
         activeDividerIndex = i;
         cacheChildSizes();
         computeMinAndMaxDelta();
         dragDelta = limitDelta(amt);
         adjustChildSizes();
         invalidateSize();
         invalidateDisplayList();
         resetDividerTracking();
      }
      
      mx_internal function restoreCursor() : void
      {
         if(cursorID != CursorManager.NO_CURSOR)
         {
            cursorManager.removeCursor(cursorID);
            cursorID = CursorManager.NO_CURSOR;
         }
      }
      
      private function layoutDivider(i:int, unscaledWidth:Number, unscaledHeight:Number, prevChild:IUIComponent, nextChild:IUIComponent) : void
      {
         var dividerHeight:Number = NaN;
         var dividerWidth:Number = NaN;
         var divider:BoxDivider = BoxDivider(getDividerAt(i));
         var vm:EdgeMetrics = viewMetrics;
         var verticalGap:Number = getStyle("verticalGap");
         var horizontalGap:Number = getStyle("horizontalGap");
         var thickness:Number = divider.getStyle("dividerThickness");
         var affordance:Number = divider.getStyle("dividerAffordance");
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
      
      private function computeMinAndMaxDelta() : void
      {
         computeAllowableMovement(activeDividerIndex);
      }
      
      mx_internal function stopDividerDrag(divider:BoxDivider, trigger:MouseEvent) : void
      {
         if(Boolean(trigger))
         {
            dragDelta = limitDelta(getMousePosition(trigger) - dragStartPosition);
         }
         var event:DividerEvent = new DividerEvent(DividerEvent.DIVIDER_RELEASE);
         event.dividerIndex = activeDividerIndex;
         event.delta = dragDelta;
         dispatchEvent(event);
         if(!liveDragging)
         {
            if(dragDelta == 0)
            {
               getDividerAt(activeDividerIndex).state = DividerState.OVER;
            }
            if(Boolean(activeDivider))
            {
               dividerLayer.removeChild(activeDivider);
            }
            activeDivider = null;
            adjustChildSizes();
            invalidateSize();
            invalidateDisplayList();
         }
         resetDividerTracking();
         systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler,true);
         systemManager.deployMouseShields(false);
      }
      
      private function postLayoutAdjustment() : void
      {
         var changeObject:Object = null;
         var len:int = int(postLayoutChanges.length);
         for(var i:int = 0; i < len; i++)
         {
            changeObject = postLayoutChanges[i];
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
         postLayoutChanges = null;
      }
      
      public function get numDividers() : int
      {
         if(Boolean(dividerLayer))
         {
            if(!liveDragging && Boolean(activeDivider))
            {
               return dividerLayer.numChildren - 1;
            }
            return dividerLayer.numChildren;
         }
         return 0;
      }
      
      private function resetDividerTracking() : void
      {
         activeDivider = null;
         activeDividerIndex = -1;
         activeDividerStartPosition = NaN;
         dragStartPosition = NaN;
         dragDelta = NaN;
         oldChildSizes = null;
         minDelta = NaN;
         maxDelta = NaN;
      }
      
      private function childAddHandler(event:ChildExistenceChangedEvent) : void
      {
         var child:DisplayObject = event.relatedObject;
         child.addEventListener("includeInLayoutChanged",child_includeInLayoutChangedHandler);
         if(!IUIComponent(child).includeInLayout)
         {
            return;
         }
         ++numLayoutChildren;
         if(numLayoutChildren > 1)
         {
            createDivider(numLayoutChildren - 2);
         }
         dbMinWidth = NaN;
         dbMinHeight = NaN;
         dbPreferredWidth = NaN;
         dbPreferredHeight = NaN;
      }
      
      mx_internal function changeCursor(divider:BoxDivider) : void
      {
         var cursorClass:Class = null;
         if(cursorID == CursorManager.NO_CURSOR)
         {
            cursorClass = isVertical() ? getStyle("verticalDividerCursor") as Class : getStyle("horizontalDividerCursor") as Class;
            cursorID = cursorManager.setCursor(cursorClass,CursorManagerPriority.HIGH,0,0);
         }
      }
      
      private function mouseMoveHandler(event:MouseEvent) : void
      {
         dragDelta = limitDelta(getMousePosition(event) - dragStartPosition);
         var dividerEvent:DividerEvent = new DividerEvent(DividerEvent.DIVIDER_DRAG);
         dividerEvent.dividerIndex = activeDividerIndex;
         dividerEvent.delta = dragDelta;
         dispatchEvent(dividerEvent);
         if(liveDragging)
         {
            adjustChildSizes();
            invalidateDisplayList();
            updateDisplayList(unscaledWidth,unscaledHeight);
         }
         else if(isVertical())
         {
            activeDivider.move(0,activeDividerStartPosition + dragDelta);
         }
         else
         {
            activeDivider.move(activeDividerStartPosition + dragDelta,0);
         }
      }
      
      public function get resizeToContent() : Boolean
      {
         return _resizeToContent;
      }
      
      mx_internal function startDividerDrag(divider:BoxDivider, trigger:MouseEvent) : void
      {
         if(activeDividerIndex >= 0)
         {
            return;
         }
         activeDividerIndex = getDividerIndex(divider);
         var event:DividerEvent = new DividerEvent(DividerEvent.DIVIDER_PRESS);
         event.dividerIndex = activeDividerIndex;
         dispatchEvent(event);
         if(liveDragging)
         {
            activeDivider = divider;
         }
         else
         {
            activeDivider = createDivider(PROXY_DIVIDER_INDEX);
            activeDivider.visible = false;
            activeDivider.state = DividerState.DOWN;
            activeDivider.setActualSize(divider.width,divider.height);
            activeDivider.move(divider.x,divider.y);
            activeDivider.visible = true;
            divider.state = DividerState.UP;
         }
         if(isVertical())
         {
            activeDividerStartPosition = activeDivider.y;
         }
         else
         {
            activeDividerStartPosition = activeDivider.x;
         }
         dragStartPosition = getMousePosition(trigger);
         dragDelta = 0;
         cacheChildSizes();
         adjustChildSizes();
         computeMinAndMaxDelta();
         systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler,true);
         systemManager.deployMouseShields(true);
      }
      
      mx_internal function getDividerIndex(divider:BoxDivider) : int
      {
         var n:int = numChildren;
         for(var i:int = 0; i < n - 1; i++)
         {
            if(getDividerAt(i) == divider)
            {
               return i;
            }
         }
         return -1;
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
         oldChildSizes = [];
         var vertical:Boolean = isVertical();
         var smallest:Number = Number.MAX_VALUE;
         var n:int = numChildren;
         for(var i:int = 0; i < n; i++)
         {
            child = IUIComponent(getChildAt(i));
            if(child.includeInLayout)
            {
               sz = vertical ? Number(child.height) : Number(child.width);
               mx = vertical ? child.maxHeight : child.maxWidth;
               umn = vertical ? child.explicitMinHeight : child.explicitMinWidth;
               mn = isNaN(umn) ? 0 : umn;
               dMin = Math.max(0,sz - mn);
               dMax = Math.max(0,mx - sz);
               if(sz > 0 && sz < smallest)
               {
                  smallest = sz;
               }
               oldChildSizes.push(new ChildSizeInfo(sz,mn,mx,dMin,dMax));
            }
         }
         oldChildSizes.push(new ChildSizeInfo(smallest == Number.MAX_VALUE ? 1 : smallest));
      }
      
      private function limitDelta(delta:Number) : Number
      {
         if(delta < minDelta)
         {
            delta = minDelta;
         }
         else if(delta > maxDelta)
         {
            delta = maxDelta;
         }
         return Math.round(delta);
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var n:int = 0;
         var i:int = 0;
         super.styleChanged(styleProp);
         if(Boolean(dividerLayer))
         {
            n = dividerLayer.numChildren;
            for(i = 0; i < n; i++)
            {
               getDividerAt(i).styleChanged(styleProp);
            }
         }
         if(StyleManager.isSizeInvalidatingStyle(styleProp))
         {
            layoutStyleChanged = true;
         }
      }
      
      private function getMousePosition(event:MouseEvent) : Number
      {
         var point:Point = new Point(event.stageX,event.stageY);
         point = globalToLocal(point);
         return isVertical() ? point.y : point.x;
      }
      
      private function adjustChildSizes() : void
      {
         distributeDelta();
      }
      
      override protected function measure() : void
      {
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
         if(!isNaN(dbPreferredWidth) && !_resizeToContent && !layoutStyleChanged)
         {
            measuredMinWidth = dbMinWidth;
            measuredMinHeight = dbMinHeight;
            measuredWidth = dbPreferredWidth;
            measuredHeight = dbPreferredHeight;
            return;
         }
         layoutStyleChanged = false;
         var isVertical:Boolean = this.isVertical();
         var minWidth:Number = 0;
         var minHeight:Number = 0;
         var preferredWidth:Number = 0;
         var preferredHeight:Number = 0;
         var n:int = numChildren;
         for(var i:int = 0; i < n; i++)
         {
            child = IUIComponent(getChildAt(i));
            if(child.includeInLayout)
            {
               prefW = child.getExplicitOrMeasuredWidth();
               prefH = child.getExplicitOrMeasuredHeight();
               minW = child.minWidth;
               minH = child.minHeight;
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
         var wPadding:Number = layoutObject.widthPadding(numLayoutChildren);
         var hPadding:Number = layoutObject.heightPadding(numLayoutChildren);
         measuredMinWidth = dbMinWidth = minWidth + wPadding;
         measuredMinHeight = dbMinHeight = minHeight + hPadding;
         measuredWidth = dbPreferredWidth = preferredWidth + wPadding;
         measuredHeight = dbPreferredHeight = preferredHeight + hPadding;
      }
      
      private function childRemoveHandler(event:ChildExistenceChangedEvent) : void
      {
         var child:DisplayObject = event.relatedObject;
         child.removeEventListener("includeInLayoutChanged",child_includeInLayoutChangedHandler);
         if(!IUIComponent(child).includeInLayout)
         {
            return;
         }
         --numLayoutChildren;
         if(numLayoutChildren > 0)
         {
            dividerLayer.removeChild(getDividerAt(numLayoutChildren - 1));
         }
         dbMinWidth = NaN;
         dbMinHeight = NaN;
         dbPreferredWidth = NaN;
         dbPreferredHeight = NaN;
         invalidateSize();
      }
      
      override protected function scrollChildren() : void
      {
         super.scrollChildren();
         if(Boolean(contentPane) && Boolean(dividerLayer))
         {
            dividerLayer.scrollRect = contentPane.scrollRect;
         }
      }
      
      public function getDividerAt(i:int) : BoxDivider
      {
         return BoxDivider(dividerLayer.getChildAt(i));
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var n:int = 0;
         var i:int = 0;
         var child:IUIComponent = null;
         if(!liveDragging && Boolean(activeDivider))
         {
            n = numChildren;
            for(i = 0; i < n; i++)
            {
               child = IUIComponent(getChildAt(i));
               if(child.includeInLayout)
               {
                  child.measuredMinWidth = 0;
                  child.measuredMinHeight = 0;
               }
            }
            return;
         }
         preLayoutAdjustment();
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         postLayoutAdjustment();
         if(!dividerLayer)
         {
            return;
         }
         var vm:EdgeMetrics = viewMetrics;
         dividerLayer.x = vm.left;
         dividerLayer.y = vm.top;
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
                  layoutDivider(dividerIndex,unscaledWidth,unscaledHeight,prevChild,child);
                  dividerIndex++;
               }
               prevChild = child;
            }
         }
      }
      
      private function cacheChildSizes() : void
      {
         oldChildSizes = [];
         cacheSizes();
      }
      
      private function distributeDelta() : void
      {
         var i:int = 0;
         var size:ChildSizeInfo = null;
         var move:Number = NaN;
         var newSize:Number = NaN;
         var child:IUIComponent = null;
         var childSize:Number = NaN;
         if(!dragDelta)
         {
            return;
         }
         var vertical:Boolean = isVertical();
         var n:int = numLayoutChildren;
         var k:int = activeDividerIndex;
         var smallest:Number = oldChildSizes[n].size - Math.abs(dragDelta);
         if(smallest <= 0 || isNaN(smallest))
         {
            smallest = 1;
         }
         var activeDividerChildIndex:int = -1;
         var dividerIndex:int = -1;
         while(dividerIndex < activeDividerIndex)
         {
            if(UIComponent(getChildAt(++activeDividerChildIndex)).includeInLayout)
            {
               dividerIndex++;
            }
         }
         var curChildIndex:int = activeDividerChildIndex;
         var amt:Number = dragDelta;
         for(i = k; i >= 0; i--)
         {
            size = ChildSizeInfo(oldChildSizes[i]);
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
         amt = dragDelta;
         for(i = k + 1; i < n; i++)
         {
            size = ChildSizeInfo(oldChildSizes[i]);
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
            child = IUIComponent(getChildAt(i));
            if(child.includeInLayout)
            {
               child.measuredMinWidth = 0;
               child.measuredMinHeight = 0;
               perc = vertical ? child.percentHeight : child.percentWidth;
               if(!isNaN(perc))
               {
                  totalPerc += perc;
                  percCount++;
               }
            }
         }
         postLayoutChanges = [];
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
                  postLayoutChanges.push(changeObject);
                  break;
               }
            }
         }
         else if(totalPerc < 100)
         {
            delta = Math.ceil((100 - totalPerc) / percCount);
            for(i = 0; i < n; i++)
            {
               child = IUIComponent(getChildAt(i));
               if(child.includeInLayout)
               {
                  changeObject = {"child":child};
                  if(vertical)
                  {
                     perc = child.percentHeight;
                     if(!isNaN(perc))
                     {
                        changeObject.percentHeight = child.percentHeight;
                        postLayoutChanges.push(changeObject);
                        child.percentHeight = (perc + delta) * unscaledHeight;
                     }
                  }
                  else
                  {
                     perc = child.percentWidth;
                     if(!isNaN(perc))
                     {
                        changeObject.percentWidth = child.percentWidth;
                        postLayoutChanges.push(changeObject);
                        child.percentWidth = (perc + delta) * unscaledWidth;
                     }
                  }
               }
            }
         }
      }
      
      private function computeAllowableMovement(at:int) : void
      {
         var i:int = 0;
         var child:ChildSizeInfo = null;
         var deltaMinAbove:Number = 0;
         var deltaMaxAbove:Number = 0;
         var deltaMinBelow:Number = 0;
         var deltaMaxBelow:Number = 0;
         var n:int = numLayoutChildren;
         if(at < 0)
         {
            return;
         }
         for(i = at; i >= 0; i--)
         {
            child = ChildSizeInfo(oldChildSizes[i]);
            deltaMinAbove += dontCoalesceDividers && Boolean(deltaMinAbove) ? 0 : child.deltaMin;
            deltaMaxAbove += dontCoalesceDividers && Boolean(deltaMaxAbove) ? 0 : child.deltaMax;
         }
         for(i = at + 1; i < n; i++)
         {
            child = ChildSizeInfo(oldChildSizes[i]);
            deltaMinBelow += dontCoalesceDividers && Boolean(deltaMinBelow) ? 0 : child.deltaMin;
            deltaMaxBelow += dontCoalesceDividers && Boolean(deltaMaxBelow) ? 0 : child.deltaMax;
         }
         var deltaUp:Number = Math.min(deltaMinAbove,deltaMaxBelow);
         var deltaDn:Number = Math.min(deltaMinBelow,deltaMaxAbove);
         minDelta = -deltaUp;
         maxDelta = deltaDn;
      }
      
      override public function set direction(value:String) : void
      {
         var i:int = 0;
         if(super.direction != value)
         {
            super.direction = value;
            if(Boolean(dividerLayer))
            {
               for(i = 0; i < dividerLayer.numChildren; i++)
               {
                  getDividerAt(i).invalidateDisplayList();
               }
            }
         }
      }
   }
}

class ChildSizeInfo
{
   
   public var size:Number;
   
   public var min:Number;
   
   public var max:Number;
   
   public var deltaMin:Number;
   
   public var deltaMax:Number;
   
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
