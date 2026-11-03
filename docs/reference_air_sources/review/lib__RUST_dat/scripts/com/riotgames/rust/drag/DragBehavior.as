package com.riotgames.rust.drag
{
   import blix.IDestructible;
   import blix.assets.proxy.InteractiveObjectProxy;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import flash.display.Stage;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class DragBehavior implements IDestructible
   {
      
      public var minDistance:Number;
      
      protected var _dragBegin:Signal = new Signal();
      
      protected var _isDragging:Boolean;
      
      protected var _mouseDownPosition:Point;
      
      protected var stage:Stage;
      
      protected var _target:InteractiveObjectProxy;
      
      protected var _localMouseDownPosition:Point;
      
      protected var _enabled:Boolean;
      
      public function DragBehavior(param1:InteractiveObjectProxy, param2:Number = 10)
      {
         super();
         this._target = param1;
         this._target.getDestroyed().addOnce(this.destroy);
         this.minDistance = param2;
         this.setEnabled(true);
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         if(this._enabled == param1)
         {
            return;
         }
         if(this._enabled)
         {
            this._target.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            this._target.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         }
         this._enabled = param1;
         if(this._enabled)
         {
            this._target.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            this._target.addEventListener(MouseEvent.CLICK,this.clickHandler,false,1000);
         }
      }
      
      private function clickHandler(param1:MouseEvent) : void
      {
         if(this._isDragging)
         {
            param1.stopImmediatePropagation();
         }
      }
      
      public function getDragBegin() : ISignal
      {
         return this._dragBegin;
      }
      
      public function getTarget() : InteractiveObjectProxy
      {
         return this._target;
      }
      
      public function getLocalMouseDownPosition() : Point
      {
         return this._localMouseDownPosition;
      }
      
      private function mouseDownHandler(param1:MouseEvent) : void
      {
         this._isDragging = false;
         this.stage = this._target.getStage();
         this.stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
         this.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         this._mouseDownPosition = new Point(this.stage.mouseX,this.stage.mouseY);
         this._localMouseDownPosition = new Point(this._target.getMouseX(),this._target.getMouseY());
      }
      
      private function mouseUpHandler(param1:MouseEvent = null) : void
      {
         this._isDragging = false;
         this.stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
         this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         this.stage == null;
      }
      
      protected function mouseMoveHandler(param1:MouseEvent) : void
      {
         var _loc2_:Point = new Point(this.stage.mouseX,this.stage.mouseY);
         if(Point.distance(_loc2_,this._mouseDownPosition) >= this.minDistance)
         {
            this.mouseUpHandler();
            this._isDragging = true;
            this._dragBegin.dispatch(this,param1.ctrlKey,param1.shiftKey,param1.altKey);
         }
      }
      
      public function destroy() : void
      {
         if(this.stage != null)
         {
            this.mouseUpHandler();
         }
         this._target.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         this._dragBegin.removeAll();
      }
   }
}

