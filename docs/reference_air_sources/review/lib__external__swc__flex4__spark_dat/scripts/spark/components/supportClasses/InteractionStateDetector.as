package spark.components.supportClasses
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.core.InteractionMode;
   import mx.core.UIComponent;
   import mx.events.SandboxMouseEvent;
   import mx.events.TouchInteractionEvent;
   import mx.managers.ISystemManager;
   
   [Event(name="change",type="flash.events.Event")]
   public class InteractionStateDetector extends EventDispatcher
   {
      
      private var component:UIComponent;
      
      private var mouseDownSelectTimer:Timer;
      
      private var mouseUpDeselectTimer:Timer;
      
      private var rollOutWhileFakingDownState:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var playTransitions:Boolean = true;
      
      private var systemMouseHandlersAdded:Boolean = false;
      
      private var _hovered:Boolean = false;
      
      private var _mouseCaptured:Boolean = false;
      
      public function InteractionStateDetector(component:UIComponent)
      {
         super();
         this.component = component;
         this.addHandlers();
      }
      
      private function get hovered() : Boolean
      {
         return this._hovered;
      }
      
      private function set hovered(value:Boolean) : void
      {
         if(value == this._hovered)
         {
            return;
         }
         this._hovered = value;
         this.invalidateState();
      }
      
      private function get mouseCaptured() : Boolean
      {
         return this._mouseCaptured;
      }
      
      private function set mouseCaptured(value:Boolean) : void
      {
         if(!value)
         {
            this.removeSystemMouseHandlers();
         }
         if(value == this._mouseCaptured)
         {
            return;
         }
         this._mouseCaptured = value;
         this.invalidateState();
      }
      
      [Bindable("change")]
      public function get state() : String
      {
         if(this.isDown())
         {
            return InteractionState.DOWN;
         }
         if(this.hovered && this.component.getStyle("interactionMode") == InteractionMode.MOUSE)
         {
            return InteractionState.OVER;
         }
         return InteractionState.UP;
      }
      
      private function isDown() : Boolean
      {
         return this.mouseCaptured && this._hovered;
      }
      
      private function invalidateState() : void
      {
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function addHandlers() : void
      {
         this.component.addEventListener(MouseEvent.ROLL_OVER,this.mouseEventHandler);
         this.component.addEventListener(MouseEvent.ROLL_OUT,this.mouseEventHandler);
         this.component.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseEventHandler);
         this.component.addEventListener(MouseEvent.MOUSE_UP,this.mouseEventHandler);
         this.component.addEventListener(MouseEvent.CLICK,this.mouseEventHandler);
         this.component.addEventListener(TouchInteractionEvent.TOUCH_INTERACTION_START,this.touchInteractionStartHandler);
      }
      
      private function addSystemMouseHandlers() : void
      {
         var systemManager:ISystemManager = this.component.systemManager;
         if(Boolean(systemManager) && !this.systemMouseHandlersAdded)
         {
            systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP,this.systemManager_mouseUpHandler,true);
            systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.systemManager_mouseUpHandler);
            this.systemMouseHandlersAdded = true;
         }
      }
      
      private function removeSystemMouseHandlers() : void
      {
         var systemManager:ISystemManager = this.component.systemManager;
         if(Boolean(systemManager) && this.systemMouseHandlersAdded)
         {
            systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP,this.systemManager_mouseUpHandler,true);
            systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.systemManager_mouseUpHandler);
            this.systemMouseHandlersAdded = false;
         }
      }
      
      private function startSelectRendererAfterDelayTimer() : void
      {
         var touchDelay:Number = Number(this.component.getStyle("touchDelay"));
         if(touchDelay > 0)
         {
            this.mouseDownSelectTimer = new Timer(touchDelay,1);
            this.mouseDownSelectTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.mouseDownSelectTimer_timerCompleteHandler);
            this.mouseDownSelectTimer.start();
         }
         else
         {
            this.mouseDownSelectTimer_timerCompleteHandler();
         }
      }
      
      private function stopSelectRendererAfterDelayTimer() : void
      {
         if(Boolean(this.mouseDownSelectTimer))
         {
            this.mouseDownSelectTimer.stop();
            this.mouseDownSelectTimer = null;
         }
      }
      
      private function startDeselectRendererAfterDelayTimer() : void
      {
         var touchDelay:Number = Number(this.component.getStyle("touchDelay"));
         if(touchDelay > 0)
         {
            this.mouseUpDeselectTimer = new Timer(touchDelay,1);
            this.mouseUpDeselectTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.mouseUpDeselectTimer_timerCompleteHandler);
            this.mouseUpDeselectTimer.start();
         }
         else
         {
            this.mouseUpDeselectTimer_timerCompleteHandler();
         }
      }
      
      private function stopDeselectRendererAfterDelayTimer() : void
      {
         if(Boolean(this.mouseUpDeselectTimer))
         {
            this.mouseUpDeselectTimer.stop();
            this.mouseUpDeselectTimer = null;
         }
      }
      
      private function mouseEventHandler(event:Event) : void
      {
         var mouseEvent:MouseEvent = event as MouseEvent;
         switch(event.type)
         {
            case MouseEvent.ROLL_OVER:
               if(mouseEvent.buttonDown && !this.mouseCaptured)
               {
                  return;
               }
               this.hovered = true;
               this.rollOutWhileFakingDownState = false;
               break;
            case MouseEvent.ROLL_OUT:
               if(Boolean(this.mouseUpDeselectTimer) && this.mouseUpDeselectTimer.running)
               {
                  this.rollOutWhileFakingDownState = true;
               }
               else
               {
                  this.hovered = false;
               }
               break;
            case MouseEvent.MOUSE_DOWN:
               if(event.isDefaultPrevented())
               {
                  break;
               }
               this.stopDeselectRendererAfterDelayTimer();
               this.addSystemMouseHandlers();
               if(this.component.getStyle("interactionMode") == InteractionMode.TOUCH)
               {
                  this.startSelectRendererAfterDelayTimer();
               }
               else
               {
                  this.mouseCaptured = true;
               }
               break;
            case MouseEvent.MOUSE_UP:
               this.hovered = true;
               if(Boolean(this.mouseDownSelectTimer) && this.mouseDownSelectTimer.running)
               {
                  this.stopSelectRendererAfterDelayTimer();
                  this.mouseCaptured = true;
                  this.startDeselectRendererAfterDelayTimer();
               }
               else if(this.mouseCaptured)
               {
                  this.mouseCaptured = false;
               }
               break;
            case MouseEvent.CLICK:
               return;
         }
      }
      
      private function systemManager_mouseUpHandler(event:Event) : void
      {
         if(event.target == this.component || Boolean(this.component.contains(event.target as DisplayObject)))
         {
            return;
         }
         if(!(this.mouseUpDeselectTimer && this.mouseUpDeselectTimer.running))
         {
            this.mouseCaptured = false;
         }
         if(Boolean(this.mouseDownSelectTimer) && this.mouseDownSelectTimer.running)
         {
            this.stopSelectRendererAfterDelayTimer();
         }
      }
      
      private function touchInteractionStartHandler(event:TouchInteractionEvent) : void
      {
         this.stopSelectRendererAfterDelayTimer();
         this.playTransitions = false;
         this.hovered = false;
         this.mouseCaptured = false;
         this.playTransitions = true;
      }
      
      private function mouseDownSelectTimer_timerCompleteHandler(event:TimerEvent = null) : void
      {
         this.mouseCaptured = true;
      }
      
      private function mouseUpDeselectTimer_timerCompleteHandler(event:TimerEvent = null) : void
      {
         this.mouseCaptured = false;
         if(this.rollOutWhileFakingDownState)
         {
            this.rollOutWhileFakingDownState = false;
            this.hovered = false;
         }
      }
      
      private function anyButtonDown(event:MouseEvent) : Boolean
      {
         var type:String = event.type;
         return event.buttonDown || type == "middleMouseDown" || type == "rightMouseDown";
      }
   }
}

