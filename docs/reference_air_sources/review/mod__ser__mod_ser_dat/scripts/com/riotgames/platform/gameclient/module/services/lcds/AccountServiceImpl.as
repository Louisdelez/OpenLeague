package com.riotgames.platform.gameclient.module.services.lcds
{
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.gameclient.services.AccountService;
   import flash.utils.Dictionary;
   
   public class AccountServiceImpl extends BaseLcdsService implements AccountService
   {
      
      public function AccountServiceImpl()
      {
         super();
      }
      
      public function getAccountState(param1:Function, param2:Function, param3:Function) : void
      {
         var _loc4_:Dictionary = new Dictionary();
         _loc4_[ServerError.MISSING_ARGUMENT_ERROR] = param3;
         invokeServiceWithoutSession("accountService","getAccountStateForCurrentSession",[],param1,param2,_loc4_);
      }
   }
}

