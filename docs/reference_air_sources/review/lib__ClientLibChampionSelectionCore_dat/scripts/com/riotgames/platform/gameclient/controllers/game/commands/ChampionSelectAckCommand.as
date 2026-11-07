package com.riotgames.platform.gameclient.controllers.game.commands
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.gameclient.services.GameService;
   
   public class ChampionSelectAckCommand extends CommandBase
   {
      
      private var gameService:GameService;
      
      private var gameId:Number;
      
      public function ChampionSelectAckCommand(param1:Number, param2:GameService)
      {
         super();
         this.gameId = param1;
         this.gameService = param2;
      }
      
      override protected function logResult(param1:Object) : void
      {
      }
      
      override public function execute() : void
      {
         super.execute();
         this.gameService.setClientReceivedGameMessage(this.gameId,"CHAMP_SELECT_CLIENT",onResult,onComplete,onError);
      }
   }
}

