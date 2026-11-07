package com.riotgames.pvpnet.system.alerter
{
   import blix.action.IAction;
   import com.riotgames.platform.provider.IProvider;
   
   [GenerateProxy]
   public interface IAlerterProvider extends IProvider
   {
      
      function addAlert(param1:IAction) : void;
      
      function removeAlert(param1:IAction) : void;
      
      function getActiveAlerts() : Vector.<IAction>;
      
      function getAllAlerts() : Vector.<IAction>;
   }
}

