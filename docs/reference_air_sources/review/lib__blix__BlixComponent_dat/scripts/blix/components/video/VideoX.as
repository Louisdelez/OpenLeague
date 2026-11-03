package blix.components.video
{
   import blix.assets.proxy.SimpleChild;
   import blix.assets.proxy.SpriteProxy;
   import blix.context.Context;
   import blix.layout.vo.HorizontalAlign;
   import blix.layout.vo.VerticalAlign;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import flash.display.Sprite;
   import flash.events.NetStatusEvent;
   import flash.events.SecurityErrorEvent;
   import flash.geom.Rectangle;
   import flash.media.Video;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   
   public class VideoX extends SpriteProxy
   {
      
      protected var isConnected:Boolean;
      
      protected var connection:NetConnection;
      
      protected var stream:NetStream;
      
      protected var video:Video;
      
      protected var _videoModel:VideoModel;
      
      protected var _maintainAspectRatio:Boolean = true;
      
      protected var _horizontalAlign:uint = 1;
      
      protected var _verticalAlign:uint = 1;
      
      protected var streamHasStarted:Boolean;
      
      protected var _isBufferingChanged:Signal = new Signal();
      
      protected var _isBuffering:Boolean = false;
      
      protected var streamIsPlaying:Boolean;
      
      private var videoChild:SimpleChild;
      
      public var bufferTime:Number = 10;
      
      protected var _erred:Signal = new Signal();
      
      protected var _error:Error;
      
      public function VideoX(param1:Context, param2:VideoModel = null, param3:Sprite = null)
      {
         super(param1,param3 || new Sprite());
         this.createConnection();
         this.setVideoModel(param2);
      }
      
      public function getErred() : ISignal
      {
         return this._erred;
      }
      
      public function getError() : Error
      {
         return this._error;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.video = new Video();
         this.videoChild = new SimpleChild(this.video);
         addChild(this.videoChild);
      }
      
      public function getVideoModel() : VideoModel
      {
         return this._videoModel;
      }
      
      public function setVideoModel(param1:VideoModel) : void
      {
         if(this._videoModel != null)
         {
            this._videoModel.getIsPlayingChanged().remove(this.videoIsPlayingChangedHandler);
            this._videoModel.getIsStoppedChanged().remove(this.videoIsStoppedChangedHandler);
            this._videoModel.getVideoUrlChanged().remove(this.videoUrlChangedHandler);
            this.closeStream();
         }
         this._videoModel = param1;
         if(this._videoModel != null)
         {
            this._videoModel.getIsPlayingChanged().add(this.videoIsPlayingChangedHandler);
            this._videoModel.getIsStoppedChanged().add(this.videoIsStoppedChangedHandler);
            this._videoModel.getVideoUrlChanged().add(this.videoUrlChangedHandler);
         }
         this.refreshIsPlaying();
      }
      
      protected function videoIsPlayingChangedHandler() : void
      {
         this.refreshIsPlaying();
      }
      
      private function videoIsStoppedChangedHandler() : void
      {
         if(this._videoModel.getIsStopped())
         {
            this.closeStream();
         }
      }
      
      protected function videoUrlChangedHandler() : void
      {
         this.refreshIsPlaying();
      }
      
      public function getStream() : NetStream
      {
         return this.stream;
      }
      
      public function getIsBufferingChanged() : ISignal
      {
         return this._isBufferingChanged;
      }
      
      public function getIsBuffering() : Boolean
      {
         return this._isBuffering;
      }
      
      protected function setIsBuffering(param1:Boolean) : void
      {
         if(this._isBuffering == param1)
         {
            return;
         }
         this._isBuffering = param1;
         this._isBufferingChanged.dispatch(this);
      }
      
      protected function createConnection() : void
      {
         this.connection = new NetConnection();
         this.connection.addEventListener(NetStatusEvent.NET_STATUS,this.netConnectionNetStatusHandler);
         this.connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
         this.connection.connect(null);
      }
      
      protected function netConnectionNetStatusHandler(param1:NetStatusEvent) : void
      {
         switch(param1.info.code)
         {
            case "NetConnection.Connect.Success":
               this.isConnected = true;
               this.createStream();
               break;
            case "NetConnection.Connect.Closed":
               this.isConnected = false;
         }
      }
      
      protected function createStream() : void
      {
         if(this.stream != null)
         {
            this.stream.removeEventListener(NetStatusEvent.NET_STATUS,this.streamNetStatusHandler);
         }
         this.stream = new NetStream(this.connection);
         this.stream.bufferTime = this.bufferTime;
         this.stream.client = {};
         this.stream.client.onMetaData = this.netStreamOnMetaData;
         this.stream.client.onCuePoint = this.netStreamOnCuePoint;
         this.stream.addEventListener(NetStatusEvent.NET_STATUS,this.streamNetStatusHandler);
         this.video.attachNetStream(this.stream);
         this.refreshIsPlaying();
      }
      
      protected function closeStream() : void
      {
         if(this.streamHasStarted)
         {
            this.streamHasStarted = false;
            this.streamIsPlaying = false;
            this.stream.close();
            this.video.clear();
         }
      }
      
      protected function refreshIsPlaying() : void
      {
         if(this._videoModel == null || this.stream == null)
         {
            return;
         }
         if(this._videoModel.getIsPlaying() && this._videoModel.getVideoUrl() != null)
         {
            if(!this.streamIsPlaying)
            {
               this.streamIsPlaying = true;
               if(this.streamHasStarted)
               {
                  this.stream.resume();
               }
               else
               {
                  this.streamHasStarted = true;
                  this.stream.play(this._videoModel.getVideoUrl());
                  this.setIsBuffering(true);
                  invalidateLayout();
               }
            }
         }
         else if(this.streamIsPlaying)
         {
            this.streamIsPlaying = false;
            this.stream.pause();
         }
      }
      
      protected function netStreamOnCuePoint(param1:Object) : void
      {
         this._videoModel.triggerCuePoint(param1);
      }
      
      protected function netStreamOnMetaData(param1:Object) : void
      {
         this._videoModel.setMetaData(VideoMetaData.unmarshal(param1));
         invalidateLayout();
      }
      
      public function getVideo() : Video
      {
         return this.video;
      }
      
      protected function streamNetStatusHandler(param1:NetStatusEvent) : void
      {
         switch(param1.info.code)
         {
            case "NetStream.Play.StreamNotFound":
               if(this._videoModel != null)
               {
                  _logger.logError("Unable to locate video: " + this._videoModel.getVideoUrl());
                  this.dispatchErred(new Error("Unable to locate video."));
               }
               break;
            case "NetStream.Play.Start":
               this.setIsBuffering(false);
               invalidateLayout();
               break;
            case "NetStream.Buffer.Full":
               this.setIsBuffering(false);
               invalidateLayout();
               break;
            case "NetStream.Play.Stop":
               this.streamIsPlaying = false;
               this.streamHasStarted = false;
               this.video.clear();
               if(this._videoModel != null)
               {
                  this._videoModel.stop();
               }
         }
      }
      
      protected function securityErrorHandler(param1:SecurityErrorEvent) : void
      {
         _logger.logError("securityErrorHandler: " + param1.text);
         this.dispatchErred(new Error(param1.text));
      }
      
      protected function dispatchErred(param1:Error) : void
      {
         this._error = param1 || new Error();
         this._erred.dispatch(this);
      }
      
      public function getMaintainAspectRatio() : Boolean
      {
         return this._maintainAspectRatio;
      }
      
      public function setMaintainAspectRatio(param1:Boolean) : void
      {
         if(this._maintainAspectRatio == param1)
         {
            return;
         }
         this._maintainAspectRatio = param1;
         invalidateLayout();
      }
      
      public function getHorizontalAlign() : uint
      {
         return this._horizontalAlign;
      }
      
      public function setHorizontalAlign(param1:uint) : void
      {
         if(this._horizontalAlign == param1)
         {
            return;
         }
         this._horizontalAlign = param1;
         invalidateLayout();
      }
      
      public function getVerticalAlign() : uint
      {
         return this._verticalAlign;
      }
      
      public function setVerticalAlign(param1:uint) : void
      {
         if(this._verticalAlign == param1)
         {
            return;
         }
         this._verticalAlign = param1;
         invalidateLayout();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc7_:Number = NaN;
         if(this._videoModel == null || !this.isConnected)
         {
            return new Rectangle();
         }
         var _loc3_:Number = isNaN(param1) ? this.video.videoWidth : param1;
         var _loc4_:Number = isNaN(param2) ? this.video.videoHeight : param2;
         var _loc5_:Number = _loc3_;
         var _loc6_:Number = _loc4_;
         if(Boolean(this._maintainAspectRatio) && Boolean(this.video.videoWidth) && Boolean(this.video.videoHeight))
         {
            _loc7_ = this.video.videoWidth / this.video.videoHeight;
            if(_loc4_ * _loc7_ >= _loc3_)
            {
               _loc6_ = _loc3_ / _loc7_;
            }
            else
            {
               _loc5_ = _loc4_ * _loc7_;
            }
            switch(this._verticalAlign)
            {
               case VerticalAlign.TOP:
                  this.video.y = 0;
                  break;
               case VerticalAlign.MIDDLE:
                  this.video.y = (_loc4_ - _loc6_) / 2;
                  break;
               case VerticalAlign.BOTTOM:
                  this.video.y = _loc4_ - _loc6_;
            }
            switch(this._horizontalAlign)
            {
               case HorizontalAlign.LEFT:
                  this.video.x = 0;
                  break;
               case HorizontalAlign.CENTER:
                  this.video.x = (_loc3_ - _loc5_) / 2;
                  break;
               case HorizontalAlign.RIGHT:
                  this.video.x = _loc3_ - _loc5_;
            }
         }
         this.video.width = _loc5_;
         this.video.height = _loc6_;
         return new Rectangle(0,0,_loc3_,_loc4_);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(Boolean(this._videoModel))
         {
            this._videoModel.stop();
         }
         this.setVideoModel(null);
         this._isBufferingChanged.removeAll();
         this._erred.removeAll();
      }
   }
}

