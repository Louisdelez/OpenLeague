package com.riotgames.pvpnet.invite.action
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.error.invite.IncorrectLobbyStateException;
   import com.riotgames.platform.common.error.invite.NotAMemberOfInvitationLobbyException;
   import com.riotgames.platform.common.services.GameInviteService;
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipant;
   import com.riotgames.pvpnet.invite.PlatformInviteActionFactory;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import mx.rpc.events.ResultEvent;
   
   public class TransferOwnershipAction extends BasicAction implements IInviteParticipantAction
   {
      
      private var _gameInviteService:GameInviteService;
      
      private var _participant:InviteParticipant;
      
      private var _inviteActionFactory:PlatformInviteActionFactory;
      
      public function TransferOwnershipAction(param1:InviteParticipant, param2:GameInviteService, param3:PlatformInviteActionFactory)
      {
         super(false);
         this._participant = param1;
         this._gameInviteService = param2;
         this._inviteActionFactory = param3;
      }
      
      private function displayError(param1:ServerError) : void
      {
         var _loc3_:String = null;
         var _loc2_:String = this._inviteActionFactory.getResourceManagerString("invite_error_title");
         if(param1.exception is NotAMemberOfInvitationLobbyException)
         {
            _loc3_ = this._inviteActionFactory.getResourceManagerString("invite_not_member_of_lobby_exception",[this._participant.name]);
         }
         else if(param1.exception is IncorrectLobbyStateException)
         {
            _loc3_ = this._inviteActionFactory.getResourceManagerString("invite_lobby_state_invalid_exception",[this._participant.name]);
         }
         else
         {
            _loc3_ = this._inviteActionFactory.getResourceManagerString("invite_critical_exception");
         }
         var _loc4_:AlertAction = new AlertAction(_loc2_,_loc3_);
         _loc4_.add();
         err(new Error("**Unable to transfer ownership to player with id: " + this._participant.summonerId));
      }
      
      private function onServiceSuccess(param1:ResultEvent) : void
      {
         complete();
      }
      
      private function onServiceError(param1:ServerError) : void
      {
         this.displayError(param1);
      }
      
      public function getInviteParticipant() : InviteParticipant
      {
         return this._participant;
      }
      
      override protected function doInvocation() : void
      {
         if(this._participant == null || this._participant.summonerId <= 0)
         {
            return;
         }
         this._gameInviteService.transferOwnership(this._participant.summonerId,this.onServiceSuccess,null,this.onServiceError);
      }
   }
}

