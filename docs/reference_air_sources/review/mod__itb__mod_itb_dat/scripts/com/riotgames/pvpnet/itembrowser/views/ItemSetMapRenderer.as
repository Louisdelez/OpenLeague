package com.riotgames.pvpnet.itembrowser.views
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.renderer.IItemRenderer;
   import blix.components.renderer.ISelectableRenderer;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSet;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetsModel;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   
   public class ItemSetMapRenderer extends ButtonX implements IItemRenderer, ISelectableRenderer
   {
      
      private var _itemSetsModel:ItemSetsModel;
      
      private var _iconContainer:SpriteProxy;
      
      private var _gameMap:GameMap;
      
      private var _index:uint = 0;
      
      private var _mapLabel:TextFieldProxy;
      
      private var _iconSizer:SpriteProxy;
      
      private var _selectionRequested:Signal = new Signal();
      
      private var _iconBitmap:BitmapProxy;
      
      private var _activeItemSet:ItemSet;
      
      public function ItemSetMapRenderer(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         setLinkage("ItemSetMapRenderer");
      }
      
      override public function destroy() : void
      {
         this.removeActiveItemSetListeners();
         this.removeItemSetsModelListeners();
         this._selectionRequested.removeAll();
         super.destroy();
      }
      
      public function setItemSetsModel(param1:ItemSetsModel) : void
      {
         if(this._itemSetsModel != param1)
         {
            this.removeItemSetsModelListeners();
            this._itemSetsModel = param1;
            this.addItemSetsModelListeners();
            if(this._itemSetsModel)
            {
               this.handleActivePageChanged();
            }
            else
            {
               this.removeActiveItemSetListeners();
            }
         }
      }
      
      private function setGameMap(param1:GameMap) : void
      {
         var _loc2_:BitmapData = null;
         if(this._gameMap != param1)
         {
            this._gameMap = param1;
            if(this._gameMap)
            {
               _loc2_ = ImagePackLookup.instance.getBitmapData("E_MAP_" + this._gameMap.mapId);
               if(!_loc2_)
               {
                  _loc2_ = ImagePackLookup.instance.getBitmapData("E_MAP_ERROR");
               }
               this._iconBitmap.setBitmapData(_loc2_);
               this._mapLabel.setText(this._gameMap.displayName);
            }
            else
            {
               this._iconBitmap.setBitmapData(null);
               this._mapLabel.setText("");
            }
            this.handleActivePageChanged();
         }
      }
      
      private function updateSelection() : void
      {
         if(Boolean(this._gameMap) && Boolean(this._activeItemSet))
         {
            this.setSelected(this._activeItemSet.isMapAssignedToThisItemSet(this._gameMap.mapId));
         }
         else
         {
            this.setSelected(false);
         }
      }
      
      public function setIndex(param1:uint) : void
      {
         this._index = param1;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = this._mapLabel.setExplicitSize(NaN,NaN);
         this._mapLabel.setExplicitPosition(NaN,this._iconSizer.getHeight() - _loc3_.y + 8);
         this._iconBitmap.setExplicitSize(this._iconSizer.getWidth(),this._iconSizer.getHeight());
         return _asset.getBounds(null);
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
         this._mapLabel = new TextFieldProxy(this);
         setTimelineChildByName("textField",this._mapLabel);
         this._mapLabel.setAutoSize(TextFieldAutoSize.LEFT);
         this._mapLabel.getLayoutInvalidated().add(invalidateLayout);
         this._mapLabel.setMouseWheelEnabled(false);
         this._mapLabel.setVerticalScrollEnabled(false);
         addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDown);
         super.createChildren();
      }
      
      private function removeActiveItemSetListeners() : void
      {
         if(this._activeItemSet)
         {
            this._activeItemSet.getIsGlobalForMapsChanged().remove(this.handlePageGlobalnessChanged);
            this._activeItemSet.getAssignedMapsChanged().remove(this.updateSelection);
         }
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
      
      override public function getData() : *
      {
         return this._gameMap;
      }
      
      public function getIndex() : uint
      {
         return this._index;
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
      
      private function handlePageGlobalnessChanged() : void
      {
         if(!this._activeItemSet)
         {
         }
      }
      
      override public function setData(param1:*) : void
      {
         this.setGameMap(param1);
      }
      
      private function addActiveItemSetListeners() : void
      {
         if(this._activeItemSet)
         {
            this._activeItemSet.getIsGlobalForMapsChanged().add(this.handlePageGlobalnessChanged);
            this._activeItemSet.getAssignedMapsChanged().add(this.updateSelection);
         }
      }
      
      private function handleActivePageChanged() : void
      {
         this.removeActiveItemSetListeners();
         this._activeItemSet = this._itemSetsModel.getActiveItemSet();
         this.addActiveItemSetListeners();
         this.updateSelection();
         this.handlePageGlobalnessChanged();
      }
      
      public function getSelectionRequested() : ISignal
      {
         return this._selectionRequested;
      }
      
      private function addItemSetsModelListeners() : void
      {
         if(this._itemSetsModel)
         {
            this._itemSetsModel.getActiveItemSetChanged().add(this.handleActivePageChanged);
         }
      }
   }
}

