package com.riotgames.pvpnet.itembrowser.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.CheckBoxX;
   import blix.components.scroll.ScrollArea;
   import blix.components.scroll.ScrollPolicy;
   import blix.context.IContext;
   import blix.layout.algorithms.VerticalLayout;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSet;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetsModel;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import mx.resources.ResourceManager;
   
   public class ItemSetSelectItemSetsView extends SpriteProxy
   {
      
      private var _selectChampionPagesView:ItemSetSelectChampionSetsView;
      
      private var _selectGlobalPagesView:ItemSetListSelectGlobalPagesView;
      
      private var _selectMultiPagesView:ItemSetListSelectMultiPagesView;
      
      private var _selectedItemSets:Vector.<ItemSet> = new Vector.<ItemSet>();
      
      private var _itemSets:Vector.<ItemSet>;
      
      private var _updatingCheckboxSelection:Boolean = false;
      
      private var _selectAllCheckbox:CheckBoxX;
      
      private var _model:ItemSetsModel;
      
      private var _selectedItemSetsChanged:Signal = new Signal();
      
      private var _itemSetMouseDown:Signal = new Signal();
      
      private var _scrollAreaSizer:SpriteProxy;
      
      private var _itemSetsScrollArea:ScrollArea;
      
      public function ItemSetSelectItemSetsView(param1:IContext, param2:Sprite = null)
      {
         super(param1,param2);
      }
      
      public function setItemSets(param1:Vector.<ItemSet>) : void
      {
         if(this._itemSets != param1)
         {
            this._itemSets = param1;
            this._selectGlobalPagesView.setItemSets(this._itemSets);
            this._selectMultiPagesView.setItemSets(this._itemSets);
            this._selectChampionPagesView.setItemSets(this._itemSets);
            this._updatingCheckboxSelection = true;
            this._selectAllCheckbox.setSelected(true);
            this._updatingCheckboxSelection = false;
            this._selectedItemSetsChanged.dispatch();
         }
      }
      
      public function getItemSetMouseDown() : ISignal
      {
         return this._itemSetMouseDown;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._itemSetsScrollArea.setExplicitSize(this._scrollAreaSizer.getWidth(),this._scrollAreaSizer.getHeight());
         this._itemSetsScrollArea.setExplicitPosition(this._scrollAreaSizer.getX(),this._scrollAreaSizer.getY());
         this._itemSetsScrollArea.setScrollRect(new Rectangle(0,0,this._scrollAreaSizer.getWidth(),this._scrollAreaSizer.getHeight()));
         return super.updateLayout(param1,param2);
      }
      
      private function handleSelectedPagesChanged() : void
      {
         this._updatingCheckboxSelection = true;
         this._selectAllCheckbox.setSelected(false);
         this._updatingCheckboxSelection = false;
         this._selectedItemSets = this.getSelectedItemSets();
         this._selectedItemSetsChanged.dispatch();
      }
      
      override protected function createChildren() : void
      {
         this._selectAllCheckbox = new CheckBoxX(this);
         setTimelineChildByName("selectAllCheckbox",this._selectAllCheckbox);
         this._selectAllCheckbox.setText(ResourceManager.getInstance().getString("itemBrowser","selectItemSets_selectAll"));
         this._selectAllCheckbox.setSelected(true);
         this._selectAllCheckbox.getSelectedChanged().add(this.handleSelectAllChanged);
         this._scrollAreaSizer = new SpriteProxy(this);
         setTimelineChildByName("listSizer",this._scrollAreaSizer);
         this._itemSetsScrollArea = new ScrollArea(this);
         this._itemSetsScrollArea.setLinkage("ScrollContainer");
         this._itemSetsScrollArea.setVScrollPolicy(ScrollPolicy.ON);
         this._itemSetsScrollArea.getLayoutInvalidated().add(invalidateLayout);
         this._itemSetsScrollArea.setKineticScrolling(true);
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.setGap(10);
         this._itemSetsScrollArea.getContents().setLayoutAlgorithm(_loc1_);
         addChild(this._itemSetsScrollArea);
         this._selectGlobalPagesView = new ItemSetListSelectGlobalPagesView(this);
         this._itemSetsScrollArea.getContents().addElement(this._selectGlobalPagesView);
         this._selectGlobalPagesView.getSelectedPagesChanged().add(this.handleSelectedPagesChanged);
         this._selectGlobalPagesView.getItemSetMouseDown().add(this.handleItemSetMouseDown);
         this._selectMultiPagesView = new ItemSetListSelectMultiPagesView(this);
         this._itemSetsScrollArea.getContents().addElement(this._selectMultiPagesView);
         this._selectMultiPagesView.getSelectedPagesChanged().add(this.handleSelectedPagesChanged);
         this._selectMultiPagesView.getItemSetMouseDown().add(this.handleItemSetMouseDown);
         this._selectChampionPagesView = new ItemSetSelectChampionSetsView(this);
         this._itemSetsScrollArea.getContents().addElement(this._selectChampionPagesView);
         this._selectChampionPagesView.getSelectedPagesChanged().add(this.handleSelectedPagesChanged);
         this._selectChampionPagesView.getItemSetMouseDown().add(this.handleItemSetMouseDown);
      }
      
      private function handleItemSetMouseDown(param1:ItemSet) : void
      {
         this._itemSetMouseDown.dispatch(param1);
      }
      
      public function setModel(param1:ItemSetsModel) : void
      {
         if(this._model != param1)
         {
            this._model = param1;
            this._selectChampionPagesView.setModel(this._model);
         }
      }
      
      public function getSelectedItemSets() : Vector.<ItemSet>
      {
         var _loc1_:Vector.<ItemSet> = null;
         if(this._selectAllCheckbox.getSelected())
         {
            return this._itemSets;
         }
         _loc1_ = this._selectGlobalPagesView.getSelectedItemSets();
         _loc1_ = _loc1_.concat(this._selectMultiPagesView.getSelectedItemSets());
         return _loc1_.concat(this._selectChampionPagesView.getSelectedItemSets());
      }
      
      private function handleSelectAllChanged() : void
      {
         if(this._selectAllCheckbox.getSelected())
         {
            this._itemSetsScrollArea.setAlpha(0.6);
         }
         else
         {
            this._itemSetsScrollArea.setAlpha(1);
         }
         if(this._updatingCheckboxSelection)
         {
            return;
         }
         this._selectedItemSetsChanged.dispatch();
      }
      
      public function getSelectedItemSetsChanged() : ISignal
      {
         return this._selectedItemSetsChanged;
      }
   }
}

