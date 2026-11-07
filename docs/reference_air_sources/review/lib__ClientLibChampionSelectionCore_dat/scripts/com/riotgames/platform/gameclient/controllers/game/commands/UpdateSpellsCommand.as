package com.riotgames.platform.gameclient.controllers.game.commands
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.gameclient.controllers.game.model.PlayerSelection;
   import com.riotgames.platform.gameclient.domain.PlayerChampionSelectionDTO;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.pvpnet.model.SpellSelection;
   import mx.collections.ArrayCollection;
   
   public class UpdateSpellsCommand extends CommandBase
   {
      
      private var playerSelection:PlayerSelection;
      
      private var spells:ArrayCollection;
      
      private var playerChampionSelectionDTO:PlayerChampionSelectionDTO;
      
      public function UpdateSpellsCommand(param1:PlayerSelection, param2:PlayerChampionSelectionDTO, param3:ArrayCollection)
      {
         super();
         this.playerChampionSelectionDTO = param2;
         this.playerSelection = param1;
         this.spells = param3;
      }
      
      public function updateSpellSelectionFromDto(param1:PlayerChampionSelectionDTO) : void
      {
         var _loc2_:Spell = null;
         var _loc3_:Spell = null;
         if(param1.spell1Id >= 0)
         {
            _loc2_ = this.getSpellForId(param1.spell1Id);
         }
         else
         {
            _loc2_ = null;
         }
         if(param1.spell2Id >= 0)
         {
            _loc3_ = this.getSpellForId(param1.spell2Id);
         }
         else
         {
            _loc3_ = null;
         }
         this.updateSpellSelections(_loc2_,_loc3_);
         this.playerSelection.spell1 = _loc2_;
         this.playerSelection.spell2 = _loc3_;
      }
      
      private function getSpellForId(param1:int) : Spell
      {
         var _loc2_:SpellSelection = null;
         for each(_loc2_ in this.spells)
         {
            if(_loc2_.spell.spellId == param1)
            {
               return _loc2_.spell;
            }
         }
         return null;
      }
      
      private function getSelectionForSpell(param1:Spell) : SpellSelection
      {
         var _loc2_:SpellSelection = null;
         for each(_loc2_ in this.spells)
         {
            if(_loc2_.spell.spellId == param1.spellId)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function updateSpellSelections(param1:Spell, param2:Spell) : void
      {
         var _loc3_:Spell = null;
         var _loc4_:SpellSelection = null;
         if(Boolean(this.playerSelection))
         {
            _loc3_ = this.playerSelection.spell1;
            if(Boolean(_loc3_))
            {
               _loc4_ = this.getSelectionForSpell(_loc3_);
               _loc4_.selectedIndex = -1;
               _loc4_.selected = false;
            }
            _loc3_ = null;
            _loc3_ = this.playerSelection.spell2;
            if(Boolean(_loc3_))
            {
               _loc4_ = this.getSelectionForSpell(_loc3_);
               _loc4_.selectedIndex = -1;
               _loc4_.selected = false;
            }
            _loc4_ = this.getSelectionForSpell(param1);
            if(Boolean(_loc4_))
            {
               _loc4_.selected = true;
               _loc4_.selectedIndex = 1;
            }
            _loc4_ = this.getSelectionForSpell(param2);
            if(Boolean(_loc4_))
            {
               _loc4_.selected = true;
               _loc4_.selectedIndex = 2;
            }
         }
      }
   }
}

