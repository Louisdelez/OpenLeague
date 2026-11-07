package com.riotgames.rust.module
{
   import blix.action.IAction;
   import blix.assets.AssetsLoader;
   import blix.assets.IAssetsLoader;
   import blix.assets.IAssetsManager;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.loader.BatchLoaderAction;
   import blix.context.Context;
   import blix.context.IContext;
   import blix.decorator.DecoratorManager;
   import blix.decorator.IDecoratorManager;
   import blix.frame.getFrameDispatcher;
   import com.riotgames.rust.decorator.FontMapDecorator;
   import com.riotgames.util.logging.getLogger;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getQualifiedSuperclassName;
   import mx.logging.ILogger;
   
   public class RiotModuleRoot extends Sprite implements IContext
   {
      
      private var _dependencies:Dictionary = new Dictionary(true);
      
      private var rootContext:IContext;
      
      protected var rootView:SpriteProxy;
      
      protected var logger:ILogger = getLogger(this);
      
      protected var assetsLoader:AssetsLoader;
      
      protected var decoratorManager:IDecoratorManager;
      
      private var _className:String;
      
      private var _superClassName:String;
      
      private var checkAssetsTimeoutId:uint;
      
      public function RiotModuleRoot()
      {
         super();
         this.initializeDependencies();
         this.rootContext = new Context(null,this._dependencies);
         this.initializeDecorators();
         this.createChildren();
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
      }
      
      private function addedToStageHandler(param1:Event) : void
      {
         IEventDispatcher(param1.currentTarget).removeEventListener(param1.type,this.addedToStageHandler);
         var _loc2_:DisplayObject = getFrameDispatcher();
         if(_loc2_.parent == null)
         {
            stage.addChild(_loc2_);
         }
      }
      
      protected function createChildren() : void
      {
         if(this.rootView == null)
         {
            this.rootView = new SpriteProxy(this);
            this.rootView.setAsset(this);
         }
      }
      
      protected function initializeDependencies() : void
      {
         this.assetsLoader = new AssetsLoader();
         this.registerDependency(IAssetsLoader,this.assetsLoader);
         this.registerDependency(IAssetsManager,this.assetsLoader);
         this.decoratorManager = new DecoratorManager();
         this.registerDependency(IDecoratorManager,this.decoratorManager);
         this.registerDependency(BatchLoaderAction,new BatchLoaderAction(),false);
      }
      
      protected function registerDependency(param1:Class, param2:Object, param3:Boolean = false) : void
      {
         if(param1 == null)
         {
            throw new Error("The dependency contract may not be null.");
         }
         this._dependencies[param1] = param2;
      }
      
      protected function initializeDecorators() : void
      {
         this.decoratorManager.addDecorator(new FontMapDecorator());
      }
      
      public function getClassName() : String
      {
         if(!this._className)
         {
            this._className = getQualifiedClassName(this);
         }
         return this._className;
      }
      
      public function getSuperClassName() : String
      {
         if(!this._superClassName)
         {
            this._superClassName = getQualifiedSuperclassName(this);
         }
         return this._superClassName;
      }
      
      public function getDependency(param1:Class, param2:Boolean = true) : *
      {
         return this.rootContext.getDependency(param1,param2);
      }
      
      public function getContextAncestry() : Vector.<IContext>
      {
         return this.rootContext.getContextAncestry();
      }
      
      public function getAncestryLength() : uint
      {
         return this.rootContext.getAncestryLength();
      }
      
      public function getRootContext() : IContext
      {
         return this.rootContext.getRootContext();
      }
      
      public function getParentContext() : IContext
      {
         return this.rootContext.getParentContext();
      }
      
      public function getFirstContext(param1:Class) : *
      {
         return this.rootContext.getFirstContext(param1);
      }
      
      public function getLastContext(param1:Class) : *
      {
         return this.rootContext.getLastContext(param1);
      }
      
      public function getChainToString() : String
      {
         return this.rootContext.getChainToString();
      }
      
      protected function unloadAssets(param1:URLRequest) : void
      {
         this.assetsLoader.unloadAssets(param1);
      }
      
      protected function loadAssets(param1:URLRequest) : IAction
      {
         var _loc2_:IAction = this.assetsLoader.loadAssets(param1);
         _loc2_.getErred().add(this.assetsErredHandler);
         return _loc2_;
      }
      
      private function assetsErredHandler(param1:IAction) : void
      {
         this.logger.error("Assets failed to load: " + String(param1.getError()));
      }
      
      public function reloadAssets() : void
      {
         this.logger.info("Reloading all assets for module " + getQualifiedClassName(this) + "...");
         this.assetsLoader.reloadAssets();
      }
   }
}

