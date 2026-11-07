package com.riotgames.platform.gameclient.chat.mediator
{
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.gameclient.chat.trackers.GroupChatBehaviorTracker;
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   import mx.resources.ResourceManager;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public class IronGroupChatHandler implements IGroupChatHandler
   {
      
      private var _chatRoomMap:Dictionary = new Dictionary();
      
      private var _totalChatViews:ArrayCollection;
      
      public function IronGroupChatHandler(param1:ArrayCollection)
      {
         super();
         this._totalChatViews = param1;
      }
      
      public function openChatRoom(param1:ChatRoom) : void
      {
         if(!this.hasRoom(param1.roomName))
         {
            this._chatRoomMap[param1.roomName.toLowerCase()] = param1;
            this._totalChatViews.addItem(param1);
         }
      }
      
      public function handleChatSpamError(param1:String) : void
      {
         var _loc2_:ChatRoom = this.getRoomByName(param1);
         if(_loc2_ != null)
         {
            _loc2_.triggerChatSuspension();
         }
      }
      
      public function closeAllRooms() : void
      {
         var _loc1_:ChatRoom = null;
         var _loc2_:int = 0;
         for each(_loc1_ in this._chatRoomMap)
         {
            _loc2_ = int(this._totalChatViews.getItemIndex(_loc1_));
            if(_loc2_ >= 0)
            {
               this._totalChatViews.removeItemAt(_loc2_);
            }
         }
         this._chatRoomMap = new Dictionary();
      }
      
      public function closeChatRoom(param1:ChatRoom) : void
      {
         if(!param1 || param1.roomName == null)
         {
            return;
         }
         var _loc2_:int = int(this._totalChatViews.getItemIndex(param1));
         if(_loc2_ >= 0)
         {
            this._totalChatViews.removeItemAt(_loc2_);
         }
         delete this._chatRoomMap[param1.roomName.toLowerCase()];
      }
      
      public function hasRoom(param1:String) : Boolean
      {
         return this.getRoomByName(param1) != null;
      }
      
      private function getRoomByName(param1:String) : ChatRoom
      {
         return this._chatRoomMap[param1.toLowerCase()];
      }
      
      public function inviteToChat(param1:String, param2:Array, param3:String, param4:String) : void
      {
         var _loc6_:RosterItemVO = null;
         var _loc5_:ChatRoom = this.getRoomByName(param1);
         if(!param3)
         {
            param3 = ResourceManager.getInstance().getString("resources","chat_inviteBay_defaultInviteReason");
         }
         if(_loc5_)
         {
            for each(_loc6_ in param2)
            {
               _loc5_.invite(_loc6_,param3,param4);
            }
         }
         GroupChatBehaviorTracker.instance.incrementInvitedPeople_InASession(_loc5_.getRoomJID());
      }
   }
}

