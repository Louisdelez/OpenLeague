package com.riotgames.platform.gameclient.domain
{
   import com.riotgames.platform.gameclient.domain.game.FeaturedGameInfo;
   import com.riotgames.platform.gameclient.domain.game.practice.GameTeam;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.game.GameDTO")]
   public class GameDTO implements IEventDispatcher
   {
      
      private static var _730315925NUM_SPELLS_PER_SUMMONER:int = 2;
      
      private static var _staticBindingEventDispatcher:EventDispatcher = new EventDispatcher();
      
      private var _1769361227gameMode:String;
      
      private var _1114616916bannedChampions:ArrayCollection;
      
      private var _148600924spectatorsAllowed:String;
      
      private var _967404915ownerSummary:PlayerParticipant;
      
      private var _21386492practiceGameRewardsDisabledReasons:ArrayCollection;
      
      private var _1973867242queueTypeName:String;
      
      private var _1868836576glmSecurePort:int;
      
      private var _90071352optimisticLock:Number;
      
      private var _3355id:Number;
      
      private var _1439297873teamTwo:ArrayCollection;
      
      private var _1769142708gameType:String;
      
      private var _1884074881banOrder:ArrayCollection;
      
      private var _816254304expiryTime:Number;
      
      private var _1439302967teamOne:ArrayCollection;
      
      private var _39554896gameStateString:String;
      
      private var _1964322152teamOnePickOutcome:String;
      
      private var _198384553statusOfParticipants:String;
      
      private var _1913270846teamTwoPickOutcome:String;
      
      private var _1020872611gameMutators:ArrayCollection;
      
      private var _3373707name:String;
      
      private var _1436849302roomPassword:String;
      
      private var _386353608terminatedCondition:String;
      
      private var _968761961gameTypeConfigId:int;
      
      private var _508744977joinTimerDuration:int;
      
      private var _173503994roomName:String;
      
      private var _1852224113playerChampionSelections:ArrayCollection;
      
      private var _1586015820creationTime:Date;
      
      private var _118466032glmHost:String;
      
      private var _103663511mapId:int;
      
      private var _1271458290featuredGameInfo:FeaturedGameInfo;
      
      private var _990064575gameState:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _118704329glmPort:int;
      
      private var _739410882pickTurn:int;
      
      private var _549554854queuePosition:int;
      
      private var _2078078883observers:ArrayCollection;
      
      private var _1298946404accountSpellsMap:ArrayCollection;
      
      private var _352543188spectatorDelay:int;
      
      private var _173940784maxNumPlayers:int;
      
      private var _1403764679passwordSet:Boolean;
      
      public function GameDTO()
      {
         super();
      }
      
      public static function get staticEventDispatcher() : IEventDispatcher
      {
         return _staticBindingEventDispatcher;
      }
      
      public static function set NUM_SPELLS_PER_SUMMONER(param1:int) : void
      {
         var _loc3_:IEventDispatcher = null;
         var _loc2_:Object = GameDTO._730315925NUM_SPELLS_PER_SUMMONER;
         if(_loc2_ !== param1)
         {
            GameDTO._730315925NUM_SPELLS_PER_SUMMONER = param1;
            _loc3_ = GameDTO.staticEventDispatcher;
            if(_loc3_ != null)
            {
               _loc3_.dispatchEvent(PropertyChangeEvent.createUpdateEvent(GameDTO,"NUM_SPELLS_PER_SUMMONER",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public static function get NUM_SPELLS_PER_SUMMONER() : int
      {
         return GameDTO._730315925NUM_SPELLS_PER_SUMMONER;
      }
      
      [Bindable(event="propertyChange")]
      public function get glmSecurePort() : int
      {
         return this._1868836576glmSecurePort;
      }
      
      [Bindable(event="propertyChange")]
      public function get practiceGameRewardsDisabledReasons() : ArrayCollection
      {
         return this._21386492practiceGameRewardsDisabledReasons;
      }
      
      public function set banOrder(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1884074881banOrder;
         if(_loc2_ !== param1)
         {
            this._1884074881banOrder = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"banOrder",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get roomName() : String
      {
         return this._173503994roomName;
      }
      
      public function set practiceGameRewardsDisabledReasons(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._21386492practiceGameRewardsDisabledReasons;
         if(_loc2_ !== param1)
         {
            this._21386492practiceGameRewardsDisabledReasons = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"practiceGameRewardsDisabledReasons",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get featuredGameInfo() : FeaturedGameInfo
      {
         return this._1271458290featuredGameInfo;
      }
      
      public function isObserverForGame(param1:GameParticipant) : Boolean
      {
         var _loc2_:GameObserver = null;
         for each(_loc2_ in this.observers)
         {
            if(_loc2_.getSummonerInternalName() == param1.getSummonerInternalName())
            {
               return true;
            }
         }
         return false;
      }
      
      public function set name(param1:String) : void
      {
         var _loc2_:Object = this._3373707name;
         if(_loc2_ !== param1)
         {
            this._3373707name = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"name",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get id() : Number
      {
         return this._3355id;
      }
      
      private function getBotParticipantForChampionOnTeam(param1:String, param2:ArrayCollection) : BotParticipant
      {
         var _loc3_:BotParticipant = null;
         var _loc4_:GameParticipant = null;
         var _loc5_:BotParticipant = null;
         for each(_loc4_ in param2)
         {
            if(!(_loc4_ is PlayerParticipant))
            {
               _loc5_ = BotParticipant(_loc4_);
               if(_loc5_.getChampionName() == param1)
               {
                  _loc3_ = _loc5_;
                  break;
               }
            }
         }
         return _loc3_;
      }
      
      [Bindable(event="propertyChange")]
      public function get queueTypeName() : String
      {
         return this._1973867242queueTypeName;
      }
      
      public function set featuredGameInfo(param1:FeaturedGameInfo) : void
      {
         var _loc2_:Object = this._1271458290featuredGameInfo;
         if(_loc2_ !== param1)
         {
            this._1271458290featuredGameInfo = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"featuredGameInfo",_loc2_,param1));
         }
      }
      
      public function set mapId(param1:int) : void
      {
         var _loc2_:Object = this._103663511mapId;
         if(_loc2_ !== param1)
         {
            this._103663511mapId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapId",_loc2_,param1));
         }
      }
      
      public function set id(param1:Number) : void
      {
         var _loc2_:Object = this._3355id;
         if(_loc2_ !== param1)
         {
            this._3355id = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"id",_loc2_,param1));
         }
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
      
      public function set queueTypeName(param1:String) : void
      {
         var _loc2_:Object = this._1973867242queueTypeName;
         if(_loc2_ !== param1)
         {
            this._1973867242queueTypeName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"queueTypeName",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get optimisticLock() : Number
      {
         return this._90071352optimisticLock;
      }
      
      public function set expiryTime(param1:Number) : void
      {
         var _loc2_:Object = this._816254304expiryTime;
         if(_loc2_ !== param1)
         {
            this._816254304expiryTime = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"expiryTime",_loc2_,param1));
         }
      }
      
      public function getSpells(param1:Number) : ArrayCollection
      {
         var _loc2_:ArrayCollection = null;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < this.accountSpellsMap.length && _loc2_ == null)
         {
            if(_loc3_ % (NUM_SPELLS_PER_SUMMONER + 1) == 0)
            {
               _loc4_ = this.accountSpellsMap.getItemAt(_loc3_) as Number;
               if(param1 == _loc4_)
               {
                  _loc2_ = new ArrayCollection();
                  _loc5_ = 0;
                  while(_loc5_ < NUM_SPELLS_PER_SUMMONER)
                  {
                     _loc6_ = _loc3_ + _loc5_ + 1;
                     if(_loc6_ < this.accountSpellsMap.length)
                     {
                        _loc2_.addItem(this.accountSpellsMap.getItemAt(_loc3_ + _loc5_ + 1));
                     }
                     _loc5_++;
                  }
               }
            }
            _loc3_++;
         }
         return _loc2_;
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
      
      [Bindable(event="propertyChange")]
      public function get terminatedCondition() : String
      {
         return this._386353608terminatedCondition;
      }
      
      public function set spectatorsAllowed(param1:String) : void
      {
         var _loc2_:Object = this._148600924spectatorsAllowed;
         if(_loc2_ !== param1)
         {
            this._148600924spectatorsAllowed = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spectatorsAllowed",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get creationTime() : Date
      {
         return this._1586015820creationTime;
      }
      
      public function getTeamTwoBotParticipantForChampion(param1:String) : BotParticipant
      {
         return this.getBotParticipantForChampionOnTeam(param1,this.teamTwo);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set statusOfParticipants(param1:String) : void
      {
         var _loc2_:Object = this._198384553statusOfParticipants;
         if(_loc2_ !== param1)
         {
            this._198384553statusOfParticipants = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statusOfParticipants",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameType() : String
      {
         return this._1769142708gameType;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get pickTurn() : int
      {
         return this._739410882pickTurn;
      }
      
      public function set bannedChampions(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1114616916bannedChampions;
         if(_loc2_ !== param1)
         {
            this._1114616916bannedChampions = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bannedChampions",_loc2_,param1));
         }
      }
      
      public function getTeamNameForSummoner(param1:String) : String
      {
         if(this.isPlayerOnTeamOne(param1))
         {
            return GameTeam.TEAM_BLUE;
         }
         if(this.isPlayerOnTeamTwo(param1))
         {
            return GameTeam.TEAM_PURPLE;
         }
         if(this.isSummonerOnTeam(param1,this.observers))
         {
            return GameTeam.SPECTATOR;
         }
         return null;
      }
      
      [Bindable(event="propertyChange")]
      public function get queuePosition() : int
      {
         return this._549554854queuePosition;
      }
      
      [Bindable(event="propertyChange")]
      public function get observers() : ArrayCollection
      {
         return this._2078078883observers;
      }
      
      [Bindable(event="propertyChange")]
      public function get accountSpellsMap() : ArrayCollection
      {
         return this._1298946404accountSpellsMap;
      }
      
      public function set gameStateString(param1:String) : void
      {
         var _loc2_:Object = this._39554896gameStateString;
         if(_loc2_ !== param1)
         {
            this._39554896gameStateString = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameStateString",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameTypeConfigId() : int
      {
         return this._968761961gameTypeConfigId;
      }
      
      public function toString() : String
      {
         return "PracticeGame (" + this.id + "-" + this.name + ") [" + this.gameStateString + "]\n\towner: " + "\n\tteam1: " + this.teamOne.toArray().join(",") + "\n\tteam2: " + this.teamTwo.toArray().join(",");
      }
      
      public function set teamTwo(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1439297873teamTwo;
         if(_loc2_ !== param1)
         {
            this._1439297873teamTwo = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamTwo",_loc2_,param1));
         }
      }
      
      public function set optimisticLock(param1:Number) : void
      {
         var _loc2_:Object = this._90071352optimisticLock;
         if(_loc2_ !== param1)
         {
            this._90071352optimisticLock = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"optimisticLock",_loc2_,param1));
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
      
      public function set roomPassword(param1:String) : void
      {
         var _loc2_:Object = this._1436849302roomPassword;
         if(_loc2_ !== param1)
         {
            this._1436849302roomPassword = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"roomPassword",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get ownerSummary() : PlayerParticipant
      {
         return this._967404915ownerSummary;
      }
      
      public function getTeamForPlayer(param1:String) : int
      {
         var _loc2_:GameParticipant = null;
         var _loc3_:GameParticipant = null;
         for each(_loc2_ in this.teamOne)
         {
            if(_loc2_.summonerName == param1)
            {
               return 1;
            }
         }
         for each(_loc3_ in this.teamTwo)
         {
            if(_loc3_.summonerName == param1)
            {
               return 2;
            }
         }
         throw new Error("Code using this method should only be invoked after a user is on a team.");
      }
      
      public function getTeamOneBotParticipantForChampion(param1:String) : BotParticipant
      {
         return this.getBotParticipantForChampionOnTeam(param1,this.teamOne);
      }
      
      public function set pickTurn(param1:int) : void
      {
         var _loc2_:Object = this._739410882pickTurn;
         if(_loc2_ !== param1)
         {
            this._739410882pickTurn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pickTurn",_loc2_,param1));
         }
      }
      
      public function isPlayerOnTeamTwo(param1:String) : Boolean
      {
         return this.isSummonerOnTeam(param1,this.teamTwo);
      }
      
      public function isPlayerOnTeamOne(param1:String) : Boolean
      {
         return this.isSummonerOnTeam(param1,this.teamOne);
      }
      
      public function set teamTwoPickOutcome(param1:String) : void
      {
         var _loc2_:Object = this._1913270846teamTwoPickOutcome;
         if(_loc2_ !== param1)
         {
            this._1913270846teamTwoPickOutcome = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamTwoPickOutcome",_loc2_,param1));
         }
      }
      
      public function set gameState(param1:String) : void
      {
         var _loc2_:Object = this._990064575gameState;
         if(_loc2_ !== param1)
         {
            this._990064575gameState = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameState",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get playerChampionSelections() : ArrayCollection
      {
         return this._1852224113playerChampionSelections;
      }
      
      [Bindable(event="propertyChange")]
      public function get name() : String
      {
         return this._3373707name;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function getNumPlayerParticipants() : Number
      {
         var _loc1_:Number = 0;
         var _loc2_:GameParticipant = null;
         var _loc3_:uint = 0;
         while(_loc3_ < this.teamOne.length)
         {
            _loc2_ = this.teamOne.getItemAt(_loc3_) as GameParticipant;
            if(_loc2_ is PlayerParticipant)
            {
               _loc1_++;
            }
            _loc3_++;
         }
         var _loc4_:uint = 0;
         while(_loc4_ < this.teamTwo.length)
         {
            _loc2_ = this.teamTwo.getItemAt(_loc4_) as GameParticipant;
            if(_loc2_ is PlayerParticipant)
            {
               _loc1_++;
            }
            _loc4_++;
         }
         return _loc1_;
      }
      
      public function getNumTotalParticipants() : Number
      {
         return this.teamOne.length + this.teamTwo.length;
      }
      
      public function set passwordSet(param1:Boolean) : void
      {
         var _loc2_:Object = this._1403764679passwordSet;
         if(_loc2_ !== param1)
         {
            this._1403764679passwordSet = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"passwordSet",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get roomPassword() : String
      {
         return this._1436849302roomPassword;
      }
      
      [Bindable(event="propertyChange")]
      public function get mapId() : int
      {
         return this._103663511mapId;
      }
      
      public function set creationTime(param1:Date) : void
      {
         var _loc2_:Object = this._1586015820creationTime;
         if(_loc2_ !== param1)
         {
            this._1586015820creationTime = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"creationTime",_loc2_,param1));
         }
      }
      
      private function isSummonerOnTeam(param1:String, param2:ArrayCollection) : Boolean
      {
         var _loc3_:IParticipant = null;
         if(param2 != null)
         {
            for each(_loc3_ in param2)
            {
               if(_loc3_.getSummonerName() == param1)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function set terminatedCondition(param1:String) : void
      {
         var _loc2_:Object = this._386353608terminatedCondition;
         if(_loc2_ !== param1)
         {
            this._386353608terminatedCondition = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"terminatedCondition",_loc2_,param1));
         }
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
      
      public function set maxNumPlayers(param1:int) : void
      {
         var _loc2_:Object = this._173940784maxNumPlayers;
         if(_loc2_ !== param1)
         {
            this._173940784maxNumPlayers = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"maxNumPlayers",_loc2_,param1));
         }
      }
      
      public function set teamOne(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1439302967teamOne;
         if(_loc2_ !== param1)
         {
            this._1439302967teamOne = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamOne",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameMutators() : ArrayCollection
      {
         return this._1020872611gameMutators;
      }
      
      [Bindable(event="propertyChange")]
      public function get spectatorsAllowed() : String
      {
         return this._148600924spectatorsAllowed;
      }
      
      public function set spectatorDelay(param1:int) : void
      {
         var _loc2_:Object = this._352543188spectatorDelay;
         if(_loc2_ !== param1)
         {
            this._352543188spectatorDelay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spectatorDelay",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get statusOfParticipants() : String
      {
         return this._198384553statusOfParticipants;
      }
      
      public function set glmPort(param1:int) : void
      {
         var _loc2_:Object = this._118704329glmPort;
         if(_loc2_ !== param1)
         {
            this._118704329glmPort = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"glmPort",_loc2_,param1));
         }
      }
      
      [Deprecated(message="This function fails for summoners named \'Summoner 1\', etc.. (See LOLBUG-18556)")]
      public function getSelectionForSummonerName(param1:String) : PlayerChampionSelectionDTO
      {
         var _loc2_:PlayerChampionSelectionDTO = null;
         for each(_loc2_ in this.playerChampionSelections)
         {
            if(_loc2_.summonerInternalName == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      [Bindable(event="propertyChange")]
      public function get teamOnePickOutcome() : String
      {
         return this._1964322152teamOnePickOutcome;
      }
      
      public function isInternalSummonerOnTeam(param1:String, param2:ArrayCollection) : Boolean
      {
         var _loc3_:IParticipant = null;
         if(param2 != null)
         {
            for each(_loc3_ in param2)
            {
               if(_loc3_.getSummonerInternalName() == param1)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function set queuePosition(param1:int) : void
      {
         var _loc2_:Object = this._549554854queuePosition;
         if(_loc2_ !== param1)
         {
            this._549554854queuePosition = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"queuePosition",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameMode() : String
      {
         return this._1769361227gameMode;
      }
      
      [Bindable(event="propertyChange")]
      public function get gameStateString() : String
      {
         return this._39554896gameStateString;
      }
      
      [Bindable(event="propertyChange")]
      public function get bannedChampions() : ArrayCollection
      {
         return this._1114616916bannedChampions;
      }
      
      [Bindable(event="propertyChange")]
      public function get teamTwo() : ArrayCollection
      {
         return this._1439297873teamTwo;
      }
      
      [Bindable(event="propertyChange")]
      public function get expiryTime() : Number
      {
         return this._816254304expiryTime;
      }
      
      [Bindable(event="propertyChange")]
      public function get banOrder() : ArrayCollection
      {
         return this._1884074881banOrder;
      }
      
      [Bindable(event="propertyChange")]
      public function get gameState() : String
      {
         return this._990064575gameState;
      }
      
      [Bindable(event="propertyChange")]
      public function get passwordSet() : Boolean
      {
         return this._1403764679passwordSet;
      }
      
      public function isParticipantInGame(param1:GameParticipant) : Boolean
      {
         return this.isInternalSummonerOnTeam(param1.summonerInternalName,this.teamOne) || this.isInternalSummonerOnTeam(param1.summonerInternalName,this.teamTwo);
      }
      
      public function set gameTypeConfigId(param1:int) : void
      {
         var _loc2_:Object = this._968761961gameTypeConfigId;
         if(_loc2_ !== param1)
         {
            this._968761961gameTypeConfigId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameTypeConfigId",_loc2_,param1));
         }
      }
      
      public function isGameOwner(param1:PlayerParticipant) : Boolean
      {
         return param1.accountId == this.ownerSummary.accountId;
      }
      
      public function toDebugString() : String
      {
         return "[" + this.id + "] - " + this.name + " (" + this.gameStateString + ") OL(" + this.optimisticLock + ")";
      }
      
      [Bindable(event="propertyChange")]
      public function get teamTwoPickOutcome() : String
      {
         return this._1913270846teamTwoPickOutcome;
      }
      
      public function set joinTimerDuration(param1:int) : void
      {
         var _loc2_:Object = this._508744977joinTimerDuration;
         if(_loc2_ !== param1)
         {
            this._508744977joinTimerDuration = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"joinTimerDuration",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get maxNumPlayers() : int
      {
         return this._173940784maxNumPlayers;
      }
      
      [Bindable(event="propertyChange")]
      public function get teamOne() : ArrayCollection
      {
         return this._1439302967teamOne;
      }
      
      [Bindable(event="propertyChange")]
      public function get spectatorDelay() : int
      {
         return this._352543188spectatorDelay;
      }
      
      public function set ownerSummary(param1:PlayerParticipant) : void
      {
         var _loc2_:Object = this._967404915ownerSummary;
         if(_loc2_ !== param1)
         {
            this._967404915ownerSummary = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ownerSummary",_loc2_,param1));
         }
      }
      
      public function set observers(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._2078078883observers;
         if(_loc2_ !== param1)
         {
            this._2078078883observers = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"observers",_loc2_,param1));
         }
      }
      
      public function set teamOnePickOutcome(param1:String) : void
      {
         var _loc2_:Object = this._1964322152teamOnePickOutcome;
         if(_loc2_ !== param1)
         {
            this._1964322152teamOnePickOutcome = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamOnePickOutcome",_loc2_,param1));
         }
      }
      
      public function set playerChampionSelections(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1852224113playerChampionSelections;
         if(_loc2_ !== param1)
         {
            this._1852224113playerChampionSelections = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerChampionSelections",_loc2_,param1));
         }
      }
      
      public function set accountSpellsMap(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1298946404accountSpellsMap;
         if(_loc2_ !== param1)
         {
            this._1298946404accountSpellsMap = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"accountSpellsMap",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get glmPort() : int
      {
         return this._118704329glmPort;
      }
      
      public function set glmSecurePort(param1:int) : void
      {
         var _loc2_:Object = this._1868836576glmSecurePort;
         if(_loc2_ !== param1)
         {
            this._1868836576glmSecurePort = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"glmSecurePort",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get joinTimerDuration() : int
      {
         return this._508744977joinTimerDuration;
      }
      
      [Bindable(event="propertyChange")]
      public function get glmHost() : String
      {
         return this._118466032glmHost;
      }
      
      public function set glmHost(param1:String) : void
      {
         var _loc2_:Object = this._118466032glmHost;
         if(_loc2_ !== param1)
         {
            this._118466032glmHost = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"glmHost",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
   }
}

