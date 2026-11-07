package com.riotgames.platform.gameclient.module.services.lcds
{
   import com.riotgames.platform.common.exception.PlatformException;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamId;
   import com.riotgames.platform.gameclient.exception.GameException;
   import com.riotgames.platform.gameclient.services.TeamService;
   import flash.utils.Dictionary;
   
   public class TeamServiceImpl extends BaseLcdsService implements TeamService
   {
      
      public function TeamServiceImpl()
      {
         super();
      }
      
      public function ownerLeaveTeam(param1:Number, param2:TeamId, param3:Function, param4:Function, param5:Function) : void
      {
         invokeServiceWithoutSession("summonerTeamService","leaveTeam",[param1,param2],param3,param4,this.getErrorMap(param5));
      }
      
      public function findOrCreateLocalPlayer(param1:Function, param2:Function, param3:Function) : void
      {
         invokeServiceWithoutSession("summonerTeamService","createPlayer",[],param1,param2,this.getErrorMap(param3));
      }
      
      public function invitePlayer(param1:Number, param2:TeamId, param3:Function, param4:Function, param5:Function) : void
      {
         invokeServiceWithoutSession("summonerTeamService","invitePlayer",[param1,param2],param3,param4,this.getErrorMap(param5));
      }
      
      public function kickPlayer(param1:Number, param2:TeamId, param3:Function, param4:Function, param5:Function) : void
      {
         invokeServiceWithoutSession("summonerTeamService","kickPlayer",[param1,param2],param3,param4,this.getErrorMap(param5));
      }
      
      public function disbandTeam(param1:TeamId, param2:Function, param3:Function, param4:Function) : void
      {
         invokeServiceWithoutSession("summonerTeamService","disbandTeam",[param1],param2,param3,this.getErrorMap(param4));
      }
      
      public function findTeamByName(param1:String, param2:Function, param3:Function, param4:Function) : void
      {
         invokeServiceWithoutSession("summonerTeamService","findTeamByName",[param1],param2,param3,this.getErrorMap(param4));
      }
      
      public function createTeam(param1:String, param2:String, param3:Function, param4:Function, param5:Function) : void
      {
         invokeServiceWithoutSession("summonerTeamService","createTeam",[param1,param2],param3,param4,this.getErrorMap(param5));
      }
      
      public function isTagValidAndAvailable(param1:String, param2:Function, param3:Function, param4:Function) : void
      {
         invokeServiceWithoutSession("summonerTeamService","isTagValidAndAvailable",[param1],param2,param3,this.getErrorMap(param4));
      }
      
      public function declineInvite(param1:TeamId, param2:Function, param3:Function, param4:Function) : void
      {
         invokeServiceWithoutSession("summonerTeamService","declineInvite",[param1],param2,param3,this.getErrorMap(param4));
      }
      
      public function joinTeam(param1:TeamId, param2:Function, param3:Function, param4:Function) : void
      {
         invokeServiceWithoutSession("summonerTeamService","joinTeam",[param1],param2,param3,this.getErrorMap(param4));
      }
      
      public function changeOwner(param1:Number, param2:TeamId, param3:Function, param4:Function, param5:Function) : void
      {
         invokeServiceWithoutSession("summonerTeamService","changeOwner",[param1,param2],param3,param4,this.getErrorMap(param5));
      }
      
      public function findTeamByTag(param1:String, param2:Function, param3:Function, param4:Function) : void
      {
         invokeServiceWithoutSession("summonerTeamService","findTeamByTag",[param1],param2,param3,this.getErrorMap(param4));
      }
      
      public function findTeamById(param1:TeamId, param2:Function, param3:Function, param4:Function) : void
      {
         invokeServiceWithoutSession("summonerTeamService","findTeamById",[param1],param2,param3,this.getErrorMap(param4));
      }
      
      private function getErrorMap(param1:Function) : Dictionary
      {
         var _loc2_:Dictionary = new Dictionary();
         _loc2_[GameException] = param1;
         _loc2_[PlatformException] = param1;
         return _loc2_;
      }
      
      public function isNameValidAndAvailable(param1:String, param2:Function, param3:Function, param4:Function) : void
      {
         invokeServiceWithoutSession("summonerTeamService","isNameValidAndAvailable",[param1],param2,param3,this.getErrorMap(param4));
      }
      
      public function leaveTeam(param1:TeamId, param2:Function, param3:Function, param4:Function) : void
      {
         invokeServiceWithoutSession("summonerTeamService","leaveTeam",[param1],param2,param3,this.getErrorMap(param4));
      }
      
      public function findPlayer(param1:Number, param2:Function, param3:Function, param4:Function) : void
      {
         invokeServiceWithoutSession("summonerTeamService","findPlayer",[param1],param2,param3,this.getErrorMap(param4));
      }
   }
}

