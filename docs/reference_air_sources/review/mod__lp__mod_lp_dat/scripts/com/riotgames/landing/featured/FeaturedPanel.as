package com.riotgames.landing.featured
{
   import blix.assets.proxy.FeaturedPanel.FeaturedPanelAsset;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.ButtonX;
   import blix.components.loader.LoaderX;
   import blix.components.text.Text;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.util.callback.preventRepeatedCalls;
   import com.riotgames.landing.navigate;
   import flash.events.MouseEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class FeaturedPanel extends SpriteProxy
   {
      
      protected var _visibleChanged:Signal = new Signal();
      
      protected var _model:FeaturedPanelModel;
      
      protected var title:Text;
      
      protected var featurePanelContentLoader:LoaderX;
      
      protected var button:ButtonX;
      
      public function FeaturedPanel(param1:IContext)
      {
         super(param1);
         this.setVisible(false);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         var _loc2_:FeaturedPanelAsset = new FeaturedPanelAsset();
         this.title = new Text(this);
         this.title.setText(_loc1_.getString("LandingPage","featuredPanel.title"));
         setTimelineChild(_loc2_.titleTextFieldAsset,this.title);
         this.featurePanelContentLoader = new LoaderX(this);
         setTimelineChild(_loc2_.featuredPanelContentAsset.loaderContainerAsset,this.featurePanelContentLoader);
         this.button = new ButtonX(this);
         this.button.addEventListener(MouseEvent.CLICK,this.clickHandler);
         setTimelineChild(_loc2_.featuredPanelContentAsset,this.button);
      }
      
      public function getVisibleChanged() : ISignal
      {
         return this._visibleChanged;
      }
      
      public function getModel() : FeaturedPanelModel
      {
         return this._model;
      }
      
      public function setModel(param1:FeaturedPanelModel) : void
      {
         if(this._model != null)
         {
            this.featurePanelContentLoader.unload();
         }
         this._model = param1;
         if(this._model != null)
         {
            this.featurePanelContentLoader.load(this._model.imageUrlRequest);
         }
      }
      
      override public function setVisible(param1:Boolean) : void
      {
         super.setVisible(param1);
         this._visibleChanged.dispatch();
      }
      
      protected function clickHandler(param1:MouseEvent) : void
      {
         if(preventRepeatedCalls(this.clickHandler,[param1],2000))
         {
            return;
         }
         if(this._model == null)
         {
            return;
         }
         navigate(this,this._model.clickUrlRequest);
      }
   }
}

