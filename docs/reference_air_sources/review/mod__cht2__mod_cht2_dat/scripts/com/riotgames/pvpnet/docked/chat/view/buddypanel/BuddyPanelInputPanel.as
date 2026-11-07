package com.riotgames.pvpnet.docked.chat.view.buddypanel
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.customsignals.PreventDefault;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.chat.NotificationsProviderProxy;
   import com.riotgames.platform.gameclient.chat.domain.ChatRoomType;
   import com.riotgames.platform.gameclient.chat.domain.DockedPrompt;
   import com.riotgames.platform.gameclient.chat.views.ChatViewMediator;
   import com.riotgames.pvpnet.game.controllers.lobby.ILegacyProfileNavigationProvider;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.rust.components.text.InputTextFieldProxy;
   import com.riotgames.rust.focus.RiotFocusManager;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class BuddyPanelInputPanel extends StatefulView
   {
      
      public static const SEARCH_SUMMONER:String = "SEARCH_SUMMONER";
      
      public static const ADD_SUMMONER:String = "ADD_SUMMONER";
      
      public static const IGNORE_SUMMONER:String = "IGNORE_SUMMONER";
      
      public static const ADD_FOLDER:String = "ADD_FOLDER";
      
      public static const JOIN_CHAT:String = "JOIN_CHAT";
      
      public static const NONE:String = "NONE";
      
      private static const VIEW_STATE_ADD:String = "add";
      
      private static const VIEW_STATE_SEARCH:String = "search";
      
      private var _labelText:TextFieldProxy;
      
      private var _inputText:InputTextFieldProxy;
      
      private var _searchButton:ButtonX;
      
      private var _addButton:ButtonX;
      
      private var _cbFunction:Function;
      
      private var _lobbyController:ILegacyProfileNavigationProvider;
      
      private var _chatViewMediator:ChatViewMediator;
      
      private var _currentMode:String;
      
      private var _currentSearchString:String;
      
      private var _ignoreShowing:Boolean;
      
      private var _parentState:String;
      
      public function BuddyPanelInputPanel(param1:IContext, param2:MovieClip = null)
      {
         (param1 as BuddyPanelView).getCurrentStateChanging().add(this.onParentStateChanged);
         super(param1,param2);
      }
      
      override protected function initializeDependencies() : void
      {
         this._lobbyController = getDependency(ILegacyProfileNavigationProvider);
         this._chatViewMediator = getDependency(ChatViewMediator);
         this._ignoreShowing = false;
         super.initializeDependencies();
      }
      
      override protected function createChildren() : void
      {
         this._labelText = new TextFieldProxy(this);
         setTimelineChildByName("labelText",this._labelText);
         this._inputText = new InputTextFieldProxy(this);
         setTimelineChildByName("inputText",this._inputText);
         this._inputText.setText("");
         this._inputText.addEventListener(KeyboardEvent.KEY_UP,this.handleKeyUp);
         this._inputText.setMaxChars(25);
         this._searchButton = new ButtonX(this);
         setTimelineChildByName("searchButton",this._searchButton);
         this._searchButton.addEventListener(MouseEvent.CLICK,this.handleSearchButtonClicked);
         this._addButton = new ButtonX(this);
         setTimelineChildByName("addButton",this._addButton);
         this._addButton.addEventListener(MouseEvent.CLICK,this.handleAddButtonClicked);
      }
      
      private function addChatRoom(param1:String) : void
      {
         if(param1 != "")
         {
            this._chatViewMediator.openChatRoomByName(param1,ChatRoomType.PUBLIC);
         }
         this.finish();
      }
      
      private function createFolder(param1:String) : void
      {
         var _loc3_:AlertAction = null;
         var _loc2_:Boolean = Boolean(this._chatViewMediator.createBuddyGroup(param1));
         if(!_loc2_)
         {
            _loc3_ = new AlertAction(RiotResourceLoader.getString("chat_buddyWindow_createGroupErrorTitle","**Create Group Error"),RiotResourceLoader.getString("chat_buddyWindow_createGroupErrorBody","**Creating the group has failed. Please try again."));
            _loc3_.add();
         }
         this.finish();
      }
      
      private function addSummoner(param1:String) : void
      {
         if(param1 != "")
         {
            this._chatViewMediator.addBuddy(param1);
         }
         this.finish();
      }
      
      private function ignoreSummoner(param1:String) : void
      {
         param1 = param1.replace(/[\r]/,"");
         if(param1 != "")
         {
            this._chatViewMediator.ignoreBuddyBySummonerName(param1);
         }
         this.finish(false);
      }
      
      private function searchSummoner(param1:String) : void
      {
         this._currentSearchString = param1;
         if(param1 != "")
         {
            this._lobbyController.searchForSummoner(param1,this.onSearchError);
         }
         this.finish();
      }
      
      public function showIgnore() : void
      {
         this._ignoreShowing = true;
         this.setMode(BuddyPanelInputPanel.IGNORE_SUMMONER);
      }
      
      public function hideIgnore() : void
      {
         this._ignoreShowing = false;
         if(this._currentMode == BuddyPanelInputPanel.IGNORE_SUMMONER)
         {
            this._currentMode = BuddyPanelInputPanel.NONE;
            setVisible(false);
         }
      }
      
      public function getMode() : String
      {
         return this._currentMode;
      }
      
      public function setMode(param1:String) : void
      {
         this._inputText.setText("");
         switch(param1)
         {
            case BuddyPanelInputPanel.JOIN_CHAT:
               this._cbFunction = this.addChatRoom;
               this._labelText.setText(ResourceManager.getInstance().getString("resources","chat_chatRooms_addChatRoom"));
               setCurrentState(BuddyPanelInputPanel.VIEW_STATE_SEARCH);
               break;
            case BuddyPanelInputPanel.ADD_FOLDER:
               this._cbFunction = this.createFolder;
               this._labelText.setText(ResourceManager.getInstance().getString("resources","addGroupWindow_infoLabel"));
               setCurrentState(BuddyPanelInputPanel.VIEW_STATE_ADD);
               break;
            case BuddyPanelInputPanel.ADD_SUMMONER:
               this._cbFunction = this.addSummoner;
               this._labelText.setText(ResourceManager.getInstance().getString("resources","addBuddyWindow_infoLabel"));
               setCurrentState(BuddyPanelInputPanel.VIEW_STATE_ADD);
               break;
            case BuddyPanelInputPanel.SEARCH_SUMMONER:
               this._cbFunction = this.searchSummoner;
               this._labelText.setText(ResourceManager.getInstance().getString("resources","summoner_searchButton_tooltip"));
               setCurrentState(BuddyPanelInputPanel.VIEW_STATE_SEARCH);
               break;
            case BuddyPanelInputPanel.IGNORE_SUMMONER:
               this._cbFunction = this.ignoreSummoner;
               this._labelText.setText(ResourceManager.getInstance().getString("resources","addIgnoredUserWindow_infoLabel"));
               setCurrentState(BuddyPanelInputPanel.VIEW_STATE_ADD);
               break;
            default:
               this._currentMode = BuddyPanelInputPanel.ADD_FOLDER;
         }
         if(param1 == this._currentMode && this._currentMode != BuddyPanelInputPanel.IGNORE_SUMMONER)
         {
            this.finish();
         }
         else
         {
            setVisible(true);
            RiotFocusManager.setFocus(this._inputText);
            this._currentMode = param1;
         }
      }
      
      private function handleSearchButtonClicked(param1:MouseEvent) : void
      {
         this._cbFunction(this._inputText.getText());
      }
      
      private function handleAddButtonClicked(param1:MouseEvent) : void
      {
         this._cbFunction(this._inputText.getText());
      }
      
      private function handleKeyUp(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this._cbFunction(this._inputText.getText());
         }
         else if(param1.keyCode == Keyboard.ESCAPE)
         {
            this.finish();
         }
      }
      
      private function onSearchError(param1:ServerError) : void
      {
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         var _loc3_:DockedPrompt = DockedPrompt.create(_loc2_.getString("resources","chat_buddyWindow_errorOnAddBuddyAlertMessage",[this._currentSearchString.replace(/</g,"&lt;")]),_loc2_.getString("resources","chat_buddyWindow_buddyBayLabel"),"",_loc2_.getString("resources","common_button_close"),null,DockedPrompt.TYPE_OTHER);
         NotificationsProviderProxy.instance.showDockedPrompt(_loc3_);
      }
      
      private function finish(param1:Boolean = true) : void
      {
         if(this._ignoreShowing && this._parentState == BuddyPanelView.VIEW_STATE_BUDDYLIST)
         {
            this.setMode(BuddyPanelInputPanel.IGNORE_SUMMONER);
            return;
         }
         if(param1)
         {
            this._labelText.setText("");
            setVisible(false);
            this._currentMode = BuddyPanelInputPanel.NONE;
         }
         this._inputText.setText("");
      }
      
      private function onParentStateChanged(param1:*, param2:String, param3:String, param4:PreventDefault) : void
      {
         if(param3 == BuddyPanelView.VIEW_STATE_BUDDYLIST && this._ignoreShowing)
         {
            this.setMode(BuddyPanelInputPanel.IGNORE_SUMMONER);
         }
         this._parentState = param3;
      }
   }
}

