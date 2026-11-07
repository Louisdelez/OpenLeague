package com.riotgames.pvpnet.itembrowser.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.scroll.ScrollArea;
   import blix.components.scroll.ScrollPolicy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.layout.algorithms.VerticalLayout;
   import blix.layout.vo.HorizontalAlign;
   import blix.layout.vo.Padding;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSet;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetsModel;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import mx.resources.ResourceManager;
   
   public class ItemSetAssociationManagementView extends StatefulView
   {
      
      private var _scrollSizer:SpriteProxy;
      
      private var _itemSetPropertiesLabel:TextFieldProxy;
      
      private var _championSelectionView:ItemSetChampionAssociationSelectionView;
      
      private var _model:ItemSetsModel;
      
      private var _mapSelectionView:ItemSetMapAssociationSelectionView;
      
      private var _scrollContainer:ScrollArea;
      
      private var _activeItemSet:ItemSet;
      
      public function ItemSetAssociationManagementView(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         setCurrentState("gotData");
      }
      
      private function removeActiveItemSetListeners() : void
      {
         if(this._activeItemSet)
         {
            this._activeItemSet.getTitleChanged().remove(this.handleItemSetTitleChanged);
         }
      }
      
      private function removeModelListeners() : void
      {
         if(this._model)
         {
            this._model.getActiveItemSetChanged().remove(this.handleActiveItemSetChanged);
         }
      }
      
      private function handleActiveItemSetChanged() : void
      {
         if(this._activeItemSet)
         {
            this.removeActiveItemSetListeners();
         }
         if(Boolean(this._model) && Boolean(this._model.getActiveItemSet()))
         {
            this._itemSetPropertiesLabel.setVisible(true);
            this.handleItemSetTitleChanged();
            this._activeItemSet = this._model.getActiveItemSet();
            this.addActiveItemSetListeners();
         }
      }
      
      private function addActiveItemSetListeners() : void
      {
         if(this._activeItemSet)
         {
            this._activeItemSet.getTitleChanged().add(this.handleItemSetTitleChanged);
         }
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._scrollContainer.setExplicitSize(this._scrollSizer.getWidth(),this._scrollSizer.getHeight());
         this._scrollContainer.setExplicitPosition(this._scrollSizer.getX(),this._scrollSizer.getY());
         return super.updateLayout(param1,param2);
      }
      
      override public function destroy() : void
      {
         this.removeModelListeners();
         super.destroy();
      }
      
      private function addModelListeners() : void
      {
         if(this._model)
         {
            this._model.getActiveItemSetChanged().add(this.handleActiveItemSetChanged);
         }
      }
      
      private function handleItemSetTitleChanged() : void
      {
         this._itemSetPropertiesLabel.setText(ResourceManager.getInstance().getString("itemBrowser","itemSets_pagePropertiesHeader",[this._model.getActiveItemSet().title]));
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
            this._championSelectionView.setModel(this._model);
            this._mapSelectionView.setModel(this._model);
            this.handleActiveItemSetChanged();
            if(this._model)
            {
               this.addModelListeners();
            }
         }
      }
      
      override protected function createChildren() : void
      {
         this._scrollSizer = new SpriteProxy(this);
         setTimelineChildByName("scrollSizer",this._scrollSizer);
         this._scrollContainer = new ScrollArea(this);
         this._scrollContainer.setLinkage("ScrollContainer");
         this._scrollContainer.setVScrollPolicy(ScrollPolicy.ON);
         this._scrollContainer.getLayoutInvalidated().add(invalidateLayout);
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.setGap(0);
         _loc1_.setHorizontalAlign(HorizontalAlign.CENTER);
         var _loc2_:Padding = new Padding(15,0,0,0);
         _loc1_.setPadding(_loc2_);
         this._scrollContainer.getContents().setLayoutAlgorithm(_loc1_);
         addChild(this._scrollContainer);
         this._mapSelectionView = new ItemSetMapAssociationSelectionView(this);
         this._scrollContainer.getContents().addElement(this._mapSelectionView);
         this._championSelectionView = new ItemSetChampionAssociationSelectionView(this);
         this._scrollContainer.getContents().addElement(this._championSelectionView);
         this._itemSetPropertiesLabel = new TextFieldProxy(this);
         setTimelineChildByName("itemSetPropertiesLabel",this._itemSetPropertiesLabel);
         this._itemSetPropertiesLabel.setText(ResourceManager.getInstance().getString("itemBrowser","itemSets_pagePropertiesHeader"));
         this._itemSetPropertiesLabel.setVisible(false);
      }
   }
}

