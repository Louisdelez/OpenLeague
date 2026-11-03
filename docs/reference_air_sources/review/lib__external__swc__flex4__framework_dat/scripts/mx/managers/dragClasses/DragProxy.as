package mx.managers.dragClasses
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import mx.core.DragSource;
   import mx.core.IFlexModule;
   import mx.core.IUIComponent;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.effects.Move;
   import mx.effects.Zoom;
   import mx.events.DragEvent;
   import mx.events.EffectEvent;
   import mx.events.InterDragManagerEvent;
   import mx.events.InterManagerRequest;
   import mx.events.SandboxMouseEvent;
   import mx.managers.CursorManager;
   import mx.managers.DragManager;
   import mx.managers.ISystemManager;
   import mx.managers.SystemManager;
   import mx.modules.ModuleManager;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.IStyleManager2;
   import mx.styles.StyleManager;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class DragProxy extends UIComponent
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var cursorClass:Class = null;
      
      private var cursorID:int = 0;
      
      private var lastKeyEvent:KeyboardEvent;
      
      private var lastMouseEvent:MouseEvent;
      
      private var sandboxRoot:IEventDispatcher;
      
      public var dragInitiator:IUIComponent;
      
      public var dragSource:DragSource;
      
      public var xOffset:Number;
      
      public var yOffset:Number;
      
      public var startX:Number;
      
      public var startY:Number;
      
      public var target:DisplayObject = null;
      
      public var action:String;
      
      public var allowMove:Boolean = true;
      
      public function DragProxy(dragInitiator:IUIComponent, dragSource:DragSource)
      {
         super();
         this.dragInitiator = dragInitiator;
         this.dragSource = dragSource;
         var sm:ISystemManager = dragInitiator.systemManager.topLevelSystemManager as ISystemManager;
         var ed:IEventDispatcher = this.sandboxRoot = sm.getSandboxRoot();
         ed.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler,true);
         ed.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler,true);
         ed.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
         ed.addEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
      }
      
      private static function getObjectsUnderPoint(obj:DisplayObject, pt:Point, arr:Array) : void
      {
         var doc:DisplayObjectContainer = null;
         var rc:Object = null;
         var n:int = 0;
         var i:int = 0;
         var child:DisplayObject = null;
         if(!obj.visible)
         {
            return;
         }
         if(obj is UIComponent && !UIComponent(obj).$visible)
         {
            return;
         }
         if(obj.hitTestPoint(pt.x,pt.y,true))
         {
            if(obj is InteractiveObject && InteractiveObject(obj).mouseEnabled)
            {
               arr.push(obj);
            }
            if(obj is DisplayObjectContainer)
            {
               doc = obj as DisplayObjectContainer;
               if(doc.mouseChildren)
               {
                  if("rawChildren" in doc)
                  {
                     rc = doc["rawChildren"];
                     n = int(rc.numChildren);
                     for(i = 0; i < n; i++)
                     {
                        try
                        {
                           getObjectsUnderPoint(rc.getChildAt(i),pt,arr);
                        }
                        catch(e:Error)
                        {
                        }
                     }
                  }
                  else if(Boolean(doc.numChildren))
                  {
                     n = doc.numChildren;
                     for(i = 0; i < n; i++)
                     {
                        try
                        {
                           child = doc.getChildAt(i);
                           getObjectsUnderPoint(child,pt,arr);
                        }
                        catch(e:Error)
                        {
                        }
                     }
                  }
               }
            }
         }
      }
      
      override public function initialize() : void
      {
         super.initialize();
         this.dragInitiator.systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.mouseLeaveHandler);
         if(!getFocus())
         {
            setFocus();
         }
      }
      
      override public function get styleManager() : IStyleManager2
      {
         if(this.dragInitiator is IFlexModule)
         {
            return StyleManager.getStyleManager(IFlexModule(this.dragInitiator).moduleFactory);
         }
         return super.styleManager;
      }
      
      public function showFeedback() : void
      {
         var newCursorClass:Class = this.cursorClass;
         var styleSheet:CSSStyleDeclaration = this.styleManager.getMergedStyleDeclaration("mx.managers.DragManager");
         if(this.action == DragManager.COPY)
         {
            newCursorClass = styleSheet.getStyle("copyCursor");
         }
         else if(this.action == DragManager.LINK)
         {
            newCursorClass = styleSheet.getStyle("linkCursor");
         }
         else if(this.action == DragManager.NONE)
         {
            newCursorClass = styleSheet.getStyle("rejectCursor");
         }
         else
         {
            newCursorClass = styleSheet.getStyle("moveCursor");
         }
         if(newCursorClass != this.cursorClass)
         {
            this.cursorClass = newCursorClass;
            if(this.cursorID != CursorManager.NO_CURSOR)
            {
               cursorManager.removeCursor(this.cursorID);
            }
            this.cursorID = cursorManager.setCursor(this.cursorClass,2,0,0);
         }
      }
      
      public function checkKeyEvent(event:KeyboardEvent) : void
      {
         var dragEvent:DragEvent = null;
         var pt:Point = null;
         if(Boolean(this.target))
         {
            if(Boolean(this.lastKeyEvent) && Boolean(event.type == this.lastKeyEvent.type) && event.keyCode == this.lastKeyEvent.keyCode)
            {
               return;
            }
            this.lastKeyEvent = event;
            dragEvent = new DragEvent(DragEvent.DRAG_OVER);
            dragEvent.dragInitiator = this.dragInitiator;
            dragEvent.dragSource = this.dragSource;
            dragEvent.action = this.action;
            dragEvent.ctrlKey = event.ctrlKey;
            dragEvent.altKey = event.altKey;
            dragEvent.shiftKey = event.shiftKey;
            pt = new Point();
            pt.x = this.lastMouseEvent.localX;
            pt.y = this.lastMouseEvent.localY;
            pt = DisplayObject(this.lastMouseEvent.target).localToGlobal(pt);
            pt = DisplayObject(this.target).globalToLocal(pt);
            dragEvent.localX = pt.x;
            dragEvent.localY = pt.y;
            this._dispatchDragEvent(this.target,dragEvent);
            this.showFeedback();
         }
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         this.checkKeyEvent(event);
      }
      
      override protected function keyUpHandler(event:KeyboardEvent) : void
      {
         this.checkKeyEvent(event);
      }
      
      public function stage_mouseMoveHandler(event:MouseEvent) : void
      {
         if(event.target != stage)
         {
            return;
         }
         this.mouseMoveHandler(event);
      }
      
      private function dispatchDragEvent(type:String, mouseEvent:MouseEvent, eventTarget:Object) : void
      {
         var dragEvent:DragEvent = new DragEvent(type);
         var pt:Point = new Point();
         dragEvent.dragInitiator = this.dragInitiator;
         dragEvent.dragSource = this.dragSource;
         dragEvent.action = this.action;
         dragEvent.ctrlKey = mouseEvent.ctrlKey;
         dragEvent.altKey = mouseEvent.altKey;
         dragEvent.shiftKey = mouseEvent.shiftKey;
         pt.x = this.lastMouseEvent.localX;
         pt.y = this.lastMouseEvent.localY;
         pt = DisplayObject(this.lastMouseEvent.target).localToGlobal(pt);
         pt = DisplayObject(eventTarget).globalToLocal(pt);
         dragEvent.localX = pt.x;
         dragEvent.localY = pt.y;
         this._dispatchDragEvent(DisplayObject(eventTarget),dragEvent);
      }
      
      private function _dispatchDragEvent(target:DisplayObject, event:DragEvent) : void
      {
         var me:InterManagerRequest = null;
         var mde:InterDragManagerEvent = null;
         if(this.isSameOrChildApplicationDomain(target))
         {
            target.dispatchEvent(event);
         }
         else
         {
            me = new InterManagerRequest(InterManagerRequest.INIT_MANAGER_REQUEST);
            me.name = "mx.managers::IDragManager";
            this.sandboxRoot.dispatchEvent(me);
            mde = new InterDragManagerEvent(InterDragManagerEvent.DISPATCH_DRAG_EVENT,false,false,event.localX,event.localY,event.relatedObject,event.ctrlKey,event.altKey,event.shiftKey,event.buttonDown,event.delta,target,event.type,event.dragInitiator,event.dragSource,event.action,event.draggedItem);
            this.sandboxRoot.dispatchEvent(mde);
         }
      }
      
      private function isSameOrChildApplicationDomain(target:Object) : Boolean
      {
         var swfRoot:DisplayObject = SystemManager.getSWFRoot(target);
         if(Boolean(swfRoot))
         {
            return true;
         }
         if(Boolean(ModuleManager.getAssociatedFactory(target)))
         {
            return true;
         }
         var me:InterManagerRequest = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST);
         me.name = "hasSWFBridges";
         this.sandboxRoot.dispatchEvent(me);
         if(!me.value)
         {
            return true;
         }
         return false;
      }
      
      public function mouseMoveHandler(event:MouseEvent) : void
      {
         var dragEvent:DragEvent = null;
         var dropTarget:DisplayObject = null;
         var i:int = 0;
         var targetList:Array = null;
         var foundIt:Boolean = false;
         var oldTarget:DisplayObject = null;
         this.lastMouseEvent = event;
         var pt:Point = new Point();
         var point:Point = new Point(event.localX,event.localY);
         var stagePoint:Point = DisplayObject(event.target).localToGlobal(point);
         point = DisplayObject(this.sandboxRoot).globalToLocal(stagePoint);
         var mouseX:Number = point.x;
         var mouseY:Number = point.y;
         x = mouseX - this.xOffset;
         y = mouseY - this.yOffset;
         if(!event)
         {
            return;
         }
         targetList = [];
         DragProxy.getObjectsUnderPoint(DisplayObject(this.sandboxRoot),stagePoint,targetList);
         var newTarget:DisplayObject = null;
         var targetIndex:int = targetList.length - 1;
         while(targetIndex >= 0)
         {
            newTarget = targetList[targetIndex];
            if(newTarget != this && !contains(newTarget))
            {
               break;
            }
            targetIndex--;
         }
         if(Boolean(this.target))
         {
            foundIt = false;
            oldTarget = this.target;
            dropTarget = newTarget;
            while(Boolean(dropTarget))
            {
               if(dropTarget == this.target)
               {
                  this.dispatchDragEvent(DragEvent.DRAG_OVER,event,dropTarget);
                  foundIt = true;
                  break;
               }
               this.dispatchDragEvent(DragEvent.DRAG_ENTER,event,dropTarget);
               if(this.target == dropTarget)
               {
                  foundIt = false;
                  break;
               }
               dropTarget = dropTarget.parent;
            }
            if(!foundIt)
            {
               this.dispatchDragEvent(DragEvent.DRAG_EXIT,event,oldTarget);
               if(this.target == oldTarget)
               {
                  this.target = null;
               }
            }
         }
         if(!this.target)
         {
            this.action = DragManager.MOVE;
            dropTarget = newTarget;
            while(Boolean(dropTarget))
            {
               if(dropTarget != this)
               {
                  this.dispatchDragEvent(DragEvent.DRAG_ENTER,event,dropTarget);
                  if(Boolean(this.target))
                  {
                     break;
                  }
               }
               dropTarget = dropTarget.parent;
            }
            if(!this.target)
            {
               this.action = DragManager.NONE;
            }
         }
         this.showFeedback();
      }
      
      public function mouseLeaveHandler(event:Event) : void
      {
         this.mouseUpHandler(this.lastMouseEvent);
      }
      
      public function mouseUpHandler(event:MouseEvent) : void
      {
         var dragEvent:DragEvent = null;
         var pt:Point = null;
         var m1:Move = null;
         var e:Zoom = null;
         var m:Move = null;
         var sm:ISystemManager = this.dragInitiator.systemManager.topLevelSystemManager as ISystemManager;
         var ed:IEventDispatcher = this.sandboxRoot;
         ed.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler,true);
         ed.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler,true);
         ed.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
         ed.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.mouseLeaveHandler);
         ed.removeEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
         var delegate:Object = automationDelegate;
         if(Boolean(this.target) && this.action != DragManager.NONE)
         {
            dragEvent = new DragEvent(DragEvent.DRAG_DROP);
            dragEvent.dragInitiator = this.dragInitiator;
            dragEvent.dragSource = this.dragSource;
            dragEvent.action = this.action;
            dragEvent.ctrlKey = event.ctrlKey;
            dragEvent.altKey = event.altKey;
            dragEvent.shiftKey = event.shiftKey;
            pt = new Point();
            pt.x = this.lastMouseEvent.localX;
            pt.y = this.lastMouseEvent.localY;
            pt = DisplayObject(this.lastMouseEvent.target).localToGlobal(pt);
            pt = DisplayObject(this.target).globalToLocal(pt);
            dragEvent.localX = pt.x;
            dragEvent.localY = pt.y;
            if(Boolean(delegate))
            {
               delegate.recordAutomatableDragDrop(this.target,dragEvent);
            }
            this._dispatchDragEvent(this.target,dragEvent);
         }
         else
         {
            this.action = DragManager.NONE;
         }
         if(this.action == DragManager.NONE)
         {
            m1 = new Move(this);
            m1.addEventListener(EffectEvent.EFFECT_END,this.effectEndHandler);
            m1.xFrom = x;
            m1.yFrom = y;
            m1.xTo = this.startX;
            m1.yTo = this.startY;
            m1.duration = 200;
            m1.play();
         }
         else
         {
            e = new Zoom(this);
            e.zoomWidthFrom = e.zoomHeightFrom = 1;
            e.zoomWidthTo = e.zoomHeightTo = 0;
            e.duration = 200;
            e.play();
            m = new Move(this);
            m.addEventListener(EffectEvent.EFFECT_END,this.effectEndHandler);
            m.xFrom = x;
            m.yFrom = y;
            m.xTo = parent.mouseX;
            m.yTo = parent.mouseY;
            m.duration = 200;
            m.play();
         }
         dragEvent = new DragEvent(DragEvent.DRAG_COMPLETE);
         dragEvent.dragInitiator = this.dragInitiator;
         dragEvent.dragSource = this.dragSource;
         dragEvent.relatedObject = InteractiveObject(this.target);
         dragEvent.action = this.action;
         dragEvent.ctrlKey = event.ctrlKey;
         dragEvent.altKey = event.altKey;
         dragEvent.shiftKey = event.shiftKey;
         this.dragInitiator.dispatchEvent(dragEvent);
         if(Boolean(delegate) && this.action == DragManager.NONE)
         {
            delegate.recordAutomatableDragCancel(this.dragInitiator,dragEvent);
         }
         cursorManager.removeCursor(this.cursorID);
         this.cursorID = CursorManager.NO_CURSOR;
         this.lastMouseEvent = null;
      }
      
      private function effectEndHandler(event:EffectEvent) : void
      {
         DragManager.endDrag();
      }
   }
}

