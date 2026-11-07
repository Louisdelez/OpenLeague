package com.riotgames.pvpnet.invite.action
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.services.GameInviteService;
   import com.riotgames.pvpnet.invite.PlatformInviteActionFactory;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import mx.rpc.events.ResultEvent;
   
   public class CloseLobbyAction extends BasicAction
   {
      
      private var _gameInviteService:GameInviteService;
      
      private var _inviteActionFactory:PlatformInviteActionFactory;
      
      public function CloseLobbyAction(param1:GameInviteService, param2:PlatformInviteActionFactory)
      {
         super(false);
         this._gameInviteService = param1;
         this._inviteActionFactory = param2;
      }
      
      override protected function doInvocation() : void
      {
         this._gameInviteService.destroyGroupFinderLobby(this.onServiceSuccess,null,this.onServiceError);
      }
      
      private function onServiceError(param1:ServerError) : void
      {
         var _loc2_:String = this._inviteActionFactory.getResourceManagerString("invite_error_title");
         var _loc3_:String = this._inviteActionFactory.getResourceManagerString("invite_lobby_close_error");
         var _loc4_:AlertAction = new AlertAction(_loc2_,_loc3_);
         _loc4_.add();
         _loc4_.invoke();
         err(new Error("**Unable to close lobby"));
      }
      
      private function onServiceSuccess(param1:ResultEvent) : void
      {
         complete();
      }
   }
}

