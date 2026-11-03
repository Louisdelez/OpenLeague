package com.riotgames.platform.common.provider
{
   import blix.signals.ISignal;
   import com.riotgames.platform.gameclient.chat.domain.PresenceStatusData;
   import com.riotgames.platform.provider.IProvider;
   
   public interface ISpectatorProvider extends IProvider
   {
      
      function spectateFeaturedGame(param1:Number, param2:String, param3:String, param4:int, param5:String) : void;
      
      function canDropInSpectate(param1:PresenceStatusData) : Boolean;
      
      function getSpectatingStateChangeSignal() : ISignal;
      
      function spectateSummoner(param1:String) : void;
   }
}

