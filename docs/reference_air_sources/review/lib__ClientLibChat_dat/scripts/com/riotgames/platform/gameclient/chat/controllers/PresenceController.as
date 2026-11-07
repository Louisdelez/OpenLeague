package com.riotgames.platform.gameclient.chat.controllers
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.xmpp.data.invite.PresenceStatusXML;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.IPresenceProvider;
   import com.riotgames.platform.gameclient.chat.domain.PresenceStatusData;
   import com.riotgames.platform.gameclient.controllers.IViewController;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.LeagueItemDTO;
   import com.riotgames.platform.gameclient.domain.PlayerStatSummaries;
   import com.riotgames.platform.gameclient.domain.PlayerStatSummary;
   import com.riotgames.platform.gameclient.domain.game.QueueType;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.pvpnet.tracking.ICrossModuleTrackerProvider;
   import com.riotgames.pvpnet.tracking.trackers.friend.IFriendListBehaviorTracker;
   import flash.desktop.NativeApplication;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.getQualifiedClassName;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import org.igniterealtime.xiff.data.Presence;
   import org.igniterealtime.xiff.events.LoginEvent;
   
   public class PresenceController implements IViewController, IPresenceProvider, IEventDispatcher
   {
      
      private var _presenceUpdated:Signal = new Signal();
      
      public var chatController:ChatController;
      
      private var _currentStatusMsg:String = "";
      
      private var _chatServiceActive:Boolean = false;
      
      private var _presenceControllerActive:Boolean = false;
      
      private var rankedRating:int = 0;
      
      private var _currentShow:String = "chat";
      
      private var _currentShowChanged:Signal = new Signal();
      
      private var _isAway:Boolean = false;
      
      private var rankedQueueType:String = "";
      
      private var _currentMobile:Boolean = false;
      
      private var lifetimeWins:int = 0;
      
      private var rankedWins:int = 0;
      
      private var gameStatus:String = "";
      
      private var skinname:String = "";
      
      public var session:Session = Session.instance;
      
      private var _currentMobileChanged:Signal = new Signal();
      
      private var lifetimeOdinLeaves:int = 0;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public var serviceProxy:ServiceProxy = ServiceProxy.instance;
      
      private var rankedLosses:int = 0;
      
      private var _friendListTracker:IFriendListBehaviorTracker;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var lifetimeLeaves:int = 0;
      
      private var normalClassicQueueSummaryTypes:Array = [QueueType.NORMAL,QueueType.NORMAL_3x3,QueueType.CAP5x5,QueueType.CAP1x1];
      
      private var _summonerProfileIcon:int = 0;
      
      private var summonerLevel:int = 1;
      
      private var _currentStatusMsgChanged:Signal = new Signal();
      
      private var lifetimeOdinWins:int = 0;
      
      private var _presenceStatus:PresenceStatusXML = new PresenceStatusXML();
      
      public var clientConfig:ClientConfig = ClientConfig.instance;
      
      public function PresenceController()
      {
         super();
      }
      
      public static function getGameType(param1:String) : String
      {
         var _loc2_:PresenceStatusXML = new PresenceStatusXML(param1);
         return _loc2_.getGameType();
      }
      
      public static function getPresenceData(param1:String) : PresenceStatusData
      {
         var _loc2_:PresenceStatusXML = new PresenceStatusXML(param1);
         return buildPresenceDataWithPresenceStatus(_loc2_);
      }
      
      public static function getProfileIcon(param1:String) : int
      {
         var _loc2_:PresenceStatusXML = new PresenceStatusXML(param1);
         return int(_loc2_.getProfileIcon());
      }
      
      private static function buildPresenceDataWithPresenceStatus(param1:PresenceStatusXML) : PresenceStatusData
      {
         var _loc2_:PresenceStatusData = new PresenceStatusData();
         _loc2_.gameType = param1.getGameType();
         _loc2_.level = int(param1.getLevel());
         _loc2_.profileIconId = int(param1.getProfileIcon());
         _loc2_.skinname = param1.getSkinname();
         _loc2_.statusMsg = param1.getStatusMessage();
         _loc2_.wins = int(param1.getWins());
         _loc2_.odinWins = int(param1.getOdinWins());
         _loc2_.timeStamp = param1.getTimestamp();
         _loc2_.rankedQueueName = param1.getStringValue(PresenceStatusXML.ENTRY_PROFILE_RANKED_QUEUETYPE);
         _loc2_.tier = param1.getStringValue(PresenceStatusXML.ENTRY_PROFILE_TIER);
         _loc2_.queueType = param1.getQueueType();
         _loc2_.isGameObservable = param1.getIsGameObservable();
         _loc2_.dropInSpectateId = param1.getDropInSpectatorId();
         _loc2_.featuredGameData = param1.getFeaturedGameData();
         _loc2_.rankedLeagueName = param1.getLeagueName();
         _loc2_.rankedLeagueTier = param1.getLeagueTier();
         _loc2_.rankedLeagueDivision = param1.getLeagueDivision();
         _loc2_.rankedLeagueQueueType = param1.getLeagueQueueType();
         if(_loc2_.rankedLeagueName != null && _loc2_.rankedLeagueName != "")
         {
            _loc2_.rankedWins = param1.getIntValue(PresenceStatusXML.ENTRY_PROFILE_RANKED_WINS);
            _loc2_.rankedLosses = param1.getIntValue(PresenceStatusXML.ENTRY_PROFILE_RANKED_LOSSES);
            _loc2_.rankedRating = param1.getIntValue(PresenceStatusXML.ENTRY_PROFILE_RANKED_RATING);
         }
         else
         {
            _loc2_.rankedWins = 0;
            _loc2_.rankedLosses = 0;
            _loc2_.rankedRating = 0;
         }
         _loc2_.rankedSoloRestricted = param1.isRankedSoloRestricted();
         return _loc2_;
      }
      
      public static function getStatusMessage(param1:String) : String
      {
         var _loc2_:PresenceStatusXML = new PresenceStatusXML(param1);
         return _loc2_.getStatusMessage();
      }
      
      public function getPresenceUpdated() : ISignal
      {
         return this._presenceUpdated;
      }
      
      public function get currentShow() : String
      {
         if(this._isAway && this._currentShow != Presence.SHOW_DND)
         {
            return Presence.SHOW_AWAY;
         }
         return this._currentShow;
      }
      
      public function updateLeagueData(param1:LeagueItemDTO) : void
      {
         if(Boolean(param1))
         {
            this._presenceStatus.setLeagueName(param1.leagueName);
            this._presenceStatus.setLeagueDivision(param1.rank);
            this._presenceStatus.setLeagueTier(param1.tier);
            this._presenceStatus.setLeagueQueueType(param1.queueType);
            this._presenceStatus.setIntValue(PresenceStatusXML.ENTRY_PROFILE_RANKED_WINS,param1.wins);
         }
         else
         {
            this._presenceStatus.setLeagueName("");
            this._presenceStatus.setLeagueDivision("");
            this._presenceStatus.setLeagueTier("");
            this._presenceStatus.setLeagueQueueType("");
         }
         this.sendPresenceUpdate();
      }
      
      private function chatServiceActiveHandler(param1:LoginEvent) : void
      {
         this._chatServiceActive = true;
         this.sendPresenceUpdate();
      }
      
      public function getCurrentMobileChanged() : ISignal
      {
         return this._currentMobileChanged;
      }
      
      public function setSkinName(param1:String, param2:Boolean = true) : void
      {
         this.skinname = param1;
         this._presenceStatus.setSkinname(param1);
         if(param2)
         {
            this.sendPresenceUpdate();
         }
      }
      
      public function set currentShow(param1:String) : void
      {
         this._currentShow = param1;
         this._currentShowChanged.dispatch();
      }
      
      private function onGetCrossModuleTrackerProvider(param1:ICrossModuleTrackerProvider) : void
      {
         this._friendListTracker = param1.getFriendListBehaviorTracker();
      }
      
      public function set summonerProfileIcon(param1:int) : void
      {
         this._summonerProfileIcon = param1;
         this._presenceStatus.setProfileIcon(param1.toString());
      }
      
      private function get isAway() : Boolean
      {
         return this._isAway;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function cycleShowMode() : void
      {
         switch(this.currentShow)
         {
            case Presence.SHOW_CHAT:
               this.setAwayFlag(true);
               break;
            case Presence.SHOW_AWAY:
            case Presence.SHOW_DND:
            case Presence.SHOW_XA:
            default:
               this.setAwayFlag(false);
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function sendPresenceUpdate() : void
      {
         if(this._presenceControllerActive && this._chatServiceActive)
         {
            this.serviceProxy.chatService.changePresence(this.currentShow,this.presenceStatus.getNode());
            this.sendGroupChatPresenceUpdate();
            this._presenceUpdated.dispatch();
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      private function sendGroupChatPresenceUpdate() : void
      {
         try
         {
            this.chatController.sendPresenceToAllChatRooms(this.currentShow,this.presenceStatus);
         }
         catch(e:Error)
         {
            logger.error("PresenceController.sendGroupChatPresenceUpdate ERROR When updating presence!! stack: " + e.getStackTrace());
         }
      }
      
      public function updateSingleQueueStats(param1:int, param2:String, param3:int, param4:Boolean, param5:String) : void
      {
         var _loc6_:int = this.lifetimeWins;
         var _loc7_:int = this.lifetimeLeaves;
         var _loc8_:int = this.lifetimeOdinWins;
         var _loc9_:int = this.lifetimeOdinLeaves;
         var _loc10_:String = this.rankedQueueType;
         var _loc11_:int = this.rankedWins;
         var _loc12_:int = this.rankedRating;
         var _loc13_:int = this.rankedLosses;
         if(param2 in this.normalClassicQueueSummaryTypes)
         {
            if(param4)
            {
               _loc6_++;
            }
         }
         if(param2 == QueueType.DOMINION_UNRANKED)
         {
            if(param4)
            {
               _loc8_++;
            }
         }
         else
         {
            if(param2 != _loc10_)
            {
               return;
            }
            if(param4)
            {
               _loc11_++;
            }
            else
            {
               _loc13_++;
            }
            _loc12_ = param3;
         }
         this.setProfileStats(param1,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc11_,_loc13_,_loc12_,param5);
      }
      
      public function sendPresenceUpdateToChatRoom(param1:ChatRoom) : void
      {
         param1.changePresence(this.currentShow,this.chatController.currentUserDisplayName,this.presenceStatus.getNode());
      }
      
      public function modUserPresenceDetection(param1:int) : void
      {
         NativeApplication.nativeApplication.idleThreshold = param1;
         NativeApplication.nativeApplication.addEventListener(Event.USER_IDLE,this.handleUserAFK);
         NativeApplication.nativeApplication.addEventListener(Event.USER_PRESENT,this.handleUserReturns);
      }
      
      public function stopUserPresenceDetection() : void
      {
         NativeApplication.nativeApplication.removeEventListener(Event.USER_IDLE,this.handleUserAFK);
         NativeApplication.nativeApplication.removeEventListener(Event.USER_PRESENT,this.handleUserReturns);
      }
      
      private function set isAway(param1:Boolean) : void
      {
         this._isAway = param1;
         this._currentShowChanged.dispatch();
      }
      
      public function deactivate() : void
      {
      }
      
      public function setStatusMessage(param1:String, param2:Boolean = true) : void
      {
         this.currentStatusMsg = param1;
         this._presenceStatus.setStatusMessage(this.currentStatusMsg);
         if(param2)
         {
            this.sendPresenceUpdate();
         }
      }
      
      §§namespace("http://www.riotgames.com/pvpnet/internal") function get currentMobile() : Boolean
      {
         return this._currentMobile;
      }
      
      public function setGameStatus(param1:String, param2:String, param3:Boolean, param4:Boolean) : void
      {
         var _loc5_:GameDTO = null;
         if(param1 == this.gameStatus)
         {
            return;
         }
         if(Boolean(this.chatController.gameProvider))
         {
            _loc5_ = this.chatController.gameProvider.currentGame;
         }
         this.currentShow = param2;
         if(param3)
         {
            if(Boolean(_loc5_))
            {
               this._presenceStatus.setQueueType(_loc5_.queueTypeName);
               if(_loc5_.queueTypeName == QueueType.NONE)
               {
                  this._presenceStatus.setIsGameObservable(_loc5_.spectatorsAllowed);
               }
            }
            this.stopUserPresenceDetection();
         }
         else
         {
            this.startUserPresenceDetection();
         }
         this.gameStatus = param1;
         this._presenceStatus.setGameType(this.gameStatus);
         if(param4)
         {
            this.sendPresenceUpdate();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set currentStatusMsg(param1:String) : void
      {
         var _loc2_:Object = this.currentStatusMsg;
         if(_loc2_ !== param1)
         {
            this._931365706currentStatusMsg = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentStatusMsg",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function initialize() : void
      {
         this.serviceProxy.chatService.addConnectionEventListener(LoginEvent.LOGIN,this.chatServiceActiveHandler);
         ProviderLookup.getProvider(ICrossModuleTrackerProvider,this.onGetCrossModuleTrackerProvider);
         ProviderLookup.publishProvider(IPresenceProvider,this);
      }
      
      public function cleanup() : void
      {
         this.serviceProxy.chatService.removeConnectionEventListener(LoginEvent.LOGIN,this.chatServiceActiveHandler);
      }
      
      private function handleUserReturns(param1:Event) : void
      {
         this.setAwayFlag(false);
      }
      
      public function get selfPresenceData() : PresenceStatusData
      {
         return buildPresenceDataWithPresenceStatus(this._presenceStatus);
      }
      
      private function set _931365706currentStatusMsg(param1:String) : void
      {
         this._currentStatusMsg = param1;
         UserPreferencesManager.userPrefs.chatShowMsg = this._currentStatusMsg;
         this._currentStatusMsgChanged.dispatch();
      }
      
      public function get currentStatusMsg() : String
      {
         return this._currentStatusMsg;
      }
      
      public function getCurrentShowChanged() : ISignal
      {
         return this._currentShowChanged;
      }
      
      public function setRankedSoloRestricted(param1:Boolean, param2:Boolean = false) : void
      {
         this.presenceStatus.setRankedSoloRestricted(param1);
         if(param2)
         {
            this.sendPresenceUpdate();
         }
      }
      
      public function get presenceStatus() : PresenceStatusXML
      {
         return this._presenceStatus;
      }
      
      public function setSummonerProfileIcon(param1:int, param2:Boolean = false) : void
      {
         this.summonerProfileIcon = param1;
         if(param2)
         {
            this.sendPresenceUpdate();
         }
      }
      
      private function handleUserAFK(param1:Event) : void
      {
         this.setAwayFlag(true);
      }
      
      public function get currentGameStatus() : String
      {
         return this.gameStatus;
      }
      
      public function updateProfileStats(param1:int, param2:PlayerStatSummaries, param3:String) : void
      {
         var _loc12_:String = null;
         var _loc13_:PlayerStatSummary = null;
         var _loc14_:PlayerStatSummary = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:String = "";
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         if(Boolean(param2))
         {
            for each(_loc12_ in this.normalClassicQueueSummaryTypes)
            {
               _loc14_ = param2.getPlayerStatSummary(_loc12_);
               if(Boolean(_loc14_))
               {
                  _loc4_ += _loc14_.wins;
                  _loc5_ += _loc14_.leaves;
               }
            }
            _loc13_ = param2.getPlayerStatSummary(QueueType.DOMINION_UNRANKED);
            if(Boolean(_loc13_))
            {
               _loc6_ = int(_loc13_.wins);
               _loc7_ = int(_loc13_.leaves);
            }
         }
         this.setProfileStats(param1,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc11_,_loc10_,param3);
      }
      
      public function getCurrentStatusMsgChanged() : ISignal
      {
         return this._currentStatusMsgChanged;
      }
      
      public function activate() : void
      {
         this.setGameStatus(PresenceStatusXML.GAME_STATUS_OUT_OF_GAME,Presence.SHOW_CHAT,false,false);
         this.setStatusMessage(UserPreferencesManager.userPrefs.chatShowMsg,false);
         this._presenceControllerActive = true;
         this.sendPresenceUpdate();
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      §§namespace("http://www.riotgames.com/pvpnet/internal") function set currentMobile(param1:Boolean) : void
      {
         this._currentMobile = param1;
         this._currentMobileChanged.dispatch();
      }
      
      private function setProfileStats(param1:int, param2:int, param3:int, param4:int, param5:int, param6:String, param7:int, param8:int, param9:int, param10:String, param11:Boolean = true) : void
      {
         this.summonerLevel = param1;
         this.lifetimeWins = param2;
         this.lifetimeLeaves = param3;
         this.lifetimeOdinWins = param4;
         this.lifetimeOdinLeaves = param5;
         this._presenceStatus.setLevel(param1.toString());
         this._presenceStatus.setWins(param2.toString());
         this._presenceStatus.setLeaves(param3.toString());
         this._presenceStatus.setOdinWins(param4.toString());
         this._presenceStatus.setOdinLeaves(param5.toString());
         if(param6 != null && param6 != "")
         {
            this.rankedQueueType = param6;
            this.rankedWins = param7;
            this.rankedLosses = param8;
            this.rankedRating = param9;
         }
         else
         {
            this.rankedQueueType = "";
            this.rankedWins = 0;
            this.rankedLosses = 0;
            this.rankedRating = 0;
         }
         this._presenceStatus.setStringValue(PresenceStatusXML.ENTRY_PROFILE_RANKED_QUEUETYPE,this.rankedQueueType);
         this._presenceStatus.setIntValue(PresenceStatusXML.ENTRY_PROFILE_RANKED_LOSSES,this.rankedLosses);
         this._presenceStatus.setIntValue(PresenceStatusXML.ENTRY_PROFILE_RANKED_RATING,this.rankedRating);
         this._presenceStatus.setStringValue(PresenceStatusXML.ENTRY_PROFILE_TIER,param10);
         if(param11)
         {
            this.sendPresenceUpdate();
         }
      }
      
      public function setAwayFlag(param1:Boolean, param2:Boolean = true) : void
      {
         if(this.isAway != param1)
         {
            this.isAway = param1;
            if(param2)
            {
               this.sendPresenceUpdate();
            }
         }
      }
      
      public function startUserPresenceDetection() : void
      {
         if(Boolean(this.clientConfig))
         {
            this.modUserPresenceDetection(this.clientConfig.idleThreshold);
         }
      }
   }
}

