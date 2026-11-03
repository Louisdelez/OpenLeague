package com.riotgames.pvpnet.game.controllers
{
   import blix.action.IAction;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.MessageDictionary;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.common.xmpp.data.invite.PresenceStatusXML;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.INotificationsProvider;
   import com.riotgames.platform.gameclient.chat.NotificationsProviderProxy;
   import com.riotgames.platform.gameclient.chat.actions.CreateChatRoomAction;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.gameclient.chat.controllers.PresenceController;
   import com.riotgames.platform.gameclient.chat.domain.ChatRoomType;
   import com.riotgames.platform.gameclient.chat.domain.DockedPrompt;
   import com.riotgames.platform.gameclient.domain.MatchMakerParams;
   import com.riotgames.platform.gameclient.domain.Summoner;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.platform.gameclient.domain.game.GameType;
   import com.riotgames.platform.gameclient.domain.game.GameViewState;
   import com.riotgames.platform.gameclient.domain.game.matched.BustedLeaver;
   import com.riotgames.platform.gameclient.domain.game.matched.FailedJoinPlayer;
   import com.riotgames.platform.gameclient.domain.game.matched.LeaverBusterLowPriorityQueueAbandoned;
   import com.riotgames.platform.gameclient.domain.game.matched.MatchSearchNotification;
   import com.riotgames.platform.gameclient.domain.game.matched.QueueDodger;
   import com.riotgames.platform.gameclient.domain.game.matched.QueueInfo;
   import com.riotgames.platform.gameclient.domain.invite.InviteState;
   import com.riotgames.platform.gameclient.domain.lobby.LobbyViewState;
   import com.riotgames.platform.gameclient.views.ViewMediator;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.celebration.CelebrationProviderProxy;
   import com.riotgames.pvpnet.game.alerts.AlreadyInGameAlertAction;
   import com.riotgames.pvpnet.game.alerts.ILeaverBusterAlertAction;
   import com.riotgames.pvpnet.game.alerts.IQueueDodgeAlertAction;
   import com.riotgames.pvpnet.game.alerts.IRankedQueueFailureAlertAction;
   import com.riotgames.pvpnet.game.controllers.actions.ShowQueueThrottledPopupAction;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.game.controllers.lobby.LobbyConfig;
   import com.riotgames.pvpnet.game.domain.GameQueueManager;
   import com.riotgames.pvpnet.invite.IInviteController;
   import com.riotgames.pvpnet.invite.IInviteProvider;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.alerter.AlertWaitAction;
   import com.riotgames.pvpnet.system.config.PlatformConfig;
   import com.riotgames.pvpnet.system.config.PlatformConfigProviderProxy;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   import mx.binding.utils.ChangeWatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.managers.CursorManager;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.rpc.events.ResultEvent;
   import org.igniterealtime.xiff.conference.RoomOccupant;
   
   public class MasterGameViewController implements IMasterGameViewController, IEventDispatcher
   {
      
      private var _269543472masterGameController:MasterGameController;
      
      private var _349030418lobbyController:ILobbyViewController;
      
      private var _2070536460applicationController:IAppController;
      
      [Inject]
      public var teamSelectionController:TeamSelectionController;
      
      private var _1137159790gameQueueManager:GameQueueManager;
      
      public var viewMediator:ViewMediator;
      
      public var chatController:ChatController;
      
      public var dockedNotificationsProvider:INotificationsProvider;
      
      public var presenceController:PresenceController;
      
      public var rankedQueueFailureAlertAction:IRankedQueueFailureAlertAction;
      
      public var queueDodgeAlertAction:IQueueDodgeAlertAction;
      
      public var leaverBusterPopupAction:ILeaverBusterAlertAction;
      
      private var _leaverBusterAccessToken:String = null;
      
      private var _inviteGroup:InviteGroup;
      
      private var inviteController:IInviteController;
      
      public var serviceProxy:ServiceProxy = ServiceProxy.instance;
      
      private var showQueueThrottledPopupAction:ShowQueueThrottledPopupAction = new ShowQueueThrottledPopupAction();
      
      private var _isBusy:Boolean = false;
      
      private var _isBusyChanged:Signal = new Signal();
      
      public var selectedLanguages:ArrayCollection;
      
      private var _2067570601isOwner:Boolean;
      
      private var _1769344611gameName:String;
      
      private var _2091584393isJoiningMatch:Boolean = false;
      
      private var logger:ILogger = Log.getLogger("com.riotgames.gameclient.controllers.game.MasterGameViewController");
      
      private var maximumDisplayableGameNameSize:int;
      
      private var mapsWatcher:ChangeWatcher;
      
      private var joinQueueTimer:Timer;
      
      private var joinQueueTimerRepeatCount:int;
      
      private var reQueueing:Boolean;
      
      private var joiningQueueWait:AlertWaitAction;
      
      private var waitingForLeaverbusterDialogue:Boolean = false;
      
      private var onCancelCallback:Function = null;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function MasterGameViewController()
      {
         super();
         this.isBusyChanged.add(this.onJoiningQueueChanged);
      }
      
      [Bindable(event="propertyChange")]
      public function get isBusy() : Boolean
      {
         return this._isBusy;
      }
      
      private function set _1180619197isBusy(param1:Boolean) : void
      {
         this._isBusy = param1;
         this._isBusyChanged.dispatch(param1);
      }
      
      public function get isBusyChanged() : ISignal
      {
         return this._isBusyChanged;
      }
      
      public function cleanup() : void
      {
      }
      
      public function cleanupCycle() : void
      {
         this.waitingForLeaverbusterDialogue = false;
         this._leaverBusterAccessToken = null;
         this.reset();
         if(Boolean(this.inviteController) && Boolean(!this.masterGameController.gameAFKStatus.waitingToRejoinTeamLobbyFromAFKReinvite) && !this.masterGameController.rejoiningQueue)
         {
            this.inviteController.setInviteGroupCancel(false);
         }
      }
      
      public function activate() : void
      {
      }
      
      public function deactivate() : void
      {
      }
      
      public function initialize() : void
      {
         this.leaverBusterPopupAction.getDialogueWaitCompleted().add(this.handleLeaverBusterDialogueWaitCompleted);
         this.leaverBusterPopupAction.getDialogueAborted().add(this.handleLeaverBusterDialogueAborted);
      }
      
      public function initializeCycle() : void
      {
         ProviderLookup.getProvider(IInviteProvider,this.onInviteProvider);
      }
      
      public function abortCycle() : void
      {
         switch(this.masterGameController.currentState)
         {
            case GameViewState.JOIN_QUEUE:
               this.cancelJoinQueueView();
               break;
            case GameViewState.WAIT_FOR_GAME:
               this.cancelWaitingForGame(null);
         }
      }
      
      private function reset() : void
      {
         this.isBusy = false;
         this.gameQueueManager.endQueueWait();
         this.leaveChatRoom();
      }
      
      public function initChatRoomForArrangingGame() : void
      {
      }
      
      public function initChatRoom(param1:String, param2:String, param3:String, param4:Function = null) : void
      {
         var _loc5_:IAction = new CreateChatRoomAction(this.masterGameController.chatController,param1,param2,param3);
         _loc5_.getCompleted().addOnce(this.onChatRoomCreated);
         if(param4 != null)
         {
            _loc5_.getCompleted().addOnce(param4);
         }
         _loc5_.invoke();
      }
      
      public function onChatRoomCreated(param1:CreateChatRoomAction) : void
      {
         var _loc2_:ChatRoom = param1.chatRoom;
         if(_loc2_ != null)
         {
            _loc2_.join();
            this.presenceController.sendPresenceUpdateToChatRoom(_loc2_);
            _loc2_.setChatRoomSortFunction(this.sortRoomByOwner);
            _loc2_.subject = ResourceManager.getInstance().getString("resources","waitingForGameView_chatRoom_Subject");
         }
      }
      
      public function leaveChatRoom() : void
      {
         if(Boolean(this._inviteGroup) && this._inviteGroup.chatRoom != null)
         {
            this.chatController.closeChatRoom(this._inviteGroup.chatRoom);
            this._inviteGroup.chatRoom = null;
         }
      }
      
      public function initializeGameMap() : void
      {
         if(this._inviteGroup.inviteState != InviteState.NONE)
         {
            if(this._inviteGroup.mapId > -1)
            {
               this.masterGameController.gameModel.gameMap = this.applicationController.getGameMap(this._inviteGroup.mapId);
            }
            else if(AppConfig.instance.availableMaps != null && AppConfig.instance.availableMaps.length > 0)
            {
               this.masterGameController.gameModel.gameMap = AppConfig.instance.availableMaps.getItemAt(0) as GameMap;
            }
            else
            {
               this.mapsWatcher = ChangeWatcher.watch(AppConfig.instance,"availableMaps",this.onAvailableMapsChanged);
            }
         }
      }
      
      public function cancelSelectMapView() : void
      {
         this.masterGameController.cancelGameFlow();
         this.reset();
      }
      
      public function handleSelectMapContinue() : void
      {
         var _loc1_:String = null;
         if(this.isSolo)
         {
            this._inviteGroup.clearParticipants();
            this.joinQueue();
         }
         else
         {
            this.lobbyController.requestLobbyState(LobbyViewState.CREATE_ARRANGED_TEAM_STATE);
            _loc1_ = GameType.RANKED_GAME_PREMADE;
            if(this.masterGameController.gameType == GameType.NORMAL_GAME || this.masterGameController.gameType == GameType.COOP_VS_AI)
            {
               _loc1_ = this.masterGameController.gameType;
            }
            this.inviteController.setInviteGroupAsInvitor(_loc1_,0,this.masterGameController.gameModel.gameMap.mapId,"");
            this.initChatRoomForArrangingGame();
         }
      }
      
      public function cancelJoinQueueView() : void
      {
         this.masterGameController.changePresence(PresenceStatusXML.GAME_STATUS_OUT_OF_GAME);
         this.inviteController.leaveLobby();
         this.inviteController.setInviteGroupCancel(false);
         if(!this.masterGameController.isShuttingDown)
         {
            this.masterGameController.cleanupAfterGameCompleteOrAborted();
            this.applicationController.home();
         }
      }
      
      public function showCancelledFromQueueMessage() : void
      {
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         var _loc2_:AlertAction = new AlertAction(_loc1_.getString("resources","waitingForGameView_title"),_loc1_.getString("resources","waitingForGameView_cancelled_from_queue"));
         _loc2_.add();
      }
      
      public function joinQueue() : void
      {
         var _loc4_:String = null;
         this.masterGameController.gameAFKStatus.waitingToRejoinTeamLobbyFromAFKReinvite = false;
         this._inviteGroup.isGroupOpenToMembers = false;
         LobbyConfig.instance.isNavigationEnabled = false;
         var _loc1_:int = int(this.gameQueueManager.selectedGameQueueConfig.numPlayersPerTeam);
         var _loc2_:int = int(this._inviteGroup.getAcceptedParticipantCount());
         var _loc3_:int = _loc2_ - _loc1_;
         if(_loc2_ == 1)
         {
            this.masterGameController.isSolo = true;
         }
         if(_loc2_ > _loc1_)
         {
            _loc4_ = ResourceManager.getInstance().getString("resources","invite_join_game_with_2_many_participants",[_loc2_,_loc1_,_loc3_]);
            NotificationsProviderProxy.instance.showDockedPrompt(DockedPrompt.create(_loc4_,ResourceManager.getInstance().getString("resources","XMPP-GAME-INVITE-TITLE"),"PVP.NET",ResourceManager.getInstance().getString("resources","common_button_ok")));
            return;
         }
         this.isJoiningMatch = true;
         this.isBusy = true;
         if(this.isSolo)
         {
            this.joinQueue_attach();
         }
         else
         {
            this.startJoinQueueTimer();
            this.inviteController.verifyInviteess();
         }
      }
      
      private function joinQueue_verifyAcked(param1:TimerEvent) : void
      {
         var _loc2_:IResourceManager = null;
         var _loc3_:AlertAction = null;
         var _loc4_:ArrayCollection = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         if(!this.inviteController.verifyInviteesHaveAcked())
         {
            ++this.joinQueueTimerRepeatCount;
            if(this.joinQueueTimerRepeatCount == 10)
            {
               this.stopJoinQueueTimer();
               this.isJoiningMatch = false;
               this.isBusy = false;
               this.reQueueing = false;
               LobbyConfig.instance.isNavigationEnabled = true;
               _loc4_ = this.inviteController.getVerifyInviteesHaveNotAcked();
               _loc5_ = ResourceManager.getInstance().getString("resources","general_generalAlertErrorTitle");
               _loc6_ = "";
               for each(_loc7_ in _loc4_)
               {
                  if(_loc6_ != "")
                  {
                     _loc6_ += ", ";
                  }
                  _loc6_ += _loc7_;
               }
               _loc2_ = ResourceManager.getInstance();
               if(_loc4_.length > 1)
               {
                  _loc8_ = _loc2_.getString("resources","XMPP-INVITES-VERIFY-NOT-ACKED",[_loc6_]);
               }
               else
               {
                  _loc8_ = _loc2_.getString("resources","XMPP-INVITES-VERIFY-NOT-ACKED_SINGLE_PLAYER",[_loc4_.getItemAt(0)]);
               }
               _loc3_ = new AlertAction(_loc5_,_loc8_);
               _loc3_.getCompleted().addOnce(this.handleCancelFailedJoinQueue);
               _loc3_.add();
            }
         }
         else
         {
            this.stopJoinQueueTimer();
            if(this.reQueueing)
            {
               setTimeout(this.joinQueue_attach,3000);
            }
            else
            {
               this.joinQueue_attach();
            }
         }
      }
      
      protected function handleCancelFailedJoinQueue() : void
      {
         this.cancelJoinQueueView();
      }
      
      private function joinQueue_attach() : void
      {
         var _loc4_:FailedJoinPlayer = null;
         var _loc5_:ArrayCollection = null;
         var _loc6_:ArrayCollection = null;
         if(!this.isSolo)
         {
            if(this._inviteGroup.getAcceptedParticipantCount() < this.gameQueueManager.selectedGameQueueConfig.minimumParticipantListSize)
            {
               this.gameQueueManager.joinEquivalentPremadeSoloQueue();
            }
            if(this._inviteGroup.getAcceptedParticipantCount() < this.gameQueueManager.selectedGameQueueConfig.minimumParticipantListSize)
            {
               _loc4_ = new FailedJoinPlayer();
               _loc4_.reasonFailed = FailedJoinPlayer.REASON_FAILED_QUEUE_PARTICIPANTS;
               _loc5_ = new ArrayCollection();
               _loc5_.addItem(_loc4_);
               this.handleFailedJoinPlayers(_loc5_);
               this.isBusy = false;
               return;
            }
         }
         var _loc1_:Number = Number(this.gameQueueManager.selectedGameQueueConfig.id);
         var _loc2_:MatchMakerParams = new MatchMakerParams();
         _loc2_.queueIds = new Array();
         _loc2_.queueIds[0] = _loc1_;
         _loc2_.lastMaestroMessage = this.applicationController.getLastInterestingMaestroMessage();
         _loc2_.botDifficulty = this.masterGameController.gameModel.difficulty;
         var _loc3_:Object = new Object();
         if(Boolean(this._leaverBusterAccessToken))
         {
            _loc3_["LEAVER_BUSTER_ACCESS_TOKEN"] = this._leaverBusterAccessToken;
         }
         if(this._inviteGroup.inviteId != null && this._inviteGroup.inviteId.length > 0)
         {
            _loc6_ = this._inviteGroup.getParticipantIDCollection();
            _loc2_.team = _loc6_;
            _loc2_.invitationId = this._inviteGroup.inviteId;
            _loc2_.teamId = this.gameQueueManager.rankedTeamId;
         }
         this.serviceProxy.matchMakerService.attachToQueue(_loc2_,_loc3_,this.onJoinQueueSuccess,this.onJoinQueueComplete,null);
         this.reQueueing = false;
         this._leaverBusterAccessToken = null;
      }
      
      private function onJoinQueueSuccess(param1:ResultEvent) : void
      {
         var _loc2_:MatchSearchNotification = param1.result as MatchSearchNotification;
         this.handleJoinQueue(_loc2_);
      }
      
      public function onJoinQueueComplete(param1:Boolean) : void
      {
         this.isJoiningMatch = false;
         this.isBusy = false;
         LobbyConfig.instance.isNavigationEnabled = true;
      }
      
      public function handleJoinQueue(param1:MatchSearchNotification) : void
      {
         var _loc2_:QueueInfo = null;
         var _loc3_:IResourceManager = null;
         var _loc4_:AlertAction = null;
         this.isJoiningMatch = false;
         if(param1.playerJoinFailures != null)
         {
            this.handleFailedJoinPlayers(param1.playerJoinFailures);
            return;
         }
         if(param1.ghostGameSummoners != null)
         {
            this.handleGhostGamePlayers(param1.ghostGameSummoners);
         }
         if(param1.joinedQueues.length > 0)
         {
            _loc2_ = param1.getJoinedQueueByIndex(0);
            this.handleQueueJoined(_loc2_);
         }
         else
         {
            this.serviceProxy.matchMakerService.purgeFromQueues(null,null,null);
            if(this.isSolo)
            {
               this.cancelJoinQueueView();
            }
            _loc3_ = ResourceManager.getInstance();
            _loc4_ = new AlertAction(_loc3_.getString("resources","general_generalAlertErrorTitle"),_loc3_.getString("resources",MessageDictionary.CANNOT_JOIN_QUEUE_ALREADY_IN));
            _loc4_.add();
         }
      }
      
      private function handleQueueJoined(param1:QueueInfo) : void
      {
         this.gameQueueManager.setQueueInfo(param1);
         this.startWaitForGame(true);
         var _loc2_:PlatformConfig = PlatformConfigProviderProxy.instance.getPlatformConfig();
         if(_loc2_ != null && _loc2_.queueThrottleDTO != null && Boolean(_loc2_.queueThrottleDTO.isQueueThrottled(param1.queueId)))
         {
            this.showQueueThrottledPopupAction.add();
         }
      }
      
      private function startWaitForGame(param1:Boolean) : void
      {
         this.gameQueueManager.beginQueueWait(param1);
         this.inviteController.disablePendingInvites();
         this.masterGameController.changePresence(PresenceStatusXML.GAME_STATUS_IN_QUEUE);
         this.masterGameController.currentState = GameViewState.WAIT_FOR_GAME;
         this.isJoiningMatch = false;
         this.isBusy = false;
         LobbyConfig.instance.isNavigationEnabled = true;
         if(!this.isSolo)
         {
            if(this._inviteGroup.isOwner)
            {
            }
            this._inviteGroup.isGroupOpenToMembers = true;
            this.masterGameController.chatController.enterMatchmakingQueueChatRoom(this._inviteGroup.inviteId,ChatRoomType.ARRANGING_GAME,this._inviteGroup.chatRoom);
         }
      }
      
      private function handleGhostGamePlayers(param1:ArrayCollection) : void
      {
         var _loc3_:Summoner = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:AlertAction = null;
         var _loc2_:Boolean = false;
         if(param1 != null && param1.length > 0)
         {
            for each(_loc3_ in param1)
            {
               if(_loc3_.sumId == Session.instance.summoner.sumId)
               {
                  _loc2_ = true;
               }
            }
         }
         if(_loc2_)
         {
            _loc4_ = RiotResourceLoader.getString("matchmaking_joinqueue_user_stats_will_be_delayed_title","End of game stats may be delayed");
            _loc5_ = RiotResourceLoader.getString("matchmaking_joinqueue_user_stats_will_be_delayed_message","End of game stats for your previous game may be delayed and will be made available later.");
            _loc6_ = new AlertAction(_loc4_,_loc5_);
            _loc6_.add();
         }
      }
      
      private function handleFailedJoinPlayers(param1:ArrayCollection) : void
      {
         var _loc2_:AlertAction = null;
         var _loc14_:String = null;
         var _loc20_:FailedJoinPlayer = null;
         var _loc21_:String = null;
         var _loc22_:FailedJoinPlayer = null;
         var _loc3_:IResourceManager = ResourceManager.getInstance();
         var _loc4_:ArrayCollection = new ArrayCollection();
         var _loc5_:ArrayCollection = new ArrayCollection();
         var _loc6_:ArrayCollection = new ArrayCollection();
         var _loc7_:ArrayCollection = new ArrayCollection();
         var _loc8_:ArrayCollection = new ArrayCollection();
         var _loc9_:ArrayCollection = new ArrayCollection();
         var _loc10_:ArrayCollection = new ArrayCollection();
         var _loc11_:Boolean = false;
         var _loc12_:Boolean = false;
         var _loc13_:Boolean = false;
         var _loc15_:ArrayCollection = new ArrayCollection();
         var _loc16_:Boolean = false;
         if(param1 != null && param1.length > 0)
         {
            for each(_loc20_ in param1)
            {
               if(_loc20_.reasonFailed == FailedJoinPlayer.REASON_FAILED_MINOR_RESTRICTED)
               {
                  if(_loc20_.summoner.sumId == Session.instance.summoner.sumId)
                  {
                     _loc11_ = true;
                     _loc2_ = new AlertAction(RiotResourceLoader.getString("matchmaking_joinqueue_shutdown_failure_title","Attempt to join queue failed"),RiotResourceLoader.getString("matchmaking_joinqueue_shutdown_failure_self","You do not have the time required to play a game in this queue before shutdown takes effect."));
                     _loc2_.add();
                     this.masterGameController.cancelGameFlow();
                     return;
                  }
                  _loc8_.addItem(_loc20_.summoner.name);
               }
               else if(_loc20_.reasonFailed == FailedJoinPlayer.REASON_FAILED_BINGE_PREVENTION)
               {
                  if(_loc20_.summoner.sumId == Session.instance.summoner.sumId)
                  {
                     _loc16_ = true;
                     _loc2_ = new AlertAction(RiotResourceLoader.getString("matchmaking_joinqueue_binge_failure_title","Attempt to join queue failed"),RiotResourceLoader.getString("matchmaking_joinqueue_binge_failure_self","You can not join the queue due to currently being in a binge play prevention timeout period."));
                     _loc2_.add();
                     this.masterGameController.cancelGameFlow();
                     return;
                  }
                  _loc15_.addItem(_loc20_.summoner.name);
               }
               else if(_loc20_ is QueueDodger)
               {
                  _loc4_.addItem(_loc20_);
               }
               else if(_loc20_.reasonFailed == FailedJoinPlayer.REASON_FAILED_ALREADY_IN_GAME)
               {
                  _loc5_.addItem(_loc20_);
               }
               else if(_loc20_.reasonFailed == FailedJoinPlayer.REASON_FAILED_QUEUE_DISABLED)
               {
                  _loc12_ = true;
               }
               else if(_loc20_.reasonFailed == FailedJoinPlayer.REASON_FAILED_RANKED_MIN_LEVEL || _loc20_.reasonFailed == FailedJoinPlayer.REASON_FAILED_RANKED_NUM_CHAMPS || _loc20_.reasonFailed == FailedJoinPlayer.REASON_FAILED_RANKED_NUM_CHAMPS_NO_FREE || _loc20_.reasonFailed == FailedJoinPlayer.REASON_FAILED_QUEUE_RESTRICTED || _loc20_.reasonFailed == FailedJoinPlayer.REASON_FAILED_RANKED_RESTRICTED || _loc20_.reasonFailed == FailedJoinPlayer.REASON_FAILED_RANKED_MAX_LEVEL)
               {
                  _loc7_.addItem(_loc20_);
               }
               else if(_loc20_.reasonFailed == FailedJoinPlayer.REASON_FAILED_QUEUE_THROTTLED)
               {
                  _loc13_ = true;
               }
               else if(_loc20_.reasonFailed == FailedJoinPlayer.REASON_FAILED_QUEUE_PARTICIPANTS)
               {
                  _loc6_.addItem(_loc20_);
               }
               else if(_loc20_.reasonFailed == FailedJoinPlayer.REASON_FAILED_LEAVER_BUSTER_TAINTED_WARNING)
               {
                  _loc9_.addItem(_loc20_);
               }
               else if(_loc20_.reasonFailed == FailedJoinPlayer.REASON_FAILED_LEAVER_BUSTED)
               {
                  _loc10_.addItem(_loc20_);
               }
            }
         }
         var _loc17_:ArrayCollection = new ArrayCollection();
         var _loc18_:Boolean = false;
         var _loc19_:Boolean = false;
         if(_loc8_.length > 0 && !_loc11_)
         {
            _loc17_ = _loc8_;
            _loc18_ = _loc11_;
            _loc19_ = true;
         }
         if(_loc15_.length > 0 && !_loc16_)
         {
            _loc17_ = _loc15_;
            _loc18_ = _loc16_;
         }
         if(_loc17_.length > 0 && !_loc18_)
         {
            if(_loc19_)
            {
            }
            if(_loc17_.length == 1)
            {
               _loc21_ = RiotResourceLoader.getString("matchmaking_joinqueue_shutdown_failure_user","Because your team had players that didn\'t meet the required game play criteria, your team was unable to join the queue");
            }
            else
            {
               _loc21_ = RiotResourceLoader.getString("matchmaking_joinqueue_shutdown_failure_many","Because your team had players that didn\'t meet the required game play criteria, your team was unable to join the queue");
            }
            _loc2_ = new AlertAction(RiotResourceLoader.getString("matchmaking_joinqueue_shutdown_failure_title","Attempt to join queue failed"),_loc21_);
            _loc2_.add();
         }
         else if(!_loc12_ && !_loc13_)
         {
            if(_loc5_.length > 0)
            {
               new AlreadyInGameAlertAction().add(_loc5_);
            }
            if(_loc4_.length > 0)
            {
               if(this.queueDodgeAlertAction != null)
               {
                  this.queueDodgeAlertAction.add(_loc4_);
               }
            }
            if(_loc6_.length > 0)
            {
               _loc21_ = RiotResourceLoader.getString("matchmaking_joinqueue_shutdown_failure_quit","Because your team had players that quit, your team was unable to join the queue");
               _loc2_ = new AlertAction(RiotResourceLoader.getString("matchmaking_joinqueue_shutdown_failure_title","Attempt to join queue failed"),_loc21_);
               _loc2_.add();
            }
            if(_loc7_.length > 0 && this.rankedQueueFailureAlertAction != null)
            {
               this.rankedQueueFailureAlertAction.add(_loc7_,this.gameQueueManager.selectedGameQueueConfig.minLevel);
            }
            if(_loc9_.length > 0)
            {
               for each(_loc22_ in _loc9_)
               {
                  if(_loc22_.summoner.acctId == Session.instance.summoner.acctId)
                  {
                     CelebrationProviderProxy.instance.showFirstTimeLeaverDialogue();
                     break;
                  }
               }
            }
            if(_loc10_.length > 0)
            {
               this.waitingForLeaverbusterDialogue = true;
               this._leaverBusterAccessToken = this.getLeaverBusterAccessTokenFromLeavers(_loc10_);
               this.leaverBusterPopupAction.showDialogueForLeavers(_loc10_,this.isSolo);
            }
         }
         else if(_loc13_)
         {
            _loc2_ = new AlertAction(_loc3_.getString("resources","general_generalAlertErrorTitle"),_loc3_.getString("resources","matchmaking_joinqueue_queue_throttled"));
            _loc2_.add();
         }
         else
         {
            _loc2_ = new AlertAction(_loc3_.getString("resources","general_generalAlertErrorTitle"),_loc3_.getString("resources","matchmaking_joinqueue_queue_disabled"));
            _loc2_.add();
         }
         if(this._inviteGroup.getAcceptedParticipantCount() > 1)
         {
            this.gameQueueManager.joinEquivalentFullPremadeQueue();
         }
         this._inviteGroup.isGroupOpenToMembers = true;
      }
      
      private function handleLeaverBusterDialogueWaitCompleted(param1:ArrayCollection) : void
      {
         if(this.waitingForLeaverbusterDialogue)
         {
            if(this.isSolo || Boolean(this._inviteGroup.isOwner))
            {
               this.joinQueue();
            }
         }
         this.waitingForLeaverbusterDialogue = false;
      }
      
      private function getLeaverBusterAccessTokenFromLeavers(param1:ArrayCollection) : String
      {
         var _loc2_:BustedLeaver = null;
         for each(_loc2_ in param1)
         {
            if(Boolean(_loc2_.accessToken))
            {
               return _loc2_.accessToken;
            }
         }
         return null;
      }
      
      private function handleLeaverBusterDialogueAborted(param1:Boolean) : void
      {
         if(!param1)
         {
            return;
         }
         if(Boolean(this._leaverBusterAccessToken))
         {
            this.serviceProxy.clientFacadeService.abandonLeaverBusterLowPriorityQueue(this._leaverBusterAccessToken);
         }
         this._leaverBusterAccessToken = null;
         this.waitingForLeaverbusterDialogue = false;
      }
      
      public function handleLeaverBusterLowPriorityQueueAbandoned(param1:LeaverBusterLowPriorityQueueAbandoned) : void
      {
         var _loc2_:String = param1.abandonerName;
         var _loc3_:DockedPrompt = new DockedPrompt();
         _loc3_.leftButtonLabel = ResourceManager.getInstance().getString("resources","common_button_ok");
         _loc3_.message = ResourceManager.getInstance().getString("resources","matchmaking_joinqueue_leaverBusterQueueAbandoned",[_loc2_]);
         _loc3_.title = ResourceManager.getInstance().getString("resources","matchmaking_joinqueue_leaverbusted_title");
         _loc3_.timeStamp = new Date();
         NotificationsProviderProxy.instance.showDockedPrompt(_loc3_);
         this.leaverBusterPopupAction.removeDialogue();
         this._leaverBusterAccessToken = null;
         this.waitingForLeaverbusterDialogue = false;
      }
      
      private function startJoinQueueTimer() : void
      {
         this.joinQueueTimer = new Timer(1000);
         this.joinQueueTimer.addEventListener("timer",this.joinQueue_verifyAcked);
         this.joinQueueTimerRepeatCount = 0;
         this.joinQueueTimer.start();
      }
      
      private function stopJoinQueueTimer() : void
      {
         this.joinQueueTimer.stop();
         this.joinQueueTimer = null;
      }
      
      public function cancelWaitingForGame(param1:Function) : void
      {
         if(this.masterGameController.currentState == GameViewState.TEAM_SELECTION)
         {
            this.teamSelectionController.quitGame(this.onQuitCustomGameError);
         }
         else
         {
            this.onCancelCallback = param1;
            if(this.gameQueueManager.queueInfo != null)
            {
               this.isBusy = true;
               this.serviceProxy.matchMakerService.cancelFromQueueIfPossible(this.gameQueueManager.queueInfo.queueId,this.onCancelWaitingForGame,this.onCancelWaitingForGameComplete,null);
            }
            else
            {
               this.onCancelWaitingForGame(ResultEvent.createEvent(true));
            }
         }
      }
      
      private function onQuitCustomGameError(param1:Error) : void
      {
         this.logger.error("unable to quit custom game");
      }
      
      private function onCancelWaitingForGame(param1:ResultEvent) : void
      {
         var _loc3_:IResourceManager = null;
         var _loc4_:AlertAction = null;
         var _loc2_:Boolean = param1.result as Boolean;
         if(_loc2_)
         {
            this.masterGameController.changePresence(PresenceStatusXML.GAME_STATUS_OUT_OF_GAME);
            this.masterGameController.cancelGameFlow();
            this.isJoiningMatch = false;
         }
         else
         {
            _loc3_ = ResourceManager.getInstance();
            _loc4_ = new AlertAction(_loc3_.getString("resources","waitingForGameView_title"),_loc3_.getString("resources","waitingForGameView_cancel_failed"));
            _loc4_.getCompleted().addOnce(this.handleCancelFailedJoinQueue);
            _loc4_.add();
         }
         if(this.onCancelCallback != null)
         {
            this.onCancelCallback(_loc2_);
         }
      }
      
      public function onCancelWaitingForGameComplete(param1:Boolean) : void
      {
         this.isBusy = false;
      }
      
      private function onAvailableMapsChanged(param1:PropertyChangeEvent) : void
      {
         if(this.mapsWatcher == null)
         {
            return;
         }
         if(this.masterGameController.gameModel.gameMap == null)
         {
            this.masterGameController.gameModel.gameMap = AppConfig.instance.availableMaps.getItemAt(0) as GameMap;
         }
         this.mapsWatcher.unwatch();
         this.mapsWatcher = null;
      }
      
      public function rejoinQueue(param1:Boolean) : void
      {
         var _loc3_:ConfigurationModel = null;
         this.isJoiningMatch = true;
         var _loc2_:int = 0;
         if(this.isSolo)
         {
            if(this.masterGameController.gameType == GameType.NORMAL_GAME)
            {
               this.masterGameController.startNormalGameFlow(this.isSolo);
               if(param1)
               {
                  setTimeout(this.joinQueue,3000);
               }
            }
            else if(this.masterGameController.gameType == GameType.COOP_VS_AI)
            {
               this.masterGameController.startCoopVsAIGameFlow(this.isSolo);
               if(param1)
               {
                  setTimeout(this.joinQueue,3000);
               }
            }
            else if(this.masterGameController.gameType == GameType.RANKED_GAME_SOLO)
            {
               this.masterGameController.startRankedGameFlow(this.isSolo);
               if(param1)
               {
                  setTimeout(this.joinQueue,3000);
               }
            }
         }
         else
         {
            if(this.masterGameController.gameType == GameType.NORMAL_GAME)
            {
               this.masterGameController.startNormalGameFlow(this.isSolo);
            }
            else if(this.masterGameController.gameType == GameType.COOP_VS_AI)
            {
               this.masterGameController.startCoopVsAIGameFlow(this.isSolo);
            }
            else if(this.masterGameController.gameType == GameType.RANKED_GAME_PREMADE)
            {
               this.masterGameController.startRankedGameFlow(this.isSolo);
            }
            if(param1)
            {
               _loc3_ = DynamicClientConfigManager.getConfiguration("GameInvites","ServiceEnabled",true,null);
               if(!_loc3_.getBoolean())
               {
                  this._inviteGroup.setRequeueInviteId();
               }
               if(this._inviteGroup.isOwner)
               {
                  this.reQueueing = true;
                  this.joinQueue();
               }
               else
               {
                  this.inviteeWaitForJoinQueue();
               }
            }
         }
         this.startWaitForGame(param1);
      }
      
      private function inviteeWaitForJoinQueue() : void
      {
         this.isJoiningMatch = true;
         this.serviceProxy.matchMakerService.acceptInviteForMatchmakingGame(this._inviteGroup.inviteId,null,null,null,null);
      }
      
      private function allRequersAccepted() : void
      {
         this.joinQueue();
      }
      
      private function sortRoomByOwner(param1:Object, param2:Object, param3:Array = null) : int
      {
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:RoomOccupant = param1 as RoomOccupant;
         var _loc7_:RoomOccupant = param2 as RoomOccupant;
         _loc4_ = Boolean(this._inviteGroup.isParticipantOwner(_loc6_));
         _loc5_ = Boolean(this._inviteGroup.isParticipantOwner(_loc7_));
         if(_loc4_ == _loc5_)
         {
            return 0;
         }
         if(_loc4_)
         {
            return -1;
         }
         return 1;
      }
      
      private function get isSolo() : Boolean
      {
         return this.masterGameController.isSolo;
      }
      
      private function onJoiningQueueChanged(param1:Boolean) : void
      {
         var _loc2_:IResourceManager = null;
         if(param1)
         {
            CursorManager.getInstance().setBusyCursor();
            _loc2_ = ResourceManager.getInstance();
            if(this.joiningQueueWait == null)
            {
               this.joiningQueueWait = new AlertWaitAction(_loc2_.getString("resources","serverWait_retrievingDataMessage"),_loc2_.getString("resources","serverWait_loadingMessage"));
            }
            this.joiningQueueWait.add();
         }
         else
         {
            if(Boolean(this.joiningQueueWait))
            {
               this.joiningQueueWait.complete();
            }
            CursorManager.getInstance().removeBusyCursor();
         }
      }
      
      private function onInviteProvider(param1:IInviteProvider) : void
      {
         this.inviteController = param1.getInviteController();
         this._inviteGroup = param1.getInviteGroup();
         this.initializeGameMap();
         this.gameQueueManager.setAvailableQueues(this.masterGameController.gameType);
      }
      
      [Bindable(event="propertyChange")]
      public function get masterGameController() : MasterGameController
      {
         return this._269543472masterGameController;
      }
      
      public function set masterGameController(param1:MasterGameController) : void
      {
         var _loc2_:Object = this._269543472masterGameController;
         if(_loc2_ !== param1)
         {
            this._269543472masterGameController = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"masterGameController",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lobbyController() : ILobbyViewController
      {
         return this._349030418lobbyController;
      }
      
      public function set lobbyController(param1:ILobbyViewController) : void
      {
         var _loc2_:Object = this._349030418lobbyController;
         if(_loc2_ !== param1)
         {
            this._349030418lobbyController = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lobbyController",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get applicationController() : IAppController
      {
         return this._2070536460applicationController;
      }
      
      public function set applicationController(param1:IAppController) : void
      {
         var _loc2_:Object = this._2070536460applicationController;
         if(_loc2_ !== param1)
         {
            this._2070536460applicationController = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"applicationController",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameQueueManager() : GameQueueManager
      {
         return this._1137159790gameQueueManager;
      }
      
      public function set gameQueueManager(param1:GameQueueManager) : void
      {
         var _loc2_:Object = this._1137159790gameQueueManager;
         if(_loc2_ !== param1)
         {
            this._1137159790gameQueueManager = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameQueueManager",_loc2_,param1));
            }
         }
      }
      
      public function set isBusy(param1:Boolean) : void
      {
         var _loc2_:Object = this.isBusy;
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
      public function get isOwner() : Boolean
      {
         return this._2067570601isOwner;
      }
      
      public function set isOwner(param1:Boolean) : void
      {
         var _loc2_:Object = this._2067570601isOwner;
         if(_loc2_ !== param1)
         {
            this._2067570601isOwner = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isOwner",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameName() : String
      {
         return this._1769344611gameName;
      }
      
      public function set gameName(param1:String) : void
      {
         var _loc2_:Object = this._1769344611gameName;
         if(_loc2_ !== param1)
         {
            this._1769344611gameName = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameName",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isJoiningMatch() : Boolean
      {
         return this._2091584393isJoiningMatch;
      }
      
      public function set isJoiningMatch(param1:Boolean) : void
      {
         var _loc2_:Object = this._2091584393isJoiningMatch;
         if(_loc2_ !== param1)
         {
            this._2091584393isJoiningMatch = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isJoiningMatch",_loc2_,param1));
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

