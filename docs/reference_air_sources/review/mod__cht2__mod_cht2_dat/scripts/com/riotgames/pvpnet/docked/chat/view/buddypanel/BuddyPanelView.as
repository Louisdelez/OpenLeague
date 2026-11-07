package com.riotgames.pvpnet.docked.chat.view.buddypanel
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.text.Text;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.assignToolTip;
   import blix.context.IContext;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.common.provider.SoundProviderProxy;
   import com.riotgames.platform.common.utils.MessageDictionary;
   import com.riotgames.platform.gameclient.chat.IChatRosterProvider;
   import com.riotgames.platform.gameclient.chat.config.ChatConfig;
   import com.riotgames.platform.gameclient.chat.domain.DockedPrompt;
   import com.riotgames.platform.gameclient.chat.domain.PresenceStatusData;
   import com.riotgames.platform.gameclient.chat.utils.RiotPresence;
   import com.riotgames.platform.gameclient.chat.utils.StatusMessageUtil;
   import com.riotgames.platform.gameclient.chat.views.ChatViewMediator;
   import com.riotgames.platform.gameclient.domain.lobby.LobbyViewState;
   import com.riotgames.pvpnet.chat.AuthTokenManager;
   import com.riotgames.pvpnet.component.AudioButton;
   import com.riotgames.pvpnet.docked.IBuddyPanel;
   import com.riotgames.pvpnet.docked.chat.view.DockedChatRootView;
   import com.riotgames.pvpnet.docked.chat.view.notifications.BuddyPanelNotificationsView;
   import com.riotgames.pvpnet.docked.chat.view.notifications.NotificationToaster;
   import com.riotgames.pvpnet.docked.model.DockedChatViewModel;
   import com.riotgames.pvpnet.game.controllers.lobby.LobbyConfig;
   import com.riotgames.pvpnet.notifications.NotificationsProvider;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.pvpnet.system.config.cdc.IConfigurationRegistry;
   import com.riotgames.pvpnet.system.wordfilter.WordFilter;
   import com.riotgames.rust.components.text.InputTextFieldProxy;
   import com.riotgames.rust.focus.RiotFocusManager;
   import flash.display.MovieClip;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.ui.Keyboard;
   import mx.collections.ListCollectionView;
   import mx.events.CollectionEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.utils.StringUtil;
   
   public class BuddyPanelView extends StatefulView implements IBuddyPanel
   {
      
      public static const VIEW_STATE_BUDDYLIST:String = "BuddyList";
      
      public static const VIEW_STATE_CHATS:String = "Chats";
      
      public static const VIEW_STATE_NOTIFICATIONS:String = "Notifications";
      
      public static const VIEW_STATE_MINIMIZED:String = "Minimized";
      
      public static const LABEL_IMPORT:String = "import";
      
      public static const LABEL_NO_IMPORT:String = "noimport";
      
      private var _chatViewMediator:ChatViewMediator;
      
      private var _rosterProvider:IChatRosterProvider;
      
      private var _notificationsProvider:NotificationsProvider;
      
      private var _model:DockedChatViewModel;
      
      private var _friendsListOptionsButton:ButtonX;
      
      private var _minimizeButton:ButtonX;
      
      private var _summonerIconContainer:SpriteProxy;
      
      private var _summonerIconSizer:SpriteProxy;
      
      private var _summonerIconBitmap:BitmapProxy;
      
      private var _summonerNameText:TextFieldProxy;
      
      private var _summonerStatusText:Text;
      
      private var _statusSwitcher:StatefulView;
      
      private var _friendsFilterInputText:InputTextFieldProxy;
      
      private var _joinChatButton:ButtonX;
      
      private var _buddyCountText:TextFieldProxy;
      
      private var _notificationsCount:BuddyPanelNotificationCountView;
      
      private var _buddyPanelControls:StatefulView;
      
      private var _importFriendButton:ButtonX;
      
      private var _addFolderButton:ButtonX;
      
      private var _summonerSearchButton:ButtonX;
      
      private var _addFriendButton:ButtonX;
      
      private var _authTokenManager:AuthTokenManager;
      
      private var _friendImporterEnabled:ConfigurationModel;
      
      private var _friendImporterUrlTemplatePass:ConfigurationModel;
      
      private var _friendImporterUrlTemplateFail:ConfigurationModel;
      
      private var _friendsListButton:AudioButton;
      
      private var _chatRoomsListButton:AudioButton;
      
      private var _notificationsListButton:AudioButton;
      
      private var _buddies:ListCollectionView;
      
      private var _inputDialogue:BuddyPanelInputPanel;
      
      private var _friendsListView:BuddyPanelFriendsListView;
      
      private var _roomsListView:BuddyPanelRoomsListView;
      
      private var _notificationsView:BuddyPanelNotificationsView;
      
      private var _friendsListOptionsPanel:FriendsListOptionsPanel;
      
      private var _toaster:NotificationToaster;
      
      private var _isMobileEnabled:Boolean;
      
      public function BuddyPanelView(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         this.setCurrentState(VIEW_STATE_MINIMIZED);
         this._model.getTopLevelViewStateChanged().add(this.handleTopLevelViewStateChanged);
         this._notificationsProvider.getNotificationAdded().add(this.handleNotificationAdded);
         this._notificationsProvider.getNotificationsChanged().add(this.handleNotificationsChanged);
         LobbyConfig.instance.currentLobbyStateChanged.add(this.minimizeByLobbyState);
      }
      
      override protected function initializeDependencies() : void
      {
         this._chatViewMediator = getDependency(ChatViewMediator);
         this._rosterProvider = getDependency(IChatRosterProvider);
         this._model = getDependency(DockedChatViewModel);
         this._notificationsProvider = getDependency(NotificationsProvider);
         var _loc1_:IConfigurationRegistry = getDependency(IConfigurationRegistry);
         var _loc2_:ConfigurationModel = _loc1_.getConfigurationModel(ChatConfig.NAMESPACE,ChatConfig.MOBILE_ENABLED);
         this._isMobileEnabled = _loc2_.getValue();
         super.initializeDependencies();
      }
      
      override protected function createChildren() : void
      {
         this._authTokenManager = new AuthTokenManager();
         this._friendImporterEnabled = DynamicClientConfigManager.getConfiguration("FriendImporter","Enabled",false,this.configureFriendImporter);
         this._friendImporterUrlTemplatePass = DynamicClientConfigManager.getConfiguration("FriendImporter","UrlTemplatePass","",this.configureFriendImporter);
         this._friendImporterUrlTemplateFail = DynamicClientConfigManager.getConfiguration("FriendImporter","UrlTemplateFail","",this.configureFriendImporter);
         this._friendsListOptionsButton = new ButtonX(this);
         setTimelineChildByName("friendsListOptionsButton",this._friendsListOptionsButton);
         this._friendsListOptionsButton.toggleOnClick = true;
         this._friendsListOptionsButton.addEventListener(MouseEvent.CLICK,this.handleFriendsListOptionsButtonClicked);
         assignToolTip(this._friendsListOptionsButton,ResourceManager.getInstance().getString("resources","chat_buddyManagerWindow_options_tooltip"));
         this._minimizeButton = new ButtonX(this);
         setTimelineChildByName("minimizeButton",this._minimizeButton);
         this._minimizeButton.addEventListener(MouseEvent.CLICK,this.handleMinimizeButtonClicked);
         assignToolTip(this._minimizeButton,ResourceManager.getInstance().getString("resources","chat_buddyManagerWindow_minimizeButton_tooltip"));
         this._summonerIconSizer = new SpriteProxy(this);
         setTimelineChildByName("summonerIconSizer",this._summonerIconSizer);
         this._summonerIconContainer = new SpriteProxy(this);
         setTimelineChildByName("summonerIconContainer",this._summonerIconContainer);
         this._summonerIconBitmap = new BitmapProxy(this);
         var _loc1_:ScalingTransformBehavior = new ScalingTransformBehavior();
         _loc1_.setMaintainAspectRatio(true);
         this._summonerIconBitmap.setTransformBehavior(_loc1_);
         this._summonerIconBitmap.setSmoothing(true);
         this.updateSummonerIconBitmap();
         this._summonerIconContainer.addChild(this._summonerIconBitmap);
         AppConfig.instance.summonerIconSourceChanged.add(this.updateSummonerIconBitmap);
         this._summonerIconContainer.getLayoutInvalidated().add(invalidateLayout);
         this._toaster = new NotificationToaster(this);
         setTimelineChildByName("toaster",this._toaster);
         this._summonerNameText = new TextFieldProxy(this);
         setTimelineChildByName("summonerNameText",this._summonerNameText);
         this.setSummonerName();
         this._chatViewMediator.getSummonerNameChanged().add(this.setSummonerName);
         this._summonerStatusText = new Text(this);
         setTimelineChildByName("summonerStatusText",this._summonerStatusText);
         this._summonerStatusText.addEventListener(MouseEvent.CLICK,this.summonerStatusClicked);
         this._summonerStatusText.setAutoSize(TextFieldAutoSize.NONE);
         this._summonerStatusText.setTruncateToFit(true);
         this._summonerStatusText.setMaxChars(25);
         this._statusSwitcher = new StatefulView(this);
         setTimelineChildByName("statusSwitcher",this._statusSwitcher);
         this._statusSwitcher.addEventListener(MouseEvent.CLICK,this.handleStatusSwitcherClicked);
         this._statusSwitcher.setUseHandCursor(true);
         this._statusSwitcher.setButtonMode(true);
         this._statusSwitcher.setMouseEnabled(true);
         this.updateStatusIndicatorAndMessage();
         this._chatViewMediator.getCurrentStatusChanged().add(this.updateStatusIndicatorAndMessage);
         assignToolTip(this._statusSwitcher,ResourceManager.getInstance().getString("resources","chat_buddyManagerWindow_changeStatue"));
         this._chatViewMediator.getSummonerStatusMessageChanged().add(this.updateStatusIndicatorAndMessage);
         this._chatViewMediator.getPresenceUpdated().add(this.updateStatusIndicatorAndMessage);
         this._friendsFilterInputText = new InputTextFieldProxy(this);
         setTimelineChildByName("friendsFilterInputText",this._friendsFilterInputText);
         this._friendsFilterInputText.addEventListener(KeyboardEvent.KEY_UP,this.onFriendsFilterInputKeyUp,false,0,true);
         this._friendsFilterInputText.selectTextOnFocus = true;
         this._friendsFilterInputText.setHintTextColor(12303291);
         this._friendsFilterInputText.setHintText(ResourceManager.getInstance().getString("resources","chat_buddyWindow_filterFriendsPrompt"));
         this._friendsFilterInputText.setMaxChars(25);
         this._buddyPanelControls = new StatefulView(this);
         setTimelineChildByName("buddyPanelControls",this._buddyPanelControls);
         this._importFriendButton = new ButtonX(this);
         this._buddyPanelControls.setTimelineChildByName("importFriendButton",this._importFriendButton);
         assignToolTip(this._importFriendButton,ResourceManager.getInstance().getString("resources","importFriendButton_infoLabel"));
         this._importFriendButton.addEventListener(MouseEvent.CLICK,this.handleImportFriendButtonClicked);
         this._addFolderButton = new ButtonX(this);
         this._buddyPanelControls.setTimelineChildByName("addFolderButton",this._addFolderButton);
         assignToolTip(this._addFolderButton,ResourceManager.getInstance().getString("resources","addGroupWindow_infoLabel"));
         this._addFolderButton.addEventListener(MouseEvent.CLICK,this.handleAddFolderButtonClicked);
         this._summonerSearchButton = new ButtonX(this);
         this._buddyPanelControls.setTimelineChildByName("summonerSearchButton",this._summonerSearchButton);
         assignToolTip(this._summonerSearchButton,ResourceManager.getInstance().getString("resources","summoner_searchButton_tooltip"));
         this._summonerSearchButton.addEventListener(MouseEvent.CLICK,this.handleSummonerSearchButtonClicked);
         this._addFriendButton = new ButtonX(this);
         this._buddyPanelControls.setTimelineChildByName("addFriendButton",this._addFriendButton);
         assignToolTip(this._addFriendButton,ResourceManager.getInstance().getString("resources","addBuddyWindow_infoLabel"));
         this._addFriendButton.addEventListener(MouseEvent.CLICK,this.handleAddFriendButtonClicked);
         this.configureFriendImporter();
         this._joinChatButton = new ButtonX(this);
         setTimelineChildByName("joinChatButton",this._joinChatButton);
         this._joinChatButton.addEventListener(MouseEvent.CLICK,this.handleJoinChatButtonClicked);
         assignToolTip(this._joinChatButton,ResourceManager.getInstance().getString("resources","chat_chatRooms_addChatRoom"));
         this._friendsListButton = new AudioButton(this,null,AudioKeys.SOUND_CHAT_TAB_CLICK);
         setTimelineChildByName("friendsListButton",this._friendsListButton);
         this._friendsListButton.addEventListener(MouseEvent.CLICK,this.handleFriendsListButtonClicked);
         assignToolTip(this._friendsListButton,ResourceManager.getInstance().getString("resources","chat_buddyManagerWindow_toggle_buddylist"));
         this._chatRoomsListButton = new AudioButton(this,null,AudioKeys.SOUND_CHAT_TAB_CLICK);
         setTimelineChildByName("chatRoomsButton",this._chatRoomsListButton);
         this._chatRoomsListButton.addEventListener(MouseEvent.CLICK,this.handleChatRoomsListButtonClicked);
         assignToolTip(this._chatRoomsListButton,ResourceManager.getInstance().getString("resources","chat_buddyManagerWindow_toggle_chatPanel"));
         this._notificationsListButton = new AudioButton(this,null,AudioKeys.SOUND_CHAT_TAB_CLICK);
         setTimelineChildByName("notificationsButton",this._notificationsListButton);
         this._notificationsListButton.addEventListener(MouseEvent.CLICK,this.handleNotificationsButtonClicked);
         assignToolTip(this._notificationsListButton,ResourceManager.getInstance().getString("resources","chat_buddyManagerWindow_notifications"));
         this._notificationsCount = new BuddyPanelNotificationCountView(this);
         setTimelineChildByName("notificationCountView",this._notificationsCount);
         this._notificationsCount.setMouseEnabled(false);
         this._notificationsCount.setMouseChildren(false);
         this._notificationsProvider.getNotificationsChanged().add(this.updateNotificationsCountText);
         this.updateNotificationsCountText();
         this._inputDialogue = new BuddyPanelInputPanel(this);
         setTimelineChildByName("inputDialogue",this._inputDialogue);
         this._inputDialogue.setVisible(false);
         this._buddyCountText = new TextFieldProxy(this);
         this._friendsListButton.setTimelineChildByName("buddyCountText",this._buddyCountText);
         this._buddyCountText.setMouseEnabled(false);
         this.updateBuddyCountText();
         this._chatViewMediator.getOnlineBuddyCountChanged().add(this.updateBuddyCountText);
         this._buddies = this._rosterProvider.getBuddyGroups();
         this._buddies.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onBuddyGroupsChanged);
         this._friendsListView = new BuddyPanelFriendsListView(this);
         setTimelineChildByName("friendsListView",this._friendsListView);
         this._friendsListView.getIgnoreListExpanded().add(this.onIgnoreListExpanded);
         this._friendsListView.getOtherListExpanded().add(this.onOtherListExpanded);
         this._roomsListView = new BuddyPanelRoomsListView(this);
         setTimelineChildByName("roomsListView",this._roomsListView);
         this._notificationsView = new BuddyPanelNotificationsView(this);
         setTimelineChildByName("notificationsListView",this._notificationsView);
         this._friendsListOptionsPanel = new FriendsListOptionsPanel(this);
         setTimelineChildByName("friendsListOptionsPanel",this._friendsListOptionsPanel);
         this._friendsListOptionsPanel.close();
         this._friendsListOptionsPanel.getChangedSortRequested().add(this.handleChangeSortRequested);
         this._friendsListOptionsPanel.getChangedOfflineFriendVisibility().add(this.handleOfflineFriendVisibilityChanged);
         this._friendsListOptionsPanel.getClosed().add(this.handleFriendsListOptionsPanelClosed);
         this._friendsListOptionsPanel.initialized();
         super.createChildren();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._summonerIconBitmap.setExplicitSize(this._summonerIconSizer.getWidth(),this._summonerIconSizer.getHeight());
         return super.updateLayout(param1,param2);
      }
      
      override public function setCurrentState(param1:String) : void
      {
         var _loc2_:DockedPrompt = null;
         if(param1 == VIEW_STATE_BUDDYLIST)
         {
            this._friendsListButton.setSelected(true);
            this._chatRoomsListButton.setSelected(false);
            this._notificationsListButton.setSelected(false);
            this._friendsListOptionsButton.setSelected(false);
         }
         else if(param1 == VIEW_STATE_CHATS)
         {
            this._friendsListButton.setSelected(false);
            this._chatRoomsListButton.setSelected(true);
            this._notificationsListButton.setSelected(false);
            this._chatViewMediator.getChatRoomListViewModel().updateChatRoomOccupantCounts();
         }
         else if(param1 == VIEW_STATE_NOTIFICATIONS)
         {
            for each(_loc2_ in this._notificationsProvider.getNotifications())
            {
               if(_loc2_.shown)
               {
                  _loc2_.unread = false;
               }
               _loc2_.shown = true;
               _loc2_.showIntro = false;
            }
            this._friendsListButton.setSelected(false);
            this._chatRoomsListButton.setSelected(false);
            this._notificationsListButton.setSelected(true);
            this.updateNotificationsCountText();
         }
         else if(param1 == VIEW_STATE_MINIMIZED)
         {
            this._friendsListButton.setSelected(false);
            this._chatRoomsListButton.setSelected(false);
            this._notificationsListButton.setSelected(false);
         }
         this._model.setBuddyPanelState(param1);
         this._friendsListOptionsPanel.setVisible(false);
         super.setCurrentState(param1);
      }
      
      private function handleNotificationAdded(param1:DockedPrompt) : void
      {
         if(param1.type == DockedPrompt.TYPE_FRIEND_INVITE)
         {
            SoundProviderProxy.instance.play(AudioKeys.SOUND_BUDDY_INVITE);
         }
         param1.shown = getCurrentState() == VIEW_STATE_NOTIFICATIONS;
         param1.showIntro = getCurrentState() == VIEW_STATE_NOTIFICATIONS;
         this.updateNotificationsCountText();
      }
      
      private function handleNotificationsChanged() : void
      {
         this.updateNotificationsCountText();
      }
      
      private function handleTopLevelViewStateChanged(param1:String, param2:String) : void
      {
         if(param2 == DockedChatRootView.STATE_LOGGED_IN)
         {
            this._friendsListButton.setEnabled(true);
            this._chatRoomsListButton.setEnabled(true);
         }
         else
         {
            if(getCurrentState() != VIEW_STATE_NOTIFICATIONS)
            {
               this.setCurrentState(VIEW_STATE_MINIMIZED);
            }
            this._friendsListButton.setEnabled(false);
            this._chatRoomsListButton.setEnabled(false);
         }
      }
      
      private function handleChangeSortRequested(param1:String) : void
      {
         this._friendsListView.setFriendScrollerSortMode(param1);
      }
      
      private function handleOfflineFriendVisibilityChanged(param1:Boolean) : void
      {
         this._friendsListView.setShowOfflineFriends(param1);
      }
      
      private function handleFriendsListOptionsPanelClosed() : void
      {
         this._friendsListOptionsButton.setSelected(false);
      }
      
      private function onBuddyGroupsChanged(param1:CollectionEvent) : void
      {
         this.updateBuddyCountText();
      }
      
      private function updateBuddyCountText() : void
      {
         this._buddyCountText.setText(String(this._chatViewMediator.getOnlineBuddyCount()));
      }
      
      private function updateNotificationsCountText() : void
      {
         var _loc2_:DockedPrompt = null;
         var _loc1_:uint = 0;
         for each(_loc2_ in this._notificationsProvider.getNotifications())
         {
            if(!_loc2_.shown && _loc2_.type != DockedPrompt.TYPE_OTHER)
            {
               _loc1_++;
            }
         }
         this._notificationsCount.setNotificationCount(_loc1_);
      }
      
      private function updateStatusIndicatorAndMessage() : void
      {
         var _loc1_:RiotPresence = RiotPresence.fromXiffPresence(this._chatViewMediator.getCurrentStatus(),this._isMobileEnabled);
         var _loc2_:PresenceStatusData = this._chatViewMediator.getCurrentPresenceData();
         var _loc3_:String = _loc2_ ? _loc2_.gameType : "";
         var _loc4_:String = StatusMessageUtil.presenceToStatusMessage(this._chatViewMediator.getSummonerStatusMessage(),_loc1_,_loc3_);
         this._statusSwitcher.setCurrentState(_loc1_.assetKey);
         this._summonerStatusText.setTextColor(_loc1_.color);
         this._summonerStatusText.setText(_loc4_);
      }
      
      public function minimize() : void
      {
         this.setCurrentState(VIEW_STATE_MINIMIZED);
      }
      
      public function minimizeByLobbyState(param1:String, param2:String) : void
      {
         switch(param2)
         {
            case LobbyViewState.LOBBY_LANDING_STATE:
            case LobbyViewState.CREATE_ARRANGED_TEAM_STATE:
               break;
            default:
               this.minimize();
         }
      }
      
      private function handleFriendsListOptionsButtonClicked(param1:MouseEvent) : void
      {
         this._friendsListOptionsPanel.setVisible(!this._friendsListOptionsPanel.getVisible());
      }
      
      private function handleMinimizeButtonClicked(param1:MouseEvent) : void
      {
         this.setCurrentState(VIEW_STATE_MINIMIZED);
      }
      
      private function summonerStatusClicked(param1:MouseEvent) : void
      {
         this._summonerStatusText.setType(TextFieldType.INPUT);
         this._summonerStatusText.setTruncateToFit(false);
         this._summonerStatusText.setSelectable(true);
         this._summonerStatusText.setBorder(true);
         this._summonerStatusText.setBackground(true);
         this._summonerStatusText.setTextColor(0);
         this._summonerStatusText.setText(this._chatViewMediator.getSummonerStatusMessage());
         this._summonerStatusText.setSelection(0,int.MAX_VALUE);
         this._summonerStatusText.addEventListener(KeyboardEvent.KEY_UP,this.summonerStatusChanged);
         this._summonerStatusText.addEventListener(FocusEvent.FOCUS_OUT,this.summonerStatusFocusOut);
         this._summonerStatusText.removeEventListener(MouseEvent.CLICK,this.summonerStatusClicked);
      }
      
      private function summonerStatusChanged(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            RiotFocusManager.setFocus(this);
         }
         else if(param1.keyCode == Keyboard.ESCAPE)
         {
            this.updateStatusIndicatorAndMessage();
            RiotFocusManager.setFocus(this);
         }
      }
      
      private function summonerStatusFocusOut(param1:FocusEvent) : void
      {
         this.summonerStatusChangeComplete();
      }
      
      private function summonerStatusChangeComplete() : void
      {
         this._summonerStatusText.setType(TextFieldType.DYNAMIC);
         this._summonerStatusText.setTruncateToFit(true);
         this._summonerStatusText.setSelectable(false);
         this._summonerStatusText.setBorder(false);
         this._summonerStatusText.setBackground(false);
         this._summonerStatusText.removeEventListener(KeyboardEvent.KEY_UP,this.summonerStatusChanged);
         this._summonerStatusText.removeEventListener(FocusEvent.FOCUS_OUT,this.summonerStatusFocusOut);
         this._summonerStatusText.addEventListener(MouseEvent.CLICK,this.summonerStatusClicked);
         this.requestNewStatusMessage(this._summonerStatusText.getText());
      }
      
      private function handleStatusSwitcherClicked(param1:MouseEvent) : void
      {
         this._chatViewMediator.cycleStatus();
      }
      
      private function handleAddFolderButtonClicked(param1:MouseEvent) : void
      {
         this.changeInputDialogMode(BuddyPanelInputPanel.ADD_FOLDER);
      }
      
      private function handleSummonerSearchButtonClicked(param1:MouseEvent) : void
      {
         this.changeInputDialogMode(BuddyPanelInputPanel.SEARCH_SUMMONER);
      }
      
      private function handleAddFriendButtonClicked(param1:MouseEvent) : void
      {
         this.changeInputDialogMode(BuddyPanelInputPanel.ADD_SUMMONER);
      }
      
      private function handleJoinChatButtonClicked(param1:MouseEvent) : void
      {
         this.changeInputDialogMode(BuddyPanelInputPanel.JOIN_CHAT);
      }
      
      private function changeInputDialogMode(param1:String) : void
      {
         this._inputDialogue.setMode(param1);
      }
      
      private function handleFriendsListButtonClicked(param1:MouseEvent) : void
      {
         if(getCurrentState() == VIEW_STATE_BUDDYLIST)
         {
            this.setCurrentState(VIEW_STATE_MINIMIZED);
         }
         else
         {
            this._inputDialogue.setVisible(false);
            this.setCurrentState(VIEW_STATE_BUDDYLIST);
         }
      }
      
      private function handleChatRoomsListButtonClicked(param1:MouseEvent) : void
      {
         if(getCurrentState() == VIEW_STATE_CHATS)
         {
            this.setCurrentState(VIEW_STATE_MINIMIZED);
         }
         else
         {
            this._inputDialogue.setVisible(false);
            this.setCurrentState(VIEW_STATE_CHATS);
         }
      }
      
      private function handleNotificationsButtonClicked(param1:MouseEvent) : void
      {
         if(getCurrentState() == VIEW_STATE_NOTIFICATIONS)
         {
            this.setCurrentState(VIEW_STATE_MINIMIZED);
         }
         else
         {
            this._inputDialogue.setVisible(false);
            this.setCurrentState(VIEW_STATE_NOTIFICATIONS);
         }
      }
      
      private function setSummonerName() : void
      {
         this._summonerNameText.setText(this._chatViewMediator.getSummonerName());
      }
      
      private function onFriendsFilterInputKeyUp(param1:KeyboardEvent) : void
      {
         this._friendsListView.filterBuddyList(this._friendsFilterInputText.getText());
         if(param1.keyCode == Keyboard.ENTER)
         {
            RiotFocusManager.setFocus(this);
         }
         else if(param1.keyCode == Keyboard.ESCAPE)
         {
            RiotFocusManager.setFocus(this);
         }
      }
      
      private function onIgnoreListExpanded() : void
      {
         this._inputDialogue.showIgnore();
      }
      
      private function onOtherListExpanded() : void
      {
         this._inputDialogue.hideIgnore();
      }
      
      private function updateSummonerIconBitmap() : void
      {
         this._summonerIconBitmap.setBitmapData(AppConfig.instance.summonerIconSource);
         invalidateLayout();
      }
      
      private function requestNewStatusMessage(param1:String) : void
      {
         var _loc2_:IResourceManager = null;
         var _loc3_:AlertAction = null;
         if(WordFilter.instance.containsOffensiveWords(param1,false))
         {
            _loc2_ = ResourceManager.getInstance();
            _loc3_ = new AlertAction(_loc2_.getString("resources","general_generalAlertErrorTitle"),_loc2_.getString("resources",MessageDictionary.CHAT_STATUS_CONTAINS_OFFENSIVE_WORDS));
            _loc3_.add();
         }
         else
         {
            this._chatViewMediator.setSummonerStatusMessage(param1);
         }
         this.updateStatusIndicatorAndMessage();
      }
      
      private function setFriendImport() : void
      {
         this._buddyPanelControls.setCurrentState(LABEL_IMPORT);
      }
      
      private function setNoFriendImport() : void
      {
         this._buddyPanelControls.setCurrentState(LABEL_NO_IMPORT);
      }
      
      private function handleImportFriendButtonClicked(param1:MouseEvent) : void
      {
         this._authTokenManager.callWithAuthToken(this.handleAuthTokenResponse,this);
      }
      
      private function configureFriendImporter() : void
      {
         var _loc1_:Boolean = Boolean(this._friendImporterEnabled.getBoolean());
         var _loc2_:String = this._friendImporterUrlTemplatePass.getString();
         var _loc3_:String = this._friendImporterUrlTemplateFail.getString();
         if(_loc1_ && _loc2_ != null && _loc2_ != "" && _loc3_ != null && _loc3_ != "")
         {
            this.setFriendImport();
         }
         else
         {
            if(_loc1_)
            {
            }
            this.setNoFriendImport();
         }
      }
      
      private function handleAuthTokenResponse(param1:Error, param2:String) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         var _loc8_:String = null;
         if(param1 != null)
         {
            _loc3_ = ClientConfig.instance.locale;
            _loc4_ = _loc3_.substr(0,2);
            _loc5_ = StringUtil.substitute(this._friendImporterUrlTemplateFail.getString(),_loc4_);
            navigateToURL(new URLRequest(_loc5_),"_blank");
         }
         else if(param2 != null)
         {
            _loc6_ = this._authTokenManager.getAccountId();
            _loc7_ = this._authTokenManager.getPlatformId();
            _loc3_ = ClientConfig.instance.locale;
            _loc4_ = _loc3_.substr(0,2);
            _loc8_ = StringUtil.substitute(this._friendImporterUrlTemplatePass.getString(),_loc4_,_loc6_,_loc7_,_loc3_,param2);
            navigateToURL(new URLRequest(_loc8_),"_blank");
         }
      }
   }
}

