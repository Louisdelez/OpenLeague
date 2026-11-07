package blix.layout.algorithms
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.layout.LayoutEntry;
   import blix.layout.data.ISizeLayoutData;
   import blix.layout.vo.Padding;
   import blix.layout.vo.Size;
   import blix.layout.vo.SizeConstraints;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.util.math.clamp;
   import blix.view.ILayoutElement;
   import flash.geom.Matrix3D;
   import flash.geom.PerspectiveProjection;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   
   public class CoverFlowLayout implements ILayoutAlgorithm
   {
      
      public var perspectiveProjectionTarget:DisplayObjectProxy;
      
      public var setPerspectiveProjection:Boolean = false;
      
      protected var _layoutInvalidated:Signal = new Signal();
      
      protected var _currentPosition:Number = 0;
      
      protected var _hGap:Number = 40;
      
      protected var _zGap:Number = 40;
      
      protected var _padding:Padding = new Padding(0);
      
      protected var _yRotation:Number = 30;
      
      protected var _xShiftMultiplier:Number = 1;
      
      public function CoverFlowLayout()
      {
         super();
      }
      
      public function getLayoutInvalidated() : ISignal
      {
         return this._layoutInvalidated;
      }
      
      public function getCurrentPosition() : Number
      {
         return this._currentPosition;
      }
      
      public function setCurrentPosition(param1:Number) : void
      {
         if(this._currentPosition == param1)
         {
            return;
         }
         this._currentPosition = param1;
         this._layoutInvalidated.dispatch(this);
      }
      
      public function getHGap() : Number
      {
         return this._hGap;
      }
      
      public function setHGap(param1:Number) : void
      {
         this._hGap = param1;
         this._layoutInvalidated.dispatch(this);
      }
      
      public function getZGap() : Number
      {
         return this._zGap;
      }
      
      public function setZGap(param1:Number) : void
      {
         if(this._zGap == param1)
         {
            return;
         }
         this._zGap = param1;
         this._layoutInvalidated.dispatch(this);
      }
      
      public function getYRotation() : Number
      {
         return this._yRotation;
      }
      
      public function setYRotation(param1:Number) : void
      {
         if(this._yRotation == param1)
         {
            return;
         }
         this._yRotation = param1;
         this._layoutInvalidated.dispatch(this);
      }
      
      public function getXShiftMultiplier() : Number
      {
         return this._xShiftMultiplier;
      }
      
      public function setXShiftMultiplier(param1:Number) : void
      {
         if(this._xShiftMultiplier == param1)
         {
            return;
         }
         this._xShiftMultiplier = param1;
         this._layoutInvalidated.dispatch(this);
      }
      
      public function getPadding() : Padding
      {
         return this._padding;
      }
      
      public function setPadding(param1:Padding) : void
      {
         this._padding = param1;
         this._layoutInvalidated.dispatch(this);
      }
      
      public function getSizeConstraints(param1:Number, param2:Number, param3:Vector.<LayoutEntry>) : SizeConstraints
      {
         return new SizeConstraints();
      }
      
      public function updateLayout(param1:Number, param2:Number, param3:Vector.<LayoutEntry>) : Rectangle
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc9_:ILayoutElement = null;
         var _loc10_:LayoutEntry = null;
         var _loc11_:uint = 0;
         var _loc15_:Point = null;
         var _loc16_:ISizeLayoutData = null;
         var _loc17_:Size = null;
         var _loc18_:Size = null;
         var _loc19_:PerspectiveProjection = null;
         var _loc20_:Number = NaN;
         var _loc21_:Point = null;
         var _loc22_:DisplayObjectProxy = null;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Matrix3D = null;
         var _loc26_:Rectangle = null;
         var _loc27_:Vector3D = null;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc6_:Number = 0;
         var _loc7_:Number = 0;
         var _loc8_:uint = param3.length;
         var _loc12_:Rectangle = new Rectangle();
         if(!_loc8_)
         {
            return _loc12_;
         }
         _loc4_ = param1 - this._padding.left - this._padding.right;
         _loc5_ = param2 - this._padding.top - this._padding.bottom;
         if(!isNaN(_loc5_))
         {
            _loc7_ = _loc5_;
         }
         _loc11_ = 0;
         while(_loc11_ < _loc8_)
         {
            _loc10_ = param3[_loc11_];
            _loc9_ = _loc10_.element;
            _loc16_ = _loc10_.data as ISizeLayoutData;
            if(Boolean(_loc16_))
            {
               _loc17_ = _loc16_.getWidthInfo(_loc4_);
               _loc18_ = _loc16_.getHeightInfo(_loc5_);
               _loc15_ = _loc9_.setExplicitSize(_loc17_.getIdeal(),_loc18_.getIdeal());
            }
            else
            {
               _loc15_ = _loc9_.setExplicitSize(NaN,NaN);
            }
            _loc6_ = Math.max(_loc6_,_loc15_.x);
            _loc7_ = Math.max(_loc7_,_loc15_.y);
            _loc11_++;
         }
         var _loc13_:Number = Math.abs(Math.cos(this._yRotation * 180 / Math.PI)) * _loc6_ * this._xShiftMultiplier;
         _loc12_.width = this._padding.left + this._hGap * (_loc8_ - 1) * 2 + _loc13_ * 2 + this._padding.right;
         _loc12_.height = _loc7_ + this._padding.top + this._padding.bottom;
         var _loc14_:Number = _loc12_.width / 2;
         if(Boolean(this.setPerspectiveProjection) && Boolean(this.perspectiveProjectionTarget) && this.perspectiveProjectionTarget.getAsset() != null)
         {
            _loc19_ = new PerspectiveProjection();
            _loc20_ = (_loc8_ - 1) * this._zGap;
            _loc14_ -= (Math.cos(_loc19_.fieldOfView * Math.PI / 180) * (_loc19_.focalLength + _loc20_) - _loc19_.projectionCenter.x) * 0.5;
            _loc21_ = new Point();
            _loc21_.x = _loc14_ + _loc6_ / 2;
            _loc21_.y = _loc12_.height / 2;
            _loc19_.projectionCenter = _loc21_;
            this.perspectiveProjectionTarget.getAsset().transform.perspectiveProjection = _loc19_;
         }
         _loc11_ = 0;
         while(_loc11_ < _loc8_)
         {
            _loc10_ = param3[_loc11_];
            _loc9_ = _loc10_.element;
            if(_loc9_ is DisplayObjectProxy)
            {
               _loc22_ = _loc9_ as DisplayObjectProxy;
               _loc23_ = _loc11_ - this._currentPosition;
               _loc24_ = Math.abs(_loc23_);
               _loc22_.setWeight(-_loc24_);
               _loc25_ = new Matrix3D();
               _loc26_ = _loc22_.getUnscaledBounds();
               _loc27_ = new Vector3D(_loc26_.width / 2,_loc26_.height / 2,0);
               _loc28_ = Number(clamp(_loc23_,-1,1));
               _loc29_ = this._hGap * _loc23_ + _loc28_ * _loc13_ + _loc14_;
               _loc30_ = 0;
               _loc31_ = _loc24_ * this._zGap;
               _loc25_.appendTranslation(_loc29_,_loc30_,_loc31_);
               _loc25_.prependRotation(_loc28_ * this._yRotation,Vector3D.Y_AXIS,_loc27_);
               _loc22_.setTransformMatrix3d(_loc25_);
            }
            _loc11_++;
         }
         return _loc12_;
      }
   }
}

