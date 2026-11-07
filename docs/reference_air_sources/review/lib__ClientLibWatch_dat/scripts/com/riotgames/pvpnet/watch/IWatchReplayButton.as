package com.riotgames.pvpnet.watch
{
   import blix.IDestructible;
   
   public interface IWatchReplayButton extends IDestructible
   {
      
      function removeFromParent() : void;
      
      function addToParent(param1:*) : void;
   }
}

