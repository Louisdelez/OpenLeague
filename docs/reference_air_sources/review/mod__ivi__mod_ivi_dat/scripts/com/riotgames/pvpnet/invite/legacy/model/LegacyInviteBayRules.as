package com.riotgames.pvpnet.invite.legacy.model
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.xmpp.data.invite.PresenceStatusXML;
   import com.riotgames.platform.gameclient.chat.IChatRoomProvider;
   import com.riotgames.platform.gameclient.chat.IChatRosterProvider;
   import com.riotgames.platform.gameclient.chat.RosterUtility;
   import com.riotgames.platform.gameclient.chat.controllers.PresenceController;
   import com.riotgames.platform.gameclient.chat.domain.PresenceStatusData;
   import com.riotgames.pvpnet.invite.IInviteController;
   import com.riotgames.pvpnet.invite.legacy.controller.InviteBayController;
   import com.riotgames.pvpnet.invite.legacy.enum.InviteSectionTypeEnums;
   import com.riotgames.pvpnet.invite.rules.IInviteBayRules;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.resources.ResourceManager;
   import org.igniterealtime.xiff.conference.RoomOccupant;
   import org.igniterealtime.xiff.data.Presence;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public class LegacyInviteBayRules extends EventDispatcher implements IInviteBayRules
   {
      
      public static const SECTION_INDEX_BUDDY_LIST:int = 0;
      
      public static const SECTION_INDEX_CHAT_ROOMS:int = 1;
      
      private var inviteController:IInviteController;
      
      private var _sectionLockedChangedSignal:Signal = new Signal();
      
      private var chatRosterProvider:IChatRosterProvider;
      
      private var _dataProvider:ArrayCollection;
      
      private var _availableInviteesChangedSignal:Signal = new Signal();
      
      private var _sectionNames:ArrayCollection = null;
      
      private var _sectionIndex:int = 0;
      
      private var _inviteBay:ArrayCollection;
      
      private var chatRoomProvider:IChatRoomProvider;
      
      private var _invitableBuddyListFilterString:String;
      
      private var _sectionChangedSignal:Signal = new Signal();
      
      private var _numGuestSlotsChangedSignal:Signal = new Signal();
      
      public function LegacyInviteBayRules(param1:ArrayCollection, param2:IChatRosterProvider, param3:IChatRoomProvider, param4:IInviteController)
      {
         super();
         this.availableInviteBay = param1;
         this.inviteController = param4;
         this.chatRosterProvider = param2;
         this.chatRoomProvider = param3;
         this.createAvailableInvitees();
      }
      
      private static function createRosterItem(param1:RoomOccupant) : RosterItemVO
      {
         var _loc2_:RosterItemVO = new RosterItemVO(param1.jid);
         _loc2_.online = true;
         _loc2_.displayName = param1.displayName;
         _loc2_.show = Presence.SHOW_CHAT;
         _loc2_.status = param1.status;
         return _loc2_;
      }
      
      public function set numGuestSlotsUsed(param1:int) : void
      {
      }
      
      public function get allowGuestInvites() : Boolean
      {
         return false;
      }
      
      public function getSectionChangedSignal() : ISignal
      {
         return this._sectionChangedSignal;
      }
      
      public function get availableInviteBay() : ArrayCollection
      {
         return this._inviteBay;
      }
      
      private function inviteesFilter(param1:Object) : Boolean
      {
         var _loc2_:RosterItemVO = param1 as RosterItemVO;
         if(!_loc2_)
         {
            return false;
         }
         if(this.isPlayerFiltered(_loc2_))
         {
            return false;
         }
         if(this.inviteController.hasAlreadyInvited(_loc2_))
         {
            return false;
         }
         if(!RosterUtility.isOnlineAndAvailableForInvite(_loc2_))
         {
            return false;
         }
         if(InviteBayController.isInAvailableList(_loc2_,this.availableInviteBay))
         {
            return false;
         }
         return true;
      }
      
      public function set availableInviteBay(param1:ArrayCollection) : void
      {
         if(this._inviteBay == param1)
         {
            return;
         }
         this._inviteBay = param1;
         dispatchEvent(new Event("availableInviteBayChanged"));
      }
      
      private function FillChatRooms(param1:ArrayCollection) : void
      {
         var _loc3_:RoomOccupant = null;
         var _loc4_:String = null;
         var _loc5_:PresenceStatusData = null;
         var _loc6_:RosterItemVO = null;
         param1.removeAll();
         var _loc2_:Dictionary = new Dictionary();
         for each(_loc3_ in this.chatRoomProvider.getAllOccupantsInChatRooms())
         {
            _loc4_ = _loc3_.show;
            if(_loc4_ == null)
            {
               _loc5_ = PresenceController.getPresenceData(_loc3_.status);
               _loc4_ = PresenceStatusXML.getStatusShowMode(_loc5_.gameType);
            }
            if(_loc4_ == Presence.SHOW_CHAT && !InviteBayController.isInAvailableList(_loc3_.rosterItem,this.availableInviteBay) && !_loc2_[_loc3_.displayName])
            {
               _loc6_ = _loc3_.rosterItem;
               if(!_loc3_.rosterItem.online || _loc3_.rosterItem.show == null)
               {
                  _loc6_ = createRosterItem(_loc3_);
               }
               if(!this.inviteController.isLocalPlayer(_loc6_))
               {
                  param1.addItem(_loc6_);
                  _loc2_[_loc3_.displayName] = true;
               }
            }
         }
      }
      
      private function FillBuddyList(param1:ArrayCollection) : void
      {
         param1.source = this.chatRosterProvider.getAllRosterItems();
      }
      
      public function get numGuestSlots() : int
      {
         return 0;
      }
      
      public function getInvitableBuddyListFilterString() : String
      {
         return this._invitableBuddyListFilterString;
      }
      
      public function get sectionLockedTooltip() : String
      {
         return "";
      }
      
      public function set availableInvitees(param1:ArrayCollection) : void
      {
         if(this._dataProvider == param1)
         {
            return;
         }
         this._dataProvider = param1;
         this._availableInviteesChangedSignal.dispatch();
         dispatchEvent(new Event("availableInviteesChanged"));
      }
      
      private function createAvailableInvitees() : void
      {
         var _loc1_:ArrayCollection = new ArrayCollection();
         if(this.sectionIndex == SECTION_INDEX_BUDDY_LIST)
         {
            this.FillBuddyList(_loc1_);
         }
         else
         {
            this.FillChatRooms(_loc1_);
         }
         _loc1_.sort = new Sort();
         _loc1_.sort.compareFunction = InviteBayController.alphabeticalCompareRosterItems;
         _loc1_.filterFunction = this.inviteesFilter;
         _loc1_.refresh();
         this.availableInvitees = _loc1_;
      }
      
      public function refreshAvailableInvitees() : void
      {
         if(this.availableInvitees)
         {
            this.availableInvitees.refresh();
         }
      }
      
      public function get sectionType() : String
      {
         return InviteSectionTypeEnums.SECTION_TYPE_TABS;
      }
      
      public function isPlayerFiltered(param1:RosterItemVO) : Boolean
      {
         if(this.getInvitableBuddyListFilterString() != null && this.getInvitableBuddyListFilterString() != "" && param1.displayName.toLowerCase().search(this.getInvitableBuddyListFilterString()) < 0)
         {
            return true;
         }
         return false;
      }
      
      public function getNumGuestSlotsChangedSignal() : ISignal
      {
         return this._numGuestSlotsChangedSignal;
      }
      
      public function get numGuestSlotsUsed() : int
      {
         return 0;
      }
      
      public function set sectionIndex(param1:int) : void
      {
         if(param1 == this._sectionIndex)
         {
            return;
         }
         this._sectionIndex = param1;
         this.createAvailableInvitees();
         this._sectionChangedSignal.dispatch();
      }
      
      public function get allowInviteByName() : Boolean
      {
         return true;
      }
      
      public function get sectionLocked() : Boolean
      {
         return false;
      }
      
      public function filterAvailableInviteList(param1:String) : void
      {
         this._invitableBuddyListFilterString = param1.toLowerCase();
         this.refreshAvailableInvitees();
      }
      
      public function get availableInvitees() : ArrayCollection
      {
         return this._dataProvider;
      }
      
      public function getSectionLockedChangedSignal() : ISignal
      {
         return this._sectionLockedChangedSignal;
      }
      
      public function invitePlayers(param1:ArrayCollection) : void
      {
         this.inviteController.checkAddInviteParticipants(param1.toArray());
      }
      
      public function get sectionIndex() : int
      {
         return this._sectionIndex;
      }
      
      public function get sectionNames() : ArrayCollection
      {
         if(this._sectionNames == null)
         {
            this._sectionNames = new ArrayCollection([ResourceManager.getInstance().getString("resources","invitePlayers_buddiesButton_label"),ResourceManager.getInstance().getString("resources","invitePlayers_chatRoomsButton_label")]);
         }
         return this._sectionNames;
      }
      
      public function getAvailableInviteesChangedSignal() : ISignal
      {
         return this._availableInviteesChangedSignal;
      }
      
      public function isPlayerGuest(param1:Number) : Boolean
      {
         return false;
      }
      
      public function set allowGuestInvites(param1:Boolean) : void
      {
      }
   }
}

