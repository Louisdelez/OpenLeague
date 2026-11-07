package com.riotgames.pvpnet.invite.legacy.action
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.utils.app.ApplicationUtil;
   import com.riotgames.platform.gameclient.chat.IChatRoomProvider;
   import com.riotgames.platform.gameclient.chat.IChatRosterProvider;
   import com.riotgames.platform.gameclient.domain.game.GameQueueConfig;
   import com.riotgames.platform.gameclient.domain.gameinvite.InviteType;
   import com.riotgames.platform.gameclient.services.SummonerService;
   import com.riotgames.pvpnet.game.domain.GameQueueManager;
   import com.riotgames.pvpnet.invite.IInviteController;
   import com.riotgames.pvpnet.invite.IInviteRankedTeamController;
   import com.riotgames.pvpnet.invite.legacy.controller.InviteBayController;
   import com.riotgames.pvpnet.invite.legacy.controller.LegacyRankedTeamInviteController;
   import com.riotgames.pvpnet.invite.legacy.enum.InviteSectionTypeEnums;
   import com.riotgames.pvpnet.invite.legacy.model.LegacyInviteBayRules;
   import com.riotgames.pvpnet.invite.legacy.model.LegacyRankedTeamInviteBayRules;
   import com.riotgames.pvpnet.invite.legacy.view.InvitePlayersView;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import com.riotgames.pvpnet.invite.rules.IInviteBayRules;
   import com.riotgames.pvpnet.queuerestriction.QueueRestrictionActionFactory;
   import com.riotgames.pvpnet.queuerestriction.QueueRestrictionCache;
   import com.riotgames.pvpnet.queuerestriction.action.FilterIneligibleQueuePartnersAction;
   import com.riotgames.pvpnet.queuerestriction.configurations.QueueRestrictionConfiguration;
   import flash.display.DisplayObject;
   import mx.collections.ArrayCollection;
   import mx.managers.PopUpManager;
   
   public class ShowInvitePlayersPopupAction extends BasicAction
   {
      
      private var _chatRosterProvider:IChatRosterProvider;
      
      private var _chatRoomProvider:IChatRoomProvider;
      
      private var _rankedTeamManagementController:IInviteRankedTeamController;
      
      private var _summonerService:SummonerService;
      
      private var _gameQueueManager:GameQueueManager;
      
      private var _inviteBayController:InviteBayController;
      
      private var _queueRestrictionCache:QueueRestrictionCache;
      
      private var _inviteController:IInviteController;
      
      private var popup:InvitePlayersView;
      
      private var _inviteRules:IInviteBayRules;
      
      private var inviteSummonerByNameAction:InviteSummonerByNameAction;
      
      private var _inviteGroup:InviteGroup;
      
      private var _queueRestrictionActionFactory:QueueRestrictionActionFactory;
      
      public function ShowInvitePlayersPopupAction(param1:SummonerService, param2:IChatRoomProvider, param3:IChatRosterProvider, param4:InviteGroup, param5:IInviteController, param6:GameQueueManager, param7:IInviteBayRules, param8:IInviteRankedTeamController, param9:QueueRestrictionActionFactory, param10:QueueRestrictionCache)
      {
         super(true);
         this._summonerService = param1;
         this._chatRosterProvider = param3;
         this._chatRoomProvider = param2;
         this._gameQueueManager = param6;
         this._inviteController = param5;
         this._inviteRules = param7;
         this._inviteGroup = param4;
         this._rankedTeamManagementController = param8;
         this._queueRestrictionActionFactory = param9;
         this._queueRestrictionCache = param10;
      }
      
      private function addPlayerInviteBayPlayersViewClicked(param1:Array) : void
      {
         var _loc2_:FilterIneligibleQueuePartnersAction = null;
         if(this._inviteRules.sectionIndex == LegacyInviteBayRules.SECTION_INDEX_CHAT_ROOMS && Boolean(QueueRestrictionConfiguration.isQueueRestrictionRequired(this._gameQueueManager.getSelectedGameQueueConfig())))
         {
            _loc2_ = this._queueRestrictionActionFactory.getFilterIneligibleQueuePartnersAction(param1);
            _loc2_.getCompleted().add(this.onAddQueueRestrictionCheckCompleted);
            _loc2_.invoke();
         }
         else
         {
            this._inviteBayController.addPlayersToInviteBay(param1);
         }
      }
      
      private function remove() : void
      {
         if(this.popup != null)
         {
            this.popup.getCloseClickedSignal().removeAll();
            this.popup.getAllowGuestsChangedSignal().removeAll();
            this.popup.getInvitePlayerClickedSignal().removeAll();
            this.popup.getChooseAvailalablePlayersClickedSignal().removeAll();
            this.popup.getFilterTextChangedSignal().removeAll();
            this.popup.getInviteAllClickedSignal().removeAll();
            this.popup.getAddPlayerInviteClickedSignal().removeAll();
            this.popup.getRemovePlayerInviteClickedSignal().removeAll();
            PopUpManager.removePopUp(this.popup);
            this.popup = null;
         }
      }
      
      private function onInvitePlayerCompleted() : void
      {
         var _loc1_:FilterIneligibleQueuePartnersAction = this._queueRestrictionActionFactory.getFilterIneligibleQueuePartnersAction([this.inviteSummonerByNameAction.getSuccessfullyInvitedPlayerRosterItem()]);
         _loc1_.getCompleted().add(this.onInviteQueueRestrictionCheckCompleted);
         _loc1_.invoke();
      }
      
      private function onInvitePlayerErred(param1:InviteSummonerByNameAction) : void
      {
         this.cleanupInviteAction();
      }
      
      private function onInviteAllClicked() : void
      {
         this._inviteRules.invitePlayers(this._inviteBayController.getAvailableInviteBay());
      }
      
      private function onChooseAvailablePlayersClicked(param1:int) : void
      {
         this._inviteRules.sectionIndex = param1;
      }
      
      private function cleanupInviteAction() : void
      {
         this.popup.isBusy = false;
         this.inviteSummonerByNameAction = null;
      }
      
      private function onInvitePlayerClicked(param1:String) : void
      {
         this.popup.isBusy = true;
         var _loc2_:GameQueueConfig = this._gameQueueManager.getSelectedGameQueueConfig();
         this.inviteSummonerByNameAction = new InviteSummonerByNameAction(param1,this._inviteGroup.myUserName,this._chatRosterProvider,this._summonerService,InviteType.DEFAULT,_loc2_);
         this.inviteSummonerByNameAction.getCompleted().addOnce(this.onInvitePlayerCompleted);
         this.inviteSummonerByNameAction.getErred().addOnce(this.onInvitePlayerErred);
         this.inviteSummonerByNameAction.invoke();
      }
      
      private function createRule() : IInviteBayRules
      {
         if(Boolean(this._inviteController.getSelectedGameQueueConfig()) && Boolean(this._inviteController.getSelectedGameQueueConfig().teamOnly))
         {
            return new LegacyRankedTeamInviteBayRules(new ArrayCollection(),this._chatRosterProvider,this._inviteController,this._rankedTeamManagementController as LegacyRankedTeamInviteController,this._gameQueueManager);
         }
         return new LegacyInviteBayRules(new ArrayCollection(),this._chatRosterProvider,this._chatRoomProvider,this._inviteController);
      }
      
      private function onFilterTextChanged(param1:String) : void
      {
         this._inviteRules.filterAvailableInviteList(param1);
      }
      
      private function removePlayerInviteBayPlayersViewClicked(param1:Array) : void
      {
         this._inviteBayController.removePlayersFromInviteBay(param1);
      }
      
      private function onInviteQueueRestrictionCheckCompleted(param1:FilterIneligibleQueuePartnersAction) : void
      {
         var _loc2_:Array = param1.getEligibleQueuePartners();
         if(_loc2_.length > 0)
         {
            this._inviteBayController.addPlayersToInviteBay(_loc2_);
         }
         this.cleanupInviteAction();
      }
      
      private function onAddQueueRestrictionCheckCompleted(param1:FilterIneligibleQueuePartnersAction) : void
      {
         var _loc2_:Array = param1.getEligibleQueuePartners();
         if(_loc2_.length > 0)
         {
            this._inviteBayController.addPlayersToInviteBay(_loc2_);
         }
      }
      
      override protected function doInvocation() : void
      {
         var _loc1_:DisplayObject = null;
         if(getIsFinished())
         {
            reset();
         }
         if(!this.popup)
         {
            if(!this._inviteRules)
            {
               this._inviteRules = this.createRule();
            }
            this._inviteBayController = new InviteBayController(this._inviteRules.availableInviteBay,this._inviteRules,this._chatRosterProvider,this._inviteController);
            this.popup = new InvitePlayersView();
            this.popup.getCloseClickedSignal().add(this.remove);
            this.popup.getAllowGuestsChangedSignal().add(this.onGuestSlotsSelectedChanged);
            this.popup.getInvitePlayerClickedSignal().add(this.onInvitePlayerClicked);
            this.popup.getChooseAvailalablePlayersClickedSignal().add(this.onChooseAvailablePlayersClicked);
            this.popup.getFilterTextChangedSignal().add(this.onFilterTextChanged);
            this.popup.getInviteAllClickedSignal().add(this.onInviteAllClicked);
            this.popup.getAddPlayerInviteClickedSignal().add(this.addPlayerInviteBayPlayersViewClicked);
            this.popup.getRemovePlayerInviteClickedSignal().add(this.removePlayerInviteBayPlayersViewClicked);
            this.popup.setInviteRules(this._inviteRules);
            this.popup.isRankedSoloQueue = Boolean(this._gameQueueManager.selectedGameQueueConfig) && Boolean(this._gameQueueManager.selectedGameQueueConfig.ranked) && !this._gameQueueManager.selectedGameQueueConfig.teamOnly;
            _loc1_ = ApplicationUtil.application as DisplayObject;
            this.popup.width = _loc1_.width * 0.85;
            this.popup.height = _loc1_.height * 0.85;
            PopUpManager.addPopUp(this.popup,_loc1_,true);
            PopUpManager.centerPopUp(this.popup);
         }
      }
      
      private function onGuestSlotsSelectedChanged(param1:Boolean) : void
      {
         if(this._inviteRules.sectionType == InviteSectionTypeEnums.SECTION_TYPE_COMBOBOX)
         {
            this._inviteRules.allowGuestInvites = param1;
         }
      }
   }
}

