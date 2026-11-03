package com.riotgames.pvpnet.game.controllers
{
   import blix.context.Context;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.provider.ChromeContextAlertProviderProxy;
   import com.riotgames.platform.common.provider.ICLSProvider;
   import com.riotgames.platform.common.provider.IChromeContextAlertProvider;
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.common.provider.IInventoryProvider;
   import com.riotgames.platform.common.provider.IRerollProvider;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.provider.SoundProviderProxy;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.MessageDictionary;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.IChatProvider;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.gameclient.chat.controllers.PresenceController;
   import com.riotgames.platform.gameclient.chat.domain.ChatMessageType;
   import com.riotgames.platform.gameclient.chat.domain.ChatMessageVO;
   import com.riotgames.platform.gameclient.chat.domain.ChatRoomType;
   import com.riotgames.platform.gameclient.configurations.PlayerInventoryConfig;
   import com.riotgames.platform.gameclient.controllers.game.ArrowedAlertController;
   import com.riotgames.platform.gameclient.controllers.game.ArrowedAlertStyle;
   import com.riotgames.platform.gameclient.controllers.game.GlowComponentController;
   import com.riotgames.platform.gameclient.controllers.game.HelpEventQueue;
   import com.riotgames.platform.gameclient.domain.AggregatedStat;
   import com.riotgames.platform.gameclient.domain.AllSummonerData;
   import com.riotgames.platform.gameclient.domain.EndOfGameStats;
   import com.riotgames.platform.gameclient.domain.LeagueItemDTO;
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.platform.gameclient.domain.PlayerStat;
   import com.riotgames.platform.gameclient.domain.PointsPenalty;
   import com.riotgames.platform.gameclient.domain.RawStatType;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.platform.gameclient.domain.SummonerLeagueItemsDTO;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.platform.gameclient.domain.game.GameMode;
   import com.riotgames.platform.gameclient.domain.game.GameQueueConfig;
   import com.riotgames.platform.gameclient.domain.game.GameType;
   import com.riotgames.platform.gameclient.domain.game.practice.Team;
   import com.riotgames.platform.gameclient.domain.rankedTeams.MatchHistorySummary;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamInfo;
   import com.riotgames.platform.gameclient.domain.reroll.EogPointChangeBreakdown;
   import com.riotgames.platform.gameclient.domain.reroll.PointSummary;
   import com.riotgames.platform.gameclient.domain.summoner.LevelUpInfo;
   import com.riotgames.platform.gameclient.leagues.LeagueUpdateItem;
   import com.riotgames.platform.gameclient.services.IBaseLcdsService;
   import com.riotgames.platform.gameclient.utils.DateUtil;
   import com.riotgames.platform.gameclient.utils.HardcodedEndOfGameStats;
   import com.riotgames.platform.gameclient.views.ViewMediator;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.contextualeducation.IContextualEducationProvider;
   import com.riotgames.pvpnet.endofgamegiftwindow.IEndOfGameGiftWindowProvider;
   import com.riotgames.pvpnet.endofgamegiftwindow.enums.EndOfGameGiftConfig;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.player.IPlayerSummary;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.player.PlayerSummary;
   import com.riotgames.pvpnet.game.alerts.IReportPlayerAlertAction;
   import com.riotgames.pvpnet.game.controllers.contextalert.EndOfGameAlertParser;
   import com.riotgames.pvpnet.game.controllers.tutorial.CreateTutorialGameController;
   import com.riotgames.pvpnet.game.variants.GameFlowVariant;
   import com.riotgames.pvpnet.game.variants.GameFlowVariantFactory;
   import com.riotgames.pvpnet.game.variants.GameStatsType;
   import com.riotgames.pvpnet.suggestedplayers.ISuggestedPlayersProvider;
   import com.riotgames.pvpnet.suggestedplayers.SuggestedPlayersProviderProxy;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.PlatformConfigProviderProxy;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.pvpnet.system.leagues.ProfileUtils;
   import com.riotgames.rust.popup.IPopUpManager;
   import com.riotgames.rust.popup.PopUpManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.rpc.events.ResultEvent;
   import org.igniterealtime.xiff.conference.RoomOccupant;
   
   public class EndOfGameStatsController implements ICycleViewController, IEndOfGameStatsProvider, IEventDispatcher
   {
      
      public static const WAITING_FOR_STATS:String = "waitingForStats";
      
      public static const SHOW_STATS:String = "showStats";
      
      public static const TUTORIAL_GAME_WRAPUP:String = "showTutorialGame";
      
      public static const defaultXpBoostBonus:int = 50;
      
      public var endOfGameStatsSet:Signal = new Signal();
      
      public var rerollStatsSet:Signal = new Signal();
      
      [Inject]
      public var applicationController:IAppController;
      
      public var createTutorialGameController:CreateTutorialGameController;
      
      public var contextAlertController:IChromeContextAlertProvider = ChromeContextAlertProviderProxy.instance;
      
      public var chatController:ChatController;
      
      public var presenceController:PresenceController;
      
      public var lcdsHeartBeatController:LCDSHeartBeatController;
      
      public var viewMediator:ViewMediator;
      
      public var arrowedAlertController:ArrowedAlertController;
      
      public var glowComponentController:GlowComponentController;
      
      public var session:Session = Session.instance;
      
      public var serviceProxy:ServiceProxy = ServiceProxy.instance;
      
      public var soundManager:ISoundProvider = SoundProviderProxy.instance;
      
      public var inventory:IInventory;
      
      public var inventoryController:IInventoryController;
      
      public var rerollProvider:IRerollProvider;
      
      public var contextualEducationProvider:IContextualEducationProvider;
      
      private var _suggestedPlayersProvider:ISuggestedPlayersProvider;
      
      public var reportPlayerAlertAction:IReportPlayerAlertAction;
      
      private var _1437342803chatRoom:ChatRoom;
      
      private var _1180619197isBusy:Boolean;
      
      private var _1428783706currentEndOfGameState:String;
      
      private var _1553104804hasLeveledUp:Boolean;
      
      private var _1082336943newTalentPoints:int;
      
      private var _599784949newSpells:ArrayCollection;
      
      private var _744510763isVictorious:Boolean;
      
      private var _1720505207winsLossesStats:ArrayCollection;
      
      private var _1922076349combinedTeamStats:ArrayCollection;
      
      private var _183829682teamBasicStats:ArrayCollection;
      
      private var _1081038210otherTeamBasicStats:ArrayCollection;
      
      private var _242072141combinedTeamBasicStats:ArrayCollection;
      
      private var _1323362860localPlayer:PlayerParticipantStatsSummary = null;
      
      private var _2017389100potentialBoostIp:int;
      
      private var _1106736997leaver:Boolean;
      
      private var _1769158177gameTime:String;
      
      private var _1803715621endOfGameStats:EndOfGameStats;
      
      private var _2004135543allowedToPlayAgain:Boolean = true;
      
      private var _1277981600showRankedElo:Boolean = false;
      
      private var _389594274isTeamOneWinner:Boolean = false;
      
      private var _949787881overrideHomeButtonLabel:String;
      
      public var overrideHomeButtonCallback:Function;
      
      public var gameFlowComplete:Signal = new Signal();
      
      public var playAgainClicked:Signal = new Signal();
      
      public var endOfGameAlertParser:EndOfGameAlertParser;
      
      private var _rerollStatsStorage:EogPointChangeBreakdown;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _gameType:String;
      
      private var _gameMap:GameMap;
      
      private var proxiedErrorHandler:Function;
      
      private var isActive:Boolean = false;
      
      private var clientConfig:ClientConfig = ClientConfig.instance;
      
      private var tutorialEventQueue:HelpEventQueue = null;
      
      private var mockEoGStats:Boolean = false;
      
      private var _tutorialGameComplete:Signal = new Signal();
      
      private var _currentStateUpdated:Signal = new Signal();
      
      private var _leagueMessages:Array = new Array();
      
      private var _leaguesUpdateInfo:LeagueUpdateItem;
      
      private var _leaguesUpdateInfoChangedSignal:Signal = new Signal();
      
      private var _endOfGameGiftEnabled:Boolean = false;
      
      private var _endOfGameGiftEnabledChange:Signal;
      
      private var _endOfGameGiftController:IEndOfGameGiftWindowProvider;
      
      private var _onGiftSent:Function;
      
      private var _onGiftWindowClosed:Function;
      
      private var _levelUpInfo:LevelUpInfo;
      
      public var currrentGameId:Number;
      
      private var viewableStats:Dictionary = null;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function EndOfGameStatsController()
      {
         super();
      }
      
      private static function CombineStatValues(param1:Number, param2:Number, param3:String) : Number
      {
         var _loc4_:Number = NaN;
         if(param3 == RawStatType.LARGEST_KILLING_SPREE || param3 == RawStatType.LARGEST_MULTI_KILL || param3 == RawStatType.LARGEST_CRITICAL_STRIKE || param3 == RawStatType.TEAM_OBJECTIVE)
         {
            _loc4_ = param1 > param2 ? param1 : param2;
         }
         else
         {
            _loc4_ = param1 + param2;
         }
         return _loc4_;
      }
      
      public static function getStatsType(param1:EndOfGameStats, param2:int) : String
      {
         var _loc3_:GameFlowVariant = null;
         if(param1 != null)
         {
            _loc3_ = GameFlowVariantFactory.instance.getVariant(param1.gameMutators,param1.gameMode);
            return _loc3_.getGameStatsType(param2);
         }
         return GameStatsType.CLASSIC;
      }
      
      public function get leaguesUpdateModel() : LeagueUpdateItem
      {
         return this._leaguesUpdateInfo;
      }
      
      public function get leaguesUpdateInfoChangedSignal() : Signal
      {
         return this._leaguesUpdateInfoChangedSignal;
      }
      
      private function calculateWinner() : Boolean
      {
         var _loc4_:PlayerParticipantStatsSummary = null;
         var _loc1_:Boolean = false;
         var _loc2_:ArrayCollection = this.endOfGameStats.teamPlayerParticipantStats;
         var _loc3_:ArrayCollection = this.endOfGameStats.otherTeamPlayerParticipantStats;
         if(Boolean(_loc2_) && _loc2_.length > 0)
         {
            _loc4_ = _loc2_[0];
         }
         else if(Boolean(_loc3_) && _loc3_.length > 0)
         {
            _loc4_ = _loc3_[0];
         }
         if(Boolean(_loc4_))
         {
            _loc1_ = _loc4_.teamId == int(Team.TEAM_ID_BLUE) && _loc4_.statistics != null && PlayerStat.findStat(RawStatType.WINS,_loc4_.statistics) != null;
         }
         return _loc1_;
      }
      
      private function findLocalPlayerInParticipants() : void
      {
         var _loc1_:PlayerParticipantStatsSummary = null;
         for each(_loc1_ in this.endOfGameStats.teamPlayerParticipantStats)
         {
            if(_loc1_.userId == this.session.summoner.sumId)
            {
               this.localPlayer = _loc1_;
               this.localPlayer.isMe = true;
               break;
            }
         }
         if(Boolean(this.localPlayer))
         {
            this.isVictorious = this.localPlayer.statistics != null && PlayerStat.findStat(RawStatType.WINS,this.localPlayer.statistics) != null;
            this.leaver = this.localPlayer.leaver;
            this.fillWinsLossesStat(this.localPlayer.wins,this.localPlayer.losses,this.localPlayer.leaves);
            this.showRankedElo = this.localPlayer.wins + this.localPlayer.losses >= ProfileUtils.MIN_RANKED_GAMES_FOR_RANKING;
         }
      }
      
      private function configureSpectatorProperties() : void
      {
         var _loc1_:ArrayCollection = null;
         var _loc2_:TeamInfo = null;
         if((this.endOfGameStats.teamPlayerParticipantStats[0] as PlayerParticipantStatsSummary).teamId != Team.TEAM_ID_BLUE)
         {
            _loc1_ = this.endOfGameStats.teamPlayerParticipantStats;
            this.endOfGameStats.teamPlayerParticipantStats = this.endOfGameStats.otherTeamPlayerParticipantStats;
            this.endOfGameStats.otherTeamPlayerParticipantStats = _loc1_;
            _loc2_ = this.endOfGameStats.myTeamInfo;
            this.endOfGameStats.myTeamInfo = this.endOfGameStats.otherTeamInfo;
            this.endOfGameStats.otherTeamInfo = _loc2_;
         }
      }
      
      private function repairSummonerNamesAndTeams(param1:Array) : void
      {
         var _loc2_:String = null;
         var _loc3_:PlayerParticipantStatsSummary = null;
         if(this.endOfGameStats.teamPlayerParticipantStats != null)
         {
            for each(_loc3_ in this.endOfGameStats.teamPlayerParticipantStats)
            {
               _loc2_ = param1[_loc3_.userId];
               if(Boolean(_loc2_))
               {
                  _loc3_.summonerName = _loc2_;
               }
               _loc3_.teamInfo = this.endOfGameStats.myTeamInfo;
            }
         }
         if(this.endOfGameStats.otherTeamPlayerParticipantStats != null)
         {
            for each(_loc3_ in this.endOfGameStats.otherTeamPlayerParticipantStats)
            {
               _loc2_ = param1[_loc3_.userId];
               if(Boolean(_loc2_))
               {
                  _loc3_.summonerName = _loc2_;
               }
               _loc3_.teamInfo = this.endOfGameStats.otherTeamInfo;
            }
         }
      }
      
      public function setEndOfGameStats(param1:EndOfGameStats, param2:Boolean, param3:Boolean, param4:Array, param5:String, param6:GameMap, param7:Boolean) : void
      {
         var _loc8_:Number = NaN;
         var _loc9_:int = 0;
         this.endOfGameStats = param1;
         this.reportEndOfGameIPGain();
         this.localPlayer = null;
         this._gameType = param5;
         this._gameMap = param6;
         this.allowedToPlayAgain = param7;
         this.overrideHomeButtonCallback = null;
         this.overrideHomeButtonLabel = null;
         this.isTeamOneWinner = this.calculateWinner();
         this.fixPenalties();
         this.session.firstWinOfDayTimeRemaining = param1.timeUntilNextFirstWinBonus;
         if(Boolean(this.endOfGameStats.teamPlayerParticipantStats) && this.endOfGameStats.teamPlayerParticipantStats.length > 0)
         {
            if(!param2)
            {
               this.findLocalPlayerInParticipants();
            }
            if(!this.localPlayer)
            {
               this.configureSpectatorProperties();
            }
         }
         this.cleanupIpEarned();
         this.gameTime = DateUtil.secondsToTimeString(this.endOfGameStats.gameLength);
         this.repairSummonerNamesAndTeams(param4);
         this.hasLeveledUp = this.endOfGameStats.leveledUp;
         this.newTalentPoints = this.endOfGameStats.talentPointsGained;
         this.newSpells = this.endOfGameStats.newSpells;
         if(!this.mockEoGStats)
         {
            this.refreshSummonerData();
         }
         else
         {
            this.mockEoGStats = false;
            this.showStatsIfApplicable();
         }
         if(!param2)
         {
            this.chatController.addRecentPlayers(this.endOfGameStats.otherTeamPlayerParticipantStats);
            this.chatController.addRecentPlayers(this.endOfGameStats.teamPlayerParticipantStats);
            if(Boolean(this._suggestedPlayersProvider))
            {
               this._suggestedPlayersProvider.handleEndOfGameEvent(param1);
            }
         }
         this.createStatViews();
         if(param3)
         {
            if(!this.endOfGameStats.roomName || this.endOfGameStats.roomName == "")
            {
               _loc8_ = Boolean(this.endOfGameStats.reportGameId) ? Number(this.endOfGameStats.reportGameId) : Number(this.endOfGameStats.gameId);
               this.chatController.requestChatRoom(this.chatController.obfuscateChatRoom("endGame" + _loc8_,ChatRoomType.POST_GAME),"endGame" + _loc8_,this.endOfGameStats.roomPassword,ChatRoomType.POST_GAME,this.onChatRoomCreated);
            }
            else
            {
               this.chatController.requestChatRoom(this.endOfGameStats.roomName,"endGame" + _loc8_,this.endOfGameStats.roomPassword,ChatRoomType.POST_GAME,this.onChatRoomCreated);
            }
         }
         if(this._rerollStatsStorage != null)
         {
            this.endOfGameStats.rerollEnabled = true;
            this.endOfGameStats.rerollBonusEarned = this._rerollStatsStorage.pointChangeFromChampionsOwned;
            this.endOfGameStats.rerollEarned = this._rerollStatsStorage.pointChangeFromGameplay;
            this._rerollStatsStorage = null;
         }
         if(this._leagueMessages.length > 0)
         {
            _loc9_ = 0;
            while(_loc9_ < this._leagueMessages.length)
            {
               this.onLeagueUpdateMessageRecieved(this._leagueMessages[_loc9_]);
               _loc9_++;
            }
            this._leagueMessages = new Array();
         }
         this.updateChatPresenceData();
         this.endOfGameStatsSet.dispatch();
      }
      
      private function updateChatPresenceData() : void
      {
         ServiceProxy.instance.leagueService.getMyLeaguePositions(this.onGetLeaguePositions);
      }
      
      private function onGetLeaguePositions(param1:ResultEvent) : void
      {
         var topLeague:LeagueItemDTO = null;
         var result:ResultEvent = param1;
         if(result.result is SummonerLeagueItemsDTO)
         {
            ServiceProxy.instance.leagueService.cache.updatePrescenceData(result.result as SummonerLeagueItemsDTO);
         }
         topLeague = ServiceProxy.instance.leagueService.cache.getTopLeagueForChatPrescence();
         ProviderLookup.getProvider(IChatProvider,function(param1:IChatProvider):void
         {
            var _loc2_:ChatController = param1 as ChatController;
            _loc2_.presenceController.updateLeagueData(topLeague);
         });
         ProviderLookup.getProvider(ICLSProvider,function(param1:ICLSProvider):void
         {
            param1.processDecayMessages();
         });
      }
      
      public function setRerollStats(param1:EogPointChangeBreakdown) : void
      {
         if(this.endOfGameStats != null)
         {
            this.endOfGameStats.rerollEnabled = true;
            this.endOfGameStats.rerollBonusEarned = param1.pointChangeFromChampionsOwned;
            this.endOfGameStats.rerollEarned = param1.pointChangeFromGameplay;
            this.rerollStatsSet.dispatch();
         }
         else
         {
            this._rerollStatsStorage = param1;
         }
         var _loc2_:Number = this.rerollProvider.getMaxRerollProgress() * this.rerollProvider.getMaxRerollCount();
         var _loc3_:Number = param1.pointChangeFromGameplay + param1.pointChangeFromChampionsOwned;
         var _loc4_:PointSummary = new PointSummary();
         _loc4_._pointsCostToRoll = this.rerollProvider.getMaxRerollProgress();
         _loc4_._currentPoints = Math.min(_loc2_,this.rerollProvider.getRerollPoints() + _loc3_);
         _loc4_._numberOfRolls = _loc4_._pointsCostToRoll > 0 ? int(_loc4_._currentPoints / _loc4_._pointsCostToRoll) : 0;
         _loc4_._maxRolls = this.rerollProvider.getMaxRerollCount();
         _loc4_._pointsToNextRoll = _loc4_._pointsCostToRoll - _loc4_._currentPoints % _loc4_._pointsCostToRoll;
         this.rerollProvider.setPointSummary(_loc4_);
      }
      
      private function reportEndOfGameIPGain() : void
      {
         var _loc1_:Object = new Object();
         _loc1_["ipEarned"] = this.endOfGameStats.ipEarned;
         _loc1_["ipTotal"] = this.endOfGameStats.ipTotal;
         _loc1_["boostIpEarned"] = this.endOfGameStats.boostIpEarned;
         _loc1_["firstWinBonus"] = this.endOfGameStats.firstWinBonus;
         if(Boolean(this.endOfGameStats.pointsPenalties))
         {
            _loc1_["pointsPenalites"] = this.endOfGameStats.pointsPenalties.source;
         }
         _loc1_["odinBonusIp"] = this.endOfGameStats.odinBonusIp;
         _loc1_["loyaltyBoostIpEarned"] = this.endOfGameStats.loyaltyBoostIpEarned;
         _loc1_["locationBoostIpEarned"] = this.endOfGameStats.locationBoostIpEarned;
      }
      
      public function onChatRoomCreated(param1:ChatRoom) : void
      {
         var _loc2_:ChatMessageVO = null;
         this.chatRoom = param1;
         if(this.chatRoom != null)
         {
            this.chatRoom.join();
            if(this.endOfGameStats.sendStatsToTournamentProvider)
            {
               _loc2_ = this.chatRoom.createChatMessageFromString(RiotResourceLoader.getString("tournamentGameReported","**tournamentCodeReported"));
               _loc2_.type = ChatMessageType.SYSTEM;
               param1.addMessageToBuffer(_loc2_);
            }
            this.updateUserList();
            this.chatRoom.userListChangedSignal.add(this.onChatRoomOccupantsChanged);
         }
      }
      
      public function get gameType() : String
      {
         return this._gameType;
      }
      
      public function get gameMap() : GameMap
      {
         return this._gameMap;
      }
      
      [Bindable(event="propertyChange")]
      public function get levelUpInfo() : LevelUpInfo
      {
         return this._levelUpInfo;
      }
      
      private function set _1834022541levelUpInfo(param1:LevelUpInfo) : void
      {
         this._levelUpInfo = param1;
      }
      
      public function initialize() : void
      {
         if(!this.inventory)
         {
            ProviderLookup.getProvider(IInventoryProvider,this.onInventoryProvider);
         }
         if(!this.contextualEducationProvider)
         {
            ProviderLookup.getProvider(IContextualEducationProvider,this.onContextualEducationProvider);
         }
         if(!this.rerollProvider)
         {
            ProviderLookup.getProvider(IRerollProvider,this.onRerollProvider);
         }
         if(!this._suggestedPlayersProvider)
         {
            ProviderLookup.getProvider(ISuggestedPlayersProvider,this.onSuggestedPlayersProvider);
         }
         if(this.clientConfig.leagueServiceEnabled)
         {
            ProviderLookup.getProvider(ICLSProvider,function(param1:ICLSProvider):void
            {
               param1.leagueUpdateMessageReceivedSignal.add(onLeagueUpdateMessageRecieved);
            });
         }
         ProviderLookup.publishProvider(IEndOfGameStatsProvider,this);
         this._endOfGameGiftEnabledChange = new Signal();
         this._endOfGameGiftEnabled = DynamicClientConfigManager.getConfiguration(EndOfGameGiftConfig.CONFIG_NAMESPACE,EndOfGameGiftConfig.ENABLED_SETTING,false,this.onEndOfGameGiftConfigChange).getBoolean();
         ProviderLookup.getProvider(IEndOfGameGiftWindowProvider,this.onEOGProviderReceived);
      }
      
      public function initializeCycle() : void
      {
         this.hasLeveledUp = false;
         this.newSpells = null;
         this.newTalentPoints = 0;
         this.levelUpInfo = null;
      }
      
      public function abortCycle() : void
      {
      }
      
      public function cleanup() : void
      {
      }
      
      public function cleanupCycle() : void
      {
      }
      
      public function activate() : void
      {
         if(Boolean(this.endOfGameStats) && this.endOfGameStats.gameId == this.currrentGameId)
         {
            this.showStatsIfApplicable();
         }
         else
         {
            this.setCurrentEndOfGameState(EndOfGameStatsController.WAITING_FOR_STATS);
            this.lcdsHeartBeatController.validatePlatformConnection(this.handlePlatformConnectionSuccess,this.handlePlatformConnectionComplete,this.handlePlatformConnectionError);
         }
         this.resetReports();
         this.isActive = true;
      }
      
      private function handlePlatformConnectionComplete(param1:Boolean) : void
      {
      }
      
      private function handlePlatformConnectionSuccess(param1:ResultEvent) : void
      {
      }
      
      private function handlePlatformConnectionError(param1:ServerError) : void
      {
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         var _loc3_:AlertAction = new AlertAction(_loc2_.getString("resources",MessageDictionary.CONNECTION_FAILED_TITLE),_loc2_.getString("resources","endofgame_server_down_alert_description"));
         _loc3_.add();
      }
      
      private function onAlertDismissed() : void
      {
      }
      
      private function showStatsIfApplicable() : void
      {
         if(this.gameType == GameType.TUTORIAL_GAME)
         {
            if(this.createTutorialGameController.isBasicTutorial)
            {
               if(this.clientConfig.advancedTutorialEnabled)
               {
                  this.setCurrentEndOfGameState(TUTORIAL_GAME_WRAPUP);
               }
               else
               {
                  this.gameFlowComplete.dispatch();
               }
            }
            else
            {
               this.initializeEoGTutorial();
               this.setCurrentEndOfGameState(EndOfGameStatsController.SHOW_STATS);
            }
            this._tutorialGameComplete.dispatch(this.createTutorialGameController.isBasicTutorial);
         }
         else
         {
            this.setCurrentEndOfGameState(EndOfGameStatsController.SHOW_STATS);
         }
      }
      
      private function setCurrentEndOfGameState(param1:String) : void
      {
         this.currentEndOfGameState = param1;
         this._currentStateUpdated.dispatch();
      }
      
      public function deactivate() : void
      {
         this.setCurrentEndOfGameState(EndOfGameStatsController.WAITING_FOR_STATS);
         this._leaguesUpdateInfo = null;
         this.isBusy = false;
         this.isActive = false;
         this.proxiedErrorHandler = null;
         this.levelUpInfo = null;
         this.isVictorious = false;
         this.endOfGameStats = null;
         if(this.chatRoom != null)
         {
            this.chatRoom.userListChangedSignal.remove(this.onChatRoomOccupantsChanged);
            this.chatController.closeChatRoom(this.chatRoom);
            this.chatRoom = null;
         }
         if(this.tutorialEventQueue != null)
         {
            this.tutorialEventQueue.clear();
         }
         this.resetReports();
      }
      
      private function onInventoryProvider(param1:IInventoryProvider) : void
      {
         this.inventory = param1.getInventory();
         this.inventoryController = param1.getInventoryController();
         this.endOfGameAlertParser = new EndOfGameAlertParser(this.contextAlertController,this.inventory);
      }
      
      private function onContextualEducationProvider(param1:IContextualEducationProvider) : void
      {
         this.contextualEducationProvider = param1;
      }
      
      private function onRerollProvider(param1:IRerollProvider) : void
      {
         this.rerollProvider = param1;
      }
      
      private function onSuggestedPlayersProvider(param1:ISuggestedPlayersProvider) : void
      {
         this._suggestedPlayersProvider = param1;
      }
      
      private function resetReports() : void
      {
         this.applicationController.reportTracker.reset();
      }
      
      private function fillWinsLossesStat(param1:Number, param2:Number, param3:Number) : void
      {
         this.winsLossesStats = new ArrayCollection();
         var _loc4_:AggregatedStat = new AggregatedStat();
         _loc4_.value = param1;
         _loc4_.displayName = RiotResourceLoader.getStatResourceString("TOTAL_SESSIONS_WON","**Won");
         var _loc5_:AggregatedStat = new AggregatedStat();
         _loc5_.value = param2;
         _loc5_.displayName = RiotResourceLoader.getStatResourceString("TOTAL_SESSIONS_LOST","**Lost");
         var _loc6_:AggregatedStat = new AggregatedStat();
         _loc6_.value = param3;
         _loc6_.displayName = RiotResourceLoader.getStatResourceString("TOTAL_LEAVES","**Left");
         this.winsLossesStats.addItem(_loc4_);
         this.winsLossesStats.addItem(_loc5_);
         this.winsLossesStats.addItem(_loc6_);
      }
      
      private function updatePresence() : void
      {
         this.presenceController.updateSingleQueueStats(Boolean(this.session.summonerLevel) ? int(this.session.summonerLevel.summonerLevel) : 1,this.endOfGameStats.queueType,this.endOfGameStats.elo,this.isVictorious,this.session.summoner.previousSeasonHighestTier);
      }
      
      private function onEOGProviderReceived(param1:IEndOfGameGiftWindowProvider) : void
      {
         this._endOfGameGiftController = param1;
         var _loc2_:Dictionary = new Dictionary();
         _loc2_[IPopUpManager] = PopUpManager.instance;
         _loc2_[IBaseLcdsService] = ServiceProxy.instance.lcdsService;
         var _loc3_:IContext = new Context(null,_loc2_);
         this._endOfGameGiftController.initializeEndOfGameGiftWindow(_loc3_);
      }
      
      public function get onEndOfGameGiftEnabledChanged() : ISignal
      {
         return this._endOfGameGiftEnabledChange;
      }
      
      private function onEndOfGameGiftConfigChange() : void
      {
         this._endOfGameGiftEnabled = !this._endOfGameGiftEnabled;
         this._endOfGameGiftEnabledChange.dispatch();
      }
      
      public function get endOfGameGiftEnabled() : Boolean
      {
         return this._endOfGameGiftEnabled;
      }
      
      private function onAllSummonerDataRetrieved(param1:ResultEvent) : void
      {
         var allSummonerData:AllSummonerData = null;
         var info:LevelUpInfo = null;
         var event:ResultEvent = param1;
         try
         {
            allSummonerData = event.result as AllSummonerData;
            if(allSummonerData == null)
            {
               return;
            }
            this.session.applyAllSummonerData(allSummonerData);
            if(this.endOfGameStats != null)
            {
               this.endOfGameStats.expPointsToNextLevel = allSummonerData.summonerLevel.expToNextLevel - allSummonerData.summonerLevelAndPoints.expPoints;
               this.endOfGameStats.ipTotal = allSummonerData.summonerLevelAndPoints.infPoints;
               if(this.endOfGameStats.leveledUp)
               {
                  this.inventoryController.refreshChampionsRoster(this.session.summonerLevel.summonerLevel);
               }
            }
            info = new LevelUpInfo();
            if(Boolean(this.endOfGameStats))
            {
               info.pointsEarned = this.endOfGameStats.experienceEarned;
            }
            if(Boolean(this.session))
            {
               if(Boolean(this.session.levelUpInfo))
               {
                  info.lastPercentCompleteForNextLevel = this.session.levelUpInfo.lastPercentCompleteForNextLevel;
               }
               if(Boolean(this.session.summonerLevelAndPoints))
               {
                  info.totalExperiencePoints = this.session.summonerLevelAndPoints.expPoints;
               }
               if(Boolean(this.session.summonerLevel))
               {
                  info.currentLevel = this.session.summonerLevel.summonerLevel;
                  info.nextLevel = info.currentLevel + 1;
                  info.pointsNeededToLevelUp = this.session.summonerLevel.expToNextLevel - info.totalExperiencePoints;
               }
            }
            this.levelUpInfo = info;
            this.showAchievementsIfNecessary();
            if(this.isActive)
            {
               this.showStatsIfApplicable();
            }
            this.updatePresence();
         }
         catch(e:Error)
         {
            logger.error("An error occurred processing end of game stats: " + e.errorID + " " + e.message + "\n" + e.getStackTrace());
            gameFlowComplete.dispatch();
         }
      }
      
      private function onServiceRequestComplete(param1:Boolean) : void
      {
         this.isBusy = false;
      }
      
      public function playAnotherGame(param1:Boolean = false) : void
      {
         if(this._endOfGameGiftEnabled && Boolean(this._endOfGameGiftController))
         {
            this._endOfGameGiftController.cleanSessionData();
         }
         this.playAgainClicked.dispatch(param1,this.isVictorious);
      }
      
      public function returnToLobby() : void
      {
         if(this._endOfGameGiftEnabled && Boolean(this._endOfGameGiftController))
         {
            this._endOfGameGiftController.cleanSessionData();
         }
         if(this.currentEndOfGameState == SHOW_STATS && this.gameType == GameType.TUTORIAL_GAME)
         {
            if(this.tutorialEventQueue != null)
            {
               this.tutorialEventQueue.clear();
            }
            if(this.clientConfig.advancedTutorialEnabled)
            {
               this.setCurrentEndOfGameState(TUTORIAL_GAME_WRAPUP);
            }
            else
            {
               this.gameFlowComplete.dispatch();
            }
         }
         else
         {
            this.gameFlowComplete.dispatch();
         }
      }
      
      private function refreshSummonerData() : void
      {
         this.isBusy = true;
         this.serviceProxy.summonerService.getAllSummonerDataByAccount(this.session.summoner.acctId,this.onAllSummonerDataRetrieved,this.onServiceRequestComplete);
      }
      
      private function showAchievementsIfNecessary() : void
      {
         this.fillNewspells();
         var _loc1_:int = 0;
         var _loc2_:int = this.session.summoner.sumId % 10;
         _loc1_ = int(this.endOfGameStats.rpEarned);
         if(Boolean(this.endOfGameAlertParser))
         {
            this.endOfGameAlertParser.runEndOfGameScript(this._levelUpInfo.currentLevel,this.hasLeveledUp,this.newSpells,this.inventory.activeBoosts,this.getNewQueues(),_loc1_);
         }
      }
      
      private function getNewQueues() : ArrayCollection
      {
         var _loc2_:GameQueueConfig = null;
         var _loc1_:ArrayCollection = new ArrayCollection();
         if(this.hasLeveledUp)
         {
            for each(_loc2_ in PlatformConfigProviderProxy.instance.getPlatformConfig().allGameQueues)
            {
               if(_loc2_.minLevel == this.session.summonerLevel.summonerLevel)
               {
                  _loc1_.addItem(_loc2_);
               }
            }
         }
         return _loc1_;
      }
      
      private function fillNewspells() : void
      {
         var _loc1_:Spell = null;
         this.newSpells = new ArrayCollection();
         if(this.hasLeveledUp)
         {
            for each(_loc1_ in this.inventory.spellDictionary)
            {
               if(_loc1_.minLevel == this.session.summonerLevel.summonerLevel && Boolean(_loc1_.active))
               {
                  this.newSpells.addItem(_loc1_);
               }
            }
         }
      }
      
      private function cleanupIpEarned() : void
      {
         this.potentialBoostIp = this.endOfGameStats.basePoints;
      }
      
      private function combineTeamStats(param1:ArrayCollection) : ArrayCollection
      {
         var _loc3_:PlayerParticipantStatsSummary = null;
         var _loc4_:ArrayCollection = null;
         var _loc5_:PlayerStat = null;
         var _loc6_:PlayerStat = null;
         var _loc7_:PlayerStat = null;
         var _loc2_:Dictionary = new Dictionary();
         for each(_loc3_ in param1)
         {
            for each(_loc6_ in _loc3_.statistics)
            {
               _loc7_ = _loc2_[_loc6_.statTypeName];
               if(!_loc7_)
               {
                  _loc7_ = new PlayerStat(_loc6_.statTypeName);
                  _loc2_[_loc6_.statTypeName] = _loc7_;
               }
               _loc7_.value = CombineStatValues(_loc7_.value,_loc6_.value,_loc7_.statTypeName);
            }
         }
         _loc4_ = new ArrayCollection();
         for each(_loc5_ in _loc2_)
         {
            _loc4_.addItem(_loc5_);
         }
         return _loc4_;
      }
      
      private function createCombinedTeamStats() : void
      {
         var _loc1_:int = int(DynamicClientConfigManager.getConfiguration(PlayerInventoryConfig.NAMESPACE,PlayerInventoryConfig.NUM_ITEMS,PlayerInventoryConfig.numItemsDefault).getInt());
         var _loc2_:PlayerParticipantStatsSummary = new PlayerParticipantStatsSummary();
         _loc2_.numItems = _loc1_;
         var _loc3_:PlayerParticipantStatsSummary = new PlayerParticipantStatsSummary();
         _loc3_.numItems = _loc1_;
         if(this.localPlayer != null)
         {
            _loc2_.summonerName = RiotResourceLoader.getString("endofgame_stats_yourteam","Your Team");
            _loc3_.summonerName = RiotResourceLoader.getString("endofgame_stats_enemyteam","Enemy Team");
         }
         else
         {
            _loc2_.summonerName = RiotResourceLoader.getString("endofgame_stats_blueteam","Blue Team");
            _loc3_.summonerName = RiotResourceLoader.getString("endofgame_stats_purpleteam","Purple Team");
         }
         if(_loc2_ == null)
         {
            _loc2_.summonerName = "**Your Team";
         }
         if(_loc3_ == null)
         {
            _loc3_.summonerName = "**Enemy Team";
         }
         if(this.localPlayer != null)
         {
            _loc2_.teamId = this.localPlayer.teamId;
         }
         else
         {
            _loc2_.teamId = Team.TEAM_ID_BLUE;
         }
         _loc3_.teamId = Team.isBlueTeam(_loc2_.teamId) ? Number(Team.TEAM_ID_PURPLE) : Number(Team.TEAM_ID_BLUE);
         _loc2_.statistics = this.combineTeamStats(this.endOfGameStats.teamPlayerParticipantStats);
         _loc3_.statistics = this.combineTeamStats(this.endOfGameStats.otherTeamPlayerParticipantStats);
         this.combinedTeamStats = new ArrayCollection();
         this.combinedTeamStats.addItem(_loc2_);
         this.combinedTeamStats.addItem(_loc3_);
      }
      
      private function createStatViews() : void
      {
         this.filterStats();
         this.createCombinedTeamStats();
      }
      
      private function filterStats() : void
      {
         var _loc2_:Sort = null;
         var _loc3_:PlayerParticipantStatsSummary = null;
         var _loc4_:PlayerParticipantStatsSummary = null;
         this.viewableStats = new Dictionary();
         this.viewableStats[RawStatType.CHAMPION_KILLS] = true;
         this.viewableStats[RawStatType.DEATHS] = true;
         this.viewableStats[RawStatType.ASSISTS] = true;
         this.viewableStats[RawStatType.MINIONS_KILLED] = true;
         this.viewableStats[RawStatType.GOLD_EARNED] = true;
         this.viewableStats[RawStatType.TOTAL_DAMAGE_DEALT] = true;
         this.viewableStats[RawStatType.TOTAL_DAMAGE_TAKEN] = true;
         this.viewableStats[RawStatType.LARGEST_KILLING_SPREE] = true;
         this.viewableStats[RawStatType.LARGEST_MULTI_KILL] = true;
         this.viewableStats[RawStatType.LARGEST_CRITICAL_STRIKE] = true;
         this.viewableStats[RawStatType.TOTAL_HEAL] = true;
         this.viewableStats[RawStatType.FIRST_BLOOD] = true;
         this.viewableStats[RawStatType.MAGIC_DAMAGE_DEALT_PLAYER] = true;
         this.viewableStats[RawStatType.PHYSICAL_DAMAGE_DEALT_PLAYER] = true;
         this.viewableStats[RawStatType.PHYSICAL_DAMAGE_TAKEN] = true;
         this.viewableStats[RawStatType.MAGIC_DAMAGE_TAKEN] = true;
         this.viewableStats[RawStatType.TOTAL_TIME_SPENT_DEAD] = true;
         this.viewableStats[RawStatType.TOTAL_DAMAGE_DEALT_TO_CHAMPIONS] = true;
         this.viewableStats[RawStatType.PHYSICAL_DAMAGE_DEALT_TO_CHAMPIONS] = true;
         this.viewableStats[RawStatType.MAGIC_DAMAGE_DEALT_TO_CHAMPIONS] = true;
         this.viewableStats[RawStatType.LEVEL] = true;
         var _loc1_:String = this.getCurrentStatsType();
         if(GameStatsType.CLASSIC == _loc1_)
         {
            this.viewableStats[RawStatType.TURRETS_KILLED] = true;
            this.viewableStats[RawStatType.BARRACKS_KILLED] = true;
            this.viewableStats[RawStatType.NEUTRAL_MINIONS_KILLED] = true;
         }
         else if(GameStatsType.DOMINION == _loc1_)
         {
            this.viewableStats[RawStatType.TOTAL_PLAYER_SCORE] = true;
            this.viewableStats[RawStatType.TEAM_OBJECTIVE] = true;
            this.viewableStats[RawStatType.NODE_CAPTURE] = true;
            this.viewableStats[RawStatType.NODE_CAPTURE_ASSIST] = true;
            this.viewableStats[RawStatType.NODE_NEUTRALIZE] = true;
            this.viewableStats[RawStatType.NODE_NEUTRALIZE_ASSIST] = true;
            this.viewableStats[RawStatType.NODE_KILL_OFFENSE] = true;
            this.viewableStats[RawStatType.NODE_KILL_DEFENSE] = true;
            this.viewableStats[RawStatType.OBJECTIVE_PLAYER_SCORE] = true;
            this.viewableStats[RawStatType.COMBAT_PLAYER_SCORE] = true;
         }
         else if(GameStatsType.ARAM == _loc1_)
         {
            this.viewableStats[RawStatType.TURRETS_KILLED] = true;
         }
         if(this.endOfGameStats.teamPlayerParticipantStats != null)
         {
            _loc2_ = new Sort();
            if(GameStatsType.CLASSIC == _loc1_)
            {
               _loc2_.compareFunction = this.friendlyTeamParticipantSorting;
            }
            else if(GameStatsType.DOMINION == _loc1_)
            {
               _loc2_.compareFunction = this.OdinParticipantSorting;
            }
            this.endOfGameStats.teamPlayerParticipantStats.sort = _loc2_;
            this.endOfGameStats.otherTeamPlayerParticipantStats.sort = _loc2_;
            this.endOfGameStats.teamPlayerParticipantStats.refresh();
            this.endOfGameStats.otherTeamPlayerParticipantStats.refresh();
            this.endOfGameStats.teamPlayerParticipantStats.sort = null;
            for each(_loc3_ in this.endOfGameStats.teamPlayerParticipantStats)
            {
               _loc3_.statistics.filterFunction = this.viewableStatsFilter;
               _loc3_.statistics.refresh();
            }
         }
         if(this.endOfGameStats.otherTeamPlayerParticipantStats != null)
         {
            for each(_loc4_ in this.endOfGameStats.otherTeamPlayerParticipantStats)
            {
               _loc4_.statistics.filterFunction = this.viewableStatsFilter;
               _loc4_.statistics.refresh();
            }
         }
      }
      
      private function fixPenalties() : void
      {
         var _loc1_:PointsPenalty = null;
         if(this.gameType == GameType.TUTORIAL_GAME)
         {
            for each(_loc1_ in this.endOfGameStats.pointsPenalties)
            {
               if(_loc1_.type == "GAME_TYPE")
               {
                  _loc1_.type = "TUTORIAL";
               }
            }
         }
      }
      
      private function friendlyTeamParticipantSorting(param1:PlayerParticipantStatsSummary, param2:PlayerParticipantStatsSummary, param3:Array = null) : int
      {
         if(this.session.summoner.name == param1.summonerName)
         {
            return -1;
         }
         if(this.session.summoner.name == param2.summonerName)
         {
            return 1;
         }
         return 0;
      }
      
      private function OdinParticipantSorting(param1:PlayerParticipantStatsSummary, param2:PlayerParticipantStatsSummary, param3:Array = null) : int
      {
         var _loc4_:PlayerStat = PlayerStat.findStat(RawStatType.TOTAL_PLAYER_SCORE,param1.statistics,true);
         var _loc5_:PlayerStat = PlayerStat.findStat(RawStatType.TOTAL_PLAYER_SCORE,param2.statistics,true);
         if(Boolean(_loc4_) && Boolean(_loc5_))
         {
            if(_loc4_.value > _loc5_.value)
            {
               return -1;
            }
            if(_loc4_.value < _loc5_.value)
            {
               return 1;
            }
            return 0;
         }
         return 0;
      }
      
      private function viewableStatsFilter(param1:PlayerStat) : Boolean
      {
         return this.viewableStats[param1.statTypeName] != null;
      }
      
      private function updateUserList() : void
      {
         var _loc1_:Dictionary = null;
         var _loc2_:RoomOccupant = null;
         var _loc3_:PlayerParticipantStatsSummary = null;
         var _loc4_:PlayerParticipantStatsSummary = null;
         if(Boolean(this.chatRoom))
         {
            _loc1_ = new Dictionary();
            for each(_loc2_ in this.chatRoom.getRoomOccupants())
            {
               _loc1_[_loc2_.displayName] = true;
            }
            for each(_loc3_ in this.endOfGameStats.teamPlayerParticipantStats)
            {
               _loc3_.inChat = _loc1_[_loc3_.summonerName] != null;
            }
            for each(_loc4_ in this.endOfGameStats.otherTeamPlayerParticipantStats)
            {
               _loc4_.inChat = _loc1_[_loc4_.summonerName] != null;
            }
         }
      }
      
      private function onChatRoomOccupantsChanged(param1:CollectionEvent) : void
      {
         var _loc2_:RoomOccupant = null;
         var _loc3_:PlayerParticipantStatsSummary = null;
         var _loc4_:RoomOccupant = null;
         var _loc5_:PlayerParticipantStatsSummary = null;
         if(param1.kind == CollectionEventKind.ADD)
         {
            for each(_loc2_ in param1.items)
            {
               _loc3_ = this.findParticipantByName(_loc2_.displayName);
               if(Boolean(_loc3_))
               {
                  _loc3_.inChat = true;
               }
            }
         }
         else if(param1.kind == CollectionEventKind.REMOVE)
         {
            for each(_loc4_ in param1.items)
            {
               _loc5_ = this.findParticipantByName(_loc4_.displayName);
               if(Boolean(_loc5_))
               {
                  _loc5_.inChat = false;
               }
            }
         }
         else
         {
            this.updateUserList();
         }
      }
      
      public function findParticipantByName(param1:String) : PlayerParticipantStatsSummary
      {
         var _loc2_:PlayerParticipantStatsSummary = null;
         var _loc3_:PlayerParticipantStatsSummary = null;
         for each(_loc2_ in this.endOfGameStats.teamPlayerParticipantStats)
         {
            if(_loc2_.summonerName == param1)
            {
               return _loc2_;
            }
         }
         for each(_loc3_ in this.endOfGameStats.otherTeamPlayerParticipantStats)
         {
            if(_loc3_.summonerName == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      private function initializeEoGTutorial() : void
      {
         if(this.tutorialEventQueue == null)
         {
            this.tutorialEventQueue = new HelpEventQueue(this.arrowedAlertController,this.glowComponentController,this.soundManager);
         }
         this.tutorialEventQueue.clear();
         this.tutorialEventQueue.pushNewState(this.onGreetingEnter,null);
         this.tutorialEventQueue.pushNewState(this.onIpRolloverEnter,null);
         this.tutorialEventQueue.pushNewState(this.onScoreboardIntro,null);
         this.tutorialEventQueue.pushNewState(this.onTeamListIntro,null);
         this.tutorialEventQueue.pushNewState(this.onIgnoreIntro,null);
         this.tutorialEventQueue.advanceState();
      }
      
      private function onGreetingEnter() : void
      {
         this.tutorialEventQueue.showConfirmationDialog("endofgame_tutorial_greeting",483,250,ArrowedAlertStyle.NO_ARROW);
         this.tutorialEventQueue.playVoiceOver(AudioKeys.EOG_TUTORIAL_GREETING);
      }
      
      private function onOverviewEnter() : void
      {
         this.tutorialEventQueue.showConfirmationDialog("endofgame_tutorial_overview",885,250,ArrowedAlertStyle.POINT_UP);
         this.tutorialEventQueue.playVoiceOver(AudioKeys.EOG_TUTORIAL_OVERVIEW);
      }
      
      private function onIpRolloverEnter() : void
      {
         this.tutorialEventQueue.showConfirmationDialog("endofgame_tutorial_ipbar",275,150,ArrowedAlertStyle.POINT_UP);
         this.tutorialEventQueue.playVoiceOver(AudioKeys.EOG_TUTORIAL_INFLUENCE_POINTS);
      }
      
      private function onScoreboardIntro() : void
      {
         this.tutorialEventQueue.showConfirmationDialog("endofgame_tutorial_scoreboard",20,140,ArrowedAlertStyle.POINT_DOWN);
         this.tutorialEventQueue.playVoiceOver(AudioKeys.EOG_TUTORIAL_SCOREBOARD);
      }
      
      private function onTeamListIntro() : void
      {
         this.tutorialEventQueue.showConfirmationDialog("endofgame_tutorial_teamlist",530,320,ArrowedAlertStyle.POINT_RIGHT);
         this.tutorialEventQueue.playVoiceOver(AudioKeys.EOG_TUTORIAL_TEAM_LIST);
      }
      
      private function onIgnoreIntro() : void
      {
         this.tutorialEventQueue.showConfirmationDialog("endofgame_tutorial_ignore",530,135,ArrowedAlertStyle.POINT_RIGHT);
         this.tutorialEventQueue.playVoiceOver(AudioKeys.EOG_TUTORIAL_IGNORE_REPORT);
      }
      
      private function onLeagueUpdateMessageRecieved(param1:LeagueUpdateItem) : void
      {
         if(!this.endOfGameStats)
         {
            this.logger.debug("EndOfGameStatsController::onLeagueUpdateMessage -> Received message too soon. Saving.");
            this._leagueMessages.push(param1);
            return;
         }
         if(this.endOfGameStats.gameId != param1.gameId)
         {
            this.logger.debug("EndOfGameStatsController::onLeagueUpdateMessage -> Received irrelevant message. Ignoring.\n{0}",param1.toString());
            return;
         }
         this._leaguesUpdateInfo = param1;
         this._leaguesUpdateInfoChangedSignal.dispatch();
      }
      
      public function reviewEndOfGameStats(param1:EndOfGameStats, param2:MatchHistorySummary, param3:String, param4:Function, param5:Boolean) : void
      {
         var _loc6_:GameMap = null;
         var _loc7_:String = null;
         this.currrentGameId = param1.gameId;
         var _loc8_:Boolean = false;
         if(param2 != null)
         {
            _loc8_ = GameStatsType.DOMINION == getStatsType(param1,param2.mapId);
         }
         if(_loc8_)
         {
            _loc6_ = this.applicationController.getGameMap(GameMap.CRYSTAL_SCAR_ID);
         }
         else
         {
            _loc6_ = this.applicationController.getGameMap(GameMap.SUMMONERS_RIFT_ID);
         }
         if(param1.gameMode == GameMode.TUTORIAL)
         {
            _loc7_ = GameType.TUTORIAL_GAME;
         }
         else
         {
            _loc7_ = GameType.NORMAL_GAME;
         }
         this.mockEoGStats = true;
         this.setEndOfGameStats(param1,param5,false,[],_loc7_,_loc6_,false);
         this.overrideHomeButtonLabel = param3;
         this.overrideHomeButtonCallback = param4;
         this.setCurrentEndOfGameState(EndOfGameStatsController.SHOW_STATS);
      }
      
      public function initializeHardcodedEndOfGame(param1:String = "CLASSIC", param2:Boolean = true, param3:Object = null, param4:Boolean = true, param5:Boolean = false, param6:Boolean = false) : void
      {
         var _loc12_:GameMap = null;
         var _loc7_:EndOfGameStats = HardcodedEndOfGameStats.createEndOfGameStats(this.session.summoner.name,this.session.summoner.sumId,param1,param2,param3,param4,param5,param6);
         this.potentialBoostIp = 100;
         this.winsLossesStats = new ArrayCollection();
         var _loc8_:AggregatedStat = new AggregatedStat();
         _loc8_.value = 75;
         _loc8_.displayName = "**Won";
         var _loc9_:AggregatedStat = new AggregatedStat();
         _loc9_.value = 22;
         _loc9_.displayName = "**Lost";
         var _loc10_:AggregatedStat = new AggregatedStat();
         _loc10_.value = 1;
         _loc10_.displayName = "**Left";
         this.winsLossesStats.addItem(_loc8_);
         this.winsLossesStats.addItem(_loc9_);
         this.winsLossesStats.addItem(_loc10_);
         this.session.summoner = this.presenceController.session.summoner;
         this.session.summonerLevelAndPoints = this.presenceController.session.summonerLevelAndPoints;
         this.session.summonerLevel = this.presenceController.session.summonerLevel;
         this.session.summonerTalentsAndPoints = this.presenceController.session.summonerTalentsAndPoints;
         this.session.summonerDefaultSpells = this.presenceController.session.summonerDefaultSpells;
         var _loc11_:LevelUpInfo = HardcodedEndOfGameStats.generateEndOfGameLevelUpInfo();
         this.levelUpInfo = _loc11_;
         if(this.gameType == GameType.TUTORIAL_GAME)
         {
            this.initializeEoGTutorial();
         }
         if(Boolean(this.applicationController))
         {
            if(_loc7_.gameMode == GameMode.DOMINION)
            {
               _loc12_ = this.applicationController.getGameMap(GameMap.CRYSTAL_SCAR_ID);
            }
            else
            {
               _loc12_ = this.applicationController.getGameMap(GameMap.SUMMONERS_RIFT_ID);
            }
         }
         else
         {
            _loc12_ = new GameMap();
         }
         this.setEndOfGameStats(_loc7_,false,true,[],_loc7_.gameType,_loc12_,false);
      }
      
      public function prepareContextualTip() : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc1_:Boolean = Boolean(DynamicClientConfigManager.getConfiguration("ContextualEducation","Enabled",false).getBoolean());
         if(Boolean(this.contextualEducationProvider) && _loc1_)
         {
            return Boolean(this.contextualEducationProvider.prepareTip(this.localPlayer,this.isVictorious,this.endOfGameStats));
         }
         return false;
      }
      
      public function get myTeamTagText() : String
      {
         if(Boolean(this.endOfGameStats) && Boolean(this.endOfGameStats.myTeamInfo))
         {
            return "[" + this.endOfGameStats.myTeamInfo.tag + "] ";
         }
         return "";
      }
      
      public function get myTeamNameText() : String
      {
         if(Boolean(this.endOfGameStats) && Boolean(this.endOfGameStats.myTeamInfo))
         {
            return this.endOfGameStats.myTeamInfo.name;
         }
         return RiotResourceLoader.getString("endofgame_stats_yourteam");
      }
      
      public function get otherTeamTagText() : String
      {
         if(Boolean(this.endOfGameStats) && Boolean(this.endOfGameStats.otherTeamInfo))
         {
            return "[" + this.endOfGameStats.otherTeamInfo.tag + "] ";
         }
         return "";
      }
      
      public function get otherTeamNameText() : String
      {
         if(Boolean(this.endOfGameStats) && Boolean(this.endOfGameStats.otherTeamInfo))
         {
            return this.endOfGameStats.otherTeamInfo.name;
         }
         return RiotResourceLoader.getString("endofgame_stats_enemyteam");
      }
      
      public function get currentStateUpdated() : ISignal
      {
         return this._currentStateUpdated;
      }
      
      public function disableKudos() : void
      {
         if(Boolean(this.endOfGameStats))
         {
            this.disableKudosForPlayerParticipants(this.endOfGameStats.teamPlayerParticipantStats);
            this.disableKudosForPlayerParticipants(this.endOfGameStats.otherTeamPlayerParticipantStats);
         }
      }
      
      public function handleKudosGiven(param1:String) : void
      {
         SuggestedPlayersProviderProxy.instance.handlePlayerHonored(param1);
      }
      
      private function disableKudosForPlayerParticipants(param1:ArrayCollection) : void
      {
         var _loc2_:PlayerParticipantStatsSummary = null;
         var _loc3_:int = 0;
         if(Boolean(param1))
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               _loc2_ = param1.getItemAt(_loc3_) as PlayerParticipantStatsSummary;
               _loc2_.kudosEnabled = false;
               _loc3_++;
            }
         }
      }
      
      public function reportPlayer(param1:PlayerParticipantStatsSummary) : void
      {
         if(this.reportPlayerAlertAction != null)
         {
            this.reportPlayerAlertAction.add(param1,this.endOfGameStats.reportGameId,this.applicationController.reportTracker);
         }
      }
      
      public function initializeGiftWindow(param1:PlayerParticipantStatsSummary, param2:Boolean, param3:Function, param4:Function) : void
      {
         var _loc5_:IPlayerSummary = new PlayerSummary(param1.userId,param1.summonerName,param1.skinName,param2,param1.level,param1.gameId,this.endOfGameStats.queueType);
         this._onGiftSent = param3;
         this._onGiftWindowClosed = param4;
         this._endOfGameGiftController.showEndOfGameGiftWindow();
         this._endOfGameGiftController.setGiftRecipient(_loc5_);
         this._endOfGameGiftController.getGiftSendSuccess().addOnce(this.onGiftSentSuccess);
         this._endOfGameGiftController.getGiftWindowClosed().addOnce(this.onGiftWindowClosed);
      }
      
      private function onGiftSentSuccess() : void
      {
         this._onGiftSent.call();
         this.cleanCallbacks();
      }
      
      private function onGiftWindowClosed() : void
      {
         this._onGiftWindowClosed.call();
         this.cleanCallbacks();
      }
      
      private function cleanCallbacks() : void
      {
         this._endOfGameGiftController.getGiftSendSuccess().remove(this.onGiftSentSuccess);
         this._endOfGameGiftController.getGiftWindowClosed().remove(this.onGiftWindowClosed);
         this._onGiftSent = null;
         this._onGiftWindowClosed = null;
      }
      
      public function canEnableGiftButton(param1:Boolean, param2:PlayerParticipantStatsSummary, param3:Boolean) : Boolean
      {
         var _loc4_:IPlayerSummary = null;
         if(!this._endOfGameGiftController || !this._endOfGameGiftEnabled)
         {
            return false;
         }
         if(param1)
         {
            _loc4_ = new PlayerSummary(param2.userId,param2.summonerName,param2.skinName,param3,param2.level,param2.gameId,this.endOfGameStats.queueType);
            return this._endOfGameGiftController.canEnableGiftButton(_loc4_);
         }
         return false;
      }
      
      public function canShowGiftButton(param1:PlayerParticipantStatsSummary, param2:Boolean) : Boolean
      {
         var _loc3_:IPlayerSummary = null;
         if(!this._endOfGameGiftController || !this._endOfGameGiftEnabled)
         {
            return false;
         }
         if(!param1.isBotPlayer() && !param1.isMe)
         {
            _loc3_ = new PlayerSummary(param1.userId,param1.summonerName,param1.skinName,param2,param1.level,param1.gameId,this.endOfGameStats.queueType);
            return this._endOfGameGiftController.canShowGiftButton(_loc3_);
         }
         return false;
      }
      
      public function getGiftToolTipText(param1:PlayerParticipantStatsSummary, param2:Boolean) : String
      {
         if(!this._endOfGameGiftController || !this._endOfGameGiftEnabled)
         {
            return "";
         }
         var _loc3_:IPlayerSummary = new PlayerSummary(param1.userId,param1.summonerName,param1.skinName,param2,param1.level,param1.gameId,this.endOfGameStats.queueType);
         return this._endOfGameGiftController.getGiftButtonToolTip(_loc3_);
      }
      
      public function getCurrentStatsType() : String
      {
         var _loc1_:int = this.gameMap != null ? int(this.gameMap.mapId) : -1;
         return getStatsType(this.endOfGameStats,_loc1_);
      }
      
      public function getTutorialGameComplete() : ISignal
      {
         return this._tutorialGameComplete;
      }
      
      [Bindable(event="propertyChange")]
      public function get chatRoom() : ChatRoom
      {
         return this._1437342803chatRoom;
      }
      
      public function set chatRoom(param1:ChatRoom) : void
      {
         var _loc2_:Object = this._1437342803chatRoom;
         if(_loc2_ !== param1)
         {
            this._1437342803chatRoom = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatRoom",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isBusy() : Boolean
      {
         return this._1180619197isBusy;
      }
      
      public function set isBusy(param1:Boolean) : void
      {
         var _loc2_:Object = this._1180619197isBusy;
         if(_loc2_ !== param1)
         {
            this._1180619197isBusy = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isBusy",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get currentEndOfGameState() : String
      {
         return this._1428783706currentEndOfGameState;
      }
      
      public function set currentEndOfGameState(param1:String) : void
      {
         var _loc2_:Object = this._1428783706currentEndOfGameState;
         if(_loc2_ !== param1)
         {
            this._1428783706currentEndOfGameState = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentEndOfGameState",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get hasLeveledUp() : Boolean
      {
         return this._1553104804hasLeveledUp;
      }
      
      public function set hasLeveledUp(param1:Boolean) : void
      {
         var _loc2_:Object = this._1553104804hasLeveledUp;
         if(_loc2_ !== param1)
         {
            this._1553104804hasLeveledUp = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hasLeveledUp",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get newTalentPoints() : int
      {
         return this._1082336943newTalentPoints;
      }
      
      public function set newTalentPoints(param1:int) : void
      {
         var _loc2_:Object = this._1082336943newTalentPoints;
         if(_loc2_ !== param1)
         {
            this._1082336943newTalentPoints = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"newTalentPoints",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get newSpells() : ArrayCollection
      {
         return this._599784949newSpells;
      }
      
      public function set newSpells(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._599784949newSpells;
         if(_loc2_ !== param1)
         {
            this._599784949newSpells = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"newSpells",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isVictorious() : Boolean
      {
         return this._744510763isVictorious;
      }
      
      public function set isVictorious(param1:Boolean) : void
      {
         var _loc2_:Object = this._744510763isVictorious;
         if(_loc2_ !== param1)
         {
            this._744510763isVictorious = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isVictorious",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get winsLossesStats() : ArrayCollection
      {
         return this._1720505207winsLossesStats;
      }
      
      public function set winsLossesStats(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1720505207winsLossesStats;
         if(_loc2_ !== param1)
         {
            this._1720505207winsLossesStats = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"winsLossesStats",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get combinedTeamStats() : ArrayCollection
      {
         return this._1922076349combinedTeamStats;
      }
      
      public function set combinedTeamStats(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1922076349combinedTeamStats;
         if(_loc2_ !== param1)
         {
            this._1922076349combinedTeamStats = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"combinedTeamStats",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Defunct]
      public function get teamBasicStats() : ArrayCollection
      {
         return this._183829682teamBasicStats;
      }
      
      public function set teamBasicStats(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._183829682teamBasicStats;
         if(_loc2_ !== param1)
         {
            this._183829682teamBasicStats = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamBasicStats",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Defunct]
      public function get otherTeamBasicStats() : ArrayCollection
      {
         return this._1081038210otherTeamBasicStats;
      }
      
      public function set otherTeamBasicStats(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1081038210otherTeamBasicStats;
         if(_loc2_ !== param1)
         {
            this._1081038210otherTeamBasicStats = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"otherTeamBasicStats",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Defunct]
      public function get combinedTeamBasicStats() : ArrayCollection
      {
         return this._242072141combinedTeamBasicStats;
      }
      
      public function set combinedTeamBasicStats(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._242072141combinedTeamBasicStats;
         if(_loc2_ !== param1)
         {
            this._242072141combinedTeamBasicStats = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"combinedTeamBasicStats",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get localPlayer() : PlayerParticipantStatsSummary
      {
         return this._1323362860localPlayer;
      }
      
      public function set localPlayer(param1:PlayerParticipantStatsSummary) : void
      {
         var _loc2_:Object = this._1323362860localPlayer;
         if(_loc2_ !== param1)
         {
            this._1323362860localPlayer = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"localPlayer",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get potentialBoostIp() : int
      {
         return this._2017389100potentialBoostIp;
      }
      
      public function set potentialBoostIp(param1:int) : void
      {
         var _loc2_:Object = this._2017389100potentialBoostIp;
         if(_loc2_ !== param1)
         {
            this._2017389100potentialBoostIp = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"potentialBoostIp",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get leaver() : Boolean
      {
         return this._1106736997leaver;
      }
      
      public function set leaver(param1:Boolean) : void
      {
         var _loc2_:Object = this._1106736997leaver;
         if(_loc2_ !== param1)
         {
            this._1106736997leaver = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leaver",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameTime() : String
      {
         return this._1769158177gameTime;
      }
      
      public function set gameTime(param1:String) : void
      {
         var _loc2_:Object = this._1769158177gameTime;
         if(_loc2_ !== param1)
         {
            this._1769158177gameTime = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameTime",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get endOfGameStats() : EndOfGameStats
      {
         return this._1803715621endOfGameStats;
      }
      
      public function set endOfGameStats(param1:EndOfGameStats) : void
      {
         var _loc2_:Object = this._1803715621endOfGameStats;
         if(_loc2_ !== param1)
         {
            this._1803715621endOfGameStats = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"endOfGameStats",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get allowedToPlayAgain() : Boolean
      {
         return this._2004135543allowedToPlayAgain;
      }
      
      public function set allowedToPlayAgain(param1:Boolean) : void
      {
         var _loc2_:Object = this._2004135543allowedToPlayAgain;
         if(_loc2_ !== param1)
         {
            this._2004135543allowedToPlayAgain = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"allowedToPlayAgain",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get showRankedElo() : Boolean
      {
         return this._1277981600showRankedElo;
      }
      
      public function set showRankedElo(param1:Boolean) : void
      {
         var _loc2_:Object = this._1277981600showRankedElo;
         if(_loc2_ !== param1)
         {
            this._1277981600showRankedElo = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showRankedElo",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isTeamOneWinner() : Boolean
      {
         return this._389594274isTeamOneWinner;
      }
      
      public function set isTeamOneWinner(param1:Boolean) : void
      {
         var _loc2_:Object = this._389594274isTeamOneWinner;
         if(_loc2_ !== param1)
         {
            this._389594274isTeamOneWinner = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isTeamOneWinner",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get overrideHomeButtonLabel() : String
      {
         return this._949787881overrideHomeButtonLabel;
      }
      
      public function set overrideHomeButtonLabel(param1:String) : void
      {
         var _loc2_:Object = this._949787881overrideHomeButtonLabel;
         if(_loc2_ !== param1)
         {
            this._949787881overrideHomeButtonLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"overrideHomeButtonLabel",_loc2_,param1));
            }
         }
      }
      
      public function set levelUpInfo(param1:LevelUpInfo) : void
      {
         var _loc2_:Object = this.levelUpInfo;
         if(_loc2_ !== param1)
         {
            this._1834022541levelUpInfo = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"levelUpInfo",_loc2_,param1));
            }
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}

