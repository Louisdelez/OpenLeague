package com.riotgames.pvpnet.itembrowser.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.button.LabelButtonX;
   import blix.components.list.DataScroller;
   import blix.components.list.RendererFactory;
   import blix.components.scroll.ScrollArea;
   import blix.components.scroll.ScrollPolicy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.ds.ListView;
   import blix.ds.ListX;
   import blix.layout.LayoutEntry;
   import blix.layout.algorithms.VerticalLayout;
   import blix.layout.algorithms.VirtualizedVerticalLayout;
   import com.riotgames.gameItems.model.GameItem;
   import com.riotgames.gameItems.model.ItemCategory;
   import com.riotgames.gameItems.model.ItemTag;
   import com.riotgames.pvpnet.itembrowser.model.ItemBrowserModel;
   import com.riotgames.pvpnet.tracking.trackers.itemset.IItemSetsBehaviorTracker;
   import com.riotgames.pvpnet.tracking.trackers.itemset.IItemSetsOrganizationalStructureTracker;
   import com.riotgames.rust.components.text.InputTextFieldProxy;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.events.NativeDragEvent;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import mx.resources.ResourceManager;
   
   public class ItemBrowserItemNavigatorView extends StatefulView
   {
      
      private static const STATE_ITEM_LISTING:String = "itemListing";
      
      private static const STATE_ITEM_DETAILS:String = "itemDetails";
      
      private var _itemListParent:SpriteProxy;
      
      private var _searchText:String = "";
      
      private var _searchClearButton:ButtonX;
      
      private var _selectedCategory:ItemCategory;
      
      private var _itemSetsBehaviorTracker:IItemSetsBehaviorTracker;
      
      private var _categoryListParent:SpriteProxy;
      
      private var _categoryListContainer:ScrollArea;
      
      private var _model:ItemBrowserModel;
      
      private var allItems:ListView;
      
      private var _itemTreeContainer:ItemBrowserRecipePanel;
      
      private var _selectedTags:Vector.<ItemTag> = new Vector.<ItemTag>();
      
      private var _categoryListSizer:SpriteProxy;
      
      private var _aliasCache:Dictionary;
      
      private var _buildsToLabel:TextFieldProxy;
      
      private var isPossibleSearching:Boolean = false;
      
      private var _itemListSizer:SpriteProxy;
      
      private var _searchBarTextInput:InputTextFieldProxy;
      
      private var _itemSetsOrganizationalStructureTracker:IItemSetsOrganizationalStructureTracker;
      
      private var hasSearchedForSomething:Boolean = false;
      
      private var _itemNameLabel:TextFieldProxy;
      
      private var _goBackButton:LabelButtonX;
      
      private var _categoryHeaderRenderers:Vector.<ItemBrowserHeaderRenderer>;
      
      private var _requiresLabel:TextFieldProxy;
      
      private var _itemBuildsToContainer:ItemBrowserBuildsToView;
      
      private var _tagRenderers:Vector.<ItemBrowserCategoryRenderer>;
      
      private var _itemListContainer:DataScroller;
      
      public function ItemBrowserItemNavigatorView(param1:IContext, param2:MovieClip = null, param3:IItemSetsBehaviorTracker = null, param4:IItemSetsOrganizationalStructureTracker = null)
      {
         super(param1,param2);
         this._itemSetsBehaviorTracker = param3;
         this._itemSetsOrganizationalStructureTracker = param4;
         setCurrentState(STATE_ITEM_LISTING);
      }
      
      private function handleSearchBarFocusOut(param1:Event) : void
      {
         if(this.isPossibleSearching && this.hasSearchedForSomething)
         {
            this._itemSetsBehaviorTracker.incrementItemSets_UserItemSearchBarUsed_Count_InASession();
         }
         this.isPossibleSearching = false;
         this.hasSearchedForSomething = false;
      }
      
      private function refreshFilterAndSort() : void
      {
         this.allItems.reset();
         this._itemListContainer.setPosition(0);
      }
      
      private function itemsSort(param1:GameItem, param2:GameItem) : Number
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(param1 == param2)
         {
            return 0;
         }
         if(param2 == null)
         {
            return -1;
         }
         if(param1 == null)
         {
            return 1;
         }
         var _loc3_:String = param1.name.toLowerCase();
         var _loc4_:String = param2.name.toLowerCase();
         var _loc5_:int = int(param1.totalPrice);
         var _loc6_:int = int(param2.totalPrice);
         if(this._searchText != "" && this._searchText != null)
         {
            _loc7_ = _loc3_.indexOf(this._searchText.toLowerCase());
            _loc8_ = _loc4_.indexOf(this._searchText.toLowerCase());
            return _loc8_ > _loc7_ ? -1 : 1;
         }
         return _loc5_ < _loc6_ ? -1 : 1;
      }
      
      private function getAliasCache() : Dictionary
      {
         var _loc1_:GameItem = null;
         var _loc2_:String = null;
         var _loc3_:ItemTag = null;
         if(!this._aliasCache)
         {
            this._aliasCache = new Dictionary();
            for each(_loc1_ in this._model.allItems)
            {
               for each(_loc2_ in _loc1_.aliases)
               {
                  this.appendToAliasCache(_loc2_.toLowerCase(),_loc1_);
               }
               for each(_loc3_ in _loc1_.tags)
               {
                  this.appendToAliasCache(_loc3_.tag.toLowerCase(),_loc1_);
                  for each(_loc2_ in _loc3_.aliases)
                  {
                     this.appendToAliasCache(_loc2_.toLowerCase(),_loc1_);
                  }
               }
            }
         }
         return this._aliasCache;
      }
      
      private function handleActiveItemChanged(param1:GameItem) : void
      {
         if(_currentState == STATE_ITEM_DETAILS)
         {
            this._itemSetsBehaviorTracker.incrementItemSets_PageVisits_Navigation_ViaItemTree_Count_InASession(param1.name);
         }
         setCurrentState(STATE_ITEM_DETAILS);
         if(param1 != null)
         {
            this._itemSetsBehaviorTracker.incrementItemSets_UserSwitchedToItemDetailFromItemBrowser_Count_InASession(param1.name);
         }
         this._itemTreeContainer.setModel(param1);
         this._itemBuildsToContainer.setModel(param1);
         this._itemNameLabel.setText(param1.name);
      }
      
      private function selectTag(param1:ItemTag) : void
      {
         var _loc2_:int = this._selectedTags.indexOf(param1);
         if(_loc2_ == -1)
         {
            this._selectedTags[this._selectedTags.length] = param1;
            this.refreshCategoryAndTagRenderers();
         }
      }
      
      private function handleHeaderClicked(param1:ItemBrowserHeaderRenderer) : void
      {
         this.clearSearchText();
         var _loc2_:ItemCategory = param1.getModel();
         if(!param1.getSelected())
         {
            this.setSelectedCategory(_loc2_);
         }
         else
         {
            this.setSelectedCategory(this._model.getItemCategoryById(-1));
         }
         this._itemSetsBehaviorTracker.incrementItemSets_UserCategoryActualNameClicked_Count_InASession();
      }
      
      private function handleSearchBarFocusIn(param1:Event) : void
      {
         this.isPossibleSearching = true;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.setGap(2);
         this._categoryListContainer = new ScrollArea(this);
         this._categoryListContainer.setLinkage("ScrollContainer");
         this._categoryListContainer.setVScrollPolicy(ScrollPolicy.AUTO);
         this._categoryListContainer.setHScrollPolicy(ScrollPolicy.OFF);
         this._categoryListContainer.getContents().setLayoutAlgorithm(_loc1_);
         this._categoryListContainer.getLayoutInvalidated().add(invalidateLayout);
         this._categoryListContainer.mouseDelta = 20;
         this._categoryListParent = new SpriteProxy(this);
         setTimelineChildByName("categoryListParent",this._categoryListParent);
         this._categoryListParent.addChild(this._categoryListContainer);
         this._categoryListParent.addEventListener(MouseEvent.CLICK,this.onCategoryListClicked);
         this._categoryListSizer = new SpriteProxy(this);
         this._categoryListParent.setTimelineChildByName("sizer",this._categoryListSizer);
         var _loc2_:VirtualizedVerticalLayout = new VirtualizedVerticalLayout();
         _loc2_.setGap(0);
         this._itemListContainer = new DataScroller(this);
         this._itemListContainer.setLinkage("ScrollContainer");
         this._itemListContainer.setScrollPolicy(ScrollPolicy.AUTO);
         this._itemListContainer.setLayoutAlgorithm(_loc2_);
         this._itemListContainer.getLayoutInvalidated().add(invalidateLayout);
         var _loc3_:RendererFactory = new RendererFactory(GameItemRenderer,[this,"ItemListDetailedRenderer",true]);
         _loc3_.getEntryActivated().add(this.activateGameItemRenderer);
         _loc3_.getEntryDeactivated().add(this.deactivateGameItemRenderer);
         this._itemListContainer.setRendererFactory(_loc3_);
         this.allItems = new ListView(new ListX(new Vector.<GameItem>()));
         this.allItems.filter(this.itemsFilter);
         this.allItems.sortWithCompare(this.itemsSort);
         this._itemListContainer.setDataProvider(this.allItems);
         this._itemListParent = new SpriteProxy(this);
         setTimelineChildByName("itemListParent",this._itemListParent);
         this._itemListParent.addChild(this._itemListContainer);
         this._itemListSizer = new SpriteProxy(this);
         this._itemListParent.setTimelineChildByName("sizer",this._itemListSizer);
         this._itemTreeContainer = new ItemBrowserRecipePanel(this);
         setTimelineChildByName("recipeTreeContainer",this._itemTreeContainer);
         this._itemBuildsToContainer = new ItemBrowserBuildsToView(this);
         setTimelineChildByName("buildsToContainer",this._itemBuildsToContainer);
         this._searchBarTextInput = new InputTextFieldProxy(this);
         setTimelineChildByName("searchBarTextInput",this._searchBarTextInput);
         this._searchBarTextInput.addEventListener(Event.CHANGE,this.handleSearchBarTextInput);
         this._searchBarTextInput.addEventListener(FocusEvent.FOCUS_IN,this.handleSearchBarFocusIn);
         this._searchBarTextInput.addEventListener(FocusEvent.FOCUS_OUT,this.handleSearchBarFocusOut);
         this._searchBarTextInput.setHintText(ResourceManager.getInstance().getString("itemBrowser","itemBrowser_itemSearchBar_defaultText"));
         this._searchClearButton = new ButtonX(this);
         setTimelineChildByName("clearButton",this._searchClearButton);
         this._searchClearButton.addEventListener(MouseEvent.CLICK,this.clearHandler);
         this._goBackButton = new LabelButtonX(this);
         setTimelineChildByName("goBackButton",this._goBackButton);
         this._goBackButton.setText(ResourceManager.getInstance().getString("itemBrowser","itemBrowser_goBackButton"));
         this._goBackButton.addEventListener(MouseEvent.CLICK,this.handleBackButton);
         this._itemNameLabel = new TextFieldProxy(this);
         setTimelineChildByName("textFieldContainer.itemNameLabel",this._itemNameLabel);
         this._itemNameLabel.setText("");
         this._buildsToLabel = new TextFieldProxy(this);
         setTimelineChildByName("textFieldContainer.buildsToLabel",this._buildsToLabel);
         this._buildsToLabel.setText(ResourceManager.getInstance().getString("itemBrowser","itemBrowser_buildsInto"));
         this._requiresLabel = new TextFieldProxy(this);
         setTimelineChildByName("textFieldContainer.requiresLabel",this._requiresLabel);
         this._requiresLabel.setText(ResourceManager.getInstance().getString("itemBrowser","itemBrowser_requires"));
      }
      
      private function deactivateGameItemRenderer(param1:LayoutEntry) : void
      {
         var _loc2_:GameItemRenderer = param1.element as GameItemRenderer;
      }
      
      private function deselectTag(param1:ItemTag) : void
      {
         var _loc2_:int = this._selectedTags.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._selectedTags.splice(_loc2_,1);
            this.refreshCategoryAndTagRenderers();
         }
      }
      
      private function clearSearchText() : void
      {
         this._searchBarTextInput.setText("");
         this._searchText = "";
         this.refreshCategoryAndTagRenderers();
      }
      
      private function appendToAliasCache(param1:String, param2:GameItem) : void
      {
         if(!this._aliasCache[param1])
         {
            this._aliasCache[param1] = new Dictionary();
         }
         this._aliasCache[param1][param2] = true;
      }
      
      private function handleItemsChanged() : void
      {
         if(this._model != null)
         {
            this.allItems.setSource(this._model.allItems);
         }
         else
         {
            this.allItems.setSource(new Vector.<GameItem>());
         }
      }
      
      private function setSelectedCategory(param1:ItemCategory) : void
      {
         if(this._selectedCategory == param1)
         {
            return;
         }
         this._selectedTags.length = 0;
         this._selectedCategory = param1;
         this.refreshCategoryAndTagRenderers();
      }
      
      private function clearHandler(param1:MouseEvent) : void
      {
         this.clearSearchText();
      }
      
      private function getCategoryContainsShownItems(param1:ItemTag) : Boolean
      {
         var _loc2_:GameItem = null;
         for each(_loc2_ in this.allItems)
         {
            if(_loc2_.isInCategory(param1.tag))
            {
               return true;
            }
         }
         return false;
      }
      
      private function createItemCategoryRenderers() : void
      {
         var _loc1_:ItemBrowserHeaderRenderer = null;
         var _loc2_:ItemBrowserCategoryRenderer = null;
         var _loc3_:ItemCategory = null;
         var _loc4_:ItemTag = null;
         for each(_loc1_ in this._categoryHeaderRenderers)
         {
            removeChild(_loc1_);
            _loc1_.destroy();
         }
         for each(_loc2_ in this._tagRenderers)
         {
            removeChild(_loc2_);
            _loc2_.destroy();
         }
         this._categoryHeaderRenderers = new Vector.<ItemBrowserHeaderRenderer>();
         this._tagRenderers = new Vector.<ItemBrowserCategoryRenderer>();
         this._categoryListContainer.getContents().removeAllElements();
         if(this._model)
         {
            for each(_loc3_ in this._model.itemCategories)
            {
               _loc1_ = new ItemBrowserHeaderRenderer(this);
               _loc1_.setModel(_loc3_);
               _loc1_.getClicked().add(this.handleHeaderClicked);
               _loc1_.setSelected(_loc3_ == this._selectedCategory);
               this._categoryHeaderRenderers[this._categoryHeaderRenderers.length] = _loc1_;
               this._categoryListContainer.getContents().addElement(_loc1_);
               for each(_loc4_ in _loc3_.tags)
               {
                  _loc2_ = new ItemBrowserCategoryRenderer(this);
                  _loc2_.setModel(_loc4_);
                  _loc2_.getClicked().add(this.handleTagClicked);
                  this._tagRenderers.push(_loc2_);
                  this._categoryListContainer.getContents().addElement(_loc2_);
               }
            }
         }
      }
      
      private function activateGameItemRenderer(param1:LayoutEntry, param2:GameItem) : void
      {
         var _loc3_:GameItemRenderer = param1.element as GameItemRenderer;
      }
      
      private function handleBackButton(param1:MouseEvent) : void
      {
         setCurrentState(STATE_ITEM_LISTING);
         this._itemSetsBehaviorTracker.incrementItemSets_UserSwitchedToItemBrowserFromItemDetail_Count_InASession();
      }
      
      private function handleDragComplete(param1:NativeDragEvent) : void
      {
         removeEventListener(NativeDragEvent.NATIVE_DRAG_COMPLETE,this.handleDragComplete);
      }
      
      private function itemsFilter(param1:GameItem, param2:int, param3:Array) : Boolean
      {
         var _loc4_:Dictionary = null;
         var _loc5_:Boolean = false;
         var _loc6_:ItemTag = null;
         var _loc7_:Boolean = false;
         var _loc8_:ItemTag = null;
         if(!param1.inStore)
         {
            return false;
         }
         if(this._searchText != "" && this._searchText != null)
         {
            _loc4_ = this.getAliasCache();
            if(_loc4_[this._searchText.toLowerCase()])
            {
               return _loc4_[this._searchText.toLowerCase()][param1];
            }
            _loc5_ = param1.name.toLowerCase().indexOf(this._searchText.toLowerCase()) != -1;
            if(!_loc5_)
            {
               return false;
            }
         }
         else
         {
            if(this._selectedCategory != null && this._selectedCategory.id != -1)
            {
               _loc7_ = false;
               if(param1.isInCategory(this._selectedCategory.name))
               {
                  _loc7_ = true;
               }
               else
               {
                  for each(_loc8_ in this._selectedCategory.tags)
                  {
                     if(param1.isInCategory(_loc8_.tag))
                     {
                        _loc7_ = true;
                        break;
                     }
                  }
               }
               if(!_loc7_)
               {
                  return false;
               }
            }
            for each(_loc6_ in this._selectedTags)
            {
               if(!param1.isInCategory(_loc6_.tag))
               {
                  return false;
               }
            }
         }
         return true;
      }
      
      private function handleSearchBarTextInput(param1:Event) : void
      {
         this._searchText = this._searchBarTextInput.getText();
         this.hasSearchedForSomething = true;
         this.deselectAllTags();
      }
      
      private function refreshCategoryAndTagRenderers() : void
      {
         var _loc1_:ItemBrowserHeaderRenderer = null;
         var _loc2_:ItemBrowserCategoryRenderer = null;
         var _loc3_:ItemTag = null;
         var _loc4_:int = 0;
         this.refreshFilterAndSort();
         for each(_loc1_ in this._categoryHeaderRenderers)
         {
            _loc1_.setSelected(_loc1_.getModel() == this._selectedCategory);
         }
         for each(_loc2_ in this._tagRenderers)
         {
            _loc3_ = _loc2_.getModel();
            _loc4_ = this._selectedTags.indexOf(_loc3_);
            _loc2_.setSelected(_loc4_ != -1);
            if(!!this._searchText || this.getCategoryContainsShownItems(_loc3_))
            {
               _loc2_.setAlpha(1);
               _loc2_.setEnabled(true);
            }
            else
            {
               _loc2_.setAlpha(0.6);
               _loc2_.setEnabled(false);
            }
         }
      }
      
      private function deselectAllTags() : void
      {
         this._selectedTags.length = 0;
         this.setSelectedCategory(this._model.getItemCategoryById(-1));
         this.refreshCategoryAndTagRenderers();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._categoryListContainer.setExplicitSize(this._categoryListSizer.getWidth(),this._categoryListSizer.getHeight());
         this._categoryListContainer.setExplicitPosition(this._categoryListSizer.getX(),this._categoryListSizer.getY());
         this._itemListContainer.setExplicitSize(this._itemListSizer.getWidth(),this._itemListSizer.getHeight());
         this._itemListContainer.setExplicitPosition(this._itemListSizer.getX(),this._itemListSizer.getY());
         return super.updateLayout(param1,param2);
      }
      
      public function setModel(param1:ItemBrowserModel) : void
      {
         if(this._model != param1)
         {
            if(this._model != null)
            {
               this._model.getItemsChanged().remove(this.handleItemsChanged);
               this._model.getItemCategoriesChanged().remove(this.handleCategoriesChanged);
               this._model.getActiveItemChanged().remove(this.handleActiveItemChanged);
            }
            this._model = param1;
            this._selectedCategory = null;
            this._selectedTags.length = 0;
            this.createItemCategoryRenderers();
            this.handleItemsChanged();
            if(this._model != null)
            {
               this._model.getItemsChanged().add(this.handleItemsChanged);
               this._model.getItemCategoriesChanged().add(this.handleCategoriesChanged);
               this._model.getActiveItemChanged().add(this.handleActiveItemChanged);
            }
         }
      }
      
      private function onCategoryListClicked(param1:MouseEvent) : void
      {
         this._itemSetsBehaviorTracker.incrementItemSets_PageVisits_Navigation_ViaCategoriesList_Count_InASession();
      }
      
      private function handleCategoriesChanged() : void
      {
         this.createItemCategoryRenderers();
      }
      
      private function handleTagClicked(param1:ItemBrowserCategoryRenderer) : void
      {
         this.clearSearchText();
         if(!param1.getSelected())
         {
            this.setSelectedCategory(null);
            this.selectTag(param1.getModel());
         }
         else
         {
            this.deselectTag(param1.getModel());
            if(this._selectedTags.length == 0)
            {
               this.setSelectedCategory(this._model.getItemCategoryById(-1));
            }
         }
         this._itemSetsBehaviorTracker.incrementItemSets_UserCategoryFilterCheckboxClicked_Count_InASession();
      }
   }
}

