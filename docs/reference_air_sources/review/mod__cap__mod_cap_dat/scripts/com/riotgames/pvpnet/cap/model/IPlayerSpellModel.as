package com.riotgames.pvpnet.cap.model
{
   import blix.signals.ISignal;
   import com.riotgames.platform.gameclient.domain.Spell;
   
   public interface IPlayerSpellModel
   {
      
      function get spell2Changed() : ISignal;
      
      function set spell1(param1:Spell) : void;
      
      function set spell2(param1:Spell) : void;
      
      function get spell1() : Spell;
      
      function get spell2() : Spell;
      
      function get spell1Changed() : ISignal;
   }
}

