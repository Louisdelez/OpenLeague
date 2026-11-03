package com.riotgames.pvpnet.tips
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.InteractiveObjectProxy;
   import blix.components.tooltip.IToolTipManager;
   import com.riotgames.platform.provider.proxy.ProviderProxyBase;
   import com.riotgames.pvpnet.tips.config.ToolTipConfig;
   import flash.display.InteractiveObject;
   import flash.display.Stage;
   
   public class TipsProviderProxy extends ProviderProxyBase implements ITipsProvider
   {
      
      private static var _instance:TipsProviderProxy;
      
      public function TipsProviderProxy()
      {
         super(ITipsProvider);
      }
      
      public static function get instance() : TipsProviderProxy
      {
         if(_instance == null)
         {
            _instance = new TipsProviderProxy();
         }
         return _instance;
      }
      
      public function createWindowToolTipManager(param1:DisplayObjectContainerProxy, param2:ToolTipConfig = null) : IToolTipManager
      {
         return _invoke("createWindowToolTipManager",[param1,param2]);
      }
      
      public function assignCustomToolTip(param1:InteractiveObjectProxy, param2:*, param3:Class, param4:ToolTipConfig = null) : void
      {
         _invoke("assignCustomToolTip",[param1,param2,param3,param4]);
      }
      
      public function registerDeprecatedToolTipManager(param1:Stage, param2:ToolTipConfig = null) : void
      {
         _invoke("registerDeprecatedToolTipManager",[param1,param2]);
      }
      
      public function assignDeprecatedToolTip(param1:InteractiveObject, param2:String) : void
      {
         _invoke("assignDeprecatedToolTip",[param1,param2]);
      }
   }
}

