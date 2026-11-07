package com.riotgames.pvpnet.accountcreation.model
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   
   public class PlayTutorialModel
   {
      
      private var _tutorialTypeRequested:Signal = new Signal();
      
      private var _tutorialTypeChanged:Signal = new Signal();
      
      private var _playTutorialAnswered:Signal = new Signal();
      
      public function PlayTutorialModel()
      {
         super();
      }
      
      public function requestTutorialType() : void
      {
         this._tutorialTypeRequested.dispatch();
      }
      
      public function getTutorialTypeRequested() : ISignal
      {
         return this._tutorialTypeRequested;
      }
      
      public function set basicTutorialType(param1:Boolean) : void
      {
         this._tutorialTypeChanged.dispatch(param1);
      }
      
      public function getTutorialTypeChanged() : ISignal
      {
         return this._tutorialTypeChanged;
      }
      
      public function set playTutorial(param1:Boolean) : void
      {
         this._playTutorialAnswered.dispatch(param1);
      }
      
      public function getPlayTutorialAnswered() : ISignal
      {
         return this._playTutorialAnswered;
      }
   }
}

