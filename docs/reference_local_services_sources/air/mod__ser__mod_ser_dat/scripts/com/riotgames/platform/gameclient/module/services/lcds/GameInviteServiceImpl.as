package com.riotgames.platform.gameclient.module.services.lcds
{
   import com.riotgames.platform.common.error.invite.AlreadyMemberOfInvitationLobbyException;
   import com.riotgames.platform.common.error.invite.ExceededInviteBulkMaxSizeException;
   import com.riotgames.platform.common.error.invite.IncorrectLobbyStateException;
   import com.riotgames.platform.common.error.invite.LobbyClosedException;
   import com.riotgames.platform.common.error.invite.LobbyCreationNotEnabledException;
   import com.riotgames.platform.common.error.invite.LobbyFullException;
   import com.riotgames.platform.common.error.invite.NoInvitePrivilegesException;
   import com.riotgames.platform.common.error.invite.NotAMemberOfInvitationLobbyException;
   import com.riotgames.platform.common.error.invite.NotInvitableException;
   import com.riotgames.platform.common.error.invite.PlayerDoesNotExistException;
   import com.riotgames.platform.common.error.invite.PlayerInGameException;
   import com.riotgames.platform.common.error.invite.ServiceNotAvailableException;
   import com.riotgames.platform.common.error.invite.UserBannedException;
   import com.riotgames.platform.common.services.GameInviteService;
   import flash.utils.Dictionary;
   
   public class GameInviteServiceImpl extends BaseLcdsService implements GameInviteService
   {
      
      public function GameInviteServiceImpl()
      {
         super();
      }
      
      public function getLobbyStatus(param1:Function, param2:Function, param3:Function) : void
      {
         var _loc4_:Dictionary = new Dictionary();
         if(param3 != null)
         {
            _loc4_[NotAMemberOfInvitationLobbyException] = param3;
            _loc4_[ServiceNotAvailableException] = param3;
         }
         invokeServiceWithoutSession("lcdsGameInvitationService","getLobbyStatus",[],param1,param2,_loc4_);
      }
      
      public function inviteBulk(param1:Array, param2:String, param3:Function, param4:Function, param5:Function) : void
      {
         var _loc6_:Dictionary = new Dictionary();
         if(param5 != null)
         {
            _loc6_[NoInvitePrivilegesException] = param5;
            _loc6_[PlayerInGameException] = param5;
            _loc6_[NotAMemberOfInvitationLobbyException] = param5;
            _loc6_[NotInvitableException] = param5;
            _loc6_[ServiceNotAvailableException] = param5;
            _loc6_[UserBannedException] = param5;
            _loc6_[ExceededInviteBulkMaxSizeException] = param5;
         }
         invokeServiceWithoutSession("lcdsGameInvitationService","inviteBulk",[param1,param2],param3,param4,_loc6_);
      }
      
      public function transferOwnership(param1:Number, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:Dictionary = new Dictionary();
         if(param4 != null)
         {
            _loc5_[IncorrectLobbyStateException] = param4;
            _loc5_[ServiceNotAvailableException] = param4;
         }
         invokeServiceWithoutSession("lcdsGameInvitationService","transferOwnership",[param1],param2,param3,_loc5_);
      }
      
      public function createArrangedTeamLobby(param1:Number, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:Dictionary = new Dictionary();
         if(param4 != null)
         {
            _loc5_[AlreadyMemberOfInvitationLobbyException] = param4;
            _loc5_[LobbyCreationNotEnabledException] = param4;
            _loc5_[ServiceNotAvailableException] = param4;
         }
         invokeServiceWithoutSession("lcdsGameInvitationService","createArrangedTeamLobby",[param1],param2,param3,_loc5_);
      }
      
      public function kick(param1:Number, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:Dictionary = new Dictionary();
         if(param4 != null)
         {
            _loc5_[ServiceNotAvailableException] = param4;
         }
         invokeServiceWithoutSession("lcdsGameInvitationService","kick",[param1],param2,param3,_loc5_);
      }
      
      public function accept(param1:String, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:Dictionary = new Dictionary();
         if(param4 != null)
         {
            _loc5_[PlayerDoesNotExistException] = param4;
            _loc5_[PlayerInGameException] = param4;
            _loc5_[AlreadyMemberOfInvitationLobbyException] = param4;
            _loc5_[ServiceNotAvailableException] = param4;
            _loc5_[IncorrectLobbyStateException] = param4;
            _loc5_[LobbyFullException] = param4;
            _loc5_[LobbyClosedException] = param4;
         }
         invokeServiceWithoutSession("lcdsGameInvitationService","accept",[param1],param2,param3,_loc5_);
      }
      
      public function grantInvitePrivileges(param1:Number, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:Dictionary = new Dictionary();
         if(param4 != null)
         {
            _loc5_[NotAMemberOfInvitationLobbyException] = param4;
            _loc5_[IncorrectLobbyStateException] = param4;
            _loc5_[ServiceNotAvailableException] = param4;
         }
         invokeServiceWithoutSession("lcdsGameInvitationService","grantInvitePrivileges",[param1],param2,param3,_loc5_);
      }
      
      public function invite(param1:Number, param2:String, param3:String, param4:Function, param5:Function, param6:Function) : void
      {
         var _loc7_:Dictionary = new Dictionary();
         if(param6 != null)
         {
            _loc7_[NoInvitePrivilegesException] = param6;
            _loc7_[AlreadyMemberOfInvitationLobbyException] = param6;
            _loc7_[PlayerDoesNotExistException] = param6;
            _loc7_[PlayerInGameException] = param6;
            _loc7_[NotAMemberOfInvitationLobbyException] = param6;
            _loc7_[NotInvitableException] = param6;
            _loc7_[ServiceNotAvailableException] = param6;
            _loc7_[UserBannedException] = param6;
         }
         invokeServiceWithoutSession("lcdsGameInvitationService","invite",[param1,param2,param3],param4,param5,_loc7_);
      }
      
      public function busy(param1:String, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:Dictionary = new Dictionary();
         if(param4 != null)
         {
            _loc5_[PlayerDoesNotExistException] = param4;
            _loc5_[ServiceNotAvailableException] = param4;
         }
         invokeServiceWithoutSession("lcdsGameInvitationService","decline",[param1],param2,param3,_loc5_);
      }
      
      public function checkLobbyStatus(param1:Function, param2:Function, param3:Function) : void
      {
         var _loc4_:Dictionary = new Dictionary();
         if(param3 != null)
         {
            _loc4_[ServiceNotAvailableException] = param3;
         }
         invokeServiceWithoutSession("lcdsGameInvitationService","checkLobbyStatus",[],param1,param2,_loc4_);
      }
      
      public function getPendingInvitations(param1:Function, param2:Function, param3:Function) : void
      {
         var _loc4_:Dictionary = new Dictionary();
         if(param3 != null)
         {
            _loc4_[NotAMemberOfInvitationLobbyException] = param3;
            _loc4_[ServiceNotAvailableException] = param3;
         }
         invokeServiceWithoutSession("lcdsGameInvitationService","getPendingInvitations",[],param1,param2,_loc4_);
      }
      
      public function createArrangedBotTeamLobby(param1:Number, param2:String, param3:Function, param4:Function, param5:Function) : void
      {
         var _loc6_:Dictionary = new Dictionary();
         if(param5 != null)
         {
            _loc6_[AlreadyMemberOfInvitationLobbyException] = param5;
            _loc6_[LobbyCreationNotEnabledException] = param5;
            _loc6_[ServiceNotAvailableException] = param5;
         }
         invokeServiceWithoutSession("lcdsGameInvitationService","createArrangedBotTeamLobby",[param1,param2],param3,param4,_loc6_);
      }
      
      public function destroyGroupFinderLobby(param1:Function, param2:Function, param3:Function) : void
      {
         var _loc4_:Dictionary = new Dictionary();
         if(param3 != null)
         {
            _loc4_[AlreadyMemberOfInvitationLobbyException] = param3;
            _loc4_[ServiceNotAvailableException] = param3;
         }
         invokeServiceWithoutSession("lcdsGameInvitationService","destroyGroupFinderLobby",[],param1,param2,_loc4_);
      }
      
      public function createGroupFinderLobby(param1:Number, param2:String, param3:Function, param4:Function, param5:Function) : void
      {
         var _loc6_:Dictionary = new Dictionary();
         if(param5 != null)
         {
            _loc6_[AlreadyMemberOfInvitationLobbyException] = param5;
            _loc6_[LobbyCreationNotEnabledException] = param5;
            _loc6_[ServiceNotAvailableException] = param5;
         }
         invokeServiceWithoutSession("lcdsGameInvitationService","createGroupFinderLobby",[param1,param2],param3,param4,_loc6_);
      }
      
      public function decline(param1:String, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:Dictionary = new Dictionary();
         if(param4 != null)
         {
            _loc5_[PlayerDoesNotExistException] = param4;
            _loc5_[ServiceNotAvailableException] = param4;
            _loc5_[IncorrectLobbyStateException] = param4;
         }
         invokeServiceWithoutSession("lcdsGameInvitationService","decline",[param1],param2,param3,_loc5_);
      }
      
      public function leave(param1:Function, param2:Function, param3:Function) : void
      {
         var _loc4_:Dictionary = new Dictionary();
         if(param3 != null)
         {
            _loc4_[ServiceNotAvailableException] = param3;
         }
         invokeServiceWithoutSession("lcdsGameInvitationService","leave",[],param1,param2,_loc4_);
      }
      
      public function revokeInvitePrivileges(param1:Number, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:Dictionary = new Dictionary();
         if(param4 != null)
         {
            _loc5_[NotAMemberOfInvitationLobbyException] = param4;
            _loc5_[IncorrectLobbyStateException] = param4;
            _loc5_[ServiceNotAvailableException] = param4;
         }
         invokeServiceWithoutSession("lcdsGameInvitationService","revokeInvitePrivileges",[param1],param2,param3,_loc5_);
      }
      
      public function createArrangedRankedTeamLobby(param1:Number, param2:String, param3:Function, param4:Function, param5:Function) : void
      {
         var _loc6_:Dictionary = new Dictionary();
         if(param5 != null)
         {
            _loc6_[AlreadyMemberOfInvitationLobbyException] = param5;
            _loc6_[LobbyCreationNotEnabledException] = param5;
            _loc6_[ServiceNotAvailableException] = param5;
         }
         invokeServiceWithoutSession("lcdsGameInvitationService","createArrangedRankedTeamLobby",[param1,param2],param3,param4,_loc6_);
      }
   }
}

