package com.riotgames.pvpnet.CLS.models
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.domain.RecentGames;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Team;
   import com.riotgames.pvpnet.CLS.views.enums.QueueTypesEnum;
   import com.riotgames.pvpnet.CLS.views.enums.SummonerRelationshipEnum;
   import com.riotgames.pvpnet.system.leagues.LeagueRank;
   import com.riotgames.pvpnet.system.leagues.LeagueTier;
   
   public class ListItemObjectModel
   {
      
      private var _id:uint;
      
      private var _iconId:uint;
      
      private var _state:String;
      
      private var _rank:LeagueRank;
      
      private var _tier:LeagueTier;
      
      private var _position:uint;
      
      private var _previousPosition:int;
      
      private var _positionChanges:int;
      
      private var _summonerName:String;
      
      private var _teamName:String;
      
      private var _relationship:String;
      
      private var _isFriend:Boolean;
      
      private var _emblems:Vector.<String>;
      
      private var _isInactive:Boolean = false;
      
      private var _wins:uint;
      
      private var _losses:uint;
      
      private var _points:int;
      
      private var _miniSeriesResults:Array;
      
      private var _miniSeriesWins:int;
      
      private var _miniSeriesLosses:int;
      
      private var _queueType:uint;
      
      private var _queueLabel:String;
      
      private var _apexPendingPromotion:Boolean = false;
      
      private var _apexPendingDemotion:Boolean = false;
      
      private var _recentGamesChanged:Signal = new Signal();
      
      private var _recentGames:RecentGames;
      
      private var _iconChanged:Signal = new Signal();
      
      private var _teamChanged:Signal = new Signal();
      
      private var _team:Team;
      
      private var _playerOrTeamId:String;
      
      private var _isSpectatable:Boolean = false;
      
      private var _isSpectatableChanged:Signal = new Signal();
      
      public function ListItemObjectModel()
      {
         super();
      }
      
      public function getIsSpectatableChanged() : ISignal
      {
         return this._isSpectatableChanged;
      }
      
      public function get isSpectatable() : Boolean
      {
         return this._isSpectatable;
      }
      
      public function set isSpectatable(param1:Boolean) : void
      {
         this._isSpectatable = param1;
         this._isSpectatableChanged.dispatch();
      }
      
      public function get queueLabel() : String
      {
         return this._queueLabel;
      }
      
      public function set queueLabel(param1:String) : void
      {
         this._queueLabel = param1;
      }
      
      public function get apexPendingPromotion() : Boolean
      {
         return this._apexPendingPromotion;
      }
      
      public function set apexPendingPromotion(param1:Boolean) : void
      {
         this._apexPendingPromotion = param1;
      }
      
      public function get apexPendingDemotion() : Boolean
      {
         return this._apexPendingDemotion;
      }
      
      public function set apexPendingDemotion(param1:Boolean) : void
      {
         this._apexPendingDemotion = param1;
      }
      
      public function get isFriend() : Boolean
      {
         return this._isFriend;
      }
      
      public function set isFriend(param1:Boolean) : void
      {
         this._isFriend = param1;
      }
      
      public function get miniSeriesResults() : Array
      {
         return this._miniSeriesResults;
      }
      
      public function get points() : int
      {
         return this._points;
      }
      
      public function get wins() : uint
      {
         return this._wins;
      }
      
      public function get losses() : uint
      {
         return this._losses;
      }
      
      public function set losses(param1:uint) : void
      {
         this._losses = param1;
      }
      
      public function get emblems() : Vector.<String>
      {
         return this._emblems;
      }
      
      public function set iconId(param1:uint) : void
      {
         this._iconId = param1;
         this._iconChanged.dispatch(this._iconId);
      }
      
      public function get iconChanged() : Signal
      {
         return this._iconChanged;
      }
      
      public function get iconId() : uint
      {
         return this._iconId;
      }
      
      public function get relationship() : String
      {
         return this._relationship;
      }
      
      public function set relationship(param1:String) : void
      {
         this._relationship = param1;
      }
      
      public function get summonerName() : String
      {
         return this._summonerName;
      }
      
      public function set summonerName(param1:String) : void
      {
         this._summonerName = param1;
      }
      
      public function get queueType() : uint
      {
         return this._queueType;
      }
      
      public function set queueType(param1:uint) : void
      {
         this._queueType = param1;
      }
      
      public function get teamName() : String
      {
         return this._teamName;
      }
      
      public function set teamName(param1:String) : void
      {
         this._teamName = param1;
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function set id(param1:uint) : void
      {
         this._id = param1;
      }
      
      public function get position() : uint
      {
         return this._position;
      }
      
      public function set position(param1:uint) : void
      {
         this._position = param1;
      }
      
      public function set state(param1:String) : void
      {
         this._state = param1;
      }
      
      public function get state() : String
      {
         return this._state;
      }
      
      public function set emblems(param1:Vector.<String>) : void
      {
         this._emblems = param1;
      }
      
      public function set wins(param1:uint) : void
      {
         this._wins = param1;
      }
      
      public function set points(param1:int) : void
      {
         this._points = param1;
      }
      
      public function set miniSeriesResults(param1:Array) : void
      {
         this._miniSeriesResults = param1;
      }
      
      public function get isInactive() : Boolean
      {
         return this._isInactive;
      }
      
      public function set isInactive(param1:Boolean) : void
      {
         this._isInactive = param1;
      }
      
      public function get recentGamesChanged() : ISignal
      {
         return this._recentGamesChanged;
      }
      
      public function get recentGames() : RecentGames
      {
         return this._recentGames;
      }
      
      public function set recentGames(param1:RecentGames) : void
      {
         this._recentGames = param1;
         this._recentGamesChanged.dispatch();
      }
      
      public function get isTeam() : Boolean
      {
         return this._queueType != QueueTypesEnum.QUEUE_TYPE_SOLO;
      }
      
      public function get name() : String
      {
         return this.isTeam ? this.teamName : this.summonerName;
      }
      
      public function get isSelf() : Boolean
      {
         return this._relationship == SummonerRelationshipEnum.SELF_RELATIONSHIP;
      }
      
      public function get teamChanged() : Signal
      {
         return this._teamChanged;
      }
      
      public function get team() : Team
      {
         return this._team;
      }
      
      public function set team(param1:Team) : void
      {
         this._team = param1;
         this._teamChanged.dispatch();
      }
      
      public function get playerOrTeamId() : String
      {
         return this._playerOrTeamId;
      }
      
      public function set playerOrTeamId(param1:String) : void
      {
         this._playerOrTeamId = param1;
      }
      
      public function get miniSeriesWins() : uint
      {
         return this._miniSeriesWins;
      }
      
      public function set miniSeriesWins(param1:uint) : void
      {
         this._miniSeriesWins = param1;
      }
      
      public function get miniSeriesLosses() : int
      {
         return this._miniSeriesLosses;
      }
      
      public function set miniSeriesLosses(param1:int) : void
      {
         this._miniSeriesLosses = param1;
      }
      
      public function get gamesPlayed() : int
      {
         return this._wins + this._losses;
      }
      
      public function get rank() : LeagueRank
      {
         return this._rank;
      }
      
      public function set rank(param1:LeagueRank) : void
      {
         this._rank = param1;
      }
      
      public function get tier() : LeagueTier
      {
         return this._tier;
      }
      
      public function set tier(param1:LeagueTier) : void
      {
         this._tier = param1;
      }
      
      public function get previousPosition() : int
      {
         return this._previousPosition;
      }
      
      public function set previousPosition(param1:int) : void
      {
         this._previousPosition = param1;
      }
      
      public function get positionChanges() : int
      {
         return this._positionChanges;
      }
      
      public function set positionChanges(param1:int) : void
      {
         this._positionChanges = param1;
      }
   }
}

