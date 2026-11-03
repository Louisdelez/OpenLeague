package com.riotgames.pvpnet.championinventory.model
{
   public class ChampionAvailabilityStatus
   {
      
      private var _label:String;
      
      private var _filterType:int;
      
      public function ChampionAvailabilityStatus(param1:String, param2:int)
      {
         super();
         this._label = param1;
         this._filterType = param2;
      }
      
      public function get label() : String
      {
         return this._label;
      }
      
      public function getFilterType() : int
      {
         return this._filterType;
      }
   }
}

