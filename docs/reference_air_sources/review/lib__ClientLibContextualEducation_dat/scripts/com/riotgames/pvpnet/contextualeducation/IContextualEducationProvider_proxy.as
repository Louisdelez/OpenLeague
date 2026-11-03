package com.riotgames.pvpnet.contextualeducation
{
   import blix.assets.proxy.SpriteProxy;
   import com.riotgames.platform.gameclient.domain.EndOfGameStats;
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.platform.proxy.IProxyObject;
   import com.riotgames.platform.proxy.ProxyFactory;
   import com.riotgames.platform.proxy.ProxyObject;
   
   public class IContextualEducationProvider_proxy implements IProxyObject, IContextualEducationProvider
   {
      
      private var __proxy:ProxyObject = new ProxyObject();
      
      public function IContextualEducationProvider_proxy()
      {
         super();
      }
      
      public function getContextualEducationDisplay() : SpriteProxy
      {
         var _loc1_:* = ProxyFactory.createProxy(SpriteProxy);
         _loc1_ = this.__proxy.__methodInvoke("getContextualEducationDisplay",[],_loc1_);
         return _loc1_ as SpriteProxy;
      }
      
      public function __setTarget(param1:Object) : void
      {
         this.__proxy.__setTarget(param1);
      }
      
      public function prepareTip(param1:PlayerParticipantStatsSummary, param2:Boolean, param3:EndOfGameStats) : Boolean
      {
         var _loc4_:* = null;
         _loc4_ = this.__proxy.__methodInvoke("prepareTip",[param1,param2,param3],_loc4_);
         return _loc4_ as Boolean;
      }
   }
}

