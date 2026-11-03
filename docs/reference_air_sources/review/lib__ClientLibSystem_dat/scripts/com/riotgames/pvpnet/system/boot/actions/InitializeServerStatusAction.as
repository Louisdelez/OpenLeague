package com.riotgames.pvpnet.system.boot.actions
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.RiotServiceConfig;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.system.notification.IServerStatusProvider;
   import com.riotgames.pvpnet.system.notification.ServerStatusController;
   
   public class InitializeServerStatusAction extends BasicAction
   {
      
      public function InitializeServerStatusAction()
      {
         super(false);
      }
      
      override protected function doInvocation() : void
      {
         var _loc1_:ServerStatusController = new ServerStatusController();
         _loc1_.initiateServerStatusMonitoring(RiotServiceConfig.instance.status_url,RiotServiceConfig.instance.rawHost.value);
         ProviderLookup.publishProvider(IServerStatusProvider,_loc1_);
         complete();
      }
   }
}

