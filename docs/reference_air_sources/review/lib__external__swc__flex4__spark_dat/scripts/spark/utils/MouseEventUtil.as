package spark.utils
{
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import mx.core.UIComponent;
   import mx.events.FlexMouseEvent;
   import mx.events.SandboxMouseEvent;
   
   [ExcludeClass]
   public class MouseEventUtil
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function MouseEventUtil()
      {
         super();
      }
      
      public static function addDownDragUpListeners(target:UIComponent, handleDown:Function, handleDrag:Function, handleUp:Function) : void
      {
         var f:Function = null;
         f = function(e:Event):void
         {
            var sbr:IEventDispatcher = null;
            switch(e.type)
            {
               case MouseEvent.MOUSE_DOWN:
                  if(e.isDefaultPrevented())
                  {
                     break;
                  }
                  handleDown(e);
                  sbr = target.systemManager.getSandboxRoot();
                  sbr.addEventListener(MouseEvent.MOUSE_MOVE,f,true);
                  sbr.addEventListener(MouseEvent.MOUSE_UP,f,true);
                  sbr.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,f,true);
                  target.systemManager.deployMouseShields(true);
                  break;
               case MouseEvent.MOUSE_MOVE:
                  handleDrag(e);
                  break;
               case MouseEvent.MOUSE_UP:
                  handleUp(e);
                  sbr = target.systemManager.getSandboxRoot();
                  sbr.removeEventListener(MouseEvent.MOUSE_MOVE,f,true);
                  sbr.removeEventListener(MouseEvent.MOUSE_UP,f,true);
                  sbr.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,f,true);
                  target.systemManager.deployMouseShields(false);
                  break;
               case "removeHandler":
                  target.removeEventListener("removeHandler",f);
                  target.removeEventListener(MouseEvent.MOUSE_DOWN,f);
                  sbr = target.systemManager.getSandboxRoot();
                  sbr.removeEventListener(MouseEvent.MOUSE_MOVE,f,true);
                  sbr.removeEventListener(MouseEvent.MOUSE_UP,f,true);
                  sbr.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,f,true);
                  target.systemManager.deployMouseShields(false);
            }
         };
         target.addEventListener(MouseEvent.MOUSE_DOWN,f);
         target.addEventListener("removeHandler",f);
      }
      
      public static function removeDownDragUpListeners(target:UIComponent, handleDown:Function, handleDrag:Function, handleUp:Function) : void
      {
         target.dispatchEvent(new RemoveHandlerEvent(handleDown,handleDrag,handleUp));
      }
      
      public static function createMouseWheelChangingEvent(event:MouseEvent) : FlexMouseEvent
      {
         return new FlexMouseEvent(FlexMouseEvent.MOUSE_WHEEL_CHANGING,true,true,event.localX,event.localY,InteractiveObject(event.target),event.ctrlKey,event.altKey,event.shiftKey,event.buttonDown,event.delta);
      }
   }
}

import flash.events.Event;

class RemoveHandlerEvent extends Event
{
   
   public var handleDown:Function;
   
   public var handleDrag:Function;
   
   public var handleUp:Function;
   
   public function RemoveHandlerEvent(handleDown:Function, handleDrag:Function = null, handleUp:Function = null)
   {
      this.handleDown = handleDown;
      this.handleDown = handleDrag;
      this.handleUp = handleUp;
      super("removeHandler");
   }
}
