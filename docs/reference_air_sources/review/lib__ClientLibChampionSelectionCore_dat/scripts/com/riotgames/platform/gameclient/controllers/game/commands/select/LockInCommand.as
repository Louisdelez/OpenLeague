package com.riotgames.platform.gameclient.controllers.game.commands.select
{
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.gameclient.controllers.game.commands.*;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.services.GameService;
   import mx.managers.ICursorManager;
   import mx.resources.IResourceManager;
   
   public class LockInCommand extends WaitCommand
   {
      
      private var gameService:GameService;
      
      private var championSelectionModel:ChampionSelectionModel;
      
      private const SUMMON_WAIT_STRING:String = "serverWait_summoningChampion";
      
      private var soundManager:ISoundProvider;
      
      public function LockInCommand(param1:GameService, param2:ISoundProvider, param3:ChampionSelectionModel, param4:IResourceManager, param5:ICursorManager)
      {
         super(param4,param5);
         this.gameService = param1;
         this.championSelectionModel = param3;
         this.soundManager = param2;
      }
      
      override protected function onResult(param1:Object = null) : void
      {
         var _loc2_:GameDTO = param1.result as GameDTO;
         if(Boolean(this.championSelectionModel) && Boolean(_loc2_))
         {
            this.championSelectionModel.currentGame = _loc2_;
         }
         super.onResult(_loc2_);
      }
      
      override public function execute() : void
      {
         super.execute();
         this.soundManager.play(AudioKeys.NEW_SOUND_LOCK_IN);
         this.gameService.championSelectCompleted(this.onResult,onComplete);
      }
   }
}

