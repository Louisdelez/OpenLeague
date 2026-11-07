package spark.components
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import mx.core.EventPriority;
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
   [IconFile("HScrollBar.png")]
   [Event(name="mouseWheelChanging",type="mx.events.FlexMouseEvent")]
   public class HScrollBar extends ScrollBarBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var _skinParts:Object = {
         "incrementButton":false,
         "track":false,
         "thumb":false,
         "decrementButton":false
      };
      
      public function HScrollBar()
      {
         super();
      }
      
      private function updateMaximumAndPageSize() : void
      {
         var hsp:Number = viewport.horizontalScrollPosition;
         var viewportWidth:Number = isNaN(viewport.width) ? 0 : Number(viewport.width);
         var cWidth:Number = viewport.contentWidth;
         if(getStyle("interactionMode") == InteractionMode.TOUCH)
         {
            minimum = -viewportWidth;
            maximum = cWidth == 0 ? hsp + viewportWidth : cWidth;
         }
         else
         {
            minimum = 0;
            maximum = cWidth == 0 ? hsp : cWidth - viewportWidth;
         }
         pageSize = viewportWidth;
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
            removeEventListener(MouseEvent.MOUSE_WHEEL,this.hsb_mouseWheelHandler,true);
         }
         super.viewport = newViewport;
         if(Boolean(newViewport))
         {
            this.updateMaximumAndPageSize();
            value = newViewport.horizontalScrollPosition;
            newViewport.addEventListener(MouseEvent.MOUSE_WHEEL,this.mouseWheelHandler,false,EventPriority.DEFAULT_HANDLER);
            addEventListener(MouseEvent.MOUSE_WHEEL,this.hsb_mouseWheelHandler,true);
         }
      }
      
      override protected function pointToValue(x:Number, y:Number) : Number
      {
         if(!thumb || !track)
         {
            return 0;
         }
         var r:Number = track.getLayoutBoundsWidth() - thumb.getLayoutBoundsWidth();
         return minimum + (r != 0 ? x / r * (maximum - minimum) : 0);
      }
      
      override protected function updateSkinDisplayList() : void
      {
         var min:Number = NaN;
         var max:Number = NaN;
         var thumbPos:Point = null;
         var viewportWidth:Number = NaN;
         if(!thumb || !track)
         {
            return;
         }
         var trackSize:Number = Number(track.getLayoutBoundsWidth());
         if(getStyle("interactionMode") == InteractionMode.TOUCH && Boolean(viewport))
         {
            viewportWidth = isNaN(viewport.width) ? 0 : Number(viewport.width);
            min = !isNaN(contentMinimum) ? contentMinimum : 0;
            max = !isNaN(contentMaximum) ? contentMaximum : Math.max(0,maximum - viewportWidth);
         }
         else
         {
            min = minimum;
            max = maximum;
         }
         var range:Number = max - min;
         var fixedThumbSize:Boolean = getStyle("fixedThumbSize") !== false;
         var thumbPosTrackX:Number = 0;
         var thumbPosParentX:Number = 0;
         var thumbSize:Number = trackSize;
         if(range > 0)
         {
            if(!fixedThumbSize)
            {
               thumbSize = Math.min(pageSize / (range + pageSize) * trackSize,trackSize);
               thumbSize = Math.max(thumb.minWidth,thumbSize);
            }
            else
            {
               thumbSize = Boolean(thumb) ? Number(thumb.width) : 0;
            }
            thumbPosTrackX = (pendingValue - min) * ((trackSize - thumbSize) / range);
         }
         if(pendingValue < min)
         {
            if(!fixedThumbSize)
            {
               thumbSize = Math.max(Math.min(thumb.minWidth,thumbSize),thumbSize + (pendingValue - min));
            }
            thumbPosTrackX = 0;
         }
         if(pendingValue > max)
         {
            if(!fixedThumbSize)
            {
               thumbSize = Math.max(Math.min(thumb.minWidth,thumbSize),thumbSize - (pendingValue - max));
            }
            thumbPosTrackX = trackSize - thumbSize;
         }
         if(!fixedThumbSize)
         {
            thumb.setLayoutBoundsSize(thumbSize,NaN);
         }
         if(getStyle("autoThumbVisibility") === true)
         {
            thumb.visible = thumbSize < trackSize;
         }
         thumbPos = track.localToGlobal(new Point(thumbPosTrackX,0));
         if(Boolean(thumb.parent))
         {
            thumbPosParentX = Number(thumb.parent.globalToLocal(thumbPos).x);
         }
         thumb.setLayoutBoundsPosition(Math.round(thumbPosParentX),thumb.getLayoutBoundsY());
      }
      
      override protected function setValue(value:Number) : void
      {
         super.setValue(value);
         if(Boolean(viewport))
         {
            viewport.horizontalScrollPosition = value;
         }
      }
      
      override public function changeValueByPage(increase:Boolean = true) : void
      {
         var oldPageSize:Number = NaN;
         if(Boolean(viewport))
         {
            oldPageSize = pageSize;
            pageSize = Math.abs(viewport.getHorizontalScrollPositionDelta(increase ? NavigationUnit.PAGE_RIGHT : NavigationUnit.PAGE_LEFT));
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
            vpPageSize = Math.abs(viewport.getHorizontalScrollPositionDelta(newValue > value ? NavigationUnit.PAGE_RIGHT : NavigationUnit.PAGE_LEFT));
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
            stepSize = Math.abs(viewport.getHorizontalScrollPositionDelta(increase ? NavigationUnit.RIGHT : NavigationUnit.LEFT));
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
            thumb.setConstraintValue("left",undefined);
            thumb.setConstraintValue("right",undefined);
            thumb.setConstraintValue("horizontalCenter",undefined);
         }
         super.partAdded(partName,instance);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function viewportHorizontalScrollPositionChangeHandler(event:PropertyChangeEvent) : void
      {
         if(Boolean(viewport))
         {
            value = viewport.horizontalScrollPosition;
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function viewportResizeHandler(event:ResizeEvent) : void
      {
         if(Boolean(viewport))
         {
            this.updateMaximumAndPageSize();
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function viewportContentWidthChangeHandler(event:PropertyChangeEvent) : void
      {
         if(Boolean(viewport))
         {
            if(getStyle("interactionMode") == InteractionMode.TOUCH)
            {
               this.updateMaximumAndPageSize();
            }
            else
            {
               maximum = viewport.contentWidth - viewport.width;
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
         var hspDelta:Number = NaN;
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
         navigationUnit = delta < 0 ? NavigationUnit.RIGHT : NavigationUnit.LEFT;
         for(var hStep:int = 0; hStep < nSteps; hStep++)
         {
            hspDelta = vp.getHorizontalScrollPositionDelta(navigationUnit);
            if(!isNaN(hspDelta))
            {
               vp.horizontalScrollPosition += hspDelta;
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
      
      private function hsb_mouseWheelHandler(event:MouseEvent) : void
      {
         var vp:IViewport = viewport;
         if(event.isDefaultPrevented() || !vp || !vp.visible)
         {
            return;
         }
         event.stopImmediatePropagation();
         vp.dispatchEvent(event);
      }
   }
}

