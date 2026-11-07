package com.riotgames.platform.gameclient.kudos
{
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.IToolTipManager;
   import blix.components.tooltip.ToolTip;
   import blix.components.tooltip.ToolTipHandler;
   import blix.components.tooltip.ToolTipManager;
   import blix.components.tooltip.assignToolTip;
   import blix.context.IContext;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import flash.display.MovieClip;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   
   [Event(name="teamworkButtonClicked",type="com.riotgames.platform.gameclient.kudos.KudosDialogFriendlyTeamViewEventt")]
   [Event(name="helpfulButtonClicked",type="com.riotgames.platform.gameclient.kudos.KudosDialogFriendlyTeamViewEvent")]
   [Event(name="friendlyButtonClicked",type="com.riotgames.platform.gameclient.kudos.KudosDialogFriendlyTeamViewEvent")]
   [Event(name="cancelButtonClicked",type="com.riotgames.platform.gameclient.kudos.KudosDialogFriendlyTeamViewEvent")]
   public class KudosDialogFriendlyTeamView extends StatefulView
   {
      
      public var teamworkButton:ButtonX;
      
      private var teamworkButtonEventDispatcher:IEventDispatcher;
      
      public var summonerNameText:TextFieldProxy;
      
      public var cancelButton:ButtonX;
      
      public var helpfulTextField:TextFieldProxy;
      
      private var helpfulButtonEventDispatcher:IEventDispatcher;
      
      public var currentBackground:MovieClipProxy;
      
      public var friendlyTextField:TextFieldProxy;
      
      private var friendlyButtonEventDispatcher:IEventDispatcher;
      
      private var defaultTooltipHandler:ToolTipHandler;
      
      public var helpfulButton:ButtonX;
      
      private var cancelButtonEventDispatcher:IEventDispatcher;
      
      public var friendlyButton:ButtonX;
      
      public var teamworkTextField:TextFieldProxy;
      
      public function KudosDialogFriendlyTeamView(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         setLinkage("kudos.KudosDialog");
      }
      
      override public function destroy() : void
      {
      }
      
      override protected function createChildren() : void
      {
         this.createBlixAssets();
         this.cancelButtonEventDispatcher = this.cancelButton;
         this.friendlyButtonEventDispatcher = this.friendlyButton;
         this.helpfulButtonEventDispatcher = this.helpfulButton;
         this.teamworkButtonEventDispatcher = this.teamworkButton;
         setTimelineChildByName("animationContainer.cancelButton",this.cancelButton);
         setTimelineChildByName("animationContainer.friendlyButton",this.friendlyButton);
         setTimelineChildByName("animationContainer.helpfulButton",this.helpfulButton);
         setTimelineChildByName("animationContainer.teamworkButton",this.teamworkButton);
         setTimelineChildByName("animationContainer.background",this.currentBackground);
         setTimelineChildByName("animationContainer.summonerName_txt",this.summonerNameText);
         setTimelineChildByName("animationContainer.friendlyButton.friendly_txt_mc.friendly_txt",this.friendlyTextField);
         setTimelineChildByName("animationContainer.helpfulButton.helpful_txt_mc.helpful_txt",this.helpfulTextField);
         setTimelineChildByName("animationContainer.teamworkButton.teamwork_txt_mc.teamwork_txt",this.teamworkTextField);
         this.friendlyTextField.setAutoSize(TextFieldAutoSize.CENTER);
         this.helpfulTextField.setAutoSize(TextFieldAutoSize.CENTER);
         this.teamworkTextField.setAutoSize(TextFieldAutoSize.CENTER);
         assignToolTip(this.friendlyButton,RiotResourceLoader.getString("kudosEndOfGameFriendlyTooltip"));
         assignToolTip(this.helpfulButton,RiotResourceLoader.getString("kudosEndOfGameHelpfulTooltip"));
         assignToolTip(this.teamworkButton,RiotResourceLoader.getString("kudosEndOfGameTeamworkTooltip"));
         this.addClickHandlers();
         var _loc1_:ToolTip = new ToolTip(this);
         _loc1_.setLinkage("assets.ToolTipAsset");
         this.defaultTooltipHandler.setView(_loc1_);
         this.defaultTooltipHandler.showDelay = 0;
      }
      
      private function onCancelButtonClick(param1:MouseEvent) : void
      {
         dispatchEvent(new KudosDialogFriendlyTeamViewEvent(KudosDialogFriendlyTeamViewEvent.CANCEL_BUTTON_CLICKED));
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this.defaultTooltipHandler = new ToolTipHandler();
         var _loc1_:ToolTipManager = new ToolTipManager(this,this.defaultTooltipHandler);
         registerDependency(IToolTipManager,_loc1_,false);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this.friendlyTextField.setY((this.friendlyButton.getHeight() - this.friendlyTextField.getTextHeight()) / 2);
         this.helpfulTextField.setY((this.helpfulButton.getHeight() - this.helpfulTextField.getTextHeight()) / 2);
         this.teamworkTextField.setY((this.teamworkButton.getHeight() - this.teamworkTextField.getTextHeight()) / 2);
         return super.updateLayout(param1,param2);
      }
      
      private function onTeamworkButtonClick(param1:MouseEvent) : void
      {
         dispatchEvent(new KudosDialogFriendlyTeamViewEvent(KudosDialogFriendlyTeamViewEvent.TEAMWORK_BUTTON_CLICKED));
      }
      
      private function onFriendlyButtonClick(param1:MouseEvent) : void
      {
         dispatchEvent(new KudosDialogFriendlyTeamViewEvent(KudosDialogFriendlyTeamViewEvent.FRIENDLY_BUTTON_CLICKED));
      }
      
      public function resetState() : void
      {
         setCurrentState("default");
         if(UserPreferencesManager.userPrefs.enableAnimations)
         {
            setCurrentState("intro");
         }
      }
      
      private function addClickHandlers() : void
      {
         this.cancelButtonEventDispatcher.addEventListener(MouseEvent.CLICK,this.onCancelButtonClick);
         this.friendlyButtonEventDispatcher.addEventListener(MouseEvent.CLICK,this.onFriendlyButtonClick);
         this.helpfulButtonEventDispatcher.addEventListener(MouseEvent.CLICK,this.onHelpfulButtonClick);
         this.teamworkButtonEventDispatcher.addEventListener(MouseEvent.CLICK,this.onTeamworkButtonClick);
      }
      
      protected function createBlixAssets() : void
      {
         this.cancelButton = new ButtonX(this);
         this.friendlyButton = new ButtonX(this);
         this.helpfulButton = new ButtonX(this);
         this.teamworkButton = new ButtonX(this);
         this.currentBackground = new MovieClipProxy(this);
         this.summonerNameText = new TextFieldProxy(this);
         this.friendlyTextField = new TextFieldProxy(this);
         this.helpfulTextField = new TextFieldProxy(this);
         this.teamworkTextField = new TextFieldProxy(this);
      }
      
      private function onHelpfulButtonClick(param1:MouseEvent) : void
      {
         dispatchEvent(new KudosDialogFriendlyTeamViewEvent(KudosDialogFriendlyTeamViewEvent.HELPFUL_BUTTON_CLICKED));
      }
      
      public function setSummonerName(param1:String) : void
      {
         if(!param1)
         {
            this.summonerNameText.setText("");
            return;
         }
         this.summonerNameText.setText(param1);
      }
   }
}

