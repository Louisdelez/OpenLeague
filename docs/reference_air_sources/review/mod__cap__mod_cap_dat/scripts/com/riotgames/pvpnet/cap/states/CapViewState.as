package com.riotgames.pvpnet.cap.states
{
   import avmplus.getQualifiedClassName;
   import blix.action.IAction;
   import blix.components.button.LabelButtonX;
   import blix.context.IContext;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.state.IState;
   import com.riotgames.platform.common.state.IStateMachine;
   import com.riotgames.platform.common.state.NonLinearState;
   import com.riotgames.platform.gameclient.chat.INotificationsProvider;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.pvpnet.cap.audio.CapAudioKeys;
   import com.riotgames.pvpnet.cap.controllers.CapController;
   import com.riotgames.pvpnet.cap.controllers.CapLobbyTimerController;
   import com.riotgames.pvpnet.cap.controllers.CapMusicController;
   import com.riotgames.pvpnet.cap.controllers.IPlayerSpellController;
   import com.riotgames.pvpnet.cap.factory.ICapActionFactory;
   import com.riotgames.pvpnet.cap.model.CapPhase;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.CapPosition;
   import com.riotgames.pvpnet.cap.model.CapRole;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.observers.IObserver;
   import com.riotgames.pvpnet.cap.observers.group.GroupUnreadyObserver;
   import com.riotgames.pvpnet.cap.observers.observable.ICapObservableFactory;
   import com.riotgames.pvpnet.cap.observers.observable.IObservable;
   import com.riotgames.pvpnet.cap.observers.observable.composite.ICompositeObservable;
   import com.riotgames.pvpnet.cap.observers.observable.composite.captain.CaptainAbleToSearchCandidatesObserver;
   import com.riotgames.pvpnet.cap.observers.observable.composite.captain.CaptainAbleToStartMatchmakingObserver;
   import com.riotgames.pvpnet.cap.observers.observable.composite.group.GroupAbleToMatchmakeObserver;
   import com.riotgames.pvpnet.cap.observers.observable.group.CapPlayerPresenceObserver;
   import com.riotgames.pvpnet.cap.observers.observable.player.PlayerFullySpeccedObserver;
   import com.riotgames.pvpnet.cap.util.CapFlowUtil;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.pvpnet.cap.views.ICapView;
   import com.riotgames.pvpnet.cap.views.components.ICapButtonsFooterComponent;
   import com.riotgames.pvpnet.cap.views.popups.champselect.CapClassicChampSelectPopup;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.game.domain.IGameQueueManager;
   import com.riotgames.pvpnet.invite.IInviteController;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   
   public class CapViewState extends NonLinearState
   {
      
      private var _groupUnreadyObserver:IObserver;
      
      private var _view:ICapView;
      
      private var _localPlayerFullySpeccedObserver:IObservable;
      
      private var _playerPresenceObserver:CapPlayerPresenceObserver;
      
      private var _groupAbleToMatchmakeObserver:ICompositeObservable;
      
      private var _spellController:IPlayerSpellController;
      
      private var _soundProvider:ISoundProvider;
      
      private var _model:CapModel;
      
      protected var _champSelectPopup:CapClassicChampSelectPopup;
      
      private var _inviteGroup:InviteGroup;
      
      private var _controller:CapController;
      
      private var _captainAbleToStartMatchmakingObserver:ICompositeObservable;
      
      private var _capLobbyTimerController:CapLobbyTimerController;
      
      private var _gameQueueManager:IGameQueueManager;
      
      private var _observableFactory:ICapObservableFactory;
      
      private var _lobbyController:ILobbyViewController;
      
      private var _dockedNotificationProvider:INotificationsProvider;
      
      private var _musicController:CapMusicController;
      
      private var _inviteController:IInviteController;
      
      private var _captainAbleToSearchCandidatesObserver:ICompositeObservable;
      
      private var _actionFactory:ICapActionFactory;
      
      public function CapViewState(param1:ICapView, param2:IContext, param3:IStateMachine)
      {
         var _loc4_:String = this.generateStateName(this);
         super(param3,_loc4_);
         this._view = param1;
         this._controller = param2.getDependency(CapController);
         this._musicController = param2.getDependency(CapMusicController);
         this._model = param2.getDependency(CapModel);
         this._spellController = param2.getDependency(IPlayerSpellController);
         this._lobbyController = param2.getDependency(ILobbyViewController);
         this._inviteController = param2.getDependency(IInviteController);
         this._actionFactory = param2.getDependency(ICapActionFactory);
         this._dockedNotificationProvider = param2.getDependency(INotificationsProvider);
         this._observableFactory = param2.getDependency(ICapObservableFactory);
         this._playerPresenceObserver = param2.getDependency(CapPlayerPresenceObserver);
         this._gameQueueManager = param2.getDependency(IGameQueueManager);
         this._capLobbyTimerController = param2.getDependency(CapLobbyTimerController);
         this._soundProvider = param2.getDependency(ISoundProvider);
         this._groupAbleToMatchmakeObserver = param2.getDependency(GroupAbleToMatchmakeObserver);
         this._groupUnreadyObserver = param2.getDependency(GroupUnreadyObserver);
         this._captainAbleToStartMatchmakingObserver = param2.getDependency(CaptainAbleToStartMatchmakingObserver);
         this._captainAbleToSearchCandidatesObserver = param2.getDependency(CaptainAbleToSearchCandidatesObserver);
         this._localPlayerFullySpeccedObserver = param2.getDependency(PlayerFullySpeccedObserver);
         this._champSelectPopup = param2.getDependency(CapClassicChampSelectPopup);
         this._inviteGroup = param2.getDependency(InviteGroup);
      }
      
      protected function get buttonsFooter() : ICapButtonsFooterComponent
      {
         return this._view.buttonsFooter;
      }
      
      protected function get inviteController() : IInviteController
      {
         return this._inviteController;
      }
      
      protected function revealNextAvailableSlot() : void
      {
         if(CapFlowUtil.isCaptain(this._model))
         {
         }
         var _loc1_:IAction = this._actionFactory.getRevealNextAvailableSlotAction();
         _loc1_.invoke();
      }
      
      protected function get capLobbyTimerController() : CapLobbyTimerController
      {
         return this._capLobbyTimerController;
      }
      
      public function handleSpell2Selected(param1:Spell) : void
      {
         this._spellController.selectSpells(null,param1);
         this._soundProvider.play(CapAudioKeys.CAP_SELECT_SUMMONER_SKILL);
      }
      
      protected function get dockedNotificationsProvider() : INotificationsProvider
      {
         return this._dockedNotificationProvider;
      }
      
      protected function get lobbyController() : ILobbyViewController
      {
         return this._lobbyController;
      }
      
      public function handleSpell1Selected(param1:Spell) : void
      {
         this._spellController.selectSpells(param1,null);
         this._soundProvider.play(CapAudioKeys.CAP_SELECT_SUMMONER_SKILL);
      }
      
      protected function get capView() : ICapView
      {
         return this._view;
      }
      
      protected function get controller() : CapController
      {
         return this._controller;
      }
      
      override public function onExit() : void
      {
         super.onExit();
         this._playerPresenceObserver.playerAddedToGroup.remove(this.handlePlayerAddedToGroup);
         this._playerPresenceObserver.playerRemovedFromGroup.remove(this.handlePlayerRemovedFromGroup);
         this.buttonsFooter.quitButtonClicked.remove(this.onQuitButtonClicked);
         this.buttonsFooter.actionButtonClicked.remove(this.handleActionButtonClicked);
      }
      
      protected function get soundProvider() : ISoundProvider
      {
         return this._soundProvider;
      }
      
      protected function get inviteGroup() : InviteGroup
      {
         return this._inviteGroup;
      }
      
      protected function get model() : CapModel
      {
         return this._model;
      }
      
      protected function displayStatusMessage(param1:String) : void
      {
         var _loc2_:IAction = this._actionFactory.getStatusMessageAction(param1);
         _loc2_.invoke();
      }
      
      public function handlePositionSelected(param1:CapPosition, param2:CapPlayerSelection) : void
      {
         this._controller.selectPosition(param1,param2.slotId);
      }
      
      protected function get groupAbleToMatchmakeObserver() : IObservable
      {
         return this._groupAbleToMatchmakeObserver;
      }
      
      public function handleSpecSolosClicked(param1:LabelButtonX) : void
      {
         this._soundProvider.play(CapAudioKeys.CAP_FIND_SOLO_PLAYERS_CLICKED);
      }
      
      protected function get musicController() : CapMusicController
      {
         return this._musicController;
      }
      
      protected function get captainAbleToStartMatchmakingObserver() : IObservable
      {
         return this._captainAbleToStartMatchmakingObserver;
      }
      
      protected function get localPlayerFullySpeccedObserver() : IObservable
      {
         return this._localPlayerFullySpeccedObserver;
      }
      
      override public function onEnter() : void
      {
         this._model.currentPhase = this.phase;
         super.onEnter();
         this.showView();
         this.playMusic();
         this._playerPresenceObserver.playerAddedToGroup.add(this.handlePlayerAddedToGroup,true);
         this._playerPresenceObserver.playerRemovedFromGroup.add(this.handlePlayerRemovedFromGroup,true);
         this.buttonsFooter.setActionButtonEnabled(false);
         this.buttonsFooter.quitButtonClicked.add(this.onQuitButtonClicked);
         this.buttonsFooter.actionButtonClicked.add(this.handleActionButtonClicked);
      }
      
      protected function changeState(param1:Class) : void
      {
         (this.stateMachine as CapStrictStateMachine).changeStateByClass(param1);
      }
      
      protected function get groupUnreadyObserver() : IObserver
      {
         return this._groupUnreadyObserver;
      }
      
      public function handleActionButtonClicked(param1:LabelButtonX) : void
      {
         this._soundProvider.play(CapAudioKeys.CAP_ACTION_BUTTON_CLICK);
      }
      
      protected function get observableFactory() : ICapObservableFactory
      {
         return this._observableFactory;
      }
      
      protected function showView() : void
      {
         logger.warn("No view defined - unable to display view.");
      }
      
      public function handleInviteButtonClicked(param1:LabelButtonX) : void
      {
         this._soundProvider.play(CapAudioKeys.CAP_OPEN_WINDOW);
         this._controller.launchInvites();
      }
      
      public function handleSpellsSelected(param1:Spell, param2:Spell) : void
      {
         this._spellController.selectSpells(param1,param2);
      }
      
      protected function stopMusic() : void
      {
         logger.warn("No music defined - unable to stop music");
      }
      
      protected function handlePlayerRemovedFromGroup(param1:CapPlayerSelection) : void
      {
         var _loc3_:String = null;
         if(param1.isCandidate || !param1.summonerName)
         {
            return;
         }
         var _loc2_:String = param1.summonerName;
         if(param1.kicked)
         {
            _loc3_ = CapLocaleUtil.getResourceString("gf_status_message_player_kicked","Player has been kicked from the group.",[_loc2_]);
         }
         else
         {
            _loc3_ = CapLocaleUtil.getResourceString("gf_status_message_player_removed","Player has been removed from the group.",[_loc2_]);
         }
         var _loc4_:IAction = this._actionFactory.getStatusMessageAction(_loc3_);
         _loc4_.invoke();
         if(!param1.isLocalPlayer)
         {
            this.soundProvider.play(CapAudioKeys.CAP_OTHER_PLAYER_LEAVES);
         }
      }
      
      protected function playMusic() : void
      {
         logger.warn("No music defined - unable to play music.");
      }
      
      private function generateStateName(param1:IState) : String
      {
         return getQualifiedClassName(param1).replace(/::/,".");
      }
      
      protected function handleFirstInviteSent() : void
      {
         this.model.invitePanelVisible = true;
         this.model.activeCaptainSelectionPanel.currentState = CapPlayerSelection.FIND_PLAYERS_STATE;
      }
      
      public function handleAdvertisedRoleSelected(param1:CapRole, param2:CapPlayerSelection) : void
      {
         this._controller.selectAdvertisedRole(param1,param2.slotId);
      }
      
      protected function displayAllPlayersReadyStatusMessage() : void
      {
         var _loc1_:String = CapLocaleUtil.getResourceString("gf_status_all_players_ready","All players are ready.");
         this.displayStatusMessage(_loc1_);
      }
      
      protected function get captainAbleToSearchCandidatesObserver() : ICompositeObservable
      {
         return this._captainAbleToSearchCandidatesObserver;
      }
      
      public function handleAdvertisedPositionSelected(param1:CapPosition, param2:CapPlayerSelection) : void
      {
         this._controller.selectAdvertisedPosition(param1,param2.slotId);
      }
      
      protected function get spellController() : IPlayerSpellController
      {
         return this._spellController;
      }
      
      public function handleChampionSelected(param1:Champion) : void
      {
         this._controller.selectChampion(param1);
      }
      
      protected function handlePlayerAddedToGroup(param1:CapPlayerSelection) : void
      {
         var _loc2_:String = null;
         var _loc3_:IAction = null;
         if(param1.summonerName)
         {
            _loc2_ = CapLocaleUtil.getResourceString("gf_status_message_player_added","Player has been added to the group.",[param1.summonerName]);
            _loc3_ = this._actionFactory.getStatusMessageAction(_loc2_);
            _loc3_.invoke();
            this.soundProvider.play(CapAudioKeys.CAP_PLAYER_JOINS);
         }
      }
      
      public function handleSpellViewClosed() : void
      {
         this._soundProvider.play(CapAudioKeys.CAP_CLOSE_SPELL_VIEW);
      }
      
      protected function get actionFactory() : ICapActionFactory
      {
         return this._actionFactory;
      }
      
      public function handleRoleSelected(param1:CapRole, param2:CapPlayerSelection) : void
      {
         this._controller.selectRole(param1,param2.slotId);
      }
      
      public function get phase() : String
      {
         return CapPhase.UNSPECIFIED;
      }
      
      protected function get gameQueueManager() : IGameQueueManager
      {
         return this._gameQueueManager;
      }
      
      protected function onQuitButtonClicked(param1:LabelButtonX) : void
      {
         this._controller.requestQuit();
      }
   }
}

