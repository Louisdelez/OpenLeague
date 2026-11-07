package com.riotgames.platform.common.services.lcdsproxy.responses.factory
{
   import blix.action.IAction;
   
   public interface ILcdsProxyMessageActionFactory
   {
      
      function createAction(param1:String, param2:String) : IAction;
   }
}

