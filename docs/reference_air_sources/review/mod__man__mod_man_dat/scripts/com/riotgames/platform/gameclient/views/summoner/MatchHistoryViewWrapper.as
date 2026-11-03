package com.riotgames.platform.gameclient.views.summoner
{
   import blix.assets.proxy.DisplayAdapter;
   import com.riotgames.platform.gameclient.controllers.summoner.SummonerProfileController;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.matchhistoryiron.IMatchHistoryIronProvider;
   import flash.events.Event;
   import mx.core.UIComponent;
   
   public class MatchHistoryViewWrapper extends UIComponent
   {
      
      private var showing:Boolean = false;
      
      private var shown:Boolean = false;
      
      public var summonerProfileController:SummonerProfileController;
      
      private var screenProvider:IMatchHistoryIronProvider;
      
      public function MatchHistoryViewWrapper()
      {
         super();
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      public function closeMatchHistoryRoot() : void
      {
         if(this.screenProvider != null)
         {
            this.screenProvider.hide();
         }
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
      }
      
      private function gotMatchHistoryProvider(param1:IMatchHistoryIronProvider) : void
      {
         this.screenProvider = param1;
      }
      
      public function showMatchHistoryRoot() : void
      {
         if(this.screenProvider != null)
         {
            this.screenProvider.show(this.summonerProfileController.baseSummoner.acctId,new DisplayAdapter(this));
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         ProviderLookup.getProvider(IMatchHistoryIronProvider,this.gotMatchHistoryProvider);
      }
   }
}

