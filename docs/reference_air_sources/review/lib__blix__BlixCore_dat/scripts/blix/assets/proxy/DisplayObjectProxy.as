package blix.assets.proxy
{
   import blix.IDestructible;
   import blix.assets.IAssetsManager;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.View;
   import flash.accessibility.AccessibilityProperties;
   import flash.display.DisplayObject;
   import flash.display.LoaderInfo;
   import flash.display.Shader;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Transform;
   import flash.geom.Vector3D;
   
   [Event(name="render",type="flash.events.Event")]
   [Event(name="removedFromStage",type="flash.events.Event")]
   [Event(name="removed",type="flash.events.Event")]
   [Event(name="frameConstructed",type="flash.events.Event")]
   [Event(name="exitFrame",type="flash.events.Event")]
   [Event(name="enterFrame",type="flash.events.Event")]
   [Event(name="addedToStage",type="flash.events.Event")]
   [Event(name="added",type="flash.events.Event")]
   public class DisplayObjectProxy extends View implements IDisplayChild, IEventDispatcher, IDestructible
   {
      
      public var validateOffStage:Boolean;
      
      protected var _linkage:String;
      
      protected var _linkageFilter:*;
      
      protected var _isOnStage:Boolean;
      
      protected var _isOnStageChanged:Signal = new Signal();
      
      protected var _isTimelineChild:Boolean;
      
      protected var _asset:DisplayObject;
      
      protected var _assetClass:Class;
      
      protected var _assetChanged:Signal = new Signal();
      
      protected var _mask:DisplayObjectProxy;
      
      protected var _parentDisplayContainer:IDisplayContainer;
      
      protected var _stage:Stage;
      
      protected var _weightChanged:Signal = new Signal();
      
      protected var _weight:Number = 0;
      
      protected var assetsManager:IAssetsManager;
      
      protected var assetProxy:PropertyProxy;
      
      protected var dispatcherProxy:EventDispatcherProxy;
      
      protected var pendingCalls:Vector.<PendingCall> = new Vector.<PendingCall>();
      
      public function DisplayObjectProxy(param1:IContext, param2:DisplayObject = null)
      {
         super(param1);
         this.setAsset(param2);
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.assetProxy = new PropertyProxy();
         this.assetProxy.setPropertyAsWriteOnly("blendShader");
         this.dispatcherProxy = new EventDispatcherProxy(this);
         this.assetsManager = getDependency(IAssetsManager);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStageHandler);
         this.addEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
      }
      
      protected function removedFromStageHandler(param1:Event) : void
      {
         this.setIsOnStage(false);
         this._stage = null;
      }
      
      protected function addedToStageHandler(param1:Event) : void
      {
         this._stage = this.getStage();
         this.setIsOnStage(true);
      }
      
      public function getIsOnStageChanged() : ISignal
      {
         return this._isOnStageChanged;
      }
      
      public function getIsOnStage() : Boolean
      {
         return this._isOnStage;
      }
      
      protected function setIsOnStage(param1:Boolean) : void
      {
         if(this._isOnStage == param1)
         {
            return;
         }
         this._isOnStage = param1;
         this._isOnStageChanged.dispatch(this);
         invalidateLayout();
      }
      
      public function getAssetChanged() : ISignal
      {
         return this._assetChanged;
      }
      
      public function getAsset() : DisplayObject
      {
         return this._asset;
      }
      
      public function setAsset(param1:DisplayObject) : void
      {
         if(this._asset == param1)
         {
            return;
         }
         var _loc2_:DisplayObject = this._asset;
         this.unconfigureAsset(_loc2_);
         this.configureAsset(param1);
         if(this._asset != null && this._asset.stage != null)
         {
            this._stage = this._asset.stage;
            if(!this.getIsOnStage())
            {
               this.setIsOnStage(true);
            }
         }
         else
         {
            if(this.getIsOnStage())
            {
               this.setIsOnStage(false);
            }
            this._stage = null;
         }
         availableSizeIsValidFlag = false;
         positionIsValidFlag = false;
         invalidateLayout();
         this._assetChanged.dispatch(this,_loc2_,this._asset);
      }
      
      protected function unconfigureAsset(param1:DisplayObject) : void
      {
      }
      
      protected function configureAsset(param1:DisplayObject) : void
      {
         var _loc2_:PendingCall = null;
         this._asset = param1;
         this.assetProxy.setTarget(this._asset);
         this.dispatcherProxy.setDispatcher(this._asset);
         if(this._asset != null)
         {
            for each(_loc2_ in this.pendingCalls)
            {
               _loc2_.execute(this._asset);
            }
            this.pendingCalls.length = 0;
         }
      }
      
      override public function getIncludeInLayout() : Boolean
      {
         return Boolean(super.getIncludeInLayout()) && this._asset != null && this._asset.stage != null && this._asset.visible;
      }
      
      public function getLinkage() : String
      {
         return this._linkage;
      }
      
      public function setLinkage(param1:String, param2:* = null) : void
      {
         if(this._linkage == param1)
         {
            return;
         }
         if(this.assetsManager == null)
         {
            throw new Error("setLinkage if the IAssetManager dependency is set.");
         }
         if(this._linkage != null)
         {
            this.assetsManager.getAssetsChanged().remove(this.refreshLinkageAsset);
            this.setAsset(null);
         }
         this._linkage = param1;
         this._linkageFilter = param2;
         this._assetClass = null;
         if(param1 != null)
         {
            this.assetsManager.getAssetsChanged().add(this.refreshLinkageAsset);
            this.refreshLinkageAsset();
         }
      }
      
      private function refreshLinkageAsset() : void
      {
         var _loc1_:Class = null;
         var _loc2_:DisplayObject = null;
         if(Boolean(this._linkage) && !this.getIsTimelineChild())
         {
            _loc1_ = this.assetsManager.getAssetByLinkage(this._linkage,this._linkageFilter);
            if(this._assetClass != _loc1_)
            {
               this._assetClass = _loc1_;
               if(_loc1_ == null)
               {
                  this.setAsset(null);
               }
               else
               {
                  _loc2_ = new _loc1_();
                  if(_loc2_ != null)
                  {
                     _loc2_.name = getName();
                  }
                  this.setAsset(_loc2_);
               }
            }
         }
      }
      
      protected function addPendingCall(param1:String, param2:Array = null) : void
      {
         this.pendingCalls[this.pendingCalls.length] = new PendingCall(param1,param2);
      }
      
      public function getAccessibilityProperties() : AccessibilityProperties
      {
         return this.assetProxy.accessibilityProperties;
      }
      
      public function setAccessibilityProperties(param1:AccessibilityProperties) : void
      {
         this.assetProxy.accessibilityProperties = param1;
      }
      
      public function getAlpha() : Number
      {
         return this.assetProxy.alpha;
      }
      
      public function setAlpha(param1:Number) : void
      {
         this.assetProxy.alpha = param1;
      }
      
      public function getBlendMode() : String
      {
         return this.assetProxy.blendMode;
      }
      
      public function setBlendMode(param1:String) : void
      {
         this.assetProxy.blendMode = param1;
      }
      
      public function getBlendShader() : Shader
      {
         return this.assetProxy.blendShader;
      }
      
      public function setBlendShader(param1:Shader) : void
      {
         this.assetProxy.blendShader = param1;
      }
      
      public function getCacheAsBitmap() : Boolean
      {
         return this.assetProxy.cacheAsBitmap;
      }
      
      public function setCacheAsBitmap(param1:Boolean) : void
      {
         this.assetProxy.cacheAsBitmap = param1;
      }
      
      public function getCacheAsBitmapMatrix() : Matrix
      {
         return this.assetProxy.cacheAsBitmapMatrix;
      }
      
      public function setCacheAsBitmapMatrix(param1:Matrix) : void
      {
         this.assetProxy.cacheAsBitmapMatrix = param1;
      }
      
      public function getFilters() : Array
      {
         return this.assetProxy.filters;
      }
      
      public function setFilters(param1:Array) : void
      {
         this.assetProxy.filters = param1;
      }
      
      public function getHeight() : Number
      {
         return this.assetProxy.height;
      }
      
      public function setHeight(param1:Number) : void
      {
         this.assetProxy.height = param1;
      }
      
      public function getLoaderInfo() : LoaderInfo
      {
         return this.assetProxy.loaderInfo;
      }
      
      public function getMask() : DisplayObject
      {
         return this.assetProxy.mask;
      }
      
      public function setMask(param1:DisplayObjectProxy) : void
      {
         if(this._mask != null)
         {
            this._mask.getAssetChanged().remove(this.maskChangeHandler);
            this.assetProxy.mask = null;
         }
         this._mask = param1;
         if(this._mask != null)
         {
            this._mask.getAssetChanged().add(this.maskChangeHandler);
            this.maskChangeHandler();
         }
      }
      
      protected function maskChangeHandler() : void
      {
         this.assetProxy.mask = this._mask.getAsset();
      }
      
      public function getMouseX() : Number
      {
         return this.assetProxy.mouseX;
      }
      
      public function getMouseY() : Number
      {
         return this.assetProxy.mouseY;
      }
      
      public function getInstanceName() : String
      {
         return this.assetProxy.name;
      }
      
      public function setInstanceName(param1:String) : void
      {
         this.assetProxy.name = param1;
      }
      
      public function getOpaqueBackground() : Object
      {
         return this.assetProxy.opaqueBackground;
      }
      
      public function setOpaqueBackground(param1:Object) : void
      {
         this.assetProxy.opaqueBackground = param1;
      }
      
      public function getRotation() : Number
      {
         return this.assetProxy.rotation;
      }
      
      public function setRotation(param1:Number) : void
      {
         this.assetProxy.rotation = param1;
         invalidateTransform();
      }
      
      public function getRotationX() : Number
      {
         return this.assetProxy.rotationX;
      }
      
      public function setRotationX(param1:Number) : void
      {
         this.assetProxy.rotationX = param1;
         invalidateTransform();
      }
      
      public function getRotationY() : Number
      {
         return this.assetProxy.rotationY;
      }
      
      public function setRotationY(param1:Number) : void
      {
         this.assetProxy.rotationY = param1;
         invalidateTransform();
      }
      
      public function getRotationZ() : Number
      {
         return this.assetProxy.rotationZ;
      }
      
      public function setRotationZ(param1:Number) : void
      {
         this.assetProxy.rotationZ = param1;
         invalidateTransform();
      }
      
      public function getScale9Grid() : Rectangle
      {
         return this.assetProxy.scale9Grid;
      }
      
      public function setScale9Grid(param1:Rectangle) : void
      {
         this.assetProxy.scale9Grid = param1;
         invalidateLayout();
      }
      
      public function getScaleX() : Number
      {
         return this.assetProxy.scaleX;
      }
      
      public function setScaleX(param1:Number) : void
      {
         this.assetProxy.scaleX = param1;
         invalidateLayout();
      }
      
      public function getScaleY() : Number
      {
         return this.assetProxy.scaleY;
      }
      
      public function setScaleY(param1:Number) : void
      {
         this.assetProxy.scaleY = param1;
         invalidateLayout();
      }
      
      public function getScaleZ() : Number
      {
         return this.assetProxy.scaleZ;
      }
      
      public function setScaleZ(param1:Number) : void
      {
         this.assetProxy.scaleZ = param1;
         invalidateLayout();
      }
      
      public function getScrollRect() : Rectangle
      {
         return this.assetProxy.scrollRect;
      }
      
      public function setScrollRect(param1:Rectangle) : void
      {
         this.assetProxy.scrollRect = param1;
         invalidateLayout();
      }
      
      public function getStage() : Stage
      {
         return this.assetProxy.stage;
      }
      
      public function getTransform() : Transform
      {
         return this.assetProxy.transform;
      }
      
      public function setTransform(param1:Transform) : void
      {
         this.assetProxy.transform = param1;
         invalidateTransform();
      }
      
      public function getVisible() : Boolean
      {
         return this.assetProxy.visible;
      }
      
      public function setVisible(param1:Boolean) : void
      {
         this.assetProxy.visible = param1;
         invalidateLayout();
      }
      
      public function getWidth() : Number
      {
         return this.assetProxy.width;
      }
      
      public function setWidth(param1:Number) : void
      {
         this.assetProxy.width = param1;
      }
      
      public function getX() : Number
      {
         return this.assetProxy.x;
      }
      
      public function setX(param1:Number) : void
      {
         this.assetProxy.x = param1;
      }
      
      public function getY() : Number
      {
         return this.assetProxy.y;
      }
      
      public function setY(param1:Number) : void
      {
         this.assetProxy.y = param1;
      }
      
      public function getZ() : Number
      {
         return this.assetProxy.z;
      }
      
      public function setZ(param1:Number) : void
      {
         this.assetProxy.z = param1;
      }
      
      public function getBounds(param1:DisplayObject = null) : Rectangle
      {
         if(this._asset == null)
         {
            return new Rectangle();
         }
         return this._asset.getBounds(param1);
      }
      
      public function getRect(param1:DisplayObject) : Rectangle
      {
         if(this._asset == null)
         {
            return new Rectangle();
         }
         return this._asset.getRect(param1);
      }
      
      public function globalToLocal(param1:Point) : Point
      {
         if(this._asset == null)
         {
            return new Point();
         }
         return this._asset.globalToLocal(param1);
      }
      
      public function globalToLocal3D(param1:Point) : Vector3D
      {
         if(this._asset == null)
         {
            return new Vector3D();
         }
         return this._asset.globalToLocal3D(param1);
      }
      
      public function hitTestObject(param1:DisplayObject) : Boolean
      {
         if(this._asset == null)
         {
            return false;
         }
         return this._asset.hitTestObject(param1);
      }
      
      public function hitTestPoint(param1:Number, param2:Number, param3:Boolean = false) : Boolean
      {
         if(this._asset == null)
         {
            return false;
         }
         return this._asset.hitTestPoint(param1,param2,param3);
      }
      
      public function local3DToGlobal(param1:Vector3D) : Point
      {
         if(this._asset == null)
         {
            return new Point();
         }
         return this._asset.local3DToGlobal(param1);
      }
      
      public function localToGlobal(param1:Point) : Point
      {
         if(this._asset == null)
         {
            return new Point();
         }
         return this._asset.localToGlobal(param1);
      }
      
      override public function getTransformMatrix() : Matrix
      {
         if(this._asset == null || this._asset.transform.matrix == null)
         {
            return new Matrix();
         }
         return this._asset.transform.matrix;
      }
      
      override public function setTransformMatrix(param1:Matrix) : void
      {
         if(this._asset != null)
         {
            this._asset.transform.matrix = param1;
            clearScaledBoundsCache();
         }
      }
      
      override public function getTransformMatrix3d() : Matrix3D
      {
         if(this._asset == null || this._asset.transform.matrix3D == null)
         {
            return new Matrix3D();
         }
         return this._asset.transform.matrix3D;
      }
      
      override public function setTransformMatrix3d(param1:Matrix3D) : void
      {
         if(this._asset != null)
         {
            this._asset.transform.matrix3D = param1;
            clearScaledBoundsCache();
         }
      }
      
      override public function validate() : void
      {
         this._stage = this.getStage();
         this._isOnStage = this._stage != null;
         super.validate();
      }
      
      public function getParentDisplayContainer() : IDisplayContainer
      {
         return this._parentDisplayContainer;
      }
      
      public function setParentDisplayContainer(param1:IDisplayContainer) : void
      {
         if(this._parentDisplayContainer == param1)
         {
            return;
         }
         this._parentDisplayContainer = param1;
      }
      
      public function getIsTimelineChild() : Boolean
      {
         return this._isTimelineChild;
      }
      
      public function setIsTimelineChild(param1:Boolean) : void
      {
         this._isTimelineChild = param1;
         if(this._linkage != null && !param1)
         {
            this.refreshLinkageAsset();
         }
      }
      
      public function getWeightChanged() : ISignal
      {
         return this._weightChanged;
      }
      
      public function getWeight() : Number
      {
         return this._weight;
      }
      
      public function setWeight(param1:Number) : void
      {
         if(this._weight == param1)
         {
            return;
         }
         var _loc2_:Number = this._weight;
         this._weight = param1;
         this._weightChanged.dispatch(this,_loc2_,this._weight);
      }
      
      override protected function validateAvailableSize() : void
      {
         if(this._asset == null || !this.validateOffStage && this._asset.stage == null)
         {
            availableSizeIsValidFlag = true;
            return;
         }
         super.validateAvailableSize();
      }
      
      override protected function validateLayout() : void
      {
         if(this._asset == null || !this.validateOffStage && this._asset.stage == null)
         {
            layoutIsValidFlag = true;
            if(!_unscaledBounds.isEmpty())
            {
               _unscaledBounds = new Rectangle();
               _scaledBoundsCache = _unscaledBounds;
            }
            return;
         }
         super.validateLayout();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         return this._asset.getBounds(null);
      }
      
      override protected function validatePosition() : void
      {
         if(this._asset == null || !this.validateOffStage && this._asset.stage == null)
         {
            positionIsValidFlag = true;
            return;
         }
         super.validatePosition();
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this.dispatcherProxy.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this.dispatcherProxy.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this.dispatcherProxy.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this.dispatcherProxy.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this.dispatcherProxy.willTrigger(param1);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._mask != null)
         {
            this._mask.getAssetChanged().remove(this.maskChangeHandler);
         }
         this.assetProxy.destroy();
         this.dispatcherProxy.destroy();
         if(this.assetsManager != null)
         {
            this.assetsManager.getAssetsChanged().remove(this.refreshLinkageAsset);
         }
         this.pendingCalls.length = 0;
         this._parentDisplayContainer = null;
         if(Boolean(this._asset))
         {
            this.unconfigureAsset(this._asset);
            this._asset = null;
         }
         this._assetClass = null;
         this._isOnStageChanged.removeAll();
         this._assetChanged.removeAll();
         this._weightChanged.removeAll();
      }
   }
}

