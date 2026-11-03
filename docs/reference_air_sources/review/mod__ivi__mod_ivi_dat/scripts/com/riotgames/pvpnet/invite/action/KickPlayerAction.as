package com.riotgames.pvpnet.invite.action
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.services.GameInviteService;
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipant;
   import com.riotgames.pvpnet.invite.PlatformInviteActionFactory;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import mx.rpc.events.ResultEvent;
   
   public class KickPlayerAction extends BasicAction implements IInviteParticipantAction
   {
      
      private var _gameInviteService:GameInviteService;
      
      private var _participant:InviteParticipant;
      
      private var _inviteActionFactory:PlatformInviteActionFactory;
      
      public function KickPlayerAction(param1:InviteParticipant, param2:GameInviteService, param3:PlatformInviteActionFactory)
      {
         super(false);
         this._participant = param1;
         this._gameInviteService = param2;
         this._inviteActionFactory = param3;
      }
      
      private function displayError() : void
      {
         var _loc2_:String = null;
         var _loc1_:String = this._inviteActionFactory.getResourceManagerString("invite_error_title");
         _loc2_ = this._inviteActionFactory.getResourceManagerString("invite_critical_exception");
         var _loc3_:AlertAction = new AlertAction(_loc1_,_loc2_);
         _loc3_.add();
         err(new Error("**Unable to kick summoner with id: " + this._participant.summonerId));
      }
      
      private function onServiceSuccess(param1:ResultEvent) : void
      {
         complete();
      }
      
      private function onServiceError() : void
      {
         this.displayError();
      }
      
      public function getInviteParticipant() : InviteParticipant
      {
         return this._participant;
      }
      
      override protected function doInvocation() : void
      {
         if(this._participant == null || this._participant.summonerId <= 0)
         {
            this.displayError();
            return;
         }
         this._gameInviteService.kick(this._participant.summonerId,this.onServiceSuccess,null,this.onServiceError);
      }
   }
}

