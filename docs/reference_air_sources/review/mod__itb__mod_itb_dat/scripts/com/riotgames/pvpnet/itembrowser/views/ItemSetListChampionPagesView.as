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
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSet;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetChampion;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetsModel;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ItemSetListChampionPagesView extends SpriteProxy
   {
      
      private var _rendererFactory:RendererFactory;
      
      private var _championsDataGroup:DataGroup;
      
      private var _championsList:ListView;
      
      private var _model:ItemSetsModel;
      
      private var _dividerGraphic:SpriteProxy;
      
      private var _activeItemSet:ItemSet;
      
      public function ItemSetListChampionPagesView(param1:IContext, param2:Sprite = null)
      {
         if(!param2)
         {
            param2 = new Sprite();
         }
         super(param1,param2);
      }
      
      private function removeActiveItemSetListeners() : void
      {
         if(this._activeItemSet)
         {
            this._activeItemSet.getIsGlobalForChampionsChanged().remove(this.refreshChampionList);
            this._activeItemSet.getAssignedChampionsChanged().remove(this.refreshChampionList);
         }
      }
      
      override public function destroy() : void
      {
         this._rendererFactory.destroy();
         this.removeModelListeners();
         this.removeActiveItemSetListeners();
         super.destroy();
      }
      
      private function removeModelListeners() : void
      {
         if(this._model)
         {
            this._model.getItemSetChampionsChanged().remove(this.handleItemSetChampionsChanged);
            this._model.getActiveItemSetChanged().remove(this.handleActiveItemSetChanged);
            this._model.getItemSetsChanged().remove(this.refreshChampionList);
         }
      }
      
      private function handleItemSetChampionsChanged() : void
      {
         if(!this._model)
         {
            this._championsList.setSource(new Vector.<ItemSetChampion>());
         }
         else
         {
            this._championsList.setSource(this._model.getItemSetChampions());
         }
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
      
      private function handleActiveItemSetChanged() : void
      {
         if(this._activeItemSet)
         {
            this.removeActiveItemSetListeners();
         }
         if(Boolean(this._model) && Boolean(this._model.getActiveItemSet()))
         {
            this._activeItemSet = this._model.getActiveItemSet();
            this.addActiveItemSetListeners();
         }
         else
         {
            this._activeItemSet = null;
         }
      }
      
      private function activateChampionSetsRenderer(param1:LayoutEntry, param2:ItemSetChampion) : void
      {
         var _loc3_:ItemSetListChampionPagesRenderer = param1.element as ItemSetListChampionPagesRenderer;
         _loc3_.setItemSetsModel(this._model);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = this._championsDataGroup.setExplicitSize(NaN,NaN);
         this._championsDataGroup.setExplicitPosition(0,15);
         return new Rectangle(0,0,_loc3_.x,_loc3_.y + 15);
      }
      
      override protected function createChildren() : void
      {
         this._rendererFactory = new RendererFactory(ItemSetListChampionPagesRenderer,[this]);
         this._rendererFactory.getEntryConstructed().add(this.activateChampionSetsRenderer);
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
      
      private function addModelListeners() : void
      {
         if(this._model)
         {
            this._model.getItemSetChampionsChanged().add(this.handleItemSetChampionsChanged);
            this._model.getActiveItemSetChanged().add(this.handleActiveItemSetChanged);
            this._model.getItemSetsChanged().add(this.refreshChampionList);
         }
      }
      
      private function refreshChampionList() : void
      {
         this._championsList.reset();
      }
      
      private function addActiveItemSetListeners() : void
      {
         if(this._activeItemSet)
         {
            this._activeItemSet.getIsGlobalForChampionsChanged().add(this.refreshChampionList);
            this._activeItemSet.getAssignedChampionsChanged().add(this.refreshChampionList);
         }
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
            this.handleItemSetChampionsChanged();
            this.handleActiveItemSetChanged();
            this.addModelListeners();
         }
      }
      
      private function sortChampions(param1:ItemSetChampion, param2:ItemSetChampion) : Number
      {
         return this._model.getChampionFilter().sortByDisplayName(param1.getChampion(),param2.getChampion());
      }
   }
}

