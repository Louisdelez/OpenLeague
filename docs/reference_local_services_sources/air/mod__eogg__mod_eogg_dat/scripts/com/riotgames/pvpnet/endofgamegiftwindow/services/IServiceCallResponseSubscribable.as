package com.riotgames.pvpnet.endofgamegiftwindow.services
{
   import blix.signals.ISignal;
   
   public interface IServiceCallResponseSubscribable
   {
      
      function serviceCallResponseReceived() : ISignal;
      
      function serviceUnavailable() : ISignal;
   }
}

