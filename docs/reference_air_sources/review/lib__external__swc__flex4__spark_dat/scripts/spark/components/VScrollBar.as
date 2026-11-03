package spark.components
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import mx.core.IInvalidating;
   import mx.core.InteractionMode;
   import mx.events.FlexMouseEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.ResizeEvent;
   import spark.components.supportClasses.ScrollBarBase;
   import spark.core.IViewport;
   import spark.core.NavigationUnit;
   import spark.utils.MouseEventUtil;
   
   [DefaultTriggerEvent("change")]
   [IconFile("VScrollBar.png")]
   [Event(name="mouseWheelChanging",type="mx.events.FlexMouseEvent")]
   public class VScrollBar extends ScrollBarBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var _skinParts:Object = {
         "incrementButton":false,
         "track":false,
         "thumb":false,
         "decrementButton":false
      };
      
      public function VScrollBar()
      {
         super();
      }
      
      private function updateMaximumAndPageSize() : void
      {
         var vsp:Number = viewport.verticalScrollPosition;
         var viewportHeight:Number = isNaN(viewport.height) ? 0 : Number(viewport.height);
         var cHeight:Number = viewport.contentHeight;
         if(getStyle("interactionMode") == InteractionMode.TOUCH)
         {
            minimum = -viewportHeight;
            maximum = cHeight == 0 ? vsp + viewportHeight : cHeight;
         }
         else
         {
            minimum = 0;
            maximum = cHeight == 0 ? vsp : cHeight - viewportHeight;
         }
         pageSize = viewportHeight;
      }
      
      override public function set viewport(newViewport:IViewport) : void
      {
         var oldViewport:IViewport = super.viewport;
         if(oldViewport == newViewport)
         {
            return;
         }
         if(Boolean(oldViewport))
         {
            oldViewport.removeEventListener(MouseEvent.MOUSE_WHEEL,this.mouseWheelHandler);
            removeEventListener(MouseEvent.MOUSE_WHEEL,this.mouseWheelHandler);
         }
         super.viewport = newViewport;
         if(Boolean(newViewport))
         {
            this.updateMaximumAndPageSize();
            value = newViewport.verticalScrollPosition;
            newViewport.addEventListener(MouseEvent.MOUSE_WHEEL,this.mouseWheelHandler);
            addEventListener(MouseEvent.MOUSE_WHEEL,this.mouseWheelHandler);
         }
      }
      
      override protected function pointToValue(x:Number, y:Number) : Number
      {
         if(!thumb || !track)
         {
            return 0;
         }
         var r:Number = track.getLayoutBoundsHeight() - thumb.getLayoutBoundsHeight();
         return minimum + (r != 0 ? y / r * (maximum - minimum) : 0);
      }
      
      override protected function updateSkinDisplayList() : void
      {
         var min:Number = NaN;
         var max:Number = NaN;
         var thumbPos:Point = null;
         var viewportHeight:Number = NaN;
         if(!thumb || !track)
         {
            return;
         }
         var trackSize:Number = Number(track.getLayoutBoundsHeight());
         if(getStyle("interactionMode") == InteractionMode.TOUCH && Boolean(viewport))
         {
            viewportHeight = isNaN(viewport.height) ? 0 : Number(viewport.height);
            min = !isNaN(contentMinimum) ? contentMinimum : 0;
            max = !isNaN(contentMaximum) ? contentMaximum : Math.max(0,maximum - viewportHeight);
         }
         else
         {
            min = minimum;
            max = maximum;
         }
         var range:Number = max - min;
         var fixedThumbSize:Boolean = getStyle("fixedThumbSize") !== false;
         var thumbPosTrackY:Number = 0;
         var thumbPosParentY:Number = 0;
         var thumbSize:Number = trackSize;
         if(range > 0)
         {
            if(!fixedThumbSize)
            {
               thumbSize = Math.min(pageSize / (range + pageSize) * trackSize,trackSize);
               thumbSize = Math.max(thumb.minHeight,thumbSize);
            }
            else
            {
               thumbSize = Boolean(thumb) ? Number(thumb.height) : 0;
            }
            thumbPosTrackY = (pendingValue - min) * ((trackSize - thumbSize) / range);
         }
         if(pendingValue < min)
         {
            if(!fixedThumbSize)
            {
               thumbSize = Math.max(Math.min(thumb.minHeight,thumbSize),thumbSize + (pendingValue - min));
            }
            thumbPosTrackY = 0;
         }
         if(pendingValue > max)
         {
            if(!fixedThumbSize)
            {
               thumbSize = Math.max(Math.min(thumb.minHeight,thumbSize),thumbSize - (pendingValue - max));
            }
            thumbPosTrackY = trackSize - thumbSize;
         }
         if(!fixedThumbSize)
         {
            thumb.setLayoutBoundsSize(NaN,thumbSize);
         }
         if(getStyle("autoThumbVisibility") === true)
         {
            thumb.visible = thumbSize < trackSize;
         }
         thumbPos = track.localToGlobal(new Point(0,thumbPosTrackY));
         if(Boolean(thumb.parent))
         {
            thumbPosParentY = Number(thumb.parent.globalToLocal(thumbPos).y);
         }
         thumb.setLayoutBoundsPosition(thumb.getLayoutBoundsX(),Math.round(thumbPosParentY));
      }
      
      override protected function setValue(value:Number) : void
      {
         super.setValue(value);
         if(Boolean(viewport))
         {
            viewport.verticalScrollPosition = value;
         }
      }
      
      override public function changeValueByPage(increase:Boolean = true) : void
      {
         var oldPageSize:Number = NaN;
         if(Boolean(viewport))
         {
            oldPageSize = pageSize;
            pageSize = Math.abs(viewport.getVerticalScrollPositionDelta(increase ? NavigationUnit.PAGE_DOWN : NavigationUnit.PAGE_UP));
         }
         super.changeValueByPage(increase);
         if(Boolean(viewport))
         {
            pageSize = oldPageSize;
         }
      }
      
      override protected function animatePaging(newValue:Number, pageSize:Number) : void
      {
         var vpPageSize:Number = NaN;
         if(Boolean(viewport))
         {
            vpPageSize = Math.abs(viewport.getVerticalScrollPositionDelta(newValue > value ? NavigationUnit.PAGE_DOWN : NavigationUnit.PAGE_UP));
            super.animatePaging(newValue,vpPageSize);
            return;
         }
         super.animatePaging(newValue,pageSize);
      }
      
      override public function changeValueByStep(increase:Boolean = true) : void
      {
         var oldStepSize:Number = NaN;
         if(Boolean(viewport))
         {
            oldStepSize = stepSize;
            stepSize = Math.abs(viewport.getVerticalScrollPositionDelta(increase ? NavigationUnit.DOWN : NavigationUnit.UP));
         }
         super.changeValueByStep(increase);
         if(Boolean(viewport))
         {
            stepSize = oldStepSize;
         }
      }
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         if(instance == thumb)
         {
            thumb.setConstraintValue("top",undefined);
            thumb.setConstraintValue("bottom",undefined);
            thumb.setConstraintValue("verticalCenter",undefined);
         }
         super.partAdded(partName,instance);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function viewportVerticalScrollPositionChangeHandler(event:PropertyChangeEvent) : void
      {
         if(Boolean(viewport))
         {
            value = viewport.verticalScrollPosition;
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function viewportResizeHandler(event:ResizeEvent) : void
      {
         if(Boolean(viewport))
         {
            this.updateMaximumAndPageSize();
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function viewportContentHeightChangeHandler(event:PropertyChangeEvent) : void
      {
         if(Boolean(viewport))
         {
            if(getStyle("interactionMode") == InteractionMode.TOUCH)
            {
               this.updateMaximumAndPageSize();
            }
            else
            {
               maximum = viewport.contentHeight - viewport.height;
            }
         }
      }
      
      override public function styleChanged(styleName:String) : void
      {
         super.styleChanged(styleName);
         var allStyles:Boolean = !styleName || styleName == "styleName";
         if(allStyles || styleName == "interactionMode")
         {
            if(Boolean(viewport))
            {
               this.updateMaximumAndPageSize();
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function mouseWheelHandler(event:MouseEvent) : void
      {
         var navigationUnit:uint = 0;
         var scrollPositionChanged:Boolean = false;
         var vspDelta:Number = NaN;
         var vp:IViewport = viewport;
         if(event.isDefaultPrevented() || !vp || !vp.visible || !visible)
         {
            return;
         }
         var changingEvent:FlexMouseEvent = MouseEventUtil.createMouseWheelChangingEvent(event);
         if(!dispatchEvent(changingEvent))
         {
            event.preventDefault();
            return;
         }
         var delta:int = int(changingEvent.delta);
         var nSteps:uint = Math.abs(delta);
         navigationUnit = delta < 0 ? NavigationUnit.DOWN : NavigationUnit.UP;
         for(var vStep:int = 0; vStep < nSteps; vStep++)
         {
            vspDelta = vp.getVerticalScrollPositionDelta(navigationUnit);
            if(!isNaN(vspDelta))
            {
               vp.verticalScrollPosition += vspDelta;
               scrollPositionChanged = true;
               if(vp is IInvalidating)
               {
                  IInvalidating(vp).validateNow();
               }
            }
         }
         if(scrollPositionChanged)
         {
            dispatchEvent(new Event(Event.CHANGE));
         }
         event.preventDefault();
      }
   }
}

