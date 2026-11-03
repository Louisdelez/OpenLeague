package com.riotgames.platform.gameclient.domain
{
   public class GameStatusLogicTable
   {
      
      public static const DEFEAT:uint = 0;
      
      public static const VICTORY:uint = 1;
      
      public static const LOSS_P:uint = 2;
      
      public static const LEAVER:uint = 3;
      
      public function GameStatusLogicTable()
      {
         super();
      }
      
      public static function determineGameResult(param1:Boolean, param2:Boolean, param3:Boolean) : uint
      {
         var _loc5_:uint = 0;
         var _loc6_:Array = null;
         var _loc4_:Array = [[false,false,false,DEFEAT],[true,false,false,VICTORY],[false,true,false,LEAVER],[false,false,true,LOSS_P],[true,true,false,LEAVER],[false,true,true,LOSS_P],[true,false,true,VICTORY],[true,true,true,VICTORY]];
         for each(_loc6_ in _loc4_)
         {
            if(_loc6_[0] == param1 && _loc6_[1] == param2 && _loc6_[2] == param3)
            {
               _loc5_ = uint(_loc6_[3]);
               break;
            }
         }
         return _loc5_;
      }
   }
}

