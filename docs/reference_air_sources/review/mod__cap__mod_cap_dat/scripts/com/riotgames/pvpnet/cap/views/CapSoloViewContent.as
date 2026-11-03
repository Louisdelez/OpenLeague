package com.riotgames.pvpnet.cap.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.LabelButtonX;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.layout.LayoutContainerView;
   import blix.layout.algorithms.VerticalLayout;
   import blix.layout.vo.HorizontalAlign;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.pvpnet.cap.controllers.ICapController;
   import com.riotgames.pvpnet.cap.layout.CapMapLayout;
   import com.riotgames.pvpnet.cap.mediators.CapViewMediator;
   import com.riotgames.pvpnet.cap.model.CapEstimatedWaitTime;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.observers.observable.player.PlayerFullySpeccedObserver;
   import com.riotgames.pvpnet.cap.renderers.player.CapLocalPlayerRenderer;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.pvpnet.cap.util.CapModelUtil;
   import com.riotgames.pvpnet.cap.views.components.CapMapPanel;
   import com.riotgames.pvpnet.game.controllers.IMasterGameController;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import flash.events.MouseEvent;
   
   public class CapSoloViewContent extends StatefulView
   {
      
      private static const STATE_NO_DEMAND_BOARD:String = "noDemandBoard";
      
      private static const STATE_DEMAND_BOARD:String = "demandBoard";
      
      private static const STATE_EMPTY:String = "empty";
      
      private static const ACTION_BUTTON_STATE_THINKING:String = "thinking";
      
      private static const ACTION_BUTTON_STATE_UP:String = "up";
      
      private var waitText:TextFieldProxy;
      
      private var waitBackground:SpriteProxy;
      
      private var playReadyObserver:PlayerFullySpeccedObserver;
      
      private var actionButton:LabelButtonX;
      
      private var _masterGameController:IMasterGameController;
      
      private var _soloLocalPlayerComponent:CapLocalPlayerRenderer;
      
      private var _viewMediator:CapViewMediator;
      
      private var _demandBoard:DemandBoardView;
      
      private var _mapView:CapMapPanel;
      
      private var _gameTypeTextField:TextFieldProxy;
      
      private var _model:CapModel;
      
      private var availabilityText:TextFieldProxy;
      
      private var _titleTextField:TextFieldProxy;
      
      private var _controller:ICapController;
      
      private var _layoutContainerView:LayoutContainerView;
      
      public function CapSoloViewContent(param1:IContext, param2:CapModel)
      {
         this._model = param2;
         this._model.currentEstimatedWaitTimeChanged.add(this.handleEstimatedWaitTimeChanged);
         this._model.creatingSoloQueryChanged.add(this.updateActionButton);
         super(param1);
         setCurrentState(STATE_DEMAND_BOARD);
      }
      
      private function updateActionButton() : void
      {
         this.actionButton.setEnabled(this.playReadyObserver.isOccurring && !this._model.creatingSoloQuery);
      }
      
      override public function destroy() : void
      {
         this._model.gameModeChanged.remove(this.renderGameInfo);
         this._model.currentEstimatedWaitTimeChanged.remove(this.handleEstimatedWaitTimeChanged);
         this._model.creatingSoloQueryChanged.remove(this.updateActionButton);
         this._masterGameController.gameModelChanged.remove(this.renderGameInfo);
         if(this.playReadyObserver)
         {
            this.playReadyObserver.destroy();
            this.playReadyObserver = null;
         }
         this._soloLocalPlayerComponent.destroy();
         this.actionButton.destroy();
         this._mapView.destroy();
         this._titleTextField.destroy();
         this._gameTypeTextField.destroy();
         this.availabilityText.destroy();
         this.waitText.destroy();
         this.waitBackground.destroy();
         this._demandBoard.specSelected.remove(this.retrieveEstimatedWaitTime);
         this._demandBoard.destroy();
         super.destroy();
      }
      
      private function renderGameInfo() : void
      {
         var _loc1_:String = this._masterGameController.gameModel != null && Boolean(this._masterGameController.gameModel.gameMap) ? this._masterGameController.gameModel.gameMap.displayName : "";
         var _loc2_:String = RiotResourceLoader.getString("classic_pvp_game_mode_title");
         var _loc3_:Number = CapModelUtil.getAllAvailablePlayerSelections(this._model).length;
         this._titleTextField.setText(_loc1_);
         this._gameTypeTextField.setText(_loc3_ + "v" + _loc3_ + " " + _loc2_);
      }
      
      override protected function initializeDependencies() : void
      {
         this._masterGameController = getDependency(MasterGameController);
         this._masterGameController.gameModelChanged.add(this.renderGameInfo);
         this._viewMediator = getDependency(CapViewMediator);
         this._controller = getDependency(ICapController);
         super.initializeDependencies();
      }
      
      override protected function createChildren() : void
      {
         this.playReadyObserver = new PlayerFullySpeccedObserver(this._model.localPlayerSelection);
         this.playReadyObserver.occurred.add(this.updateActionButton);
         this._layoutContainerView = new LayoutContainerView(this);
         setTimelineChildByName("layoutContainer",this._layoutContainerView);
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.setHorizontalAlign(HorizontalAlign.RIGHT);
         _loc1_.setGap(10);
         this._layoutContainerView.setLayoutAlgorithm(_loc1_);
         this._soloLocalPlayerComponent = new CapLocalPlayerRenderer(this);
         this._soloLocalPlayerComponent.setData(this._model.localPlayerSelection);
         this._layoutContainerView.setTimelineChildByName("captainComponent",this._soloLocalPlayerComponent);
         this._soloLocalPlayerComponent.getChampionSelected().add(this.retrieveEstimatedWaitTime);
         this._soloLocalPlayerComponent.getPositionSelected().add(this.retrieveEstimatedWaitTime);
         this._soloLocalPlayerComponent.getRoleSelected().add(this.retrieveEstimatedWaitTime);
         this._mapView = new CapMapPanel(this);
         this._mapView.setLayoutAlgorithm(new CapMapLayout());
         setTimelineChildByName("mapPanel",this._mapView);
         this._titleTextField = new TextFieldProxy(this);
         setTimelineChildByName("titleTextField",this._titleTextField);
         this._gameTypeTextField = new TextFieldProxy(this);
         setTimelineChildByName("gameTypeTextField",this._gameTypeTextField);
         this._model.gameModeChanged.add(this.renderGameInfo);
         this.renderGameInfo();
         this.actionButton = new LabelButtonX(this);
         this._layoutContainerView.setTimelineChildByName("actionButton",this.actionButton);
         this.actionButton.addEventListener(MouseEvent.CLICK,this.handleActionButtonClicked);
         this.actionButton.setText(CapLocaleUtil.getResourceString("gf_solo_find_group_button_label","Find Group"));
         this.availabilityText = new TextFieldProxy(this);
         this.actionButton.setTimelineChildByName("availabilityText",this.availabilityText);
         this.availabilityText.setText(CapLocaleUtil.getResourceString("gf_solo_availability_title","Availability"));
         this.waitText = new TextFieldProxy(this);
         this.actionButton.setTimelineChildByName("waitText",this.waitText);
         this.waitText.setText("");
         this.waitBackground = new SpriteProxy(this);
         this.actionButton.setTimelineChildByName("background",this.waitBackground);
         this._demandBoard = new DemandBoardView(this,this._model);
         this._demandBoard.specSelected.add(this.retrieveEstimatedWaitTime);
         this._layoutContainerView.setTimelineChildByName("demandBoard",this._demandBoard);
         this._layoutContainerView.addElement(this._soloLocalPlayerComponent);
         this._layoutContainerView.addElement(this._demandBoard);
         this._layoutContainerView.addElement(this.actionButton);
         this.setWaitTimeInterfaceVisibility(false);
         this.updateActionButton();
         super.createChildren();
      }
      
      private function setWaitTimeInterfaceVisibility(param1:Boolean) : void
      {
         this.availabilityText.setVisible(param1);
         this.waitText.setVisible(param1);
         this.waitBackground.setVisible(param1);
      }
      
      protected function handleEstimatedWaitTimeChanged() : void
      {
         var _loc1_:CapEstimatedWaitTime = this._model.currentEstimatedWaitTime;
         this.waitText.setText(_loc1_.name);
         this.actionButton.setCurrentState(ACTION_BUTTON_STATE_UP);
      }
      
      protected function retrieveEstimatedWaitTime() : void
      {
         if(this._controller.retrieveEstimatedWaitTime())
         {
            this.actionButton.setCurrentState(ACTION_BUTTON_STATE_THINKING);
            this.waitText.setText("");
            this.setWaitTimeInterfaceVisibility(true);
         }
      }
      
      private function handleActionButtonClicked(param1:MouseEvent) : void
      {
         if(this._viewMediator.currentState)
         {
            this._viewMediator.currentState.handleActionButtonClicked(this.actionButton);
         }
      }
   }
}

