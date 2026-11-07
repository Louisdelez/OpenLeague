package com.riotgames.pvpnet.CLS.views.rankingview
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.assignToolTip;
   import blix.components.tooltip.unassignToolTip;
   import blix.context.IContext;
   import com.riotgames.pvpnet.CLS.models.EmblemModel;
   import com.riotgames.pvpnet.CLS.views.tooltip.EmblemsToolTipHandler;
   import com.riotgames.pvpnet.CLS.views.tooltip.SingleLineToolTip;
   import com.riotgames.pvpnet.system.leagues.LeagueRank;
   import com.riotgames.pvpnet.system.leagues.LeagueTier;
   import flash.display.MovieClip;
   
   public class LeagueBadge extends StatefulView
   {
      
      private var _badge:StatefulView;
      
      private var _tier:LeagueTier;
      
      private var _rank:LeagueRank;
      
      private var _tooltipModel:EmblemModel;
      
      private var _tooltipHandler:EmblemsToolTipHandler;
      
      private var _tooltipHitArea:SpriteProxy;
      
      public function LeagueBadge(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:SingleLineToolTip = new SingleLineToolTip(this);
         this._badge = new StatefulView(this);
         setTimelineChildByName("badge",this._badge);
         this._tooltipHitArea = new SpriteProxy(this);
         this._tooltipHandler = new EmblemsToolTipHandler(_loc1_,1,0);
         this._badge.setTimelineChildByName("tooltipHitArea",this._tooltipHitArea);
         this._tooltipModel = new EmblemModel("","");
      }
      
      public function setBadgeState(param1:LeagueTier, param2:LeagueRank) : void
      {
         if(param1 != null)
         {
            this._tier = param1;
         }
         if(param2 != null)
         {
            this._rank = param2;
         }
         super.setCurrentState(this._tier.value());
         this._badge.setCurrentState(this._rank.value());
         unassignToolTip(this._tooltipHitArea);
         if(this.hasTooltip())
         {
            this._tooltipModel.title = this._tier.value() + " " + this._rank.value();
            assignToolTip(this._tooltipHitArea,this._tooltipModel,this._tooltipHandler);
         }
      }
      
      private function hasTooltip() : Boolean
      {
         return !this._tier || !this._tier.isApex();
      }
   }
}

