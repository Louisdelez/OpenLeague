package com.riotgames.pvpnet.spells
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.domain.SummonerLevel;
   
   public class SpellsController
   {
      
      private var _summonerLevelChanged:Signal = new Signal();
      
      private var _summonerLevel:SummonerLevel;
      
      public function SpellsController()
      {
         super();
      }
      
      public function get summonerLevelChanged() : ISignal
      {
         return this._summonerLevelChanged;
      }
      
      public function get summonerLevel() : SummonerLevel
      {
         return this._summonerLevel;
      }
      
      public function set summonerLevel(param1:SummonerLevel) : void
      {
         if(this._summonerLevel == param1)
         {
            return;
         }
         this._summonerLevel = param1;
         this._summonerLevelChanged.dispatch();
      }
   }
}

