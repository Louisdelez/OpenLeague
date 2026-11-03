package com.riotgames.pvpnet.celebration.views
{
   import blix.action.IAction;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.LabelButtonX;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.provider.SoundProviderProxy;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.celebration.SimpleDialogMessage;
   import com.riotgames.pvpnet.celebration.ClientModuleCelebration;
   import com.riotgames.pvpnet.celebration.enums.CelebrationConstants;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.pvpnet.system.wordfilter.WordFilter;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.media.SoundTransform;
   
   public class CelebrationDialog extends StatefulView implements ICelebrationDialog
   {
      
      public static const GIFT_CELEBRATION:int = 1;
      
      private var okButton:LabelButtonX;
      
      private var titleTextField:TextFieldProxy;
      
      private var bodyTextField:TextFieldProxy;
      
      private var giftTextField:TextFieldProxy;
      
      private var customMessageTextField:TextFieldProxy;
      
      private var dialogueDismissed:Signal = new Signal();
      
      private var model:SimpleDialogMessage;
      
      public function CelebrationDialog(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         setCurrentState("default");
         getAssetChanged().add(this.handleAssetChanged);
         setLinkage("CelebrationDialogue");
         setTransitionsEnabled(UserPreferencesManager.userPrefs.enableAnimations);
         this.startAnimation();
      }
      
      override protected function createChildren() : void
      {
         this.titleTextField = new TextFieldProxy(this);
         setTimelineChildByName("infoBox.titleText",this.titleTextField);
         this.bodyTextField = new TextFieldProxy(this);
         setTimelineChildByName("infoBox.bodyText",this.bodyTextField);
         this.giftTextField = new TextFieldProxy(this);
         setTimelineChildByName("infoBox.giftText",this.giftTextField);
         this.customMessageTextField = new TextFieldProxy(this);
         setTimelineChildByName("infoBox.customMessage",this.customMessageTextField);
         this.okButton = new LabelButtonX(this);
         setTimelineChildByName("infoBox.closeButton",this.okButton);
         this.okButton.addEventListener(MouseEvent.CLICK,this.onCloseButtonClicked);
         this.okButton.setText(RiotResourceLoader.getResourceString(ClientModuleCelebration.CELEBRATION_RESOURCE_ID,CelebrationConstants.GIFT_RECEIVED_BUTTON,"##Awesome!"));
         getStateAnimation("intro").setRepeatCount(-1);
      }
      
      override public function destroy() : void
      {
         this.dialogueDismissed.removeAll();
         this.okButton.removeEventListener(MouseEvent.CLICK,this.onCloseButtonClicked);
         super.destroy();
      }
      
      public function setModel(param1:SimpleDialogMessage, param2:String) : void
      {
         var _loc3_:String = null;
         if(this.model != param1)
         {
            this.model = param1;
         }
         if(this.model)
         {
            this.titleTextField.setText(RiotResourceLoader.getResourceString(ClientModuleCelebration.CELEBRATION_RESOURCE_ID,this.model.titleCode,"##Congrats!"));
            this.bodyTextField.setText(RiotResourceLoader.getResourceString(ClientModuleCelebration.CELEBRATION_RESOURCE_ID,this.model.bodyCode,"##You got a gift!",[this.model.params[1]]));
            this.giftTextField.setText(param2);
            if(this.model.params[2] == "")
            {
               this.customMessageTextField.setText("");
            }
            else
            {
               _loc3_ = WordFilter.instance.maskOffensiveWords(this.model.params[2]);
               this.customMessageTextField.setText(RiotResourceLoader.getResourceString(ClientModuleCelebration.CELEBRATION_RESOURCE_ID,CelebrationConstants.GIFT_RECEIVED_CUSTOM_MESSAGE,"##{0} -{1}",[_loc3_,this.model.params[1]]));
            }
         }
      }
      
      public function getDialogDismissed() : ISignal
      {
         return this.dialogueDismissed;
      }
      
      private function startAnimation() : void
      {
         setCurrentState("default");
         setCurrentState("intro");
      }
      
      private function handleAssetChanged(param1:StatefulView, param2:MovieClip, param3:MovieClip) : void
      {
         if(param3)
         {
            SoundProviderProxy.instance.applyVolumeToMovieClip(param3);
         }
      }
      
      private function onCloseButtonClicked(param1:MouseEvent) : void
      {
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
         return new Rectangle(-700,-368,820,446);
      }
   }
}

