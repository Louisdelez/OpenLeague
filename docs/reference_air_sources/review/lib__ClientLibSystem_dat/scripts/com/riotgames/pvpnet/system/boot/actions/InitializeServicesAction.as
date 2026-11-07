package com.riotgames.pvpnet.system.boot.actions
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.provider.IServicesProvider;
   import com.riotgames.platform.provider.ProviderLookup;
   
   public class InitializeServicesAction extends BasicAction
   {
      
      public function InitializeServicesAction()
      {
         super(false);
      }
      
      override protected function doInvocation() : void
      {
         ProviderLookup.getProvider(IServicesProvider,this.onServicesModuleLoaded,this.erredHandler);
      }
      
      private function onServicesModuleLoaded(param1:IServicesProvider) : void
      {
         complete();
      }
      
      private function erredHandler(param1:Error) : void
      {
         err(param1);
      }
   }
}

