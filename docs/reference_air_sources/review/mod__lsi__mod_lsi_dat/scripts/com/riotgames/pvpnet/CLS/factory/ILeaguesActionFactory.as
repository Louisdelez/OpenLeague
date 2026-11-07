package com.riotgames.pvpnet.CLS.factory
{
   import blix.action.IAction;
   
   public interface ILeaguesActionFactory
   {
      
      function getRetrieveInProgressGameSpectatorInfoAction(param1:String) : IAction;
      
      function getRetrieveDropInSpectateAvailabilityAction(param1:Vector.<String>) : IAction;
   }
}

