package com.greensock.loading
{
   import com.greensock.events.LoaderEvent;
   import com.greensock.loading.core.LoaderItem;
   import com.greensock.loading.display.ContentDisplay;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.NetStatusEvent;
   import flash.events.ProgressEvent;
   import flash.events.TimerEvent;
   import flash.media.SoundTransform;
   import flash.media.Video;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   import flash.net.URLRequest;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   [Event(name="netStatus",type="com.greensock.events.LoaderEvent")]
   [Event(name="httpStatus",type="com.greensock.events.LoaderEvent")]
   public class VideoLoader extends LoaderItem
   {
      
      private static var _classActivated:Boolean = _activateClass("VideoLoader",VideoLoader,"flv,f4v,mp4,mov");
      
      public static const VIDEO_COMPLETE:String = "videoComplete";
      
      public static const VIDEO_BUFFER_FULL:String = "videoBufferFull";
      
      public static const VIDEO_BUFFER_EMPTY:String = "videoBufferEmpty";
      
      public static const VIDEO_PAUSE:String = "videoPause";
      
      public static const VIDEO_PLAY:String = "videoPlay";
      
      public static const VIDEO_CUE_POINT:String = "videoCuePoint";
      
      public static const PLAY_PROGRESS:String = "playProgress";
      
      protected var _video:Video;
      
      protected var _prevTime:Number;
      
      protected var _bufferFull:Boolean;
      
      protected var _sound:SoundTransform;
      
      protected var _renderTimer:Timer;
      
      protected var _auditNS:NetStream;
      
      protected var _bufferMode:Boolean;
      
      protected var _pausePending:Boolean;
      
      protected var _renderedOnce:Boolean;
      
      protected var _volume:Number;
      
      protected var _autoDetachNetStream:Boolean;
      
      protected var _initted:Boolean;
      
      protected var _videoPaused:Boolean;
      
      protected var _nc:NetConnection;
      
      protected var _videoComplete:Boolean;
      
      public var metaData:Object;
      
      protected var _forceTime:Number;
      
      protected var _ns:NetStream;
      
      protected var _sprite:Sprite;
      
      protected var _firstCuePoint:CuePoint;
      
      protected var _duration:Number;
      
      protected var _repeatCount:uint;
      
      protected var _dispatchPlayProgress:Boolean;
      
      protected var _playStarted:Boolean;
      
      public var autoAdjustBuffer:Boolean;
      
      public function VideoLoader(urlOrRequest:*, vars:Object = null)
      {
         super(urlOrRequest,vars);
         _type = "VideoLoader";
         _nc = new NetConnection();
         _nc.connect(null);
         _nc.addEventListener("asyncError",_failHandler,false,0,true);
         _nc.addEventListener("securityError",_failHandler,false,0,true);
         _renderTimer = new Timer(80,0);
         _renderTimer.addEventListener(TimerEvent.TIMER,_renderHandler,false,0,true);
         _video = new Video(int(this.vars.width) || 320,int(this.vars.height) || 240);
         _video.smoothing = Boolean(this.vars.smoothing != false);
         _video.deblocking = uint(this.vars.deblocking);
         _video.addEventListener(Event.ADDED_TO_STAGE,_videoAddedToStage,false,0,true);
         _video.addEventListener(Event.REMOVED_FROM_STAGE,_videoRemovedFromStage,false,0,true);
         _autoDetachNetStream = Boolean(this.vars.autoDetachNetStream == true);
         _refreshNetStream();
         _duration = isNaN(this.vars.estimatedDuration) ? 200 : Number(this.vars.estimatedDuration);
         _bufferMode = _preferEstimatedBytesInAudit = Boolean(this.vars.bufferMode == true);
         _videoPaused = _pausePending = Boolean(this.vars.autoPlay == false);
         this.autoAdjustBuffer = this.vars.autoAdjustBuffer != false;
         this.volume = "volume" in this.vars ? Number(this.vars.volume) : 1;
         if(LoaderMax.contentDisplayClass is Class)
         {
            _sprite = new LoaderMax.contentDisplayClass(this);
            if(!_sprite.hasOwnProperty("rawContent"))
            {
               throw new Error("LoaderMax.contentDisplayClass must be set to a class with a \'rawContent\' property, like com.greensock.loading.display.ContentDisplay");
            }
         }
         else
         {
            _sprite = new ContentDisplay(this);
         }
         Object(_sprite).rawContent = null;
      }
      
      public function getCuePointTime(name:String) : Number
      {
         var i:int = 0;
         if(this.metaData != null && this.metaData.cuePoints is Array)
         {
            i = int(this.metaData.cuePoints.length);
            while(--i > -1)
            {
               if(name == this.metaData.cuePoints[i].name)
               {
                  return Number(this.metaData.cuePoints[i].time);
               }
            }
         }
         var cp:CuePoint = _firstCuePoint;
         while(Boolean(cp))
         {
            if(cp.name == name)
            {
               return cp.time;
            }
            cp = cp.next;
         }
         return NaN;
      }
      
      public function get playProgress() : Number
      {
         return _videoComplete ? 1 : this.videoTime / _duration;
      }
      
      public function removeASCuePoint(timeNameOrCuePoint:*) : Object
      {
         var cp:CuePoint = _firstCuePoint;
         while(Boolean(cp))
         {
            if(cp == timeNameOrCuePoint || cp.time == timeNameOrCuePoint || cp.name == timeNameOrCuePoint)
            {
               if(Boolean(cp.next))
               {
                  cp.next.prev = cp.prev;
               }
               if(Boolean(cp.prev))
               {
                  cp.prev.next = cp.next;
               }
               else if(cp == _firstCuePoint)
               {
                  _firstCuePoint = cp.next;
               }
               cp.next = cp.prev = null;
               cp.gc = true;
               return cp;
            }
            cp = cp.next;
         }
         return null;
      }
      
      protected function _setForceTime(time:Number) : void
      {
         if(!(_forceTime || _forceTime == 0))
         {
            _waitForRender();
         }
         _forceTime = time;
      }
      
      public function get videoPaused() : Boolean
      {
         return _videoPaused;
      }
      
      public function get bufferMode() : Boolean
      {
         return _bufferMode;
      }
      
      public function setContentDisplay(contentDisplay:Sprite) : void
      {
         _sprite = contentDisplay;
      }
      
      public function get netStream() : NetStream
      {
         return _ns;
      }
      
      protected function _onBufferFull() : void
      {
         if(!_renderedOnce && !_renderTimer.running)
         {
            _waitForRender();
            return;
         }
         if(_pausePending)
         {
            if(!_initted && getTimer() - _time < 10000)
            {
               _video.attachNetStream(null);
            }
            else if(_renderedOnce)
            {
               _applyPendingPause();
            }
         }
         else if(!_bufferFull)
         {
            _bufferFull = true;
            dispatchEvent(new LoaderEvent(VIDEO_BUFFER_FULL,this));
         }
      }
      
      override public function get content() : *
      {
         return _sprite;
      }
      
      public function set videoPaused(value:Boolean) : void
      {
         var changed:Boolean = Boolean(value != _videoPaused);
         _videoPaused = value;
         if(_videoPaused)
         {
            if(!_renderedOnce)
            {
               _setForceTime(0);
               _pausePending = true;
               _sound.volume = 0;
               _ns.soundTransform = _sound;
            }
            else
            {
               _pausePending = false;
               this.volume = _volume;
               _ns.pause();
            }
            if(changed)
            {
               dispatchEvent(new LoaderEvent(VIDEO_PAUSE,this));
            }
         }
         else
         {
            if(_pausePending || !_bufferFull)
            {
               if(_video.stage != null)
               {
                  _video.attachNetStream(_ns);
               }
               if(_initted && _renderedOnce)
               {
                  _seek(this.videoTime);
               }
               _pausePending = false;
            }
            this.volume = _volume;
            _ns.resume();
            if(changed && _playStarted)
            {
               dispatchEvent(new LoaderEvent(VIDEO_PLAY,this));
            }
         }
      }
      
      public function gotoVideoCuePoint(name:String, forcePlay:Boolean = false, skipCuePoints:Boolean = true) : Number
      {
         return gotoVideoTime(getCuePointTime(name),forcePlay,skipCuePoints);
      }
      
      public function set playProgress(value:Number) : void
      {
         if(_duration != 0)
         {
            gotoVideoTime(value * _duration,!_videoPaused,true);
         }
      }
      
      public function get duration() : Number
      {
         return _duration;
      }
      
      protected function _videoRemovedFromStage(event:Event) : void
      {
         if(_autoDetachNetStream)
         {
            _video.attachNetStream(null);
            _video.clear();
         }
      }
      
      protected function _forceInit() : void
      {
         if(_ns.bufferTime >= _duration)
         {
            _ns.bufferTime = uint(_duration - 1);
         }
         _initted = true;
         if(!_bufferFull && _ns.bufferLength >= _ns.bufferTime)
         {
            _onBufferFull();
         }
         Object(_sprite).rawContent = _video;
         if(!_bufferFull && _pausePending && _renderedOnce && _video.stage != null)
         {
            _video.attachNetStream(null);
         }
         else if(!_autoDetachNetStream || _video.stage != null)
         {
            _video.attachNetStream(_ns);
         }
      }
      
      public function pauseVideo(event:Event = null) : void
      {
         this.videoPaused = true;
      }
      
      override public function auditSize() : void
      {
         var request:URLRequest = null;
         if(_url.substr(0,4) == "http" && _url.indexOf("://") != -1)
         {
            super.auditSize();
         }
         else if(_auditNS == null)
         {
            _auditNS = new NetStream(_nc);
            _auditNS.bufferTime = isNaN(this.vars.bufferTime) ? 5 : Number(this.vars.bufferTime);
            _auditNS.client = {
               "onMetaData":_auditHandler,
               "onCuePoint":_auditHandler
            };
            _auditNS.addEventListener(NetStatusEvent.NET_STATUS,_auditHandler,false,0,true);
            _auditNS.addEventListener("ioError",_auditHandler,false,0,true);
            _auditNS.addEventListener("asyncError",_auditHandler,false,0,true);
            _auditNS.soundTransform = new SoundTransform(0);
            request = new URLRequest();
            request.data = _request.data;
            _setRequestURL(request,_url,!_isLocal || _url.substr(0,4) == "http" ? "gsCacheBusterID=" + _cacheID++ + "&purpose=audit" : "");
            _auditNS.play(request.url);
         }
      }
      
      public function playVideo(event:Event = null) : void
      {
         this.videoPaused = false;
      }
      
      public function get rawContent() : Video
      {
         return _video;
      }
      
      override protected function _calculateProgress() : void
      {
         _cachedBytesLoaded = _ns.bytesLoaded;
         if(_cachedBytesLoaded > 1)
         {
            if(_bufferMode)
            {
               _cachedBytesTotal = _ns.bytesTotal * (_ns.bufferTime / _duration);
               if(_ns.bufferLength > 0)
               {
                  _cachedBytesLoaded = _ns.bufferLength / _ns.bufferTime * _cachedBytesTotal;
               }
            }
            else
            {
               _cachedBytesTotal = _ns.bytesTotal;
            }
            if(_cachedBytesTotal <= _cachedBytesLoaded)
            {
               _cachedBytesTotal = this.metaData != null && _renderedOnce && _initted || getTimer() - _time >= 10000 ? _cachedBytesLoaded : uint(int(1.01 * _cachedBytesLoaded) + 1);
            }
            if(!_auditedSize)
            {
               _auditedSize = true;
               dispatchEvent(new Event("auditedSize"));
            }
         }
         _cacheIsDirty = false;
      }
      
      public function get bufferProgress() : Number
      {
         if(uint(_ns.bytesTotal) < 5)
         {
            return 0;
         }
         return _ns.bufferLength > _ns.bufferTime ? 1 : _ns.bufferLength / _ns.bufferTime;
      }
      
      public function set volume(value:Number) : void
      {
         _sound.volume = _volume = value;
         _ns.soundTransform = _sound;
      }
      
      protected function _applyPendingPause() : void
      {
         _pausePending = false;
         this.volume = _volume;
         _seek(_forceTime || 0);
         if(!_autoDetachNetStream || _video.stage != null)
         {
            _video.cacheAsBitmap = false;
            _video.attachNetStream(_ns);
            _ns.pause();
         }
      }
      
      protected function _videoAddedToStage(event:Event) : void
      {
         if(_autoDetachNetStream)
         {
            if(!_pausePending)
            {
               _seek(this.videoTime);
            }
            _video.attachNetStream(_ns);
         }
      }
      
      protected function _refreshNetStream() : void
      {
         if(_ns != null)
         {
            _ns.pause();
            try
            {
               _ns.close();
            }
            catch(error:Error)
            {
            }
            _sprite.removeEventListener(Event.ENTER_FRAME,_playProgressHandler);
            _video.attachNetStream(null);
            _video.clear();
            _ns.client = {};
            _ns.removeEventListener(NetStatusEvent.NET_STATUS,_statusHandler);
            _ns.removeEventListener("ioError",_failHandler);
            _ns.removeEventListener("asyncError",_failHandler);
            _ns.removeEventListener(Event.RENDER,_renderHandler);
         }
         _prevTime = 0;
         _ns = this.vars.netStream is NetStream ? this.vars.netStream : new NetStream(_nc);
         _ns.checkPolicyFile = Boolean(this.vars.checkPolicyFile == true);
         _ns.client = {
            "onMetaData":_metaDataHandler,
            "onCuePoint":_cuePointHandler
         };
         _ns.addEventListener(NetStatusEvent.NET_STATUS,_statusHandler,false,0,true);
         _ns.addEventListener("ioError",_failHandler,false,0,true);
         _ns.addEventListener("asyncError",_failHandler,false,0,true);
         _ns.bufferTime = isNaN(this.vars.bufferTime) ? 5 : Number(this.vars.bufferTime);
         if(!_autoDetachNetStream || _video.stage != null)
         {
            _video.attachNetStream(_ns);
         }
         _sound = _ns.soundTransform;
      }
      
      protected function _metaDataHandler(info:Object) : void
      {
         if(this.metaData == null || this.metaData.cuePoints == null)
         {
            this.metaData = info;
         }
         _duration = info.duration;
         if("width" in info)
         {
            _video.width = Number(info.width);
            _video.height = Number(info.height);
         }
         if("framerate" in info)
         {
            _renderTimer.delay = int(1000 / Number(info.framerate) + 1);
         }
         if(!_initted)
         {
            _forceInit();
            dispatchEvent(new LoaderEvent(LoaderEvent.INIT,this,"",info));
         }
         else
         {
            (_sprite as Object).rawContent = _video;
         }
      }
      
      override protected function _load() : void
      {
         var concatChar:String = null;
         _prepRequest();
         _repeatCount = 0;
         _prevTime = 0;
         _bufferFull = _playStarted = _renderedOnce = false;
         this.metaData = null;
         _pausePending = _videoPaused;
         if(_videoPaused)
         {
            _setForceTime(0);
            _sound.volume = 0;
            _ns.soundTransform = _sound;
         }
         else
         {
            this.volume = _volume;
         }
         _sprite.addEventListener(Event.ENTER_FRAME,_playProgressHandler);
         _sprite.addEventListener(Event.ENTER_FRAME,_loadingProgressCheck);
         _waitForRender();
         _videoComplete = _initted = false;
         if(Boolean(this.vars.noCache) && (Boolean(!_isLocal || _url.substr(0,4) == "http")) && _request.data != null)
         {
            concatChar = _request.url.indexOf("?") != -1 ? "&" : "?";
            _ns.play(_request.url + concatChar + _request.data.toString());
         }
         else
         {
            _ns.play(_request.url);
         }
      }
      
      protected function _cuePointHandler(info:Object) : void
      {
         if(!_videoPaused)
         {
            dispatchEvent(new LoaderEvent(VIDEO_CUE_POINT,this,"",info));
         }
      }
      
      public function get volume() : Number
      {
         return _volume;
      }
      
      public function gotoVideoTime(time:Number, forcePlay:Boolean = false, skipCuePoints:Boolean = true) : Number
      {
         if(isNaN(time))
         {
            return NaN;
         }
         if(time > _duration)
         {
            time = _duration;
         }
         var changed:Boolean = time != this.videoTime;
         if(_initted && _renderedOnce && changed)
         {
            _seek(time);
         }
         else
         {
            _setForceTime(time);
         }
         _videoComplete = false;
         if(changed && !skipCuePoints)
         {
            _playProgressHandler(null);
         }
         if(forcePlay)
         {
            playVideo();
         }
         return time;
      }
      
      override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         if(type == PLAY_PROGRESS)
         {
            _dispatchPlayProgress = true;
         }
         super.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      protected function _auditHandler(event:Event = null) : void
      {
         var request:URLRequest = null;
         var type:String = event == null ? "" : event.type;
         var code:String = event == null || !(event is NetStatusEvent) ? "" : NetStatusEvent(event).info.code;
         if(event != null && "duration" in event)
         {
            _duration = Object(event).duration;
         }
         if(_auditNS != null)
         {
            _cachedBytesTotal = _auditNS.bytesTotal;
            if(_bufferMode && _duration != 0)
            {
               _cachedBytesTotal *= _auditNS.bufferTime / _duration;
            }
         }
         if(type == "ioError" || type == "asyncError" || code == "NetStream.Play.StreamNotFound" || code == "NetConnection.Connect.Failed" || code == "NetStream.Play.Failed" || code == "NetStream.Play.FileStructureInvalid" || code == "The MP4 doesn\'t contain any supported tracks")
         {
            if(this.vars.alternateURL != undefined && this.vars.alternateURL != "" && this.vars.alternateURL != _url)
            {
               _url = this.vars.alternateURL;
               _setRequestURL(_request,_url);
               request = new URLRequest();
               request.data = _request.data;
               _setRequestURL(request,_url,!_isLocal || _url.substr(0,4) == "http" ? "gsCacheBusterID=" + _cacheID++ + "&purpose=audit" : "");
               _auditNS.play(request.url);
               _errorHandler(new LoaderEvent(LoaderEvent.ERROR,this,code));
               return;
            }
            super._failHandler(new LoaderEvent(LoaderEvent.ERROR,this,code));
         }
         _auditedSize = true;
         _closeStream();
         dispatchEvent(new Event("auditedSize"));
      }
      
      public function addASCuePoint(time:Number, name:String = "", parameters:Object = null) : Object
      {
         var prev:CuePoint = _firstCuePoint;
         if(prev != null && prev.time > time)
         {
            prev = null;
         }
         else
         {
            while(Boolean(prev && prev.time <= time) && Boolean(prev.next) && prev.next.time <= time)
            {
               prev = prev.next;
            }
         }
         var cp:CuePoint = new CuePoint(time,name,parameters,prev);
         if(prev == null)
         {
            if(_firstCuePoint != null)
            {
               _firstCuePoint.prev = cp;
               cp.next = _firstCuePoint;
            }
            _firstCuePoint = cp;
         }
         return cp;
      }
      
      protected function _playProgressHandler(event:Event) : void
      {
         var prevTime:Number = NaN;
         var next:CuePoint = null;
         var cp:CuePoint = null;
         if(!_bufferFull && !_videoComplete && _ns.bufferLength >= _ns.bufferTime)
         {
            _onBufferFull();
         }
         if(_bufferFull && (Boolean(_firstCuePoint) || Boolean(_dispatchPlayProgress)))
         {
            prevTime = _prevTime;
            _prevTime = (Boolean(_forceTime) || Boolean(_forceTime == 0)) && _ns.time <= _duration ? _ns.time : this.videoTime;
            cp = _firstCuePoint;
            while(Boolean(cp))
            {
               next = cp.next;
               if(cp.time > prevTime && cp.time <= _prevTime && !cp.gc)
               {
                  dispatchEvent(new LoaderEvent(VIDEO_CUE_POINT,this,"",cp));
               }
               cp = next;
            }
            if(_dispatchPlayProgress && prevTime != _prevTime)
            {
               dispatchEvent(new LoaderEvent(PLAY_PROGRESS,this));
            }
         }
      }
      
      protected function _waitForRender() : void
      {
         _ns.addEventListener(Event.RENDER,_renderHandler,false,0,true);
         _renderTimer.reset();
         _renderTimer.start();
      }
      
      override protected function _dump(scrubLevel:int = 0, newStatus:int = 0, suppressEvents:Boolean = false) : void
      {
         _sprite.removeEventListener(Event.ENTER_FRAME,_loadingProgressCheck);
         _sprite.removeEventListener(Event.ENTER_FRAME,_playProgressHandler);
         _sprite.removeEventListener(Event.ENTER_FRAME,_detachNS);
         _ns.removeEventListener(Event.RENDER,_renderHandler);
         _renderTimer.stop();
         _forceTime = NaN;
         _prevTime = 0;
         _initted = false;
         _renderedOnce = false;
         _videoComplete = false;
         this.metaData = null;
         if(scrubLevel != 2)
         {
            _refreshNetStream();
            (_sprite as Object).rawContent = null;
            if(_video.parent != null)
            {
               _video.parent.removeChild(_video);
            }
         }
         if(scrubLevel >= 2)
         {
            if(scrubLevel == 3)
            {
               (_sprite as Object).dispose(false,false);
            }
            _renderTimer.removeEventListener(TimerEvent.TIMER,_renderHandler);
            _nc.removeEventListener("asyncError",_failHandler);
            _nc.removeEventListener("securityError",_failHandler);
            _ns.removeEventListener(NetStatusEvent.NET_STATUS,_statusHandler);
            _ns.removeEventListener("ioError",_failHandler);
            _ns.removeEventListener("asyncError",_failHandler);
            _video.removeEventListener(Event.ADDED_TO_STAGE,_videoAddedToStage);
            _video.removeEventListener(Event.REMOVED_FROM_STAGE,_videoRemovedFromStage);
            _firstCuePoint = null;
            (_sprite as Object).gcProtect = scrubLevel == 3 ? null : _ns;
            _ns.client = {};
            _video = null;
            _ns = null;
            _nc = null;
            _sound = null;
            (_sprite as Object).loader = null;
            _sprite = null;
            _renderTimer = null;
         }
         else
         {
            _duration = isNaN(this.vars.estimatedDuration) ? 200 : Number(this.vars.estimatedDuration);
            _videoPaused = _pausePending = Boolean(this.vars.autoPlay == false);
         }
         super._dump(scrubLevel,newStatus,suppressEvents);
      }
      
      protected function _seek(time:Number) : void
      {
         _ns.seek(time);
         _setForceTime(time);
         if(_bufferFull)
         {
            _bufferFull = false;
            dispatchEvent(new LoaderEvent(VIDEO_BUFFER_EMPTY,this));
         }
      }
      
      public function set bufferMode(value:Boolean) : void
      {
         _bufferMode = value;
         _preferEstimatedBytesInAudit = _bufferMode;
         _calculateProgress();
         if(_cachedBytesLoaded < _cachedBytesTotal && _status == LoaderStatus.COMPLETED)
         {
            _status = LoaderStatus.LOADING;
            _sprite.addEventListener(Event.ENTER_FRAME,_loadingProgressCheck);
         }
      }
      
      override protected function _auditStreamHandler(event:Event) : void
      {
         if(event is ProgressEvent && _bufferMode)
         {
            (event as ProgressEvent).bytesTotal *= _ns.bufferTime / _duration;
         }
         super._auditStreamHandler(event);
      }
      
      protected function _loadingProgressCheck(event:Event) : void
      {
         var bl:uint = _cachedBytesLoaded;
         var bt:uint = _cachedBytesTotal;
         if(!_bufferFull && _ns.bufferLength >= _ns.bufferTime)
         {
            _onBufferFull();
         }
         _calculateProgress();
         if(_cachedBytesLoaded == _cachedBytesTotal)
         {
            _sprite.removeEventListener(Event.ENTER_FRAME,_loadingProgressCheck);
            if(!_bufferFull)
            {
               _onBufferFull();
            }
            if(!_initted)
            {
               _forceInit();
               _errorHandler(new LoaderEvent(LoaderEvent.ERROR,this,"No metaData was received."));
            }
            _completeHandler(event);
         }
         else if(_dispatchProgress && _cachedBytesLoaded / _cachedBytesTotal != bl / bt)
         {
            dispatchEvent(new LoaderEvent(LoaderEvent.PROGRESS,this));
         }
      }
      
      public function set videoTime(value:Number) : void
      {
         gotoVideoTime(value,!_videoPaused,true);
      }
      
      override protected function _closeStream() : void
      {
         if(_auditNS != null)
         {
            _auditNS.client = {};
            _auditNS.removeEventListener(NetStatusEvent.NET_STATUS,_auditHandler);
            _auditNS.removeEventListener("ioError",_auditHandler);
            _auditNS.removeEventListener("asyncError",_auditHandler);
            _auditNS.pause();
            try
            {
               _auditNS.close();
            }
            catch(error:Error)
            {
            }
            _auditNS = null;
         }
         else
         {
            super._closeStream();
         }
      }
      
      public function get videoTime() : Number
      {
         if(Boolean(_forceTime) || _forceTime == 0)
         {
            return _forceTime;
         }
         if(_videoComplete)
         {
            return _duration;
         }
         if(_ns.time > _duration)
         {
            return _duration * 0.995;
         }
         return _ns.time;
      }
      
      protected function _renderHandler(event:Event) : void
      {
         _renderedOnce = true;
         if(!_videoPaused || _initted)
         {
            _forceTime = NaN;
            _renderTimer.stop();
            _ns.removeEventListener(Event.RENDER,_renderHandler);
         }
         if(_pausePending)
         {
            if(_bufferFull)
            {
               _applyPendingPause();
            }
            else if(_video.stage != null)
            {
               _sprite.addEventListener(Event.ENTER_FRAME,_detachNS,false,100,true);
            }
         }
         else if(_videoPaused && _initted)
         {
            _ns.pause();
         }
      }
      
      public function set autoDetachNetStream(value:Boolean) : void
      {
         _autoDetachNetStream = value;
         if(_autoDetachNetStream && _video.stage == null)
         {
            _video.attachNetStream(null);
            _video.clear();
         }
         else
         {
            _video.attachNetStream(_ns);
         }
      }
      
      private function _detachNS(event:Event) : void
      {
         _sprite.removeEventListener(Event.ENTER_FRAME,_detachNS);
         if(!_bufferFull && _pausePending)
         {
            _video.attachNetStream(null);
         }
      }
      
      protected function _statusHandler(event:NetStatusEvent) : void
      {
         var videoRemaining:Number = NaN;
         var loadRemaining:Number = NaN;
         var revisedBufferTime:Number = NaN;
         var code:String = event.info.code;
         if(code == "NetStream.Play.Start" && !_playStarted)
         {
            _playStarted = true;
            if(!_pausePending)
            {
               dispatchEvent(new LoaderEvent(VIDEO_PLAY,this));
            }
         }
         dispatchEvent(new LoaderEvent(NetStatusEvent.NET_STATUS,this,code,event.info));
         if(code == "NetStream.Play.Stop")
         {
            if(_videoPaused)
            {
               return;
            }
            if(this.vars.repeat == -1 || uint(this.vars.repeat) > _repeatCount)
            {
               ++_repeatCount;
               dispatchEvent(new LoaderEvent(VIDEO_COMPLETE,this));
               gotoVideoTime(0,true,true);
            }
            else
            {
               _videoComplete = true;
               this.videoPaused = true;
               _playProgressHandler(null);
               dispatchEvent(new LoaderEvent(VIDEO_COMPLETE,this));
            }
         }
         else if(code == "NetStream.Buffer.Full")
         {
            _onBufferFull();
         }
         else if(code == "NetStream.Seek.Notify")
         {
            if(!_autoDetachNetStream && !isNaN(_forceTime))
            {
               _renderHandler(null);
            }
         }
         else if(code == "NetStream.Seek.InvalidTime" && "details" in event.info)
         {
            _seek(event.info.details);
         }
         else if(code == "NetStream.Buffer.Empty" && !_videoComplete)
         {
            videoRemaining = this.duration - this.videoTime;
            loadRemaining = 1 / this.progress * this.loadTime;
            revisedBufferTime = videoRemaining * (1 - videoRemaining / loadRemaining) * 0.9;
            if(revisedBufferTime < _ns.bufferTime)
            {
               return;
            }
            if(this.autoAdjustBuffer && loadRemaining > videoRemaining)
            {
               _ns.bufferTime = revisedBufferTime;
            }
            _bufferFull = false;
            dispatchEvent(new LoaderEvent(VIDEO_BUFFER_EMPTY,this));
         }
         else if(code == "NetStream.Play.StreamNotFound" || code == "NetConnection.Connect.Failed" || code == "NetStream.Play.Failed" || code == "NetStream.Play.FileStructureInvalid" || code == "The MP4 doesn\'t contain any supported tracks")
         {
            _failHandler(new LoaderEvent(LoaderEvent.ERROR,this,code));
         }
      }
      
      public function get autoDetachNetStream() : Boolean
      {
         return _autoDetachNetStream;
      }
   }
}

class CuePoint
{
   
   public var time:Number;
   
   public var parameters:Object;
   
   public var name:String;
   
   public var next:CuePoint;
   
   public var prev:CuePoint;
   
   public var gc:Boolean;
   
   public function CuePoint(time:Number, name:String, params:Object, prev:CuePoint)
   {
      super();
      this.time = time;
      this.name = name;
      this.parameters = params;
      if(Boolean(prev))
      {
         this.prev = prev;
         if(Boolean(prev.next))
         {
            prev.next.prev = this;
            this.next = prev.next;
         }
         prev.next = this;
      }
   }
}
