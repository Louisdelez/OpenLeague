package com.riotgames.platform.gameclient.domain.game
{
   public class GameNotificationType
   {
      
      public static const PLAYER_BANNED_FROM_GAME:String = "PLAYER_BANNED_FROM_GAME";
      
      public static const PLAYER_QUIT:String = "PLAYER_QUIT";
      
      public static const TEAM_REMOVED:String = "TEAM_REMOVED";
      
      public static const PLAYER_REMOVED:String = "PLAYER_REMOVED";
      
      public function GameNotificationType()
      {
         super();
         throw new Error("Cannot create an instance of this class.");
      }
   }
}

