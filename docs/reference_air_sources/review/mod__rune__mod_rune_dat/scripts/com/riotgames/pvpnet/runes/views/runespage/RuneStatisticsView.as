package com.riotgames.pvpnet.runes.views.runespage
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.list.DataScroller;
   import blix.components.list.RendererFactory;
   import blix.components.scroll.ScrollPolicy;
   import blix.context.IContext;
   import blix.ds.IListX;
   import blix.ds.ListView;
   import blix.ds.ListX;
   import blix.frame.getEnterFrame;
   import blix.layout.algorithms.VirtualizedVerticalLayout;
   import blix.layout.data.SizeLayoutData;
   import blix.layout.vo.HorizontalAlign;
   import com.riotgames.pvpnet.runes.viewcontroller.RunesTransportationController;
   import com.riotgames.pvpnet.runes.viewcontroller.RunesViewController;
   import com.riotgames.rust.data.ListAdapter;
   import flash.geom.Rectangle;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class RuneStatisticsView extends SpriteProxy
   {
      
      private var runesViewController:RunesViewController;
      
      private var runesTransportationController:RunesTransportationController;
      
      private var sizer:SpriteProxy;
      
      private var statisticsScroller:DataScroller;
      
      private var rendererFactory:RendererFactory;
      
      private var _isValidating:Boolean;
      
      public function RuneStatisticsView(param1:IContext)
      {
         super(param1);
         this.watchControllers();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.runesViewController = getDependency(RunesViewController);
         this.runesTransportationController = getDependency(RunesTransportationController);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         var _loc2_:TextFieldProxy = new TextFieldProxy(this);
         _loc2_.setText(_loc1_.getString("resources","runebook_book_statsHeaderLabel"));
         setTimelineChildByName("statisticsHeader.textField",_loc2_);
         this.statisticsScroller = new DataScroller(this);
         this.statisticsScroller.setKineticScrolling(true);
         this.statisticsScroller.setSelectionEnabled(false);
         this.statisticsScroller.setMouseWheelEnabled(true);
         this.statisticsScroller.setScrollPolicy(ScrollPolicy.AUTO);
         this.statisticsScroller.setExplicitSize(NaN,NaN);
         setTimelineChildByName("statisticsScroller",this.statisticsScroller);
         this.sizer = new SpriteProxy(this);
         this.sizer.getLayoutInvalidated().add(invalidateLayout);
         setTimelineChildByName("sizer",this.sizer);
         var _loc3_:VirtualizedVerticalLayout = new VirtualizedVerticalLayout();
         _loc3_.setHorizontalAlign(HorizontalAlign.LEFT);
         _loc3_.setGap(0);
         this.statisticsScroller.setLayoutAlgorithm(_loc3_);
         var _loc4_:SizeLayoutData = new SizeLayoutData();
         _loc4_.setWidthPercent(1);
         this.rendererFactory = new RendererFactory(RuneItemEffectRenderer,[this],_loc4_);
         this.statisticsScroller.setDataProvider(new ListView(new ListX()));
         this.statisticsScroller.setRendererFactory(this.rendererFactory);
         this.statisticsScroller.getLayoutInvalidated().add(invalidateLayout);
      }
      
      private function watchControllers() : void
      {
         this.runesTransportationController.getRuneAddedToPage().add(this.invalidateStatistics);
         this.runesTransportationController.getRuneRemovedFromPage().add(this.invalidateStatistics);
         this.invalidateStatistics();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.runesTransportationController.getRuneAddedToPage().remove(this.invalidateStatistics);
         this.runesTransportationController.getRuneRemovedFromPage().remove(this.invalidateStatistics);
      }
      
      private function invalidateStatistics() : void
      {
         if(!this._isValidating)
         {
            this._isValidating = true;
            getEnterFrame().addOnce(this.validateStatistics);
         }
      }
      
      private function validateStatistics() : void
      {
         if(this.runesViewController.getCurrentRuneBookPage())
         {
            this.setDataProvider(new ListAdapter(this.runesViewController.getCurrentRuneBookPage().getCombinedStats()));
            this._isValidating = false;
         }
      }
      
      public function setDataProvider(param1:IListX) : void
      {
         this.statisticsScroller.setDataProvider(param1);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this.statisticsScroller.setExplicitSize(this.sizer.getWidth(),this.sizer.getHeight());
         this.statisticsScroller.setExplicitPosition(this.sizer.getX(),this.sizer.getY());
         return super.updateLayout(param1,param2);
      }
   }
}

