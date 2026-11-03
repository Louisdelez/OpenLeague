package com.riotgames.platform.gameclient.controllers.game.commands.trades
{
   import com.riotgames.platform.gameclient.controllers.game.commands.WaitCommand;
   import com.riotgames.platform.gameclient.services.trade.IChampionTradeService;
   import mx.managers.ICursorManager;
   import mx.resources.IResourceManager;
   
   public class AttemptChampionTradeCommand extends WaitCommand
   {
      
      private var _tradeService:IChampionTradeService;
      
      private var _desiredSummonerInternalName:String;
      
      private var _isResponse:Boolean;
      
      private var _desiredChampionId:int;
      
      public function AttemptChampionTradeCommand(param1:String, param2:int, param3:Boolean, param4:IChampionTradeService, param5:IResourceManager, param6:ICursorManager)
      {
         super(param5,param6);
         this._desiredSummonerInternalName = param1;
         this._desiredChampionId = param2;
         this._tradeService = param4;
         this._isResponse = param3;
      }
      
      override public function execute() : void
      {
         super.execute();
         this._tradeService.attemptTrade(this._desiredSummonerInternalName,this._desiredChampionId,this._isResponse,onResult,onComplete,onError);
      }
   }
}

