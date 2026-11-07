package com.riotgames.newplayerlanding.metrics
{
   import com.riotgames.newplayerlanding.model.NewPlayerLandingPageModel;
   import com.riotgames.pvpnet.tracker.SessionTimeframedTracker;
   
   public class NPLPTracker extends SessionTimeframedTracker
   {
      
      private var _pageStartTime:Number = NaN;
      
      private var _firstPage:Boolean = true;
      
      private var _pageModel:NewPlayerLandingPageModel;
      
      public function NPLPTracker(param1:NewPlayerLandingPageModel)
      {
         super("igo_new_player_landing_page");
         this._pageModel = param1;
         this._pageModel.getActiveCarouselIndexChanged().add(this.onActiveCarouselIndexChanged);
      }
      
      override public function sessionClosed() : void
      {
         this.onCloseInternal();
         super.sessionClosed();
      }
      
      public function onStageStateChanged(param1:Boolean) : void
      {
         if(param1)
         {
            this._pageStartTime = clock.getNow();
         }
         else
         {
            this.onCloseInternal();
         }
      }
      
      private function onActiveCarouselIndexChanged(param1:int, param2:int) : void
      {
         var _loc4_:Number = NaN;
         if(this._firstPage)
         {
            setProperty("first_page_visited.index",param2);
            this._firstPage = false;
         }
         var _loc3_:Number = Number(clock.getNow());
         if(!isNaN(this._pageStartTime))
         {
            _loc4_ = _loc3_ - this._pageStartTime;
            this.updatePageTime(param1,_loc4_);
         }
         incrementCounter("page_visits.page_" + param2 + ".count");
         this._pageStartTime = _loc3_;
      }
      
      public function onRightArrow() : void
      {
         incrementCounter("button_clicked.right_arrow.count");
      }
      
      public function onLeftArrow() : void
      {
         incrementCounter("button_clicked.left_arrow.count");
      }
      
      public function onClose() : void
      {
         incrementCounter("button_clicked.close.count");
         this.onCloseInternal();
      }
      
      public function onLike() : void
      {
         incrementCounter("button_clicked.like.count");
      }
      
      public function onSubscribe() : void
      {
         incrementCounter("button_clicked.subscribe.count");
      }
      
      public function onChampClicked(param1:Number) : void
      {
         incrementCounter("button_clicked.champ_" + param1 + ".count");
      }
      
      private function onCloseInternal() : void
      {
         var _loc2_:Number = NaN;
         var _loc1_:Number = Number(clock.getNow());
         if(!isNaN(this._pageStartTime))
         {
            _loc2_ = _loc1_ - this._pageStartTime;
            this.updatePageTime(this._pageModel.getActiveCarouselIndex(),_loc2_);
         }
         this._pageStartTime = NaN;
      }
      
      private function updatePageTime(param1:Number, param2:Number) : void
      {
         incrementCounter("time_spent_on_page.page_" + param1 + ".duration",param2);
      }
   }
}

