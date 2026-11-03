package com.riotgames.pvpnet.invite.action
{
   import blix.action.BasicAction;
   import com.riotgames.platform.gameclient.chat.IChatRoomProvider;
   import com.riotgames.platform.gameclient.chat.IPresenceProvider;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.gameclient.chat.domain.ChatRoomType;
   import com.riotgames.platform.gameclient.domain.game.GameType;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import mx.resources.ResourceManager;
   import org.igniterealtime.xiff.conference.RoomOccupant;
   
   public class JoinInviteChatRoomAction extends BasicAction
   {
      
      private var _presenceProvider:IPresenceProvider;
      
      private var _chatRoom:ChatRoom;
      
      private var _chatController:IChatRoomProvider;
      
      private var _inviteGroup:InviteGroup;
      
      public function JoinInviteChatRoomAction(param1:IChatRoomProvider, param2:InviteGroup, param3:IPresenceProvider)
      {
         super(false);
         this._chatController = param1;
         this._inviteGroup = param2;
         this._presenceProvider = param3;
      }
      
      private function sortRoomByOwner(param1:Object, param2:Object, param3:Array = null) : int
      {
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:RoomOccupant = param1 as RoomOccupant;
         var _loc7_:RoomOccupant = param2 as RoomOccupant;
         _loc4_ = Boolean(this._inviteGroup.isParticipantOwner(_loc6_));
         _loc5_ = Boolean(this._inviteGroup.isParticipantOwner(_loc7_));
         if(_loc4_ == _loc5_)
         {
            return 0;
         }
         if(_loc4_)
         {
            return -1;
         }
         return 1;
      }
      
      public function getChatRoom() : ChatRoom
      {
         return this._chatRoom;
      }
      
      public function onChatRoomCreated(param1:ChatRoom) : void
      {
         this._chatRoom = param1;
         if(this._chatRoom != null)
         {
            this._chatRoom.join();
            this._presenceProvider.sendPresenceUpdateToChatRoom(this._chatRoom);
            this._chatRoom.setChatRoomSortFunction(this.sortRoomByOwner);
            this._chatRoom.subject = ResourceManager.getInstance().getString("resources","waitingForGameView_chatRoom_Subject");
            this._inviteGroup.chatRoom = this._chatRoom;
         }
         complete();
      }
      
      override protected function doInvocation() : void
      {
         var _loc1_:String = null;
         if(this._inviteGroup.gameType == GameType.PRACTICE_GAME)
         {
            _loc1_ = ChatRoomType.ARRANGING_PRACTICE;
         }
         else
         {
            _loc1_ = ChatRoomType.ARRANGING_GAME;
         }
         if(this._inviteGroup.groupId)
         {
            this._chatController.requestChatRoom(this._chatController.obfuscateChatRoom(this._inviteGroup.groupId,ChatRoomType.CAP),this._chatController.obfuscateChatRoom(this._inviteGroup.groupId,ChatRoomType.CAP),null,ChatRoomType.CAP,this.onChatRoomCreated);
         }
         else
         {
            this._chatController.requestChatRoom(this._chatController.obfuscateChatRoom(this._inviteGroup.inviteId,_loc1_),this._chatController.obfuscateChatRoom(this._inviteGroup.inviteId,_loc1_),this._inviteGroup.gamePassword,_loc1_,this.onChatRoomCreated);
         }
      }
   }
}

