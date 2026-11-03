package com.riotgames.pvpnet.suggestedplayers.factory
{
   import com.riotgames.pvpnet.suggestedplayers.model.SuggestedPlayersMetrics;
   
   public class SuggestedPlayersMetricsFactory
   {
      
      public function SuggestedPlayersMetricsFactory()
      {
         super();
      }
      
      public function createSuggestedPlayersMetrics(param1:Boolean, param2:Array, param3:Array, param4:Number, param5:Number) : SuggestedPlayersMetrics
      {
         var _loc6_:String = null;
         if(param1)
         {
            _loc6_ = SuggestedPlayersMetrics.GAME_STARTED;
         }
         else
         {
            _loc6_ = SuggestedPlayersMetrics.LOBBY_DISBANDED;
         }
         var _loc7_:SuggestedPlayersMetrics = new SuggestedPlayersMetrics();
         _loc7_.endState = _loc6_;
         _loc7_.suggestedPlayers = param2;
         _loc7_.inviteParticipants = param3;
         _loc7_.gameId = param4;
         _loc7_.queueId = param5;
         return _loc7_;
      }
   }
}

