package com.riotgames.platform.common.provider
{
   import blix.signals.ISignal;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.contextAlert.AlertParameters;
   import com.riotgames.platform.gameclient.domain.inventory.ActiveBoosts;
   import com.riotgames.platform.provider.IProvider;
   import com.riotgames.pvpnet.system.alerter.IAlerterProvider;
   
   public interface IChromeContextAlertProvider extends IProvider
   {
      
      function getActiveAlert() : AlertParameters;
      
      function runStoreScript() : void;
      
      function runExpiredBoostScript(param1:ActiveBoosts) : void;
      
      function getActiveAlertChanged() : ISignal;
      
      function getAlertDismissedByUser() : ISignal;
      
      function initialize(param1:IInventoryController, param2:Session, param3:IAlerterProvider) : void;
      
      function removeAlert(param1:AlertParameters) : void;
      
      function showAlertForParameters(param1:AlertParameters) : void;
   }
}

