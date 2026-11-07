package com.riotgames.pvpnet.itembrowser.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.list.DataGroup;
   import blix.components.list.RendererFactory;
   import blix.components.list.SelectionBehavior;
   import blix.components.renderer.IItemRenderer;
   import blix.context.IContext;
   import blix.ds.ListView;
   import blix.ds.ListX;
   import blix.layout.algorithms.VirtualizedVerticalLayout;
   import blix.layout.vo.Padding;
   import com.riotgames.pvpnet.itembrowser.controller.ItemSetsController;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSet;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetChampion;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetsModel;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ItemSetListChampionPagesRenderer extends SpriteProxy implements IItemRenderer
   {
      
      private var _pagesList:ListView;
      
      private var _rendererFactory:RendererFactory;
      
      private var _itemSetsModel:ItemSetsModel;
      
      private var _index:uint;
      
      private var _championHeaderRenderer:ItemSetListChampionHeaderRenderer;
      
      private var _itemSetChampion:ItemSetChampion;
      
      private var _itemSetsController:ItemSetsController;
      
      private var _updatingSelection:Boolean = false;
      
      private var _activeItemSet:ItemSet;
      
      private var _pagesDataGroup:DataGroup;
      
      private var _selectionBehavior:SelectionBehavior;
      
      public function ItemSetListChampionPagesRenderer(param1:IContext, param2:Sprite = null)
      {
         if(!param2)
         {
            param2 = new Sprite();
         }
         super(param1,param2);
         this._itemSetsController = getDependency(ItemSetsController);
      }
      
      override public function destroy() : void
      {
         this.removeItemSetChampionListeners();
         this.removeActiveItemSetListeners();
         this.removeItemSetsModelListeners();
         super.destroy();
      }
      
      private function handleSelectedPageChanged() : void
      {
         if(this._updatingSelection)
         {
            return;
         }
         var _loc1_:ItemSet = this._selectionBehavior.getSelectedItem() as ItemSet;
         if(_loc1_)
         {
            this._itemSetsController.changeActiveItemSet(_loc1_);
         }
      }
      
      private function filterChampionPages(param1:ItemSet, param2:int, param3:Array) : Boolean
      {
         return !param1.getIsGlobalForChampions() && param1.getAssignedChampions().length == 1;
      }
      
      private function addItemSetChampionListeners() : void
      {
         if(this._itemSetChampion)
         {
            this._itemSetChampion.getAssignedItemSetsChanged().add(this.handleAssignedItemSetsChanged);
         }
      }
      
      public function setItemSetsModel(param1:ItemSetsModel) : void
      {
         if(param1 != this._itemSetsModel)
         {
            if(this._itemSetsModel)
            {
               this.removeItemSetsModelListeners();
            }
            this._itemSetsModel = param1;
            this.handleActiveItemSetChanged();
            this.addItemSetsModelListeners();
         }
      }
      
      private function updateSelectionState() : void
      {
         this._updatingSelection = true;
         this._selectionBehavior.clearSelection();
         if(!this._itemSetChampion || !this._activeItemSet)
         {
            return;
         }
         if(this._activeItemSet.isChampionIdAssignedToThisItemSet(this._itemSetChampion.getChampionID()))
         {
            this._selectionBehavior.setItemIsSelected(this._activeItemSet,true);
         }
         this._updatingSelection = false;
      }
      
      public function setItemSetChampion(param1:ItemSetChampion) : void
      {
         if(param1 != this._itemSetChampion)
         {
            if(this._itemSetChampion)
            {
               this.removeItemSetChampionListeners();
            }
            this._itemSetChampion = param1;
            this._championHeaderRenderer.setModel(this._itemSetChampion);
            if(this._itemSetChampion)
            {
               this.addItemSetChampionListeners();
               this.handleAssignedItemSetsChanged();
               this.handleActiveItemSetChanged();
            }
         }
      }
      
      private function addActiveItemSetListeners() : void
      {
         if(this._activeItemSet)
         {
            this._activeItemSet.getIsGlobalForChampionsChanged().add(this.refreshPagesList);
            this._activeItemSet.getTitleChanged().add(this.refreshPagesList);
            this._activeItemSet.getAssignedChampionsChanged().add(this.updateSelectionState);
            this._activeItemSet.getAssignedChampionsChanged().add(this.refreshPagesList);
         }
      }
      
      private function handleActiveItemSetChanged() : void
      {
         this.removeActiveItemSetListeners();
         this._activeItemSet = this._itemSetsModel.getActiveItemSet();
         this.addActiveItemSetListeners();
         this.updateSelectionState();
      }
      
      override protected function createChildren() : void
      {
         this._championHeaderRenderer = new ItemSetListChampionHeaderRenderer(this);
         this._championHeaderRenderer.getLayoutInvalidated().add(invalidateLayout);
         addChild(this._championHeaderRenderer);
         this._rendererFactory = new RendererFactory(ItemSetPageListRenderer,[this]);
         this._pagesList = new ListView(new ListX(new Vector.<ItemSet>()));
         this._pagesList.filter(this.filterChampionPages);
         this._pagesList.sortWithCompare(this.sortChampionPages);
         var _loc1_:VirtualizedVerticalLayout = new VirtualizedVerticalLayout();
         _loc1_.setGap(2);
         var _loc2_:Padding = new Padding(5,0,0,0);
         _loc1_.setPadding(_loc2_);
         this._pagesDataGroup = new DataGroup(this,null,null,new Sprite());
         this._pagesDataGroup.setRendererFactory(this._rendererFactory);
         this._pagesDataGroup.setDataProvider(this._pagesList);
         this._pagesDataGroup.getLayoutInvalidated().add(invalidateLayout);
         this._pagesDataGroup.setLayoutAlgorithm(_loc1_);
         addChild(this._pagesDataGroup);
         this._selectionBehavior = new SelectionBehavior(this._rendererFactory,this._pagesList);
         this._selectionBehavior.allowMultipleSelection = false;
         this._selectionBehavior.getSelectedItemsChanged().add(this.handleSelectedPageChanged);
         super.createChildren();
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
      
      private function sortChampionPages(param1:ItemSet, param2:ItemSet) : Number
      {
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
         var _loc3_:String = param1.title.toLowerCase();
         var _loc4_:String = param2.title.toLowerCase();
         return _loc4_ > _loc3_ ? -1 : 1;
      }
      
      private function removeItemSetsModelListeners() : void
      {
         if(this._itemSetsModel)
         {
            this._itemSetsModel.getActiveItemSetChanged().remove(this.handleActiveItemSetChanged);
         }
      }
      
      private function handleAssignedItemSetsChanged() : void
      {
         this._pagesList.setSource(this._itemSetChampion.getAssignedItemSets());
         this.updateSelectionState();
         this._pagesList.reset();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = this._championHeaderRenderer.setExplicitSize(NaN,NaN);
         var _loc4_:Point = this._pagesDataGroup.setExplicitSize(NaN,NaN);
         this._pagesDataGroup.setExplicitPosition(0,_loc3_.y);
         return new Rectangle(0,0,Math.max(_loc3_.x,_loc4_.x),_loc4_.y + _loc3_.y);
      }
      
      public function setIndex(param1:uint) : void
      {
         this._index = param1;
      }
      
      private function removeItemSetChampionListeners() : void
      {
         if(this._itemSetChampion)
         {
            this._itemSetChampion.getAssignedItemSetsChanged().remove(this.handleAssignedItemSetsChanged);
         }
      }
      
      public function setData(param1:*) : void
      {
         this.setItemSetChampion(param1);
      }
      
      private function refreshPagesList() : void
      {
         this._pagesList.reset();
      }
      
      public function getData() : *
      {
         return this._itemSetChampion;
      }
      
      private function removeActiveItemSetListeners() : void
      {
         if(this._activeItemSet)
         {
            this._activeItemSet.getIsGlobalForChampionsChanged().remove(this.refreshPagesList);
            this._activeItemSet.getTitleChanged().remove(this.refreshPagesList);
            this._activeItemSet.getAssignedChampionsChanged().remove(this.updateSelectionState);
            this._activeItemSet.getAssignedChampionsChanged().remove(this.refreshPagesList);
         }
      }
      
      private function addItemSetsModelListeners() : void
      {
         if(this._itemSetsModel)
         {
            this._itemSetsModel.getActiveItemSetChanged().add(this.handleActiveItemSetChanged);
         }
      }
   }
}

