package com.riotgames.pvpnet.cap.views.components
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.context.IContext;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.gameclient.chat.views.blixViews.TailedChatView;
   import flash.desktop.DockIcon;
   import flash.desktop.NativeApplication;
   import flash.desktop.NotificationType;
   import flash.display.DisplayObject;
   import flash.display.NativeWindow;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class CapTailedChatView extends TailedChatView
   {
      
      private static const MAX_INPUT_CHARS:int = 1000;
      
      private var _spamTextField:TextFieldProxy;
      
      public function CapTailedChatView(param1:IContext, param2:ChatController = null, param3:ChatRoom = null)
      {
         super(param1,param2,param3);
      }
      
      override protected function applyIronFilters(param1:String) : String
      {
         return param1;
      }
      
      override protected function onNewMessageReceived(param1:String, param2:Boolean = true) : void
      {
         super.onNewMessageReceived(param1,param2);
         this.notifyUser();
      }
      
      public function clear() : void
      {
         if(_chatLogTextField)
         {
            _chatLogTextField.setText("");
         }
         if(_enterTextField)
         {
            _enterTextField.setText("");
         }
      }
      
      override public function createAndInitializeChatProcessor(param1:ChatController, param2:ChatRoom, param3:Vector.<String> = null) : void
      {
         if(chatRoomHandler)
         {
            chatRoomHandler.startSpamPenaltySignal.remove(this.startSpamPenalty);
            chatRoomHandler.endSpamPenaltySignal.remove(this.endSpamPenalty);
         }
         super.createAndInitializeChatProcessor(param1,param2,param3);
         if(chatRoomHandler)
         {
            chatRoomHandler.startSpamPenaltySignal.add(this.startSpamPenalty);
            chatRoomHandler.endSpamPenaltySignal.add(this.endSpamPenalty);
         }
         this.clear();
      }
      
      private function notifyUser() : void
      {
         var _loc1_:DockIcon = null;
         var _loc2_:NativeWindow = null;
         if(NativeApplication.supportsDockIcon)
         {
            _loc1_ = NativeApplication.nativeApplication.icon as DockIcon;
            _loc1_.bounce(NotificationType.CRITICAL);
         }
         else if(NativeApplication.supportsSystemTrayIcon)
         {
            _loc2_ = NativeApplication.nativeApplication.openedWindows[0];
            _loc2_.notifyUser(NotificationType.CRITICAL);
         }
      }
      
      override public function destroy() : void
      {
         if(_chatLogTextField)
         {
            _chatLogTextField.getAssetChanged().remove(this.ensureTheRightFontIsUsed);
         }
         if(_enterTextField)
         {
            _enterTextField.getAssetChanged().remove(this.ensureTheRightFontIsUsed);
         }
         super.destroy();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         _sendChatButton.setText(RiotResourceLoader.getString("chat_groupChatWindow_sendButton_label"));
         _chatLogTextField.getAssetChanged().add(this.ensureTheRightFontIsUsed);
         _enterTextField.getAssetChanged().add(this.ensureTheRightFontIsUsed);
         _enterTextField.setMaxChars(MAX_INPUT_CHARS);
         this._spamTextField = new TextFieldProxy(this);
         setTimelineChildByName("spamTextField",this._spamTextField);
         this._spamTextField.setVisible(false);
         this._spamTextField.setText(RiotResourceLoader.getString("chat_groupChatWindow_sendButton_tooltip_disabled"));
         setCurrentState("enabled");
      }
      
      private function endSpamPenalty() : void
      {
         this._spamTextField.setVisible(false);
         _enterTextField.setVisible(true);
         setCurrentState("enabled");
      }
      
      private function startSpamPenalty() : void
      {
         this._spamTextField.setVisible(true);
         _enterTextField.setVisible(false);
         setCurrentState("disabled");
      }
      
      private function ensureTheRightFontIsUsed(param1:DisplayObjectProxy, param2:DisplayObject, param3:DisplayObject) : void
      {
         var _loc5_:TextFormat = null;
         var _loc4_:TextField = param3 as TextField;
         if(_loc4_)
         {
            _loc4_.embedFonts = true;
            _loc5_ = new TextFormat();
            _loc5_.font = "ApplicationFont1";
            _loc4_.defaultTextFormat = _loc5_;
            _loc4_.setTextFormat(_loc5_);
         }
      }
   }
}

