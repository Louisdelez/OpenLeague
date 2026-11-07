package com.riotgames.landing.news.bannerscroller
{
   import blix.assets.proxy.NewsPanel.BannerScroller.BannerItemAsset;
   import blix.assets.proxy.NewsPanel.BannerScroller.BannerScrollerAsset;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.ButtonX;
   import blix.context.IContext;
   import blix.util.callback.preventRepeatedCalls;
   import com.riotgames.landing.analytics.trackEvent;
   import com.riotgames.landing.navigate;
   import com.riotgames.landing.news.bannerscroller.thumb.BannerThumbs;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class BannerScroller extends SpriteProxy
   {
      
      protected static const IMAGE_WIDTH:Number = 597;
      
      protected static const IMAGE_HEIGHT:Number = 268;
      
      protected static const NEXT_IMAGE_INTERVAL:Number = 7000;
      
      private static const BUFFER_COUNT:uint = 1;
      
      private var _model:BannerScrollerModel;
      
      private var _isPaused:Boolean = true;
      
      private var userIsInteracting:Boolean;
      
      private var nextImageIntervalId:uint;
      
      public var callToAction:ButtonX;
      
      public var bannerThumbs:BannerThumbs;
      
      public var bannerItems:Vector.<BannerItem> = new Vector.<BannerItem>();
      
      public var bannerItemsContainerView:SpriteProxy;
      
      public function BannerScroller(param1:IContext)
      {
         super(param1);
         addEventListener(Event.ADDED_TO_STAGE,this.refreshPaused);
         addEventListener(Event.REMOVED_FROM_STAGE,this.refreshPaused);
         addEventListener(MouseEvent.CLICK,this.assetClickHandler);
         addEventListener(MouseEvent.ROLL_OUT,this.assetRollOutHandler);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:BannerScrollerAsset = new BannerScrollerAsset();
         this.callToAction = new ButtonX(this);
         this.callToAction.addEventListener(MouseEvent.CLICK,this.callToActionClickHandler);
         setTimelineChild(_loc1_.callToActionAsset,this.callToAction);
         this.bannerThumbs = new BannerThumbs(this);
         setTimelineChild(_loc1_.bannerThumbsAsset,this.bannerThumbs);
         this.bannerItemsContainerView = _loc1_.bannerItemsContainerAsset.create(this);
      }
      
      protected function callToActionClickHandler(param1:MouseEvent) : void
      {
         if(preventRepeatedCalls(this.callToActionClickHandler,[param1],2000))
         {
            return;
         }
         if(this._model == null)
         {
            return;
         }
         if(this._model.getCurrentBannerIndex() >= this._model.bannerItemModels.length)
         {
            return;
         }
         trackEvent(this,"News Banner Click",this._model.bannerItemModels[this._model.getCurrentBannerIndex()].title);
         var _loc2_:BannerItemModel = this._model.bannerItemModels[this._model.getCurrentBannerIndex()];
         if(_loc2_ != null)
         {
            navigate(this,_loc2_.clickUrlRequest);
         }
      }
      
      protected function gotoNextImage() : void
      {
         if(this._model == null)
         {
            return;
         }
         var _loc1_:int = this.wrapIndex(this._model.getCurrentBannerIndex() + 1,this._model.bannerItemModels.length);
         this._model.setCurrentBannerIndex(_loc1_);
      }
      
      private function wrapIndex(param1:int, param2:uint) : int
      {
         if(param1 < 0)
         {
            param1 = param2 - 1;
         }
         if(param1 >= param2)
         {
            param1 = 0;
         }
         return param1;
      }
      
      public function setModel(param1:BannerScrollerModel) : void
      {
         var _loc2_:BannerItem = null;
         var _loc3_:BannerItemModel = null;
         if(this._model == param1)
         {
            return;
         }
         if(this._model != null)
         {
            this._model.getCurrentBannerIndexChanged().remove(this.currentBannerIndexChangedHandler);
            this.bannerThumbs.setModel(null);
            for each(_loc2_ in this.bannerItems)
            {
               this.bannerItemsContainerView.removeChild(_loc2_);
               _loc2_.destroy();
            }
            this.bannerItems.length = 0;
         }
         this._model = param1;
         if(this._model != null)
         {
            this._model.getCurrentBannerIndexChanged().add(this.currentBannerIndexChangedHandler);
            this.bannerThumbs.setModel(this._model);
            for each(_loc3_ in this._model.bannerItemModels)
            {
               _loc2_ = new BannerItem(this);
               _loc2_.setLinkage(BannerItemAsset.LINKAGE);
               _loc2_.setModel(_loc3_);
               this.bannerItemsContainerView.addChild(_loc2_);
               this.bannerItems[this.bannerItems.length] = _loc2_;
            }
            this.currentBannerIndexChangedHandler(this._model,-1,this._model.getCurrentBannerIndex());
         }
      }
      
      private function currentBannerIndexChangedHandler(param1:BannerScrollerModel, param2:int, param3:int) : void
      {
         var _loc7_:BannerItem = null;
         var _loc4_:uint = this.bannerItems.length;
         var _loc5_:int = param1.getCurrentBannerIndex();
         if(_loc5_ >= _loc4_ || _loc5_ < 0)
         {
            return;
         }
         var _loc6_:int = _loc5_;
         while(_loc6_ <= _loc5_ + BUFFER_COUNT && _loc6_ < _loc4_)
         {
            _loc7_ = this.bannerItems[_loc6_];
            _loc7_.beginLoad();
            _loc6_++;
         }
         if(param2 != -1)
         {
            this.bannerItems[param2].hide();
         }
         this.bannerItems[_loc5_].show();
         this.refreshPaused();
      }
      
      private function assetClickHandler(param1:MouseEvent) : void
      {
         this.userIsInteracting = true;
         this.refreshPaused();
      }
      
      private function assetRollOutHandler(param1:MouseEvent) : void
      {
         this.userIsInteracting = false;
         this.refreshPaused();
      }
      
      private function refreshPaused(param1:Event = null) : void
      {
         var _loc3_:BannerItem = null;
         var _loc2_:Boolean = false;
         if(this._model == null || getStage() == null || this.userIsInteracting || !this.bannerItems.length || getVisible() == false)
         {
            _loc2_ = true;
         }
         else
         {
            _loc3_ = this.bannerItems[this._model.getCurrentBannerIndex()];
            if(!_loc3_.image.getIsFinished())
            {
               _loc2_ = true;
               _loc3_.image.getCompleted().add(this.bannerImageCompletedHandler);
            }
         }
         if(_loc2_ != this._isPaused)
         {
            this._isPaused = _loc2_;
            if(!this._isPaused)
            {
               this.nextImageIntervalId = setInterval(this.gotoNextImage,NEXT_IMAGE_INTERVAL);
            }
            else
            {
               clearInterval(this.nextImageIntervalId);
            }
         }
      }
      
      override public function setVisible(param1:Boolean) : void
      {
         super.setVisible(param1);
         this.refreshPaused();
      }
      
      private function bannerImageCompletedHandler() : void
      {
         this.refreshPaused();
      }
      
      override public function destroy() : void
      {
         this.setModel(null);
         super.destroy();
      }
   }
}

