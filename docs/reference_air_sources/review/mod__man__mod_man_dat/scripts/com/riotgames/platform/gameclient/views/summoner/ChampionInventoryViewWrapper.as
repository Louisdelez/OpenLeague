package com.riotgames.platform.gameclient.views.summoner
{
   import blix.assets.proxy.DisplayAdapter;
   import com.riotgames.platform.gameclient.controllers.summoner.SummonerProfileController;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.championinventory.IChampionInventoryProvider;
   import mx.core.UIComponent;
   
   public class ChampionInventoryViewWrapper extends UIComponent
   {
      
      public var summonerProfileController:SummonerProfileController;
      
      private var screenProvider:IChampionInventoryProvider;
      
      public function ChampionInventoryViewWrapper()
      {
         super();
      }
      
      public function closeChampionInventoryRoot() : void
      {
         if(this.screenProvider != null)
         {
            this.screenProvider.hide();
         }
      }
      
      private function getChampionInventoryProvider(param1:IChampionInventoryProvider) : void
      {
         this.screenProvider = param1;
      }
      
      public function showChampionInventoryRoot() : void
      {
         if(this.screenProvider != null)
         {
            this.screenProvider.show(this.summonerProfileController.baseSummoner.acctId,new DisplayAdapter(this));
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         ProviderLookup.getProvider(IChampionInventoryProvider,this.getChampionInventoryProvider);
      }
      
      public function resetView() : void
      {
      }
   }
}

