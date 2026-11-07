package com.riotgames.pvpnet.system.dataload.actions
{
   import blix.action.BasicAction;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.system.config.LoginConfig;
   import com.riotgames.pvpnet.system.dataload.InitialClientData;
   
   public class InitializeCelebration extends BasicAction
   {
      
      private var _initialClientData:InitialClientData;
      
      public function InitializeCelebration(param1:InitialClientData)
      {
         super(false);
         this._initialClientData = param1;
      }
      
      override protected function doInvocation() : void
      {
         LoginConfig.instance.celebrationMessages = this._initialClientData.loginDataPacket.simpleMessages;
         ProviderLookup.instance.requestProvider("com.riotgames.pvpnet.celebration::ICelebrationProvider");
         complete();
      }
   }
}

