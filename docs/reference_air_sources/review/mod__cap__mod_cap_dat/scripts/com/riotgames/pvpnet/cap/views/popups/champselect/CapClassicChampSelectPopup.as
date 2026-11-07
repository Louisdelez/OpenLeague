package com.riotgames.pvpnet.cap.views.popups.champselect
{
   import blix.IDestructible;
   import blix.action.IAction;
   import blix.context.IContext;
   import com.riotgames.platform.common.components.controls.TextInput;
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.common.provider.SoundProviderProxy;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.common.utils.app.ApplicationUtil;
   import com.riotgames.platform.gameclient.controllers.game.controllers.AdvancedToolTipManager;
   import com.riotgames.platform.gameclient.controllers.game.enums.MenuStates;
   import com.riotgames.platform.gameclient.controllers.game.event.ChampionSelectionEvent;
   import com.riotgames.platform.gameclient.controllers.game.event.ItemSelectEvent;
   import com.riotgames.platform.gameclient.controllers.game.model.ParticipantChampionListView;
   import com.riotgames.platform.gameclient.controllers.game.model.PlayerSelection;
   import com.riotgames.platform.gameclient.controllers.game.views.ChampionSkinSelector;
   import com.riotgames.platform.gameclient.controllers.game.views.ChampionSummaryView;
   import com.riotgames.platform.gameclient.controllers.game.views.ChampionTooltip;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.ChampionSkin;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import com.riotgames.platform.gameclient.domain.IChampionFilter;
   import com.riotgames.platform.gameclient.domain.game.ParticipantChampionSelection;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfig;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfigManager;
   import com.riotgames.pvpnet.cap.audio.CapAudioKeys;
   import com.riotgames.pvpnet.cap.championselection.classic.views.CapChampionGrid;
   import com.riotgames.pvpnet.cap.controllers.ICapController;
   import com.riotgames.pvpnet.cap.mediators.CapViewMediator;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.observers.ClassicChampionAvailableObserver;
   import com.riotgames.pvpnet.cap.observers.IObserver;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.pvpnet.cap.util.CapModelUtil;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.containers.ViewStack;
   import mx.controls.Button;
   import mx.core.UIComponent;
   import mx.managers.PopUpManager;
   
   public class CapClassicChampSelectPopup extends UIComponent implements IDestructible
   {
      
      public static const CHAMPION_SELECT_INDEX:int = 0;
      
      public static const SKIN_SELECT_INDEX:int = 1;
      
      private static const DETAILS_DELAY:int = 400;
      
      private static const SUMMARY_VIEW_WIDTH:int = 1260;
      
      private static const VIEWSTACK_X:int = 268;
      
      private static const VIEWSTACK_Y:int = 167;
      
      private static const VIEWSTACK_WIDTH:int = 723;
      
      private static const VIEWSTACK_HEIGHT:int = 272;
      
      private static const TOOLTIP_X:int = 1015;
      
      private static const TOOLTIP_Y:int = 112;
      
      private static const VERTICAL_GAP:int = 192;
      
      private static const PADDING_TOP:int = 110;
      
      private static const CHAMPION_BUTTON_X:int = 276;
      
      private static const CHAMPION_BUTTON_Y:int = 115;
      
      private static const SKIN_BUTTON_X:int = 394;
      
      private static const SKIN_BUTTON_Y:int = 115;
      
      private static const SKIN_SELECTOR_X_OFFSET:int = 50;
      
      private static const CONFIRM_BUTTON_WIDTH:int = 180;
      
      private static const CONFIRM_BUTTON_HEIGHT:int = 50;
      
      private static const CONFIRM_BUTTON_X:int = 818;
      
      private static const CONFIRM_BUTTON_Y:int = 460;
      
      private static const FILTER_PADDING_TOP:int = 9;
      
      private static const FILTER_PADDING_RIGHT:int = 5;
      
      private var viewstack:ViewStack;
      
      private var filterTextInput:TextInput;
      
      private var championObservers:Array = [];
      
      private var skinButton:UIComponent;
      
      private var confirmButton:Button;
      
      private var currentSound:IAction;
      
      private var inventoryController:IInventoryController;
      
      private var controller:ICapController;
      
      private var model:CapModel;
      
      private var context:IContext;
      
      private var championSelectionEnabledChanged:Boolean = false;
      
      private var dataProvider:ParticipantChampionListView;
      
      private var selectedSkin:ChampionSkin;
      
      private var tabNavigator:cs_mainMenu;
      
      private var viewMediator:CapViewMediator;
      
      private var championSummaryView:ChampionSummaryView;
      
      private var championGrid:CapChampionGrid;
      
      private var _viewstackSelectedIndex:int = 0;
      
      private var rollOverTimer:Timer;
      
      private var viewstackSelectedIndexChanged:Boolean = false;
      
      private var currentParticipant:ParticipantChampionSelection;
      
      private var championButton:UIComponent;
      
      private var skinSelector:ChampionSkinSelector;
      
      private var _championSelectionEnabled:Boolean = true;
      
      public function CapClassicChampSelectPopup(param1:IContext)
      {
         super();
         this.context = param1;
         this.model = param1.getDependency(CapModel);
         this.model.localPlayerSelection.skinChanged.add(this.handleSkinChanged);
         this.model.localPlayerSelection.championChanged.add(this.handleChampionChanged);
         this.inventoryController = param1.getDependency(IInventoryController);
         this.viewMediator = param1.getDependency(CapViewMediator);
         this.controller = param1.getDependency(ICapController);
      }
      
      protected function playChampionSelectionSound(param1:*) : void
      {
         if(!param1)
         {
            return;
         }
         this.cleanupSound();
         this.currentSound = SoundProviderProxy.instance.playSummonChampionBySkinname(param1.skinName);
      }
      
      private function doFilterClick(param1:Event = null) : void
      {
         this.filterTextInput.text = "";
         this.doFilter();
      }
      
      public function destroy() : void
      {
         this.cleanupSound();
         this.removeChampionListeners();
         this.model.localPlayerSelection.skinChanged.remove(this.handleSkinChanged);
         this.model.localPlayerSelection.championChanged.remove(this.handleChampionChanged);
         this.context = null;
         if(this.filterTextInput)
         {
            this.filterTextInput.removeEventListener(Event.ADDED_TO_STAGE,this.doFilterAddedToStage);
            this.filterTextInput.removeEventListener(MouseEvent.CLICK,this.doFilterClick);
            this.filterTextInput.removeEventListener(Event.REMOVED_FROM_STAGE,this.doFilterRemovedFromStage);
            this.filterTextInput = null;
         }
         if(this.championGrid)
         {
            this.championGrid.removeEventListener(ItemSelectEvent.ROLL_OVER,this.handleChampionRollOver);
            this.championGrid.removeEventListener(ItemSelectEvent.ROLL_OUT,this.handleChampionRollOut);
            this.championGrid.removeEventListener(ItemSelectEvent.SELECT,this.handleChampionSelected);
            this.championGrid = null;
         }
         if(this.skinSelector)
         {
            this.skinSelector.removeEventListener(ChampionSelectionEvent.SKIN_SELECTED,this.handleSkinSelected);
            this.skinSelector = null;
         }
         if(this.championButton)
         {
            this.championButton.removeEventListener(MouseEvent.CLICK,this.handleChampionButtonClick);
            this.championButton = null;
         }
         if(this.skinButton)
         {
            this.skinButton.removeEventListener(MouseEvent.CLICK,this.handleSkinButtonClick);
            this.skinButton = null;
         }
         if(this.confirmButton)
         {
            this.confirmButton.removeEventListener(MouseEvent.CLICK,this.handleConfirmButtonClick);
            this.confirmButton = null;
         }
         if(this.rollOverTimer)
         {
            this.rollOverTimer.stop();
         }
      }
      
      protected function handleChampionButtonClick(param1:MouseEvent) : void
      {
         this.viewstackSelectedIndex = CHAMPION_SELECT_INDEX;
      }
      
      public function show() : void
      {
         var _loc1_:DisplayObject = ApplicationUtil.application as DisplayObject;
         this.scaleX = ApplicationUtil.application.scaleX;
         this.scaleY = ApplicationUtil.application.scaleY;
         PopUpManager.addPopUp(this,_loc1_,true);
         PopUpManager.centerPopUp(this);
      }
      
      private function doFilterRemovedFromStage(param1:Event) : void
      {
         this.filterTextInput.removeEventListener(Event.CHANGE,this.doFilter);
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:ParticipantChampionListView = null;
         super.createChildren();
         if(!this.tabNavigator)
         {
            this.tabNavigator = new cs_mainMenu();
            this.tabNavigator.mainMenu_nameText1.nameTxt.text = RiotResourceLoader.getString("summonerProfile_page_champions");
            this.tabNavigator.mainMenu_nameText2.nameTxt.text = RiotResourceLoader.getString("championOverlay_skinPage_label");
            this.tabNavigator.currentState = MenuStates.MAIN_MENU_STATE_CHAMPS_ACTIVE;
            addChild(this.tabNavigator);
         }
         if(!this.filterTextInput)
         {
            this.filterTextInput = new TextInput();
            this.filterTextInput.setStyle("styleName","standard");
            this.filterTextInput.setStyle("focusAlpha",0);
            this.filterTextInput.setStyle("right","colMiddle:0");
            this.filterTextInput.setStyle("top","rowContent:95");
            this.filterTextInput.setStyle("paddingTop",4);
            this.filterTextInput.tabEnabled = false;
            this.filterTextInput.width = 150;
            this.filterTextInput.height = 32;
            this.filterTextInput.addEventListener(Event.ADDED_TO_STAGE,this.doFilterAddedToStage,false,0,true);
            this.filterTextInput.addEventListener(MouseEvent.CLICK,this.doFilterClick,false,0,true);
            this.filterTextInput.addEventListener(Event.REMOVED_FROM_STAGE,this.doFilterRemovedFromStage,false,0,true);
            addChild(this.filterTextInput);
         }
         if(!this.championGrid)
         {
            this.championGrid = new CapChampionGrid();
            this.championGrid.cacheAsBitmap = true;
            this.championGrid.percentWidth = 100;
            this.championGrid.percentHeight = 100;
            _loc1_ = this.setupDataProvider();
            this.championGrid.dataProvider = _loc1_;
            this.setupChampionListeners(_loc1_);
            this.championGrid.addEventListener(ItemSelectEvent.ROLL_OVER,this.handleChampionRollOver,false,0,true);
            this.championGrid.addEventListener(ItemSelectEvent.ROLL_OUT,this.handleChampionRollOut,false,0,true);
            this.championGrid.addEventListener(ItemSelectEvent.SELECT,this.handleChampionSelected,false,0,true);
         }
         if(!this.skinSelector)
         {
            this.skinSelector = new ChampionSkinSelector();
            this.skinSelector.addEventListener(ChampionSelectionEvent.SKIN_SELECTED,this.handleSkinSelected,false,0,true);
         }
         if(!this.viewstack)
         {
            this.viewstack = new ViewStack();
            this.viewstack.width = VIEWSTACK_WIDTH;
            this.viewstack.height = VIEWSTACK_HEIGHT;
            this.viewstack.addChild(this.championGrid);
            this.viewstack.addChild(this.skinSelector);
            addChild(this.viewstack);
         }
         if(!this.championButton)
         {
            this.championButton = new UIComponent();
            this.championButton.buttonMode = true;
            this.championButton.useHandCursor = true;
            this.championButton.width = 100;
            this.championButton.height = 50;
            this.championButton.graphics.beginFill(0,0);
            this.championButton.graphics.drawRect(0,0,100,50);
            this.championButton.graphics.endFill();
            addChild(this.championButton);
            this.championButton.addEventListener(MouseEvent.CLICK,this.handleChampionButtonClick,false,0,true);
         }
         if(!this.skinButton)
         {
            this.skinButton = new UIComponent();
            this.skinButton.buttonMode = true;
            this.skinButton.useHandCursor = true;
            this.skinButton.width = 100;
            this.skinButton.height = 50;
            this.skinButton.graphics.beginFill(0,0);
            this.skinButton.graphics.drawRect(0,0,100,50);
            this.skinButton.graphics.endFill();
            addChild(this.skinButton);
            this.skinButton.addEventListener(MouseEvent.CLICK,this.handleSkinButtonClick,false,0,true);
         }
         if(!this.championSummaryView)
         {
            this.championSummaryView = new ChampionSummaryView();
            this.championSummaryView.setStyle("backgroundAlpha",1);
            this.championSummaryView.setStyle("borderStyle","none");
            this.championSummaryView.setStyle("styleName","stoneTablet");
            this.championSummaryView.visible = false;
            addChild(this.championSummaryView);
         }
         if(!this.confirmButton)
         {
            this.confirmButton = new Button();
            this.confirmButton.enabled = false;
            this.confirmButton.useHandCursor = false;
            this.confirmButton.width = CONFIRM_BUTTON_WIDTH;
            this.confirmButton.height = CONFIRM_BUTTON_HEIGHT;
            this.confirmButton.x = CONFIRM_BUTTON_X;
            this.confirmButton.y = CONFIRM_BUTTON_Y;
            this.confirmButton.setStyle("styleName","lockInButton");
            this.confirmButton.label = CapLocaleUtil.getResourceString("gf_button_champion_select_next_label","Next");
            this.confirmButton.buttonMode = true;
            this.confirmButton.addEventListener(MouseEvent.CLICK,this.handleConfirmButtonClick,false,0,true);
            addChild(this.confirmButton);
         }
      }
      
      protected function displayChampionOverlays(param1:TimerEvent) : void
      {
         if(this.rollOverTimer)
         {
            this.rollOverTimer.stop();
         }
         this.showChampionOverlays(this.currentParticipant);
      }
      
      public function get championSelectionEnabled() : Boolean
      {
         return this._championSelectionEnabled;
      }
      
      protected function handleChampionRollOut(param1:ItemSelectEvent) : void
      {
         if(this.rollOverTimer)
         {
            this.rollOverTimer.stop();
         }
         this.championSummaryView.visible = false;
         this.championSummaryView.champion = null;
         if(AdvancedToolTipManager.toolTipOpen)
         {
            AdvancedToolTipManager.destroyCurrentToolTip();
         }
      }
      
      protected function handleSkinSelected(param1:ChampionSelectionEvent) : void
      {
         var _loc2_:PlayerSelection = param1.participantChampionSelection;
         var _loc3_:ChampionSkin = _loc2_.selectedSkin;
         if(Boolean(this.selectedSkin) && this.selectedSkin == _loc3_)
         {
            return;
         }
         this.controller.selectSkin(_loc3_);
      }
      
      private function removeChampionListeners() : void
      {
         var _loc1_:ClassicChampionAvailableObserver = null;
         for each(_loc1_ in this.championObservers)
         {
            _loc1_.destroy();
         }
      }
      
      public function get viewstackSelectedIndex() : int
      {
         return this._viewstackSelectedIndex;
      }
      
      private function doFilterAddedToStage(param1:Event) : void
      {
         this.filterTextInput.text = "";
         this.doFilter();
         this.filterTextInput.text = RiotResourceLoader.getString("championSelection_filterbox_label");
         this.filterTextInput.addEventListener(Event.CHANGE,this.doFilter,false,0,true);
      }
      
      public function set championSelectionEnabled(param1:Boolean) : void
      {
         if(this._championSelectionEnabled == param1)
         {
            return;
         }
         this._championSelectionEnabled = param1;
         this.championSelectionEnabledChanged = true;
         invalidateProperties();
      }
      
      protected function handleSkinChanged() : void
      {
         if(this.selectedSkin)
         {
            this.selectedSkin.lastSelected = false;
         }
         this.selectedSkin = this.model.localPlayerSelection.skin;
         if(Boolean(this.selectedSkin) && Boolean(this.selectedSkin.isAvailable()) && !this.selectedSkin.skinDisabled)
         {
            this.selectedSkin.lastSelected = true;
         }
      }
      
      protected function handleChampionChanged() : void
      {
         this.determineIfConfirmButtonIsEnabled();
      }
      
      protected function determineIfConfirmButtonIsEnabled() : void
      {
         var _loc1_:Boolean = false;
         if(this.confirmButton)
         {
            _loc1_ = Boolean(this.model.localPlayerSelection.champion);
            this.confirmButton.enabled = _loc1_;
            this.confirmButton.useHandCursor = _loc1_;
         }
      }
      
      protected function setChampionOnSkinSelector(param1:ParticipantChampionSelection) : void
      {
         var _loc2_:GameParticipant = param1.participant;
         var _loc3_:PlayerSelection = new PlayerSelection(_loc2_);
         var _loc4_:Champion = param1.champion;
         _loc3_.champion = _loc4_;
         if(_loc4_.getCurrentChampionSkin().skinDisabled)
         {
            _loc4_.setCurrentChampionSkin(_loc4_.defaultSkin.skinId);
         }
         else
         {
            _loc3_.selectedSkin = _loc4_.getCurrentChampionSkin();
         }
         this.skinSelector.playerSelection = _loc3_;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(Boolean(this.viewstack) && this.viewstackSelectedIndexChanged)
         {
            this.viewstack.selectedIndex = this.viewstackSelectedIndex;
            if(this.tabNavigator)
            {
               if(this.viewstackSelectedIndex == CHAMPION_SELECT_INDEX)
               {
                  this.tabNavigator.currentState = MenuStates.MAIN_MENU_STATE_CHAMPS_ACTIVE;
               }
               else if(this.viewstackSelectedIndex == SKIN_SELECT_INDEX)
               {
                  this.tabNavigator.currentState = MenuStates.MAIN_MENU_STATE_SKINS_ACTIVE;
               }
            }
            if(this.confirmButton)
            {
               if(this.viewstackSelectedIndex == CHAMPION_SELECT_INDEX)
               {
                  this.confirmButton.label = this.confirmButton.label = CapLocaleUtil.getResourceString("gf_button_champion_select_next_label","Next");
               }
               else if(this.viewstackSelectedIndex == SKIN_SELECT_INDEX)
               {
                  this.confirmButton.label = this.confirmButton.label = CapLocaleUtil.getResourceString("gf_button_champion_select_confirm_label","Done");
               }
            }
            if(this.filterTextInput)
            {
               if(this.viewstackSelectedIndex == CHAMPION_SELECT_INDEX)
               {
                  this.filterTextInput.visible = true;
               }
               else if(this.viewstackSelectedIndex == SKIN_SELECT_INDEX)
               {
                  this.filterTextInput.visible = false;
               }
            }
            this.viewstackSelectedIndexChanged = false;
         }
         if(this.championSelectionEnabledChanged)
         {
            if(this.championGrid)
            {
               this.championGrid.mouseEnabled = this._championSelectionEnabled;
            }
            if(this.championButton)
            {
               this.championButton.mouseEnabled = this._championSelectionEnabled;
            }
            this.championSelectionEnabledChanged = false;
         }
      }
      
      private function cleanupSound() : void
      {
         if(this.currentSound)
         {
            this.currentSound.abort();
            this.currentSound = null;
         }
      }
      
      protected function showChampionOverlays(param1:ParticipantChampionSelection) : void
      {
         var _loc2_:ChampionTooltip = null;
         this.championSummaryView.champion = this.currentParticipant.champion;
         this.championSummaryView.visible = true;
         if(!AdvancedToolTipManager.toolTipOpen)
         {
            _loc2_ = new ChampionTooltip();
            _loc2_.data = param1;
            AdvancedToolTipManager.createCustomToolTip(TOOLTIP_X * ApplicationUtil.application.scaleX,TOOLTIP_Y * ApplicationUtil.application.scaleY,_loc2_);
         }
      }
      
      public function hide() : void
      {
         if(this.championGrid)
         {
            this.championGrid.hide();
         }
         PopUpManager.removePopUp(this);
      }
      
      private function setupDataProvider() : ParticipantChampionListView
      {
         var _loc1_:Array = this.inventoryController.createSearchTags();
         var _loc2_:IChampionFilter = this.inventoryController.createChampionFilter(_loc1_);
         var _loc3_:GameTypeConfig = GameTypeConfigManager.instance.getGameTypeConfig(this.model.gameTypeConfigId);
         this.dataProvider = new ParticipantChampionListView(_loc3_,true,_loc2_,this.model.availableChampions.toArray());
         this.dataProvider.showRandom = false;
         this.dataProvider.refresh();
         return this.dataProvider;
      }
      
      private function setupChampionListeners(param1:ParticipantChampionListView) : void
      {
         var _loc3_:CapPlayerSelection = null;
         var _loc4_:IObserver = null;
         var _loc2_:Array = CapModelUtil.getAllAvailablePlayerSelections(this.model);
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = new ClassicChampionAvailableObserver(_loc3_,param1);
            _loc4_.setupSignals();
            _loc4_.refresh();
            this.championObservers.push(_loc4_);
         }
      }
      
      protected function handleChampionRollOver(param1:ItemSelectEvent) : void
      {
         var _loc2_:ParticipantChampionSelection = param1.data as ParticipantChampionSelection;
         var _loc3_:Champion = _loc2_.champion;
         this.currentParticipant = _loc2_;
         if(!this.rollOverTimer)
         {
            this.rollOverTimer = new Timer(DETAILS_DELAY);
            this.rollOverTimer.addEventListener(TimerEvent.TIMER,this.displayChampionOverlays,false,0,true);
         }
         this.rollOverTimer.reset();
         this.rollOverTimer.start();
      }
      
      private function doFilter(param1:Event = null) : void
      {
         if(this.dataProvider)
         {
            this.dataProvider.filterString = this.filterTextInput.text.toLowerCase();
            this.dataProvider.refresh();
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredWidth = SUMMARY_VIEW_WIDTH;
         measuredHeight = this.tabNavigator.getExplicitOrMeasuredHeight() + this.championSummaryView.getExplicitOrMeasuredHeight() + VERTICAL_GAP + PADDING_TOP;
      }
      
      public function set viewstackSelectedIndex(param1:int) : void
      {
         if(this._viewstackSelectedIndex == param1)
         {
            return;
         }
         this._viewstackSelectedIndex = param1;
         this.viewstackSelectedIndexChanged = true;
         invalidateProperties();
      }
      
      override protected function childrenCreated() : void
      {
         var _loc1_:Champion = null;
         var _loc2_:GameTypeConfig = null;
         var _loc3_:ParticipantChampionSelection = null;
         if(Boolean(this.model.localPlayerSelection.champion) && !this.skinSelector.playerSelection)
         {
            _loc1_ = this.model.localPlayerSelection.champion;
            _loc2_ = GameTypeConfigManager.instance.getGameTypeConfig(this.model.gameTypeConfigId);
            _loc3_ = new ParticipantChampionSelection(_loc2_,_loc1_);
            this.setChampionOnSkinSelector(_loc3_);
            this.determineIfConfirmButtonIsEnabled();
         }
      }
      
      protected function handleConfirmButtonClick(param1:MouseEvent) : void
      {
         if(this.viewstack.selectedIndex == CHAMPION_SELECT_INDEX && Boolean(this.model.localPlayerSelection.champion))
         {
            this.viewstackSelectedIndex = SKIN_SELECT_INDEX;
         }
         else if(this.viewstack.selectedIndex == SKIN_SELECT_INDEX)
         {
            this.hide();
         }
         SoundProviderProxy.instance.play(CapAudioKeys.CAP_CHAMP_SELECT_CONFIRM);
      }
      
      protected function handleSkinButtonClick(param1:MouseEvent) : void
      {
         if(!this.skinSelector || !this.skinSelector.playerSelection || !this.skinSelector.playerSelection.champion)
         {
            return;
         }
         this.viewstackSelectedIndex = SKIN_SELECT_INDEX;
      }
      
      protected function handleChampionSelected(param1:ItemSelectEvent) : void
      {
         var _loc2_:ParticipantChampionSelection = param1.data as ParticipantChampionSelection;
         var _loc3_:Champion = _loc2_.champion;
         this.setChampionOnSkinSelector(_loc2_);
         this.playChampionSelectionSound(_loc3_);
         if(this.viewMediator.currentState)
         {
            this.viewMediator.currentState.handleChampionSelected(_loc3_);
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         super.updateDisplayList(param1,param2);
         if(this.tabNavigator)
         {
            this.tabNavigator.x = (param1 - this.tabNavigator.width) / 2;
            this.tabNavigator.y = PADDING_TOP;
         }
         if(this.filterTextInput)
         {
            this.filterTextInput.x = this.tabNavigator.x + this.tabNavigator.width - this.filterTextInput.width - FILTER_PADDING_RIGHT;
            this.filterTextInput.y = this.tabNavigator.y + FILTER_PADDING_TOP;
         }
         if(this.viewstack)
         {
            _loc3_ = Number(this.viewstack.getExplicitOrMeasuredWidth());
            _loc4_ = Number(this.viewstack.getExplicitOrMeasuredHeight());
            this.viewstack.setActualSize(_loc3_,_loc4_);
            this.viewstack.move(VIEWSTACK_X,VIEWSTACK_Y);
         }
         if(this.championButton)
         {
            _loc5_ = Number(this.championButton.getExplicitOrMeasuredWidth());
            _loc6_ = Number(this.championButton.getExplicitOrMeasuredHeight());
            this.championButton.setActualSize(_loc5_,_loc6_);
            this.championButton.move(CHAMPION_BUTTON_X,CHAMPION_BUTTON_Y);
         }
         if(this.skinButton)
         {
            _loc7_ = Number(this.skinButton.getExplicitOrMeasuredWidth());
            _loc8_ = Number(this.skinButton.getExplicitOrMeasuredHeight());
            this.skinButton.setActualSize(_loc7_,_loc8_);
            this.skinButton.move(SKIN_BUTTON_X,SKIN_BUTTON_Y);
         }
         if(this.championSummaryView)
         {
            _loc9_ = SUMMARY_VIEW_WIDTH;
            _loc10_ = Number(this.championSummaryView.getExplicitOrMeasuredHeight());
            this.championSummaryView.setActualSize(_loc9_,_loc10_);
            this.championSummaryView.move(0,this.tabNavigator.height + VERTICAL_GAP);
         }
      }
   }
}

