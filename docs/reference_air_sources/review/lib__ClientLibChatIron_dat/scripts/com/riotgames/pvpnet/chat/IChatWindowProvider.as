package com.riotgames.pvpnet.chat
{
   import com.riotgames.platform.provider.IProvider;
   import com.riotgames.pvpnet.chat.model.ChatWindowModel;
   
   public interface IChatWindowProvider extends IProvider
   {
      
      function getPersonalChatWindow(param1:ChatWindowModel) : IDockedMessageWindow;
   }
}

