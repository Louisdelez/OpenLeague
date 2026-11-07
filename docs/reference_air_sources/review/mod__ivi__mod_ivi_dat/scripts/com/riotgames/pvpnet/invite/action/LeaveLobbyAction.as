package com.riotgames.pvpnet.invite.action
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.services.GameInviteService;
   import com.riotgames.pvpnet.invite.PlatformInviteActionFactory;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import mx.rpc.events.ResultEvent;
   
   public class LeaveLobbyAction extends BasicAction
   {
      
      private var _gameInviteService:GameInviteService;
      
      private var _inviteActionFactory:PlatformInviteActionFactory;
      
      public function LeaveLobbyAction(param1:GameInviteService)
      {
         super(false);
         this._gameInviteService = param1;
      }
      
      override protected function doInvocation() : void
      {
         this._gameInviteService.leave(this.onServiceSuccess,null,this.onServiceError);
      }
      
      private function onServiceError(param1:ServerError) : void
      {
         var _loc2_:String = this._inviteActionFactory.getResourceManagerString("invite_error_title");
         var _loc3_:String = this._inviteActionFactory.getResourceManagerString("invite_lobby_leave_error");
         var _loc4_:AlertAction = new AlertAction(_loc2_,_loc3_);
         _loc4_.add();
         _loc4_.invoke();
         err(new Error("**Unable to leave lobby"));
      }
      
      private function onServiceSuccess(param1:ResultEvent) : void
      {
         complete();
      }
   }
}

