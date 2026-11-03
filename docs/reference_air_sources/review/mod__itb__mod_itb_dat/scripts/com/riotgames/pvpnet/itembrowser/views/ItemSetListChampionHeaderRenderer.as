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
   import com.riotgames.pvpnet.itembrowser.controller.ItemSetsController;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetChampion;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetsModel;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class ItemSetListChampionHeaderRenderer extends ButtonX implements IItemRenderer, ISelectableRenderer
   {
      
      private var _itemSetsModel:ItemSetsModel;
      
      private var _iconContainer:SpriteProxy;
      
      private var _index:uint;
      
      private var _textField:TextFieldProxy;
      
      private var _iconSizer:SpriteProxy;
      
      private var _addPageForChampionButton:ButtonX;
      
      private var _itemSetsController:ItemSetsController;
      
      private var _selectionRequested:Signal = new Signal();
      
      private var _iconBitmap:BitmapProxy;
      
      private var _disablingSelectionChangedDispatch:Boolean = false;
      
      private var _model:ItemSetChampion;
      
      public function ItemSetListChampionHeaderRenderer(param1:Context)
      {
         super(param1);
         setLinkage("ChampionCentricSetListRenderer");
         this._itemSetsController = getDependency(ItemSetsController);
         setMouseChildren(true);
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
         this._textField = new TextFieldProxy(this);
         setTimelineChildByName("textField",this._textField);
         this._textField.setMouseEnabled(false);
         this._iconBitmap = new BitmapProxy(this);
         var _loc1_:ScalingTransformBehavior = new ScalingTransformBehavior();
         _loc1_.setMaintainAspectRatio(true);
         this._iconBitmap.setTransformBehavior(_loc1_);
         this._iconBitmap.setSmoothing(true);
         this._iconContainer.addChild(this._iconBitmap);
         this._iconBitmap.getLayoutInvalidated().add(invalidateLayout);
         this._iconContainer.getLayoutInvalidated().add(invalidateLayout);
         this._addPageForChampionButton = new ButtonX(this);
         setTimelineChildByName("addPageForChampionButton",this._addPageForChampionButton);
         this._addPageForChampionButton.addEventListener(MouseEvent.CLICK,this.handleAddPageForChampionClicked);
         addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDown);
      }
      
      override public function getData() : *
      {
         return this._model;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._iconBitmap.setExplicitSize(this._iconSizer.getWidth(),this._iconSizer.getHeight());
         this._iconBitmap.setExplicitPosition(this._iconSizer.getX(),this._iconSizer.getY());
         return _asset.getBounds(null);
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
      
      private function handleAddPageForChampionClicked(param1:MouseEvent) : void
      {
         if(this._model)
         {
            this._itemSetsController.addItemPageForChampion(this._model);
         }
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
      
      private function handleMouseDown(param1:MouseEvent) : void
      {
         this._selectionRequested.dispatch(this,param1.ctrlKey,param1.shiftKey);
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
               this._textField.setText(this._model.getChampion().displayName);
            }
            else
            {
               this._textField.setText("");
               this._iconBitmap.setBitmapData(null);
            }
         }
      }
      
      public function getSelectionRequested() : ISignal
      {
         return this._selectionRequested;
      }
      
      override public function destroy() : void
      {
         this._selectionRequested.removeAll();
         this._addPageForChampionButton.removeEventListener(MouseEvent.CLICK,this.handleAddPageForChampionClicked);
         removeEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDown);
         super.destroy();
      }
      
      override public function setData(param1:*) : void
      {
         this.setModel(param1);
      }
   }
}

