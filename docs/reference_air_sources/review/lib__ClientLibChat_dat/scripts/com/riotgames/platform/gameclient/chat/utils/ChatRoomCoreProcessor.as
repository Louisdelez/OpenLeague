package com.riotgames.platform.gameclient.chat.utils
{
   import blix.signals.Signal;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.gameclient.chat.domain.ChatMessageType;
   import com.riotgames.platform.gameclient.chat.domain.ChatMessageVO;
   import com.riotgames.pvpnet.system.wordfilter.WordFilter;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.formatters.DateFormatter;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.utils.ObjectUtil;
   import org.igniterealtime.xiff.conference.RoomOccupant;
   import org.igniterealtime.xiff.data.im.RosterGroup;
   
   public class ChatRoomCoreProcessor
   {
      
      public var startSpamPenaltySignal:Signal = new Signal();
      
      public var disconnectedStateChangedSignal:Signal = new Signal();
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public var clearMessageDisplaysSignal:Signal = new Signal();
      
      private var _disconnected:Boolean = true;
      
      private var chatSpamPenaltyTimer:Timer = new Timer(10000);
      
      public var newMessageReceivedSignal:Signal = new Signal();
      
      private var messagesDisplayedCount:int = 0;
      
      private var _messages:Array = [];
      
      public var endSpamPenaltySignal:Signal = new Signal();
      
      private var _chatRoom:ChatRoom;
      
      private var dateFormatter:DateFormatter = null;
      
      private var _wordFilter:WordFilter;
      
      private var _chatController:ChatController;
      
      private var roomsTimeoutId:int = 0;
      
      private var _formattedMessagesBuffer:String = "";
      
      private var _filteredMessageTypes:Dictionary = new Dictionary();
      
      private var timeoutTimer:Timer = null;
      
      private var _showTimeStamp:Boolean = false;
      
      private const maxLines:int = 400;
      
      private var disabled:Boolean = false;
      
      public function ChatRoomCoreProcessor(param1:ChatController, param2:WordFilter, param3:ChatRoom = null, param4:Vector.<String> = null)
      {
         var _loc5_:String = null;
         super();
         this._chatController = param1;
         if(param1 != null)
         {
            this._chatController.addEventListener("currentStateChanged",this.onChatControllerStateChanged,false,0,true);
            this._chatController.addEventListener("error",this.onChatControllerError,false,0,true);
            this.chatSpamPenaltyTimer.addEventListener(TimerEvent.TIMER,this.onChatSpamPenaltyComplete,false,0,true);
         }
         this._wordFilter = param2;
         for each(_loc5_ in param4)
         {
            this.addMessageTypeFilter(_loc5_);
         }
         this.setChatRoom(param3);
      }
      
      private function onChatSpamPenaltyComplete(param1:TimerEvent) : void
      {
         var _loc2_:Timer = param1.currentTarget as Timer;
         this.disabled = false;
         this.endSpamPenaltySignal.dispatch();
         this.chatSpamPenaltyTimer.stop();
      }
      
      private function isMessageTypeFiltered(param1:String) : Boolean
      {
         return this._filteredMessageTypes[param1] == true;
      }
      
      public function removeMessageTypeFilter(param1:String) : void
      {
         delete this._filteredMessageTypes[param1];
      }
      
      private function redrawAllMessages() : void
      {
         var _loc1_:Array = null;
         var _loc2_:FormattedChatMessage = null;
         this.messagesDisplayedCount = 0;
         this._formattedMessagesBuffer = "";
         if(this._messages.length > this.maxLines)
         {
            _loc1_ = this._messages.splice(this._messages.length - this.maxLines / 2,this._messages.length);
         }
         else
         {
            _loc1_ = this._messages;
         }
         for each(_loc2_ in _loc1_)
         {
            this.addMessageToBuffer(_loc2_.htmlMessage);
         }
      }
      
      public function addMessageTypeFilter(param1:String) : void
      {
         this._filteredMessageTypes[param1] = true;
      }
      
      private function processExistingMessages() : void
      {
         var _loc1_:Object = null;
         if(Boolean(this._chatRoom) && this._chatRoom.chatMessages.length > 0)
         {
            for each(_loc1_ in this._chatRoom.chatMessages)
            {
               if(_loc1_ is ChatMessageVO)
               {
                  this.addChatMessage(_loc1_ as ChatMessageVO);
               }
            }
         }
      }
      
      private function setupTimeout() : void
      {
         if(this._chatRoom != null && this._chatRoom.isActive != false)
         {
            return;
         }
         if(this.timeoutTimer != null && this.timeoutTimer.running)
         {
            return;
         }
         if(this.timeoutTimer == null)
         {
            this.timeoutTimer = new Timer(5000,1);
         }
         this.timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.disconnectErrorHandler);
         this.timeoutTimer.start();
      }
      
      private function chatMessageReceived(param1:CollectionEvent) : void
      {
         var _loc3_:Object = null;
         var _loc4_:ChatMessageVO = null;
         if(param1.kind == CollectionEventKind.RESET || this._chatController == null)
         {
            return;
         }
         var _loc2_:ChatMessageVO = param1.items[0] as ChatMessageVO;
         if(_loc2_.rosterItem != null && _loc2_.rosterItem.jid.node != this._chatController.currentUserJID.node)
         {
            this.removeTimer();
         }
         for each(_loc3_ in param1.items)
         {
            _loc4_ = _loc3_ as ChatMessageVO;
            if(_loc4_ != null && !this.isMessageTypeFiltered(_loc4_.type))
            {
               this.addChatMessage(_loc3_ as ChatMessageVO);
            }
         }
      }
      
      private function addChatMessage(param1:ChatMessageVO) : void
      {
         if(this.isMessageBlocked(param1))
         {
            return;
         }
         var _loc2_:String = "";
         _loc2_ += "<p>";
         _loc2_ += this.formatMessage(param1);
         _loc2_ += "</p>";
         this._messages.push(new FormattedChatMessage(_loc2_,param1.type));
         this.addMessageToBuffer(_loc2_);
         this.newMessageReceivedSignal.dispatch(param1.type);
      }
      
      private function isMessageBlocked(param1:ChatMessageVO) : Boolean
      {
         var _loc2_:String = param1.rosterItem == null ? null : param1.rosterItem.jid.bareJID;
         return !_loc2_ || this._chatController.privacyListController != null && this._chatController.privacyListController.isBlocked(_loc2_);
      }
      
      private function removeTimer() : void
      {
         if(this.timeoutTimer != null)
         {
            this.timeoutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.disconnectErrorHandler);
            this.timeoutTimer.stop();
         }
         this.setDisconnected(false);
      }
      
      private function onUserListChanged(param1:CollectionEvent) : void
      {
         this.removeTimer();
         if(this.roomsTimeoutId == 0 && param1.kind != CollectionEventKind.REFRESH)
         {
            this.roomsTimeoutId = setTimeout(this.refreshRooms,50);
         }
      }
      
      public function get disconnected() : Boolean
      {
         return this._disconnected;
      }
      
      private function setDisconnected(param1:Boolean) : void
      {
         if(this._disconnected == param1)
         {
            return;
         }
         this._disconnected = param1;
         this.disconnectedStateChangedSignal.dispatch(this._disconnected);
      }
      
      public function isDisabled() : Boolean
      {
         return this.disabled;
      }
      
      public function get formattedMessageBuffer() : String
      {
         return this._formattedMessagesBuffer;
      }
      
      public function setChatRoom(param1:ChatRoom) : void
      {
         if(this._chatRoom != null)
         {
            this.teardownChatRoom();
         }
         this._chatRoom = param1;
         if(this._chatRoom != null)
         {
            this.setupChatRoom();
         }
      }
      
      private function onChatControllerStateChanged(param1:Event) : void
      {
         if(!this._chatController)
         {
            return;
         }
         switch(this._chatController.currentState)
         {
            case ChatController.ONLINE:
               this.setDisconnected(false);
               break;
            default:
               this.setDisconnected(true);
         }
      }
      
      private function disconnectErrorHandler(param1:TimerEvent) : void
      {
         if(this._chatController != null)
         {
            if(this._chatRoom != null && this._chatRoom.isActive == false)
            {
            }
            if(this._chatRoom == null || this._chatRoom.isActive == false)
            {
               this.setDisconnected(true);
            }
         }
      }
      
      private function addMessageToBuffer(param1:String) : void
      {
         ++this.messagesDisplayedCount;
         if(this.messagesDisplayedCount > this.maxLines)
         {
            this.redrawAllMessages();
            return;
         }
         this._formattedMessagesBuffer += param1;
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
      
      public function get currentMessages() : Array
      {
         return this._messages;
      }
      
      public function sendChatMessage(param1:String) : void
      {
         this._chatRoom.sendMessage(param1);
      }
      
      private function refreshRooms() : void
      {
         if(this.roomsTimeoutId > 0 && Boolean(this._chatRoom))
         {
            this._chatRoom.refreshRoom();
            if(Boolean(this._chatController))
            {
               this._chatController.refreshOccupantCountForRoom(this._chatRoom);
            }
            this.roomsTimeoutId = 0;
         }
      }
      
      private function setupChatRoom() : void
      {
         this.setupTimeout();
         this._chatRoom.chatMessages.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.chatMessageReceived,false,0,true);
         this._chatRoom.setChatRoomSortFunction(this.sortRoomByStatus);
         this._chatRoom.userListChangedSignal.add(this.onUserListChanged);
         this._chatRoom.roomJoinSignal.add(this.removeTimer);
         this._chatRoom.otherUserJoinedRoomSignal.add(this.removeTimer);
         if(Boolean(this._chatRoom.subject))
         {
            this.removeTimer();
         }
         this.processExistingMessages();
      }
      
      public function set showTimeStamp(param1:Boolean) : void
      {
         if(this._showTimeStamp == param1)
         {
            return;
         }
         this._showTimeStamp = param1;
         this.clearMessageDisplaysSignal.dispatch();
         this.processExistingMessages();
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
         var _loc2_:String = "<font face=\'ApplicationFont1\'>";
         switch(param1.type)
         {
            case ChatMessageType.JOIN:
               _loc2_ += "<font color=\'#CCFF00\'>";
               _loc2_ += RiotResourceLoader.getString("chat_groupChatWindow_userJoinMessage","USER_JOIN",[param1.rosterItem.displayName]);
               _loc2_ += "</font>";
               break;
            case ChatMessageType.LEAVE:
               _loc2_ += "<font color=\'#CCFF00\'>";
               _loc2_ += RiotResourceLoader.getString("chat_groupChatWindow_userLeaveMessage","USER_LEAVE",[param1.rosterItem.displayName]);
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
               _loc2_ += "<font color=\'#00CCFF\'>";
               _loc2_ += param1.rosterItem.displayName;
               if(this._showTimeStamp)
               {
                  if(this.dateFormatter == null)
                  {
                     this.dateFormatter = new DateFormatter();
                     this.dateFormatter.formatString = " (L:NN)";
                  }
                  _loc2_ += this.dateFormatter.format(param1.timeStamp);
               }
               _loc2_ += ": ";
               _loc2_ += "</font>";
               _loc2_ += this._wordFilter.maskOffensiveWords(param1.body);
               break;
            case ChatMessageType.SYSTEM:
               _loc2_ += "<font color=\'#FF771C\'>";
               _loc2_ += param1.body;
               _loc2_ += "</font>";
               break;
            default:
               _loc2_ = "";
         }
         return _loc2_ + "</font>";
      }
      
      private function onChatControllerError(param1:Object) : void
      {
         var _loc2_:Object = this._chatController.errorDataProvider.source[this._chatController.errorDataProvider.length - 1];
         if(_loc2_.errorCode == 500 && _loc2_.errorCondition == "resource-constraint")
         {
            this.disabled = true;
            this.startSpamPenaltySignal.dispatch();
            this.chatSpamPenaltyTimer.start();
         }
      }
      
      private function teardownChatRoom() : void
      {
         this.setDisconnected(false);
         this._messages = null;
         if(this._chatRoom != null)
         {
            this._chatRoom.chatMessages.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.chatMessageReceived);
            this._chatRoom.userListChangedSignal.remove(this.onUserListChanged);
            this._chatRoom.roomJoinSignal.remove(this.removeTimer);
            this._chatRoom.otherUserJoinedRoomSignal.remove(this.removeTimer);
         }
      }
   }
}

