package com.riotgames.pvpnet.docked
{
   import com.riotgames.platform.provider.IProvider;
   
   public interface IBuddyPanelProvider extends IProvider
   {
      
      function getBuddyPanel() : IBuddyPanel;
   }
}

