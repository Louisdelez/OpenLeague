package mx.containers.dividedBoxClasses
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.containers.DividedBox;
   import mx.containers.DividerState;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.SandboxMouseEvent;
   
   use namespace mx_internal;
   
   [Style(name="dividerThickness",type="Number",format="Length",inherit="no")]
   [Style(name="dividerColor",type="uint",format="Color",inherit="yes")]
   [Style(name="dividerAlpha",type="Number",inherit="no")]
   [Style(name="dividerAffordance",type="Number",format="Length",inherit="no")]
   [Style(name="verticalGap",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no")]
   public class BoxDivider extends UIComponent
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var isMouseOver:Boolean = false;
      
      private var _state:String = "up";
      
      private var knob:DisplayObject;
      
      public function BoxDivider()
      {
         super();
         addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
         addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
         addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
      }
      
      mx_internal function set state(value:String) : void
      {
         _state = value;
         invalidateDisplayList();
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         if(!styleProp || styleProp == "dividerSkin" || styleProp == "styleName")
         {
            if(Boolean(knob))
            {
               removeChild(knob);
               knob = null;
            }
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var color:Number = NaN;
         var knobClass:Class = null;
         var visibleHeight:Number = NaN;
         var y:Number = NaN;
         var visibleWidth:Number = NaN;
         var x:Number = NaN;
         if(isNaN(width) || isNaN(height))
         {
            return;
         }
         if(!parent)
         {
            return;
         }
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         graphics.clear();
         graphics.beginFill(0,0);
         graphics.drawRect(0,0,width,height);
         graphics.endFill();
         var alpha:Number = 1;
         var thickness:Number = getStyle("dividerThickness");
         var gap:Number = DividedBox(owner).isVertical() ? Number(DividedBox(owner).getStyle("verticalGap")) : Number(DividedBox(owner).getStyle("horizontalGap"));
         if(state != DividerState.DOWN)
         {
            if(gap >= 6)
            {
               if(!knob)
               {
                  knobClass = Class(getStyle("dividerSkin"));
                  if(Boolean(knobClass))
                  {
                     knob = new knobClass();
                  }
                  if(Boolean(knob))
                  {
                     addChild(knob);
                  }
               }
               if(Boolean(knob))
               {
                  if(DividedBox(owner).isVertical())
                  {
                     knob.scaleX = 1;
                     knob.rotation = 0;
                  }
                  else
                  {
                     knob.scaleX = -1;
                     knob.rotation = -90;
                  }
                  knob.x = Math.round((width - knob.width) / 2);
                  knob.y = Math.round((height - knob.height) / 2);
               }
            }
            return;
         }
         color = getStyle("dividerColor");
         alpha = getStyle("dividerAlpha");
         graphics.beginFill(color,alpha);
         if(DividedBox(owner).isVertical())
         {
            visibleHeight = thickness;
            if(visibleHeight > gap)
            {
               visibleHeight = gap;
            }
            y = (height - visibleHeight) / 2;
            graphics.drawRect(0,y,width,visibleHeight);
         }
         else
         {
            visibleWidth = thickness;
            if(visibleWidth > gap)
            {
               visibleWidth = gap;
            }
            x = (width - visibleWidth) / 2;
            graphics.drawRect(x,0,visibleWidth,height);
         }
         graphics.endFill();
      }
      
      private function mouseOutHandler(event:MouseEvent) : void
      {
         isMouseOver = false;
         if(!DividedBox(owner).activeDivider)
         {
            state = DividerState.UP;
            if(Boolean(parent))
            {
               DividedBox(owner).restoreCursor();
            }
         }
      }
      
      private function mouseUpHandler(event:Event) : void
      {
         if(!isMouseOver)
         {
            DividedBox(owner).restoreCursor();
         }
         state = DividerState.OVER;
         DividedBox(owner).stopDividerDrag(this,event as MouseEvent);
         var sbRoot:DisplayObject = systemManager.getSandboxRoot();
         sbRoot.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler,true);
         sbRoot.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,mouseUpHandler);
      }
      
      override public function set x(value:Number) : void
      {
         var oldValue:Number = x;
         super.x = value;
         if(!DividedBox(owner).isVertical())
         {
            DividedBox(owner).moveDivider(DividedBox(owner).getDividerIndex(this),value - oldValue);
         }
      }
      
      mx_internal function get state() : String
      {
         return _state;
      }
      
      private function mouseOverHandler(event:MouseEvent) : void
      {
         if(event.buttonDown)
         {
            return;
         }
         isMouseOver = true;
         if(!DividedBox(owner).activeDivider)
         {
            state = DividerState.OVER;
            DividedBox(owner).changeCursor(this);
         }
      }
      
      override public function set y(value:Number) : void
      {
         var oldValue:Number = y;
         super.y = value;
         if(DividedBox(owner).isVertical())
         {
            DividedBox(owner).moveDivider(DividedBox(owner).getDividerIndex(this),value - oldValue);
         }
      }
      
      private function mouseDownHandler(event:MouseEvent) : void
      {
         DividedBox(owner).changeCursor(this);
         DividedBox(owner).startDividerDrag(this,event);
         var sbRoot:DisplayObject = systemManager.getSandboxRoot();
         sbRoot.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler,true);
         sbRoot.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,mouseUpHandler);
      }
   }
}

