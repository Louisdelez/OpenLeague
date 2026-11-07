package com.riotgames.pvpnet.system.dataload.actions
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.system.config.PlatformConfigProviderProxy;
   import com.riotgames.pvpnet.system.dataload.InitialClientData;
   
   public class AddMessageListenersAction extends BasicAction
   {
      
      private var _initialClientData:InitialClientData;
      
      public function AddMessageListenersAction(param1:InitialClientData)
      {
         super(false);
         this._initialClientData = param1;
      }
      
      override protected function doInvocation() : void
      {
         PlatformConfigProviderProxy.instance.initializePlatformConfigMonitoring();
         complete();
      }
   }
}

