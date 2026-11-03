package com.riotgames.platform.gameclient.chat
{
   import blix.signals.ISignal;
   import com.riotgames.platform.provider.IProvider;
   
   public interface IChatStateProvider extends IProvider
   {
      
      function getCurrentState() : String;
      
      function getCurrentStateChanged() : ISignal;
   }
}

