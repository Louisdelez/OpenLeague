package com.riotgames.platform.common.provider
{
   import com.riotgames.platform.proxy.IProxyObject;
   import com.riotgames.platform.proxy.ProxyObject;
   
   public class IFullScreenPopupProvider_proxy implements IProxyObject, IFullScreenPopupProvider
   {
      
      private var __proxy:ProxyObject = new ProxyObject();
      
      public function IFullScreenPopupProvider_proxy()
      {
         super();
      }
      
      public function __setTarget(param1:Object) : void
      {
         this.__proxy.__setTarget(param1);
      }
      
      public function close() : void
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("close",[],_loc1_);
      }
      
      public function displayFullScreenPopup(param1:String) : void
      {
         var _loc2_:* = null;
         _loc2_ = this.__proxy.__methodInvoke("displayFullScreenPopup",[param1],_loc2_);
      }
   }
}

