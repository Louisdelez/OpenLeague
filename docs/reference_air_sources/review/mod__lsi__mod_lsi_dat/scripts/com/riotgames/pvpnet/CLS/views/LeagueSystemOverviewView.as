package com.riotgames.pvpnet.CLS.views
{
   import blix.assets.proxy.IDisplayChild;
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.CLS.views.rankingview.MyLeaguesOverview;
   import com.riotgames.pvpnet.seasonrewards.ISeasonRewardsProvider;
   
   public class LeagueSystemOverviewView extends SpriteProxy
   {
      
      private var _panel1:SpriteProxy;
      
      private var _panel2:SpriteProxy;
      
      private var _panel3:SpriteProxy;
      
      private var _seasonRewardsProvider:ISeasonRewardsProvider;
      
      public function LeagueSystemOverviewView(param1:IContext)
      {
         super(param1);
         setLinkage("SystemOverview");
      }
      
      override protected function createChildren() : void
      {
         this._panel1 = new SpriteProxy(this);
         setTimelineChildByName("panel1",this._panel1);
         this._panel2 = new SpriteProxy(this);
         setTimelineChildByName("panel2",this._panel2);
         this._panel3 = new SpriteProxy(this);
         setTimelineChildByName("panel3",this._panel3);
         ProviderLookup.getProvider(ISeasonRewardsProvider,this.handleSeasonsRewardsProvider);
      }
      
      private function handleSeasonsRewardsProvider(param1:ISeasonRewardsProvider) : void
      {
         this._seasonRewardsProvider = param1;
         var _loc2_:IDisplayChild = param1.getTeamRewardsView();
         var _loc3_:IDisplayChild = param1.getTierRewardsView();
         var _loc4_:MyLeaguesOverview = new MyLeaguesOverview(this);
         this._panel1.addChild(_loc2_);
         this._panel2.addChild(_loc3_);
         this._panel3.addChild(_loc4_);
      }
   }
}

