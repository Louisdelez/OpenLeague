package com.riotgames.pvpnet.invite.model
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.xmpp.data.invite.PresenceStatusXML;
   import com.riotgames.platform.gameclient.chat.IChatProvider;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.gameclient.domain.game.GameType;
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipant;
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipantState;
   import com.riotgames.platform.gameclient.domain.invite.InviteState;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   import org.igniterealtime.xiff.conference.RoomOccupant;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.data.Presence;
   
   public class InviteGroup extends EventDispatcher
   {
      
      private var _allowedToInviteChanged:Signal = new Signal();
      
      private var _isOwnerChangedSignal:Signal = new Signal();
      
      private var _isAcceptingInvites:Boolean = true;
      
      private var _numGuestSlotsUsedChanged:Signal = new Signal();
      
      private var _isAcceptingInvitesChanged:Signal = new Signal();
      
      private var _numGuestSlotsUsed:int = 0;
      
      private var _inviteState:String = "NONE";
      
      private var _2000266271allParticipants:ArrayCollection = new ArrayCollection();
      
      public var gameType:String = "PRACTICE_GAME";
      
      private var _isGroupOpenToMembers:Boolean = false;
      
      private var _inviteId:String;
      
      private var _numGuestSlots:int = 2;
      
      private var _isOwner:Boolean = false;
      
      public var inviterUsername:String;
      
      public var ownerParticipant:InviteParticipant;
      
      private var _isInviteActiveChangedSignal:Signal = new Signal();
      
      public var mapId:Number;
      
      private var _395845051invitedParticipants:ArrayCollection = new ArrayCollection();
      
      public var participants:Array = new Array();
      
      private var _ownerQuitCancelsGame:Boolean = true;
      
      public var gameId:Number;
      
      private var _inviteStateChangedSignal:Signal = new Signal();
      
      public var gamePassword:String;
      
      private var _1734125799acceptedParticipants:ArrayCollection = new ArrayCollection();
      
      public var myJID:UnescapedJID;
      
      private var _isGroupOpenToMembersChangedSignal:Signal = new Signal();
      
      private var _numGuestSlotsChanged:Signal = new Signal();
      
      private var _chatRoom:ChatRoom;
      
      public var myUserName:String;
      
      public var inviterJID:EscapedJID;
      
      private var _pendingInvitesEnabled:Boolean = true;
      
      private var _1059116329pendingParticipants:ArrayCollection = new ArrayCollection();
      
      public var mySummonerId:Number;
      
      private var _isInviteActive:Boolean = false;
      
      private var _inviteIdChangedSignal:Signal = new Signal();
      
      private var _invitedParticipantsChangedSignal:Signal = new Signal();
      
      private var _chatRoomChangedSignal:Signal = new Signal();
      
      public var myUserIconId:int;
      
      private var _allowedToInvite:Boolean = false;
      
      public var requeueInviteId:String;
      
      public var groupId:String = null;
      
      public function InviteGroup()
      {
         super();
         this.acceptedParticipants.filterFunction = this.acceptedFilter;
         this.pendingParticipants.filterFunction = this.pendingFilter;
         this.invitedParticipants.filterFunction = this.invitedFilter;
         this.clear();
      }
      
      [Bindable(event="inviteIdChanged")]
      public function get inviteId() : String
      {
         return this._inviteId;
      }
      
      public function set isGroupOpenToMembers(param1:Boolean) : void
      {
         if(param1 != this._isGroupOpenToMembers)
         {
            this._isGroupOpenToMembers = param1;
            dispatchEvent(new Event("isGroupOpenToMembersChanged"));
            this._isGroupOpenToMembersChangedSignal.dispatch();
         }
      }
      
      public function getIsInviteActiveChangedSignal() : ISignal
      {
         return this._isInviteActiveChangedSignal;
      }
      
      [Bindable(event="inviteStateChanged")]
      public function get inviteState() : String
      {
         return this._inviteState;
      }
      
      public function set inviteState(param1:String) : void
      {
         if(param1 != this._inviteState)
         {
            this._inviteState = param1;
            dispatchEvent(new Event("inviteStateChanged"));
            this._inviteStateChangedSignal.dispatch();
         }
      }
      
      public function removeParticipant(param1:InviteParticipant) : void
      {
         var _loc2_:InviteParticipant = null;
         var _loc3_:Array = this.participants.slice();
         this.clearParticipants();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc2_ = _loc3_[_loc4_] as InviteParticipant;
            if(_loc2_.summonerId != param1.summonerId)
            {
               this.participants.push(_loc2_);
            }
            _loc4_++;
         }
         this.refresh();
         this._invitedParticipantsChangedSignal.dispatch(param1);
      }
      
      public function set inviteId(param1:String) : void
      {
         var _loc2_:int = 0;
         this._inviteId = param1;
         if(this._inviteId != null && this._inviteId != "")
         {
            _loc2_ = new int(this._inviteId);
            _loc2_++;
            this.requeueInviteId = _loc2_.toString();
         }
         dispatchEvent(new Event("inviteIdChanged"));
         this._inviteIdChangedSignal.dispatch();
      }
      
      public function getPendingParticipantCount() : int
      {
         if(Boolean(this.pendingParticipants))
         {
            return this.pendingParticipants.length;
         }
         return 0;
      }
      
      public function setRequeueInviteId() : void
      {
         this.inviteId = this.requeueInviteId;
      }
      
      public function getInviteIdChangedSignal() : ISignal
      {
         return this._inviteIdChangedSignal;
      }
      
      public function getParticipantsExceptOwner() : ArrayCollection
      {
         var _loc2_:InviteParticipant = null;
         var _loc1_:ArrayCollection = new ArrayCollection();
         var _loc3_:int = 0;
         while(_loc3_ < this.participants.length)
         {
            _loc2_ = this.participants[_loc3_] as InviteParticipant;
            if(Boolean(_loc2_) && Boolean(InviteParticipantState.isMemberState(_loc2_.status)) && _loc2_.status != InviteParticipantState.OWNER)
            {
               if(!this.ownerParticipant || _loc2_.summonerId != this.ownerParticipant.summonerId)
               {
                  _loc1_.addItem(_loc2_);
               }
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      [Bindable(event="allowedToInviteChanged")]
      public function get allowedToInvite() : Boolean
      {
         return this._allowedToInvite;
      }
      
      public function getChatRoomChangedSignal() : ISignal
      {
         return this._chatRoomChangedSignal;
      }
      
      public function set isAcceptingInvites(param1:Boolean) : void
      {
         this._isAcceptingInvites = param1;
         this._isAcceptingInvitesChanged.dispatch();
      }
      
      private function userAvailable(param1:Presence) : void
      {
         var _loc2_:InviteParticipant = null;
         var _loc3_:PresenceStatusXML = null;
         var _loc4_:Number = NaN;
         if(Boolean(param1) && Boolean(param1.from))
         {
            _loc2_ = this.getParticipantByName(param1.from.resource);
            if(Boolean(_loc2_) && Boolean(param1.status))
            {
               _loc3_ = new PresenceStatusXML(param1.status);
               if(Boolean(_loc3_.getProfileIcon()) && _loc3_.getProfileIcon() != "")
               {
                  _loc4_ = Number(_loc3_.getProfileIcon());
                  _loc2_.profileIconId = _loc4_;
                  this.refresh();
                  this._invitedParticipantsChangedSignal.dispatch(_loc2_);
               }
            }
         }
      }
      
      public function hasParticipant(param1:InviteParticipant) : Boolean
      {
         var _loc2_:InviteParticipant = null;
         for each(_loc2_ in this.participants)
         {
            if(_loc2_.summonerId == param1.summonerId)
            {
               return true;
            }
         }
         return false;
      }
      
      public function isAcceptedInvitee(param1:UnescapedJID) : Boolean
      {
         var _loc2_:InviteParticipant = null;
         for each(_loc2_ in this.acceptedParticipants)
         {
            if(_loc2_.jid.bareJID == param1.bareJID)
            {
               return true;
            }
         }
         return false;
      }
      
      public function clear() : void
      {
         this.clearParticipants();
         this.ownerParticipant = null;
         this.inviterJID = null;
         this.inviterUsername = null;
         this.allowedToInvite = false;
         this.isOwner = false;
         this.isAcceptingInvites = true;
         this.gameType = "";
         this.gameId = 0;
         this.mapId = 0;
         this.inviteId = "";
         this.groupId = "";
         this.inviteState = InviteState.NONE;
      }
      
      public function reset(param1:String, param2:UnescapedJID, param3:Number, param4:String, param5:int, param6:Number, param7:Number) : void
      {
         this.clearParticipants();
         this.ownerParticipant = new InviteParticipant(param2,param3,param4,InviteParticipantState.OWNER,param5);
         this.ownerParticipant.isOwner = true;
         this.addParticipant(this.ownerParticipant);
         this.gameType = param1;
         this.gameId = param6;
         this.mapId = param7;
         this.allowedToInvite = this.isOwner = this.ownerParticipant != null && this.mySummonerId == this.ownerParticipant.summonerId ? true : false;
      }
      
      public function set isOwner(param1:Boolean) : void
      {
         if(param1 != this._isOwner)
         {
            this._isOwner = param1;
            dispatchEvent(new Event("isOwnerChanged"));
            this._isOwnerChangedSignal.dispatch();
         }
      }
      
      [Bindable(event="invites_chatRoomChanged")]
      public function get chatRoom() : ChatRoom
      {
         return this._chatRoom;
      }
      
      public function getParticipantByNode(param1:String) : InviteParticipant
      {
         var _loc2_:InviteParticipant = null;
         for each(_loc2_ in this.participants)
         {
            if(_loc2_.jid.node == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function set allowedToInvite(param1:Boolean) : void
      {
         if(this._allowedToInvite != param1)
         {
            this._allowedToInvite = param1;
            dispatchEvent(new Event("allowedToInviteChanged"));
            this._allowedToInviteChanged.dispatch(param1);
         }
      }
      
      public function getParticipantBySummonerId(param1:Number) : InviteParticipant
      {
         var _loc2_:InviteParticipant = null;
         for each(_loc2_ in this.participants)
         {
            if(_loc2_.summonerId == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function hasParticipants() : Boolean
      {
         var _loc1_:InviteParticipant = null;
         if(this.acceptedParticipants.length > 1)
         {
            return true;
         }
         if(this.acceptedParticipants.length == 1)
         {
            _loc1_ = this.acceptedParticipants.getItemAt(0) as InviteParticipant;
            if(_loc1_.status == InviteParticipantState.OWNER)
            {
               return false;
            }
            return true;
         }
         return false;
      }
      
      public function get numGuestSlots() : int
      {
         return this._numGuestSlots;
      }
      
      public function set invitedParticipants(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._395845051invitedParticipants;
         if(_loc2_ !== param1)
         {
            this._395845051invitedParticipants = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"invitedParticipants",_loc2_,param1));
         }
      }
      
      public function set isInviteActive(param1:Boolean) : void
      {
         if(param1 != this._isInviteActive)
         {
            this._isInviteActive = param1;
            dispatchEvent(new Event("isInviteActiveChanged"));
            this._isInviteActiveChangedSignal.dispatch();
         }
      }
      
      [Bindable(event="isGroupOpenToMembersChanged")]
      public function get isGroupOpenToMembers() : Boolean
      {
         return this._isGroupOpenToMembers;
      }
      
      public function getIsGroupOpenToMembersChangedSignal() : ISignal
      {
         return this._isGroupOpenToMembersChangedSignal;
      }
      
      public function isParticipantOwner(param1:RoomOccupant) : Boolean
      {
         if(Boolean(param1 && param1.jid) && Boolean(this.ownerParticipant) && Boolean(this.ownerParticipant.jid))
         {
            return param1.jid.bareJID == this.ownerParticipant.jid.bareJID;
         }
         return false;
      }
      
      public function clearParticipants() : void
      {
         this.participants = new Array();
         this.acceptedParticipants.source = this.participants;
         this.invitedParticipants.source = this.participants;
         this.pendingParticipants.source = this.participants;
         this.allParticipants.source = this.participants;
      }
      
      public function set numGuestSlotsUsed(param1:int) : void
      {
         this._numGuestSlotsUsed = param1;
         this._numGuestSlotsUsedChanged.dispatch();
      }
      
      public function set ownerQuitCancelsGame(param1:Boolean) : void
      {
         this._ownerQuitCancelsGame = param1;
      }
      
      public function getParticipantIDCollection() : ArrayCollection
      {
         var _loc2_:InviteParticipant = null;
         var _loc1_:ArrayCollection = new ArrayCollection();
         var _loc3_:int = 0;
         while(_loc3_ < this.participants.length)
         {
            _loc2_ = this.participants[_loc3_] as InviteParticipant;
            if(InviteParticipantState.isMemberState(_loc2_.status))
            {
               _loc1_.addItem(_loc2_.summonerId);
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function get isAcceptingInvites() : Boolean
      {
         return this._isAcceptingInvites;
      }
      
      public function set pendingInvitesEnabled(param1:Boolean) : void
      {
         this._pendingInvitesEnabled = param1;
      }
      
      public function set chatRoom(param1:ChatRoom) : void
      {
         if(this._chatRoom == param1)
         {
            return;
         }
         this._chatRoom = param1;
         dispatchEvent(new Event("invites_chatRoomChanged"));
         this._chatRoomChangedSignal.dispatch(this.chatRoom);
      }
      
      [Bindable(event="isOwnerChanged")]
      public function get isOwner() : Boolean
      {
         return this._isOwner;
      }
      
      public function set pendingParticipants(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1059116329pendingParticipants;
         if(_loc2_ !== param1)
         {
            this._1059116329pendingParticipants = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pendingParticipants",_loc2_,param1));
         }
      }
      
      public function get isAcceptingInvitesChanged() : ISignal
      {
         return this._isAcceptingInvitesChanged;
      }
      
      [Bindable(event="propertyChange")]
      public function get invitedParticipants() : ArrayCollection
      {
         return this._395845051invitedParticipants;
      }
      
      [Bindable(event="isInviteActiveChanged")]
      public function get isInviteActive() : Boolean
      {
         return this._isInviteActive;
      }
      
      public function get ownerQuitCancelsGame() : Boolean
      {
         return this._ownerQuitCancelsGame;
      }
      
      public function getInviteStateChangedSignal() : ISignal
      {
         return this._inviteStateChangedSignal;
      }
      
      public function set numGuestSlots(param1:int) : void
      {
         this._numGuestSlots = param1;
         this._numGuestSlotsChanged.dispatch();
      }
      
      public function get pendingInvitesEnabled() : Boolean
      {
         return this._pendingInvitesEnabled;
      }
      
      public function getIsOwnerChangedSignal() : ISignal
      {
         return this._isOwnerChangedSignal;
      }
      
      public function addParticipant(param1:InviteParticipant) : void
      {
         var _loc2_:int = this.getParticipantIndex(param1);
         if(_loc2_ == -1)
         {
            this.participants.push(param1);
         }
         else
         {
            this.participants[_loc2_] = param1;
         }
         if(param1.isOwner)
         {
            param1.isInvitor = true;
         }
         if(this.gameType == GameType.PRACTICE_GAME)
         {
            param1.kickBanningEnabled = false;
         }
         this.refresh();
         this._invitedParticipantsChangedSignal.dispatch(param1);
      }
      
      private function invitedFilter(param1:Object) : Boolean
      {
         var _loc2_:InviteParticipant = param1 as InviteParticipant;
         if(_loc2_.status != InviteParticipantState.OWNER)
         {
            return true;
         }
         return false;
      }
      
      [Bindable(event="propertyChange")]
      public function get pendingParticipants() : ArrayCollection
      {
         return this._1059116329pendingParticipants;
      }
      
      private function getParticipantIndex(param1:InviteParticipant) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.participants.length)
         {
            if(this.participants[_loc2_].summonerId == param1.summonerId)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function set acceptedParticipants(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1734125799acceptedParticipants;
         if(_loc2_ !== param1)
         {
            this._1734125799acceptedParticipants = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"acceptedParticipants",_loc2_,param1));
         }
      }
      
      public function getParticipantByName(param1:String) : InviteParticipant
      {
         var _loc2_:InviteParticipant = null;
         for each(_loc2_ in this.participants)
         {
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      [Bindable(event="propertyChange")]
      public function get allParticipants() : ArrayCollection
      {
         return this._2000266271allParticipants;
      }
      
      public function get numGuestSlotsUsed() : int
      {
         return this._numGuestSlotsUsed;
      }
      
      public function get numGuestSlotsUsedChanged() : ISignal
      {
         return this._numGuestSlotsUsedChanged;
      }
      
      public function set allParticipants(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._2000266271allParticipants;
         if(_loc2_ !== param1)
         {
            this._2000266271allParticipants = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"allParticipants",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get acceptedParticipants() : ArrayCollection
      {
         return this._1734125799acceptedParticipants;
      }
      
      public function get allowedToInviteChanged() : ISignal
      {
         return this._allowedToInviteChanged;
      }
      
      public function get numGuestSlotsChanged() : ISignal
      {
         return this._numGuestSlotsChanged;
      }
      
      private function pendingFilter(param1:Object) : Boolean
      {
         var _loc2_:InviteParticipant = param1 as InviteParticipant;
         if(_loc2_.status == InviteParticipantState.PENDING)
         {
            return true;
         }
         return false;
      }
      
      public function getparticipantIDCollectionIncludingLeavers() : ArrayCollection
      {
         var _loc2_:InviteParticipant = null;
         var _loc3_:String = null;
         var _loc1_:ArrayCollection = new ArrayCollection();
         var _loc4_:int = 0;
         while(_loc4_ < this.participants.length)
         {
            _loc2_ = this.participants[_loc4_] as InviteParticipant;
            if(Boolean(InviteParticipantState.isMemberState(_loc2_.status)) || _loc2_.status == InviteParticipantState.QUIT || _loc2_.status == InviteParticipantState.REJECTED)
            {
               _loc3_ = _loc2_.jid.node.substring(3);
               _loc1_.addItem(new Number(_loc3_));
            }
            _loc4_++;
         }
         return _loc1_;
      }
      
      public function setChatProvider(param1:IChatProvider) : void
      {
         param1.getUserAvailableSignal().add(this.userAvailable);
      }
      
      public function refresh() : void
      {
         this.acceptedParticipants.refresh();
         this.invitedParticipants.refresh();
         this.pendingParticipants.refresh();
         this.allParticipants.refresh();
      }
      
      public function getInvitedParticipantsChangedSignal() : ISignal
      {
         return this._invitedParticipantsChangedSignal;
      }
      
      public function getAcceptedParticipantCount() : int
      {
         if(Boolean(this.acceptedParticipants))
         {
            return this.acceptedParticipants.length;
         }
         return 0;
      }
      
      public function getParticipant(param1:InviteParticipant) : InviteParticipant
      {
         var _loc2_:InviteParticipant = null;
         for each(_loc2_ in this.participants)
         {
            if(_loc2_.summonerId == param1.summonerId)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function acceptedFilter(param1:Object) : Boolean
      {
         var _loc2_:InviteParticipant = param1 as InviteParticipant;
         if(InviteParticipantState.isMemberState(_loc2_.status))
         {
            return true;
         }
         return false;
      }
   }
}

