package com.riotgames.platform.gameclient.controllers.game.commands.trades
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.gameclient.services.trade.IChampionTradeService;
   
   public class DismissTradeCommand extends CommandBase
   {
      
      private var _tradeService:IChampionTradeService;
      
      public function DismissTradeCommand(param1:IChampionTradeService)
      {
         super(false);
         this._tradeService = param1;
      }
      
      override public function execute() : void
      {
         super.execute();
         this._tradeService.dismissTrade(onResult,onComplete,onError);
      }
   }
}

