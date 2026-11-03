package org.papervision3d.utils.virtualmouse
{
   import com.blitzagency.xray.logger.XrayLog;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   [Event(name="doubleClick",type="flash.events.MouseEvent")]
   [Event(name="click",type="flash.events.MouseEvent")]
   [Event(name="mouseUp",type="flash.events.MouseEvent")]
   [Event(name="mouseDown",type="flash.events.MouseEvent")]
   [Event(name="rollOver",type="flash.events.MouseEvent")]
   [Event(name="mouseOver",type="flash.events.MouseEvent")]
   [Event(name="rollOut",type="flash.events.MouseEvent")]
   [Event(name="mouseOut",type="flash.events.MouseEvent")]
   [Event(name="mouseMove",type="flash.events.MouseEvent")]
   [Event(name="mouseLeave",type="flash.events.Event")]
   [Event(name="update",type="flash.events.Event")]
   public class VirtualMouse extends EventDispatcher
   {
      
      public static const UPDATE:String = "update";
      
      private static var _mouseIsDown:Boolean = false;
      
      private var _container:Sprite;
      
      private var lastDownTarget:DisplayObject;
      
      private var target:InteractiveObject;
      
      private var updateMouseDown:Boolean = false;
      
      private var eventEvent:Class = VirtualMouseEvent;
      
      private var _lastEvent:Event;
      
      private var mouseEventEvent:Class = VirtualMouseMouseEvent;
      
      private var location:Point;
      
      private var delta:int = 0;
      
      private var disabledEvents:Object = new Object();
      
      private var log:XrayLog = new XrayLog();
      
      private var ignoredInstances:Dictionary = new Dictionary(true);
      
      private var isLocked:Boolean = false;
      
      private var lastWithinStage:Boolean = true;
      
      private var lastLocation:Point;
      
      private var isDoubleClickEvent:Boolean = false;
      
      private var lastMouseDown:Boolean = false;
      
      private var altKey:Boolean = false;
      
      private var _useNativeEvents:Boolean = false;
      
      private var ctrlKey:Boolean = false;
      
      private var shiftKey:Boolean = false;
      
      private var _stage:Stage;
      
      public function VirtualMouse(stage:Stage = null, container:Sprite = null, startX:Number = 0, startY:Number = 0)
      {
         super();
         this.stage = stage;
         this.container = container;
         location = new Point(startX,startY);
         lastLocation = location.clone();
         addEventListener(UPDATE,handleUpdate);
         update();
      }
      
      public function get mouseIsDown() : Boolean
      {
         return _mouseIsDown;
      }
      
      public function get stage() : Stage
      {
         return _stage;
      }
      
      public function exitContainer() : void
      {
         var targetLocal:Point = null;
         targetLocal = target.globalToLocal(location);
         if(!disabledEvents[MouseEvent.MOUSE_OUT])
         {
            _lastEvent = new mouseEventEvent(MouseEvent.MOUSE_OUT,true,false,targetLocal.x,targetLocal.y,container,ctrlKey,altKey,shiftKey,_mouseIsDown,delta);
            container.dispatchEvent(_lastEvent);
            dispatchEvent(_lastEvent);
         }
         if(!disabledEvents[MouseEvent.ROLL_OUT])
         {
            _lastEvent = new mouseEventEvent(MouseEvent.ROLL_OUT,false,false,targetLocal.x,targetLocal.y,container,ctrlKey,altKey,shiftKey,_mouseIsDown,delta);
            container.dispatchEvent(_lastEvent);
            dispatchEvent(_lastEvent);
         }
         if(target != container)
         {
            if(!disabledEvents[MouseEvent.MOUSE_OUT])
            {
               _lastEvent = new mouseEventEvent(MouseEvent.MOUSE_OUT,true,false,targetLocal.x,targetLocal.y,container,ctrlKey,altKey,shiftKey,_mouseIsDown,delta);
               target.dispatchEvent(_lastEvent);
               dispatchEvent(_lastEvent);
            }
            if(!disabledEvents[MouseEvent.ROLL_OUT])
            {
               _lastEvent = new mouseEventEvent(MouseEvent.ROLL_OUT,false,false,targetLocal.x,targetLocal.y,container,ctrlKey,altKey,shiftKey,_mouseIsDown,delta);
               target.dispatchEvent(_lastEvent);
               dispatchEvent(_lastEvent);
            }
         }
         target = _stage;
      }
      
      public function release() : void
      {
         updateMouseDown = true;
         _mouseIsDown = false;
         if(!isLocked)
         {
            update();
         }
      }
      
      public function click() : void
      {
         press();
         release();
      }
      
      public function get container() : Sprite
      {
         return _container;
      }
      
      public function set container(value:Sprite) : void
      {
         _container = value;
      }
      
      public function get y() : Number
      {
         return location.y;
      }
      
      public function set x(n:Number) : void
      {
         location.x = n;
         if(!isLocked)
         {
            update();
         }
      }
      
      public function disableEvent(type:String) : void
      {
         disabledEvents[type] = true;
      }
      
      public function get lastEvent() : Event
      {
         return _lastEvent;
      }
      
      private function handleUpdate(event:Event) : void
      {
         var objectsUnderPoint:Array = null;
         var currentTarget:InteractiveObject = null;
         var currentParent:DisplayObject = null;
         var i:int = 0;
         var targetLocal:Point = null;
         var currentTargetLocal:Point = null;
         var withinStage:Boolean = false;
         if(!container)
         {
            return;
         }
         objectsUnderPoint = container.getObjectsUnderPoint(location);
         i = int(objectsUnderPoint.length);
         while(Boolean(i--))
         {
            currentParent = objectsUnderPoint[i];
            while(Boolean(currentParent))
            {
               if(Boolean(ignoredInstances[currentParent]))
               {
                  currentTarget = null;
                  break;
               }
               if(Boolean(currentTarget) && currentParent is SimpleButton)
               {
                  currentTarget = null;
               }
               else if(Boolean(currentTarget) && !DisplayObjectContainer(currentParent).mouseChildren)
               {
                  currentTarget = null;
               }
               if(!currentTarget && currentParent is InteractiveObject && InteractiveObject(currentParent).mouseEnabled)
               {
                  currentTarget = InteractiveObject(currentParent);
               }
               currentParent = currentParent.parent;
            }
            if(Boolean(currentTarget))
            {
               break;
            }
         }
         if(!currentTarget)
         {
            currentTarget = _stage;
         }
         targetLocal = target.globalToLocal(location);
         currentTargetLocal = currentTarget.globalToLocal(location);
         if(lastLocation.x != location.x || lastLocation.y != location.y)
         {
            withinStage = false;
            if(Boolean(stage))
            {
               withinStage = location.x >= 0 && location.y >= 0 && location.x <= stage.stageWidth && location.y <= stage.stageHeight;
            }
            if(!withinStage && lastWithinStage && !disabledEvents[Event.MOUSE_LEAVE])
            {
               _lastEvent = new eventEvent(Event.MOUSE_LEAVE,false,false);
               stage.dispatchEvent(_lastEvent);
               dispatchEvent(_lastEvent);
            }
            if(withinStage && !disabledEvents[MouseEvent.MOUSE_MOVE])
            {
               _lastEvent = new mouseEventEvent(MouseEvent.MOUSE_MOVE,true,false,currentTargetLocal.x,currentTargetLocal.y,currentTarget,ctrlKey,altKey,shiftKey,_mouseIsDown,delta);
               currentTarget.dispatchEvent(_lastEvent);
               dispatchEvent(_lastEvent);
            }
            lastWithinStage = withinStage;
         }
         if(currentTarget != target)
         {
            if(!disabledEvents[MouseEvent.MOUSE_OUT])
            {
               _lastEvent = new mouseEventEvent(MouseEvent.MOUSE_OUT,true,false,targetLocal.x,targetLocal.y,currentTarget,ctrlKey,altKey,shiftKey,_mouseIsDown,delta);
               target.dispatchEvent(_lastEvent);
               dispatchEvent(_lastEvent);
            }
            if(!disabledEvents[MouseEvent.ROLL_OUT])
            {
               _lastEvent = new mouseEventEvent(MouseEvent.ROLL_OUT,false,false,targetLocal.x,targetLocal.y,currentTarget,ctrlKey,altKey,shiftKey,_mouseIsDown,delta);
               target.dispatchEvent(_lastEvent);
               dispatchEvent(_lastEvent);
            }
            if(!disabledEvents[MouseEvent.MOUSE_OVER])
            {
               _lastEvent = new mouseEventEvent(MouseEvent.MOUSE_OVER,true,false,currentTargetLocal.x,currentTargetLocal.y,target,ctrlKey,altKey,shiftKey,_mouseIsDown,delta);
               currentTarget.dispatchEvent(_lastEvent);
               dispatchEvent(_lastEvent);
            }
            if(!disabledEvents[MouseEvent.ROLL_OVER])
            {
               _lastEvent = new mouseEventEvent(MouseEvent.ROLL_OVER,false,false,currentTargetLocal.x,currentTargetLocal.y,target,ctrlKey,altKey,shiftKey,_mouseIsDown,delta);
               currentTarget.dispatchEvent(_lastEvent);
               dispatchEvent(_lastEvent);
            }
         }
         if(updateMouseDown)
         {
            if(_mouseIsDown)
            {
               if(!disabledEvents[MouseEvent.MOUSE_DOWN])
               {
                  _lastEvent = new mouseEventEvent(MouseEvent.MOUSE_DOWN,true,false,currentTargetLocal.x,currentTargetLocal.y,currentTarget,ctrlKey,altKey,shiftKey,_mouseIsDown,delta);
                  currentTarget.dispatchEvent(_lastEvent);
                  dispatchEvent(_lastEvent);
               }
               lastDownTarget = currentTarget;
               updateMouseDown = false;
            }
            else
            {
               if(!disabledEvents[MouseEvent.MOUSE_UP])
               {
                  _lastEvent = new mouseEventEvent(MouseEvent.MOUSE_UP,true,false,currentTargetLocal.x,currentTargetLocal.y,currentTarget,ctrlKey,altKey,shiftKey,_mouseIsDown,delta);
                  currentTarget.dispatchEvent(_lastEvent);
                  dispatchEvent(_lastEvent);
               }
               if(!disabledEvents[MouseEvent.CLICK] && currentTarget == lastDownTarget)
               {
                  _lastEvent = new mouseEventEvent(MouseEvent.CLICK,true,false,currentTargetLocal.x,currentTargetLocal.y,currentTarget,ctrlKey,altKey,shiftKey,_mouseIsDown,delta);
                  currentTarget.dispatchEvent(_lastEvent);
                  dispatchEvent(_lastEvent);
               }
               lastDownTarget = null;
               updateMouseDown = false;
            }
         }
         if(isDoubleClickEvent && !disabledEvents[MouseEvent.DOUBLE_CLICK] && currentTarget.doubleClickEnabled)
         {
            _lastEvent = new mouseEventEvent(MouseEvent.DOUBLE_CLICK,true,false,currentTargetLocal.x,currentTargetLocal.y,currentTarget,ctrlKey,altKey,shiftKey,_mouseIsDown,delta);
            currentTarget.dispatchEvent(_lastEvent);
            dispatchEvent(_lastEvent);
         }
         lastLocation = location.clone();
         lastMouseDown = _mouseIsDown;
         target = currentTarget;
      }
      
      public function getLocation() : Point
      {
         return location.clone();
      }
      
      public function get x() : Number
      {
         return location.x;
      }
      
      public function lock() : void
      {
         isLocked = true;
      }
      
      public function get useNativeEvents() : Boolean
      {
         return _useNativeEvents;
      }
      
      public function setLocation(a:*, b:* = null) : void
      {
         var loc:Point = null;
         if(a is Point)
         {
            loc = Point(a);
            location.x = loc.x;
            location.y = loc.y;
         }
         else
         {
            location.x = Number(a);
            location.y = Number(b);
         }
         if(!isLocked)
         {
            update();
         }
      }
      
      private function keyHandler(event:KeyboardEvent) : void
      {
         altKey = event.altKey;
         ctrlKey = event.ctrlKey;
         shiftKey = event.shiftKey;
      }
      
      public function unignore(instance:DisplayObject) : void
      {
         if(instance in ignoredInstances)
         {
            delete ignoredInstances[instance];
         }
      }
      
      public function doubleClick() : void
      {
         if(isLocked)
         {
            release();
         }
         else
         {
            click();
            press();
            isDoubleClickEvent = true;
            release();
            isDoubleClickEvent = false;
         }
      }
      
      public function update() : void
      {
         dispatchEvent(new Event(UPDATE,false,false));
      }
      
      public function ignore(instance:DisplayObject) : void
      {
         ignoredInstances[instance] = true;
      }
      
      public function unlock() : void
      {
         isLocked = false;
         update();
      }
      
      public function enableEvent(type:String) : void
      {
         if(type in disabledEvents)
         {
            delete disabledEvents[type];
         }
      }
      
      public function press() : void
      {
         updateMouseDown = true;
         _mouseIsDown = true;
         if(!isLocked)
         {
            update();
         }
      }
      
      public function set useNativeEvents(b:Boolean) : void
      {
         if(b == _useNativeEvents)
         {
            return;
         }
         _useNativeEvents = b;
         if(_useNativeEvents)
         {
            eventEvent = VirtualMouseEvent;
            mouseEventEvent = VirtualMouseMouseEvent;
         }
         else
         {
            eventEvent = Event;
            mouseEventEvent = MouseEvent;
         }
      }
      
      public function set y(n:Number) : void
      {
         location.y = n;
         if(!isLocked)
         {
            update();
         }
      }
      
      public function set stage(s:Stage) : void
      {
         var hadStage:Boolean = false;
         if(Boolean(_stage))
         {
            hadStage = true;
            _stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyHandler);
            _stage.removeEventListener(KeyboardEvent.KEY_UP,keyHandler);
         }
         else
         {
            hadStage = false;
         }
         _stage = s;
         if(Boolean(_stage))
         {
            _stage.addEventListener(KeyboardEvent.KEY_DOWN,keyHandler);
            _stage.addEventListener(KeyboardEvent.KEY_UP,keyHandler);
            target = _stage;
            if(!hadStage)
            {
               update();
            }
         }
      }
   }
}

