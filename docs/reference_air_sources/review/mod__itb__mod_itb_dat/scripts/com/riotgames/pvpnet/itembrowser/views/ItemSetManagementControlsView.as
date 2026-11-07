package com.riotgames.pvpnet.itembrowser.views
{
   import blix.components.button.ButtonX;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.assignToolTip;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.pvpnet.itembrowser.controller.ItemSetsController;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetsModel;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import mx.resources.ResourceManager;
   
   public class ItemSetManagementControlsView extends StatefulView
   {
      
      private var _showImportDialogueRequested:Signal = new Signal();
      
      private var _itemSetsController:ItemSetsController;
      
      private var _deleteButton:ButtonX;
      
      private var _revertButton:ButtonX;
      
      private var _saveButton:ButtonX;
      
      private var _model:ItemSetsModel;
      
      private var _shareButton:ButtonX;
      
      private var _addButton:ButtonX;
      
      public function ItemSetManagementControlsView(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         this._itemSetsController = getDependency(ItemSetsController);
      }
      
      private function removeModelListeners() : void
      {
         if(this._model)
         {
            this._model.getItemSetsDirtyChanged().remove(this.handleDirtyChanged);
            this._model.getActiveItemSetChanged().remove(this.handleActiveItemSetChanged);
         }
      }
      
      private function deleteButtonClicked(param1:MouseEvent) : void
      {
         this._itemSetsController.deleteActiveItemSet();
      }
      
      private function handleDirtyChanged(param1:ItemSetsModel, param2:Boolean) : void
      {
         this._saveButton.setEnabled(param2);
         this._revertButton.setEnabled(param2);
      }
      
      private function revertButtonClicked(param1:MouseEvent) : void
      {
         this._itemSetsController.revertItemSets();
      }
      
      private function handleActiveItemSetChanged() : void
      {
         this._deleteButton.setEnabled(this._model.getActiveItemSet() != null);
      }
      
      private function addModelListeners() : void
      {
         if(this._model)
         {
            this._model.getItemSetsDirtyChanged().add(this.handleDirtyChanged);
            this._model.getActiveItemSetChanged().add(this.handleActiveItemSetChanged);
         }
      }
      
      private function saveButtonClicked(param1:MouseEvent) : void
      {
         this._itemSetsController.saveItemSets();
      }
      
      override protected function createChildren() : void
      {
         this._addButton = new ButtonX(this);
         setTimelineChildByName("addButton",this._addButton);
         assignToolTip(this._addButton,ResourceManager.getInstance().getString("itemBrowser","addButtonTooltip"));
         this._addButton.addEventListener(MouseEvent.CLICK,this.addPageClicked);
         this._saveButton = new ButtonX(this);
         this._saveButton.setSelected(false);
         setTimelineChildByName("saveButton",this._saveButton);
         assignToolTip(this._saveButton,ResourceManager.getInstance().getString("itemBrowser","saveButtonTooltip"));
         this._saveButton.addEventListener(MouseEvent.CLICK,this.saveButtonClicked);
         this._revertButton = new ButtonX(this);
         setTimelineChildByName("revertButton",this._revertButton);
         assignToolTip(this._revertButton,ResourceManager.getInstance().getString("itemBrowser","revertButtonTooltip"));
         this._revertButton.addEventListener(MouseEvent.CLICK,this.revertButtonClicked);
         this._deleteButton = new ButtonX(this);
         setTimelineChildByName("deleteButton",this._deleteButton);
         assignToolTip(this._deleteButton,ResourceManager.getInstance().getString("itemBrowser","deleteButtonTooltip"));
         this._deleteButton.addEventListener(MouseEvent.CLICK,this.deleteButtonClicked);
         this._shareButton = new ButtonX(this);
         setTimelineChildByName("shareButton",this._shareButton);
         assignToolTip(this._shareButton,ResourceManager.getInstance().getString("itemBrowser","shareButtonTooltip"));
         this._shareButton.addEventListener(MouseEvent.CLICK,this.onShareButtonClicked);
         setCurrentState(ClientConfig.instance.showItemSetSharing ? "withSharing" : "withoutSharing");
      }
      
      public function getShowImportDialogueRequested() : ISignal
      {
         return this._showImportDialogueRequested;
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
               this.handleDirtyChanged(this._model,this._model.getItemSetsDirty());
               this.handleActiveItemSetChanged();
            }
         }
      }
      
      private function onShareButtonClicked(param1:MouseEvent) : void
      {
         if(!ClientConfig.instance.showItemSetSharing)
         {
            return;
         }
         this._showImportDialogueRequested.dispatch();
      }
      
      private function addPageClicked(param1:MouseEvent) : void
      {
         this._itemSetsController.addItemPage();
      }
      
      override public function destroy() : void
      {
         this.removeModelListeners();
         super.destroy();
      }
   }
}

