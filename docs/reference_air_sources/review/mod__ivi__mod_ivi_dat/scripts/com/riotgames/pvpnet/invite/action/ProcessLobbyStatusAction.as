package com.riotgames.pvpnet.invite.action
{
   import blix.action.BasicAction;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.domain.gameinvite.Invitee;
   import com.riotgames.platform.gameclient.domain.gameinvite.LobbyStatus;
   import com.riotgames.platform.gameclient.domain.gameinvite.Member;
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipant;
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipantState;
   import com.riotgames.pvpnet.invite.PlatformInviteActionFactory;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   
   public class ProcessLobbyStatusAction extends BasicAction
   {
      
      private var _inviteGroup:InviteGroup;
      
      private var _lobbyStatus:LobbyStatus;
      
      private var _inviteActionFactory:PlatformInviteActionFactory;
      
      public function ProcessLobbyStatusAction(param1:LobbyStatus, param2:InviteGroup, param3:PlatformInviteActionFactory)
      {
         super(false);
         this._inviteGroup = param2;
         this._lobbyStatus = param1;
         this._inviteActionFactory = param3;
      }
      
      override protected function doInvocation() : void
      {
         var _loc1_:Invitee = null;
         var _loc2_:InviteParticipant = null;
         var _loc3_:InviteParticipant = null;
         var _loc4_:Boolean = false;
         var _loc5_:Member = null;
         this._inviteGroup.inviteId = this._lobbyStatus.invitationId;
         this._inviteGroup.mapId = this._lobbyStatus.mapId;
         this._inviteGroup.gameType = this._lobbyStatus.gameType;
         if(Boolean(this._lobbyStatus.chatKey) && this._lobbyStatus.chatKey != "")
         {
            this._inviteGroup.gamePassword = this._lobbyStatus.chatKey;
         }
         this.setupOwnerParticipant(this._lobbyStatus);
         for each(_loc1_ in this._lobbyStatus.invitees)
         {
            _loc3_ = this._inviteGroup.getParticipantBySummonerId(_loc1_.summonerId);
            if(_loc3_)
            {
               _loc3_.status = this._lobbyStatus.owner.summonerId == _loc1_.summonerId ? InviteParticipantState.OWNER : _loc1_.inviteeState;
            }
            else
            {
               _loc3_ = new InviteParticipant(ChatController.unescapedJIDFromSummonerId(_loc1_.summonerId),_loc1_.summonerId,_loc1_.summonerName,_loc1_.inviteeState);
            }
            this._inviteGroup.addParticipant(_loc3_);
         }
         for each(_loc2_ in this._inviteGroup.acceptedParticipants)
         {
            _loc4_ = false;
            for each(_loc5_ in this._lobbyStatus.members)
            {
               if(_loc5_.summonerId == _loc2_.summonerId)
               {
                  _loc2_.hasDelegatedInvitePower = _loc5_.hasDelegatedInvitePower;
                  _loc2_.isInvitor = _loc5_.hasDelegatedInvitePower;
                  if(_loc5_.summonerId == this._inviteGroup.mySummonerId && _loc5_.summonerId != this._lobbyStatus.owner.summonerId)
                  {
                     this._inviteGroup.allowedToInvite = _loc5_.hasDelegatedInvitePower;
                  }
                  _loc4_ = true;
               }
            }
            if(!_loc4_)
            {
               this._inviteGroup.removeParticipant(_loc2_);
            }
         }
         this._inviteGroup.refresh();
         complete();
      }
      
      private function setupOwnerParticipant(param1:LobbyStatus) : void
      {
         var _loc2_:InviteParticipant = this._inviteGroup.ownerParticipant;
         if(_loc2_)
         {
            _loc2_.isOwner = false;
            _loc2_.hasDelegatedInvitePower = false;
            _loc2_.kickBanningEnabled = false;
         }
         var _loc3_:InviteParticipant = this._inviteGroup.getParticipantBySummonerId(param1.owner.summonerId);
         if(!_loc3_)
         {
            _loc3_ = new InviteParticipant(ChatController.unescapedJIDFromSummonerId(param1.owner.summonerId),param1.owner.summonerId,param1.owner.summonerName);
            this._inviteGroup.addParticipant(_loc3_);
         }
         _loc3_.isOwner = true;
         _loc3_.isInvitor = true;
         _loc3_.hasDelegatedInvitePower = true;
         _loc3_.kickBanningEnabled = true;
         if(param1.owner.summonerId == this._inviteGroup.mySummonerId)
         {
            this._inviteGroup.isOwner = true;
            this._inviteGroup.allowedToInvite = true;
            this._inviteGroup.isGroupOpenToMembers = true;
         }
         else
         {
            this._inviteGroup.isOwner = false;
            this._inviteGroup.allowedToInvite = false;
            this._inviteGroup.isGroupOpenToMembers = false;
         }
         this._inviteGroup.ownerParticipant = _loc3_;
         this._inviteGroup.refresh();
      }
   }
}

