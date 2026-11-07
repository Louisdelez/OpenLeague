package com.riotgames.pvpnet.spells
{
   import blix.assets.proxy.DisplayAdapter;
   import com.riotgames.platform.gameclient.domain.SummonerLevel;
   import com.riotgames.platform.proxy.IProxyObject;
   import com.riotgames.platform.proxy.ProxyObject;
   
   public class ISpellsProvider_proxy implements IProxyObject, ISpellsProvider
   {
      
      private var __proxy:ProxyObject = new ProxyObject();
      
      public function ISpellsProvider_proxy()
      {
         super();
      }
      
      public function __setTarget(param1:Object) : void
      {
         this.__proxy.__setTarget(param1);
      }
      
      public function show(param1:DisplayAdapter, param2:SummonerLevel) : void
      {
         var _loc3_:* = null;
         _loc3_ = this.__proxy.__methodInvoke("show",[param1,param2],_loc3_);
      }
      
      public function hide() : void
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("hide",[],_loc1_);
      }
   }
}

