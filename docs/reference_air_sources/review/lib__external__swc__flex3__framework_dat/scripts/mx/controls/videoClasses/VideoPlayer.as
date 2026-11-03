package mx.controls.videoClasses
{
   import flash.events.Event;
   import flash.events.NetStatusEvent;
   import flash.events.ProgressEvent;
   import flash.events.TimerEvent;
   import flash.media.SoundTransform;
   import flash.media.Video;
   import flash.utils.Timer;
   import mx.core.mx_internal;
   import mx.events.MetadataEvent;
   import mx.events.VideoEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   use namespace mx_internal;
   
   [ResourceBundle("controls")]
   [ExcludeClass]
   [Event(name="stateChange",type="mx.events.VideoEvent")]
   [Event(name="rewind",type="mx.events.VideoEvent")]
   [Event(name="ready",type="mx.events.VideoEvent")]
   [Event(name="progress",type="flash.events.ProgressEvent")]
   [Event(name="playheadUpdate",type="mx.events.VideoEvent")]
   [Event(name="metadataReceived",type="mx.events.MetadataEvent")]
   [Event(name="cuePoint",type="mx.events.MetadataEvent")]
   [Event(name="complete",type="mx.events.VideoEvent")]
   [Event(name="close",type="mx.events.VideoEvent")]
   public class VideoPlayer extends Video
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public static const DISCONNECTED:String = "disconnected";
      
      public static const STOPPED:String = "stopped";
      
      public static const PLAYING:String = "playing";
      
      public static const PAUSED:String = "paused";
      
      public static const BUFFERING:String = "buffering";
      
      public static const LOADING:String = "loading";
      
      public static const CONNECTION_ERROR:String = "connectionError";
      
      public static const REWINDING:String = "rewinding";
      
      public static const SEEKING:String = "seeking";
      
      public static const RESIZING:String = "resizing";
      
      public static const EXEC_QUEUED_CMD:String = "execQueuedCmd";
      
      private static const BUFFER_EMPTY:String = "bufferEmpty";
      
      private static const BUFFER_FULL:String = "bufferFull";
      
      private static const BUFFER_FLUSH:String = "bufferFlush";
      
      public static const DEFAULT_UPDATE_TIME_INTERVAL:Number = 250;
      
      public static const DEFAULT_UPDATE_PROGRESS_INTERVAL:Number = 250;
      
      public static const DEFAULT_IDLE_TIMEOUT_INTERVAL:Number = 300000;
      
      public static const AUTO_RESIZE_INTERVAL:Number = 100;
      
      public static const AUTO_RESIZE_PLAYHEAD_TIMEOUT:Number = 0.5;
      
      public static const AUTO_RESIZE_METADATA_DELAY_MAX:Number = 5;
      
      public static const FINISH_AUTO_RESIZE_INTERVAL:Number = 250;
      
      public static const RTMP_DO_STOP_AT_END_INTERVAL:Number = 500;
      
      public static const RTMP_DO_SEEK_INTERVAL:Number = 100;
      
      public static const HTTP_DO_SEEK_INTERVAL:Number = 250;
      
      public static const HTTP_DO_SEEK_MAX_COUNT:Number = 4;
      
      public static const CLOSE_NS_INTERVAL:Number = 0.25;
      
      public static const HTTP_DELAYED_BUFFERING_INTERVAL:Number = 100;
      
      public static var DEFAULT_INCMANAGER:Class = NCManager;
      
      public var autoBandWidthDetection:Boolean = false;
      
      private var rtmpDoStopAtEndTimer:Timer;
      
      private var currentPos:Number;
      
      private var bufferState:String;
      
      private var _volume:Number;
      
      public var ncMgrClassName:Class;
      
      private var _visible:Boolean;
      
      private var cachedPlayheadTime:Number;
      
      private var _ncMgr:INCManager;
      
      private var _soundTransform:SoundTransform;
      
      private var prevVideoHeight:Number = -1;
      
      private var _isLive:Boolean;
      
      private var idleTimeoutTimer:Timer;
      
      private var sawPlayStop:Boolean;
      
      private var lastUpdateTime:Number;
      
      private var invalidSeekTime:Boolean;
      
      private var autoPlay:Boolean;
      
      private var _priorBytesLoaded:int = -1;
      
      private var httpDoSeekCount:Number;
      
      private var streamLength:Number;
      
      private var _metadata:Object;
      
      private var cachedState:String;
      
      private var _state:String;
      
      private var startingPlay:Boolean;
      
      private var readyDispatched:Boolean;
      
      private var internalVideoHeight:Number = -1;
      
      private var atEnd:Boolean;
      
      private var sawSeekNotify:Boolean;
      
      private var prevVideoWidth:Number = -1;
      
      private var updateTimeTimer:Timer;
      
      private var finishAutoResizeTimer:Timer;
      
      private var _url:String;
      
      private var httpDoSeekTimer:Timer;
      
      private var rtmpDoSeekTimer:Timer;
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var internalVideoWidth:Number = -1;
      
      private var autoResizeTimer:Timer;
      
      private var invalidSeekRecovery:Boolean;
      
      private var ns:VideoPlayerNetStream;
      
      private var delayedBufferingTimer:Timer;
      
      private var updateProgressTimer:Timer;
      
      private var _bufferTime:Number;
      
      private var _autoRewind:Boolean;
      
      private var cmdQueue:Array;
      
      public function VideoPlayer(width:uint, height:uint, ncMgrClassName:Class = null)
      {
         super(width,height);
         _state = DISCONNECTED;
         cachedState = _state;
         bufferState = BUFFER_EMPTY;
         sawPlayStop = false;
         cachedPlayheadTime = 0;
         _metadata = null;
         startingPlay = false;
         invalidSeekTime = false;
         invalidSeekRecovery = false;
         currentPos = 0;
         atEnd = false;
         cmdQueue = [];
         readyDispatched = false;
         lastUpdateTime = -1;
         sawSeekNotify = false;
         ncMgrClassName = ncMgrClassName == null ? DEFAULT_INCMANAGER : ncMgrClassName;
         updateTimeTimer = new Timer(DEFAULT_UPDATE_TIME_INTERVAL);
         updateTimeTimer.addEventListener(TimerEvent.TIMER,doUpdateTime);
         updateProgressTimer = new Timer(DEFAULT_UPDATE_PROGRESS_INTERVAL);
         updateProgressTimer.addEventListener(TimerEvent.TIMER,doUpdateProgress);
         idleTimeoutTimer = new Timer(DEFAULT_IDLE_TIMEOUT_INTERVAL,1);
         idleTimeoutTimer.addEventListener(TimerEvent.TIMER,doIdleTimeout);
         autoResizeTimer = new Timer(AUTO_RESIZE_INTERVAL);
         autoResizeTimer.addEventListener(TimerEvent.TIMER,doAutoResize);
         rtmpDoStopAtEndTimer = new Timer(RTMP_DO_STOP_AT_END_INTERVAL);
         rtmpDoStopAtEndTimer.addEventListener(TimerEvent.TIMER,rtmpDoStopAtEnd);
         rtmpDoSeekTimer = new Timer(RTMP_DO_SEEK_INTERVAL);
         rtmpDoSeekTimer.addEventListener(TimerEvent.TIMER,doSeek);
         httpDoSeekTimer = new Timer(HTTP_DO_SEEK_INTERVAL);
         httpDoSeekTimer.addEventListener(TimerEvent.TIMER,doSeek);
         finishAutoResizeTimer = new Timer(FINISH_AUTO_RESIZE_INTERVAL,1);
         finishAutoResizeTimer.addEventListener(TimerEvent.TIMER,finishAutoResize);
         delayedBufferingTimer = new Timer(HTTP_DELAYED_BUFFERING_INTERVAL);
         delayedBufferingTimer.addEventListener(TimerEvent.TIMER,doDelayedBuffering);
         httpDoSeekCount = 0;
         _isLive = false;
         autoPlay = true;
         _autoRewind = true;
         _bufferTime = 0.1;
         _volume = 100;
         _soundTransform = new SoundTransform(_volume);
         _visible = true;
         _url = "";
      }
      
      public function get playheadTime() : Number
      {
         var nowTime:Number = ns == null ? currentPos : Number(ns.time);
         if(Boolean(_metadata) && Boolean(_metadata.audiodelay))
         {
            nowTime -= _metadata.audiodelay;
            if(nowTime < 0)
            {
               nowTime = 0;
            }
         }
         return nowTime;
      }
      
      public function set playheadTime(position:Number) : void
      {
         seek(position);
      }
      
      public function stop() : void
      {
         if(!isXnOK())
         {
            if(_state == CONNECTION_ERROR || _ncMgr == null || _ncMgr.netConnection == null)
            {
               throw new VideoError(VideoError.NO_CONNECTION);
            }
            return;
         }
         if(_state == EXEC_QUEUED_CMD)
         {
            _state = cachedState;
         }
         else
         {
            if(!stateResponsive)
            {
               queueCmd(VideoPlayerQueuedCommand.STOP);
               return;
            }
            execQueuedCmds();
         }
         if(_state == STOPPED || ns == null)
         {
            return;
         }
         if(_ncMgr.isRTMP())
         {
            if(_autoRewind && !_isLive)
            {
               currentPos = 0;
               _play(0,0);
               _state = STOPPED;
               setState(REWINDING);
            }
            else
            {
               closeNS();
               setState(STOPPED);
            }
         }
         else
         {
            _pause(true);
            if(_autoRewind)
            {
               _seek(0);
               _state = STOPPED;
               setState(REWINDING);
            }
            else
            {
               setState(STOPPED);
            }
         }
      }
      
      override public function get videoWidth() : int
      {
         if(internalVideoWidth > 0)
         {
            return internalVideoWidth;
         }
         if(metadata != null && !isNaN(metadata.width) && !isNaN(metadata.height))
         {
            if(metadata.width == metadata.height && readyDispatched)
            {
               return super.videoWidth;
            }
            return int(metadata.width);
         }
         if(readyDispatched)
         {
            return super.videoWidth;
         }
         return -1;
      }
      
      public function get progressInterval() : uint
      {
         return updateProgressTimer.delay;
      }
      
      private function _play(... rest) : void
      {
         var message:String = null;
         rtmpDoStopAtEndTimer.reset();
         startingPlay = true;
         switch(rest.length)
         {
            case 0:
               ns.play(_ncMgr.streamName);
               break;
            case 1:
               ns.play(_ncMgr.streamName,rest[0]);
               break;
            case 2:
               ns.play(_ncMgr.streamName,rest[0],rest[1]);
               break;
            default:
               message = resourceManager.getString("controls","badArgs");
               throw new ArgumentError(message);
         }
      }
      
      public function setScale(xs:Number, ys:Number) : void
      {
         if(xs == super.scaleX && ys == super.scaleY)
         {
            return;
         }
         super.scaleX = xs;
         super.scaleY = ys;
      }
      
      public function get volume() : Number
      {
         return _volume;
      }
      
      public function get soundTransform() : SoundTransform
      {
         return _soundTransform;
      }
      
      public function doUpdateTime(event:Event) : void
      {
         var videoEvent:VideoEvent = null;
         var theTime:Number = playheadTime;
         switch(_state)
         {
            case STOPPED:
            case PAUSED:
            case DISCONNECTED:
            case CONNECTION_ERROR:
               if(event != null)
               {
                  updateTimeTimer.reset();
               }
         }
         if(lastUpdateTime != theTime)
         {
            videoEvent = new VideoEvent(VideoEvent.PLAYHEAD_UPDATE);
            videoEvent.state = _state;
            videoEvent.playheadTime = theTime;
            dispatchEvent(videoEvent);
            lastUpdateTime = theTime;
         }
      }
      
      public function get ncMgr() : INCManager
      {
         if(_ncMgr == null)
         {
            createINCManager();
         }
         return _ncMgr;
      }
      
      public function set progressInterval(aTime:uint) : void
      {
         updateProgressTimer.delay = aTime;
      }
      
      public function get stateResponsive() : Boolean
      {
         switch(_state)
         {
            case DISCONNECTED:
            case STOPPED:
            case PLAYING:
            case PAUSED:
            case BUFFERING:
               return true;
            default:
               return false;
         }
      }
      
      public function get bufferTime() : Number
      {
         return _bufferTime;
      }
      
      private function doAutoResize(event:Event) : void
      {
         if(event != null)
         {
            switch(_state)
            {
               case RESIZING:
               case LOADING:
                  break;
               case DISCONNECTED:
               case CONNECTION_ERROR:
                  autoResizeTimer.reset();
                  return;
               default:
                  if(!stateResponsive)
                  {
                     return;
                  }
            }
            if(!(videoWidth != prevVideoWidth || videoHeight != prevVideoHeight || bufferState == BUFFER_FULL || bufferState == BUFFER_FLUSH || (Boolean(ns) ? Boolean(ns.time > AUTO_RESIZE_PLAYHEAD_TIMEOUT) : Boolean(false))))
            {
               return;
            }
            internalVideoWidth = videoWidth;
            internalVideoHeight = videoHeight;
            autoResizeTimer.reset();
         }
         setState(cachedState);
      }
      
      public function get metadata() : Object
      {
         return _metadata;
      }
      
      public function set volume(aVol:Number) : void
      {
         if(aVol >= 0 && aVol <= 1)
         {
            _volume = aVol;
         }
         else if(aVol < 0)
         {
            _volume = 0;
         }
         else
         {
            _volume = 1;
         }
         _soundTransform.volume = _volume;
         if(ns != null)
         {
            ns.soundTransform = _soundTransform;
         }
      }
      
      public function get isLive() : Boolean
      {
         return _isLive;
      }
      
      public function set soundTransform(s:SoundTransform) : void
      {
         _soundTransform = s;
         _volume = _soundTransform.volume;
         ns.soundTransform = _soundTransform;
      }
      
      public function play(url:String = null, isLive:Boolean = false, totalTime:Number = -1) : void
      {
         if(url != null)
         {
            if(_state == EXEC_QUEUED_CMD)
            {
               _state = cachedState;
            }
            else
            {
               if(!stateResponsive)
               {
                  queueCmd(VideoPlayerQueuedCommand.PLAY,url,isLive,totalTime);
                  return;
               }
               execQueuedCmds();
            }
            autoPlay = true;
            _load(url,isLive,totalTime);
            return;
         }
         if(!isXnOK())
         {
            if(_state == CONNECTION_ERROR || _ncMgr == null || _ncMgr.netConnection == null)
            {
               throw new VideoError(VideoError.NO_CONNECTION);
            }
            flushQueuedCmds();
            queueCmd(VideoPlayerQueuedCommand.PLAY);
            setState(LOADING);
            cachedState = LOADING;
            _ncMgr.reconnect();
            return;
         }
         if(_state == EXEC_QUEUED_CMD)
         {
            _state = cachedState;
         }
         else
         {
            if(!stateResponsive)
            {
               queueCmd(VideoPlayerQueuedCommand.PLAY,null,isLive);
               return;
            }
            execQueuedCmds();
         }
         if(ns == null)
         {
            createStream();
            attachNetStream(ns);
         }
         switch(_state)
         {
            case BUFFERING:
               if(_ncMgr.isRTMP())
               {
                  _play(0);
                  if(atEnd)
                  {
                     atEnd = false;
                     currentPos = 0;
                     setState(REWINDING);
                  }
                  else if(currentPos > 0)
                  {
                     _seek(currentPos);
                     currentPos = 0;
                  }
               }
            case PLAYING:
               return;
            case STOPPED:
               if(_ncMgr.isRTMP())
               {
                  if(isLive)
                  {
                     _play(-1);
                     setState(BUFFERING);
                  }
                  else
                  {
                     _play(0);
                     if(atEnd)
                     {
                        atEnd = false;
                        currentPos = 0;
                        _state = BUFFERING;
                        setState(REWINDING);
                     }
                     else if(currentPos > 0)
                     {
                        _seek(currentPos);
                        currentPos = 0;
                        setState(BUFFERING);
                     }
                     else
                     {
                        setState(BUFFERING);
                     }
                  }
               }
               else
               {
                  _pause(false);
                  if(atEnd)
                  {
                     atEnd = false;
                     _seek(0);
                     _state = BUFFERING;
                     setState(REWINDING);
                  }
                  else if(bufferState == BUFFER_EMPTY)
                  {
                     setState(BUFFERING);
                  }
                  else
                  {
                     setState(PLAYING);
                  }
               }
               break;
            case PAUSED:
               _pause(false);
               if(!_ncMgr.isRTMP())
               {
                  if(bufferState == BUFFER_EMPTY)
                  {
                     setState(BUFFERING);
                  }
                  else
                  {
                     setState(PLAYING);
                  }
               }
               else
               {
                  setState(BUFFERING);
               }
         }
      }
      
      public function onCuePoint(info:Object) : void
      {
         var metadataEvent:MetadataEvent = new MetadataEvent(MetadataEvent.CUE_POINT);
         metadataEvent.info = info;
         dispatchEvent(metadataEvent);
      }
      
      public function ncReconnected() : void
      {
         if(_ncMgr == null || _ncMgr.netConnection == null)
         {
            setState(CONNECTION_ERROR);
         }
         else
         {
            ns = null;
            _state = STOPPED;
            execQueuedCmds();
         }
      }
      
      private function recoverInvalidSeek() : void
      {
         setStateFromCachedState();
         invalidSeekTime = false;
         invalidSeekRecovery = true;
         seek(playheadTime);
      }
      
      public function rtmpOnStatus(event:NetStatusEvent) : void
      {
         if(_state == CONNECTION_ERROR)
         {
            return;
         }
         switch(event.info.code)
         {
            case "NetStream.Play.Stop":
               if(startingPlay)
               {
                  return;
               }
               switch(_state)
               {
                  case RESIZING:
                  case LOADING:
                  case STOPPED:
                  case PAUSED:
                     break;
                  default:
                     sawPlayStop = true;
               }
               break;
            case "NetStream.Buffer.Empty":
               switch(bufferState)
               {
                  case BUFFER_FULL:
                     if(sawPlayStop)
                     {
                        rtmpDoStopAtEnd(null);
                     }
                     else if(_state == PLAYING)
                     {
                        setState(BUFFERING);
                     }
               }
               bufferState = BUFFER_EMPTY;
               sawPlayStop = false;
               break;
            case "NetStream.Buffer.Flush":
               if(sawSeekNotify && _state == SEEKING)
               {
                  bufferState = BUFFER_EMPTY;
                  sawPlayStop = false;
                  setStateFromCachedState();
                  doUpdateTime(null);
               }
               if(sawPlayStop && (bufferState == BUFFER_EMPTY || _bufferTime <= 0.1 && ns.bufferLength <= 0.1))
               {
                  cachedPlayheadTime = playheadTime;
                  rtmpDoStopAtEndTimer.start();
               }
               switch(bufferState)
               {
                  case BUFFER_EMPTY:
                     if(_state == LOADING && cachedState == PLAYING || _state == BUFFERING)
                     {
                        setState(PLAYING);
                     }
                     else if(cachedState == BUFFERING)
                     {
                        cachedState = PLAYING;
                     }
                     bufferState = BUFFER_FLUSH;
                     break;
                  default:
                     if(_state == BUFFERING)
                     {
                        setStateFromCachedState();
                     }
               }
               break;
            case "NetStream.Buffer.Full":
               if(sawSeekNotify && _state == SEEKING)
               {
                  bufferState = BUFFER_EMPTY;
                  sawPlayStop = false;
                  setStateFromCachedState();
                  doUpdateTime(null);
               }
               switch(bufferState)
               {
                  case BUFFER_EMPTY:
                     bufferState = BUFFER_FULL;
                     if(_state == LOADING && cachedState == PLAYING || _state == BUFFERING)
                     {
                        setState(PLAYING);
                     }
                     else if(cachedState == BUFFERING)
                     {
                        cachedState = PLAYING;
                     }
                     if(rtmpDoStopAtEndTimer.running)
                     {
                        sawPlayStop = true;
                        rtmpDoStopAtEndTimer.reset();
                     }
                     break;
                  case BUFFER_FLUSH:
                     bufferState = BUFFER_FULL;
                     if(rtmpDoStopAtEndTimer.running)
                     {
                        sawPlayStop = true;
                        rtmpDoStopAtEndTimer.reset();
                     }
               }
               if(_state == BUFFERING)
               {
                  setStateFromCachedState();
               }
               break;
            case "NetStream.Pause.Notify":
               break;
            case "NetStream.Unpause.Notify":
               if(_state == PAUSED)
               {
                  _state = PLAYING;
                  setState(BUFFERING);
               }
               else
               {
                  cachedState = PLAYING;
               }
               break;
            case "NetStream.Play.Start":
               rtmpDoStopAtEndTimer.reset();
               bufferState = BUFFER_EMPTY;
               sawPlayStop = false;
               if(startingPlay)
               {
                  startingPlay = false;
                  cachedPlayheadTime = playheadTime;
               }
               else if(_state == PLAYING)
               {
                  setState(BUFFERING);
               }
               break;
            case "NetStream.Play.Reset":
               rtmpDoStopAtEndTimer.reset();
               if(_state == REWINDING)
               {
                  rtmpDoSeekTimer.reset();
                  if(playheadTime == 0 || playheadTime < cachedPlayheadTime)
                  {
                     setStateFromCachedState();
                  }
                  else
                  {
                     cachedPlayheadTime = playheadTime;
                     rtmpDoSeekTimer.start();
                  }
               }
               break;
            case "NetStream.Seek.Notify":
               if(playheadTime != cachedPlayheadTime)
               {
                  setStateFromCachedState();
                  doUpdateTime(null);
               }
               else
               {
                  sawSeekNotify = true;
                  if(!rtmpDoSeekTimer.running)
                  {
                     rtmpDoSeekTimer.start();
                  }
               }
               break;
            case "Netstream.Play.UnpublishNotify":
            case "Netstream.Play.PublishNotify":
               break;
            case "NetStream.Play.StreamNotFound":
               if(!_ncMgr.connectAgain())
               {
                  setState(CONNECTION_ERROR);
               }
               break;
            case "NetStream.Play.Failed":
            case "NetStream.Failed":
               setState(CONNECTION_ERROR);
         }
      }
      
      public function get totalTime() : Number
      {
         return streamLength;
      }
      
      public function get autoRewind() : Boolean
      {
         return _autoRewind;
      }
      
      override public function set height(value:Number) : void
      {
         setSize(width,value);
      }
      
      private function createINCManager() : void
      {
         var ncMgrClass:Class = ncMgrClassName == null ? DEFAULT_INCMANAGER : ncMgrClassName;
         _ncMgr = new ncMgrClass();
         _ncMgr.videoPlayer = this;
      }
      
      private function setState(s:String) : void
      {
         if(s == _state)
         {
            return;
         }
         cachedState = _state;
         cachedPlayheadTime = playheadTime;
         _state = s;
         var newState:String = _state;
         var videoEvent:VideoEvent = new VideoEvent(VideoEvent.STATE_CHANGE);
         videoEvent.state = newState;
         videoEvent.playheadTime = playheadTime;
         dispatchEvent(videoEvent);
         if(!readyDispatched)
         {
            switch(newState)
            {
               case STOPPED:
               case PLAYING:
               case PAUSED:
               case BUFFERING:
                  readyDispatched = true;
                  videoEvent = new VideoEvent(VideoEvent.READY);
                  videoEvent.state = newState;
                  videoEvent.playheadTime = playheadTime;
                  dispatchEvent(videoEvent);
            }
         }
         switch(cachedState)
         {
            case REWINDING:
               videoEvent = new VideoEvent(VideoEvent.REWIND);
               videoEvent.state = newState;
               videoEvent.playheadTime = playheadTime;
               dispatchEvent(videoEvent);
               if(_ncMgr.isRTMP() && newState == STOPPED)
               {
                  closeNS();
               }
         }
         switch(newState)
         {
            case STOPPED:
            case PAUSED:
               if(_ncMgr.isRTMP() && !idleTimeoutTimer.running)
               {
                  idleTimeoutTimer.start();
               }
               break;
            case SEEKING:
            case REWINDING:
               bufferState = BUFFER_EMPTY;
               sawPlayStop = false;
            case PLAYING:
            case BUFFERING:
               if(!updateTimeTimer.running)
               {
                  updateTimeTimer.start();
               }
            case LOADING:
            case RESIZING:
               idleTimeoutTimer.reset();
         }
         execQueuedCmds();
      }
      
      public function httpOnStatus(event:NetStatusEvent) : void
      {
         switch(event.info.code)
         {
            case "NetStream.Play.Stop":
               delayedBufferingTimer.reset();
               if(invalidSeekTime)
               {
                  recoverInvalidSeek();
               }
               else
               {
                  switch(_state)
                  {
                     case PLAYING:
                     case BUFFERING:
                     case SEEKING:
                        httpDoStopAtEnd();
                  }
               }
               break;
            case "NetStream.Seek.InvalidTime":
               if(invalidSeekRecovery)
               {
                  invalidSeekTime = false;
                  invalidSeekRecovery = false;
                  setState(cachedState);
                  seek(0);
               }
               else
               {
                  recoverInvalidSeek();
               }
               break;
            case "NetStream.Buffer.Empty":
               bufferState = BUFFER_EMPTY;
               if(_state == PLAYING)
               {
                  delayedBufferingTimer.start();
               }
               break;
            case "NetStream.Buffer.Full":
            case "NetStream.Buffer.Flush":
               delayedBufferingTimer.reset();
               bufferState = BUFFER_FULL;
               if(_state == LOADING && cachedState == PLAYING || _state == BUFFERING)
               {
                  setState(PLAYING);
               }
               else if(cachedState == BUFFERING)
               {
                  cachedState = PLAYING;
               }
               break;
            case "NetStream.Seek.Notify":
               invalidSeekRecovery = false;
               switch(_state)
               {
                  case SEEKING:
                  case REWINDING:
                     if(!httpDoSeekTimer.running)
                     {
                        httpDoSeekCount = 0;
                        httpDoSeekTimer.start();
                     }
               }
               break;
            case "NetStream.Play.StreamNotFound":
               setState(CONNECTION_ERROR);
         }
      }
      
      public function set bufferTime(aTime:Number) : void
      {
         _bufferTime = aTime;
         if(ns != null)
         {
            ns.bufferTime = _bufferTime;
         }
      }
      
      public function onMetaData(info:Object) : void
      {
         if(_metadata != null)
         {
            return;
         }
         _metadata = info;
         if(isNaN(streamLength) || streamLength <= 0)
         {
            streamLength = info.duration;
         }
         if(isNaN(internalVideoWidth) || internalVideoWidth <= 0)
         {
            internalVideoWidth = info.width;
         }
         if(isNaN(internalVideoHeight) || internalVideoHeight <= 0)
         {
            internalVideoHeight = info.height;
         }
         var metadataEvent:MetadataEvent = new MetadataEvent(MetadataEvent.METADATA_RECEIVED);
         metadataEvent.info = info;
         dispatchEvent(metadataEvent);
      }
      
      private function setStateFromCachedState() : void
      {
         switch(cachedState)
         {
            case PLAYING:
            case PAUSED:
               setState(cachedState);
               break;
            case BUFFERING:
               if(bufferState == BUFFER_EMPTY)
               {
                  setState(BUFFERING);
               }
               else
               {
                  setState(cachedState);
               }
               break;
            default:
               setState(STOPPED);
         }
      }
      
      public function get bytesLoaded() : int
      {
         if(ns == null || _ncMgr.isRTMP())
         {
            return -1;
         }
         return ns.bytesLoaded;
      }
      
      private function doIdleTimeout(event:Event) : void
      {
         idleTimeoutTimer.reset();
         close();
      }
      
      private function doDelayedBuffering(event:Event) : void
      {
         switch(_state)
         {
            case LOADING:
            case RESIZING:
               break;
            case PLAYING:
               delayedBufferingTimer.reset();
               setState(BUFFERING);
               break;
            default:
               delayedBufferingTimer.reset();
         }
      }
      
      public function get url() : String
      {
         return _url;
      }
      
      private function queueCmd(type:uint, url:String = null, isLive:Boolean = false, time:Number = 0) : void
      {
         cmdQueue.push(new VideoPlayerQueuedCommand(type,url,isLive,time));
      }
      
      override public function get visible() : Boolean
      {
         _visible = super.visible;
         return _visible;
      }
      
      private function rtmpDoSeek() : void
      {
         if(_state != REWINDING && _state != SEEKING)
         {
            rtmpDoSeekTimer.reset();
            sawSeekNotify = false;
         }
         else if(playheadTime != cachedPlayheadTime)
         {
            rtmpDoSeekTimer.reset();
            sawSeekNotify = false;
            setStateFromCachedState();
            doUpdateTime(null);
         }
      }
      
      private function setUpStream() : void
      {
         if(!isNaN(_ncMgr.streamLength) && _ncMgr.streamLength >= 0)
         {
            streamLength = _ncMgr.streamLength;
         }
         if(!isNaN(_ncMgr.streamWidth) && _ncMgr.streamWidth >= 0)
         {
            internalVideoWidth = _ncMgr.streamWidth;
         }
         else
         {
            internalVideoWidth = -1;
         }
         if(!isNaN(_ncMgr.streamHeight) && _ncMgr.streamHeight >= 0)
         {
            internalVideoHeight = _ncMgr.streamHeight;
         }
         else
         {
            internalVideoHeight = -1;
         }
         if(autoPlay)
         {
            if(!_ncMgr.isRTMP())
            {
               cachedState = BUFFERING;
               _play();
            }
            else if(_isLive)
            {
               cachedState = BUFFERING;
               _play(-1);
            }
            else
            {
               cachedState = BUFFERING;
               _play(0);
            }
         }
         else
         {
            cachedState = STOPPED;
            if(_ncMgr.isRTMP())
            {
               _play(-2,0);
            }
            else
            {
               _play();
               _pause(true);
               _seek(0);
            }
         }
         autoResizeTimer.reset();
         autoResizeTimer.start();
      }
      
      public function seek(time:Number) : void
      {
         if(invalidSeekTime)
         {
            return;
         }
         if(isNaN(time) || time < 0)
         {
            throw new VideoError(VideoError.INVALID_SEEK);
         }
         if(!isXnOK())
         {
            if(_state == CONNECTION_ERROR || _ncMgr == null || _ncMgr.netConnection == null)
            {
               throw new VideoError(VideoError.NO_CONNECTION);
            }
            flushQueuedCmds();
            queueCmd(VideoPlayerQueuedCommand.SEEK,null,false,time);
            setState(LOADING);
            cachedState = LOADING;
            _ncMgr.reconnect();
            return;
         }
         if(_state == EXEC_QUEUED_CMD)
         {
            _state = cachedState;
         }
         else
         {
            if(!stateResponsive)
            {
               queueCmd(VideoPlayerQueuedCommand.SEEK,null,false,time);
               return;
            }
            execQueuedCmds();
         }
         if(ns == null)
         {
            createStream();
            attachNetStream(ns);
         }
         if(atEnd && time <= playheadTime)
         {
            atEnd = false;
         }
         switch(_state)
         {
            case PLAYING:
               _state = BUFFERING;
            case BUFFERING:
            case PAUSED:
               _seek(time);
               setState(SEEKING);
               break;
            case STOPPED:
               if(_ncMgr.isRTMP())
               {
                  _play(0);
                  _pause(true);
               }
               _seek(time);
               _state = PAUSED;
               setState(SEEKING);
         }
      }
      
      public function doUpdateProgress(event:Event) : void
      {
         if(ns == null)
         {
            return;
         }
         if(ns.bytesTotal >= 0 && ns.bytesLoaded != _priorBytesLoaded)
         {
            dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,ns.bytesLoaded,ns.bytesTotal));
         }
         if(_state == DISCONNECTED || _state == CONNECTION_ERROR || ns.bytesLoaded == ns.bytesTotal)
         {
            updateProgressTimer.reset();
         }
         _priorBytesLoaded = ns.bytesLoaded;
      }
      
      override public function get videoHeight() : int
      {
         if(internalVideoHeight > 0)
         {
            return internalVideoHeight;
         }
         if(metadata != null && !isNaN(metadata.width) && !isNaN(metadata.height))
         {
            if(metadata.width == metadata.height && readyDispatched)
            {
               return super.videoHeight;
            }
            return int(metadata.height);
         }
         if(readyDispatched)
         {
            return super.videoHeight;
         }
         return -1;
      }
      
      override public function set width(value:Number) : void
      {
         setSize(value,height);
      }
      
      private function _seek(time:Number) : void
      {
         rtmpDoStopAtEndTimer.reset();
         var seekTime:Number = Math.round(time * 1000) / 1000;
         if(Boolean(_metadata) && Boolean(_metadata.audiodelay) && time + _metadata.audiodelay < streamLength)
         {
            time += _metadata.audiodelay;
         }
         ns.seek(time);
         invalidSeekTime = false;
         bufferState = BUFFER_EMPTY;
         sawPlayStop = false;
         sawSeekNotify = false;
      }
      
      public function get isRTMP() : Boolean
      {
         if(_ncMgr == null)
         {
            return true;
         }
         return _ncMgr.isRTMP();
      }
      
      public function get state() : String
      {
         return _state;
      }
      
      public function get bytesTotal() : int
      {
         if(ns == null || _ncMgr.isRTMP())
         {
            return -1;
         }
         return ns.bytesTotal;
      }
      
      public function set autoRewind(flag:Boolean) : void
      {
         _autoRewind = flag;
      }
      
      override public function set scaleX(xs:Number) : void
      {
         setScale(xs,this.scaleY);
      }
      
      private function finishAutoResize(event:Event) : void
      {
         finishAutoResizeTimer.reset();
         if(stateResponsive)
         {
            return;
         }
         super.visible = _visible;
         _soundTransform.volume = _volume;
         ns.soundTransform = _soundTransform;
         if(autoPlay)
         {
            if(_ncMgr.isRTMP())
            {
               if(!_isLive)
               {
                  currentPos = 0;
                  _play(0);
               }
               if(_state == RESIZING)
               {
                  setState(LOADING);
                  cachedState = PLAYING;
               }
            }
            else
            {
               _pause(false);
               cachedState = PLAYING;
            }
         }
         else
         {
            setState(STOPPED);
         }
      }
      
      private function isXnOK() : Boolean
      {
         if(_state == LOADING)
         {
            return true;
         }
         if(_state == CONNECTION_ERROR)
         {
            return false;
         }
         if(_state != DISCONNECTED)
         {
            if(_ncMgr == null || _ncMgr.netConnection == null || !_ncMgr.netConnection.connected)
            {
               setState(DISCONNECTED);
               return false;
            }
            return true;
         }
         return false;
      }
      
      private function doSeek(event:Event) : void
      {
         var seekState:Boolean = _state == REWINDING || _state == SEEKING;
         if(seekState && httpDoSeekCount < HTTP_DO_SEEK_MAX_COUNT && (cachedPlayheadTime == playheadTime || invalidSeekTime))
         {
            ++httpDoSeekCount;
            return;
         }
         httpDoSeekCount = 0;
         httpDoSeekTimer.reset();
         if(!seekState)
         {
            return;
         }
         if(invalidSeekTime)
         {
            recoverInvalidSeek();
         }
         else
         {
            setStateFromCachedState();
            doUpdateTime(null);
         }
      }
      
      private function createStream() : void
      {
         ns = new VideoPlayerNetStream(_ncMgr.netConnection,this);
         ns.bufferTime = _bufferTime;
         ns.soundTransform = _soundTransform;
         ns.addEventListener(NetStatusEvent.NET_STATUS,_ncMgr.isRTMP() ? rtmpOnStatus : httpOnStatus);
         attachNetStream(ns);
      }
      
      public function setSize(w:Number, h:Number) : void
      {
         if(w == width && h == height)
         {
            return;
         }
         super.width = w;
         super.height = h;
      }
      
      private function flushQueuedCmds() : void
      {
         while(cmdQueue.length > 0)
         {
            cmdQueue.pop();
         }
      }
      
      override public function set scaleY(ys:Number) : void
      {
         setScale(this.scaleX,ys);
      }
      
      public function ncConnected() : void
      {
         if(_ncMgr == null || _ncMgr.netConnection == null)
         {
            setState(CONNECTION_ERROR);
         }
         else
         {
            createStream();
            setUpStream();
         }
      }
      
      private function closeNS(updateCurrentPos:Boolean = true) : void
      {
         if(ns != null)
         {
            if(updateCurrentPos)
            {
               updateTimeTimer.reset();
               doUpdateTime(null);
               currentPos = ns.time;
            }
            ns.removeEventListener(NetStatusEvent.NET_STATUS,httpOnStatus);
            ns.removeEventListener(NetStatusEvent.NET_STATUS,rtmpOnStatus);
            ns.close();
            ns = null;
         }
      }
      
      private function rtmpDoStopAtEnd(event:TimerEvent) : void
      {
         if(event != null)
         {
            switch(_state)
            {
               case DISCONNECTED:
               case CONNECTION_ERROR:
                  rtmpDoStopAtEndTimer.reset();
                  return;
               default:
                  if(cachedPlayheadTime != playheadTime)
                  {
                     cachedPlayheadTime = playheadTime;
                     return;
                  }
                  rtmpDoStopAtEndTimer.reset();
            }
         }
         bufferState = BUFFER_EMPTY;
         sawPlayStop = false;
         atEnd = true;
         setState(STOPPED);
         if(_state != STOPPED)
         {
            return;
         }
         doUpdateTime(null);
         if(_state != STOPPED)
         {
            return;
         }
         var videoEvent:VideoEvent = new VideoEvent(VideoEvent.COMPLETE);
         videoEvent.state = _state;
         videoEvent.playheadTime = playheadTime;
         dispatchEvent(videoEvent);
         if(_state != STOPPED)
         {
            return;
         }
         if(_autoRewind && !_isLive && playheadTime != 0)
         {
            atEnd = false;
            currentPos = 0;
            _play(0,0);
            setState(REWINDING);
         }
         else
         {
            closeNS();
         }
      }
      
      public function set idleTimeout(aTime:uint) : void
      {
         idleTimeoutTimer.delay = aTime;
      }
      
      public function set playheadUpdateInterval(aTime:uint) : void
      {
         updateTimeTimer.delay = aTime;
      }
      
      private function _load(url:String, isLive:Boolean, totalTime:Number) : void
      {
         if(prevVideoWidth == -1)
         {
            if(videoWidth >= 0)
            {
               prevVideoWidth = videoWidth;
            }
            else
            {
               prevVideoWidth = 0;
            }
         }
         if(prevVideoHeight == -1)
         {
            if(videoHeight >= 0)
            {
               prevVideoHeight = videoHeight;
            }
            else
            {
               prevVideoHeight = 0;
            }
         }
         cachedPlayheadTime = 0;
         bufferState = BUFFER_EMPTY;
         sawPlayStop = false;
         _metadata = null;
         startingPlay = false;
         invalidSeekRecovery = false;
         invalidSeekTime = false;
         _isLive = isLive;
         _url = url;
         currentPos = 0;
         streamLength = totalTime;
         atEnd = false;
         internalVideoWidth = -1;
         internalVideoHeight = -1;
         readyDispatched = false;
         lastUpdateTime = -1;
         sawSeekNotify = false;
         updateTimeTimer.reset();
         updateProgressTimer.reset();
         idleTimeoutTimer.reset();
         autoResizeTimer.reset();
         rtmpDoStopAtEndTimer.reset();
         rtmpDoSeekTimer.reset();
         httpDoSeekTimer.reset();
         finishAutoResizeTimer.reset();
         delayedBufferingTimer.reset();
         closeNS(false);
         if(_ncMgr == null)
         {
            createINCManager();
         }
         var instantConnect:Boolean = _ncMgr.connectToURL(_url);
         setState(LOADING);
         cachedState = LOADING;
         if(instantConnect)
         {
            createStream();
            setUpStream();
         }
         if(!_ncMgr.isRTMP())
         {
            updateProgressTimer.start();
         }
      }
      
      public function get playheadUpdateInterval() : uint
      {
         return updateTimeTimer.delay;
      }
      
      override public function set visible(v:Boolean) : void
      {
         _visible = v;
         super.visible = _visible;
      }
      
      public function load(url:String, isLive:Boolean = false, totalTime:Number = -1) : void
      {
         var message:String = null;
         if(url == null)
         {
            message = resourceManager.getString("controls","nullURL");
            throw new ArgumentError(message);
         }
         if(_state == EXEC_QUEUED_CMD)
         {
            _state = cachedState;
         }
         else
         {
            if(!stateResponsive)
            {
               queueCmd(VideoPlayerQueuedCommand.LOAD,url,isLive,totalTime);
               return;
            }
            execQueuedCmds();
         }
         autoPlay = false;
         _load(url,isLive,totalTime);
      }
      
      private function httpDoStopAtEnd() : void
      {
         atEnd = true;
         if(isNaN(streamLength) || streamLength <= 0)
         {
            streamLength = ns.time;
         }
         _pause(true);
         setState(STOPPED);
         if(_state != STOPPED)
         {
            return;
         }
         doUpdateTime(null);
         if(_state != STOPPED)
         {
            return;
         }
         var videoEvent:VideoEvent = new VideoEvent(VideoEvent.COMPLETE);
         videoEvent.state = _state;
         videoEvent.playheadTime = playheadTime;
         dispatchEvent(videoEvent);
         if(_state != STOPPED)
         {
            return;
         }
         if(_autoRewind)
         {
            atEnd = false;
            _pause(true);
            _seek(0);
            setState(REWINDING);
         }
      }
      
      public function get idleTimeout() : uint
      {
         return idleTimeoutTimer.delay;
      }
      
      public function pause() : void
      {
         if(!isXnOK())
         {
            if(_state == CONNECTION_ERROR || _ncMgr == null || _ncMgr.netConnection == null)
            {
               throw new VideoError(VideoError.NO_CONNECTION);
            }
            return;
         }
         if(_state == EXEC_QUEUED_CMD)
         {
            _state = cachedState;
         }
         else
         {
            if(!stateResponsive)
            {
               queueCmd(VideoPlayerQueuedCommand.PAUSE);
               return;
            }
            execQueuedCmds();
         }
         if(_state == PAUSED || _state == STOPPED || ns == null)
         {
            return;
         }
         _pause(true);
         setState(PAUSED);
      }
      
      private function execQueuedCmds() : void
      {
         var nextCmd:VideoPlayerQueuedCommand = null;
         while(cmdQueue.length > 0 && (stateResponsive || _state == CONNECTION_ERROR) && (cmdQueue[0].url != null || _state != DISCONNECTED && _state != CONNECTION_ERROR))
         {
            nextCmd = cmdQueue.shift();
            cachedState = _state;
            _state = EXEC_QUEUED_CMD;
            switch(nextCmd.type)
            {
               case VideoPlayerQueuedCommand.PLAY:
                  play(nextCmd.url,nextCmd.isLive,nextCmd.time);
                  break;
               case VideoPlayerQueuedCommand.LOAD:
                  load(nextCmd.url,nextCmd.isLive,nextCmd.time);
                  break;
               case VideoPlayerQueuedCommand.PAUSE:
                  pause();
                  break;
               case VideoPlayerQueuedCommand.STOP:
                  stop();
                  break;
               case VideoPlayerQueuedCommand.SEEK:
                  seek(nextCmd.time);
            }
         }
      }
      
      private function _pause(doPause:Boolean) : void
      {
         rtmpDoStopAtEndTimer.reset();
         if(doPause)
         {
            ns.pause();
         }
         else
         {
            ns.resume();
         }
      }
      
      public function close() : void
      {
         closeNS();
         if(_ncMgr != null && _ncMgr.isRTMP())
         {
            _ncMgr.close();
         }
         setState(DISCONNECTED);
         var videoEvent:VideoEvent = new VideoEvent(VideoEvent.CLOSE);
         videoEvent.state = _state;
         videoEvent.playheadTime = playheadTime;
         dispatchEvent(videoEvent);
      }
   }
}

import flash.net.NetConnection;
import flash.net.NetStream;
import mx.controls.videoClasses.VideoPlayer;

dynamic class VideoPlayerNetStream extends NetStream
{
   
   private var videoPlayer:VideoPlayer;
   
   public function VideoPlayerNetStream(connection:NetConnection, videoPlayer:VideoPlayer)
   {
      super(connection);
      this.videoPlayer = videoPlayer;
   }
   
   public function onCuePoint(info:Object, ... rest) : void
   {
      videoPlayer.onCuePoint(info);
   }
   
   public function onPlayStatus(... rest) : void
   {
   }
   
   public function onMetaData(info:Object, ... rest) : void
   {
      videoPlayer.onMetaData(info);
   }
}
