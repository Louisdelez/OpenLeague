package com.riotgames.pvpnet.rankedteams
{
   import com.riotgames.platform.gameclient.domain.rankedTeams.Player;
   import flash.events.Event;
   
   public class RankedTeamEvent extends Event
   {
      
      public static const UPDATE_PLAYER:String = "UPDATE_PLAYER";
      
      public static const REQUEST_ADD_FRIEND:String = "REQUEST_ADD_FRIEND";
      
      public static const REQUEST_VIEW_PROFILE:String = "REQUEST_VIEW_PROFILE";
      
      public static const REQUEST_RETURN_TO_MATCH_DETAILS:String = "REQUEST_RETURN_TO_MATCH_DETAILS";
      
      public var teamPlayer:Player = null;
      
      public var summonerName:String;
      
      public function RankedTeamEvent(param1:String, param2:Player, param3:String = null)
      {
         this.teamPlayer = param2;
         this.summonerName = param3;
         super(param1);
      }
   }
}

