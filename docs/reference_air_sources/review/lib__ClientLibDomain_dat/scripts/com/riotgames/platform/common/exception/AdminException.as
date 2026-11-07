package com.riotgames.platform.common.exception
{
   import flash.net.registerClassAlias;
   import mx.managers.ISystemManager;
   
   [RemoteClass(alias="com.riotgames.platform.admin.AdminException")]
   [Mixin]
   public class AdminException extends PlatformException
   {
      
      public function AdminException()
      {
         super();
      }
      
      public static function init(param1:ISystemManager) : void
      {
         registerClassAlias("com.riotgames.platform.admin.InvitationNotFoundException",AdminException);
      }
   }
}

