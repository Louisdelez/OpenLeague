package com.riotgames.platform.gameclient.chat.views.chatpanel
{
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.provider.SoundProviderProxy;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.gameclient.chat.controllers.PrivacyListController;
   import com.riotgames.platform.gameclient.chat.domain.ChatMessageType;
   import com.riotgames.platform.gameclient.chat.domain.ChatMessageVO;
   import com.riotgames.platform.gameclient.chat.mediator.ChatViewMediatorImpl;
   import com.riotgames.pvpnet.system.wordfilter.WordFilter;
   import flash.accessibility.*;
   import flash.data.*;
   import flash.debugger.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filesystem.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.html.*;
   import flash.html.script.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import mx.binding.*;
   import mx.containers.Canvas;
   import mx.controls.TextArea;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.ScrollEvent;
   import mx.events.ScrollEventDirection;
   import mx.formatters.DateFormatter;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.managers.ISystemManager;
   import mx.styles.*;
   import mx.utils.ObjectUtil;
   import org.igniterealtime.xiff.conference.RoomOccupant;
   import org.igniterealtime.xiff.data.im.RosterGroup;
   import org.igniterealtime.xiff.events.RoomEvent;
   
   public class CoreChatTextArea extends Canvas
   {
      
      public static const maxLines:int = 400;
      
      public static const cullLinesCount:int = 200;
      
      public static const TIMEOUT_TIME:int = 5000;
      
      public static const NEW_MESSAGE:String = "newMessage";
      
      [Inject]
      public var privacyListController:PrivacyListController;
      
      private var isChatMessageListTailed:Boolean = true;
      
      private var textAreaChatMessageList:TextArea = null;
      
      [Inject]
      public var chatController:ChatController;
      
      private var _1806550482chatRoomDisconnected:Boolean = true;
      
      private var messagesDisplayedCount:int = 0;
      
      private var chatSpamPenaltyTimer:Timer = new Timer(10000);
      
      public var soundManager:ISoundProvider = SoundProviderProxy.instance;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public var wordFilter:WordFilter;
      
      private var _1648362389textAreaContainer_c:Canvas;
      
      private var _chatRoom:ChatRoom;
      
      private var dateFormatter:DateFormatter = null;
      
      private var setChatRoomAfterAddedToStage:Boolean = false;
      
      private var roomsTimeoutId:int;
      
      private var _newChatRoom:ChatRoom;
      
      [Inject]
      private var _660759600chatViewMediator:ChatViewMediatorImpl;
      
      private var timeoutTimer:Timer = null;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":Canvas,
               "id":"textAreaContainer_c",
               "stylesFactory":function():void
               {
                  this.backgroundAlpha = 0;
                  this.verticalScrollBarStyleName = "blueGlassScrollBar";
                  this.borderStyle = "none";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "cacheAsBitmap":true,
                     "percentWidth":100,
                     "percentHeight":100,
                     "horizontalScrollPolicy":"off"
                  };
               }
            })]};
         }
      });
      
      public var showTimeStamp:Boolean = false;
      
      public var disabled:Boolean = false;
      
      private var _787566978chatRoomFull:Boolean = false;
      
      public function CoreChatTextArea()
      {
         super();
         mx_internal::_document = this;
         this.addEventListener("addedToStage",this.___CoreChatTextArea_Canvas1_addedToStage);
         this.addEventListener("initialize",this.___CoreChatTextArea_Canvas1_initialize);
         this.addEventListener("creationComplete",this.___CoreChatTextArea_Canvas1_creationComplete);
      }
      
      private function onChatSpamPenaltyComplete(param1:TimerEvent) : void
      {
         var _loc2_:Timer = param1.currentTarget as Timer;
         this.disabled = false;
         dispatchEvent(new Event("endSpamPenalty"));
         this.chatSpamPenaltyTimer.stop();
      }
      
      public function set chatRoomFull(param1:Boolean) : void
      {
         var _loc2_:Object = this._787566978chatRoomFull;
         if(_loc2_ !== param1)
         {
            this._787566978chatRoomFull = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatRoomFull",_loc2_,param1));
         }
      }
      
      private function onUserListChanged(param1:CollectionEvent) : void
      {
         this.removeTimer();
         if(this.roomsTimeoutId == 0 && param1.kind != CollectionEventKind.REFRESH)
         {
            this.roomsTimeoutId = setTimeout(this.refreshRooms,50);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get textAreaContainer_c() : Canvas
      {
         return this._1648362389textAreaContainer_c;
      }
      
      override public function initialize() : void
      {
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         super.initialize();
      }
      
      private function onVerticalScrollBar() : void
      {
         this.recreateTextArea(this.textAreaChatMessageList.systemManager);
         this.textAreaChatMessageList.width -= this.textAreaContainer_c.verticalScrollBar.width;
      }
      
      public function redrawAllMessages() : void
      {
         var _loc1_:Array = null;
         var _loc2_:ChatMessageVO = null;
         if(this.chatRoom == null || this.textAreaChatMessageList == null)
         {
            return;
         }
         this.messagesDisplayedCount = 0;
         this.textAreaChatMessageList.htmlText = "";
         if(this.chatRoom.chatMessages.length > CoreChatTextArea.maxLines)
         {
            _loc1_ = this.chatRoom.chatMessages.source.splice(this.chatRoom.chatMessages.length - CoreChatTextArea.cullLinesCount,this.chatRoom.chatMessages.length);
         }
         else
         {
            _loc1_ = this.chatRoom.chatMessages.source;
         }
         for each(_loc2_ in _loc1_)
         {
            this.addChatMessage(_loc2_);
         }
      }
      
      private function initializeHandler() : void
      {
         this.wordFilter = WordFilter.instance;
         this.dateFormatter = new DateFormatter();
         this.dateFormatter.formatString = "[L:NN] ";
      }
      
      private function addedToStageHandler(param1:Event) : void
      {
         if(this.setChatRoomAfterAddedToStage && Boolean(this._newChatRoom))
         {
            this.chatRoom = this._newChatRoom;
         }
      }
      
      private function setupTimeout() : void
      {
         if(this.chatRoom != null && this.chatRoom.isActive != false)
         {
            return;
         }
         if(this.timeoutTimer != null && this.timeoutTimer.running)
         {
            return;
         }
         if(this.timeoutTimer == null)
         {
            this.timeoutTimer = new Timer(CoreChatTextArea.TIMEOUT_TIME,1);
         }
         this.timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.disconnectErrorHandler);
         this.timeoutTimer.start();
      }
      
      public function ___CoreChatTextArea_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      private function addChatMessage(param1:ChatMessageVO) : void
      {
         if(this.isMessageBlocked(param1))
         {
            return;
         }
         if(this.textAreaChatMessageList == null)
         {
            return;
         }
         ++this.messagesDisplayedCount;
         if(this.messagesDisplayedCount > CoreChatTextArea.maxLines)
         {
            this.redrawAllMessages();
            return;
         }
         var _loc2_:String = "";
         _loc2_ += "<p>";
         _loc2_ += this.formatMessage(param1);
         _loc2_ += "</p>";
         this.textAreaChatMessageList.htmlText += _loc2_;
      }
      
      [Bindable(event="propertyChange")]
      public function get chatRoomDisconnected() : Boolean
      {
         return this._1806550482chatRoomDisconnected;
      }
      
      private function isMessageBlocked(param1:ChatMessageVO) : Boolean
      {
         var _loc2_:String = param1.rosterItem == null ? null : param1.rosterItem.jid.bareJID;
         return !_loc2_ || this.privacyListController != null && Boolean(this.privacyListController.isBlocked(_loc2_));
      }
      
      private function onCreationComplete() : void
      {
         this.setupTimeout();
         this.textAreaContainer_c.addEventListener(ScrollEvent.SCROLL,this.onChatMessageListScrolled);
      }
      
      private function removeTimer(param1:Event = null) : void
      {
         if(this.timeoutTimer != null)
         {
            this.timeoutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.disconnectErrorHandler);
            this.timeoutTimer.stop();
         }
         this.chatRoomDisconnected = false;
      }
      
      [Bindable(event="propertyChange")]
      public function get chatRoomFull() : Boolean
      {
         return this._787566978chatRoomFull;
      }
      
      private function chatMessageReceived(param1:CollectionEvent) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Boolean = false;
         var _loc5_:Object = null;
         if(param1.kind == CollectionEventKind.RESET || this.chatController == null)
         {
            return;
         }
         var _loc2_:ChatMessageVO = param1.items[0] as ChatMessageVO;
         if(_loc2_.rosterItem != null && _loc2_.rosterItem.jid.node != this.chatController.currentUserJID.node)
         {
            this.removeTimer();
            _loc4_ = true;
            for each(_loc5_ in param1.items)
            {
               if(_loc5_ is ChatMessageVO)
               {
                  if(!this.isMessageBlocked(_loc5_ as ChatMessageVO))
                  {
                     _loc4_ = false;
                  }
               }
            }
            switch(_loc2_.type)
            {
               case ChatMessageType.PUBLIC:
                  if(!_loc4_)
                  {
                     this.soundManager.play(AudioKeys.SOUND_MSG_RECEIVE);
                  }
                  this.dispatchEvent(new Event(NEW_MESSAGE));
                  break;
               case ChatMessageType.JOIN:
                  this.soundManager.play(AudioKeys.SOUND_CHAT_JOIN);
                  break;
               case ChatMessageType.LEAVE:
                  this.soundManager.play(AudioKeys.SOUND_CHAT_LEAVE);
                  break;
               case ChatMessageType.PRIVATE:
                  if(!_loc4_)
                  {
                     this.soundManager.play(AudioKeys.SOUND_PM_RECEIVE);
                  }
            }
         }
         for each(_loc3_ in param1.items)
         {
            if(_loc3_ is ChatMessageVO)
            {
               this.addChatMessage(_loc3_ as ChatMessageVO);
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set chatRoom(param1:ChatRoom) : void
      {
         var _loc2_:Object = this.chatRoom;
         if(_loc2_ !== param1)
         {
            this._1437342803chatRoom = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatRoom",_loc2_,param1));
         }
      }
      
      private function resizeTextAreaChatMessageList() : void
      {
         if(Boolean(this.textAreaContainer_c.verticalScrollBar) && this.textAreaChatMessageList.width != this.textAreaContainer_c.width - this.textAreaContainer_c.verticalScrollBar.width)
         {
            this.textAreaChatMessageList.width = this.textAreaContainer_c.width - this.textAreaContainer_c.verticalScrollBar.width;
            this.redrawAllMessages();
         }
      }
      
      private function onChatMessageListScrolled(param1:ScrollEvent) : void
      {
         if(param1.direction == ScrollEventDirection.VERTICAL)
         {
            this.isChatMessageListTailed = param1.position >= this.textAreaContainer_c.maxVerticalScrollPosition - 2;
         }
      }
      
      public function ___CoreChatTextArea_Canvas1_addedToStage(param1:Event) : void
      {
         this.addedToStageHandler(param1);
      }
      
      private function set _1437342803chatRoom(param1:ChatRoom) : void
      {
         var _loc3_:Object = null;
         if(this.chatController == null)
         {
            this.setChatRoomAfterAddedToStage = true;
            this._newChatRoom = param1;
            return;
         }
         this.chatRoomDisconnected = false;
         this.chatRoomFull = false;
         var _loc2_:String = null;
         if(this.textAreaChatMessageList != null)
         {
            this.textAreaChatMessageList.htmlText = "";
         }
         if(this._chatRoom != null)
         {
            this._chatRoom.chatMessages.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.chatMessageReceived);
            this._chatRoom.userListChangedSignal.remove(this.onUserListChanged);
            this._chatRoom.roomJoinSignal.remove(this.removeTimer);
            this._chatRoom.otherUserJoinedRoomSignal.remove(this.removeTimer);
            this._chatRoom.maxUsersErrorSignal.remove(this.removeTimer);
            _loc2_ = this._chatRoom.roomName;
         }
         this._chatRoom = param1;
         this.setupTimeout();
         if(param1 != null && _loc2_ == null)
         {
            _loc2_ = this._chatRoom.roomName;
         }
         if(this._chatRoom != null)
         {
            this._chatRoom.chatMessages.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.chatMessageReceived);
            this._chatRoom.setChatRoomSortFunction(this.sortRoomByStatus);
            this._chatRoom.userListChangedSignal.add(this.onUserListChanged);
            this._chatRoom.roomJoinSignal.add(this.removeTimer);
            this._chatRoom.otherUserJoinedRoomSignal.add(this.removeTimer);
            this._chatRoom.maxUsersErrorSignal.add(this.removeTimer);
            if(Boolean(this._chatRoom.subject) || Boolean(this._chatRoom.roomFull))
            {
               this.removeTimer();
               if(this._chatRoom.subject)
               {
                  this.label = this._chatRoom.subject;
               }
               if(this._chatRoom.roomFull)
               {
                  this.chatRoomFull = true;
               }
            }
            if(this._chatRoom.chatMessages.length > 0)
            {
               for each(_loc3_ in this._chatRoom.chatMessages)
               {
                  if(_loc3_ is ChatMessageVO)
                  {
                     this.addChatMessage(_loc3_ as ChatMessageVO);
                  }
               }
            }
            if(this.chatController != null)
            {
               this.chatController.addEventListener("currentStateChanged",this.onChatStateChanged);
               this.chatController.addEventListener("error",this.onChatControllerError,false,0,true);
               this.chatController.getChatSpammerErrorSignal().add(this.onChatControllerError);
               this.chatSpamPenaltyTimer.addEventListener(TimerEvent.TIMER,this.onChatSpamPenaltyComplete);
            }
         }
         else if(_loc2_ != null)
         {
            this.chatController.removeEventListener("currentStateChanged",this.onChatStateChanged);
            this.chatController.removeEventListener("error",this.onChatControllerError);
            this.chatController.getChatSpammerErrorSignal().remove(this.onChatControllerError);
            this.chatSpamPenaltyTimer.removeEventListener(TimerEvent.TIMER,this.onChatSpamPenaltyComplete);
         }
      }
      
      private function formatMessage(param1:ChatMessageVO) : String
      {
         if(!param1)
         {
            return "";
         }
         if(!param1.rosterItem && param1.type != ChatMessageType.SYSTEM)
         {
            return "";
         }
         var _loc2_:String = "";
         switch(param1.type)
         {
            case ChatMessageType.JOIN:
               _loc2_ += "<font color=\'#CCFF00\'>";
               if(this.showTimeStamp)
               {
                  _loc2_ += this.dateFormatter.format(param1.timeStamp);
               }
               _loc2_ += resourceManager.getString("resources","chat_groupChatWindow_userJoinMessage",[param1.rosterItem.displayName]);
               _loc2_ += "</font>";
               break;
            case ChatMessageType.LEAVE:
               _loc2_ += "<font color=\'#CCFF00\'>";
               if(this.showTimeStamp)
               {
                  _loc2_ += this.dateFormatter.format(param1.timeStamp);
               }
               _loc2_ += resourceManager.getString("resources","chat_groupChatWindow_userLeaveMessage",[param1.rosterItem.displayName]);
               _loc2_ += "</font>";
               break;
            case ChatMessageType.DELEGATE:
               _loc2_ += "<font color=\'#CCFF00\'>";
               _loc2_ += param1.body;
               _loc2_ += "</font>";
               break;
            case ChatMessageType.REVOKE:
               _loc2_ += "<font color=\'#CCFF00\'>";
               _loc2_ += param1.body;
               _loc2_ += "</font>";
               break;
            case ChatMessageType.PUBLIC:
               this.clearStyle("color");
               _loc2_ += "<font color=\'#00CCFF\'>";
               if(this.showTimeStamp)
               {
                  _loc2_ += this.dateFormatter.format(param1.timeStamp);
               }
               _loc2_ += param1.rosterItem.displayName;
               _loc2_ += ": ";
               _loc2_ += "</font>";
               _loc2_ += this.wordFilter.maskOffensiveWords(param1.body);
               break;
            case ChatMessageType.SYSTEM:
               this.clearStyle("color");
               _loc2_ += "<font color=\'#FF771C\'>";
               _loc2_ += param1.body;
               _loc2_ += "</font>";
               break;
            default:
               _loc2_ = "";
         }
         return _loc2_;
      }
      
      private function handleMaxUsers(param1:RoomEvent) : void
      {
         if(param1.errorInThisRoom)
         {
            this.chatRoomFull = true;
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get chatViewMediator() : ChatViewMediatorImpl
      {
         return this._660759600chatViewMediator;
      }
      
      public function get chatRoom() : ChatRoom
      {
         return this._chatRoom;
      }
      
      public function set textAreaContainer_c(param1:Canvas) : void
      {
         var _loc2_:Object = this._1648362389textAreaContainer_c;
         if(_loc2_ !== param1)
         {
            this._1648362389textAreaContainer_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"textAreaContainer_c",_loc2_,param1));
         }
      }
      
      private function onChatStateChanged(param1:Event) : void
      {
         if(!this.chatController)
         {
            return;
         }
         switch(this.chatController.currentState)
         {
            case ChatController.ONLINE:
               this.chatRoomDisconnected = false;
               break;
            default:
               this.chatRoomDisconnected = true;
         }
      }
      
      private function refreshRooms() : void
      {
         if(this.roomsTimeoutId > 0 && Boolean(this.chatRoom))
         {
            this.chatRoom.refreshRoom();
            this.roomsTimeoutId = 0;
         }
      }
      
      public function set chatViewMediator(param1:ChatViewMediatorImpl) : void
      {
         var _loc2_:Object = this._660759600chatViewMediator;
         if(_loc2_ !== param1)
         {
            this._660759600chatViewMediator = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatViewMediator",_loc2_,param1));
         }
      }
      
      private function sortRoomByStatus(param1:Object, param2:Object, param3:Array = null) : int
      {
         var _loc6_:int = 0;
         var _loc4_:RoomOccupant = param1 as RoomOccupant;
         var _loc5_:RoomOccupant = param2 as RoomOccupant;
         _loc6_ = int(ObjectUtil.numericCompare(RosterGroup.rankShow(_loc4_.show),RosterGroup.rankShow(_loc5_.show)));
         if(_loc6_ == 0 && _loc4_.displayName.toLowerCase() != _loc5_.displayName.toLowerCase())
         {
            _loc6_ = _loc4_.displayName.toLowerCase() > _loc5_.displayName.toLowerCase() ? 1 : -1;
         }
         return _loc6_;
      }
      
      public function scrollChatDisplayToBottom() : void
      {
         if(this.textAreaContainer_c != null && this.textAreaContainer_c.maxVerticalScrollPosition > 0)
         {
            this.textAreaContainer_c.verticalScrollPosition = this.textAreaContainer_c.maxVerticalScrollPosition;
         }
      }
      
      private function disconnectErrorHandler(param1:TimerEvent) : void
      {
         if(this.chatController != null)
         {
            if(this.chatRoom != null && this.chatRoom.isActive == false)
            {
            }
            if(this.chatRoom == null || this.chatRoom.isActive == false)
            {
               this.chatRoomDisconnected = true;
            }
         }
      }
      
      public function ___CoreChatTextArea_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.initializeHandler();
      }
      
      public function recreateTextArea(param1:ISystemManager) : void
      {
         if(this.textAreaContainer_c == null)
         {
            return;
         }
         if(this.textAreaChatMessageList != null)
         {
            this.textAreaChatMessageList.removeEventListener(FlexEvent.UPDATE_COMPLETE,this.onChatMessageListUpdated);
            this.textAreaChatMessageList.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onChatTextMouseWheel);
            this.textAreaContainer_c.removeChild(this.textAreaChatMessageList);
         }
         this.textAreaChatMessageList = new TextArea();
         this.textAreaChatMessageList.tabEnabled = false;
         this.textAreaContainer_c.addChild(this.textAreaChatMessageList);
         this.textAreaChatMessageList.setStyle("styleName",this.getStyle("stylename"));
         this.textAreaChatMessageList.setStyle("focusAlpha",0);
         this.textAreaChatMessageList.editable = false;
         this.textAreaChatMessageList.wordWrap = true;
         this.textAreaChatMessageList.systemManager = param1;
         this.textAreaChatMessageList.x = 0;
         this.textAreaChatMessageList.width = this.textAreaContainer_c.width;
         this.textAreaChatMessageList.y = 0;
         this.textAreaChatMessageList.height = this.textAreaContainer_c.height;
         this.textAreaChatMessageList.systemManager = param1;
         this.textAreaChatMessageList.verticalScrollPolicy = "false";
         this.textAreaChatMessageList.addEventListener(FlexEvent.UPDATE_COMPLETE,this.onChatMessageListUpdated);
         this.textAreaChatMessageList.addEventListener(MouseEvent.MOUSE_WHEEL,this.onChatTextMouseWheel);
         this.redrawAllMessages();
      }
      
      private function onChatMessageListUpdated(param1:FlexEvent) : void
      {
         this.textAreaChatMessageList.height = this.textAreaChatMessageList.textHeight + 15;
         if(this.isChatMessageListTailed)
         {
            this.scrollChatDisplayToBottom();
            this.resizeTextAreaChatMessageList();
         }
      }
      
      public function set chatRoomDisconnected(param1:Boolean) : void
      {
         var _loc2_:Object = this._1806550482chatRoomDisconnected;
         if(_loc2_ !== param1)
         {
            this._1806550482chatRoomDisconnected = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatRoomDisconnected",_loc2_,param1));
         }
      }
      
      private function onChatControllerError(param1:Object = null) : void
      {
         if(this.chatController == null)
         {
            return;
         }
         var _loc2_:Object = this.chatController.errorDataProvider.source[this.chatController.errorDataProvider.length - 1];
         if(_loc2_.errorCode == 500 && _loc2_.errorCondition == "resource-constraint")
         {
            this.disabled = true;
            dispatchEvent(new Event("startSpamPenalty"));
            this.chatSpamPenaltyTimer.start();
         }
      }
      
      private function onChatTextMouseWheel(param1:MouseEvent) : void
      {
         this.textAreaContainer_c.verticalScrollPosition -= param1.delta * 5;
         this.isChatMessageListTailed = this.textAreaContainer_c.verticalScrollPosition >= this.textAreaContainer_c.maxVerticalScrollPosition - 2;
      }
   }
}

