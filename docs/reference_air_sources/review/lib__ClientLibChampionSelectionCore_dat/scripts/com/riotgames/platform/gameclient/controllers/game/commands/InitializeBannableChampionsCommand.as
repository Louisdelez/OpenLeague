package com.riotgames.platform.gameclient.controllers.game.commands
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.common.commands.ICommand;
   import com.riotgames.platform.gameclient.controllers.game.builders.IChampionSelectionCommandFactory;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.domain.ChampionBanInfoDTO;
   import com.riotgames.platform.gameclient.domain.game.ParticipantChampionSelection;
   import com.riotgames.platform.gameclient.services.GameService;
   import com.riotgames.pvpnet.system.alerter.IAlerterProvider;
   import mx.collections.ArrayCollection;
   
   public class InitializeBannableChampionsCommand extends CommandBase
   {
      
      private static const BAN_WAIT_STRING:String = "serverWait_banChampion";
      
      private var gameService:GameService;
      
      private var championSelectionModel:ChampionSelectionModel;
      
      private var alerter:IAlerterProvider;
      
      private var commandFactory:IChampionSelectionCommandFactory;
      
      public function InitializeBannableChampionsCommand(param1:ChampionSelectionModel, param2:GameService, param3:IAlerterProvider, param4:IChampionSelectionCommandFactory)
      {
         super();
         this.gameService = param2;
         this.alerter = param3;
         this.championSelectionModel = param1;
         this.commandFactory = param4;
      }
      
      private function initializeAllBannableChampions(param1:ArrayCollection) : void
      {
         var _loc2_:ChampionBanInfoDTO = null;
         var _loc3_:ParticipantChampionSelection = null;
         for each(_loc2_ in param1)
         {
            _loc3_ = this.championSelectionModel.championSelections.getSelectionByChampionId(_loc2_.championId);
            if(Boolean(_loc3_))
            {
               _loc3_.ownedByYourTeam = _loc2_.owned;
               _loc3_.ownedByEnemyTeam = _loc2_.enemyOwned;
            }
         }
         this.championSelectionModel.championSelections.refresh();
         onComplete();
      }
      
      override protected function onResult(param1:Object = null) : void
      {
         this.initializeAllBannableChampions(param1 as ArrayCollection);
         super.onResult(param1);
      }
      
      private function getChampionsForBan() : void
      {
         var _loc1_:ICommand = this.commandFactory.getGetBannableChampionsCommand();
         _loc1_.addResponder(this.onResult);
         _loc1_.execute();
      }
      
      override public function execute() : void
      {
         super.execute();
         this.getChampionsForBan();
      }
   }
}

