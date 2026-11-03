package com.riotgames.pvpnet.CLS.models
{
   import com.riotgames.pvpnet.system.leagues.LeagueRank;
   import com.riotgames.pvpnet.system.leagues.LeagueTier;
   
   public class SummonerLeagueObjectModel
   {
      
      private var _leagueName:String;
      
      private var _id:int;
      
      private var _tier:LeagueTier;
      
      private var _rank:LeagueRank;
      
      private var _teamName:String;
      
      private var _queueType:uint = 2147483647;
      
      private var _elements:RankListViewModel;
      
      public function SummonerLeagueObjectModel(param1:String, param2:LeagueTier, param3:LeagueRank, param4:RankListViewModel)
      {
         super();
         this._leagueName = param1;
         this._tier = param2;
         this._rank = param3;
         this._elements = param4;
         if(param4)
         {
            this._elements.myRank.rank = param3;
            this._elements.myRank.tier = param2;
            this._teamName = param4.myRank.teamName;
            this._queueType = param4.myRank.queueType;
         }
      }
      
      public function get queueType() : uint
      {
         return this._queueType;
      }
      
      public function get teamName() : String
      {
         return this._teamName;
      }
      
      public function get elements() : RankListViewModel
      {
         return this._elements;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set id(param1:int) : void
      {
         this._id = param1;
      }
      
      public function get leagueName() : String
      {
         return this._leagueName;
      }
      
      public function get tier() : LeagueTier
      {
         return this._tier;
      }
      
      public function set tier(param1:LeagueTier) : void
      {
         this._tier = param1;
      }
      
      public function get rank() : LeagueRank
      {
         return this._rank;
      }
      
      public function set rank(param1:LeagueRank) : void
      {
         this._rank = param1;
      }
   }
}

