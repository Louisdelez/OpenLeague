package com.riotgames.platform.gameclient.controllers.game.commands
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.gameclient.controllers.game.model.PlayerSelection;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import mx.collections.ArrayCollection;
   
   public class UpdatePlayerSelectionsLengthForTeamCommand extends CommandBase
   {
      
      private var playerSelections:ArrayCollection;
      
      private var team:ArrayCollection;
      
      public function UpdatePlayerSelectionsLengthForTeamCommand(param1:ArrayCollection, param2:ArrayCollection)
      {
         super();
         this.team = param1;
         this.playerSelections = param2;
      }
      
      override public function execute() : void
      {
         super.execute();
         var _loc1_:PlayerSelection = this.updatePlayerSelectionsLengthForTeam(this.team,this.playerSelections);
         onComplete(null);
         onResult(null);
      }
      
      private function createPlayerSelection(param1:GameParticipant) : PlayerSelection
      {
         return new PlayerSelection(null);
      }
      
      private function updatePlayerSelectionsLengthForTeam(param1:ArrayCollection, param2:ArrayCollection) : PlayerSelection
      {
         var _loc3_:GameParticipant = null;
         var _loc4_:PlayerSelection = null;
         var _loc5_:PlayerSelection = null;
         var _loc6_:Boolean = false;
         while(param2.length < param1.length)
         {
            _loc4_ = this.createPlayerSelection(_loc3_);
            param2.addItem(_loc4_);
         }
         return _loc5_;
      }
   }
}

