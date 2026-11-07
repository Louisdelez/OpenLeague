package com.riotgames.championdetails.abilities
{
   import blix.action.LoaderAction;
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.abilities.AbilitiesVideoAsset;
   import blix.components.button.ButtonX;
   import blix.components.loader.ImageX;
   import blix.components.text.Text;
   import blix.components.video.VideoModel;
   import blix.components.video.VideoX;
   import blix.context.Context;
   import blix.layout.vo.HorizontalAlign;
   import blix.layout.vo.VerticalAlign;
   import com.greensock.TweenLite;
   import com.greensock.easing.Sine;
   import com.riotgames.championdetails.IChampionDetailsContext;
   import com.riotgames.championdetails.Main;
   import com.riotgames.common.fadeOut;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import mx.resources.IResourceManager;
   
   public class AbilitiesVideoPlayer extends SpriteProxy
   {
      
      private static const CHAMPION_DETAILS_RESOURCE_ID:String = Main.CHAMPION_DETAILS_RESOURCE_ID;
      
      public var model:VideoModel = new VideoModel();
      
      private var video:VideoX;
      
      private var stillImage:ImageX;
      
      private var playButton:ButtonX;
      
      private var pauseButton:ButtonX;
      
      private var bufferingIndicator:MovieClipProxy;
      
      private var videoUnavailableText:Text;
      
      private var _disabled:Boolean;
      
      private var cdpContext:IChampionDetailsContext;
      
      private var resourceManager:IResourceManager;
      
      public function AbilitiesVideoPlayer(param1:Context)
      {
         super(param1);
         this.initModel();
         this.cdpContext = getFirstContext(IChampionDetailsContext);
      }
      
      override protected function setIsOnStage(param1:Boolean) : void
      {
         super.setIsOnStage(param1);
         if(!param1)
         {
            this.model.stop();
         }
      }
      
      private function initModel() : void
      {
         this.model.pause();
         this.model.getVideoUrlChanged().add(this.videoUrlChangedHandler);
         this.model.getIsPlayingChanged().add(this.videoIsPlayingChangedHandler);
         this.model.getIsStoppedChanged().add(this.refreshStillImageVisible);
         this.videoUrlChangedHandler();
         this.videoIsPlayingChangedHandler();
      }
      
      public function setStillImagePath(param1:String) : void
      {
         if(this.cdpContext.getConfig().useTransitions)
         {
            fadeOut(this.stillImage.getAsset());
         }
         this.stillImage.setAlpha(0);
         this.stillImage.load(new URLRequest(param1));
         this.stillImage.getErred().add(this.stillImageUnavailableHandler);
         this.stillImage.getCompleted().add(this.stillImageLoadedHandler);
      }
      
      private function videoUrlChangedHandler() : void
      {
         this.videoUnavailableText.setText("");
         this.setDisabled(true);
      }
      
      private function videoIsPlayingChangedHandler() : void
      {
         this.refreshPlayButtonIsVisible();
         this.pauseButton.setVisible(this.model.getIsPlaying());
         this.refreshBufferingIndicatorVisible();
      }
      
      private function stillImageLoadedHandler() : void
      {
         this.stillImage.getErred().remove(this.stillImageUnavailableHandler);
         this.stillImage.getCompleted().remove(this.stillImageLoadedHandler);
         this.setDisabled(false);
         TweenLite.to(this.stillImage.getSetterProxy(),0.5,{
            "alpha":1,
            "ease":Sine.easeOut
         });
      }
      
      private function stillImageUnavailableHandler() : void
      {
         this.stillImage.getErred().remove(this.stillImageUnavailableHandler);
         this.stillImage.getCompleted().remove(this.stillImageLoadedHandler);
         this.videoUnavailableText.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"abilityScreen.noVideo"));
         this.setDisabled(true);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:AbilitiesVideoAsset = new AbilitiesVideoAsset();
         this.video = new VideoX(this,this.model);
         this.video.setHorizontalAlign(HorizontalAlign.CENTER);
         this.video.setVerticalAlign(VerticalAlign.MIDDLE);
         this.video.getLayoutInvalidated().add(invalidateLayout);
         this.video.getErred().add(this.videoErredHandler);
         setTimelineChild(_loc1_.videoContainer,this.video);
         this.stillImage = new ImageX(this);
         this.stillImage.setHorizontalAlign(HorizontalAlign.CENTER);
         this.stillImage.setVerticalAlign(VerticalAlign.MIDDLE);
         this.stillImage.setAlpha(0.7);
         var _loc2_:LoaderAction = this.stillImage.getLoader().loaderAction;
         _loc2_.getCompleted().add(this.refreshBufferingIndicatorVisible);
         _loc2_.getErred().add(this.refreshBufferingIndicatorVisible);
         _loc2_.getAborted().add(this.refreshBufferingIndicatorVisible);
         _loc2_.getProgress().add(this.refreshBufferingIndicatorVisible);
         setTimelineChild(_loc1_.stillImageContainer,this.stillImage);
         this.playButton = new ButtonX(this);
         this.playButton.addEventListener(MouseEvent.CLICK,this.playClickHandler);
         setTimelineChild(_loc1_.playButton,this.playButton);
         this.pauseButton = new ButtonX(this);
         this.pauseButton.addEventListener(MouseEvent.CLICK,this.pauseClickHandler);
         setTimelineChild(_loc1_.pauseButton,this.pauseButton);
         this.bufferingIndicator = _loc1_.bufferingAnimation.create(this);
         this.bufferingIndicator.play();
         this.video.getIsBufferingChanged().add(this.videoIsBufferingChangedHandler);
         this.videoIsBufferingChangedHandler();
         this.videoUnavailableText = new Text(this);
         this.videoUnavailableText.setMouseEnabled(false);
         this.videoUnavailableText.setVisible(false);
         setTimelineChild(_loc1_.videoUnavailableText,this.videoUnavailableText);
      }
      
      private function videoIsBufferingChangedHandler() : void
      {
         this.refreshBufferingIndicatorVisible();
         this.refreshStillImageVisible();
      }
      
      private function videoErredHandler() : void
      {
         this.videoUnavailableText.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"abilityScreen.noVideo"));
         this.setDisabled(true);
      }
      
      private function playClickHandler(param1:MouseEvent) : void
      {
         this.model.play();
      }
      
      private function pauseClickHandler(param1:MouseEvent) : void
      {
         this.model.pause();
      }
      
      private function setDisabled(param1:Boolean) : void
      {
         this._disabled = param1;
         if(param1)
         {
            this.pauseButton.setVisible(false);
            this.videoUnavailableText.setVisible(true);
         }
         else
         {
            this.videoUnavailableText.setVisible(false);
            this.videoIsPlayingChangedHandler();
         }
         this.refreshPlayButtonIsVisible();
         this.refreshStillImageVisible();
      }
      
      public function getDisabled() : Boolean
      {
         return this._disabled;
      }
      
      private function refreshPlayButtonIsVisible() : void
      {
         this.playButton.setVisible(!this.model.getIsPlaying() && !this._disabled);
      }
      
      private function refreshBufferingIndicatorVisible() : void
      {
         var _loc1_:LoaderAction = this.stillImage.getLoader().loaderAction;
         var _loc2_:Number = Number(_loc1_.getPercentLoaded());
         var _loc3_:Boolean = Boolean(_loc1_.getHasBeenInvoked()) && _loc2_ > 0 && _loc2_ < 0.95 && !_loc1_.getIsFinished();
         this.bufferingIndicator.setVisible(_loc3_ || Boolean(this.model.getIsPlaying()) && Boolean(this.video.getIsBuffering()));
      }
      
      private function refreshStillImageVisible() : void
      {
         if(this._disabled)
         {
            this.stillImage.setVisible(false);
         }
         else
         {
            this.stillImage.setVisible(Boolean(this.model.getIsStopped()) || Boolean(this.video.getIsBuffering()));
         }
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:DisplayObject = _asset["videoSizer"];
         this.video.setExplicitSize(_loc3_.width,_loc3_.height);
         this.stillImage.setExplicitSize(_loc3_.width,_loc3_.height);
         return _asset.getBounds(null);
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this.resourceManager = getDependency(IResourceManager);
      }
   }
}

