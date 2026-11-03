package com.riotgames.platform.gameclient.controllers.game.commands.chat
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.gameclient.chat.IChatRoomProvider;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.gameclient.chat.domain.ChatRoomType;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import mx.resources.ResourceManager;
   
   public class CreateChatRoomCommand extends CommandBase
   {
      
      private var game:GameDTO;
      
      private var chatRoomProvider:IChatRoomProvider;
      
      private var championSelectionModel:ChampionSelectionModel;
      
      public function CreateChatRoomCommand(param1:GameDTO, param2:ChampionSelectionModel, param3:IChatRoomProvider)
      {
         super();
         this.game = param1;
         this.championSelectionModel = param2;
         this.chatRoomProvider = param3;
      }
      
      override protected function onResult(param1:Object = null) : void
      {
         var _loc2_:ChatRoom = param1 as ChatRoom;
         _loc2_.join();
         _loc2_.subject = ResourceManager.getInstance().getString("resources","championSelection_chat_title");
         this.championSelectionModel.chatRoom = _loc2_;
         onComplete(_loc2_);
         super.onResult(_loc2_);
      }
      
      override public function execute() : void
      {
         super.execute();
         this.tryToCreateChatRoom();
      }
      
      private function tryToCreateChatRoom() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(Boolean(this.game))
         {
            _loc1_ = "";
            if(!this.game.roomName || this.game.roomName == "")
            {
               _loc3_ = this.championSelectionModel.currentTeam == this.game.teamOne ? ChatRoomType.CHAMPION_SELECT1 : ChatRoomType.CHAMPION_SELECT2;
               _loc4_ = this.game.name;
               _loc1_ = this.chatRoomProvider.obfuscateChatRoom(_loc4_ + "_" + _loc3_,_loc3_);
            }
            else
            {
               _loc1_ = this.game.roomName;
            }
            _loc2_ = this.game.roomPassword;
            if(!this.championSelectionModel.isSpectating)
            {
               this.chatRoomProvider.requestChatRoom(_loc1_,_loc1_,_loc2_,_loc3_,this.onResult);
            }
         }
      }
   }
}

