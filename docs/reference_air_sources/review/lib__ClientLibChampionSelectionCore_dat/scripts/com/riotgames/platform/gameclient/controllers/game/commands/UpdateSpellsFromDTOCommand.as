package com.riotgames.platform.gameclient.controllers.game.commands
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.gameclient.controllers.game.model.PlayerSelection;
   import com.riotgames.platform.gameclient.domain.PlayerChampionSelectionDTO;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.pvpnet.model.SpellSelection;
   import com.riotgames.pvpnet.utils.SpellUtils;
   import mx.collections.ArrayCollection;
   
   public class UpdateSpellsFromDTOCommand extends CommandBase
   {
      
      private var playerSelection:PlayerSelection;
      
      private var spells:ArrayCollection;
      
      private var playerChampionSelectionDTO:PlayerChampionSelectionDTO;
      
      public function UpdateSpellsFromDTOCommand(param1:PlayerSelection, param2:PlayerChampionSelectionDTO, param3:ArrayCollection)
      {
         super();
         this.playerChampionSelectionDTO = param2;
         this.playerSelection = param1;
         this.spells = param3;
      }
      
      public function updateSpellSelectionFromDto() : void
      {
         var _loc1_:Spell = null;
         var _loc2_:Spell = null;
         if(this.playerChampionSelectionDTO.spell1Id >= 0)
         {
            _loc1_ = SpellUtils.getSpellForIdFromSelectionCollection(this.playerChampionSelectionDTO.spell1Id,this.spells);
         }
         else
         {
            _loc1_ = null;
         }
         if(this.playerChampionSelectionDTO.spell2Id >= 0)
         {
            _loc2_ = SpellUtils.getSpellForIdFromSelectionCollection(this.playerChampionSelectionDTO.spell2Id,this.spells);
         }
         else
         {
            _loc2_ = null;
         }
         this.updateSpellSelections(_loc1_,_loc2_);
         this.playerSelection.spell1 = _loc1_;
         this.playerSelection.spell2 = _loc2_;
      }
      
      override public function execute() : void
      {
         super.execute();
         this.updateSpellSelectionFromDto();
         onComplete();
         onResult();
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
               _loc4_ = SpellUtils.getSelectionForSpellFromSelectionCollection(_loc3_,this.spells);
               _loc4_.selectedIndex = -1;
               _loc4_.selected = false;
            }
            _loc3_ = null;
            _loc3_ = this.playerSelection.spell2;
            if(Boolean(_loc3_))
            {
               _loc4_ = SpellUtils.getSelectionForSpellFromSelectionCollection(_loc3_,this.spells);
               _loc4_.selectedIndex = -1;
               _loc4_.selected = false;
            }
            if(Boolean(param1))
            {
               _loc4_ = SpellUtils.getSelectionForSpellFromSelectionCollection(param1,this.spells);
            }
            if(Boolean(_loc4_))
            {
               _loc4_.selected = true;
               _loc4_.selectedIndex = 1;
            }
            if(Boolean(param2))
            {
               _loc4_ = SpellUtils.getSelectionForSpellFromSelectionCollection(param2,this.spells);
            }
            if(Boolean(_loc4_))
            {
               _loc4_.selected = true;
               _loc4_.selectedIndex = 2;
            }
         }
      }
   }
}

