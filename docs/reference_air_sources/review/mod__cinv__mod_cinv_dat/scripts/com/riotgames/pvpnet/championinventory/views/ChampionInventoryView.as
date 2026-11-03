package com.riotgames.pvpnet.championinventory.views
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.IDisplayChild;
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import com.riotgames.pvpnet.championinventory.model.ChampionInventoryViewModel;
   import com.riotgames.rust.context.popup.IPopupContext;
   import com.riotgames.rust.context.popup.SimplePopupContextBehavior;
   
   public class ChampionInventoryView extends SpriteProxy implements IPopupContext
   {
      
      private var championSearchView:ChampionInventorySearchView;
      
      private var championListView:ChampionInventoryListView;
      
      private var _championViewModel:ChampionInventoryViewModel;
      
      private var championFilterView:ChampionInventoryFilterView;
      
      private var popupBehavior:SimplePopupContextBehavior;
      
      public function ChampionInventoryView(param1:IContext)
      {
         super(param1);
         setLinkage("ChampionInventory");
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this._championViewModel = getDependency(ChampionInventoryViewModel);
         this.popupBehavior = new SimplePopupContextBehavior(this);
      }
      
      override protected function createChildren() : void
      {
         this.championSearchView = new ChampionInventorySearchView(this);
         setTimelineChildByName("searchView",this.championSearchView);
         this.championListView = new ChampionInventoryListView(this);
         setTimelineChildByName("championList",this.championListView);
         this.championFilterView = new ChampionInventoryFilterView(this);
         setTimelineChildByName("filterView",this.championFilterView);
         this.initializeListView();
      }
      
      private function initializeListView() : void
      {
         this.championListView.setChampions(this._championViewModel.getChampionList());
      }
      
      public function addPopup(param1:IDisplayChild) : void
      {
         this.popupBehavior.addPopup(param1);
      }
      
      public function removePopup(param1:IDisplayChild) : void
      {
         this.popupBehavior.removePopup(param1);
      }
      
      public function setPosition(param1:DisplayObjectProxy, param2:DisplayObjectProxy, param3:int, param4:int) : void
      {
         this.popupBehavior.setPosition(param1,param2,param3,param4);
      }
   }
}

