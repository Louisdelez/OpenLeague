package com.riotgames.pvpnet.celebration.views
{
   import blix.action.IAction;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.LabelButtonX;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.provider.SoundProviderProxy;
   import com.riotgames.platform.gameclient.domain.celebration.SimpleDialogMessage;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.media.SoundTransform;
   
   public class TierPromotionDialog extends StatefulView
   {
      
      public static const GIFT_CELEBRATION:int = 1;
      
      private var okButton:LabelButtonX;
      
      private var titleText:TextFieldProxy;
      
      private var bodyText:TextFieldProxy;
      
      private var customMessageText:TextFieldProxy;
      
      private var dialogBoxContainer:SpriteProxy;
      
      private var dialogueDismissed:Signal = new Signal();
      
      private var model:SimpleDialogMessage;
      
      private var assetLoaded:Boolean = false;
      
      private var assetRect:Rectangle = new Rectangle(-700,-368,820,446);
      
      public function TierPromotionDialog(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         setCurrentState("default");
         getAssetChanged().add(this.handleAssetChanged);
         getIsOnStageChanged().addOnce(this.playAnimationIfReady);
         setLinkage("TierPromotionDialogue");
         setTransitionsEnabled(UserPreferencesManager.userPrefs.enableAnimations);
      }
      
      override protected function createChildren() : void
      {
         this.dialogBoxContainer = new SpriteProxy(this);
         setTimelineChildByName("infoBox",this.dialogBoxContainer);
         this.bodyText = new TextFieldProxy(this);
         this.dialogBoxContainer.setTimelineChildByName("bodyText",this.bodyText);
         this.customMessageText = new TextFieldProxy(this);
         this.dialogBoxContainer.setTimelineChildByName("customMessage",this.customMessageText);
         this.okButton = new LabelButtonX(this);
         this.dialogBoxContainer.setTimelineChildByName("closeButton",this.okButton);
         this.okButton.addEventListener(MouseEvent.CLICK,this.onCloseButtonClicked);
         this.okButton.setText("OK");
         this.titleText = new TextFieldProxy(this);
         this.dialogBoxContainer.setTimelineChildByName("titleText",this.titleText);
      }
      
      override public function destroy() : void
      {
         this.dialogueDismissed.removeAll();
         this.okButton.removeEventListener(MouseEvent.CLICK,this.onCloseButtonClicked);
         getAssetChanged().removeAll();
         getIsOnStageChanged().removeAll();
         super.destroy();
      }
      
      public function setModel(param1:SimpleDialogMessage, param2:String) : void
      {
         if(this.model != param1)
         {
            this.model = param1;
         }
         if(this.model)
         {
            this.titleText.setText(this.model.titleCode);
         }
      }
      
      public function getDialogDismissed() : ISignal
      {
         return this.dialogueDismissed;
      }
      
      private function playAnimationIfReady() : void
      {
         if(this.assetLoaded && Boolean(getIsOnStage()))
         {
            this.startAnimation();
         }
      }
      
      private function startAnimation() : void
      {
         setCurrentState("default");
         setCurrentState("intro");
         getStateAnimation("intro").getCompleted().add(this.introAnimationComplete);
      }
      
      private function handleAssetChanged() : void
      {
         var _loc1_:MovieClip = getAsset() as MovieClip;
         if(_loc1_)
         {
            SoundProviderProxy.instance.applyVolumeToMovieClip(_loc1_);
            this.assetLoaded = true;
            if(getIsOnStage())
            {
               this.playAnimationIfReady();
            }
         }
      }
      
      private function introAnimationComplete(param1:IAction) : void
      {
         param1.invoke();
      }
      
      private function onCloseButtonClicked(param1:MouseEvent) : void
      {
         getStateAnimation("intro").getCompleted().remove(this.introAnimationComplete);
         getStateAnimation("out").getCompleted().add(this.outroAnimationComplete);
         setCurrentState("out");
      }
      
      private function outroAnimationComplete(param1:IAction) : void
      {
         getStateAnimation("out").getCompleted().remove(this.outroAnimationComplete);
         setSoundTransform(new SoundTransform(0));
         this.dialogueDismissed.dispatch(this,this.model);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         return this.assetRect;
      }
   }
}

