package com.riotgames.pvpnet.cap.views.components
{
   import blix.components.button.LabelButtonX;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.pvpnet.cap.controllers.ICapController;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class CapButtonsFooterComponent extends StatefulView implements ICapButtonsFooterComponent
   {
      
      private var _quitButtonClicked:Signal = new Signal();
      
      private var actionButton:CapActionButton;
      
      private var _actionButtonClicked:Signal = new Signal();
      
      private var quitButton:LabelButtonX;
      
      private var findAnotherGroupButton:LabelButtonX;
      
      private var _model:CapModel;
      
      private var _controller:ICapController;
      
      public function CapButtonsFooterComponent(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
      }
      
      public function showSoloView() : void
      {
         setCurrentState("solo");
      }
      
      public function setActionButtonMouseEnabled(param1:Boolean) : void
      {
         this.actionButton.setMouseEnabled(param1);
      }
      
      public function setActionButtonLabel(param1:String) : void
      {
         this.actionButton.setText(param1);
      }
      
      private function handleActionButtonClick(param1:MouseEvent) : void
      {
         this._actionButtonClicked.dispatch(this.actionButton);
      }
      
      public function setQuitButtonVisible(param1:Boolean) : void
      {
         this.quitButton.setVisible(param1);
      }
      
      public function setActionButtonEnabled(param1:Boolean) : void
      {
         this.actionButton.setEnabled(param1);
      }
      
      public function showTeamViewForInvitee() : void
      {
         setCurrentState("invitee");
      }
      
      override protected function createChildren() : void
      {
         this.actionButton = new CapActionButton(this);
         this.actionButton.addEventListener(MouseEvent.CLICK,this.handleActionButtonClick);
         setTimelineChildByName("actionButton",this.actionButton);
         this.actionButton.setText("");
         this.quitButton = new LabelButtonX(this);
         this.quitButton.addEventListener(MouseEvent.CLICK,this.handleQuitButtonClick);
         setTimelineChildByName("quitButton",this.quitButton);
         this.quitButton.setText(CapLocaleUtil.getResourceString("gf_button_quit_game_label","Quit Game"));
         this.findAnotherGroupButton = new LabelButtonX(this);
         this.findAnotherGroupButton.addEventListener(MouseEvent.CLICK,this.handleFindAnotherGroupClick);
         setTimelineChildByName("findAnotherGroupButton",this.findAnotherGroupButton);
         this.findAnotherGroupButton.setText(CapLocaleUtil.getResourceString("gf_button_find_another_group_label","Find Another Group"));
      }
      
      public function showTeamViewForCaptain() : void
      {
         setCurrentState("captain");
      }
      
      public function setFindAnotherGroupButtonVisible(param1:Boolean) : void
      {
         this.findAnotherGroupButton.setVisible(param1);
      }
      
      public function setActionButtonReadyState(param1:uint) : void
      {
         this.actionButton.setReadyState(param1);
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this._controller = getDependency(ICapController);
         this._model = getDependency(CapModel);
         this._model.quitEnabledChanged.add(this.handleQuitEnabledChanged);
      }
      
      private function handleQuitButtonClick(param1:MouseEvent) : void
      {
         this._quitButtonClicked.dispatch(this.quitButton);
      }
      
      public function get quitButtonClicked() : ISignal
      {
         return this._quitButtonClicked;
      }
      
      public function showTeamViewForSolo() : void
      {
         setCurrentState("solo_in_group");
      }
      
      override public function destroy() : void
      {
         this._model.quitEnabledChanged.remove(this.handleQuitEnabledChanged);
         this.quitButton.destroy();
         this.actionButton.destroy();
         this.findAnotherGroupButton.removeEventListener(MouseEvent.CLICK,this.handleFindAnotherGroupClick);
         this.findAnotherGroupButton.destroy();
         this._quitButtonClicked.removeAll();
         this._actionButtonClicked.removeAll();
         super.destroy();
      }
      
      private function handleQuitEnabledChanged() : void
      {
         this.quitButton.setVisible(this._model.quitEnabled);
      }
      
      private function handleFindAnotherGroupClick(param1:MouseEvent) : void
      {
         this.findAnotherGroupButton.setVisible(false);
         this._controller.searchForAnotherGroup();
      }
      
      public function setActionButtonVisible(param1:Boolean) : void
      {
         this.actionButton.setVisible(param1);
      }
      
      public function get actionButtonClicked() : ISignal
      {
         return this._actionButtonClicked;
      }
   }
}

