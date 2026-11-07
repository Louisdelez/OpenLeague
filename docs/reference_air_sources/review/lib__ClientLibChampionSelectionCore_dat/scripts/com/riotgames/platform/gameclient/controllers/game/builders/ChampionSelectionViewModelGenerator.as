package com.riotgames.platform.gameclient.controllers.game.builders
{
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.gameclient.Models.SearchTagData;
   import com.riotgames.platform.gameclient.championselection.GameSelectionData;
   import com.riotgames.platform.gameclient.controllers.game.enums.MenuStates;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.controllers.game.model.ParticipantChampionListView;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import com.riotgames.platform.gameclient.domain.IChampionFilter;
   import com.riotgames.platform.gameclient.domain.SpellBookDTO;
   import com.riotgames.platform.gameclient.domain.game.GameMutator;
   import com.riotgames.platform.gameclient.domain.game.GameType;
   
   public class ChampionSelectionViewModelGenerator
   {
      
      public function ChampionSelectionViewModelGenerator()
      {
         super();
      }
      
      public static function generateChampionSelectionViewModel(param1:GameSelectionData, param2:Array, param3:SpellBookDTO, param4:IInventoryController) : ChampionSelectionModel
      {
         var _loc8_:SearchTagData = null;
         var _loc5_:ChampionSelectionModel = new ChampionSelectionModel();
         _loc5_.isSpectating = param1.isSpectating;
         _loc5_.currentGame = param1.game;
         _loc5_.gameTypeConfig = param1.gameTypeConfig;
         _loc5_.runeBook = param3;
         _loc5_.runePageSynced = true;
         _loc5_.allowFreeChampions = param1.allowFreeChampions;
         var _loc6_:Array = param4.createSearchTags();
         if(Boolean(_loc6_))
         {
            for each(_loc8_ in _loc6_)
            {
               _loc8_.enabled = true;
            }
         }
         var _loc7_:IChampionFilter = param4.createChampionFilter(_loc6_);
         _loc5_.championSelections = new ParticipantChampionListView(_loc5_.gameTypeConfig,_loc5_.allowFreeChampions,_loc7_,param2);
         _loc5_.allowReroll = GameMutator.hasMutator(param1.game.gameMutators,GameMutator.REROLL);
         if(_loc5_.currentPickMode == GameParticipant.PICK_MODE_ACTIVE)
         {
            _loc5_.mainMenuState = MenuStates.MAIN_MENU_STATE_CHAMPS_ACTIVE;
            _loc5_.lockInState = MenuStates.SMALL_MENU_STATE_ACTIVE;
         }
         else
         {
            _loc5_.mainMenuState = MenuStates.MAIN_MENU_STATE_CHAMPS_INACTIVE;
            _loc5_.lockInState = MenuStates.SMALL_MENU_STATE_INACTIVE;
         }
         if(Boolean(_loc5_.currentGame) && _loc5_.currentGame.gameType == GameType.TUTORIAL_GAME)
         {
            _loc5_.allowChampionSerching = false;
         }
         else
         {
            _loc5_.allowChampionSerching = true;
            if(Boolean(_loc5_.gameTypeConfig))
            {
               _loc5_.enemyTeamVisible = true;
               _loc5_.progressBarVisible = _loc5_.gameTypeConfig.maxAllowableBans > 0;
            }
            else
            {
               _loc5_.enemyTeamVisible = false;
               _loc5_.progressBarVisible = false;
            }
         }
         _loc5_.gameMap = param1.gameMap;
         return _loc5_;
      }
   }
}

