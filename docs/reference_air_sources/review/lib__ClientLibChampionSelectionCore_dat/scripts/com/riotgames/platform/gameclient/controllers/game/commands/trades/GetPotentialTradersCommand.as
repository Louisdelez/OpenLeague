package com.riotgames.platform.gameclient.controllers.game.commands.trades
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.gameclient.controllers.game.model.PlayerSelection;
   import com.riotgames.platform.gameclient.domain.game.trade.PotentialTradersDTO;
   import com.riotgames.platform.gameclient.services.trade.IChampionTradeService;
   import mx.collections.ArrayCollection;
   
   public class GetPotentialTradersCommand extends CommandBase
   {
      
      private var _playerSelections:ArrayCollection;
      
      private var _championTradeService:IChampionTradeService;
      
      private var _tradesAllowed:Boolean;
      
      public function GetPotentialTradersCommand(param1:ArrayCollection, param2:Boolean, param3:IChampionTradeService)
      {
         super(false);
         this._championTradeService = param3;
         this._playerSelections = param1;
         this._tradesAllowed = param2;
      }
      
      override protected function onResult(param1:Object = null) : void
      {
         var _loc2_:PotentialTradersDTO = param1.result as PotentialTradersDTO;
         if(Boolean(_loc2_))
         {
            this.handlePotentialTradesRetrieved(_loc2_);
            super.onResult(_loc2_);
         }
         else
         {
            onError(param1);
         }
      }
      
      override public function execute() : void
      {
         var _loc1_:PotentialTradersDTO = null;
         super.execute();
         if(this._tradesAllowed)
         {
            this._championTradeService.getPotentialTraders(this.onResult,onComplete,onError);
         }
         else
         {
            logger.warn("Trades forced off, turning of all trades");
            onComplete();
            _loc1_ = new PotentialTradersDTO();
            _loc1_.potentialTraders = new ArrayCollection();
            this.handlePotentialTradesRetrieved(_loc1_);
         }
      }
      
      private function handlePotentialTradesRetrieved(param1:PotentialTradersDTO) : void
      {
         var _loc2_:PlayerSelection = null;
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         for each(_loc2_ in this._playerSelections)
         {
            _loc3_ = false;
            for each(_loc4_ in param1.potentialTraders)
            {
               if(_loc4_ == _loc2_.participant.summonerInternalName)
               {
                  _loc3_ = true;
                  break;
               }
            }
            _loc2_.tradeAvailable = _loc3_;
         }
      }
   }
}

