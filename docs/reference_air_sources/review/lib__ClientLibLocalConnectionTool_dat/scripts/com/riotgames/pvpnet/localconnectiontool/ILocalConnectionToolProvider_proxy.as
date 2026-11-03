package com.riotgames.pvpnet.localconnectiontool
{
   import com.riotgames.platform.proxy.IProxyObject;
   import com.riotgames.platform.proxy.ProxyObject;
   
   public class ILocalConnectionToolProvider_proxy implements IProxyObject, ILocalConnectionToolProvider
   {
      
      private var __proxy:ProxyObject = new ProxyObject();
      
      public function ILocalConnectionToolProvider_proxy()
      {
         super();
      }
      
      public function __setTarget(param1:Object) : void
      {
         this.__proxy.__setTarget(param1);
      }
   }
}

