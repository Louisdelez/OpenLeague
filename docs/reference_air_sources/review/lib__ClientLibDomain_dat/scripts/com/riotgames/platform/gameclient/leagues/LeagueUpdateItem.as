package com.riotgames.platform.gameclient.leagues
{
   import com.riotgames.platform.gameclient.domain.MiniSeriesDTO;
   
   public class LeagueUpdateItem
   {
      
      public static const LEAGUE_PROMOTED:String = "LEAGUE_PROMOTED";
      
      public static const LEAGUE_DEMOTED:String = "LEAGUE_DEMOTED";
      
      public static const MINISERIES_START:String = "MINISERIES_START";
      
      public static const MINISERIES_LOST:String = "MINISERIES_LOST";
      
      public static const MINISERIES_CANCEL:String = "MINISERIES_CANCEL";
      
      public static const LEAGUE_SEEDED:String = "LEAGUE_SEEDED";
      
      public static const LEAGUE_POINTS_UPDATE:String = "LEAGUE_POINTS_UPDATE";
      
      public static const LEAGUE_UPDATE_DECAY:String = "LEAGUE_UPDATE_DECAY";
      
      public static const NOT_YET_SEEDED:String = "NOT_YET_SEEDED";
      
      public static const QUEUE_DODGE:String = "QUEUE_DODGE";
      
      private var _veteran:Boolean = false;
      
      private var _freshBlood:Boolean = false;
      
      private var _rank:String = "";
      
      private var _type:String = "";
      
      private var _lastPlayed:int = 0;
      
      private var _playerOrTeamName:String = "";
      
      private var _losses:int = 0;
      
      private var _hotStreak:Boolean = false;
      
      private var _playerOrTeamId:String = "";
      
      private var _tier:String = "";
      
      private var _timeUntilDecay:int = 0;
      
      private var _inactive:Boolean = false;
      
      private var _gameId:Number = 0;
      
      private var _miniSeries:MiniSeriesDTO = null;
      
      private var _leaguePoints:int = 0;
      
      private var _leaguePointsDelta:int = 0;
      
      private var _timeLastDecayMessageShown:int = 0;
      
      private var _queueType:String = "";
      
      private var _wins:int = 0;
      
      private var _leagueName:String = "";
      
      private var _previousDayLeaguePosition:int = 0;
      
      public function LeagueUpdateItem()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_ += "Type = " + this._type;
         _loc1_ += "GameId = " + this._gameId.toString();
         _loc1_ += "LeagueName = " + this._leagueName;
         _loc1_ += "FreshBlood = " + this.freshBlood.toString();
         _loc1_ += "HotStreak = " + this._hotStreak.toString();
         _loc1_ += "Inactive = " + this._inactive.toString();
         _loc1_ += "Veteran = " + this._veteran.toString();
         _loc1_ += "LeaguePoints = " + this._leaguePoints.toString();
         _loc1_ += "Wins = " + this._wins.toString();
         _loc1_ += "Losses = " + this._losses.toString();
         _loc1_ += "PlayerOrTeamName = " + this._playerOrTeamName;
         _loc1_ += "QueueType = " + this._queueType;
         _loc1_ += "Rank = " + this._rank;
         _loc1_ += "Tier = " + this._tier;
         return _loc1_ + ("In MiniSeries= " + this._miniSeries != null ? "true" : "false");
      }
      
      public function get lastPlayed() : int
      {
         return this._lastPlayed;
      }
      
      public function get losses() : int
      {
         return this._losses;
      }
      
      public function get wins() : int
      {
         return this._wins;
      }
      
      public function get playerOrTeamId() : String
      {
         return this._playerOrTeamId;
      }
      
      public function get timeUntilDecay() : int
      {
         return this._timeUntilDecay;
      }
      
      public function get rank() : String
      {
         return this._rank;
      }
      
      public function get gameId() : Number
      {
         return this._gameId;
      }
      
      public function get miniSeries() : MiniSeriesDTO
      {
         return this._miniSeries;
      }
      
      public function get hotStreak() : Boolean
      {
         return this._hotStreak;
      }
      
      public function set leagueName(param1:String) : void
      {
         this._leagueName = param1;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function get veteran() : Boolean
      {
         return this._veteran;
      }
      
      public function get playerOrTeamName() : String
      {
         return this._playerOrTeamName;
      }
      
      public function get leagueName() : String
      {
         return this._leagueName;
      }
      
      public function get timeLastDecayMessageShown() : int
      {
         return this._timeLastDecayMessageShown;
      }
      
      public function get tier() : String
      {
         return this._tier;
      }
      
      public function get leaguePointsDelta() : int
      {
         return this._leaguePointsDelta;
      }
      
      public function get queueType() : String
      {
         return this._queueType;
      }
      
      public function get leaguePoints() : int
      {
         return this._leaguePoints;
      }
      
      public function get freshBlood() : Boolean
      {
         return this._freshBlood;
      }
      
      public function fillDataFromPayload(param1:String, param2:Object, param3:int = 0, param4:Number = NaN) : void
      {
         this._type = param1;
         this._leaguePointsDelta = param3;
         this._gameId = param4;
         if(param2 == null)
         {
            return;
         }
         if(param2.hasOwnProperty("leagueName"))
         {
            this._leagueName = param2["leagueName"];
         }
         if(param2.hasOwnProperty("freshBlood"))
         {
            this._freshBlood = param2["freshBlood"];
         }
         if(param2.hasOwnProperty("hotStreak"))
         {
            this._hotStreak = param2["hotStreak"];
         }
         if(param2.hasOwnProperty("inactive"))
         {
            this._inactive = param2["inactive"];
         }
         if(param2.hasOwnProperty("veteran"))
         {
            this._veteran = param2["veteran"];
         }
         if(param2.hasOwnProperty("leaguePoints"))
         {
            this._leaguePoints = param2["leaguePoints"];
         }
         if(param2.hasOwnProperty("wins"))
         {
            this._wins = param2["wins"];
         }
         if(param2.hasOwnProperty("losses"))
         {
            this._losses = param2["losses"];
         }
         if(param2.hasOwnProperty("playerOrTeamId"))
         {
            this._playerOrTeamId = param2["playerOrTeamId"];
         }
         if(param2.hasOwnProperty("playerOrTeamName"))
         {
            this._playerOrTeamName = param2["playerOrTeamName"];
         }
         if(param2.hasOwnProperty("previousDayLeaguePosition"))
         {
            this._previousDayLeaguePosition = param2["previousDayLeaguePosition"];
         }
         if(param2.hasOwnProperty("queueType"))
         {
            this._queueType = param2["queueType"];
         }
         if(param2.hasOwnProperty("rank"))
         {
            this._rank = param2["rank"];
         }
         if(param2.hasOwnProperty("tier"))
         {
            this._tier = param2["tier"];
         }
         if(param2.hasOwnProperty("miniSeries"))
         {
            this._miniSeries = MiniSeriesDTO.createFromObject(param2["miniSeries"]);
         }
      }
      
      public function get inactive() : Boolean
      {
         return this._inactive;
      }
      
      public function get previousDayLeaguePosition() : int
      {
         return this._previousDayLeaguePosition;
      }
   }
}

