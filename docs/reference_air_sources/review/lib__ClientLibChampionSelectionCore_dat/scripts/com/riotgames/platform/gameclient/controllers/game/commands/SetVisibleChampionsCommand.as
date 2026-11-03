package com.riotgames.platform.gameclient.controllers.game.commands
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.controllers.game.model.ParticipantChampionListView;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import com.riotgames.platform.gameclient.domain.game.GameState;
   
   public class SetVisibleChampionsCommand extends CommandBase
   {
      
      private var _gameState:String;
      
      private var _championSelectionModel:ChampionSelectionModel;
      
      private var _isTutorial:Boolean = false;
      
      private var _isRanked:Boolean = false;
      
      private var _isSpectating:Boolean = false;
      
      public function SetVisibleChampionsCommand(param1:ChampionSelectionModel, param2:String, param3:Boolean, param4:Boolean, param5:Boolean)
      {
         super();
         this._championSelectionModel = param1;
         this._isSpectating = param3;
         this._gameState = param2;
         this._isTutorial = param4;
         this._isRanked = param5;
      }
      
      private function setChampionsForBan() : void
      {
         var _loc2_:Boolean = false;
         var _loc1_:ParticipantChampionListView = this._championSelectionModel.championSelections;
         if(this._isSpectating)
         {
            _loc1_.ownedByEnemyTeam = false;
            _loc1_.ownedByMyTeam = false;
            _loc1_.ownedByEitherTeam = false;
            _loc1_.owned = true;
            _loc1_.notOwned = true;
            _loc1_.showRandom = false;
            _loc1_.available = false;
         }
         else
         {
            _loc1_.owned = true;
            _loc1_.notOwned = true;
            _loc1_.showRandom = false;
            _loc1_.available = false;
            if(this._championSelectionModel.gameTypeConfig != null && Boolean(this._championSelectionModel.gameTypeConfig.crossTeamChampionPool))
            {
               _loc1_.ownedByEnemyTeam = false;
               _loc1_.ownedByMyTeam = false;
               _loc1_.ownedByEitherTeam = true;
            }
            else
            {
               _loc2_ = this.getIsMyTeamBanning();
               _loc1_.ownedByEnemyTeam = _loc2_;
               _loc1_.ownedByMyTeam = !_loc2_;
               _loc1_.ownedByEitherTeam = false;
            }
         }
      }
      
      private function setChampions() : void
      {
         if(this._gameState == GameState.PRE_CHAMPION_SELECTION)
         {
            this.setChampionsForBan();
         }
         else
         {
            this.setChampionsForSelect();
         }
         this._championSelectionModel.championSelections.refresh();
      }
      
      private function getIsMyTeamBanning() : Boolean
      {
         var _loc1_:GameParticipant = null;
         for each(_loc1_ in this._championSelectionModel.currentTeam)
         {
            if(_loc1_.pickMode == GameParticipant.PICK_MODE_ACTIVE)
            {
               return true;
            }
         }
         return false;
      }
      
      override public function execute() : void
      {
         super.execute();
         this.setChampions();
         onResult(null);
      }
      
      private function setChampionsForSelect() : void
      {
         var _loc1_:ParticipantChampionListView = this._championSelectionModel.championSelections;
         if(this._isSpectating)
         {
            _loc1_.ownedByEnemyTeam = false;
            _loc1_.ownedByMyTeam = false;
            _loc1_.ownedByEitherTeam = false;
            _loc1_.owned = true;
            _loc1_.notOwned = true;
            _loc1_.showRandom = false;
            _loc1_.available = false;
         }
         else if(this._isTutorial)
         {
            _loc1_.ownedByEnemyTeam = false;
            _loc1_.ownedByMyTeam = false;
            _loc1_.ownedByEitherTeam = false;
            _loc1_.owned = true;
            _loc1_.notOwned = true;
            _loc1_.showRandom = false;
            _loc1_.available = false;
         }
         else if(this._championSelectionModel.gameTypeConfig != null && Boolean(this._championSelectionModel.gameTypeConfig.teamChampionPool))
         {
            _loc1_.ownedByEnemyTeam = false;
            _loc1_.ownedByMyTeam = true;
            _loc1_.ownedByEitherTeam = false;
            _loc1_.owned = true;
            _loc1_.notOwned = true;
            _loc1_.showRandom = true;
            _loc1_.available = false;
         }
         else if(this._championSelectionModel.gameTypeConfig != null && Boolean(this._championSelectionModel.gameTypeConfig.crossTeamChampionPool))
         {
            _loc1_.ownedByEnemyTeam = false;
            _loc1_.ownedByMyTeam = false;
            _loc1_.ownedByEitherTeam = true;
            _loc1_.owned = true;
            _loc1_.notOwned = true;
            _loc1_.showRandom = true;
            _loc1_.available = false;
         }
         else if(this._championSelectionModel.allChampionsPlayable)
         {
            _loc1_.ownedByEnemyTeam = false;
            _loc1_.ownedByMyTeam = false;
            _loc1_.ownedByEitherTeam = false;
            _loc1_.owned = true;
            _loc1_.notOwned = true;
            _loc1_.showRandom = false;
            _loc1_.available = false;
         }
         else
         {
            _loc1_.ownedByEnemyTeam = false;
            _loc1_.ownedByMyTeam = false;
            _loc1_.ownedByEitherTeam = false;
            _loc1_.owned = true;
            _loc1_.notOwned = true;
            _loc1_.showRandom = !this._isRanked;
            _loc1_.available = true;
         }
      }
   }
}

