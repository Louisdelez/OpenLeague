package com.riotgames.landing.takeover
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.takeover.TakeoverAsset;
   import blix.components.button.ButtonX;
   import blix.components.loader.ImageX;
   import blix.components.loader.ProgressIndicator;
   import blix.context.IContext;
   import com.greensock.TweenLite;
   import com.greensock.easing.Sine;
   import com.riotgames.landing.navigate;
   import com.riotgames.pvpnet.component.AudioButton;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   
   public class TakeoverView extends SpriteProxy
   {
      
      private var _model:TakeoverModel;
      
      private var _showContent:Boolean;
      
      public var content:ImageX;
      
      public var progressIndicator:ProgressIndicator;
      
      public function TakeoverView(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:TakeoverAsset = new TakeoverAsset();
         this.content = new ImageX(this);
         this.content.getProgress().add(this.contentProgressHandler);
         this.content.getCompleted().add(this.contentCompletedHandler);
         this.content.setAlpha(0);
         setTimelineChild(_loc1_.contentContainer,this.content);
         this.progressIndicator = new ProgressIndicator(this);
         setTimelineChild(_loc1_.progressIndicatorAsset,this.progressIndicator);
         var _loc2_:AudioButton = new AudioButton(this);
         _loc2_.setLinkage("assets.closeBtn");
         _loc2_.getLayoutInvalidated().add(invalidateLayout);
         addChild(_loc2_);
         _loc2_.setButtonMode(true);
         _loc2_.setExplicitPosition(1230,10);
         _loc2_.addEventListener(MouseEvent.CLICK,this.contentCloseHandler);
         var _loc3_:ButtonX = new ButtonX(this);
         _loc3_.addEventListener(MouseEvent.CLICK,this.contentClickHandler);
         setTimelineChild(_loc1_.clickArea,_loc3_);
         this.content.addEventListener(MouseEvent.CLICK,this.contentClickHandler);
      }
      
      override protected function setIsOnStage(param1:Boolean) : void
      {
         super.setIsOnStage(param1);
         this.refreshContent();
      }
      
      private function contentProgressHandler() : void
      {
         this.progressIndicator.setPercent(this.content.getPercentLoaded());
      }
      
      private function contentCompletedHandler() : void
      {
         this.progressIndicator.setVisible(false);
         TweenLite.to(this.content.getSetterProxy(),0.5,{
            "alpha":1,
            "ease":Sine.easeIn
         });
      }
      
      private function contentClickHandler(param1:MouseEvent) : void
      {
         if(this._model == null)
         {
            return;
         }
         navigate(this,new URLRequest(this._model.clickUrl));
      }
      
      private function contentCloseHandler(param1:MouseEvent = null) : void
      {
         this._showContent = false;
         this.refreshContent();
         dispatchEvent(new TakeoverEvent(TakeoverEvent.TAKEOVER_CLOSED));
      }
      
      public function getModel() : TakeoverModel
      {
         return this._model;
      }
      
      public function setModel(param1:TakeoverModel) : void
      {
         this._model = param1;
         this.refreshContent();
      }
      
      private function refreshContent() : void
      {
         var _loc1_:Boolean = this._showContent;
         this._showContent = Boolean(getIsOnStage()) && this._model != null;
         if(this._showContent == _loc1_)
         {
            return;
         }
         if(this._showContent)
         {
            this.content.load(new URLRequest(this._model.imageUrl));
         }
         else
         {
            this.content.unloadAndStop();
         }
      }
   }
}

