package com.riotgames.platform.gameclient.controllers.game.commands
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.gameclient.domain.BotParticipant;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import com.riotgames.platform.gameclient.domain.PlayerParticipant;
   import com.riotgames.platform.gameclient.domain.game.ParticipantChampionSelection;
   import mx.collections.IList;
   
   public class UpdateParticipantChampionCommand extends CommandBase
   {
      
      private var playerRoster:Array;
      
      private var championMap:Array;
      
      private var unfilteredChampionList:IList;
      
      private var teamMap:Object;
      
      public function UpdateParticipantChampionCommand(param1:Array, param2:IList, param3:Array)
      {
         super();
         this.playerRoster = param1;
         this.unfilteredChampionList = param2;
         this.championMap = param3;
      }
      
      private function updateParticipantForChampionSelections(param1:IList, param2:Array) : void
      {
         var _loc4_:ParticipantChampionSelection = null;
         var _loc5_:Champion = null;
         var _loc6_:GameParticipant = null;
         var _loc7_:PlayerParticipant = null;
         var _loc8_:String = null;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1.getItemAt(_loc3_) as ParticipantChampionSelection;
            _loc5_ = _loc4_.champion;
            _loc6_ = param2[_loc5_.championId];
            if(_loc6_ is PlayerParticipant)
            {
               _loc7_ = PlayerParticipant(_loc6_);
               _loc8_ = _loc7_.accountId.toString();
               _loc6_ = this.playerRoster[_loc8_] as GameParticipant;
            }
            else if(_loc6_ is BotParticipant)
            {
               BotParticipant(_loc6_).champion = _loc5_;
            }
            _loc4_.participant = _loc6_;
            _loc3_++;
         }
      }
      
      override public function execute() : void
      {
         super.execute();
         this.updateParticipantForChampionSelections(this.unfilteredChampionList,this.championMap);
         onComplete(null);
         onResult(null);
      }
   }
}

