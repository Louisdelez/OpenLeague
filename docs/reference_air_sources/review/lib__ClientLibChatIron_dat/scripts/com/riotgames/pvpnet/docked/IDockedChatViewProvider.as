package com.riotgames.pvpnet.docked
{
   import com.riotgames.platform.provider.IProvider;
   
   public interface IDockedChatViewProvider extends IProvider
   {
      
      function getDockedChatView() : IDockedChatView;
   }
}

