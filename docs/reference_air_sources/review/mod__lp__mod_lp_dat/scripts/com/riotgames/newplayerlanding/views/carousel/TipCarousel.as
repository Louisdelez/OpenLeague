package com.riotgames.newplayerlanding.views.carousel
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.ButtonX;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.newplayerlanding.NewPlayerLandingConfig;
   import com.riotgames.newplayerlanding.metrics.NPLPTracker;
   import com.riotgames.newplayerlanding.model.NewPlayerLandingPageModel;
   import com.riotgames.platform.common.session.Session;
   import flash.events.MouseEvent;
   
   public class TipCarousel extends SpriteProxy
   {
      
      private var _statTracker:NPLPTracker;
      
      private var _carouselContent:StatefulView;
      
      private var _leftArrow:ButtonX;
      
      private var _rightArrow:ButtonX;
      
      private var _pageModel:NewPlayerLandingPageModel;
      
      private var _championsPage:ChampionsPage;
      
      private var _communityPage:CommunityPage;
      
      private var _itemPage:ItemPage;
      
      private var _goldPage:GoldPage;
      
      private var _turretsPage:TurretsPage;
      
      public function TipCarousel(param1:IContext, param2:NewPlayerLandingPageModel, param3:NPLPTracker)
      {
         this._statTracker = param3;
         super(param1);
         this._pageModel = param2;
         this._pageModel.getActiveCarouselIndexChanged().add(this.onActiveCarouselIndexChanged);
         var _loc4_:int = 0;
         if(Session.instance.summonerLevel.summonerLevel > 1)
         {
            _loc4_ = 1 + Math.floor(Math.random() * (NewPlayerLandingConfig.MAX_CAROUSEL_PAGES - 1));
         }
         this._pageModel.setActiveCarouselIndex(_loc4_);
      }
      
      private function onActiveCarouselIndexChanged(param1:int, param2:int) : void
      {
         this._carouselContent.setCurrentState(param2.toString());
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._leftArrow = new ButtonX(this);
         setTimelineChildByName("leftArrow",this._leftArrow);
         this._leftArrow.addEventListener(MouseEvent.CLICK,this.onLeftArrow);
         this._rightArrow = new ButtonX(this);
         setTimelineChildByName("rightArrow",this._rightArrow);
         this._rightArrow.addEventListener(MouseEvent.CLICK,this.onRightArrow);
         this._carouselContent = new StatefulView(this);
         setTimelineChildByName("carouselContent",this._carouselContent);
         this._championsPage = new ChampionsPage(this,this._statTracker);
         this._carouselContent.setTimelineChildByName("championsPage",this._championsPage);
         this._communityPage = new CommunityPage(this,this._statTracker);
         this._carouselContent.setTimelineChildByName("communityPage",this._communityPage);
         this._itemPage = new ItemPage(this);
         this._carouselContent.setTimelineChildByName("itemPage",this._itemPage);
         this._goldPage = new GoldPage(this);
         this._carouselContent.setTimelineChildByName("goldPage",this._goldPage);
         this._turretsPage = new TurretsPage(this);
         this._carouselContent.setTimelineChildByName("turretsPage",this._turretsPage);
      }
      
      private function onRightArrow(param1:MouseEvent) : void
      {
         var _loc2_:int = this._pageModel.getActiveCarouselIndex();
         if(_loc2_ == NewPlayerLandingConfig.MAX_CAROUSEL_PAGES - 1)
         {
            _loc2_ = Session.instance.summonerLevel.summonerLevel > 1 ? 1 : 0;
         }
         else
         {
            _loc2_++;
         }
         this._pageModel.setActiveCarouselIndex(_loc2_);
         if(this._statTracker)
         {
            this._statTracker.onRightArrow();
         }
      }
      
      private function onLeftArrow(param1:MouseEvent) : void
      {
         var _loc2_:* = this._pageModel.getActiveCarouselIndex();
         if(_loc2_ == (Session.instance.summonerLevel.summonerLevel > 1 ? 1 : 0))
         {
            _loc2_ = int(NewPlayerLandingConfig.MAX_CAROUSEL_PAGES - 1);
         }
         else
         {
            _loc2_--;
         }
         this._pageModel.setActiveCarouselIndex(_loc2_);
         if(this._statTracker)
         {
            this._statTracker.onLeftArrow();
         }
      }
   }
}

