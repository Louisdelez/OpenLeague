package com.riotgames.pvpnet.invite.action
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.error.invite.AlreadyMemberOfInvitationLobbyException;
   import com.riotgames.platform.common.error.invite.LobbyCreationNotEnabledException;
   import com.riotgames.platform.common.services.GameInviteService;
   import com.riotgames.platform.gameclient.domain.gameinvite.LobbyStatus;
   import com.riotgames.pvpnet.invite.PlatformInviteActionFactory;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import mx.rpc.events.ResultEvent;
   
   public class CreateArrangedRankedTeamLobbyAction extends BasicAction implements ILobbyStatusAction
   {
      
      private var _lobbyStatus:LobbyStatus;
      
      private var _inviteActionFactory:PlatformInviteActionFactory;
      
      private var _queueId:Number;
      
      private var _rankedTeamName:String;
      
      private var _gameInviteService:GameInviteService;
      
      public function CreateArrangedRankedTeamLobbyAction(param1:Number, param2:String, param3:GameInviteService, param4:PlatformInviteActionFactory)
      {
         super(false);
         this._queueId = param1;
         this._rankedTeamName = param2;
         this._gameInviteService = param3;
         this._inviteActionFactory = param4;
      }
      
      public function getLobbyStatus() : LobbyStatus
      {
         return this._lobbyStatus;
      }
      
      override protected function doInvocation() : void
      {
         this._gameInviteService.createArrangedRankedTeamLobby(this._queueId,this._rankedTeamName,this.onServiceSuccess,null,this.onServiceError);
      }
      
      private function displayError(param1:ServerError) : void
      {
         var _loc3_:String = null;
         var _loc2_:String = this._inviteActionFactory.getResourceManagerString("invite_error_title");
         if(param1.exception is LobbyCreationNotEnabledException)
         {
            _loc3_ = this._inviteActionFactory.getResourceManagerString("invite_lobby_creation_unavailable_exception");
         }
         else if(param1.exception is AlreadyMemberOfInvitationLobbyException)
         {
            _loc3_ = this._inviteActionFactory.getResourceManagerString("invite_already_invite_member_exception");
         }
         else
         {
            _loc3_ = this._inviteActionFactory.getResourceManagerString("invite_critical_exception");
         }
         var _loc4_:AlertAction = new AlertAction(_loc2_,_loc3_);
         _loc4_.add();
         err(new Error("**Unable to create lobby for queue: " + this._queueId + "\nReceived Error of type: " + param1.exception.toString()));
      }
      
      private function onServiceSuccess(param1:ResultEvent) : void
      {
         this._lobbyStatus = param1.result as LobbyStatus;
         complete();
      }
      
      private function onServiceError(param1:ServerError) : void
      {
         this.displayError(param1);
      }
   }
}

