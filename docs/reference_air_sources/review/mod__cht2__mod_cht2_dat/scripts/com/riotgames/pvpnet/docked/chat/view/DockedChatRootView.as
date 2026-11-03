package com.riotgames.pvpnet.docked.chat.view
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.button.LabelButtonX;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.IChatStateProvider;
   import com.riotgames.platform.gameclient.chat.config.ChatConfig;
   import com.riotgames.platform.gameclient.chat.domain.DockedPrompt;
   import com.riotgames.platform.gameclient.chat.views.ChatViewMediator;
   import com.riotgames.pvpnet.communities.ICommunitiesProvider;
   import com.riotgames.pvpnet.docked.IDockedChatView;
   import com.riotgames.pvpnet.docked.chat.view.buddypanel.BuddyPanelView;
   import com.riotgames.pvpnet.docked.chat.view.taskbar.DockedChatTaskBar;
   import com.riotgames.pvpnet.docked.model.DockedChatViewModel;
   import com.riotgames.pvpnet.notifications.NotificationsProvider;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   import mx.resources.ResourceManager;
   
   public class DockedChatRootView extends StatefulView implements IDockedChatView
   {
      
      public static const STATE_LOGGING_ON:String = "loggingOn";
      
      public static const STATE_LOGGED_IN:String = "loggedIn";
      
      public static const STATE_DISCONNECTED:String = "disconnected";
      
      public static const STATE_RECONNECTING:String = "reconnecting";
      
      public static const STATE_LOGGING_OUT:String = "loggingOut";
      
      public static const STATE_CHAT_DISABLED:String = "chatDisabled";
      
      private var _chatStateProvider:IChatStateProvider;
      
      private var _notificationsProvider:NotificationsProvider;
      
      private var _model:DockedChatViewModel;
      
      private var _reconnectButton:LabelButtonX;
      
      private var _statusText:TextFieldProxy;
      
      private var _buddyPanel:BuddyPanelView;
      
      private var _taskBar:DockedChatTaskBar;
      
      private var _communitiesTab:ButtonX;
      
      private var _communitiesContainer:SpriteProxy;
      
      private var _communitiesProvider:ICommunitiesProvider;
      
      private var _communitiesEnabled:ConfigurationModel;
      
      private var _loggedOut:Boolean = false;
      
      private var _updateFriendInviteNotifications:Boolean = false;
      
      private var _previousState:String = "";
      
      public function DockedChatRootView(param1:IContext)
      {
         super(param1,new MovieClip());
         setLinkage("DockedChatRootView");
         this._chatStateProvider.getCurrentStateChanged().add(this.handleChatStateChanged);
         setCurrentState(STATE_CHAT_DISABLED);
         this.handleChatStateChanged();
      }
      
      override protected function initializeDependencies() : void
      {
         this._chatStateProvider = getDependency(IChatStateProvider);
         this._model = getDependency(DockedChatViewModel);
         this._notificationsProvider = getDependency(NotificationsProvider);
         super.initializeDependencies();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._buddyPanel = new BuddyPanelView(this);
         setTimelineChildByName("buddyPanel",this._buddyPanel);
         this._taskBar = new DockedChatTaskBar(this);
         setTimelineChildByName("taskBar",this._taskBar);
         this._communitiesTab = new ButtonX(this);
         this._communitiesTab.setVisible(false);
         this._communitiesTab.toggleOnClick = true;
         this._communitiesTab.addEventListener(MouseEvent.CLICK,this.handleCommunitiesToggled);
         setTimelineChildByName("communitiesTab",this._communitiesTab);
         this._communitiesContainer = new SpriteProxy(this);
         this._communitiesContainer.setVisible(false);
         setTimelineChildByName("communitiesContainer",this._communitiesContainer);
         this._statusText = new TextFieldProxy(this);
         setTimelineChildByName("statusText",this._statusText);
         this._statusText.setAutoSize(TextFieldAutoSize.CENTER);
         this._statusText.setWordWrap(false);
         this._statusText.getLayoutInvalidated().add(invalidateLayout);
         this._reconnectButton = new LabelButtonX(this);
         setTimelineChildByName("reconnectButton",this._reconnectButton);
         this._reconnectButton.setText(ResourceManager.getInstance().getString("resources","chat_loading_reconnectButton"));
         this._reconnectButton.addEventListener(MouseEvent.CLICK,this.handleReconnectButton);
         this._communitiesProvider = getDependency(ICommunitiesProvider);
         this._communitiesEnabled = DynamicClientConfigManager.getConfiguration(ChatConfig.NAMESPACE,ChatConfig.COMMUNITIES_ENABLED,false,this.handleCommunitiesConfigChanged);
         this.handleCommunitiesConfigChanged();
      }
      
      private function handleReconnectButton(param1:MouseEvent) : void
      {
         var _loc2_:ChatViewMediator = getDependency(ChatViewMediator);
         _loc2_.reconnectToChat();
      }
      
      private function handleCommunitiesConfigChanged() : void
      {
         var _loc1_:Boolean = Boolean(this._communitiesEnabled.getBoolean()) && this._communitiesProvider != null;
         this._communitiesTab.setVisible(_loc1_);
         this._communitiesContainer.setVisible(_loc1_ && Boolean(this._communitiesContainer.getVisible()));
      }
      
      private function handleCommunitiesToggled(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObjectContainer = null;
         if(this._communitiesProvider != null && this._communitiesContainer.getChildren().length == 0)
         {
            _loc2_ = this._communitiesContainer.getAsset() as DisplayObjectContainer;
            while(_loc2_ != null && _loc2_.numChildren > 0)
            {
               _loc2_.removeChildAt(0);
            }
            this._communitiesContainer.addChild(this._communitiesProvider.getCommunitiesView(this));
         }
         this._communitiesContainer.setVisible(this._communitiesTab.getSelected());
      }
      
      private function handleChatStateChanged() : void
      {
         var _loc1_:String = null;
         var _loc4_:DockedPrompt = null;
         switch(this._chatStateProvider.getCurrentState())
         {
            case ChatController.LOGGING_IN:
               this._loggedOut = false;
               _loc1_ = STATE_LOGGING_ON;
               this._statusText.setText(ResourceManager.getInstance().getString("resources","chat_loading_loggingOn"));
               break;
            case ChatController.ONLINE:
               _loc1_ = STATE_LOGGED_IN;
               this._statusText.setText("");
               break;
            case ChatController.TEMP_FAILURE:
               _loc1_ = STATE_RECONNECTING;
               this._statusText.setText(ResourceManager.getInstance().getString("resources","chat_loading_reconnecting"));
               break;
            case ChatController.LOGGING_OUT:
               _loc1_ = STATE_LOGGING_OUT;
               this._statusText.setText(ResourceManager.getInstance().getString("resources","chat_loading_loggingOut"));
               break;
            case ChatController.OFFLINE:
               if(getCurrentState() == STATE_LOGGING_OUT)
               {
                  this._loggedOut = true;
               }
               _loc1_ = STATE_DISCONNECTED;
               this._statusText.setText(ResourceManager.getInstance().getString("resources","chat_loading_disconnected"));
         }
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         if(_loc1_ == STATE_LOGGED_IN && this._previousState != STATE_LOGGED_IN)
         {
            _loc2_ = true;
            _loc3_ = false;
         }
         else if(_loc1_ != STATE_LOGGED_IN && this._previousState == STATE_LOGGED_IN)
         {
            _loc2_ = true;
            _loc3_ = true;
         }
         if(_loc2_)
         {
            for each(_loc4_ in this._notificationsProvider.getNotifications())
            {
               if(_loc4_.type == DockedPrompt.TYPE_FRIEND_INVITE)
               {
                  _loc4_.disabled = _loc3_;
               }
            }
         }
         this._previousState = _loc1_;
         this._model.setTopLevelViewState(_loc1_);
         setCurrentState(_loc1_);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Number = Number(this._statusText.getWidth());
         this._statusText.setExplicitPosition(param1 / 2 - _loc3_ / 2,NaN);
         return super.updateLayout(param1,param2);
      }
   }
}

