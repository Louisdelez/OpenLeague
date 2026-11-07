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
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   
   public class KudosDialogEnemyView extends StatefulView
   {
      
      private var summonerNameText:TextFieldProxy;
      
      public var cancelButton:ButtonX;
      
      private var honorableButton:ButtonX;
      
      private var defaultTooltipHandler:ToolTipHandler;
      
      private var honorableTextField:TextFieldProxy;
      
      public var honorableButtonEventDispatcher:IEventDispatcher;
      
      private var background:MovieClipProxy;
      
      public var cancelButtonEventDispatcher:IEventDispatcher;
      
      public function KudosDialogEnemyView(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         setLinkage("kudos.EnemyKudosDialog");
      }
      
      public function resetState() : void
      {
         setCurrentState("default");
         if(UserPreferencesManager.userPrefs.enableAnimations)
         {
            setCurrentState("intro");
         }
      }
      
      private function onHonorableButtonClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event("honorableButtonClicked"));
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this.honorableTextField.setY((this.honorableButton.getHeight() - this.honorableTextField.getTextHeight()) / 2);
         return super.updateLayout(param1,param2);
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this.defaultTooltipHandler = new ToolTipHandler();
         var _loc1_:ToolTipManager = new ToolTipManager(this,this.defaultTooltipHandler);
         registerDependency(IToolTipManager,_loc1_,false);
      }
      
      override protected function createChildren() : void
      {
         this.cancelButton = new ButtonX(this);
         this.cancelButtonEventDispatcher = this.cancelButton;
         this.honorableButton = new ButtonX(this);
         this.honorableButtonEventDispatcher = this.honorableButton;
         this.background = new MovieClipProxy(this);
         this.summonerNameText = new TextFieldProxy(this);
         this.honorableTextField = new TextFieldProxy(this);
         setTimelineChildByName("animationContainer.background",this.background);
         setTimelineChildByName("animationContainer.cancelButton",this.cancelButton);
         setTimelineChildByName("animationContainer.honorableButton",this.honorableButton);
         setTimelineChildByName("animationContainer.summonerName_txt",this.summonerNameText);
         setTimelineChildByName("animationContainer.honorableButton.honorable_txt_mc.honorable_txt",this.honorableTextField);
         this.honorableTextField.setAutoSize(TextFieldAutoSize.CENTER);
         assignToolTip(this.honorableButton,RiotResourceLoader.getString("kudosEndOfGameHonorableTooltip"));
         this.addClickHandlers();
         var _loc1_:ToolTip = new ToolTip(this);
         _loc1_.setLinkage("assets.ToolTipAsset");
         this.defaultTooltipHandler.setView(_loc1_);
         this.defaultTooltipHandler.showDelay = 0;
      }
      
      private function addClickHandlers() : void
      {
         this.cancelButtonEventDispatcher.addEventListener(MouseEvent.CLICK,this.onCancelButtonClick);
         this.honorableButtonEventDispatcher.addEventListener(MouseEvent.CLICK,this.onHonorableButtonClick);
      }
      
      override public function destroy() : void
      {
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
      
      private function onCancelButtonClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event("cancelButtonClicked"));
      }
   }
}

