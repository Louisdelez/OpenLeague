package com.riotgames.pvpnet.runes.viewcontroller
{
   import com.riotgames.platform.gameclient.domain.RuneSlot;
   import com.riotgames.platform.gameclient.domain.SummonerRune;
   
   public class RuneDropTarget
   {
      
      private var _summonerRune:SummonerRune;
      
      private var _targetSlot:RuneSlot;
      
      public function RuneDropTarget(param1:SummonerRune, param2:RuneSlot)
      {
         super();
         this._summonerRune = param1;
         this._targetSlot = param2;
      }
      
      public function getSummonerRune() : SummonerRune
      {
         return this._summonerRune;
      }
      
      public function getTargetSlot() : RuneSlot
      {
         return this._targetSlot;
      }
      
      public function equals(param1:RuneDropTarget) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         if(Boolean(this._summonerRune == param1.getSummonerRune()) && Boolean(this._targetSlot) && Boolean(param1.getTargetSlot()))
         {
            return true;
         }
         return false;
      }
   }
}

