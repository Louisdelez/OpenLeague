package com.riotgames.platform.gameclient.chat.views.chatpanel
{
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   
   public interface IGroupChatWindow extends IChatWindow
   {
      
      function set inviteEnabled(param1:Boolean) : void;
      
      function get disabled() : Boolean;
      
      function setupTimeout() : void;
      
      function get inviteEnabled() : Boolean;
      
      function get chatGroupWindowChatRoom() : ChatRoom;
      
      function set chatGroupWindowChatRoom(param1:ChatRoom) : void;
      
      function inviteToChat(param1:Array, param2:String, param3:String) : void;
      
      function set disabled(param1:Boolean) : void;
   }
}

