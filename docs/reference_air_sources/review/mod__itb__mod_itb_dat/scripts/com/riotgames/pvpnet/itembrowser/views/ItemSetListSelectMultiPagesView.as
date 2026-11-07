package com.riotgames.pvpnet.itembrowser.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.list.DataGroup;
   import blix.components.list.RendererFactory;
   import blix.components.list.SelectionBehavior;
   import blix.context.IContext;
   import blix.ds.ListView;
   import blix.ds.ListX;
   import blix.layout.LayoutEntry;
   import blix.layout.algorithms.VirtualizedVerticalLayout;
   import blix.layout.vo.Padding;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSet;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ItemSetListSelectMultiPagesView extends SpriteProxy
   {
      
      private var _rendererFactory:RendererFactory;
      
      private var _globalPagesList:ListView;
      
      private var _selectedPagesChanged:Signal = new Signal();
      
      private var _pagesDataGroup:DataGroup;
      
      private var _itemSetMouseDown:Signal = new Signal();
      
      private var _dividerGraphic:SpriteProxy;
      
      private var _selectionBehavior:SelectionBehavior;
      
      public function ItemSetListSelectMultiPagesView(param1:IContext)
      {
         super(param1,new Sprite());
      }
      
      public function setItemSets(param1:Vector.<ItemSet>) : void
      {
         this._selectionBehavior.clearSelection();
         this._globalPagesList.setSource(param1);
      }
      
      private function filterGlobalPages(param1:ItemSet, param2:int, param3:Array) : Boolean
      {
         return !param1.getIsGlobalForChampions() && param1.getAssignedChampions().length > 1;
      }
      
      public function getItemSetMouseDown() : ISignal
      {
         return this._itemSetMouseDown;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = new Point();
         _loc3_ = this._pagesDataGroup.setExplicitSize(NaN,NaN);
         this._pagesDataGroup.setExplicitPosition(0,15);
         return new Rectangle(0,0,_loc3_.x,_loc3_.y + 15);
      }
      
      private function handlePageMouseDown(param1:ItemSet) : void
      {
         this._itemSetMouseDown.dispatch(param1);
      }
      
      public function getSelectedPagesChanged() : ISignal
      {
         return this._selectedPagesChanged;
      }
      
      private function handleSelectedPagesChanged() : void
      {
         this._selectedPagesChanged.dispatch();
         this.getSelectedItemSets();
      }
      
      override protected function createChildren() : void
      {
         this._rendererFactory = new RendererFactory(ItemSetSelectPageRenderer,[this]);
         this._rendererFactory.getEntryConstructed().add(this.prepareRenderer);
         this._globalPagesList = new ListView(new ListX(new Vector.<ItemSet>()));
         this._globalPagesList.filter(this.filterGlobalPages);
         this._globalPagesList.sortWithCompare(this.sortGlobalPages);
         this._dividerGraphic = new SpriteProxy(this);
         this._dividerGraphic.setLinkage("ParchmentDivider");
         addChild(this._dividerGraphic);
         var _loc1_:VirtualizedVerticalLayout = new VirtualizedVerticalLayout();
         _loc1_.setGap(3);
         var _loc2_:Padding = new Padding(10,0,0,0);
         _loc1_.setPadding(_loc2_);
         this._pagesDataGroup = new DataGroup(this);
         this._pagesDataGroup.setRendererFactory(this._rendererFactory);
         this._pagesDataGroup.setDataProvider(this._globalPagesList);
         this._pagesDataGroup.getLayoutInvalidated().add(invalidateLayout);
         this._pagesDataGroup.setLayoutAlgorithm(_loc1_);
         addChild(this._pagesDataGroup);
         this._selectionBehavior = new SelectionBehavior(this._rendererFactory,this._globalPagesList);
         this._selectionBehavior.allowMultipleSelection = true;
         this._selectionBehavior.autoMultipleSelection = true;
         this._selectionBehavior.getSelectedItemsChanged().add(this.handleSelectedPagesChanged);
         super.createChildren();
      }
      
      private function sortGlobalPages(param1:ItemSet, param2:ItemSet) : Number
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
      
      private function prepareRenderer(param1:LayoutEntry, param2:ItemSet) : void
      {
         var _loc3_:ItemSetSelectPageRenderer = param1.element as ItemSetSelectPageRenderer;
         _loc3_.getMouseDown().add(this.handlePageMouseDown);
      }
      
      public function getSelectedItemSets() : Vector.<ItemSet>
      {
         var _loc2_:Object = null;
         var _loc1_:Vector.<ItemSet> = new Vector.<ItemSet>();
         for each(_loc2_ in this._selectionBehavior.getSelectedItems())
         {
            _loc1_.push(_loc2_ as ItemSet);
         }
         return _loc1_;
      }
      
      override public function destroy() : void
      {
         this._rendererFactory.destroy();
         super.destroy();
      }
   }
}

