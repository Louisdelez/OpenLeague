package com.riotgames.pvpnet.invite.controller
{
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.platform.common.provider.IGameProvider;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.game.GameQueueConfig;
   import com.riotgames.platform.gameclient.domain.game.GameType;
   import com.riotgames.platform.gameclient.domain.game.QueueType;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfig;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfigManager;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamId;
   import com.riotgames.pvpnet.game.domain.GameQueueManager;
   
   public class InviteQueueManager
   {
      
      private var _gameProvider:IGameProvider;
      
      private var _gameQueueManager:GameQueueManager;
      
      private var _appController:IAppController;
      
      public function InviteQueueManager(param1:GameQueueManager, param2:IGameProvider, param3:IAppController)
      {
         super();
         this._gameQueueManager = param1;
         this._gameProvider = param2;
         this._appController = param3;
      }
      
      public function getGameDifficulty() : String
      {
         return this._gameProvider.gameModel.difficulty;
      }
      
      public function setRankedTeamId(param1:String) : void
      {
         if(Boolean(this._gameQueueManager.selectedGameQueueConfig) && Boolean(this._gameQueueManager.selectedGameQueueConfig.teamOnly))
         {
            this._gameQueueManager.rankedTeamId = TeamId.MakeTeamId(param1);
         }
      }
      
      public function getGameTypeConfig() : GameTypeConfig
      {
         if(this._gameProvider.currentGame)
         {
            return GameTypeConfigManager.instance.getGameTypeConfig(this._gameProvider.currentGame.gameTypeConfigId);
         }
         return null;
      }
      
      public function setGameMapById(param1:int) : void
      {
         if(Boolean(this._gameProvider) && Boolean(this._gameProvider.gameModel) && Boolean(this._appController))
         {
            this._gameProvider.gameModel.gameMap = this._appController.getGameMap(param1);
         }
      }
      
      public function getSelectedGameQueueConfigId() : int
      {
         if(this.getSelectedGameQueueConfig())
         {
            return this.getSelectedGameQueueConfig().id;
         }
         return -1;
      }
      
      public function isCoopVsAiGame() : Boolean
      {
         if(this.getSelectedGameQueueConfig())
         {
            return QueueType.isCoopVsAI(this.getSelectedGameQueueConfig().type);
         }
         return false;
      }
      
      public function setGameDifficulty(param1:String) : void
      {
         this._gameProvider.gameModel.difficulty = param1;
      }
      
      public function getSelectedGameQueueConfig() : GameQueueConfig
      {
         if(this._gameQueueManager)
         {
            return this._gameQueueManager.selectedGameQueueConfig;
         }
         return null;
      }
      
      public function get getGameQueueManager() : GameQueueManager
      {
         return this._gameQueueManager;
      }
      
      public function isRankedTeam() : Boolean
      {
         var _loc1_:GameQueueConfig = this.getSelectedGameQueueConfig();
         if(_loc1_)
         {
            return Boolean(_loc1_.ranked) && Boolean(_loc1_.teamOnly);
         }
         return false;
      }
      
      public function getCurrentGameState() : String
      {
         return this._gameProvider.currentState;
      }
      
      public function isRanked() : Boolean
      {
         if(this.getSelectedGameQueueConfig())
         {
            return this.getSelectedGameQueueConfig().ranked;
         }
         return false;
      }
      
      public function setSelectedGameQueueConfigById(param1:int) : void
      {
         if(Boolean(this._gameQueueManager) && !this._gameProvider.currentGame)
         {
            this._gameQueueManager.setSelectedQueueId(param1);
         }
         else if(this._gameProvider.currentGame)
         {
            trace("Game is a practice game, not setting queue");
         }
         else
         {
            trace("Critical error setting queue");
         }
         if(Boolean(this._gameProvider) && Boolean(this._gameProvider.gameModel))
         {
            this._gameProvider.gameModel.allowFreeChampions = !this._gameQueueManager.selectedGameQueueConfig.disallowFreeChampions;
         }
      }
      
      public function isPracticeGame() : Boolean
      {
         if(Boolean(this._gameProvider) && Boolean(this._gameProvider.gameModel))
         {
            return this._gameProvider.gameModel.gameType == GameType.PRACTICE_GAME || this._gameProvider.gameModel.gameType == GameType.CUSTOM_GAME;
         }
         return false;
      }
      
      public function setRankedTeamName(param1:String) : void
      {
         if(Boolean(this._gameQueueManager.selectedGameQueueConfig) && Boolean(this._gameQueueManager.selectedGameQueueConfig.teamOnly))
         {
            this._gameQueueManager.rankedTeamName = param1;
         }
      }
      
      public function isCapGame() : Boolean
      {
         if(this.getSelectedGameQueueConfig())
         {
            return this.getSelectedGameQueueConfig().isCap();
         }
         return false;
      }
      
      public function getCurrentGame() : GameDTO
      {
         return this._gameProvider.currentGame;
      }
      
      public function setGameType(param1:String) : void
      {
         if(Boolean(this._gameProvider) && Boolean(this._gameProvider.gameModel))
         {
            this._gameProvider.gameModel.gameType = param1;
         }
      }
   }
}

