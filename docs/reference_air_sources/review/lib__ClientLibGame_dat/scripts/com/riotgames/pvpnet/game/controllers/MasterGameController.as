package com.riotgames.pvpnet.game.controllers
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.notification.DialogQueueProviderProxy;
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.platform.common.RiotServiceConfig;
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.provider.IGameProvider;
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.common.provider.IInventoryProvider;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.provider.SoundProviderProxy;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.MessageDictionary;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.common.xmpp.data.invite.PresenceStatusXML;
   import com.riotgames.platform.gameclient.Models.GameModel;
   import com.riotgames.platform.gameclient.championselection.GameEvent;
   import com.riotgames.platform.gameclient.championselection.GameSelectionData;
   import com.riotgames.platform.gameclient.championselection.IChampionSelection;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.INotificationsProvider;
   import com.riotgames.platform.gameclient.chat.domain.DockedPrompt;
   import com.riotgames.platform.gameclient.chat.event.XMPPEvent;
   import com.riotgames.platform.gameclient.controllers.IGamePreloadController;
   import com.riotgames.platform.gameclient.domain.BotParticipant;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.EndOfGameStats;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import com.riotgames.platform.gameclient.domain.IParticipant;
   import com.riotgames.platform.gameclient.domain.ObfuscatedParticipant;
   import com.riotgames.platform.gameclient.domain.PlayerChampionSelectionDTO;
   import com.riotgames.platform.gameclient.domain.PlayerCredentialsDTO;
   import com.riotgames.platform.gameclient.domain.PlayerParticipant;
   import com.riotgames.platform.gameclient.domain.Summoner;
   import com.riotgames.platform.gameclient.domain.SummonerSummary;
   import com.riotgames.platform.gameclient.domain.TeamSkinRentalDTO;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.platform.gameclient.domain.game.GameNotification;
   import com.riotgames.platform.gameclient.domain.game.GameNotificationType;
   import com.riotgames.platform.gameclient.domain.game.GameState;
   import com.riotgames.platform.gameclient.domain.game.GameType;
   import com.riotgames.platform.gameclient.domain.game.GameViewState;
   import com.riotgames.platform.gameclient.domain.game.PracticeGameManager;
   import com.riotgames.platform.gameclient.domain.game.matched.LeaverBusterLowPriorityQueueAbandoned;
   import com.riotgames.platform.gameclient.domain.game.matched.MatchSearchNotification;
   import com.riotgames.platform.gameclient.domain.game.practice.PracticeGameSearchResult;
   import com.riotgames.platform.gameclient.domain.game.practice.Team;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfig;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfigManager;
   import com.riotgames.platform.gameclient.domain.invite.InviteState;
   import com.riotgames.platform.gameclient.domain.lobby.LobbyViewState;
   import com.riotgames.platform.gameclient.domain.reroll.EogPointChangeBreakdown;
   import com.riotgames.platform.gameclient.services.GameClientAcknowledgeTypes;
   import com.riotgames.platform.gameclient.views.ViewMediator;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.clientfeaturedcontent.IClientFeaturedContentProviderProxy;
   import com.riotgames.pvpnet.game.IGamePreparationDelegate;
   import com.riotgames.pvpnet.game.alerts.IAFKFilterChampionSelectionAlertAction;
   import com.riotgames.pvpnet.game.alerts.ILegacyChampionSelectionAlertAction;
   import com.riotgames.pvpnet.game.controllers.actions.IdentifyLeaversFromAFKAction;
   import com.riotgames.pvpnet.game.controllers.actions.LeaverActionFactory;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.game.controllers.lobby.LobbyConfig;
   import com.riotgames.pvpnet.game.controllers.lobby.MatchMakingState;
   import com.riotgames.pvpnet.game.controllers.practice.CreatePracticeGameController;
   import com.riotgames.pvpnet.game.controllers.practice.JoinGameController;
   import com.riotgames.pvpnet.game.controllers.preload.LolGamePreloadController;
   import com.riotgames.pvpnet.game.controllers.tutorial.CreateTutorialGameController;
   import com.riotgames.pvpnet.game.domain.EnterChampionSelectManager;
   import com.riotgames.pvpnet.game.domain.GameAFKStatus;
   import com.riotgames.pvpnet.game.domain.GameQueueManager;
   import com.riotgames.pvpnet.game.event.UnexpectedGameErrorEvent;
   import com.riotgames.pvpnet.invite.IInviteController;
   import com.riotgames.pvpnet.invite.IInviteProvider;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import com.riotgames.pvpnet.suggestedplayers.SuggestedPlayersProviderProxy;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.alerter.AlerterProviderProxy;
   import com.riotgames.pvpnet.system.alerter.IAlerterProvider;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.pvpnet.system.maestro.IMaestroProvider;
   import com.riotgames.pvpnet.system.maestro.MaestroController;
   import com.riotgames.pvpnet.system.maestro.MaestroProviderProxy;
   import com.riotgames.pvpnet.system.messaging.MessageQueue;
   import com.riotgames.pvpnet.system.messaging.ShellDispatcher;
   import com.riotgames.pvpnet.tracking.trackers.session.ISessionMetricsProvider;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.messaging.events.MessageEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.rpc.events.ResultEvent;
   
   public class MasterGameController extends EventDispatcher implements IMasterGameController
   {
      
      private var _masterGameViewController:MasterGameViewController;
      
      public var applicationController:IAppController;
      
      public var lobbyController:ILobbyViewController;
      
      public var joinGameController:JoinGameController;
      
      public var createPracticeGameController:CreatePracticeGameController;
      
      public var createTutorialGameController:CreateTutorialGameController;
      
      public var teamSelectionController:TeamSelectionController;
      
      public var championSelectionController:IChampionSelection;
      
      public var inGameController:InGameController;
      
      public var endOfGameStatsController:EndOfGameStatsController;
      
      public var chatController:ChatController;
      
      public var dockedNotificationsProvider:INotificationsProvider;
      
      public var inviteController:IInviteController;
      
      public var gamePreloadController:LolGamePreloadController;
      
      public var enterChampionSelectManager:EnterChampionSelectManager;
      
      public var viewMediator:ViewMediator;
      
      private var _inviteGroup:InviteGroup;
      
      public var AFKFilterChampionSelectionAlertAction:IAFKFilterChampionSelectionAlertAction;
      
      public var legacyChampionSelectionAlertAction:ILegacyChampionSelectionAlertAction;
      
      private var _2108295968practiceGameManager:PracticeGameManager;
      
      [Inject]
      public var spectatorController:SpectatorController;
      
      public var inventory:IInventory;
      
      public var maestroController:IMaestroProvider = MaestroProviderProxy.instance;
      
      public var serviceProxy:ServiceProxy = ServiceProxy.instance;
      
      public var soundManager:ISoundProvider = SoundProviderProxy.instance;
      
      public var session:Session = Session.instance;
      
      public var alerter:IAlerterProvider = AlerterProviderProxy.instance;
      
      public var clientConfig:ClientConfig = ClientConfig.instance;
      
      public var servicesConfig:RiotServiceConfig = RiotServiceConfig.instance;
      
      public var shellDispatcher:ShellDispatcher = ShellDispatcher.instance;
      
      public var isShuttingDown:Boolean;
      
      public var gameAFKStatus:GameAFKStatus = new GameAFKStatus();
      
      private var _1488477984isSpectating:Boolean = false;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var messageQueue:MessageQueue;
      
      private var gameTypeConfigManager:GameTypeConfigManager = GameTypeConfigManager.instance;
      
      private var activeSubsidiaryController:ICycleViewController;
      
      private var playerRoster:Array = new Array();
      
      private var _isReconnecting:Boolean;
      
      private var summonerNameMap:Array = new Array();
      
      private var _currentGame:GameDTO;
      
      private var _pendingGamePlayerCredentials:PlayerCredentialsDTO;
      
      private var _currentGamePlayerCredentials:PlayerCredentialsDTO;
      
      private var _gamePreparationDelegate:IGamePreparationDelegate;
      
      private var _FIXMEChampionSelectionDisplay:Sprite;
      
      private var _rejoiningQueue:Boolean = false;
      
      private var _requestRejoin:Boolean = false;
      
      private var _lastPlayedGameModel:GameModel;
      
      private var _gameModel:GameModel;
      
      private var _gameModelChanged:Signal = new Signal();
      
      private var _playAgainClicked:Signal = new Signal();
      
      private var _pendingAFKChatNotification:DockedPrompt;
      
      private var shouldNavigateToHome:Boolean = true;
      
      private var leaverActionFactory:LeaverActionFactory;
      
      private var sessionMetrics:ISessionMetricsProvider;
      
      private var _isSolo:Boolean;
      
      private var _currentState:String = "";
      
      public var gameSelectionData:GameSelectionData;
      
      private var _1885851143_leavers:ArrayCollection;
      
      public var amIGameOwner:Boolean;
      
      private var _championSmallIcons:Boolean = false;
      
      private var _gameStateChanged:Signal = new Signal();
      
      private var _currentGameChanged:Signal = new Signal();
      
      public function MasterGameController()
      {
         super();
      }
      
      public function get masterGameViewController() : MasterGameViewController
      {
         return this._masterGameViewController;
      }
      
      public function set masterGameViewController(param1:MasterGameViewController) : void
      {
         this._masterGameViewController = param1;
      }
      
      public function get playAgainClicked() : ISignal
      {
         return this._playAgainClicked;
      }
      
      public function get FIXMEChampionSelectionDisplay() : Sprite
      {
         return this._FIXMEChampionSelectionDisplay;
      }
      
      public function set FIXMEChampionSelectionDisplay(param1:Sprite) : void
      {
         if(this._FIXMEChampionSelectionDisplay == param1)
         {
            return;
         }
         this._FIXMEChampionSelectionDisplay = param1;
         if(this.gameSelectionData != null)
         {
            this.gameSelectionData.parentDisplay = this.FIXMEChampionSelectionDisplay;
            this.attemptToStartChampSelect();
         }
      }
      
      private function attemptToStartChampSelect() : void
      {
         if(Boolean(this.gameSelectionData) && Boolean(this.gameSelectionData.parentDisplay != null) && Boolean(this.championSelectionController))
         {
            this.championSelectionController.addEventListener(GameEvent.ABORT_CHAMPION_SELECTION,this.onChampionSelectAborted);
            this.championSelectionController.addEventListener(GameEvent.END_CHAMPION_SELECTION,this.onChampionSelectComplete);
            this.championSelectionController.addEventListener(GameEvent.BROWSE_REQUESTED,this.onBrowseRequested);
            this.championSelectionController.addEventListener(GameEvent.COMPLETE_CHAMPION_SELECT,this.onChampionSelectComplete);
            this.championSelectionController.addEventListener(GameEvent.COMPLETE_LOAD_SCREEN,this.onLoadScreenComplete);
            this.championSelectionController.startChampionSelect(this.gameSelectionData);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameModel() : GameModel
      {
         if(!this._gameModel)
         {
            this._gameModel = new GameModel();
         }
         return this._gameModel;
      }
      
      private function set _984376919gameModel(param1:GameModel) : void
      {
         this._gameModel = param1;
         this._gameModelChanged.dispatch();
      }
      
      public function get gameModelChanged() : ISignal
      {
         return this._gameModelChanged;
      }
      
      public function resetGameModel() : void
      {
         this.gameModel.reset();
      }
      
      public function joinQueueWithMapName(param1:int, param2:Boolean, param3:String, param4:String) : void
      {
         if(LobbyConfig.instance.matchmakingState == MatchMakingState.MATCHMAKING_NOT_PARTICIPATING)
         {
            this.gameModel.difficulty = param4;
            this.gameModel.gameMap = this.applicationController.getMapByName(param3);
            this.lobbyController.selectQueue(param1,param2);
         }
      }
      
      public function cancelMatchmaking() : void
      {
         this.lobbyController.cancelMatchmaking();
      }
      
      [Bindable(event="propertyChange")]
      public function get isSolo() : Boolean
      {
         return this._isSolo;
      }
      
      private function set _1180118743isSolo(param1:Boolean) : void
      {
         this._isSolo = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get currentGame() : GameDTO
      {
         return this._currentGame;
      }
      
      private function checkForOutOfSequenceGame(param1:GameDTO) : Boolean
      {
         if(Boolean(this.currentGame))
         {
            if(this.currentGame.id == param1.id && this.currentGame.optimisticLock > param1.optimisticLock)
            {
               this.logger.warn("0012 Receivied game message out of sequence. Existing Game: " + this.currentGame.toDebugString() + "  Just received game: " + param1.toDebugString());
               return true;
            }
            if(this.currentGame.id > param1.id)
            {
               this.logger.warn("0013 Receivied message for incorrect game id. Existing Game: " + this.currentGame.toDebugString() + "  Just received game: " + param1.toDebugString());
               return true;
            }
         }
         return false;
      }
      
      public function checkForMessageHandledForCurrentGame(param1:GameDTO) : Boolean
      {
         if(this.currentGame != null && this.currentGame.id != param1.id)
         {
            if(!GameState.isInChampionSelectionState(param1.gameState))
            {
               return false;
            }
            this.logger.warn("0007 MasterGameController.currentGame<setter>: Received game message for " + param1.toDebugString() + ", but the current game is " + this.currentGame.toDebugString() + ".  The current game will be aborted and the game message will be processed since the CHAMPION_SELECTION state from the server takes precedence.");
            if(this.currentState == GameViewState.CHAMPION_SELECTION || this.currentState == GameViewState.TEAM_SELECTION)
            {
               this.cleanupAfterGameCompleteOrAborted();
            }
         }
         return true;
      }
      
      public function checkForOutOfOrderChampSelectDto(param1:GameDTO) : Boolean
      {
         if(this.currentGame != null && param1 != null && Boolean(GameState.isInChampionSelectionState(param1.gameState)) && this.currentGame.gameState == param1.gameState && param1.pickTurn < this.currentGame.pickTurn)
         {
            this.logger.warn("0008 MasterGameController.currentGame<setter>: Ignoring " + param1.gameState + " because it is an out of order DTO. Game pickturn is " + param1.pickTurn + " when our current pickturn is: " + this.currentGame.pickTurn);
            return true;
         }
         return false;
      }
      
      public function checkForTerminatedGameWithNoCurrentGame(param1:GameDTO) : Boolean
      {
         if(this.currentGame == null)
         {
            if(param1.gameState == GameState.TERMINATED || param1.gameState == GameState.TERMINATED_IN_ERROR)
            {
               return true;
            }
         }
         return false;
      }
      
      private function set _600840459currentGame(param1:GameDTO) : void
      {
         var _loc2_:DockedPrompt = null;
         var _loc4_:GameDTO = null;
         var _loc11_:Boolean = false;
         var _loc12_:IdentifyLeaversFromAFKAction = null;
         var _loc13_:ArrayCollection = null;
         var _loc14_:Boolean = false;
         var _loc15_:ArrayCollection = null;
         var _loc16_:String = null;
         var _loc17_:String = null;
         var _loc18_:* = undefined;
         var _loc19_:Boolean = false;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:GameModel = null;
         var _loc23_:String = null;
         if(param1 == null)
         {
            this._currentGame = null;
            this._currentGameChanged.dispatch(_loc4_,param1);
            return;
         }
         if(this.checkForOutOfSequenceGame(param1) || !this.checkForMessageHandledForCurrentGame(param1) || this.checkForOutOfOrderChampSelectDto(param1) || this.checkForTerminatedGameWithNoCurrentGame(param1))
         {
            return;
         }
         var _loc3_:Boolean = false;
         _loc4_ = this.currentGame;
         if(param1 != null)
         {
            _loc11_ = this.currentGame == null || this.currentState != GameViewState.TEAM_SELECTION && param1.gameState == GameViewState.TEAM_SELECTION;
            this.practiceGameManager.beginExpiryCountDown(_loc11_,param1);
         }
         this._lastPlayedGameModel = this.gameModel.copy();
         var _loc5_:String = "";
         var _loc6_:ArrayCollection = null;
         var _loc7_:Boolean = true;
         var _loc8_:Boolean = true;
         var _loc9_:Boolean = false;
         this.gameAFKStatus.gameTerminatedFromAFK = false;
         this.gameAFKStatus.waitingToRejoinTeamLobbyFromAFKReinvite = false;
         if(param1.glmHost != null && param1.glmPort != 0 && !this.serviceProxy.gameZoneGameService.isGameZoneMatch(param1.glmHost,param1.glmPort,param1.glmSecurePort))
         {
            this.serviceProxy.gameZoneGameService.setGameServiceZone(param1.glmHost,param1.glmPort,param1.glmSecurePort);
         }
         var _loc10_:ConfigurationModel = DynamicClientConfigManager.getConfiguration("GameInvites","ServiceEnabled",true,null);
         switch(this.currentState)
         {
            case GameViewState.NO_GAME:
               if(GameState.isInChampionSelectionState(param1.gameState))
               {
                  this.initializeForNewGame();
                  this.gameType = param1.gameType;
                  _loc5_ = param1.gameState;
               }
               else if(param1.gameState == GameState.TEAM_SELECTION)
               {
                  _loc5_ = param1.gameState;
               }
               break;
            case GameViewState.JOIN_GAME:
               if(param1.gameState == GameState.TEAM_SELECTION)
               {
                  _loc5_ = param1.gameState;
               }
               break;
            case GameViewState.CREATE_GAME:
               if(param1.gameState == GameState.TEAM_SELECTION)
               {
                  _loc5_ = param1.gameState;
               }
               break;
            case GameViewState.WAIT_FOR_GAME:
               this.removeAFKFilterChampionSelectionAction();
               if(GameState.isInChampionSelectionState(param1.gameState))
               {
                  _loc5_ = GameViewState.WAIT_FOR_GAME_AFTER_MATCH;
                  this.chatController.leaveMatchmakingQueueChatRoom();
               }
               else if(param1.gameState == GameState.JOINING_CHAMP_SELECT)
               {
                  this.gameAFKStatus.acceptedPoppedGame = false;
                  this.applicationController.restore();
                  this.soundManager.play(AudioKeys.SOUND_MATCHMAKING_QUEUED);
                  this.chatController.leaveMatchmakingQueueChatRoom();
                  _loc5_ = GameViewState.WAIT_FOR_JOINING_GAME;
                  this.addAFKFilterChampionSelectionAlertAction(param1);
               }
               else if(param1.gameState == GameState.TERMINATED || param1.gameState == GameState.TERMINATED_IN_ERROR)
               {
                  return;
               }
               break;
            case GameViewState.WAIT_FOR_JOINING_GAME:
               if(param1.gameState == GameState.JOINING_CHAMP_SELECT)
               {
                  this.addAFKFilterChampionSelectionAlertAction(param1);
                  _loc7_ = false;
               }
               else if(GameState.isInChampionSelectionState(param1.gameState))
               {
                  this.removeAFKFilterChampionSelectionAction();
                  _loc5_ = GameViewState.WAIT_FOR_GAME_AFTER_MATCH;
               }
               else if(param1.gameState == GameState.TERMINATED)
               {
                  this.gameAFKStatus.gameTerminatedFromAFK = true;
                  this.gameAFKStatus.initialTimerValue = Math.min(10,param1.joinTimerDuration - 2);
                  if(this.isSolo)
                  {
                     if(this.gameAFKStatus.respondedToPoppedGame && this.gameAFKStatus.acceptedPoppedGame)
                     {
                        this._rejoiningQueue = true;
                        this.setLeaverChatNotification(RiotResourceLoader.getString("ecsp_matchDeclinedNotification"));
                     }
                     else if(!(this.gameAFKStatus.respondedToPoppedGame && !this.gameAFKStatus.acceptedPoppedGame))
                     {
                        if(!this.gameAFKStatus.respondedToPoppedGame)
                        {
                           this.setLeaverChatNotification(RiotResourceLoader.getString("ecsp_wasAFKNotification"));
                        }
                     }
                     this.addAFKFilterChampionSelectionAlertAction(param1,true);
                  }
                  else
                  {
                     _loc12_ = this.leaverActionFactory.getIdentifyLeaversFromAFKAction(param1);
                     _loc12_.invoke();
                     _loc13_ = _loc12_.leavers;
                     _loc14_ = Boolean(this.inviteController.arePlayersOnTeam(_loc13_));
                     if(!_loc14_)
                     {
                        this.setLeaverChatNotification(RiotResourceLoader.getString("ecsp_matchDeclinedNotification"));
                        this.addAFKFilterChampionSelectionAlertAction(param1,true);
                     }
                     else
                     {
                        _loc15_ = this.inviteController.getPlayersOnTeam(_loc13_);
                        _loc16_ = this.convertLeaversArrayToString(_loc15_);
                        this.setLeaverChatNotification(RiotResourceLoader.getString("ecsp_teamPlayersDidntAccept",null,[_loc16_]));
                        if(_loc10_.getBoolean())
                        {
                           this.updateAFKFilterForLobbyReturn();
                        }
                        else if(this._inviteGroup.isOwner)
                        {
                           _loc9_ = true;
                           this.removeAFKFilterChampionSelectionAction();
                        }
                        else
                        {
                           this.updateAFKFilterForLobbyReturn();
                        }
                     }
                     this._rejoiningQueue = !_loc14_;
                     this.gameAFKStatus.waitingToRejoinTeamLobbyFromAFKReinvite = _loc14_;
                  }
                  _loc3_ = true;
                  this.shouldNavigateToHome = false;
               }
               break;
            case GameViewState.WAIT_FOR_GAME_AFTER_MATCH:
               if(GameState.isInChampionSelectionState(param1.gameState))
               {
                  _loc7_ = false;
               }
               else if(param1.gameState == GameState.TERMINATED)
               {
                  this.removeLegacyChampionSelectionAction();
                  this.removeAFKFilterChampionSelectionAction();
                  _loc6_ = this.identifyLeavers(param1);
                  _loc3_ = true;
                  this._rejoiningQueue = this.isSolo || !this.inviteController.arePlayersOnTeam(_loc6_);
                  this.gameAFKStatus.waitingToRejoinTeamLobbyFromAFKReinvite = !this._isSolo && Boolean(this.inviteController.arePlayersOnTeam(_loc13_));
               }
               break;
            case GameViewState.TEAM_SELECTION:
               if(param1.gameState == GameState.TEAM_SELECTION)
               {
                  _loc5_ = param1.gameState;
               }
               else if(GameState.isInChampionSelectionState(param1.gameState))
               {
                  _loc5_ = param1.gameState;
                  this.applicationController.restore();
               }
               else if(param1.gameState == GameState.TERMINATED_IN_ERROR)
               {
                  this.shellDispatcher.dispatchEvent(new UnexpectedGameErrorEvent(UnexpectedGameErrorEvent.GAME_TERMINATED_IN_ERROR));
                  _loc3_ = true;
               }
               else if(param1.gameState == GameState.TERMINATED && param1.gameType == GameType.PRACTICE_GAME && param1.terminatedCondition == "LOBBY_EXPIRED")
               {
                  this.showPracticeGameExpiredDialog();
               }
               else if(param1.gameState == GameState.TERMINATED && param1.gameType == GameType.PRACTICE_GAME && param1.terminatedCondition == "LAST_PLAYER_LEFT")
               {
                  _loc2_ = new DockedPrompt();
                  _loc2_.leftButtonLabel = ResourceManager.getInstance().getString("resources","common_button_close");
                  _loc17_ = ResourceManager.getInstance().getString("resources","practiceGame_gameLobbyVacated");
                  _loc2_.message = _loc17_;
                  _loc2_.title = ResourceManager.getInstance().getString("resources","practiceGame_expiry_alert");
                  _loc2_.timeStamp = new Date();
                  this.dockedNotificationsProvider.showDockedPrompt(_loc2_);
               }
               this.updateInvitesWithNewGameDTO(param1);
               break;
            case GameViewState.CHAMPION_SELECTION:
               if(param1.gameState == GameState.START_REQUESTED)
               {
                  _loc5_ = param1.gameState;
               }
               else if(param1.gameState == GameState.TEAM_SELECTION)
               {
                  this.rebuildCustomGameAfterChampionSelect(param1);
                  _loc5_ = GameState.TEAM_SELECTION;
               }
               else if(GameState.isInChampionSelectionState(param1.gameState))
               {
                  _loc5_ = GameState.GameStateToGameViewState(param1.gameState);
               }
               else if(param1.gameState == GameState.TERMINATED)
               {
                  _loc3_ = true;
                  if(param1.gameType == GameType.PRACTICE_GAME && param1.terminatedCondition == "LOBBY_EXPIRED")
                  {
                     this.showPracticeGameExpiredDialog();
                  }
                  if(param1.gameType != GameType.PRACTICE_GAME)
                  {
                     _loc12_ = this.leaverActionFactory.getIdentifyLeaversFromAFKAction(param1);
                     _loc12_.invoke();
                     _loc6_ = _loc12_.leavers;
                     _loc18_ = false;
                     if(_loc6_.length == 0)
                     {
                        _loc6_ = this.identifyLeavers(param1);
                        if(!this.isSolo)
                        {
                           _loc18_ = this.isInviteGroupOwnerInList(_loc6_);
                        }
                     }
                     _loc3_ = true;
                     this.gameAFKStatus.gameTerminatedFromAFK = true;
                     if(this.isSolo)
                     {
                        _loc19_ = this.checkIfLocalPlayerLeft(_loc6_);
                        if(!_loc19_)
                        {
                           this.logger.debug("MasterGameController.currentGame<setter>: AFK detection(ChampSelect): Requeueing Solo Player.");
                        }
                        this._rejoiningQueue = !_loc19_;
                        this.notifySoloQueueOfChampSelectDissolution(_loc19_);
                     }
                     else
                     {
                        _loc15_ = this.inviteController.getPlayersOnTeam(_loc6_);
                        if(_loc15_.length == 0)
                        {
                           this.logger.debug("MasterGameController.currentGame<setter>: AFK detection(ChampSelect): Everyone on this team was ready. Requeueing team.");
                           this._rejoiningQueue = true;
                           this.gameAFKStatus.waitingToRejoinTeamLobbyFromAFKReinvite = false;
                        }
                        else
                        {
                           _loc9_ = this.handleTeamQueueChampSelectDissolution(_loc18_);
                           this._rejoiningQueue = false;
                        }
                        this.notifyTeamQueueOfChampSelectDissolution(_loc15_);
                     }
                     this.displayPendingAFKChatNotification();
                  }
               }
               break;
            case GameViewState.CAP_STATE:
               _loc7_ = false;
               if(param1.gameState == GameState.START_REQUESTED)
               {
                  _loc5_ = param1.gameState;
               }
               this.cancelInvite();
               break;
            case GameViewState.START_REQUESTED:
               if(param1.gameState == GameState.START_REQUESTED)
               {
                  _loc5_ = param1.gameState;
               }
            case GameViewState.IN_PROGRESS:
            case GameViewState.PLAYING_GAME:
               if(param1.gameState == GameState.FAILED_TO_START)
               {
                  this.shellDispatcher.dispatchEvent(new UnexpectedGameErrorEvent(UnexpectedGameErrorEvent.GAME_FAILED_TO_START));
                  this.cleanupAfterGameCompleteOrAborted();
                  this.changePresence(PresenceStatusXML.GAME_STATUS_OUT_OF_GAME);
                  _loc3_ = true;
               }
               else if(param1.gameState == GameState.TERMINATED)
               {
                  if(this.currentState == GameState.START_REQUESTED)
                  {
                     _loc6_ = this.identifyLeavers(param1);
                     _loc3_ = true;
                     this._requestRejoin = this._rejoiningQueue = this.isSolo || !this.inviteController.arePlayersOnTeam(_loc6_);
                  }
                  else
                  {
                     _loc5_ = GameViewState.GAME_OVER;
                     this.changePresence(PresenceStatusXML.GAME_STATUS_OUT_OF_GAME);
                     this.populateSummonerNameMap(param1);
                  }
               }
               else if(param1.gameState == GameState.TERMINATED_IN_ERROR)
               {
                  this.shellDispatcher.dispatchEvent(new UnexpectedGameErrorEvent(UnexpectedGameErrorEvent.GAME_TERMINATED_IN_ERROR));
                  this.cleanupAfterGameCompleteOrAborted();
                  this.changePresence(PresenceStatusXML.GAME_STATUS_OUT_OF_GAME);
                  _loc3_ = true;
               }
               this.cancelInvite();
               break;
            case GameViewState.TUTORIAL_GAME:
               _loc8_ = false;
               if(param1.gameState == GameState.TERMINATED)
               {
                  this.lobbyController.requestLobbyState(LobbyViewState.LOBBY_LANDING_STATE);
               }
               else if(Boolean(GameState.isInChampionSelectionState(param1.gameState)) || param1.gameState == GameState.START_REQUESTED)
               {
                  _loc5_ = GameViewState.CHAMPION_SELECTION;
               }
               break;
            default:
               this.logger.warn("0009 MasterGameController.currentGame<setter>: Invalid state transition from " + this.currentState + " to " + _loc5_);
               return;
         }
         if(_loc5_ == GameViewState.JOIN_GAME)
         {
            if(this.gameType == GameType.NORMAL_GAME)
            {
               this.startNormalGameFlow(this.isSolo);
               this.masterGameViewController.handleSelectMapContinue();
            }
            else if(this.gameType == GameType.COOP_VS_AI)
            {
               this.startCoopVsAIGameFlow(this.isSolo);
               this.masterGameViewController.handleSelectMapContinue();
            }
            else if(this.gameType == GameType.PRACTICE_GAME)
            {
               this.startPracticeGameFlowAtJoinGame();
            }
            else if(this.gameType == GameType.RANKED_GAME_SOLO || this.gameType == GameType.RANKED_GAME_PREMADE)
            {
               this.startRankedGameFlow(this.isSolo);
               this.masterGameViewController.handleSelectMapContinue();
            }
         }
         else if(_loc5_ == "" && _loc7_ && !_loc3_)
         {
            this.logger.warn("0010 MasterGameController.currentGame<setter>: Invalid state transition from " + this.currentState + " to " + _loc5_ + " based on new game state of " + param1.gameState);
         }
         else
         {
            this._currentGame = param1;
            this.startGameIfGamePending();
            this._currentGameChanged.dispatch(_loc4_,param1);
            if(_loc7_)
            {
               if(param1.ownerSummary != null)
               {
                  _loc20_ = Number(this.session.accountSummary.accountId);
                  _loc21_ = Number(param1.ownerSummary.accountId);
                  this.amIGameOwner = _loc21_ == _loc20_;
               }
               this.currentState = GameState.GameStateToGameViewState(_loc5_);
               if(_loc8_ && GameState.TEAM_SELECTION == this.currentGame.gameState)
               {
                  this.updatePlayerRosterAndChampionSelections();
               }
               if(!this.gameAFKStatus.gameTerminatedFromAFK)
               {
                  this.setLeaversAndShowDialog(_loc6_,Boolean(param1) && param1.gameState == GameState.TERMINATED,this._rejoiningQueue);
               }
            }
         }
         if(_loc3_)
         {
            if(this._rejoiningQueue)
            {
               _loc22_ = this.gameModel.copy();
            }
            this.cancelGameFlow();
         }
         if(this._rejoiningQueue)
         {
            if(Boolean(_loc22_))
            {
               this.gameModel = _loc22_;
            }
            this.rejoinQueue(this._requestRejoin);
            this.initializeCycle();
         }
         if(Boolean(param1))
         {
            _loc23_ = param1.getTeamNameForSummoner(this.session.summoner.name);
            this.isSpectating = _loc23_ == Team.SPECTATOR;
            if(this.isSpectating)
            {
               this.clientConfig.disconnect_logging = false;
            }
         }
         else
         {
            this.isSpectating = false;
            this.clientConfig.disconnect_logging = true;
         }
         if(Boolean(_loc10_.getBoolean()) && this.gameAFKStatus.gameTerminatedFromAFK && this.gameAFKStatus.waitingToRejoinTeamLobbyFromAFKReinvite)
         {
            this.inviteController.setInviteGroupCancel(true);
            this.removeAFKFilterChampionSelectionAction();
            this.gameAFKStatus.waitingToRejoinTeamLobbyFromAFKReinvite = false;
         }
         else if(this.gameAFKStatus.gameTerminatedFromAFK && _loc9_)
         {
            this.displayPendingAFKChatNotification();
            this.restartMatchmakingGame(this.gameType,this.inviteController.getReInviteList());
         }
      }
      
      private function setLeaverChatNotification(param1:String) : void
      {
         var _loc2_:* = new DockedPrompt();
         _loc2_.leftButtonLabel = ResourceManager.getInstance().getString("resources","common_button_close");
         _loc2_.message = param1;
         _loc2_.title = ResourceManager.getInstance().getString("resources","practiceGame_leaver_title");
         _loc2_.timeStamp = new Date();
         this._pendingAFKChatNotification = _loc2_;
      }
      
      private function notifyTeamQueueOfChampSelectDissolution(param1:ArrayCollection) : void
      {
         var _loc2_:String = null;
         if(param1.length == 0)
         {
            this.setLeaverChatNotification(RiotResourceLoader.getString("ecsp_otherPlayerDidntPickChampion"));
         }
         else
         {
            _loc2_ = this.convertLeaversArrayToString(param1);
            this.setLeaverChatNotification(RiotResourceLoader.getString("ecsp_teamPlayersDidntPickChampion",null,[_loc2_]));
         }
      }
      
      private function notifySoloQueueOfChampSelectDissolution(param1:Boolean) : void
      {
         if(param1)
         {
            this.setLeaverChatNotification(RiotResourceLoader.getString("ecsp_soloPlayerDidntPickChampion"));
         }
         else
         {
            this.setLeaverChatNotification(RiotResourceLoader.getString("ecsp_otherPlayerDidntPickChampion"));
         }
      }
      
      private function handleTeamQueueChampSelectDissolution(param1:Boolean) : Boolean
      {
         var _loc2_:Boolean = false;
         this.gameAFKStatus.waitingToRejoinTeamLobbyFromAFKReinvite = true;
         if(this._inviteGroup.isOwner)
         {
            _loc2_ = true;
         }
         else if(param1)
         {
            this.gameAFKStatus.waitingToRejoinTeamLobbyFromAFKReinvite = false;
         }
         return _loc2_;
      }
      
      private function isInviteGroupOwnerInList(param1:ArrayCollection) : Boolean
      {
         var _loc2_:PlayerParticipant = null;
         var _loc3_:IParticipant = null;
         for each(_loc3_ in param1)
         {
            if(_loc3_ is PlayerParticipant)
            {
               _loc2_ = _loc3_ as PlayerParticipant;
               if(Boolean(this._inviteGroup.ownerParticipant) && _loc2_.summonerId == this._inviteGroup.ownerParticipant.summonerId)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private function checkIfLocalPlayerLeft(param1:ArrayCollection) : Boolean
      {
         var _loc3_:IParticipant = null;
         var _loc4_:PlayerParticipant = null;
         var _loc2_:Boolean = false;
         for each(_loc3_ in param1)
         {
            _loc4_ = _loc3_ as PlayerParticipant;
            if(_loc4_ != null && _loc4_.accountId == this.session.accountSummary.accountId)
            {
               _loc2_ = true;
               break;
            }
         }
         return _loc2_;
      }
      
      private function showPracticeGameExpiredDialog() : void
      {
         var _loc2_:String = null;
         var _loc1_:DockedPrompt = new DockedPrompt();
         _loc1_.leftButtonLabel = ResourceManager.getInstance().getString("resources","common_button_ok");
         _loc2_ = ResourceManager.getInstance().getString("resources","practiceGame_gameLobbyExpired");
         _loc1_.message = _loc2_;
         _loc1_.title = ResourceManager.getInstance().getString("resources","practiceGame_expiry_alert");
         _loc1_.timeStamp = new Date();
         this.dockedNotificationsProvider.showDockedPrompt(_loc1_);
      }
      
      private function convertLeaversArrayToString(param1:ArrayCollection) : String
      {
         var _loc2_:String = new String();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ += param1[_loc3_].summonerName;
            _loc2_ += _loc3_ == param1.length - 1 ? "." : ", ";
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function rebuildCustomGameAfterChampionSelect(param1:GameDTO) : void
      {
         this.updateInvitesWithNewGameDTO(param1);
      }
      
      private function updateInvitesWithNewGameDTO(param1:GameDTO) : void
      {
         var _loc2_:ArrayCollection = this.identifyLeavers(param1);
         var _loc3_:* = param1 && param1.ownerSummary && this.session.accountSummary.accountId == param1.ownerSummary.accountId;
         this.inviteController.updateCustomGame(param1,this.currentGame,_loc3_,_loc2_);
         if(Boolean(_loc3_))
         {
            this.changePresence(PresenceStatusXML.GAME_STATUS_HOSTING_PRACTICE_GAME);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get currentState() : String
      {
         return this._currentState;
      }
      
      public function getMatchmakingState() : String
      {
         return LobbyConfig.instance.matchmakingState;
      }
      
      private function set _1457822360currentState(param1:String) : void
      {
         var _loc2_:ICycleViewController = this.activeSubsidiaryController;
         switch(param1)
         {
            case GameViewState.JOIN_GAME:
               this.activeSubsidiaryController = this.joinGameController;
               if(this.sessionMetrics != null)
               {
                  this.sessionMetrics.setGameStateTo_JoinGame();
               }
               break;
            case GameViewState.CREATE_GAME:
               this.activeSubsidiaryController = this.createPracticeGameController;
               this.changePresence(PresenceStatusXML.GAME_STATUS_HOSTING_PRACTICE_GAME);
               if(this.sessionMetrics != null)
               {
                  this.sessionMetrics.setGameStateTo_CreateGame();
               }
               break;
            case GameViewState.TUTORIAL_GAME:
               this.activeSubsidiaryController = this.createTutorialGameController;
               this.changePresence(PresenceStatusXML.GAME_STATUS_TUTORIAL);
               if(this.sessionMetrics != null)
               {
                  this.sessionMetrics.setGameStateTo_TutorialGame();
               }
               break;
            case GameViewState.TEAM_SELECTION:
               this.activeSubsidiaryController = this.teamSelectionController;
               if(this._inviteGroup.inviteState == InviteState.INVITOR || this.amIGameOwner)
               {
                  this.changePresence(PresenceStatusXML.GAME_STATUS_HOSTING_PRACTICE_GAME);
               }
               else
               {
                  this.changePresence(PresenceStatusXML.GAME_STATUS_TEAM_SELECT);
               }
               if(this.sessionMetrics != null)
               {
                  this.sessionMetrics.setGameStateTo_TeamSelection();
               }
               break;
            case GameViewState.WAIT_FOR_GAME:
               this.activeSubsidiaryController = this.masterGameViewController;
               if(this._currentState == GameViewState.JOIN_QUEUE || this._currentState == GameViewState.GAME_OVER || this._currentState == GameViewState.NO_GAME)
               {
                  this.lobbyController.requestLobbyState(LobbyViewState.LOBBY_LANDING_STATE);
               }
               if(!this.isSolo && this._inviteGroup.chatRoom == null)
               {
                  this.masterGameViewController.initChatRoomForArrangingGame();
               }
               if(this.sessionMetrics != null)
               {
                  this.sessionMetrics.setGameStateTo_WaitForGame();
               }
               break;
            case GameViewState.WAIT_FOR_GAME_AFTER_MATCH:
               if(this.gameType == GameType.RANKED_GAME_SOLO || this.gameType == GameType.RANKED_GAME_PREMADE || this._currentState == GameViewState.WAIT_FOR_JOINING_GAME)
               {
                  setTimeout(this.enterChampionSelect,10);
               }
               else
               {
                  this.enterChampionSelectManager.initializeTimer();
                  this.addLegacyEnterChampionSelectionAction();
                  this.applicationController.restore();
                  this.soundManager.play(AudioKeys.SOUND_MATCHMAKING_QUEUED);
               }
               this._inviteGroup.isGroupOpenToMembers = false;
               this.masterGameViewController.leaveChatRoom();
               if(this.sessionMetrics != null)
               {
                  this.sessionMetrics.setGameStateTo_WaitForGameAfterMatch();
               }
               break;
            case GameViewState.CHAMPION_SELECTION:
               if(this._currentState != GameViewState.WAIT_FOR_GAME_AFTER_MATCH)
               {
                  this._inviteGroup.isGroupOpenToMembers = false;
               }
               if(this.sessionMetrics != null)
               {
                  this.sessionMetrics.setGameStateTo_ChampionSelection();
               }
               IClientFeaturedContentProviderProxy.instance.closeFromGameViewStateChampionSelection();
            case GameViewState.START_REQUESTED:
               this.leavers = null;
               if(this._currentState == GameViewState.WAIT_FOR_GAME_AFTER_MATCH)
               {
                  this.restoreNewGameViewConfiguration();
               }
               if(this._currentState != GameViewState.CHAMPION_SELECTION && this._currentState != GameViewState.START_REQUESTED && (this.gameType != GameType.TUTORIAL_GAME || this.gameType == GameType.TUTORIAL_GAME && this.createTutorialGameController.isBasicTutorial == false))
               {
                  this.activeSubsidiaryController = null;
                  this.startChampionSelect();
               }
               this.practiceGameManager.endExpiryCountDown();
               this.cancelInvite();
               if(this.sessionMetrics != null)
               {
                  this.sessionMetrics.setGameStateTo_StartRequested();
               }
               break;
            case GameViewState.IN_PROGRESS:
               if(this.sessionMetrics != null)
               {
                  this.sessionMetrics.setGameStateTo_InProgress();
               }
            case GameViewState.PLAYING_GAME:
               this.cancelInvite();
               this.practiceGameManager.endExpiryCountDown();
               this.activeSubsidiaryController = this.inGameController;
               this.applicationController.minimizeToTray();
               if(this.gameType != GameType.TUTORIAL_GAME)
               {
                  if(this.isSpectating)
                  {
                     this.changePresenceToSpectating(this.spectatorController.dropInSpectateGameID,this.spectatorController.featuredGameObject);
                  }
                  else
                  {
                     this.changePresence(PresenceStatusXML.GAME_STATUS_IN_GAME);
                  }
               }
               else
               {
                  this.changePresence(PresenceStatusXML.GAME_STATUS_TUTORIAL);
               }
               if(this.sessionMetrics != null)
               {
                  this.sessionMetrics.setGameStateTo_PlayingGame();
               }
               break;
            case GameViewState.GAME_OVER:
               this.changePresence(PresenceStatusXML.GAME_STATUS_OUT_OF_GAME);
               this.activeSubsidiaryController = this.endOfGameStatsController;
               this.checkRetrieveEndOfGameStats();
               this.endOfGameStatsController.currrentGameId = Boolean(this.currentGame) ? Number(this.currentGame.id) : -1;
               if(this.sessionMetrics != null)
               {
                  this.sessionMetrics.setGameStateTo_GameOver();
               }
               break;
            case GameViewState.JOIN_QUEUE:
               this.activeSubsidiaryController = this.masterGameViewController;
               if(!this.isSolo)
               {
                  this.masterGameViewController.initChatRoomForArrangingGame();
               }
               if(Boolean(this._inviteGroup) && this._inviteGroup.inviteState != InviteState.INVITEE)
               {
                  switch(this.gameType)
                  {
                     case GameType.NORMAL_GAME:
                        this.changePresence(PresenceStatusXML.GAME_STATUS_HOSTING_NORMAL_GAME);
                        break;
                     case GameType.RANKED_GAME_PREMADE:
                        this.changePresence(PresenceStatusXML.GAME_STATUS_HOSTING_RANKED_GAME);
                        break;
                     case GameType.COOP_VS_AI:
                        this.changePresence(PresenceStatusXML.GAME_STATUS_HOSTING_COOP_VS_AI_GAME);
                  }
               }
               if(this.sessionMetrics != null)
               {
                  this.sessionMetrics.setGameStateTo_JoinQueue();
               }
               IClientFeaturedContentProviderProxy.instance.enteredMatchmakingQueue();
               break;
            case GameViewState.NO_GAME:
               this.activeSubsidiaryController = null;
               this.practiceGameManager.endExpiryCountDown();
               if(this.createTutorialGameController.isBasicTutorial != true)
               {
                  this.lobbyController.requestLobbyState(LobbyViewState.LOBBY_LANDING_STATE);
               }
               if(this.sessionMetrics != null)
               {
                  this.sessionMetrics.setGameStateTo_NoGame();
               }
               break;
            case GameViewState.CAP_STATE:
               this.changePresence(PresenceStatusXML.GAME_STATUS_IN_TEAM_BUILDER_LOBBY);
               break;
            default:
               this.activeSubsidiaryController = null;
         }
         if(this._inviteGroup.inviteState == InviteState.NONE && this._currentState == GameViewState.JOIN_GAME && param1 == GameViewState.TEAM_SELECTION)
         {
            if(this.amIGameOwner)
            {
               this._inviteGroup.gamePassword = this.createPracticeGameController.game.gamePassword;
               this.changePresence(PresenceStatusXML.GAME_STATUS_HOSTING_PRACTICE_GAME);
               this.inviteController.setInviteGroupAsInvitor(GameType.PRACTICE_GAME,this.currentGame.id,this.gameMap.mapId,"");
            }
            else
            {
               this.inviteController.joinPracticeGame(this.currentGame.ownerSummary.summonerName,this.chatController.currentUserDisplayName,this.chatController.currentUserIconID);
            }
         }
         else if((this._currentState == GameViewState.TEAM_SELECTION || this._currentState == GameViewState.CREATE_GAME) && (param1 == GameViewState.JOIN_GAME || param1 == GameViewState.NO_GAME))
         {
            this.changePresence(PresenceStatusXML.GAME_STATUS_OUT_OF_GAME);
            this.quitGame();
         }
         else if(this._currentState == GameViewState.CREATE_GAME && param1 == GameViewState.TEAM_SELECTION)
         {
            this._inviteGroup.gamePassword = this.createPracticeGameController.game.gamePassword;
            this.changePresence(PresenceStatusXML.GAME_STATUS_HOSTING_PRACTICE_GAME);
            this.inviteController.setInviteGroupAsInvitor(GameType.PRACTICE_GAME,this.currentGame.id,this.gameMap.mapId,"");
         }
         if(this.activeSubsidiaryController != _loc2_)
         {
            if(_loc2_ != null)
            {
               _loc2_.deactivate();
            }
            if(this.activeSubsidiaryController != null)
            {
               this.activeSubsidiaryController.activate();
            }
         }
         if(param1 == null)
         {
            throw new Error("Trying to set state to null");
         }
         var _loc3_:String = this._currentState;
         this._currentState = param1;
         this._gameStateChanged.dispatch(_loc3_,param1);
         this.updateLobbyForNewState();
      }
      
      private function checkRetrieveEndOfGameStats() : void
      {
         var _loc1_:String = this.spectatorController.dropInSpectateGameID;
         if(_loc1_ != null && _loc1_.length > 0)
         {
            this.endOfGameStatsController.currentEndOfGameState = EndOfGameStatsController.WAITING_FOR_STATS;
            this.spectatorController.retrieveEndOfGameStats();
         }
      }
      
      public function startChampionSelect() : void
      {
         this.gameSelectionData = new GameSelectionData();
         this.gameSelectionData.arrowedAlertController = this.endOfGameStatsController.arrowedAlertController;
         this.gameSelectionData.game = this.currentGame;
         this.gameSelectionData.gameMap = this.gameMap;
         this.gameSelectionData.gameTypeConfig = this.gameTypeConfigManager.getGameTypeConfig(this.currentGame.gameTypeConfigId);
         this.gameSelectionData.glowController = this.endOfGameStatsController.glowComponentController;
         this.gameSelectionData.locale = this.clientConfig.locale;
         this.gameSelectionData.isSpectating = this.isSpectating;
         this.gameSelectionData.session = this.session;
         this.gameSelectionData.playerRoster = this.playerRoster;
         this.gameSelectionData.chatController = this.chatController;
         this.gameSelectionData.allowFreeChampions = this.gameModel.allowFreeChampions;
         this.gameSelectionData.parentDisplay = this.FIXMEChampionSelectionDisplay;
         if(this.gamePreloadController == null)
         {
            this.gamePreloadController = new LolGamePreloadController(this.clientConfig.preloadGameClient,this.session.summoner,this.maestroController,this.servicesConfig.startMaestro);
         }
         this.gamePreloadController.startGamePreload(this.gameSelectionData);
         if(this.clientConfig.preloadGameClient)
         {
            this.applicationController.removeGameCrashCallbacks();
         }
         this.attemptToStartChampSelect();
      }
      
      private function onBrowseRequested(param1:GameEvent) : void
      {
         if(param1.info != null && param1.info is String && param1.info != "")
         {
            this.lobbyController.searchForSummoner(param1.info as String,null,true);
         }
         else
         {
            this.lobbyController.requestLobbyState(LobbyViewState.LOBBY_LANDING_STATE);
         }
         LobbyConfig.instance.matchmakingState = MatchMakingState.MATCHMAKING_SPECTATING_CHAMP_SELECT;
      }
      
      private function cancelChampionSelection(param1:GameDTO) : void
      {
         this.gameSelectionData = null;
         this.championSelectionController.removeEventListener(GameEvent.ABORT_CHAMPION_SELECTION,this.onChampionSelectAborted);
         this.championSelectionController.removeEventListener(GameEvent.END_CHAMPION_SELECTION,this.onChampionSelectComplete);
         this.championSelectionController.removeEventListener(GameEvent.BROWSE_REQUESTED,this.onBrowseRequested);
         this.championSelectionController.removeEventListener(GameEvent.COMPLETE_CHAMPION_SELECT,this.onChampionSelectComplete);
         this.championSelectionController.removeEventListener(GameEvent.COMPLETE_LOAD_SCREEN,this.onLoadScreenComplete);
         if(Boolean(param1) && Boolean(param1.glmHost != null) && param1.glmPort != 0)
         {
            this.serviceProxy.gameZoneGameService.quitGzGame(this.onQuitGameSuccess,null,null);
         }
         else
         {
            this.serviceProxy.gameService.quitGame(this.onQuitGameSuccess,null,null);
         }
         if(this.gamePreloadController != null)
         {
            this.gamePreloadController.haltPreload();
         }
      }
      
      private function onQuitGameSuccess(param1:ResultEvent) : void
      {
         this.gameMap = null;
         this.cleanupAfterGameCompleteOrAborted();
         this.cancelGameFlow();
      }
      
      private function waitForObserverGame(param1:GameDTO) : void
      {
         if(Boolean(param1))
         {
            this.currentGame = param1;
         }
         this.serviceProxy.messageRouterService.addGameMessageListener(this.messageQueue.onMessageReceived);
      }
      
      private function endChampionSelection(param1:GameDTO) : void
      {
         if(Boolean(param1))
         {
            this.currentGame = param1;
         }
         this.championSelectionController.removeEventListener(GameEvent.ABORT_CHAMPION_SELECTION,this.onChampionSelectAborted);
         this.championSelectionController.removeEventListener(GameEvent.END_CHAMPION_SELECTION,this.onChampionSelectComplete);
      }
      
      private function updateLobbyForNewState() : void
      {
         if(this._currentState == GameViewState.CHAMPION_SELECTION || this._currentState == GameViewState.START_REQUESTED || this._currentState == GameViewState.IN_PROGRESS || this._currentState == GameViewState.JOIN_QUEUE)
         {
            LobbyConfig.instance.isNavigationEnabled = false;
         }
         else if(this._currentState == GameViewState.TEAM_SELECTION || this._currentState == GameViewState.JOIN_GAME || this._currentState == GameViewState.WAIT_FOR_GAME)
         {
            LobbyConfig.instance.isNavigationEnabled = true;
         }
         if(this._currentState == GameViewState.TEAM_SELECTION || this._currentState == GameViewState.WAIT_FOR_GAME_AFTER_MATCH || this._currentState == GameViewState.CHAMPION_SELECTION || this._currentState == GameViewState.START_REQUESTED || this._currentState == GameViewState.IN_PROGRESS)
         {
            LobbyConfig.instance.isGameButtonEnabled = false;
         }
         else
         {
            LobbyConfig.instance.isGameButtonEnabled = true;
         }
         switch(this._currentState)
         {
            case GameViewState.JOIN_GAME:
            case GameViewState.CREATE_GAME:
            case GameViewState.TEAM_SELECTION:
               this.inviteController.enablePendingInvites();
               this.lobbyController.requestLobbyState(LobbyViewState.PLAY_PRACTICE_GAME_STATE);
               break;
            case GameViewState.GAME_OVER:
            case GameViewState.NO_GAME:
               this.inviteController.enablePendingInvites();
               break;
            case GameViewState.START_REQUESTED:
            case GameViewState.TUTORIAL_GAME:
            case GameViewState.CHAMPION_SELECTION:
            case GameViewState.IN_PROGRESS:
               this.inviteController.disablePendingInvites();
               if(!(this.isSpectating && this._currentState == GameViewState.START_REQUESTED))
               {
                  this.lobbyController.requestLobbyState(LobbyViewState.PLAY_GAME_STATE);
               }
         }
      }
      
      public function set leavers(param1:ArrayCollection) : void
      {
         this._leavers = param1;
      }
      
      public function get leavers() : ArrayCollection
      {
         return this._leavers;
      }
      
      public function setLeaversAndShowDialog(param1:ArrayCollection, param2:Boolean, param3:Boolean) : void
      {
         var _loc4_:IResourceManager = null;
         var _loc5_:String = null;
         var _loc6_:DockedPrompt = null;
         var _loc7_:String = null;
         this.leavers = param1;
         if(this.hasLeavers())
         {
            _loc4_ = ResourceManager.getInstance();
            _loc5_ = "<font size=\"13\">" + this.leavers.getItemAt(0).summonerName + "</font>";
            _loc6_ = new DockedPrompt();
            _loc6_.leftButtonLabel = _loc4_.getString("resources","common_button_close");
            if(param2)
            {
               if(param3)
               {
                  _loc7_ = _loc4_.getString("resources","normal_leaver_leaverFormHeadingLabel",[_loc5_]);
                  if(!_loc7_)
                  {
                     _loc7_ = _loc5_ + " has left during champion selection and you have been placed back to the top of the matchmaking queue.";
                  }
               }
               else
               {
                  _loc7_ = _loc4_.getString("resources","normal_leaver_sameteam_leaverFormHeadingLabel",[_loc5_]);
               }
            }
            else
            {
               _loc7_ = _loc4_.getString("resources","practiceGame_leaver_leaverFormHeadingLabel",[_loc5_]);
            }
            _loc6_.message = _loc7_;
            _loc6_.title = _loc4_.getString("resources","practiceGame_leaver_title");
            _loc6_.timeStamp = new Date();
            this.dockedNotificationsProvider.showDockedPrompt(_loc6_);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameMap() : GameMap
      {
         return this.gameModel.gameMap;
      }
      
      private function set _195623926gameMap(param1:GameMap) : void
      {
         this.gameModel.gameMap = param1;
      }
      
      public function setGameMapByID(param1:int) : void
      {
         this.gameMap = this.applicationController.getGameMap(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get gameType() : String
      {
         return this.gameModel.gameType;
      }
      
      private function set _1769142708gameType(param1:String) : void
      {
         this.gameModel.gameType = param1;
      }
      
      public function changePresence(param1:String) : void
      {
         this.chatController.changePresence(param1);
      }
      
      public function changePresenceToSpectating(param1:String, param2:Object) : void
      {
         this.chatController.changePresenceToSpecating(param1,param2);
      }
      
      [Bindable(event="propertyChange")]
      public function get championSmallIcons() : Boolean
      {
         return this._championSmallIcons;
      }
      
      private function set _940837788championSmallIcons(param1:Boolean) : void
      {
         this._championSmallIcons = param1;
         UserPreferencesManager.userPrefs.championSmallIcons = this._championSmallIcons;
      }
      
      private function getDockedNotificationsProvider() : void
      {
         ProviderLookup.getProvider(INotificationsProvider,this.onDockedNotificationsProvider);
      }
      
      private function onDockedNotificationsProvider(param1:INotificationsProvider) : void
      {
         this.dockedNotificationsProvider = param1;
      }
      
      private function onInventoryProvider(param1:IInventoryProvider) : void
      {
         this.inventory = param1.getInventory();
      }
      
      private function onInviteProvider(param1:IInviteProvider) : *
      {
         this.inviteController = param1.getInviteController();
         this._inviteGroup = param1.getInviteGroup();
      }
      
      private function onSessionMetricsProvider(param1:ISessionMetricsProvider) : void
      {
         this.sessionMetrics = param1;
      }
      
      private function getChampionSelection() : void
      {
         ProviderLookup.getProvider(IChampionSelection,this.onChampionSelectionRetrieved);
      }
      
      public function onChampionSelectionRetrieved(param1:IChampionSelection) : void
      {
         this.championSelectionController = param1;
         if(Boolean(this.gameSelectionData))
         {
            this.attemptToStartChampSelect();
         }
      }
      
      private function onChampionSelectAborted(param1:GameEvent) : void
      {
         this.cancelChampionSelection(param1.game);
      }
      
      private function onChampionSelectComplete(param1:GameEvent) : void
      {
         if(this.isSpectating)
         {
            this.waitForObserverGame(param1.game);
         }
         else if(!this.gamePreloadController.isPreloadingEnabled)
         {
            this.endChampionSelection(param1.game);
         }
         else if(Boolean(param1.game))
         {
            this.currentGame = param1.game;
         }
      }
      
      private function onLoadScreenComplete(param1:GameEvent) : void
      {
         this.gamePreloadController.completePreload();
         this.currentState = GameViewState.PLAYING_GAME;
         this.endChampionSelection(param1.game);
      }
      
      public function setPlayingDisconnected() : void
      {
         this.inGameController.setDisconnected();
      }
      
      public function get rejoiningQueue() : Boolean
      {
         return this._rejoiningQueue;
      }
      
      public function initialize() : void
      {
         if(!this.inventory)
         {
            ProviderLookup.getProvider(IInventoryProvider,this.onInventoryProvider);
         }
         if(!this.championSelectionController)
         {
            this.getChampionSelection();
         }
         if(this.dockedNotificationsProvider == null)
         {
            this.getDockedNotificationsProvider();
         }
         if(this.sessionMetrics == null)
         {
            ProviderLookup.getProvider(ISessionMetricsProvider,this.onSessionMetricsProvider);
         }
         if(this.inviteController == null)
         {
            ProviderLookup.getProvider(IInviteProvider,this.onInviteProvider);
         }
         this.joinGameController.initialize();
         this.masterGameViewController.initialize();
         this.teamSelectionController.initialize();
         this.inGameController.initialize();
         this.endOfGameStatsController.initialize();
         this.isShuttingDown = false;
         this.leaverActionFactory = new LeaverActionFactory();
         this.addListeners();
         this.messageQueue = new MessageQueue("gameQueue",this.onServerGameMessageReceived);
         ProviderLookup.publishProvider(IGameProvider,this);
         ProviderLookup.publishProvider(IMasterGameController,this);
      }
      
      public function initializeCycle() : void
      {
         this.masterGameViewController.initializeCycle();
         this.joinGameController.initializeCycle();
         this.createTutorialGameController.initializeCycle();
         this.teamSelectionController.initializeCycle();
         this.inGameController.initializeCycle();
         this.createPracticeGameController.initializeCycle();
         this.endOfGameStatsController.initializeCycle();
         this.serviceProxy.messageRouterService.addGameMessageListener(this.messageQueue.onMessageReceived);
      }
      
      public function abortCycle() : void
      {
         if(this.activeSubsidiaryController != null)
         {
            this.activeSubsidiaryController.abortCycle();
            this.activeSubsidiaryController = null;
         }
         this.cleanupCycle();
      }
      
      public function cleanup() : void
      {
         this.isShuttingDown = true;
         if(this.activeSubsidiaryController != null)
         {
            this.abortCycle();
         }
         else
         {
            this.cleanupCycle();
         }
         this.joinGameController.cleanup();
         this.masterGameViewController.cleanup();
         this.teamSelectionController.cleanup();
         this.inGameController.cleanup();
         this.endOfGameStatsController.cleanup();
         this.spectatorController.cleanup();
      }
      
      public function cleanupCycle() : void
      {
         this.joinGameController.cleanupCycle();
         this.masterGameViewController.cleanupCycle();
         this.teamSelectionController.cleanupCycle();
         this.inGameController.cleanupCycle();
         this.endOfGameStatsController.cleanupCycle();
         this._isReconnecting = false;
      }
      
      public function activate() : void
      {
      }
      
      protected function addListeners() : void
      {
         this.chatController.addEventListener(XMPPEvent.CHAMPION_TRADE_REQUESTED,this.chatController_handleChampionTradeRequest);
         this.session.sessionSummonerUpdated.add(this.applySummonerUpdate);
         this.applySummonerUpdate();
         this.endOfGameStatsController.gameFlowComplete.add(this.onGameFlowComplete);
         this.endOfGameStatsController.playAgainClicked.add(this.onPlayAgainClicked);
      }
      
      private function onGameFlowComplete() : void
      {
         this.cancelGameFlow();
      }
      
      private function onPlayAgainClicked(param1:Boolean, param2:Boolean) : void
      {
         this.playAnotherGame(param1);
         this._playAgainClicked.dispatch(param2);
      }
      
      private function chatController_handleChampionTradeRequest(param1:XMPPEvent) : void
      {
      }
      
      public function deactivate() : void
      {
      }
      
      public function cancelChampSelect() : void
      {
         if(Boolean(this.championSelectionController) && Boolean(this.gameSelectionData))
         {
            this.cancelChampionSelection(this.gameSelectionData.game);
         }
      }
      
      public function quitGame() : void
      {
         if(!this.rejoiningQueue)
         {
            if(this._inviteGroup.myJID != null)
            {
               if(!this._inviteGroup.isOwner)
               {
                  if(this._inviteGroup.gameType == GameType.PRACTICE_GAME)
                  {
                     if(Boolean(this.currentGame))
                     {
                        if(this.currentGame.glmHost != null && this.currentGame.glmPort != 0)
                        {
                           this.serviceProxy.gameZoneGameService.quitGzGame(null,null,null);
                        }
                        else
                        {
                           this.serviceProxy.gameService.quitGame(null,null,null);
                        }
                        this.changePresence(PresenceStatusXML.GAME_STATUS_OUT_OF_GAME);
                        this.cleanupAfterGameCompleteOrAborted();
                     }
                  }
               }
            }
            if(!this.gameAFKStatus.waitingToRejoinTeamLobbyFromAFKReinvite)
            {
               this.inviteController.leaveLobby();
               this.inviteController.setInviteGroupCancel(false);
            }
         }
      }
      
      public function cancelInvite() : void
      {
         if(!this.rejoiningQueue)
         {
            this.inviteController.setInviteGroupCancel(true);
         }
      }
      
      public function startNormalGameFlow(param1:Boolean) : void
      {
         this._isSolo = param1;
         this.gameType = GameType.NORMAL_GAME;
         this.gameModel.ranked = false;
         this.initializeForNewGame();
         if(!param1)
         {
            this.currentState = GameViewState.JOIN_QUEUE;
         }
      }
      
      public function startCoopVsAIGameFlow(param1:Boolean) : void
      {
         this._isSolo = param1;
         this.gameType = GameType.COOP_VS_AI;
         this.gameModel.ranked = false;
         this.initializeForNewGame();
         if(!param1)
         {
            this.currentState = GameViewState.JOIN_QUEUE;
         }
      }
      
      public function startRankedGameFlow(param1:Boolean) : void
      {
         this._isSolo = param1;
         this.gameModel.ranked = true;
         if(param1)
         {
            this.gameType = GameType.RANKED_GAME_SOLO;
         }
         else
         {
            this.gameType = GameType.RANKED_GAME_PREMADE;
            this.currentState = GameViewState.JOIN_QUEUE;
         }
         this.initializeForNewGame();
      }
      
      public function startPracticeGameFlowAtJoinGame() : void
      {
         this.gameType = GameType.PRACTICE_GAME;
         this.masterGameViewController.gameQueueManager.reset();
         this.initializeForNewGame();
         this.lobbyController.requestLobbyState(LobbyViewState.PLAY_PRACTICE_GAME_STATE);
         this.currentState = GameViewState.JOIN_GAME;
      }
      
      public function startTutorialGame() : void
      {
         this.gameType = GameType.TUTORIAL_GAME;
         this.initializeForNewGame();
         this.currentState = GameViewState.TUTORIAL_GAME;
         if(this.gameModel.tutorialType == GameModel.TUTORIAL_TYPE_BASIC)
         {
            this.gameMap = this.applicationController.getGameMap(GameMap.PROVING_GROUNDS_ID);
            this.createTutorialGameController.chooseTutorialType(true);
         }
         else if(this.gameModel.tutorialType == GameModel.TUTORIAL_TYPE_ADVANCED)
         {
            this.gameMap = this.applicationController.getGameMap(GameMap.SUMMONERS_RIFT_ID);
            this.createTutorialGameController.chooseTutorialType(false);
         }
         this.createTutorialGameController.createGame(null);
         this.lobbyController.requestLobbyState(LobbyViewState.PLAY_TUTORIAL_GAME_STATE);
      }
      
      public function startPracticeGameFlowAtCreateGame() : void
      {
         this.gameType = GameType.PRACTICE_GAME;
         this.masterGameViewController.gameQueueManager.reset();
         this.initializeForNewGame();
         this.lobbyController.requestLobbyState(LobbyViewState.PLAY_PRACTICE_GAME_STATE);
         this.currentState = GameViewState.CREATE_GAME;
      }
      
      [Deprecated(message="Deprecated, InviteModule now handles the join when accepting an invite")]
      public function joinPracticeGameFromInvitation(param1:Number, param2:Number, param3:String, param4:Function) : void
      {
         var _loc5_:PracticeGameSearchResult = new PracticeGameSearchResult();
         this.gameMap = this.applicationController.getGameMap(param2);
         _loc5_.id = param1;
         _loc5_.gameMap = this.gameMap;
         this.startPracticeGameFlowAtJoinGame();
         this.joinGameController.joinGame(_loc5_,param3,param4);
      }
      
      private function initializeForNewGame() : void
      {
         this.initializeCycle();
      }
      
      public function cleanupIfGameIsNotNull() : void
      {
         if(this._currentGame != null)
         {
            this.cleanupAfterGameCompleteOrAborted();
         }
      }
      
      public function cleanupAfterGameCompleteOrAborted() : void
      {
         this.cleanupCycle();
         this.changePresence(PresenceStatusXML.GAME_STATUS_OUT_OF_GAME);
         this.serviceProxy.messageRouterService.removeGameMessageListener(this.messageQueue.onMessageReceived);
         this.leavers = null;
         this.playerRoster = new Array();
         this.summonerNameMap = new Array();
         this.currentGame = null;
         this.amIGameOwner = false;
         this.currentState = GameViewState.NO_GAME;
         this.spectatorController.cleanup();
         this.spectatorController.cleanupReconnectionInfo();
         this.isSpectating = false;
         this.clientConfig.disconnect_logging = true;
         this._currentGamePlayerCredentials = null;
         this._pendingGamePlayerCredentials = null;
         if(Boolean(this._gamePreparationDelegate))
         {
            this._gamePreparationDelegate.getGamePreparationFinished().removeAll();
         }
         this._gamePreparationDelegate = null;
         if(this.gamePreloadController != null)
         {
            this.gamePreloadController.haltPreload();
            this.gamePreloadController.shouldPreload = this.clientConfig.preloadGameClient;
         }
         GameConfig.instance.currentTeamSkinRental = null;
         this.serviceProxy.gameZoneGameService.clearGameZoneConnection();
         this.inviteController.enablePendingInvites();
      }
      
      public function gameCompleted() : void
      {
         if(this.currentState == GameViewState.PLAYING_GAME || this.currentState == GameViewState.IN_PROGRESS)
         {
            this.currentState = GameViewState.GAME_OVER;
         }
      }
      
      public function resetGameQueueManager() : void
      {
         this.masterGameViewController.gameQueueManager.reset();
      }
      
      public function get isReconnecting() : Boolean
      {
         return this._isReconnecting;
      }
      
      public function reconnectToGame(param1:GameDTO, param2:PlayerCredentialsDTO, param3:int = 0) : void
      {
         if(Boolean(param1 == null && param2 && param2.gameId) && Boolean(param2.observerEncryptionKey) && Boolean(param2.platformId))
         {
            this.spectatorController.spectateFeaturedGame(param2.gameId,param2.platformId,param2.observerEncryptionKey,param2.mapId,param2.gameType);
            this._isReconnecting = true;
            this.clientConfig.disconnect_logging = false;
            return;
         }
         if(Boolean(param1) && !param2)
         {
            this.logger.warn("0011 null player credentials on reconnect.");
         }
         this._isReconnecting = true;
         if(this.currentState == GameViewState.NO_GAME)
         {
            this.initializeCycle();
            this._currentState = GameViewState.START_REQUESTED;
         }
         this._currentGame = param1;
         this.gameType = param1.gameType;
         this.setGameMapByID(param1.mapId);
         if(Boolean(param2) && Boolean(param2.observer))
         {
            this.isSpectating = true;
            this.clientConfig.disconnect_logging = false;
            if(param3 > 0)
            {
               this._currentState = GameViewState.START_REQUESTED;
               this.currentGame.spectatorDelay = param3;
               this.startChampionSelect();
            }
            this.spectatorController.spectateGame(param2,param3);
         }
         else if(Boolean(param2))
         {
            this.startGame(param2);
         }
         if(this.clientConfig.DISCONNECT_LOGGING_PROP)
         {
            this.serviceProxy.gameService.setClientReceivedMaestroMessage(param1.id,"GameReconnect",this.onDisconnectLoggingSuccess,null,null);
         }
      }
      
      public function onServerGameMessageReceived(param1:MessageEvent) : void
      {
         var _loc2_:Object = param1.message.body;
         if(_loc2_ is GameDTO)
         {
            this.currentGame = GameDTO(_loc2_);
         }
         else if(_loc2_ is EndOfGameStats)
         {
            this.handleEndOfGameStatsMessage(EndOfGameStats(_loc2_));
         }
         else if(_loc2_ is EogPointChangeBreakdown)
         {
            this.handleRerollStatsMessage(EogPointChangeBreakdown(_loc2_));
         }
         else if(_loc2_ is PlayerCredentialsDTO)
         {
            this.handlePlayerCredentialsMessage(PlayerCredentialsDTO(_loc2_));
         }
         else if(_loc2_ is MatchSearchNotification)
         {
            this.masterGameViewController.handleJoinQueue(_loc2_ as MatchSearchNotification);
         }
         else if(_loc2_ is GameNotification)
         {
            this.handleGameNotificationMessage(GameNotification(_loc2_));
         }
         else if(_loc2_ is TeamSkinRentalDTO)
         {
            GameConfig.instance.currentTeamSkinRental = _loc2_ as TeamSkinRentalDTO;
         }
         else if(_loc2_ is LeaverBusterLowPriorityQueueAbandoned)
         {
            this.masterGameViewController.handleLeaverBusterLowPriorityQueueAbandoned(_loc2_ as LeaverBusterLowPriorityQueueAbandoned);
         }
      }
      
      private function onGameStartAcknowledgeSuccess(param1:ResultEvent) : void
      {
         this.serviceProxy.gameZoneGameService.clearGameZoneConnection();
      }
      
      private function onDisconnectLoggingSuccess(param1:ResultEvent) : void
      {
      }
      
      public function onMaestroGameConnectedToServer() : void
      {
         if(Boolean(this.clientConfig.DISCONNECT_LOGGING_PROP) && Boolean(this.currentGame))
         {
            this.serviceProxy.gameService.setClientReceivedMaestroMessage(this.currentGame.id,MaestroController.GAME_CLIENT_CONNECTED_TO_SERVER,this.onDisconnectLoggingSuccess,null,null);
         }
      }
      
      public function onMaestroGameClientVersionMismatch() : void
      {
         if(Boolean(this.clientConfig.DISCONNECT_LOGGING_PROP) && Boolean(this.currentGame))
         {
            this.serviceProxy.gameService.setClientReceivedMaestroMessage(this.currentGame.id,MaestroController.GAME_CLIENT_VERSION_MISMATCH,this.onDisconnectLoggingSuccess,null,null);
         }
      }
      
      private function handleGameNotificationMessage(param1:GameNotification) : void
      {
         this.changePresence(PresenceStatusXML.GAME_STATUS_OUT_OF_GAME);
         if(param1.type == GameNotificationType.PLAYER_BANNED_FROM_GAME)
         {
            this.handlePlayerBannedFromGame();
         }
         else if(param1.type == GameNotificationType.PLAYER_QUIT || param1.type == GameNotificationType.TEAM_REMOVED)
         {
            this.handleMatchedGamePlayerQuitWhileInQueue(param1.messageArgument);
         }
         else if(param1.type == GameNotificationType.PLAYER_REMOVED)
         {
            this.handleMatchedGamePlayerRemovedWhileInQueue();
         }
      }
      
      private function handlePlayerCredentialsMessage(param1:PlayerCredentialsDTO) : void
      {
         if(param1.observer)
         {
            this.spectatorController.spectateGame(param1,this.currentGame.spectatorDelay);
         }
         else
         {
            this.startGame(param1);
         }
      }
      
      private function startGame(param1:PlayerCredentialsDTO) : void
      {
         if(Boolean(this.currentGame) && param1.gameId == this.currentGame.id)
         {
            this._currentGamePlayerCredentials = param1;
            if(Boolean(this._gamePreparationDelegate) && !this._isReconnecting)
            {
               this._gamePreparationDelegate.getGamePreparationFinished().add(this.launchGame);
               this._gamePreparationDelegate.prepareForGame();
            }
            else
            {
               this.launchGame();
            }
         }
         else if(!this.currentGame)
         {
            this._pendingGamePlayerCredentials = param1;
            this.logger.warn("0682 MasterGameController.startGame: Received PlayerCredentials without a currentGame");
            if(this.isCap())
            {
               this.logger.warn("0684 MasterGameController.startGame: Received PlayerCredentials without a currentGame for a Team Builder game");
            }
         }
         else
         {
            this.logger.warn("0681 MasterGameController.startGame: Player credentials received from server for game " + param1.gameId + ", but current game id is " + this.currentGame.id);
         }
      }
      
      private function launchGame() : void
      {
         if(this._currentGamePlayerCredentials.observer)
         {
            throw new Error("can\'t play game as a spectator..");
         }
         this.currentState = GameViewState.IN_PROGRESS;
         if(this.gamePreloadController == null || !this.gamePreloadController.isPreloadingEnabled || this._isReconnecting)
         {
            if(Boolean(this.servicesConfig.startMaestro) && this.maestroController != null)
            {
               this.maestroController.createGame(this._currentGamePlayerCredentials.serverIp,this._currentGamePlayerCredentials.serverPort.toString(),this._currentGamePlayerCredentials.encryptionKey,this.session.summoner.sumId.toString());
            }
            this.currentState = GameViewState.PLAYING_GAME;
         }
         else if(this.gamePreloadController.isPreloadingEnabled)
         {
            this.gamePreloadController.updateGamePreloadWithPlayerCredentials(this._currentGamePlayerCredentials,this.session.summoner,true);
         }
         if(this.clientConfig.preloadGameClient)
         {
            this.applicationController.registerGameCrashCallbacks();
         }
         if(Boolean(this.clientConfig.DISCONNECT_LOGGING_PROP) && Boolean(this.currentGame))
         {
            if(!this.isSpectating)
            {
               this.serviceProxy.gameService.setClientReceivedGameMessage(this.currentGame.id,GameClientAcknowledgeTypes.GAME_START_CLIENT,this.onGameStartAcknowledgeSuccess,null,null);
            }
         }
         this._currentGamePlayerCredentials = null;
         this.trackSuggestedPlayersData();
      }
      
      public function trackSuggestedPlayersData() : void
      {
         if(!this._inviteGroup || !this._inviteGroup.isOwner)
         {
            return;
         }
         var _loc1_:Number = -1;
         if(Boolean(this.masterGameViewController) && Boolean(this.masterGameViewController.gameQueueManager) && Boolean(this.masterGameViewController.gameQueueManager.selectedGameQueueConfig))
         {
            _loc1_ = Number(this.masterGameViewController.gameQueueManager.selectedGameQueueConfig.id);
         }
         var _loc2_:Number = -1;
         if(Boolean(this.currentGame))
         {
            _loc2_ = Number(this.currentGame.id);
         }
         SuggestedPlayersProviderProxy.instance.notifyGameLaunched(_loc2_,_loc1_);
      }
      
      private function isCap() : Boolean
      {
         if(Boolean(this.masterGameViewController) && Boolean(this.masterGameViewController.gameQueueManager) && Boolean(this.masterGameViewController.gameQueueManager.getSelectedGameQueueConfig()))
         {
            return this.masterGameViewController.gameQueueManager.getSelectedGameQueueConfig().isCap();
         }
         return false;
      }
      
      private function startGameIfGamePending() : void
      {
         if(Boolean(this.currentGame) && Boolean(this._pendingGamePlayerCredentials))
         {
            if(this.currentGame.id == this._pendingGamePlayerCredentials.gameId)
            {
               this.logger.warn("0683 MasterGameController.startGame: Had pending player crendentials when receiving a GameDTO of the same ID. Attempting to start game");
               this.handlePlayerCredentialsMessage(this._pendingGamePlayerCredentials);
            }
         }
         this._pendingGamePlayerCredentials = null;
      }
      
      public function setGamePreparationDelegate(param1:IGamePreparationDelegate) : void
      {
         this._gamePreparationDelegate = param1;
      }
      
      public function handleSpectatorEndOfGameStats(param1:EndOfGameStats) : void
      {
         this.currentState = GameViewState.GAME_OVER;
         this.endOfGameStatsController.currentEndOfGameState = EndOfGameStatsController.SHOW_STATS;
         var _loc2_:String = this.spectatorController.dropInSpectateGameID;
         var _loc3_:Boolean = _loc2_ == null || _loc2_.length == 0;
         this.endOfGameStatsController.setEndOfGameStats(param1,true,_loc3_,this.summonerNameMap,this.gameType,this.gameMap,this.allowedtoPlayAgain());
         this.changePresence(PresenceStatusXML.GAME_STATUS_OUT_OF_GAME);
      }
      
      private function handleEndOfGameStatsMessage(param1:EndOfGameStats) : void
      {
         this.currentState = GameViewState.GAME_OVER;
         this.endOfGameStatsController.setEndOfGameStats(param1,false,true,this.summonerNameMap,this.gameType,this.gameMap,this.allowedtoPlayAgain());
         this.changePresence(PresenceStatusXML.GAME_STATUS_OUT_OF_GAME);
      }
      
      private function handleRerollStatsMessage(param1:EogPointChangeBreakdown) : void
      {
         this.endOfGameStatsController.setRerollStats(param1);
      }
      
      private function onGameClaimFailed(param1:ServerError) : void
      {
         this.logger.error("0003 claiming a newly created game failed: " + param1);
      }
      
      public function hasLeavers() : Boolean
      {
         return this.leavers != null && this.leavers.length > 0;
      }
      
      private function identifyLeavers(param1:GameDTO) : ArrayCollection
      {
         var _loc3_:IParticipant = null;
         var _loc4_:PlayerParticipant = null;
         var _loc5_:String = null;
         var _loc6_:GameParticipant = null;
         var _loc2_:ArrayCollection = new ArrayCollection();
         for each(_loc3_ in this.currentGame.teamOne)
         {
            if(_loc3_ is PlayerParticipant)
            {
               _loc4_ = _loc3_ as PlayerParticipant;
               if(!param1.isParticipantInGame(_loc4_) && !param1.isObserverForGame(_loc4_))
               {
                  _loc2_.addItem(_loc4_);
                  _loc5_ = _loc4_.accountId.toString();
                  delete this.playerRoster[_loc5_];
               }
            }
         }
         for each(_loc3_ in this.currentGame.teamTwo)
         {
            if(_loc3_ is PlayerParticipant)
            {
               _loc4_ = _loc3_ as PlayerParticipant;
               if(!param1.isParticipantInGame(_loc4_) && !param1.isObserverForGame(_loc4_))
               {
                  _loc2_.addItem(_loc4_);
                  _loc5_ = _loc4_.accountId.toString();
                  delete this.playerRoster[_loc5_];
               }
            }
         }
         for each(_loc3_ in this.currentGame.observers)
         {
            if(_loc3_ is GameParticipant)
            {
               _loc6_ = _loc3_ as GameParticipant;
               if(!param1.isParticipantInGame(_loc6_) && !param1.isObserverForGame(_loc6_))
               {
                  _loc2_.addItem(_loc6_);
               }
            }
         }
         return _loc2_.length == 0 ? null : _loc2_;
      }
      
      public function willBeLeaver() : Boolean
      {
         if(this.isSpectating)
         {
            return false;
         }
         var _loc1_:Array = [GameViewState.CHAMPION_SELECTION,GameViewState.WAIT_FOR_GAME_AFTER_MATCH,GameViewState.START_REQUESTED,GameViewState.IN_PROGRESS,GameViewState.PLAYING_GAME];
         return _loc1_.indexOf(this.currentState) != -1;
      }
      
      private function updatePlayerRosterAndChampionSelections() : void
      {
         var _loc6_:int = 0;
         var _loc7_:IParticipant = null;
         var _loc8_:String = null;
         var _loc9_:PlayerParticipant = null;
         var _loc10_:ObfuscatedParticipant = null;
         var _loc11_:Boolean = false;
         var _loc12_:Boolean = false;
         var _loc13_:GameTypeConfig = null;
         var _loc1_:Array = new Array();
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         for each(_loc7_ in this.currentGame.teamOne)
         {
            if(_loc7_ is BotParticipant)
            {
               _loc3_.push(_loc7_);
            }
            else
            {
               _loc8_ = "1";
               if(_loc7_ is PlayerParticipant)
               {
                  _loc8_ = PlayerParticipant(_loc7_).accountId.toString();
                  _loc9_ = this.playerRoster[_loc8_] as PlayerParticipant;
               }
               else
               {
                  if(!(_loc7_ is ObfuscatedParticipant))
                  {
                     this.logger.error("0004 updatePlayerRosterAndChampionSelections(): Handled game participant of unknown type [%s]",getQualifiedClassName(_loc7_));
                     continue;
                  }
                  _loc9_ = new PlayerParticipant();
                  _loc9_.pickMode = _loc7_.getPickMode();
                  _loc10_ = _loc7_ as ObfuscatedParticipant;
                  _loc9_.accountId = _loc10_.gameUniqueId;
                  _loc9_.clientInSynch = _loc10_.clientInSynch;
                  _loc9_.summonerName = ResourceManager.getInstance().getString("resources","championSelection_player_summoner_anonymous",[_loc10_.gameUniqueId]);
                  _loc8_ = _loc10_.gameUniqueId.toString();
               }
               if(_loc9_ == null)
               {
                  this.playerRoster[_loc8_] = _loc7_;
                  _loc1_.push(_loc7_);
                  _loc9_ = PlayerParticipant(_loc7_);
               }
               else if(_loc7_ is PlayerParticipant && !_loc9_.equals(_loc7_ as PlayerParticipant))
               {
                  this.playerRoster[_loc8_] = _loc7_;
                  _loc9_ = PlayerParticipant(_loc7_);
               }
               if(this.currentGame.ownerSummary != null)
               {
                  _loc9_.isGameOwner = this.currentGame.ownerSummary.accountId == _loc9_.accountId;
               }
               _loc9_.isMe = this.session.accountSummary.accountId == _loc9_.accountId;
               _loc2_.push(_loc9_);
               if(_loc9_.isMe)
               {
                  _loc6_ = 1;
               }
            }
         }
         for each(_loc7_ in this.currentGame.teamTwo)
         {
            if(_loc7_ is BotParticipant)
            {
               _loc5_.push(_loc7_);
            }
            else
            {
               if(_loc7_ is PlayerParticipant)
               {
                  _loc8_ = PlayerParticipant(_loc7_).accountId.toString();
                  _loc9_ = this.playerRoster[_loc8_] as PlayerParticipant;
               }
               else
               {
                  if(!(_loc7_ is ObfuscatedParticipant))
                  {
                     this.logger.error("0005 updatePlayerRosterAndChampionSelections(): Handled game participant of unknown type [%s]",getQualifiedClassName(_loc7_));
                     continue;
                  }
                  _loc9_ = new PlayerParticipant();
                  _loc9_.pickMode = _loc7_.getPickMode();
                  _loc10_ = _loc7_ as ObfuscatedParticipant;
                  _loc9_.accountId = _loc10_.gameUniqueId;
                  _loc9_.clientInSynch = _loc10_.clientInSynch;
                  _loc9_.summonerName = ResourceManager.getInstance().getString("resources","championSelection_player_summoner_anonymous",[_loc10_.gameUniqueId]);
                  _loc8_ = _loc10_.gameUniqueId.toString();
               }
               if(_loc9_ == null)
               {
                  this.playerRoster[_loc8_] = _loc7_;
                  _loc1_.push(_loc7_);
                  _loc9_ = PlayerParticipant(_loc7_);
               }
               else if(_loc7_ is PlayerParticipant && !_loc9_.equals(_loc7_ as PlayerParticipant))
               {
                  this.playerRoster[_loc8_] = _loc7_;
                  _loc9_ = PlayerParticipant(_loc7_);
               }
               if(this.currentGame.ownerSummary != null)
               {
                  _loc9_.isGameOwner = this.currentGame.ownerSummary.accountId == _loc9_.accountId;
               }
               _loc9_.isMe = this.session.accountSummary.accountId == _loc9_.accountId;
               _loc4_.push(_loc9_);
               if(_loc9_.isMe)
               {
                  _loc6_ = 2;
               }
            }
         }
         this.currentGame.teamOne = new ArrayCollection(_loc2_.concat(_loc3_));
         this.currentGame.teamTwo = new ArrayCollection(_loc4_.concat(_loc5_));
         if(GameState.isInChampionSelectionState(this.currentGame.gameStateString))
         {
            _loc11_ = _loc6_ == 1;
            _loc12_ = _loc6_ == 2;
            _loc13_ = null;
            if(Boolean(this.currentGame))
            {
               _loc13_ = this.gameTypeConfigManager.getGameTypeConfig(this.currentGame.gameTypeConfigId);
            }
            if(Boolean(_loc13_) && _loc13_.exclusivePick == true)
            {
               _loc11_ = _loc12_ = true;
            }
            this.updateChampionSelections(_loc13_,_loc11_,_loc12_);
         }
         else if(this.currentGame.gameStateString == GameState.TEAM_SELECTION)
         {
            this.updateBotChampions();
         }
      }
      
      public function getParticipant(param1:String) : PlayerParticipant
      {
         var _loc2_:GameParticipant = null;
         var _loc3_:PlayerParticipant = null;
         for each(_loc2_ in this.currentGame.teamOne)
         {
            if(!(_loc2_ is BotParticipant))
            {
               _loc3_ = PlayerParticipant(_loc2_);
               if(_loc3_.summonerName == param1)
               {
                  return _loc3_;
               }
            }
         }
         for each(_loc2_ in this.currentGame.teamTwo)
         {
            if(!(_loc2_ is BotParticipant))
            {
               _loc3_ = PlayerParticipant(_loc2_);
               if(_loc3_.summonerName == param1)
               {
                  return _loc3_;
               }
            }
         }
         return null;
      }
      
      private function updateChampionSelections(param1:GameTypeConfig, param2:Boolean, param3:Boolean) : void
      {
         var _loc6_:PlayerChampionSelectionDTO = null;
         var _loc7_:GameParticipant = null;
         var _loc8_:GameParticipant = null;
         var _loc4_:Object = new Object();
         if(param2)
         {
            for each(_loc7_ in this.currentGame.teamOne)
            {
               _loc4_[this.keyForSummonerName(_loc7_.summonerInternalName)] = _loc7_;
            }
         }
         if(param3)
         {
            for each(_loc7_ in this.currentGame.teamTwo)
            {
               _loc4_[this.keyForSummonerName(_loc7_.summonerInternalName)] = _loc7_;
            }
         }
         var _loc5_:Array = new Array();
         for each(_loc6_ in this.currentGame.playerChampionSelections)
         {
            _loc8_ = _loc4_[this.keyForSummonerName(_loc6_.summonerInternalName)];
            if(_loc8_ != null)
            {
               _loc5_[_loc6_.championId] = _loc8_;
            }
         }
      }
      
      private function keyForSummonerName(param1:String) : String
      {
         return "sum_" + param1;
      }
      
      private function rejoinQueue(param1:Boolean) : void
      {
         this.masterGameViewController.rejoinQueue(param1);
         this._rejoiningQueue = false;
         this._requestRejoin = false;
      }
      
      private function updateBotChampions() : void
      {
         var _loc1_:GameParticipant = null;
         var _loc2_:BotParticipant = null;
         var _loc3_:String = null;
         var _loc4_:Champion = null;
         for each(_loc1_ in this.currentGame.teamOne)
         {
            if(!(_loc1_ is PlayerParticipant))
            {
               _loc2_ = BotParticipant(_loc1_);
               _loc3_ = _loc2_.getChampionName();
               _loc4_ = this.inventory.championRegistry[_loc3_] as Champion;
               _loc2_.champion = _loc4_;
            }
         }
         for each(_loc1_ in this.currentGame.teamTwo)
         {
            if(!(_loc1_ is PlayerParticipant))
            {
               _loc2_ = BotParticipant(_loc1_);
               _loc3_ = _loc2_.getChampionName();
               _loc4_ = this.inventory.championRegistry[_loc3_] as Champion;
               _loc2_.champion = _loc4_;
            }
         }
      }
      
      public function allowedtoPlayAgain() : Boolean
      {
         var _loc1_:Boolean = this.gameType != GameType.TUTORIAL_GAME && (this.isSolo || Boolean(this._inviteGroup.isOwner) || this.gameType == GameType.PRACTICE_GAME);
         _loc1_ &&= this.masterGameViewController.gameQueueManager.selectedGameQueueConfig != null;
         if(_loc1_ && Boolean(this.masterGameViewController.gameQueueManager.selectedGameQueueConfig.teamOnly))
         {
            _loc1_ = _loc1_ && this.masterGameViewController.gameQueueManager.rankedTeamId != null && this.masterGameViewController.gameQueueManager.rankedTeamName != GameQueueManager.TEAM_NAME_UNSELECTED;
         }
         if(AppConfig.instance.shutdownDisablePlayButton)
         {
            _loc1_ = false;
         }
         return _loc1_;
      }
      
      public function playAnotherGame(param1:Boolean = false) : void
      {
         var _loc2_:GameModel = this.gameModel.copy();
         var _loc3_:Array = this.inviteController.getReInviteList();
         this.cleanupAfterGameCompleteOrAborted();
         this.gameModel = _loc2_;
         if(this.isCap())
         {
            this.currentState = GameViewState.CAP_STATE;
            return;
         }
         switch(this.gameType)
         {
            case GameType.NORMAL_GAME:
            case GameType.RANKED_GAME_SOLO:
            case GameType.COOP_VS_AI:
               this.restartMatchmakingGame(this.gameType,_loc3_);
               break;
            case GameType.RANKED_TEAM_GAME:
            case GameType.RANKED_GAME_PREMADE:
               this.restartRankedTeamGame(_loc3_);
               break;
            case GameType.TUTORIAL_GAME:
            default:
               if(param1)
               {
                  this.startPracticeGameFlowAtCreateGame();
               }
               else
               {
                  this.startPracticeGameFlowAtJoinGame();
               }
         }
      }
      
      private function restartMatchmakingGame(param1:String, param2:Array) : void
      {
         this.gameAFKStatus.waitingToRejoinTeamLobbyFromAFKReinvite = false;
         if(!this.allowedtoPlayAgain())
         {
            this.cancelGameFlow();
         }
         else
         {
            switch(param1)
            {
               case GameType.NORMAL_GAME:
                  this.startNormalGameFlow(this.isSolo);
                  break;
               case GameType.RANKED_GAME_SOLO:
               case GameType.RANKED_GAME_PREMADE:
                  this.startRankedGameFlow(this.isSolo);
                  break;
               case GameType.COOP_VS_AI:
                  this.startCoopVsAIGameFlow(this.isSolo);
            }
            this.masterGameViewController.handleSelectMapContinue();
            if(!this.isSolo)
            {
               this.currentState = GameViewState.JOIN_QUEUE;
               this.inviteController.reInviteParticipants(param2);
            }
         }
      }
      
      private function restartRankedTeamGame(param1:Array) : void
      {
         this.gameAFKStatus.waitingToRejoinTeamLobbyFromAFKReinvite = false;
         this.gameModel.ranked = true;
         this.gameType = GameType.RANKED_GAME_PREMADE;
         this.currentState = GameViewState.JOIN_QUEUE;
         this.initializeForNewGame();
         this.masterGameViewController.handleSelectMapContinue();
         this.inviteController.createRankedTeamLobby(this._masterGameViewController.gameQueueManager.rankedTeamName);
         this.inviteController.reInviteParticipants(param1);
      }
      
      public function cancelGameFlow() : void
      {
         this.cleanupTimers();
         this.cleanupAfterGameCompleteOrAborted();
         if(this.shouldNavigateToHome)
         {
            this.applicationController.home();
         }
         else
         {
            this.shouldNavigateToHome = true;
         }
      }
      
      private function getParticipantFromRoster(param1:String) : GameParticipant
      {
         return this.playerRoster[param1] as GameParticipant;
      }
      
      public function canShowPreviousGameAchievements() : Boolean
      {
         return this.currentState != GameViewState.CHAMPION_SELECTION && this.currentState != GameViewState.START_REQUESTED && this.currentState != GameViewState.IN_PROGRESS;
      }
      
      private function handlePlayerBannedFromGame() : void
      {
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         var _loc2_:AlertAction = new AlertAction(_loc1_.getString("resources","general_generalAlertErrorTitle"),_loc1_.getString("resources",MessageDictionary.PLAYER_BANNED_FROM_GAME));
         _loc2_.add();
         this.playAnotherGame();
      }
      
      private function handleMatchedGamePlayerQuitWhileInQueue(param1:String) : void
      {
         var _loc3_:IResourceManager = null;
         var _loc4_:AlertAction = null;
         if(this.currentState != GameViewState.WAIT_FOR_GAME)
         {
            this.logger.warn("MasterGameController.handleMatchedGamePlayerQuitWhileInQueue: " + "Tried to quit champion selection, but we were not in queue we are in state: " + this.currentState);
            return;
         }
         this.applicationController.home();
         var _loc2_:String = Summoner.SUMMONER_INTERNAL_NAME_PREFIX + param1;
         if(param1 == null || param1 == "")
         {
            _loc3_ = ResourceManager.getInstance();
            _loc4_ = new AlertAction("",_loc3_.getString("resources","invite_participant_unknown_teammate_quit_while_in_queue",[]));
            _loc4_.add();
         }
         else if(Boolean(this.session && this.session.summoner) && Boolean(_loc2_ != this.session.summoner.internalName) && _loc2_ != "sum" + this.session.summoner.sumId)
         {
            this.serviceProxy.statisticsService.getSummonerSummaryByInternalName(_loc2_,this.displayMatchedGamePlayerQuitMessage,null);
         }
         this.chatController.leaveMatchmakingQueueChatRoom();
         this.cleanupTimers();
         this.cleanupAfterGameCompleteOrAborted();
      }
      
      private function handleMatchedGamePlayerRemovedWhileInQueue() : void
      {
         this.applicationController.home();
         this.cancelInvite();
         this.chatController.leaveMatchmakingQueueChatRoom();
         this.cleanupTimers();
         this.cleanupAfterGameCompleteOrAborted();
         this.masterGameViewController.showCancelledFromQueueMessage();
      }
      
      private function displayMatchedGamePlayerQuitMessage(param1:ResultEvent) : void
      {
         var _loc5_:AlertAction = null;
         var _loc6_:DockedPrompt = null;
         var _loc2_:SummonerSummary = param1.result as SummonerSummary;
         var _loc3_:IResourceManager = ResourceManager.getInstance();
         var _loc4_:ConfigurationModel = DynamicClientConfigManager.getConfiguration("GameInvites","ServiceEnabled",true,null);
         if(!_loc4_.getBoolean())
         {
            _loc5_ = new AlertAction("",_loc3_.getString("resources","invite_participant_teammate_quit_while_in_queue",[_loc2_.name]));
            _loc5_.add();
         }
         else
         {
            _loc6_ = DockedPrompt.create(_loc3_.getString("resources","invite_participant_teammate_quit_while_in_queue_back_to_lobby",[_loc2_.name]),_loc3_.getString("resources","XMPP-GAME-INVITE-TITLE"),"PVP.NET",_loc3_.getString("resources","common_button_close"));
            this.dockedNotificationsProvider.showDockedPrompt(_loc6_);
         }
      }
      
      private function cleanupTimers() : void
      {
         this.masterGameViewController.gameQueueManager.endQueueWait();
         this.enterChampionSelectManager.cleanupTimer();
      }
      
      private function restoreNewGameViewConfiguration() : void
      {
         this.removeLegacyChampionSelectionAction();
         this.removeAFKFilterChampionSelectionAction();
         DialogQueueProviderProxy.instance.removeActiveDialogs();
         this.lobbyController.requestLobbyState(LobbyViewState.PLAY_GAME_STATE);
         this.cleanupTimers();
         this.updatePlayerRosterAndChampionSelections();
      }
      
      private function populateSummonerNameMap(param1:GameDTO) : void
      {
         var _loc2_:PlayerParticipant = null;
         var _loc3_:IParticipant = null;
         var _loc4_:Number = NaN;
         for each(_loc3_ in param1.teamOne)
         {
            if(_loc3_ is PlayerParticipant)
            {
               _loc2_ = _loc3_ as PlayerParticipant;
               _loc4_ = Number(_loc2_.summonerId);
               this.summonerNameMap[_loc4_] = _loc2_.summonerName;
            }
         }
         for each(_loc3_ in param1.teamTwo)
         {
            if(_loc3_ is PlayerParticipant)
            {
               _loc2_ = _loc3_ as PlayerParticipant;
               _loc4_ = Number(_loc2_.summonerId);
               this.summonerNameMap[_loc4_] = _loc2_.summonerName;
            }
         }
      }
      
      private function enterChampionSelect() : void
      {
         if(this.currentState == GameViewState.WAIT_FOR_GAME_AFTER_MATCH)
         {
            this.currentState = GameViewState.CHAMPION_SELECTION;
         }
      }
      
      public function get isLastPlayedGameTypeTutorial() : Boolean
      {
         if(this._lastPlayedGameModel != null)
         {
            return this._lastPlayedGameModel.gameType == GameType.TUTORIAL_GAME;
         }
         return false;
      }
      
      private function applySummonerUpdate() : void
      {
         var _loc1_:String = null;
         var _loc2_:GameParticipant = null;
         var _loc3_:PlayerParticipant = null;
         if(this.session.summoner != null && this.session.summonerLevelAndPoints != null)
         {
            _loc1_ = this.session.summoner.acctId.toString();
            _loc2_ = this.getParticipantFromRoster(_loc1_);
            if(_loc2_ != null && _loc2_ is PlayerParticipant)
            {
               _loc3_ = PlayerParticipant(_loc2_);
               _loc3_.summonerLevel = this.session.summonerLevelAndPoints.summonerLevel;
            }
         }
      }
      
      public function joinPracticeGame(param1:GameDTO) : void
      {
         this.initializeForNewGame();
         this.lobbyController.requestLobbyState(LobbyViewState.PLAY_PRACTICE_GAME_STATE);
         if(this.currentState == GameViewState.NO_GAME)
         {
            this.currentState = GameViewState.JOIN_GAME;
         }
         this.gameType = GameType.PRACTICE_GAME;
         this.gameMap = this.applicationController.getGameMap(param1.mapId);
         this.currentGame = param1;
      }
      
      public function getGameStateChanged() : ISignal
      {
         return this._gameStateChanged;
      }
      
      public function getCurrentGameChanged() : ISignal
      {
         return this._currentGameChanged;
      }
      
      public function getPreloadController() : IGamePreloadController
      {
         return this.gamePreloadController;
      }
      
      private function removeLegacyChampionSelectionAction() : void
      {
         if(this.legacyChampionSelectionAlertAction != null)
         {
            this.legacyChampionSelectionAlertAction.remove();
         }
      }
      
      private function addLegacyEnterChampionSelectionAction() : void
      {
         if(this.legacyChampionSelectionAlertAction != null)
         {
            this.legacyChampionSelectionAlertAction.getOnPlayNow().removeAll();
            this.legacyChampionSelectionAlertAction.getOnPlayNow().add(this.onLegacyChampionSelectionAlertPlayNow);
            this.legacyChampionSelectionAlertAction.add(this.enterChampionSelectManager);
         }
      }
      
      private function onLegacyChampionSelectionAlertPlayNow(param1:ISignal) : void
      {
         param1.remove(this.onLegacyChampionSelectionAlertPlayNow);
         this.currentState = GameViewState.CHAMPION_SELECTION;
      }
      
      public function removeAFKFilterChampionSelectionAction() : void
      {
         if(this.AFKFilterChampionSelectionAlertAction != null)
         {
            this.AFKFilterChampionSelectionAlertAction.remove();
         }
      }
      
      private function updateAFKFilterForLobbyReturn() : void
      {
         if(this.AFKFilterChampionSelectionAlertAction != null)
         {
            this.AFKFilterChampionSelectionAlertAction.updateForLobbyReturn();
         }
      }
      
      private function displayPendingAFKChatNotification() : void
      {
         if(this._pendingAFKChatNotification != null)
         {
            this.dockedNotificationsProvider.showDockedPrompt(this._pendingAFKChatNotification);
            this._pendingAFKChatNotification = null;
         }
      }
      
      private function addAFKFilterChampionSelectionAlertAction(param1:GameDTO, param2:Boolean = false) : void
      {
         if(this.AFKFilterChampionSelectionAlertAction != null)
         {
            this.AFKFilterChampionSelectionAlertAction.getMatchAccepted().removeAll();
            this.AFKFilterChampionSelectionAlertAction.getMatchDeclined().removeAll();
            this.AFKFilterChampionSelectionAlertAction.getDialogClosed().removeAll();
            this.AFKFilterChampionSelectionAlertAction.getMatchAccepted().add(this.onAFKFilterChampionSelectionAlertMatchAccepted);
            this.AFKFilterChampionSelectionAlertAction.getMatchDeclined().add(this.onAFKFilterChampionSelectionAlertMatchDeclined);
            this.AFKFilterChampionSelectionAlertAction.getDialogClosed().add(this.displayPendingAFKChatNotification);
            this.AFKFilterChampionSelectionAlertAction.add(this.gameAFKStatus,this.getStatusStringWithoutBots(param1),param2);
         }
      }
      
      private function onAFKFilterChampionSelectionAlertMatchAccepted(param1:ISignal) : void
      {
         param1.remove(this.onAFKFilterChampionSelectionAlertMatchAccepted);
         ServiceProxy.instance.gameService.acceptOrDeclinePoppedGame(true,null,null,this.onAcceptOrDeclinePoppedGameAckError);
      }
      
      private function onAFKFilterChampionSelectionAlertMatchDeclined(param1:ISignal) : void
      {
         param1.remove(this.onAFKFilterChampionSelectionAlertMatchDeclined);
         ServiceProxy.instance.gameService.acceptOrDeclinePoppedGame(false,null,null,this.onAcceptOrDeclinePoppedGameAckError);
      }
      
      private function onAcceptOrDeclinePoppedGameAckError(param1:ServerError) : void
      {
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         var _loc3_:AlertAction = new AlertAction(_loc2_.getString("resources","practiceGame_createOrJoinGame_invalidJoinErrorTitle"),_loc2_.getString("resources",param1.errorCode,param1.messageArguments));
         _loc3_.add();
         this.removeAFKFilterChampionSelectionAction();
      }
      
      private function getStatusStringWithoutBots(param1:GameDTO) : String
      {
         var _loc4_:IParticipant = null;
         var _loc5_:Array = null;
         if(!param1 || !param1.statusOfParticipants)
         {
            return null;
         }
         var _loc2_:String = new String();
         var _loc3_:ArrayCollection = new ArrayCollection();
         for each(_loc4_ in param1.teamOne)
         {
            if(_loc4_ is IParticipant)
            {
               _loc3_.addItem(_loc4_);
            }
         }
         for each(_loc4_ in param1.teamTwo)
         {
            if(_loc4_ is IParticipant)
            {
               _loc3_.addItem(_loc4_);
            }
         }
         _loc5_ = param1.statusOfParticipants.split("");
         if(_loc3_.length != _loc5_.length)
         {
            return null;
         }
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_.length)
         {
            if(!(_loc3_[_loc6_] is BotParticipant))
            {
               _loc2_ += _loc5_[_loc6_];
            }
            _loc6_++;
         }
         return _loc2_;
      }
      
      [Bindable(event="propertyChange")]
      public function get practiceGameManager() : PracticeGameManager
      {
         return this._2108295968practiceGameManager;
      }
      
      public function set practiceGameManager(param1:PracticeGameManager) : void
      {
         var _loc2_:Object = this._2108295968practiceGameManager;
         if(_loc2_ !== param1)
         {
            this._2108295968practiceGameManager = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"practiceGameManager",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isSpectating() : Boolean
      {
         return this._1488477984isSpectating;
      }
      
      public function set isSpectating(param1:Boolean) : void
      {
         var _loc2_:Object = this._1488477984isSpectating;
         if(_loc2_ !== param1)
         {
            this._1488477984isSpectating = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isSpectating",_loc2_,param1));
            }
         }
      }
      
      public function set gameModel(param1:GameModel) : void
      {
         var _loc2_:Object = this.gameModel;
         if(_loc2_ !== param1)
         {
            this._984376919gameModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameModel",_loc2_,param1));
            }
         }
      }
      
      public function set isSolo(param1:Boolean) : void
      {
         var _loc2_:Object = this.isSolo;
         if(_loc2_ !== param1)
         {
            this._1180118743isSolo = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isSolo",_loc2_,param1));
            }
         }
      }
      
      public function set currentGame(param1:GameDTO) : void
      {
         var _loc2_:Object = this.currentGame;
         if(_loc2_ !== param1)
         {
            this._600840459currentGame = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentGame",_loc2_,param1));
            }
         }
      }
      
      public function set currentState(param1:String) : void
      {
         var _loc2_:Object = this.currentState;
         if(_loc2_ !== param1)
         {
            this._1457822360currentState = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentState",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _leavers() : ArrayCollection
      {
         return this._1885851143_leavers;
      }
      
      public function set _leavers(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1885851143_leavers;
         if(_loc2_ !== param1)
         {
            this._1885851143_leavers = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_leavers",_loc2_,param1));
            }
         }
      }
      
      public function set gameMap(param1:GameMap) : void
      {
         var _loc2_:Object = this.gameMap;
         if(_loc2_ !== param1)
         {
            this._195623926gameMap = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameMap",_loc2_,param1));
            }
         }
      }
      
      public function set gameType(param1:String) : void
      {
         var _loc2_:Object = this.gameType;
         if(_loc2_ !== param1)
         {
            this._1769142708gameType = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameType",_loc2_,param1));
            }
         }
      }
      
      public function set championSmallIcons(param1:Boolean) : void
      {
         var _loc2_:Object = this.championSmallIcons;
         if(_loc2_ !== param1)
         {
            this._940837788championSmallIcons = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championSmallIcons",_loc2_,param1));
            }
         }
      }
   }
}

