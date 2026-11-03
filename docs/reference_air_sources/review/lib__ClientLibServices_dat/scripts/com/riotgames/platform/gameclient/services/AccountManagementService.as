package com.riotgames.platform.gameclient.services
{
   import com.riotgames.platform.gameclient.domain.AccountInformation;
   
   public interface AccountManagementService
   {
      
      function resetPassword(param1:String, param2:String, param3:String, param4:Function, param5:Function, param6:Function) : void;
      
      function changePassword(param1:String, param2:String, param3:String, param4:String, param5:Function, param6:Function, param7:Function) : void;
      
      function changeEmail(param1:String, param2:String, param3:Function, param4:Function, param5:Function) : void;
      
      function getAccountSecurityQuestion(param1:String, param2:Function, param3:Function, param4:Function) : void;
      
      function changePasswordAfterReset(param1:String, param2:Function, param3:Function, param4:Function) : void;
      
      function changeAccountInformation(param1:AccountInformation, param2:Function, param3:Function, param4:Function) : void;
   }
}

