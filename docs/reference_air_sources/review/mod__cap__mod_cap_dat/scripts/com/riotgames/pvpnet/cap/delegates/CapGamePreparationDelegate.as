package com.riotgames.pvpnet.cap.delegates
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.provider.SoundProviderProxy;
   import com.riotgames.pvpnet.cap.audio.CapAudioKeys;
   import com.riotgames.pvpnet.cap.controllers.CapMusicController;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.views.CapView;
   import com.riotgames.pvpnet.game.IGamePreparationDelegate;
   import flash.utils.setTimeout;
   
   public class CapGamePreparationDelegate implements IGamePreparationDelegate
   {
      
      private static const PREP_TIME:int = 5200;
      
      private var _musicController:CapMusicController;
      
      private var _model:CapModel;
      
      private var _inProgress:Boolean = false;
      
      private var _gamePreparationFinished:Signal = new Signal();
      
      private var _capView:CapView;
      
      public function CapGamePreparationDelegate(param1:CapMusicController, param2:CapModel)
      {
         super();
         this._musicController = param1;
         this._model = param2;
      }
      
      public function getGamePreparationFinished() : ISignal
      {
         return this._gamePreparationFinished;
      }
      
      public function setView(param1:CapView) : void
      {
         this._capView = param1;
      }
      
      public function prepareForGame() : void
      {
         if(this._inProgress)
         {
            return;
         }
         this._inProgress = true;
         if(this._capView)
         {
            setTimeout(this.showPopupCompleted,PREP_TIME);
            this._capView.showMatchFoundPopup();
            SoundProviderProxy.instance.play(CapAudioKeys.CAP_MATCH_FOUND);
            this._musicController.stopMusic();
            this._model.quitEnabled = false;
         }
         else
         {
            this._gamePreparationFinished.dispatch();
         }
      }
      
      private function showPopupCompleted() : void
      {
         this._capView.hideMatchFoundPopup();
         this._gamePreparationFinished.dispatch();
      }
   }
}

