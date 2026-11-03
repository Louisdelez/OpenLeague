package com.riotgames.platform.gameclient.init
{
   import blix.action.BasicAction;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.localconnectiontool.ILocalConnectionToolProvider;
   
   public class InitializeLocalConnectionTool extends BasicAction
   {
      
      public function InitializeLocalConnectionTool()
      {
         super(false);
      }
      
      override protected function doInvocation() : void
      {
         ProviderLookup.getProvider(ILocalConnectionToolProvider,this.onLocalConnectionToolLoaded,this.erredHandler);
         complete();
      }
      
      private function erredHandler(param1:Error) : void
      {
         err(param1);
      }
      
      private function onLocalConnectionToolLoaded(param1:ILocalConnectionToolProvider) : void
      {
      }
   }
}

