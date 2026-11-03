package com.riotgames.platform.gameclient.module.services.lcds
{
   import com.riotgames.platform.common.services.RerollService;
   import com.riotgames.platform.gameclient.exception.GameException;
   import com.riotgames.platform.gameclient.exception.NoRollsRemainException;
   import com.riotgames.platform.gameclient.exception.ServiceNotAvailableException;
   import flash.utils.Dictionary;
   
   public class RerollServiceImpl extends BaseLcdsService implements RerollService
   {
      
      public function RerollServiceImpl()
      {
         super();
      }
      
      public function getPointsBalance(param1:Function, param2:Function, param3:Function) : void
      {
         var _loc4_:Dictionary = new Dictionary();
         if(param3 != null)
         {
            _loc4_[ServiceNotAvailableException] = param3;
         }
         invokeServiceWithoutSession("lcdsRerollService","getPointsBalance",[],param1,param2,_loc4_);
      }
      
      public function useReroll(param1:Function, param2:Function, param3:Function) : void
      {
         var _loc4_:Dictionary = new Dictionary();
         if(param3 != null)
         {
            _loc4_[NoRollsRemainException] = param3;
            _loc4_[GameException] = param3;
         }
         invokeServiceWithoutSession("lcdsRerollService","roll",[],param1,param2,_loc4_);
      }
   }
}

