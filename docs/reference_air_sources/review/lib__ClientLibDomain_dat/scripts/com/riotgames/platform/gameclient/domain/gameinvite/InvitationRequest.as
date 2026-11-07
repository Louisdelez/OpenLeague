package com.riotgames.platform.gameclient.domain.gameinvite
{
   [RemoteClass(alias="com.riotgames.platform.gameinvite.contract.InvitationRequest")]
   public class InvitationRequest extends InvitationMetadata
   {
      
      private static const COMMON_FRIEND_NAME:String = "commonFriendName";
      
      private var _inviteType:String = "DEFAULT";
      
      private var _invitePayload:String;
      
      private var _inviter:Inviter;
      
      private var _payloadBlob:Object = {};
      
      private var _owner:InvitationPlayer;
      
      private var _invitationState:String = "ACTIVE";
      
      private var _invitationId:String;
      
      public function InvitationRequest()
      {
         super();
      }
      
      public function get invitePayload() : String
      {
         return this._invitePayload;
      }
      
      public function get inviter() : Inviter
      {
         return this._inviter;
      }
      
      public function set inviteType(param1:String) : void
      {
         this._inviteType = param1;
      }
      
      public function set invitePayload(param1:String) : void
      {
         if(!param1)
         {
            return;
         }
         this._invitePayload = param1;
         this._payloadBlob = JSON.parse(this._invitePayload);
      }
      
      public function set inviter(param1:Inviter) : void
      {
         this._inviter = param1;
      }
      
      public function get commonFriendName() : String
      {
         if(Boolean(this._payloadBlob[COMMON_FRIEND_NAME]))
         {
            return this._payloadBlob[COMMON_FRIEND_NAME];
         }
         return "";
      }
      
      public function get invitationId() : String
      {
         return this._invitationId;
      }
      
      public function get inviteType() : String
      {
         return this._inviteType;
      }
      
      public function set owner(param1:InvitationPlayer) : void
      {
         this._owner = param1;
      }
      
      public function set invitationId(param1:String) : void
      {
         this._invitationId = param1;
      }
      
      public function set invitationState(param1:String) : void
      {
         this._invitationState = param1;
      }
      
      public function get owner() : InvitationPlayer
      {
         return this._owner;
      }
      
      public function get invitationState() : String
      {
         return this._invitationState;
      }
      
      public function getInviterOrOwner() : InvitationPlayer
      {
         return this._inviter != null ? this._inviter : this._owner;
      }
   }
}

