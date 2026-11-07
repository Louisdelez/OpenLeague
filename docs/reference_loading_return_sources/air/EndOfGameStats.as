package com.riotgames.platform.gameclient.domain
{
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamInfo;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   import mx.utils.RPCObjectUtil;
   
   [RemoteClass(alias="com.riotgames.platform.statistics.EndOfGameStats")]
   public class EndOfGameStats implements IEventDispatcher
   {
      
      private var _1739445269queueType:String;
      
      private var _1655724770leveledUp:Boolean;
      
      private var _708044436sendStatsToTournamentProvider:Boolean = false;
      
      private var _599784949newSpells:ArrayCollection;
      
      private var _100520elo:int;
      
      private var _1769142708gameType:String;
      
      private var _1829500859difficulty:String;
      
      private var _1888199525loyaltyBoostIpEarned:Number = 0;
      
      private var _41561489customMsecsUntilReset:Number;
      
      private var _1020872611gameMutators:ArrayCollection;
      
      private var _996153982ipEarned:Number;
      
      private var _1173460360eloChange:int;
      
      private var _864605932customMinutesLeftToday:Number;
      
      private var _869788698otherTeamPlayerParticipantStats:ArrayCollection;
      
      private var _173503994roomName:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _1253236563gameId:Number;
      
      private var _1586712385boostIpEarned:Number;
      
      private var _1812690907otherTeamInfo:TeamInfo;
      
      private var _2143407528skinName:String;
      
      private var _1000290437myTeamStatus:String;
      
      private var _1515848276loyaltyBoostXpEarned:Number = 0;
      
      private var _836030906userId:Number;
      
      private var _1769361227gameMode:String;
      
      private var _1093696278teamPlayerParticipantStats:ArrayCollection;
      
      private var _1303354692pointsPenalties:ArrayCollection;
      
      private var _694744179firstWinBonus:Number;
      
      private var _908513516basePoints:Number;
      
      private var _1733086604locationBoostIpEarned:Number = 0;
      
      private var _1208046985myTeamInfo:TeamInfo;
      
      private var _2111759354experienceTotal:Number;
      
      private var _597616769experienceEarned:Number = 0;
      
      private var _709446004odinBonusIp:Number;
      
      private var _2015387686rerollBonusEarned:Number = 0;
      
      private var _1793544942coOpVsAiMsecsUntilReset:Number;
      
      private var _1436849302roomPassword:String;
      
      private var _892495770completionBonusPoints:Number;
      
      private var _1427577775timeUntilNextFirstWinBonus:Number;
      
      private var _1986068061ipTotal:Number = 0;
      
      private var _1959784951invalid:Boolean;
      
      private var _941457002practiceMinutesPlayedToday:Number;
      
      private var _1004130666expPointsToNextLevel:Number = 0;
      
      private var _2030436955queueBonusEarned:Number;
      
      private var _413349240gameLength:Number;
      
      private var _1746265330imbalancedTeamsNoPoints:Boolean;
      
      private var _1835578835talentPointsGained:Number;
      
      private var _2105437853locationBoostXpEarned:Number = 0;
      
      private var _599478287rerollEnabled:Boolean;
      
      private var _1918330445coOpVsAiMinutesLeftToday:Number;
      
      private var _498422187rpEarned:Number;
      
      private var _938279477ranked:Boolean;
      
      private var _242133761reportGameId:Number;
      
      private var _2016885077skinIndex:Number;
      
      private var _1959063634boostXpEarned:Number;
      
      private var _585015353rerollEarned:Number = 0;
      
      public function EndOfGameStats()
      {
         super();
      }
      
      public function set reportGameId(param1:Number) : void
      {
         var _loc2_:Object = this._242133761reportGameId;
         if(_loc2_ !== param1)
         {
            this._242133761reportGameId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"reportGameId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get roomName() : String
      {
         return this._173503994roomName;
      }
      
      [Bindable(event="propertyChange")]
      public function get otherTeamInfo() : TeamInfo
      {
         return this._1812690907otherTeamInfo;
      }
      
      [Bindable(event="propertyChange")]
      public function get newSpells() : ArrayCollection
      {
         return this._599784949newSpells;
      }
      
      public function set roomName(param1:String) : void
      {
         var _loc2_:Object = this._173503994roomName;
         if(_loc2_ !== param1)
         {
            this._173503994roomName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"roomName",_loc2_,param1));
         }
      }
      
      public function set newSpells(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._599784949newSpells;
         if(_loc2_ !== param1)
         {
            this._599784949newSpells = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"newSpells",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get otherTeamPlayerParticipantStats() : ArrayCollection
      {
         return this._869788698otherTeamPlayerParticipantStats;
      }
      
      public function set imbalancedTeamsNoPoints(param1:Boolean) : void
      {
         var _loc2_:Object = this._1746265330imbalancedTeamsNoPoints;
         if(_loc2_ !== param1)
         {
            this._1746265330imbalancedTeamsNoPoints = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"imbalancedTeamsNoPoints",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rerollBonusEarned() : Number
      {
         return this._2015387686rerollBonusEarned;
      }
      
      public function set basePoints(param1:Number) : void
      {
         var _loc2_:Object = this._908513516basePoints;
         if(_loc2_ !== param1)
         {
            this._908513516basePoints = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"basePoints",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get talentPointsGained() : Number
      {
         return this._1835578835talentPointsGained;
      }
      
      public function set otherTeamPlayerParticipantStats(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._869788698otherTeamPlayerParticipantStats;
         if(_loc2_ !== param1)
         {
            this._869788698otherTeamPlayerParticipantStats = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"otherTeamPlayerParticipantStats",_loc2_,param1));
         }
      }
      
      public function set leveledUp(param1:Boolean) : void
      {
         var _loc2_:Object = this._1655724770leveledUp;
         if(_loc2_ !== param1)
         {
            this._1655724770leveledUp = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leveledUp",_loc2_,param1));
         }
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set rerollBonusEarned(param1:Number) : void
      {
         var _loc2_:Object = this._2015387686rerollBonusEarned;
         if(_loc2_ !== param1)
         {
            this._2015387686rerollBonusEarned = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rerollBonusEarned",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get boostXpEarned() : Number
      {
         return this._1959063634boostXpEarned;
      }
      
      [Bindable(event="propertyChange")]
      public function get gameType() : String
      {
         return this._1769142708gameType;
      }
      
      [Bindable(event="propertyChange")]
      public function get userId() : Number
      {
         return this._836030906userId;
      }
      
      public function set talentPointsGained(param1:Number) : void
      {
         var _loc2_:Object = this._1835578835talentPointsGained;
         if(_loc2_ !== param1)
         {
            this._1835578835talentPointsGained = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"talentPointsGained",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rpEarned() : Number
      {
         return this._498422187rpEarned;
      }
      
      [Bindable(event="propertyChange")]
      public function get ipTotal() : Number
      {
         return this._1986068061ipTotal;
      }
      
      [Bindable(event="propertyChange")]
      public function get coOpVsAiMinutesLeftToday() : Number
      {
         return this._1918330445coOpVsAiMinutesLeftToday;
      }
      
      [Bindable(event="propertyChange")]
      public function get completionBonusPoints() : Number
      {
         return this._892495770completionBonusPoints;
      }
      
      [Bindable(event="propertyChange")]
      public function get practiceMinutesPlayedToday() : Number
      {
         return this._941457002practiceMinutesPlayedToday;
      }
      
      public function toString() : String
      {
         return RPCObjectUtil.toString(this);
      }
      
      [Bindable(event="propertyChange")]
      public function get customMsecsUntilReset() : Number
      {
         return this._41561489customMsecsUntilReset;
      }
      
      [Bindable(event="propertyChange")]
      public function get firstWinBonus() : Number
      {
         return this._694744179firstWinBonus;
      }
      
      [Bindable(event="propertyChange")]
      public function get myTeamInfo() : TeamInfo
      {
         return this._1208046985myTeamInfo;
      }
      
      [Bindable(event="propertyChange")]
      public function get eloChange() : int
      {
         return this._1173460360eloChange;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get ipEarned() : Number
      {
         return this._996153982ipEarned;
      }
      
      [Bindable(event="propertyChange")]
      public function get experienceEarned() : Number
      {
         return this._597616769experienceEarned;
      }
      
      public function set boostIpEarned(param1:Number) : void
      {
         var _loc2_:Object = this._1586712385boostIpEarned;
         if(_loc2_ !== param1)
         {
            this._1586712385boostIpEarned = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"boostIpEarned",_loc2_,param1));
         }
      }
      
      public function set userId(param1:Number) : void
      {
         var _loc2_:Object = this._836030906userId;
         if(_loc2_ !== param1)
         {
            this._836030906userId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"userId",_loc2_,param1));
         }
      }
      
      public function set pointsPenalties(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1303354692pointsPenalties;
         if(_loc2_ !== param1)
         {
            this._1303354692pointsPenalties = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pointsPenalties",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get odinBonusIp() : Number
      {
         return this._709446004odinBonusIp;
      }
      
      [Bindable(event="propertyChange")]
      public function get expPointsToNextLevel() : Number
      {
         return this._1004130666expPointsToNextLevel;
      }
      
      public function set gameType(param1:String) : void
      {
         var _loc2_:Object = this._1769142708gameType;
         if(_loc2_ !== param1)
         {
            this._1769142708gameType = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameType",_loc2_,param1));
         }
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
      
      [Bindable(event="propertyChange")]
      public function get loyaltyBoostIpEarned() : Number
      {
         return this._1888199525loyaltyBoostIpEarned;
      }
      
      [Bindable(event="propertyChange")]
      public function get locationBoostXpEarned() : Number
      {
         return this._2105437853locationBoostXpEarned;
      }
      
      public function set boostXpEarned(param1:Number) : void
      {
         var _loc2_:Object = this._1959063634boostXpEarned;
         if(_loc2_ !== param1)
         {
            this._1959063634boostXpEarned = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"boostXpEarned",_loc2_,param1));
         }
      }
      
      public function set rpEarned(param1:Number) : void
      {
         var _loc2_:Object = this._498422187rpEarned;
         if(_loc2_ !== param1)
         {
            this._498422187rpEarned = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rpEarned",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameId() : Number
      {
         return this._1253236563gameId;
      }
      
      [Bindable(event="propertyChange")]
      public function get roomPassword() : String
      {
         return this._1436849302roomPassword;
      }
      
      [Bindable(event="propertyChange")]
      public function get elo() : int
      {
         return this._100520elo;
      }
      
      public function set skinIndex(param1:Number) : void
      {
         var _loc2_:Object = this._2016885077skinIndex;
         if(_loc2_ !== param1)
         {
            this._2016885077skinIndex = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"skinIndex",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameMode() : String
      {
         return this._1769361227gameMode;
      }
      
      public function set ipTotal(param1:Number) : void
      {
         var _loc2_:Object = this._1986068061ipTotal;
         if(_loc2_ !== param1)
         {
            this._1986068061ipTotal = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ipTotal",_loc2_,param1));
         }
      }
      
      public function set completionBonusPoints(param1:Number) : void
      {
         var _loc2_:Object = this._892495770completionBonusPoints;
         if(_loc2_ !== param1)
         {
            this._892495770completionBonusPoints = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"completionBonusPoints",_loc2_,param1));
         }
      }
      
      public function set practiceMinutesPlayedToday(param1:Number) : void
      {
         var _loc2_:Object = this._941457002practiceMinutesPlayedToday;
         if(_loc2_ !== param1)
         {
            this._941457002practiceMinutesPlayedToday = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"practiceMinutesPlayedToday",_loc2_,param1));
         }
      }
      
      public function set sendStatsToTournamentProvider(param1:Boolean) : void
      {
         var _loc2_:Object = this._708044436sendStatsToTournamentProvider;
         if(_loc2_ !== param1)
         {
            this._708044436sendStatsToTournamentProvider = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sendStatsToTournamentProvider",_loc2_,param1));
         }
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
      
      public function set firstWinBonus(param1:Number) : void
      {
         var _loc2_:Object = this._694744179firstWinBonus;
         if(_loc2_ !== param1)
         {
            this._694744179firstWinBonus = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"firstWinBonus",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get teamPlayerParticipantStats() : ArrayCollection
      {
         return this._1093696278teamPlayerParticipantStats;
      }
      
      [Bindable(event="propertyChange")]
      public function get customMinutesLeftToday() : Number
      {
         return this._864605932customMinutesLeftToday;
      }
      
      [Bindable(event="propertyChange")]
      public function get coOpVsAiMsecsUntilReset() : Number
      {
         return this._1793544942coOpVsAiMsecsUntilReset;
      }
      
      public function set eloChange(param1:int) : void
      {
         var _loc2_:Object = this._1173460360eloChange;
         if(_loc2_ !== param1)
         {
            this._1173460360eloChange = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"eloChange",_loc2_,param1));
         }
      }
      
      public function set myTeamInfo(param1:TeamInfo) : void
      {
         var _loc2_:Object = this._1208046985myTeamInfo;
         if(_loc2_ !== param1)
         {
            this._1208046985myTeamInfo = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"myTeamInfo",_loc2_,param1));
         }
      }
      
      public function set myTeamStatus(param1:String) : void
      {
         var _loc2_:Object = this._1000290437myTeamStatus;
         if(_loc2_ !== param1)
         {
            this._1000290437myTeamStatus = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"myTeamStatus",_loc2_,param1));
         }
      }
      
      public function set gameLength(param1:Number) : void
      {
         var _loc2_:Object = this._413349240gameLength;
         if(_loc2_ !== param1)
         {
            this._413349240gameLength = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameLength",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set ipEarned(param1:Number) : void
      {
         var _loc2_:Object = this._996153982ipEarned;
         if(_loc2_ !== param1)
         {
            this._996153982ipEarned = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ipEarned",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get reportGameId() : Number
      {
         return this._242133761reportGameId;
      }
      
      public function set experienceEarned(param1:Number) : void
      {
         var _loc2_:Object = this._597616769experienceEarned;
         if(_loc2_ !== param1)
         {
            this._597616769experienceEarned = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"experienceEarned",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get imbalancedTeamsNoPoints() : Boolean
      {
         return this._1746265330imbalancedTeamsNoPoints;
      }
      
      [Bindable(event="propertyChange")]
      public function get basePoints() : Number
      {
         return this._908513516basePoints;
      }
      
      public function set odinBonusIp(param1:Number) : void
      {
         var _loc2_:Object = this._709446004odinBonusIp;
         if(_loc2_ !== param1)
         {
            this._709446004odinBonusIp = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"odinBonusIp",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get leveledUp() : Boolean
      {
         return this._1655724770leveledUp;
      }
      
      public function set locationBoostIpEarned(param1:Number) : void
      {
         var _loc2_:Object = this._1733086604locationBoostIpEarned;
         if(_loc2_ !== param1)
         {
            this._1733086604locationBoostIpEarned = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"locationBoostIpEarned",_loc2_,param1));
         }
      }
      
      public function set expPointsToNextLevel(param1:Number) : void
      {
         var _loc2_:Object = this._1004130666expPointsToNextLevel;
         if(_loc2_ !== param1)
         {
            this._1004130666expPointsToNextLevel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"expPointsToNextLevel",_loc2_,param1));
         }
      }
      
      public function set loyaltyBoostIpEarned(param1:Number) : void
      {
         var _loc2_:Object = this._1888199525loyaltyBoostIpEarned;
         if(_loc2_ !== param1)
         {
            this._1888199525loyaltyBoostIpEarned = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"loyaltyBoostIpEarned",_loc2_,param1));
         }
      }
      
      public function set locationBoostXpEarned(param1:Number) : void
      {
         var _loc2_:Object = this._2105437853locationBoostXpEarned;
         if(_loc2_ !== param1)
         {
            this._2105437853locationBoostXpEarned = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"locationBoostXpEarned",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get boostIpEarned() : Number
      {
         return this._1586712385boostIpEarned;
      }
      
      [Bindable(event="propertyChange")]
      public function get pointsPenalties() : ArrayCollection
      {
         return this._1303354692pointsPenalties;
      }
      
      public function set gameMutators(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1020872611gameMutators;
         if(_loc2_ !== param1)
         {
            this._1020872611gameMutators = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameMutators",_loc2_,param1));
         }
      }
      
      public function set queueBonusEarned(param1:Number) : void
      {
         var _loc2_:Object = this._2030436955queueBonusEarned;
         if(_loc2_ !== param1)
         {
            this._2030436955queueBonusEarned = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"queueBonusEarned",_loc2_,param1));
         }
      }
      
      public function set roomPassword(param1:String) : void
      {
         var _loc2_:Object = this._1436849302roomPassword;
         if(_loc2_ !== param1)
         {
            this._1436849302roomPassword = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"roomPassword",_loc2_,param1));
         }
      }
      
      public function set skinName(param1:String) : void
      {
         var _loc2_:Object = this._2143407528skinName;
         if(_loc2_ !== param1)
         {
            this._2143407528skinName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"skinName",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get skinIndex() : Number
      {
         return this._2016885077skinIndex;
      }
      
      public function set elo(param1:int) : void
      {
         var _loc2_:Object = this._100520elo;
         if(_loc2_ !== param1)
         {
            this._100520elo = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"elo",_loc2_,param1));
         }
      }
      
      public function set loyaltyBoostXpEarned(param1:Number) : void
      {
         var _loc2_:Object = this._1515848276loyaltyBoostXpEarned;
         if(_loc2_ !== param1)
         {
            this._1515848276loyaltyBoostXpEarned = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"loyaltyBoostXpEarned",_loc2_,param1));
         }
      }
      
      public function set gameId(param1:Number) : void
      {
         var _loc2_:Object = this._1253236563gameId;
         if(_loc2_ !== param1)
         {
            this._1253236563gameId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameId",_loc2_,param1));
         }
      }
      
      public function set timeUntilNextFirstWinBonus(param1:Number) : void
      {
         var _loc2_:Object = this._1427577775timeUntilNextFirstWinBonus;
         if(_loc2_ !== param1)
         {
            this._1427577775timeUntilNextFirstWinBonus = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"timeUntilNextFirstWinBonus",_loc2_,param1));
         }
      }
      
      public function set gameMode(param1:String) : void
      {
         var _loc2_:Object = this._1769361227gameMode;
         if(_loc2_ !== param1)
         {
            this._1769361227gameMode = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameMode",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get sendStatsToTournamentProvider() : Boolean
      {
         return this._708044436sendStatsToTournamentProvider;
      }
      
      public function set difficulty(param1:String) : void
      {
         var _loc2_:Object = this._1829500859difficulty;
         if(_loc2_ !== param1)
         {
            this._1829500859difficulty = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"difficulty",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameLength() : Number
      {
         return this._413349240gameLength;
      }
      
      [Bindable(event="propertyChange")]
      public function get myTeamStatus() : String
      {
         return this._1000290437myTeamStatus;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get locationBoostIpEarned() : Number
      {
         return this._1733086604locationBoostIpEarned;
      }
      
      public function set rerollEarned(param1:Number) : void
      {
         var _loc2_:Object = this._585015353rerollEarned;
         if(_loc2_ !== param1)
         {
            this._585015353rerollEarned = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rerollEarned",_loc2_,param1));
         }
      }
      
      public function set ranked(param1:Boolean) : void
      {
         var _loc2_:Object = this._938279477ranked;
         if(_loc2_ !== param1)
         {
            this._938279477ranked = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ranked",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameMutators() : ArrayCollection
      {
         return this._1020872611gameMutators;
      }
      
      [Bindable(event="propertyChange")]
      public function get queueBonusEarned() : Number
      {
         return this._2030436955queueBonusEarned;
      }
      
      [Bindable(event="propertyChange")]
      public function get skinName() : String
      {
         return this._2143407528skinName;
      }
      
      [Bindable(event="propertyChange")]
      public function get loyaltyBoostXpEarned() : Number
      {
         return this._1515848276loyaltyBoostXpEarned;
      }
      
      [Bindable(event="propertyChange")]
      public function get timeUntilNextFirstWinBonus() : Number
      {
         return this._1427577775timeUntilNextFirstWinBonus;
      }
      
      public function set otherTeamInfo(param1:TeamInfo) : void
      {
         var _loc2_:Object = this._1812690907otherTeamInfo;
         if(_loc2_ !== param1)
         {
            this._1812690907otherTeamInfo = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"otherTeamInfo",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get difficulty() : String
      {
         return this._1829500859difficulty;
      }
      
      [Bindable(event="propertyChange")]
      public function get ranked() : Boolean
      {
         return this._938279477ranked;
      }
      
      [Bindable(event="propertyChange")]
      public function get rerollEarned() : Number
      {
         return this._585015353rerollEarned;
      }
      
      public function set queueType(param1:String) : void
      {
         var _loc2_:Object = this._1739445269queueType;
         if(_loc2_ !== param1)
         {
            this._1739445269queueType = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"queueType",_loc2_,param1));
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
      
      public function set teamPlayerParticipantStats(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1093696278teamPlayerParticipantStats;
         if(_loc2_ !== param1)
         {
            this._1093696278teamPlayerParticipantStats = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamPlayerParticipantStats",_loc2_,param1));
         }
      }
      
      public function set rerollEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._599478287rerollEnabled;
         if(_loc2_ !== param1)
         {
            this._599478287rerollEnabled = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rerollEnabled",_loc2_,param1));
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
      public function get queueType() : String
      {
         return this._1739445269queueType;
      }
      
      public function set invalid(param1:Boolean) : void
      {
         var _loc2_:Object = this._1959784951invalid;
         if(_loc2_ !== param1)
         {
            this._1959784951invalid = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"invalid",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rerollEnabled() : Boolean
      {
         return this._599478287rerollEnabled;
      }
      
      public function set experienceTotal(param1:Number) : void
      {
         var _loc2_:Object = this._2111759354experienceTotal;
         if(_loc2_ !== param1)
         {
            this._2111759354experienceTotal = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"experienceTotal",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get invalid() : Boolean
      {
         return this._1959784951invalid;
      }
      
      [Bindable(event="propertyChange")]
      public function get experienceTotal() : Number
      {
         return this._2111759354experienceTotal;
      }
   }
}

