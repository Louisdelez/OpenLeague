package com.riotgames.platform.gameclient.domain
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.Models.GameModel;
   import com.riotgames.platform.gameclient.domain.chat.InitialChatWindowPosition;
   import com.riotgames.platform.gameclient.domain.game.AllowSpectators;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass]
   public class UserPrefs implements IEventDispatcher
   {
      
      public static const DEFAULT_MUTE:Boolean = false;
      
      public static const DEFAULT_VOLUME:Number = 0.7;
      
      public static const DEFAULT_MUSIC_MUTE:Boolean = false;
      
      public static const DEFAULT_MUSIC_VOLUME:Number = 0.7;
      
      public static const DEFAULT_CHAT_FILTER:Boolean = true;
      
      public static const DEFAULT_CHAT_WARN_LINK_CLICKED:Boolean = true;
      
      public static const DEFAULT_SUPPRESS_NOTIFICATION_POPUPS:Boolean = false;
      
      public static const DEFAULT_PERSONALIM_TIMESTAMPS:Boolean = true;
      
      public static const DEFAULT_FRIEND_ONLINE_PROMPTS:Boolean = false;
      
      public static const DEFAULT_CHATROOMS_TIMESTAMPS:Boolean = false;
      
      public static const DEFAULT_CHAMPION_SMALLICONS:Boolean = false;
      
      public static const DEFAULT_CHATROOMS_MAXIMIZED:Boolean = false;
      
      public static const DEFAULT_CHAT_SHOWMESSAGE:String = "";
      
      public static const DEFAULT_FRIENDS_LIST_SORT_TYPE:String = "status";
      
      public static const DEFAULT_SHOW_OFFLINE_FRIENDS:Boolean = false;
      
      public static const DEFAULT_AUTOJOIN_LIST:Array = [];
      
      public static const DEFAULT_TRANSITION_ANIMATIONS:Boolean = true;
      
      public static const DEFAULT_NEWBIE_TIPS:Boolean = true;
      
      public static const DEFAULT_RANKED_TIPS:Boolean = true;
      
      public static const DEFAULT_HAD_BOOST:Boolean = false;
      
      public static const DEFAULT_ALLOW_SPECTATORS:String = AllowSpectators.ALL;
      
      public static const DEFAULT_INITIAL_CHAT_WINDOW_POSITION:String = InitialChatWindowPosition.DOCKED;
      
      public static const DEFAULT_SELECTED_PVP_OPTIONS:Object = {
         "mapId":GameMap.SUMMONERS_RIFT_ID,
         "ranked":false,
         "pickType":"blind_pick",
         "teamType":"solo"
      };
      
      public static const DEFAULT_SELECTED_PVE_OPTIONS:Object = {
         "mapId":GameMap.SUMMONERS_RIFT_ID,
         "difficulty":"EASY",
         "teamType":"solo"
      };
      
      public static const DEFAULT_TUTORIAL_TYPE:String = GameModel.TUTORIAL_TYPE_BASIC;
      
      public static const DEFAULT_MAP_FILTERS:Array = [true,true,true,true];
      
      public static const DEFAULT_GAME_TYPE_FILTERS:Array = [true,true,true,true];
      
      public static const DEFAULT_LOBBIES_FILTERS:Array = [true,true];
      
      public static const DEFAULT_CREATE_CUSTOM_GAME_MAP_ID:int = -1;
      
      public static const DEFAULT_CREATE_CUSTOM_GAME_SERVER_NAME:String = "";
      
      public static const DEFAULT_CREATE_CUSTOM_GAME_TEAM_SIZE:int = 5;
      
      public static const DEFAULT_CREATE_CUSTOM_GAME_PICK_TYPE:int = 1;
      
      public static const DEFAULT_CREATE_CUSTOM_GAME_SPECTATOR_ALLOWED:String = "";
      
      public static const SEER_POPUP:Boolean = false;
      
      public static const HAS_COMPLETED_TUTORIAL:Boolean = false;
      
      public static const HAS_COMPLETED_BATTLE_TRAINING:Boolean = false;
      
      public static const DEFAULT_COLLECTION_ZOOM_SIZE:String = "Small";
      
      public static const DEFAULT_GAME_SETUP_LAST_VIEW:String = "";
      
      public static const DEFAULT_LAST_D:String = "";
      
      public static const DEFAULT_EDITOR_DOUBLE_CLICK_TUTORIAL:Boolean = false;
      
      public static var enableAnimationsChanged:Signal = new Signal();
      
      public var hadIPTimeBoost:Boolean = false;
      
      public var hadXPWinBoost:Boolean = false;
      
      public var itemSets:String = "";
      
      public var selectedPVPOptions:Object = DEFAULT_SELECTED_PVP_OPTIONS;
      
      public var hasSeenMasteriesReset2014:Boolean = false;
      
      public var create_custom_game_mapId:int = -1;
      
      public var musicVolumeChanged:Signal = new Signal();
      
      public var replayNewbieTip1Shown:Boolean = false;
      
      private var _1175381747EnableChatFilter:Boolean = true;
      
      public var b_editor_top_collection_zoom:String = "Small";
      
      private var _volume:Number = 0.7;
      
      public var volumeChanged:Signal = new Signal();
      
      public var b_game_setup_last_pvp_d:String = "";
      
      public var hadIPWinBoost:Boolean = false;
      
      private var _initialChatWindowPositionChanged:Signal = new Signal();
      
      private var _seenSeerInfo:Boolean = false;
      
      private var _788091287allowSpectatorMode:String = "ALL";
      
      public var currentMasteryPage:int = -1;
      
      public var hasCompletedTutorial:Boolean = false;
      
      public var hasSeenSocialNetworkPrompt:Boolean = false;
      
      public var b_builder_collection_zoom:String = "Small";
      
      public var b_game_setup_last_practice_d:String = "";
      
      private var _1399084990friendOnlinePrompts:Boolean = false;
      
      public var hadXPTimeBoost:Boolean = false;
      
      public var muteChanged:Signal = new Signal();
      
      public var chatRoomsTimeStamp:Boolean = false;
      
      private var _musicMute:Boolean = false;
      
      public var teamInactivityPendingWarnings:Array;
      
      public var musicMuteChanging:Signal = new Signal();
      
      public var create_custom_game_spectatorAllowed:String = "";
      
      public var chatRoomsMaximized:Boolean = false;
      
      public var selectedPVEOptions:Object = DEFAULT_SELECTED_PVE_OPTIONS;
      
      public var showOfflineFriends:Boolean = false;
      
      private var _1489851051newbieTipsEnabled:Boolean = true;
      
      public var personalImTimeStampsChanged:Signal = new Signal();
      
      private var _initialChatWindowPosition:String = "chatWindowPositionDocked";
      
      public var runeStyle:String = null;
      
      public var b_game_setup_last_survival_d:String = "";
      
      public var find_custom_game_type_filters:Array = DEFAULT_GAME_TYPE_FILTERS;
      
      public var championSmallIcons:Boolean = false;
      
      public var lastStoreRSSRead:Number = 0;
      
      public var prefTimestamps:Dictionary = new Dictionary();
      
      public var create_custom_game_serverName:String = "";
      
      public var enableLinkClickWarning:Boolean = true;
      
      public var masteryPages:ArrayCollection = null;
      
      public var replayNewbieTip2Shown:Boolean = false;
      
      public var autoJoinList:Array = DEFAULT_AUTOJOIN_LIST;
      
      private var _enableAnimations:Boolean = true;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _1340826969rankedChampionSelectTipsEnabled:Boolean = true;
      
      public var create_custom_game_pickType:int = 1;
      
      public var b_editor_bottom_collection_zoom:String = "Small";
      
      private var _personalImTimeStamps:Boolean = true;
      
      private var _1100840359suppressNotificationPopups:Boolean = false;
      
      public var prefDTO:Dictionary = new Dictionary();
      
      public var chatShowMsg:String = "";
      
      public var b_editor_double_click_tutorial:Boolean = false;
      
      public var create_custom_game_teamSize:int = 5;
      
      public var find_custom_game_map_filters:Array = DEFAULT_MAP_FILTERS;
      
      public var previousRentals:Array = null;
      
      public var lastJoJRSSRead:Number = 0;
      
      public var b_game_setup_last_view:String = "";
      
      public var lastSeenEmailVerificationPopup:Date = null;
      
      private var _musicVolume:Number = 0.7;
      
      public var hasCompletedBattleTraining:Boolean = false;
      
      public var teamInactivityWarnings:Array;
      
      public var find_custom_game_lobbies_filters:Array = DEFAULT_LOBBIES_FILTERS;
      
      public var contextualEducationTipRecords:String = "";
      
      public var friendsListSortType:String = "status";
      
      public var selectedTutorialType:String = "basic";
      
      public var musicMuteChanged:Signal = new Signal();
      
      private var _mute:Boolean = false;
      
      public function UserPrefs()
      {
         super();
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      private function set _389945822musicMute(param1:Boolean) : void
      {
         this.musicMuteChanging.dispatch(param1);
         this._musicMute = param1;
         this.musicMuteChanged.dispatch(param1);
      }
      
      public function get mute() : Boolean
      {
         return this._mute;
      }
      
      [Bindable(event="propertyChange")]
      public function set mute(param1:Boolean) : void
      {
         var _loc2_:Object = this.mute;
         if(_loc2_ !== param1)
         {
            this._3363353mute = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mute",_loc2_,param1));
         }
      }
      
      public function set musicVolume(param1:Number) : void
      {
         this._musicVolume = param1;
         if(this._musicVolume > 1)
         {
            this._musicVolume *= 0.1;
         }
         this.musicVolumeChanged.dispatch(this._musicVolume);
      }
      
      public function set suppressNotificationPopups(param1:Boolean) : void
      {
         var _loc2_:Object = this._1100840359suppressNotificationPopups;
         if(_loc2_ !== param1)
         {
            this._1100840359suppressNotificationPopups = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"suppressNotificationPopups",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function get enableAnimations() : Boolean
      {
         return this._enableAnimations;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function getInitialChatWindowPositionChanged() : ISignal
      {
         return this._initialChatWindowPositionChanged;
      }
      
      private function set _1996302488seenSeerInfo(param1:Boolean) : void
      {
         this._seenSeerInfo = param1;
      }
      
      private function set _3363353mute(param1:Boolean) : void
      {
         this._mute = param1;
         this.muteChanged.dispatch(param1);
      }
      
      public function set newbieTipsEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._1489851051newbieTipsEnabled;
         if(_loc2_ !== param1)
         {
            this._1489851051newbieTipsEnabled = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"newbieTipsEnabled",_loc2_,param1));
         }
      }
      
      public function getInitialChatWindowPosition() : String
      {
         return this._initialChatWindowPosition;
      }
      
      public function get seenSeerInfo() : Boolean
      {
         return this._seenSeerInfo;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set friendOnlinePrompts(param1:Boolean) : void
      {
         var _loc2_:Object = this._1399084990friendOnlinePrompts;
         if(_loc2_ !== param1)
         {
            this._1399084990friendOnlinePrompts = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"friendOnlinePrompts",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rankedChampionSelectTipsEnabled() : Boolean
      {
         return this._1340826969rankedChampionSelectTipsEnabled;
      }
      
      [Bindable(event="propertyChange")]
      public function get allowSpectatorMode() : String
      {
         return this._788091287allowSpectatorMode;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function get musicVolume() : Number
      {
         return this._musicVolume;
      }
      
      private function set _79466322enableAnimations(param1:Boolean) : void
      {
         this._enableAnimations = param1;
         enableAnimationsChanged.dispatch();
      }
      
      [Bindable(event="propertyChange")]
      public function set enableAnimations(param1:Boolean) : void
      {
         var _loc2_:Object = this.enableAnimations;
         if(_loc2_ !== param1)
         {
            this._79466322enableAnimations = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enableAnimations",_loc2_,param1));
         }
      }
      
      public function set rankedChampionSelectTipsEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._1340826969rankedChampionSelectTipsEnabled;
         if(_loc2_ !== param1)
         {
            this._1340826969rankedChampionSelectTipsEnabled = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankedChampionSelectTipsEnabled",_loc2_,param1));
         }
      }
      
      public function set personalImTimeStamps(param1:Boolean) : void
      {
         if(param1 != this._personalImTimeStamps)
         {
            this._personalImTimeStamps = param1;
            this.personalImTimeStampsChanged.dispatch(this,param1);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get friendOnlinePrompts() : Boolean
      {
         return this._1399084990friendOnlinePrompts;
      }
      
      [Bindable(event="propertyChange")]
      public function get newbieTipsEnabled() : Boolean
      {
         return this._1489851051newbieTipsEnabled;
      }
      
      [Bindable(event="propertyChange")]
      public function set musicMute(param1:Boolean) : void
      {
         var _loc2_:Object = this.musicMute;
         if(_loc2_ !== param1)
         {
            this._389945822musicMute = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"musicMute",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set seenSeerInfo(param1:Boolean) : void
      {
         var _loc2_:Object = this.seenSeerInfo;
         if(_loc2_ !== param1)
         {
            this._1996302488seenSeerInfo = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"seenSeerInfo",_loc2_,param1));
         }
      }
      
      public function setInitialChatWindowPosition(param1:String) : void
      {
         this._initialChatWindowPosition = param1;
      }
      
      public function get musicMute() : Boolean
      {
         return this._musicMute;
      }
      
      public function get personalImTimeStamps() : Boolean
      {
         return this._personalImTimeStamps;
      }
      
      public function set allowSpectatorMode(param1:String) : void
      {
         var _loc2_:Object = this._788091287allowSpectatorMode;
         if(_loc2_ !== param1)
         {
            this._788091287allowSpectatorMode = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"allowSpectatorMode",_loc2_,param1));
         }
      }
      
      public function set EnableChatFilter(param1:Boolean) : void
      {
         var _loc2_:Object = this._1175381747EnableChatFilter;
         if(_loc2_ !== param1)
         {
            this._1175381747EnableChatFilter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"EnableChatFilter",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get EnableChatFilter() : Boolean
      {
         return this._1175381747EnableChatFilter;
      }
      
      [Bindable(event="propertyChange")]
      public function get suppressNotificationPopups() : Boolean
      {
         return this._1100840359suppressNotificationPopups;
      }
      
      public function set sfxVolume(param1:Number) : void
      {
         this._volume = param1;
         if(this._volume > 1)
         {
            this._volume *= 0.1;
         }
         this.volumeChanged.dispatch(this._volume);
      }
      
      public function get sfxVolume() : Number
      {
         return this._volume;
      }
   }
}

