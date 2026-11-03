package com.riotgames.pvpnet.invite.action
{
   import blix.action.BasicAction;
   import blix.action.IAction;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.error.invite.IncorrectLobbyStateException;
   import com.riotgames.platform.common.error.invite.LobbyClosedException;
   import com.riotgames.platform.common.error.invite.LobbyFullException;
   import com.riotgames.platform.common.services.GameInviteService;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.domain.game.GameType;
   import com.riotgames.platform.gameclient.domain.game.GameViewState;
   import com.riotgames.platform.gameclient.domain.gameinvite.LobbyStatus;
   import com.riotgames.pvpnet.invite.IInviteController;
   import com.riotgames.pvpnet.invite.PlatformInviteActionFactory;
   import com.riotgames.pvpnet.invite.controller.InviteQueueManager;
   import com.riotgames.pvpnet.invite.model.GameInvite;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import mx.rpc.events.ResultEvent;
   
   public class RespondToInviteAction extends BasicAction implements ILobbyStatusAction
   {
      
      private var _acceptInvite:Boolean = false;
      
      private var _gameInviteService:GameInviteService;
      
      private var _inviteController:IInviteController;
      
      private var _lobbyStatus:LobbyStatus;
      
      private var _inviteQueueManager:InviteQueueManager;
      
      private var _inviteActionFactory:PlatformInviteActionFactory;
      
      private var _inviteGroup:InviteGroup;
      
      private var _gameInvite:GameInvite;
      
      public function RespondToInviteAction(param1:GameInvite, param2:IInviteController, param3:Boolean, param4:GameInviteService, param5:PlatformInviteActionFactory, param6:InviteGroup, param7:InviteQueueManager)
      {
         super(false);
         this._gameInvite = param1;
         this._acceptInvite = param3;
         this._gameInviteService = param4;
         this._inviteController = param2;
         this._inviteActionFactory = param5;
         this._inviteGroup = param6;
         this._inviteQueueManager = param7;
      }
      
      private function acceptInvitation() : void
      {
         this.quitCurrentGame();
      }
      
      private function onAcceptSuccess(param1:ResultEvent) : void
      {
         if(!(this._gameInvite.gameType == GameType.CUSTOM_GAME || this._gameInvite.gameType == GameType.PRACTICE_GAME))
         {
            this.setupAndTransitionView();
         }
         this.onServiceSuccess(param1);
      }
      
      private function displayAlert() : void
      {
         var _loc1_:String = this._inviteActionFactory.getRiotResourceString("general_generalAlertErrorTitle","Title");
         var _loc2_:String = this._inviteActionFactory.getRiotResourceString("XMPP-OWNER-CAN-NOT-ACCEPT","Cannot accept invite.");
         var _loc3_:AlertAction = new AlertAction(_loc1_,_loc2_);
         _loc3_.add();
      }
      
      private function onLeaveSuccess(param1:IAction) : void
      {
         if(this._gameInvite.gameType == GameType.CUSTOM_GAME || this._gameInvite.gameType == GameType.PRACTICE_GAME)
         {
            this.setupAndTransitionView();
         }
         this._gameInviteService.accept(this._gameInvite.invitationId,this.onAcceptSuccess,null,this.onServiceError);
      }
      
      private function onServiceSuccess(param1:ResultEvent) : void
      {
         this._lobbyStatus = param1.result as LobbyStatus;
         complete();
      }
      
      private function setupAndTransitionView() : void
      {
         this._inviteController.setInviteGroupAsInvitee(this._gameInvite.gameType,this._gameInvite.invitationId,ChatController.unescapedJIDFromSummonerId(this._gameInvite.owner.summonerId),this._gameInvite.owner.summonerId,this._gameInvite.owner.summonerName,0,this._gameInvite.gameId,this._gameInvite.mapId,this._gameInvite.groupId);
         this._inviteActionFactory.getBeginGameflowAction(this._gameInvite.queueId,this._gameInvite.gameDifficulty,this._gameInvite.teamName,this._gameInvite.teamId,this._gameInvite.gameType,this._gameInvite.mapId).invoke();
      }
      
      private function onLeaveError(param1:IAction) : void
      {
         err(param1.getError());
         var _loc2_:String = this._inviteQueueManager.getCurrentGameState();
         if(_loc2_ == GameViewState.CAP_STATE)
         {
            this._gameInviteService.decline(this._gameInvite.invitationId,this.onServiceSuccess,null,this.onServiceError);
         }
      }
      
      private function onServiceError(param1:ServerError) : void
      {
         this._inviteController.setInviteGroupCancel(false);
         var _loc2_:IAction = this._inviteActionFactory.getQuitGameAction(this._gameInvite.gameType);
         _loc2_.getErred().add(this.onLeaveError);
         _loc2_.invoke();
         this.displayError(param1);
      }
      
      private function isAllowedToAccept() : Boolean
      {
         var _loc1_:String = this._inviteQueueManager.getCurrentGameState();
         if(_loc1_ == GameViewState.CAP_STATE && Boolean(this._inviteGroup.isOwner))
         {
            return false;
         }
         return true;
      }
      
      private function displayError(param1:ServerError) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:AlertAction = null;
         if(this._acceptInvite)
         {
            _loc2_ = this._inviteActionFactory.getResourceManagerString("invite_error_title");
            if(param1.exception is IncorrectLobbyStateException)
            {
               _loc3_ = this._inviteActionFactory.getResourceManagerString("invite_lobby_state_invalid_exception");
            }
            else if(param1.exception is LobbyFullException)
            {
               _loc3_ = this._inviteActionFactory.getResourceManagerString("invite_lobby_full_exception");
            }
            else if(param1.exception is LobbyClosedException)
            {
               _loc3_ = this._inviteActionFactory.getResourceManagerString("invite_lobby_closed_exception",[this._gameInvite.getInviterName()]);
            }
            else
            {
               _loc3_ = this._inviteActionFactory.getResourceManagerString("invite_critical_exception");
            }
            _loc4_ = new AlertAction(_loc2_,_loc3_);
            _loc4_.add();
         }
         err(new Error("**Attempted to respond to invitation with id: " + this._gameInvite.invitationId + " and failed - Accepted: " + this._acceptInvite + "\n\nError: " + param1.exception.toString()));
      }
      
      public function getLobbyStatus() : LobbyStatus
      {
         return this._lobbyStatus;
      }
      
      override protected function doInvocation() : void
      {
         if(this._gameInvite == null || this._gameInvite.invitationId == "" || this._gameInvite.invitationId == null)
         {
            return;
         }
         var _loc1_:Boolean = this.isAllowedToAccept();
         if(this._acceptInvite && _loc1_)
         {
            this.acceptInvitation();
         }
         else
         {
            if(!_loc1_)
            {
               this.displayAlert();
            }
            this._gameInviteService.decline(this._gameInvite.invitationId,this.onServiceSuccess,null,this.onServiceError);
         }
      }
      
      private function quitCurrentGame() : void
      {
         var _loc1_:IAction = this._inviteActionFactory.getQuitGameAction(this._inviteGroup.gameType);
         _loc1_.getCompleted().add(this.onLeaveSuccess);
         _loc1_.getErred().add(this.onLeaveError);
         _loc1_.invoke();
      }
   }
}

