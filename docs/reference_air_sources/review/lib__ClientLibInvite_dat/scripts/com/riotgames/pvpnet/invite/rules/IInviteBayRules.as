package com.riotgames.pvpnet.invite.rules
{
   import blix.signals.ISignal;
   import mx.collections.ArrayCollection;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   [Bindable]
   public interface IInviteBayRules
   {
      
      function set numGuestSlotsUsed(param1:int) : void;
      
      function refreshAvailableInvitees() : void;
      
      function get numGuestSlotsUsed() : int;
      
      function get availableInviteBay() : ArrayCollection;
      
      function getSectionChangedSignal() : ISignal;
      
      function get sectionLocked() : Boolean;
      
      function set availableInviteBay(param1:ArrayCollection) : void;
      
      function get allowInviteByName() : Boolean;
      
      function getNumGuestSlotsChangedSignal() : ISignal;
      
      function set availableInvitees(param1:ArrayCollection) : void;
      
      function set sectionIndex(param1:int) : void;
      
      function filterAvailableInviteList(param1:String) : void;
      
      function get availableInvitees() : ArrayCollection;
      
      function isPlayerFiltered(param1:RosterItemVO) : Boolean;
      
      function get sectionNames() : ArrayCollection;
      
      function getInvitableBuddyListFilterString() : String;
      
      function invitePlayers(param1:ArrayCollection) : void;
      
      function get numGuestSlots() : int;
      
      function isPlayerGuest(param1:Number) : Boolean;
      
      function getSectionLockedChangedSignal() : ISignal;
      
      function get sectionLockedTooltip() : String;
      
      function set allowGuestInvites(param1:Boolean) : void;
      
      function getAvailableInviteesChangedSignal() : ISignal;
      
      function get allowGuestInvites() : Boolean;
      
      function get sectionIndex() : int;
      
      function get sectionType() : String;
   }
}

