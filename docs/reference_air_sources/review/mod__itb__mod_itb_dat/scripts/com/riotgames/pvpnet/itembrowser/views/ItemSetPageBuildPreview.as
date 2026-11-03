package com.riotgames.pvpnet.itembrowser.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.list.DataScroller;
   import blix.components.list.MultiRendererFactory;
   import blix.components.scroll.ScrollPolicy;
   import blix.context.IContext;
   import blix.ds.ListX;
   import blix.layout.LayoutEntry;
   import blix.layout.algorithms.VirtualizedVerticalLayout;
   import blix.layout.vo.HorizontalAlign;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSet;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetBlock;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetsModel;
   import com.riotgames.util.vector.vectorToArray;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class ItemSetPageBuildPreview extends SpriteProxy
   {
      
      private var blockRenderers:DataScroller;
      
      private var _model:ItemSetsModel;
      
      private var _currentItemSet:ItemSet;
      
      private var _scrollAreaSizer:SpriteProxy;
      
      private var _lastBlockRendererCount:int = 0;
      
      private var _associationPreviewPanel:ItemSetAssociationManagementPreview;
      
      public function ItemSetPageBuildPreview(param1:IContext, param2:Sprite = null)
      {
         super(param1,param2);
      }
      
      override protected function createChildren() : void
      {
         this.blockRenderers = new DataScroller(this);
         this.blockRenderers.setLinkage("ScrollContainer");
         this.blockRenderers.setScrollPolicy(ScrollPolicy.ON);
         this.blockRenderers.mouseDelta = 0.1;
         var _loc1_:VirtualizedVerticalLayout = new VirtualizedVerticalLayout();
         _loc1_.setGap(3);
         _loc1_.setHorizontalAlign(HorizontalAlign.CENTER);
         this.blockRenderers.setLayoutAlgorithm(_loc1_);
         var _loc2_:MultiRendererFactory = new MultiRendererFactory();
         _loc2_.addType(ItemSetBlock,ItemSetBlockRenderer,[this,null,"ItemGroupRendererNoEdit"]);
         _loc2_.addType(ItemSet,ItemSetAssociationManagementPreview,[this]);
         _loc2_.getEntryConstructed().add(this.onEntryConstructed);
         this.blockRenderers.setRendererFactory(_loc2_);
         this.blockRenderers.getLayoutInvalidated().add(invalidateLayout);
         this.blockRenderers.setDataProvider(new ListX());
         addChild(this.blockRenderers);
         this._scrollAreaSizer = new SpriteProxy(this);
         setTimelineChildByName("scrollAreaSizer",this._scrollAreaSizer);
         this._scrollAreaSizer.setMouseEnabled(false);
      }
      
      public function setModel(param1:ItemSetsModel) : void
      {
         if(this._model != param1)
         {
            this._model = param1;
            if(this._associationPreviewPanel)
            {
               this._associationPreviewPanel.setModel(this._model);
            }
         }
      }
      
      private function blocksChangedHandler() : void
      {
         var _loc1_:Array = new Array();
         _loc1_.push(this._currentItemSet);
         var _loc2_:Array = vectorToArray(this._currentItemSet.blocks);
         _loc1_ = _loc1_.concat(_loc2_);
         this.blockRenderers.setDataProvider(new ListX(_loc1_));
      }
      
      private function onEntryConstructed(param1:LayoutEntry, param2:*) : void
      {
         var _loc3_:ItemSetBlockRenderer = null;
         if(param1.element is ItemSetBlockRenderer)
         {
            _loc3_ = param1.element as ItemSetBlockRenderer;
            _loc3_.setMouseEnabled(false);
            _loc3_.setMouseChildren(false);
         }
         else if(param1.element is ItemSetAssociationManagementPreview)
         {
            this._associationPreviewPanel = param1.element as ItemSetAssociationManagementPreview;
            if(this._associationPreviewPanel)
            {
               this._associationPreviewPanel.setModel(this._model);
            }
         }
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:ItemSetBlockRenderer = null;
         var _loc4_:ItemSetBlock = null;
         this.blockRenderers.setExplicitSize(this._scrollAreaSizer.getWidth(),this._scrollAreaSizer.getHeight());
         this.blockRenderers.setExplicitPosition(this._scrollAreaSizer.getX(),this._scrollAreaSizer.getY());
         if(this.blockRenderers.getActiveEntries().length > this._lastBlockRendererCount && this.blockRenderers.getActiveEntries().length > 1)
         {
            _loc3_ = this.blockRenderers.getActiveEntries()[this.blockRenderers.getActiveEntries().length - 2].element as ItemSetBlockRenderer;
            if(_loc3_ != null)
            {
               _loc4_ = _loc3_.getData() as ItemSetBlock;
            }
         }
         this._lastBlockRendererCount = this.blockRenderers.getActiveEntries().length;
         return super.updateLayout(param1,param2);
      }
      
      public function setCurrentItemSet(param1:ItemSet) : void
      {
         this._currentItemSet = param1;
         if(this._associationPreviewPanel)
         {
            this._associationPreviewPanel.setCurrentItemSet(param1);
         }
         if(this._currentItemSet)
         {
            this.blocksChangedHandler();
         }
         else
         {
            this.blockRenderers.setDataProvider(new ListX());
         }
      }
   }
}

