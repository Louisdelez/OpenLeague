package mx.containers.dividedBoxClasses
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.containers.DividedBox;
   import mx.containers.DividerState;
   import mx.core.ILayoutDirectionElement;
   import mx.core.UIComponent;
   import mx.events.SandboxMouseEvent;
   
   [Style(name="dividerThickness",type="Number",format="Length",inherit="no")]
   [Style(name="dividerColor",type="uint",format="Color",inherit="yes")]
   [Style(name="dividerAlpha",type="Number",inherit="no")]
   [Style(name="dividerAffordance",type="Number",format="Length",inherit="no")]
   [Style(name="verticalGap",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no")]
   public class BoxDivider extends UIComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var knob:DisplayObject;
      
      private var isMouseOver:Boolean = false;
      
      private var _state:String = "up";
      
      public function BoxDivider()
      {
         super();
         addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
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
      
      override public function set y(value:Number) : void
      {
         var oldValue:Number = y;
         super.y = value;
         if(DividedBox(owner).isVertical())
         {
            DividedBox(owner).moveDivider(DividedBox(owner).getDividerIndex(this),value - oldValue);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get state() : String
      {
         return this._state;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set state(value:String) : void
      {
         this._state = value;
         invalidateDisplayList();
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
         var thickness:Number = Number(getStyle("dividerThickness"));
         var gap:Number = DividedBox(owner).isVertical() ? Number(DividedBox(owner).getStyle("verticalGap")) : Number(DividedBox(owner).getStyle("horizontalGap"));
         if(this.state != DividerState.DOWN)
         {
            if(gap >= 6)
            {
               if(!this.knob)
               {
                  knobClass = Class(getStyle("dividerSkin"));
                  if(Boolean(knobClass))
                  {
                     this.knob = new knobClass();
                  }
                  if(Boolean(this.knob))
                  {
                     if(this.knob is ILayoutDirectionElement)
                     {
                        ILayoutDirectionElement(this.knob).layoutDirection = null;
                     }
                     addChild(this.knob);
                  }
               }
               if(Boolean(this.knob))
               {
                  if(DividedBox(owner).isVertical())
                  {
                     this.knob.scaleX = 1;
                     this.knob.rotation = 0;
                  }
                  else
                  {
                     this.knob.scaleX = -1;
                     this.knob.rotation = -90;
                  }
                  this.knob.x = Math.round((width - this.knob.width) / 2);
                  this.knob.y = Math.round((height - this.knob.height) / 2);
               }
            }
            return;
         }
         color = Number(getStyle("dividerColor"));
         alpha = Number(getStyle("dividerAlpha"));
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
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         if(!styleProp || styleProp == "dividerSkin" || styleProp == "styleName")
         {
            if(Boolean(this.knob))
            {
               removeChild(this.knob);
               this.knob = null;
            }
         }
      }
      
      private function mouseOverHandler(event:MouseEvent) : void
      {
         if(event.buttonDown)
         {
            return;
         }
         this.isMouseOver = true;
         if(!DividedBox(owner).activeDivider)
         {
            this.state = DividerState.OVER;
            DividedBox(owner).changeCursor(this);
         }
      }
      
      private function mouseOutHandler(event:MouseEvent) : void
      {
         this.isMouseOver = false;
         if(!DividedBox(owner).activeDivider)
         {
            this.state = DividerState.UP;
            if(Boolean(parent))
            {
               DividedBox(owner).restoreCursor();
            }
         }
      }
      
      private function mouseDownHandler(event:MouseEvent) : void
      {
         DividedBox(owner).changeCursor(this);
         DividedBox(owner).startDividerDrag(this,event);
         var sbRoot:DisplayObject = systemManager.getSandboxRoot();
         sbRoot.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler,true);
         sbRoot.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.mouseUpHandler);
      }
      
      private function mouseUpHandler(event:Event) : void
      {
         if(!this.isMouseOver)
         {
            DividedBox(owner).restoreCursor();
         }
         this.state = DividerState.OVER;
         DividedBox(owner).stopDividerDrag(this,event as MouseEvent);
         var sbRoot:DisplayObject = systemManager.getSandboxRoot();
         sbRoot.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler,true);
         sbRoot.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.mouseUpHandler);
      }
   }
}

