package com.riotgames.platform.common.provider
{
   import blix.signals.ISignal;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.contextAlert.AlertParameters;
   import com.riotgames.platform.gameclient.domain.inventory.ActiveBoosts;
   import com.riotgames.platform.provider.proxy.ProviderProxyBase;
   import com.riotgames.pvpnet.system.alerter.IAlerterProvider;
   
   public class ChromeContextAlertProviderProxy extends ProviderProxyBase implements IChromeContextAlertProvider
   {
      
      private static var _instance:ChromeContextAlertProviderProxy;
      
      public function ChromeContextAlertProviderProxy()
      {
         super(IChromeContextAlertProvider);
      }
      
      public static function get instance() : ChromeContextAlertProviderProxy
      {
         if(_instance == null)
         {
            _instance = new ChromeContextAlertProviderProxy();
         }
         return _instance;
      }
      
      public function getActiveAlert() : AlertParameters
      {
         return _invoke("getActiveAlert");
      }
      
      public function showAlertForParameters(param1:AlertParameters) : void
      {
         _invoke("showAlertForParameters",[param1]);
      }
      
      public function getAlertDismissedByUser() : ISignal
      {
         return _getSignal("getAlertDismissedByUser");
      }
      
      public function runStoreScript() : void
      {
         _invoke("runStoreScript");
      }
      
      public function initialize(param1:IInventoryController, param2:Session, param3:IAlerterProvider) : void
      {
         _invoke("initialize",[param1,param2,param3]);
      }
      
      public function getActiveAlertChanged() : ISignal
      {
         return _getSignal("getActiveAlertChanged");
      }
      
      public function runExpiredBoostScript(param1:ActiveBoosts) : void
      {
         _invoke("runExpiredBoostScript",[param1]);
      }
      
      public function removeAlert(param1:AlertParameters) : void
      {
         _invoke("removeAlert",[param1]);
      }
   }
}

