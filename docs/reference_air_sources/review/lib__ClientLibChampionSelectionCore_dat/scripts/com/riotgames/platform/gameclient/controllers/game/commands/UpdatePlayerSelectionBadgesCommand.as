package com.riotgames.platform.gameclient.controllers.game.commands
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.gameclient.controllers.game.model.PlayerSelection;
   import mx.collections.ArrayCollection;
   
   public class UpdatePlayerSelectionBadgesCommand extends CommandBase
   {
      
      private var friendlySelections:ArrayCollection;
      
      private var enemySelections:ArrayCollection;
      
      public function UpdatePlayerSelectionBadgesCommand(param1:ArrayCollection, param2:ArrayCollection)
      {
         super();
         this.friendlySelections = param1;
         this.enemySelections = param2;
      }
      
      override public function execute() : void
      {
         var _loc3_:PlayerSelection = null;
         super.execute();
         var _loc1_:Array = this.friendlySelections.source;
         var _loc2_:Array = this.enemySelections.source;
         for each(_loc3_ in _loc1_)
         {
            if(Boolean(_loc3_.participant))
            {
               _loc3_.badges = _loc3_.participant.badges;
            }
         }
         for each(_loc3_ in _loc2_)
         {
            if(Boolean(_loc3_.participant))
            {
               _loc3_.badges = _loc3_.participant.badges;
            }
         }
      }
   }
}

