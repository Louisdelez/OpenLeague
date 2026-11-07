package com.riotgames.pvpnet.championinventory.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.list.DataScroller;
   import blix.components.list.RendererFactory;
   import blix.components.scroll.ScrollPolicy;
   import blix.context.IContext;
   import blix.ds.IListX;
   import blix.ds.ListView;
   import blix.ds.ListX;
   import blix.layout.algorithms.VirtualizedTileLayout;
   import blix.layout.vo.HorizontalAlign;
   import blix.layout.vo.Padding;
   import flash.geom.Rectangle;
   
   public class ChampionInventoryListView extends SpriteProxy
   {
      
      private var _sizer:SpriteProxy;
      
      private var _championScroller:DataScroller;
      
      private var _rendererFactory:RendererFactory;
      
      public function ChampionInventoryListView(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._sizer = new SpriteProxy(this);
         this._sizer.getLayoutInvalidated().add(invalidateLayout);
         setTimelineChildByName("sizer",this._sizer);
         this._championScroller = new DataScroller(this);
         this._championScroller.setSelectionEnabled(false);
         this._championScroller.setMouseWheelEnabled(true);
         this._championScroller.setScrollPolicy(ScrollPolicy.ON);
         this._championScroller.setPadding(new Padding(0,0,0,0));
         setTimelineChildByName("championScroller",this._championScroller);
         var _loc1_:VirtualizedTileLayout = new VirtualizedTileLayout();
         _loc1_.setPadding(new Padding(8,6,0,6));
         _loc1_.setHGap(0);
         _loc1_.setVGap(6);
         _loc1_.setHorizontalAlign(HorizontalAlign.CENTER);
         this._championScroller.setLayoutAlgorithm(_loc1_);
         this._rendererFactory = new RendererFactory(ChampionInventoryListItemRenderer,[this]);
         this._championScroller.setDataProvider(new ListView(new ListX()));
         this._championScroller.setRendererFactory(this._rendererFactory);
         this._championScroller.getLayoutInvalidated().add(invalidateLayout);
      }
      
      public function setChampions(param1:IListX) : void
      {
         this._championScroller.setDataProvider(param1);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._championScroller.setExplicitPosition(this._sizer.getX(),this._sizer.getY());
         this._championScroller.setExplicitSize(this._sizer.getWidth(),this._sizer.getHeight());
         return super.updateLayout(param1,param2);
      }
   }
}

