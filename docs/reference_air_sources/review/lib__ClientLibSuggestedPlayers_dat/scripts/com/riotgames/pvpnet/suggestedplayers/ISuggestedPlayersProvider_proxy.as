package com.riotgames.pvpnet.suggestedplayers
{
   import com.riotgames.platform.gameclient.domain.EndOfGameStats;
   import com.riotgames.platform.gameclient.domain.game.GameQueueConfig;
   import com.riotgames.platform.proxy.IProxyObject;
   import com.riotgames.platform.proxy.ProxyObject;
   import com.riotgames.pvpnet.suggestedplayers.model.SuggestedPlayer;
   import mx.collections.ArrayCollection;
   
   public class ISuggestedPlayersProvider_proxy implements IProxyObject, ISuggestedPlayersProvider
   {
      
      private var __proxy:ProxyObject = new ProxyObject();
      
      public function ISuggestedPlayersProvider_proxy()
      {
         super();
      }
      
      public function __setTarget(param1:Object) : void
      {
         this.__proxy.__setTarget(param1);
      }
      
      public function getSuggestedPlayerModels(param1:GameQueueConfig, param2:Function) : void
      {
         var _loc3_:* = null;
         _loc3_ = this.__proxy.__methodInvoke("getSuggestedPlayerModels",[param1,param2],_loc3_);
      }
      
      public function handleEndOfGameEvent(param1:EndOfGameStats) : void
      {
         var _loc2_:* = null;
         _loc2_ = this.__proxy.__methodInvoke("handleEndOfGameEvent",[param1],_loc2_);
      }
      
      public function declineSuggestedPlayerAndGetReplacement(param1:ArrayCollection, param2:SuggestedPlayer) : void
      {
         var _loc3_:* = null;
         _loc3_ = this.__proxy.__methodInvoke("declineSuggestedPlayerAndGetReplacement",[param1,param2],_loc3_);
      }
      
      public function updateSuggestedPlayerVisibility(param1:ArrayCollection) : void
      {
         var _loc2_:* = null;
         _loc2_ = this.__proxy.__methodInvoke("updateSuggestedPlayerVisibility",[param1],_loc2_);
      }
      
      public function notifyGameLaunched(param1:Number, param2:Number) : void
      {
         var _loc3_:* = null;
         _loc3_ = this.__proxy.__methodInvoke("notifyGameLaunched",[param1,param2],_loc3_);
      }
      
      public function notifyLobbyDisbanded(param1:Number) : void
      {
         var _loc2_:* = null;
         _loc2_ = this.__proxy.__methodInvoke("notifyLobbyDisbanded",[param1],_loc2_);
      }
      
      public function handlePlayerHonored(param1:String) : void
      {
         var _loc2_:* = null;
         _loc2_ = this.__proxy.__methodInvoke("handlePlayerHonored",[param1],_loc2_);
      }
      
      public function handlePlayerReported(param1:String) : void
      {
         var _loc2_:* = null;
         _loc2_ = this.__proxy.__methodInvoke("handlePlayerReported",[param1],_loc2_);
      }
   }
}

