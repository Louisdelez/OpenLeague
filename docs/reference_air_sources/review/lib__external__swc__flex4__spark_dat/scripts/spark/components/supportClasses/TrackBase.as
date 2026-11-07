package spark.components.supportClasses
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import mx.core.InteractionMode;
   import mx.events.FlexEvent;
   import mx.events.ResizeEvent;
   import mx.events.SandboxMouseEvent;
   import mx.events.TouchInteractionEvent;
   import spark.components.Button;
   import spark.events.TrackBaseEvent;
   
   [Style(name="slideDuration",type="Number",format="Time",inherit="no")]
   [SkinState("disabled")]
   [SkinState("normal")]
   [Event(name="thumbRelease",type="spark.events.TrackBaseEvent")]
   [Event(name="thumbPress",type="spark.events.TrackBaseEvent")]
   [Event(name="thumbDrag",type="spark.events.TrackBaseEvent")]
   [Event(name="changeStart",type="mx.events.FlexEvent")]
   [Event(name="changeEnd",type="mx.events.FlexEvent")]
   [Event(name="change",type="flash.events.Event")]
   public class TrackBase extends Range
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var _skinParts:Object = {
         "track":false,
         "thumb":false
      };
      
      [SkinPart(required="false")]
      public var thumb:Button;
      
      [SkinPart(required="false")]
      public var track:Button;
      
      private var mouseDownTarget:DisplayObject;
      
      private var clickOffset:Point;
      
      public function TrackBase()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
      }
      
      [Inspectable(category="General",defaultValue="100.0")]
      override public function get maximum() : Number
      {
         return super.maximum;
      }
      
      override public function set maximum(value:Number) : void
      {
         if(value == super.maximum)
         {
            return;
         }
         super.maximum = value;
         invalidateDisplayList();
      }
      
      [Inspectable(category="General",defaultValue="0.0")]
      override public function get minimum() : Number
      {
         return super.minimum;
      }
      
      override public function set minimum(value:Number) : void
      {
         if(value == super.minimum)
         {
            return;
         }
         super.minimum = value;
         invalidateDisplayList();
      }
      
      override public function set scaleX(value:Number) : void
      {
         if(value == super.scaleX)
         {
            return;
         }
         if(super.scaleX == 0)
         {
            invalidateDisplayList();
         }
         super.scaleX = value;
      }
      
      override public function set scaleY(value:Number) : void
      {
         if(value == super.scaleY)
         {
            return;
         }
         if(super.scaleY == 0)
         {
            invalidateDisplayList();
         }
         super.scaleY = value;
      }
      
      [Inspectable(category="General",defaultValue="0.0")]
      [Bindable(event="valueCommit")]
      override public function get value() : Number
      {
         return super.value;
      }
      
      override public function set value(newValue:Number) : void
      {
         if(newValue == super.value)
         {
            return;
         }
         super.value = newValue;
         invalidateDisplayList();
      }
      
      override protected function setValue(value:Number) : void
      {
         super.setValue(value);
         invalidateDisplayList();
      }
      
      protected function pointToValue(x:Number, y:Number) : Number
      {
         return this.minimum;
      }
      
      override public function changeValueByStep(increase:Boolean = true) : void
      {
         var prevValue:Number = this.value;
         super.changeValueByStep(increase);
         if(this.value != prevValue)
         {
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      override protected function getCurrentSkinState() : String
      {
         return enabled ? "normal" : "disabled";
      }
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         super.partAdded(partName,instance);
         if(instance == this.thumb)
         {
            this.thumb.addEventListener(MouseEvent.MOUSE_DOWN,this.thumb_mouseDownHandler);
            this.thumb.addEventListener(TouchInteractionEvent.TOUCH_INTERACTION_STARTING,this.thumb_touchInteractionStartingHandler);
            this.thumb.addEventListener(ResizeEvent.RESIZE,this.thumb_resizeHandler);
            this.thumb.addEventListener(FlexEvent.UPDATE_COMPLETE,this.thumb_updateCompleteHandler);
            this.thumb.stickyHighlighting = true;
         }
         else if(instance == this.track)
         {
            this.track.addEventListener(ResizeEvent.RESIZE,this.track_resizeHandler);
            if(getStyle("interactionMode") == InteractionMode.MOUSE)
            {
               this.track.addEventListener(MouseEvent.MOUSE_DOWN,this.track_mouseDownHandler);
            }
         }
      }
      
      override protected function partRemoved(partName:String, instance:Object) : void
      {
         super.partRemoved(partName,instance);
         if(instance == this.thumb)
         {
            this.thumb.removeEventListener(MouseEvent.MOUSE_DOWN,this.thumb_mouseDownHandler);
            this.thumb.removeEventListener(TouchInteractionEvent.TOUCH_INTERACTION_STARTING,this.thumb_touchInteractionStartingHandler);
            this.thumb.removeEventListener(ResizeEvent.RESIZE,this.thumb_resizeHandler);
            this.thumb.removeEventListener(FlexEvent.UPDATE_COMPLETE,this.thumb_updateCompleteHandler);
         }
         else if(instance == this.track)
         {
            this.track.removeEventListener(MouseEvent.MOUSE_DOWN,this.track_mouseDownHandler);
            this.track.removeEventListener(ResizeEvent.RESIZE,this.track_resizeHandler);
         }
      }
      
      override public function styleChanged(styleName:String) : void
      {
         var allStyles:Boolean = styleName == null || styleName == "styleName";
         super.styleChanged(styleName);
         if(allStyles || styleName == "interactionMode")
         {
            if(Boolean(this.track))
            {
               if(getStyle("interactionMode") == InteractionMode.MOUSE)
               {
                  this.track.addEventListener(MouseEvent.MOUSE_DOWN,this.track_mouseDownHandler);
               }
               else
               {
                  this.track.removeEventListener(MouseEvent.MOUSE_DOWN,this.track_mouseDownHandler);
               }
            }
         }
      }
      
      override protected function focusInHandler(event:FocusEvent) : void
      {
         super.focusInHandler(event);
         systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_WHEEL,this.system_mouseWheelHandler,true);
      }
      
      override protected function focusOutHandler(event:FocusEvent) : void
      {
         super.focusOutHandler(event);
         systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_WHEEL,this.system_mouseWheelHandler,true);
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         super.updateDisplayList(w,h);
         this.updateSkinDisplayList();
      }
      
      protected function updateSkinDisplayList() : void
      {
      }
      
      private function addedToStageHandler(event:Event) : void
      {
         this.updateSkinDisplayList();
      }
      
      private function track_resizeHandler(event:Event) : void
      {
         this.updateSkinDisplayList();
      }
      
      private function thumb_resizeHandler(event:Event) : void
      {
         this.updateSkinDisplayList();
      }
      
      private function thumb_updateCompleteHandler(event:Event) : void
      {
         this.updateSkinDisplayList();
         this.thumb.removeEventListener(FlexEvent.UPDATE_COMPLETE,this.thumb_updateCompleteHandler);
      }
      
      protected function system_mouseWheelHandler(event:MouseEvent) : void
      {
         var newValue:Number = NaN;
         if(!event.isDefaultPrevented())
         {
            newValue = nearestValidValue(this.value + event.delta * stepSize,stepSize);
            this.setValue(newValue);
            dispatchEvent(new Event(Event.CHANGE));
            event.preventDefault();
         }
      }
      
      protected function thumb_mouseDownHandler(event:MouseEvent) : void
      {
         systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_MOVE,this.system_mouseMoveHandler,true);
         systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP,this.system_mouseUpHandler,true);
         systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.system_mouseUpHandler);
         this.clickOffset = this.thumb.globalToLocal(new Point(event.stageX,event.stageY));
         dispatchEvent(new TrackBaseEvent(TrackBaseEvent.THUMB_PRESS));
         dispatchEvent(new FlexEvent(FlexEvent.CHANGE_START));
      }
      
      protected function thumb_touchInteractionStartingHandler(event:TouchInteractionEvent) : void
      {
         event.preventDefault();
      }
      
      protected function system_mouseMoveHandler(event:MouseEvent) : void
      {
         if(!this.track)
         {
            return;
         }
         var p:Point = this.track.globalToLocal(new Point(event.stageX,event.stageY));
         var newValue:Number = this.pointToValue(p.x - this.clickOffset.x,p.y - this.clickOffset.y);
         newValue = nearestValidValue(newValue,snapInterval);
         if(newValue != this.value)
         {
            this.setValue(newValue);
            dispatchEvent(new TrackBaseEvent(TrackBaseEvent.THUMB_DRAG));
            dispatchEvent(new Event(Event.CHANGE));
         }
         event.updateAfterEvent();
      }
      
      protected function system_mouseUpHandler(event:Event) : void
      {
         systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE,this.system_mouseMoveHandler,true);
         systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP,this.system_mouseUpHandler,true);
         systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.system_mouseUpHandler);
         dispatchEvent(new TrackBaseEvent(TrackBaseEvent.THUMB_RELEASE));
         dispatchEvent(new FlexEvent(FlexEvent.CHANGE_END));
      }
      
      protected function track_mouseDownHandler(event:MouseEvent) : void
      {
      }
      
      private function mouseDownHandler(event:MouseEvent) : void
      {
         systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP,this.system_mouseUpSomewhereHandler,true);
         systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.system_mouseUpSomewhereHandler);
         this.mouseDownTarget = DisplayObject(event.target);
      }
      
      private function system_mouseUpSomewhereHandler(event:Event) : void
      {
         var mEvent:MouseEvent = null;
         var mousePoint:Point = null;
         systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP,this.system_mouseUpSomewhereHandler,true);
         systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.system_mouseUpSomewhereHandler);
         if(this.mouseDownTarget != event.target && event is MouseEvent && Boolean(contains(DisplayObject(event.target))))
         {
            mEvent = event as MouseEvent;
            mousePoint = new Point(mEvent.localX,mEvent.localY);
            mousePoint = globalToLocal(DisplayObject(event.target).localToGlobal(mousePoint));
            dispatchEvent(new MouseEvent(MouseEvent.CLICK,mEvent.bubbles,mEvent.cancelable,mousePoint.x,mousePoint.y,mEvent.relatedObject,mEvent.ctrlKey,mEvent.altKey,mEvent.shiftKey,mEvent.buttonDown,mEvent.delta));
         }
         this.mouseDownTarget = null;
      }
   }
}

