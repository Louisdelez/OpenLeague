package blix.context
{
   import blix.action.IAction;
   import blix.assets.AssetsLoader;
   import blix.assets.IAssetsLoader;
   import blix.assets.IAssetsManager;
   import blix.assets.proxy.SpriteProxy;
   import blix.decorator.DecoratorManager;
   import blix.decorator.IDecorator;
   import blix.decorator.IDecoratorManager;
   import blix.frame.getFrameDispatcher;
   import blix.i18n.ILocalizationManager;
   import blix.i18n.LocalizationManager;
   import blix.logger.ArrayTarget;
   import blix.logger.ILoggingManager;
   import blix.logger.LoggingManager;
   import blix.logger.TraceTarget;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Stage;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   
   public class ApplicationContext extends SpriteProxy implements IApplicationContext
   {
      
      private var _root:DisplayObjectContainer;
      
      private var _width:Number;
      
      private var _height:Number;
      
      protected var arrayTarget:ArrayTarget;
      
      protected var _rootStage:Stage;
      
      protected var _assetsLoader:IAssetsLoader;
      
      protected var _localizationManager:ILocalizationManager;
      
      public function ApplicationContext(param1:Object)
      {
         this.configure(param1);
         super(null,null);
         setAsset(this._root);
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         var _loc1_:IAssetsLoader = new AssetsLoader();
         registerDependency(IAssetsLoader,_loc1_);
         registerDependency(IAssetsManager,_loc1_);
         registerDependency(ILoggingManager,new LoggingManager());
         registerDependency(ILocalizationManager,new LocalizationManager());
         registerDependency(IDecoratorManager,new DecoratorManager());
      }
      
      protected function configure(param1:Object) : void
      {
         this._root = param1.root;
         this._width = param1.width;
         this._height = param1.height;
         if(this._root.stage != null)
         {
            this.configureStage(this._root.stage);
         }
         else
         {
            this._root.addEventListener(Event.ADDED_TO_STAGE,this.rootAddedToStageHandler);
         }
      }
      
      private function rootAddedToStageHandler(param1:Event) : void
      {
         this._root.removeEventListener(Event.ADDED_TO_STAGE,this.rootAddedToStageHandler);
         this.configureStage(this._root.stage);
      }
      
      override protected function initialize() : void
      {
         this._assetsLoader = getDependency(IAssetsLoader);
         this._localizationManager = getDependency(ILocalizationManager);
         _decoratorManager = getDependency(IDecoratorManager);
         var _loc1_:ILoggingManager = getDependency(ILoggingManager);
         if(_loc1_ != null)
         {
            this.initializeLogging(_loc1_);
         }
         super.initialize();
      }
      
      protected function initializeLogging(param1:ILoggingManager) : void
      {
         this.arrayTarget = new ArrayTarget(param1);
         new TraceTarget(param1);
      }
      
      protected function configureStage(param1:Stage) : void
      {
         this._rootStage = param1;
         param1.align = StageAlign.TOP_LEFT;
         param1.scaleMode = StageScaleMode.NO_SCALE;
         var _loc2_:DisplayObject = getFrameDispatcher();
         if(_loc2_.parent == null)
         {
            param1.addChild(_loc2_);
         }
      }
      
      override public function getStage() : Stage
      {
         return this._rootStage;
      }
      
      public function getRoot() : DisplayObject
      {
         return this._root;
      }
      
      public function getSharedEvents() : IEventDispatcher
      {
         return this._root.loaderInfo.sharedEvents;
      }
      
      public function getAppWidth() : Number
      {
         return this._width;
      }
      
      public function getAppHeight() : Number
      {
         return this._height;
      }
      
      public function getArrayLogTarget() : ArrayTarget
      {
         return this.arrayTarget;
      }
      
      public function getBytesLoaded() : uint
      {
         return this._assetsLoader.getBytesLoaded();
      }
      
      public function getBytesTotal() : uint
      {
         return this._assetsLoader.getBytesTotal();
      }
      
      public function getPercentLoaded() : Number
      {
         var _loc1_:uint = this.getBytesTotal();
         var _loc2_:uint = this.getBytesLoaded();
         if(_loc2_ >= _loc1_)
         {
            return 1;
         }
         return _loc2_ / _loc1_;
      }
      
      public function unloadAssets(param1:URLRequest) : void
      {
         this._assetsLoader.unloadAssets(param1);
      }
      
      public function loadAssets(param1:URLRequest, param2:LoaderContext = null) : IAction
      {
         return this._assetsLoader.loadAssets(param1,param2);
      }
      
      public function addDecorator(param1:IDecorator) : void
      {
         _decoratorManager.addDecorator(param1);
      }
   }
}

