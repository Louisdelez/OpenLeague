package com.riotgames.platform.common.provider
{
   import com.riotgames.platform.proxy.IProxyObject;
   import com.riotgames.platform.proxy.ProxyObject;
   
   public class IMainScreenProvider_proxy implements IProxyObject, IMainScreenProvider
   {
      
      private var __proxy:ProxyObject = new ProxyObject();
      
      public function IMainScreenProvider_proxy()
      {
         super();
      }
      
      public function registerMainScreenFactory(param1:String, param2:Function) : void
      {
         var _loc3_:* = null;
         _loc3_ = this.__proxy.__methodInvoke("registerMainScreenFactory",[param1,param2],_loc3_);
      }
      
      public function __setTarget(param1:Object) : void
      {
         this.__proxy.__setTarget(param1);
      }
   }
}

