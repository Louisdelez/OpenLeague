package com.riotgames.pvpnet.system.dataload.actions
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.gameclient.domain.inventory.ActiveBoosts;
   import com.riotgames.pvpnet.system.dataload.InitialClientData;
   import mx.rpc.events.ResultEvent;
   
   public class LoadSummonerActiveBoostsAction extends BasicAction
   {
      
      private var _initialClientData:InitialClientData;
      
      public function LoadSummonerActiveBoostsAction(param1:InitialClientData)
      {
         super(false);
         this._initialClientData = param1;
      }
      
      override protected function doInvocation() : void
      {
         if(this._initialClientData.loginDataPacket.allSummonerData != null && this._initialClientData.loginDataPacket.allSummonerData.summoner != null)
         {
            ServiceProxy.instance.inventoryService.getSumonerActiveBoosts(this.handleSummonerActiveBoosts,null);
         }
         else
         {
            complete();
         }
      }
      
      private function handleSummonerActiveBoosts(param1:ResultEvent) : void
      {
         this._initialClientData.activeBoosts = param1.result as ActiveBoosts;
         complete();
      }
   }
}

