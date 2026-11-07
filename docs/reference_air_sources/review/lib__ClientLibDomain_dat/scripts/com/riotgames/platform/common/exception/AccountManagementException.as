package com.riotgames.platform.common.exception
{
   import flash.net.registerClassAlias;
   import mx.managers.ISystemManager;
   
   [RemoteClass(alias="com.riotgames.platform.account.management.AccountManagementException")]
   [Mixin]
   public class AccountManagementException extends PlatformException
   {
      
      public function AccountManagementException()
      {
         super();
      }
      
      public static function init(param1:ISystemManager) : void
      {
         registerClassAlias("com.riotgames.platform.account.management.InvalidCredentialsException",AccountManagementException);
      }
   }
}

