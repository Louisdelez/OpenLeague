package com.riotgames.platform.gameclient.domain.game.practice
{
   public class Team
   {
      
      public static const TEAM_BLUE:String = "blue";
      
      public static const TEAM_PURPLE:String = "purple";
      
      public static const SPECTATOR:String = "spectator";
      
      public static const MAX_PLAYERS_PER_TEAM:int = 6;
      
      public static const TEAM_ID_BLUE:int = 100;
      
      public static const TEAM_ID_PURPLE:int = 200;
      
      public function Team()
      {
         super();
      }
      
      public static function isBlueTeam(param1:int) : Boolean
      {
         if(param1 == TEAM_ID_BLUE)
         {
            return true;
         }
         return false;
      }
      
      public static function getBotTeamId(param1:String) : int
      {
         return param1 == Team.TEAM_BLUE ? int(Team.TEAM_ID_BLUE) : int(Team.TEAM_ID_PURPLE);
      }
      
      public static function isPurpleTeam(param1:int) : Boolean
      {
         if(param1 == TEAM_ID_PURPLE)
         {
            return true;
         }
         return false;
      }
   }
}

