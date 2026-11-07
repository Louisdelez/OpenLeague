package com.riotgames.platform.gameclient.controllers.game.commands
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import mx.collections.ArrayCollection;
   
   public class UpdatePlayerSelectionTeamsCommand extends CommandBase
   {
      
      private var friendlyTeamName:String;
      
      private var enemyTeam:ArrayCollection;
      
      private var enemyTeamName:String;
      
      private var friendlyTeam:ArrayCollection;
      
      public function UpdatePlayerSelectionTeamsCommand(param1:ArrayCollection, param2:String, param3:ArrayCollection, param4:String)
      {
         super();
         this.friendlyTeam = param1;
         this.friendlyTeamName = param2;
         this.enemyTeam = param3;
         this.enemyTeamName = param4;
      }
      
      override public function execute() : void
      {
         var _loc3_:GameParticipant = null;
         super.execute();
         var _loc1_:Array = this.friendlyTeam.source;
         var _loc2_:Array = this.enemyTeam.source;
         for each(_loc3_ in _loc1_)
         {
            _loc3_.team = GameParticipant.FRIENDLY_TEAM;
            _loc3_.teamName = this.friendlyTeamName;
         }
         for each(_loc3_ in _loc2_)
         {
            _loc3_.team = GameParticipant.ENEMY_TEAM;
            _loc3_.teamName = this.enemyTeamName;
         }
      }
   }
}

