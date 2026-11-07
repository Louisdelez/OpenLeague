package com.riotgames.pvpnet.system.dataload.actions
{
   import blix.action.BasicAction;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   
   public class InitializeItemSets extends BasicAction
   {
      
      public function InitializeItemSets()
      {
         super(false);
      }
      
      override protected function doInvocation() : void
      {
         if(ClientConfig.instance.showItemSets)
         {
            ProviderLookup.instance.requestProvider("com.riotgames.pvpnet.itembrowser::IItemBrowserProvider");
         }
         complete();
      }
   }
}

