package com.riotgames.platform.gameclient.views.game.common.endofgame
{
   import com.riotgames.platform.gameclient.domain.EndOfGameStats;
   import com.riotgames.platform.gameclient.domain.game.GameViewState;
   import com.riotgames.platform.gameclient.domain.lobby.LobbyViewState;
   import com.riotgames.platform.gameclient.domain.rankedTeams.MatchHistorySummary;
   import com.riotgames.platform.gameclient.views.IEndOfGameScoreboardProvider;
   import com.riotgames.platform.gameclient.views.IScoreboard;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.game.controllers.EndOfGameStatsController;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.game.controllers.lobby.LobbyConfig;
   import com.riotgames.pvpnet.game.controllers.lobby.MatchMakingState;
   
   public class EndOfGameScoreboardProvider implements IEndOfGameScoreboardProvider
   {
      
      [Inject]
      public var masterGameController:MasterGameController;
      
      [Inject]
      public var lobbyController:ILobbyViewController;
      
      [Inject]
      public var endOfGameStatsController:EndOfGameStatsController;
      
      public function EndOfGameScoreboardProvider()
      {
         super();
      }
      
      public function getScoreboardForStats(param1:EndOfGameStats, param2:MatchHistorySummary, param3:Boolean) : IScoreboard
      {
         this.endOfGameStatsController.reviewEndOfGameStats(param1,param2,null,null,param3);
         return new EndOfGameScoreboard();
      }
      
      public function navigateToEndOfGameScreen(param1:EndOfGameStats, param2:MatchHistorySummary, param3:String, param4:Function, param5:Boolean) : void
      {
         if(this.isGameNavigationAllowed())
         {
            this.lobbyController.requestLobbyState(LobbyViewState.PLAY_GAME_STATE);
            this.masterGameController.currentState = GameViewState.GAME_OVER;
            this.endOfGameStatsController.reviewEndOfGameStats(param1,param2,param3,param4,param5);
         }
      }
      
      public function navigateToFakeEndOfGameScreen(param1:String = "CLASSIC", param2:Boolean = true, param3:Boolean = true, param4:Boolean = false, param5:Boolean = false) : void
      {
         this.lobbyController.requestLobbyState(LobbyViewState.PLAY_GAME_STATE);
         this.masterGameController.createTutorialGameController.chooseTutorialType(false);
         this.masterGameController.currentState = GameViewState.GAME_OVER;
         this.endOfGameStatsController.initializeHardcodedEndOfGame(param1,param2,null,param3,param4,param5);
      }
      
      [PostConstruct]
      public function postConstruct() : void
      {
         ProviderLookup.publishProvider(IEndOfGameScoreboardProvider,this);
      }
      
      public function isGameNavigationAllowed() : Boolean
      {
         return LobbyConfig.instance.matchmakingState == MatchMakingState.MATCHMAKING_NOT_PARTICIPATING;
      }
   }
}

