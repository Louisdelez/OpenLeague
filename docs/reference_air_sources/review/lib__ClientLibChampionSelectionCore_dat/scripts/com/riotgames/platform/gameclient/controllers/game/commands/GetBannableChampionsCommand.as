package com.riotgames.platform.gameclient.controllers.game.commands
{
   import com.riotgames.platform.gameclient.services.GameService;
   import mx.managers.ICursorManager;
   import mx.resources.IResourceManager;
   
   public class GetBannableChampionsCommand extends WaitCommand
   {
      
      private var gameService:GameService;
      
      public function GetBannableChampionsCommand(param1:GameService, param2:IResourceManager, param3:ICursorManager)
      {
         super(param2,param3);
         this.gameService = param1;
      }
      
      override public function execute() : void
      {
         super.execute();
         this.getChampionsForBan();
      }
      
      private function getChampionsForBan() : void
      {
         this.gameService.getChampionsForBan(this.onResult,onComplete);
      }
      
      override protected function onResult(param1:Object = null) : void
      {
         super.onResult(param1.result);
      }
   }
}

