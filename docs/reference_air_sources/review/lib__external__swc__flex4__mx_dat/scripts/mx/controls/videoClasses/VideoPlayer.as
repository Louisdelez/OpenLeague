package mx.controls.videoClasses
{
   import flash.events.Event;
   import flash.events.NetStatusEvent;
   import flash.events.ProgressEvent;
   import flash.events.TimerEvent;
   import flash.media.SoundTransform;
   import flash.media.Video;
   import flash.utils.Timer;
   import mx.events.MetadataEvent;
   import mx.events.VideoEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
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
      
      private var cachedState:String;
      
      private var bufferState:String;
      
      private var sawPlayStop:Boolean;
      
      private var cachedPlayheadTime:Number;
      
      private var startingPlay:Boolean;
      
      private var invalidSeekRecovery:Boolean;
      
      private var invalidSeekTime:Boolean;
      
      private var readyDispatched:Boolean;
      
      private var lastUpdateTime:Number;
      
      private var sawSeekNotify:Boolean;
      
      public var ncMgrClassName:Class;
      
      private var ns:VideoPlayerNetStream;
      
      private var currentPos:Number;
      
      private var atEnd:Boolean;
      
      private var streamLength:Number;
      
      private var autoPlay:Boolean;
      
      private var _priorBytesLoaded:int = -1;
      
      private var internalVideoWidth:Number = -1;
      
      private var internalVideoHeight:Number = -1;
      
      private var prevVideoWidth:Number = -1;
      
      private var prevVideoHeight:Number = -1;
      
      private var updateTimeTimer:Timer;
      
      private var updateProgressTimer:Timer;
      
      private var idleTimeoutTimer:Timer;
      
      private var autoResizeTimer:Timer;
      
      private var rtmpDoStopAtEndTimer:Timer;
      
      private var rtmpDoSeekTimer:Timer;
      
      private var httpDoSeekTimer:Timer;
      
      private var finishAutoResizeTimer:Timer;
      
      private var delayedBufferingTimer:Timer;
      
      private var httpDoSeekCount:Number;
      
      private var cmdQueue:Array;
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var _visible:Boolean;
      
      private var _autoRewind:Boolean;
      
      private var _url:String;
      
      private var _volume:Number;
      
      private var _soundTransform:SoundTransform;
      
      private var _isLive:Boolean;
      
      private var _state:String;
      
      private var _bufferTime:Number;
      
      private var _ncMgr:INCManager;
      
      private var _metadata:Object;
      
      public function VideoPlayer(width:uint, height:uint, ncMgrClassName:Class = null)
      {
         super(width,height);
         this._state = DISCONNECTED;
         this.cachedState = this._state;
         this.bufferState = BUFFER_EMPTY;
         this.sawPlayStop = false;
         this.cachedPlayheadTime = 0;
         this._metadata = null;
         this.startingPlay = false;
         this.invalidSeekTime = false;
         this.invalidSeekRecovery = false;
         this.currentPos = 0;
         this.atEnd = false;
         this.cmdQueue = [];
         this.readyDispatched = false;
         this.lastUpdateTime = -1;
         this.sawSeekNotify = false;
         ncMgrClassName = ncMgrClassName == null ? DEFAULT_INCMANAGER : ncMgrClassName;
         this.updateTimeTimer = new Timer(DEFAULT_UPDATE_TIME_INTERVAL);
         this.updateTimeTimer.addEventListener(TimerEvent.TIMER,this.doUpdateTime);
         this.updateProgressTimer = new Timer(DEFAULT_UPDATE_PROGRESS_INTERVAL);
         this.updateProgressTimer.addEventListener(TimerEvent.TIMER,this.doUpdateProgress);
         this.idleTimeoutTimer = new Timer(DEFAULT_IDLE_TIMEOUT_INTERVAL,1);
         this.idleTimeoutTimer.addEventListener(TimerEvent.TIMER,this.doIdleTimeout);
         this.autoResizeTimer = new Timer(AUTO_RESIZE_INTERVAL);
         this.autoResizeTimer.addEventListener(TimerEvent.TIMER,this.doAutoResize);
         this.rtmpDoStopAtEndTimer = new Timer(RTMP_DO_STOP_AT_END_INTERVAL);
         this.rtmpDoStopAtEndTimer.addEventListener(TimerEvent.TIMER,this.rtmpDoStopAtEnd);
         this.rtmpDoSeekTimer = new Timer(RTMP_DO_SEEK_INTERVAL);
         this.rtmpDoSeekTimer.addEventListener(TimerEvent.TIMER,this.doSeek);
         this.httpDoSeekTimer = new Timer(HTTP_DO_SEEK_INTERVAL);
         this.httpDoSeekTimer.addEventListener(TimerEvent.TIMER,this.doSeek);
         this.finishAutoResizeTimer = new Timer(FINISH_AUTO_RESIZE_INTERVAL,1);
         this.finishAutoResizeTimer.addEventListener(TimerEvent.TIMER,this.finishAutoResize);
         this.delayedBufferingTimer = new Timer(HTTP_DELAYED_BUFFERING_INTERVAL);
         this.delayedBufferingTimer.addEventListener(TimerEvent.TIMER,this.doDelayedBuffering);
         this.httpDoSeekCount = 0;
         this._isLive = false;
         this.autoPlay = true;
         this._autoRewind = true;
         this._bufferTime = 0.1;
         this._volume = 100;
         this._soundTransform = new SoundTransform(this._volume);
         this._visible = true;
         this._url = "";
      }
      
      override public function set scaleX(xs:Number) : void
      {
         this.setScale(xs,this.scaleY);
      }
      
      override public function set scaleY(ys:Number) : void
      {
         this.setScale(this.scaleX,ys);
      }
      
      override public function set width(value:Number) : void
      {
         this.setSize(value,height);
      }
      
      override public function set height(value:Number) : void
      {
         this.setSize(width,value);
      }
      
      override public function get videoWidth() : int
      {
         if(this.internalVideoWidth > 0)
         {
            return this.internalVideoWidth;
         }
         if(this.metadata != null && !isNaN(this.metadata.width) && !isNaN(this.metadata.height))
         {
            if(this.metadata.width == this.metadata.height && this.readyDispatched)
            {
               return super.videoWidth;
            }
            return int(this.metadata.width);
         }
         if(this.readyDispatched)
         {
            return super.videoWidth;
         }
         return -1;
      }
      
      override public function get videoHeight() : int
      {
         if(this.internalVideoHeight > 0)
         {
            return this.internalVideoHeight;
         }
         if(this.metadata != null && !isNaN(this.metadata.width) && !isNaN(this.metadata.height))
         {
            if(this.metadata.width == this.metadata.height && this.readyDispatched)
            {
               return super.videoHeight;
            }
            return int(this.metadata.height);
         }
         if(this.readyDispatched)
         {
            return super.videoHeight;
         }
         return -1;
      }
      
      override public function get visible() : Boolean
      {
         this._visible = super.visible;
         return this._visible;
      }
      
      override public function set visible(v:Boolean) : void
      {
         this._visible = v;
         super.visible = this._visible;
      }
      
      public function get autoRewind() : Boolean
      {
         return this._autoRewind;
      }
      
      public function set autoRewind(flag:Boolean) : void
      {
         this._autoRewind = flag;
      }
      
      public function get playheadTime() : Number
      {
         var nowTime:Number = this.ns == null ? this.currentPos : Number(this.ns.time);
         if(Boolean(this._metadata) && Boolean(this._metadata.audiodelay))
         {
            nowTime -= this._metadata.audiodelay;
            if(nowTime < 0)
            {
               nowTime = 0;
            }
         }
         return nowTime;
      }
      
      public function set playheadTime(position:Number) : void
      {
         this.seek(position);
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function get volume() : Number
      {
         return this._volume;
      }
      
      public function set volume(aVol:Number) : void
      {
         if(aVol >= 0 && aVol <= 1)
         {
            this._volume = aVol;
         }
         else if(aVol < 0)
         {
            this._volume = 0;
         }
         else
         {
            this._volume = 1;
         }
         this._soundTransform.volume = this._volume;
         if(this.ns != null)
         {
            this.ns.soundTransform = this._soundTransform;
         }
      }
      
      public function get soundTransform() : SoundTransform
      {
         return this._soundTransform;
      }
      
      public function set soundTransform(s:SoundTransform) : void
      {
         this._soundTransform = s;
         this._volume = this._soundTransform.volume;
         this.ns.soundTransform = this._soundTransform;
      }
      
      public function get isRTMP() : Boolean
      {
         if(this._ncMgr == null)
         {
            return true;
         }
         return this._ncMgr.isRTMP();
      }
      
      public function get isLive() : Boolean
      {
         return this._isLive;
      }
      
      public function get state() : String
      {
         return this._state;
      }
      
      public function get stateResponsive() : Boolean
      {
         switch(this._state)
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
      
      public function get bytesLoaded() : int
      {
         if(this.ns == null || this._ncMgr.isRTMP())
         {
            return -1;
         }
         return this.ns.bytesLoaded;
      }
      
      public function get bytesTotal() : int
      {
         if(this.ns == null || this._ncMgr.isRTMP())
         {
            return -1;
         }
         return this.ns.bytesTotal;
      }
      
      public function get totalTime() : Number
      {
         return this.streamLength;
      }
      
      public function get bufferTime() : Number
      {
         return this._bufferTime;
      }
      
      public function set bufferTime(aTime:Number) : void
      {
         this._bufferTime = aTime;
         if(this.ns != null)
         {
            this.ns.bufferTime = this._bufferTime;
         }
      }
      
      public function get idleTimeout() : uint
      {
         return this.idleTimeoutTimer.delay;
      }
      
      public function set idleTimeout(aTime:uint) : void
      {
         this.idleTimeoutTimer.delay = aTime;
      }
      
      public function get playheadUpdateInterval() : uint
      {
         return this.updateTimeTimer.delay;
      }
      
      public function set playheadUpdateInterval(aTime:uint) : void
      {
         this.updateTimeTimer.delay = aTime;
      }
      
      public function get progressInterval() : uint
      {
         return this.updateProgressTimer.delay;
      }
      
      public function set progressInterval(aTime:uint) : void
      {
         this.updateProgressTimer.delay = aTime;
      }
      
      public function get ncMgr() : INCManager
      {
         if(this._ncMgr == null)
         {
            this.createINCManager();
         }
         return this._ncMgr;
      }
      
      public function get metadata() : Object
      {
         return this._metadata;
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
      
      public function setScale(xs:Number, ys:Number) : void
      {
         if(xs == super.scaleX && ys == super.scaleY)
         {
            return;
         }
         super.scaleX = xs;
         super.scaleY = ys;
      }
      
      public function play(url:String = null, isLive:Boolean = false, totalTime:Number = -1) : void
      {
         if(url != null)
         {
            if(this._state == EXEC_QUEUED_CMD)
            {
               this._state = this.cachedState;
            }
            else
            {
               if(!this.stateResponsive)
               {
                  this.queueCmd(VideoPlayerQueuedCommand.PLAY,url,isLive,totalTime);
                  return;
               }
               this.execQueuedCmds();
            }
            this.autoPlay = true;
            this._load(url,isLive,totalTime);
            return;
         }
         if(!this.isXnOK())
         {
            if(this._state == CONNECTION_ERROR || this._ncMgr == null || this._ncMgr.netConnection == null)
            {
               throw new VideoError(VideoError.NO_CONNECTION);
            }
            this.flushQueuedCmds();
            this.queueCmd(VideoPlayerQueuedCommand.PLAY);
            this.setState(LOADING);
            this.cachedState = LOADING;
            this._ncMgr.reconnect();
            return;
         }
         if(this._state == EXEC_QUEUED_CMD)
         {
            this._state = this.cachedState;
         }
         else
         {
            if(!this.stateResponsive)
            {
               this.queueCmd(VideoPlayerQueuedCommand.PLAY,null,isLive);
               return;
            }
            this.execQueuedCmds();
         }
         if(this.ns == null)
         {
            this.createStream();
            attachNetStream(this.ns);
         }
         switch(this._state)
         {
            case BUFFERING:
               if(this._ncMgr.isRTMP())
               {
                  this._play(0);
                  if(this.atEnd)
                  {
                     this.atEnd = false;
                     this.currentPos = 0;
                     this.setState(REWINDING);
                  }
                  else if(this.currentPos > 0)
                  {
                     this._seek(this.currentPos);
                     this.currentPos = 0;
                  }
               }
            case PLAYING:
               return;
            case STOPPED:
               if(this._ncMgr.isRTMP())
               {
                  if(isLive)
                  {
                     this._play(-1);
                     this.setState(BUFFERING);
                  }
                  else
                  {
                     this._play(0);
                     if(this.atEnd)
                     {
                        this.atEnd = false;
                        this.currentPos = 0;
                        this._state = BUFFERING;
                        this.setState(REWINDING);
                     }
                     else if(this.currentPos > 0)
                     {
                        this._seek(this.currentPos);
                        this.currentPos = 0;
                        this.setState(BUFFERING);
                     }
                     else
                     {
                        this.setState(BUFFERING);
                     }
                  }
               }
               else
               {
                  this._pause(false);
                  if(this.atEnd)
                  {
                     this.atEnd = false;
                     this._seek(0);
                     this._state = BUFFERING;
                     this.setState(REWINDING);
                  }
                  else if(this.bufferState == BUFFER_EMPTY)
                  {
                     this.setState(BUFFERING);
                  }
                  else
                  {
                     this.setState(PLAYING);
                  }
               }
               break;
            case PAUSED:
               this._pause(false);
               if(!this._ncMgr.isRTMP())
               {
                  if(this.bufferState == BUFFER_EMPTY)
                  {
                     this.setState(BUFFERING);
                  }
                  else
                  {
                     this.setState(PLAYING);
                  }
               }
               else
               {
                  this.setState(BUFFERING);
               }
         }
      }
      
      public function load(url:String, isLive:Boolean = false, totalTime:Number = -1) : void
      {
         var message:String = null;
         if(url == null)
         {
            message = this.resourceManager.getString("controls","nullURL");
            throw new ArgumentError(message);
         }
         if(this._state == EXEC_QUEUED_CMD)
         {
            this._state = this.cachedState;
         }
         else
         {
            if(!this.stateResponsive)
            {
               this.queueCmd(VideoPlayerQueuedCommand.LOAD,url,isLive,totalTime);
               return;
            }
            this.execQueuedCmds();
         }
         this.autoPlay = false;
         this._load(url,isLive,totalTime);
      }
      
      public function pause() : void
      {
         if(!this.isXnOK())
         {
            if(this._state == CONNECTION_ERROR || this._ncMgr == null || this._ncMgr.netConnection == null)
            {
               throw new VideoError(VideoError.NO_CONNECTION);
            }
            return;
         }
         if(this._state == EXEC_QUEUED_CMD)
         {
            this._state = this.cachedState;
         }
         else
         {
            if(!this.stateResponsive)
            {
               this.queueCmd(VideoPlayerQueuedCommand.PAUSE);
               return;
            }
            this.execQueuedCmds();
         }
         if(this._state == PAUSED || this._state == STOPPED || this.ns == null)
         {
            return;
         }
         this._pause(true);
         this.setState(PAUSED);
      }
      
      public function stop() : void
      {
         if(!this.isXnOK())
         {
            if(this._state == CONNECTION_ERROR || this._ncMgr == null || this._ncMgr.netConnection == null)
            {
               throw new VideoError(VideoError.NO_CONNECTION);
            }
            return;
         }
         if(this._state == EXEC_QUEUED_CMD)
         {
            this._state = this.cachedState;
         }
         else
         {
            if(!this.stateResponsive)
            {
               this.queueCmd(VideoPlayerQueuedCommand.STOP);
               return;
            }
            this.execQueuedCmds();
         }
         if(this._state == STOPPED || this.ns == null)
         {
            return;
         }
         if(this._ncMgr.isRTMP())
         {
            if(this._autoRewind && !this._isLive)
            {
               this.currentPos = 0;
               this._play(0,0);
               this._state = STOPPED;
               this.setState(REWINDING);
            }
            else
            {
               this.closeNS();
               this.setState(STOPPED);
            }
         }
         else
         {
            this._pause(true);
            if(this._autoRewind)
            {
               this._seek(0);
               this._state = STOPPED;
               this.setState(REWINDING);
            }
            else
            {
               this.setState(STOPPED);
            }
         }
      }
      
      public function seek(time:Number) : void
      {
         if(this.invalidSeekTime)
         {
            return;
         }
         if(isNaN(time) || time < 0)
         {
            throw new VideoError(VideoError.INVALID_SEEK);
         }
         if(!this.isXnOK())
         {
            if(this._state == CONNECTION_ERROR || this._ncMgr == null || this._ncMgr.netConnection == null)
            {
               throw new VideoError(VideoError.NO_CONNECTION);
            }
            this.flushQueuedCmds();
            this.queueCmd(VideoPlayerQueuedCommand.SEEK,null,false,time);
            this.setState(LOADING);
            this.cachedState = LOADING;
            this._ncMgr.reconnect();
            return;
         }
         if(this._state == EXEC_QUEUED_CMD)
         {
            this._state = this.cachedState;
         }
         else
         {
            if(!this.stateResponsive)
            {
               this.queueCmd(VideoPlayerQueuedCommand.SEEK,null,false,time);
               return;
            }
            this.execQueuedCmds();
         }
         if(this.ns == null)
         {
            this.createStream();
            attachNetStream(this.ns);
         }
         if(this.atEnd && time <= this.playheadTime)
         {
            this.atEnd = false;
         }
         switch(this._state)
         {
            case PLAYING:
               this._state = BUFFERING;
            case BUFFERING:
            case PAUSED:
               this._seek(time);
               this.setState(SEEKING);
               break;
            case STOPPED:
               if(this._ncMgr.isRTMP())
               {
                  this._play(0);
                  this._pause(true);
               }
               this._seek(time);
               this._state = PAUSED;
               this.setState(SEEKING);
         }
      }
      
      public function close() : void
      {
         this.closeNS();
         if(this._ncMgr != null && this._ncMgr.isRTMP())
         {
            this._ncMgr.close();
         }
         this.setState(DISCONNECTED);
         var videoEvent:VideoEvent = new VideoEvent(VideoEvent.CLOSE);
         videoEvent.state = this._state;
         videoEvent.playheadTime = this.playheadTime;
         dispatchEvent(videoEvent);
      }
      
      public function doUpdateTime(event:Event) : void
      {
         var videoEvent:VideoEvent = null;
         var theTime:Number = this.playheadTime;
         switch(this._state)
         {
            case STOPPED:
            case PAUSED:
            case DISCONNECTED:
            case CONNECTION_ERROR:
               if(event != null)
               {
                  this.updateTimeTimer.reset();
               }
         }
         if(this.lastUpdateTime != theTime)
         {
            videoEvent = new VideoEvent(VideoEvent.PLAYHEAD_UPDATE);
            videoEvent.state = this._state;
            videoEvent.playheadTime = theTime;
            dispatchEvent(videoEvent);
            this.lastUpdateTime = theTime;
         }
      }
      
      public function doUpdateProgress(event:Event) : void
      {
         if(this.ns == null)
         {
            return;
         }
         if(this.ns.bytesTotal >= 0 && this.ns.bytesLoaded != this._priorBytesLoaded)
         {
            dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,this.ns.bytesLoaded,this.ns.bytesTotal));
         }
         if(this._state == DISCONNECTED || this._state == CONNECTION_ERROR || this.ns.bytesLoaded == this.ns.bytesTotal)
         {
            this.updateProgressTimer.reset();
         }
         this._priorBytesLoaded = this.ns.bytesLoaded;
      }
      
      public function rtmpOnStatus(event:NetStatusEvent) : void
      {
         if(this._state == CONNECTION_ERROR)
         {
            return;
         }
         switch(event.info.code)
         {
            case "NetStream.Play.Stop":
               if(this.startingPlay)
               {
                  return;
               }
               switch(this._state)
               {
                  case RESIZING:
                  case LOADING:
                  case STOPPED:
                  case PAUSED:
                     break;
                  default:
                     this.sawPlayStop = true;
               }
               break;
            case "NetStream.Buffer.Empty":
               switch(this.bufferState)
               {
                  case BUFFER_FULL:
                     if(this.sawPlayStop)
                     {
                        this.rtmpDoStopAtEnd(null);
                     }
                     else if(this._state == PLAYING)
                     {
                        this.setState(BUFFERING);
                     }
               }
               this.bufferState = BUFFER_EMPTY;
               this.sawPlayStop = false;
               break;
            case "NetStream.Buffer.Flush":
               if(this.sawSeekNotify && this._state == SEEKING)
               {
                  this.bufferState = BUFFER_EMPTY;
                  this.sawPlayStop = false;
                  this.setStateFromCachedState();
                  this.doUpdateTime(null);
               }
               if(this.sawPlayStop && (this.bufferState == BUFFER_EMPTY || this._bufferTime <= 0.1 && this.ns.bufferLength <= 0.1))
               {
                  this.cachedPlayheadTime = this.playheadTime;
                  this.rtmpDoStopAtEndTimer.start();
               }
               switch(this.bufferState)
               {
                  case BUFFER_EMPTY:
                     if(this._state == LOADING && this.cachedState == PLAYING || this._state == BUFFERING)
                     {
                        this.setState(PLAYING);
                     }
                     else if(this.cachedState == BUFFERING)
                     {
                        this.cachedState = PLAYING;
                     }
                     this.bufferState = BUFFER_FLUSH;
                     break;
                  default:
                     if(this._state == BUFFERING)
                     {
                        this.setStateFromCachedState();
                     }
               }
               break;
            case "NetStream.Buffer.Full":
               if(this.sawSeekNotify && this._state == SEEKING)
               {
                  this.bufferState = BUFFER_EMPTY;
                  this.sawPlayStop = false;
                  this.setStateFromCachedState();
                  this.doUpdateTime(null);
               }
               switch(this.bufferState)
               {
                  case BUFFER_EMPTY:
                     this.bufferState = BUFFER_FULL;
                     if(this._state == LOADING && this.cachedState == PLAYING || this._state == BUFFERING)
                     {
                        this.setState(PLAYING);
                     }
                     else if(this.cachedState == BUFFERING)
                     {
                        this.cachedState = PLAYING;
                     }
                     if(this.rtmpDoStopAtEndTimer.running)
                     {
                        this.sawPlayStop = true;
                        this.rtmpDoStopAtEndTimer.reset();
                     }
                     break;
                  case BUFFER_FLUSH:
                     this.bufferState = BUFFER_FULL;
                     if(this.rtmpDoStopAtEndTimer.running)
                     {
                        this.sawPlayStop = true;
                        this.rtmpDoStopAtEndTimer.reset();
                     }
               }
               if(this._state == BUFFERING)
               {
                  this.setStateFromCachedState();
               }
               break;
            case "NetStream.Pause.Notify":
               break;
            case "NetStream.Unpause.Notify":
               if(this._state == PAUSED)
               {
                  this._state = PLAYING;
                  this.setState(BUFFERING);
               }
               else
               {
                  this.cachedState = PLAYING;
               }
               break;
            case "NetStream.Play.Start":
               this.rtmpDoStopAtEndTimer.reset();
               this.bufferState = BUFFER_EMPTY;
               this.sawPlayStop = false;
               if(this.startingPlay)
               {
                  this.startingPlay = false;
                  this.cachedPlayheadTime = this.playheadTime;
               }
               else if(this._state == PLAYING)
               {
                  this.setState(BUFFERING);
               }
               break;
            case "NetStream.Play.Reset":
               this.rtmpDoStopAtEndTimer.reset();
               if(this._state == REWINDING)
               {
                  this.rtmpDoSeekTimer.reset();
                  if(this.playheadTime == 0 || this.playheadTime < this.cachedPlayheadTime)
                  {
                     this.setStateFromCachedState();
                  }
                  else
                  {
                     this.cachedPlayheadTime = this.playheadTime;
                     this.rtmpDoSeekTimer.start();
                  }
               }
               break;
            case "NetStream.Seek.Notify":
               if(this.playheadTime != this.cachedPlayheadTime)
               {
                  this.setStateFromCachedState();
                  this.doUpdateTime(null);
               }
               else
               {
                  this.sawSeekNotify = true;
                  if(!this.rtmpDoSeekTimer.running)
                  {
                     this.rtmpDoSeekTimer.start();
                  }
               }
               break;
            case "Netstream.Play.UnpublishNotify":
            case "Netstream.Play.PublishNotify":
               break;
            case "NetStream.Play.StreamNotFound":
               if(!this._ncMgr.connectAgain())
               {
                  this.setState(CONNECTION_ERROR);
               }
               break;
            case "NetStream.Play.Failed":
            case "NetStream.Failed":
               this.setState(CONNECTION_ERROR);
         }
      }
      
      public function httpOnStatus(event:NetStatusEvent) : void
      {
         switch(event.info.code)
         {
            case "NetStream.Play.Stop":
               this.delayedBufferingTimer.reset();
               if(this.invalidSeekTime)
               {
                  this.recoverInvalidSeek();
               }
               else
               {
                  switch(this._state)
                  {
                     case PLAYING:
                     case BUFFERING:
                     case SEEKING:
                        this.httpDoStopAtEnd();
                  }
               }
               break;
            case "NetStream.Seek.InvalidTime":
               if(this.invalidSeekRecovery)
               {
                  this.invalidSeekTime = false;
                  this.invalidSeekRecovery = false;
                  this.setState(this.cachedState);
                  this.seek(0);
               }
               else
               {
                  this.recoverInvalidSeek();
               }
               break;
            case "NetStream.Buffer.Empty":
               this.bufferState = BUFFER_EMPTY;
               if(this._state == PLAYING)
               {
                  this.delayedBufferingTimer.start();
               }
               break;
            case "NetStream.Buffer.Full":
            case "NetStream.Buffer.Flush":
               this.delayedBufferingTimer.reset();
               this.bufferState = BUFFER_FULL;
               if(this._state == LOADING && this.cachedState == PLAYING || this._state == BUFFERING)
               {
                  this.setState(PLAYING);
               }
               else if(this.cachedState == BUFFERING)
               {
                  this.cachedState = PLAYING;
               }
               break;
            case "NetStream.Seek.Notify":
               this.invalidSeekRecovery = false;
               switch(this._state)
               {
                  case SEEKING:
                  case REWINDING:
                     if(!this.httpDoSeekTimer.running)
                     {
                        this.httpDoSeekCount = 0;
                        this.httpDoSeekTimer.start();
                     }
               }
               break;
            case "NetStream.Play.StreamNotFound":
               this.setState(CONNECTION_ERROR);
         }
      }
      
      public function ncConnected() : void
      {
         if(this._ncMgr == null || this._ncMgr.netConnection == null)
         {
            this.setState(CONNECTION_ERROR);
         }
         else
         {
            this.createStream();
            this.setUpStream();
         }
      }
      
      public function ncReconnected() : void
      {
         if(this._ncMgr == null || this._ncMgr.netConnection == null)
         {
            this.setState(CONNECTION_ERROR);
         }
         else
         {
            this.ns = null;
            this._state = STOPPED;
            this.execQueuedCmds();
         }
      }
      
      public function onMetaData(info:Object) : void
      {
         if(this._metadata != null)
         {
            return;
         }
         this._metadata = info;
         if(isNaN(this.streamLength) || this.streamLength <= 0)
         {
            this.streamLength = info.duration;
         }
         if(isNaN(this.internalVideoWidth) || this.internalVideoWidth <= 0)
         {
            this.internalVideoWidth = info.width;
         }
         if(isNaN(this.internalVideoHeight) || this.internalVideoHeight <= 0)
         {
            this.internalVideoHeight = info.height;
         }
         var metadataEvent:MetadataEvent = new MetadataEvent(MetadataEvent.METADATA_RECEIVED);
         metadataEvent.info = info;
         dispatchEvent(metadataEvent);
      }
      
      public function onCuePoint(info:Object) : void
      {
         var metadataEvent:MetadataEvent = new MetadataEvent(MetadataEvent.CUE_POINT);
         metadataEvent.info = info;
         dispatchEvent(metadataEvent);
      }
      
      private function _load(url:String, isLive:Boolean, totalTime:Number) : void
      {
         if(this.prevVideoWidth == -1)
         {
            if(this.videoWidth >= 0)
            {
               this.prevVideoWidth = this.videoWidth;
            }
            else
            {
               this.prevVideoWidth = 0;
            }
         }
         if(this.prevVideoHeight == -1)
         {
            if(this.videoHeight >= 0)
            {
               this.prevVideoHeight = this.videoHeight;
            }
            else
            {
               this.prevVideoHeight = 0;
            }
         }
         this.cachedPlayheadTime = 0;
         this.bufferState = BUFFER_EMPTY;
         this.sawPlayStop = false;
         this._metadata = null;
         this.startingPlay = false;
         this.invalidSeekRecovery = false;
         this.invalidSeekTime = false;
         this._isLive = isLive;
         this._url = url;
         this.currentPos = 0;
         this.streamLength = totalTime;
         this.atEnd = false;
         this.internalVideoWidth = -1;
         this.internalVideoHeight = -1;
         this.readyDispatched = false;
         this.lastUpdateTime = -1;
         this.sawSeekNotify = false;
         this.updateTimeTimer.reset();
         this.updateProgressTimer.reset();
         this.idleTimeoutTimer.reset();
         this.autoResizeTimer.reset();
         this.rtmpDoStopAtEndTimer.reset();
         this.rtmpDoSeekTimer.reset();
         this.httpDoSeekTimer.reset();
         this.finishAutoResizeTimer.reset();
         this.delayedBufferingTimer.reset();
         this.closeNS(false);
         if(this._ncMgr == null)
         {
            this.createINCManager();
         }
         var instantConnect:Boolean = this._ncMgr.connectToURL(this._url);
         this.setState(LOADING);
         this.cachedState = LOADING;
         if(instantConnect)
         {
            this.createStream();
            this.setUpStream();
         }
         if(!this._ncMgr.isRTMP())
         {
            this.updateProgressTimer.start();
         }
      }
      
      private function setState(s:String) : void
      {
         if(s == this._state)
         {
            return;
         }
         this.cachedState = this._state;
         this.cachedPlayheadTime = this.playheadTime;
         this._state = s;
         var newState:String = this._state;
         var videoEvent:VideoEvent = new VideoEvent(VideoEvent.STATE_CHANGE);
         videoEvent.state = newState;
         videoEvent.playheadTime = this.playheadTime;
         dispatchEvent(videoEvent);
         if(!this.readyDispatched)
         {
            switch(newState)
            {
               case STOPPED:
               case PLAYING:
               case PAUSED:
               case BUFFERING:
                  this.readyDispatched = true;
                  videoEvent = new VideoEvent(VideoEvent.READY);
                  videoEvent.state = newState;
                  videoEvent.playheadTime = this.playheadTime;
                  dispatchEvent(videoEvent);
            }
         }
         switch(this.cachedState)
         {
            case REWINDING:
               videoEvent = new VideoEvent(VideoEvent.REWIND);
               videoEvent.state = newState;
               videoEvent.playheadTime = this.playheadTime;
               dispatchEvent(videoEvent);
               if(this._ncMgr.isRTMP() && newState == STOPPED)
               {
                  this.closeNS();
               }
         }
         switch(newState)
         {
            case STOPPED:
            case PAUSED:
               if(this._ncMgr.isRTMP() && !this.idleTimeoutTimer.running)
               {
                  this.idleTimeoutTimer.start();
               }
               break;
            case SEEKING:
            case REWINDING:
               this.bufferState = BUFFER_EMPTY;
               this.sawPlayStop = false;
            case PLAYING:
            case BUFFERING:
               if(!this.updateTimeTimer.running)
               {
                  this.updateTimeTimer.start();
               }
            case LOADING:
            case RESIZING:
               this.idleTimeoutTimer.reset();
         }
         this.execQueuedCmds();
      }
      
      private function setStateFromCachedState() : void
      {
         switch(this.cachedState)
         {
            case PLAYING:
            case PAUSED:
               this.setState(this.cachedState);
               break;
            case BUFFERING:
               if(this.bufferState == BUFFER_EMPTY)
               {
                  this.setState(BUFFERING);
               }
               else
               {
                  this.setState(this.cachedState);
               }
               break;
            default:
               this.setState(STOPPED);
         }
      }
      
      private function recoverInvalidSeek() : void
      {
         this.setStateFromCachedState();
         this.invalidSeekTime = false;
         this.invalidSeekRecovery = true;
         this.seek(this.playheadTime);
      }
      
      private function createINCManager() : void
      {
         var ncMgrClass:Class = this.ncMgrClassName == null ? DEFAULT_INCMANAGER : this.ncMgrClassName;
         this._ncMgr = new ncMgrClass();
         this._ncMgr.videoPlayer = this;
      }
      
      private function rtmpDoStopAtEnd(event:TimerEvent) : void
      {
         if(event != null)
         {
            switch(this._state)
            {
               case DISCONNECTED:
               case CONNECTION_ERROR:
                  this.rtmpDoStopAtEndTimer.reset();
                  return;
               default:
                  if(this.cachedPlayheadTime != this.playheadTime)
                  {
                     this.cachedPlayheadTime = this.playheadTime;
                     return;
                  }
                  this.rtmpDoStopAtEndTimer.reset();
            }
         }
         this.bufferState = BUFFER_EMPTY;
         this.sawPlayStop = false;
         this.atEnd = true;
         this.setState(STOPPED);
         if(this._state != STOPPED)
         {
            return;
         }
         this.doUpdateTime(null);
         if(this._state != STOPPED)
         {
            return;
         }
         var videoEvent:VideoEvent = new VideoEvent(VideoEvent.COMPLETE);
         videoEvent.state = this._state;
         videoEvent.playheadTime = this.playheadTime;
         dispatchEvent(videoEvent);
         if(this._state != STOPPED)
         {
            return;
         }
         if(this._autoRewind && !this._isLive && this.playheadTime != 0)
         {
            this.atEnd = false;
            this.currentPos = 0;
            this._play(0,0);
            this.setState(REWINDING);
         }
         else
         {
            this.closeNS();
         }
      }
      
      private function rtmpDoSeek() : void
      {
         if(this._state != REWINDING && this._state != SEEKING)
         {
            this.rtmpDoSeekTimer.reset();
            this.sawSeekNotify = false;
         }
         else if(this.playheadTime != this.cachedPlayheadTime)
         {
            this.rtmpDoSeekTimer.reset();
            this.sawSeekNotify = false;
            this.setStateFromCachedState();
            this.doUpdateTime(null);
         }
      }
      
      private function httpDoStopAtEnd() : void
      {
         this.atEnd = true;
         if(isNaN(this.streamLength) || this.streamLength <= 0)
         {
            this.streamLength = this.ns.time;
         }
         this._pause(true);
         this.setState(STOPPED);
         if(this._state != STOPPED)
         {
            return;
         }
         this.doUpdateTime(null);
         if(this._state != STOPPED)
         {
            return;
         }
         var videoEvent:VideoEvent = new VideoEvent(VideoEvent.COMPLETE);
         videoEvent.state = this._state;
         videoEvent.playheadTime = this.playheadTime;
         dispatchEvent(videoEvent);
         if(this._state != STOPPED)
         {
            return;
         }
         if(this._autoRewind)
         {
            this.atEnd = false;
            this._pause(true);
            this._seek(0);
            this.setState(REWINDING);
         }
      }
      
      private function doSeek(event:Event) : void
      {
         var seekState:Boolean = this._state == REWINDING || this._state == SEEKING;
         if(seekState && this.httpDoSeekCount < HTTP_DO_SEEK_MAX_COUNT && (this.cachedPlayheadTime == this.playheadTime || this.invalidSeekTime))
         {
            ++this.httpDoSeekCount;
            return;
         }
         this.httpDoSeekCount = 0;
         this.httpDoSeekTimer.reset();
         if(!seekState)
         {
            return;
         }
         if(this.invalidSeekTime)
         {
            this.recoverInvalidSeek();
         }
         else
         {
            this.setStateFromCachedState();
            this.doUpdateTime(null);
         }
      }
      
      private function closeNS(updateCurrentPos:Boolean = true) : void
      {
         if(this.ns != null)
         {
            if(updateCurrentPos)
            {
               this.updateTimeTimer.reset();
               this.doUpdateTime(null);
               this.currentPos = this.ns.time;
            }
            this.ns.removeEventListener(NetStatusEvent.NET_STATUS,this.httpOnStatus);
            this.ns.removeEventListener(NetStatusEvent.NET_STATUS,this.rtmpOnStatus);
            this.ns.close();
            this.ns = null;
         }
      }
      
      private function doDelayedBuffering(event:Event) : void
      {
         switch(this._state)
         {
            case LOADING:
            case RESIZING:
               break;
            case PLAYING:
               this.delayedBufferingTimer.reset();
               this.setState(BUFFERING);
               break;
            default:
               this.delayedBufferingTimer.reset();
         }
      }
      
      private function _pause(doPause:Boolean) : void
      {
         this.rtmpDoStopAtEndTimer.reset();
         if(doPause)
         {
            this.ns.pause();
         }
         else
         {
            this.ns.resume();
         }
      }
      
      private function _play(... rest) : void
      {
         var message:String = null;
         this.rtmpDoStopAtEndTimer.reset();
         this.startingPlay = true;
         switch(rest.length)
         {
            case 0:
               this.ns.play(this._ncMgr.streamName);
               break;
            case 1:
               this.ns.play(this._ncMgr.streamName,rest[0]);
               break;
            case 2:
               this.ns.play(this._ncMgr.streamName,rest[0],rest[1]);
               break;
            default:
               message = this.resourceManager.getString("controls","badArgs");
               throw new ArgumentError(message);
         }
      }
      
      private function _seek(time:Number) : void
      {
         this.rtmpDoStopAtEndTimer.reset();
         var seekTime:Number = Math.round(time * 1000) / 1000;
         if(Boolean(this._metadata) && Boolean(this._metadata.audiodelay) && time + this._metadata.audiodelay < this.streamLength)
         {
            time += this._metadata.audiodelay;
         }
         this.ns.seek(time);
         this.invalidSeekTime = false;
         this.bufferState = BUFFER_EMPTY;
         this.sawPlayStop = false;
         this.sawSeekNotify = false;
      }
      
      private function isXnOK() : Boolean
      {
         if(this._state == LOADING)
         {
            return true;
         }
         if(this._state == CONNECTION_ERROR)
         {
            return false;
         }
         if(this._state != DISCONNECTED)
         {
            if(this._ncMgr == null || this._ncMgr.netConnection == null || !this._ncMgr.netConnection.connected)
            {
               this.setState(DISCONNECTED);
               return false;
            }
            return true;
         }
         return false;
      }
      
      private function doAutoResize(event:Event) : void
      {
         if(event != null)
         {
            switch(this._state)
            {
               case RESIZING:
               case LOADING:
                  break;
               case DISCONNECTED:
               case CONNECTION_ERROR:
                  this.autoResizeTimer.reset();
                  return;
               default:
                  if(!this.stateResponsive)
                  {
                     return;
                  }
            }
            if(!(this.videoWidth != this.prevVideoWidth || this.videoHeight != this.prevVideoHeight || this.bufferState == BUFFER_FULL || this.bufferState == BUFFER_FLUSH || (Boolean(this.ns) ? Boolean(this.ns.time > AUTO_RESIZE_PLAYHEAD_TIMEOUT) : Boolean(false))))
            {
               return;
            }
            this.internalVideoWidth = this.videoWidth;
            this.internalVideoHeight = this.videoHeight;
            this.autoResizeTimer.reset();
         }
         this.setState(this.cachedState);
      }
      
      private function finishAutoResize(event:Event) : void
      {
         this.finishAutoResizeTimer.reset();
         if(this.stateResponsive)
         {
            return;
         }
         super.visible = this._visible;
         this._soundTransform.volume = this._volume;
         this.ns.soundTransform = this._soundTransform;
         if(this.autoPlay)
         {
            if(this._ncMgr.isRTMP())
            {
               if(!this._isLive)
               {
                  this.currentPos = 0;
                  this._play(0);
               }
               if(this._state == RESIZING)
               {
                  this.setState(LOADING);
                  this.cachedState = PLAYING;
               }
            }
            else
            {
               this._pause(false);
               this.cachedState = PLAYING;
            }
         }
         else
         {
            this.setState(STOPPED);
         }
      }
      
      private function createStream() : void
      {
         this.ns = new VideoPlayerNetStream(this._ncMgr.netConnection,this);
         this.ns.bufferTime = this._bufferTime;
         this.ns.soundTransform = this._soundTransform;
         this.ns.addEventListener(NetStatusEvent.NET_STATUS,this._ncMgr.isRTMP() ? this.rtmpOnStatus : this.httpOnStatus);
         attachNetStream(this.ns);
      }
      
      private function setUpStream() : void
      {
         if(!isNaN(this._ncMgr.streamLength) && this._ncMgr.streamLength >= 0)
         {
            this.streamLength = this._ncMgr.streamLength;
         }
         if(!isNaN(this._ncMgr.streamWidth) && this._ncMgr.streamWidth >= 0)
         {
            this.internalVideoWidth = this._ncMgr.streamWidth;
         }
         else
         {
            this.internalVideoWidth = -1;
         }
         if(!isNaN(this._ncMgr.streamHeight) && this._ncMgr.streamHeight >= 0)
         {
            this.internalVideoHeight = this._ncMgr.streamHeight;
         }
         else
         {
            this.internalVideoHeight = -1;
         }
         if(this.autoPlay)
         {
            if(!this._ncMgr.isRTMP())
            {
               this.cachedState = BUFFERING;
               this._play();
            }
            else if(this._isLive)
            {
               this.cachedState = BUFFERING;
               this._play(-1);
            }
            else
            {
               this.cachedState = BUFFERING;
               this._play(0);
            }
         }
         else
         {
            this.cachedState = STOPPED;
            if(this._ncMgr.isRTMP())
            {
               this._play(-2,0);
            }
            else
            {
               this._play();
               this._pause(true);
               this._seek(0);
            }
         }
         this.autoResizeTimer.reset();
         this.autoResizeTimer.start();
      }
      
      private function doIdleTimeout(event:Event) : void
      {
         this.idleTimeoutTimer.reset();
         this.close();
      }
      
      private function flushQueuedCmds() : void
      {
         while(this.cmdQueue.length > 0)
         {
            this.cmdQueue.pop();
         }
      }
      
      private function execQueuedCmds() : void
      {
         var nextCmd:VideoPlayerQueuedCommand = null;
         while(this.cmdQueue.length > 0 && (this.stateResponsive || this._state == CONNECTION_ERROR) && (this.cmdQueue[0].url != null || this._state != DISCONNECTED && this._state != CONNECTION_ERROR))
         {
            nextCmd = this.cmdQueue.shift();
            this.cachedState = this._state;
            this._state = EXEC_QUEUED_CMD;
            switch(nextCmd.type)
            {
               case VideoPlayerQueuedCommand.PLAY:
                  this.play(nextCmd.url,nextCmd.isLive,nextCmd.time);
                  break;
               case VideoPlayerQueuedCommand.LOAD:
                  this.load(nextCmd.url,nextCmd.isLive,nextCmd.time);
                  break;
               case VideoPlayerQueuedCommand.PAUSE:
                  this.pause();
                  break;
               case VideoPlayerQueuedCommand.STOP:
                  this.stop();
                  break;
               case VideoPlayerQueuedCommand.SEEK:
                  this.seek(nextCmd.time);
            }
         }
      }
      
      private function queueCmd(type:uint, url:String = null, isLive:Boolean = false, time:Number = 0) : void
      {
         this.cmdQueue.push(new VideoPlayerQueuedCommand(type,url,isLive,time));
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
   
   public function onMetaData(info:Object, ... rest) : void
   {
      this.videoPlayer.onMetaData(info);
   }
   
   public function onCuePoint(info:Object, ... rest) : void
   {
      this.videoPlayer.onCuePoint(info);
   }
   
   public function onPlayStatus(... rest) : void
   {
   }
}
