package com.riotgames.pvpnet.cap.views.components
{
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.IChatRoomProvider;
   import com.riotgames.platform.gameclient.chat.domain.ChatMessageType;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   
   public class CapChatPanel extends CapPanel
   {
      
      private var _model:CapModel;
      
      private var capPanel:CapPanel;
      
      private var chatController:ChatController;
      
      private var chatView:CapTailedChatView;
      
      private var capHeader:CapHeader;
      
      public function CapChatPanel(param1:IContext)
      {
         super(param1);
      }
      
      override public function destroy() : void
      {
         this.chatView.destroy();
         super.destroy();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.chatView = new CapTailedChatView(this);
         setTimelineChildByName("chatBox",this.chatView);
         title = "";
         this.onChatRoomChanged();
      }
      
      private function onChatRoomChanged() : void
      {
         var _loc1_:Vector.<String> = null;
         if(Boolean(this._model) && Boolean(this._model) && Boolean(this._model.chatRoom))
         {
            _loc1_ = new Vector.<String>();
            _loc1_.push(ChatMessageType.JOIN);
            _loc1_.push(ChatMessageType.LEAVE);
            this.chatView.createAndInitializeChatProcessor(this.chatController,this._model.chatRoom,_loc1_);
         }
      }
      
      public function clear() : void
      {
         if(this.chatView)
         {
            this.chatView.clear();
         }
      }
      
      override protected function initializeDependencies() : void
      {
         this.chatController = getDependency(IChatRoomProvider) as ChatController;
         this._model = getDependency(CapModel) as CapModel;
         this._model.chatRoomChanged.add(this.onChatRoomChanged);
      }
   }
}

