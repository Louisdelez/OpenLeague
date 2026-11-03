package com.riotgames.pvpnet.cap.views.components
{
   import blix.assets.proxy.MovieClipProxy;
   import blix.components.list.DataGroup;
   import blix.components.list.RendererFactory;
   import blix.context.IContext;
   import blix.ds.IListX;
   import com.riotgames.pvpnet.cap.controllers.CapMapController;
   import com.riotgames.pvpnet.cap.model.CapPositionTargets;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.renderers.CapMapRenderer;
   import com.riotgames.rust.data.ListAdapter;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.collections.ArrayCollection;
   
   public class CapMapPanel extends DataGroup
   {
      
      public static const STARTING_POINT:Point = new Point(0,0);
      
      private var rendererFactory:RendererFactory;
      
      private var playerSelections:ArrayCollection;
      
      private var model:CapModel;
      
      private var tweenTargets:MovieClipProxy;
      
      private var mapController:CapMapController;
      
      private var positionTargets:CapPositionTargets;
      
      public function CapMapPanel(param1:IContext)
      {
         this.model = param1.getDependency(CapModel);
         this.playerSelections = this.model.playerSelections;
         var _loc2_:IListX = new ListAdapter(this.playerSelections);
         this.rendererFactory = new RendererFactory(CapMapRenderer,[param1]);
         super(param1,_loc2_,this.rendererFactory);
      }
      
      protected function rebuildTweenTargetData(param1:MovieClip) : void
      {
         if(this.mapController)
         {
            this.mapController.destroy();
            this.mapController = null;
         }
         this.positionTargets = new CapPositionTargets(param1,this.model.positions);
         this.mapController = new CapMapController(this.model.playerSelections,this.positionTargets,this.model.positions);
         this.mapController.updateAllPositions();
         invalidateLayout();
      }
      
      protected function handleTweenAsset() : void
      {
         var _loc1_:MovieClip = null;
         if(this.tweenTargets.getAsset())
         {
            _loc1_ = this.tweenTargets.getAsset() as MovieClip;
         }
         if(_loc1_)
         {
            this.rebuildTweenTargetData(_loc1_);
         }
      }
      
      override public function setScrollRect(param1:Rectangle) : void
      {
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.tweenTargets = new MovieClipProxy(this);
         this.tweenTargets.setVisible(false);
         setTimelineChildByName("tweenTargets",this.tweenTargets);
         this.tweenTargets.getAssetChanged().add(this.handleTweenAsset);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this.rendererFactory)
         {
            this.rendererFactory.destroy();
            this.rendererFactory = null;
         }
         if(this.mapController)
         {
            this.mapController.destroy();
            this.mapController = null;
         }
      }
   }
}

