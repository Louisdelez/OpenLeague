package com.riotgames.platform.gameclient.chat
{
   import blix.assets.proxy.IDisplayChild;
   import blix.view.IView;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   
   public interface IChatRoomView extends IDisplayChild, IView
   {
      
      function setModel(param1:ChatRoom) : void;
   }
}

