package com.riotgames.platform.gameclient.controllers
{
   import blix.signals.ISignal;
   
   public interface IGamePreloadController
   {
      
      function setDisplayStateChangeSignal(param1:ISignal) : void;
      
      function get isPreloadingEnabled() : Boolean;
   }
}

