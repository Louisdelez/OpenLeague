package mx.controls
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.media.Camera;
   import mx.controls.videoClasses.VideoPlayer;
   import mx.core.EdgeMetrics;
   import mx.core.IFlexDisplayObject;
   import mx.core.IRectangularBorder;
   import mx.core.IUIComponent;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.CuePointEvent;
   import mx.events.FlexEvent;
   import mx.events.MetadataEvent;
   import mx.events.VideoEvent;
   import mx.styles.ISimpleStyleClient;
   import mx.utils.LoaderUtil;
   
   use namespace mx_internal;
   
   [IconFile("VideoDisplay.png")]
   [Event(name="stateChange",type="mx.events.VideoEvent")]
   [Event(name="rewind",type="mx.events.VideoEvent")]
   [Event(name="ready",type="mx.events.VideoEvent")]
   [Event(name="progress",type="flash.events.ProgressEvent")]
   [Event(name="playheadUpdate",type="mx.events.VideoEvent")]
   [Event(name="metadataReceived",type="mx.events.MetadataEvent")]
   [Event(name="cuePoint",type="mx.events.CuePointEvent")]
   [Event(name="complete",type="mx.events.VideoEvent")]
   [Event(name="close",type="mx.events.VideoEvent")]
   [Style(name="shadowDistance",type="Number",format="Length",inherit="no")]
   [Style(name="shadowDirection",type="String",enumeration="left,center,right",inherit="no")]
   [Style(name="dropShadowColor",type="uint",format="Color",inherit="yes")]
   [Style(name="dropShadowEnabled",type="Boolean",inherit="no")]
   [Style(name="cornerRadius",type="Number",format="Length",inherit="no")]
   [Style(name="borderThickness",type="Number",format="Length",inherit="no")]
   [Style(name="borderStyle",type="String",enumeration="inset,outset,solid,none",inherit="no")]
   [Style(name="borderSkin",type="Class",inherit="no")]
   [Style(name="borderSides",type="String",inherit="no")]
   [Style(name="borderColor",type="uint",format="Color",inherit="no")]
   [Style(name="backgroundSize",type="String",inherit="no")]
   [Style(name="backgroundImage",type="Object",format="File",inherit="no")]
   [Style(name="backgroundDisabledColor",type="uint",format="Color",inherit="yes")]
   [Style(name="backgroundColor",type="uint",format="Color",inherit="no")]
   [Style(name="backgroundAlpha",type="Number",inherit="no")]
   public class VideoDisplay extends UIComponent
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const DEFAULT_WIDTH:Number = 10;
      
      private static const DEFAULT_HEIGHT:Number = 10;
      
      private var sourceChanged:Boolean = false;
      
      private var _playheadUpdateInterval:int = -1;
      
      private var _autoBandWidthDetection:Boolean = false;
      
      protected var border:IFlexDisplayObject;
      
      private var _idleTimeout:int = -1;
      
      private var _volume:Number = 0.75;
      
      private var _source:String = null;
      
      private var creationCompleted:Boolean = false;
      
      mx_internal var videoPlayer:VideoPlayer = null;
      
      private var _ncManagerClass:Class = null;
      
      private var _maintainAspectRatio:Boolean = true;
      
      private var _cuePointManagerClass:Class = null;
      
      private var _progressInterval:int = -1;
      
      private var _cuePoints:Array = null;
      
      private var asCuePointIndexResetPending:Boolean = false;
      
      private var makeVideoVisibleOnLayout:Boolean = false;
      
      private var _cuePointManager:Object = null;
      
      private var closeCalled:Boolean = false;
      
      private var _totalTime:Number = NaN;
      
      private var _live:Boolean = false;
      
      private var _bufferTime:Number = 0.1;
      
      private var _playheadTime:Number = NaN;
      
      private var _autoPlay:Boolean = true;
      
      private var _autoRewind:Boolean = true;
      
      public function VideoDisplay()
      {
         super();
         addEventListener(FlexEvent.CREATION_COMPLETE,creationCompleteHandler);
      }
      
      [Inspectable(defaultValue="0")]
      [Bindable("playheadUpdate")]
      [Bindable("playheadTimeChanged")]
      [Bindable("change")]
      public function get playheadTime() : Number
      {
         return videoPlayer != null ? videoPlayer.playheadTime : _playheadTime;
      }
      
      public function set playheadTime(value:Number) : void
      {
         _playheadTime = value;
         asCuePointIndexResetPending = true;
         if(Boolean(videoPlayer))
         {
            videoPlayer.playheadTime = value;
            dispatchEvent(new Event("playheadTimeChanged"));
         }
      }
      
      [Inspectable(defaultValue="false")]
      [Bindable("autoBandWidthDetection")]
      public function get autoBandWidthDetection() : Boolean
      {
         return _autoBandWidthDetection;
      }
      
      public function set autoBandWidthDetection(value:Boolean) : void
      {
         if(_autoBandWidthDetection != value)
         {
            _autoBandWidthDetection = value;
            if(Boolean(videoPlayer))
            {
               videoPlayer.autoBandWidthDetection = value;
            }
            dispatchEvent(new Event("autoBandWidthDetectionChanged"));
         }
      }
      
      [Inspectable(defaultValue="true")]
      [Bindable("maintainAspectRatioChanged")]
      public function get maintainAspectRatio() : Boolean
      {
         return _maintainAspectRatio;
      }
      
      [Bindable("resize")]
      public function get videoWidth() : int
      {
         return Boolean(videoPlayer) ? videoPlayer.videoWidth : -1;
      }
      
      public function set autoPlay(value:Boolean) : void
      {
         _autoPlay = value;
      }
      
      public function set cuePointManagerClass(value:Class) : void
      {
         _cuePointManagerClass = value;
      }
      
      public function stop() : void
      {
         if(!videoPlayer)
         {
            return;
         }
         videoPlayer.stop();
      }
      
      [Inspectable(defaultValue="250")]
      public function get progressInterval() : int
      {
         if(Boolean(videoPlayer))
         {
            return videoPlayer.progressInterval;
         }
         return _progressInterval == -1 ? int(VideoPlayer.DEFAULT_UPDATE_PROGRESS_INTERVAL) : _progressInterval;
      }
      
      public function set maintainAspectRatio(value:Boolean) : void
      {
         if(_maintainAspectRatio != value)
         {
            _maintainAspectRatio = value;
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("maintainAspectRatioChanged"));
         }
      }
      
      private function videoPlayer_metadataHandler(event:MetadataEvent) : void
      {
         resizeVideo();
         dispatchEvent(event.clone());
      }
      
      [Inspectable(category="General",defaultValue="0.75")]
      [Bindable("volumeChanged")]
      public function get volume() : Number
      {
         return Boolean(videoPlayer) ? videoPlayer.volume : _volume;
      }
      
      [Inspectable(category="General",defaultValue="null")]
      [Bindable("sourceChanged")]
      public function get source() : String
      {
         return _source;
      }
      
      private function get ncManagerClass() : Class
      {
         return _ncManagerClass != null ? _ncManagerClass : VideoPlayer.DEFAULT_INCMANAGER;
      }
      
      public function set progressInterval(value:int) : void
      {
         if(_progressInterval != value)
         {
            _progressInterval = value;
            if(Boolean(videoPlayer))
            {
               videoPlayer.progressInterval = value;
            }
         }
      }
      
      [Bindable("stateChange")]
      public function get stateResponsive() : Boolean
      {
         return Boolean(videoPlayer) ? videoPlayer.stateResponsive : true;
      }
      
      private function resizeVideo() : void
      {
         var vw:Number = videoPlayer.videoWidth;
         var vh:Number = videoPlayer.videoHeight;
         if(vw > 0 && vh > 0 && (measuredWidth != vw || measuredHeight != vh))
         {
            invalidateSize();
            invalidateDisplayList();
            makeVideoVisibleOnLayout = true;
         }
      }
      
      [Inspectable(category="General",defaultValue="0.1")]
      [Bindable("bufferTimeChanged")]
      public function get bufferTime() : Number
      {
         return _bufferTime;
      }
      
      [Bindable("metadataReceived")]
      public function get metadata() : Object
      {
         return videoPlayer != null ? videoPlayer.metadata : null;
      }
      
      [Inspectable(defaultValue="NaN")]
      [Bindable("metadataReceived")]
      [Bindable("totalTimeUpdated")]
      [Bindable("complete")]
      public function get totalTime() : Number
      {
         if(!isNaN(_totalTime))
         {
            return _totalTime;
         }
         return videoPlayer != null ? videoPlayer.totalTime : NaN;
      }
      
      public function set volume(value:Number) : void
      {
         if(_volume != value)
         {
            _volume = value;
            if(Boolean(videoPlayer))
            {
               videoPlayer.volume = value;
            }
            dispatchEvent(new Event("volumeChanged"));
         }
      }
      
      [Bindable("stateChange")]
      public function get playing() : Boolean
      {
         return videoPlayer != null && videoPlayer.state == VideoPlayer.PLAYING;
      }
      
      public function set source(value:String) : void
      {
         if(_source != value)
         {
            _source = value;
            _playheadTime = NaN;
            sourceChanged = true;
            dispatchEvent(new Event("sourceChanged"));
            if(_autoPlay && creationCompleted)
            {
               autoPlaying();
            }
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         createBorder();
         createVideoPlayer();
      }
      
      private function set ncManagerClass(value:Class) : void
      {
         _ncManagerClass = value;
      }
      
      public function play() : void
      {
         if(!videoPlayer)
         {
            createVideoPlayer();
         }
         if(videoPlayer.playheadTime >= 0)
         {
            asCuePointIndexResetPending = true;
         }
         if(sourceChanged || closeCalled)
         {
            sourceChanged = false;
            closeCalled = false;
            videoPlayer.play(getActualURL(_source),_live,isNaN(_totalTime) ? -1 : _totalTime);
         }
         else
         {
            videoPlayer.play(null,_live,isNaN(_totalTime) ? -1 : _totalTime);
         }
      }
      
      protected function layoutChrome(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         if(Boolean(border))
         {
            border.move(0,0);
            border.setActualSize(unscaledWidth,unscaledHeight);
         }
      }
      
      protected function createBorder() : void
      {
         var borderClass:Class = null;
         if(!border && isBorderNeeded())
         {
            borderClass = getStyle("borderSkin");
            border = new borderClass();
            if(border is IUIComponent)
            {
               IUIComponent(border).enabled = enabled;
            }
            if(border is ISimpleStyleClient)
            {
               ISimpleStyleClient(border).styleName = this;
            }
            addChildAt(DisplayObject(border),0);
            invalidateDisplayList();
         }
      }
      
      [Inspectable(category="General",defaultValue="true")]
      [Bindable("autoRewindChanged")]
      public function get autoRewind() : Boolean
      {
         return _autoRewind;
      }
      
      private function videoPlayer_rewindHandler(event:VideoEvent) : void
      {
         dispatchEvent(event.clone());
      }
      
      [Bindable("progress")]
      [Bindable("complete")]
      public function get bytesLoaded() : int
      {
         if(Boolean(videoPlayer))
         {
            return videoPlayer.bytesLoaded;
         }
         return -1;
      }
      
      private function videoPlayer_readyHandler(event:VideoEvent) : void
      {
         resizeVideo();
         dispatchEvent(event.clone());
      }
      
      private function getActualURL(url:String) : String
      {
         var rootURL:String = null;
         var lastIndex:int = 0;
         if(!(url.indexOf(":") > -1 || url.indexOf("/") == 0 || url.indexOf("\\") == 0))
         {
            if(Boolean(root))
            {
               rootURL = LoaderUtil.normalizeURL(root.loaderInfo);
            }
            else if(Boolean(systemManager))
            {
               rootURL = LoaderUtil.normalizeURL(DisplayObject(systemManager).loaderInfo);
            }
            if(Boolean(rootURL))
            {
               lastIndex = Math.max(rootURL.lastIndexOf("\\"),rootURL.lastIndexOf("/"));
               if(lastIndex != -1)
               {
                  url = rootURL.substr(0,lastIndex + 1) + url;
               }
            }
         }
         return url;
      }
      
      private function videoPlayer_stateChangeHandler(event:VideoEvent) : void
      {
         if(videoPlayer.state == VideoPlayer.PLAYING)
         {
            resizeVideo();
         }
         if(event.state == VideoEvent.CONNECTION_ERROR)
         {
            this.close();
         }
         dispatchEvent(event.clone());
      }
      
      public function set bufferTime(value:Number) : void
      {
         if(_bufferTime != value)
         {
            _bufferTime = value;
            if(Boolean(videoPlayer))
            {
               videoPlayer.bufferTime = value;
            }
            dispatchEvent(new Event("bufferTimeChanged"));
         }
      }
      
      override protected function measure() : void
      {
         var vh:Number = NaN;
         super.measure();
         var vw:Number = videoPlayer.videoWidth;
         vh = videoPlayer.videoHeight;
         measuredWidth = Math.max(vw,DEFAULT_WIDTH);
         measuredHeight = Math.max(vh,DEFAULT_HEIGHT);
         var bExplicitWidth:Boolean = !isNaN(explicitWidth);
         var bExplicitHeight:Boolean = !isNaN(explicitHeight);
         if(_maintainAspectRatio && (bExplicitWidth || bExplicitHeight))
         {
            if(bExplicitWidth && !bExplicitHeight && vw > 0)
            {
               measuredHeight = explicitWidth * vh / vw;
            }
            else if(bExplicitHeight && !bExplicitWidth && vh > 0)
            {
               measuredWidth = explicitHeight * vw / vh;
            }
         }
         measuredMinWidth = DEFAULT_WIDTH;
         measuredMinHeight = DEFAULT_HEIGHT;
      }
      
      private function videoPlayer_progressHandler(event:ProgressEvent) : void
      {
         dispatchEvent(event.clone());
      }
      
      public function set totalTime(value:Number) : void
      {
         if(_totalTime != value)
         {
            _totalTime = value;
            dispatchEvent(new Event("totalTimeUpdated"));
         }
      }
      
      private function isBorderNeeded() : Boolean
      {
         var v:Object = getStyle("borderStyle");
         if(Boolean(v))
         {
            if(v != "none" || Boolean(v == "none") && Boolean(getStyle("mouseShield")))
            {
               return true;
            }
         }
         v = getStyle("backgroundColor");
         if(v !== null && v !== "")
         {
            return true;
         }
         v = getStyle("backgroundImage");
         return v != null && v != "";
      }
      
      private function videoPlayer_cuePointHandler(event:MetadataEvent) : void
      {
         var info:Object = event.info;
         var cuePointEvent:CuePointEvent = new CuePointEvent(CuePointEvent.CUE_POINT);
         cuePointEvent.cuePointName = info.name;
         cuePointEvent.cuePointTime = info.time;
         cuePointEvent.cuePointType = info.type;
         dispatchEvent(cuePointEvent);
      }
      
      private function autoPlaying() : void
      {
         if(Boolean(_source))
         {
            if(_autoPlay)
            {
               play();
            }
            else
            {
               load();
            }
            if(!isNaN(_playheadTime))
            {
               asCuePointIndexResetPending = Boolean(_playheadTime >= 0);
               videoPlayer.seek(_playheadTime);
            }
         }
      }
      
      [Bindable("resize")]
      public function get videoHeight() : int
      {
         return Boolean(videoPlayer) ? videoPlayer.videoHeight : -1;
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get autoPlay() : Boolean
      {
         return _autoPlay;
      }
      
      public function get cuePointManagerClass() : Class
      {
         return _cuePointManagerClass;
      }
      
      public function set autoRewind(value:Boolean) : void
      {
         if(_autoRewind != value)
         {
            _autoRewind = value;
            if(Boolean(videoPlayer))
            {
               videoPlayer.autoRewind = value;
            }
            dispatchEvent(new Event("autoRewindChanged"));
         }
      }
      
      [Bindable("progress")]
      [Bindable("complete")]
      public function get bytesTotal() : int
      {
         if(Boolean(videoPlayer))
         {
            return videoPlayer.bytesTotal;
         }
         return -1;
      }
      
      [Bindable("stateChange")]
      public function get state() : String
      {
         return Boolean(videoPlayer) ? videoPlayer.state : VideoPlayer.DISCONNECTED;
      }
      
      private function createVideoPlayer() : void
      {
         videoPlayer = new VideoPlayer(10,10,_ncManagerClass);
         addChild(videoPlayer);
         videoPlayer.visible = false;
         videoPlayer.autoBandWidthDetection = _autoBandWidthDetection;
         videoPlayer.autoRewind = _autoRewind;
         videoPlayer.bufferTime = _bufferTime;
         videoPlayer.volume = _volume;
         if(_idleTimeout != -1)
         {
            videoPlayer.idleTimeout = _idleTimeout;
         }
         if(_playheadUpdateInterval != -1)
         {
            videoPlayer.playheadUpdateInterval = _playheadUpdateInterval;
         }
         if(_progressInterval != -1)
         {
            videoPlayer.progressInterval = _progressInterval;
         }
         videoPlayer.addEventListener(VideoEvent.PLAYHEAD_UPDATE,videoPlayer_playheadUpdateHandler);
         videoPlayer.addEventListener(VideoEvent.COMPLETE,videoPlayer_completeHandler);
         videoPlayer.addEventListener(MetadataEvent.CUE_POINT,videoPlayer_cuePointHandler);
         videoPlayer.addEventListener(MetadataEvent.METADATA_RECEIVED,videoPlayer_metadataHandler);
         videoPlayer.addEventListener(ProgressEvent.PROGRESS,videoPlayer_progressHandler);
         videoPlayer.addEventListener(VideoEvent.READY,videoPlayer_readyHandler);
         videoPlayer.addEventListener(VideoEvent.REWIND,videoPlayer_rewindHandler);
         videoPlayer.addEventListener(VideoEvent.STATE_CHANGE,videoPlayer_stateChangeHandler);
         if(Boolean(cuePointManagerClass))
         {
            _cuePointManager = new cuePointManagerClass(videoPlayer);
            _cuePointManager.videoDisplay = this;
         }
         if(Boolean(_cuePoints))
         {
            setCuePoints(_cuePoints);
         }
      }
      
      private function setCuePoints(cuePoints:Array) : void
      {
         if(Boolean(_cuePointManager))
         {
            _cuePointManager.setCuePoints(cuePoints);
         }
         _cuePoints = null;
         dispatchEvent(new Event("cuePointsChanged"));
      }
      
      public function attachCamera(camera:Camera) : void
      {
         if(!videoPlayer)
         {
            createVideoPlayer();
         }
         videoPlayer.attachCamera(camera);
         videoPlayer.visible = true;
      }
      
      public function get cuePointManager() : Object
      {
         return _cuePointManager;
      }
      
      private function videoPlayer_playheadUpdateHandler(event:VideoEvent) : void
      {
         dispatchEvent(event.clone());
         if(Boolean(_cuePointManager))
         {
            if(asCuePointIndexResetPending && videoPlayer.state != VideoPlayer.SEEKING)
            {
               asCuePointIndexResetPending = false;
               _cuePointManager.resetCuePointIndex(event.playheadTime);
            }
            _cuePointManager.dispatchCuePoints();
         }
      }
      
      public function set playheadUpdateInterval(value:int) : void
      {
         if(_playheadUpdateInterval != value)
         {
            _playheadUpdateInterval = value;
            if(Boolean(videoPlayer))
            {
               videoPlayer.playheadUpdateInterval = value;
            }
         }
      }
      
      private function videoPlayer_completeHandler(event:VideoEvent) : void
      {
         dispatchEvent(event.clone());
      }
      
      public function set live(value:Boolean) : void
      {
         _live = value;
      }
      
      public function set idleTimeout(value:int) : void
      {
         if(_idleTimeout != value)
         {
            _idleTimeout = value;
            if(Boolean(videoPlayer))
            {
               videoPlayer.idleTimeout = value;
            }
         }
      }
      
      public function load() : void
      {
         if(!videoPlayer)
         {
            createVideoPlayer();
         }
         if(sourceChanged)
         {
            sourceChanged = false;
            videoPlayer.load(getActualURL(_source),false,isNaN(_totalTime) ? -1 : _totalTime);
         }
      }
      
      public function set cuePoints(value:Array) : void
      {
         _cuePoints = value;
         if(Boolean(_cuePointManager))
         {
            setCuePoints(value);
         }
      }
      
      [Inspectable(defaultValue="300000")]
      public function get idleTimeout() : int
      {
         if(Boolean(videoPlayer))
         {
            return videoPlayer.idleTimeout;
         }
         return _idleTimeout == -1 ? int(VideoPlayer.DEFAULT_IDLE_TIMEOUT_INTERVAL) : _idleTimeout;
      }
      
      [Inspectable(defaultValue="250")]
      public function get playheadUpdateInterval() : int
      {
         if(Boolean(videoPlayer))
         {
            return videoPlayer.playheadUpdateInterval;
         }
         return _playheadUpdateInterval == -1 ? int(VideoPlayer.DEFAULT_UPDATE_TIME_INTERVAL) : _playheadUpdateInterval;
      }
      
      private function creationCompleteHandler(event:FlexEvent) : void
      {
         removeEventListener(FlexEvent.CREATION_COMPLETE,creationCompleteHandler);
         creationCompleted = true;
         autoPlaying();
      }
      
      [Inspectable(category="General",defaultValue="false")]
      public function get live() : Boolean
      {
         return _live;
      }
      
      public function pause() : void
      {
         if(!videoPlayer)
         {
            return;
         }
         videoPlayer.pause();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var rw:Number = NaN;
         var rh:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         layoutChrome(unscaledWidth,unscaledHeight);
         if(!videoPlayer)
         {
            return;
         }
         var bm:EdgeMetrics = borderMetrics;
         var x:Number = bm.left;
         var y:Number = bm.top;
         var w:Number = unscaledWidth - bm.left - bm.right;
         var h:Number = unscaledHeight - bm.top - bm.bottom;
         var vw:Number = videoPlayer.videoWidth;
         var vh:Number = videoPlayer.videoHeight;
         if(_maintainAspectRatio && vw > 0 && vh > 0)
         {
            rw = w / vw;
            rh = h / vh;
            if(rw < rh)
            {
               h = w * vh / vw;
               y = (unscaledHeight - h) / 2;
            }
            else if(rh < rw)
            {
               w = h * vw / vh;
               x = (unscaledWidth - w) / 2;
            }
         }
         videoPlayer.x = x;
         videoPlayer.y = y;
         videoPlayer.setSize(w,h);
         if(makeVideoVisibleOnLayout)
         {
            makeVideoVisibleOnLayout = false;
            videoPlayer.visible = true;
         }
      }
      
      public function close() : void
      {
         if(!videoPlayer)
         {
            return;
         }
         videoPlayer.close();
         closeCalled = true;
      }
      
      [Inspectable(defaultValue="null")]
      [Bindable("cuePointsChanged")]
      public function get cuePoints() : Array
      {
         if(!_cuePointManager)
         {
            return _cuePoints;
         }
         return _cuePointManager.getCuePoints();
      }
      
      public function get borderMetrics() : EdgeMetrics
      {
         return Boolean(border) && border is IRectangularBorder ? IRectangularBorder(border).borderMetrics : EdgeMetrics.EMPTY;
      }
   }
}

