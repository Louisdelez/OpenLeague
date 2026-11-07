package com.riotgames.platform.common.provider
{
   import com.riotgames.platform.gameclient.domain.reroll.PointSummary;
   import com.riotgames.platform.proxy.IProxyObject;
   import com.riotgames.platform.proxy.ProxyFactory;
   import com.riotgames.platform.proxy.ProxyObject;
   
   public class IRerollProvider_proxy implements IProxyObject, IRerollProvider
   {
      
      private var __proxy:ProxyObject = new ProxyObject();
      
      public function IRerollProvider_proxy()
      {
         super();
      }
      
      public function getMaxRerollCount() : uint
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("getMaxRerollCount",[],_loc1_);
         return _loc1_ as uint;
      }
      
      public function getRerollPoints() : uint
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("getRerollPoints",[],_loc1_);
         return _loc1_ as uint;
      }
      
      public function getPointsBalance(param1:Function, param2:Function, param3:Function) : void
      {
         var _loc4_:* = null;
         _loc4_ = this.__proxy.__methodInvoke("getPointsBalance",[param1,param2,param3],_loc4_);
      }
      
      public function getRerollCount() : uint
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("getRerollCount",[],_loc1_);
         return _loc1_ as uint;
      }
      
      public function getMaxRerollProgress() : uint
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("getMaxRerollProgress",[],_loc1_);
         return _loc1_ as uint;
      }
      
      public function useReroll(param1:Function, param2:Function, param3:Function) : void
      {
         var _loc4_:* = null;
         _loc4_ = this.__proxy.__methodInvoke("useReroll",[param1,param2,param3],_loc4_);
      }
      
      public function __setTarget(param1:Object) : void
      {
         this.__proxy.__setTarget(param1);
      }
      
      public function getRerollCached() : Boolean
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("getRerollCached",[],_loc1_);
         return _loc1_ as Boolean;
      }
      
      public function getPointSummary() : PointSummary
      {
         var _loc1_:* = ProxyFactory.createProxy(PointSummary);
         _loc1_ = this.__proxy.__methodInvoke("getPointSummary",[],_loc1_);
         return _loc1_ as PointSummary;
      }
      
      public function updateRerollCache() : void
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("updateRerollCache",[],_loc1_);
      }
      
      public function getRerollProgress() : uint
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("getRerollProgress",[],_loc1_);
         return _loc1_ as uint;
      }
      
      public function getRerollEnabled() : Boolean
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("getRerollEnabled",[],_loc1_);
         return _loc1_ as Boolean;
      }
      
      public function setPointSummary(param1:PointSummary) : void
      {
         var _loc2_:* = null;
         _loc2_ = this.__proxy.__methodInvoke("setPointSummary",[param1],_loc2_);
      }
   }
}

