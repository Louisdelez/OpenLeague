package com.riotgames.pvpnet.CLS.views.rankingview
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.tooltip.IToolTipManager;
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Team;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.CLS.localeHelper.ILocaleHelper;
   import com.riotgames.pvpnet.CLS.managers.ILeagueSystemModuleNavigation;
   import com.riotgames.pvpnet.CLS.models.ListItemObjectModel;
   import com.riotgames.pvpnet.CLS.models.RankListViewModel;
   import com.riotgames.pvpnet.CLS.models.SummonerLeagueObjectModel;
   import com.riotgames.pvpnet.CLS.views.enums.QueueTypesEnum;
   import com.riotgames.pvpnet.CLS.views.rankingview.listrenderers.MyLeaguesItemRenderer;
   import com.riotgames.pvpnet.component.AudioButton;
   import com.riotgames.pvpnet.rankedteams.IRankedTeamsProvider;
   import com.riotgames.pvpnet.rankedteams.RankedTeamEvent;
   import com.riotgames.pvpnet.system.leagues.LeagueRank;
   import com.riotgames.pvpnet.system.leagues.LeagueTier;
   import com.riotgames.pvpnet.tips.TipsProviderProxy;
   import com.riotgames.pvpnet.tips.config.RectPosition;
   import com.riotgames.pvpnet.tips.config.ToolTipConfig;
   import com.riotgames.rust.components.list.List;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class MyLeaguesOverview extends SpriteProxy
   {
      
      private var myLeaguesList:List;
      
      private var viewChallengerTierButton:AudioButton;
      
      private var _localeHelper:ILocaleHelper;
      
      private var _leagueSystemModuleNavigation:ILeagueSystemModuleNavigation;
      
      private var _rankedTeamsProvider:IRankedTeamsProvider;
      
      private var _localRankedLeagueDict:Dictionary = new Dictionary();
      
      private var _localRankedLeagueList:Array = new Array();
      
      private var _localProvisionalLeagueList:Array = new Array();
      
      public function MyLeaguesOverview(param1:IContext)
      {
         super(param1);
         setLinkage("MyLeaguesOverview");
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.setupToolTipManager();
         this._localeHelper = getDependency(ILocaleHelper);
         this.myLeaguesList = new List(this);
         this.myLeaguesList.listView.rendererLinkage = "MyLeaguesItemRenderer";
         this.myLeaguesList.listView.rendererType = MyLeaguesItemRenderer;
         this.myLeaguesList.listView.itemPadding = 0;
         this.myLeaguesList.getLayoutInvalidated().add(invalidate);
         setTimelineChildByName("myLeaguesList",this.myLeaguesList);
         this.viewChallengerTierButton = new AudioButton(this);
         this.viewChallengerTierButton.setVisible(false);
         setTimelineChildByName("viewChallengerTierButton",this.viewChallengerTierButton);
         this._leagueSystemModuleNavigation = getDependency(ILeagueSystemModuleNavigation);
         this._leagueSystemModuleNavigation.getOnReceiveLeagueItemsSignal().add(this.onInitializeLeaguesData);
         this._leagueSystemModuleNavigation.dispatchOnAskLeagueItemsSignal();
         ProviderLookup.getProvider(IRankedTeamsProvider,this.onRankedTeamsAvailable);
      }
      
      private function setupToolTipManager() : void
      {
         var _loc1_:ToolTipConfig = new ToolTipConfig();
         _loc1_.showDelay = 0;
         _loc1_.toolTipPosition = new RectPosition(RectPosition.TOP_RIGHT,RectPosition.BOTTOM_LEFT);
         var _loc2_:IToolTipManager = TipsProviderProxy.instance.createWindowToolTipManager(this,_loc1_);
         registerDependency(IToolTipManager,_loc2_);
      }
      
      private function onInitializeLeaguesData(param1:Vector.<SummonerLeagueObjectModel>) : void
      {
         var _loc2_:Array = this.filterLeagueModels(param1);
         this._localRankedLeagueList = _loc2_;
         this.updateView();
      }
      
      private function onRankedTeamsAvailable(param1:IRankedTeamsProvider) : void
      {
         this._rankedTeamsProvider = param1;
         this._rankedTeamsProvider.addListener(RankedTeamEvent.UPDATE_PLAYER,this.onRankedTeamsChanged);
         this.viewChallengerTierButton.setVisible(true);
         this.viewChallengerTierButton.addEventListener(MouseEvent.CLICK,this.onViewChallengerTierClick);
         this.updateProvisionalLeagueTeams(this._rankedTeamsProvider.getRankedTeams());
      }
      
      private function onRankedTeamsChanged(param1:RankedTeamEvent) : void
      {
         if(Boolean(param1.teamPlayer) && Boolean(param1.teamPlayer.teamsSummary))
         {
            this.updateProvisionalLeagueTeams(param1.teamPlayer.teamsSummary.toArray());
         }
      }
      
      private function onViewChallengerTierClick(param1:MouseEvent) : void
      {
         this._leagueSystemModuleNavigation.dispatchOnLeagueSelectionUpdateSignal(null);
         this._leagueSystemModuleNavigation.dispatchOnChallengerTierSelectionSignal(QueueTypesEnum.QUEUE_TYPE_5V5);
      }
      
      private function updateProvisionalLeagueTeams(param1:Array) : void
      {
         var _loc3_:Team = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in param1.sortOn("name"))
         {
            _loc2_.push(this.convertProvisionalRankedTeamToLeague(_loc3_));
         }
         this._localProvisionalLeagueList = _loc2_;
         this.updateView();
      }
      
      private function convertProvisionalRankedTeamToLeague(param1:Team) : SummonerLeagueObjectModel
      {
         var _loc2_:ListItemObjectModel = new ListItemObjectModel();
         _loc2_.isInactive = false;
         _loc2_.team = param1;
         _loc2_.playerOrTeamId = param1.teamId.fullId;
         _loc2_.teamName = param1.name;
         var _loc3_:RankListViewModel = new RankListViewModel();
         _loc3_.myRank = _loc2_;
         _loc3_.allRankListElements = new <ListItemObjectModel>[_loc2_];
         return new SummonerLeagueObjectModel("",LeagueTier.PROVISIONAL,LeagueRank.DEFAULT,_loc3_);
      }
      
      private function updateView() : void
      {
         var _loc2_:SummonerLeagueObjectModel = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this._localProvisionalLeagueList)
         {
            if(this._localRankedLeagueDict[_loc2_.teamName] == null)
            {
               _loc1_.push(_loc2_);
            }
         }
         this.myLeaguesList.data = this._localRankedLeagueList.concat(_loc1_);
      }
      
      private function filterLeagueModels(param1:Vector.<SummonerLeagueObjectModel>) : Array
      {
         var _loc4_:SummonerLeagueObjectModel = null;
         var _loc5_:int = 0;
         var _loc6_:SummonerLeagueObjectModel = null;
         this._localRankedLeagueDict = new Dictionary();
         var _loc2_:Array = [];
         var _loc3_:Object = {};
         for each(_loc4_ in param1)
         {
            this._localRankedLeagueDict[_loc4_.teamName] = 1;
            if(_loc3_[_loc4_.teamName] !== undefined)
            {
               _loc5_ = int(_loc3_[_loc4_.teamName]);
               _loc6_ = _loc2_[_loc5_];
               if(_loc4_.tier.isBelow(_loc6_.tier))
               {
                  _loc2_[_loc5_] = _loc6_;
               }
               else if(_loc4_.tier == _loc6_.tier && Boolean(_loc4_.rank.isBelow(_loc6_.rank)))
               {
                  _loc2_[_loc5_] = _loc6_;
               }
               else if(_loc6_.tier == _loc4_.tier && _loc6_.rank == _loc4_.rank && _loc6_.elements.myRank.queueType < _loc4_.elements.myRank.queueType)
               {
                  _loc2_[_loc5_] = _loc6_;
               }
            }
            else
            {
               _loc2_.push(_loc4_);
               _loc3_[_loc4_.teamName] = _loc2_.length - 1;
            }
         }
         _loc2_.sort(this.orderLeaguesHighToLowSmallerQueuesFirst);
         return _loc2_;
      }
      
      private function orderLeaguesHighToLowSmallerQueuesFirst(param1:SummonerLeagueObjectModel, param2:SummonerLeagueObjectModel) : int
      {
         if(param1.queueType > param2.queueType)
         {
            return -1;
         }
         if(param1.queueType < param2.queueType)
         {
            return 1;
         }
         if(param2.tier.isBelow(param1.tier))
         {
            return -1;
         }
         if(param1.tier.isBelow(param2.tier))
         {
            return 1;
         }
         if(param2.rank.isBelow(param1.rank))
         {
            return -1;
         }
         if(param1.rank.isBelow(param2.rank))
         {
            return 1;
         }
         if(param1.teamName < param2.teamName)
         {
            return -1;
         }
         if(param1.teamName > param2.teamName)
         {
            return 1;
         }
         return param2.id - param1.id;
      }
   }
}

