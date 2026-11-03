package com.riotgames.pvpnet.invite.legacy.controller
{
   import com.riotgames.platform.gameclient.chat.IChatRosterProvider;
   import com.riotgames.pvpnet.invite.IInviteController;
   import com.riotgames.pvpnet.invite.rules.IInviteBayRules;
   import mx.collections.ArrayCollection;
   import mx.utils.ObjectUtil;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public class InviteBayController
   {
      
      public static const MAX_NUM_INVITE_BAY_PLAYERS:uint = 15;
      
      private var _inviteController:IInviteController;
      
      private var _availableInviteBay:ArrayCollection;
      
      private var _inviteRules:IInviteBayRules;
      
      private var _chatRosterProvider:IChatRosterProvider;
      
      public function InviteBayController(param1:ArrayCollection, param2:IInviteBayRules, param3:IChatRosterProvider, param4:IInviteController)
      {
         super();
         this._inviteRules = param2;
         this._availableInviteBay = param1;
         this._inviteController = param4;
         this._chatRosterProvider = param3;
      }
      
      public static function isInAvailableList(param1:RosterItemVO, param2:ArrayCollection) : Boolean
      {
         var _loc3_:RosterItemVO = null;
         if(param2)
         {
            for each(_loc3_ in param2)
            {
               if(_loc3_.jid.node == param1.jid.node)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public static function retrieveSummonerIdFromRosterItemVO(param1:RosterItemVO) : Number
      {
         var _loc2_:RegExp = /[^0-9]/;
         return parseInt(param1.uid.split(_loc2_).join(""));
      }
      
      public static function alphabeticalCompareRosterItems(param1:Object, param2:Object, param3:Array = null) : int
      {
         var _loc4_:RosterItemVO = null;
         var _loc5_:RosterItemVO = null;
         if(param1 is RosterItemVO && param2 is RosterItemVO)
         {
            _loc4_ = param1 as RosterItemVO;
            _loc5_ = param2 as RosterItemVO;
            return ObjectUtil.stringCompare(_loc4_.displayName,_loc5_.displayName,true);
         }
         return 0;
      }
      
      public function removePlayerFromInviteBay(param1:RosterItemVO) : void
      {
         if(!this.getAvailableInviteBay())
         {
            return;
         }
         if(this._inviteRules.isPlayerGuest(InviteBayController.retrieveSummonerIdFromRosterItemVO(param1)))
         {
            if(!this.removeGuestPlayer())
            {
               return;
            }
         }
         var _loc2_:int = int(this.getAvailableInviteBay().getItemIndex(param1));
         if(_loc2_ >= 0)
         {
            this.getAvailableInviteBay().removeItemAt(_loc2_);
         }
         _loc2_ = int(this._inviteController.pendingInviteList.getItemIndex(param1));
         if(_loc2_ >= 0)
         {
            this._inviteController.pendingInviteList.removeItemAt(_loc2_);
         }
         this._inviteRules.refreshAvailableInvitees();
      }
      
      public function addPlayersToInviteBay(param1:Array) : void
      {
         var _loc2_:RosterItemVO = null;
         for each(_loc2_ in param1)
         {
            this.addPlayerToInviteBay(_loc2_);
         }
      }
      
      public function addPlayerToInviteBay(param1:RosterItemVO) : void
      {
         if(this.getAvailableInviteBay().length >= InviteBayController.MAX_NUM_INVITE_BAY_PLAYERS)
         {
            return;
         }
         if(this._inviteRules.isPlayerGuest(InviteBayController.retrieveSummonerIdFromRosterItemVO(param1)))
         {
            if(!this.addGuestPlayer())
            {
               return;
            }
         }
         if(!this.getAvailableInviteBay().contains(param1))
         {
            this.getAvailableInviteBay().addItem(param1);
         }
         this._inviteController.addToPendingInviteList([param1]);
         this._inviteRules.refreshAvailableInvitees();
      }
      
      public function removeGuestPlayer() : Boolean
      {
         if(this._inviteRules.numGuestSlotsUsed <= 0)
         {
            return false;
         }
         --this._inviteRules.numGuestSlotsUsed;
         return true;
      }
      
      public function addGuestPlayer() : Boolean
      {
         if(this._inviteRules.numGuestSlotsUsed >= this._inviteRules.numGuestSlots)
         {
            return false;
         }
         this._inviteRules.numGuestSlotsUsed += 1;
         return true;
      }
      
      public function removePlayersFromInviteBay(param1:Array) : void
      {
         var _loc2_:RosterItemVO = null;
         for each(_loc2_ in param1)
         {
            this.removePlayerFromInviteBay(_loc2_);
         }
      }
      
      public function inviteAllPlayersInBay() : void
      {
         this._inviteRules.invitePlayers(this.getAvailableInviteBay());
      }
      
      public function isBuddy(param1:String) : Boolean
      {
         return this._chatRosterProvider.isSummonerBuddy(param1);
      }
      
      public function getAvailableInviteBay() : ArrayCollection
      {
         return this._availableInviteBay;
      }
   }
}

