package com.riotgames.pvpnet.game
{
   import blix.signals.ISignal;
   
   public interface IGamePreparationDelegate
   {
      
      function prepareForGame() : void;
      
      function getGamePreparationFinished() : ISignal;
   }
}

