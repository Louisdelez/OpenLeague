package com.riotgames.pvpnet.system.messaging
{
   import com.riotgames.platform.provider.proxy.ProviderProxyBase;
   
   public class BroadcastMessageControllerProxy extends ProviderProxyBase implements IBroadcastMessageProvider
   {
      
      private static var _instance:BroadcastMessageControllerProxy;
      
      public function BroadcastMessageControllerProxy()
      {
         super(IBroadcastMessageProvider);
      }
      
      public static function get instance() : BroadcastMessageControllerProxy
      {
         if(_instance == null)
         {
            _instance = new BroadcastMessageControllerProxy();
         }
         return _instance;
      }
      
      public function addMessageListener(param1:String, param2:Function) : void
      {
         _invoke("addMessageListener",[param1,param2]);
      }
      
      public function removeMessageListener(param1:String, param2:Function) : void
      {
         _invoke("removeMessageListener",[param1,param2]);
      }
   }
}

