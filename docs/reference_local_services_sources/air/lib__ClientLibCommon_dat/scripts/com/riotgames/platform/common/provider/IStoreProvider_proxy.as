package com.riotgames.platform.common.provider
{
   import blix.signals.ISignal;
   import com.riotgames.platform.proxy.IProxyObject;
   import com.riotgames.platform.proxy.ProxyFactory;
   import com.riotgames.platform.proxy.ProxyObject;
   
   public class IStoreProvider_proxy implements IProxyObject, IStoreProvider
   {
      
      private var __proxy:ProxyObject = new ProxyObject();
      
      public function IStoreProvider_proxy()
      {
         super();
      }
      
      public function getStoreUrlReady() : Boolean
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("getStoreUrlReady",[],_loc1_);
         return _loc1_ as Boolean;
      }
      
      public function getIsStoreAvailable() : Boolean
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("getIsStoreAvailable",[],_loc1_);
         return _loc1_ as Boolean;
      }
      
      public function refreshStoreUrl(param1:Boolean = false) : void
      {
         var _loc2_:* = null;
         _loc2_ = this.__proxy.__methodInvoke("refreshStoreUrl",[param1],_loc2_);
      }
      
      public function getCurrentStoreUrl(param1:String = "", param2:String = "") : String
      {
         var _loc3_:* = null;
         _loc3_ = this.__proxy.__methodInvoke("getCurrentStoreUrl",[param1,param2],_loc3_);
         return _loc3_ as String;
      }
      
      public function openInventoryBrowser(param1:String, param2:String = "", param3:String = "", param4:Boolean = false) : void
      {
         var _loc5_:* = null;
         _loc5_ = this.__proxy.__methodInvoke("openInventoryBrowser",[param1,param2,param3,param4],_loc5_);
      }
      
      public function __setTarget(param1:Object) : void
      {
         this.__proxy.__setTarget(param1);
      }
      
      public function discardToken() : void
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("discardToken",[],_loc1_);
      }
      
      public function getStoreUrlReadyChanged() : ISignal
      {
         var _loc1_:* = ProxyFactory.createProxy(ISignal);
         _loc1_ = this.__proxy.__methodInvoke("getStoreUrlReadyChanged",[],_loc1_);
         return _loc1_ as ISignal;
      }
   }
}

