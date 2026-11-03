package blix.view
{
   import blix.INamed;
   import blix.context.Context;
   import blix.context.IContext;
   import blix.decorator.IDecoratable;
   import blix.decorator.IDecoratorManager;
   import blix.layout.vo.SizeConstraints;
   import blix.logger.Logger;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.util.proxy.SetterProxy;
   import blix.view.behaviors.ITransformBehavior;
   import blix.view.behaviors.SimpleTransformBehavior;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class View extends Context implements IView, IDecoratable, IContext, INamed, IValidatable
   {
      
      protected var _actualPositionChanged:Signal = new Signal();
      
      protected var _destroyed:Signal = new Signal();
      
      protected var _layoutInvalidated:Signal = new Signal();
      
      protected var _scaledBoundsChanged:Signal = new Signal();
      
      protected var _unscaledBoundsChanged:Signal = new Signal();
      
      protected var _actualPosition:Point = new Point(0,0);
      
      protected var _availableSize:Point = new Point(NaN,NaN);
      
      protected var _unscaledSizeConstraints:SizeConstraints = new SizeConstraints();
      
      protected var _explicitPosition:Point = new Point(NaN,NaN);
      
      protected var _explicitSize:Point = new Point(NaN,NaN);
      
      protected var _includeInLayout:Boolean = true;
      
      protected var _name:String;
      
      protected var _scaledBoundsCache:Rectangle = new Rectangle();
      
      protected var _setterProxy:SetterProxy;
      
      protected var _transformBehavior:ITransformBehavior = new SimpleTransformBehavior();
      
      protected var _unscaledBounds:Rectangle = new Rectangle();
      
      protected var _logger:Logger;
      
      protected var _decoratorManager:IDecoratorManager;
      
      protected var isValidFlag:Boolean = true;
      
      protected var availableSizeIsValidFlag:Boolean = false;
      
      protected var layoutIsValidFlag:Boolean = false;
      
      protected var positionIsValidFlag:Boolean = false;
      
      protected var _isValidatingLayout:Boolean;
      
      public function View(param1:IContext)
      {
         super(param1);
         this._logger = new Logger(this);
         this.initialize();
         this.invalidate();
      }
      
      protected function initialize() : void
      {
         this._decoratorManager = getDependency(IDecoratorManager);
         if(this._decoratorManager != null)
         {
            this._decoratorManager.addTarget(this);
         }
      }
      
      public function getTransformBehavior() : ITransformBehavior
      {
         return this._transformBehavior;
      }
      
      public function setTransformBehavior(param1:ITransformBehavior) : void
      {
         if(param1 == null)
         {
            throw new Error("transform behavior may not be null.");
         }
         if(Boolean(this._transformBehavior))
         {
            this._transformBehavior.getLayoutInvalidated().remove(this.invalidateLayout);
         }
         this._transformBehavior = param1;
         if(Boolean(this._transformBehavior))
         {
            this._transformBehavior.getLayoutInvalidated().add(this.invalidateLayout);
         }
         this.invalidateLayout();
      }
      
      public function getSetterProxy() : SetterProxy
      {
         if(this._setterProxy == null)
         {
            this._setterProxy = new SetterProxy(this);
         }
         return this._setterProxy;
      }
      
      public function getIncludeInLayout() : Boolean
      {
         return this._includeInLayout;
      }
      
      public function setIncludeInLayout(param1:Boolean) : void
      {
         if(this._includeInLayout == param1)
         {
            return;
         }
         this._includeInLayout = param1;
         this._layoutInvalidated.dispatch(this);
      }
      
      public function getLayoutIsValid() : Boolean
      {
         return this.layoutIsValidFlag;
      }
      
      public function invalidate() : void
      {
         if(!this.isValidFlag)
         {
            return;
         }
         var _loc1_:Boolean = LayoutValidator.getInstance().getValidateLayoutBegin().add(this);
         if(_loc1_)
         {
            this.isValidFlag = false;
         }
         LayoutValidator.getInstance().invalidateLayout();
      }
      
      public function validate() : void
      {
         if(!this.availableSizeIsValidFlag)
         {
            this.validateAvailableSize();
         }
         if(!this.layoutIsValidFlag)
         {
            this.validateLayout();
         }
         if(!this.positionIsValidFlag)
         {
            this.validatePosition();
         }
         this.isValidFlag = true;
      }
      
      public function getValidationWeight() : Number
      {
         return getAncestryLength();
      }
      
      [Abstract]
      public function getTransformMatrix() : Matrix
      {
         return new Matrix();
      }
      
      [Abstract]
      public function setTransformMatrix(param1:Matrix) : void
      {
      }
      
      [Abstract]
      public function getTransformMatrix3d() : Matrix3D
      {
         return new Matrix3D();
      }
      
      [Abstract]
      public function setTransformMatrix3d(param1:Matrix3D) : void
      {
      }
      
      public function getScaledSizeConstraints() : SizeConstraints
      {
         return this._transformBehavior.getSizeConstraintsAfterTransform(this,this._unscaledSizeConstraints,this.getTransformMatrix());
      }
      
      public function getUnscaledSizeConstraints() : SizeConstraints
      {
         return this._unscaledSizeConstraints;
      }
      
      public function setAvailableSize(param1:Number, param2:Number) : SizeConstraints
      {
         if(this._availableSize.x != param1 && (!isNaN(this._availableSize.x) || !isNaN(param1)) || this._availableSize.y != param2 && (!isNaN(this._availableSize.y) || !isNaN(param2)))
         {
            this._availableSize.x = param1;
            this._availableSize.y = param2;
            this.availableSizeIsValidFlag = false;
         }
         if(!this.availableSizeIsValidFlag)
         {
            this.validateAvailableSize();
         }
         return this._transformBehavior.getSizeConstraintsAfterTransform(this,this._unscaledSizeConstraints,this.getTransformMatrix());
      }
      
      protected function validateAvailableSize() : void
      {
         var _loc1_:Matrix = this.getTransformMatrix();
         var _loc2_:Point = this._transformBehavior.getAvailableSizeBeforeTransform(this,this._availableSize,_loc1_);
         this._unscaledSizeConstraints = this.updateSizeConstraints(_loc2_.x,_loc2_.y);
         this.availableSizeIsValidFlag = true;
      }
      
      public function updateSizeConstraints(param1:Number, param2:Number) : SizeConstraints
      {
         return new SizeConstraints();
      }
      
      public function getScaledBoundsChanged() : ISignal
      {
         return this._scaledBoundsChanged;
      }
      
      public function getScaledBounds() : Rectangle
      {
         if(this._scaledBoundsCache == null)
         {
            this._scaledBoundsCache = this.calculateScaledBoundsCache();
         }
         return this._scaledBoundsCache;
      }
      
      protected function clearScaledBoundsCache() : void
      {
         if(Boolean(this._scaledBoundsCache))
         {
            this._scaledBoundsCache = null;
         }
      }
      
      protected function calculateScaledBoundsCache() : Rectangle
      {
         return this._transformBehavior.getUnscaledBoundsAfterTransform(this,this.getUnscaledBounds(),this.getTransformMatrix());
      }
      
      public function getUnscaledBoundsChanged() : ISignal
      {
         return this._unscaledBoundsChanged;
      }
      
      public function getUnscaledBounds() : Rectangle
      {
         return this._unscaledBounds;
      }
      
      public function getExplicitSize() : Point
      {
         return this._explicitSize.clone();
      }
      
      public function getLayoutInvalidated() : ISignal
      {
         return this._layoutInvalidated;
      }
      
      public function setExplicitSize(param1:Number, param2:Number) : Point
      {
         if(this._explicitSize.x != param1 && !(isNaN(this._explicitSize.x) && isNaN(param1)) || this._explicitSize.y != param2 && !(isNaN(this._explicitSize.y) && isNaN(param2)))
         {
            this._explicitSize.x = param1;
            this._explicitSize.y = param2;
            this.layoutIsValidFlag = false;
            this.invalidate();
         }
         if(!this.availableSizeIsValidFlag)
         {
            this.validateAvailableSize();
         }
         if(!this.layoutIsValidFlag)
         {
            this.validateLayout();
         }
         var _loc3_:Rectangle = this.getScaledBounds();
         return new Point(_loc3_.width,_loc3_.height);
      }
      
      public function invalidateLayout() : void
      {
         if(this._isValidatingLayout)
         {
            return;
         }
         if(this.layoutIsValidFlag)
         {
            this.layoutIsValidFlag = false;
            this._layoutInvalidated.dispatch(this);
         }
         this.invalidate();
      }
      
      protected function validateLayout() : void
      {
         var _loc6_:Rectangle = null;
         this._isValidatingLayout = true;
         var _loc1_:Matrix = this.getTransformMatrix();
         var _loc2_:Point = this._transformBehavior.getExplicitSizeBeforeTransform(this,this._explicitSize,_loc1_);
         var _loc3_:Rectangle = this.getScaledBounds();
         var _loc4_:Rectangle = this._unscaledBounds;
         this._unscaledBounds = this.updateLayout(_loc2_.x,_loc2_.y);
         var _loc5_:Boolean = this._transformBehavior.updateTransformation(this,this._unscaledBounds,_loc1_);
         if(_loc5_)
         {
            this.positionIsValidFlag = false;
            this.setTransformMatrix(_loc1_);
         }
         if(!_loc4_.equals(this._unscaledBounds))
         {
            this.positionIsValidFlag = false;
            this.clearScaledBoundsCache();
            this._unscaledBoundsChanged.dispatch(this,_loc4_,this._unscaledBounds);
         }
         if(this._scaledBoundsChanged.getHasListeners())
         {
            _loc6_ = this.getScaledBounds();
            if(!_loc3_.equals(_loc6_))
            {
               this._scaledBoundsChanged.dispatch(this,_loc3_,_loc6_);
            }
         }
         this.layoutIsValidFlag = true;
         this._isValidatingLayout = false;
      }
      
      [Abstract]
      protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         return new Rectangle();
      }
      
      protected function invalidateTransform() : void
      {
         this.availableSizeIsValidFlag = false;
         this.positionIsValidFlag = false;
         this.clearScaledBoundsCache();
         this.invalidateLayout();
      }
      
      public function getActualPositionChanged() : ISignal
      {
         return this._actualPositionChanged;
      }
      
      public function getActualPosition() : Point
      {
         return this._actualPosition;
      }
      
      public function getExplicitPosition() : Point
      {
         return this._explicitPosition.clone();
      }
      
      public function setExplicitPosition(param1:Number, param2:Number) : Point
      {
         if(!this.layoutIsValidFlag && !this._isValidatingLayout)
         {
            this.validateLayout();
         }
         if(this._explicitPosition.x != param1 && (!isNaN(this._explicitPosition.x) || !isNaN(param1)) || this._explicitPosition.y != param2 && (!isNaN(this._explicitPosition.y) || !isNaN(param2)))
         {
            this._explicitPosition.x = param1;
            this._explicitPosition.y = param2;
            this.positionIsValidFlag = false;
            this.invalidate();
         }
         if(!this.availableSizeIsValidFlag)
         {
            this.validateAvailableSize();
         }
         if(!this.layoutIsValidFlag)
         {
            this.validateLayout();
         }
         if(!this.positionIsValidFlag)
         {
            this.validatePosition();
         }
         return this._transformBehavior.getActualPositionAfterTransform(this,this._actualPosition,this.getTransformMatrix());
      }
      
      protected function validatePosition() : void
      {
         var _loc1_:Matrix = this.getTransformMatrix();
         var _loc2_:Point = this._actualPosition;
         var _loc3_:Point = this._transformBehavior.getExplicitPositionBeforeTransform(this,this._explicitPosition,_loc1_);
         this._actualPosition = this.updatePosition(_loc3_.x,_loc3_.y);
         var _loc4_:Boolean = this._transformBehavior.updateTranslation(this,this._actualPosition,_loc1_);
         if(_loc4_)
         {
            this.setTransformMatrix(_loc1_);
         }
         if(this._actualPositionChanged.getHasListeners() && !_loc2_.equals(this._actualPosition))
         {
            this._actualPositionChanged.dispatch(this,_loc2_,this._actualPosition);
         }
         this.positionIsValidFlag = true;
      }
      
      [Abstract]
      protected function updatePosition(param1:Number, param2:Number) : Point
      {
         return new Point(param1,param2);
      }
      
      public function toString() : String
      {
         return this.getName();
      }
      
      public function getName() : String
      {
         var _loc1_:Array = null;
         var _loc2_:String = null;
         if(Boolean(this._name))
         {
            return this._name;
         }
         _loc1_ = getClassName().split("::");
         return _loc1_.pop() + id.toString();
      }
      
      public function setName(param1:String) : void
      {
         this._name = param1;
      }
      
      public function getDestroyed() : ISignal
      {
         return this._destroyed;
      }
      
      public function destroy() : void
      {
         this._destroyed.dispatch(this);
         LayoutValidator.getInstance().getValidateLayoutBegin().remove(this);
         this._transformBehavior.getLayoutInvalidated().remove(this.invalidateLayout);
         if(this._decoratorManager != null)
         {
            this._decoratorManager.removeTarget(this);
         }
         this._actualPositionChanged.removeAll();
         this._destroyed.removeAll();
         this._layoutInvalidated.removeAll();
         this._unscaledBoundsChanged.removeAll();
      }
   }
}

