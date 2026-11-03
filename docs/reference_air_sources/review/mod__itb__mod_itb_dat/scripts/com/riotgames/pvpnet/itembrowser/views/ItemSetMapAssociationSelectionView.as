package com.riotgames.pvpnet.itembrowser.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.CheckBoxX;
   import blix.components.button.RadioButtonGroupX;
   import blix.components.list.DataGroup;
   import blix.components.list.RendererFactory;
   import blix.components.list.SelectionBehavior;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.ds.ListView;
   import blix.ds.ListX;
   import blix.layout.LayoutEntry;
   import blix.layout.algorithms.VirtualizedTileLayout;
   import blix.layout.vo.HorizontalAlign;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.pvpnet.itembrowser.controller.ItemSetsController;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSet;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetsModel;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.resources.ResourceManager;
   
   public class ItemSetMapAssociationSelectionView extends StatefulView
   {
      
      private var _itemSetsModel:ItemSetsModel;
      
      private var _background:SpriteProxy;
      
      private var _globalForMapsRadioButton:CheckBoxX;
      
      private var _backgroundGlobal:SpriteProxy;
      
      private var _radioButtonGroup:RadioButtonGroupX;
      
      private var _chooseMapText:TextFieldProxy;
      
      private var _mapDataGroup:DataGroup;
      
      private var _itemSetsController:ItemSetsController;
      
      private var _mapListView:ListView;
      
      private var _mapSelectionBehavior:SelectionBehavior;
      
      private var _mapSelectionSizer:SpriteProxy;
      
      private var _updatingSelectionState:Boolean = false;
      
      private var _dataGroupContainer:SpriteProxy;
      
      private var _mapRendererFactory:RendererFactory;
      
      private var _currentItemSet:ItemSet;
      
      private var _nonGlobalRadioButton:CheckBoxX;
      
      public function ItemSetMapAssociationSelectionView(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         setLinkage("ItemSetMapSelectionView");
         this._itemSetsController = getDependency(ItemSetsController);
      }
      
      private function handleGlobalnessForActivePageChanged() : void
      {
         if(this._updatingSelectionState)
         {
            return;
         }
         this.updateRadioButtonSelection();
      }
      
      private function removeActiveItemSetListeners() : void
      {
         if(this._currentItemSet)
         {
            this._currentItemSet.getIsGlobalForMapsChanged().remove(this.handleGlobalnessForActivePageChanged);
         }
      }
      
      private function handleGlobalForMapsSelectedChanged() : void
      {
         if(this._updatingSelectionState || this._currentItemSet == null)
         {
            return;
         }
         this._itemSetsController.changeGlobalnessForMapsOnCurrentItemSet(this._globalForMapsRadioButton.getSelected());
         if(!this._globalForMapsRadioButton.getSelected() && this._currentItemSet.getAssignedMaps().length == 0)
         {
            this._updatingSelectionState = true;
            this._itemSetsController.changeGlobalnessForMapsOnCurrentItemSet(true);
            this._updatingSelectionState = false;
         }
      }
      
      private function handleSelectedMapsChanged() : void
      {
         var _loc3_:GameMap = null;
         if(this._updatingSelectionState || !this._currentItemSet)
         {
            return;
         }
         var _loc1_:Vector.<Object> = this._mapSelectionBehavior.getSelectedItems();
         var _loc2_:Vector.<uint> = new Vector.<uint>();
         for each(_loc3_ in this._itemSetsModel.getAvailableMaps())
         {
            if(this._mapSelectionBehavior.getItemIsSelected(_loc3_))
            {
               _loc2_.push(_loc3_.mapId);
            }
         }
         this._itemSetsController.changeGlobalnessForMapsOnCurrentItemSet(_loc2_.length == 0);
         this._itemSetsController.setMapAssignments(_loc2_);
      }
      
      private function addActiveItemSetListeners() : void
      {
         if(this._currentItemSet)
         {
            this._currentItemSet.getIsGlobalForMapsChanged().add(this.handleGlobalnessForActivePageChanged);
         }
      }
      
      private function handleActiveItemSetChanged() : void
      {
         var _loc1_:Vector.<Object> = null;
         var _loc2_:GameMap = null;
         if(Boolean(this._itemSetsModel) && Boolean(this._itemSetsModel.getActiveItemSet()))
         {
            this._updatingSelectionState = true;
            this.removeActiveItemSetListeners();
            this._currentItemSet = this._itemSetsModel.getActiveItemSet();
            this.addActiveItemSetListeners();
            this._mapSelectionBehavior.clearSelection();
            _loc1_ = new Vector.<Object>();
            for each(_loc2_ in this._itemSetsModel.getAvailableMaps())
            {
               if(this._currentItemSet.getAssignedMaps().indexOf(_loc2_.mapId) != -1)
               {
                  _loc1_.push(_loc2_);
               }
            }
            this._mapSelectionBehavior.setSelectedItems(_loc1_,false);
            this.updateRadioButtonSelection();
            this._updatingSelectionState = false;
         }
      }
      
      private function handleSelectedRadioButtonChanged() : void
      {
         this.handleGlobalForMapsSelectedChanged();
      }
      
      private function setupMapRenderer(param1:LayoutEntry, param2:GameMap) : void
      {
         var _loc3_:ItemSetMapRenderer = param1.element as ItemSetMapRenderer;
         _loc3_.setItemSetsModel(this._itemSetsModel);
      }
      
      private function removeItemSetsModelListeners() : void
      {
         if(this._itemSetsModel)
         {
            this._itemSetsModel.getActiveItemSetChanged().remove(this.handleActiveItemSetChanged);
            this._itemSetsModel.getAvailableMapsChanged().remove(this.handleItemSetsMapsChanged);
         }
      }
      
      private function updateRadioButtonSelection() : void
      {
         this._updatingSelectionState = true;
         if(this._currentItemSet.getIsGlobalForMaps())
         {
            this._radioButtonGroup.setSelectedButton(this._globalForMapsRadioButton);
            setCurrentState("global");
            invalidateLayout();
         }
         else
         {
            this._radioButtonGroup.setSelectedButton(this._nonGlobalRadioButton);
            setCurrentState("notGlobal");
            invalidateLayout();
         }
         this._updatingSelectionState = false;
      }
      
      public function setModel(param1:ItemSetsModel) : void
      {
         if(param1 != this._itemSetsModel)
         {
            if(this._itemSetsModel)
            {
               this.removeItemSetsModelListeners();
            }
            this._itemSetsModel = param1;
            this.handleActiveItemSetChanged();
            this.handleItemSetsMapsChanged();
            if(this._itemSetsModel)
            {
               this.addItemSetsModelListeners();
            }
         }
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         if(getCurrentState() == "global")
         {
            this._backgroundGlobal.setExplicitSize(NaN,NaN);
            return new Rectangle(0,0,this._backgroundGlobal.getWidth(),this._backgroundGlobal.getHeight());
         }
         var _loc3_:Point = this._mapDataGroup.setExplicitSize(this._mapSelectionSizer.getWidth(),NaN);
         this._mapDataGroup.setExplicitPosition(this._mapSelectionSizer.getX(),this._mapSelectionSizer.getY());
         this._background.setExplicitSize(NaN,this._mapSelectionSizer.getY() + _loc3_.y + 5);
         return new Rectangle(0,0,this._background.getWidth(),this._background.getHeight());
      }
      
      private function handleItemSetsMapsChanged() : void
      {
         var _loc1_:Vector.<GameMap> = this._itemSetsModel ? this._itemSetsModel.getAvailableMaps() : null;
         this._mapListView.setSource(_loc1_);
      }
      
      override public function destroy() : void
      {
         this.removeItemSetsModelListeners();
         this.removeActiveItemSetListeners();
         this._mapRendererFactory.destroy();
         super.destroy();
      }
      
      private function addItemSetsModelListeners() : void
      {
         if(this._itemSetsModel)
         {
            this._itemSetsModel.getActiveItemSetChanged().add(this.handleActiveItemSetChanged);
            this._itemSetsModel.getAvailableMapsChanged().add(this.handleItemSetsMapsChanged);
         }
      }
      
      override protected function createChildren() : void
      {
         this._background = new SpriteProxy(this);
         this._background.setTransformBehavior(new ScalingTransformBehavior());
         setTimelineChildByName("background",this._background);
         this._backgroundGlobal = new SpriteProxy(this);
         setTimelineChildByName("backgroundGlobal",this._backgroundGlobal);
         this._chooseMapText = new TextFieldProxy(this);
         setTimelineChildByName("chooseMapText",this._chooseMapText);
         this._chooseMapText.setText(ResourceManager.getInstance().getString("itemBrowser","itemSets_chooseMapAssociations"));
         this._globalForMapsRadioButton = new CheckBoxX(this);
         setTimelineChildByName("globalForMapsCheckbox",this._globalForMapsRadioButton);
         this._globalForMapsRadioButton.setText(ResourceManager.getInstance().getString("itemBrowser","itemSets_setGlobalForMapsLabel") + "  ");
         this._nonGlobalRadioButton = new CheckBoxX(this);
         setTimelineChildByName("nonGlobalCheckbox",this._nonGlobalRadioButton);
         this._nonGlobalRadioButton.setText(ResourceManager.getInstance().getString("itemBrowser","itemSets_setSpecificForMapsLabel") + "  ");
         this._radioButtonGroup = new RadioButtonGroupX();
         this._radioButtonGroup.addRadioButton(this._globalForMapsRadioButton);
         this._radioButtonGroup.addRadioButton(this._nonGlobalRadioButton);
         this._radioButtonGroup.getSelectedButtonChanged().add(this.handleSelectedRadioButtonChanged);
         this._mapSelectionSizer = new SpriteProxy(this);
         setTimelineChildByName("mapSelectionSizer",this._mapSelectionSizer);
         this._mapSelectionSizer.setMouseEnabled(false);
         this._mapDataGroup = new DataGroup(this);
         setTimelineChildByName("dataGroupContainer",this._mapDataGroup);
         var _loc1_:VirtualizedTileLayout = new VirtualizedTileLayout();
         this._mapDataGroup.setLayoutAlgorithm(_loc1_);
         _loc1_.setHorizontalAlign(HorizontalAlign.CENTER);
         this._mapDataGroup.getLayoutInvalidated().add(invalidateLayout);
         this._mapListView = new ListView(new ListX(new Vector.<GameMap>()));
         this._mapDataGroup.setDataProvider(this._mapListView);
         this._mapRendererFactory = new RendererFactory(ItemSetMapRenderer,[this]);
         this._mapRendererFactory.getEntryConstructed().add(this.setupMapRenderer);
         this._mapDataGroup.setRendererFactory(this._mapRendererFactory);
         this._mapSelectionBehavior = new SelectionBehavior(this._mapRendererFactory,this._mapListView);
         this._mapSelectionBehavior.autoMultipleSelection = true;
         this._mapSelectionBehavior.getSelectedItemsChanged().add(this.handleSelectedMapsChanged);
      }
   }
}

