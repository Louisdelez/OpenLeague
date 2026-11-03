package com.riotgames.platform.gameclient.controllers.game.commands
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.platform.gameclient.domain.game.GameMode;
   import com.riotgames.pvpnet.model.SpellSelection;
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.collections.SortField;
   
   public class CreateSpellSelectionsCommand extends CommandBase
   {
      
      private var championSelectionModel:ChampionSelectionModel;
      
      private var summonerLevel:Number;
      
      private var inventoryController:IInventoryController;
      
      private var gameMode:String;
      
      public function CreateSpellSelectionsCommand(param1:ChampionSelectionModel, param2:String, param3:Number, param4:IInventoryController)
      {
         super();
         this.championSelectionModel = param1;
         this.gameMode = param2;
         this.summonerLevel = param3;
         this.inventoryController = param4;
      }
      
      private function getGameModeString(param1:String, param2:GameMap) : String
      {
         if(!this.inventoryController.inventory.knownGameModesForSpells.contains(param1))
         {
            switch(param2.mapId)
            {
               case GameMap.CRYSTAL_SCAR_ID:
                  param1 = GameMode.DOMINION;
                  break;
               case GameMap.PROVING_GROUNDS_ARAM_ID:
                  param1 = GameMode.ARAM;
                  break;
               case GameMap.HOWLING_ABYSS:
                  param1 = GameMode.ARAM;
                  break;
               default:
                  param1 = GameMode.CLASSIC;
            }
         }
         return param1;
      }
      
      private function isEnabledForModeOrMap(param1:Spell, param2:String, param3:GameMap) : Boolean
      {
         param2 = this.getGameModeString(param2,param3);
         return param1.gameModes.contains(param2);
      }
      
      override public function execute() : void
      {
         super.execute();
         this.createSpellSelections(this.inventoryController.getActiveSpells());
         onComplete();
         onResult();
      }
      
      protected function createSpellSelections(param1:ArrayCollection) : void
      {
         var _loc4_:SpellSelection = null;
         var _loc5_:Spell = null;
         var _loc6_:SortField = null;
         var _loc7_:Sort = null;
         var _loc8_:String = null;
         var _loc9_:Boolean = false;
         var _loc2_:ArrayCollection = new ArrayCollection();
         var _loc3_:ArrayCollection = new ArrayCollection();
         for each(_loc5_ in param1)
         {
            if(Boolean(_loc5_.gameModes.contains(this.gameMode)) || this.isEnabledForModeOrMap(_loc5_,this.gameMode,this.championSelectionModel.gameMap))
            {
               _loc3_.addItem(_loc5_);
            }
         }
         for each(_loc5_ in _loc3_)
         {
            _loc8_ = this.getGameModeString(this.gameMode,this.championSelectionModel.gameMap);
            _loc9_ = false;
            if(_loc5_.minLevel <= this.summonerLevel && !this.inventoryController.isSpellDisabledForMode(_loc5_.spellId,_loc8_))
            {
               _loc9_ = true;
            }
            _loc4_ = new SpellSelection(_loc5_,_loc9_,false);
            _loc2_.addItem(_loc4_);
         }
         _loc6_ = new SortField();
         _loc7_ = new Sort();
         _loc6_.name = "minLevel";
         _loc6_.numeric = true;
         _loc7_.fields = [_loc6_];
         _loc2_.sort = _loc7_;
         _loc2_.refresh();
         RiotResourceLoader.loadSpellResourceStrings(_loc3_);
         this.championSelectionModel.allSpells = _loc2_;
      }
   }
}

