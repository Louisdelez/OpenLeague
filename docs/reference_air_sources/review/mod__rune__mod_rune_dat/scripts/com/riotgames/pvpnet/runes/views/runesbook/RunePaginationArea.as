package com.riotgames.pvpnet.runes.views.runesbook
{
   import blix.components.list.DataGroup;
   import blix.components.list.RendererFactory;
   import blix.components.list.SelectionBehavior;
   import blix.context.IContext;
   import blix.ds.IListX;
   import blix.layout.algorithms.VirtualizedHorizontalLayout;
   import com.riotgames.platform.gameclient.domain.SpellBookPageDTO;
   import com.riotgames.pvpnet.runes.viewcontroller.RunesViewController;
   
   public class RunePaginationArea extends DataGroup
   {
      
      private var runesViewController:RunesViewController;
      
      private var rendererFactory:RendererFactory;
      
      private var selectionBehavior:SelectionBehavior;
      
      private var _selectedItemsChanging:Boolean;
      
      public function RunePaginationArea(param1:IContext)
      {
         super(param1);
         var _loc2_:VirtualizedHorizontalLayout = new VirtualizedHorizontalLayout();
         _loc2_.setGap(0);
         setLayoutAlgorithm(_loc2_);
         setExplicitSize(NaN,NaN);
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.runesViewController = getDependency(RunesViewController);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.rendererFactory = new RendererFactory(RunePageButtonRenderer,[this]);
         setRendererFactory(this.rendererFactory);
         this.selectionBehavior = new SelectionBehavior(this.rendererFactory);
         this.selectionBehavior.getSelectedItemsChanged().add(this.selectedItemsChangedHandler);
         this.runesViewController.getRuneBookRetrieved().add(this.currentRuneBookPageChanged);
         this.runesViewController.getCurrentRuneBookPageChanged().add(this.currentRuneBookPageChanged);
         this.currentRuneBookPageChanged();
      }
      
      private function currentRuneBookPageChanged() : void
      {
         if(this._selectedItemsChanging)
         {
            return;
         }
         this.selectionBehavior.setSelectedItem(this.runesViewController.getCurrentRuneBookPage());
      }
      
      private function selectedItemsChangedHandler() : void
      {
         this._selectedItemsChanging = true;
         this.setNewRuneBookPage();
      }
      
      private function setNewRuneBookPage() : void
      {
         var _loc1_:SpellBookPageDTO = this.selectionBehavior.getSelectedItem() as SpellBookPageDTO;
         if(_loc1_)
         {
            this.runesViewController.setCurrentRuneBookPage(_loc1_);
         }
         this._selectedItemsChanging = false;
      }
      
      override public function setDataProvider(param1:IListX) : void
      {
         super.setDataProvider(param1);
         this.selectionBehavior.setDataProvider(param1);
      }
      
      override public function destroy() : void
      {
         this.rendererFactory.destroy();
         this.selectionBehavior.destroy();
         this.runesViewController.getCurrentRuneBookPageChanged().remove(this.currentRuneBookPageChanged);
         this.runesViewController.getRuneBookRetrieved().remove(this.currentRuneBookPageChanged);
         super.destroy();
      }
   }
}

