package com.riotgames.pvpnet.celebration.views
{
   import blix.action.IAction;
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.LabelButtonX;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.common.provider.SoundProviderProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.buddyImages.BuddyImages;
   import com.riotgames.platform.gameclient.domain.celebration.SimpleDialogMessage;
   import com.riotgames.pvpnet.celebration.ClientModuleCelebration;
   import com.riotgames.pvpnet.celebration.enums.CelebrationConstants;
   import com.riotgames.pvpnet.celebration.model.SummonerIconRoleMapping;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.media.SoundTransform;
   
   public class SummonerIconCeremonyDialogue extends StatefulView implements ICelebrationDialog
   {
      
      private static var SUMMONER_ICON_SIZE:int = 128;
      
      private var _dialogDismissed:Signal = new Signal();
      
      private var _simpleDialogMessage:SimpleDialogMessage;
      
      private var okButton:LabelButtonX;
      
      private var titleTextField:TextFieldProxy;
      
      private var bodyTextField:TextFieldProxy;
      
      private var _summonerIconParent:SpriteProxy;
      
      private var _summonerIconContainer:SpriteProxy;
      
      private var _summonerIconBitmap:BitmapProxy;
      
      public function SummonerIconCeremonyDialogue(param1:IContext)
      {
         super(param1);
         getAssetChanged().add(this.handleAssetChanged);
         setCurrentState("default");
         setLinkage("SummonerIconCeremonyDialogue");
         setTransitionsEnabled(UserPreferencesManager.userPrefs.enableAnimations);
         this.startAnimation();
      }
      
      override protected function createChildren() : void
      {
         this.titleTextField = new TextFieldProxy(this);
         setTimelineChildByName("infoBox.titleText",this.titleTextField);
         this.bodyTextField = new TextFieldProxy(this);
         setTimelineChildByName("infoBox.customMessage",this.bodyTextField);
         this.bodyTextField.setText("");
         this.okButton = new LabelButtonX(this);
         setTimelineChildByName("infoBox.closeButton",this.okButton);
         this.okButton.addEventListener(MouseEvent.CLICK,this.onCloseButtonClicked);
         this.okButton.setText(RiotResourceLoader.getResourceString(ClientModuleCelebration.CELEBRATION_RESOURCE_ID,CelebrationConstants.GIFT_RECEIVED_BUTTON,"##Awesome!"));
         this._summonerIconParent = new SpriteProxy(this);
         setTimelineChildByName("summonerIconParent",this._summonerIconParent);
         this._summonerIconContainer = new SpriteProxy(this);
         this._summonerIconParent.setTimelineChildByName("iconContainer",this._summonerIconContainer);
         this._summonerIconBitmap = new BitmapProxy(this);
         var _loc1_:ScalingTransformBehavior = new ScalingTransformBehavior();
         _loc1_.setMaintainAspectRatio(true);
         this._summonerIconBitmap.setTransformBehavior(_loc1_);
         this._summonerIconBitmap.setSmoothing(true);
         this._summonerIconContainer.addChild(this._summonerIconBitmap);
         getStateAnimation("intro").setRepeatCount(-1);
         super.createChildren();
      }
      
      public function setModel(param1:SimpleDialogMessage, param2:String) : void
      {
         var _loc4_:BitmapData = null;
         var _loc6_:String = null;
         if(this._simpleDialogMessage != param1)
         {
            this._simpleDialogMessage = param1;
         }
         if(Boolean(this._simpleDialogMessage) && Boolean(Session.instance.summoner))
         {
            this.titleTextField.setText(RiotResourceLoader.getResourceString(ClientModuleCelebration.CELEBRATION_RESOURCE_ID,"summoner_icon_ceremony_title","##Congrats!",[Session.instance.summoner.name]));
         }
         var _loc3_:int = -1;
         if(param1.params[0])
         {
            _loc6_ = param1.params[0];
            if(SummonerIconRoleMapping[_loc6_])
            {
               _loc3_ = int(SummonerIconRoleMapping[_loc6_]);
            }
         }
         if(_loc3_ == -1)
         {
            return;
         }
         _loc4_ = BuddyImages.getSummonerIconSafely(_loc3_);
         this._summonerIconBitmap.setBitmapData(_loc4_);
         var _loc5_:String = RiotResourceLoader.getResourceString(ClientModuleCelebration.CELEBRATION_RESOURCE_ID,"role_icon_" + String(param1.params[0]).toLowerCase(),"##Icon Name");
         this.bodyTextField.setText(RiotResourceLoader.getResourceString(ClientModuleCelebration.CELEBRATION_RESOURCE_ID,"summoner_icom_ceremony_body","##Show off your new summoner icon!",[_loc5_]));
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
         this._dialogDismissed.dispatch(this,this._simpleDialogMessage);
      }
      
      public function getDialogDismissed() : ISignal
      {
         return this._dialogDismissed;
      }
      
      private function dismissDialog() : void
      {
         this._dialogDismissed.dispatch(this,this._simpleDialogMessage);
      }
      
      override public function destroy() : void
      {
         this._dialogDismissed.removeAll();
         this.okButton.removeEventListener(MouseEvent.CLICK,this.onCloseButtonClicked);
         super.destroy();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._summonerIconBitmap.setExplicitSize(SUMMONER_ICON_SIZE,SUMMONER_ICON_SIZE);
         return new Rectangle(-700,-410,820,446);
      }
   }
}

