package com.riotgames.platform.common.exception
{
   import flash.net.registerClassAlias;
   import mx.managers.ISystemManager;
   
   [RemoteClass(alias="com.riotgames.platform.account.AccountException")]
   [Mixin]
   public class AccountException extends PlatformException
   {
      
      public function AccountException()
      {
         super();
      }
      
      public static function init(param1:ISystemManager) : void
      {
         registerClassAlias("com.riotgames.platform.account.AccountSaveFailedException",AccountException);
      }
   }
}

