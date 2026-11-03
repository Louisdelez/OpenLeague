package com.riotgames.rust.module
{
   import blix.action.IAction;
   import blix.assets.IAssetsLoader;
   import blix.assets.IAssetsManager;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.decorator.DecoratorManager;
   import blix.decorator.IDecoratorManager;
   import com.riotgames.rust.asset.RustAssetLoader;
   import com.riotgames.rust.decorator.FontMapDecorator;
   import com.riotgames.rust.decorator.LocaleDecorator;
   import com.riotgames.rust.theme.ThemeConfig;
   import com.riotgames.util.logging.getLogger;
   import flash.display.MovieClip;
   import flash.net.URLRequest;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   
   public class RiotModuleView extends StatefulView
   {
      
      protected var logger:ILogger = getLogger(this);
      
      protected var assetsLoader:RustAssetLoader;
      
      private var checkAssetsTimeoutId:uint;
      
      public function RiotModuleView(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         _decoratorManager.addDecorator(new FontMapDecorator());
      }
      
      override protected function initializeDependencies() : void
      {
         this.assetsLoader = new RustAssetLoader();
         registerDependency(IAssetsLoader,this.assetsLoader);
         registerDependency(IAssetsManager,this.assetsLoader);
         _decoratorManager = new DecoratorManager();
         registerDependency(IDecoratorManager,_decoratorManager);
      }
      
      protected function enableAutoLocalization(param1:String) : void
      {
         _decoratorManager.addDecorator(new LocaleDecorator(param1));
      }
      
      protected function unloadAssets(param1:URLRequest) : void
      {
         if(param1 == null)
         {
            this.logger.warn("Error: Attempting to unload null assets.");
            return;
         }
         this.assetsLoader.unloadAssets(param1);
      }
      
      protected function loadAssets(param1:URLRequest) : void
      {
         if(param1 == null)
         {
            this.logger.warn("Error: Attempting to load null assets.");
            return;
         }
         var _loc2_:IAction = this.assetsLoader.loadAssets(param1);
         _loc2_.getErred().add(this.assetsErredHandler);
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
      
      public function getThemeAssetUrl(param1:String, param2:String) : URLRequest
      {
         return ThemeConfig.instance.getThemeAssetUrl(param1,param2);
      }
      
      public function setLinkagePostfix(param1:String) : void
      {
         this.assetsLoader.setAssetLinkagePostfix(param1);
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
   }
}

