package com.riotgames.newplayerlanding.views
{
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.newplayerlanding.metrics.NPLPTracker;
   import com.riotgames.newplayerlanding.model.NewPlayerLandingPageModel;
   import com.riotgames.newplayerlanding.views.carousel.TipCarousel;
   import com.riotgames.pvpnet.component.AudioButton;
   import flash.events.MouseEvent;
   
   public class NPLPView extends StatefulView
   {
      
      private var _tipCarousel:TipCarousel;
      
      private var _pageModel:NewPlayerLandingPageModel = new NewPlayerLandingPageModel();
      
      private var _closedSignal:Signal = new Signal();
      
      private var _statTracker:NPLPTracker = null;
      
      public function NPLPView(param1:IContext, param2:Boolean)
      {
         if(param2)
         {
            this._statTracker = new NPLPTracker(this._pageModel);
         }
         super(param1);
         setLinkage("nplp.LandingPageView");
         getIsOnStageChanged().add(this.onStageStateChange);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._tipCarousel = new TipCarousel(this,this._pageModel,this._statTracker);
         setTimelineChildByName("tipCarousel",this._tipCarousel);
         var _loc1_:AudioButton = new AudioButton(this);
         setTimelineChildByName("closeBtn",_loc1_);
         _loc1_.addEventListener(MouseEvent.CLICK,this.contentCloseHandler);
      }
      
      private function contentCloseHandler(param1:MouseEvent = null) : void
      {
         this._closedSignal.dispatch();
         if(this._statTracker)
         {
            this._statTracker.onClose();
         }
      }
      
      public function getClosed() : ISignal
      {
         return this._closedSignal;
      }
      
      private function onStageStateChange() : void
      {
         if(this._statTracker)
         {
            this._statTracker.onStageStateChanged(getIsOnStage());
         }
      }
   }
}

