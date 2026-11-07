package com.riotgames.platform.gameclient.chat.actions
{
   import blix.action.BasicAction;
   import com.riotgames.platform.gameclient.chat.IChatRoomProvider;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   
   public class CreateChatRoomAction extends BasicAction
   {
      
      private var _chatController:IChatRoomProvider;
      
      private var _chatRoomType:String;
      
      private var _chatRoomPassword:String;
      
      private var _chatRoom:ChatRoom;
      
      private var _chatRoomName:String;
      
      public function CreateChatRoomAction(param1:IChatRoomProvider, param2:String, param3:String, param4:String)
      {
         super(false);
         this._chatController = param1;
         this._chatRoomName = param2;
         this._chatRoomType = param4;
         this._chatRoomPassword = param3;
      }
      
      public function get chatRoom() : ChatRoom
      {
         return this._chatRoom;
      }
      
      private function onChatRoomCreated(param1:ChatRoom) : void
      {
         this._chatRoom = param1;
         complete();
      }
      
      override protected function doInvocation() : void
      {
         this._chatController.requestChatRoom(this._chatController.obfuscateChatRoom(this._chatRoomName,this._chatRoomType),this._chatController.obfuscateChatRoom(this._chatRoomName,this._chatRoomType),this._chatRoomPassword,this._chatRoomType,this.onChatRoomCreated);
      }
   }
}

