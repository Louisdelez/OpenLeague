package com.riotgames.platform.gameclient.controllers.game.commands
{
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.services.GameService;
   import mx.managers.ICursorManager;
   import mx.resources.IResourceManager;
   
   public class BanCommand extends WaitCommand
   {
      
      private static const BAN_WAIT_STRING:String = "serverWait_banChampion";
      
      private var gameService:GameService;
      
      private var champion:Champion;
      
      public function BanCommand(param1:Champion, param2:GameService, param3:IResourceManager, param4:ICursorManager)
      {
         super(param3,param4);
         this.champion = param1;
         this.gameService = param2;
      }
      
      override public function execute() : void
      {
         super.execute();
         this.gameService.banChampion(this.champion.championId,onResult,onComplete,onError);
      }
   }
}

