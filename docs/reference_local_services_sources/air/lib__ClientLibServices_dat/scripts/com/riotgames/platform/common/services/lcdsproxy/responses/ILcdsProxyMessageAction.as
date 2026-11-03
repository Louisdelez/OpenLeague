package com.riotgames.platform.common.services.lcdsproxy.responses
{
   import blix.IDestructible;
   import blix.action.IAction;
   
   public interface ILcdsProxyMessageAction extends IAction, IDestructible
   {
      
      function set payload(param1:String) : void;
   }
}

