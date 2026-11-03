package com.riotgames.platform.gameclient.chat
{
   import blix.assets.proxy.DisplayAdapter;
   import com.riotgames.platform.provider.IProvider;
   
   public interface IChatViewProvider extends IProvider
   {
      
      function getChatRoomView(param1:DisplayAdapter) : IChatRoomView;
   }
}

