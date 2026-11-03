package com.riotgames.pvpnet.docked.chat.view
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.ButtonX;
   import blix.components.button.CheckBoxX;
   import blix.components.button.LabelButtonX;
   import blix.components.renderer.IDataRenderer;
   import blix.components.text.Text;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.assignToolTip;
   import blix.context.IContext;
   import blix.frame.getEnterFrame;
   import blix.layout.vo.MinMax;
   import blix.layout.vo.SizeConstraints;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.common.provider.SoundProviderProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.chat.IChatProvider;
   import com.riotgames.platform.gameclient.chat.config.ChatConfig;
   import com.riotgames.platform.gameclient.chat.domain.Buddy;
   import com.riotgames.platform.gameclient.chat.domain.ChatPersonalMessageVO;
   import com.riotgames.platform.gameclient.chat.utils.ChatFormatUtil;
   import com.riotgames.platform.gameclient.chat.utils.RiotPresence;
   import com.riotgames.platform.gameclient.components.text.ExpandingTextScroller;
   import com.riotgames.platform.gameclient.domain.Summoner;
   import com.riotgames.platform.gameclient.domain.UserPrefs;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.chat.IDockedMessageWindow;
   import com.riotgames.pvpnet.chat.model.ChatWindowModel;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.IConfigurationRegistry;
   import com.riotgames.pvpnet.tracking.ICrossModuleTrackerProvider;
   import com.riotgames.pvpnet.tracking.trackers.chat.IChatBehaviorTracker;
   import com.riotgames.rust.focus.RiotFocusManager;
   import flash.events.MouseEvent;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.resources.ResourceManager;
   
   public class ChatWindowView extends StatefulView implements IDockedMessageWindow, IDataRenderer
   {
      
      private static const MAX_CHAT_WINDOW_SIZE:Number = 173;
      
      private static const MIN_CHAT_WINDOW_SIZE:Number = 30;
      
      private var _model:ChatWindowModel;
      
      private var dockedWindowTab:StatefulView;
      
      private var dockedTabBackground:StatefulView;
      
      private var summonerNameContainer:StatefulView;
      
      private var dockedTabLabel:Text;
      
      private var dockedTabCloseButton:ButtonX;
      
      private var statusIndicator:StatefulView;
      
      private var windowPaneContainer:SpriteProxy;
      
      private var windowPane:StatefulView;
      
      private var chatOptions:SpriteProxy;
      
      private var timeStampCheckBox:CheckBoxX;
      
      private var viewProfileButton:LabelButtonX;
      
      private var windowOptionsButton:ButtonX;
      
      private var windowMinimizeButton:ButtonX;
      
      private var windowCloseButton:ButtonX;
      
      private var windowSummonerLabel:Text;
      
      private var panelTop:SpriteProxy;
      
      private var chatInput:ExpandingTextScroller;
      
      private var chatInputBottom:Number;
      
      private var chatInputPadding:Number;
      
      private var scrollingTextArea:ChatWindowTextArea;
      
      private var _activateWindowRequested:Signal = new Signal();
      
      private var _minimizeWindowRequested:Signal = new Signal();
      
      private var _closeWindowRequested:Signal = new Signal();
      
      private var _viewProfileRequested:Signal = new Signal();
      
      private var _userPrefs:UserPrefs = UserPreferencesManager.userPrefs;
      
      private var _isOpen:Boolean = false;
      
      private var _pulseAnimator:PulseAnimator;
      
      private var isMobileEnabled:Boolean;
      
      private var _chatTracker:IChatBehaviorTracker;
      
      private var _availableSpace:Rectangle = new Rectangle(0,0,10000,0);
      
      public function ChatWindowView(param1:IContext)
      {
         super(param1);
         setLinkage("chat.ChatWindow");
         this._userPrefs.personalImTimeStampsChanged.add(this.onTimeStampPreferenceChanged);
         this.onTimeStampPreferenceChanged();
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         var _loc1_:IConfigurationRegistry = this.getDependency(IConfigurationRegistry);
         var _loc2_:ConfigurationModel = _loc1_.getConfigurationModel(ChatConfig.NAMESPACE,ChatConfig.MOBILE_ENABLED);
         this.isMobileEnabled = _loc2_.getValue();
         ProviderLookup.getProvider(ICrossModuleTrackerProvider,this.onGetTracker);
      }
      
      private function onGetTracker(param1:ICrossModuleTrackerProvider) : void
      {
         this._chatTracker = param1.getChatTracker();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.dockedWindowTab = new StatefulView(this);
         this.dockedWindowTab.setCurrentState("closed");
         this.dockedWindowTab.getLayoutInvalidated().add(this.invalidateLayout);
         setTimelineChildByName("tab",this.dockedWindowTab);
         this.dockedWindowTab.getMouseIsOverChanged().add(this.invalidateLayout);
         this.dockedTabBackground = new StatefulView(this);
         this.dockedWindowTab.setTimelineChildByName("background",this.dockedTabBackground);
         this.dockedTabBackground.setTransformBehavior(new ScalingTransformBehavior());
         this.dockedTabBackground.addEventListener(MouseEvent.CLICK,this.handleTabBackgroundClicked);
         this.summonerNameContainer = new StatefulView(this);
         this.dockedWindowTab.setTimelineChildByName("summonerNameContainer",this.summonerNameContainer);
         this.summonerNameContainer.addEventListener(MouseEvent.CLICK,this.handleTabBackgroundClicked);
         this.dockedTabLabel = new Text(this);
         this.summonerNameContainer.setTimelineChildByName("summonerName",this.dockedTabLabel);
         this.dockedTabLabel.setTruncateToFit(true);
         this.dockedTabCloseButton = new ButtonX(this);
         this.dockedWindowTab.setTimelineChildByName("closeButton",this.dockedTabCloseButton);
         this.dockedTabCloseButton.addEventListener(MouseEvent.CLICK,this.handleDockedCloseButtonClicked);
         this.statusIndicator = new StatefulView(this);
         this.dockedWindowTab.setTimelineChildByName("statusIndicator",this.statusIndicator);
         this.statusIndicator.addEventListener(MouseEvent.CLICK,this.handleTabBackgroundClicked);
         this.windowPaneContainer = new SpriteProxy(this);
         this.windowPaneContainer.getLayoutInvalidated().add(this.invalidateLayout);
         setTimelineChildByName("paneContainer",this.windowPaneContainer);
         this.windowPane = new StatefulView(this);
         this.windowPane.setCurrentState("closed");
         this.windowPane.getCurrentStateChanged().add(this.windowPane.invalidateLayout);
         this.windowPane.getLayoutInvalidated().add(this.windowPaneContainer.invalidateLayout);
         this.windowPaneContainer.setTimelineChildByName("pane",this.windowPane);
         this.windowPaneContainer.getLayoutInvalidated().add(this.invalidateLayout);
         this.chatOptions = new SpriteProxy(this);
         this.windowPane.setTimelineChildByName("optionsPanel",this.chatOptions);
         this.chatOptions.setVisible(false);
         var _loc1_:Text = new Text(this);
         this.chatOptions.setTimelineChildByName("timestampsTextField",_loc1_);
         _loc1_.setText(ResourceManager.getInstance().getString("resources","chat_imWindow_options_ShowTimeStamp"));
         this.timeStampCheckBox = new CheckBoxX(this);
         this.chatOptions.setTimelineChildByName("showTimestampsCheckbox",this.timeStampCheckBox);
         this.timeStampCheckBox.getSelectedChanged().add(this.handleTimestampSelectedChanged);
         this.timeStampCheckBox.setText(_loc1_.getText());
         this.viewProfileButton = new LabelButtonX(this);
         this.chatOptions.setTimelineChildByName("viewProfileButton",this.viewProfileButton);
         this.viewProfileButton.addEventListener(MouseEvent.CLICK,this.handleViewProfileButtonClicked);
         this.viewProfileButton.setText(ResourceManager.getInstance().getString("resources","BuddyListTreeRenderer_viewProfile"));
         this.windowSummonerLabel = new Text(this);
         this.windowPane.setTimelineChildByName("summonerNameText",this.windowSummonerLabel);
         this.windowSummonerLabel.addEventListener(MouseEvent.CLICK,this.handleTabBackgroundClicked);
         this.panelTop = new SpriteProxy(this);
         this.windowPane.setTimelineChildByName("panelTop",this.panelTop);
         this.panelTop.addEventListener(MouseEvent.CLICK,this.handleTabBackgroundClicked);
         this.windowOptionsButton = new ButtonX(this);
         this.windowPane.setTimelineChildByName("optionsButton",this.windowOptionsButton);
         this.windowOptionsButton.addEventListener(MouseEvent.CLICK,this.handleOptionsButtonClicked);
         assignToolTip(this.windowOptionsButton,ResourceManager.getInstance().getString("resources","chat_imWindow_options_tooltip"));
         this.windowMinimizeButton = new ButtonX(this);
         this.windowPane.setTimelineChildByName("minimizeButton",this.windowMinimizeButton);
         this.windowMinimizeButton.addEventListener(MouseEvent.CLICK,this.handleMinimizeButtonClicked);
         assignToolTip(this.windowMinimizeButton,ResourceManager.getInstance().getString("resources","chat_imWindow_minimize_tooltip"));
         this.windowCloseButton = new ButtonX(this);
         this.windowPane.setTimelineChildByName("closeButton",this.windowCloseButton);
         this.windowCloseButton.addEventListener(MouseEvent.CLICK,this.handleWindowCloseButtonClicked);
         assignToolTip(this.windowCloseButton,ResourceManager.getInstance().getString("resources","chat_imWindow_close_tooltip"));
         this.chatInput = new ExpandingTextScroller(this);
         this.windowPane.setTimelineChildByName("chatTextInput",this.chatInput);
         this.chatInput.setAutoClear(true);
         this.chatInput.setAltNewline(true);
         this.chatInput.clear.add(this.handleChatInputClear);
         this.chatInput.clearText();
         this.chatInput.getTextView().setMaxChars(200);
         this.chatInput.getAssetChanged().add(this.handleChatInputAssetChanged);
         this.chatInput.getLayoutInvalidated().add(this.windowPane.invalidateLayout);
         this.scrollingTextArea = new ChatWindowTextArea(this);
         this.windowPane.setTimelineChildByName("textScrollArea",this.scrollingTextArea);
         this.scrollingTextArea.getLinkClicked().add(this.onLinkClicked);
         this.scrollingTextArea.getLayoutInvalidated().add(this.invalidateLayout);
         this.scrollingTextArea.getAssetChanged().add(this.handleChatInputAssetChanged);
         this._pulseAnimator = new PulseAnimator(getEnterFrame(),300,1600,this.renderPulse);
      }
      
      public function setModel(param1:ChatWindowModel) : void
      {
         if(param1 != this._model)
         {
            if(this._model != null)
            {
               this.removeModelListeners();
            }
            this._model = param1;
            this.scrollingTextArea.setModel(this._model);
            if(this._model != null)
            {
               this.dockedTabLabel.setText(this._model.getBuddy().getName());
               this.windowSummonerLabel.setText(this._model.getBuddy().getName());
               this.setupModelListeners();
               this.updateStatusIndicator();
            }
         }
         this.invalidateLayout();
      }
      
      public function getModel() : ChatWindowModel
      {
         return this._model;
      }
      
      private function setupModelListeners() : void
      {
         this._model.getBuddy().getBuddyChanged().add(this.handleStatusChanged);
         this._model.getChatMessagesChanged().add(this.handleChatMessagesChanged);
         this._model.getActivated().add(this.activateThisWindow);
      }
      
      private function removeModelListeners() : void
      {
         this._model.getBuddy().getBuddyChanged().remove(this.handleStatusChanged);
         this._model.getChatMessagesChanged().remove(this.handleChatMessagesChanged);
         this._model.getActivated().remove(this.activateThisWindow);
      }
      
      private function activateThisWindow() : void
      {
         this._activateWindowRequested.dispatch(this);
      }
      
      private function handleDockedCloseButtonClicked(param1:MouseEvent) : void
      {
         this.closeClicked();
      }
      
      private function handleViewProfileButtonClicked(param1:MouseEvent) : void
      {
         this._viewProfileRequested.dispatch(this,this._model.getBuddy());
         this._chatTracker.incrementViewProfileClicked();
      }
      
      private function handleTabBackgroundClicked(param1:MouseEvent) : void
      {
         if(this.getIsOpen())
         {
            this._minimizeWindowRequested.dispatch(this);
         }
         else
         {
            this._activateWindowRequested.dispatch(this);
         }
      }
      
      private function handleOptionsButtonClicked(param1:MouseEvent) : void
      {
         this.chatOptions.setVisible(!this.chatOptions.getVisible());
         this._chatTracker.incrementChatWindowOptionsClicked();
      }
      
      private function handleMinimizeButtonClicked(param1:MouseEvent) : void
      {
         this._minimizeWindowRequested.dispatch(this);
         this._chatTracker.incrementChatWindowsMinimizedViaButton();
      }
      
      private function handleWindowCloseButtonClicked(param1:MouseEvent) : void
      {
         this.closeClicked();
      }
      
      private function closeClicked() : void
      {
         this._model.hasUnreadMessages = false;
         this.stopBlink();
         this.setIsOpen(false);
         this._closeWindowRequested.dispatch(this,this._model);
      }
      
      private function handleChatInputClear() : void
      {
         this.sendMessage();
         this.chatInput.getTextView().setSelection(int.MAX_VALUE,int.MAX_VALUE);
      }
      
      private function sendMessage() : void
      {
         var _loc2_:Summoner = null;
         var _loc3_:ChatPersonalMessageVO = null;
         var _loc4_:IChatProvider = null;
         var _loc1_:String = this.chatInput.getText();
         if(_loc1_.length > 0)
         {
            _loc2_ = Session.instance.summoner;
            _loc3_ = new ChatPersonalMessageVO(_loc2_.name,this._model.getBuddy().getName(),_loc1_);
            this._model.addMessage(_loc3_);
            _loc4_ = getDependency(IChatProvider);
            _loc4_.sendBuddyMessage(this._model.getBuddy().getJID(),_loc1_);
         }
      }
      
      private function handleTimestampSelectedChanged() : void
      {
         var _loc1_:Boolean = Boolean(this.timeStampCheckBox.getSelected());
         if(_loc1_ != this._userPrefs.personalImTimeStamps)
         {
            this._userPrefs.personalImTimeStamps = _loc1_;
         }
      }
      
      private function onTimeStampPreferenceChanged() : void
      {
         var _loc1_:Boolean = Boolean(this._userPrefs.personalImTimeStamps);
         this.timeStampCheckBox.setSelected(_loc1_);
         this.scrollingTextArea.setShowTimestamps(_loc1_);
      }
      
      private function handleStatusChanged() : void
      {
         this.updateStatusIndicator();
      }
      
      private function updateStatusIndicator() : void
      {
         var _loc1_:Buddy = this._model.getBuddy();
         var _loc2_:RiotPresence = RiotPresence.fromXiffPresence(_loc1_.getBusyStatus(),this.isMobileEnabled);
         if(_loc1_.getStatus() == Buddy.STATUS_ONLINE)
         {
            this.statusIndicator.setCurrentState(_loc2_.assetKey);
            this.summonerNameContainer.setCurrentState(_loc2_ == RiotPresence.MOBILE ? "available" : _loc2_.assetKey);
         }
         else
         {
            this.statusIndicator.setCurrentState("offline");
            this.summonerNameContainer.setCurrentState("offline");
         }
      }
      
      public function getIsOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function setIsOpen(param1:Boolean) : void
      {
         if(this._isOpen == param1)
         {
            return;
         }
         this._isOpen = param1;
         if(this._isOpen)
         {
            this.chatOptions.setVisible(false);
            RiotFocusManager.setFocus(this.chatInput.getTextView());
            this._model.hasUnreadMessages = false;
         }
         this.updateBlink();
         var _loc2_:String = this._isOpen ? "open" : "closed";
         this.windowPane.setCurrentState(_loc2_);
         this.dockedWindowTab.setCurrentState(_loc2_);
         this.dockedTabBackground.setCurrentState(_loc2_);
         this.invalidateLayout();
      }
      
      private function handleChatMessagesChanged() : void
      {
         if(this._isOpen)
         {
            this._model.hasUnreadMessages = false;
         }
         var _loc1_:Vector.<ChatPersonalMessageVO> = this._model.getMessages();
         var _loc2_:ChatPersonalMessageVO = _loc1_[_loc1_.length - 1];
         if(_loc2_.userFrom != Session.instance.summoner.name && Boolean(ChatFormatUtil.hasUrl(_loc2_.message)))
         {
            this._chatTracker.incrementURLReceived();
         }
         this.updateBlink();
         this.beepIfNeeded();
      }
      
      private function beepIfNeeded() : void
      {
         var _loc2_:ChatPersonalMessageVO = null;
         var _loc3_:Summoner = null;
         var _loc1_:Vector.<ChatPersonalMessageVO> = this._model.getMessages();
         if(_loc1_.length > 0)
         {
            _loc2_ = _loc1_[_loc1_.length - 1];
            _loc3_ = Session.instance.summoner;
            if(Boolean(_loc3_) && _loc2_.userFrom != _loc3_.name)
            {
               SoundProviderProxy.instance.play(AudioKeys.SOUND_PM_RECEIVE);
            }
         }
      }
      
      private function updateBlink() : void
      {
         if(this._isOpen)
         {
            this.stopBlink();
         }
         else if(Boolean(this._model) && Boolean(this._model.hasUnreadMessages))
         {
            this.startBlink();
         }
         else
         {
            this.stopBlink();
         }
      }
      
      private function startBlink() : void
      {
         this._pulseAnimator.start();
      }
      
      private function stopBlink() : void
      {
         this._pulseAnimator.stop();
         this.dockedTabBackground.setFilters([]);
         this.summonerNameContainer.setFilters([]);
      }
      
      private function renderPulse(param1:Number) : void
      {
         this.dockedTabBackground.setFilters([new GlowFilter(1745308,param1,15,15,1,BitmapFilterQuality.HIGH,true)]);
         this.summonerNameContainer.setFilters([new GlowFilter(1745308,param1 * 0.6,5 + 3 * param1,5 + 3 * param1,5,BitmapFilterQuality.HIGH)]);
      }
      
      private function onLinkClicked() : void
      {
         this._chatTracker.incrementURLClicked();
      }
      
      private function handleChatInputAssetChanged() : void
      {
         var _loc1_:Number = Number(this.chatInput.getY());
         if(!isNaN(_loc1_) && !isNaN(this.scrollingTextArea.getY()))
         {
            this.chatInputBottom = _loc1_ + this.chatInput.getHeight();
            this.chatInputPadding = _loc1_ - (this.scrollingTextArea.getY() + this.scrollingTextArea.getHeight());
            this.chatInput.getAssetChanged().remove(this.handleChatInputAssetChanged);
            this.scrollingTextArea.getAssetChanged().remove(this.handleChatInputAssetChanged);
            this.invalidateLayout();
         }
      }
      
      override public function destroy() : void
      {
         this.removeModelListeners();
         this._minimizeWindowRequested.removeAll();
         this._closeWindowRequested.removeAll();
         this._viewProfileRequested.removeAll();
         this._activateWindowRequested.removeAll();
         super.destroy();
      }
      
      override public function updateSizeConstraints(param1:Number, param2:Number) : SizeConstraints
      {
         return new SizeConstraints(new MinMax(MIN_CHAT_WINDOW_SIZE,MAX_CHAT_WINDOW_SIZE),new MinMax());
      }
      
      override public function invalidateLayout() : void
      {
         positionIsValidFlag = false;
         super.invalidateLayout();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc6_:Point = null;
         var _loc3_:Point = this.dockedTabBackground.setExplicitSize(param1,param2);
         if(param1 > 100 || Boolean(this.dockedWindowTab.getMouseIsOver()))
         {
            _loc6_ = this.dockedTabCloseButton.setExplicitPosition(_loc3_.x - this.dockedTabCloseButton.getWidth() - 4,NaN);
            this.statusIndicator.setExplicitPosition(_loc6_.x - 24,NaN);
            this.dockedTabLabel.setExplicitSize(_loc6_.x - 24,NaN);
            this.dockedTabCloseButton.setVisible(true);
         }
         else
         {
            this.dockedTabCloseButton.setVisible(false);
            this.statusIndicator.setExplicitPosition(_loc3_.x - 24,NaN);
            this.dockedTabLabel.setExplicitSize(_loc3_.x - 24,NaN);
         }
         this.windowPane.setExplicitSize(NaN,NaN);
         this.windowPaneContainer.setExplicitSize(NaN,NaN);
         var _loc4_:Point = this.chatInput.setExplicitSize(NaN,NaN);
         var _loc5_:Number = this.chatInputBottom - _loc4_.y;
         this.chatInput.setExplicitPosition(NaN,_loc5_);
         this.scrollingTextArea.setExplicitSize(this.scrollingTextArea.getWidth(),_loc5_ - this.scrollingTextArea.getY() - this.chatInputPadding);
         return new Rectangle(0,0,param1 || Number(this.dockedWindowTab.getWidth()),35);
      }
      
      override protected function updatePosition(param1:Number, param2:Number) : Point
      {
         var _loc3_:Rectangle = this.windowPaneContainer.getRect(this.windowPaneContainer.getAsset());
         var _loc4_:Number = this._availableSpace.right - param1 - _loc3_.right;
         this.windowPaneContainer.setExplicitPosition(_loc3_.left + Math.min(_loc4_,0),NaN);
         return super.updatePosition(param1,param2);
      }
      
      public function getCloseWindowRequested() : ISignal
      {
         return this._closeWindowRequested;
      }
      
      public function getMinimizeWindowRequested() : ISignal
      {
         return this._minimizeWindowRequested;
      }
      
      public function getActivateWindowRequested() : ISignal
      {
         return this._activateWindowRequested;
      }
      
      public function getViewProfileRequested() : ISignal
      {
         return this._viewProfileRequested;
      }
      
      public function getData() : *
      {
         return this._model;
      }
      
      public function setData(param1:*) : void
      {
         this.setModel(param1);
      }
      
      public function setAvailableSpace(param1:Rectangle) : void
      {
         this._availableSpace = param1;
         this.invalidateLayout();
      }
   }
}

