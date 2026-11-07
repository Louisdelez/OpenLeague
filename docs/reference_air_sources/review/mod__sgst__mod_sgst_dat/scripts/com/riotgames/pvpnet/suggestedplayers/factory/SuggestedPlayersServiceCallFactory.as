package com.riotgames.pvpnet.suggestedplayers.factory
{
   import blix.action.IAction;
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.platform.common.utils.encode.IEncode;
   import com.riotgames.pvpnet.suggestedplayers.actions.GetFriendsOfFriendsAction;
   import com.riotgames.pvpnet.suggestedplayers.actions.TrackSuggestedPlayersMetricsAction;
   import com.riotgames.pvpnet.suggestedplayers.model.SuggestedPlayersMetrics;
   
   public class SuggestedPlayersServiceCallFactory
   {
      
      private var _service:ILcdsProxyServiceMessenger;
      
      private var _encoder:IEncode;
      
      private var _decoder:IDecode;
      
      public function SuggestedPlayersServiceCallFactory(param1:ILcdsProxyServiceMessenger, param2:IEncode, param3:IDecode)
      {
         super();
         this._service = param1;
         this._encoder = param2;
         this._decoder = param3;
      }
      
      public function getFriendsOfFriendsAction(param1:int) : IAction
      {
         return new GetFriendsOfFriendsAction(this._service,param1,this._encoder,this._decoder);
      }
      
      public function getTrackSuggestedPlayersMetricsAction(param1:Boolean, param2:Array, param3:Array, param4:Number, param5:Number) : IAction
      {
         var _loc6_:SuggestedPlayersMetricsFactory = new SuggestedPlayersMetricsFactory();
         var _loc7_:SuggestedPlayersMetrics = _loc6_.createSuggestedPlayersMetrics(param1,param2,param3,param4,param5);
         return new TrackSuggestedPlayersMetricsAction(_loc7_);
      }
   }
}

