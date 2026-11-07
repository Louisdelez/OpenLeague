package com.riotgames.platform.gameclient.exception
{
   import com.riotgames.platform.common.exception.PlatformException;
   import mx.managers.ISystemManager;
   
   [RemoteClass(alias="com.riotgames.platform.game.GameInitiationException")]
   [Mixin]
   public class GameInitiationException extends PlatformException
   {
      
      public function GameInitiationException()
      {
         super();
      }
      
      public static function init(param1:ISystemManager) : void
      {
      }
   }
}

