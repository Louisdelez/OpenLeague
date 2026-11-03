package com.riotgames.platform.gameclient.domain.game
{
   public class GameState
   {
      
      public static const TEAM_SELECTION:String = "TEAM_SELECT";
      
      public static const PRE_CHAMPION_SELECTION:String = "PRE_CHAMP_SELECT";
      
      public static const CHAMPION_SELECTION:String = "CHAMP_SELECT";
      
      public static const POST_CHAMPION_SELECTION:String = "POST_CHAMP_SELECT";
      
      public static const START_REQUESTED:String = "START_REQUESTED";
      
      public static const IN_PROGRESS:String = "IN_PROGRESS";
      
      public static const TERMINATED:String = "TERMINATED";
      
      public static const TERMINATED_IN_ERROR:String = "TERMINATED_IN_ERROR";
      
      public static const FAILED_TO_START:String = "FAILED_TO_START";
      
      public static const JOINING_CHAMP_SELECT:String = "JOINING_CHAMP_SELECT";
      
      public static const CHAMP_SELECT_AFK_CLEANUP:String = "CHAMP_SELECT_AFK_CLEANUP";
      
      public function GameState()
      {
         super();
         throw new Error("Cannot create an instance of this class.");
      }
      
      public static function GameStateToGameViewState(param1:String) : String
      {
         if(isInChampionSelectionState(param1))
         {
            return GameViewState.CHAMPION_SELECTION;
         }
         return param1;
      }
      
      public static function isAfterChampionSelectionState(param1:String) : Boolean
      {
         return param1 == GameState.START_REQUESTED || param1 == GameState.IN_PROGRESS;
      }
      
      public static function isInChampionSelectionState(param1:String) : Boolean
      {
         return param1 == GameState.PRE_CHAMPION_SELECTION || param1 == GameState.CHAMPION_SELECTION || param1 == GameState.POST_CHAMPION_SELECTION;
      }
   }
}

