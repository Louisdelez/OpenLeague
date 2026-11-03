package com.riotgames.platform.gameclient.module.rt
{
   import blix.action.IAction;
   import blix.signals.Signal;
   import com.riotgames.platform.common.event.RosterProviderEvent;
   import com.riotgames.platform.common.provider.IChampionImagesProvider;
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.common.provider.IInventoryProvider;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.provider.SoundProviderProxy;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.IChatProvider;
   import com.riotgames.platform.gameclient.chat.IChatRoomProvider;
   import com.riotgames.platform.gameclient.chat.IChatRosterProvider;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.LeagueItemDTO;
   import com.riotgames.platform.gameclient.domain.LeagueListDTO;
   import com.riotgames.platform.gameclient.domain.Summoner;
   import com.riotgames.platform.gameclient.domain.SummonerLevel;
   import com.riotgames.platform.gameclient.domain.game.CompetitiveSeason;
   import com.riotgames.platform.gameclient.domain.game.QueueType;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Player;
   import com.riotgames.platform.gameclient.domain.rankedTeams.RankedDisplayBucketDTO;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Team;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamId;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberStatus;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamStatDetail;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamStatType;
   import com.riotgames.platform.gameclient.domain.systemstates.TeamRewardQaulificationVO;
   import com.riotgames.platform.gameclient.module.rt.controller.RTRefreshProfileTeamCommand;
   import com.riotgames.platform.gameclient.module.rt.model.ProfilePlayerProxy;
   import com.riotgames.platform.gameclient.module.rt.model.ServiceStateProxy;
   import com.riotgames.platform.gameclient.module.rt.model.TeamProxy;
   import com.riotgames.platform.gameclient.module.rt.resource.RTContext;
   import com.riotgames.platform.gameclient.module.rt.view.RTModuleShell;
   import com.riotgames.platform.gameclient.module.rt.view.create.CreateButton;
   import com.riotgames.platform.gameclient.module.rt.view.stats.TeamStatsView;
   import com.riotgames.platform.gameclient.module.rt.view.tab.ProfileTab;
   import com.riotgames.platform.gameclient.views.models.ProfileDisplayModel;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.rankedteams.IRankedTeamsProvider;
   import com.riotgames.pvpnet.rankedteams.RTViewEvent;
   import com.riotgames.pvpnet.rankedteams.RankedTeamEvent;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.localization.action.LoadModuleResourceBundleAction;
   import com.riotgames.pvpnet.system.messaging.ShellDispatcher;
   import com.riotgames.pvpnet.system.wordfilter.WordFilter;
   import flash.display.DisplayObject;
   import flash.utils.getQualifiedClassName;
   import mx.binding.utils.ChangeWatcher;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import org.igniterealtime.xiff.data.Message;
   
   public class RankedTeamsProvider implements IRankedTeamsProvider
   {
      
      private var RTProfile:RTModuleShell;
      
      public var chatController:ChatController;
      
      private var localeLoaded:Boolean = false;
      
      public var shellDispatcher:ShellDispatcher;
      
      public var wordFilter:WordFilter;
      
      private var profileButton:ProfileTab;
      
      private var createButton:CreateButton;
      
      private var inventory:IInventory;
      
      public var chatRoomProvider:IChatRoomProvider;
      
      private var playerNotificationsController:PlayerNotificationController;
      
      private var summonerWatcher:ChangeWatcher;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public var session:Session;
      
      private var champImages:IChampionImagesProvider;
      
      public var rosterProvider:IChatRosterProvider;
      
      public var soundManager:ISoundProvider = SoundProviderProxy.instance;
      
      public var context:RTContext;
      
      private var assetLoaders:Array = [];
      
      public var serviceProxy:ServiceProxy;
      
      private var hasRegistered:Boolean = false;
      
      public var profileDisplayModel:ProfileDisplayModel;
      
      private var onInitializedCallbackFunction:Function;
      
      public var clientConfig:ClientConfig;
      
      public function RankedTeamsProvider()
      {
         super();
         this.serviceProxy = ServiceProxy.instance;
         this.session = Session.instance;
         this.shellDispatcher = ShellDispatcher.instance;
         this.clientConfig = ClientConfig.instance;
         this.wordFilter = WordFilter.instance;
         this.playerNotificationsController = new PlayerNotificationController();
         RTFacade.instance.rtProvider = this;
      }
      
      private function makeDTOWithQueueTypeOnly(param1:String) : RankedDisplayBucketDTO
      {
         var _loc2_:RankedDisplayBucketDTO = new RankedDisplayBucketDTO();
         _loc2_.teamName = "";
         _loc2_.queueType = param1;
         _loc2_.wins = 0;
         _loc2_.losses = 0;
         _loc2_.onlyDisplayQueueType = true;
         return _loc2_;
      }
      
      private function onRosterChanged(param1:RosterProviderEvent) : void
      {
         RTFacade.instance.sendNotification(RosterProviderEvent.ROSTER_CHANGED);
      }
      
      public function requestViewSummonerProfile(param1:String) : void
      {
         this.shellDispatcher.dispatchEvent(new RankedTeamEvent(RankedTeamEvent.REQUEST_VIEW_PROFILE,null,param1));
      }
      
      private function get teamProxy() : TeamProxy
      {
         return RTFacade.instance.retrieveProxy(TeamProxy.NAME) as TeamProxy;
      }
      
      public function gotoTeamProfile(param1:TeamId, param2:Boolean = false) : void
      {
         this.serviceStateProxy.onServiceCall();
         this.teamProxy.showTeamById(param1,true,false,param2);
         if(!this.RTProfile)
         {
            this.RTProfile = new RTModuleShell();
         }
         this.profileDisplayModel.activeView = ProfileDisplayModel.RANKED_TEAMS_VIEW;
         this.profileDisplayModel.update();
         this.RTProfile.goToProfile();
      }
      
      private function onGotChampImages(param1:IChampionImagesProvider) : void
      {
         this.champImages = param1;
      }
      
      public function getRankedTeamsTabButton() : DisplayObject
      {
         if(!this.profileButton)
         {
            this.profileButton = new ProfileTab(this.context);
         }
         return this.profileButton;
      }
      
      public function isPlayerFriend(param1:String) : Boolean
      {
         return this.rosterProvider.isSummonerBuddy(param1);
      }
      
      private function registerModule() : void
      {
         if(!this.hasRegistered)
         {
            this.hasRegistered = true;
            ProviderLookup.publishProvider(IRankedTeamsProvider,this);
            if(this.session.summoner)
            {
               this.getLocalPlayerOnStartup();
            }
            else
            {
               this.summonerWatcher = ChangeWatcher.watch(this.session,"summoner",this.onSummonerChanged);
            }
         }
      }
      
      private function getLocalPlayerOnStartup() : void
      {
         if(this.session.summonerLevel != null && this.session.summonerLevel.summonerLevel >= Team.MIN_SUMMONER_LEVEL_FOR_RANKED_TEAMS)
         {
            RTFacade.playerProxy.retrieveLocalPlayer();
         }
      }
      
      public function getChampionById(param1:int) : Champion
      {
         return this.inventory.championIdMapping[param1];
      }
      
      private function onLoadResourceBundleComplete() : void
      {
         if(Boolean(this.onInitializedCallbackFunction))
         {
            this.onInitializedCallbackFunction();
         }
         this.localeLoaded = true;
         this.joinLoadComplete();
      }
      
      public function requestReturnToMatchDetails() : void
      {
         this.shellDispatcher.dispatchEvent(new RankedTeamEvent(RankedTeamEvent.REQUEST_RETURN_TO_MATCH_DETAILS,null));
      }
      
      public function removeListener(param1:String, param2:Function) : void
      {
         this.shellDispatcher.removeEventListener(param1,param2);
      }
      
      public function getCreateRankedTeamButton() : DisplayObject
      {
         if(!this.createButton)
         {
            this.createButton = new CreateButton(this.context);
         }
         return this.createButton;
      }
      
      private function onInventoryProvider(param1:IInventoryProvider) : void
      {
         this.inventory = param1.getInventory();
      }
      
      private function getLeaguePoints(param1:LeagueListDTO, param2:String) : Number
      {
         var _loc4_:LeagueListDTO = null;
         var _loc5_:LeagueItemDTO = null;
         var _loc3_:Number = 0;
         for each(_loc4_ in param1)
         {
            for each(_loc5_ in _loc4_)
            {
               if(_loc5_.playerOrTeamName == param2)
               {
                  _loc3_ = Number(_loc5_.leaguePoints);
               }
            }
         }
         return _loc3_;
      }
      
      public function setViewableSummoner(param1:Summoner, param2:SummonerLevel) : void
      {
         RTFacade.profilePlayerProxy.setSummoner(param1,param2);
      }
      
      public function addListener(param1:String, param2:Function) : void
      {
         this.shellDispatcher.addEventListener(param1,param2);
      }
      
      public function retrieveHighest5v5TeamData(param1:int) : RankedDisplayBucketDTO
      {
         return this.retrieveHighestTeamData(param1,TeamStatType.RANKED_TEAM_5x5,QueueType.RANKED_TEAM_5x5);
      }
      
      private function getCurrentLocale() : String
      {
         return ClientConfig.instance.locale;
      }
      
      private function joinLoadComplete() : void
      {
         var _loc1_:IAction = null;
         if(!this.localeLoaded)
         {
            return;
         }
         for each(_loc1_ in this.assetLoaders)
         {
            if(!_loc1_.getIsFinished())
            {
               return;
            }
         }
         this.registerModule();
      }
      
      public function setExternalChatAndProfileManagers(param1:IChatRoomProvider, param2:IChatRosterProvider, param3:ProfileDisplayModel) : void
      {
         this.chatRoomProvider = param1;
         this.rosterProvider = param2;
         this.profileDisplayModel = param3;
         param2.addEventListener(RosterProviderEvent.ROSTER_CHANGED,this.onRosterChanged);
      }
      
      public function getRankedTeams() : Array
      {
         if(Boolean(this.profilePlayerProxy.player) && Boolean(this.profilePlayerProxy.player.teamsSummary))
         {
            return this.profilePlayerProxy.player.teamsSummary.toArray();
         }
         return new Array();
      }
      
      private function retrieveHighestTeamData(param1:int, param2:String, param3:String) : RankedDisplayBucketDTO
      {
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:Team = null;
         var _loc13_:TeamRewardQaulificationVO = null;
         if(param1 != CompetitiveSeason.currentSeason)
         {
            return null;
         }
         var _loc4_:RankedDisplayBucketDTO = new RankedDisplayBucketDTO();
         var _loc5_:Team = null;
         var _loc6_:Player = this.profilePlayerProxy.player;
         if(_loc6_ == null)
         {
            return this.makeDTOWithQueueTypeOnly(param3);
         }
         var _loc7_:int = int(this.profilePlayerProxy.player.playerId);
         var _loc8_:TeamStatDetail = null;
         var _loc9_:TeamStatDetail = null;
         for each(_loc12_ in this.profilePlayerProxy.player.teamsSummary)
         {
            if(_loc12_.roster.retrieveMemberStatus(_loc7_) == TeamMemberStatus.MEMBER)
            {
               if(_loc5_ == null)
               {
                  _loc5_ = _loc12_;
               }
               else
               {
                  _loc8_ = _loc5_.teamStatSummary.retrieveTeamStatDetail(param2);
                  _loc9_ = _loc12_.teamStatSummary.retrieveTeamStatDetail(param2);
                  _loc10_ = _loc9_.wins + _loc9_.losses >= TeamStatDetail.GAMES_PLAYED_FOR_RANKED_STATUS;
                  _loc11_ = _loc8_.wins + _loc8_.losses >= TeamStatDetail.GAMES_PLAYED_FOR_RANKED_STATUS;
                  if(!((_loc11_) && !_loc10_))
                  {
                     if(!_loc11_ && _loc10_)
                     {
                        _loc5_ = _loc12_;
                     }
                     else if(_loc10_)
                     {
                        if(_loc9_.wins + _loc9_.losses > _loc8_.wins + _loc8_.losses)
                        {
                           _loc5_ = _loc12_;
                        }
                        else if(_loc9_.wins + _loc9_.losses == _loc8_.wins + _loc8_.losses)
                        {
                           if(_loc9_.wins > _loc8_.wins)
                           {
                              _loc5_ = _loc12_;
                              continue;
                           }
                        }
                     }
                     else if(_loc9_.wins + _loc9_.losses > _loc8_.wins + _loc8_.losses)
                     {
                        _loc5_ = _loc12_;
                     }
                     else if(_loc9_.wins + _loc9_.losses == _loc8_.wins + _loc8_.losses)
                     {
                        if(_loc9_.wins > _loc8_.wins)
                        {
                           _loc5_ = _loc12_;
                        }
                     }
                  }
               }
            }
         }
         if(_loc5_ == null)
         {
            return this.makeDTOWithQueueTypeOnly(param3);
         }
         _loc8_ = _loc5_.teamStatSummary.retrieveTeamStatDetail(param2);
         _loc4_.teamName = _loc5_.name;
         _loc4_.queueType = param3;
         _loc4_.wins = _loc8_.wins;
         _loc4_.losses = _loc8_.losses;
         _loc4_.leaves = _loc8_.leaves;
         _loc4_.onlyDisplayQueueType = false;
         if(ClientConfig.instance.leagueServiceEnabled)
         {
            _loc4_.isLeague = true;
            _loc4_.league = ServiceProxy.instance.leagueService.cache.getLeagueDataForQueue(_loc5_.name,param3);
            _loc4_.leaguePoints = ServiceProxy.instance.leagueService.cache.getLeaguePointsFromTeamCache(_loc5_.name,param3);
            _loc13_ = ServiceProxy.instance.leagueService.cache.getIsQualifiedForRewardsFromTeam(_loc5_.teamId.toString(),param3);
            _loc4_.isPersonallyQualified = _loc13_.qualifiedTierReward;
            _loc4_.numGamesNeededForQualification = _loc13_.gameWinForReward;
            _loc4_.demotionWarningLevel = ServiceProxy.instance.leagueService.cache.getDemotionWarning(_loc5_.teamId.toString(),param3);
         }
         else
         {
            _loc4_.isPersonallyQualified = true;
         }
         return _loc4_;
      }
      
      private function onRTViewEvent(param1:RTViewEvent) : void
      {
         RTFacade.instance.sendNotification(RTRefreshProfileTeamCommand.REFRESH);
      }
      
      public function get configShowTeamHistory() : Boolean
      {
         return this.clientConfig.showTeamHistory;
      }
      
      public function clearInviteNotificationsForTeam(param1:TeamId) : void
      {
         this.playerNotificationsController.clearInviteNotificationsForTeam(param1);
      }
      
      public function initialize(param1:Function = null) : void
      {
         var _loc2_:IAction = null;
         this.onInitializedCallbackFunction = param1;
         this.context = new RTContext(this.soundManager);
         this.assetLoaders.push(this.context.loadAssets("/assets/rankedTeams/RTAsset.swf"));
         this.assetLoaders.push(this.context.loadAssets("/assets/rankedTeams/matchHistory.swf"));
         this.assetLoaders.push(this.context.loadAssets("/assets/rankedTeams/CreateTeamModal.swf"));
         this.assetLoaders.push(this.context.loadAssets("/assets/rankedTeams/teamStats.swf"));
         this.context.enableAutoLocalization("rankedTeams");
         for each(_loc2_ in this.assetLoaders)
         {
            _loc2_.getCompleted().addOnce(this.joinLoadComplete);
         }
         this.loadResources();
         ProviderLookup.getProvider(IInventoryProvider,this.onInventoryProvider);
         ProviderLookup.getProvider(IChampionImagesProvider,this.onGotChampImages);
         ProviderLookup.getProvider(IChatProvider,this.onChatProvider);
      }
      
      public function handleP2PMessage(param1:Message) : void
      {
         this.playerNotificationsController.handleP2PMessage(param1);
      }
      
      public function get configShowTeamStats() : Boolean
      {
         return this.clientConfig.showTeamStats;
      }
      
      public function getRankedTeamsTabView() : DisplayObject
      {
         if(!this.RTProfile)
         {
            this.RTProfile = new RTModuleShell();
         }
         return this.RTProfile;
      }
      
      private function onSummonerChanged(param1:PropertyChangeEvent) : void
      {
         this.summonerWatcher.unwatch();
         this.getLocalPlayerOnStartup();
      }
      
      public function getChampIcon(param1:int, param2:Function) : void
      {
         var _loc3_:Champion = this.inventory.championIdMapping[param1];
         if(_loc3_)
         {
            this.champImages.getIcon(_loc3_.skinName,0,param2);
         }
      }
      
      private function get profilePlayerProxy() : ProfilePlayerProxy
      {
         return RTFacade.instance.retrieveProxy(ProfilePlayerProxy.NAME) as ProfilePlayerProxy;
      }
      
      public function updateTeamStatsView(param1:TeamId, param2:Function = null, param3:Function = null) : void
      {
         this.teamProxy.showTeamById(param1,false,true,false);
         this.teamProxy.profileTeamProxy.teamLoaded.add(param2);
         this.teamProxy.teamStatsProxy.statsChanged.add(param3);
      }
      
      public function processNotifications(param1:Player) : void
      {
         this.playerNotificationsController.processNotifications(param1);
      }
      
      public function requestAddFriend(param1:String) : void
      {
         this.shellDispatcher.dispatchEvent(new RankedTeamEvent(RankedTeamEvent.REQUEST_ADD_FRIEND,null,param1));
      }
      
      public function loadResources() : void
      {
         var _loc1_:String = this.getCurrentLocale();
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         var _loc3_:IAction = new LoadModuleResourceBundleAction(_loc2_,_loc1_,"rankedTeams","rankedTeams","rkt",ClientConfig.instance.debugLocale);
         _loc3_.getCompleted().addOnce(this.onLoadResourceBundleComplete);
         _loc3_.invoke();
      }
      
      private function onChatProvider(param1:IChatProvider) : void
      {
         this.chatController = param1 as ChatController;
      }
      
      public function getRankedTeamsStatsView(param1:Signal = null) : DisplayObject
      {
         var _loc2_:TeamStatsView = new TeamStatsView(RTFacade.context);
         RTFacade.context.setTooltipRoot(_loc2_);
         _loc2_.isLeague = true;
         _loc2_.closeSignal = param1;
         return _loc2_;
      }
      
      public function setActiveRankedTeam(param1:TeamId) : void
      {
         this.profileDisplayModel.activeView = ProfileDisplayModel.RANKED_TEAMS_VIEW;
         this.profileDisplayModel.update();
         this.teamProxy.showTeamById(param1,true);
      }
      
      private function get serviceStateProxy() : ServiceStateProxy
      {
         return RTFacade.instance.retrieveProxy(ServiceStateProxy.NAME) as ServiceStateProxy;
      }
      
      public function retrieveHighest3v3TeamData(param1:int) : RankedDisplayBucketDTO
      {
         return this.retrieveHighestTeamData(param1,TeamStatType.RANKED_TEAM_3x3,QueueType.RANKED_TEAM_3x3);
      }
      
      public function showCreateTeamModal() : void
      {
         RTFacade.modalMediator.showCreateTeamModal();
      }
      
      public function isRankedTeamServiceEnabled() : Boolean
      {
         return this.clientConfig.teamServiceEnabled;
      }
   }
}

