package com.riotgames.pvpnet.cap.controllers
{
   import blix.IDestructible;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.pvpnet.cap.model.IPlayerSpellModel;
   
   public interface IPlayerSpellController extends IDestructible
   {
      
      function activate() : void;
      
      function deactivate() : void;
      
      function set playerSelection(param1:IPlayerSpellModel) : void;
      
      function selectSpells(param1:Spell, param2:Spell) : void;
      
      function get playerSelection() : IPlayerSpellModel;
   }
}

