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
   import blix.layout.LayoutEntry;
   import blix.layout.algorithms.VirtualizedVerticalLayout;
   import blix.layout.vo.Padding;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSet;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetChampion;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ItemSetSelectChampionPagesRenderer extends SpriteProxy implements IItemRenderer
   {
      
      private var _pagesList:ListView;
      
      private var _rendererFactory:RendererFactory;
      
      private var _index:uint;
      
      private var _selectionBehavior:SelectionBehavior;
      
      private var _championHeaderRenderer:ItemSetListChampionHeaderRenderer;
      
      private var _itemSetChampion:ItemSetChampion;
      
      private var _selectedPagesChanged:Signal = new Signal();
      
      private var _pagesDataGroup:DataGroup;
      
      private var _itemSetMouseDown:Signal = new Signal();
      
      public function ItemSetSelectChampionPagesRenderer(param1:IContext)
      {
         super(param1,new Sprite());
      }
      
      public function getSelectedPagesChanged() : ISignal
      {
         return this._selectedPagesChanged;
      }
      
      private function handleSelectedPageChanged() : void
      {
         var _loc2_:Object = null;
         var _loc1_:Vector.<ItemSet> = new Vector.<ItemSet>();
         for each(_loc2_ in this._selectionBehavior.getSelectedItems())
         {
            _loc1_.push(_loc2_ as ItemSet);
         }
         this._selectedPagesChanged.dispatch(this._itemSetChampion,_loc1_);
      }
      
      private function filterChampionPages(param1:ItemSet, param2:int, param3:Array) : Boolean
      {
         return !param1.getIsGlobalForChampions() && param1.getAssignedChampions().length == 1;
      }
      
      public function getItemSetMouseDown() : ISignal
      {
         return this._itemSetMouseDown;
      }
      
      public function setItemSetChampion(param1:ItemSetChampion) : void
      {
         if(param1 != this._itemSetChampion)
         {
            this._itemSetChampion = param1;
            this._championHeaderRenderer.setModel(this._itemSetChampion);
            this._pagesList.setSource(this._itemSetChampion.getAssignedItemSets());
         }
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = this._championHeaderRenderer.setExplicitSize(NaN,NaN);
         var _loc4_:Point = this._pagesDataGroup.setExplicitSize(NaN,NaN);
         this._pagesDataGroup.setExplicitPosition(0,_loc3_.y);
         return new Rectangle(0,0,Math.max(_loc3_.x,_loc4_.x),_loc4_.y + _loc3_.y);
      }
      
      override protected function createChildren() : void
      {
         this._championHeaderRenderer = new ItemSetListChampionHeaderRenderer(this);
         this._championHeaderRenderer.getLayoutInvalidated().add(invalidateLayout);
         this._championHeaderRenderer.setMouseChildren(false);
         this._championHeaderRenderer.setMouseEnabled(false);
         addChild(this._championHeaderRenderer);
         this._rendererFactory = new RendererFactory(ItemSetSelectPageRenderer,[this]);
         this._rendererFactory.getEntryActivated().add(this.prepareRenderer);
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
         this._selectionBehavior.allowMultipleSelection = true;
         this._selectionBehavior.autoMultipleSelection = true;
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
      
      private function handlePageMouseDown(param1:ItemSet) : void
      {
         this._itemSetMouseDown.dispatch(param1);
      }
      
      public function getData() : *
      {
         return this._itemSetChampion;
      }
      
      public function setIndex(param1:uint) : void
      {
         this._index = param1;
      }
      
      public function setData(param1:*) : void
      {
         this.setItemSetChampion(param1);
      }
      
      private function prepareRenderer(param1:LayoutEntry, param2:ItemSet) : void
      {
         var _loc3_:ItemSetSelectPageRenderer = param1.element as ItemSetSelectPageRenderer;
         _loc3_.getMouseDown().add(this.handlePageMouseDown);
      }
      
      override public function destroy() : void
      {
         this._rendererFactory.destroy();
         super.destroy();
      }
   }
}

