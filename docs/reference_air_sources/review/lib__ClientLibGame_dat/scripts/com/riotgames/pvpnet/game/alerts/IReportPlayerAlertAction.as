package com.riotgames.pvpnet.game.alerts
{
   import blix.action.IAction;
   import com.riotgames.platform.common.IReportTracker;
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   
   public interface IReportPlayerAlertAction extends IAction
   {
      
      function add(param1:PlayerParticipantStatsSummary, param2:Number, param3:IReportTracker) : void;
   }
}

