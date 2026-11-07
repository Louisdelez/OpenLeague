package com.riotgames.pvpnet.system.boot.actions
{
   import blix.action.BasicAction;
   import com.riotgames.platform.gameclient.config.ModuleEntry;
   import com.riotgames.platform.gameclient.config.ProvidersLoader;
   import com.riotgames.platform.provider.IProviderLookup;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import flash.filesystem.File;
   
   public class InitializeProviderLayerAction extends BasicAction
   {
      
      private var _providersLoader:ProvidersLoader;
      
      private var _providerLookup:IProviderLookup;
      
      public function InitializeProviderLayerAction(param1:IProviderLookup, param2:ProvidersLoader)
      {
         super(false);
         this._providerLookup = param1;
         this._providersLoader = param2;
      }
      
      override protected function doInvocation() : void
      {
         var modulesFilter:Function;
         var clientConfigServicesMode:uint = 0;
         ProviderLookup.registerImpl(this._providerLookup);
         clientConfigServicesMode = ClientConfig.instance.servicesMode;
         modulesFilter = function(param1:ModuleEntry):Boolean
         {
            var _loc2_:uint = param1.extraData == null ? 0 : uint(param1.extraData["servicesMode"]);
            return _loc2_ == 0 || (_loc2_ & clientConfigServicesMode) > 0;
         };
         this._providersLoader.loadProviders(File.applicationDirectory.resolvePath("mod"),modulesFilter,this.completedHandler,this.erredHandler);
      }
      
      private function completedHandler() : void
      {
         complete();
      }
      
      private function erredHandler(param1:*) : void
      {
         var _loc2_:Error = null;
         if(param1 is Error)
         {
            err(param1);
         }
         else
         {
            _loc2_ = new Error("InitializeProviderLayerAction failed");
            err(_loc2_);
         }
      }
      
      override public function destroy() : void
      {
         this._providersLoader = null;
      }
   }
}

