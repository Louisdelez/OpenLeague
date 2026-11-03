package com.riotgames.platform.gameclient.module.services.lcds
{
   import com.riotgames.platform.common.domain.AuthenticationCredentials;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.exception.AccountException;
   import com.riotgames.platform.common.exception.AccountManagementException;
   import com.riotgames.platform.gameclient.domain.AccountInformation;
   import com.riotgames.platform.gameclient.services.AccountManagementService;
   import flash.utils.Dictionary;
   
   public class AccountManagementServiceImpl extends BaseLcdsService implements AccountManagementService
   {
      
      public function AccountManagementServiceImpl()
      {
         super();
      }
      
      public function getAccountSecurityQuestion(param1:String, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:Dictionary = new Dictionary();
         _loc5_[AccountException] = param4;
         invokeServiceWithoutSession("accountManagementService","getAccountSecurityQuestion",[param1],param2,param3,_loc5_);
      }
      
      public function changeAccountInformation(param1:AccountInformation, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:Dictionary = new Dictionary();
         _loc5_[ServerError.VALIDATION_ERROR] = param4;
         invokeServiceWithoutSession("accountManagementService","changeAccountInformation",[param1],param2,param3,_loc5_);
      }
      
      public function resetPassword(param1:String, param2:String, param3:String, param4:Function, param5:Function, param6:Function) : void
      {
         var _loc7_:Dictionary = new Dictionary();
         _loc7_[AccountManagementException] = param6;
         invokeServiceWithoutSession("accountManagementService","resetPassword",[param1,param2,param3],param4,param5,_loc7_);
      }
      
      public function changePassword(param1:String, param2:String, param3:String, param4:String, param5:Function, param6:Function, param7:Function) : void
      {
         var _loc8_:Dictionary = new Dictionary();
         _loc8_[AccountManagementException] = param7;
         _loc8_[AccountException] = param7;
         var _loc9_:AuthenticationCredentials = new AuthenticationCredentials();
         _loc9_.password = param3;
         _loc9_.oldPassword = param2;
         _loc9_.securityAnswer = param4;
         _loc9_.clientVersion = param1;
         invokeServiceWithoutSession("accountManagementService","changePassword",[_loc9_],param5,param6,_loc8_);
      }
      
      public function changeEmail(param1:String, param2:String, param3:Function, param4:Function, param5:Function) : void
      {
         var _loc6_:Dictionary = new Dictionary();
         _loc6_[ServerError.VALIDATION_ERROR] = param5;
         _loc6_[AccountException] = param5;
         invokeServiceWithoutSession("accountManagementService","changeEmail",[param1,param2],param3,param4,_loc6_);
      }
      
      public function changePasswordAfterReset(param1:String, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:Dictionary = new Dictionary();
         _loc5_[AccountManagementException] = param4;
         _loc5_[AccountException] = param4;
         invokeServiceWithoutSession("accountManagementService","changePasswordAfterReset",[param1],param2,param3,_loc5_);
      }
   }
}

