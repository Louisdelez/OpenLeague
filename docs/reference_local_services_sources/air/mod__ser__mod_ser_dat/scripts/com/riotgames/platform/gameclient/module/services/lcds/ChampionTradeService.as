package com.riotgames.platform.gameclient.module.services.lcds
{
   import com.riotgames.platform.gameclient.domain.game.trade.ChampionsOutOfDateException;
   import com.riotgames.platform.gameclient.services.trade.IChampionTradeService;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class ChampionTradeService extends BaseLcdsService implements IChampionTradeService
   {
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private const SERVICE_NAME:String = "lcdsChampionTradeService";
      
      public function ChampionTradeService()
      {
         super();
      }
      
      public function dismissTrade(param1:Function, param2:Function, param3:Function) : void
      {
         var _loc4_:Dictionary = new Dictionary();
         if(param3 != null)
         {
            _loc4_[ChampionsOutOfDateException] = param3;
         }
         invokeServiceWithoutSession(this.SERVICE_NAME,"dismissTrade",[],param1,param2,_loc4_);
      }
      
      public function attemptTrade(param1:String, param2:int, param3:Boolean, param4:Function, param5:Function, param6:Function) : void
      {
         var _loc7_:Dictionary = new Dictionary();
         if(param6 != null)
         {
            _loc7_[ChampionsOutOfDateException] = param6;
         }
         invokeServiceWithoutSession(this.SERVICE_NAME,"attemptTrade",[param1,param2,param3],param4,param5,_loc7_);
      }
      
      public function getPotentialTraders(param1:Function, param2:Function, param3:Function) : void
      {
         var _loc4_:Dictionary = new Dictionary();
         if(param3 != null)
         {
            _loc4_[ChampionsOutOfDateException] = param3;
         }
         invokeServiceWithoutSession(this.SERVICE_NAME,"getPotentialTraders",[],param1,param2,_loc4_);
      }
   }
}

