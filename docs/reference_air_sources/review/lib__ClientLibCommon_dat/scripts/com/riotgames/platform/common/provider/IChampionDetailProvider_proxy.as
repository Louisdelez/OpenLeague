package com.riotgames.platform.common.provider
{
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.proxy.IProxyObject;
   import com.riotgames.platform.proxy.ProxyObject;
   
   public class IChampionDetailProvider_proxy implements IProxyObject, IChampionDetailProvider
   {
      
      private var __proxy:ProxyObject = new ProxyObject();
      
      public function IChampionDetailProvider_proxy()
      {
         super();
      }
      
      public function displayChampionDetailView(param1:String, param2:Champion, param3:int = 0, param4:Boolean = false) : void
      {
         var _loc5_:* = null;
         _loc5_ = this.__proxy.__methodInvoke("displayChampionDetailView",[param1,param2,param3,param4],_loc5_);
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
   }
}

