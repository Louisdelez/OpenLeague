package com.riotgames.pvpnet.game.controllers
{
   import blix.action.IAction;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.MessageDictionary;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.gameclient.chat.controllers.PresenceController;
   import com.riotgames.platform.gameclient.chat.domain.ChatRoomType;
   import com.riotgames.platform.gameclient.chat.domain.PresenceStatusData;
   import com.riotgames.platform.gameclient.domain.BotParticipant;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.GameObserver;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import com.riotgames.platform.gameclient.domain.PlayerParticipant;
   import com.riotgames.platform.gameclient.domain.StartChampSelectDTO;
   import com.riotgames.platform.gameclient.domain.game.*;
   import com.riotgames.platform.gameclient.domain.game.practice.RewardsDisabledReason;
   import com.riotgames.platform.gameclient.domain.game.practice.Team;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfig;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfigManager;
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipant;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.game.QuitPracticeGameAction;
   import com.riotgames.pvpnet.game.alerts.IRankedQueueFailureAlertAction;
   import com.riotgames.pvpnet.game.controllers.practice.TeamSelectionSlot;
   import com.riotgames.pvpnet.game.variants.GameFlowVariant;
   import com.riotgames.pvpnet.game.variants.GameFlowVariantFactory;
   import com.riotgames.pvpnet.invite.IInviteController;
   import com.riotgames.pvpnet.invite.IInviteProvider;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.getQualifiedClassName;
   import mx.binding.utils.ChangeWatcher;
   import mx.collections.ArrayCollection;
   import mx.events.CollectionEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.PropertyChangeEventKind;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.ResourceManager;
   import mx.rpc.events.ResultEvent;
   import mx.utils.ObjectUtil;
   import org.igniterealtime.xiff.conference.RoomOccupant;
   import org.igniterealtime.xiff.data.Presence;
   import org.igniterealtime.xiff.events.RoomEvent;
   
   public class TeamSelectionController extends EventDispatcher implements ICycleViewController
   {
      
      public static const WAITING_CHANGE_TEAMS:String = "changeTeams";
      
      public static const WAITING_START_GAME:String = "startGame";
      
      private var _269543472masterGameController:MasterGameController;
      
      private var _1019249940chatController:ChatController;
      
      private var inviteController:IInviteController;
      
      private var inviteGroup:InviteGroup;
      
      public var session:Session = Session.instance;
      
      public var clientConfig:ClientConfig = ClientConfig.instance;
      
      public var serviceProxy:ServiceProxy = ServiceProxy.instance;
      
      public var rankedQueueFailureAlertAction:IRankedQueueFailureAlertAction;
      
      private var _1180619197isBusy:Boolean;
      
      private var _1781605956waitingState:String = "";
      
      private var _491640361blueTeam:ArrayCollection;
      
      private var _blueTeamChanged:Signal = new Signal();
      
      private var _1494003687blueTeamChampionSelections:ArrayCollection;
      
      private var _1726335646blueTeamSlots:ArrayCollection = new ArrayCollection();
      
      private var _932544455purpleTeam:ArrayCollection;
      
      private var _purpleTeamChanged:Signal = new Signal();
      
      private var _953479625purpleTeamChampionSelections:ArrayCollection;
      
      private var _1137827460purpleTeamSlots:ArrayCollection = new ArrayCollection();
      
      private var _1326329257spectatorTeamSlots:ArrayCollection = new ArrayCollection();
      
      private var _spectatorTeamChanged:Signal = new Signal();
      
      private var _195623926gameMap:GameMap;
      
      private var _1769344611gameName:String;
      
      private var _1437342803chatRoom:ChatRoom;
      
      private var _1335052023availableBotDifficulties:ArrayCollection;
      
      private var _2109547355currentGameSpectatable:Boolean = false;
      
      private var _currentGameSpectatableChanged:Signal = new Signal();
      
      private var _canAddBotsToGame:Boolean = false;
      
      public var userDataMap:Object = new Object();
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var maximumDisplayableGameNameSize:int;
      
      private var spectatorWatcher:ChangeWatcher;
      
      private var blueTeamWatcher:ChangeWatcher;
      
      private var purpleTeamWatcher:ChangeWatcher;
      
      private var spectatorTeam:ArrayCollection;
      
      private var practiceGameWatcher:ChangeWatcher;
      
      private var proxiedErrorHandler:Function;
      
      private var proxiedSuccessHandler:Function;
      
      private var newBotParticipant:BotParticipant;
      
      private var statusChangeWatchers:ArrayCollection = new ArrayCollection();
      
      private var _isOwner:Boolean = false;
      
      private var _isOwnerChanged:Signal = new Signal();
      
      private var _teamSelectionActivated:Signal = new Signal();
      
      private var _teamSelectionDeactivated:Signal = new Signal();
      
      public function TeamSelectionController()
      {
         super();
      }
      
      private static function teamContainsNonObserver(param1:ArrayCollection, param2:Object) : Boolean
      {
         var _loc3_:PlayerParticipant = null;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:PlayerParticipant = null;
         if(param2 is BotParticipant)
         {
            return teamContainsBot(param1,BotParticipant(param2));
         }
         if(param2 is PlayerParticipant)
         {
            _loc3_ = param2 as PlayerParticipant;
            _loc4_ = 0;
            for each(_loc5_ in param1)
            {
               if(_loc5_ is PlayerParticipant)
               {
                  _loc6_ = _loc5_ as PlayerParticipant;
                  if(_loc6_.summonerName == _loc3_.summonerName)
                  {
                     param1.removeItemAt(_loc4_);
                     param1.addItemAt(param2,_loc4_);
                     return true;
                  }
               }
               _loc4_++;
            }
         }
         return param1.contains(param2);
      }
      
      private static function teamContainsObserver(param1:ArrayCollection, param2:GameObserver) : Boolean
      {
         var _loc3_:GameObserver = null;
         for each(_loc3_ in param1)
         {
            if(param2.summonerId == _loc3_.summonerId)
            {
               return true;
            }
         }
         return false;
      }
      
      private static function teamContainsBot(param1:ArrayCollection, param2:BotParticipant) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:GameParticipant = null;
         for each(_loc4_ in param1)
         {
            if(!(_loc4_ is PlayerParticipant))
            {
               if(_loc4_.summonerInternalName == param2.summonerInternalName)
               {
                  _loc3_ = true;
                  break;
               }
            }
         }
         return _loc3_;
      }
      
      [Bindable(event="canAddBotsChanged")]
      public function get canAddBotsToGame() : Boolean
      {
         return this._canAddBotsToGame;
      }
      
      public function set canAddBotsToGame(param1:Boolean) : void
      {
         if(this._canAddBotsToGame != param1)
         {
            this._canAddBotsToGame = param1;
            dispatchEvent(new Event("canAddBotsChanged"));
         }
      }
      
      public function get teamSelectionActivated() : ISignal
      {
         return this._teamSelectionActivated;
      }
      
      public function get teamSelectionDeactivated() : ISignal
      {
         return this._teamSelectionDeactivated;
      }
      
      [Bindable(event="propertyChange")]
      public function get isOwner() : Boolean
      {
         return this._isOwner;
      }
      
      private function set _2067570601isOwner(param1:Boolean) : void
      {
         this._isOwner = param1;
         this._isOwnerChanged.dispatch(param1);
      }
      
      public function get isOwnerChanged() : ISignal
      {
         return this._isOwnerChanged;
      }
      
      public function initialize() : void
      {
         var _loc1_:Array = null;
         this.maximumDisplayableGameNameSize = ResourceManager.getInstance().getNumber("resources","practiceGame_new_maxTeamDisplayLength");
         ProviderLookup.getProvider(IInviteProvider,this.onInviteProvider);
         if(this.availableBotDifficulties == null)
         {
            _loc1_ = new Array();
            _loc1_.push(ResourceManager.getInstance().getString("resources","bot_difficulty_easy"));
            if(DynamicClientConfigManager.getConfiguration("BotConfigurations","IntermediateInCustoms",false).getBoolean())
            {
               _loc1_.push(ResourceManager.getInstance().getString("resources","bot_difficulty_medium"));
            }
            this.availableBotDifficulties = new ArrayCollection(_loc1_);
         }
      }
      
      public function initializeCycle() : void
      {
      }
      
      public function abortCycle() : void
      {
         this.quitGame(null);
      }
      
      public function cleanup() : void
      {
      }
      
      public function cleanupCycle() : void
      {
      }
      
      public function activate() : void
      {
         this.practiceGameWatcher = ChangeWatcher.watch(this.masterGameController,"currentGame",this.onPracticeGameChanged);
         this.clearChangeWatchers();
         this.blueTeam = this.masterGameController.currentGame.teamOne;
         this.purpleTeam = this.masterGameController.currentGame.teamTwo;
         this.spectatorTeam = this.masterGameController.currentGame.observers;
         this.gameMap = this.masterGameController.gameMap;
         this.isOwner = this.masterGameController.amIGameOwner;
         this.watchForTeamChanges();
         var _loc1_:String = this.masterGameController.currentGame.name;
         if(_loc1_.length > this.maximumDisplayableGameNameSize)
         {
            _loc1_ = _loc1_.substr(0,this.maximumDisplayableGameNameSize) + "...";
         }
         this.gameName = _loc1_;
         var _loc2_:String = this.gameName + this.masterGameController.currentGame.id;
         var _loc3_:String = this.chatController.obfuscateChatRoom(_loc2_,ChatRoomType.ARRANGING_PRACTICE);
         var _loc4_:String = this.masterGameController.currentGame.roomPassword;
         this.chatController.requestChatRoom(_loc3_,_loc3_,_loc4_,ChatRoomType.ARRANGING_PRACTICE,this.onChatRoomCreated);
         if(this.isOwner)
         {
            this.initializeTeamChampionSelections();
         }
         this._teamSelectionActivated.dispatch();
      }
      
      private function clearChangeWatchers() : void
      {
         if(Boolean(this.blueTeam))
         {
            this.blueTeam.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onBlueTeamChanged);
         }
         if(Boolean(this.purpleTeam))
         {
            this.purpleTeam.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onPurpleTeamChanged);
         }
         if(Boolean(this.spectatorTeam))
         {
            this.spectatorTeam.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onSpectatorTeamChanged);
         }
         if(Boolean(this.blueTeamWatcher))
         {
            this.blueTeamWatcher.unwatch();
         }
         if(Boolean(this.purpleTeamWatcher))
         {
            this.purpleTeamWatcher.unwatch();
         }
         if(Boolean(this.spectatorWatcher))
         {
            this.spectatorWatcher.unwatch();
         }
      }
      
      private function watchForTeamChanges() : void
      {
         this.clearChangeWatchers();
         this.blueTeamWatcher = ChangeWatcher.watch(this,"blueTeam",this.onBlueTeamChanged);
         this.onBlueTeamChanged(null);
         this.purpleTeamWatcher = ChangeWatcher.watch(this,"purpleTeam",this.onPurpleTeamChanged);
         this.onPurpleTeamChanged(null);
         this.spectatorWatcher = ChangeWatcher.watch(this,"spectatorTeam",this.onSpectatorTeamChanged);
         this.onSpectatorTeamChanged(null);
      }
      
      private function onBlueTeamChanged(param1:Event) : void
      {
         if(Boolean(this.masterGameController.currentGame))
         {
            this.updateTeamSlots(Team.TEAM_BLUE,this.blueTeam,this.blueTeamSlots,this.masterGameController.currentGame.maxNumPlayers * 0.5);
            this._blueTeamChanged.dispatch();
            if(Boolean(this.blueTeam))
            {
               this.blueTeam.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onBlueTeamChanged);
            }
            this.onSpectatorTeamChanged(null);
         }
      }
      
      private function onPurpleTeamChanged(param1:Event) : void
      {
         if(Boolean(this.masterGameController.currentGame))
         {
            this.updateTeamSlots(Team.TEAM_PURPLE,this.purpleTeam,this.purpleTeamSlots,this.masterGameController.currentGame.maxNumPlayers * 0.5);
            this._purpleTeamChanged.dispatch();
            if(Boolean(this.purpleTeam))
            {
               this.purpleTeam.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onPurpleTeamChanged);
            }
            this.onSpectatorTeamChanged(null);
         }
      }
      
      public function get blueTeamChanged() : ISignal
      {
         return this._blueTeamChanged;
      }
      
      public function get purpleTeamChanged() : ISignal
      {
         return this._purpleTeamChanged;
      }
      
      public function get spectatorTeamChanged() : ISignal
      {
         return this._spectatorTeamChanged;
      }
      
      public function get currentGameSpectatableChanged() : ISignal
      {
         return this._currentGameSpectatableChanged;
      }
      
      private function onSpectatorTeamChanged(param1:Event) : void
      {
         if(Boolean(this.masterGameController.currentGame))
         {
            this.updateTeamSlots(Team.SPECTATOR,this.spectatorTeam,this.spectatorTeamSlots,this.clientConfig.spectatorSlotLimit);
            this._spectatorTeamChanged.dispatch();
            if(Boolean(this.spectatorTeam))
            {
               this.spectatorTeam.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onSpectatorTeamChanged);
            }
         }
      }
      
      private function updateTeamSlots(param1:String, param2:ArrayCollection, param3:ArrayCollection, param4:int) : void
      {
         var _loc5_:TeamSelectionSlot = null;
         var _loc6_:GameParticipant = null;
         var _loc7_:String = null;
         var _loc8_:Boolean = false;
         param3.disableAutoUpdate();
         param3.removeAll();
         if(Boolean(param2))
         {
            for each(_loc6_ in param2)
            {
               _loc5_ = new TeamSelectionSlot(param1);
               _loc5_.participant = _loc6_;
               _loc5_.slotOrdinal = param3.length;
               param3.addItem(_loc5_);
            }
         }
         if(param3.length < param4)
         {
            _loc7_ = this.masterGameController.currentGame.getTeamNameForSummoner(this.session.summoner.name);
            _loc8_ = param1 != _loc7_;
            _loc8_ ||= this.isOwner && param1 != Team.SPECTATOR;
            if(param1 == Team.SPECTATOR && this.masterGameController.currentGame.getNumPlayerParticipants() <= 1)
            {
               _loc8_ = false;
            }
            if(_loc8_)
            {
               _loc5_ = new TeamSelectionSlot(param1);
               _loc5_.slotOrdinal = param3.length;
               param3.addItem(_loc5_);
            }
         }
         param3.enableAutoUpdate();
      }
      
      public function onChatRoomCreated(param1:ChatRoom) : void
      {
         this.chatRoom = param1;
         if(Boolean(this.inviteGroup))
         {
            this.inviteGroup.chatRoom = param1;
         }
         this.chatRoom.roomJoinSignal.add(this.room_joinHandler);
         this.chatRoom.otherUserJoinedRoomSignal.add(this.room_userJoinHandler);
         this.chatRoom.join();
         this.chatRoom.subject = ResourceManager.getInstance().getString("resources","practiceGame_chatRoom_title");
      }
      
      private function room_joinHandler() : void
      {
         var _loc2_:RoomOccupant = null;
         var _loc1_:PresenceStatusData = this.chatController.presenceController.selfPresenceData;
         this.notifyPresenceData(this.chatRoom.currentDisplayName,_loc1_.gameType,_loc1_);
         for each(_loc2_ in this.chatRoom.getRoomOccupants())
         {
            this.setPresenceData(_loc2_);
         }
      }
      
      private function room_userJoinHandler(param1:RoomEvent) : void
      {
         var _loc2_:Presence = param1.data as Presence;
         if(!_loc2_ || this.chatRoom == null)
         {
            return;
         }
         this.setPresenceData(this.chatRoom.getRoomOccupantByDisplayName(param1.nickname));
      }
      
      private function setPresenceData(param1:RoomOccupant) : void
      {
         var presenceData:PresenceStatusData = null;
         var changeWatcher:ChangeWatcher = null;
         var roomOccupant:RoomOccupant = param1;
         presenceData = PresenceController.getPresenceData(roomOccupant.status);
         var success:Boolean = this.notifyPresenceData(roomOccupant.displayName,roomOccupant.status,presenceData);
         if(!success)
         {
            changeWatcher = ChangeWatcher.watch(roomOccupant,"status",function(param1:PropertyChangeEvent):void
            {
               notifyPresenceData(roomOccupant.displayName,roomOccupant.status,presenceData);
            });
            this.statusChangeWatchers.addItem(changeWatcher);
         }
      }
      
      private function notifyPresenceData(param1:String, param2:String, param3:PresenceStatusData) : Boolean
      {
         var _loc4_:PropertyChangeEvent = null;
         if(param3.level > 0)
         {
            this.userDataMap[param1] = param3;
            _loc4_ = new PropertyChangeEvent("presenceUpdated",false,false,PropertyChangeEventKind.UPDATE,param1,null,param3,this.userDataMap);
            dispatchEvent(_loc4_);
            return true;
         }
         return false;
      }
      
      public function deactivate() : void
      {
         var _loc2_:ChangeWatcher = null;
         if(this.practiceGameWatcher != null)
         {
            this.practiceGameWatcher.unwatch();
            this.practiceGameWatcher = null;
         }
         this.clearChangeWatchers();
         this.blueTeam = null;
         this.purpleTeam = null;
         this.resetChampionSelection(this.blueTeamChampionSelections);
         this.resetChampionSelection(this.purpleTeamChampionSelections);
         this.gameMap = null;
         this.isOwner = false;
         this.gameName = null;
         this.chatRoom.otherUserJoinedRoomSignal.remove(this.room_userJoinHandler);
         if(Boolean(this.inviteGroup))
         {
            this.inviteGroup.chatRoom = null;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this.statusChangeWatchers.length)
         {
            _loc2_ = this.statusChangeWatchers[_loc1_] as ChangeWatcher;
            if(Boolean(_loc2_))
            {
               _loc2_.unwatch();
            }
            _loc1_++;
         }
         this.statusChangeWatchers.removeAll();
         this.userDataMap = new Object();
         this.chatController.closeChatRoom(this.chatRoom);
         this.chatRoom = null;
         this.proxiedErrorHandler = null;
         this.proxiedSuccessHandler = null;
         this.newBotParticipant = null;
         this.isBusy = false;
         this._teamSelectionDeactivated.dispatch();
      }
      
      private function onPracticeGameChanged(param1:PropertyChangeEvent) : void
      {
         var _loc2_:GameDTO = null;
         var _loc3_:Boolean = false;
         if(this.masterGameController.currentGame != null)
         {
            _loc2_ = GameDTO(param1.newValue);
            if(_loc2_.gameState == GameState.TERMINATED)
            {
               this.masterGameController.cleanupAfterGameCompleteOrAborted();
               this.masterGameController.cancelGameFlow();
            }
            else
            {
               _loc3_ = !this.isOwner && this.masterGameController.amIGameOwner;
               this.updateTeam(this.blueTeam,this.masterGameController.currentGame.teamOne);
               this.updateTeam(this.purpleTeam,this.masterGameController.currentGame.teamTwo);
               this.updateTeam(this.spectatorTeam,this.masterGameController.currentGame.observers);
               this.isOwner = this.masterGameController.amIGameOwner;
               this.gameName = this.masterGameController.currentGame.name;
               this.currentGameSpectatable = Boolean(this.clientConfig.observerModeEnabled) && (this.masterGameController.currentGame.spectatorsAllowed == AllowSpectators.ALL || this.masterGameController.currentGame.spectatorsAllowed == AllowSpectators.LOBBY_ONLY);
               this._currentGameSpectatableChanged.dispatch(this.currentGameSpectatable);
               if(this.gameMap == null)
               {
                  this.gameMap = this.masterGameController.gameMap;
               }
               if(this.isOwner)
               {
                  if(_loc3_)
                  {
                     this.initializeTeamChampionSelections();
                     this.onBlueTeamChanged(null);
                     this.onPurpleTeamChanged(null);
                  }
                  this.updateTeamChampionSelections();
               }
               this.canAddBotsToGame = this.computeCanAddBotsToGame();
            }
         }
      }
      
      private function onServiceRequestComplete(param1:Boolean) : void
      {
         this.isBusy = false;
      }
      
      private function onServiceRequestSuccess(param1:ResultEvent) : void
      {
         var _loc2_:StartChampSelectDTO = param1.result as StartChampSelectDTO;
         if(Boolean(_loc2_ && _loc2_.invalidPlayers) && Boolean(_loc2_.invalidPlayers.length > 0) && this.rankedQueueFailureAlertAction != null)
         {
            this.rankedQueueFailureAlertAction.add(_loc2_.invalidPlayers);
         }
      }
      
      private function onSwitchTeamsSuccess(param1:ResultEvent) : void
      {
         var _loc2_:Boolean = param1.result as Boolean;
         if(!_loc2_ && this.proxiedSuccessHandler != null)
         {
            this.proxiedSuccessHandler.apply(null,[]);
         }
         this.proxiedSuccessHandler = null;
      }
      
      private function onQuitGameSuccess(param1:ResultEvent) : void
      {
         this.masterGameController.gameMap = null;
         this.masterGameController.cleanupAfterGameCompleteOrAborted();
         this.masterGameController.startPracticeGameFlowAtJoinGame();
      }
      
      private function onServiceRequestError(param1:ServerError) : void
      {
         if(this.proxiedErrorHandler != null)
         {
            this.proxiedErrorHandler.apply(null,[param1]);
            this.proxiedErrorHandler = null;
         }
      }
      
      private function onDefaultBotAddSuccess(param1:ResultEvent) : void
      {
      }
      
      private function onBotRemovedSuccess(param1:ResultEvent) : void
      {
      }
      
      private function onBotRemoveComplete(param1:Boolean) : void
      {
         if(!param1)
         {
            return;
         }
         this.internalAddBotToGame(this.newBotParticipant);
      }
      
      public function quitGame(param1:Function) : void
      {
         this.proxiedErrorHandler = param1;
         this.isBusy = true;
         var _loc2_:IAction = new QuitPracticeGameAction(this.masterGameController,this.serviceProxy.gameService);
         _loc2_.getErred().add(this.onQuitError);
         _loc2_.getCompleted().add(this.onQuitSuccess);
         _loc2_.invoke();
      }
      
      private function onQuitError(param1:IAction) : void
      {
         this.isBusy = false;
         if(this.proxiedErrorHandler != null)
         {
            this.proxiedErrorHandler.apply(null,[param1.getError()]);
            this.proxiedErrorHandler = null;
         }
      }
      
      private function onQuitSuccess() : void
      {
         this.isBusy = false;
      }
      
      public function rewardsDisabledHandler(param1:AlertAction) : void
      {
         if(param1.affirmativeResponse)
         {
            this.beginChampionSelection();
         }
      }
      
      public function startChampionSelection(param1:Function) : void
      {
         var _loc4_:ServerError = null;
         var _loc5_:ServerError = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:AlertAction = null;
         var _loc10_:AlertAction = null;
         this.waitingState = WAITING_START_GAME;
         this.proxiedErrorHandler = param1;
         var _loc2_:GameDTO = this.masterGameController.currentGame;
         var _loc3_:int = int(_loc2_.getNumPlayerParticipants());
         if(_loc3_ < this.gameMap.minCustomPlayers)
         {
            _loc4_ = new ServerError(null);
            _loc4_.errorCode = MessageDictionary.NOT_ENOUGH_PLAYERS_TO_START_GAME;
            _loc4_.messageArguments = [this.gameMap.minCustomPlayers.toString()];
            this.onServiceRequestError(_loc4_);
            return;
         }
         if(_loc2_.getNumPlayerParticipants() < ClientConfig.instance.minNumPlayersForPracticeGame && !this.clientConfig.bypassClientMinPlayersCheck)
         {
            _loc5_ = new ServerError(null);
            _loc5_.errorCode = MessageDictionary.PRACTICE_GAME_CANNOT_SELECT_CHAMP_NEED_MORE_PLAYERS;
            _loc5_.messageArguments = [ClientConfig.instance.minNumPlayersForPracticeGame.toString()];
            this.onServiceRequestError(_loc5_);
            this.onServiceRequestComplete(true);
            return;
         }
         if(_loc2_.practiceGameRewardsDisabledReasons != null && _loc2_.practiceGameRewardsDisabledReasons.length > 0 && _loc2_.practiceGameRewardsDisabledReasons.getItemAt(0) != RewardsDisabledReason.NONE)
         {
            _loc6_ = [];
            _loc6_.push(ResourceManager.getInstance().getString("resources","enterChampionSelect_rewardsDisabledDescriptionQuestion"));
            _loc6_.push("<BR>");
            _loc6_.push("<BR>");
            _loc7_ = ResourceManager.getInstance().getString("resources",_loc2_.practiceGameRewardsDisabledReasons.length == 1 ? "enterChampionSelect_rewardsDisabledDescriptionHeaderSingular" : "enterChampionSelect_rewardsDisabledDescriptionHeaderPluaral");
            _loc6_.push(_loc7_);
            _loc6_.push("<BR>");
            for each(_loc8_ in _loc2_.practiceGameRewardsDisabledReasons)
            {
               _loc6_.push("<LI>" + ResourceManager.getInstance().getString("resources","enterChampionSelect_rewardsDisabledReason_" + _loc8_));
            }
            _loc6_.push("<BR>\n");
            _loc9_ = new AlertAction(ResourceManager.getInstance().getString("resources","enterChampionSelect_rewardsDisabledTitle"),_loc6_.join(""));
            _loc9_.showNegative = true;
            _loc9_.setYesNoLabels();
            _loc9_.getCompleted().addOnce(this.rewardsDisabledHandler);
            _loc9_.add();
            return;
         }
         if(_loc2_.practiceGameRewardsDisabledReasons == null && this.blueTeam.length != this.purpleTeam.length)
         {
            _loc10_ = new AlertAction(ResourceManager.getInstance().getString("resources","enterChampionSelect_UnbalancedTeamsTitle"),ResourceManager.getInstance().getString("resources","enterChampionSelect_UnbalancedTeams"));
            _loc10_.showNegative = true;
            _loc10_.setYesNoLabels();
            _loc10_.getCompleted().addOnce(this.rewardsDisabledHandler);
            _loc10_.add();
            return;
         }
         this.beginChampionSelection();
      }
      
      protected function beginChampionSelection() : void
      {
         this.isBusy = true;
         var _loc1_:GameDTO = this.masterGameController.currentGame;
         this.serviceProxy.gameService.startChampionSelection(_loc1_.id,_loc1_.optimisticLock,this.onServiceRequestSuccess,this.onServiceRequestComplete,this.onServiceRequestError);
      }
      
      public function takeSlot(param1:TeamSelectionSlot, param2:Function, param3:Function) : void
      {
         var _loc5_:int = 0;
         var _loc4_:String = this.masterGameController.currentGame.getTeamNameForSummoner(this.session.summoner.name);
         if(_loc4_ != param1.type)
         {
            if(param1.type == Team.SPECTATOR)
            {
               this.switchToObserver(param2,param3);
            }
            else if(_loc4_ == Team.SPECTATOR)
            {
               if(param1.type == Team.TEAM_BLUE)
               {
                  _loc5_ = int(Team.TEAM_ID_BLUE);
               }
               else
               {
                  _loc5_ = int(Team.TEAM_ID_PURPLE);
               }
               this.switchObserverToTeam(_loc5_,param2,param3);
            }
            else
            {
               this.switchTeams(param2,param3);
            }
         }
         else
         {
            param3();
         }
      }
      
      public function switchTeams(param1:Function, param2:Function) : void
      {
         this.setupTeamSwitch(param1,param2);
         var _loc3_:GameDTO = this.masterGameController.currentGame;
         this.serviceProxy.gameService.switchTeams(_loc3_.id,this.onSwitchTeamsSuccess,this.onServiceRequestComplete,this.onServiceRequestError);
      }
      
      private function switchToObserver(param1:Function, param2:Function) : void
      {
         this.setupTeamSwitch(param1,param2);
         var _loc3_:GameDTO = this.masterGameController.currentGame;
         this.serviceProxy.gameService.switchPlayerToObserver(_loc3_.id,this.onSwitchTeamsSuccess,this.onServiceRequestComplete,this.onServiceRequestError);
      }
      
      private function switchObserverToTeam(param1:Number, param2:Function, param3:Function) : void
      {
         this.setupTeamSwitch(param2,param3);
         var _loc4_:GameDTO = this.masterGameController.currentGame;
         this.serviceProxy.gameService.switchObserverToPlayer(_loc4_.id,param1,this.onSwitchTeamsSuccess,this.onServiceRequestComplete,this.onServiceRequestError);
      }
      
      private function setupTeamSwitch(param1:Function, param2:Function) : void
      {
         this.waitingState = WAITING_CHANGE_TEAMS;
         this.proxiedErrorHandler = param2;
         this.proxiedSuccessHandler = param1;
         this.isBusy = true;
      }
      
      public function banPlayerFromGame(param1:PlayerParticipant, param2:Function) : void
      {
         this.proxiedErrorHandler = param2;
         this.isBusy = true;
         var _loc3_:Number = Number(this.masterGameController.currentGame.id);
         this.serviceProxy.gameService.banUserFromGame(_loc3_,param1.accountId,this.onBanPlayerFromGameSuccess,this.onServiceRequestComplete,this.onServiceRequestError,param1);
      }
      
      private function onBanPlayerFromGameSuccess(param1:ResultEvent) : void
      {
         var _loc2_:PlayerParticipant = null;
         if(param1 != null && param1.token != null && param1.token.asyncObject != null)
         {
            _loc2_ = param1.token.asyncObject as PlayerParticipant;
            this.inviteController.banUserFromPracticeGame(_loc2_.summonerName);
         }
      }
      
      public function banObserverFromGame(param1:GameObserver, param2:Function) : void
      {
         this.proxiedErrorHandler = param2;
         this.isBusy = true;
         var _loc3_:Number = Number(this.masterGameController.currentGame.id);
         this.serviceProxy.gameService.banObserverFromGame(_loc3_,param1.accountId,this.banObserverFromGameSuccess,this.onServiceRequestComplete,this.onServiceRequestError,param1);
      }
      
      private function banObserverFromGameSuccess(param1:ResultEvent) : void
      {
         var _loc2_:GameObserver = null;
         if(param1 != null && param1.token != null && param1.token.asyncObject != null)
         {
            _loc2_ = param1.token.asyncObject as GameObserver;
            this.inviteController.banUserFromPracticeGame(_loc2_.summonerName);
         }
      }
      
      public function addDefaultBotToGame(param1:String, param2:Function) : void
      {
         var _loc4_:ServerError = null;
         var _loc5_:BotParticipant = null;
         this.proxiedErrorHandler = param2;
         this.isBusy = true;
         var _loc3_:ParticipantChampionSelection = this.findRandomChampion(param1);
         if(_loc3_ == null)
         {
            _loc4_ = new ServerError(null);
            _loc4_.errorCode = MessageDictionary.NO_MORE_AVAILABLE_BOTS;
            this.onServiceRequestError(_loc4_);
            this.onServiceRequestComplete(true);
         }
         else
         {
            _loc5_ = new BotParticipant(_loc3_.champion);
            _loc5_.botSkillLevel = BotParticipant.SKILL_LEVEL_EASY;
            _loc5_.teamId = Team.getBotTeamId(param1).toString();
            this.internalAddBotToGame(_loc5_);
         }
      }
      
      public function addBotToGame(param1:ParticipantChampionSelection, param2:int, param3:String, param4:Function) : void
      {
         var _loc6_:ServerError = null;
         var _loc7_:BotParticipant = null;
         this.proxiedErrorHandler = param4;
         this.isBusy = true;
         var _loc5_:GameDTO = this.masterGameController.currentGame;
         if(_loc5_.getNumPlayerParticipants() + _loc5_.maxNumPlayers - _loc5_.getNumTotalParticipants() - 1 < ClientConfig.instance.minNumPlayersForPracticeGame)
         {
            _loc6_ = new ServerError(null);
            _loc6_.errorCode = MessageDictionary.PRACTICE_GAME_CANNOT_ADD_BOT_SLOT_NEEDED_FOR_PLAYER;
            _loc6_.messageArguments = [ClientConfig.instance.minNumPlayersForPracticeGame.toString()];
            this.onServiceRequestError(_loc6_);
            this.onServiceRequestComplete(true);
         }
         else
         {
            _loc7_ = new BotParticipant(param1.champion);
            _loc7_.botSkillLevel = param2;
            _loc7_.teamId = Team.getBotTeamId(param3).toString();
            this.internalAddBotToGame(_loc7_);
         }
      }
      
      public function kickBotFromGame(param1:BotParticipant, param2:Function) : void
      {
         this.proxiedErrorHandler = param2;
         this.isBusy = true;
         this.internalRemoveBot(param1,this.onBotRemovedSuccess,this.onServiceRequestComplete,this.onServiceRequestError);
      }
      
      public function removeAndAddBot(param1:BotParticipant, param2:String, param3:int, param4:Champion, param5:Function) : void
      {
         this.proxiedErrorHandler = param5;
         this.isBusy = true;
         this.newBotParticipant = new BotParticipant(param4);
         this.newBotParticipant.botSkillLevel = param3;
         this.newBotParticipant.teamId = Team.getBotTeamId(param2).toString();
         this.newBotParticipant.updateInternalName();
         this.internalRemoveBot(param1,this.onBotRemovedSuccess,this.onBotRemoveComplete,this.onServiceRequestError);
      }
      
      public function isGameOwner(param1:GameParticipant) : Boolean
      {
         return param1.isGameOwner;
      }
      
      private function initializeTeamChampionSelections() : void
      {
         if(this.blueTeamChampionSelections == null)
         {
            this.blueTeamChampionSelections = this.getChampionSelections();
         }
         if(this.purpleTeamChampionSelections == null)
         {
            this.purpleTeamChampionSelections = this.getChampionSelections();
         }
      }
      
      private function getChampionSelections() : ArrayCollection
      {
         var _loc2_:Champion = null;
         var _loc3_:GameTypeConfig = null;
         var _loc4_:ParticipantChampionSelection = null;
         var _loc5_:int = 0;
         var _loc1_:ArrayCollection = new ArrayCollection();
         for each(_loc2_ in this.masterGameController.inventory.championRegistry)
         {
            if(_loc2_.botEnabled)
            {
               _loc3_ = GameTypeConfigManager.instance.getGameTypeConfig(this.masterGameController.currentGame.gameTypeConfigId);
               _loc4_ = new ParticipantChampionSelection(_loc3_,_loc2_);
               _loc4_.participant = null;
               _loc5_ = 0;
               _loc5_ = 0;
               while(_loc5_ < _loc1_.length)
               {
                  if(_loc4_.champion.displayName < _loc1_.getItemAt(_loc5_).champion.displayName)
                  {
                     break;
                  }
                  _loc5_++;
               }
               _loc1_.addItemAt(_loc4_,_loc5_);
            }
         }
         return _loc1_;
      }
      
      private function resetChampionSelection(param1:ArrayCollection) : void
      {
         var _loc2_:ParticipantChampionSelection = null;
         for each(_loc2_ in param1)
         {
            _loc2_.participant = null;
         }
      }
      
      private function updateTeamChampionSelections() : void
      {
         var _loc2_:ParticipantChampionSelection = null;
         var _loc3_:GameParticipant = null;
         var _loc1_:GameDTO = this.masterGameController.currentGame;
         for each(_loc2_ in this.blueTeamChampionSelections)
         {
            _loc3_ = _loc1_.getTeamOneBotParticipantForChampion(_loc2_.champion.skinName);
            _loc2_.participant = _loc3_;
         }
         for each(_loc2_ in this.purpleTeamChampionSelections)
         {
            _loc3_ = _loc1_.getTeamTwoBotParticipantForChampion(_loc2_.champion.skinName);
            _loc2_.participant = _loc3_;
         }
      }
      
      private function findRandomChampion(param1:String) : ParticipantChampionSelection
      {
         var _loc4_:ParticipantChampionSelection = null;
         var _loc5_:int = 0;
         var _loc2_:ArrayCollection = param1 == Team.TEAM_BLUE ? this.blueTeamChampionSelections : this.purpleTeamChampionSelections;
         var _loc3_:Array = [];
         for each(_loc4_ in _loc2_)
         {
            if(_loc4_.participant == null)
            {
               _loc3_.push(_loc4_);
            }
         }
         if(_loc3_.length > 0)
         {
            _loc5_ = Math.floor(Math.random() * _loc3_.length);
            return _loc3_[_loc5_];
         }
         return null;
      }
      
      private function internalAddBotToGame(param1:BotParticipant) : void
      {
         this.serviceProxy.gameService.selectBotChampion(param1.champion,param1,this.onDefaultBotAddSuccess,this.onServiceRequestComplete,this.onServiceRequestError);
      }
      
      private function internalRemoveBot(param1:BotParticipant, param2:Function, param3:Function, param4:Function) : void
      {
         this.serviceProxy.gameService.removeBotChampion(param1.champion,param1,param2,param3,param4);
      }
      
      private function updateTeam(param1:ArrayCollection, param2:ArrayCollection) : void
      {
         var _loc3_:GameParticipant = null;
         var _loc4_:int = 0;
         if(param1 == null || param2 == null)
         {
            return;
         }
         for each(_loc3_ in param2)
         {
            if(_loc3_ is GameObserver)
            {
               if(teamContainsObserver(param1,_loc3_ as GameObserver))
               {
                  continue;
               }
            }
            else if(teamContainsNonObserver(param1,_loc3_))
            {
               continue;
            }
            param1.addItem(_loc3_);
         }
         for each(_loc3_ in param1)
         {
            if(_loc3_ is GameObserver)
            {
               if(teamContainsObserver(param2,_loc3_ as GameObserver))
               {
                  continue;
               }
            }
            else if(teamContainsNonObserver(param2,_loc3_))
            {
               continue;
            }
            _loc4_ = int(param1.getItemIndex(_loc3_));
            param1.removeItemAt(_loc4_);
         }
      }
      
      private function sortTeamMembers(param1:Object, param2:Object, param3:Array = null) : int
      {
         if(Boolean(param1.isGameOwner))
         {
            return -1;
         }
         if(Boolean(param2.isGameOwner))
         {
            return 1;
         }
         if(param1 is PlayerParticipant && param2 is BotParticipant)
         {
            return -1;
         }
         if(param1 is BotParticipant && param2 is PlayerParticipant)
         {
            return 1;
         }
         return ObjectUtil.stringCompare(param1.summonerName as String,param2.summonerName as String);
      }
      
      private function computeCanAddBotsToGame() : Boolean
      {
         var _loc1_:GameFlowVariant = null;
         if(Boolean(this.masterGameController.gameMap))
         {
            _loc1_ = GameFlowVariantFactory.instance.getVariant(this.masterGameController.currentGame.gameMutators,this.masterGameController.currentGame.gameMode);
            return this.isOwner && Boolean(this.masterGameController.gameMap.canAddBotsToMap()) && _loc1_.canAddBotsToCustomGame();
         }
         return false;
      }
      
      private function onInviteProvider(param1:IInviteProvider) : void
      {
         this.inviteGroup = param1.getInviteGroup();
         this.inviteController = param1.getInviteController();
         if(Boolean(this.chatRoom))
         {
            this.inviteGroup.chatRoom = this.chatRoom;
         }
         this.inviteGroup.getInvitedParticipantsChangedSignal().add(this.updateTeams);
      }
      
      private function updateTeams(param1:InviteParticipant) : void
      {
         var _loc2_:Object = null;
         var _loc3_:PlayerParticipant = null;
         for each(_loc2_ in this.blueTeam)
         {
            if(_loc2_ is PlayerParticipant)
            {
               _loc3_ = _loc2_ as PlayerParticipant;
               if(_loc3_.summonerId == param1.summonerId)
               {
                  _loc3_.profileIconId = param1.profileIconId;
                  this.onBlueTeamChanged(null);
                  return;
               }
            }
         }
         for each(_loc2_ in this.purpleTeam)
         {
            if(_loc2_ is PlayerParticipant)
            {
               _loc3_ = _loc2_ as PlayerParticipant;
               if(_loc3_.summonerId == param1.summonerId)
               {
                  _loc3_.profileIconId = param1.profileIconId;
                  this.onPurpleTeamChanged(null);
                  return;
               }
            }
         }
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
      public function get chatController() : ChatController
      {
         return this._1019249940chatController;
      }
      
      public function set chatController(param1:ChatController) : void
      {
         var _loc2_:Object = this._1019249940chatController;
         if(_loc2_ !== param1)
         {
            this._1019249940chatController = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatController",_loc2_,param1));
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
      public function get waitingState() : String
      {
         return this._1781605956waitingState;
      }
      
      public function set waitingState(param1:String) : void
      {
         var _loc2_:Object = this._1781605956waitingState;
         if(_loc2_ !== param1)
         {
            this._1781605956waitingState = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"waitingState",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get blueTeam() : ArrayCollection
      {
         return this._491640361blueTeam;
      }
      
      public function set blueTeam(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._491640361blueTeam;
         if(_loc2_ !== param1)
         {
            this._491640361blueTeam = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"blueTeam",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get blueTeamChampionSelections() : ArrayCollection
      {
         return this._1494003687blueTeamChampionSelections;
      }
      
      public function set blueTeamChampionSelections(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1494003687blueTeamChampionSelections;
         if(_loc2_ !== param1)
         {
            this._1494003687blueTeamChampionSelections = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"blueTeamChampionSelections",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get blueTeamSlots() : ArrayCollection
      {
         return this._1726335646blueTeamSlots;
      }
      
      public function set blueTeamSlots(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1726335646blueTeamSlots;
         if(_loc2_ !== param1)
         {
            this._1726335646blueTeamSlots = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"blueTeamSlots",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get purpleTeam() : ArrayCollection
      {
         return this._932544455purpleTeam;
      }
      
      public function set purpleTeam(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._932544455purpleTeam;
         if(_loc2_ !== param1)
         {
            this._932544455purpleTeam = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"purpleTeam",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get purpleTeamChampionSelections() : ArrayCollection
      {
         return this._953479625purpleTeamChampionSelections;
      }
      
      public function set purpleTeamChampionSelections(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._953479625purpleTeamChampionSelections;
         if(_loc2_ !== param1)
         {
            this._953479625purpleTeamChampionSelections = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"purpleTeamChampionSelections",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get purpleTeamSlots() : ArrayCollection
      {
         return this._1137827460purpleTeamSlots;
      }
      
      public function set purpleTeamSlots(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1137827460purpleTeamSlots;
         if(_loc2_ !== param1)
         {
            this._1137827460purpleTeamSlots = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"purpleTeamSlots",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get spectatorTeamSlots() : ArrayCollection
      {
         return this._1326329257spectatorTeamSlots;
      }
      
      public function set spectatorTeamSlots(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1326329257spectatorTeamSlots;
         if(_loc2_ !== param1)
         {
            this._1326329257spectatorTeamSlots = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spectatorTeamSlots",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameMap() : GameMap
      {
         return this._195623926gameMap;
      }
      
      public function set gameMap(param1:GameMap) : void
      {
         var _loc2_:Object = this._195623926gameMap;
         if(_loc2_ !== param1)
         {
            this._195623926gameMap = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameMap",_loc2_,param1));
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
      public function get availableBotDifficulties() : ArrayCollection
      {
         return this._1335052023availableBotDifficulties;
      }
      
      public function set availableBotDifficulties(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1335052023availableBotDifficulties;
         if(_loc2_ !== param1)
         {
            this._1335052023availableBotDifficulties = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"availableBotDifficulties",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get currentGameSpectatable() : Boolean
      {
         return this._2109547355currentGameSpectatable;
      }
      
      public function set currentGameSpectatable(param1:Boolean) : void
      {
         var _loc2_:Object = this._2109547355currentGameSpectatable;
         if(_loc2_ !== param1)
         {
            this._2109547355currentGameSpectatable = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentGameSpectatable",_loc2_,param1));
            }
         }
      }
      
      public function set isOwner(param1:Boolean) : void
      {
         var _loc2_:Object = this.isOwner;
         if(_loc2_ !== param1)
         {
            this._2067570601isOwner = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isOwner",_loc2_,param1));
            }
         }
      }
   }
}

