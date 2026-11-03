package com.riotgames.pvpnet.runes.views.common
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.list.DataScroller;
   import blix.components.list.RendererFactory;
   import blix.components.scroll.ScrollPolicy;
   import blix.context.IContext;
   import com.riotgames.platform.common.provider.IRuneBookController;
   import com.riotgames.platform.gameclient.domain.SpellBookPageDTO;
   import com.riotgames.pvpnet.runes.viewcontroller.RunesViewController;
   import com.riotgames.rust.data.ListAdapter;
   import flash.geom.Rectangle;
   
   public class RunePageList extends SpriteProxy
   {
      
      private var _sizer:SpriteProxy;
      
      private var _runePageScroller:DataScroller;
      
      private var rendererFactory:RendererFactory;
      
      private var runesViewController:RunesViewController;
      
      private var _selectedItemsChanging:Boolean;
      
      private var runeBookController:IRuneBookController;
      
      public function RunePageList(param1:IContext)
      {
         super(param1);
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.runesViewController = getDependency(RunesViewController);
         this.runeBookController = getDependency(IRuneBookController);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._sizer = new SpriteProxy(this);
         setTimelineChildByName("sizer",this._sizer);
         this._runePageScroller = new DataScroller(this);
         setTimelineChildByName("runePageScroller",this._runePageScroller);
         this._runePageScroller.setScrollPolicy(ScrollPolicy.AUTO);
         this._runePageScroller.setMouseWheelEnabled(true);
         this.rendererFactory = new RendererFactory(RunePageListRenderer,[this]);
         this._runePageScroller.getSelectionBehavior().getSelectedItemsChanged().add(this.onSelectedItemsChanged);
         this._runePageScroller.getSelectionBehavior().allowMultipleSelection = false;
         this._runePageScroller.setRendererFactory(this.rendererFactory);
         this.runesViewController.getRuneBookRetrieved().add(this.onRuneBookRetrieved);
         this.runesViewController.getCurrentRuneBookPageChanged().add(this.currentRuneBookPageChanged);
         this.currentRuneBookPageChanged();
         this.onRuneBookRetrieved();
      }
      
      private function onRuneBookRetrieved() : void
      {
         if(this.runeBookController.runeBook != null)
         {
            this._runePageScroller.setDataProvider(new ListAdapter(this.runeBookController.runeBook.bookPages));
         }
      }
      
      private function currentRuneBookPageChanged() : void
      {
         if(this._selectedItemsChanging)
         {
            return;
         }
      }
      
      private function onSelectedItemsChanged() : void
      {
         this._selectedItemsChanging = true;
         this.setNewRuneBookPage();
      }
      
      private function setNewRuneBookPage() : void
      {
         var _loc1_:SpellBookPageDTO = this._runePageScroller.getSelectionBehavior().getSelectedItem() as SpellBookPageDTO;
         if(_loc1_)
         {
            this.runesViewController.setCurrentRuneBookPage(_loc1_);
         }
         this._selectedItemsChanging = false;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.rendererFactory.destroy();
         this.runesViewController.getRuneBookRetrieved().remove(this.currentRuneBookPageChanged);
         this.runesViewController.getCurrentRuneBookPageChanged().remove(this.currentRuneBookPageChanged);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._runePageScroller.setExplicitSize(this._sizer.getWidth(),this._sizer.getHeight());
         this._runePageScroller.setExplicitPosition(this._sizer.getX(),this._sizer.getY());
         return super.updateLayout(param1,param2);
      }
   }
}

