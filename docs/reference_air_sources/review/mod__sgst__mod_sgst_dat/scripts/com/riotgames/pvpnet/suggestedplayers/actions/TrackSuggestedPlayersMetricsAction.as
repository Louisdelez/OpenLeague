package com.riotgames.pvpnet.suggestedplayers.actions
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.suggestedplayers.model.SuggestedPlayersMetrics;
   import com.riotgames.pvpnet.tracking.Dradis;
   
   public class TrackSuggestedPlayersMetricsAction extends BasicAction
   {
      
      public static const DRADIS_IDENTIFIER:String = "pb__suggested_players";
      
      private var _metrics:SuggestedPlayersMetrics;
      
      public function TrackSuggestedPlayersMetricsAction(param1:SuggestedPlayersMetrics)
      {
         super(false);
         this._metrics = param1;
      }
      
      override protected function doInvocation() : void
      {
         super.doInvocation();
         Dradis.track(DRADIS_IDENTIFIER,this._metrics.toObject());
      }
   }
}

