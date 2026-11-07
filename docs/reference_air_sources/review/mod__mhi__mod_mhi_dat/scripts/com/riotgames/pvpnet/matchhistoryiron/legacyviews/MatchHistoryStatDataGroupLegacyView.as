package com.riotgames.pvpnet.matchhistoryiron.legacyviews
{
   import blix.components.list.DataScroller;
   import blix.components.list.RendererFactory;
   import blix.components.scroll.ScrollPolicy;
   import blix.context.IContext;
   import blix.layout.algorithms.VirtualizedVerticalLayout;
   import blix.layout.vo.Padding;
   import com.riotgames.pvpnet.matchhistoryiron.legacyviews.renderer.MatchHistoryLegacyStatRenderer;
   import flash.geom.Rectangle;
   
   public class MatchHistoryStatDataGroupLegacyView extends DataScroller
   {
      
      private var _rendererFactory:RendererFactory = new RendererFactory(MatchHistoryLegacyStatRenderer,[this]);
      
      public function MatchHistoryStatDataGroupLegacyView(param1:IContext)
      {
         super(param1,null,this._rendererFactory);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:VirtualizedVerticalLayout = new VirtualizedVerticalLayout();
         _loc1_.setPadding(new Padding(0));
         _loc1_.setGap(0);
         setLayoutAlgorithm(_loc1_);
         dataGroup.setMouseEnabled(false);
         dataGroupBottom.setMouseEnabled(false);
         setScrollPolicy(ScrollPolicy.OFF);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         if(_scrollModel.getMax() <= 0)
         {
            setScrollPolicy(ScrollPolicy.OFF);
         }
         else
         {
            setScrollPolicy(ScrollPolicy.ON);
         }
         return super.updateLayout(param1,param2);
      }
   }
}

