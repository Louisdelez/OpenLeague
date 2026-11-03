package com.riotgames.pvpnet.cap.controllers
{
   import blix.IDestructible;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.pvpnet.cap.model.IPlayerSpellModel;
   
   public class PlayerSpellController implements IPlayerSpellController, IDestructible
   {
      
      protected var _playerSelection:IPlayerSpellModel;
      
      public function PlayerSpellController(param1:IPlayerSpellModel)
      {
         super();
         this._playerSelection = param1;
      }
      
      public function destroy() : void
      {
         this.deactivate();
      }
      
      public function confirmSpells(param1:Spell, param2:Spell) : void
      {
         if(param1 == null)
         {
            param1 = this._playerSelection.spell1;
            if(param1 == param2)
            {
               param1 = this._playerSelection.spell2;
            }
         }
         if(param2 == null)
         {
            param2 = this._playerSelection.spell2;
            if(param1 == param2)
            {
               param2 = this._playerSelection.spell1;
            }
         }
         if(param1 == this._playerSelection.spell1 && param2 == this._playerSelection.spell2)
         {
            return;
         }
         this.doSelectSpells(param1,param2);
      }
      
      public function selectSpells(param1:Spell, param2:Spell) : void
      {
         this.confirmSpells(param1,param2);
      }
      
      public function get playerSelection() : IPlayerSpellModel
      {
         return this._playerSelection;
      }
      
      public function deactivate() : void
      {
      }
      
      public function set playerSelection(param1:IPlayerSpellModel) : void
      {
         this._playerSelection = param1;
      }
      
      protected function doSelectSpells(param1:Spell, param2:Spell) : void
      {
         this._playerSelection.spell1 = param1;
         this._playerSelection.spell2 = param2;
      }
      
      public function activate() : void
      {
      }
   }
}

