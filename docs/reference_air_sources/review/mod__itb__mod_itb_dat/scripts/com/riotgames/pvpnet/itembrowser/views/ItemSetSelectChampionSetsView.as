package com.riotgames.pvpnet.itembrowser.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.list.DataGroup;
   import blix.components.list.RendererFactory;
   import blix.context.IContext;
   import blix.ds.ListView;
   import blix.ds.ListX;
   import blix.layout.LayoutEntry;
   import blix.layout.algorithms.VirtualizedVerticalLayout;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSet;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetChampion;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetsModel;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class ItemSetSelectChampionSetsView extends SpriteProxy
   {
      
      private var _rendererFactory:RendererFactory;
      
      private var _championsDataGroup:DataGroup;
      
      private var _championPagesDictionary:Dictionary = new Dictionary();
      
      private var _itemSets:Vector.<ItemSet> = new Vector.<ItemSet>();
      
      private var _championsList:ListView;
      
      private var _model:ItemSetsModel;
      
      private var _selectedPagesChanged:Signal = new Signal();
      
      private var _dividerGraphic:SpriteProxy;
      
      private var _itemSetMouseDown:Signal = new Signal();
      
      private var _itemSetChampions:Vector.<ItemSetChampion> = new Vector.<ItemSetChampion>();
      
      public function ItemSetSelectChampionSetsView(param1:IContext)
      {
         super(param1,new Sprite());
      }
      
      override public function destroy() : void
      {
         this._rendererFactory.destroy();
         super.destroy();
      }
      
      public function getSelectedPagesChanged() : ISignal
      {
         return this._selectedPagesChanged;
      }
      
      public function setItemSets(param1:Vector.<ItemSet>) : void
      {
         this._itemSets = param1;
         this._championPagesDictionary = new Dictionary();
         this.setItemSetChampions();
      }
      
      public function getItemSetMouseDown() : ISignal
      {
         return this._itemSetMouseDown;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = this._championsDataGroup.setExplicitSize(NaN,NaN);
         this._championsDataGroup.setExplicitPosition(0,15);
         return new Rectangle(0,0,_loc3_.x,_loc3_.y + 15);
      }
      
      private function handlePageMouseDown(param1:ItemSet) : void
      {
         this._itemSetMouseDown.dispatch(param1);
      }
      
      override protected function createChildren() : void
      {
         this._rendererFactory = new RendererFactory(ItemSetSelectChampionPagesRenderer,[this]);
         this._rendererFactory.getEntryConstructed().add(this.prepareRenderer);
         this._dividerGraphic = new SpriteProxy(this);
         this._dividerGraphic.setLinkage("ParchmentDivider");
         addChild(this._dividerGraphic);
         var _loc1_:VirtualizedVerticalLayout = new VirtualizedVerticalLayout();
         _loc1_.setGap(5);
         this._championsList = new ListView(new ListX(new Vector.<ItemSetChampion>()));
         this._championsList.filter(this.filterChampions);
         this._championsList.sortWithCompare(this.sortChampions);
         this._championsDataGroup = new DataGroup(this);
         this._championsDataGroup.setRendererFactory(this._rendererFactory);
         this._championsDataGroup.setDataProvider(this._championsList);
         this._championsDataGroup.getLayoutInvalidated().add(invalidateLayout);
         this._championsDataGroup.setLayoutAlgorithm(_loc1_);
         addChild(this._championsDataGroup);
         super.createChildren();
      }
      
      private function handleSelectedChampionPagesChanged(param1:ItemSetChampion, param2:Vector.<ItemSet>) : void
      {
         this._championPagesDictionary[param1] = param2;
         this._selectedPagesChanged.dispatch();
      }
      
      private function setItemSetChampions() : void
      {
         var _loc2_:ItemSet = null;
         var _loc3_:int = 0;
         var _loc4_:ItemSetChampion = null;
         var _loc5_:Champion = null;
         if(!this._model)
         {
            return;
         }
         var _loc1_:Dictionary = new Dictionary(true);
         this._itemSetChampions = new Vector.<ItemSetChampion>();
         for each(_loc2_ in this._itemSets)
         {
            for each(_loc3_ in _loc2_.getAssignedChampions())
            {
               _loc4_ = _loc1_[_loc3_];
               if(_loc4_ == null)
               {
                  _loc5_ = ItemSetChampion(this._model.championIdToChampionDictionary[_loc3_]).getChampion();
                  if(_loc5_)
                  {
                     _loc4_ = new ItemSetChampion(_loc5_);
                  }
                  this._itemSetChampions.push(_loc4_);
               }
               _loc4_.addAssignedItemSet(_loc2_);
               _loc1_[_loc3_] = _loc4_;
            }
         }
         this._championsList.setSource(this._itemSetChampions);
      }
      
      private function filterChampions(param1:ItemSetChampion, param2:int, param3:Array) : Boolean
      {
         var _loc5_:ItemSet = null;
         if(param1.getChampionID() == -1)
         {
            return false;
         }
         var _loc4_:Boolean = false;
         for each(_loc5_ in param1.getAssignedItemSets())
         {
            if(!_loc5_.getIsGlobalForChampions() && _loc5_.getAssignedChampions().length == 1)
            {
               _loc4_ = true;
               break;
            }
         }
         return _loc4_;
      }
      
      public function setModel(param1:ItemSetsModel) : void
      {
         if(param1 != this._model)
         {
            this._model = param1;
         }
      }
      
      private function prepareRenderer(param1:LayoutEntry, param2:ItemSetChampion) : void
      {
         var _loc3_:ItemSetSelectChampionPagesRenderer = param1.element as ItemSetSelectChampionPagesRenderer;
         _loc3_.getItemSetMouseDown().add(this.handlePageMouseDown);
         _loc3_.getSelectedPagesChanged().add(this.handleSelectedChampionPagesChanged);
      }
      
      private function sortChampions(param1:ItemSetChampion, param2:ItemSetChampion) : Number
      {
         return this._model.getChampionFilter().sortByDisplayName(param1.getChampion(),param2.getChampion());
      }
      
      public function getSelectedItemSets() : Vector.<ItemSet>
      {
         var _loc2_:Vector.<ItemSet> = null;
         var _loc1_:Vector.<ItemSet> = new Vector.<ItemSet>();
         for each(_loc2_ in this._championPagesDictionary)
         {
            if(_loc2_)
            {
               _loc1_ = _loc1_.concat(_loc2_);
            }
         }
         return _loc1_;
      }
   }
}

