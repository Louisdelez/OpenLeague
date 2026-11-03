package com.riotgames.pvpnet.chrome
{
   import blix.assets.proxy.DisplayAdapter;
   import com.riotgames.platform.proxy.IProxyObject;
   import com.riotgames.platform.proxy.ProxyObject;
   
   public class IChromeProvider_proxy implements IProxyObject, IChromeProvider
   {
      
      private var __proxy:ProxyObject = new ProxyObject();
      
      public function IChromeProvider_proxy()
      {
         super();
      }
      
      public function __setTarget(param1:Object) : void
      {
         this.__proxy.__setTarget(param1);
      }
      
      public function addFrame(param1:DisplayAdapter) : void
      {
         var _loc2_:* = null;
         _loc2_ = this.__proxy.__methodInvoke("addFrame",[param1],_loc2_);
      }
      
      public function addWindowControls(param1:DisplayAdapter) : void
      {
         var _loc2_:* = null;
         _loc2_ = this.__proxy.__methodInvoke("addWindowControls",[param1],_loc2_);
      }
      
      public function registerCloseRequestedResponder(param1:Function) : void
      {
         var _loc2_:* = null;
         _loc2_ = this.__proxy.__methodInvoke("registerCloseRequestedResponder",[param1],_loc2_);
      }
      
      public function navigationReady() : void
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("navigationReady",[],_loc1_);
      }
   }
}

