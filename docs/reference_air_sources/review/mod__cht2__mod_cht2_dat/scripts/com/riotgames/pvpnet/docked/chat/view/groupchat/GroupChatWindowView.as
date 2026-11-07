package com.riotgames.pvpnet.docked.chat.view.groupchat
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.button.CheckBoxX;
   import blix.components.text.Text;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.assignToolTip;
   import blix.context.IContext;
   import blix.layout.vo.MinMax;
   import blix.layout.vo.SizeConstraints;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.gameclient.chat.domain.AutojoinChatDesc;
   import com.riotgames.platform.gameclient.chat.domain.Buddy;
   import com.riotgames.platform.gameclient.chat.trackers.GroupChatBehaviorTracker;
   import com.riotgames.platform.gameclient.chat.views.ChatViewMediator;
   import com.riotgames.platform.gameclient.domain.UserPrefs;
   import com.riotgames.pvpnet.chat.IDockedMessageWindow;
   import com.riotgames.pvpnet.docked.DockedChatStates;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.rust.focus.RiotFocusManager;
   import flash.desktop.NativeDragManager;
   import flash.events.MouseEvent;
   import flash.events.NativeDragEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.resources.ResourceManager;
   
   public class GroupChatWindowView extends StatefulView implements IDockedMessageWindow
   {
      
      private static const MAX_CHAT_WINDOW_SIZE:Number = 173;
      
      private static const MIN_CHAT_WINDOW_SIZE:Number = 30;
      
      private var _activateWindowRequested:Signal = new Signal();
      
      private var _minimizeWindowRequested:Signal = new Signal();
      
      private var _closeWindowRequested:Signal = new Signal();
      
      private var _viewProfileRequested:Signal = new Signal();
      
      private var _model:ChatRoom;
      
      private var dockedWindowTab:StatefulView;
      
      private var dockedTabBackground:StatefulView;
      
      private var dockedTabLabel:Text;
      
      private var dockedTabCloseButton:ButtonX;
      
      private var windowPane:StatefulView;
      
      private var chatOptions:SpriteProxy;
      
      private var timeStampCheckBox:CheckBoxX;
      
      private var autojoinCheckBox:CheckBoxX;
      
      private var windowOptionsButton:ButtonX;
      
      private var windowMinimizeButton:ButtonX;
      
      private var windowCloseButton:ButtonX;
      
      private var windowRoomLabel:Text;
      
      private var panelTop:SpriteProxy;
      
      private var participantsList:GroupChatWindowParticipantList;
      
      private var dropIndicator:SpriteProxy;
      
      private var chatroomInfoText:TextFieldProxy;
      
      private var chatRoomView:ChatRoomView;
      
      private var viewMediator:ChatViewMediator;
      
      private var _isOpen:Boolean;
      
      private var _userPrefs:UserPrefs;
      
      private var _disabled:Boolean;
      
      private var _availableSpace:Rectangle = new Rectangle(0,0,10000,0);
      
      public function GroupChatWindowView(param1:IContext)
      {
         super(param1);
         setLinkage("chat.GroupChatWindow");
         this._userPrefs = UserPreferencesManager.userPrefs;
         this._userPrefs.personalImTimeStampsChanged.add(this.onTimeStampPreferenceChanged);
         this.onTimeStampPreferenceChanged();
         this.chatRoomView.setShowTimeStamp(this._userPrefs.personalImTimeStamps);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.dockedWindowTab = new StatefulView(this);
         setTimelineChildByName("tab",this.dockedWindowTab);
         this.dockedTabBackground = new StatefulView(this);
         this.dockedWindowTab.setTimelineChildByName("background",this.dockedTabBackground);
         this.dockedTabBackground.setTransformBehavior(new ScalingTransformBehavior());
         this.dockedTabBackground.addEventListener(MouseEvent.CLICK,this.handleTabBackgroundClicked);
         this.dockedWindowTab.getMouseIsOverChanged().add(this.invalidateLayout);
         this.dockedTabLabel = new Text(this);
         this.dockedWindowTab.setTimelineChildByName("roomNameText",this.dockedTabLabel);
         this.dockedTabLabel.setTruncateToFit(true);
         this.dockedTabLabel.addEventListener(MouseEvent.CLICK,this.handleTabBackgroundClicked);
         this.dockedTabCloseButton = new ButtonX(this);
         this.dockedWindowTab.setTimelineChildByName("closeButton",this.dockedTabCloseButton);
         this.dockedTabCloseButton.addEventListener(MouseEvent.CLICK,this.handleWindowCloseButtonClicked);
         this.windowPane = new StatefulView(this);
         this.windowPane.getCurrentStateChanged().add(this.windowPane.invalidateLayout);
         this.windowPane.getLayoutInvalidated().add(this.invalidateLayout);
         setTimelineChildByName("pane",this.windowPane);
         this.chatOptions = new SpriteProxy(this);
         this.windowPane.setTimelineChildByName("optionsPanel",this.chatOptions);
         this.chatOptions.setVisible(false);
         this.timeStampCheckBox = new CheckBoxX(this);
         this.chatOptions.setTimelineChildByName("showTimestampsCheckbox",this.timeStampCheckBox);
         this.timeStampCheckBox.getSelectedChanged().add(this.handleTimestampSelectedChanged);
         this.timeStampCheckBox.setText(ResourceManager.getInstance().getString("resources","chat_imWindow_options_ShowTimeStamp"));
         this.autojoinCheckBox = new CheckBoxX(this);
         this.chatOptions.setTimelineChildByName("autojoinCheckbox",this.autojoinCheckBox);
         this.autojoinCheckBox.getSelectedChanged().add(this.handleAutojoinSelectedChanged);
         this.autojoinCheckBox.setText(ResourceManager.getInstance().getString("resources","chat_imWindow_options_Autojoin"));
         this.windowRoomLabel = new Text(this);
         this.windowPane.setTimelineChildByName("roomNameText",this.windowRoomLabel);
         this.windowRoomLabel.addEventListener(MouseEvent.CLICK,this.handleTabBackgroundClicked);
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
         this.chatRoomView = new ChatRoomView(this);
         this.windowPane.setTimelineChildByName("chatRoomView",this.chatRoomView);
         this.participantsList = new GroupChatWindowParticipantList(this);
         this.windowPane.setTimelineChildByName("participantsPanel",this.participantsList);
         this.dropIndicator = new SpriteProxy(this);
         this.windowPane.setTimelineChildByName("dropIndicator",this.dropIndicator);
         this.dropIndicator.setVisible(false);
         this.chatroomInfoText = new TextFieldProxy(this);
         this.windowPane.setTimelineChildByName("chatroomInfoText",this.chatroomInfoText);
         this.windowPane.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,this.handleDragEnter);
         this.windowPane.addEventListener(NativeDragEvent.NATIVE_DRAG_EXIT,this.handleDragExit);
         this.windowPane.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,this.handleDragDrop);
         this._isOpen = true;
         this.setIsOpen(false);
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this.viewMediator = getDependency(ChatViewMediator);
      }
      
      public function getModel() : ChatRoom
      {
         return this._model;
      }
      
      public function setModel(param1:ChatRoom) : void
      {
         if(param1 == this._model)
         {
            return;
         }
         if(this._model != null)
         {
            this.dockedTabLabel.setText("");
            this.windowRoomLabel.setText("");
            this.autojoinCheckBox.setSelected(false);
            this._model.roomJoinSignal.remove(this.updateState);
            this._model.maxUsersErrorSignal.remove(this.updateState);
            this._model.getChatServiceDisconnectedSignal().remove(this.updateState);
            this._model.getChatServiceReconnectedSignal().remove(this.updateState);
            this._model.userListChangedSignal.remove(this.handleParticipantListChanged);
            if(this._model.isActive)
            {
               this._model.leave();
            }
         }
         this._model = param1;
         this.chatRoomView.setModel(this._model);
         this.participantsList.setModel(this._model);
         if(this._model != null)
         {
            this.dockedTabLabel.setText(this._model.subject);
            this.windowRoomLabel.setText(this._model.subject + " (" + this._model.getRoomOccupants().length.toString() + ")");
            this.autojoinCheckBox.setSelected(this.isAutoJoinSelected());
            this.autojoinCheckBox.setEnabled(this._model.isEnableAutoJoinOption());
            if(!this._model.isActive)
            {
               this._model.join();
               this._model.roomJoinSignal.add(this.updateState);
            }
            this._model.maxUsersErrorSignal.add(this.updateState);
            this._model.getChatServiceDisconnectedSignal().add(this.updateState);
            this._model.getChatServiceReconnectedSignal().add(this.updateState);
            this._model.userListChangedSignal.add(this.handleParticipantListChanged);
            this.updateState();
            this.invalidateLayout();
            this._activateWindowRequested.dispatch(this);
         }
      }
      
      public function isAutoJoinSelected() : Boolean
      {
         return this.autojoinListIndex() != -1 && Boolean(this._model.isEnableAutoJoinOption());
      }
      
      public function getDisabled() : Boolean
      {
         return this._disabled;
      }
      
      public function setDisabled(param1:Boolean) : void
      {
         if(this._disabled == param1)
         {
            return;
         }
         this._disabled = param1;
         this.updateState();
      }
      
      public function getIsOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function setIsOpen(param1:Boolean) : void
      {
         var _loc2_:Text = null;
         if(this._isOpen == param1)
         {
            return;
         }
         this._isOpen = param1;
         this.updateState();
         if(this._isOpen)
         {
            this.chatOptions.setVisible(false);
            _loc2_ = this.chatRoomView.chatInput.getTextView();
            RiotFocusManager.setFocus(_loc2_);
            _loc2_.setSelection(int.MAX_VALUE,int.MAX_VALUE);
         }
      }
      
      private function updateState() : void
      {
         var _loc1_:String = DockedChatStates.WINDOW_STATE_CLOSED;
         if(this._isOpen)
         {
            _loc1_ = DockedChatStates.WINDOW_STATE_OPEN;
            if(this._model)
            {
               if(this._model.roomFull)
               {
                  _loc1_ = DockedChatStates.WINDOW_STATE_INFO;
                  this.chatroomInfoText.setText(ResourceManager.getInstance().getString("resources","chat_groupChatWindow_roomFull"));
                  GroupChatBehaviorTracker.instance.incrementJoinAttempts_InASession(this._model.getRoomJID());
               }
               else if(this._model.disconnected)
               {
                  _loc1_ = DockedChatStates.WINDOW_STATE_INFO;
                  this.chatroomInfoText.setText(ResourceManager.getInstance().getString("resources","chat_groupChatWindow_disconnetedMessage"));
               }
               else if(!this._model.isActive)
               {
                  _loc1_ = DockedChatStates.WINDOW_STATE_INFO;
                  this.chatroomInfoText.setText(ResourceManager.getInstance().getString("resources","chat_groupChatWindow_joiningRoomMessage"));
               }
            }
         }
         this.windowPane.setCurrentState(_loc1_);
         this.dockedWindowTab.setCurrentState(_loc1_);
         this.dockedTabBackground.setCurrentState(_loc1_);
         this.invalidateLayout();
      }
      
      private function handleTabBackgroundClicked(param1:MouseEvent) : void
      {
         if(this._isOpen)
         {
            this._minimizeWindowRequested.dispatch(this);
         }
         else
         {
            this._activateWindowRequested.dispatch(this);
         }
         this.invalidateLayout();
      }
      
      private function handleTimestampSelectedChanged() : void
      {
         var _loc1_:Boolean = Boolean(this.timeStampCheckBox.getSelected());
         if(this._userPrefs.personalImTimeStamps != _loc1_)
         {
            this._userPrefs.personalImTimeStamps = _loc1_;
            this.chatRoomView.setShowTimeStamp(_loc1_);
         }
      }
      
      private function onTimeStampPreferenceChanged() : void
      {
         var _loc1_:Boolean = Boolean(this._userPrefs.personalImTimeStamps);
         this.chatRoomView.setShowTimeStamp(_loc1_);
         this.timeStampCheckBox.setSelected(_loc1_);
      }
      
      private function handleAutojoinSelectedChanged() : void
      {
         var _loc1_:Boolean = Boolean(this.autojoinCheckBox.getSelected());
         var _loc2_:AutojoinChatDesc = new AutojoinChatDesc();
         if(this._model == null)
         {
            return;
         }
         var _loc3_:int = this.autojoinListIndex();
         _loc2_.roomName = this._model.roomName;
         _loc2_.roomSubject = this._model.subject;
         _loc2_.roomType = this._model.getRoomType();
         if(_loc1_)
         {
            if(_loc3_ == -1)
            {
               this._userPrefs.autoJoinList.push(_loc2_);
            }
         }
         else
         {
            this._userPrefs.autoJoinList.splice(_loc3_,1);
         }
         UserPreferencesManager.instance.saveUserPreferences(this._model.getNickName());
      }
      
      private function autojoinListIndex() : int
      {
         var _loc2_:AutojoinChatDesc = null;
         if(this._model == null)
         {
            return -1;
         }
         var _loc1_:uint = 0;
         while(_loc1_ < this._userPrefs.autoJoinList.length)
         {
            _loc2_ = this._userPrefs.autoJoinList[_loc1_];
            if(this._model.roomName == _loc2_.roomName)
            {
               return _loc1_;
            }
            _loc1_++;
         }
         return -1;
      }
      
      private function handleOptionsButtonClicked(param1:MouseEvent) : void
      {
         this.chatOptions.setVisible(!this.chatOptions.getVisible());
      }
      
      private function handleMinimizeButtonClicked(param1:MouseEvent) : void
      {
         this._minimizeWindowRequested.dispatch(this);
      }
      
      private function handleWindowCloseButtonClicked(param1:MouseEvent) : void
      {
         GroupChatBehaviorTracker.instance.incrementPublicChatRoomClosed_InASession(this._model.getRoomJID());
         this.closeClicked();
      }
      
      private function closeClicked() : void
      {
         this._closeWindowRequested.dispatch(this);
      }
      
      private function handleParticipantListChanged() : void
      {
         this.windowRoomLabel.setText(this._model.subject + " (" + this._model.getRoomOccupants().length.toString() + ")");
      }
      
      public function getData() : *
      {
         return this._model;
      }
      
      public function setData(param1:*) : void
      {
         this.setModel(param1);
      }
      
      private function handleDragDrop(param1:NativeDragEvent) : void
      {
         var _loc2_:Buddy = param1.clipboard.getData(Buddy.DATA_FORMAT) as Buddy;
         if(_loc2_)
         {
            this.viewMediator.inviteBuddyToChat(_loc2_,this._model.getRoomType(),this._model.subject);
         }
      }
      
      private function handleDragEnter(param1:NativeDragEvent) : void
      {
         if(param1.clipboard.hasFormat(Buddy.DATA_FORMAT))
         {
            NativeDragManager.acceptDragDrop(this.windowPane.getInteractiveAsset());
            this.dropIndicator.setVisible(true);
         }
      }
      
      private function handleDragExit(param1:NativeDragEvent) : void
      {
         this.dropIndicator.setVisible(false);
      }
      
      public function getCloseWindowRequested() : ISignal
      {
         return this._closeWindowRequested;
      }
      
      public function getMinimizeWindowRequested() : ISignal
      {
         return this._minimizeWindowRequested;
      }
      
      public function getViewProfileRequested() : ISignal
      {
         return this._viewProfileRequested;
      }
      
      public function getActivateWindowRequested() : ISignal
      {
         return this._activateWindowRequested;
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
         var _loc4_:Point = null;
         var _loc3_:Point = this.dockedTabBackground.setExplicitSize(param1,param2);
         if(param1 > 100 || Boolean(this.dockedWindowTab.getMouseIsOver()))
         {
            _loc4_ = this.dockedTabCloseButton.setExplicitPosition(_loc3_.x - this.dockedTabCloseButton.getWidth() - 4,NaN);
            this.dockedTabLabel.setExplicitSize(_loc4_.x - 15,NaN);
            this.dockedTabCloseButton.setVisible(true);
         }
         else
         {
            this.dockedTabCloseButton.setVisible(false);
            this.dockedTabLabel.setExplicitSize(_loc3_.x - 15,NaN);
         }
         return new Rectangle(0,0,param1 || Number(this.dockedWindowTab.getWidth()),35);
      }
      
      override protected function updatePosition(param1:Number, param2:Number) : Point
      {
         var _loc3_:Rectangle = this.windowPane.getRect(this.windowPane.getAsset());
         var _loc4_:Number = this._availableSpace.right - param1 - _loc3_.right;
         this.windowPane.setExplicitPosition(_loc3_.left + Math.min(_loc4_,0),NaN);
         return super.updatePosition(param1,param2);
      }
      
      public function setAvailableSpace(param1:Rectangle) : void
      {
         this._availableSpace = param1;
         this.invalidateLayout();
      }
   }
}

