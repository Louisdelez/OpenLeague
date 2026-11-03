package com.riotgames.pvpnet.game
{
   import com.riotgames.platform.gameclient.chat.controllers.PresenceController;
   import com.riotgames.platform.gameclient.controllers.game.GlowComponentController;
   import com.riotgames.platform.provider.IProvider;
   import com.riotgames.pvpnet.game.controllers.EndOfGameStatsController;
   import com.riotgames.pvpnet.game.controllers.InGameController;
   import com.riotgames.pvpnet.game.controllers.LCDSHeartBeatController;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.game.controllers.MasterGameViewController;
   import com.riotgames.pvpnet.game.controllers.SpectatorController;
   import com.riotgames.pvpnet.game.controllers.TeamSelectionController;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.game.controllers.practice.CreatePracticeGameController;
   import com.riotgames.pvpnet.game.controllers.practice.JoinGameController;
   import com.riotgames.pvpnet.game.controllers.tutorial.CreateTutorialGameController;
   import com.riotgames.pvpnet.game.domain.EnterChampionSelectManager;
   import com.riotgames.pvpnet.game.domain.GameQueueManager;
   
   public interface IGameLoopProvider extends IProvider
   {
      
      function get createPracticeGameController() : CreatePracticeGameController;
      
      function get createTutorialGameController() : CreateTutorialGameController;
      
      function get endOfGameStatsController() : EndOfGameStatsController;
      
      function get enterChampionSelectManager() : EnterChampionSelectManager;
      
      function get gameQueueManager() : GameQueueManager;
      
      function get inGameController() : InGameController;
      
      function get joinGameController() : JoinGameController;
      
      function get lcdsHeartBeatController() : LCDSHeartBeatController;
      
      function get masterGameController() : MasterGameController;
      
      function get masterGameViewController() : MasterGameViewController;
      
      function get spectatorController() : SpectatorController;
      
      function get teamSelectionController() : TeamSelectionController;
      
      function set lobbyController(param1:ILobbyViewController) : void;
      
      function get lobbyController() : ILobbyViewController;
      
      function get glowComponentController() : GlowComponentController;
      
      function get presenceController() : PresenceController;
   }
}

