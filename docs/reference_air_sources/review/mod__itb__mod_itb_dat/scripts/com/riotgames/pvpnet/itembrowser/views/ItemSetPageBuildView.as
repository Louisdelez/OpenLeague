package com.riotgames.pvpnet.itembrowser.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.list.DataScroller;
   import blix.components.list.MultiRendererFactory;
   import blix.components.renderer.IItemRenderer;
   import blix.components.scroll.ScrollModel;
   import blix.components.scroll.ScrollPolicy;
   import blix.context.IContext;
   import blix.ds.ListX;
   import blix.frame.getEnterFrame;
   import blix.layout.LayoutEntry;
   import blix.layout.algorithms.VirtualizedVerticalLayout;
   import blix.layout.vo.HorizontalAlign;
   import blix.layout.vo.Padding;
   import blix.view.View;
   import com.riotgames.pvpnet.itembrowser.controller.ItemSetsController;
   import com.riotgames.pvpnet.itembrowser.sets.model.BlankItemSetBlock;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSet;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetBlock;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetsModel;
   import com.riotgames.rust.focus.RiotFocusManager;
   import com.riotgames.util.vector.vectorToArray;
   import flash.desktop.NativeDragActions;
   import flash.desktop.NativeDragManager;
   import flash.display.Sprite;
   import flash.events.NativeDragEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import mx.managers.DragManager;
   
   public class ItemSetPageBuildView extends SpriteProxy
   {
      
      private static const DRAG_SCROLL_PERCENT:Number = 0.2;
      
      private static const DRAG_SCROLL_SPEED:Number = 0.3;
      
      private var blockRenderers:DataScroller;
      
      private var _newPage:Boolean = false;
      
      private var _itemSetsController:ItemSetsController;
      
      private var insertionIndicator:SpriteProxy;
      
      private var _model:ItemSetsModel;
      
      private var _currentItemSet:ItemSet;
      
      private var _scrollAreaSizer:SpriteProxy;
      
      public function ItemSetPageBuildView(param1:IContext, param2:Sprite = null)
      {
         super(param1,param2);
         this._itemSetsController = getDependency(ItemSetsController);
      }
      
      private function removeModelListeners() : void
      {
         if(this._model)
         {
            this._model.getActiveItemSetChanged().remove(this.handleActiveItemSetChanged);
         }
      }
      
      private function dragOverHandler(param1:NativeDragEvent = null) : void
      {
         var _loc7_:Rectangle = null;
         var _loc8_:View = null;
         if(this._model == null)
         {
            return;
         }
         var _loc2_:int = this.getVisualBlockInsertionIndex();
         this.insertionIndicator.validate();
         var _loc3_:Rectangle = this.insertionIndicator.getScaledBounds();
         var _loc4_:Number = _loc3_.height / 2;
         var _loc5_:Number = Number((this.blockRenderers.getLayoutAlgorithm() as VirtualizedVerticalLayout).getGap());
         var _loc6_:Point = this.blockRenderers.getExplicitPosition();
         if(_loc2_ > 0)
         {
            _loc8_ = this.blockRenderers.getActiveEntries()[_loc2_ - 1].element as View;
            if(_loc8_ is ItemSetBlockRenderer)
            {
               _loc7_ = _loc8_.getScaledBounds();
               this.insertionIndicator.setExplicitPosition(_loc6_.x,_loc6_.y + Math.floor(_loc7_.bottom + _loc5_ / 2 - _loc4_));
            }
            else if(_loc8_ is ItemSetPageInfoRenderer)
            {
               _loc7_ = (this.blockRenderers.getActiveEntries()[0].element as View).getScaledBounds();
               this.insertionIndicator.setExplicitPosition(_loc6_.x,_loc6_.y + Math.floor(_loc7_.bottom + _loc5_ / 2 - _loc4_));
            }
         }
      }
      
      private function getVisualBlockInsertionIndex() : int
      {
         var _loc5_:LayoutEntry = null;
         var _loc6_:View = null;
         var _loc7_:Rectangle = null;
         var _loc1_:int = 0;
         var _loc2_:Number = Number(getMouseX());
         var _loc3_:Number = Number(getMouseY());
         var _loc4_:Point = this.blockRenderers.getExplicitPosition();
         for each(_loc5_ in this.blockRenderers.getActiveEntries())
         {
            _loc6_ = _loc5_.element as View;
            if(_loc6_ != null)
            {
               _loc7_ = _loc6_.getScaledBounds();
               if(_loc3_ <= _loc4_.y + (_loc7_.bottom - _loc7_.height / 2))
               {
                  break;
               }
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      private function handleDragDrop(param1:NativeDragEvent) : void
      {
         var _loc3_:int = 0;
         if(this._model == null)
         {
            return;
         }
         var _loc2_:ItemSetBlock = param1.clipboard.getData(ItemSetBlock.DATA_FORMAT) as ItemSetBlock;
         if(_loc2_)
         {
            _loc3_ = this.getRealBlockInsertionIndex();
            this._itemSetsController.moveBlock(_loc2_,_loc3_);
         }
      }
      
      override public function destroy() : void
      {
         getEnterFrame().remove(this.updateDragScrolling);
         this.removeModelListeners();
         super.destroy();
      }
      
      private function handleActiveItemSetChanged() : void
      {
         if(this._currentItemSet)
         {
            this._currentItemSet.getBlocksChanged().remove(this.blocksChangedHandler);
         }
         this._currentItemSet = this._model ? this._model.getActiveItemSet() : null;
         if(this._currentItemSet)
         {
            this.blocksChangedHandler();
            this._currentItemSet.getBlocksChanged().add(this.blocksChangedHandler);
         }
         else
         {
            this.blockRenderers.setDataProvider(new ListX());
         }
         this._newPage = true;
      }
      
      private function addModelListeners() : void
      {
         if(this._model)
         {
            this._model.getActiveItemSetChanged().add(this.handleActiveItemSetChanged);
         }
      }
      
      private function updateDragScrolling() : void
      {
         var _loc4_:Number = NaN;
         var _loc1_:Number = Number(getMouseX());
         var _loc2_:Number = Number(getMouseY());
         var _loc3_:Rectangle = this.blockRenderers.getScaledBounds();
         if(!_loc3_.contains(_loc1_,_loc2_) || !DragManager.isDragging)
         {
            getEnterFrame().remove(this.updateDragScrolling);
            return;
         }
         var _loc5_:ScrollModel = this.blockRenderers.getScrollModel();
         var _loc6_:Number = _loc3_.top + _loc3_.height * DRAG_SCROLL_PERCENT;
         if(_loc2_ <= _loc6_)
         {
            _loc4_ = 1 - (_loc2_ - _loc3_.top) / (_loc3_.height * DRAG_SCROLL_PERCENT);
            _loc5_.setValue(_loc5_.clampValue(_loc5_.getValue() - DRAG_SCROLL_SPEED * _loc4_));
         }
         var _loc7_:Number = _loc3_.bottom - _loc3_.height * DRAG_SCROLL_PERCENT;
         if(_loc2_ >= _loc7_)
         {
            _loc4_ = (_loc2_ - _loc7_) / (_loc3_.height * DRAG_SCROLL_PERCENT);
            _loc5_.setValue(_loc5_.clampValue(_loc5_.getValue() + DRAG_SCROLL_SPEED * _loc4_));
         }
         this.dragOverHandler(null);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this.blockRenderers.setExplicitSize(this._scrollAreaSizer.getWidth(),this._scrollAreaSizer.getHeight());
         this.blockRenderers.setExplicitPosition(this._scrollAreaSizer.getX(),this._scrollAreaSizer.getY());
         if(this._newPage)
         {
            this._newPage = false;
            ItemSetBlockRenderer.firstTimeDict = new Dictionary(true);
            RiotFocusManager.setFocus(this);
         }
         return super.updateLayout(param1,param2);
      }
      
      override protected function createChildren() : void
      {
         this.blockRenderers = new DataScroller(this);
         this.blockRenderers.setLinkage("ScrollContainer");
         this.blockRenderers.setScrollPolicy(ScrollPolicy.ON);
         this.blockRenderers.mouseDelta = 0.1;
         var _loc1_:VirtualizedVerticalLayout = new VirtualizedVerticalLayout();
         _loc1_.setGap(3);
         _loc1_.setPadding(new Padding(15,0,0,0));
         _loc1_.setHorizontalAlign(HorizontalAlign.CENTER);
         this.blockRenderers.setLayoutAlgorithm(_loc1_);
         var _loc2_:MultiRendererFactory = new MultiRendererFactory();
         _loc2_.addType(BlankItemSetBlock,BlankBlockRenderer,[this]);
         _loc2_.addType(ItemSetBlock,ItemSetBlockRenderer,[this]);
         _loc2_.addType(ItemSet,ItemSetPageInfoRenderer,[this]);
         _loc2_.getEntryActivated().add(this.activateBlockRenderer);
         _loc2_.getEntryDeactivated().add(this.deactivateBlockRenderer);
         this.blockRenderers.setRendererFactory(_loc2_);
         this.blockRenderers.getLayoutInvalidated().add(invalidateLayout);
         this.blockRenderers.setDataProvider(new ListX());
         addChild(this.blockRenderers);
         this._scrollAreaSizer = new SpriteProxy(this);
         setTimelineChildByName("scrollAreaSizer",this._scrollAreaSizer);
         this._scrollAreaSizer.setMouseEnabled(false);
         this.insertionIndicator = new SpriteProxy(this);
         this.insertionIndicator.setLinkage("ItemBlockInsertionIndicator");
         this.insertionIndicator.setVisible(false);
         this.insertionIndicator.setWeight(1);
         addChild(this.insertionIndicator);
         addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,this.dragEnterHandler);
         addEventListener(NativeDragEvent.NATIVE_DRAG_EXIT,this.handleDragExit);
         addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,this.handleDragDrop);
      }
      
      private function blocksChangedHandler() : void
      {
         var _loc1_:Array = new Array();
         _loc1_.push(this._currentItemSet);
         var _loc2_:Array = vectorToArray(this._currentItemSet.blocks);
         _loc2_.push(new BlankItemSetBlock());
         _loc1_ = _loc1_.concat(_loc2_);
         this.blockRenderers.setDataProvider(new ListX(_loc1_));
      }
      
      private function deactivateBlockRenderer(param1:LayoutEntry) : void
      {
         var _loc2_:ItemSetBlockRenderer = null;
         var _loc3_:BlankBlockRenderer = null;
         if(param1.element is ItemSetBlockRenderer)
         {
            _loc2_ = param1.element as ItemSetBlockRenderer;
            _loc2_.removeEventListener(NativeDragEvent.NATIVE_DRAG_START,this.startDraggingBlock);
            _loc2_.deactivate();
         }
         else if(param1.element is BlankBlockRenderer)
         {
            _loc3_ = param1.element as BlankBlockRenderer;
         }
      }
      
      private function dragEnterHandler(param1:NativeDragEvent) : void
      {
         getEnterFrame().add(this.updateDragScrolling);
         if(this._model.getActiveItemSet() == null || this._model.getActiveItemSet().blocks.length >= ItemSet.MAX_BLOCKS)
         {
            return;
         }
         if(param1.clipboard.hasFormat(ItemSetBlock.DATA_FORMAT))
         {
            param1.dropAction = NativeDragActions.MOVE;
            NativeDragManager.acceptDragDrop(getInteractiveAsset());
            addEventListener(NativeDragEvent.NATIVE_DRAG_OVER,this.dragOverHandler);
            this.insertionIndicator.setVisible(true);
            this.dragOverHandler();
         }
      }
      
      public function setModel(param1:ItemSetsModel) : void
      {
         if(param1 != this._model)
         {
            if(this._model)
            {
               this.removeModelListeners();
            }
            this._model = param1;
            if(this._model)
            {
               this.addModelListeners();
               this.handleActiveItemSetChanged();
            }
         }
      }
      
      private function getRealBlockInsertionIndex() : int
      {
         var _loc5_:LayoutEntry = null;
         var _loc6_:ItemSetBlockRenderer = null;
         var _loc7_:Rectangle = null;
         var _loc1_:IItemRenderer = this.blockRenderers.getActiveEntries()[0].element as IItemRenderer;
         var _loc2_:int = 0;
         if(_loc1_ is ItemSetBlockRenderer)
         {
            _loc2_ = _loc1_.getIndex() - 1;
         }
         var _loc3_:Number = Number(getMouseY());
         var _loc4_:Point = this.blockRenderers.getExplicitPosition();
         for each(_loc5_ in this.blockRenderers.getActiveEntries())
         {
            _loc6_ = _loc5_.element as ItemSetBlockRenderer;
            if(_loc6_)
            {
               _loc7_ = _loc6_.getScaledBounds();
               if(_loc3_ <= _loc4_.y + (_loc7_.bottom - _loc7_.height / 2))
               {
                  break;
               }
               _loc2_++;
            }
         }
         return _loc2_;
      }
      
      private function handleDragExit(param1:NativeDragEvent) : void
      {
         if(param1.clipboard.hasFormat(ItemSetBlock.DATA_FORMAT))
         {
            this.insertionIndicator.setVisible(false);
         }
      }
      
      private function startDraggingBlock(param1:NativeDragEvent) : void
      {
      }
      
      private function activateBlockRenderer(param1:LayoutEntry, param2:*) : void
      {
         var _loc3_:ItemSetBlockRenderer = null;
         var _loc4_:BlankBlockRenderer = null;
         if(param1.element is ItemSetBlockRenderer)
         {
            _loc3_ = param1.element as ItemSetBlockRenderer;
            _loc3_.addEventListener(NativeDragEvent.NATIVE_DRAG_START,this.startDraggingBlock);
            _loc3_.activate(this._model);
         }
         else if(param1.element is BlankBlockRenderer)
         {
            _loc4_ = param1.element as BlankBlockRenderer;
         }
      }
   }
}

