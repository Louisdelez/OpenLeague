package com.riotgames.pvpnet.system.boot.actions
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   
   public class InitializeRegionalConfigurations extends BasicAction
   {
      
      public function InitializeRegionalConfigurations()
      {
         super(false);
      }
      
      override protected function doInvocation() : void
      {
         if(ClientConfig.instance.clientMode == null || ClientConfig.instance.clientMode == "")
         {
            if(ClientConfig.instance.locale == "zh_CN")
            {
               ClientConfig.instance.clientMode = ClientConfig.SPECIAL_MODE_TENCENT;
            }
         }
         complete();
      }
   }
}

