package com.riotgames.pvpnet.game.alerts
{
   import blix.action.IAction;
   import blix.signals.ISignal;
   import com.riotgames.pvpnet.game.domain.GameAFKStatus;
   
   public interface IAFKFilterChampionSelectionAlertAction extends IAction
   {
      
      function getMatchAccepted() : ISignal;
      
      function getMatchDeclined() : ISignal;
      
      function getDialogClosed() : ISignal;
      
      function add(param1:GameAFKStatus, param2:String, param3:Boolean = false) : void;
      
      function remove() : void;
      
      function updateForLobbyReturn() : void;
   }
}

