package com.riotgames.platform.gameclient.domain.gameinvite
{
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipantState;
   
   [RemoteClass(alias="com.riotgames.platform.gameinvite.contract.Invitee")]
   public class Invitee extends InvitationPlayer
   {
      
      private var _inviteeState:String;
      
      public function Invitee()
      {
         super();
      }
      
      public function set inviteeState(param1:String) : void
      {
         this._inviteeState = InviteParticipantState.fromPlatformInviteeState(param1);
      }
      
      public function get inviteeState() : String
      {
         return this._inviteeState;
      }
   }
}

