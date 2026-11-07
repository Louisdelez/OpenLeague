package com.riotgames.pvpnet.cap.views.popups
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.LabelButtonX;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.components.sprites.PieClockSpriteProxy;
   import com.riotgames.pvpnet.cap.controllers.CapController;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CapSoloGroupFoundPopup extends SpriteProxy
   {
      
      private var _acceptClicked:Signal = new Signal();
      
      private var declineButton:LabelButtonX;
      
      private var acceptButton:LabelButtonX;
      
      private var controller:CapController;
      
      private var pieTimerDisplay:PieClockSpriteProxy;
      
      private var text:TextFieldProxy;
      
      private var model:CapModel;
      
      private var _declineClicked:Signal = new Signal();
      
      public function CapSoloGroupFoundPopup(param1:IContext, param2:Sprite = null)
      {
         super(param1,param2);
         setLinkage("CapSoloGroupFoundPopup");
      }
      
      private function onAFKTimeChange() : void
      {
         var _loc1_:Number = this.model.soloAFKStartTime;
         var _loc2_:Number = this.model.soloAFKTimeRemaining;
         var _loc3_:Number = (_loc1_ - _loc2_) / _loc1_;
         this.pieTimerDisplay.percentComplete = _loc3_;
      }
      
      public function getAcceptClicked() : ISignal
      {
         return this._acceptClicked;
      }
      
      public function getDeclineClicked() : ISignal
      {
         return this._declineClicked;
      }
      
      private function onAcceptButtonClicked(param1:MouseEvent) : void
      {
         this._acceptClicked.dispatch(this);
      }
      
      override protected function initializeDependencies() : void
      {
         this.controller = getDependency(CapController);
         this.model = getDependency(CapModel);
         this.model.soloAFKTimeRemainingChanged.add(this.onAFKTimeChange);
      }
      
      override protected function createChildren() : void
      {
         this.pieTimerDisplay = new PieClockSpriteProxy(this);
         setTimelineChildByName("pieClockContainer",this.pieTimerDisplay);
         this.text = new TextFieldProxy(this);
         setTimelineChildByName("textArea",this.text);
         this.text.setText(CapLocaleUtil.getResourceString("gf_dialog_solo_group_found_title","Group Found!"));
         this.acceptButton = new LabelButtonX(this);
         setTimelineChildByName("acceptBtn",this.acceptButton);
         this.acceptButton.addEventListener(MouseEvent.CLICK,this.onAcceptButtonClicked);
         this.acceptButton.setText(CapLocaleUtil.getResourceString("gf_dialog_solo_group_found_accept_button_label","**Join Group"));
         this.declineButton = new LabelButtonX(this);
         setTimelineChildByName("declineBtn",this.declineButton);
         this.declineButton.setText(CapLocaleUtil.getResourceString("gf_dialog_solo_group_found_decline_button_label","**Quit"));
         this.declineButton.addEventListener(MouseEvent.CLICK,this.onDeclineButtonClicked);
         this.declineButton.setVisible(true);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.acceptButton.removeEventListener(MouseEvent.CLICK,this.onDeclineButtonClicked);
         this.declineButton.removeEventListener(MouseEvent.CLICK,this.onAcceptButtonClicked);
         this._acceptClicked.removeAll();
         this._declineClicked.removeAll();
         this.model.soloAFKTimeRemainingChanged.remove(this.onAFKTimeChange);
         this.pieTimerDisplay.destroy();
      }
      
      private function onDeclineButtonClicked(param1:MouseEvent) : void
      {
         this._declineClicked.dispatch(this);
      }
   }
}

