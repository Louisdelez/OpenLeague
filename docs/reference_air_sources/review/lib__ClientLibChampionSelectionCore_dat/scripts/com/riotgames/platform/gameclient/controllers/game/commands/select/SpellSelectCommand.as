package com.riotgames.platform.gameclient.controllers.game.commands.select
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.platform.gameclient.services.GameService;
   import mx.collections.ArrayCollection;
   
   public class SpellSelectCommand extends CommandBase
   {
      
      private var gameService:GameService;
      
      private var spell1:Spell;
      
      private var spell2:Spell;
      
      private var championSelectionModel:ChampionSelectionModel;
      
      public function SpellSelectCommand(param1:Spell, param2:Spell, param3:ChampionSelectionModel, param4:GameService)
      {
         super();
         this.spell1 = param1;
         this.spell2 = param2;
         this.championSelectionModel = param3;
         this.gameService = param4;
      }
      
      override protected function onResult(param1:Object = null) : void
      {
         this.championSelectionModel.currentGame = param1.result as GameDTO;
         super.onResult(param1.result);
      }
      
      override public function execute() : void
      {
         super.execute();
         this.championSelectionModel.spellsBusy = true;
         this.gameService.selectSpells(new ArrayCollection([this.spell1.spellId,this.spell2.spellId]),this.onResult,this.onComplete,onError);
      }
      
      override protected function onComplete(param1:Object = null) : void
      {
         this.championSelectionModel.spellsBusy = false;
         super.onComplete(param1);
      }
   }
}

