package com.riotgames.pvpnet.invite.action
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.services.GameInviteService;
   import mx.collections.ArrayCollection;
   import mx.rpc.events.ResultEvent;
   
   public class RetrievePendingInvitationsAction extends BasicAction
   {
      
      private var _gameInviteService:GameInviteService;
      
      private var _invitations:ArrayCollection;
      
      public function RetrievePendingInvitationsAction(param1:GameInviteService)
      {
         super(false);
         this._gameInviteService = param1;
      }
      
      public function getInvitations() : ArrayCollection
      {
         return this._invitations;
      }
      
      private function onServiceError(param1:ServerError) : void
      {
         err(new Error("**Unable to retrieve pending invitations\nReceived Error of type: " + param1.exception.toString()));
      }
      
      override protected function doInvocation() : void
      {
         this._gameInviteService.getPendingInvitations(this.onServiceSuccess,null,this.onServiceError);
      }
      
      private function onServiceSuccess(param1:ResultEvent) : void
      {
         this._invitations = param1.result as ArrayCollection;
         complete();
      }
   }
}

