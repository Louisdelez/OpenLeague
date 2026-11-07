package com.riotgames.platform.gameclient.controllers.game.commands.chat
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.gameclient.chat.domain.ChatMessageType;
   import com.riotgames.platform.gameclient.chat.domain.ChatMessageVO;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.platform.gameclient.domain.game.GameType;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfig;
   
   public class PrintMatchDetailsCommand extends CommandBase
   {
      
      private var gameTypeConfig:GameTypeConfig;
      
      private var gameMap:GameMap;
      
      private var game:GameDTO;
      
      private var chatRoom:ChatRoom;
      
      public function PrintMatchDetailsCommand(param1:GameDTO, param2:ChatRoom, param3:GameMap, param4:GameTypeConfig)
      {
         super();
         this.game = param1;
         this.chatRoom = param2;
         this.gameMap = param3;
         this.gameTypeConfig = param4;
      }
      
      private function printMatchDetails() : void
      {
         if(!this.chatRoom)
         {
            return;
         }
         if(!this.game)
         {
            return;
         }
         var _loc1_:String = "";
         if(this.gameMap != null)
         {
            _loc1_ += RiotResourceLoader.getString("practiceGame_mapName_label") + " " + this.gameMap.displayName + "\n";
         }
         _loc1_ += RiotResourceLoader.getString("practiceGame_teamSize_label") + " " + (this.game.maxNumPlayers / 2 + "x" + this.game.maxNumPlayers / 2).toString() + "\n";
         if(Boolean(this.game.gameMode))
         {
            _loc1_ += RiotResourceLoader.getString("practiceGame_gameMode_label") + " " + RiotResourceLoader.getString(this.game.gameMode.toLowerCase() + "_pvp_game_mode_title") + "\n";
         }
         _loc1_ += RiotResourceLoader.getString("practiceGame_pickType_label") + " " + RiotResourceLoader.getString("practiceGame_gameMode_" + this.gameTypeConfig.name) + "\n";
         _loc1_ += RiotResourceLoader.getString("practiceGame_showStats_gameType_label") + " " + RiotResourceLoader.getString("practiceGame_gameMode_" + this.game.gameType) + "\n";
         if(this.game.gameType == GameType.PRACTICE_GAME)
         {
            _loc1_ += RiotResourceLoader.getString("practiceGame_gameName_label") + " " + this.game.name;
         }
         var _loc2_:ChatMessageVO = new ChatMessageVO();
         _loc2_.type = ChatMessageType.SYSTEM;
         _loc2_.rosterItem = null;
         _loc2_.timeStamp = new Date();
         _loc2_.body = _loc1_;
         this.chatRoom.addMessageToBuffer(_loc2_);
      }
      
      override public function execute() : void
      {
         super.execute();
         this.printMatchDetails();
         onComplete();
         onResult();
      }
   }
}

