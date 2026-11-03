package com.riotgames.landing.spotlight
{
   import blix.assets.proxy.SpotlightPanel.SpotlightPanelAsset;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.ButtonX;
   import blix.components.button.LabelButtonX;
   import blix.components.text.Text;
   import blix.context.IContext;
   import blix.layout.LayoutContainer;
   import blix.layout.algorithms.CanvasLayout;
   import blix.layout.algorithms.HorizontalLayout;
   import blix.layout.data.CanvasLayoutData;
   import blix.layout.vo.VerticalAlign;
   import blix.util.callback.preventRepeatedCalls;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.greensock.TweenLite;
   import com.greensock.easing.Sine;
   import com.riotgames.landing.analytics.trackEvent;
   import com.riotgames.landing.navigate;
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.pvpnet.component.AudioButton;
   import com.riotgames.rust.effects.fadeOut;
   import com.riotgames.youtube.YouTubePlayer;
   import com.riotgames.youtube.YouTubeStateChangeCodes;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class SpotlightPanel extends SpriteProxy
   {
      
      protected var _model:SpotlightPanelModel;
      
      public var titleText:Text;
      
      public var infoButton:LabelButtonX;
      
      public var buyButton:LabelButtonX;
      
      public var spotlightTitleText:Text;
      
      public var previousButton:AudioButton;
      
      public var nextButton:AudioButton;
      
      public var fullScreenButton:ButtonX;
      
      public var sizer:SpriteProxy;
      
      public var backgroundInnerView:SpriteProxy;
      
      public var backgroundOuterView:SpriteProxy;
      
      public var spotlightControls:SpriteProxy;
      
      protected var video:YouTubePlayer;
      
      private var isPlaying:Boolean;
      
      private var normalRect:Rectangle;
      
      private var _fullScreenRect:Rectangle;
      
      private var _fullScreenPercent:Number = 0;
      
      private var layout:LayoutContainer;
      
      private var spotlightPanelControlsView:SpriteProxy;
      
      public function SpotlightPanel(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         var _loc2_:SpotlightPanelAsset = new SpotlightPanelAsset();
         this.titleText = new Text(this);
         this.titleText.setText(_loc1_.getString("LandingPage","videoSpotlightPanel.title"));
         setTimelineChild(_loc2_.titleTextFieldAsset,this.titleText);
         this.infoButton = new LabelButtonX(this);
         this.infoButton.setText(_loc1_.getString("LandingPage","common.info"));
         this.infoButton.addEventListener(MouseEvent.CLICK,this.infoClickHandler);
         setTimelineChild(_loc2_.spotlightPanelControls.infoButtonAsset,this.infoButton);
         this.buyButton = new LabelButtonX(this);
         this.buyButton.setText(_loc1_.getString("LandingPage","common.buy"));
         this.buyButton.addEventListener(MouseEvent.CLICK,this.buyClickHandler);
         setTimelineChild(_loc2_.spotlightPanelControls.buyButtonAsset,this.buyButton);
         this.spotlightTitleText = new Text(this);
         this.spotlightTitleText.setText("");
         this.spotlightTitleText.setTruncateToFit(true);
         setTimelineChild(_loc2_.spotlightPanelControls.navControlsAsset.textFieldAsset,this.spotlightTitleText);
         this.previousButton = new AudioButton(this,null,AudioKeys.SOUND_LANDING_PAGE_ARROW_CLICK);
         setTimelineChild(_loc2_.spotlightPanelControls.navControlsAsset.leftArrowAsset,this.previousButton);
         this.previousButton.addEventListener(MouseEvent.CLICK,this.previousClickHandler);
         this.nextButton = new AudioButton(this,null,AudioKeys.SOUND_LANDING_PAGE_ARROW_CLICK);
         setTimelineChild(_loc2_.spotlightPanelControls.navControlsAsset.rightArrowAsset,this.nextButton);
         this.nextButton.addEventListener(MouseEvent.CLICK,this.nextClickHandler);
         this.fullScreenButton = new ButtonX(this);
         this.fullScreenButton.toggleOnClick = true;
         this.fullScreenButton.addEventListener(MouseEvent.CLICK,this.fullScreenClickHandler);
         setTimelineChild(_loc2_.fullScreenButtonAsset,this.fullScreenButton);
         this.sizer = new SpriteProxy(this);
         this.sizer.getLayoutInvalidated().add(invalidateLayout);
         this.sizer.setTransformBehavior(new ScalingTransformBehavior());
         setTimelineChild(_loc2_.youTubeSizer,this.sizer);
         this.backgroundInnerView = new SpriteProxy(this);
         this.backgroundInnerView.setTransformBehavior(new ScalingTransformBehavior());
         setTimelineChild(_loc2_.backgroundInnerAsset,this.backgroundInnerView);
         this.backgroundOuterView = new SpriteProxy(this);
         this.backgroundOuterView.setTransformBehavior(new ScalingTransformBehavior());
         setTimelineChild(_loc2_.backgroundOuterAsset,this.backgroundOuterView);
         this.spotlightControls = new SpriteProxy(this);
         setTimelineChild(_loc2_.spotlightPanelControls.navControlsAsset,this.spotlightControls);
         var _loc3_:HorizontalLayout = new HorizontalLayout();
         _loc3_.setVerticalAlign(VerticalAlign.BOTTOM);
         this.spotlightPanelControlsView = _loc2_.spotlightPanelControls.create(this);
         var _loc4_:LayoutContainer = new LayoutContainer(this);
         _loc4_.setLayoutAlgorithm(_loc3_);
         _loc4_.addElement(this.spotlightControls);
         _loc4_.addElement(this.infoButton);
         _loc4_.addElement(this.buyButton);
         this.layout = new LayoutContainer(this);
         this.layout.setLayoutAlgorithm(new CanvasLayout());
         this.video = new YouTubePlayer(this);
         this.video.getPlayerStateChanged().add(this.playerStateChangedHandler);
         _loc2_.youTubeScrollerAsset.create(this).addChild(this.video);
      }
      
      public function setFullScreenRect(param1:Rectangle) : void
      {
         this._fullScreenRect = param1;
         this.setFullScreenPercent(this._fullScreenPercent);
      }
      
      protected function fullScreenClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = Boolean(this.fullScreenButton.getSelected());
         if(this._model != null && this._model.videoSpotlightModels.length > 0)
         {
            if(_loc2_)
            {
               trackEvent(this,"Video Go Fullscreen",this._model.videoSpotlightModels[this._model.getCurrentVideoIndex()].videoName);
            }
         }
         this.setFullScreen(_loc2_);
      }
      
      protected function previousClickHandler(param1:MouseEvent) : void
      {
         trackEvent(this,"Video","Video/Previous/Click");
         if(this._model == null)
         {
            return;
         }
         var _loc2_:int = this._model.getCurrentVideoIndex() - 1;
         if(_loc2_ < 0)
         {
            _loc2_ = this._model.videoSpotlightModels.length - 1;
         }
         this._model.setCurrentVideoIndex(_loc2_);
      }
      
      protected function nextClickHandler(param1:MouseEvent) : void
      {
         trackEvent(this,"Video","Video/Next/Click");
         if(this._model == null)
         {
            return;
         }
         var _loc2_:int = this._model.getCurrentVideoIndex() + 1;
         if(_loc2_ >= this._model.videoSpotlightModels.length)
         {
            _loc2_ = 0;
         }
         this._model.setCurrentVideoIndex(_loc2_);
      }
      
      public function setModel(param1:SpotlightPanelModel) : void
      {
         if(this._model != null)
         {
            this._model.getCurrentVideoIndexChanged().remove(this.videoIndexChangedHandler);
         }
         this._model = param1;
         if(this._model != null)
         {
            this._model.getCurrentVideoIndexChanged().add(this.videoIndexChangedHandler);
            this.videoIndexChangedHandler();
         }
      }
      
      private function videoIndexChangedHandler() : void
      {
         if(this._model.videoSpotlightModels == null)
         {
            return;
         }
         var _loc1_:uint = this._model.videoSpotlightModels.length;
         var _loc2_:int = this._model.getCurrentVideoIndex();
         if(_loc2_ >= _loc1_ || _loc2_ < 0)
         {
            return;
         }
         this.isPlaying = false;
         var _loc3_:VideoSpotlightModel = this._model.videoSpotlightModels[_loc2_];
         this.spotlightTitleText.setText(_loc3_.videoName);
         this.infoButton.setVisible(_loc3_.infoUrlRequest != null);
         this.buyButton.setVisible(_loc3_.buyUrlRequest != null);
         fadeOut(this.video.getAsset());
         this.video.loadVideo(_loc3_.videoUrl);
      }
      
      private function playerStateChangedHandler(param1:YouTubePlayer, param2:int, param3:int) : void
      {
         var _loc4_:String = null;
         var _loc5_:VideoSpotlightModel = null;
         if(param2 != param3)
         {
            _loc4_ = "";
            switch(param3)
            {
               case YouTubeStateChangeCodes.ENDED:
                  _loc4_ = "Played To End";
                  break;
               case YouTubeStateChangeCodes.PLAYING:
                  _loc4_ = "Play";
                  break;
               case YouTubeStateChangeCodes.PAUSED:
                  _loc4_ = "Pause";
            }
            if(_loc4_.length > 0)
            {
               _loc5_ = this._model.videoSpotlightModels[this._model.getCurrentVideoIndex()];
               if(_loc4_ == "Played To End" || _loc4_ == "Play" && !this.isPlaying)
               {
                  trackEvent(this,"Video" + _loc4_,_loc5_.videoName);
               }
               this.isPlaying = _loc4_ == "Play";
            }
         }
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
         var _loc2_:VideoSpotlightModel = this._model.videoSpotlightModels[this._model.getCurrentVideoIndex()];
         trackEvent(this,"Click Info",_loc2_.videoName);
         navigate(this,_loc2_.infoUrlRequest);
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
         var _loc2_:VideoSpotlightModel = this._model.videoSpotlightModels[this._model.getCurrentVideoIndex()];
         trackEvent(this,"Click Buy",_loc2_.videoName);
         navigate(this,_loc2_.buyUrlRequest);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc8_:DisplayObject = null;
         var _loc9_:DisplayObject = null;
         var _loc10_:DisplayObject = null;
         var _loc11_:CanvasLayoutData = null;
         var _loc12_:DisplayObject = null;
         var _loc13_:CanvasLayoutData = null;
         var _loc14_:CanvasLayoutData = null;
         var _loc15_:CanvasLayoutData = null;
         var _loc16_:DisplayObject = null;
         var _loc17_:CanvasLayoutData = null;
         var _loc18_:DisplayObject = null;
         if(this.normalRect == null)
         {
            _loc8_ = _asset;
            _loc9_ = _loc8_["backgroundOuterAsset"];
            this.normalRect = new Rectangle(_loc8_.x,_loc8_.y,_loc9_.width,_loc9_.height);
            _logger.logInfo("normalRect: " + this.normalRect);
            _loc10_ = _loc8_["youTubeSizer"];
            _loc11_ = new CanvasLayoutData();
            _loc11_.setLeft(_loc10_.x);
            _loc11_.setRight(_loc9_.width - _loc10_.width - _loc10_.x);
            _loc11_.setTop(_loc10_.y);
            _loc11_.setBottom(_loc9_.height - _loc10_.height - _loc10_.y);
            this.layout.addElement(this.sizer,_loc11_);
            _loc12_ = _loc8_["backgroundInnerAsset"];
            _loc13_ = new CanvasLayoutData();
            _loc13_.setLeft(_loc12_.x);
            _loc13_.setRight(_loc9_.width - _loc12_.width - _loc12_.x);
            _loc13_.setTop(_loc12_.y);
            _loc13_.setBottom(_loc9_.height - _loc12_.height - _loc12_.y);
            this.layout.addElement(this.backgroundInnerView,_loc13_);
            _loc14_ = new CanvasLayoutData();
            _loc14_.setWidthPercent(1);
            _loc14_.setHeightPercent(1);
            this.layout.addElement(this.backgroundOuterView,_loc14_);
            _loc15_ = new CanvasLayoutData();
            _loc15_.setHeight(100);
            _loc16_ = _loc8_["controlsPosition"];
            _loc15_.setLeft(_loc16_.x);
            _loc15_.setBottom(_loc9_.height - _loc16_.y);
            this.layout.addElement(this.spotlightPanelControlsView,_loc15_);
            _loc17_ = new CanvasLayoutData();
            _loc18_ = _loc8_["fullScreenButtonAsset"];
            _loc17_.setTop(_loc18_.y);
            _loc17_.setRight(_loc9_.width - _loc18_.x - _loc18_.width);
            this.layout.addElement(this.fullScreenButton,_loc17_);
         }
         var _loc3_:Number = this._fullScreenRect.width - this.normalRect.width;
         var _loc4_:Number = this._fullScreenRect.height - this.normalRect.height;
         var _loc5_:Number = _loc3_ * this._fullScreenPercent + this.normalRect.width;
         var _loc6_:Number = _loc4_ * this._fullScreenPercent + this.normalRect.height;
         this.layout.setExplicitSize(_loc5_,_loc6_);
         var _loc7_:Rectangle = this.sizer.getBounds(_asset);
         this.video.setExplicitSize(_loc7_.width,_loc7_.height);
         return new Rectangle(0,0,param1,param2);
      }
      
      override protected function updatePosition(param1:Number, param2:Number) : Point
      {
         if(this._fullScreenRect == null || this.normalRect == null)
         {
            return new Point();
         }
         var _loc3_:Number = this._fullScreenRect.x - this.normalRect.x;
         var _loc4_:Number = this._fullScreenRect.y - this.normalRect.y;
         param1 = _loc3_ * this._fullScreenPercent + this.normalRect.x;
         param2 = _loc4_ * this._fullScreenPercent + this.normalRect.y;
         return super.updatePosition(param1,param2);
      }
      
      private function setFullScreen(param1:Boolean) : void
      {
         TweenLite.to(this,0.5,{
            "fullScreenPercent":(param1 ? 1 : 0),
            "ease":Sine.easeOut
         });
      }
      
      public function get fullScreenPercent() : Number
      {
         return this._fullScreenPercent;
      }
      
      public function set fullScreenPercent(param1:Number) : void
      {
         this.setFullScreenPercent(param1);
      }
      
      private function setFullScreenPercent(param1:Number) : void
      {
         if(this.normalRect == null || this._fullScreenRect == null)
         {
            return;
         }
         this._fullScreenPercent = param1;
         invalidateLayout();
      }
   }
}

