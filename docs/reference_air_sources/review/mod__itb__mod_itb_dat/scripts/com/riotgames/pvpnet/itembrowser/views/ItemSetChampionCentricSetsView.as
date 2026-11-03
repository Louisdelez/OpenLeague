package com.riotgames.pvpnet.itembrowser.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.scroll.ScrollArea;
   import blix.components.scroll.ScrollPolicy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.layout.algorithms.VerticalLayout;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.pvpnet.itembrowser.controller.ItemSetsController;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetsModel;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import mx.resources.ResourceManager;
   
   public class ItemSetChampionCentricSetsView extends StatefulView
   {
      
      private var _itemSetsScrollArea:ScrollArea;
      
      private var _showImportDialogueRequested:Signal = new Signal();
      
      private var _infoText:TextFieldProxy;
      
      private var _itemSetsController:ItemSetsController;
      
      private var _championPagesView:ItemSetListChampionPagesView;
      
      private var _globalPagesView:ItemSetListGlobalPagesView;
      
      private var _model:ItemSetsModel;
      
      private var _multiAssignmentsView:ItemSetMultiAssignmentPagesView;
      
      private var _scrollAreaSizer:SpriteProxy;
      
      private var _managementControlsView:ItemSetManagementControlsView;
      
      public function ItemSetChampionCentricSetsView(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         this._itemSetsController = getDependency(ItemSetsController);
      }
      
      private function handleItemSetsChanged() : void
      {
         if(Boolean(this._model) && this._model.getItemSets().length > 0)
         {
            setCurrentState("yesSets");
         }
         else
         {
            setCurrentState("noSets");
         }
      }
      
      private function removeModelListeners() : void
      {
         if(this._model)
         {
            this._model.getItemSetsChanged().remove(this.handleItemSetsChanged);
         }
      }
      
      override public function destroy() : void
      {
         this.removeModelListeners();
         super.destroy();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._itemSetsScrollArea.setExplicitSize(this._scrollAreaSizer.getWidth(),this._scrollAreaSizer.getHeight());
         this._itemSetsScrollArea.setExplicitPosition(this._scrollAreaSizer.getX(),this._scrollAreaSizer.getY());
         this._itemSetsScrollArea.setScrollRect(new Rectangle(0,0,this._scrollAreaSizer.getWidth(),this._scrollAreaSizer.getHeight()));
         return super.updateLayout(param1,param2);
      }
      
      private function addModelListeners() : void
      {
         if(this._model)
         {
            this._model.getItemSetsChanged().add(this.handleItemSetsChanged);
         }
      }
      
      private function updateViewModels() : void
      {
         this._managementControlsView.setModel(this._model);
         this._championPagesView.setModel(this._model);
         this._multiAssignmentsView.setModel(this._model);
         this._globalPagesView.setModel(this._model);
      }
      
      override protected function createChildren() : void
      {
         this._scrollAreaSizer = new SpriteProxy(this);
         setTimelineChildByName("itemSetListSizer",this._scrollAreaSizer);
         this._scrollAreaSizer.setMouseChildren(false);
         this._itemSetsScrollArea = new ScrollArea(this);
         this._itemSetsScrollArea.setLinkage("ScrollContainer");
         this._itemSetsScrollArea.setVScrollPolicy(ScrollPolicy.ON);
         this._itemSetsScrollArea.getLayoutInvalidated().add(invalidateLayout);
         this._itemSetsScrollArea.setKineticScrolling(true);
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.setGap(10);
         this._itemSetsScrollArea.getContents().setLayoutAlgorithm(_loc1_);
         addChild(this._itemSetsScrollArea);
         this._managementControlsView = new ItemSetManagementControlsView(this);
         setTimelineChildByName("itemSetManagementControls",this._managementControlsView);
         this._managementControlsView.getShowImportDialogueRequested().add(this._showImportDialogueRequested.dispatch);
         this._globalPagesView = new ItemSetListGlobalPagesView(this);
         this._itemSetsScrollArea.getContents().addElement(this._globalPagesView);
         this._multiAssignmentsView = new ItemSetMultiAssignmentPagesView(this);
         this._itemSetsScrollArea.getContents().addElement(this._multiAssignmentsView);
         this._championPagesView = new ItemSetListChampionPagesView(this);
         this._itemSetsScrollArea.getContents().addElement(this._championPagesView);
         this._infoText = new TextFieldProxy(this);
         setTimelineChildByName("infoText",this._infoText);
         this._infoText.setText(ResourceManager.getInstance().getString("itemBrowser","itemSets_noItemSetsText"));
      }
      
      public function getShowImportDialogueRequested() : ISignal
      {
         return this._showImportDialogueRequested;
      }
      
      public function setModel(param1:ItemSetsModel) : void
      {
         if(param1 != this._model)
         {
            this.removeModelListeners();
            this._model = param1;
            this.addModelListeners();
            this.handleItemSetsChanged();
            this.updateViewModels();
         }
      }
   }
}

