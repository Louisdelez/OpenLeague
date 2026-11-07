package com.riotgames.pvpnet.cap.views
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.list.ConditionalRendererFactory;
   import blix.components.list.DataGroup;
   import blix.components.list.IRendererFactory;
   import blix.components.list.RendererFactory;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.layout.algorithms.VirtualizedVerticalLayout;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.pvpnet.cap.layout.CapMapLayout;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.renderers.player.CapLocalPlayerRenderer;
   import com.riotgames.pvpnet.cap.renderers.player.CapPlayerRenderer;
   import com.riotgames.pvpnet.cap.util.CapModelUtil;
   import com.riotgames.pvpnet.cap.views.components.CapChatPanel;
   import com.riotgames.pvpnet.cap.views.components.CapInviteStatusPanel;
   import com.riotgames.pvpnet.cap.views.components.CapMapPanel;
   import com.riotgames.pvpnet.game.controllers.IMasterGameController;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.rust.data.ListAdapter;
   
   public class CapTeamViewContent extends StatefulView
   {
      
      private var remotePlayerRendererFactory:RendererFactory;
      
      private var localPlayerRendererFactory:RendererFactory;
      
      private var teammateListAdapter:ListAdapter;
      
      private var _masterGameController:IMasterGameController;
      
      private var chatView:CapChatPanel;
      
      private var teammateList:DataGroup;
      
      private var conditionalRendererFactory:ConditionalRendererFactory;
      
      private var _mapView:CapMapPanel;
      
      private var _gameTypeTextField:TextFieldProxy;
      
      private var _model:CapModel;
      
      private var _titleTextField:TextFieldProxy;
      
      private var invitePanel:CapInviteStatusPanel;
      
      public function CapTeamViewContent(param1:IContext, param2:CapModel)
      {
         this._model = param2;
         super(param1);
      }
      
      override public function destroy() : void
      {
         this._model.gameModeChanged.remove(this.renderGameInfo);
         this._masterGameController.gameModelChanged.remove(this.renderGameInfo);
         this.teammateList.destroy();
         this.teammateListAdapter.destroy();
         this.chatView.destroy();
         this.invitePanel.destroy();
         this.localPlayerRendererFactory.destroy();
         this.remotePlayerRendererFactory.destroy();
         this.conditionalRendererFactory.destroy();
         this._mapView.destroy();
         this._titleTextField.destroy();
         this._gameTypeTextField.destroy();
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
      
      private function factoryFunction(param1:*) : IRendererFactory
      {
         if(param1 is CapPlayerSelection && (param1 as CapPlayerSelection).isLocalPlayer)
         {
            return this.localPlayerRendererFactory;
         }
         return this.remotePlayerRendererFactory;
      }
      
      override protected function initializeDependencies() : void
      {
         this._masterGameController = getDependency(MasterGameController);
         this._masterGameController.gameModelChanged.add(this.renderGameInfo);
         super.initializeDependencies();
      }
      
      override protected function createChildren() : void
      {
         this.chatView = new CapChatPanel(this);
         setTimelineChildByName("chatPanel",this.chatView);
         this.invitePanel = new CapInviteStatusPanel(this);
         setTimelineChildByName("invitePanel",this.invitePanel);
         this.teammateListAdapter = new ListAdapter(this._model.playerSelections);
         this.localPlayerRendererFactory = new RendererFactory(CapLocalPlayerRenderer,[this]);
         this.remotePlayerRendererFactory = new RendererFactory(CapPlayerRenderer,[this]);
         this.conditionalRendererFactory = new ConditionalRendererFactory(this.factoryFunction);
         this.teammateList = new DataGroup(this,this.teammateListAdapter,this.conditionalRendererFactory);
         this.teammateList.setLinkage("TeammateList");
         this.teammateList.setExplicitSize(NaN,NaN);
         this.teammateList.setLayoutAlgorithm(new VirtualizedVerticalLayout());
         setTimelineChildByName("teammateList",this.teammateList);
         this._mapView = new CapMapPanel(this);
         this._mapView.setLayoutAlgorithm(new CapMapLayout());
         setTimelineChildByName("mapPanel",this._mapView);
         this._titleTextField = new TextFieldProxy(this);
         setTimelineChildByName("titleTextField",this._titleTextField);
         this._gameTypeTextField = new TextFieldProxy(this);
         setTimelineChildByName("gameTypeTextField",this._gameTypeTextField);
         this._model.gameModeChanged.add(this.renderGameInfo);
         this.renderGameInfo();
         super.createChildren();
      }
   }
}

