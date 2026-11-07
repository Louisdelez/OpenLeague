package com.riotgames.platform.gameclient.init
{
   import blix.action.BasicAction;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.tips.ITipsProvider;
   
   public class InitializeTipsAction extends BasicAction
   {
      
      public function InitializeTipsAction()
      {
         super(false);
      }
      
      private function onTipsModuleLoaded(param1:ITipsProvider) : void
      {
         complete();
      }
      
      override protected function doInvocation() : void
      {
         ProviderLookup.getProvider(ITipsProvider,this.onTipsModuleLoaded,this.erredHandler);
      }
      
      private function erredHandler(param1:Error) : void
      {
         err(param1);
      }
   }
}

