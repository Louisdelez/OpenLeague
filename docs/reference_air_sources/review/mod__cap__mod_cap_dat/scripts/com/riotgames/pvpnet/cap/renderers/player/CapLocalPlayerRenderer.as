package com.riotgames.pvpnet.cap.renderers.player
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.button.LabelButtonX;
   import blix.components.dropdown.DropDown;
   import blix.components.list.RendererFactory;
   import blix.components.timeline.StatefulView;
   import blix.components.timeline.TimelineAnimation;
   import blix.context.IContext;
   import blix.ds.ListX;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.utils.ChampionIconCacheUtil;
   import com.riotgames.platform.common.utils.app.ApplicationUtil;
   import com.riotgames.platform.gameclient.controllers.game.event.ItemSelectEvent;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.platform.gameclient.domain.SpellBookPageDTO;
   import com.riotgames.platform.gameclient.domain.UserPrefs;
   import com.riotgames.platform.masteries.IMasteriesProvider;
   import com.riotgames.platform.masteries.objects.MasteryPageInfoSummary;
   import com.riotgames.pvpnet.cap.audio.CapAudioKeys;
   import com.riotgames.pvpnet.cap.controllers.ICapController;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.CapPosition;
   import com.riotgames.pvpnet.cap.model.CapRole;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.renderers.dropdown.CapDropdownRenderer;
   import com.riotgames.pvpnet.cap.renderers.dropdown.CapRoleDropdownItemRenderer;
   import com.riotgames.pvpnet.cap.states.CapViewState;
   import com.riotgames.pvpnet.cap.states.common.CapFinishedSelfSpecState;
   import com.riotgames.pvpnet.cap.states.common.CapFullGroupState;
   import com.riotgames.pvpnet.cap.util.CapFlowUtil;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.pvpnet.cap.util.CapModelUtil;
   import com.riotgames.pvpnet.cap.views.popups.CapEditMasteriesPopup;
   import com.riotgames.pvpnet.cap.views.popups.CapSpellSelectionView;
   import com.riotgames.pvpnet.cap.views.popups.champselect.CapClassicChampSelectPopup;
   import com.riotgames.pvpnet.cap.views.spells.CapSpellSelectionViewBase;
   import com.riotgames.pvpnet.cap.views.tooltips.CapMasteriesDescriptionTooltip;
   import com.riotgames.pvpnet.cap.views.tooltips.CapRoleDescriptionTooltip;
   import com.riotgames.pvpnet.cap.views.tooltips.CapRuneDescriptionTooltip;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.rust.data.ListAdapter;
   import com.riotgames.rust.popup.PopUpManager;
   import flash.display.Bitmap;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import mx.collections.ArrayCollection;
   import mx.events.CollectionEvent;
   
   public class CapLocalPlayerRenderer extends CapPlayerRendererBase
   {
      
      private var _masteryPageEditButton:ButtonX;
      
      protected var _selectChampionButton:LabelButtonX;
      
      private var _roleSelected:Signal = new Signal();
      
      private var _championText:TextFieldProxy;
      
      private var _runeDropdownRendererFactory:RendererFactory;
      
      protected var _soundProvider:ISoundProvider;
      
      private var _roleText:TextFieldProxy;
      
      private var _summonerNameText:TextFieldProxy;
      
      protected var _controller:ICapController;
      
      private var _masteryDropdownRendererFactory:RendererFactory;
      
      private var _positionSelected:Signal = new Signal();
      
      private var _runePageEditButton:ButtonX;
      
      private var _masteryDropdown:DropDown;
      
      private var _runesTitleText:TextFieldProxy;
      
      private var _championImageContainer:SpriteProxy;
      
      private var _runeDropdown:DropDown;
      
      private var champSelectPopup:CapClassicChampSelectPopup;
      
      private var _spellsTitleText:TextFieldProxy;
      
      private var _roleDropdownRendererFactory:RendererFactory;
      
      private var _spell2View:CapSpellSelectionViewBase;
      
      private var masteriesPopup:CapEditMasteriesPopup;
      
      private var _championSelected:Signal = new Signal();
      
      private var _roleDropdown:DropDown;
      
      private var _masteriesTitleText:TextFieldProxy;
      
      private var _sizer:SpriteProxy;
      
      protected var _mmaIcon:CapMmaIcon;
      
      private var _changeChampionButton:ButtonX;
      
      private var _captainText:TextFieldProxy;
      
      private var _positionDropdown:DropDown;
      
      private var _positionDropdownRendererFactory:RendererFactory;
      
      private var _roleTitleText:TextFieldProxy;
      
      private var _positionText:TextFieldProxy;
      
      protected var _capModel:CapModel;
      
      private var _statusText:TextFieldProxy;
      
      private var _rolePositionText:TextFieldProxy;
      
      private var _spell1View:CapSpellSelectionViewBase;
      
      private var _glowEffects:StatefulView;
      
      private var _positionTitleText:TextFieldProxy;
      
      private var _captainIcon:SpriteProxy;
      
      public function CapLocalPlayerRenderer(param1:IContext)
      {
         super(param1);
         setLinkage("CapLocalPlayerComponent");
         UserPrefs.enableAnimationsChanged.add(this.onEnableAnimationsChanged);
      }
      
      private function setupCaptainIcon() : void
      {
         this._captainIcon = new SpriteProxy(this);
         setTimelineChildByName("captain",this._captainIcon);
      }
      
      override public function destroy() : void
      {
         UserPrefs.enableAnimationsChanged.remove(this.onEnableAnimationsChanged);
         this._capModel.availableChampions.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.handleInventoryChange);
         this._capModel.masteryPagesChanged.remove(this.handleMasteriesChanged);
         this._runeDropdownRendererFactory.destroy();
         this._positionDropdownRendererFactory.destroy();
         this._roleDropdownRendererFactory.destroy();
         this._masteryDropdownRendererFactory.destroy();
         this._selectChampionButton.destroy();
         this._captainText.destroy();
         this._summonerNameText.destroy();
         this._championText.destroy();
         this._roleText.destroy();
         this._positionText.destroy();
         this._rolePositionText.destroy();
         this._roleDropdown.destroy();
         this._positionDropdown.destroy();
         this._masteryDropdown.destroy();
         this._runeDropdown.destroy();
         this._masteryPageEditButton.destroy();
         this._runePageEditButton.destroy();
         this._spell1View.getSpellSelected().remove(this.handleSpell1Selected);
         this._spell1View.getCloseClicked().remove(this.handleSpellViewClosed);
         this._spell2View.getSpellSelected().remove(this.handleSpell2Selected);
         this._spell2View.getCloseClicked().remove(this.handleSpellViewClosed);
         this._spell1View.destroy();
         this._spell2View.destroy();
         this._changeChampionButton.destroy();
         this._championImageContainer.destroy();
         this._roleTitleText.destroy();
         this._positionTitleText.destroy();
         this._statusText.destroy();
         this._captainIcon.destroy();
         this._mmaIcon.destroy();
         this._glowEffects.destroy();
         if(this.masteriesPopup)
         {
            this.hideMasteriesPopup();
         }
         this.hideChampSelectDialog();
         if(getStage())
         {
            getStage().removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         }
         if(this.champSelectPopup)
         {
            this.champSelectPopup.removeEventListener(ItemSelectEvent.SELECT,this.handleChampionSelect);
            this.champSelectPopup.destroy();
         }
         this._roleSelected.removeAll();
         this._championSelected.removeAll();
         this._positionSelected.removeAll();
         super.destroy();
      }
      
      protected function handleMasteriesChanged() : void
      {
         var _loc2_:MasteryPageInfoSummary = null;
         if(!this._masteryDropdown)
         {
            return;
         }
         var _loc1_:ArrayCollection = this._capModel.masteryPages;
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.length)
         {
            _loc2_ = _loc1_.getItemAt(_loc3_) as MasteryPageInfoSummary;
            if(_loc2_.isCurrent)
            {
               this._masteryDropdown.getSelectionBehavior().setSelectedItem(_loc2_,false);
               this._capModel.localPlayerSelection.masteryPage = _loc2_;
               break;
            }
            _loc3_++;
         }
      }
      
      private function handlePositionDropdownSelection() : void
      {
         handlePositionSelected(this._positionDropdown.getSelectionBehavior().getSelectedItem() as CapPosition);
         this._positionSelected.dispatch();
      }
      
      protected function handleSpell1Selected(param1:Spell) : void
      {
         if(_viewMediator.currentState)
         {
            _viewMediator.currentState.handleSpell1Selected(param1);
         }
      }
      
      protected function handleChampionSelect(param1:ItemSelectEvent) : void
      {
         this._championSelected.dispatch();
      }
      
      protected function showEditMasteriesView() : void
      {
         var _loc1_:IMasteriesProvider = null;
         if(!this.masteriesPopup)
         {
            _loc1_ = getDependency(IMasteriesProvider);
            this.masteriesPopup = new CapEditMasteriesPopup(this,_loc1_);
            this.masteriesPopup.setScaleX(ApplicationUtil.application.scaleX);
            this.masteriesPopup.setScaleY(ApplicationUtil.application.scaleY);
         }
         PopUpManager.addPopUp(this.masteriesPopup,null,true);
         this.masteriesPopup.closeClicked.add(this.hideMasteriesPopup);
      }
      
      override protected function subscribeToDataChanges(param1:CapPlayerSelection) : void
      {
         super.subscribeToDataChanges(param1);
         this._capModel.availableChampions.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.handleInventoryChange);
         this._capModel.inMatchmakingQueueChanged.add(this.handleInMatchmakingChanged);
         param1.currentStateChanged.add(this.updateState);
         param1.championChanged.add(this.renderSelectedChampion);
         param1.roleChanged.add(this.renderRoleChanged);
         param1.positionChanged.add(this.renderPositionChanged);
         param1.isReadyChanged.add(this.renderReadyChanged);
         param1.rolePositionLockedChanged.add(this.renderRolePositionLocked);
         param1.masteryPageChanged.add(this.renderMasteryPageChanged);
         param1.runePageChanged.add(this.renderRunePageChanged);
      }
      
      protected function handleSpell2Selected(param1:Spell) : void
      {
         if(_viewMediator.currentState)
         {
            _viewMediator.currentState.handleSpell2Selected(param1);
         }
      }
      
      private function onEnableAnimationsChanged() : void
      {
         this.updateGlowEffectVisibility();
      }
      
      public function hideChampSelectDialog() : void
      {
         if(getStage())
         {
            getStage().removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         }
         this.champSelectPopup.hide();
      }
      
      protected function renderRunePageChanged() : void
      {
         if(Boolean(playerSelection) && Boolean(playerSelection.runePage))
         {
            this._runeDropdown.getSelectionBehavior().getSelectedItemsChanged().remove(this.handleRuneSelected);
            this._runeDropdown.getSelectionBehavior().getSelectedItemsChanged().remove(this.handleDropdownSelection);
            this._runeDropdown.getSelectionBehavior().setSelectedItem(playerSelection.runePage);
            this._runeDropdown.getSelectionBehavior().getSelectedItemsChanged().add(this.handleDropdownSelection);
            this._runeDropdown.getSelectionBehavior().getSelectedItemsChanged().add(this.handleRuneSelected);
         }
      }
      
      private function setSpellButtonsEnabled(param1:Boolean) : void
      {
         this._spell1View.setEnabled(param1);
         this._spell2View.setEnabled(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.setupMmaIcon();
         this.setupCaptainIcon();
         this.setupTextFields();
         this.setupSelections();
         this.setupChampionSelectionButtons();
         this.setupGlowEffects();
         this.handleInventoryChange();
         this._sizer = new SpriteProxy(this);
         setTimelineChildByName("sizer",this._sizer);
         this.initializeView();
         if(getAsset())
         {
            this.invalidateLayoutOnAnimation();
         }
         else
         {
            getAssetChanged().addOnce(this.invalidateLayoutOnAnimation);
         }
      }
      
      protected function handleEditMasteriesClick(param1:MouseEvent) : void
      {
         this._soundProvider.play(CapAudioKeys.CAP_OPEN_WINDOW);
         this.showEditMasteriesView();
      }
      
      protected function renderReadyChanged() : void
      {
         if(playerSelection.isReady)
         {
            setCurrentState("ready");
            this._statusText.setVisible(true);
            this._statusText.setText(CapLocaleUtil.getResourceString("gf_player_status_ready","Ready!"));
         }
         else
         {
            this._statusText.setVisible(false);
         }
      }
      
      override protected function updateState() : void
      {
         super.updateState();
         if(playerSelection)
         {
            setCurrentState(playerSelection.currentState);
         }
      }
      
      protected function handleRuneSelected() : void
      {
         this._controller.selectRunePage(this._runeDropdown.getSelectionBehavior().getSelectedItem() as SpellBookPageDTO);
      }
      
      override protected function set model(param1:CapModel) : void
      {
         _model = param1;
         playerSelection = _model.localPlayerSelection;
      }
      
      protected function hideMasteriesPopup() : void
      {
         if(this.masteriesPopup)
         {
            this.masteriesPopup.closeClicked.remove(this.hideMasteriesPopup);
            PopUpManager.removePopUp(this.masteriesPopup);
            this.masteriesPopup.destroy();
            this.masteriesPopup = null;
         }
      }
      
      public function getPositionSelected() : ISignal
      {
         return this._positionSelected;
      }
      
      public function initializeView() : void
      {
         setCurrentState("intro");
         this._captainIcon.setVisible(_model.localPlayerSelection.isCaptain);
         this.renderRolePositionLocked();
      }
      
      private function handleRoleDropdownSelection() : void
      {
         handleRoleSelected(this._roleDropdown.getSelectionBehavior().getSelectedItem() as CapRole);
         this._roleSelected.dispatch();
      }
      
      protected function handleDropdownSelection() : void
      {
         this._soundProvider.play(CapAudioKeys.CAP_DROP_DOWN_SELECT);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         return new Rectangle(0,0,this._sizer.getWidth(),this._sizer.getHeight());
      }
      
      public function toggleSpecSelectionEnabled(param1:Boolean) : void
      {
         this._roleDropdown.setEnabled(param1);
         this._positionDropdown.setEnabled(param1);
      }
      
      protected function handleSpellViewClosed() : void
      {
         if(_viewMediator.currentState)
         {
            _viewMediator.currentState.handleSpellViewClosed();
         }
      }
      
      private function setupChampionSelectionButtons() : void
      {
         this._selectChampionButton = new LabelButtonX(this);
         setTimelineChildByName("selectChampionButton",this._selectChampionButton);
         this._selectChampionButton.setText(CapLocaleUtil.getResourceString("gf_button_select_champion_label","Select Champion"));
         this._selectChampionButton.addEventListener(MouseEvent.CLICK,this.handleSelectChampionClicked);
         this._selectChampionButton.setEnabled(false);
         this._changeChampionButton = new ButtonX(this);
         setTimelineChildByName("changeChampionButton",this._changeChampionButton);
         this._changeChampionButton.addEventListener(MouseEvent.CLICK,this.handleSelectChampionClicked);
         this._changeChampionButton.getAssetChanged().add(this.renderSelectedChampion);
         this._changeChampionButton.setEnabled(false);
         this._championImageContainer = new SpriteProxy(this);
         this._changeChampionButton.setTimelineChildByName("championImageContainer",this._championImageContainer);
         this.champSelectPopup = getDependency(CapClassicChampSelectPopup);
         this.champSelectPopup.addEventListener(ItemSelectEvent.SELECT,this.handleChampionSelect,false,0,true);
      }
      
      protected function renderMasteryPageChanged() : void
      {
         if(Boolean(playerSelection) && Boolean(playerSelection.masteryPage))
         {
            this._masteryDropdown.getSelectionBehavior().getSelectedItemsChanged().remove(this.handleMasterySelected);
            this._masteryDropdown.getSelectionBehavior().getSelectedItemsChanged().remove(this.handleDropdownSelection);
            this._masteryDropdown.getSelectionBehavior().setSelectedItem(playerSelection.masteryPage);
            this._masteryDropdown.getSelectionBehavior().getSelectedItemsChanged().add(this.handleDropdownSelection);
            this._masteryDropdown.getSelectionBehavior().getSelectedItemsChanged().add(this.handleMasterySelected);
         }
      }
      
      public function getChampionSelected() : ISignal
      {
         return this._championSelected;
      }
      
      private function setupMmaIcon() : void
      {
         this._mmaIcon = new CapMmaIcon(this);
         setTimelineChildByName("mmaIcon",this._mmaIcon);
      }
      
      protected function handleSelectChampionClicked(param1:MouseEvent) : void
      {
         this.showChampSelectDialog();
      }
      
      public function getRoleSelected() : ISignal
      {
         return this._roleSelected;
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
      
      private function handleInMatchmakingChanged() : void
      {
         this.setSpellButtonsEnabled(!this._capModel.inMatchmakingQueue);
      }
      
      private function setupTextFields() : void
      {
         this._captainText = new TextFieldProxy(this);
         setTimelineChildByName("captainTitleText",this._captainText);
         this._captainText.setText(CapLocaleUtil.getResourceString("gf_captain_title","Captain"));
         this._statusText = new TextFieldProxy(this);
         setTimelineChildByName("status",this._statusText);
         this._statusText.setText("");
         this._roleTitleText = new TextFieldProxy(this);
         setTimelineChildByName("roleText",this._roleTitleText);
         this._roleTitleText.setText(CapLocaleUtil.getResourceString("gf_local_player_roles_title_text","Role"));
         this._positionTitleText = new TextFieldProxy(this);
         setTimelineChildByName("laneText",this._positionTitleText);
         this._positionTitleText.setText(CapLocaleUtil.getResourceString("gf_local_player_positions_title_text","Position"));
         this._spellsTitleText = new TextFieldProxy(this);
         setTimelineChildByName("spellsText",this._spellsTitleText);
         this._spellsTitleText.setText(CapLocaleUtil.getResourceString("gf_local_player_spells_title_text","Spells"));
         this._runesTitleText = new TextFieldProxy(this);
         setTimelineChildByName("runesText",this._runesTitleText);
         this._runesTitleText.setText(CapLocaleUtil.getResourceString("gf_local_player_runes_title_text","Runes"));
         this._masteriesTitleText = new TextFieldProxy(this);
         setTimelineChildByName("masteriesText",this._masteriesTitleText);
         this._masteriesTitleText.setText(CapLocaleUtil.getResourceString("gf_local_player_masteries_title_text","Masteries"));
         this._summonerNameText = new TextFieldProxy(this);
         setTimelineChildByName("summonerNameText",this._summonerNameText);
         this._summonerNameText.setText(_model.summoner.name);
         this._rolePositionText = new TextFieldProxy(this);
         setTimelineChildByName("rolePositionText",this._rolePositionText);
         this._rolePositionText.setText("");
         this._championText = new TextFieldProxy(this);
         setTimelineChildByName("championText",this._championText);
         this._championText.setText("");
         this._roleText = new TextFieldProxy(this);
         setTimelineChildByName("yourRoleText",this._roleText);
         this._positionText = new TextFieldProxy(this);
         setTimelineChildByName("yourLaneText",this._positionText);
      }
      
      private function setupSelections() : void
      {
         var _loc1_:ListX = new ListX(_model.selectableRoles);
         this._roleDropdown = new DropDown(this);
         this._roleDropdownRendererFactory = new RendererFactory(CapRoleDropdownItemRenderer,[this,"CapRoleDropDownItemRenderer","name",CapRoleDescriptionTooltip]);
         this._roleDropdown.setRendererFactory(this._roleDropdownRendererFactory);
         this._roleDropdown.setListLinkage("DataGroupDropdownList");
         this._roleDropdown.setDataProvider(_loc1_);
         this._roleDropdown.getSelectionBehavior().getSelectedItemsChanged().add(this.handleRoleDropdownSelection);
         this._roleDropdown.setLabelField("name");
         this._roleDropdown.setNoneSelectedLabel(CapLocaleUtil.getResourceString("gf_dropdown_role_initial_label","Select role..."));
         setTimelineChildByName("roleDropDown",this._roleDropdown);
         this._roleDropdown.getSelectedChanged().add(this.handleDropdownOpenChanged);
         this._roleDropdown.getSelectionBehavior().getSelectedItemsChanged().add(this.handleDropdownSelection);
         var _loc2_:ListX = new ListX(_model.positions);
         this._positionDropdown = new DropDown(this);
         this._positionDropdownRendererFactory = new RendererFactory(CapDropdownRenderer,[this]);
         this._positionDropdown.setRendererFactory(this._positionDropdownRendererFactory);
         this._positionDropdown.setListLinkage("DataGroupDropdownList");
         this._positionDropdown.setDataProvider(_loc2_);
         this._positionDropdown.getSelectionBehavior().getSelectedItemsChanged().add(this.handlePositionDropdownSelection);
         this._positionDropdown.setLabelField("name");
         this._positionDropdown.setNoneSelectedLabel(CapLocaleUtil.getResourceString("gf_dropdown_position_initial_label","Select position..."));
         setTimelineChildByName("laneDropDown",this._positionDropdown);
         this._positionDropdown.getSelectedChanged().add(this.handleDropdownOpenChanged);
         this._positionDropdown.getSelectionBehavior().getSelectedItemsChanged().add(this.handleDropdownSelection);
         var _loc3_:ListAdapter = new ListAdapter(this._capModel.runePages);
         this._runeDropdown = new DropDown(this);
         this._runeDropdownRendererFactory = new RendererFactory(CapDropdownRenderer,[this,"CapDropDownItemRenderer","name",CapRuneDescriptionTooltip]);
         this._runeDropdown.setRendererFactory(this._runeDropdownRendererFactory);
         this._runeDropdown.setListLinkage("DataGroupDropdownList");
         this._runeDropdown.setDataProvider(_loc3_);
         this._runeDropdown.setLabelField("name");
         this._runeDropdown.setNoneSelectedLabel(CapLocaleUtil.getResourceString("gf_dropdown_rune_initial_label","Rune set..."));
         this._runeDropdown.getSelectionBehavior().getSelectedItemsChanged().add(this.handleRuneSelected);
         setTimelineChildByName("runeDropDown",this._runeDropdown);
         this._runeDropdown.getSelectedChanged().add(this.handleDropdownOpenChanged);
         this._runeDropdown.getSelectionBehavior().getSelectedItemsChanged().add(this.handleDropdownSelection);
         var _loc4_:ListAdapter = new ListAdapter(this._capModel.masteryPages);
         this._masteryDropdown = new DropDown(this);
         this._masteryDropdownRendererFactory = new RendererFactory(CapDropdownRenderer,[this,"CapDropDownItemRenderer","pageName",CapMasteriesDescriptionTooltip]);
         this._masteryDropdown.setRendererFactory(this._masteryDropdownRendererFactory);
         this._masteryDropdown.setListLinkage("DataGroupDropdownList");
         this._masteryDropdown.setDataProvider(_loc4_);
         this._masteryDropdown.setLabelField("pageName");
         this._masteryDropdown.setNoneSelectedLabel(CapLocaleUtil.getResourceString("gf_dropdown_mastery_initial_label","Mastery page..."));
         this._masteryDropdown.getSelectionBehavior().getSelectedItemsChanged().add(this.handleMasterySelected);
         setTimelineChildByName("masteriesDropDown",this._masteryDropdown);
         this._masteryDropdown.getSelectedChanged().add(this.handleDropdownOpenChanged);
         this._masteryDropdown.getSelectionBehavior().getSelectedItemsChanged().add(this.handleDropdownSelection);
         this._spell1View = new CapSpellSelectionView(this,1);
         this._spell1View.getSpellSelected().add(this.handleSpell1Selected,true);
         this._spell1View.getCloseClicked().add(this.handleSpellViewClosed);
         setTimelineChildByName("spell1Icon",this._spell1View);
         this._spell2View = new CapSpellSelectionView(this,2);
         this._spell2View.getSpellSelected().add(this.handleSpell2Selected,true);
         this._spell2View.getCloseClicked().add(this.handleSpellViewClosed);
         setTimelineChildByName("spell2Icon",this._spell2View);
         this._runePageEditButton = new ButtonX(this);
         setTimelineChildByName("editRunesButton",this._runePageEditButton);
         this._masteryPageEditButton = new ButtonX(this);
         this._masteryPageEditButton.addEventListener(MouseEvent.CLICK,this.handleEditMasteriesClick,false,0,true);
         setTimelineChildByName("editMasteriesButton",this._masteryPageEditButton);
      }
      
      public function showChampSelectDialog() : void
      {
         this._soundProvider.play(CapAudioKeys.CAP_OPEN_WINDOW);
         if(this.championSelectionIsEnabled())
         {
            this.champSelectPopup.championSelectionEnabled = true;
         }
         else
         {
            this.champSelectPopup.viewstackSelectedIndex = CapClassicChampSelectPopup.SKIN_SELECT_INDEX;
            this.champSelectPopup.championSelectionEnabled = false;
         }
         this.champSelectPopup.show();
         getStage().addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown,false,0,true);
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.charCode == Keyboard.ESCAPE)
         {
            this.hideChampSelectDialog();
         }
      }
      
      protected function handleMasterySelected() : void
      {
         this._controller.selectMasteryPage(this._masteryDropdown.getSelectionBehavior().getSelectedItem() as MasteryPageInfoSummary);
      }
      
      private function championSelectionIsEnabled() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:CapViewState = _viewMediator.currentState;
         if(_loc2_ is CapFinishedSelfSpecState)
         {
            _loc1_ = true;
         }
         if(CapFlowUtil.isSolo(_model) && !CapFlowUtil.isInAGroup(_model))
         {
            _loc1_ = true;
         }
         if(CapModelUtil.isFullPremadeGroup(_model) && _loc2_ is CapFullGroupState && !playerSelection.isReady)
         {
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this._capModel = getDependency(CapModel);
         this._capModel.availableChampions.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.handleInventoryChange);
         this._capModel.masteryPagesChanged.add(this.handleMasteriesChanged);
         this._controller = getDependency(ICapController);
         this._soundProvider = getDependency(ISoundProvider);
         if(_viewMediator == null)
         {
            throw new Error("Unable to create component - no view mediator found");
         }
      }
      
      protected function renderRolePositionLocked() : void
      {
         this.toggleSpecSelectionEnabled(!playerSelection.rolePositionLocked);
      }
      
      private function invalidateLayoutOnAnimation() : void
      {
         if(!getAsset())
         {
            return;
         }
         var _loc1_:TimelineAnimation = getTransitionAnimation("champ_selected","lane_selected",false);
         if(_loc1_)
         {
            _loc1_.getTransitionProgressed().add(this.onTransitionProgress);
         }
      }
      
      private function onTransitionProgress() : void
      {
         invalidateLayout();
      }
      
      protected function handleInventoryChange(param1:CollectionEvent = null) : void
      {
         var _loc2_:Boolean = _model.availableChampions != null && _model.availableChampions.length > 0;
         this._changeChampionButton.setEnabled(_loc2_);
         this._selectChampionButton.setEnabled(_loc2_);
         this.toggleSpecSelectionEnabled(_loc2_);
      }
      
      override protected function updateChildren() : void
      {
         super.updateChildren();
         this.renderRolePositionLocked();
         this.renderReadyChanged();
         this.renderSelectedChampion();
         this.handleInventoryChange();
         this.renderRoleChanged();
         this.renderPositionChanged();
         this.renderMasteryPageChanged();
         this.renderRunePageChanged();
      }
      
      protected function renderSelectedChampion() : void
      {
         this._championImageContainer.removeAllChildren();
         if(_model.localPlayerSelection.champion == null)
         {
            return;
         }
         var _loc1_:Bitmap = new Bitmap(ChampionIconCacheUtil.instance.getIcon(_model.localPlayerSelection.champion.skinName));
         _loc1_.width = this._changeChampionButton.getWidth();
         _loc1_.height = this._changeChampionButton.getHeight();
         var _loc2_:BitmapProxy = new BitmapProxy(this,_loc1_);
         this._championImageContainer.addChild(_loc2_);
         _loc2_.setSmoothing(true);
         this._championText.setText(_model.localPlayerSelection.champion.displayName);
      }
      
      protected function renderRoleChanged() : void
      {
         if(Boolean(playerSelection) && Boolean(playerSelection.role))
         {
            this._roleText.setText(playerSelection.role.name);
            this._roleDropdown.getSelectionBehavior().getSelectedItemsChanged().remove(this.handleRoleDropdownSelection);
            this._roleDropdown.getSelectionBehavior().getSelectedItemsChanged().remove(this.handleDropdownSelection);
            this._roleDropdown.getDropDownList().getDataScroller().getSelectionBehavior().setSelectedItem(playerSelection.role);
            this._roleDropdown.getSelectionBehavior().getSelectedItemsChanged().add(this.handleDropdownSelection);
            this._roleDropdown.getSelectionBehavior().getSelectedItemsChanged().add(this.handleRoleDropdownSelection);
         }
         else
         {
            this._roleText.setText("");
         }
      }
      
      protected function handleDropdownOpenChanged(param1:DropDown, param2:Boolean) : void
      {
         if(param2)
         {
            this._soundProvider.play(CapAudioKeys.CAP_DROP_DOWN_OPEN);
         }
      }
      
      override protected function unsubscribeToDataChanges(param1:CapPlayerSelection) : void
      {
         super.unsubscribeToDataChanges(param1);
         this._capModel.availableChampions.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.handleInventoryChange);
         this._capModel.inMatchmakingQueueChanged.remove(this.handleInMatchmakingChanged);
         param1.currentStateChanged.remove(this.updateState);
         param1.championChanged.remove(this.renderSelectedChampion);
         param1.roleChanged.remove(this.renderRoleChanged);
         param1.isReadyChanged.remove(this.renderReadyChanged);
         param1.rolePositionLockedChanged.remove(this.renderRolePositionLocked);
         param1.masteryPageChanged.remove(this.renderMasteryPageChanged);
         param1.runePageChanged.remove(this.renderRunePageChanged);
      }
      
      protected function renderPositionChanged() : void
      {
         if(Boolean(playerSelection) && Boolean(playerSelection.position))
         {
            this._positionText.setText(playerSelection.position.name);
            this._positionDropdown.getSelectionBehavior().getSelectedItemsChanged().remove(this.handlePositionDropdownSelection);
            this._positionDropdown.getSelectionBehavior().getSelectedItemsChanged().remove(this.handleDropdownSelection);
            this._positionDropdown.getDropDownList().getDataScroller().getSelectionBehavior().setSelectedItem(playerSelection.position);
            this._positionDropdown.getSelectionBehavior().getSelectedItemsChanged().add(this.handlePositionDropdownSelection);
            this._positionDropdown.getSelectionBehavior().getSelectedItemsChanged().add(this.handleDropdownSelection);
         }
         else
         {
            this._positionText.setText("");
         }
      }
      
      private function setupGlowEffects() : void
      {
         this._glowEffects = new StatefulView(this);
         setTimelineChildByName("glowEffects",this._glowEffects);
         this.updateGlowEffectVisibility();
      }
   }
}

