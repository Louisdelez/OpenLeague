package com.riotgames.landing.news.bannerscroller.thumb
{
   import blix.assets.proxy.NewsPanel.BannerScroller.BannerThumbAsset;
   import blix.assets.proxy.NewsPanel.BannerScroller.BannerThumbsAsset;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.ButtonX;
   import blix.context.IContext;
   import blix.layout.LayoutContainer;
   import blix.layout.algorithms.VerticalLayout;
   import com.greensock.TweenLite;
   import com.greensock.easing.Sine;
   import com.riotgames.landing.news.bannerscroller.BannerItemModel;
   import com.riotgames.landing.news.bannerscroller.BannerScrollerModel;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class BannerThumbs extends SpriteProxy
   {
      
      private static const THUMBS_PER_SCREEN:uint = 4;
      
      private static const GAP:Number = 5;
      
      private var _model:BannerScrollerModel;
      
      private var _currentScreenIndex:int = -1;
      
      private var _visualScreenIndex:Number = 0;
      
      private var thumbsContainerY:Number = 0;
      
      public var thumbsContainer:SpriteProxy;
      
      public var bannerThumbs:Vector.<BannerThumb> = new Vector.<BannerThumb>();
      
      public var previousButton:ButtonX;
      
      public var nextButton:ButtonX;
      
      private var thumbsLayout:LayoutContainer;
      
      public function BannerThumbs(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:BannerThumbsAsset = new BannerThumbsAsset();
         this.thumbsContainer = _loc1_.thumbsContainerAsset.create(this);
         this.thumbsLayout = new LayoutContainer(this);
         var _loc2_:VerticalLayout = new VerticalLayout();
         _loc2_.setGap(GAP);
         this.thumbsLayout.setLayoutAlgorithm(_loc2_);
         this.previousButton = new ButtonX(this);
         this.previousButton.addEventListener(MouseEvent.CLICK,this.previousClickHandler);
         setTimelineChild(_loc1_.previousButtonAsset,this.previousButton);
         this.nextButton = new ButtonX(this);
         this.nextButton.addEventListener(MouseEvent.CLICK,this.nextClickHandler);
         setTimelineChild(_loc1_.nextButtonAsset,this.nextButton);
      }
      
      override protected function configureAsset(param1:DisplayObject) : void
      {
         super.configureAsset(param1);
         if(_asset != null)
         {
            this.thumbsContainerY = this.thumbsContainer.getY();
         }
      }
      
      private function previousClickHandler(param1:MouseEvent) : void
      {
         if(this._model == null)
         {
            return;
         }
         this.setCurrentScreenIndex(this.getCurrentScreenIndex() - 1);
      }
      
      private function nextClickHandler(param1:MouseEvent) : void
      {
         if(this._model == null)
         {
            return;
         }
         this.setCurrentScreenIndex(this.getCurrentScreenIndex() + 1);
      }
      
      public function setModel(param1:BannerScrollerModel) : void
      {
         var _loc2_:BannerThumb = null;
         var _loc3_:uint = 0;
         var _loc4_:BannerItemModel = null;
         var _loc5_:BannerThumb = null;
         if(this._model != null)
         {
            this._model.getCurrentBannerIndexChanged().remove(this.currentBannerIndexChangedHandler);
            for each(_loc2_ in this.bannerThumbs)
            {
               this.thumbsContainer.removeChild(_loc2_);
               _loc2_.destroy();
            }
            this.thumbsLayout.removeAllElements();
            this.bannerThumbs.length = 0;
         }
         this._model = param1;
         if(this._model != null)
         {
            _loc3_ = 0;
            for each(_loc4_ in param1.bannerItemModels)
            {
               _loc5_ = new BannerThumb(this);
               _loc5_.addEventListener(MouseEvent.CLICK,this.bannerThumbClickHandler);
               _loc5_.setModel(_loc4_);
               _loc5_.setLinkage(BannerThumbAsset.LINKAGE);
               this.thumbsContainer.addChild(_loc5_);
               this.thumbsLayout.addElement(_loc5_);
               this.bannerThumbs[_loc3_] = _loc5_;
               _loc3_++;
            }
            this._model.getCurrentBannerIndexChanged().add(this.currentBannerIndexChangedHandler);
            this.currentBannerIndexChangedHandler(this._model,-1,this._model.getCurrentBannerIndex());
         }
      }
      
      protected function bannerThumbClickHandler(param1:MouseEvent) : void
      {
         if(this._model == null)
         {
            return;
         }
         var _loc2_:BannerThumb = param1.currentTarget as BannerThumb;
         var _loc3_:int = this._model.bannerItemModels.indexOf(_loc2_.getModel());
         this._model.setCurrentBannerIndex(_loc3_);
      }
      
      private function currentBannerIndexChangedHandler(param1:BannerScrollerModel, param2:int, param3:int) : void
      {
         if(param2 != -1)
         {
            this.bannerThumbs[param2].setSelected(false);
         }
         if(param3 < this.bannerThumbs.length)
         {
            this.bannerThumbs[param3].setSelected(true);
         }
         this.refreshCurrentScreenIndex();
      }
      
      protected function refreshCurrentScreenIndex() : void
      {
         var _loc1_:int = Math.floor(this._model.getCurrentBannerIndex() / THUMBS_PER_SCREEN);
         this.setCurrentScreenIndex(_loc1_);
      }
      
      private function getCurrentScreenIndex() : int
      {
         return this._currentScreenIndex;
      }
      
      private function setCurrentScreenIndex(param1:int) : void
      {
         if(this._currentScreenIndex == param1)
         {
            return;
         }
         this._currentScreenIndex = param1;
         this.previousButton.setEnabled(param1 > 0);
         this.nextButton.setEnabled(param1 < this.getLastScreenIndex());
         TweenLite.to(this,0.5,{
            "visualScreenIndex":param1,
            "ease":Sine.easeOut
         });
      }
      
      private function getLastScreenIndex() : int
      {
         return Math.floor((this._model.bannerItemModels.length - 1) / THUMBS_PER_SCREEN);
      }
      
      public function get visualScreenIndex() : Number
      {
         return this._visualScreenIndex;
      }
      
      public function set visualScreenIndex(param1:Number) : void
      {
         if(this._visualScreenIndex == param1)
         {
            return;
         }
         this._visualScreenIndex = param1;
         invalidateLayout();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this.thumbsContainer.setY(this.thumbsContainerY - this._visualScreenIndex * (BannerThumb.IMAGE_HEIGHT + GAP) * THUMBS_PER_SCREEN);
         return super.updateLayout(param1,param2);
      }
   }
}

