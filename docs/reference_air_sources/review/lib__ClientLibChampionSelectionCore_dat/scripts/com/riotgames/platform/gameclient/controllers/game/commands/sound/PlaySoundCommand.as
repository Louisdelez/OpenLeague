package com.riotgames.platform.gameclient.controllers.game.commands.sound
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.common.provider.ISoundProvider;
   
   public class PlaySoundCommand extends CommandBase
   {
      
      private var _soundProvider:ISoundProvider;
      
      private var _audioKey:String;
      
      public function PlaySoundCommand(param1:String, param2:ISoundProvider)
      {
         super();
         this._audioKey = param1;
         this._soundProvider = param2;
      }
      
      override public function execute() : void
      {
         super.execute();
         this._soundProvider.play(this._audioKey);
         onComplete();
         onResult();
      }
   }
}

