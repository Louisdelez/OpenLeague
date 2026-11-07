package com.riotgames.pvpnet.cap.actions
{
   import blix.action.BasicAction;
   import com.riotgames.platform.gameclient.chat.IChatProvider;
   import com.riotgames.platform.gameclient.chat.domain.ChatMessageType;
   import com.riotgames.platform.gameclient.chat.domain.ChatMessageVO;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public class CapStatusMessageAction extends BasicAction
   {
      
      private var _messageVO:ChatMessageVO;
      
      private var _chatController:IChatProvider;
      
      private var _model:CapModel;
      
      public function CapStatusMessageAction(param1:CapModel, param2:IChatProvider, param3:String)
      {
         super(false);
         this._model = param1;
         this._chatController = param2;
         this.setupStatusMessage(param3);
      }
      
      private function setupStatusMessage(param1:String) : void
      {
         if(!this._chatController || !this._chatController.currentUserJID)
         {
            return;
         }
         this._messageVO = new ChatMessageVO();
         this._messageVO.type = ChatMessageType.DELEGATE;
         this._messageVO.rosterItem = new RosterItemVO(this._chatController.currentUserJID);
         this._messageVO.timeStamp = new Date();
         this._messageVO.body = param1;
      }
      
      override protected function doInvocation() : void
      {
         if(this._model.chatRoom)
         {
            this._model.chatRoom.addMessageToBuffer(this._messageVO,false);
         }
         complete();
      }
   }
}

