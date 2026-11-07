package spark.components.supportClasses
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import mx.events.FlexEvent;
   import mx.events.SandboxMouseEvent;
   import mx.managers.ISystemManager;
   import spark.events.DropDownEvent;
   
   public class DropDownController extends EventDispatcher
   {
      
      private var mouseIsDown:Boolean;
      
      private var _openButton:ButtonBase;
      
      private var _systemManager:ISystemManager;
      
      public var hitAreaAdditions:Vector.<DisplayObject>;
      
      private var _dropDown:DisplayObject;
      
      private var _isOpen:Boolean = false;
      
      private var _closeOnResize:Boolean = true;
      
      private var _rollOverOpenDelay:Number = NaN;
      
      private var rollOverOpenDelayTimer:Timer;
      
      public function DropDownController()
      {
         super();
      }
      
      public function set openButton(value:ButtonBase) : void
      {
         if(this._openButton === value)
         {
            return;
         }
         this.removeOpenTriggers();
         this._openButton = value;
         this._openButton.disableMinimumDownStateTime = true;
         this.addOpenTriggers();
      }
      
      public function get openButton() : ButtonBase
      {
         return this._openButton;
      }
      
      public function set systemManager(value:ISystemManager) : void
      {
         this._systemManager = value;
      }
      
      public function get systemManager() : ISystemManager
      {
         return this._systemManager != null ? this._systemManager : (this.openButton != null ? this.openButton.systemManager : null);
      }
      
      public function set dropDown(value:DisplayObject) : void
      {
         if(this._dropDown === value)
         {
            return;
         }
         this._dropDown = value;
      }
      
      public function get dropDown() : DisplayObject
      {
         return this._dropDown;
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function get closeOnResize() : Boolean
      {
         return this._closeOnResize;
      }
      
      public function set closeOnResize(value:Boolean) : void
      {
         if(this._closeOnResize == value)
         {
            return;
         }
         if(this.isOpen)
         {
            this.removeCloseOnResizeTrigger();
         }
         this._closeOnResize = value;
         this.addCloseOnResizeTrigger();
      }
      
      public function get rollOverOpenDelay() : Number
      {
         return this._rollOverOpenDelay;
      }
      
      public function set rollOverOpenDelay(value:Number) : void
      {
         if(this._rollOverOpenDelay == value)
         {
            return;
         }
         this.removeOpenTriggers();
         this._rollOverOpenDelay = value;
         this.addOpenTriggers();
      }
      
      private function addOpenTriggers() : void
      {
         if(Boolean(this.openButton))
         {
            if(isNaN(this.rollOverOpenDelay))
            {
               this.openButton.addEventListener(FlexEvent.BUTTON_DOWN,this.openButton_buttonDownHandler);
            }
            else
            {
               this.openButton.addEventListener(MouseEvent.ROLL_OVER,this.openButton_rollOverHandler);
            }
         }
      }
      
      private function removeOpenTriggers() : void
      {
         if(Boolean(this.openButton))
         {
            if(isNaN(this.rollOverOpenDelay))
            {
               this.openButton.removeEventListener(FlexEvent.BUTTON_DOWN,this.openButton_buttonDownHandler);
            }
            else
            {
               this.openButton.removeEventListener(MouseEvent.ROLL_OVER,this.openButton_rollOverHandler);
            }
         }
      }
      
      private function addCloseTriggers() : void
      {
         if(Boolean(this.systemManager))
         {
            if(isNaN(this.rollOverOpenDelay))
            {
               this.systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_DOWN,this.systemManager_mouseDownHandler);
               this.systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,this.systemManager_mouseDownHandler);
               this.systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP,this.systemManager_mouseUpHandler_noRollOverOpenDelay);
            }
            else
            {
               this.systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_MOVE,this.systemManager_mouseMoveHandler);
               this.systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE,this.systemManager_mouseMoveHandler);
            }
            this.addCloseOnResizeTrigger();
            if(Boolean(this.openButton) && Boolean(this.openButton.systemManager))
            {
               this.openButton.systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_WHEEL,this.systemManager_mouseWheelHandler);
            }
         }
      }
      
      private function addCloseOnResizeTrigger() : void
      {
         if(this.closeOnResize)
         {
            this.systemManager.getSandboxRoot().addEventListener(Event.RESIZE,this.systemManager_resizeHandler,false,0,true);
         }
      }
      
      private function removeCloseTriggers() : void
      {
         if(Boolean(this.systemManager))
         {
            if(isNaN(this.rollOverOpenDelay))
            {
               this.systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_DOWN,this.systemManager_mouseDownHandler);
               this.systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,this.systemManager_mouseDownHandler);
               this.systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP,this.systemManager_mouseUpHandler_noRollOverOpenDelay);
            }
            else
            {
               this.systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE,this.systemManager_mouseMoveHandler);
               this.systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE,this.systemManager_mouseMoveHandler);
               this.systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP,this.systemManager_mouseUpHandler);
               this.systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.systemManager_mouseUpHandler);
            }
            this.removeCloseOnResizeTrigger();
            if(Boolean(this.openButton) && Boolean(this.openButton.systemManager))
            {
               this.openButton.systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_WHEEL,this.systemManager_mouseWheelHandler);
            }
         }
      }
      
      private function removeCloseOnResizeTrigger() : void
      {
         if(this.closeOnResize)
         {
            this.systemManager.getSandboxRoot().removeEventListener(Event.RESIZE,this.systemManager_resizeHandler);
         }
      }
      
      private function isTargetOverDropDownOrOpenButton(target:DisplayObject) : Boolean
      {
         var i:int = 0;
         if(Boolean(target))
         {
            if(Boolean(this.openButton) && Boolean(this.openButton.contains(target)))
            {
               return true;
            }
            if(this.hitAreaAdditions != null)
            {
               for(i = 0; i < this.hitAreaAdditions.length; i++)
               {
                  if(this.hitAreaAdditions[i] == target || this.hitAreaAdditions[i] is DisplayObjectContainer && DisplayObjectContainer(this.hitAreaAdditions[i]).contains(target as DisplayObject))
                  {
                     return true;
                  }
               }
            }
            if(this.dropDown is DisplayObjectContainer)
            {
               if(DisplayObjectContainer(this.dropDown).contains(target))
               {
                  return true;
               }
            }
            else if(target == this.dropDown)
            {
               return true;
            }
         }
         return false;
      }
      
      public function openDropDown() : void
      {
         this.openDropDownHelper(true);
      }
      
      private function openDropDownHelper(isProgrammatic:Boolean = false) : void
      {
         if(!this.isOpen)
         {
            this.addCloseTriggers();
            this._isOpen = true;
            if(Boolean(this.openButton))
            {
               this.openButton.keepDown(true,!isProgrammatic);
            }
            dispatchEvent(new DropDownEvent(DropDownEvent.OPEN));
         }
      }
      
      public function closeDropDown(commit:Boolean) : void
      {
         var dde:DropDownEvent = null;
         if(this.isOpen)
         {
            this._isOpen = false;
            if(Boolean(this.openButton))
            {
               this.openButton.keepDown(false);
            }
            dde = new DropDownEvent(DropDownEvent.CLOSE,false,true);
            if(!commit)
            {
               dde.preventDefault();
            }
            dispatchEvent(dde);
            this.removeCloseTriggers();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function openButton_buttonDownHandler(event:Event) : void
      {
         if(this.isOpen)
         {
            this.closeDropDown(true);
         }
         else
         {
            this.mouseIsDown = true;
            this.openDropDownHelper();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function openButton_rollOverHandler(event:MouseEvent) : void
      {
         if(this.rollOverOpenDelay == 0)
         {
            this.openDropDownHelper();
         }
         else
         {
            this.openButton.addEventListener(MouseEvent.ROLL_OUT,this.openButton_rollOutHandler);
            this.rollOverOpenDelayTimer = new Timer(this.rollOverOpenDelay,1);
            this.rollOverOpenDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.rollOverDelay_timerCompleteHandler);
            this.rollOverOpenDelayTimer.start();
         }
      }
      
      private function openButton_rollOutHandler(event:MouseEvent) : void
      {
         if(Boolean(this.rollOverOpenDelayTimer) && this.rollOverOpenDelayTimer.running)
         {
            this.rollOverOpenDelayTimer.stop();
            this.rollOverOpenDelayTimer = null;
         }
         this.openButton.removeEventListener(MouseEvent.ROLL_OUT,this.openButton_rollOutHandler);
      }
      
      private function rollOverDelay_timerCompleteHandler(event:TimerEvent) : void
      {
         this.openButton.removeEventListener(MouseEvent.ROLL_OUT,this.openButton_rollOutHandler);
         this.rollOverOpenDelayTimer = null;
         this.openDropDownHelper();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function systemManager_mouseDownHandler(event:Event) : void
      {
         var target:DisplayObject = null;
         var i:int = 0;
         if(this.mouseIsDown)
         {
            this.mouseIsDown = false;
            return;
         }
         if(!this.dropDown || Boolean(this.dropDown) && (Boolean(event.target == this.dropDown || this.dropDown is DisplayObjectContainer && !DisplayObjectContainer(this.dropDown).contains(DisplayObject(event.target)))))
         {
            target = event.target as DisplayObject;
            if(Boolean(this.openButton) && Boolean(target) && Boolean(this.openButton.contains(target)))
            {
               return;
            }
            if(this.hitAreaAdditions != null)
            {
               for(i = 0; i < this.hitAreaAdditions.length; i++)
               {
                  if(this.hitAreaAdditions[i] == event.target || this.hitAreaAdditions[i] is DisplayObjectContainer && DisplayObjectContainer(this.hitAreaAdditions[i]).contains(event.target as DisplayObject))
                  {
                     return;
                  }
               }
            }
            this.closeDropDown(true);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function systemManager_mouseMoveHandler(event:Event) : void
      {
         var target:DisplayObject = event.target as DisplayObject;
         var containedTarget:Boolean = this.isTargetOverDropDownOrOpenButton(target);
         if(containedTarget)
         {
            return;
         }
         if(event is MouseEvent && MouseEvent(event).buttonDown || event is SandboxMouseEvent && Boolean(SandboxMouseEvent(event).buttonDown))
         {
            this.systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP,this.systemManager_mouseUpHandler);
            this.systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.systemManager_mouseUpHandler);
            return;
         }
         this.closeDropDown(true);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function systemManager_mouseUpHandler_noRollOverOpenDelay(event:Event) : void
      {
         if(this.mouseIsDown)
         {
            this.mouseIsDown = false;
            return;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function systemManager_mouseUpHandler(event:Event) : void
      {
         var target:DisplayObject = event.target as DisplayObject;
         var containedTarget:Boolean = this.isTargetOverDropDownOrOpenButton(target);
         if(containedTarget)
         {
            this.systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP,this.systemManager_mouseUpHandler);
            this.systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.systemManager_mouseUpHandler);
            return;
         }
         this.closeDropDown(true);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function systemManager_resizeHandler(event:Event) : void
      {
         this.closeDropDown(true);
      }
      
      private function systemManager_mouseWheelHandler(event:MouseEvent) : void
      {
         if(Boolean(this.dropDown) && !(DisplayObjectContainer(this.dropDown).contains(DisplayObject(event.target)) && event.isDefaultPrevented()))
         {
            this.closeDropDown(false);
         }
      }
      
      public function processFocusOut(event:FocusEvent) : void
      {
         if(this.isOpen)
         {
            if(!event.relatedObject || (!this.dropDown || this.dropDown is DisplayObjectContainer && !DisplayObjectContainer(this.dropDown).contains(event.relatedObject)))
            {
               this.closeDropDown(true);
            }
         }
      }
      
      public function processKeyDown(event:KeyboardEvent) : Boolean
      {
         if(event.isDefaultPrevented())
         {
            return true;
         }
         if(event.ctrlKey && event.keyCode == Keyboard.DOWN)
         {
            this.openDropDownHelper(true);
            event.preventDefault();
         }
         else if(event.ctrlKey && event.keyCode == Keyboard.UP)
         {
            this.closeDropDown(true);
            event.preventDefault();
         }
         else if(event.keyCode == Keyboard.ENTER)
         {
            if(this.isOpen)
            {
               this.closeDropDown(true);
               event.preventDefault();
            }
         }
         else
         {
            if(event.keyCode != Keyboard.ESCAPE)
            {
               return false;
            }
            if(this.isOpen)
            {
               this.closeDropDown(false);
               event.preventDefault();
            }
         }
         return true;
      }
   }
}

