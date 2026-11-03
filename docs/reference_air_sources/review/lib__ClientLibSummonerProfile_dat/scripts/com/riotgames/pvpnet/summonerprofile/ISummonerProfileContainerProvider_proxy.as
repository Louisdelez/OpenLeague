package com.riotgames.pvpnet.summonerprofile
{
   import blix.assets.proxy.DisplayAdapter;
   import com.riotgames.platform.proxy.IProxyObject;
   import com.riotgames.platform.proxy.ProxyObject;
   
   public class ISummonerProfileContainerProvider_proxy implements IProxyObject, ISummonerProfileContainerProvider
   {
      
      private var __proxy:ProxyObject = new ProxyObject();
      
      public function ISummonerProfileContainerProvider_proxy()
      {
         super();
      }
      
      public function __setTarget(param1:Object) : void
      {
         this.__proxy.__setTarget(param1);
      }
      
      public function showProfileContainer(param1:DisplayAdapter) : void
      {
         var _loc2_:* = null;
         _loc2_ = this.__proxy.__methodInvoke("showProfileContainer",[param1],_loc2_);
      }
      
      public function hideProfileContainer(param1:DisplayAdapter) : void
      {
         var _loc2_:* = null;
         _loc2_ = this.__proxy.__methodInvoke("hideProfileContainer",[param1],_loc2_);
      }
   }
}

