package com.riotgames.pvpnet.docked
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import com.riotgames.platform.gameclient.chat.domain.Buddy;
   import com.riotgames.platform.provider.IProvider;
   
   public interface IDockedChatProvider extends IProvider
   {
      
      function dock(param1:DisplayObjectContainerProxy) : void;
      
      function showPrivateChatWindow(param1:Buddy) : void;
   }
}

