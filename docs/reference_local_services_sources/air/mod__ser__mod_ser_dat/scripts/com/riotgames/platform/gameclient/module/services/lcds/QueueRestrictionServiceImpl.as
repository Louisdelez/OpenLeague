package com.riotgames.platform.gameclient.module.services.lcds
{
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.services.QueueRestrictionService;
   import flash.utils.Dictionary;
   
   public class QueueRestrictionServiceImpl extends BaseLcdsService implements QueueRestrictionService
   {
      
      public function QueueRestrictionServiceImpl()
      {
         super();
      }
      
      public function getQueueRestrictions(param1:Number, param2:Array, param3:Function, param4:Function, param5:Function) : void
      {
         var _loc6_:Dictionary = new Dictionary();
         if(Boolean(param5))
         {
            _loc6_[ServerError] = param5;
         }
         invokeServiceWithoutSession("lcdsQueueRestrictionService","getQueueRestrictions",[param1,param2],param3,param4,_loc6_);
      }
   }
}

