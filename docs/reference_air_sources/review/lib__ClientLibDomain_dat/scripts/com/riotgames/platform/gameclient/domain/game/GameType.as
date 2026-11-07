package com.riotgames.platform.gameclient.domain.game
{
   public class GameType
   {
      
      public static const TUTORIAL_GAME:String = "TUTORIAL_GAME";
      
      public static const PRACTICE_GAME:String = "PRACTICE_GAME";
      
      public static const NORMAL_GAME:String = "NORMAL_GAME";
      
      public static const RANKED_GAME:String = "RANKED_GAME";
      
      public static const RANKED_TEAM_GAME:String = "RANKED_TEAM_GAME";
      
      public static const RANKED_GAME_SOLO:String = "RANKED_GAME_SOLO";
      
      public static const RANKED_GAME_PREMADE:String = "RANKED_GAME_PREMADE";
      
      public static const COOP_VS_AI:String = "COOP_VS_AI_GAME";
      
      public static const CUSTOM_GAME:String = "CUSTOM_GAME";
      
      public function GameType()
      {
         super();
      }
      
      public static function IsTutorial(param1:String) : Boolean
      {
         return param1 == TUTORIAL_GAME;
      }
      
      public static function isRanked(param1:String) : Boolean
      {
         return param1 == RANKED_GAME || param1 == RANKED_TEAM_GAME || param1 == RANKED_GAME_SOLO || param1 == RANKED_GAME_PREMADE;
      }
   }
}

