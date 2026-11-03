package com.riotgames.pvpnet.docked.chat.view.groupchat
{
   import blix.components.scroll.TailedScrollingBehavior;
   import blix.components.text.TextScroller;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.layout.ILayoutContainer;
   import blix.layout.LayoutContainer;
   import blix.layout.algorithms.CanvasLayout;
   import blix.layout.data.CanvasLayoutData;
   import blix.logger.Logger;
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.gameclient.chat.IChatRoomView;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.gameclient.chat.domain.ChatMessageType;
   import com.riotgames.platform.gameclient.chat.domain.ChatMessageVO;
   import com.riotgames.platform.gameclient.chat.views.ChatViewMediator;
   import com.riotgames.platform.gameclient.components.text.ExpandingTextScroller;
   import com.riotgames.pvpnet.docked.DockedChatStates;
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.formatters.DateFormatter;
   import mx.resources.ResourceManager;
   
   public class ChatRoomView extends StatefulView implements IChatRoomView
   {
      
      public static const MAX_LINES:int = 400;
      
      public static const CULL_LINES_COUNT:int = 200;
      
      public var textScroller:TextScroller;
      
      public var restrictedText:ExpandingTextScroller;
      
      public var chatInput:ExpandingTextScroller;
      
      private var _showTimeStamp:Boolean;
      
      private var _model:ChatRoom;
      
      private var dateFormatter:DateFormatter;
      
      private var tailingBehavior:TailedScrollingBehavior;
      
      private var layout:ILayoutContainer;
      
      private var textScrollerLayout:CanvasLayoutData;
      
      private var messagesDisplayedCount:uint = 0;
      
      private var messages:String;
      
      private var logger:Logger;
      
      private var viewMediator:ChatViewMediator;
      
      private var soundProvider:ISoundProvider;
      
      public function ChatRoomView(param1:IContext)
      {
         super(param1);
         setLinkage("chat.ChatRoomView");
         this.logger = new Logger(this);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.layout = new LayoutContainer(this);
         var _loc1_:CanvasLayout = new CanvasLayout();
         this.layout.setLayoutAlgorithm(_loc1_);
         this.textScroller = new TextScroller(this);
         setTimelineChildByName("textScroller",this.textScroller);
         this.textScrollerLayout = new CanvasLayoutData();
         this.textScrollerLayout.setTop(0);
         this.layout.addElement(this.textScroller,this.textScrollerLayout);
         this.restrictedText = new ExpandingTextScroller(this);
         this.restrictedText.clearText();
         this.restrictedText.getLayoutInvalidated().add(invalidateLayout);
         setTimelineChildByName("restrictedText",this.restrictedText);
         var _loc2_:CanvasLayoutData = new CanvasLayoutData();
         _loc2_.setBottom(3);
         this.layout.addElement(this.restrictedText,_loc2_);
         this.chatInput = new ExpandingTextScroller(this);
         this.chatInput.setIsInput(true);
         this.chatInput.setAutoClear(true);
         this.chatInput.setAltNewline(true);
         this.chatInput.clear.add(this.handleChatInputClear);
         this.chatInput.clearText();
         this.chatInput.getTextView().setMaxChars(200);
         this.chatInput.getLayoutInvalidated().add(invalidateLayout);
         setTimelineChildByName("chatTextInput",this.chatInput);
         var _loc3_:CanvasLayoutData = new CanvasLayoutData();
         _loc3_.setBottom(3);
         this.layout.addElement(this.chatInput,_loc3_);
         this.dateFormatter = new DateFormatter();
         this.dateFormatter.formatString = "[L:NN] ";
         this.textScroller.setMouseWheelEnabled(false);
         this.tailingBehavior = new TailedScrollingBehavior(this.textScroller.getVScrollModel());
         this.refreshChatMessages();
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this.viewMediator = getDependency(ChatViewMediator);
         this.soundProvider = getDependency(ISoundProvider);
      }
      
      public function setModel(param1:ChatRoom) : void
      {
         if(this._model != param1)
         {
            if(this._model != null)
            {
               this.chatInput.clearText();
               this._model.roomJoinSignal.remove(this.updateState);
               this._model.chatSuspendedChangeSignal.remove(this.updateState);
               this._model.chatMessages.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.chatMessagesChanged);
            }
            this._model = param1;
            if(this._model != null)
            {
               if(!this._model.isActive)
               {
                  this._model.join();
                  this._model.roomJoinSignal.add(this.updateState);
               }
               this._model.chatSuspendedChangeSignal.add(this.updateState);
               this._model.chatMessages.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.chatMessagesChanged);
               this.updateState();
               invalidateLayout();
            }
            this.refreshChatMessages();
         }
      }
      
      public function getShowTimeStamp() : Boolean
      {
         return this._showTimeStamp;
      }
      
      public function setShowTimeStamp(param1:Boolean) : void
      {
         if(this._showTimeStamp != param1)
         {
            this._showTimeStamp = param1;
            this.refreshChatMessages();
         }
      }
      
      private function handleChatInputClear() : void
      {
         if(!this._model)
         {
            return;
         }
         this._model.sendMessage(this.chatInput.getText());
         this.chatInput.getTextView().setSelection(int.MAX_VALUE,int.MAX_VALUE);
      }
      
      private function updateState() : void
      {
         var _loc1_:String = DockedChatStates.CHAT_STATE_DEFAULT;
         if(this._model)
         {
            if(this._model.role == ChatRoom.ROLE_VISITOR)
            {
               _loc1_ = DockedChatStates.CHAT_STATE_RESTRICTED;
               this.restrictedText.setText(ResourceManager.getInstance().getString("resources","chat_groupChatWindow_minimumLevelRequirement_text"));
            }
            else if(this._model.getChatSuspended())
            {
               if(getCurrentState() != DockedChatStates.CHAT_STATE_RESTRICTED)
               {
                  _loc1_ = DockedChatStates.CHAT_STATE_RESTRICTED;
                  this.restrictedText.setText(ResourceManager.getInstance().getString("resources","chat_groupChatWindow_sendButton_tooltip_disabled"));
                  this.soundProvider.play(AudioKeys.SOUND_CHAT_RESTRICTED);
               }
            }
         }
         setCurrentState(_loc1_);
      }
      
      private function refreshChatMessages() : void
      {
         var _loc1_:int = 0;
         var _loc2_:ChatMessageVO = null;
         this.messages = "";
         this.messagesDisplayedCount = 0;
         if(this._model != null)
         {
            _loc1_ = 0;
            if(this._model.chatMessages.length > MAX_LINES)
            {
               _loc1_ = this._model.chatMessages.length - CULL_LINES_COUNT;
            }
            while(_loc1_ < this._model.chatMessages.length)
            {
               _loc2_ = this._model.chatMessages.getItemAt(_loc1_) as ChatMessageVO;
               this.addChatMessage(_loc2_);
               _loc1_++;
            }
         }
         this.textScroller.setHtmlText("<font face=\'ApplicationFont1\'>" + this.messages + "</font>");
      }
      
      private function chatMessagesChanged(param1:CollectionEvent) : void
      {
         var _loc2_:ChatMessageVO = null;
         if(param1.kind == CollectionEventKind.ADD)
         {
            for each(_loc2_ in param1.items)
            {
               this.addChatMessage(_loc2_,true);
            }
            this.textScroller.setHtmlText("<font face=\'ApplicationFont1\'>" + this.messages + "</font>");
         }
         else
         {
            this.refreshChatMessages();
         }
      }
      
      private function addChatMessage(param1:ChatMessageVO, param2:Boolean = false) : void
      {
         ++this.messagesDisplayedCount;
         if(this.messagesDisplayedCount > MAX_LINES)
         {
            this.refreshChatMessages();
            return;
         }
         if(param1.rosterItem != null && Boolean(this.viewMediator.getPrivacyListController().isBlocked(param1.rosterItem.jid.bareJID)))
         {
            return;
         }
         if(param2)
         {
            switch(param1.type)
            {
               case ChatMessageType.PUBLIC:
                  this.soundProvider.play(AudioKeys.SOUND_MSG_RECEIVE);
                  break;
               case ChatMessageType.JOIN:
                  this.soundProvider.play(AudioKeys.SOUND_CHAT_JOIN);
                  break;
               case ChatMessageType.LEAVE:
                  this.soundProvider.play(AudioKeys.SOUND_CHAT_LEAVE);
                  break;
               case ChatMessageType.PRIVATE:
                  this.soundProvider.play(AudioKeys.SOUND_PM_RECEIVE);
            }
         }
         this.messages += "<p>" + this.formatMessage(param1) + "</p>";
      }
      
      private function formatMessage(param1:ChatMessageVO) : String
      {
         var _loc2_:String = "";
         switch(param1.type)
         {
            case ChatMessageType.JOIN:
               _loc2_ += "<font color=\'#CCFF00\'>";
               if(this._showTimeStamp)
               {
                  _loc2_ += this.dateFormatter.format(param1.timeStamp);
               }
               _loc2_ += ResourceManager.getInstance().getString("resources","chat_groupChatWindow_userJoinMessage",[param1.rosterItem.displayName]);
               _loc2_ += "</font>";
               break;
            case ChatMessageType.LEAVE:
               _loc2_ += "<font color=\'#CCFF00\'>";
               if(this._showTimeStamp)
               {
                  _loc2_ += this.dateFormatter.format(param1.timeStamp);
               }
               _loc2_ += ResourceManager.getInstance().getString("resources","chat_groupChatWindow_userLeaveMessage",[param1.rosterItem.displayName]);
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
            case ChatMessageType.SYSTEM:
               _loc2_ += "<font color=\'#FF771C\'>";
               _loc2_ += param1.body;
               _loc2_ += "</font>";
               break;
            case ChatMessageType.PRIVATE:
            case ChatMessageType.PUBLIC:
               _loc2_ += "<font color=\'#00CCFF\'>";
               if(this._showTimeStamp)
               {
                  _loc2_ += this.dateFormatter.format(param1.timeStamp);
               }
               _loc2_ += param1.rosterItem.displayName;
               _loc2_ += ": ";
               _loc2_ += "</font>";
               _loc2_ += param1.body;
               break;
            default:
               this.logger.logWarn("Unsupported chat message type \'" + param1.type + "\' in Group Chat.");
         }
         return _loc2_;
      }
      
      override protected function configureAsset(param1:DisplayObject) : void
      {
         if(param1 != null)
         {
            this.layout.setExplicitSize(param1.width,param1.height);
         }
         super.configureAsset(param1);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this.chatInput.setExplicitSize(NaN,NaN);
         this.textScrollerLayout.setBottom(this.chatInput.getHeight() + 3);
         return super.updateLayout(param1,param2);
      }
   }
}

