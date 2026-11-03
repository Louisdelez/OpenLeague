package com.riotgames.pvpnet.cap.actions
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.provider.MetricsProxy;
   import com.riotgames.pvpnet.cap.model.CapPlayAgainMetrics;
   
   public class CapTrackEnhancedPlayAgainMetricsAction extends BasicAction
   {
      
      private static const ENHANCED_PLAY_AGAIN_IDENTIFIER:String = "pb__teambuilder__enhanced_play_again";
      
      private var _metrics:CapPlayAgainMetrics;
      
      public function CapTrackEnhancedPlayAgainMetricsAction(param1:CapPlayAgainMetrics)
      {
         this._metrics = param1;
         super(false);
      }
      
      override protected function doInvocation() : void
      {
         super.doInvocation();
         var _loc1_:Object = this._metrics.toObject();
         MetricsProxy.instance.track(ENHANCED_PLAY_AGAIN_IDENTIFIER,_loc1_);
      }
   }
}

