package com.riotgames.pvpnet.cap.actions
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.provider.MetricsProxy;
   import com.riotgames.pvpnet.cap.model.CapDemandBoardMetrics;
   
   public class CapTrackDemandBoardMetricsAction extends BasicAction
   {
      
      private static const DEMAND_BOARD_METRICS_IDENTIFIER:String = "pb__teambuilder__demand_board";
      
      private var _metrics:CapDemandBoardMetrics;
      
      public function CapTrackDemandBoardMetricsAction(param1:CapDemandBoardMetrics)
      {
         this._metrics = param1;
         super(false);
      }
      
      override protected function doInvocation() : void
      {
         super.doInvocation();
         MetricsProxy.instance.track(DEMAND_BOARD_METRICS_IDENTIFIER,this._metrics.toObject());
      }
   }
}

