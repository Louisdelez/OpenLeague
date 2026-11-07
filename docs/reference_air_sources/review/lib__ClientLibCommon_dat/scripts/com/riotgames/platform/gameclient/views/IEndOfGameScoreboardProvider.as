package com.riotgames.platform.gameclient.views
{
   import com.riotgames.platform.gameclient.domain.EndOfGameStats;
   import com.riotgames.platform.gameclient.domain.rankedTeams.MatchHistorySummary;
   import com.riotgames.platform.provider.IProvider;
   
   public interface IEndOfGameScoreboardProvider extends IProvider
   {
      
      function getScoreboardForStats(param1:EndOfGameStats, param2:MatchHistorySummary, param3:Boolean) : IScoreboard;
      
      function navigateToEndOfGameScreen(param1:EndOfGameStats, param2:MatchHistorySummary, param3:String, param4:Function, param5:Boolean) : void;
      
      function navigateToFakeEndOfGameScreen(param1:String = "CLASSIC", param2:Boolean = true, param3:Boolean = true, param4:Boolean = false, param5:Boolean = false) : void;
      
      function isGameNavigationAllowed() : Boolean;
   }
}

