package com.riotgames.platform.gameclient.views.summoner
{
   import blix.assets.proxy.DisplayAdapter;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.provider.ICLSProvider;
   import com.riotgames.platform.gameclient.controllers.summoner.SummonerProfileController;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamId;
   import com.riotgames.platform.gameclient.views.summoner.stats.LeagueSystemStatsView;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.rankedteams.IRankedTeamsProvider;
   import flash.events.Event;
   import mx.core.UIComponent;
   
   public class LeagueSystemShell extends UIComponent
   {
      
      public static const THREES_TEAM_QUEUE:String = "RANKED_TEAM_3x3";
      
      public static const FIVES_TEAM_QUEUE:String = "RANKED_TEAM_5x5";
      
      private var rankedTeamsProvider:IRankedTeamsProvider;
      
      public var leagueSystemStatsView:LeagueSystemStatsView;
      
      private var leagueSystemProvider:ICLSProvider;
      
      public var masterGameController:MasterGameController;
      
      public var lobbyController:ILobbyViewController;
      
      public var summonerProfileController:SummonerProfileController;
      
      private var leagueDisplayAdapter:DisplayAdapter;
      
      public function LeagueSystemShell()
      {
         super();
         this.leagueDisplayAdapter = new DisplayAdapter(this);
         ProviderLookup.getProvider(ICLSProvider,this.onLeagueSystemRetrieved);
         ProviderLookup.getProvider(IRankedTeamsProvider,this.onRankedTeamsRetrieved);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onSearchError(param1:ServerError) : void
      {
      }
      
      public function hide() : void
      {
         this.leagueSystemProvider.hide(this.leagueDisplayAdapter);
         this.leagueSystemStatsView.hideAllStats();
         this.summonerProfileController.summonerName = this.summonerProfileController.baseSummoner.name;
      }
      
      private function onNavigateToProfileClick(param1:String, param2:String, param3:Boolean) : void
      {
         var _loc4_:TeamId = null;
         if(!param3)
         {
            this.lobbyController.searchForSummoner(param1,this.onSearchError);
         }
         else
         {
            _loc4_ = new TeamId();
            _loc4_.fullId = param2;
            this.rankedTeamsProvider.gotoTeamProfile(_loc4_,true);
         }
      }
      
      private function onLeagueSystemRetrieved(param1:ICLSProvider) : void
      {
         this.leagueSystemProvider = param1;
         this.leagueSystemProvider.statsSignal.add(this.onSeeMoreStatsClick);
         this.leagueSystemProvider.lobbySignal.add(this.onNavigateToProfileClick);
      }
      
      private function onRankedTeamsRetrieved(param1:IRankedTeamsProvider) : void
      {
         this.rankedTeamsProvider = param1;
      }
      
      private function onSeeMoreStatsClick(param1:String, param2:String, param3:String) : void
      {
         var _loc5_:TeamId = null;
         this.visible = false;
         this.summonerProfileController.closeLeagueStats.add(this.closeStatsView);
         this.leagueSystemStatsView.closeTeamStats.add(this.closeStatsView);
         var _loc4_:Boolean = param3 != THREES_TEAM_QUEUE && param3 != FIVES_TEAM_QUEUE;
         if(_loc4_)
         {
            this.leagueSystemStatsView.showPlayerStats();
            this.summonerProfileController.summonerName = param1;
         }
         else
         {
            _loc5_ = new TeamId();
            _loc5_.fullId = param2;
            this.leagueSystemStatsView.showTeamStats(_loc5_);
         }
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         this.hide();
      }
      
      private function closeStatsView() : void
      {
         this.leagueSystemStatsView.hideAllStats();
         this.visible = true;
         this.summonerProfileController.summonerName = this.summonerProfileController.baseSummoner.name;
      }
      
      public function show() : void
      {
         this.leagueSystemStatsView.hideAllStats();
         this.leagueSystemProvider.show(this.leagueDisplayAdapter);
         this.visible = true;
         this.summonerProfileController.summonerName = this.summonerProfileController.baseSummoner.name;
      }
   }
}

