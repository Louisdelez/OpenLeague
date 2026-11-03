package com.riotgames.pvpnet.itembrowser.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.list.DataGroup;
   import blix.components.list.RendererFactory;
   import blix.components.list.SelectionBehavior;
   import blix.context.IContext;
   import blix.ds.ListView;
   import blix.ds.ListX;
   import blix.layout.algorithms.VirtualizedVerticalLayout;
   import com.riotgames.pvpnet.itembrowser.controller.ItemSetsController;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSet;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetsModel;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ItemSetMultiAssignmentPagesView extends SpriteProxy
   {
      
      private var _pagesList:ListView;
      
      private var _rendererFactory:RendererFactory;
      
      private var _itemSetsController:ItemSetsController;
      
      private var _model:ItemSetsModel;
      
      private var _dividerGraphic:SpriteProxy;
      
      private var _pagesDataGroup:DataGroup;
      
      private var _activeItemSet:ItemSet;
      
      private var _selectionBehavior:SelectionBehavior;
      
      public function ItemSetMultiAssignmentPagesView(param1:IContext, param2:Sprite = null)
      {
         if(!param2)
         {
            param2 = new Sprite();
         }
         super(param1,param2);
         this._itemSetsController = getDependency(ItemSetsController);
      }
      
      private function removeActiveItemSetListeners() : void
      {
         if(this._activeItemSet)
         {
            this._activeItemSet.getAssignedChampionsChanged().remove(this.refreshPagesList);
            this._activeItemSet.getIsGlobalForChampionsChanged().remove(this.refreshPagesList);
            this._activeItemSet.getTitleChanged().remove(this.refreshPagesList);
         }
      }
      
      private function handleSelectedPageChanged() : void
      {
         var _loc1_:ItemSet = this._selectionBehavior.getSelectedItem() as ItemSet;
         if(_loc1_)
         {
            this._itemSetsController.changeActiveItemSet(_loc1_);
         }
      }
      
      override public function destroy() : void
      {
         this._rendererFactory.destroy();
         this.removeModelListeners();
         this.removeActiveItemSetListeners();
         super.destroy();
      }
      
      private function sortPages(param1:ItemSet, param2:ItemSet) : Number
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
      
      private function handleItemSetsChanged() : void
      {
         if(!this._model)
         {
            this._pagesList.setSource(new Vector.<ItemSet>());
         }
         else
         {
            this._pagesList.setSource(this._model.getItemSets());
         }
      }
      
      private function removeModelListeners() : void
      {
         if(this._model)
         {
            this._model.getItemSetsChanged().remove(this.handleItemSetsChanged);
            this._model.getActiveItemSetChanged().remove(this.handleActiveItemSetChanged);
         }
      }
      
      private function handleActiveItemSetChanged() : void
      {
         if(this._activeItemSet == this._model.getActiveItemSet())
         {
            return;
         }
         if(this._activeItemSet)
         {
            this.removeActiveItemSetListeners();
         }
         this._selectionBehavior.clearSelection();
         if(Boolean(this._model) && Boolean(this._model.getActiveItemSet()))
         {
            this._activeItemSet = this._model.getActiveItemSet();
            this.addActiveItemSetListeners();
            this._selectionBehavior.setItemIsSelected(this._activeItemSet,true);
         }
         else
         {
            this._activeItemSet = null;
         }
      }
      
      private function addActiveItemSetListeners() : void
      {
         if(this._activeItemSet)
         {
            this._activeItemSet.getAssignedChampionsChanged().add(this.refreshPagesList);
            this._activeItemSet.getIsGlobalForChampionsChanged().add(this.refreshPagesList);
            this._activeItemSet.getTitleChanged().add(this.refreshPagesList);
         }
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = new Point();
         _loc3_ = this._pagesDataGroup.setExplicitSize(NaN,NaN);
         this._pagesDataGroup.setExplicitPosition(0,15);
         return new Rectangle(0,0,_loc3_.x,_loc3_.y + 15);
      }
      
      override protected function createChildren() : void
      {
         this._rendererFactory = new RendererFactory(ItemSetPageListRenderer,[this]);
         this._pagesList = new ListView(new ListX(new Vector.<ItemSet>()));
         this._pagesList.filter(this.filterPages);
         this._pagesList.sortWithCompare(this.sortPages);
         this._dividerGraphic = new SpriteProxy(this);
         this._dividerGraphic.setLinkage("ParchmentDivider");
         addChild(this._dividerGraphic);
         var _loc1_:VirtualizedVerticalLayout = new VirtualizedVerticalLayout();
         _loc1_.setGap(3);
         this._pagesDataGroup = new DataGroup(this);
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
      
      private function addModelListeners() : void
      {
         if(this._model)
         {
            this._model.getItemSetsChanged().add(this.handleItemSetsChanged);
            this._model.getActiveItemSetChanged().add(this.handleActiveItemSetChanged);
         }
      }
      
      public function setModel(param1:ItemSetsModel) : void
      {
         if(param1 != this._model)
         {
            this.removeModelListeners();
            this._model = param1;
            this.handleItemSetsChanged();
            this.handleActiveItemSetChanged();
            this.addModelListeners();
         }
      }
      
      private function filterPages(param1:ItemSet, param2:int, param3:Array) : Boolean
      {
         return !param1.getIsGlobalForChampions() && param1.getAssignedChampions().length > 1;
      }
      
      private function refreshPagesList() : void
      {
         this._pagesList.reset();
      }
   }
}

