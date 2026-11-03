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
   import mx.events.CuePointEvent;
   import mx.events.FlexEvent;
   import mx.events.MetadataEvent;
   import mx.events.VideoEvent;
   import mx.styles.ISimpleStyleClient;
   import mx.utils.LoaderUtil;
   
   [Alternative(replacement="spark.components.VideoPlayer",since="4.0")]
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
   [Style(name="cornerRadius",type="Number",format="Length",inherit="no",theme="halo")]
   [Style(name="contentBackgroundColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="contentBackgroundAlpha",type="Number",inherit="yes",theme="spark",minValue="0.0",maxValue="1.0")]
   [Style(name="shadowDistance",type="Number",format="Length",inherit="no",theme="halo")]
   [Style(name="shadowDirection",type="String",enumeration="left,center,right",inherit="no",theme="halo")]
   [Style(name="dropShadowColor",type="uint",format="Color",inherit="yes",theme="halo")]
   [Style(name="dropShadowVisible",type="Boolean",inherit="no",theme="spark")]
   [Style(name="dropShadowEnabled",type="Boolean",inherit="no",theme="halo")]
   [Style(name="borderVisible",type="Boolean",inherit="no",theme="spark")]
   [Style(name="borderThickness",type="Number",format="Length",inherit="no",theme="halo")]
   [Style(name="borderStyle",type="String",enumeration="inset,outset,solid,none",inherit="no")]
   [Style(name="borderSkin",type="Class",inherit="no")]
   [Style(name="borderSides",type="String",inherit="no",theme="halo")]
   [Style(name="borderColor",type="uint",format="Color",inherit="no",theme="halo, spark")]
   [Style(name="borderAlpha",type="Number",inherit="no",theme="spark")]
   [Style(name="backgroundSize",type="String",inherit="no",theme="halo")]
   [Style(name="backgroundImage",type="Object",format="File",inherit="no",theme="halo")]
   [Style(name="backgroundDisabledColor",type="uint",format="Color",inherit="yes",theme="halo")]
   [Style(name="backgroundColor",type="uint",format="Color",inherit="no",theme="halo")]
   [Style(name="backgroundAlpha",type="Number",inherit="no",theme="halo")]
   public class VideoDisplay extends UIComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const DEFAULT_WIDTH:Number = 10;
      
      private static const DEFAULT_HEIGHT:Number = 10;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var videoPlayer:VideoPlayer = null;
      
      private var _cuePointManager:Object = null;
      
      private var sourceChanged:Boolean = false;
      
      private var closeCalled:Boolean = false;
      
      private var makeVideoVisibleOnLayout:Boolean = false;
      
      protected var border:IFlexDisplayObject;
      
      private var asCuePointIndexResetPending:Boolean = false;
      
      private var creationCompleted:Boolean = false;
      
      private var _autoBandWidthDetection:Boolean = false;
      
      private var _autoRewind:Boolean = true;
      
      private var _bufferTime:Number = 0.1;
      
      private var _autoPlay:Boolean = true;
      
      private var _cuePointManagerClass:Class = null;
      
      private var _cuePoints:Array = null;
      
      private var _idleTimeout:int = -1;
      
      private var _live:Boolean = false;
      
      private var _maintainAspectRatio:Boolean = true;
      
      private var _ncManagerClass:Class = null;
      
      private var _playheadTime:Number = NaN;
      
      private var _playheadUpdateInterval:int = -1;
      
      private var _progressInterval:int = -1;
      
      private var _totalTime:Number = NaN;
      
      private var _source:String = null;
      
      private var _volume:Number = 0.75;
      
      public function VideoDisplay()
      {
         super();
         addEventListener(FlexEvent.CREATION_COMPLETE,this.creationCompleteHandler);
      }
      
      [Inspectable(defaultValue="false")]
      [Bindable("autoBandWidthDetection")]
      public function get autoBandWidthDetection() : Boolean
      {
         return this._autoBandWidthDetection;
      }
      
      public function set autoBandWidthDetection(value:Boolean) : void
      {
         if(this._autoBandWidthDetection != value)
         {
            this._autoBandWidthDetection = value;
            if(Boolean(this.videoPlayer))
            {
               this.videoPlayer.autoBandWidthDetection = value;
            }
            dispatchEvent(new Event("autoBandWidthDetectionChanged"));
         }
      }
      
      [Inspectable(category="General",defaultValue="true")]
      [Bindable("autoRewindChanged")]
      public function get autoRewind() : Boolean
      {
         return this._autoRewind;
      }
      
      public function set autoRewind(value:Boolean) : void
      {
         if(this._autoRewind != value)
         {
            this._autoRewind = value;
            if(Boolean(this.videoPlayer))
            {
               this.videoPlayer.autoRewind = value;
            }
            dispatchEvent(new Event("autoRewindChanged"));
         }
      }
      
      public function get borderMetrics() : EdgeMetrics
      {
         return Boolean(this.border) && this.border is IRectangularBorder ? IRectangularBorder(this.border).borderMetrics : EdgeMetrics.EMPTY;
      }
      
      [Inspectable(category="General",defaultValue="0.1")]
      [Bindable("bufferTimeChanged")]
      public function get bufferTime() : Number
      {
         return this._bufferTime;
      }
      
      public function set bufferTime(value:Number) : void
      {
         if(this._bufferTime != value)
         {
            this._bufferTime = value;
            if(Boolean(this.videoPlayer))
            {
               this.videoPlayer.bufferTime = value;
            }
            dispatchEvent(new Event("bufferTimeChanged"));
         }
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get autoPlay() : Boolean
      {
         return this._autoPlay;
      }
      
      public function set autoPlay(value:Boolean) : void
      {
         this._autoPlay = value;
      }
      
      [Bindable("progress")]
      [Bindable("complete")]
      public function get bytesLoaded() : int
      {
         if(Boolean(this.videoPlayer))
         {
            return this.videoPlayer.bytesLoaded;
         }
         return -1;
      }
      
      [Bindable("progress")]
      [Bindable("complete")]
      public function get bytesTotal() : int
      {
         if(Boolean(this.videoPlayer))
         {
            return this.videoPlayer.bytesTotal;
         }
         return -1;
      }
      
      public function get cuePointManager() : Object
      {
         return this._cuePointManager;
      }
      
      public function get cuePointManagerClass() : Class
      {
         return this._cuePointManagerClass;
      }
      
      public function set cuePointManagerClass(value:Class) : void
      {
         this._cuePointManagerClass = value;
      }
      
      [Inspectable(defaultValue="null")]
      [Bindable("cuePointsChanged")]
      public function get cuePoints() : Array
      {
         if(!this._cuePointManager)
         {
            return this._cuePoints;
         }
         return this._cuePointManager.getCuePoints();
      }
      
      public function set cuePoints(value:Array) : void
      {
         this._cuePoints = value;
         if(Boolean(this._cuePointManager))
         {
            this.setCuePoints(value);
         }
      }
      
      [Inspectable(defaultValue="300000")]
      public function get idleTimeout() : int
      {
         if(Boolean(this.videoPlayer))
         {
            return this.videoPlayer.idleTimeout;
         }
         return this._idleTimeout == -1 ? int(VideoPlayer.DEFAULT_IDLE_TIMEOUT_INTERVAL) : this._idleTimeout;
      }
      
      public function set idleTimeout(value:int) : void
      {
         if(this._idleTimeout != value)
         {
            this._idleTimeout = value;
            if(Boolean(this.videoPlayer))
            {
               this.videoPlayer.idleTimeout = value;
            }
         }
      }
      
      [Inspectable(category="General",defaultValue="false")]
      public function get live() : Boolean
      {
         return this._live;
      }
      
      public function set live(value:Boolean) : void
      {
         this._live = value;
      }
      
      [Inspectable(defaultValue="true")]
      [Bindable("maintainAspectRatioChanged")]
      public function get maintainAspectRatio() : Boolean
      {
         return this._maintainAspectRatio;
      }
      
      public function set maintainAspectRatio(value:Boolean) : void
      {
         if(this._maintainAspectRatio != value)
         {
            this._maintainAspectRatio = value;
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("maintainAspectRatioChanged"));
         }
      }
      
      [Bindable("metadataReceived")]
      public function get metadata() : Object
      {
         return this.videoPlayer != null ? this.videoPlayer.metadata : null;
      }
      
      private function get ncManagerClass() : Class
      {
         return this._ncManagerClass != null ? this._ncManagerClass : VideoPlayer.DEFAULT_INCMANAGER;
      }
      
      private function set ncManagerClass(value:Class) : void
      {
         this._ncManagerClass = value;
      }
      
      [Inspectable(defaultValue="0")]
      [Bindable("playheadUpdate")]
      [Bindable("playheadTimeChanged")]
      [Bindable("change")]
      public function get playheadTime() : Number
      {
         return this.videoPlayer != null ? this.videoPlayer.playheadTime : this._playheadTime;
      }
      
      public function set playheadTime(value:Number) : void
      {
         this._playheadTime = value;
         this.asCuePointIndexResetPending = true;
         if(Boolean(this.videoPlayer))
         {
            this.videoPlayer.playheadTime = value;
            dispatchEvent(new Event("playheadTimeChanged"));
         }
      }
      
      [Inspectable(defaultValue="250")]
      public function get playheadUpdateInterval() : int
      {
         if(Boolean(this.videoPlayer))
         {
            return this.videoPlayer.playheadUpdateInterval;
         }
         return this._playheadUpdateInterval == -1 ? int(VideoPlayer.DEFAULT_UPDATE_TIME_INTERVAL) : this._playheadUpdateInterval;
      }
      
      public function set playheadUpdateInterval(value:int) : void
      {
         if(this._playheadUpdateInterval != value)
         {
            this._playheadUpdateInterval = value;
            if(Boolean(this.videoPlayer))
            {
               this.videoPlayer.playheadUpdateInterval = value;
            }
         }
      }
      
      [Bindable("stateChange")]
      public function get playing() : Boolean
      {
         return this.videoPlayer != null && this.videoPlayer.state == VideoPlayer.PLAYING;
      }
      
      [Inspectable(defaultValue="250")]
      public function get progressInterval() : int
      {
         if(Boolean(this.videoPlayer))
         {
            return this.videoPlayer.progressInterval;
         }
         return this._progressInterval == -1 ? int(VideoPlayer.DEFAULT_UPDATE_PROGRESS_INTERVAL) : this._progressInterval;
      }
      
      public function set progressInterval(value:int) : void
      {
         if(this._progressInterval != value)
         {
            this._progressInterval = value;
            if(Boolean(this.videoPlayer))
            {
               this.videoPlayer.progressInterval = value;
            }
         }
      }
      
      [Bindable("stateChange")]
      public function get state() : String
      {
         return Boolean(this.videoPlayer) ? this.videoPlayer.state : VideoPlayer.DISCONNECTED;
      }
      
      [Bindable("stateChange")]
      public function get stateResponsive() : Boolean
      {
         return Boolean(this.videoPlayer) ? this.videoPlayer.stateResponsive : true;
      }
      
      [Inspectable(defaultValue="NaN")]
      [Bindable("metadataReceived")]
      [Bindable("totalTimeUpdated")]
      [Bindable("complete")]
      public function get totalTime() : Number
      {
         if(!isNaN(this._totalTime))
         {
            return this._totalTime;
         }
         return this.videoPlayer != null ? this.videoPlayer.totalTime : NaN;
      }
      
      public function set totalTime(value:Number) : void
      {
         if(this._totalTime != value)
         {
            this._totalTime = value;
            dispatchEvent(new Event("totalTimeUpdated"));
         }
      }
      
      [Inspectable(category="General",defaultValue="null")]
      [Bindable("sourceChanged")]
      public function get source() : String
      {
         return this._source;
      }
      
      public function set source(value:String) : void
      {
         if(this._source != value)
         {
            this._source = value;
            this._playheadTime = NaN;
            this.sourceChanged = true;
            dispatchEvent(new Event("sourceChanged"));
            if(this._autoPlay && this.creationCompleted)
            {
               this.autoPlaying();
            }
         }
      }
      
      [Bindable("resize")]
      public function get videoHeight() : int
      {
         return Boolean(this.videoPlayer) ? this.videoPlayer.videoHeight : -1;
      }
      
      [Bindable("resize")]
      public function get videoWidth() : int
      {
         return Boolean(this.videoPlayer) ? this.videoPlayer.videoWidth : -1;
      }
      
      [Inspectable(category="General",defaultValue="0.75")]
      [Bindable("volumeChanged")]
      public function get volume() : Number
      {
         return Boolean(this.videoPlayer) ? this.videoPlayer.volume : this._volume;
      }
      
      public function set volume(value:Number) : void
      {
         if(this._volume != value)
         {
            this._volume = value;
            if(Boolean(this.videoPlayer))
            {
               this.videoPlayer.volume = value;
            }
            dispatchEvent(new Event("volumeChanged"));
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.createBorder();
         this.createVideoPlayer();
      }
      
      override protected function measure() : void
      {
         var vh:Number = NaN;
         super.measure();
         var vw:Number = this.videoPlayer.videoWidth;
         vh = this.videoPlayer.videoHeight;
         measuredWidth = Math.max(vw,DEFAULT_WIDTH);
         measuredHeight = Math.max(vh,DEFAULT_HEIGHT);
         var bExplicitWidth:Boolean = !isNaN(explicitWidth);
         var bExplicitHeight:Boolean = !isNaN(explicitHeight);
         if(this._maintainAspectRatio && (bExplicitWidth || bExplicitHeight))
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
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var rw:Number = NaN;
         var rh:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         this.layoutChrome(unscaledWidth,unscaledHeight);
         if(!this.videoPlayer)
         {
            return;
         }
         var bm:EdgeMetrics = this.borderMetrics;
         var x:Number = Number(bm.left);
         var y:Number = Number(bm.top);
         var w:Number = unscaledWidth - bm.left - bm.right;
         var h:Number = unscaledHeight - bm.top - bm.bottom;
         var vw:Number = this.videoPlayer.videoWidth;
         var vh:Number = this.videoPlayer.videoHeight;
         if(this._maintainAspectRatio && vw > 0 && vh > 0)
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
         this.videoPlayer.x = x;
         this.videoPlayer.y = y;
         this.videoPlayer.setSize(w,h);
         if(this.makeVideoVisibleOnLayout)
         {
            this.makeVideoVisibleOnLayout = false;
            this.videoPlayer.visible = true;
         }
      }
      
      public function attachCamera(camera:Camera) : void
      {
         if(!this.videoPlayer)
         {
            this.createVideoPlayer();
         }
         this.videoPlayer.attachCamera(camera);
         this.videoPlayer.visible = true;
      }
      
      public function close() : void
      {
         if(!this.videoPlayer)
         {
            return;
         }
         this.videoPlayer.close();
         this.closeCalled = true;
      }
      
      public function load() : void
      {
         if(!this.videoPlayer)
         {
            this.createVideoPlayer();
         }
         if(this.sourceChanged)
         {
            this.sourceChanged = false;
            this.videoPlayer.load(this.getActualURL(this._source),false,isNaN(this._totalTime) ? -1 : this._totalTime);
         }
      }
      
      public function pause() : void
      {
         if(!this.videoPlayer)
         {
            return;
         }
         this.videoPlayer.pause();
      }
      
      public function play() : void
      {
         if(!this.videoPlayer)
         {
            this.createVideoPlayer();
         }
         if(this.videoPlayer.playheadTime >= 0)
         {
            this.asCuePointIndexResetPending = true;
         }
         if(this.sourceChanged || this.closeCalled)
         {
            this.sourceChanged = false;
            this.closeCalled = false;
            this.videoPlayer.play(this.getActualURL(this._source),this._live,isNaN(this._totalTime) ? -1 : this._totalTime);
         }
         else
         {
            this.videoPlayer.play(null,this._live,isNaN(this._totalTime) ? -1 : this._totalTime);
         }
      }
      
      public function stop() : void
      {
         if(!this.videoPlayer)
         {
            return;
         }
         this.videoPlayer.stop();
      }
      
      protected function layoutChrome(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         if(Boolean(this.border))
         {
            this.border.move(0,0);
            this.border.setActualSize(unscaledWidth,unscaledHeight);
         }
      }
      
      protected function createBorder() : void
      {
         var borderClass:Class = null;
         if(!this.border && this.isBorderNeeded())
         {
            borderClass = getStyle("borderSkin");
            this.border = new borderClass();
            if(this.border is IUIComponent)
            {
               IUIComponent(this.border).enabled = enabled;
            }
            if(this.border is ISimpleStyleClient)
            {
               ISimpleStyleClient(this.border).styleName = this;
            }
            addChildAt(DisplayObject(this.border),0);
            invalidateDisplayList();
         }
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
         v = getStyle("contentBackgroundColor");
         if(v !== null && v !== "")
         {
            return true;
         }
         v = getStyle("backgroundColor");
         if(v !== null && v !== "")
         {
            return true;
         }
         v = getStyle("backgroundImage");
         return v != null && v != "";
      }
      
      private function createVideoPlayer() : void
      {
         this.videoPlayer = new VideoPlayer(10,10,this._ncManagerClass);
         addChild(this.videoPlayer);
         this.videoPlayer.visible = false;
         this.videoPlayer.autoBandWidthDetection = this._autoBandWidthDetection;
         this.videoPlayer.autoRewind = this._autoRewind;
         this.videoPlayer.bufferTime = this._bufferTime;
         this.videoPlayer.volume = this._volume;
         if(this._idleTimeout != -1)
         {
            this.videoPlayer.idleTimeout = this._idleTimeout;
         }
         if(this._playheadUpdateInterval != -1)
         {
            this.videoPlayer.playheadUpdateInterval = this._playheadUpdateInterval;
         }
         if(this._progressInterval != -1)
         {
            this.videoPlayer.progressInterval = this._progressInterval;
         }
         this.videoPlayer.addEventListener(VideoEvent.PLAYHEAD_UPDATE,this.videoPlayer_playheadUpdateHandler);
         this.videoPlayer.addEventListener(VideoEvent.COMPLETE,this.videoPlayer_completeHandler);
         this.videoPlayer.addEventListener(MetadataEvent.CUE_POINT,this.videoPlayer_cuePointHandler);
         this.videoPlayer.addEventListener(MetadataEvent.METADATA_RECEIVED,this.videoPlayer_metadataHandler);
         this.videoPlayer.addEventListener(ProgressEvent.PROGRESS,this.videoPlayer_progressHandler);
         this.videoPlayer.addEventListener(VideoEvent.READY,this.videoPlayer_readyHandler);
         this.videoPlayer.addEventListener(VideoEvent.REWIND,this.videoPlayer_rewindHandler);
         this.videoPlayer.addEventListener(VideoEvent.STATE_CHANGE,this.videoPlayer_stateChangeHandler);
         if(Boolean(this.cuePointManagerClass))
         {
            this._cuePointManager = new this.cuePointManagerClass(this.videoPlayer);
            this._cuePointManager.videoDisplay = this;
         }
         if(Boolean(this._cuePoints))
         {
            this.setCuePoints(this._cuePoints);
         }
      }
      
      private function autoPlaying() : void
      {
         if(Boolean(this._source))
         {
            if(this._autoPlay)
            {
               this.play();
            }
            else
            {
               this.load();
            }
            if(!isNaN(this._playheadTime))
            {
               this.asCuePointIndexResetPending = Boolean(this._playheadTime >= 0);
               this.videoPlayer.seek(this._playheadTime);
            }
         }
      }
      
      private function resizeVideo() : void
      {
         var vw:Number = this.videoPlayer.videoWidth;
         var vh:Number = this.videoPlayer.videoHeight;
         if(vw > 0 && vh > 0 && (measuredWidth != vw || measuredHeight != vh))
         {
            invalidateSize();
            invalidateDisplayList();
            this.makeVideoVisibleOnLayout = true;
         }
      }
      
      private function setCuePoints(cuePoints:Array) : void
      {
         if(Boolean(this._cuePointManager))
         {
            this._cuePointManager.setCuePoints(cuePoints);
         }
         this._cuePoints = null;
         dispatchEvent(new Event("cuePointsChanged"));
      }
      
      private function creationCompleteHandler(event:FlexEvent) : void
      {
         removeEventListener(FlexEvent.CREATION_COMPLETE,this.creationCompleteHandler);
         this.creationCompleted = true;
         this.autoPlaying();
      }
      
      private function videoPlayer_playheadUpdateHandler(event:VideoEvent) : void
      {
         dispatchEvent(event.clone());
         if(Boolean(this._cuePointManager))
         {
            if(this.asCuePointIndexResetPending && this.videoPlayer.state != VideoPlayer.SEEKING)
            {
               this.asCuePointIndexResetPending = false;
               this._cuePointManager.resetCuePointIndex(event.playheadTime);
            }
            this._cuePointManager.dispatchCuePoints();
         }
      }
      
      private function videoPlayer_completeHandler(event:VideoEvent) : void
      {
         dispatchEvent(event.clone());
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
      
      private function videoPlayer_metadataHandler(event:MetadataEvent) : void
      {
         this.resizeVideo();
         dispatchEvent(event.clone());
      }
      
      private function videoPlayer_progressHandler(event:ProgressEvent) : void
      {
         dispatchEvent(event.clone());
      }
      
      private function videoPlayer_readyHandler(event:VideoEvent) : void
      {
         this.resizeVideo();
         dispatchEvent(event.clone());
      }
      
      private function videoPlayer_rewindHandler(event:VideoEvent) : void
      {
         dispatchEvent(event.clone());
      }
      
      private function videoPlayer_stateChangeHandler(event:VideoEvent) : void
      {
         if(this.videoPlayer.state == VideoPlayer.PLAYING)
         {
            this.resizeVideo();
         }
         if(event.state == VideoEvent.CONNECTION_ERROR)
         {
            this.close();
         }
         dispatchEvent(event.clone());
      }
   }
}

