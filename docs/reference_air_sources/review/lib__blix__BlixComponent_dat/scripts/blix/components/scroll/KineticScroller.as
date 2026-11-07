package blix.components.scroll
{
   import blix.IDestructible;
   import blix.assets.proxy.IDisplayChild;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import flash.display.DisplayObject;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.getTimer;
   
   public class KineticScroller implements IDestructible
   {
      
      private static const MIN_TOSS_DISTANCE:Number = 7;
      
      private static const HISTORY_LENGTH:uint = 5;
      
      public var modelToPixels:Number = 1;
      
      public var dampening:Number = 0.8;
      
      public var horizontalScrollEnabled:Boolean = true;
      
      public var verticalScrollEnabled:Boolean = true;
      
      protected var _tossStart:Signal = new Signal();
      
      protected var _tossEnd:Signal = new Signal();
      
      protected var _velocity:Point = new Point();
      
      protected var _target:IDisplayChild;
      
      protected var _targetAsset:DisplayObject;
      
      protected var startPoint:Point;
      
      protected var previousPoints:Vector.<Point> = new Vector.<Point>();
      
      protected var previousTimes:Vector.<int> = new Vector.<int>();
      
      protected var _enabled:Boolean = true;
      
      protected var _horizontalScrollModel:ScrollModel;
      
      protected var _verticalScrollModel:ScrollModel;
      
      protected var _isMoving:Boolean;
      
      protected var _stage:Stage;
      
      public function KineticScroller(param1:IDisplayChild, param2:ScrollModel, param3:ScrollModel)
      {
         super();
         this.setTarget(param1,param2,param3);
      }
      
      public function getTossStart() : ISignal
      {
         return this._tossStart;
      }
      
      public function getTossEnd() : ISignal
      {
         return this._tossEnd;
      }
      
      public function getTarget() : IDisplayChild
      {
         return this._target;
      }
      
      public function setTarget(param1:IDisplayChild, param2:ScrollModel, param3:ScrollModel) : void
      {
         if(this._target == param1)
         {
            return;
         }
         if(this._target != null)
         {
            this._target.getAssetChanged().remove(this.targetAssetChangedHandler);
            this.setTargetAsset(null);
         }
         this._target = param1;
         this._horizontalScrollModel = param2;
         this._verticalScrollModel = param3;
         if(this._target != null)
         {
            this._target.getAssetChanged().add(this.targetAssetChangedHandler);
            this.setTargetAsset(this._target.getAsset());
         }
      }
      
      protected function targetAssetChangedHandler() : void
      {
         this.setTargetAsset(this._target.getAsset());
      }
      
      protected function getTargetAsset() : DisplayObject
      {
         return this._targetAsset;
      }
      
      protected function setTargetAsset(param1:DisplayObject) : void
      {
         if(this._targetAsset == param1)
         {
            return;
         }
         if(this._targetAsset != null)
         {
            this.removeAllListeners();
         }
         this._targetAsset = param1;
         if(this._targetAsset != null)
         {
            this._targetAsset.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler,false,0,true);
            this._targetAsset.addEventListener(MouseEvent.CLICK,this.mouseClickHandler,true,100,true);
         }
      }
      
      protected function mouseDownHandler(param1:MouseEvent) : void
      {
         if(!this._enabled)
         {
            return;
         }
         if(param1.target is TextField && TextField(param1.target).selectable)
         {
            return;
         }
         this._stage = this._targetAsset.stage;
         this.stop();
         this.startPoint = new Point(this._stage.mouseX,this._stage.mouseY);
         this.previousPoints.length = 0;
         this.previousPoints[0] = this.startPoint;
         this.previousTimes.length = 0;
         this.previousTimes[0] = getTimer();
         this._stage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler,false,0,true);
         this._stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler,false,0,true);
         this._tossStart.dispatch(this);
      }
      
      private function hasMouseEventListeners(param1:DisplayObject) : Boolean
      {
         if(param1 == this._targetAsset)
         {
            return false;
         }
         if(param1.hasEventListener(MouseEvent.MOUSE_DOWN) || param1.hasEventListener(MouseEvent.MOUSE_UP))
         {
            return true;
         }
         if(Boolean(param1.parent))
         {
            return this.hasMouseEventListeners(param1.parent);
         }
         return false;
      }
      
      protected function mouseMoveHandler(param1:MouseEvent) : void
      {
         if(!param1.buttonDown)
         {
            this.mouseUpHandler();
            return;
         }
         if(!this._enabled)
         {
            return;
         }
         var _loc2_:Point = new Point(this._stage.mouseX,this._stage.mouseY);
         var _loc3_:int = getTimer();
         var _loc4_:Point = this.previousPoints[this.previousPoints.length - 1];
         var _loc5_:Point = _loc2_.subtract(_loc4_);
         _loc5_ = this.transformPointToLocal(_loc5_);
         if(_loc2_.subtract(this.startPoint).length > MIN_TOSS_DISTANCE)
         {
            this.moveScrollPosition(_loc5_);
         }
         this.previousPoints.push(_loc2_);
         this.previousTimes.push(_loc3_);
         if(this.previousPoints.length >= HISTORY_LENGTH)
         {
            this.previousPoints.shift();
            this.previousTimes.shift();
         }
      }
      
      protected function mouseUpHandler(param1:MouseEvent = null) : void
      {
         this._stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
         this._stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         if(!this._enabled)
         {
            return;
         }
         var _loc2_:Point = new Point(this._stage.mouseX,this._stage.mouseY);
         var _loc3_:int = getTimer();
         var _loc4_:Point = this.previousPoints[0];
         var _loc5_:int = this.previousTimes[0];
         if(_loc3_ - _loc5_ < 2)
         {
            return;
         }
         var _loc6_:Point = _loc2_.subtract(_loc4_);
         var _loc7_:Number = (_loc3_ - _loc5_) / (1000 / this._stage.frameRate);
         this._velocity = new Point(_loc6_.x / _loc7_,_loc6_.y / _loc7_);
         if(_loc2_.subtract(this.startPoint).length > MIN_TOSS_DISTANCE)
         {
            this.start();
         }
      }
      
      private function mouseClickHandler(param1:MouseEvent) : void
      {
         if(!this._enabled || this.previousPoints.length == 0)
         {
            return;
         }
         var _loc2_:Point = this.previousPoints[this.previousPoints.length - 1];
         if(_loc2_.subtract(this.startPoint).length > MIN_TOSS_DISTANCE)
         {
            param1.stopImmediatePropagation();
         }
      }
      
      protected function start() : void
      {
         if(this._isMoving == true)
         {
            return;
         }
         this._isMoving = true;
         this._targetAsset.addEventListener(Event.ENTER_FRAME,this.enterFrameHandler,false,0,true);
      }
      
      public function stop() : void
      {
         if(this._isMoving == false)
         {
            return;
         }
         this._targetAsset.removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
         this._velocity = new Point();
         this._tossEnd.dispatch(this);
         this._isMoving = false;
      }
      
      protected function enterFrameHandler(param1:Event) : void
      {
         this._velocity = new Point(this._velocity.x * this.dampening,this._velocity.y * this.dampening);
         var _loc2_:Point = this.transformPointToLocal(this._velocity);
         if(Math.abs(_loc2_.x) < 0.1)
         {
            _loc2_.x = 0;
         }
         if(Math.abs(_loc2_.y) < 0.1)
         {
            _loc2_.y = 0;
         }
         if(!_loc2_.x && !_loc2_.y)
         {
            this.stop();
         }
         this.moveScrollPosition(_loc2_);
      }
      
      public function getVelocity() : Point
      {
         return this._velocity;
      }
      
      public function setVelocity(param1:Point) : void
      {
         if(!param1)
         {
            param1 = new Point();
         }
         if(!this._stage)
         {
            return;
         }
         this._stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
         this._stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         this._velocity = param1;
         this.start();
      }
      
      protected function removeAllListeners() : void
      {
         this._targetAsset.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         this._targetAsset.removeEventListener(MouseEvent.CLICK,this.mouseClickHandler,true);
         this._targetAsset.removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
         if(Boolean(this._stage))
         {
            this._stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
            this._stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         }
      }
      
      public function getEnabled() : Boolean
      {
         return this._enabled;
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         if(param1 == this._enabled)
         {
            return;
         }
         this._enabled = param1;
         if(!param1)
         {
            this.stop();
         }
      }
      
      protected function moveScrollPosition(param1:Point) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.horizontalScrollEnabled && this._horizontalScrollModel != null)
         {
            _loc2_ = this._horizontalScrollModel.getValue();
            this._horizontalScrollModel.setValue(this._horizontalScrollModel.clampValue(_loc2_ - param1.x / this.modelToPixels));
         }
         if(this.verticalScrollEnabled && this._verticalScrollModel != null)
         {
            _loc3_ = this._verticalScrollModel.getValue();
            this._verticalScrollModel.setValue(this._verticalScrollModel.clampValue(_loc3_ - param1.y / this.modelToPixels));
         }
      }
      
      private function transformPointToLocal(param1:Point) : Point
      {
         var _loc2_:Matrix = this._targetAsset.transform.concatenatedMatrix.clone();
         _loc2_.tx = 0;
         _loc2_.ty = 0;
         _loc2_.invert();
         return _loc2_.transformPoint(param1);
      }
      
      public function destroy() : void
      {
         this._tossStart.removeAll();
         this._tossEnd.removeAll();
         this.setTarget(null,null,null);
      }
   }
}

