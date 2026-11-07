package com.riotgames.pvpnet.itembrowser.views
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.IDisplayChild;
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
   import blix.layout.vo.Padding;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.gameclient.Models.SearchTagData;
   import com.riotgames.platform.gameclient.domain.ChampionAvailabilityEnums;
   import com.riotgames.pvpnet.itembrowser.controller.ItemSetsController;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSet;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetChampion;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetsModel;
   import com.riotgames.rust.components.dropdown.Dropdown;
   import com.riotgames.rust.components.list.renderer.DefaultListItem;
   import com.riotgames.rust.components.text.InputTextFieldProxy;
   import com.riotgames.rust.context.popup.IPopupContext;
   import com.riotgames.rust.context.popup.SimplePopupContextBehavior;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.resources.ResourceManager;
   
   public class ItemSetChampionAssociationSelectionView extends StatefulView implements IPopupContext
   {
      
      private var _itemSetsModel:ItemSetsModel;
      
      private var _championDataGroup:DataGroup;
      
      private var _ownedChampionCheckbox:CheckBoxX;
      
      private var popupBehavior:SimplePopupContextBehavior;
      
      private var _championFilterText:String = "";
      
      private var _championRoleDropDown:Dropdown;
      
      private var _currentItemSet:ItemSet;
      
      private var _updatingSelectionStates:Boolean = false;
      
      private var _globalForChampionsRadioButton:CheckBoxX;
      
      private var _championListView:ListView;
      
      private var _background:SpriteProxy;
      
      private var _backgroundGlobal:SpriteProxy;
      
      private var _radioButtonGroup:RadioButtonGroupX;
      
      private var _dataGroupSizer:SpriteProxy;
      
      private var _championRendererFactory:RendererFactory;
      
      private var _chooseChampionsText:TextFieldProxy;
      
      private var _itemSetsController:ItemSetsController;
      
      private var _championSearchInputText:InputTextFieldProxy;
      
      private var _nonGlobalRadioButton:CheckBoxX;
      
      private var _selectionBehavior:SelectionBehavior;
      
      public function ItemSetChampionAssociationSelectionView(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         setLinkage("ItemSetChampionSelectionView");
         this._itemSetsController = getDependency(ItemSetsController);
      }
      
      private function removeActiveItemSetListeners() : void
      {
         if(this._currentItemSet)
         {
            this._currentItemSet.getIsGlobalForChampionsChanged().remove(this.handleGlobalnessForActivePageChanged);
         }
      }
      
      public function removePopup(param1:IDisplayChild) : void
      {
         this.popupBehavior.removePopup(param1);
      }
      
      override public function destroy() : void
      {
         this.removeItemSetsModelListeners();
         this.removeActiveItemSetListeners();
         this._championRendererFactory.destroy();
         super.destroy();
      }
      
      public function addPopup(param1:IDisplayChild) : void
      {
         this.popupBehavior.addPopup(param1);
      }
      
      override protected function createChildren() : void
      {
         this._background = new SpriteProxy(this);
         this._background.setTransformBehavior(new ScalingTransformBehavior());
         setTimelineChildByName("background",this._background);
         this._backgroundGlobal = new SpriteProxy(this);
         setTimelineChildByName("backgroundGlobal",this._backgroundGlobal);
         this._chooseChampionsText = new TextFieldProxy(this);
         setTimelineChildByName("chooseChampionsText",this._chooseChampionsText);
         this._chooseChampionsText.setText(ResourceManager.getInstance().getString("itemBrowser","itemSets_chooseChampionAssociations"));
         this._globalForChampionsRadioButton = new CheckBoxX(this);
         setTimelineChildByName("globalForChampionsCheckbox",this._globalForChampionsRadioButton);
         this._globalForChampionsRadioButton.setText(ResourceManager.getInstance().getString("itemBrowser","itemSets_setGlobalForChampionsLabel") + "  ");
         this._nonGlobalRadioButton = new CheckBoxX(this);
         setTimelineChildByName("nonGlobalCheckbox",this._nonGlobalRadioButton);
         this._nonGlobalRadioButton.setText(ResourceManager.getInstance().getString("itemBrowser","itemSets_setSpecificForChampionsLabel") + "  ");
         this._radioButtonGroup = new RadioButtonGroupX();
         this._radioButtonGroup.addRadioButton(this._globalForChampionsRadioButton);
         this._radioButtonGroup.addRadioButton(this._nonGlobalRadioButton);
         this._radioButtonGroup.getSelectedButtonChanged().add(this.handleSelectedRadioButtonChanged);
         this._ownedChampionCheckbox = new CheckBoxX(this);
         setTimelineChildByName("ownedChampionCheckbox",this._ownedChampionCheckbox);
         this._ownedChampionCheckbox.setText(ResourceManager.getInstance().getString("itemBrowser","itemSets_championFilter_owned") + "  ");
         this._ownedChampionCheckbox.getSelectedChanged().add(this.handleOwnedSelectionChange);
         this._championSearchInputText = new InputTextFieldProxy(this);
         setTimelineChildByName("searchBarTextInput",this._championSearchInputText);
         this._championSearchInputText.addEventListener(Event.CHANGE,this.handleSearchBarTextInput);
         this._championSearchInputText.setHintText(ResourceManager.getInstance().getString("itemBrowser","itemSets_championSearchBar_defaultText"));
         this._dataGroupSizer = new SpriteProxy(this);
         setTimelineChildByName("dataGroupSizer",this._dataGroupSizer);
         this._dataGroupSizer.setMouseEnabled(false);
         this._championRoleDropDown = new Dropdown(this);
         this._championRoleDropDown.listLinkage = "ItemSetChampionList";
         this._championRoleDropDown.listRendererLinkage = "ChampionRoleRenderer";
         this._championRoleDropDown.listRenderer = DefaultListItem;
         this._championRoleDropDown.labelField = "searchTagDisplayName";
         this._championRoleDropDown.selectionChanged.add(this.handleChampionFiltersChanged);
         this._championRoleDropDown.getLayoutInvalidated().add(invalidateLayout);
         setTimelineChildByName("championFilterSelectionView",this._championRoleDropDown);
         this._championDataGroup = new DataGroup(this);
         setTimelineChildByName("dataGroupContainer",this._championDataGroup);
         var _loc1_:VirtualizedTileLayout = new VirtualizedTileLayout();
         _loc1_.setHGap(0);
         _loc1_.setVGap(0);
         _loc1_.setPadding(new Padding(0,0,0,3));
         this._championDataGroup.setLayoutAlgorithm(_loc1_);
         this._championRendererFactory = new RendererFactory(ItemSetChampionListRenderer,[this]);
         this._championRendererFactory.getEntryConstructed().add(this.setupChampionRenderer);
         this._championDataGroup.setRendererFactory(this._championRendererFactory);
         this._championDataGroup.getLayoutInvalidated().add(invalidateLayout);
         this._championListView = new ListView(new ListX(new Vector.<ItemSetChampion>()));
         this._championListView.sortWithCompare(this.championSort);
         this._championListView.filter(this.championFilter);
         this._championDataGroup.setDataProvider(this._championListView);
         this._selectionBehavior = new SelectionBehavior(this._championRendererFactory,this._championListView);
         this._selectionBehavior.autoMultipleSelection = true;
         this._selectionBehavior.getSelectedItemsChanged().add(this.handleSelectedChampionsChanged);
         this.popupBehavior = new SimplePopupContextBehavior(this);
      }
      
      private function handleGlobalForChampionsSelectedChanged() : void
      {
         if(this._updatingSelectionStates || this._currentItemSet == null)
         {
            return;
         }
         this._itemSetsController.changeGlobalnessForChampionsOnCurrentItemSet(this._globalForChampionsRadioButton.getSelected());
         if(!this._globalForChampionsRadioButton.getSelected() && this._currentItemSet.getAssignedChampions().length == 0)
         {
            this._updatingSelectionStates = true;
            this._itemSetsController.changeGlobalnessForChampionsOnCurrentItemSet(true);
            this._updatingSelectionStates = false;
         }
      }
      
      private function championSort(param1:ItemSetChampion, param2:ItemSetChampion) : Number
      {
         return this._itemSetsModel.getChampionFilter().sortByDisplayName(param1.getChampion(),param2.getChampion());
      }
      
      private function handleSelectedRadioButtonChanged() : void
      {
         this.handleGlobalForChampionsSelectedChanged();
      }
      
      public function setPosition(param1:DisplayObjectProxy, param2:DisplayObjectProxy, param3:int, param4:int) : void
      {
         this.popupBehavior.setPosition(param1,param2,param3,param4);
      }
      
      private function handleSelectedChampionsChanged() : void
      {
         var _loc2_:ItemSetChampion = null;
         if(this._updatingSelectionStates || !this._currentItemSet)
         {
            return;
         }
         var _loc1_:Vector.<uint> = new Vector.<uint>();
         for each(_loc2_ in this._itemSetsModel.getItemSetChampions())
         {
            if(this._selectionBehavior.getItemIsSelected(_loc2_))
            {
               _loc1_.push(_loc2_.getChampionID());
            }
         }
         this._itemSetsController.changeGlobalnessForChampionsOnCurrentItemSet(_loc1_.length == 0);
         this._itemSetsController.setChampionAssignments(_loc1_);
      }
      
      private function addItemSetsModelListeners() : void
      {
         if(this._itemSetsModel)
         {
            this._itemSetsModel.getItemSetChampionsChanged().add(this.handleItemSetChampionsChanged);
            this._itemSetsModel.getActiveItemSetChanged().add(this.handleActiveItemSetChanged);
         }
      }
      
      private function handleOwnedSelectionChange() : void
      {
         if(this._ownedChampionCheckbox.getSelected())
         {
            this._itemSetsModel.getChampionFilter().setOwnedState(ChampionAvailabilityEnums.FILTER_OWNED);
         }
         else
         {
            this._itemSetsModel.getChampionFilter().setOwnedState(ChampionAvailabilityEnums.FILTER_ALL);
         }
         this._championListView.reset();
      }
      
      private function championFilter(param1:ItemSetChampion, param2:int = -1, param3:Array = null) : Boolean
      {
         return this._itemSetsModel.getChampionFilter().filter(param1.getChampion(),param2,param3);
      }
      
      private function addActiveItemSetListeners() : void
      {
         if(this._currentItemSet)
         {
            this._currentItemSet.getIsGlobalForChampionsChanged().add(this.handleGlobalnessForActivePageChanged);
         }
      }
      
      private function handleGlobalnessForActivePageChanged() : void
      {
         if(this._updatingSelectionStates)
         {
            return;
         }
         this.updateRadioButtonSelection();
      }
      
      private function handleChampionFiltersChanged() : void
      {
         var _loc1_:SearchTagData = this._championRoleDropDown.data[this._championRoleDropDown.selectedIndex];
         this._itemSetsModel.getChampionFilter().setTagState(_loc1_,true,true);
         this._championListView.reset();
      }
      
      private function removeItemSetsModelListeners() : void
      {
         if(this._itemSetsModel)
         {
            this._itemSetsModel.getItemSetChampionsChanged().remove(this.handleItemSetChampionsChanged);
            this._itemSetsModel.getActiveItemSetChanged().remove(this.handleActiveItemSetChanged);
         }
      }
      
      private function handleItemSetChampionsChanged() : void
      {
         var _loc1_:Vector.<ItemSetChampion> = this._itemSetsModel ? this._itemSetsModel.getItemSetChampions() : null;
         this._championListView.setSource(_loc1_);
      }
      
      private function handleActiveItemSetChanged() : void
      {
         var _loc1_:Vector.<Object> = null;
         var _loc2_:ItemSetChampion = null;
         if(Boolean(this._itemSetsModel) && Boolean(this._itemSetsModel.getActiveItemSet()))
         {
            this._updatingSelectionStates = true;
            this.removeActiveItemSetListeners();
            this._currentItemSet = this._itemSetsModel.getActiveItemSet();
            this.addActiveItemSetListeners();
            this._selectionBehavior.clearSelection();
            _loc1_ = new Vector.<Object>();
            for each(_loc2_ in this._itemSetsModel.getItemSetChampions())
            {
               if(this._currentItemSet.getAssignedChampions().indexOf(_loc2_.getChampionID()) != -1)
               {
                  _loc1_.push(_loc2_);
               }
            }
            this._selectionBehavior.setSelectedItems(_loc1_,false);
            this.updateRadioButtonSelection();
            this._updatingSelectionStates = false;
         }
      }
      
      private function updateRadioButtonSelection() : void
      {
         this._updatingSelectionStates = true;
         if(this._currentItemSet.getIsGlobalForChampions())
         {
            this._radioButtonGroup.setSelectedButton(this._globalForChampionsRadioButton);
            setCurrentState("global");
            invalidateLayout();
         }
         else
         {
            this._radioButtonGroup.setSelectedButton(this._nonGlobalRadioButton);
            setCurrentState("notGlobal");
            invalidateLayout();
         }
         this._updatingSelectionStates = false;
      }
      
      private function handleSearchBarTextInput(param1:Event) : void
      {
         this._itemSetsModel.getChampionFilter().setFilterString(this._championSearchInputText.getText().toLowerCase());
         this._championListView.reset();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         if(getCurrentState() == "global")
         {
            this._backgroundGlobal.setExplicitSize(NaN,NaN);
            return new Rectangle(0,0,this._backgroundGlobal.getWidth(),this._backgroundGlobal.getHeight());
         }
         var _loc3_:Point = this._championDataGroup.setExplicitSize(this._dataGroupSizer.getWidth(),NaN);
         this._championDataGroup.setExplicitPosition(this._dataGroupSizer.getX(),this._dataGroupSizer.getY());
         var _loc4_:Point = this._championRoleDropDown.setExplicitSize(NaN,NaN);
         var _loc5_:Number = Math.max(_loc3_.y + this._dataGroupSizer.getY(),_loc4_.y + this._championRoleDropDown.getBoundsWithDropDown().height);
         this._background.setExplicitSize(NaN,_loc5_ + 10);
         return new Rectangle(0,0,this._background.getWidth(),this._background.getHeight());
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
            this._championRoleDropDown.data = this._itemSetsModel.getChampionFilterTags();
            this.handleItemSetChampionsChanged();
            this.handleActiveItemSetChanged();
            if(this._itemSetsModel)
            {
               this.addItemSetsModelListeners();
            }
         }
      }
      
      private function setupChampionRenderer(param1:LayoutEntry, param2:ItemSetChampion) : void
      {
         var _loc3_:ItemSetChampionListRenderer = param1.element as ItemSetChampionListRenderer;
         _loc3_.setItemSetsModel(this._itemSetsModel);
      }
   }
}

