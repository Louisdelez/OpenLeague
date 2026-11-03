package flexlib.containers
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.containers.Canvas;
   
   [IconFile("DragScrollingCanvas.png")]
   public class DragScrollingCanvas extends Canvas
   {
      
      private var _undraggableClasses:Array = null;
      
      private var _childrenDoDrag:Boolean = true;
      
      private var regVScrollPosition:Number;
      
      private var regHScrollPosition:Number;
      
      private var regX:Number;
      
      private var _undraggableChildren:Array = null;
      
      private var regY:Number;
      
      public function DragScrollingCanvas()
      {
         super();
      }
      
      protected function startDragging(event:MouseEvent) : void
      {
         var child:* = undefined;
         var testClass:Class = null;
         if(event.target.parent == this.verticalScrollBar || event.target.parent == this.horizontalScrollBar)
         {
            return;
         }
         if(_undraggableChildren != null)
         {
            for each(child in _undraggableChildren)
            {
               if(event.target == child)
               {
                  return;
               }
            }
         }
         if(_undraggableClasses != null)
         {
            for each(testClass in _undraggableClasses)
            {
               if(event.target is testClass)
               {
                  return;
               }
            }
         }
         if(_childrenDoDrag || event.target == this)
         {
            regX = event.stageX;
            regY = event.stageY;
            regHScrollPosition = this.horizontalScrollPosition;
            regVScrollPosition = this.verticalScrollPosition;
            systemManager.addEventListener(MouseEvent.MOUSE_MOVE,systemManager_mouseMoveHandler,true);
            systemManager.addEventListener(MouseEvent.MOUSE_UP,systemManager_mouseUpHandler,true);
            systemManager.stage.addEventListener(Event.MOUSE_LEAVE,stage_mouseLeaveHandler);
         }
      }
      
      private function systemManager_mouseMoveHandler(event:MouseEvent) : void
      {
         event.stopImmediatePropagation();
         this.verticalScrollPosition = regVScrollPosition - (event.stageY - regY);
         this.horizontalScrollPosition = regHScrollPosition - (event.stageX - regX);
      }
      
      private function systemManager_mouseUpHandler(event:MouseEvent) : void
      {
         if(!isNaN(regX))
         {
            stopDragging();
         }
      }
      
      public function set undraggableClasses(value:Array) : void
      {
         _undraggableClasses = value;
      }
      
      public function get undraggableChildren() : Array
      {
         return _undraggableChildren;
      }
      
      public function set undraggableChildren(value:Array) : void
      {
         _undraggableChildren = value;
      }
      
      public function get undraggableClasses() : Array
      {
         return _undraggableClasses;
      }
      
      public function set childrenDoDrag(value:Boolean) : void
      {
         this._childrenDoDrag = value;
      }
      
      private function stage_mouseLeaveHandler(event:Event) : void
      {
         if(!isNaN(regX))
         {
            stopDragging();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.addEventListener(MouseEvent.MOUSE_DOWN,startDragging);
      }
      
      public function get childrenDoDrag() : Boolean
      {
         return this._childrenDoDrag;
      }
      
      protected function stopDragging() : void
      {
         systemManager.removeEventListener(MouseEvent.MOUSE_MOVE,systemManager_mouseMoveHandler,true);
         systemManager.removeEventListener(MouseEvent.MOUSE_UP,systemManager_mouseUpHandler,true);
         systemManager.stage.removeEventListener(Event.MOUSE_LEAVE,stage_mouseLeaveHandler);
         regX = NaN;
         regY = NaN;
      }
   }
}

