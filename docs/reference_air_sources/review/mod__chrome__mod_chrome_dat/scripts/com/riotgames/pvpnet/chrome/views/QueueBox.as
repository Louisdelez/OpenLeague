package com.riotgames.pvpnet.chrome.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.assignToolTip;
   import blix.components.tooltip.unassignToolTip;
   import blix.context.IContext;
   import blix.frame.getEnterFrame;
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.gameclient.domain.game.CapModuleInfo;
   import com.riotgames.pvpnet.chrome.ChromeController;
   import com.riotgames.pvpnet.chrome.model.ChromeGameState;
   import com.riotgames.pvpnet.chrome.model.ChromeModel;
   import com.riotgames.pvpnet.component.AudioButton;
   import flash.events.MouseEvent;
   import mx.resources.ResourceManager;
   
   public class QueueBox extends StatefulView
   {
      
      private var homeButton:AudioButton;
      
      private var cancelButton:AudioButton;
      
      private var statusText1:TextFieldProxy;
      
      private var statusText2:TextFieldProxy;
      
      private var statusText3:TextFieldProxy;
      
      private var progressBar:SpriteProxy;
      
      private var model:ChromeModel;
      
      public function QueueBox(param1:IContext)
      {
         super(param1);
         this.model = getDependency(ChromeModel);
         this.model.gameStateChanged.add(this.onGameStateChanged);
         this.model.queueBoxHomeButtonIsHiddenChanged.add(this.onGameScreenChanged);
         this.onGameStateChanged();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.homeButton = new AudioButton(this,null,AudioKeys.SOUND_TOP_NAV_BUTTON_CLICK);
         setTimelineChildByName("homeButton",this.homeButton);
         this.homeButton.addEventListener(MouseEvent.CLICK,this.onHomeClicked);
         this.cancelButton = new AudioButton(this,null,AudioKeys.SOUND_TOP_NAV_BUTTON_CLICK);
         setTimelineChildByName("cancelButton",this.cancelButton);
         assignToolTip(this.cancelButton,ResourceManager.getInstance().getString("resources","navigator_cancelGame_tooltip"));
         this.cancelButton.addEventListener(MouseEvent.CLICK,this.onCancelClicked);
         this.statusText1 = new TextFieldProxy(this);
         setTimelineChildByName("statusText1",this.statusText1);
         this.statusText2 = new TextFieldProxy(this);
         setTimelineChildByName("statusText2",this.statusText2);
         this.statusText3 = new TextFieldProxy(this);
         setTimelineChildByName("statusText3",this.statusText3);
         this.progressBar = new SpriteProxy(this);
         setTimelineChildByName("progressBar",this.progressBar);
         getEnterFrame().add(this.onEnterFrame);
      }
      
      private function onEnterFrame() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(this.model.gameState == ChromeGameState.CUSTOM_GAME)
         {
            this.statusText2.setText(this.controller.practiceGameTimerString);
         }
         else if(this.model.gameState == ChromeGameState.SPECTATING)
         {
            this.statusText2.setText(this.controller.spectatorDelayTimerString);
         }
         else if(this.model.gameState == ChromeGameState.MATCHING)
         {
            _loc1_ = ResourceManager.getInstance().getString("resources","lobbyRibbon_Approx");
            _loc2_ = this.controller.queueManagerWaitTimeStr;
            _loc3_ = ResourceManager.getInstance().getString("resources","lobbyRibbon_Actual");
            _loc4_ = this.controller.queueManagerActualWaitTimeStr;
            this.statusText3.setText(_loc1_ + " " + _loc2_ + "\n" + _loc3_ + " " + _loc4_);
         }
         else if(this.model.gameState == ChromeGameState.CAP)
         {
            this.statusText2.setText(CapModuleInfo.instance.lobbyTimeRemaining);
         }
      }
      
      private function onGameStateChanged() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         switch(this.model.gameState)
         {
            case ChromeGameState.ARRANGING:
               setCurrentState("arranging");
               assignToolTip(this.homeButton,ResourceManager.getInstance().getString("resources","navigator_arrangedTeam_home_tooltip"));
               this.statusText1.setText(ResourceManager.getInstance().getString("resources","lobbyRibbon_Arranging"));
               this.statusText2.setVisible(false);
               this.statusText3.setVisible(false);
               break;
            case ChromeGameState.MATCHING:
               setCurrentState("matchmaking");
               _loc1_ = this.controller.isCapMode ? "lobbyRibbon_SearchingForGroup" : "lobbyRibbon_InQueue";
               _loc2_ = ResourceManager.getInstance().getString("resources",_loc1_);
               _loc3_ = "qqq";
               this.statusText1.setText(_loc2_ + " " + this.controller.getSelectedGameQueueConfigName());
               this.statusText2.setVisible(false);
               this.statusText3.setVisible(true);
               break;
            case ChromeGameState.SPECTATING:
               setCurrentState("spectating");
               this.statusText1.setText(ResourceManager.getInstance().getString("resources","lobbyRibbon_SpectatingLabel"));
               this.statusText2.setVisible(true);
               this.statusText3.setVisible(false);
               break;
            case ChromeGameState.CUSTOM_GAME:
               setCurrentState("custom");
               assignToolTip(this.homeButton,ResourceManager.getInstance().getString("resources","navigator_customGame_home_tooltip"));
               this.statusText1.setText(ResourceManager.getInstance().getString("resources","lobbyRibbon_ArrangingCustom"));
               this.statusText2.setVisible(true);
               this.statusText3.setVisible(false);
               break;
            case ChromeGameState.CAP:
               setCurrentState("cap");
               assignToolTip(this.homeButton,ResourceManager.getInstance().getString("resources","navigator_capGame_home_tooltip"));
               this.statusText1.setText(ResourceManager.getInstance().getString("resources","lobbyRibbon_Cap"));
               this.statusText2.setVisible(true);
               this.statusText3.setVisible(false);
               break;
            default:
               setCurrentState("none");
         }
      }
      
      private function onGameScreenChanged() : void
      {
         this.homeButton.setVisible(!this.model.queueBoxHomeButtonIsHidden);
      }
      
      private function get controller() : ChromeController
      {
         return getDependency(ChromeController);
      }
      
      private function onHomeClicked(param1:MouseEvent) : void
      {
         this.controller.backToGame();
      }
      
      private function onCancelClicked(param1:MouseEvent) : void
      {
         this.controller.cancelGame();
      }
      
      override public function destroy() : void
      {
         unassignToolTip(this.cancelButton);
         unassignToolTip(this.homeButton);
         this.model.gameStateChanged.remove(this.onGameStateChanged);
         this.model.queueBoxHomeButtonIsHiddenChanged.remove(this.onGameScreenChanged);
         this.model = null;
         super.destroy();
      }
   }
}

