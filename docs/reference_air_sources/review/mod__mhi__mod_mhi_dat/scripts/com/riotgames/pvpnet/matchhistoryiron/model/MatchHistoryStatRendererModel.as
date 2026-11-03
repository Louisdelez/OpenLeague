package com.riotgames.pvpnet.matchhistoryiron.model
{
   public class MatchHistoryStatRendererModel
   {
      
      private var _statName:String;
      
      private var _statValue:int;
      
      public function MatchHistoryStatRendererModel()
      {
         super();
      }
      
      public function get statName() : String
      {
         return this._statName;
      }
      
      public function set statName(param1:String) : void
      {
         this._statName = param1;
      }
      
      public function get statValue() : int
      {
         return this._statValue;
      }
      
      public function set statValue(param1:int) : void
      {
         this._statValue = param1;
      }
   }
}

