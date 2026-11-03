package com.riotgames.pvpnet.endofgamegiftwindow
{
   import blix.context.IContext;
   import com.riotgames.platform.common.view.IMainScreen;
   import com.riotgames.platform.provider.IProvider;
   import com.riotgames.pvpnet.endofgamegiftwindow.controllers.IEndOfGameGiftWindowController;
   
   public interface IEndOfGameGiftWindowProvider extends IProvider, IMainScreen, IEndOfGameGiftWindowController
   {
      
      function initializeEndOfGameGiftWindow(param1:IContext) : void;
   }
}

