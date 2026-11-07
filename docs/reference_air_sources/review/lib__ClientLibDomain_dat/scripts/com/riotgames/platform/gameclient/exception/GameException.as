package com.riotgames.platform.gameclient.exception
{
   import com.riotgames.platform.common.exception.PlatformException;
   import flash.net.registerClassAlias;
   import mx.managers.ISystemManager;
   
   [RemoteClass(alias="com.riotgames.platform.game.GameException")]
   [Mixin]
   public class GameException extends PlatformException
   {
      
      public function GameException()
      {
         super();
      }
      
      public static function init(param1:ISystemManager) : void
      {
         registerClassAlias("com.riotgames.platform.game.GameFullException",GameException);
         registerClassAlias("com.riotgames.platform.game.GameNameNotUniqueException",GameException);
         registerClassAlias("com.riotgames.platform.game.GameNotFoundException",GameException);
         registerClassAlias("com.riotgames.platform.game.IncorrectPasswordException",GameException);
         registerClassAlias("com.riotgames.platform.game.InvalidGameStateException",GameException);
         registerClassAlias("com.riotgames.platform.game.PlayerAlreadyInGameException",GameException);
         registerClassAlias("com.riotgames.platform.game.TeamFullException",GameException);
         registerClassAlias("com.riotgames.platform.game.UserBannedException",GameException);
         registerClassAlias("com.riotgames.platform.game.StaleGameVersionException",GameException);
         registerClassAlias("com.riotgames.platform.game.NotEnoughPlayersException",GameException);
         registerClassAlias("com.riotgames.platform.game.TooManyPlayersException",GameException);
         registerClassAlias("com.riotgames.platform.game.GameModeNotSupportedException",GameException);
         registerClassAlias("com.riotgames.platform.game.GameNotDraftModeTurnException",GameException);
         registerClassAlias("com.riotgames.platform.messaging.UnexpectedServiceException",GameException);
      }
   }
}

