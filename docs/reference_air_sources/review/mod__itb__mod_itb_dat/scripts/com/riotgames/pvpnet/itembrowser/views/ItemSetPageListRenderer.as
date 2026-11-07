package com.riotgames.pvpnet.itembrowser.views
{
   import blix.components.button.LabelButtonX;
   import blix.components.renderer.IDataRenderer;
   import blix.components.renderer.ISelectableRenderer;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.pvpnet.itembrowser.controller.ItemSetsController;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSet;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   import mx.resources.ResourceManager;
   
   public class ItemSetPageListRenderer extends LabelButtonX implements IDataRenderer, ISelectableRenderer
   {
      
      private var _itemSet:ItemSet;
      
      private var _index:uint;
      
      private var _editingPageName:Boolean = false;
      
      private var _selectionRequested:Signal = new Signal();
      
      private var _selectionBackground:StatefulView;
      
      private var _itemSetsController:ItemSetsController;
      
      public function ItemSetPageListRenderer(param1:IContext, param2:String = "")
      {
         super(param1);
         this._itemSetsController = getDependency(ItemSetsController);
         if(param2 == "")
         {
            setLinkage("ItemSetPageListRenderer");
         }
         else
         {
            setLinkage(param2);
         }
      }
      
      override public function destroy() : void
      {
         removeEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDown);
         if(this._itemSet)
         {
            this.removeModelListeners();
         }
         super.destroy();
      }
      
      private function handlePageTitleChanged() : void
      {
         this.updatePageNameDisplay();
      }
      
      private function addModelListeners() : void
      {
         this._itemSet.getTitleChanged().add(this.handlePageTitleChanged);
         this._itemSet.getIsDirtyChanged().add(this.handlePageDirtyChanged);
         this._itemSet.getAssignedChampionsChanged().add(this.updatePageNameDisplay);
      }
      
      override public function setCurrentState(param1:String) : void
      {
         super.setCurrentState(param1);
         this._selectionBackground.setCurrentState(getCurrentState());
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDown);
         this._selectionBackground = new StatefulView(this);
         setTimelineChildByName("selectionBackground",this._selectionBackground);
         this._selectionBackground.setTransformBehavior(new ScalingTransformBehavior());
         textField.setAutoSize(TextFieldAutoSize.LEFT);
         textField.getLayoutInvalidated().add(invalidateLayout);
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
      
      private function handleMouseDown(param1:MouseEvent) : void
      {
         this._selectionRequested.dispatch(this,param1.ctrlKey,param1.shiftKey);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = textField.setExplicitSize(NaN,NaN);
         textField.setExplicitPosition(NaN,3);
         this._selectionBackground.setExplicitSize(NaN,_loc3_.y + 6);
         return _asset.getBounds(null);
      }
      
      public function setIndex(param1:uint) : void
      {
         this._index = param1;
      }
      
      override public function setData(param1:*) : void
      {
         if(this._itemSet)
         {
            this.removeModelListeners();
         }
         this._itemSet = param1;
         if(this._itemSet)
         {
            this.handlePageTitleChanged();
            this.handlePageDirtyChanged();
            this.addModelListeners();
         }
         super.setData(param1);
      }
      
      private function updatePageNameDisplay() : void
      {
         var _loc1_:String = this._itemSet.getIsDirty() ? "*" : "";
         _loc1_ += this._itemSet.title;
         if(!this._itemSet.getIsGlobalForChampions() && this._itemSet.getAssignedChampions().length > 1)
         {
            _loc1_ += "\n" + ResourceManager.getInstance().getString("itemBrowser","itemSets_champion_association_count",[this._itemSet.getAssignedChampions().length]);
         }
         textField.setText(_loc1_);
      }
      
      public function getSelectionRequested() : ISignal
      {
         return this._selectionRequested;
      }
      
      private function handlePageDirtyChanged() : void
      {
         this.updatePageNameDisplay();
      }
      
      private function removeModelListeners() : void
      {
         this._itemSet.getTitleChanged().remove(this.handlePageTitleChanged);
         this._itemSet.getIsDirtyChanged().remove(this.handlePageDirtyChanged);
         this._itemSet.getAssignedChampionsChanged().remove(this.updatePageNameDisplay);
      }
   }
}

