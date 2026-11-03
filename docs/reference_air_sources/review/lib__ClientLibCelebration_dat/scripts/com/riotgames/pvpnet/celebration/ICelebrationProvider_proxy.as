package com.riotgames.pvpnet.celebration
{
   import com.riotgames.platform.proxy.IProxyObject;
   import com.riotgames.platform.proxy.ProxyObject;
   
   public class ICelebrationProvider_proxy implements IProxyObject, ICelebrationProvider
   {
      
      private var __proxy:ProxyObject = new ProxyObject();
      
      public function ICelebrationProvider_proxy()
      {
         super();
      }
      
      public function __setTarget(param1:Object) : void
      {
         this.__proxy.__setTarget(param1);
      }
      
      public function showFirstTimeLeaverDialogue() : void
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("showFirstTimeLeaverDialogue",[],_loc1_);
      }
   }
}

