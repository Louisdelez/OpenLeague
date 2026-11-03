package com.riotgames.platform.gameclient.controllers.game.commands.chat
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.gameclient.chat.IChatRoomProvider;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   
   public class CloseChatRoomCommand extends CommandBase
   {
      
      private var _chatRoomProvider:IChatRoomProvider;
      
      private var _championSelectionModel:ChampionSelectionModel;
      
      public function CloseChatRoomCommand(param1:ChampionSelectionModel, param2:IChatRoomProvider)
      {
         super(false);
         this._championSelectionModel = param1;
         this._chatRoomProvider = param2;
      }
      
      override public function execute() : void
      {
         super.execute();
         if(this._championSelectionModel.chatRoom != null)
         {
            this._chatRoomProvider.closeChatRoom(this._championSelectionModel.chatRoom);
            this._championSelectionModel.chatRoom = null;
         }
         onComplete();
         onResult();
      }
   }
}

