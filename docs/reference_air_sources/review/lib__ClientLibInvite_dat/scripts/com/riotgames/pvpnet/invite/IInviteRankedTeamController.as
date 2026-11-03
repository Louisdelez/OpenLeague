package com.riotgames.pvpnet.invite
{
   import com.riotgames.platform.gameclient.domain.rankedTeams.Player;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamId;
   
   public interface IInviteRankedTeamController
   {
      
      function get numTeams() : int;
      
      function isPlayerGuest(param1:Number) : Boolean;
      
      function get teamPlayer() : Player;
      
      function findTeamById(param1:TeamId, param2:Function) : void;
   }
}

