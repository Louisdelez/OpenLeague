package com.riotgames.platform.gameclient.kudos
{
   import blix.action.IAction;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.platform.common.provider.SoundProviderProxy;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.kudos.actions.ShowKudosDialogAction;
   import com.riotgames.platform.gameclient.views.game.common.ICancelableDialog;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.rust.context.RustContext;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.media.SoundTransform;
   import mx.core.Container;
   import mx.core.UIComponent;
   
   public class KudosBadgeDialog extends Container implements ICancelableDialog
   {
      
      public static const DEFAULT_BADGE_DIALOGUE_DELAY:int = 5000;
      
      public static const LEADSHIP_BADGE:int = 1;
      
      public static const MENTOR_BADGE:int = 2;
      
      public static const TEAMWORK_BADGE:int = 3;
      
      public static const HONORABLE_OPPONENT_BADGE:int = 4;
      
      private var container:UIComponent;
      
      private var titleText:TextFieldProxy;
      
      private var linkText:TextFieldProxy;
      
      private var badgeDialog:StatefulView;
      
      private var cancelButton:ButtonX;
      
      private var bodyText:TextFieldProxy;
      
      private var alertAction:ShowKudosDialogAction;
      
      private var flexWrapper:SpriteProxy;
      
      private var parentContext:IContext;
      
      public function KudosBadgeDialog(param1:RustContext, param2:int)
      {
         super();
         this.parentContext = param1;
         this.clipContent = false;
         this.container = new UIComponent();
         addChild(this.container);
         this.badgeDialog = new StatefulView(param1);
         this.badgeDialog.getAssetChanged().add(this.onDialogueAssetChanged);
         this.badgeDialog.setCurrentState("default");
         this.flexWrapper = new SpriteProxy(param1,this.container);
         this.flexWrapper.addChild(this.badgeDialog);
         this.cancelButton = new ButtonX(this.badgeDialog);
         this.badgeDialog.setTimelineChildByName("infoBox.closeButton",this.cancelButton);
         this.cancelButton.addEventListener(MouseEvent.CLICK,this.onCloseButtonClicked);
         this.titleText = new TextFieldProxy(this.badgeDialog);
         this.badgeDialog.setTimelineChildByName("infoBox.titleText",this.titleText);
         this.titleText.setText(RiotResourceLoader.getString("kudosBadgeDialogTitle"));
         this.bodyText = new TextFieldProxy(this.badgeDialog);
         this.badgeDialog.setTimelineChildByName("infoBox.bodyText",this.bodyText);
         switch(param2)
         {
            case LEADSHIP_BADGE:
               this.bodyText.setText(RiotResourceLoader.getString("kudosBadgeDialogLeader"));
               break;
            case MENTOR_BADGE:
               this.bodyText.setText(RiotResourceLoader.getString("kudosBadgeDialogMentor"));
               break;
            case TEAMWORK_BADGE:
               this.bodyText.setText(RiotResourceLoader.getString("kudosBadgeDialogTeammate"));
               break;
            case HONORABLE_OPPONENT_BADGE:
               this.bodyText.setText(RiotResourceLoader.getString("kudosBadgeDialogHonorable"));
         }
         this.linkText = new TextFieldProxy(this.badgeDialog);
         this.badgeDialog.setTimelineChildByName("infoBox.linkText",this.linkText);
         this.linkText.setHtmlText(RiotResourceLoader.getString("kudosBadgeDialogLink"));
         this.badgeDialog.setTransitionsEnabled(UserPreferencesManager.userPrefs.enableAnimations);
         this.badgeDialog.setLinkage("kudos.CeremonyBadge" + param2);
         this.badgeDialog.setCurrentState("default");
         this.badgeDialog.getStateAnimation("intro").setRepeatCount(-1);
      }
      
      private function onCloseButtonClicked(param1:MouseEvent) : void
      {
         this.badgeDialog.getStateAnimation("out").getCompleted().add(this.outroAnimationComplete);
         this.badgeDialog.setCurrentState("out");
      }
      
      public function display() : void
      {
         this.alertAction = new ShowKudosDialogAction(this.parentContext);
         this.alertAction.add(this,this.badgeDialog);
         this.badgeDialog.setCurrentState("intro");
      }
      
      private function outroAnimationComplete(param1:IAction) : void
      {
         this.badgeDialog.getStateAnimation("out").getCompleted().remove(this.outroAnimationComplete);
         this.cancel();
      }
      
      private function onDialogueAssetChanged(param1:StatefulView, param2:MovieClip, param3:MovieClip) : void
      {
         if(Boolean(param3))
         {
            SoundProviderProxy.instance.applyVolumeToMovieClip(param3);
         }
      }
      
      public function cancel() : void
      {
         this.alertAction.complete();
         this.badgeDialog.setSoundTransform(new SoundTransform(0));
         this.cancelButton.removeEventListener(MouseEvent.CLICK,this.onCloseButtonClicked);
         this.badgeDialog.destroy();
      }
   }
}

