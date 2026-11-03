package com.riotgames.pvpnet.CLS.models
{
   public class SummonerObjectModel
   {
      
      private var _name:String;
      
      private var _leagues:Vector.<SummonerLeagueObjectModel>;
      
      public function SummonerObjectModel(param1:String, param2:Vector.<SummonerLeagueObjectModel>)
      {
         super();
         this._name = param1;
         this._leagues = param2;
      }
      
      public function get leagues() : Vector.<SummonerLeagueObjectModel>
      {
         return this._leagues;
      }
      
      public function get name() : String
      {
         return this._name;
      }
   }
}

