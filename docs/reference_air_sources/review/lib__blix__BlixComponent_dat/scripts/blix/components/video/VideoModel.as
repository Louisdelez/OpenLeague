package blix.components.video
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   
   public class VideoModel
   {
      
      protected var _isPlayingChanged:Signal = new Signal();
      
      protected var _isPlaying:Boolean = true;
      
      protected var _isStoppedChanged:Signal = new Signal();
      
      protected var _isStopped:Boolean = false;
      
      protected var _metaDataChanged:Signal = new Signal();
      
      protected var _metaData:VideoMetaData;
      
      protected var _videoUrlChanged:Signal = new Signal();
      
      protected var _videoUrl:String;
      
      public function VideoModel()
      {
         super();
      }
      
      public function getIsPaused() : Boolean
      {
         return this._isPlaying && !this._isStopped;
      }
      
      public function getIsPlayingChanged() : ISignal
      {
         return this._isPlayingChanged;
      }
      
      public function getIsPlaying() : Boolean
      {
         return this._isPlaying;
      }
      
      public function setIsPlaying(param1:Boolean) : void
      {
         if(this._isPlaying == param1)
         {
            return;
         }
         this._isPlaying = param1;
         if(this._isPlaying)
         {
            this.setIsStopped(false);
         }
         this._isPlayingChanged.dispatch(this);
      }
      
      public function getIsStoppedChanged() : ISignal
      {
         return this._isStoppedChanged;
      }
      
      public function getIsStopped() : Boolean
      {
         return this._isStopped;
      }
      
      public function setIsStopped(param1:Boolean) : void
      {
         if(this._isStopped == param1)
         {
            return;
         }
         this._isStopped = param1;
         if(this._isStopped)
         {
            this.setIsPlaying(false);
         }
         this._isStoppedChanged.dispatch(this);
      }
      
      public function play() : void
      {
         this.setIsPlaying(true);
      }
      
      public function pause() : void
      {
         this.setIsPlaying(false);
      }
      
      public function stop() : void
      {
         this.setIsStopped(true);
      }
      
      public function seek(param1:Number) : void
      {
      }
      
      public function getMetaDataChanged() : ISignal
      {
         return this._metaDataChanged;
      }
      
      public function getMetaData() : VideoMetaData
      {
         return this._metaData;
      }
      
      public function setMetaData(param1:VideoMetaData) : void
      {
         this._metaData = param1;
         this._metaDataChanged.dispatch(this);
      }
      
      public function getVideoUrlChanged() : ISignal
      {
         return this._videoUrlChanged;
      }
      
      public function getVideoUrl() : String
      {
         return this._videoUrl;
      }
      
      public function setVideoUrl(param1:String) : void
      {
         this._videoUrl = param1;
         this.setMetaData(null);
         this.setIsStopped(true);
         this._videoUrlChanged.dispatch(this);
      }
      
      public function triggerCuePoint(param1:Object) : void
      {
      }
   }
}

