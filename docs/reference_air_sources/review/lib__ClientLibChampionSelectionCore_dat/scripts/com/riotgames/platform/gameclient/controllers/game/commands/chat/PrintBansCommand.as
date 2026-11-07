package com.riotgames.platform.gameclient.controllers.game.commands.chat
{
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.gameclient.chat.domain.ChatAnnouncementMessageVO;
   import com.riotgames.platform.gameclient.controllers.game.model.ParticipantChampionListView;
   import com.riotgames.platform.gameclient.domain.BannedChampion;
   import com.riotgames.platform.gameclient.domain.game.ParticipantChampionSelection;
   import mx.collections.ArrayCollection;
   import mx.resources.ResourceManager;
   
   public class PrintBansCommand extends CommandBase
   {
      
      private var oldBans:Array;
      
      private var championSelections:ParticipantChampionListView;
      
      private var bannedChamps:ArrayCollection;
      
      private var chatRoom:ChatRoom;
      
      private var soundManager:ISoundProvider;
      
      public function PrintBansCommand(param1:ChatRoom, param2:ParticipantChampionListView, param3:ArrayCollection, param4:Array, param5:ISoundProvider)
      {
         super();
         this.chatRoom = param1;
         this.championSelections = param2;
         this.soundManager = param5;
         this.bannedChamps = param3;
         this.oldBans = param4;
      }
      
      private function printBannedChampion(param1:int) : void
      {
         if(!this.chatRoom)
         {
            return;
         }
         var _loc2_:ParticipantChampionSelection = this.championSelections.getSelectionByChampionId(param1);
         if(_loc2_ == null || _loc2_.champion == null)
         {
            return;
         }
         var _loc3_:String = _loc2_.champion.displayName;
         var _loc4_:ChatAnnouncementMessageVO = new ChatAnnouncementMessageVO();
         var _loc5_:String = ResourceManager.getInstance().getString("resources","championSelection_announcement_championBanned",[_loc3_]);
         if(_loc5_ == null || _loc5_ == "")
         {
            _loc5_ = "**" + _loc3_ + " has been Banned.";
         }
         _loc4_.body = _loc5_;
         this.chatRoom.addMessageToBuffer(_loc4_);
      }
      
      override public function execute() : void
      {
         super.execute();
         this.printNewConfirmedBans(this.bannedChamps,this.oldBans);
         onComplete();
         onResult(this.bannedChamps.source);
      }
      
      private function printNewConfirmedBans(param1:ArrayCollection, param2:Array) : Array
      {
         var _loc3_:BannedChampion = null;
         var _loc4_:Boolean = false;
         var _loc5_:BannedChampion = null;
         for each(_loc3_ in param1)
         {
            _loc4_ = false;
            for each(_loc5_ in param2)
            {
               if(_loc5_.championId == _loc3_.championId)
               {
                  _loc4_ = true;
                  break;
               }
            }
            if(!_loc4_)
            {
               this.printBannedChampion(_loc3_.championId);
            }
         }
         if(param1.length > param2.length)
         {
            this.soundManager.play(AudioKeys.NEW_SOUND_BAN);
         }
         return param1.source;
      }
   }
}

