package com.riotgames.platform.gameclient.controllers.game.commands
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.services.GameService;
   
   public class SetGameStateCommand extends CommandBase
   {
      
      private var game:GameDTO;
      
      private var gameService:GameService;
      
      public function SetGameStateCommand(param1:GameDTO, param2:GameService)
      {
         super();
         this.game = param1;
         this.gameService = param2;
      }
      
      override public function execute() : void
      {
         super.execute();
         this.gameService.getGameState(this.game,this.onResult,null,onError);
      }
      
      override protected function onResult(param1:Object = null) : void
      {
         var _loc2_:GameDTO = param1.result as GameDTO;
         super.onResult(_loc2_);
      }
   }
}

