package com.riotgames.pvpnet.CLS.views
{
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.module.RiotModuleInfo;
   import com.riotgames.pvpnet.CLS.dataprovider.ILeagueDataProviderLocal;
   import com.riotgames.pvpnet.CLS.managers.ILeagueSystemModuleNavigation;
   import com.riotgames.pvpnet.rankedteams.IRankedTeamsProvider;
   import com.riotgames.pvpnet.rankedteams.RankedTeamEvent;
   import com.riotgames.rust.components.sidebar.INestedScreen;
   import com.riotgames.rust.module.RiotModuleView;
   import flash.display.MovieClip;
   import flash.net.URLRequest;
   
   public class LeagueSystemModuleView extends RiotModuleView implements INestedScreen
   {
      
      private var _hideCompleted:Signal = new Signal();
      
      private var _moduleInfo:RiotModuleInfo;
      
      private var _leagueDataProvider:ILeagueDataProviderLocal;
      
      private var _rankedTeamsProvider:IRankedTeamsProvider;
      
      private var _leagueSystemModuleNavigation:ILeagueSystemModuleNavigation;
      
      private var _assetsUrlRequest:URLRequest;
      
      private var _assets:String = "assets/leagueSystemParchmentAssets.swf";
      
      private var _ceremonyAssetsLoaded:Boolean = false;
      
      private var _ceremonyAssetsUrlRequest:URLRequest;
      
      private var _ceremonyAssets:String = "assets/leagueSystemCeremony.swf";
      
      private var _landingView:LeagueSystemOverviewView;
      
      private var _mainView:LeagueSystemMainView;
      
      public function LeagueSystemModuleView(param1:IContext, param2:RiotModuleInfo)
      {
         super(param1,new MovieClip());
         this._moduleInfo = param2;
         enableAutoLocalization("LeagueSystemIron");
         this.isParchment = false;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._landingView = new LeagueSystemOverviewView(this);
         this._landingView.setVisible(false);
         addChild(this._landingView);
         this._mainView = new LeagueSystemMainView(this);
         this._mainView.setVisible(false);
         addChild(this._mainView);
         this._leagueDataProvider = getDependency(ILeagueDataProviderLocal);
         this._rankedTeamsProvider = getDependency(IRankedTeamsProvider);
         this._leagueSystemModuleNavigation = getDependency(ILeagueSystemModuleNavigation);
         this._leagueSystemModuleNavigation.getOnLeagueNavigateHome().add(this.onLeagueNavigationHome);
         this._leagueSystemModuleNavigation.getOnLeagueSelectionUpdateSignal().add(this.onLeagueSelectionUpdate);
         this._leagueSystemModuleNavigation.getOnChallengerTierSelectionUpdateSignal().add(this.onLeagueSelectionUpdate);
         this._rankedTeamsProvider.addListener(RankedTeamEvent.UPDATE_PLAYER,this.onRankedTeamsChanged);
      }
      
      public function show() : void
      {
         if(this._assetsUrlRequest == null)
         {
            this._assetsUrlRequest = new URLRequest(this._moduleInfo.getPath() + this._assets);
            loadAssets(this._assetsUrlRequest);
         }
         this._leagueSystemModuleNavigation.dispatchOnLeagueNavigateHome();
      }
      
      public function loadCeremonyAssets() : void
      {
         if(this._ceremonyAssetsLoaded)
         {
            return;
         }
         this._ceremonyAssetsUrlRequest = new URLRequest(this._moduleInfo.getPath() + this._ceremonyAssets);
         loadAssets(this._ceremonyAssetsUrlRequest);
         this._ceremonyAssetsLoaded = true;
      }
      
      public function getHideCompleted() : ISignal
      {
         return this._hideCompleted;
      }
      
      public function hide() : void
      {
         this._hideCompleted.dispatch();
      }
      
      public function set isParchment(param1:Boolean) : void
      {
         if(param1)
         {
            this._assets = "assets/leagueSystemParchmentAssets.swf";
         }
      }
      
      private function onLeagueNavigationHome() : void
      {
         if(this._leagueSystemModuleNavigation.getLeagueOverviewEnabled() && this._leagueDataProvider.self && this._rankedTeamsProvider.getRankedTeams().length > 0)
         {
            this._leagueSystemModuleNavigation.dispatchOnLeagueSelectionSignal(uint.MAX_VALUE);
            this._mainView.setVisible(false);
            this._landingView.setVisible(true);
         }
         else
         {
            this._leagueSystemModuleNavigation.dispatchOnLeagueSelectionSignal(0);
         }
      }
      
      private function onRankedTeamsChanged(param1:RankedTeamEvent) : void
      {
      }
      
      private function onLeagueSelectionUpdate(param1:*) : void
      {
         this._landingView.setVisible(false);
         this._mainView.setVisible(true);
      }
   }
}

