package com.riotgames.platform.common.exception
{
   [RemoteClass(alias="com.riotgames.platform.login.LoginFailedException")]
   public class LoginFailedException extends PlatformException
   {
      
      public var bannedUntilDate:Number;
      
      public function LoginFailedException()
      {
         super();
      }
   }
}

