package com.riotgames.platform.gameclient.controllers.game.commands
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.gameclient.controllers.game.enums.MenuStates;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import com.riotgames.platform.gameclient.domain.game.GameState;
   import com.riotgames.platform.gameclient.domain.game.GameType;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfig;
   
   public class UpdateMenuStatesCommand extends CommandBase
   {
      
      private var championSelectionModel:ChampionSelectionModel;
      
      public function UpdateMenuStatesCommand(param1:ChampionSelectionModel)
      {
         super();
         this.championSelectionModel = param1;
      }
      
      override public function execute() : void
      {
         super.execute();
         this.updateMenuStates();
         onComplete();
         onResult();
      }
      
      private function updateMenuStates() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:GameDTO = this.championSelectionModel.currentGame;
         if(Boolean(this.championSelectionModel) && Boolean(this.championSelectionModel.currentPlayerParticipant) && this.championSelectionModel.currentPlayerParticipant.pickMode == GameParticipant.PICK_MODE_ACTIVE)
         {
            _loc1_ = true;
         }
         if(_loc1_ && _loc2_.gameType != GameType.TUTORIAL_GAME)
         {
            if(this.championSelectionModel.mainMenuState == MenuStates.MAIN_MENU_STATE_CHAMPS_INACTIVE)
            {
               this.championSelectionModel.mainMenuState = MenuStates.MAIN_MENU_STATE_CHAMPS_ACTIVE;
            }
            if(this.championSelectionModel.championSelectionState == GameState.CHAMPION_SELECTION)
            {
               this.championSelectionModel.lockInState = MenuStates.SMALL_MENU_STATE_ACTIVE;
            }
            else
            {
               this.championSelectionModel.lockInState = MenuStates.SMALL_MENU_STATE_INACTIVE;
            }
            this.championSelectionModel.spellsMenuState = MenuStates.SMALL_MENU_STATE_ACTIVE;
            this.championSelectionModel.masteriesMenuState = MenuStates.SMALL_MENU_STATE_ACTIVE;
         }
         else if(_loc2_.gameType != GameType.TUTORIAL_GAME)
         {
            if(this.championSelectionModel.gameTypeConfig.pickMode == GameTypeConfig.PICK_MODE_ALL_RANDOM || this.championSelectionModel.mainMenuState == MenuStates.MAIN_MENU_STATE_CHAMPS_ACTIVE && this.championSelectionModel.selectedChampion != null && !this.championSelectionModel.selectedChampion.champion.isRandomChampion() && !this.championSelectionModel.selectedChampion.champion.isWildCardChampion())
            {
               this.championSelectionModel.mainMenuState = MenuStates.MAIN_MENU_STATE_SKINS_ACTIVE;
            }
            this.championSelectionModel.lockInState = MenuStates.SMALL_MENU_STATE_INACTIVE;
            this.championSelectionModel.spellsMenuState = MenuStates.SMALL_MENU_STATE_ACTIVE;
            this.championSelectionModel.masteriesMenuState = MenuStates.SMALL_MENU_STATE_ACTIVE;
         }
         else
         {
            if(this.championSelectionModel.championsActive)
            {
               if(this.championSelectionModel.mainMenuState == MenuStates.MAIN_MENU_STATE_CHAMPS_INACTIVE)
               {
                  this.championSelectionModel.mainMenuState = MenuStates.MAIN_MENU_STATE_CHAMPS_ACTIVE;
               }
            }
            else
            {
               this.championSelectionModel.mainMenuState = MenuStates.MAIN_MENU_STATE_CHAMPS_INACTIVE;
            }
            if(this.championSelectionModel.spellsActive)
            {
               this.championSelectionModel.spellsMenuState = MenuStates.SMALL_MENU_STATE_ACTIVE;
            }
            else
            {
               this.championSelectionModel.spellsMenuState = MenuStates.SMALL_MENU_STATE_INACTIVE;
            }
            if(this.championSelectionModel.runesActive)
            {
               this.championSelectionModel.masteriesMenuState = MenuStates.SMALL_MENU_STATE_ACTIVE;
            }
            else
            {
               this.championSelectionModel.masteriesMenuState = MenuStates.SMALL_MENU_STATE_INACTIVE;
            }
            if(this.championSelectionModel.lockInActive)
            {
               this.championSelectionModel.lockInState = MenuStates.SMALL_MENU_STATE_ACTIVE;
            }
            else
            {
               this.championSelectionModel.lockInState = MenuStates.SMALL_MENU_STATE_INACTIVE;
            }
         }
      }
   }
}

