package com.riotgames.platform.gameclient.exception
{
   import com.riotgames.platform.common.exception.PlatformException;
   import flash.net.registerClassAlias;
   import mx.managers.ISystemManager;
   
   [RemoteClass(alias="com.riotgames.platform.matchmaking.MatchmakingException")]
   [Mixin]
   public class MatchmakingException extends PlatformException
   {
      
      public function MatchmakingException()
      {
         super();
      }
      
      public static function init(param1:ISystemManager) : void
      {
         registerClassAlias("com.riotgames.platform.matchmaking.MatchmakingException",MatchmakingException);
      }
   }
}

