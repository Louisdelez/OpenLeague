package com.riotgames.platform.gameclient.chat.views.blixViews
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.LabelButtonX;
   import blix.components.scroll.ScrollModel;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.provider.SoundProviderProxy;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.gameclient.chat.domain.ChatMessageType;
   import com.riotgames.platform.gameclient.chat.utils.ChatRoomCoreProcessor;
   import com.riotgames.pvpnet.system.wordfilter.WordFilter;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   import flash.ui.Keyboard;
   import mx.resources.ResourceManager;
   
   public class TailedChatView extends StatefulView
   {
      
      protected var _chatLogTextField:TextFieldProxy;
      
      private var _scrollBar:TailedChatScrollbar;
      
      private var _scrollModel:ScrollModel;
      
      private var _soundProvider:ISoundProvider = SoundProviderProxy.instance;
      
      private const TAILED_TRIGGER_OFFSET:int = 8;
      
      private var tailed:Boolean = true;
      
      protected var _sendChatButton:LabelButtonX;
      
      protected var _enterTextField:TextFieldProxy;
      
      protected var chatRoomHandler:ChatRoomCoreProcessor;
      
      private var chatLogInitialSize:Point;
      
      public function TailedChatView(param1:IContext, param2:ChatController = null, param3:ChatRoom = null, param4:Vector.<String> = null)
      {
         super(param1);
         this.createAndInitializeChatProcessor(param2,param3,param4);
      }
      
      private function playSoundForRespectiveMessageType(param1:String) : void
      {
         switch(param1)
         {
            case ChatMessageType.PUBLIC:
               if(Boolean(this._soundProvider))
               {
                  this._soundProvider.play(AudioKeys.SOUND_MSG_RECEIVE);
               }
               break;
            case ChatMessageType.JOIN:
               if(Boolean(this._soundProvider))
               {
                  this._soundProvider.play(AudioKeys.SOUND_CHAT_JOIN);
               }
               break;
            case ChatMessageType.LEAVE:
               if(Boolean(this._soundProvider))
               {
                  this._soundProvider.play(AudioKeys.SOUND_CHAT_LEAVE);
               }
               break;
            case ChatMessageType.PRIVATE:
               if(Boolean(this._soundProvider))
               {
                  this._soundProvider.play(AudioKeys.SOUND_PM_RECEIVE);
               }
         }
      }
      
      protected function applyIronFilters(param1:String) : String
      {
         return param1.replace(/face=['"]applicationFont1['"]/gi,"face=\'ApplicationFontNormal\' size=\'14\'");
      }
      
      private function recordChatLogHeight() : void
      {
         if(this._chatLogTextField.getTextField() != null)
         {
            this.chatLogInitialSize = new Point(this._chatLogTextField.getTextField().width,this._chatLogTextField.getTextField().height);
            this._chatLogTextField.setAutoSize(TextFieldAutoSize.LEFT);
            this._chatLogTextField.getAssetChanged().remove(this.recordChatLogHeight);
         }
      }
      
      private function onClearMessageDisplay() : void
      {
         this._chatLogTextField.setHtmlText("");
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         if(this.chatRoomHandler == null)
         {
            return super.updateLayout(param1,param2);
         }
         this._scrollBar.setExplicitSize(NaN,this.chatLogInitialSize.y);
         var _loc3_:Number = Number(this._chatLogTextField.getTextHeight());
         this._scrollModel.setMax(_loc3_ - this.chatLogInitialSize.y);
         if(this.tailed)
         {
            this._scrollModel.setValue(this._scrollModel.getMax());
         }
         this._chatLogTextField.setScrollRect(new Rectangle(0,this._scrollModel.getClampedValue(),this.chatLogInitialSize.x,this.chatLogInitialSize.y));
         return super.updateLayout(param1,param2);
      }
      
      private function updateTailed() : void
      {
         if(this._scrollModel.getValue() >= this._scrollModel.getMax() - this.TAILED_TRIGGER_OFFSET)
         {
            this.tailed = true;
            invalidateLayout();
         }
         else
         {
            this.tailed = false;
         }
      }
      
      override protected function createChildren() : void
      {
         this._enterTextField = new TextFieldProxy(this);
         setTimelineChildByName("enterTextField",this._enterTextField);
         this._enterTextField.addEventListener(KeyboardEvent.KEY_DOWN,this.onTextFieldEntrySubmit);
         this._enterTextField.setHtmlText("");
         this._chatLogTextField = new TextFieldProxy(this);
         setTimelineChildByName("chatLogTextField",this._chatLogTextField);
         this._chatLogTextField.setHtmlText("");
         this._chatLogTextField.getAssetChanged().add(this.recordChatLogHeight);
         this._sendChatButton = new LabelButtonX(this);
         setTimelineChildByName("sendChat",this._sendChatButton);
         this._sendChatButton.setText(ResourceManager.getInstance().getString("resources","chatButtonLabel"));
         this._sendChatButton.addEventListener(MouseEvent.CLICK,this.onSendButtonClick);
         this._scrollBar = new TailedChatScrollbar(this);
         setTimelineChildByName("scrollBar",this._scrollBar);
         this._scrollModel = new ScrollModel();
         this._scrollModel.getChanged().add(invalidateLayout);
         this._scrollBar.setScrollModel(this._scrollModel);
         this._scrollBar.setMousewheelEventTarget(this._chatLogTextField);
         this._scrollBar.onThumbMoved.add(this.updateTailed);
         this._scrollBar.unTailChatSignal.add(this.untailChat);
      }
      
      private function onTextFieldEntrySubmit(param1:KeyboardEvent) : void
      {
         if(param1.charCode == Keyboard.ENTER)
         {
            this.submitText();
         }
      }
      
      protected function onNewMessageReceived(param1:String, param2:Boolean = true) : void
      {
         if(param2)
         {
            this.playSoundForRespectiveMessageType(param1);
         }
         this._chatLogTextField.setHtmlText(this.applyIronFilters(this.chatRoomHandler.formattedMessageBuffer));
         invalidateLayout();
      }
      
      private function submitText() : void
      {
         if(this.chatRoomHandler == null || this.chatRoomHandler.isDisabled())
         {
            return;
         }
         this.chatRoomHandler.sendChatMessage(this._enterTextField.getText());
         this._enterTextField.setText("");
      }
      
      private function untailChat() : void
      {
         this.tailed = false;
      }
      
      public function createAndInitializeChatProcessor(param1:ChatController, param2:ChatRoom, param3:Vector.<String> = null) : void
      {
         if(this.chatRoomHandler != null)
         {
            this.chatRoomHandler.newMessageReceivedSignal.remove(this.onNewMessageReceived);
            this.chatRoomHandler.clearMessageDisplaysSignal.remove(this.onClearMessageDisplay);
            this.chatRoomHandler = null;
         }
         if(Boolean(param1) && Boolean(param2) && this.chatRoomHandler == null)
         {
            this.chatRoomHandler = new ChatRoomCoreProcessor(param1,WordFilter.instance,param2,param3);
            this.chatRoomHandler.newMessageReceivedSignal.add(this.onNewMessageReceived);
            this.chatRoomHandler.clearMessageDisplaysSignal.add(this.onClearMessageDisplay);
         }
      }
      
      private function onSendButtonClick(param1:MouseEvent) : void
      {
         this.submitText();
      }
   }
}

