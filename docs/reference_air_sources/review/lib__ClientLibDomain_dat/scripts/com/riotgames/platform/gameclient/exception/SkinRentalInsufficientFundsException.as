package com.riotgames.platform.gameclient.exception
{
   import com.riotgames.platform.common.exception.PlatformException;
   import flash.net.registerClassAlias;
   import mx.managers.ISystemManager;
   
   [RemoteClass(alias="com.riotgames.platform.skin.rental.service.api.SkinRentalInsufficientFundsException")]
   [Mixin]
   public class SkinRentalInsufficientFundsException extends PlatformException
   {
      
      public function SkinRentalInsufficientFundsException()
      {
         super();
      }
      
      public static function init(param1:ISystemManager) : void
      {
         registerClassAlias("com.riotgames.platform.skin.rental.service.api.SkinRentalInsufficientFundsException",SkinRentalInsufficientFundsException);
      }
   }
}

