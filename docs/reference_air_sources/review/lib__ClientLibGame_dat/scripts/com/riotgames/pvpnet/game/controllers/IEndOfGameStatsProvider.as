package com.riotgames.pvpnet.game.controllers
{
   import blix.signals.ISignal;
   import com.riotgames.platform.provider.IProvider;
   
   public interface IEndOfGameStatsProvider extends IProvider
   {
      
      function getTutorialGameComplete() : ISignal;
   }
}

