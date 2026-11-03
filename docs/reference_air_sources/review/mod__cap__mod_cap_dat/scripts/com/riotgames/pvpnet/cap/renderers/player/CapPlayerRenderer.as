package com.riotgames.pvpnet.cap.renderers.player
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.button.LabelButtonX;
   import blix.components.dropdown.DropDown;
   import blix.components.list.RendererFactory;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.assignToolTip;
   import blix.components.tooltip.unassignToolTip;
   import blix.context.IContext;
   import blix.ds.ListX;
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.utils.ChampionIconCacheUtil;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.platform.gameclient.domain.UserPrefs;
   import com.riotgames.pvpnet.cap.audio.CapAudioKeys;
   import com.riotgames.pvpnet.cap.controllers.CapController;
   import com.riotgames.pvpnet.cap.mediators.CapViewMediator;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.CapPosition;
   import com.riotgames.pvpnet.cap.model.CapRole;
   import com.riotgames.pvpnet.cap.observers.observable.composite.captain.CaptainAbleToSpecCandidatesObserver;
   import com.riotgames.pvpnet.cap.renderers.dropdown.CapDropdownRenderer;
   import com.riotgames.pvpnet.cap.util.CapFlowUtil;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.pvpnet.cap.util.CapRoleUtil;
   import com.riotgames.pvpnet.cap.views.tooltips.CapSpecSoloRoleDescriptionTooltip;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class CapPlayerRenderer extends CapPlayerRendererBase
   {
      
      private static const SPELL_IMAGE_WIDTH:int = 24;
      
      private static const SPELL_IMAGE_HEIGHT:int = 24;
      
      private static const SPELL_IMAGE_PADDING_TOP:int = 1;
      
      private static const SPELL_IMAGE_PADDING_LEFT:int = 1;
      
      private static const CHAMPION_IMAGE_WIDTH:int = 56;
      
      private static const CHAMPION_IMAGE_HEIGHT:int = 56;
      
      private static const CHAMPION_IMAGE_PADDING_TOP:int = 2;
      
      private static const CHAMPION_IMAGE_PADDING_LEFT:int = 2;
      
      private static const ACCEPT_DECLINE_BUTTONS_CONTAINER_DEFAULT_STATE:String = "default";
      
      private static const ACCEPT_DECLINE_BUTTONS_CONTAINER_THINKING_STATE:String = "thinking";
      
      public var specSolosButton:LabelButtonX;
      
      public var positionDropdownRendererFactory:RendererFactory;
      
      public var roleAndPositionText:TextFieldProxy;
      
      public var kickButton:ButtonX;
      
      public var roleDropdownRendererFactory:RendererFactory;
      
      private var _soundProvider:ISoundProvider;
      
      private var _inviteGroup:InviteGroup;
      
      private var _controller:CapController;
      
      public var statusText:TextFieldProxy;
      
      public var errorText:TextFieldProxy;
      
      public var acceptButton:ButtonX;
      
      public var positionDropdown:DropDown;
      
      public var pendingText:TextFieldProxy;
      
      public var spell2Image:MovieClipProxy;
      
      public var championImage:MovieClipProxy;
      
      private var _readyToSpecCandidatesObserver:CaptainAbleToSpecCandidatesObserver;
      
      public var pendingSpinner:MovieClipProxy;
      
      public var penaltyTimerText:TextFieldProxy;
      
      public var settingUpSpinner:SpriteProxy;
      
      public var invitePowersButton:ButtonX;
      
      private var _sizer:SpriteProxy;
      
      public var inviteButton:LabelButtonX;
      
      public var roleDropdown:DropDown;
      
      public var promptText:TextFieldProxy;
      
      public var captainIcon:SpriteProxy;
      
      public var summonerNameText:TextFieldProxy;
      
      public var declineButton:ButtonX;
      
      public var anyRoleText:TextFieldProxy;
      
      public var spell1Image:MovieClipProxy;
      
      public var settingUpText:TextFieldProxy;
      
      public var timeToApproveText:TextFieldProxy;
      
      public var errorPanel:SpriteProxy;
      
      public var acceptDeclineButtonsContainer:StatefulView;
      
      private var _glowEffects:StatefulView;
      
      public function CapPlayerRenderer(param1:IContext)
      {
         super(param1);
         setLinkage("TeamMemberRenderer");
         UserPrefs.enableAnimationsChanged.add(this.onEnableAnimationsChanged);
      }
      
      private function updateTimeToApproveText() : void
      {
         var _loc1_:Boolean = playerSelection.timeToApprove >= 0;
         var _loc2_:String = _loc1_ ? ACCEPT_DECLINE_BUTTONS_CONTAINER_DEFAULT_STATE : ACCEPT_DECLINE_BUTTONS_CONTAINER_THINKING_STATE;
         this.acceptDeclineButtonsContainer.setCurrentState(_loc2_);
         this.timeToApproveText.setVisible(_loc1_);
         this.timeToApproveText.setText(playerSelection.timeToApprove.toString());
      }
      
      private function handlePositionDropdownSelection() : void
      {
         handlePositionSelected(this.positionDropdown.getSelectionBehavior().getSelectedItem() as CapPosition);
      }
      
      private function clearImage(param1:DisplayObjectContainerProxy) : void
      {
         param1.removeAllChildren();
      }
      
      override protected function subscribeToDataChanges(param1:CapPlayerSelection) : void
      {
         super.subscribeToDataChanges(param1);
         param1.visibleChanged.add(this.updateChildren);
         param1.errorTextChanged.add(this.updateErrorText);
         param1.rolePositionLockedChanged.add(this.updateStatusText);
         param1.isReadyChanged.add(this.updateStatusText);
         param1.currentStateChanged.add(this.updateState);
         param1.isCaptainChanged.add(this.updateCaptainIcon);
         param1.summonerNameChanged.add(this.updateSummonerNameText);
         param1.championChanged.add(this.updateChampionImage);
         param1.spell1Changed.add(this.updateSpell1Image);
         param1.spell2Changed.add(this.updateSpell2Image);
         param1.roleChanged.add(this.updateRoleAndPositionText);
         param1.advertisedRoleChanged.add(this.updateRoleAndPositionText);
         param1.positionChanged.add(this.updateRoleAndPositionText);
         param1.isCandidateChanged.add(this.updateAcceptDeclineButtons);
         param1.timeToApproveTimeChanged.add(this.updateTimeToApproveText);
         param1.isSoloChanged.add(this.updateKickButton);
         param1.penaltyTimeInSecondsChanged.add(this.updatePenaltyTmer);
         param1.isInvitedPlayerChanged.add(this.updateInviteeSettingUpIndicators);
         param1.isCaptainChanged.add(this.updateInvitePowersButton);
         param1.isInvitedPlayerChanged.add(this.updateInvitePowersButton);
         param1.isSoloChanged.add(this.updateInvitePowersButton);
      }
      
      private function setSpellImage(param1:DisplayObjectContainerProxy, param2:Spell) : void
      {
         var _loc3_:Bitmap = null;
         if(param2)
         {
            _loc3_ = ImagePackLookup.instance.getSpellBitmap(param2);
            _loc3_.width = SPELL_IMAGE_WIDTH;
            _loc3_.height = SPELL_IMAGE_HEIGHT;
            _loc3_.x = SPELL_IMAGE_PADDING_LEFT;
            _loc3_.y = SPELL_IMAGE_PADDING_TOP;
            this.setImage(param1,_loc3_);
         }
         else
         {
            this.clearImage(param1);
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc3_:CapRole = null;
         super.createChildren();
         this.errorPanel = new SpriteProxy(this);
         setTimelineChildByName("declineWarning",this.errorPanel);
         this.errorPanel.setVisible(false);
         this.errorText = new TextFieldProxy(this);
         this.errorPanel.setTimelineChildByName("declineWarning_text",this.errorText);
         this.errorText.setText("");
         this.inviteButton = new LabelButtonX(this);
         setTimelineChildByName("inviteButton",this.inviteButton);
         this.inviteButton.addEventListener(MouseEvent.CLICK,this.handleInviteClick);
         this.inviteButton.setText(CapLocaleUtil.getResourceString("gf_button_invite_label","Invite"));
         this.specSolosButton = new LabelButtonX(this);
         setTimelineChildByName("specSolosButton",this.specSolosButton);
         this.specSolosButton.addEventListener(MouseEvent.CLICK,this.handleSpecSolosClick);
         this.specSolosButton.setText(CapLocaleUtil.getResourceString("gf_button_spec_solos_label","Spec Solos"));
         this.championImage = new MovieClipProxy(this);
         setTimelineChildByName("championImage",this.championImage);
         this.championImage.getAssetChanged().add(this.updateChampionImage);
         this.summonerNameText = new TextFieldProxy(this);
         setTimelineChildByName("summonerName",this.summonerNameText);
         this.roleAndPositionText = new TextFieldProxy(this);
         setTimelineChildByName("roleAndLane",this.roleAndPositionText);
         this.spell1Image = new MovieClipProxy(this);
         setTimelineChildByName("spell1Image",this.spell1Image);
         this.spell2Image = new MovieClipProxy(this);
         setTimelineChildByName("spell2Image",this.spell2Image);
         this.statusText = new TextFieldProxy(this);
         setTimelineChildByName("status",this.statusText);
         this.captainIcon = new SpriteProxy(this);
         setTimelineChildByName("captainIcon",this.captainIcon);
         this.acceptDeclineButtonsContainer = new StatefulView(this);
         setTimelineChildByName("buttonsContainer",this.acceptDeclineButtonsContainer);
         this.acceptButton = new ButtonX(this);
         setTimelineChildByName("buttonsContainer.acceptbtn",this.acceptButton);
         this.acceptButton.addEventListener(MouseEvent.CLICK,this.handleAcceptClick);
         assignToolTip(this.acceptButton,CapLocaleUtil.getResourceString("gf_button_accept_label","Accept"));
         this.declineButton = new ButtonX(this);
         setTimelineChildByName("buttonsContainer.declinebtn",this.declineButton);
         this.declineButton.addEventListener(MouseEvent.CLICK,this.handleDeclineClick);
         assignToolTip(this.declineButton,CapLocaleUtil.getResourceString("gf_button_decline_label","Decline"));
         this.invitePowersButton = new ButtonX(this);
         this.invitePowersButton.addEventListener(MouseEvent.CLICK,this.handleInvitePowersButtonClicked);
         setTimelineChildByName("invitePowersButton",this.invitePowersButton);
         this.kickButton = new ButtonX(this);
         setTimelineChildByName("kickbtn",this.kickButton);
         this.kickButton.setVisible(false);
         this.kickButton.addEventListener(MouseEvent.CLICK,this.handleKickClick);
         assignToolTip(this.kickButton,CapLocaleUtil.getResourceString("gf_button_kick","Kick"));
         var _loc1_:ListX = new ListX(_model.speccableRoles);
         this.roleDropdown = new DropDown(this);
         this.roleDropdownRendererFactory = new RendererFactory(CapDropdownRenderer,[this,"CapDropDownItemRenderer","name",CapSpecSoloRoleDescriptionTooltip]);
         this.roleDropdown.setRendererFactory(this.roleDropdownRendererFactory);
         this.roleDropdown.setDataProvider(_loc1_);
         this.roleDropdown.setListLinkage("DataGroupDropdownList");
         this.roleDropdown.setLabelField("name");
         this.roleDropdown.setNoneSelectedLabel(CapLocaleUtil.getResourceString("gf_dropdown_role_initial_label","Select role..."));
         setTimelineChildByName("roleDropdown",this.roleDropdown);
         this.anyRoleText = new TextFieldProxy(this);
         setTimelineChildByName("anyRole_mc.anyRole_txt",this.anyRoleText);
         this.anyRoleText.setVisible(false);
         if(CapRoleUtil.hasAnyRole(_model.speccableRoles))
         {
            _loc3_ = CapRoleUtil.getAnyRole(_model.speccableRoles);
            this.roleDropdown.getSelectionBehavior().setSelectedItem(_loc3_);
            if(_model.speccableRoles.length == 1)
            {
               this.roleDropdown.setVisible(false);
               this.anyRoleText.setVisible(true);
               this.anyRoleText.setText(_loc3_.name);
            }
         }
         this.roleDropdown.getSelectedChanged().add(this.handleDropdownOpenChanged);
         this.roleDropdown.getSelectionBehavior().getSelectedItemsChanged().add(this.handleAdvertisedRoleSelected);
         this.roleDropdown.getSelectionBehavior().getSelectedItemsChanged().add(this.handleDropdownSelection);
         var _loc2_:ListX = new ListX(_model.positions);
         this.positionDropdown = new DropDown(this);
         this.positionDropdownRendererFactory = new RendererFactory(CapDropdownRenderer,[this]);
         this.positionDropdown.setRendererFactory(this.positionDropdownRendererFactory);
         this.positionDropdown.setListLinkage("DataGroupDropdownList");
         this.positionDropdown.setLabelField("name");
         this.positionDropdown.setNoneSelectedLabel(CapLocaleUtil.getResourceString("gf_dropdown_position_initial_label","Select position..."));
         this.positionDropdown.setDataProvider(_loc2_);
         setTimelineChildByName("positionDropdown",this.positionDropdown);
         this.positionDropdown.getSelectedChanged().add(this.handleDropdownOpenChanged);
         this.positionDropdown.getSelectionBehavior().getSelectedItemsChanged().add(this.handleAdvertisedPositionSelected);
         this.positionDropdown.getSelectionBehavior().getSelectedItemsChanged().add(this.handleDropdownSelection);
         this.pendingSpinner = new MovieClipProxy(this);
         setTimelineChildByName("pendingSpinner",this.pendingSpinner);
         this.pendingText = new TextFieldProxy(this);
         setTimelineChildByName("pendingText",this.pendingText);
         this.timeToApproveText = new TextFieldProxy(this);
         setTimelineChildByName("pending",this.timeToApproveText);
         assignToolTip(this.timeToApproveText,CapLocaleUtil.getResourceString("gf_tooltip_found_solo_countdown_timer","Accept/Decline time limit"));
         this.promptText = new TextFieldProxy(this);
         setTimelineChildByName("prompt",this.promptText);
         this._glowEffects = new StatefulView(this);
         setTimelineChildByName("glowEffects",this._glowEffects);
         this.updateGlowEffectVisibility();
         this.settingUpText = new TextFieldProxy(this);
         setTimelineChildByName("settingUpText",this.settingUpText);
         this.settingUpText.setText(CapLocaleUtil.getResourceString("gf_player_status_setting_up_invitee","Setting up"));
         this.settingUpText.setVisible(false);
         this.settingUpSpinner = new SpriteProxy(this);
         setTimelineChildByName("settingUpSpinner",this.settingUpSpinner);
         this.settingUpSpinner.setVisible(false);
         this._sizer = new SpriteProxy(this);
         setTimelineChildByName("sizer",this._sizer);
         this.penaltyTimerText = new TextFieldProxy(this);
         setTimelineChildByName("kickcountdown",this.penaltyTimerText);
      }
      
      private function handleInvitePowersButtonClicked(param1:MouseEvent = null) : void
      {
         if(!playerSelection)
         {
            return;
         }
         this.invitePowersButton.setSelected(!this.invitePowersButton.getSelected());
         if(this.invitePowersButton.getSelected())
         {
            this._controller.delegateAsInvitor(playerSelection);
         }
         else
         {
            this._controller.revokeInvitePrivileges(playerSelection);
         }
      }
      
      private function handleAcceptClick(param1:MouseEvent) : void
      {
         this._soundProvider.play(CapAudioKeys.CAP_BUTTON_CLICK);
         this.renderAcceptedCandidate();
         this._controller.acceptCandidate(playerSelection.slotId,this.updateAcceptDeclineButtons);
      }
      
      private function onEnableAnimationsChanged() : void
      {
         this.updateGlowEffectVisibility();
      }
      
      private function setImage(param1:DisplayObjectContainerProxy, param2:Bitmap) : void
      {
         this.clearImage(param1);
         var _loc3_:BitmapProxy = new BitmapProxy(this,param2);
         param1.addChild(_loc3_);
         _loc3_.setSmoothing(true);
      }
      
      private function updateChampionImage() : void
      {
         if(playerSelection)
         {
            this.setChampionImage(this.championImage,playerSelection.champion);
         }
         else
         {
            this.clearImage(this.championImage);
         }
      }
      
      private function updateInvitePowersButton() : void
      {
         this.invitePowersButton.setVisible(_model.localPlayerSelection.isCaptain && !playerSelection.isCaptain && playerSelection.isInvitedPlayer && !playerSelection.isSolo() && _model.getShowInvitePowersButton());
      }
      
      private function updateCaptainIcon() : void
      {
         if(playerSelection)
         {
            this.captainIcon.setVisible(playerSelection.isCaptain);
         }
         else
         {
            this.captainIcon.setVisible(false);
         }
      }
      
      protected function handleDropdownSelection() : void
      {
         this._soundProvider.play(CapAudioKeys.CAP_DROP_DOWN_SELECT);
      }
      
      private function updateInviteeSettingUpIndicators() : void
      {
         var _loc1_:Boolean = false;
         if(playerSelection)
         {
            _loc1_ = !playerSelection.isCaptain && playerSelection.isInvitedPlayer && (!playerSelection.role || !playerSelection.position || !playerSelection.champion);
            this.settingUpSpinner.setVisible(_loc1_);
            this.settingUpText.setVisible(_loc1_);
         }
      }
      
      private function handleAdvertisedRoleSelected() : void
      {
         _viewMediator.currentState.handleAdvertisedRoleSelected(this.roleDropdown.getSelectionBehavior().getSelectedItem() as CapRole,playerSelection);
      }
      
      private function updateAcceptDeclineButtons() : void
      {
         var _loc1_:Boolean = CapFlowUtil.isCaptain(_model) && playerSelection.isCandidate;
         this.acceptButton.setVisible(_loc1_);
         this.acceptButton.setEnabled(_loc1_);
         this.declineButton.setVisible(_loc1_);
         this.declineButton.setEnabled(_loc1_);
      }
      
      private function setChampionImage(param1:SpriteProxy, param2:Champion) : void
      {
         var _loc3_:BitmapData = null;
         var _loc4_:Bitmap = null;
         if(param2)
         {
            _loc3_ = ChampionIconCacheUtil.instance.getIcon(param2.skinName);
            _loc4_ = new Bitmap(_loc3_);
            _loc4_.width = CHAMPION_IMAGE_WIDTH;
            _loc4_.height = CHAMPION_IMAGE_HEIGHT;
            _loc4_.x = CHAMPION_IMAGE_PADDING_LEFT;
            _loc4_.y = CHAMPION_IMAGE_PADDING_TOP;
            this.setImage(param1,_loc4_);
         }
         else
         {
            this.clearImage(param1);
         }
      }
      
      private function updateSpell1Image() : void
      {
         if(playerSelection)
         {
            this.setSpellImage(this.spell1Image,playerSelection.spell1);
         }
         else
         {
            this.clearImage(this.spell1Image);
         }
      }
      
      override protected function updateState() : void
      {
         super.updateState();
         if(playerSelection)
         {
            if(!getCurrentState() && playerSelection.currentState == CapPlayerSelection.CHOOSE_ROLE_STATE)
            {
               setCurrentState(CapPlayerSelection.FIND_PLAYERS_STATE);
            }
            setCurrentState(playerSelection.currentState);
            this.updatePromptText(playerSelection.currentState);
         }
         invalidateLayout();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         return new Rectangle(0,0,this._sizer.getWidth(),this._sizer.getHeight());
      }
      
      private function updatePromptText(param1:String) : void
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case CapPlayerSelection.INTRO_STATE:
               _loc2_ = CapLocaleUtil.getResourceString("gf_teammate_prompt_group_requires_friend","Group requries at least one friend");
               break;
            case CapPlayerSelection.CHOOSE_ROLE_STATE:
            case CapPlayerSelection.CHOSEN_ROLE_STATE:
               _loc2_ = CapLocaleUtil.getResourceString("gf_teammate_prompt_select_role_and_position","Select Position and Role");
               break;
            case CapPlayerSelection.FIND_PLAYERS_STATE:
               this.updateInviteText();
               break;
            case CapPlayerSelection.SEARCHING_STATE:
               _loc2_ = CapLocaleUtil.getResourceString("gf_teammate_prompt_searching_for_solo","Searching For:");
               break;
            case CapPlayerSelection.FOUND_STATE:
               _loc2_ = CapLocaleUtil.getResourceString("gf_teammate_prompt_player_found","Player Found:");
               break;
            case CapPlayerSelection.PENALTY_STATE:
               _loc2_ = CapLocaleUtil.getResourceString("gf_teammate_prompt_player_kicked","Player Kicked");
               break;
            case CapPlayerSelection.CAPTAIN_SPECCING_STATE:
               _loc2_ = CapLocaleUtil.getResourceString("gf_teammate_prompt_captain_speccing","Captain Selecting Role and Position:");
         }
         this.promptText.setText(_loc2_);
      }
      
      private function handleAdvertisedPositionSelected() : void
      {
         _viewMediator.currentState.handleAdvertisedPositionSelected(this.positionDropdown.getSelectionBehavior().getSelectedItem() as CapPosition,playerSelection);
      }
      
      private function updateInviteText() : void
      {
         var _loc1_:Boolean = this._inviteGroup.getPendingParticipantCount() != 0;
         this.pendingSpinner.setVisible(_loc1_);
         this.pendingText.setVisible(_loc1_);
         this.pendingText.setText(CapLocaleUtil.getResourceString("gf_pending_invites_label",this._inviteGroup.getPendingParticipantCount() + " pending...",[this._inviteGroup.getPendingParticipantCount()]));
      }
      
      private function handleDeclineClick(param1:MouseEvent) : void
      {
         this._soundProvider.play(CapAudioKeys.CAP_DECLINE_CANDIDATE_CLICK);
         this._controller.declineCandidate(playerSelection.slotId,this.updateAcceptDeclineButtons);
      }
      
      private function updateReadyToSpecSolos() : void
      {
         if(playerSelection)
         {
            if(this._readyToSpecCandidatesObserver.isOccurring)
            {
               assignToolTip(this.specSolosButton,CapLocaleUtil.getResourceString("gf_button_spec_solos_tooltip","Find random players for positions and roles you choose..."));
            }
            else
            {
               assignToolTip(this.specSolosButton,CapLocaleUtil.getResourceString("gf_button_spec_solos_unavailable_tooltip","Not available until everyone is ready"));
            }
            this.specSolosButton.setEnabled(this._readyToSpecCandidatesObserver.isOccurring);
         }
         else
         {
            this.specSolosButton.setEnabled(false);
            unassignToolTip(this.specSolosButton);
         }
         this.specSolosButton.setMouseEnabled(true);
      }
      
      private function updatePenaltyTmer() : void
      {
         this.penaltyTimerText.setText(String(playerSelection.penaltyTimeInSeconds));
      }
      
      private function updateErrorText() : void
      {
         var _loc1_:Boolean = playerSelection.errorText != null && playerSelection.errorText != "";
         this.errorPanel.setVisible(_loc1_);
         this.errorText.setText(_loc1_ ? playerSelection.errorText : "");
      }
      
      private function updateRoleAndPositionText() : void
      {
         var _loc1_:CapRole = null;
         if(playerSelection)
         {
            _loc1_ = playerSelection.role != null ? playerSelection.role : playerSelection.advertisedRole;
            this.roleAndPositionText.setText(this.formatRoleAndPositionText(_loc1_,playerSelection.position));
            this.updateInviteeSettingUpIndicators();
         }
         else
         {
            this.roleAndPositionText.setText("");
         }
      }
      
      private function updateGlowEffectVisibility() : void
      {
         if(UserPreferencesManager.userPrefs.enableAnimations)
         {
            this._glowEffects.setCurrentState("animationsEnabled");
         }
         else
         {
            this._glowEffects.setCurrentState("animationsDisabled");
         }
      }
      
      private function handleKickClick(param1:MouseEvent) : void
      {
         this._controller.kickPlayer(playerSelection);
      }
      
      private function formatRoleAndPositionText(param1:CapRole, param2:CapPosition) : String
      {
         var _loc3_:String = "";
         var _loc4_:String = "";
         var _loc5_:String = "";
         if(param2)
         {
            _loc5_ += param2.name;
         }
         if(param1)
         {
            if(param2)
            {
               _loc5_ += " ";
               _loc5_ = _loc5_ + CapLocaleUtil.getResourceString("gf_role_position_teammate_delimiter","/");
               _loc5_ = _loc5_ + " ";
            }
            _loc5_ += param1.name;
         }
         return _loc5_;
      }
      
      private function renderAcceptedCandidate() : void
      {
         playerSelection.timeToApprove = -1;
         this.acceptDeclineButtonsContainer.setCurrentState(ACCEPT_DECLINE_BUTTONS_CONTAINER_THINKING_STATE);
      }
      
      private function updateSummonerNameText() : void
      {
         if(playerSelection)
         {
            this.summonerNameText.setText(playerSelection.summonerName);
         }
         else
         {
            this.summonerNameText.setText("");
         }
      }
      
      private function handleInviteClick(param1:MouseEvent) : void
      {
         _viewMediator.currentState.handleInviteButtonClicked(this.inviteButton);
      }
      
      private function updateKickButton() : void
      {
         this.kickButton.setVisible(_model.kickEnabled && CapFlowUtil.isCaptain(_model) && playerSelection.isSolo());
      }
      
      private function handleSpecSolosClick(param1:MouseEvent) : void
      {
         _viewMediator.currentState.handleSpecSolosClicked(this.specSolosButton);
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this._controller = getDependency(CapController);
         _viewMediator = getDependency(CapViewMediator);
         this._readyToSpecCandidatesObserver = getDependency(CaptainAbleToSpecCandidatesObserver);
         this._readyToSpecCandidatesObserver.occurred.add(this.updateReadyToSpecSolos);
         this._inviteGroup = getDependency(InviteGroup);
         this._soundProvider = getDependency(ISoundProvider);
         _model.kickEnabledChanged.add(this.updateKickButton);
         _model.getShowInvitePowersButtonChanged().add(this.updateInvitePowersButton);
      }
      
      override protected function updateChildren() : void
      {
         super.updateChildren();
         this.updateCaptainIcon();
         this.updateSummonerNameText();
         this.updateChampionImage();
         this.updateSpell1Image();
         this.updateSpell2Image();
         this.updateRoleAndPositionText();
         this.updateAcceptDeclineButtons();
         this.updateStatusText();
         this.updateReadyToSpecSolos();
         this.updateErrorText();
         this.updateInviteText();
         this.updateTimeToApproveText();
         this.updateKickButton();
         this.updateInviteeSettingUpIndicators();
         this.updateInvitePowersButton();
      }
      
      override protected function unsubscribeToDataChanges(param1:CapPlayerSelection) : void
      {
         super.unsubscribeToDataChanges(param1);
         param1.visibleChanged.remove(this.updateChildren);
         param1.errorTextChanged.remove(this.updateErrorText);
         param1.rolePositionLockedChanged.remove(this.updateStatusText);
         param1.isReadyChanged.remove(this.updateStatusText);
         param1.currentStateChanged.remove(this.updateState);
         param1.isCaptainChanged.remove(this.updateCaptainIcon);
         param1.summonerNameChanged.remove(this.updateSummonerNameText);
         param1.championChanged.remove(this.updateChampionImage);
         param1.spell1Changed.remove(this.updateSpell1Image);
         param1.spell2Changed.remove(this.updateSpell2Image);
         param1.roleChanged.remove(this.updateRoleAndPositionText);
         param1.advertisedRoleChanged.remove(this.updateRoleAndPositionText);
         param1.positionChanged.remove(this.updateRoleAndPositionText);
         param1.isCandidateChanged.remove(this.updateAcceptDeclineButtons);
         param1.timeToApproveTimeChanged.remove(this.updateTimeToApproveText);
         param1.isSoloChanged.remove(this.updateKickButton);
         param1.penaltyTimeInSecondsChanged.remove(this.updatePenaltyTmer);
         param1.isInvitedPlayerChanged.remove(this.updateInviteeSettingUpIndicators);
         param1.isCaptainChanged.remove(this.updateInvitePowersButton);
         param1.isInvitedPlayerChanged.remove(this.updateInvitePowersButton);
         param1.isSoloChanged.remove(this.updateInvitePowersButton);
      }
      
      private function updateStatusText() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         if(playerSelection)
         {
            _loc1_ = !playerSelection.rolePositionLocked && !playerSelection.isReady;
            _loc2_ = playerSelection.isReady;
            if(_loc1_)
            {
               this.statusText.setVisible(true);
               this.statusText.setText(CapLocaleUtil.getResourceString("gf_player_status_setting_up","Setting up..."));
            }
            else if(_loc2_)
            {
               this.statusText.setVisible(true);
               this.statusText.setText(CapLocaleUtil.getResourceString("gf_player_status_ready","Ready!"));
            }
            else
            {
               this.statusText.setVisible(false);
            }
         }
         else
         {
            this.statusText.setVisible(false);
         }
      }
      
      protected function handleDropdownOpenChanged(param1:DropDown, param2:Boolean) : void
      {
         if(param2)
         {
            this._soundProvider.play(CapAudioKeys.CAP_DROP_DOWN_OPEN);
         }
      }
      
      private function updateSpell2Image() : void
      {
         if(playerSelection)
         {
            this.setSpellImage(this.spell2Image,playerSelection.spell2);
         }
         else
         {
            this.clearImage(this.spell2Image);
         }
      }
      
      override public function destroy() : void
      {
         UserPrefs.enableAnimationsChanged.remove(this.onEnableAnimationsChanged);
         this._inviteGroup.getInvitedParticipantsChangedSignal().remove(this.updateInviteText);
         this.kickButton.removeEventListener(MouseEvent.CLICK,this.handleKickClick);
         _model.kickEnabledChanged.remove(this.updateKickButton);
         _model.getShowInvitePowersButtonChanged().remove(this.updateInvitePowersButton);
         this.roleDropdownRendererFactory.destroy();
         this.positionDropdownRendererFactory.destroy();
         unassignToolTip(this.specSolosButton);
         unassignToolTip(this.kickButton);
         unassignToolTip(this.acceptButton);
         unassignToolTip(this.declineButton);
         unassignToolTip(this.timeToApproveText);
         this.errorPanel.destroy();
         this.inviteButton.destroy();
         this.championImage.destroy();
         this.summonerNameText.destroy();
         this.roleAndPositionText.destroy();
         this.spell1Image.destroy();
         this.spell2Image.destroy();
         this.statusText.destroy();
         this.captainIcon.destroy();
         this.acceptButton.destroy();
         this.declineButton.destroy();
         this.kickButton.destroy();
         this.roleDropdown.destroy();
         this.positionDropdown.destroy();
         this.pendingSpinner.destroy();
         this.pendingText.destroy();
         this.promptText.destroy();
         this._glowEffects.destroy();
         super.destroy();
      }
   }
}

