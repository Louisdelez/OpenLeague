package com.riotgames.platform.common.services
{
   public interface GameInviteService
   {
      
      function getPendingInvitations(param1:Function, param2:Function, param3:Function) : void;
      
      function transferOwnership(param1:Number, param2:Function, param3:Function, param4:Function) : void;
      
      function createArrangedTeamLobby(param1:Number, param2:Function, param3:Function, param4:Function) : void;
      
      function kick(param1:Number, param2:Function, param3:Function, param4:Function) : void;
      
      function grantInvitePrivileges(param1:Number, param2:Function, param3:Function, param4:Function) : void;
      
      function accept(param1:String, param2:Function, param3:Function, param4:Function) : void;
      
      function invite(param1:Number, param2:String, param3:String, param4:Function, param5:Function, param6:Function) : void;
      
      function destroyGroupFinderLobby(param1:Function, param2:Function, param3:Function) : void;
      
      function createArrangedBotTeamLobby(param1:Number, param2:String, param3:Function, param4:Function, param5:Function) : void;
      
      function checkLobbyStatus(param1:Function, param2:Function, param3:Function) : void;
      
      function revokeInvitePrivileges(param1:Number, param2:Function, param3:Function, param4:Function) : void;
      
      function getLobbyStatus(param1:Function, param2:Function, param3:Function) : void;
      
      function createGroupFinderLobby(param1:Number, param2:String, param3:Function, param4:Function, param5:Function) : void;
      
      function decline(param1:String, param2:Function, param3:Function, param4:Function) : void;
      
      function leave(param1:Function, param2:Function, param3:Function) : void;
      
      function busy(param1:String, param2:Function, param3:Function, param4:Function) : void;
      
      function createArrangedRankedTeamLobby(param1:Number, param2:String, param3:Function, param4:Function, param5:Function) : void;
      
      function inviteBulk(param1:Array, param2:String, param3:Function, param4:Function, param5:Function) : void;
   }
}

