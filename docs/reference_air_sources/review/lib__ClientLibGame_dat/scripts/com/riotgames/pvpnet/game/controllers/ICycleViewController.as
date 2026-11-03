package com.riotgames.pvpnet.game.controllers
{
   import com.riotgames.platform.gameclient.controllers.IViewController;
   
   public interface ICycleViewController extends IViewController
   {
      
      function initializeCycle() : void;
      
      function abortCycle() : void;
      
      function cleanupCycle() : void;
   }
}

