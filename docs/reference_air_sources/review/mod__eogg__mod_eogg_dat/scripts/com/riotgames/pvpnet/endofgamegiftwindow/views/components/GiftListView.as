package com.riotgames.pvpnet.endofgamegiftwindow.views.components
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.components.list.DataScroller;
   import blix.components.list.IRendererFactory;
   import blix.components.scroll.ScrollPolicy;
   import blix.context.IContext;
   import blix.ds.IListX;
   import blix.ds.ListX;
   import blix.layout.algorithms.VirtualizedVerticalLayout;
   import blix.layout.vo.HorizontalAlign;
   import blix.layout.vo.Padding;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.AvailableGiftCategory;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.IEndOfGameGift;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.components.giftlist.GiftListBucketHeader;
   import flash.geom.Rectangle;
   
   public class GiftListView extends DisplayObjectContainerProxy implements IGiftListView
   {
      
      public static const DATA_GROUP_LINKAGE:String = "assets.EmptySprite";
      
      private static const SCROLLER_WIDTH:Number = 220;
      
      private static const SCROLLER_HEIGHT:Number = 412;
      
      private var _selectionChanged:Signal = new Signal();
      
      private var _renderFactory:IRendererFactory;
      
      private var _listData:Vector.<AvailableGiftCategory>;
      
      private var _selectionList:IListX;
      
      private var _buckets:Vector.<GiftListBucketHeader> = new Vector.<GiftListBucketHeader>();
      
      private var _scrollListDataProvider:ListX = new ListX();
      
      private var _scrollerLayout:VirtualizedVerticalLayout = new VirtualizedVerticalLayout();
      
      private var _scroller:DataScroller;
      
      public function GiftListView(param1:IContext)
      {
         this._scrollerLayout.setGap(10);
         this._scrollerLayout.setPadding(new Padding(0));
         this._scrollerLayout.setHorizontalAlign(HorizontalAlign.LEFT);
         this._scroller = new DataScroller(param1);
         super(param1);
      }
      
      override protected function initializeDependencies() : void
      {
         this._renderFactory = getDependency(IRendererFactory);
         super.initializeDependencies();
         this._scroller.setRendererFactory(this._renderFactory);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         setTimelineChildByName("scroller",this._scroller);
         this._scroller.setScrollPolicy(ScrollPolicy.AUTO);
         this._scroller.setLayoutAlgorithm(this._scrollerLayout);
         this._scroller.setKineticScrolling(true);
         this._scroller.setMouseWheelEnabled(true);
         this._scroller.setScrollBarsAutoPosition(true);
         this._scroller.setSelectionEnabled(true);
         this._scroller.getSelectionBehavior().allowMultipleSelection = false;
         this._scroller.setExplicitSize(SCROLLER_WIDTH,SCROLLER_HEIGHT);
         this._scroller.getSelectionBehavior().getSelectedItemsChanged().add(this.onSelectionChanged);
      }
      
      public function getData() : *
      {
         return this._listData;
      }
      
      public function setData(param1:*) : void
      {
         var _loc3_:AvailableGiftCategory = null;
         var _loc4_:int = 0;
         var _loc5_:IEndOfGameGift = null;
         this._listData = Vector.<AvailableGiftCategory>(param1);
         this._selectionList = new ListX();
         var _loc2_:int = 0;
         while(_loc2_ < this._listData.length)
         {
            _loc3_ = this._listData[_loc2_];
            this._scrollListDataProvider.addItem(_loc3_.giftBucketHeaderData);
            _loc4_ = 0;
            while(_loc4_ < _loc3_.giftList.length)
            {
               _loc5_ = _loc3_.giftList[_loc4_];
               this._scrollListDataProvider.addItem(_loc5_);
               this._selectionList.addItem(_loc5_);
               _loc4_++;
            }
            _loc2_++;
         }
         this._scroller.setDataProvider(this._scrollListDataProvider);
         this._scroller.getSelectionBehavior().setRangeSelected(1,1,true,true);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._scroller.setExplicitSize(SCROLLER_WIDTH,SCROLLER_HEIGHT);
         return super.updateLayout(param1,param2);
      }
      
      public function getSelectionChanged() : ISignal
      {
         return this._selectionChanged;
      }
      
      private function onHeaderExpand(param1:GiftListBucketHeader) : void
      {
      }
      
      private function onHeaderCollapse(param1:GiftListBucketHeader) : void
      {
      }
      
      private function getHeaderIndex(param1:GiftListBucketHeader) : int
      {
         var _loc3_:GiftListBucketHeader = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._buckets.length)
         {
            _loc3_ = this._buckets[_loc2_];
            if(param1 == _loc3_)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      private function onSelectionChanged() : void
      {
         this._selectionChanged.dispatch(IEndOfGameGift(this._scroller.getSelectionBehavior().getSelectedItem()));
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
   }
}

