package com.riotgames.platform.gameclient.controllers.game.commands
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import com.riotgames.platform.gameclient.domain.IParticipant;
   import mx.collections.ArrayCollection;
   import mx.resources.ResourceManager;
   
   public class AnonymizeNamesCommand extends CommandBase
   {
      
      private var team:ArrayCollection;
      
      public function AnonymizeNamesCommand(param1:ArrayCollection)
      {
         super();
         this.team = param1;
      }
      
      private function anonymizeNames() : void
      {
         var _loc2_:IParticipant = null;
         var _loc3_:GameParticipant = null;
         var _loc4_:String = null;
         var _loc1_:int = 1;
         for each(_loc2_ in this.team)
         {
            if(_loc2_ is GameParticipant)
            {
               _loc3_ = _loc2_ as GameParticipant;
               _loc4_ = ResourceManager.getInstance().getString("resources","championSelection_player_summoner_anonymous",[_loc1_]);
               if(_loc4_ == null)
               {
                  _loc4_ = "Summoner " + _loc1_;
               }
               _loc3_.summonerName = _loc4_;
            }
            _loc1_++;
         }
      }
      
      override public function execute() : void
      {
         super.execute();
         this.anonymizeNames();
         onComplete();
         onResult();
      }
   }
}

