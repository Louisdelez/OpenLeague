package com.riotgames.pvpnet.system.dataload.actions
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.provider.IInventoryProvider;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.system.dataload.InitialClientData;
   
   public class InitializeInventoryControllerProviderAction extends BasicAction
   {
      
      private var _initialClientData:InitialClientData;
      
      public function InitializeInventoryControllerProviderAction(param1:InitialClientData)
      {
         super(false);
         this._initialClientData = param1;
      }
      
      override protected function doInvocation() : void
      {
         ProviderLookup.getProvider(IInventoryProvider,this.onInventoryProviderRetrieved);
      }
      
      private function onInventoryProviderRetrieved(param1:IInventoryProvider) : void
      {
         this._initialClientData.inventoryController = param1.getInventoryController();
         complete();
      }
   }
}

