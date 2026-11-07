package com.riotgames.platform.gameclient.controllers.game.commands
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import mx.collections.ArrayCollection;
   
   public class MapTeamCommand extends CommandBase
   {
      
      private var team:ArrayCollection;
      
      private var teamMap:Object;
      
      public function MapTeamCommand(param1:Object, param2:ArrayCollection)
      {
         super();
         this.teamMap = param1;
         this.team = param2;
      }
      
      private function updateTeamMapForTeam() : void
      {
         var _loc1_:GameParticipant = null;
         for each(_loc1_ in this.team)
         {
            this.teamMap[_loc1_.summonerInternalName] = _loc1_;
         }
      }
      
      override public function execute() : void
      {
         super.execute();
         this.updateTeamMapForTeam();
         onComplete();
         onResult();
      }
   }
}

