package com.riotgames.pvpnet.invite.action
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.error.invite.AlreadyMemberOfInvitationLobbyException;
   import com.riotgames.platform.common.error.invite.ExceededInviteBulkMaxSizeException;
   import com.riotgames.platform.common.error.invite.IncorrectLobbyStateException;
   import com.riotgames.platform.common.error.invite.InviteFailed;
   import com.riotgames.platform.common.error.invite.NoInvitePrivilegesException;
   import com.riotgames.platform.common.error.invite.NotAMemberOfInvitationLobbyException;
   import com.riotgames.platform.common.error.invite.NotInvitableException;
   import com.riotgames.platform.common.error.invite.PlayerDoesNotExistException;
   import com.riotgames.platform.common.error.invite.PlayerInGameException;
   import com.riotgames.platform.common.error.invite.UserBannedException;
   import com.riotgames.platform.common.services.GameInviteService;
   import com.riotgames.platform.gameclient.chat.INotificationsProvider;
   import com.riotgames.platform.gameclient.chat.domain.DockedPrompt;
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipant;
   import com.riotgames.pvpnet.invite.PlatformInviteActionFactory;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import mx.collections.ArrayCollection;
   import mx.resources.ResourceManager;
   import mx.rpc.events.ResultEvent;
   
   public class InvitePlayersAction extends BasicAction
   {
      
      private var _inviteType:String;
      
      private var _dockedNotificationsProvider:INotificationsProvider;
      
      private var _inviteActionFactory:PlatformInviteActionFactory;
      
      private var _payload:String;
      
      private var _inviteGroup:InviteGroup;
      
      private var _gameInviteService:GameInviteService;
      
      private var _participants:Array;
      
      public function InvitePlayersAction(param1:Array, param2:InviteGroup, param3:GameInviteService, param4:INotificationsProvider, param5:PlatformInviteActionFactory, param6:String, param7:String)
      {
         super(false);
         this._participants = param1;
         this._inviteGroup = param2;
         this._gameInviteService = param3;
         this._dockedNotificationsProvider = param4;
         this._inviteActionFactory = param5;
         this._inviteType = param6;
         this._payload = param7;
      }
      
      private function completedWithError(param1:Object) : void
      {
         err(new Error("**Unable to invite summoner(s) with id: " + this._participants + "\nReceived Error(s) of type: " + param1.toString()));
      }
      
      private function onBulkInviteSuccess(param1:ResultEvent) : void
      {
         var _loc3_:InviteFailed = null;
         var _loc2_:ArrayCollection = param1.result as ArrayCollection;
         if(_loc2_.length == 0)
         {
            complete();
         }
         else
         {
            for each(_loc3_ in _loc2_)
            {
               this.displayError(_loc3_.exception,_loc3_.summonerName);
               this.removeFailedParticipant(_loc3_.summonerId);
            }
            this.completedWithError(_loc2_);
         }
      }
      
      override protected function doInvocation() : void
      {
         var _loc2_:InviteParticipant = null;
         if(!this._participants || this._participants.length == 0)
         {
            return;
         }
         var _loc1_:Array = new Array();
         for each(_loc2_ in this._participants)
         {
            if(_loc2_)
            {
               _loc2_.kickBanningEnabled = true;
               _loc1_.push(_loc2_.summonerId);
            }
         }
         if(_loc1_.length == 1)
         {
            this._gameInviteService.invite(_loc1_[0],this._inviteType,this._payload,this.onSingleInviteSuccess,null,this.onServiceError);
         }
         else if(this._participants.length > 1)
         {
            this._gameInviteService.inviteBulk(_loc1_,this._inviteType,this.onBulkInviteSuccess,null,this.onServiceError);
         }
      }
      
      private function displayError(param1:Object, param2:String) : void
      {
         var _loc4_:String = null;
         var _loc6_:DockedPrompt = null;
         var _loc3_:String = this._inviteActionFactory.getResourceManagerString("invite_error_title");
         if(param1 is NotAMemberOfInvitationLobbyException)
         {
            _loc4_ = this._inviteActionFactory.getResourceManagerString("invite_critical_exception");
         }
         else if(param1 is IncorrectLobbyStateException)
         {
            _loc4_ = this._inviteActionFactory.getResourceManagerString("invite_lobby_state_invalid_exception");
         }
         else if(param1 is NoInvitePrivilegesException)
         {
            _loc4_ = this._inviteActionFactory.getResourceManagerString("invite_no_invite_privileges_exception");
         }
         else
         {
            if(param1 is AlreadyMemberOfInvitationLobbyException)
            {
               _loc6_ = DockedPrompt.create(this._inviteActionFactory.getResourceManagerString("invite_already_invite_member_exception",[param2]),this._inviteActionFactory.getResourceManagerString("XMPP-GAME-INVITE-TITLE"),param2,ResourceManager.getInstance().getString("resources","common_button_ok"));
               this._dockedNotificationsProvider.showDockedPrompt(_loc6_);
               return;
            }
            if(param1 is PlayerDoesNotExistException)
            {
               _loc4_ = this._inviteActionFactory.getResourceManagerString("invite_nonexistent_player_exception",[param2]);
            }
            else if(param1 is PlayerInGameException)
            {
               _loc4_ = this._inviteActionFactory.getResourceManagerString("invite_player_in_game_exception",[param2]);
            }
            else if(param1 is NotInvitableException)
            {
               _loc4_ = this._inviteActionFactory.getResourceManagerString("invite_uninvitable_exception",[param2]);
            }
            else if(param1 is UserBannedException)
            {
               _loc4_ = this._inviteActionFactory.getResourceManagerString("invite_banned_exception",[param2]);
            }
            else if(param1 is ExceededInviteBulkMaxSizeException)
            {
               _loc4_ = this._inviteActionFactory.getResourceManagerString("invite_bulk_max_size_exceeded_exception",[(param1 as ExceededInviteBulkMaxSizeException).inviteBulkMaxSize]);
            }
            else
            {
               _loc4_ = this._inviteActionFactory.getResourceManagerString("invite_critical_exception");
            }
         }
         var _loc5_:AlertAction = new AlertAction(_loc3_,_loc4_);
         _loc5_.add();
      }
      
      private function removeFailedParticipant(param1:Number) : void
      {
         var _loc2_:InviteParticipant = this._inviteGroup.getParticipantBySummonerId(param1);
         if(_loc2_)
         {
            this._inviteGroup.removeParticipant(_loc2_);
         }
      }
      
      private function onServiceError(param1:ServerError) : void
      {
         var _loc3_:InviteParticipant = null;
         var _loc2_:String = "";
         if(Boolean(this._participants) && Boolean(this._participants[0]))
         {
            _loc2_ = (this._participants[0] as InviteParticipant).name;
         }
         this.displayError(param1.exception,_loc2_);
         for each(_loc3_ in this._participants)
         {
            this._inviteGroup.removeParticipant(_loc3_);
         }
         this.completedWithError(param1.exception);
      }
      
      private function onSingleInviteSuccess(param1:ResultEvent) : void
      {
         complete();
      }
   }
}

InviteFailed;

