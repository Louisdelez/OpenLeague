package com.riotgames.platform.gameclient.exception
{
   import com.riotgames.platform.common.exception.PlatformException;
   import flash.net.registerClassAlias;
   import mx.managers.ISystemManager;
   
   [RemoteClass(alias="com.riotgames.platform.reroll.logic.exception.ServiceNotAvailableException")]
   [Mixin]
   public class ServiceNotAvailableException extends PlatformException
   {
      
      public function ServiceNotAvailableException()
      {
         super();
      }
      
      public static function init(param1:ISystemManager) : void
      {
         registerClassAlias("com.riotgames.platform.reroll.logic.exception.ServiceNotAvailableException",ServiceNotAvailableException);
      }
   }
}

