package blix.components.loader
{
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import blix.layout.vo.MinMax;
   import blix.layout.vo.SizeConstraints;
   import blix.signals.ISignal;
   import blix.view.behaviors.ScalingTransformBehavior;
   import flash.display.Bitmap;
   import flash.display.LoaderInfo;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   
   public class ImageX extends SpriteProxy
   {
      
      public var allowSmoothing:Boolean = true;
      
      public var pixelSnapping:String = "auto";
      
      protected var loader:LoaderX;
      
      protected var _scalingTransformBehavior:ScalingTransformBehavior;
      
      public function ImageX(param1:IContext, param2:Sprite = null)
      {
         super(param1,param2 || new Sprite());
         this.setMaintainAspectRatio(true);
      }
      
      public function getProgress() : ISignal
      {
         return this.loader.getProgress();
      }
      
      public function getCompleted() : ISignal
      {
         return this.loader.getCompleted();
      }
      
      public function getErred() : ISignal
      {
         return this.loader.getErred();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._scalingTransformBehavior = new ScalingTransformBehavior();
         this._scalingTransformBehavior.setMaintainAspectRatio(true);
         this._scalingTransformBehavior.setScalePercentConstraints(new SizeConstraints(new MinMax(0,1),new MinMax(0,1)));
         setTransformBehavior(this._scalingTransformBehavior);
         this.loader = new LoaderX(this);
         this.loader.loaderAction.loader.contentLoaderInfo.addEventListener(Event.INIT,this.contentInitHandler);
         this.loader.getLayoutInvalidated().add(invalidateLayout);
         addChild(this.loader);
      }
      
      public function getScalingTransformBehavior() : ScalingTransformBehavior
      {
         return this._scalingTransformBehavior;
      }
      
      public function setScalingTransformBehavior(param1:ScalingTransformBehavior) : void
      {
         this._scalingTransformBehavior = param1;
      }
      
      public function getMaintainAspectRatio() : Boolean
      {
         return this._scalingTransformBehavior.getMaintainAspectRatio();
      }
      
      public function setMaintainAspectRatio(param1:Boolean) : void
      {
         this._scalingTransformBehavior.setMaintainAspectRatio(param1);
      }
      
      public function getHorizontalAlign() : uint
      {
         return this._scalingTransformBehavior.getHorizontalAlign();
      }
      
      public function setHorizontalAlign(param1:uint) : void
      {
         this._scalingTransformBehavior.setHorizontalAlign(param1);
      }
      
      public function getVerticalAlign() : uint
      {
         return this._scalingTransformBehavior.getVerticalAlign();
      }
      
      public function setVerticalAlign(param1:uint) : void
      {
         this._scalingTransformBehavior.setVerticalAlign(param1);
      }
      
      public function getPercentLoaded() : Number
      {
         return this.loader.getPercentLoaded();
      }
      
      public function getIsFinished() : Boolean
      {
         return this.loader.getIsFinished();
      }
      
      public function getLoader() : LoaderX
      {
         return this.loader;
      }
      
      public function unload() : void
      {
         this.loader.unload();
      }
      
      public function unloadAndStop(param1:Boolean = true) : void
      {
         this.loader.unloadAndStop(param1);
      }
      
      public function load(param1:URLRequest, param2:LoaderContext = null) : void
      {
         if(param2 == null)
         {
            param2 = new LoaderContext();
            param2.applicationDomain = new ApplicationDomain(null);
            param2.checkPolicyFile = true;
         }
         this.loader.load(param1,param2);
      }
      
      public function loadBytes(param1:ByteArray, param2:LoaderContext = null) : void
      {
         this.loader.loadBytes(param1,param2);
      }
      
      protected function contentInitHandler(param1:Event) : void
      {
         var _loc3_:Bitmap = null;
         var _loc2_:LoaderInfo = param1.currentTarget as LoaderInfo;
         try
         {
            _loc3_ = _loc2_.loader.content as Bitmap;
         }
         catch(error:Error)
         {
         }
         if(_loc3_ != null)
         {
            _loc3_.smoothing = this.allowSmoothing;
            _loc3_.pixelSnapping = this.pixelSnapping;
         }
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         if(!this.loader.loaderAction.getHasInitialized())
         {
            return new Rectangle();
         }
         return new Rectangle(0,0,this.loader.loaderAction.loader.width,this.loader.loaderAction.loader.height);
      }
   }
}

