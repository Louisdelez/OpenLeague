package com.riotgames.platform.gameclient.chat.controllers
{
   import blix.action.IAction;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.RiotServiceConfig;
   import com.riotgames.platform.common.services.ChatService;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.config.ChatConfig;
   import com.riotgames.platform.gameclient.chat.domain.ChatMessageType;
   import com.riotgames.platform.gameclient.chat.domain.ChatMessageVO;
   import com.riotgames.platform.gameclient.chat.event.PlayerRoomEvent;
   import com.riotgames.platform.gameclient.chat.factory.IChatRoomActionFactory;
   import com.riotgames.platform.gameclient.chat.trackers.GroupChatBehaviorTracker;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.pvpnet.system.wordfilter.WordFilter;
   import com.riotgames.util.json.jsonEncode;
   import com.riotgames.util.logging.ErrorUtil;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import flash.xml.XMLNode;
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.events.CollectionEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.utils.StringUtil;
   import org.igniterealtime.xiff.conference.Room;
   import org.igniterealtime.xiff.conference.RoomOccupant;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.data.Message;
   import org.igniterealtime.xiff.data.Presence;
   import org.igniterealtime.xiff.data.XMPPStanza;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   import org.igniterealtime.xiff.events.ConnectionSuccessEvent;
   import org.igniterealtime.xiff.events.DisconnectionEvent;
   import org.igniterealtime.xiff.events.LoginEvent;
   import org.igniterealtime.xiff.events.RoomEvent;
   
   public class ChatRoom extends EventDispatcher
   {
      
      public static const ROLE_PARTICIPANT:String = "participant";
      
      public static const ROLE_VISITOR:String = "visitor";
      
      public static const HIDDEN_MESSAGE_ID_PREFIX:String = "hm_";
      
      private static const ROOM_LOCKED_RETRY_TIMING:Array = [200,400,1000,2000,5000,5000];
      
      private static const ROOM_JOIN_SPAM_DELAY:int = 5000;
      
      public var roomFull:Boolean = false;
      
      private var chatController:ChatController;
      
      private var _disconnected:Boolean = false;
      
      private var wordFilter:WordFilter;
      
      public var maxUsersErrorSignal:Signal = new Signal();
      
      private var roomLockedRejoinCount:int = 0;
      
      private var _isActive:Boolean = false;
      
      private var showJoinMessages:Boolean = false;
      
      private var chatService:ChatService;
      
      public var otherUserLeaveSignal:Signal = new Signal();
      
      private var _chatRoomActionFactory:IChatRoomActionFactory = null;
      
      private var _chatSuspended:Boolean = false;
      
      public var chatSuspendedChangeSignal:Signal = new Signal();
      
      private var messageTimer:Timer;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _enableAutoJoinOption:Boolean = true;
      
      private var _chatServiceReconnectedSignal:Signal = new Signal();
      
      private var _chatMessages:ArrayCollection = new ArrayCollection();
      
      public var otherUserJoinedRoomSignal:Signal = new Signal();
      
      public var roomJoinSignal:Signal = new Signal();
      
      private var roomType:String;
      
      private var _receivedGroupChatMessageSignal:Signal = new Signal();
      
      private var lastJoinAttempt:int = 0;
      
      private var _currentDisplayName:String;
      
      private var isExplicitLeave:Boolean;
      
      private var room:Room;
      
      private var _subject:String;
      
      private var _chatServiceDisconnectedSignal:Signal = new Signal();
      
      public var userListChangedSignal:Signal = new Signal();
      
      private var chatSuspensionTimer:Timer;
      
      private var presenceController:PresenceController;
      
      public function ChatRoom(param1:ChatController, param2:ChatService, param3:PresenceController, param4:UnescapedJID, param5:String, param6:String)
      {
         super();
         this.presenceController = param3;
         this.wordFilter = param1.wordFilter;
         this.chatService = param2;
         this.chatController = param1;
         this.roomType = param6;
         this.room = new Room(this.chatService.getConnection());
         this.room.enableAutoUpdate();
         this.room.roomJID = param4;
         this.room.password = param5;
         this.room.nickname = param1.currentUserDisplayName;
      }
      
      public static function createRoomJID(param1:String, param2:String, param3:String, param4:Boolean, param5:Boolean, param6:RiotServiceConfig) : UnescapedJID
      {
         var _loc7_:UnescapedJID = null;
         if(param5)
         {
            param2 = determineConferenceName(param1,param2,param3,param4,param6);
            _loc7_ = new UnescapedJID(param1 + "@" + param2 + "." + ClientConfig.JABBER_DOMAIN);
         }
         else
         {
            _loc7_ = new UnescapedJID(param1 + "." + ClientConfig.JABBER_DOMAIN);
         }
         return _loc7_;
      }
      
      private static function determineConferenceName(param1:String, param2:String, param3:String, param4:Boolean, param5:RiotServiceConfig) : String
      {
         var _loc6_:Boolean = param3 != null;
         if(Boolean(param2))
         {
            return param2;
         }
         if(_loc6_ && !param4)
         {
            return param5.xmpp_muc_secure_conference_name;
         }
         if(param4 && !_loc6_)
         {
            return param5.xmpp_muc_global_name;
         }
         if(param4 && _loc6_)
         {
            throw "Error: can\'t be both public chat room and have a password. (roomName=" + param1 + ", roomPassword=" + param3 + ")";
         }
         return param5.xmpp_muc_conference_name;
      }
      
      public function getNickName() : String
      {
         return this.room.nickname;
      }
      
      public function getRoomOccupants() : ArrayCollection
      {
         if(this.room != null)
         {
            return this.room as ArrayCollection;
         }
         return new ArrayCollection();
      }
      
      public function get roomName() : String
      {
         if(this.room != null)
         {
            return this.room.roomName;
         }
         return null;
      }
      
      public function getRoomOccupantByDisplayName(param1:String) : RoomOccupant
      {
         var _loc2_:RoomOccupant = null;
         for each(_loc2_ in this.room)
         {
            if(_loc2_.displayName == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function invite(param1:RosterItemVO, param2:String, param3:String) : void
      {
         var _loc4_:Object = {};
         _loc4_["message"] = param2;
         _loc4_["subject"] = this._subject;
         _loc4_["type"] = param3;
         var _loc5_:String = jsonEncode(_loc4_);
         this.room.invite(param1.jid,_loc5_);
      }
      
      public function setChatRoomSortFunction(param1:Function) : void
      {
         var _loc2_:Sort = new Sort();
         _loc2_.compareFunction = param1;
         this.room.sort = _loc2_;
         this.room.refresh();
      }
      
      public function setNickName(param1:String) : void
      {
         if(this.room.nickname != param1)
         {
            this.room.nickname = param1;
         }
      }
      
      public function join(param1:Boolean = false) : void
      {
         var presenceStatus:String;
         var now:int;
         var isRejoin:Boolean = param1;
         if(this.room.isActive)
         {
            return;
         }
         now = getTimer();
         if(now - this.lastJoinAttempt < ROOM_JOIN_SPAM_DELAY)
         {
            return;
         }
         this.lastJoinAttempt = now;
         this.showJoinMessages = false;
         if(!isRejoin)
         {
            this.roomLockedRejoinCount = 0;
            this.addEventListeners();
         }
         presenceStatus = null;
         try
         {
            presenceStatus = this.presenceController.presenceStatus.getNode().toString();
         }
         catch(e:Error)
         {
            logger.error(ErrorUtil.makeErrorMessage(e,"Failed to get current presence status. stack:" + e.getStackTrace()));
         }
         this.room.join(false,null,presenceStatus);
      }
      
      public function getRoomType() : String
      {
         return this.roomType;
      }
      
      public function getChatServiceDisconnectedSignal() : ISignal
      {
         return this._chatServiceDisconnectedSignal;
      }
      
      private function room_onUserListChanged(param1:CollectionEvent) : void
      {
         this.userListChangedSignal.dispatch(param1);
      }
      
      [Bindable("disconnectedChanged")]
      public function get disconnected() : Boolean
      {
         return this._disconnected;
      }
      
      public function triggerChatSuspension(param1:Number = 10000) : void
      {
         if(!this._chatSuspended)
         {
            this._chatSuspended = true;
            this.chatSuspendedChangeSignal.dispatch();
            if(this.chatSuspensionTimer == null)
            {
               this.chatSuspensionTimer = new Timer(param1,1);
               this.chatSuspensionTimer.addEventListener(TimerEvent.TIMER,this.relieveSuspension);
            }
            else
            {
               this.chatSuspensionTimer.delay = param1;
            }
            this.chatSuspensionTimer.start();
         }
      }
      
      private function room_groupMessageHandler(param1:RoomEvent) : void
      {
         var rosterItem:RosterItemVO;
         var from:String;
         var displayName:String;
         var chatMessage:ChatMessageVO;
         var event:RoomEvent = param1;
         var message:Message = event.data as Message;
         if(message == null || message.body == "")
         {
            return;
         }
         if(Boolean(message.id) && Boolean(message.id.length >= 3) && message.id.substr(0,3) == HIDDEN_MESSAGE_ID_PREFIX)
         {
            if(message.from.resource == this.chatController.currentUserDisplayName)
            {
               return;
            }
            try
            {
               dispatchEvent(new PlayerRoomEvent(message));
            }
            catch(e:Error)
            {
               logger.error(ErrorUtil.makeErrorMessage(e,"Failed to dispatch hidden message event. stack:" + e.getStackTrace()));
            }
            return;
         }
         from = message.from.toString();
         displayName = from.substring(from.indexOf("/") + 1);
         rosterItem = this.getRosterItemByDisplayName(displayName);
         chatMessage = new ChatMessageVO();
         chatMessage.type = ChatMessageType.PUBLIC;
         chatMessage.body = this.wordFilter.maskOffensiveWords(message.body);
         chatMessage.rosterItem = rosterItem;
         if(chatMessage.rosterItem != null && !this.room.isThisUser(message.from.unescaped))
         {
            this.addMessageToBuffer(chatMessage);
            this._receivedGroupChatMessageSignal.dispatch(rosterItem.displayName,message.body);
            GroupChatBehaviorTracker.instance.incrementGroupChatMessageReceived_InASession(this.getRoomJID(),chatMessage.body);
         }
      }
      
      public function setEnableAutoJoinOption(param1:Boolean) : void
      {
         this._enableAutoJoinOption = param1;
      }
      
      [Bindable("currentDisplayNameChanged")]
      public function get currentDisplayName() : String
      {
         return this._currentDisplayName;
      }
      
      private function removeListeners() : void
      {
         if(this.room != null && this.isExplicitLeave)
         {
            this.room.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.room_onUserListChanged);
            this.room.removeEventListener(RoomEvent.ROOM_JOIN,this.room_roomJoinHandler);
            this.room.removeEventListener(RoomEvent.GROUP_MESSAGE,this.room_groupMessageHandler);
            this.room.removeEventListener(RoomEvent.USER_JOIN,this.room_userJoinHandler);
            this.room.removeEventListener(RoomEvent.USER_DEPARTURE,this.room_userDepartureHandler);
            this.room.removeEventListener(RoomEvent.LOCKED_ERROR,this.room_roomLocked);
            this.room.removeEventListener(RoomEvent.MAX_USERS_ERROR,this.room_roomFullHandler);
            this.room.removeEventListener(RoomEvent.PASSWORD_ERROR,this.room_incorrectPasswordHandler);
            this.room.removeEventListener(RoomEvent.SUBJECT_CHANGE,this.room_subjectChangeHandler);
            this.chatService.getConnection().removeEventListener(DisconnectionEvent.DISCONNECT,this.conn_disconnectHandler);
            this.chatService.getConnection().removeEventListener(ConnectionSuccessEvent.CONNECT_SUCCESS,this.conn_connectSuccessHandler);
            this.chatService.getConnection().removeEventListener(LoginEvent.LOGIN,this.conn_loginHandler);
         }
      }
      
      private function updateBufferedMessages(param1:TimerEvent) : void
      {
         this.messageTimer.stop();
         this._chatMessages.enableAutoUpdate();
         this._chatMessages.disableAutoUpdate();
      }
      
      public function getChatServiceReconnectedSignal() : ISignal
      {
         return this._chatServiceReconnectedSignal;
      }
      
      public function sendHiddenMessage(param1:String) : void
      {
         var _loc3_:Message = null;
         var _loc2_:String = StringUtil.trim(param1);
         if(_loc2_.length > 0 && Boolean(this.chatService.getConnection().isLoggedIn()))
         {
            _loc3_ = new Message(this.room.roomJID.escaped,XMPPStanza.generateID(HIDDEN_MESSAGE_ID_PREFIX),this.wrapWithCDATA(_loc2_),null,Message.GROUPCHAT_TYPE);
            this.room.sendMessageWithExtension(_loc3_);
         }
      }
      
      public function refreshRoom() : void
      {
         if(this.room != null)
         {
            this.room.refresh();
         }
      }
      
      [Bindable("subjectChanged")]
      public function get subject() : String
      {
         return this._subject;
      }
      
      public function sendMessage(param1:String) : void
      {
         var _loc2_:String = StringUtil.trim(param1);
         if(_loc2_.length > 0 && Boolean(this.chatService.getConnection().isLoggedIn()))
         {
            this.addMessageToBuffer(this.createChatMessageFromString(this.wordFilter.maskOffensiveWords(_loc2_)),false);
            this.room.sendMessage(_loc2_);
            GroupChatBehaviorTracker.instance.incrementGroupChatMessageSent_InASession(this.getRoomJID(),_loc2_);
         }
      }
      
      public function set subject(param1:String) : void
      {
         this._subject = param1;
      }
      
      public function get chatRoomActionFactory() : IChatRoomActionFactory
      {
         return this._chatRoomActionFactory;
      }
      
      public function get role() : String
      {
         return this.room.role;
      }
      
      private function room_roomFullHandler(param1:RoomEvent) : void
      {
         if(param1.errorInThisRoom)
         {
            this.roomFull = true;
            this.maxUsersErrorSignal.dispatch(param1);
         }
      }
      
      private function conn_connectSuccessHandler(param1:Event) : void
      {
         this._disconnected = false;
         dispatchEvent(new Event("disconnectedChanged"));
         this._chatServiceReconnectedSignal.dispatch();
      }
      
      private function room_roomJoinHandler(param1:RoomEvent) : void
      {
         var _loc2_:Room = param1.target as Room;
         if(_loc2_ != null)
         {
            _loc2_.addEventListener(RoomEvent.ROOM_LEAVE,this.room_roomLeaveHandler);
         }
         this._currentDisplayName = this.room.nickname;
         dispatchEvent(new Event("currentDisplayNameChanged"));
         this._isActive = true;
         this.roomFull = false;
         dispatchEvent(new Event("isActiveChanged"));
         this.roomJoinSignal.dispatch();
      }
      
      private function wrapWithCDATA(param1:String) : String
      {
         return param1 == null ? param1 : "<![CDATA[" + param1 + "]]>";
      }
      
      private function room_userDepartureHandler(param1:RoomEvent) : void
      {
         var _loc2_:RosterItemVO = this.getRosterItemByDisplayName(param1.nickname);
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:ChatMessageVO = new ChatMessageVO();
         _loc3_.type = ChatMessageType.LEAVE;
         _loc3_.body = _loc2_.uid;
         _loc3_.rosterItem = _loc2_;
         this.addMessageToBuffer(_loc3_);
         this.otherUserLeaveSignal.dispatch(param1);
      }
      
      public function getReceivedGroupChatMessageSignal() : ISignal
      {
         return this._receivedGroupChatMessageSignal;
      }
      
      private function room_userJoinHandler(param1:RoomEvent) : void
      {
         var _loc6_:ChatMessageVO = null;
         var _loc2_:Presence = param1.data as Presence;
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:String = param1.nickname;
         if(this.chatController.currentUserDisplayName == _loc3_)
         {
            this.showJoinMessages = true;
         }
         var _loc4_:RoomOccupant = this.getRoomOccupantByDisplayName(_loc3_);
         var _loc5_:RosterItemVO = RosterItemVO.get(_loc4_.jid,true);
         if(_loc5_ != null)
         {
            _loc5_.displayName = _loc3_;
            _loc5_.online = true;
            _loc5_.status = _loc2_.status;
            _loc6_ = new ChatMessageVO();
            _loc6_.type = ChatMessageType.JOIN;
            _loc6_.body = _loc5_.uid;
            _loc6_.rosterItem = _loc5_;
            if(this.showJoinMessages)
            {
               this.addMessageToBuffer(_loc6_);
            }
         }
         if(!this.showJoinMessages)
         {
            return;
         }
         this.otherUserJoinedRoomSignal.dispatch(param1);
      }
      
      private function room_subjectChangeHandler(param1:RoomEvent) : void
      {
         this._subject = param1.subject;
         dispatchEvent(new Event("subjectChanged"));
      }
      
      public function getRegisteredChatService() : ChatService
      {
         return this.chatService;
      }
      
      private function room_roomLocked(param1:RoomEvent) : void
      {
         if(this.roomLockedRejoinCount < ROOM_LOCKED_RETRY_TIMING.length)
         {
            setTimeout(this.join,ROOM_LOCKED_RETRY_TIMING[this.roomLockedRejoinCount],true);
            ++this.roomLockedRejoinCount;
         }
         else
         {
            this.logger.error("0001 room stayed locked through all join attempts! " + this.room.roomJID.bareJID);
         }
      }
      
      public function createChatMessageFromString(param1:String) : ChatMessageVO
      {
         if(param1 == null || param1 == "")
         {
            return null;
         }
         var _loc2_:RosterItemVO = this.getRosterItemByDisplayName(this.room.nickname);
         var _loc3_:ChatMessageVO = new ChatMessageVO();
         _loc3_.type = ChatMessageType.PUBLIC;
         _loc3_.body = param1;
         _loc3_.rosterItem = _loc2_;
         return _loc3_;
      }
      
      public function getChatSuspended() : Boolean
      {
         return this._chatSuspended;
      }
      
      public function leave() : void
      {
         this.isExplicitLeave = true;
         this.cleanRoom();
         this.room.leave();
      }
      
      private function conn_disconnectHandler(param1:Event) : void
      {
         this._disconnected = true;
         dispatchEvent(new Event("disconnectedChanged"));
         this._chatServiceDisconnectedSignal.dispatch();
      }
      
      private function room_incorrectPasswordHandler(param1:RoomEvent) : void
      {
         var _loc2_:Room = param1.target as Room;
         if(_loc2_ != null)
         {
            this.logger.error("0002 Authentication failure when attempting to join chat room!");
         }
      }
      
      private function addEventListeners() : void
      {
         if(this.room != null)
         {
            this.room.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.room_onUserListChanged);
            this.room.addEventListener(RoomEvent.ROOM_JOIN,this.room_roomJoinHandler);
            this.room.addEventListener(RoomEvent.GROUP_MESSAGE,this.room_groupMessageHandler);
            this.room.addEventListener(RoomEvent.USER_JOIN,this.room_userJoinHandler);
            this.room.addEventListener(RoomEvent.USER_DEPARTURE,this.room_userDepartureHandler);
            this.room.addEventListener(RoomEvent.LOCKED_ERROR,this.room_roomLocked);
            this.room.addEventListener(RoomEvent.MAX_USERS_ERROR,this.room_roomFullHandler);
            this.room.addEventListener(RoomEvent.PASSWORD_ERROR,this.room_incorrectPasswordHandler);
            this.room.addEventListener(RoomEvent.SUBJECT_CHANGE,this.room_subjectChangeHandler);
            this.chatService.getConnection().addEventListener(DisconnectionEvent.DISCONNECT,this.conn_disconnectHandler);
            this.chatService.getConnection().addEventListener(ConnectionSuccessEvent.CONNECT_SUCCESS,this.conn_connectSuccessHandler);
            this.chatService.getConnection().addEventListener(LoginEvent.LOGIN,this.conn_loginHandler);
         }
      }
      
      public function set chatRoomActionFactory(param1:IChatRoomActionFactory) : void
      {
         this._chatRoomActionFactory = param1;
      }
      
      public function changePresence(param1:String, param2:String, param3:XMLNode) : void
      {
         var _loc5_:Presence = null;
         var _loc4_:UnescapedJID = new UnescapedJID(this.getRoomJID().bareJID.toString() + "/" + param2);
         if(this._isActive)
         {
            if(DynamicClientConfigManager.getConfiguration(ChatConfig.NAMESPACE,ChatConfig.SEND_PRESENCE_UPDATES_TO_CHAT_ROOMS,false).getBoolean())
            {
               _loc5_ = new Presence(_loc4_.escaped,null,null,param1,param3.toString());
               if(Boolean(this.chatService.getConnection()))
               {
                  this.chatService.getConnection().send(_loc5_);
               }
            }
         }
      }
      
      [Bindable("isActiveChanged")]
      public function get isActive() : Boolean
      {
         return this._isActive;
      }
      
      private function getRosterItemByDisplayName(param1:String) : RosterItemVO
      {
         var _loc2_:RosterItemVO = null;
         var _loc3_:RoomOccupant = this.getRoomOccupantByDisplayName(param1);
         if(_loc3_ != null)
         {
            _loc2_ = new RosterItemVO(_loc3_.jid);
            _loc2_.displayName = _loc3_.displayName;
            _loc2_.status = _loc3_.status;
         }
         return _loc2_;
      }
      
      private function conn_loginHandler(param1:Event) : void
      {
         this.join(true);
      }
      
      [Bindable("chatMessagesChanged")]
      [Bindable("isActiveChanged")]
      public function get chatMessages() : ArrayCollection
      {
         return this._chatMessages;
      }
      
      public function addMessageToBuffer(param1:ChatMessageVO, param2:Boolean = true) : void
      {
         this._chatMessages.addItem(param1);
         if(param2)
         {
            if(this.messageTimer == null)
            {
               this.messageTimer = new Timer(250);
               this.messageTimer.addEventListener("timer",this.updateBufferedMessages);
            }
            if(!this.messageTimer.running)
            {
               this.messageTimer.start();
            }
         }
         else
         {
            this._chatMessages.enableAutoUpdate();
            this._chatMessages.disableAutoUpdate();
         }
      }
      
      private function relieveSuspension(param1:TimerEvent) : void
      {
         this._chatSuspended = false;
         this.chatSuspendedChangeSignal.dispatch();
      }
      
      public function customInvite(... rest) : void
      {
         if(this._chatRoomActionFactory == null)
         {
            return;
         }
         var _loc2_:IAction = this._chatRoomActionFactory.getSendInviteAction(this.room,this._subject,rest);
         _loc2_.invoke();
      }
      
      private function cleanRoom(param1:Boolean = true) : void
      {
         this.removeListeners();
         if(param1)
         {
            this.chatMessages.disableAutoUpdate();
            this.chatMessages.removeAll();
            this.chatMessages.enableAutoUpdate();
         }
         this._isActive = false;
         this.roomFull = false;
         dispatchEvent(new Event("isActiveChanged"));
      }
      
      private function room_roomLeaveHandler(param1:RoomEvent) : void
      {
         var _loc2_:Room = param1.target as Room;
         if(_loc2_ != null)
         {
            _loc2_.removeEventListener(RoomEvent.ROOM_LEAVE,this.room_roomLeaveHandler);
         }
         this.cleanRoom(false);
      }
      
      public function getRoomJID() : UnescapedJID
      {
         return this.room.roomJID;
      }
      
      public function sendResponse(... rest) : void
      {
         if(this._chatRoomActionFactory == null)
         {
            return;
         }
         var _loc2_:IAction = this._chatRoomActionFactory.getSendResponseAction(this.room,this.chatService,rest);
         _loc2_.invoke();
      }
      
      public function isEnableAutoJoinOption() : Boolean
      {
         return this._enableAutoJoinOption;
      }
   }
}

