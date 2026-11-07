package com.riotgames.pvpnet.cap.observers
{
   import blix.IDestructible;
   
   public interface IObserver extends IDestructible
   {
      
      function refresh() : void;
      
      function setupSignals() : void;
      
      function removeSignals() : void;
   }
}

