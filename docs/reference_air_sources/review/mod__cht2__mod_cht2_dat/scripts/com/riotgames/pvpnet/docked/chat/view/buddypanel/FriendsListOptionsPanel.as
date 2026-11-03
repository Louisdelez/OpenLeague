package com.riotgames.pvpnet.docked.chat.view.buddypanel
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.CheckBoxX;
   import blix.components.dropdown.DropDown;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.utils.MessageDictionary;
   import com.riotgames.platform.gameclient.chat.views.ChatViewMediator;
   import com.riotgames.pvpnet.docked.friendlist.view.FriendScroller;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.pvpnet.system.wordfilter.WordFilter;
   import com.riotgames.rust.components.text.InputTextFieldProxy;
   import com.riotgames.rust.data.ListAdapter;
   import com.riotgames.rust.focus.RiotFocusManager;
   import flash.display.Sprite;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import mx.collections.ArrayCollection;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class FriendsListOptionsPanel extends SpriteProxy
   {
      
      private static const WHITE:int = 16777215;
      
      private var _statusMessageLabel:TextFieldProxy;
      
      private var _friendsListSortLabel:TextFieldProxy;
      
      private var _statusMessageInputText:InputTextFieldProxy;
      
      private var _friendsListSortDropDown:DropDown;
      
      private var _showOfflineFriendsCheckBox:CheckBoxX;
      
      private var _chatViewMediator:ChatViewMediator;
      
      private var _sortChangeRequested:Signal = new Signal();
      
      private var _offlineFriendVisibilityChanged:Signal = new Signal();
      
      private var _closed:Signal = new Signal();
      
      private var _sortByStatus:String;
      
      private var _sortByName:String;
      
      public function FriendsListOptionsPanel(param1:IContext, param2:Sprite = null)
      {
         super(param1,param2);
      }
      
      override protected function initializeDependencies() : void
      {
         this._chatViewMediator = getDependency(ChatViewMediator);
      }
      
      override protected function createChildren() : void
      {
         this._statusMessageLabel = new TextFieldProxy(this);
         setTimelineChildByName("statusMessageLabel",this._statusMessageLabel);
         this._statusMessageLabel.setText(ResourceManager.getInstance().getString("resources","chat_buddyWindow_statusMessageLabel"));
         this._statusMessageInputText = new InputTextFieldProxy(this);
         setTimelineChildByName("statusMessageInputText",this._statusMessageInputText);
         this._statusMessageInputText.addEventListener(FocusEvent.FOCUS_OUT,this.onStatusMessageInputTextFocusOut,false,0,true);
         this._statusMessageInputText.addEventListener(KeyboardEvent.KEY_UP,this.onStatusMessageInputKeyUp,false,0,true);
         this._statusMessageInputText.setHintTextColor(10066329);
         this._statusMessageInputText.setHintText(ResourceManager.getInstance().getString("resources","chat_buddyWindow_buddyBaySetStatusPrompt"));
         this._statusMessageInputText.setMaxChars(25);
         this._chatViewMediator.getSummonerStatusMessageChanged().add(this.renderCurrentSummonerStatusMessage);
         this.renderCurrentSummonerStatusMessage();
         this._friendsListSortLabel = new TextFieldProxy(this);
         setTimelineChildByName("friendsListSortLabel",this._friendsListSortLabel);
         this._friendsListSortLabel.setText(ResourceManager.getInstance().getString("resources","chat_buddyWindow_friendsListSortLabel"));
         this._sortByStatus = ResourceManager.getInstance().getString("resources","chat_buddyWindow_sortByStatus");
         this._sortByName = ResourceManager.getInstance().getString("resources","chat_buddyWindow_sortByName");
         this._friendsListSortDropDown = new DropDown(this);
         this._friendsListSortDropDown.setListLinkage("FriendsListSortDropDownList");
         setTimelineChildByName("friendsListSortDropDown",this._friendsListSortDropDown);
         this._friendsListSortDropDown.setDataProvider(new ListAdapter(new ArrayCollection(new Array(this._sortByStatus,this._sortByName))));
         this._friendsListSortDropDown.getSelectionBehavior().getSelectedItemsChanged().add(this.onFriendsListSortDropDownSelectionChanged);
         this._showOfflineFriendsCheckBox = new CheckBoxX(this);
         setTimelineChildByName("showOfflineFriendsCheckBox",this._showOfflineFriendsCheckBox);
         this._showOfflineFriendsCheckBox.textField.setTextColor(WHITE);
         this._showOfflineFriendsCheckBox.textField.setText(ResourceManager.getInstance().getString("resources","chat_buddyWindow_friendsListOfflineFilterLabel"));
         this._showOfflineFriendsCheckBox.setSelected(UserPreferencesManager.userPrefs.showOfflineFriends);
         this._showOfflineFriendsCheckBox.getSelectedChanged().add(this.onShowOfflineFriendsCheckBoxChanged);
      }
      
      private function renderCurrentSummonerStatusMessage() : void
      {
         this._statusMessageInputText.setText(this._chatViewMediator.getSummonerStatusMessage());
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
         this.renderCurrentSummonerStatusMessage();
      }
      
      private function onStatusMessageInputTextFocusOut(param1:FocusEvent) : void
      {
         this.requestNewStatusMessage(this._statusMessageInputText.getText());
      }
      
      private function onStatusMessageInputKeyUp(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            RiotFocusManager.setFocus(this);
            this.close();
         }
         else if(param1.keyCode == Keyboard.ESCAPE)
         {
            this.renderCurrentSummonerStatusMessage();
            RiotFocusManager.setFocus(this);
         }
      }
      
      private function onFriendsListSortDropDownSelectionChanged() : void
      {
         var _loc1_:Object = this._friendsListSortDropDown.getSelectionBehavior().getSelectedItem();
         if(_loc1_ == this._sortByStatus)
         {
            this._sortChangeRequested.dispatch(FriendScroller.SORT_MODE_STATUS);
            this.saveSortModeUserPreference(FriendScroller.SORT_MODE_STATUS);
         }
         else if(_loc1_ == this._sortByName)
         {
            this._sortChangeRequested.dispatch(FriendScroller.SORT_MODE_NAME);
            this.saveSortModeUserPreference(FriendScroller.SORT_MODE_NAME);
         }
         this.close();
      }
      
      private function onShowOfflineFriendsCheckBoxChanged() : void
      {
         var _loc1_:Boolean = Boolean(this._showOfflineFriendsCheckBox.getSelected());
         this._offlineFriendVisibilityChanged.dispatch(_loc1_);
         UserPreferencesManager.userPrefs.showOfflineFriends = _loc1_;
      }
      
      private function saveSortModeUserPreference(param1:String) : void
      {
         UserPreferencesManager.userPrefs.friendsListSortType = param1;
      }
      
      private function loadSortModeUserPreference() : void
      {
         var _loc1_:String = UserPreferencesManager.userPrefs.friendsListSortType;
         if(_loc1_ == FriendScroller.SORT_MODE_STATUS)
         {
            this._friendsListSortDropDown.getSelectionBehavior().setSelectedItem(this._sortByStatus);
         }
         else if(_loc1_ == FriendScroller.SORT_MODE_NAME)
         {
            this._friendsListSortDropDown.getSelectionBehavior().setSelectedItem(this._sortByName);
         }
      }
      
      public function initialized() : void
      {
         this.loadSortModeUserPreference();
         this.onShowOfflineFriendsCheckBoxChanged();
      }
      
      public function close() : void
      {
         setVisible(false);
         this._closed.dispatch();
      }
      
      public function getChangedSortRequested() : ISignal
      {
         return this._sortChangeRequested;
      }
      
      public function getChangedOfflineFriendVisibility() : ISignal
      {
         return this._offlineFriendVisibilityChanged;
      }
      
      public function getClosed() : ISignal
      {
         return this._closed;
      }
   }
}

