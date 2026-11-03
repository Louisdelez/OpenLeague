package com.riotgames.pvpnet.docked.chat.view.buddypanel
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.list.DataScroller;
   import blix.components.list.RendererFactory;
   import blix.components.scroll.ScrollPolicy;
   import blix.context.IContext;
   import blix.ds.ListView;
   import blix.layout.algorithms.VirtualizedVerticalLayout;
   import com.riotgames.platform.gameclient.chat.views.ChatViewMediator;
   import com.riotgames.rust.data.ListAdapter;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import mx.collections.ArrayCollection;
   
   public class BuddyPanelRecentPlayersView extends SpriteProxy
   {
      
      private var _chatViewMediator:ChatViewMediator;
      
      private var _recentPlayersDataScroller:DataScroller;
      
      private var _rendererFactory:RendererFactory;
      
      private var _recentPlayerListAdapter:ListAdapter;
      
      private var _recentPlayerList:ListView;
      
      public function BuddyPanelRecentPlayersView(param1:IContext)
      {
         super(param1,new Sprite());
      }
      
      override protected function initializeDependencies() : void
      {
         this._chatViewMediator = getDependency(ChatViewMediator);
         super.initializeDependencies();
      }
      
      override protected function createChildren() : void
      {
         this._recentPlayersDataScroller = new DataScroller(this);
         this._recentPlayersDataScroller.getLayoutInvalidated().add(invalidateLayout);
         this._recentPlayersDataScroller.setLinkage("ScrollContainer");
         this._recentPlayersDataScroller.setScrollPolicy(ScrollPolicy.AUTO);
         this._recentPlayersDataScroller.setScrollBarsAutoPosition(false);
         this._rendererFactory = new RendererFactory(BuddyPanelRecentPlayerRenderer,[this]);
         this._recentPlayersDataScroller.setRendererFactory(this._rendererFactory);
         var _loc1_:ArrayCollection = this._chatViewMediator.getRecentlyPlayedList();
         this._recentPlayerListAdapter = new ListAdapter(_loc1_);
         this._recentPlayerList = new ListView(this._recentPlayerListAdapter);
         this._recentPlayersDataScroller.setDataProvider(this._recentPlayerList);
         var _loc2_:VirtualizedVerticalLayout = new VirtualizedVerticalLayout();
         _loc2_.setGap(1);
         this._recentPlayersDataScroller.setLayoutAlgorithm(_loc2_);
         addChild(this._recentPlayersDataScroller);
         super.createChildren();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._recentPlayersDataScroller.setExplicitSize(param1,param2);
         return this._recentPlayersDataScroller.getScaledBounds();
      }
   }
}

