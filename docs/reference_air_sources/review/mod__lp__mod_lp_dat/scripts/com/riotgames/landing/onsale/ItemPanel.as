package com.riotgames.landing.onsale
{
   import blix.assets.proxy.OnSalePanel.OnSalePanelAsset;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.LabelButtonX;
   import blix.components.loader.ImageX;
   import blix.components.text.Text;
   import blix.context.IContext;
   import blix.layout.LayoutContainer;
   import blix.layout.algorithms.HorizontalLayout;
   import blix.layout.data.SizeLayoutData;
   import blix.layout.vo.VerticalAlign;
   import blix.model.TextModel;
   import blix.util.callback.preventRepeatedCalls;
   import com.riotgames.landing.ILandingPageContext;
   import com.riotgames.landing.LandingPageConfig;
   import com.riotgames.landing.analytics.trackEvent;
   import com.riotgames.landing.navigate;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class ItemPanel extends SpriteProxy
   {
      
      protected var _model:ItemPanelModel;
      
      protected var _visible:Boolean = true;
      
      private var saleTimeRemainingInterval:uint;
      
      public var panelTitle:Text;
      
      public var title:Text;
      
      public var subTitle:Text;
      
      public var rpCost:Text;
      
      public var ipCost:Text;
      
      public var rpIcon:SpriteProxy;
      
      public var ipIcon:SpriteProxy;
      
      public var loader:ImageX;
      
      public var infoButton:LabelButtonX;
      
      public var buyButton:LabelButtonX;
      
      public var sunburst:SpriteProxy;
      
      public var onSalePercent:Text;
      
      private var costsPosition:SpriteProxy;
      
      private var costsLayout:LayoutContainer;
      
      private var buttonsPosition:SpriteProxy;
      
      private var buttonsLayout:LayoutContainer;
      
      public var imageSizer:SpriteProxy;
      
      private var config:LandingPageConfig;
      
      public function ItemPanel(param1:IContext)
      {
         super(param1);
         this.refreshVisible();
         var _loc2_:ILandingPageContext = getFirstContext(ILandingPageContext);
         this.config = _loc2_.getConfig();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         var _loc2_:OnSalePanelAsset = new OnSalePanelAsset();
         this.panelTitle = new Text(this);
         setTimelineChild(_loc2_.panelTitleTextFieldAsset,this.panelTitle);
         this.title = new Text(this);
         setTimelineChild(_loc2_.titleAsset,this.title);
         this.subTitle = new Text(this);
         setTimelineChild(_loc2_.subTitleAsset,this.subTitle);
         this.rpCost = new Text(this);
         setTimelineChild(_loc2_.rpCostAsset,this.rpCost);
         this.rpIcon = _loc2_.rpCostIconAsset.create(this);
         this.ipCost = new Text(this);
         setTimelineChild(_loc2_.ipCostAsset,this.ipCost);
         this.ipIcon = _loc2_.ipCostIconAsset.create(this);
         this.loader = new ImageX(this);
         setTimelineChild(_loc2_.loaderContainerAsset,this.loader);
         this.infoButton = new LabelButtonX(this);
         this.infoButton.addEventListener(MouseEvent.CLICK,this.infoClickHandler);
         this.infoButton.setText(_loc1_.getString("LandingPage","common.info"));
         setTimelineChild(_loc2_.infoButtonAsset,this.infoButton);
         this.buyButton = new LabelButtonX(this);
         this.buyButton.addEventListener(MouseEvent.CLICK,this.buyClickHandler);
         this.buyButton.setText(_loc1_.getString("LandingPage","common.buy"));
         setTimelineChild(_loc2_.buyButtonAsset,this.buyButton);
         this.sunburst = _loc2_.sunburst.create(this);
         this.onSalePercent = new Text(this);
         setTimelineChild(_loc2_.salePercent,this.onSalePercent);
         this.imageSizer = _loc2_.imageSizer.create(this);
         this.imageSizer.getLayoutInvalidated().add(invalidateLayout);
         this.costsPosition = _loc2_.costsPosition.create(this);
         this.costsLayout = new LayoutContainer(this);
         var _loc3_:HorizontalLayout = new HorizontalLayout();
         _loc3_.setVerticalAlign(VerticalAlign.MIDDLE);
         this.costsLayout.setLayoutAlgorithm(_loc3_);
         this.costsLayout.addElement(this.rpIcon);
         this.costsLayout.addElement(this.rpCost);
         this.costsLayout.addElement(this.ipIcon);
         var _loc4_:SizeLayoutData = new SizeLayoutData();
         _loc4_.setWidthMin(60);
         this.costsLayout.addElement(this.ipCost,_loc4_);
         this.buttonsPosition = _loc2_.buttonsPosition.create(this);
         this.buttonsLayout = new LayoutContainer(this);
         this.buttonsLayout.setLayoutAlgorithm(new HorizontalLayout());
         this.buttonsLayout.addElement(this.infoButton);
         this.buttonsLayout.addElement(this.buyButton);
      }
      
      override public function getVisible() : Boolean
      {
         return this._visible;
      }
      
      override public function setVisible(param1:Boolean) : void
      {
         this._visible = param1;
         this.refreshVisible();
      }
      
      private function refreshVisible() : void
      {
         super.setVisible(this._model != null && this._visible);
      }
      
      private function infoClickHandler(param1:MouseEvent) : void
      {
         if(this._model == null)
         {
            return;
         }
         if(preventRepeatedCalls(this.infoClickHandler,[],2000))
         {
            return;
         }
         trackEvent(this,"Featured Item Info Click",this._model.title);
         navigate(this,this._model.infoUrlRequest);
      }
      
      private function buyClickHandler(param1:MouseEvent) : void
      {
         if(this._model == null)
         {
            return;
         }
         if(preventRepeatedCalls(this.buyClickHandler,[],2000))
         {
            return;
         }
         trackEvent(this,"Featured Item Buy Click",this._model.title);
         navigate(this,this._model.buyUrlRequest);
      }
      
      public function setModel(param1:ItemPanelModel) : void
      {
         var _loc2_:LoaderContext = null;
         if(this._model != null)
         {
            this.loader.unload();
            this.title.setText(null);
            this.subTitle.setText(null);
            this.rpCost.setText(null);
            this.ipCost.setText(null);
         }
         this._model = param1;
         this.refreshVisible();
         if(this._model != null)
         {
            _loc2_ = new LoaderContext();
            _loc2_.checkPolicyFile = true;
            if(this._model.imageUrl.toLowerCase().indexOf("http") == 0)
            {
               this.loader.load(new URLRequest(this._model.imageUrl),_loc2_);
            }
            else
            {
               this.loader.load(new URLRequest(this.config.imageRoot + this._model.imageUrl),_loc2_);
            }
            this.title.setText(this._model.title);
            this.subTitle.setText(this._model.subTitle);
            this.rpIcon.setVisible(!!this._model.rpCost);
            this.rpCost.setVisible(!!this._model.rpCost);
            this.ipIcon.setVisible(!!this._model.ipCost);
            this.ipCost.setVisible(!!this._model.ipCost);
            this.infoButton.setVisible(!!this._model.infoUrlRequest);
            this.buyButton.setVisible(!!this._model.buyUrlRequest);
            this.rpCost.setText(this._model.rpCost.toString());
            this.ipCost.setText(this._model.ipCost.toString());
         }
         this.refreshOnSaleTimer();
      }
      
      private function refreshOnSaleTimer() : void
      {
         var _loc1_:IResourceManager = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         clearTimeout(this.saleTimeRemainingInterval);
         if(this._model == null)
         {
            return;
         }
         if(this._model.saleDiscount)
         {
            _loc1_ = ResourceManager.getInstance();
            this.panelTitle.setText(_loc1_.getString("LandingPage","onSalePanel.title"));
            _loc2_ = new Date().getTime();
            _loc3_ = this._model.saleEndDate.getTime() - _loc2_;
            if(_loc3_ < 0)
            {
               this.switchToFeatured();
            }
            else
            {
               this.sunburst.setVisible(true);
               this.onSalePercent.setVisible(true);
               this.onSalePercent.setText("-" + this._model.saleDiscount + "%");
               if(_loc3_ < 48 * 3600 * 1000)
               {
                  this.saleTimeRemainingInterval = setTimeout(this.switchToFeatured,_loc3_);
               }
            }
         }
         else
         {
            this.switchToFeatured();
         }
      }
      
      private function switchToFeatured() : void
      {
         if(this._model == null)
         {
            return;
         }
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         this.panelTitle.setText(_loc1_.getString("LandingPage","featuredPanel.title"));
         this.rpCost.setTextModel(new TextModel(this._model.rpOriginalCost.toString()));
         this.ipCost.setTextModel(new TextModel(this._model.ipOriginalCost.toString()));
         this.sunburst.setVisible(false);
         this.onSalePercent.setVisible(false);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this.loader.setExplicitSize(this.imageSizer.getWidth(),this.imageSizer.getHeight());
         this.costsLayout.setExplicitSize(NaN,NaN);
         this.costsLayout.setExplicitPosition(this.costsPosition.getX(),this.costsPosition.getY());
         this.buttonsLayout.setExplicitSize(NaN,NaN);
         this.buttonsLayout.setExplicitPosition(this.buttonsPosition.getX(),this.buttonsPosition.getY());
         return super.updateLayout(param1,param2);
      }
   }
}

