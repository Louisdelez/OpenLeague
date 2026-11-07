package com.riotgames.pvpnet.watch
{
   import blix.assets.proxy.DisplayAdapter;
   import blix.context.IContext;
   import blix.signals.Signal;
   import com.riotgames.platform.common.view.IMainScreen;
   import com.riotgames.platform.provider.proxy.ProviderProxyBase;
   import flash.display.DisplayObjectContainer;
   
   public class WatchTabProviderProxy extends ProviderProxyBase implements IWatchTabProvider
   {
      
      private static var _instance:WatchTabProviderProxy;
      
      public function WatchTabProviderProxy()
      {
         super(IWatchTabProvider);
      }
      
      public static function get instance() : WatchTabProviderProxy
      {
         if(_instance == null)
         {
            _instance = new WatchTabProviderProxy();
         }
         return _instance;
      }
      
      public function isReplayModeChanged() : Signal
      {
         return _invoke("isReplayModeChanged");
      }
      
      public function createWatchButton(param1:String, param2:IContext, param3:Number, param4:String, param5:Boolean, param6:Boolean, param7:Boolean) : IWatchReplayButton
      {
         return _invoke("createWatchButton",[param1,param2,param3,param4,param5,param6,param7]);
      }
      
      public function getWatchTabScreen(param1:IContext) : IMainScreen
      {
         return _invoke("getWatchTabScreen",[param1]);
      }
      
      public function getDragOverlayAsset(param1:DisplayAdapter) : void
      {
         _invoke("getDragOverlayAsset",[param1]);
      }
      
      public function acceptDragDrop() : Boolean
      {
         return _invoke("acceptDragDrop");
      }
      
      public function addReplayToQueue(param1:Number) : void
      {
         _invoke("addReplayToQueue",[param1]);
      }
      
      public function setContentHolder(param1:DisplayObjectContainer) : void
      {
         _invoke("setContentHolder",[param1]);
      }
      
      public function setNavHolder(param1:DisplayObjectContainer) : void
      {
         _invoke("setNavHolder",[param1]);
      }
      
      public function isReplayMode() : Boolean
      {
         return _invoke("isReplayMode");
      }
      
      public function isEnabled() : Boolean
      {
         return _invoke("isEnabled");
      }
   }
}

