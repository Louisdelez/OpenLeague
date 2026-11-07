package com.riotgames.platform.gameclient.controllers.game.commands
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.domain.GameObserver;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   
   public class UpdateSpectatorsCommand extends CommandBase
   {
      
      private var championSelectionModel:ChampionSelectionModel;
      
      private var playerRoster:Array;
      
      private var accountId:Number;
      
      public function UpdateSpectatorsCommand(param1:ChampionSelectionModel, param2:Array, param3:Number)
      {
         super();
         this.championSelectionModel = param1;
         this.playerRoster = param2;
         this.accountId = param3;
      }
      
      override public function execute() : void
      {
         super.execute();
         this.updateSpectators();
         onComplete();
         onResult();
      }
      
      private function updateSpectators() : void
      {
         var _loc1_:GameObserver = null;
         var _loc2_:GameParticipant = null;
         for each(_loc1_ in this.championSelectionModel.currentGame.observers)
         {
            _loc2_ = this.playerRoster[_loc1_.accountId] as GameParticipant;
            if(!_loc2_)
            {
               this.playerRoster[_loc1_.accountId] = _loc1_;
            }
            if(_loc1_.accountId == this.accountId)
            {
               _loc1_.isMe = true;
               this.championSelectionModel.currentPlayerParticipant = this.playerRoster[_loc1_.accountId];
            }
         }
      }
   }
}

