package com.riotgames.platform.gameclient.services
{
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamId;
   
   public interface TeamService
   {
      
      function disbandTeam(param1:TeamId, param2:Function, param3:Function, param4:Function) : void;
      
      function ownerLeaveTeam(param1:Number, param2:TeamId, param3:Function, param4:Function, param5:Function) : void;
      
      function changeOwner(param1:Number, param2:TeamId, param3:Function, param4:Function, param5:Function) : void;
      
      function joinTeam(param1:TeamId, param2:Function, param3:Function, param4:Function) : void;
      
      function findTeamById(param1:TeamId, param2:Function, param3:Function, param4:Function) : void;
      
      function invitePlayer(param1:Number, param2:TeamId, param3:Function, param4:Function, param5:Function) : void;
      
      function findTeamByTag(param1:String, param2:Function, param3:Function, param4:Function) : void;
      
      function kickPlayer(param1:Number, param2:TeamId, param3:Function, param4:Function, param5:Function) : void;
      
      function isNameValidAndAvailable(param1:String, param2:Function, param3:Function, param4:Function) : void;
      
      function findOrCreateLocalPlayer(param1:Function, param2:Function, param3:Function) : void;
      
      function findTeamByName(param1:String, param2:Function, param3:Function, param4:Function) : void;
      
      function createTeam(param1:String, param2:String, param3:Function, param4:Function, param5:Function) : void;
      
      function findPlayer(param1:Number, param2:Function, param3:Function, param4:Function) : void;
      
      function leaveTeam(param1:TeamId, param2:Function, param3:Function, param4:Function) : void;
      
      function isTagValidAndAvailable(param1:String, param2:Function, param3:Function, param4:Function) : void;
      
      function declineInvite(param1:TeamId, param2:Function, param3:Function, param4:Function) : void;
   }
}

