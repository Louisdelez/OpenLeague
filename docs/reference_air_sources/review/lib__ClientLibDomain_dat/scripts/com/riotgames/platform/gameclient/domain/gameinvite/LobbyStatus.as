package com.riotgames.platform.gameclient.domain.gameinvite
{
   import mx.collections.ArrayCollection;
   
   [RemoteClass(alias="com.riotgames.platform.gameinvite.contract.LobbyStatus")]
   public class LobbyStatus extends InvitationMetadata
   {
      
      private var _members:ArrayCollection;
      
      private var _chatKey:String;
      
      private var _invitees:ArrayCollection;
      
      private var _invitationId:String;
      
      private var _owner:InvitationPlayer;
      
      public function LobbyStatus()
      {
         super();
      }
      
      public function get owner() : InvitationPlayer
      {
         return this._owner;
      }
      
      public function get invitationId() : String
      {
         return this._invitationId;
      }
      
      public function toString() : String
      {
         var _loc2_:Member = null;
         var _loc3_:Invitee = null;
         var _loc1_:String = "LobbyStatus - InvitationId: " + this.invitationId + "\n";
         _loc1_ += "Owner Id: " + this.owner.summonerId + "\n\nMembers: ";
         for each(_loc2_ in this.members)
         {
            _loc1_ += "\nSummoner Id: " + _loc2_.summonerId + " - Summoner Name: " + _loc2_.summonerName + " - HasDelegatedInvitePower: " + _loc2_.hasDelegatedInvitePower;
         }
         _loc1_ += "\n\nInvitations:";
         for each(_loc3_ in this.invitees)
         {
            _loc1_ += "\nSummoner Id: " + _loc3_.summonerId + " - Summoner Name: " + _loc3_.summonerName + " - Status: " + _loc3_.inviteeState;
         }
         return _loc1_;
      }
      
      public function get chatKey() : String
      {
         return this._chatKey;
      }
      
      public function set owner(param1:InvitationPlayer) : void
      {
         this._owner = param1;
      }
      
      public function set invitees(param1:ArrayCollection) : void
      {
         this._invitees = param1;
      }
      
      public function set members(param1:ArrayCollection) : void
      {
         this._members = param1;
      }
      
      public function set chatKey(param1:String) : void
      {
         this._chatKey = param1;
      }
      
      public function set invitationId(param1:String) : void
      {
         this._invitationId = param1;
      }
      
      public function get members() : ArrayCollection
      {
         return this._members;
      }
      
      public function get invitees() : ArrayCollection
      {
         return this._invitees;
      }
   }
}

