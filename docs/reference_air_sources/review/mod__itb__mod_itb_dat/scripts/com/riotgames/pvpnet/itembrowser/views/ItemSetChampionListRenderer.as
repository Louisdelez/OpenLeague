package com.riotgames.pvpnet.itembrowser.views
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.renderer.IItemRenderer;
   import blix.components.renderer.ISelectableRenderer;
   import blix.context.Context;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.common.utils.ChampionIconCacheUtil;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSet;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetChampion;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetsModel;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class ItemSetChampionListRenderer extends ButtonX implements IItemRenderer, ISelectableRenderer
   {
      
      private var _itemSetsModel:ItemSetsModel;
      
      private var _iconContainer:SpriteProxy;
      
      private var _championLabel:TextFieldProxy;
      
      private var _iconSizer:SpriteProxy;
      
      private var _index:uint;
      
      private var _selectionRequested:Signal = new Signal();
      
      private var _iconBitmap:BitmapProxy;
      
      private var _model:ItemSetChampion;
      
      private var _activeItemSet:ItemSet;
      
      public function ItemSetChampionListRenderer(param1:Context)
      {
         super(param1);
         setLinkage("ChampionListRenderer");
      }
      
      public function setItemSetsModel(param1:ItemSetsModel) : void
      {
         var _loc2_:ItemSet = null;
         if(this._itemSetsModel != param1)
         {
            this.removeItemSetsModelListeners();
            this._itemSetsModel = param1;
            this.addItemSetsModelListeners();
            if(this._itemSetsModel)
            {
               _loc2_ = this._itemSetsModel.getActiveItemSet();
               if(Boolean(_loc2_) && _loc2_ != this._activeItemSet)
               {
                  this.removeItemSetListeners();
                  this._activeItemSet = _loc2_;
                  this.addItemSetListeners();
                  this.handleActivePageChanged();
               }
            }
            else
            {
               this.removeItemSetListeners();
            }
         }
      }
      
      override public function setData(param1:*) : void
      {
         this.setModel(param1);
      }
      
      private function handlePageGlobalnessChanged() : void
      {
         if(!this._activeItemSet)
         {
         }
      }
      
      public function setIndex(param1:uint) : void
      {
         this._index = param1;
      }
      
      override protected function createChildren() : void
      {
         this._iconSizer = new SpriteProxy(this);
         setTimelineChildByName("iconSizer",this._iconSizer);
         this._iconContainer = new SpriteProxy(this);
         setTimelineChildByName("itemContainer",this._iconContainer);
         this._iconBitmap = new BitmapProxy(this);
         var _loc1_:ScalingTransformBehavior = new ScalingTransformBehavior();
         _loc1_.setMaintainAspectRatio(true);
         this._iconBitmap.setTransformBehavior(_loc1_);
         this._iconBitmap.setSmoothing(true);
         this._iconContainer.addChild(this._iconBitmap);
         this._iconContainer.getLayoutInvalidated().add(invalidateLayout);
         this._championLabel = new TextFieldProxy(this);
         setTimelineChildByName("textField",this._championLabel);
         addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDown);
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
      
      private function removeItemSetsModelListeners() : void
      {
         if(this._itemSetsModel)
         {
            this._itemSetsModel.getActiveItemSetChanged().remove(this.handleActivePageChanged);
         }
      }
      
      private function handleMouseDown(param1:MouseEvent) : void
      {
         this._selectionRequested.dispatch(this,param1.ctrlKey,param1.shiftKey);
      }
      
      private function handleAssignedChampionsChanged() : void
      {
         if(Boolean(this._model) && Boolean(this._activeItemSet))
         {
            this.setSelected(this._activeItemSet.isChampionIdAssignedToThisItemSet(this._model.getChampionID()));
         }
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._iconBitmap.setExplicitSize(this._iconSizer.getWidth(),this._iconSizer.getHeight());
         return _asset.getBounds(null);
      }
      
      override public function setSelected(param1:Boolean) : void
      {
         if(_selected == param1)
         {
            return;
         }
         _selected = param1;
         refreshState();
      }
      
      private function removeItemSetListeners() : void
      {
         if(this._activeItemSet)
         {
            this._activeItemSet.getIsGlobalForChampionsChanged().remove(this.handlePageGlobalnessChanged);
            this._activeItemSet.getAssignedChampionsChanged().remove(this.handleAssignedChampionsChanged);
         }
      }
      
      public function setModel(param1:ItemSetChampion) : void
      {
         var _loc2_:BitmapData = null;
         if(this._model != param1)
         {
            this._model = param1;
            if(Boolean(this._model) && Boolean(this._model.getChampion()) && Boolean(this._model.getChampion()))
            {
               _loc2_ = ChampionIconCacheUtil.instance.getIcon(this._model.getChampion().skinName);
               this._iconBitmap.setBitmapData(_loc2_);
               this._championLabel.setText(this._model.getChampion().displayName);
            }
            else
            {
               this._iconBitmap.setBitmapData(null);
               this._championLabel.setText("");
            }
            this.handleActivePageChanged();
         }
      }
      
      override public function getData() : *
      {
         return this._model;
      }
      
      private function handleActivePageChanged() : void
      {
         this.removeItemSetListeners();
         this._activeItemSet = this._itemSetsModel.getActiveItemSet();
         this.addItemSetListeners();
         if(Boolean(this._model) && Boolean(this._activeItemSet))
         {
            this.setSelected(this._activeItemSet.isChampionIdAssignedToThisItemSet(this._model.getChampionID()));
         }
         this.handlePageGlobalnessChanged();
      }
      
      private function addItemSetListeners() : void
      {
         if(this._activeItemSet)
         {
            this._activeItemSet.getIsGlobalForChampionsChanged().add(this.handlePageGlobalnessChanged);
            this._activeItemSet.getAssignedChampionsChanged().add(this.handleAssignedChampionsChanged);
         }
      }
      
      override public function destroy() : void
      {
         this.removeItemSetListeners();
         this.removeItemSetsModelListeners();
         this._selectionRequested.removeAll();
         super.destroy();
      }
      
      private function addItemSetsModelListeners() : void
      {
         if(this._itemSetsModel)
         {
            this._itemSetsModel.getActiveItemSetChanged().add(this.handleActivePageChanged);
         }
      }
      
      public function getSelectionRequested() : ISignal
      {
         return this._selectionRequested;
      }
   }
}

