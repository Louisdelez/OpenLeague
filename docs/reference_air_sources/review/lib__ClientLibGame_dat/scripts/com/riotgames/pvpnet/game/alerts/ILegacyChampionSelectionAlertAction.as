package com.riotgames.pvpnet.game.alerts
{
   import blix.action.IAction;
   import blix.signals.ISignal;
   import com.riotgames.pvpnet.game.domain.EnterChampionSelectManager;
   
   public interface ILegacyChampionSelectionAlertAction extends IAction
   {
      
      function getOnPlayNow() : ISignal;
      
      function add(param1:EnterChampionSelectManager) : void;
      
      function remove() : void;
   }
}

