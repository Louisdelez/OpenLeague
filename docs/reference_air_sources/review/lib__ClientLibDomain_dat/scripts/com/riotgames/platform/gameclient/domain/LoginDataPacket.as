package com.riotgames.platform.gameclient.domain
{
   import com.riotgames.platform.gameclient.domain.broadcast.BroadcastNotification;
   import com.riotgames.platform.gameclient.domain.game.GameReconnectionInfo;
   import com.riotgames.platform.gameclient.domain.kudos.PendingKudos;
   import com.riotgames.platform.gameclient.domain.systemstates.ClientSystemStatesNotification;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.clientfacade.domain.LoginDataPacket")]
   public class LoginDataPacket implements IEventDispatcher
   {
      
      private var _941013585minutesUntilMidnight:Number;
      
      private var _1518327835languages:ArrayCollection;
      
      private var _1289303952clientHeartBeatEnabled:Boolean;
      
      private var _31777968bingeIsPlayerInBingePreventionWindow:Boolean;
      
      private var _727434526simpleMessages:ArrayCollection;
      
      private var _1980047598platformId:String;
      
      private var _446892421gameTypeConfigs:ArrayCollection;
      
      private var _1895285149competitiveRegion:String;
      
      private var _233864292restrictedGamesRemainingForRanked:Number = -1;
      
      private var _951118571summonerCatalog:SummonerCatalog;
      
      private var _530506037minutesUntilShutdown:Number;
      
      private var _398697448pendingKudosDTO:PendingKudos;
      
      private var _84377177pendingBadges:int;
      
      private var _2009313944restrictedChatGamesRemaining:Number = -1;
      
      private var _569617484broadcastNotification:BroadcastNotification;
      
      private var _41561489customMsecsUntilReset:Number;
      
      private var _375805820inGhostGame:Boolean;
      
      private var _1327061097bingePreventionSystemEnabledForClient:Boolean;
      
      private var _808547526leaverBusterPenaltyTime:int;
      
      private var _939649346rpBalance:Number;
      
      private var _1793544942coOpVsAiMsecsUntilReset:Number;
      
      private var _417288973minorShutdownEnforced:Boolean;
      
      private var _2079793550showEmailVerificationPopup:Boolean;
      
      private var _581949073playerStatSummaries:PlayerStatSummaries;
      
      private var _1334538994maxPracticeGameSize:int;
      
      private var _1507069787reconnectInfo:GameReconnectionInfo;
      
      private var _103901109minor:Boolean;
      
      private var _864605932customMinutesLeftToday:Number;
      
      private var _840028817bingeData:String;
      
      private var _1880941230emailStatus:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _1852428363ipBalance:Number;
      
      private var _2098562532bingeMinutesRemaining:Number;
      
      private var _98991228clientSystemStates:ClientSystemStatesNotification = new ClientSystemStatesNotification();
      
      private var _483527257allSummonerData:AllSummonerData;
      
      private var _533254986leaverPenaltyLevel:int;
      
      private var _536374348minutesUntilShutdownEnabled:Boolean;
      
      private var _1807840303matchMakingEnabled:Boolean;
      
      private var _2058986104timeUntilFirstWinOfDay:Number;
      
      private var _1918330445coOpVsAiMinutesLeftToday:Number;
      
      public function LoginDataPacket()
      {
         super();
      }
      
      public function set gameTypeConfigs(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._446892421gameTypeConfigs;
         if(_loc2_ !== param1)
         {
            this._446892421gameTypeConfigs = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameTypeConfigs",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get minorShutdownEnforced() : Boolean
      {
         return this._417288973minorShutdownEnforced;
      }
      
      public function set timeUntilFirstWinOfDay(param1:Number) : void
      {
         var _loc2_:Object = this._2058986104timeUntilFirstWinOfDay;
         if(_loc2_ !== param1)
         {
            this._2058986104timeUntilFirstWinOfDay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"timeUntilFirstWinOfDay",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get languages() : ArrayCollection
      {
         return this._1518327835languages;
      }
      
      [Bindable(event="propertyChange")]
      public function get bingeMinutesRemaining() : Number
      {
         return this._2098562532bingeMinutesRemaining;
      }
      
      public function set minorShutdownEnforced(param1:Boolean) : void
      {
         var _loc2_:Object = this._417288973minorShutdownEnforced;
         if(_loc2_ !== param1)
         {
            this._417288973minorShutdownEnforced = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minorShutdownEnforced",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get pendingKudosDTO() : PendingKudos
      {
         return this._398697448pendingKudosDTO;
      }
      
      [Bindable(event="propertyChange")]
      public function get simpleMessages() : ArrayCollection
      {
         return this._727434526simpleMessages;
      }
      
      [Bindable(event="propertyChange")]
      public function get minutesUntilShutdown() : Number
      {
         return this._530506037minutesUntilShutdown;
      }
      
      public function set languages(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1518327835languages;
         if(_loc2_ !== param1)
         {
            this._1518327835languages = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"languages",_loc2_,param1));
         }
      }
      
      public function set pendingKudosDTO(param1:PendingKudos) : void
      {
         var _loc2_:Object = this._398697448pendingKudosDTO;
         if(_loc2_ !== param1)
         {
            this._398697448pendingKudosDTO = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pendingKudosDTO",_loc2_,param1));
         }
      }
      
      public function set bingeMinutesRemaining(param1:Number) : void
      {
         var _loc2_:Object = this._2098562532bingeMinutesRemaining;
         if(_loc2_ !== param1)
         {
            this._2098562532bingeMinutesRemaining = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bingeMinutesRemaining",_loc2_,param1));
         }
      }
      
      public function set bingePreventionSystemEnabledForClient(param1:Boolean) : void
      {
         var _loc2_:Object = this._1327061097bingePreventionSystemEnabledForClient;
         if(_loc2_ !== param1)
         {
            this._1327061097bingePreventionSystemEnabledForClient = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bingePreventionSystemEnabledForClient",_loc2_,param1));
         }
      }
      
      public function set simpleMessages(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._727434526simpleMessages;
         if(_loc2_ !== param1)
         {
            this._727434526simpleMessages = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"simpleMessages",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get leaverBusterPenaltyTime() : int
      {
         return this._808547526leaverBusterPenaltyTime;
      }
      
      public function set reconnectInfo(param1:GameReconnectionInfo) : void
      {
         var _loc2_:Object = this._1507069787reconnectInfo;
         if(_loc2_ !== param1)
         {
            this._1507069787reconnectInfo = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"reconnectInfo",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get minutesUntilShutdownEnabled() : Boolean
      {
         return this._536374348minutesUntilShutdownEnabled;
      }
      
      [Bindable(event="propertyChange")]
      public function get coOpVsAiMinutesLeftToday() : Number
      {
         return this._1918330445coOpVsAiMinutesLeftToday;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get bingeIsPlayerInBingePreventionWindow() : Boolean
      {
         return this._31777968bingeIsPlayerInBingePreventionWindow;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get broadcastNotification() : BroadcastNotification
      {
         return this._569617484broadcastNotification;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set pendingBadges(param1:int) : void
      {
         var _loc2_:Object = this._84377177pendingBadges;
         if(_loc2_ !== param1)
         {
            this._84377177pendingBadges = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pendingBadges",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get allSummonerData() : AllSummonerData
      {
         return this._483527257allSummonerData;
      }
      
      public function set minutesUntilMidnight(param1:Number) : void
      {
         var _loc2_:Object = this._941013585minutesUntilMidnight;
         if(_loc2_ !== param1)
         {
            this._941013585minutesUntilMidnight = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minutesUntilMidnight",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get competitiveRegion() : String
      {
         return this._1895285149competitiveRegion;
      }
      
      [Bindable(event="propertyChange")]
      public function get restrictedChatGamesRemaining() : Number
      {
         return this._2009313944restrictedChatGamesRemaining;
      }
      
      public function set ipBalance(param1:Number) : void
      {
         var _loc2_:Object = this._1852428363ipBalance;
         if(_loc2_ !== param1)
         {
            this._1852428363ipBalance = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ipBalance",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get restrictedGamesRemainingForRanked() : Number
      {
         return this._233864292restrictedGamesRemainingForRanked;
      }
      
      public function set leaverPenaltyLevel(param1:int) : void
      {
         var _loc2_:Object = this._533254986leaverPenaltyLevel;
         if(_loc2_ !== param1)
         {
            this._533254986leaverPenaltyLevel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leaverPenaltyLevel",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get customMsecsUntilReset() : Number
      {
         return this._41561489customMsecsUntilReset;
      }
      
      [Bindable(event="propertyChange")]
      public function get clientHeartBeatEnabled() : Boolean
      {
         return this._1289303952clientHeartBeatEnabled;
      }
      
      [Bindable(event="propertyChange")]
      public function get showEmailVerificationPopup() : Boolean
      {
         return this._2079793550showEmailVerificationPopup;
      }
      
      [Bindable(event="propertyChange")]
      public function get playerStatSummaries() : PlayerStatSummaries
      {
         return this._581949073playerStatSummaries;
      }
      
      public function set minor(param1:Boolean) : void
      {
         var _loc2_:Object = this._103901109minor;
         if(_loc2_ !== param1)
         {
            this._103901109minor = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minor",_loc2_,param1));
         }
      }
      
      public function set leaverBusterPenaltyTime(param1:int) : void
      {
         var _loc2_:Object = this._808547526leaverBusterPenaltyTime;
         if(_loc2_ !== param1)
         {
            this._808547526leaverBusterPenaltyTime = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leaverBusterPenaltyTime",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get inGhostGame() : Boolean
      {
         return this._375805820inGhostGame;
      }
      
      [Bindable(event="propertyChange")]
      public function get bingeData() : String
      {
         return this._840028817bingeData;
      }
      
      public function set rpBalance(param1:Number) : void
      {
         var _loc2_:Object = this._939649346rpBalance;
         if(_loc2_ !== param1)
         {
            this._939649346rpBalance = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rpBalance",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameTypeConfigs() : ArrayCollection
      {
         return this._446892421gameTypeConfigs;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get timeUntilFirstWinOfDay() : Number
      {
         return this._2058986104timeUntilFirstWinOfDay;
      }
      
      [Bindable(event="propertyChange")]
      public function get clientSystemStates() : ClientSystemStatesNotification
      {
         return this._98991228clientSystemStates;
      }
      
      public function set minutesUntilShutdown(param1:Number) : void
      {
         var _loc2_:Object = this._530506037minutesUntilShutdown;
         if(_loc2_ !== param1)
         {
            this._530506037minutesUntilShutdown = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minutesUntilShutdown",_loc2_,param1));
         }
      }
      
      public function set emailStatus(param1:String) : void
      {
         var _loc2_:Object = this._1880941230emailStatus;
         if(_loc2_ !== param1)
         {
            this._1880941230emailStatus = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"emailStatus",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bingePreventionSystemEnabledForClient() : Boolean
      {
         return this._1327061097bingePreventionSystemEnabledForClient;
      }
      
      public function set coOpVsAiMinutesLeftToday(param1:Number) : void
      {
         var _loc2_:Object = this._1918330445coOpVsAiMinutesLeftToday;
         if(_loc2_ !== param1)
         {
            this._1918330445coOpVsAiMinutesLeftToday = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"coOpVsAiMinutesLeftToday",_loc2_,param1));
         }
      }
      
      public function set matchMakingEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._1807840303matchMakingEnabled;
         if(_loc2_ !== param1)
         {
            this._1807840303matchMakingEnabled = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"matchMakingEnabled",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get reconnectInfo() : GameReconnectionInfo
      {
         return this._1507069787reconnectInfo;
      }
      
      [Bindable(event="propertyChange")]
      public function get pendingBadges() : int
      {
         return this._84377177pendingBadges;
      }
      
      [Bindable(event="propertyChange")]
      public function get minutesUntilMidnight() : Number
      {
         return this._941013585minutesUntilMidnight;
      }
      
      public function set minutesUntilShutdownEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._536374348minutesUntilShutdownEnabled;
         if(_loc2_ !== param1)
         {
            this._536374348minutesUntilShutdownEnabled = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minutesUntilShutdownEnabled",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get ipBalance() : Number
      {
         return this._1852428363ipBalance;
      }
      
      [Bindable(event="propertyChange")]
      public function get leaverPenaltyLevel() : int
      {
         return this._533254986leaverPenaltyLevel;
      }
      
      public function set bingeIsPlayerInBingePreventionWindow(param1:Boolean) : void
      {
         var _loc2_:Object = this._31777968bingeIsPlayerInBingePreventionWindow;
         if(_loc2_ !== param1)
         {
            this._31777968bingeIsPlayerInBingePreventionWindow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bingeIsPlayerInBingePreventionWindow",_loc2_,param1));
         }
      }
      
      public function set allSummonerData(param1:AllSummonerData) : void
      {
         var _loc2_:Object = this._483527257allSummonerData;
         if(_loc2_ !== param1)
         {
            this._483527257allSummonerData = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"allSummonerData",_loc2_,param1));
         }
      }
      
      public function set broadcastNotification(param1:BroadcastNotification) : void
      {
         var _loc2_:Object = this._569617484broadcastNotification;
         if(_loc2_ !== param1)
         {
            this._569617484broadcastNotification = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"broadcastNotification",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rpBalance() : Number
      {
         return this._939649346rpBalance;
      }
      
      [Bindable(event="propertyChange")]
      public function get minor() : Boolean
      {
         return this._103901109minor;
      }
      
      public function set competitiveRegion(param1:String) : void
      {
         var _loc2_:Object = this._1895285149competitiveRegion;
         if(_loc2_ !== param1)
         {
            this._1895285149competitiveRegion = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"competitiveRegion",_loc2_,param1));
         }
      }
      
      public function set restrictedGamesRemainingForRanked(param1:Number) : void
      {
         var _loc2_:Object = this._233864292restrictedGamesRemainingForRanked;
         if(_loc2_ !== param1)
         {
            this._233864292restrictedGamesRemainingForRanked = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"restrictedGamesRemainingForRanked",_loc2_,param1));
         }
      }
      
      public function set restrictedChatGamesRemaining(param1:Number) : void
      {
         var _loc2_:Object = this._2009313944restrictedChatGamesRemaining;
         if(_loc2_ !== param1)
         {
            this._2009313944restrictedChatGamesRemaining = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"restrictedChatGamesRemaining",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get matchMakingEnabled() : Boolean
      {
         return this._1807840303matchMakingEnabled;
      }
      
      public function set summonerCatalog(param1:SummonerCatalog) : void
      {
         var _loc2_:Object = this._951118571summonerCatalog;
         if(_loc2_ !== param1)
         {
            this._951118571summonerCatalog = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerCatalog",_loc2_,param1));
         }
      }
      
      public function set customMinutesLeftToday(param1:Number) : void
      {
         var _loc2_:Object = this._864605932customMinutesLeftToday;
         if(_loc2_ !== param1)
         {
            this._864605932customMinutesLeftToday = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"customMinutesLeftToday",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get emailStatus() : String
      {
         return this._1880941230emailStatus;
      }
      
      public function set customMsecsUntilReset(param1:Number) : void
      {
         var _loc2_:Object = this._41561489customMsecsUntilReset;
         if(_loc2_ !== param1)
         {
            this._41561489customMsecsUntilReset = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"customMsecsUntilReset",_loc2_,param1));
         }
      }
      
      public function set maxPracticeGameSize(param1:int) : void
      {
         var _loc2_:Object = this._1334538994maxPracticeGameSize;
         if(_loc2_ !== param1)
         {
            this._1334538994maxPracticeGameSize = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"maxPracticeGameSize",_loc2_,param1));
         }
      }
      
      public function set playerStatSummaries(param1:PlayerStatSummaries) : void
      {
         var _loc2_:Object = this._581949073playerStatSummaries;
         if(_loc2_ !== param1)
         {
            this._581949073playerStatSummaries = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerStatSummaries",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerCatalog() : SummonerCatalog
      {
         return this._951118571summonerCatalog;
      }
      
      [Bindable(event="propertyChange")]
      public function get customMinutesLeftToday() : Number
      {
         return this._864605932customMinutesLeftToday;
      }
      
      public function set bingeData(param1:String) : void
      {
         var _loc2_:Object = this._840028817bingeData;
         if(_loc2_ !== param1)
         {
            this._840028817bingeData = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bingeData",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get coOpVsAiMsecsUntilReset() : Number
      {
         return this._1793544942coOpVsAiMsecsUntilReset;
      }
      
      public function set clientHeartBeatEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._1289303952clientHeartBeatEnabled;
         if(_loc2_ !== param1)
         {
            this._1289303952clientHeartBeatEnabled = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clientHeartBeatEnabled",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get maxPracticeGameSize() : int
      {
         return this._1334538994maxPracticeGameSize;
      }
      
      public function set showEmailVerificationPopup(param1:Boolean) : void
      {
         var _loc2_:Object = this._2079793550showEmailVerificationPopup;
         if(_loc2_ !== param1)
         {
            this._2079793550showEmailVerificationPopup = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showEmailVerificationPopup",_loc2_,param1));
         }
      }
      
      public function set coOpVsAiMsecsUntilReset(param1:Number) : void
      {
         var _loc2_:Object = this._1793544942coOpVsAiMsecsUntilReset;
         if(_loc2_ !== param1)
         {
            this._1793544942coOpVsAiMsecsUntilReset = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"coOpVsAiMsecsUntilReset",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get platformId() : String
      {
         return this._1980047598platformId;
      }
      
      public function set clientSystemStates(param1:ClientSystemStatesNotification) : void
      {
         var _loc2_:Object = this._98991228clientSystemStates;
         if(_loc2_ !== param1)
         {
            this._98991228clientSystemStates = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clientSystemStates",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set platformId(param1:String) : void
      {
         var _loc2_:Object = this._1980047598platformId;
         if(_loc2_ !== param1)
         {
            this._1980047598platformId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"platformId",_loc2_,param1));
         }
      }
      
      public function set inGhostGame(param1:Boolean) : void
      {
         var _loc2_:Object = this._375805820inGhostGame;
         if(_loc2_ !== param1)
         {
            this._375805820inGhostGame = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inGhostGame",_loc2_,param1));
         }
      }
   }
}

