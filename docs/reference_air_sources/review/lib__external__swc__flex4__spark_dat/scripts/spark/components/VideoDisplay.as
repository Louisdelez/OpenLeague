package spark.components
{
   import flash.events.Event;
   import flash.geom.Point;
   import flash.media.Video;
   import mx.core.IUIComponent;
   import mx.core.IVisualElement;
   import mx.core.UIComponent;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import org.osmf.containers.MediaContainer;
   import org.osmf.elements.VideoElement;
   import org.osmf.events.AudioEvent;
   import org.osmf.events.DisplayObjectEvent;
   import org.osmf.events.LoadEvent;
   import org.osmf.events.MediaPlayerCapabilityChangeEvent;
   import org.osmf.events.MediaPlayerStateChangeEvent;
   import org.osmf.events.SeekEvent;
   import org.osmf.events.TimeEvent;
   import org.osmf.layout.HorizontalAlign;
   import org.osmf.layout.LayoutMetadata;
   import org.osmf.layout.ScaleMode;
   import org.osmf.layout.VerticalAlign;
   import org.osmf.media.DefaultMediaFactory;
   import org.osmf.media.MediaElement;
   import org.osmf.media.MediaFactory;
   import org.osmf.media.MediaFactoryItem;
   import org.osmf.media.MediaPlayer;
   import org.osmf.media.MediaPlayerState;
   import org.osmf.media.MediaResourceBase;
   import org.osmf.media.MediaType;
   import org.osmf.media.URLResource;
   import org.osmf.net.DynamicStreamingItem;
   import org.osmf.net.DynamicStreamingResource;
   import org.osmf.net.rtmpstreaming.RTMPDynamicStreamingNetLoader;
   import org.osmf.utils.OSMFStrings;
   import org.osmf.utils.URL;
   import spark.components.mediaClasses.DynamicStreamingVideoItem;
   import spark.components.mediaClasses.DynamicStreamingVideoSource;
   import spark.primitives.BitmapImage;
   
   [DiscouragedForProfile("mobileDevice")]
   [IconFile("VideoDisplay.png")]
   [ResourceBundle("osmf")]
   [DefaultProperty("source")]
   [Event(name="mediaPlayerStateChange",type="org.osmf.events.MediaPlayerStateChangeEvent")]
   [Event(name="durationChange",type="org.osmf.events.TimeEvent")]
   [Event(name="currentTimeChange",type="org.osmf.events.TimeEvent")]
   [Event(name="complete",type="org.osmf.events.TimeEvent")]
   [Event(name="bytesLoadedChange",type="org.osmf.events.LoadEvent")]
   public class VideoDisplay extends UIComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var videoPlayer:MediaPlayer;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var videoContainer:MediaContainer;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var mediaFactory:MediaFactory;
      
      private var _isOnDisplayList:Boolean = false;
      
      private var playTheVideoOnVisible:Boolean = true;
      
      private var effectiveVisibility:Boolean = false;
      
      private var effectiveVisibilityChanged:Boolean = false;
      
      private var effectiveEnabled:Boolean = false;
      
      private var effectiveEnabledChanged:Boolean = false;
      
      private var initializedOnce:Boolean = false;
      
      private var beforeLoadMuted:Boolean;
      
      private var inLoadingState1:Boolean;
      
      private var inLoadingState2:Boolean;
      
      private var inLoadingState3:Boolean;
      
      private var oldCurrentTimeUpdateInterval:Number = NaN;
      
      private var oldBytesLoadedUpdateInterval:Number = NaN;
      
      private var _autoDisplayFirstFrame:Boolean = true;
      
      private var _autoPlay:Boolean = true;
      
      private var _pauseWhenHidden:Boolean = true;
      
      private var _scaleMode:String = "letterbox";
      
      private var _source:Object;
      
      private var sourceChanged:Boolean;
      
      private var _thumbnailSource:Object;
      
      private var thumbnailGroup:Group;
      
      private var thumbnailBitmapImage:BitmapImage;
      
      public function VideoDisplay()
      {
         super();
         this.createUnderlyingVideoPlayer();
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStageHandler);
         OSMFStrings.resourceStringFunction = getResourceString;
      }
      
      private static function getResourceString(resourceName:String, args:Array = null) : String
      {
         var resourceManager:IResourceManager = ResourceManager.getInstance();
         return resourceManager.getString("osmf",resourceName,args);
      }
      
      private static function getScaledSize(scaleMode:String, availableWidth:Number, availableHeight:Number, intrinsicWidth:Number, intrinsicHeight:Number) : Point
      {
         var result:Point = null;
         var availableRatio:Number = NaN;
         var componentRatio:Number = NaN;
         switch(scaleMode)
         {
            case ScaleMode.ZOOM:
            case ScaleMode.LETTERBOX:
               availableRatio = availableWidth / availableHeight;
               componentRatio = (intrinsicWidth || availableWidth) / (intrinsicHeight || availableHeight);
               if(scaleMode == ScaleMode.ZOOM && componentRatio < availableRatio || scaleMode == ScaleMode.LETTERBOX && componentRatio > availableRatio)
               {
                  result = new Point(availableWidth,availableWidth / componentRatio);
               }
               else
               {
                  result = new Point(availableHeight * componentRatio,availableHeight);
               }
               break;
            case ScaleMode.STRETCH:
               result = new Point(availableWidth,availableHeight);
               break;
            case ScaleMode.NONE:
               result = new Point(intrinsicWidth || availableWidth,intrinsicHeight || availableHeight);
         }
         return result;
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get autoDisplayFirstFrame() : Boolean
      {
         return this._autoDisplayFirstFrame;
      }
      
      public function set autoDisplayFirstFrame(value:Boolean) : void
      {
         this._autoDisplayFirstFrame = value;
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get autoPlay() : Boolean
      {
         return this._autoPlay;
      }
      
      public function set autoPlay(value:Boolean) : void
      {
         if(this.autoPlay == value)
         {
            return;
         }
         this._autoPlay = value;
         this.changePlayback(false,false);
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get autoRewind() : Boolean
      {
         return this.videoPlayer.autoRewind;
      }
      
      public function set autoRewind(value:Boolean) : void
      {
         this.videoPlayer.autoRewind = value;
      }
      
      [Bindable("mediaPlayerStateChange")]
      [Bindable("bytesLoadedChange")]
      [Inspectable(Category="General",defaultValue="0")]
      public function get bytesLoaded() : Number
      {
         return this.videoPlayer.bytesLoaded;
      }
      
      [Bindable("mediaPlayerStateChange")]
      [Inspectable(Category="General",defaultValue="0")]
      public function get bytesTotal() : Number
      {
         return this.videoPlayer.bytesTotal;
      }
      
      [Bindable("mediaPlayerStateChange")]
      [Bindable("currentTimeChange")]
      [Inspectable(Category="General",defaultValue="0")]
      public function get currentTime() : Number
      {
         return this.videoPlayer.currentTime;
      }
      
      [Bindable("mediaPlayerStateChange")]
      [Bindable("durationChange")]
      [Inspectable(Category="General",defaultValue="0")]
      public function get duration() : Number
      {
         return this.videoPlayer.duration;
      }
      
      [Inspectable(Category="General",defaultValue="false")]
      public function get loop() : Boolean
      {
         return this.videoPlayer.loop;
      }
      
      public function set loop(value:Boolean) : void
      {
         if(this.loop == value)
         {
            return;
         }
         this.videoPlayer.loop = value;
      }
      
      [Bindable("mediaPlayerStateChange")]
      [Inspectable(category="General",defaultValue="uninitialized")]
      public function get mediaPlayerState() : String
      {
         return this.videoPlayer.state;
      }
      
      [Bindable("volumeChanged")]
      [Inspectable(category="General",defaultValue="false")]
      public function get muted() : Boolean
      {
         if(this.inLoadingState2)
         {
            return this.beforeLoadMuted;
         }
         return this.videoPlayer.muted;
      }
      
      public function set muted(value:Boolean) : void
      {
         if(this.muted == value)
         {
            return;
         }
         if(this.inLoadingState2)
         {
            this.beforeLoadMuted = value;
            return;
         }
         this.videoPlayer.muted = value;
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get pauseWhenHidden() : Boolean
      {
         return this._pauseWhenHidden;
      }
      
      public function set pauseWhenHidden(value:Boolean) : void
      {
         if(this._pauseWhenHidden == value)
         {
            return;
         }
         this._pauseWhenHidden = value;
         if(this._pauseWhenHidden)
         {
            this.addVisibilityListeners();
            this.computeEffectiveVisibilityAndEnabled();
         }
         else
         {
            this.removeVisibilityListeners();
         }
         this.changePlayback(value,false);
      }
      
      [Bindable("mediaPlayerStateChange")]
      [Inspectable(category="General")]
      public function get playing() : Boolean
      {
         return this.videoPlayer.playing;
      }
      
      [Inspectable(Category="General",enumeration="none,stretch,letterbox,zoom",defaultValue="letterbox")]
      public function get scaleMode() : String
      {
         return this._scaleMode;
      }
      
      public function set scaleMode(value:String) : void
      {
         var layout:LayoutMetadata = null;
         if(this.scaleMode == value)
         {
            return;
         }
         switch(value)
         {
            case ScaleMode.NONE:
               this._scaleMode = ScaleMode.NONE;
               break;
            case ScaleMode.STRETCH:
               this._scaleMode = ScaleMode.STRETCH;
               break;
            case ScaleMode.LETTERBOX:
               this._scaleMode = ScaleMode.LETTERBOX;
               break;
            case ScaleMode.ZOOM:
               this._scaleMode = ScaleMode.ZOOM;
               break;
            default:
               this._scaleMode = ScaleMode.LETTERBOX;
         }
         if(Boolean(this.videoPlayer.media))
         {
            layout = this.videoPlayer.media.getMetadata(LayoutMetadata.LAYOUT_NAMESPACE) as LayoutMetadata;
            if(Boolean(layout))
            {
               layout.scaleMode = this._scaleMode;
            }
         }
         invalidateSize();
         invalidateDisplayList();
      }
      
      [Bindable("sourceChanged")]
      [Inspectable(category="General",defaultValue="null")]
      public function get source() : Object
      {
         return this._source;
      }
      
      public function set source(value:Object) : void
      {
         this._source = value;
         if(!this.initializedOnce)
         {
            this.sourceChanged = true;
            invalidateProperties();
         }
         else
         {
            this.setUpSource();
         }
         dispatchEvent(new Event("sourceChanged"));
      }
      
      [Inspectable(Category="General")]
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get thumbnailSource() : Object
      {
         return this._thumbnailSource;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set thumbnailSource(value:Object) : void
      {
         if(this._thumbnailSource == value)
         {
            return;
         }
         this._thumbnailSource = value;
         if(!this.initializedOnce)
         {
            this.sourceChanged = true;
            invalidateProperties();
         }
         else
         {
            this.setUpThumbnailSource();
         }
      }
      
      private function setUpThumbnailSource() : void
      {
         if(Boolean(this.thumbnailSource))
         {
            if(!this.thumbnailGroup)
            {
               this.thumbnailBitmapImage = new BitmapImage();
               this.thumbnailBitmapImage.includeInLayout = false;
               this.thumbnailGroup = new Group();
               addChild(this.thumbnailGroup);
               this.thumbnailGroup.clipAndEnableScrolling = true;
               this.thumbnailGroup.addElement(this.thumbnailBitmapImage);
            }
            if(!this.contains(this.thumbnailGroup))
            {
               addChild(this.thumbnailGroup);
            }
            this.thumbnailBitmapImage.source = this.thumbnailSource;
            invalidateSize();
            invalidateDisplayList();
         }
         else if(Boolean(this.thumbnailGroup))
         {
            if(Boolean(this.thumbnailBitmapImage))
            {
               this.thumbnailBitmapImage.source = null;
            }
            if(this.contains(this.thumbnailGroup))
            {
               removeChild(this.thumbnailGroup);
            }
            invalidateSize();
         }
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get videoObject() : Video
      {
         return this.videoPlayer.displayObject as Video;
      }
      
      [Bindable("volumeChanged")]
      [Inspectable(category="General",defaultValue="1.0",minValue="0.0",maxValue="1.0")]
      public function get volume() : Number
      {
         return this.videoPlayer.volume;
      }
      
      public function set volume(value:Number) : void
      {
         if(this.volume == value)
         {
            return;
         }
         this.videoPlayer.volume = value;
      }
      
      override protected function commitProperties() : void
      {
         var causePause:Boolean = false;
         var causePlay:Boolean = false;
         super.commitProperties();
         this.initializedOnce = true;
         if(this.effectiveVisibilityChanged || this.effectiveEnabledChanged)
         {
            this.computeEffectiveVisibilityAndEnabled();
            causePause = false;
            causePlay = false;
            if(this.effectiveVisibilityChanged && this.pauseWhenHidden)
            {
               causePause = !this.effectiveVisibility;
               causePlay = this.effectiveVisibility;
            }
            if(this.effectiveEnabledChanged)
            {
               if(!this.effectiveEnabled)
               {
                  causePause = true;
               }
            }
            this.changePlayback(causePause,causePlay);
            this.effectiveVisibilityChanged = false;
            this.effectiveEnabledChanged = false;
         }
         if(this.sourceChanged)
         {
            this.sourceChanged = false;
            if(Boolean(this.thumbnailSource))
            {
               this.setUpThumbnailSource();
            }
            else
            {
               this.setUpSource();
            }
         }
      }
      
      override protected function measure() : void
      {
         var intrinsicWidth:Number = NaN;
         var intrinsicHeight:Number = NaN;
         super.measure();
         if(Boolean(this.thumbnailSource) && Boolean(this.thumbnailGroup))
         {
            intrinsicWidth = this.thumbnailBitmapImage.getPreferredBoundsWidth();
            intrinsicHeight = this.thumbnailBitmapImage.getPreferredBoundsHeight();
         }
         else
         {
            intrinsicWidth = Number(this.videoPlayer.mediaWidth);
            if(isNaN(intrinsicWidth))
            {
               intrinsicWidth = 0;
            }
            intrinsicHeight = Number(this.videoPlayer.mediaHeight);
            if(isNaN(intrinsicHeight))
            {
               intrinsicHeight = 0;
            }
         }
         measuredWidth = intrinsicWidth;
         measuredHeight = intrinsicHeight;
         var bExplicitWidth:Boolean = !isNaN(explicitWidth);
         var bExplicitHeight:Boolean = !isNaN(explicitHeight);
         if(bExplicitWidth && !bExplicitHeight && intrinsicWidth > 0)
         {
            measuredHeight = explicitWidth * intrinsicHeight / intrinsicWidth;
         }
         else if(bExplicitHeight && !bExplicitWidth && intrinsicHeight > 0)
         {
            measuredWidth = explicitHeight * intrinsicWidth / intrinsicHeight;
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var newSize:Point = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(Boolean(this.thumbnailSource) && Boolean(this.thumbnailGroup))
         {
            newSize = getScaledSize(this.scaleMode,unscaledWidth,unscaledHeight,this.thumbnailBitmapImage.getPreferredBoundsWidth(),this.thumbnailBitmapImage.getPreferredBoundsHeight());
            this.thumbnailGroup.setLayoutBoundsSize(unscaledWidth,unscaledHeight);
            this.thumbnailBitmapImage.setLayoutBoundsSize(newSize.x,newSize.y);
            this.thumbnailBitmapImage.x = (unscaledWidth - newSize.x) / 2;
            this.thumbnailBitmapImage.y = (unscaledHeight - newSize.y) / 2;
            return;
         }
         this.videoContainer.width = Math.floor(unscaledWidth);
         this.videoContainer.height = Math.floor(unscaledHeight);
         this.videoContainer.validateNow();
      }
      
      public function pause() : void
      {
         if(!this.videoPlayerResponsive())
         {
            return;
         }
         this.playTheVideoOnVisible = false;
         if(!this.inLoadingState1 && Boolean(this.videoPlayer.canPause))
         {
            this.videoPlayer.pause();
         }
         else if(!this.videoPlayer.canPause && this.autoDisplayFirstFrame)
         {
            this.load();
         }
      }
      
      public function play() : void
      {
         if(!this.videoPlayerResponsive())
         {
            return;
         }
         this.playTheVideoOnVisible = false;
         if(this.inLoadingState1)
         {
            this.cancelLoadAndPlay();
         }
         else if(this.videoPlayer.canPlay)
         {
            this.videoPlayer.play();
         }
      }
      
      public function seek(time:Number) : void
      {
         if(!this.videoPlayerResponsive())
         {
            return;
         }
         if(this.videoPlayer.canSeek)
         {
            this.videoPlayer.seek(time);
         }
      }
      
      public function stop() : void
      {
         if(!this.videoPlayerResponsive())
         {
            return;
         }
         this.playTheVideoOnVisible = false;
         if(!this.inLoadingState1 && Boolean(this.videoPlayer.canPause))
         {
            this.videoPlayer.stop();
         }
         else if(!this.videoPlayer.canPause && this.autoDisplayFirstFrame)
         {
            this.load();
         }
      }
      
      private function videoPlayerResponsive() : Boolean
      {
         if(!this.initializedOnce)
         {
            return false;
         }
         if(Boolean(this.thumbnailSource))
         {
            return false;
         }
         if(this.videoPlayer.state == MediaPlayerState.PLAYBACK_ERROR || this.videoPlayer.state == MediaPlayerState.UNINITIALIZED || this.videoPlayer.state == MediaPlayerState.LOADING)
         {
            return false;
         }
         if(!this.source)
         {
            return false;
         }
         return true;
      }
      
      private function createUnderlyingVideoPlayer() : void
      {
         var mediaType:String = null;
         var mediaFactoryItem:MediaFactoryItem = null;
         this.videoPlayer = new MediaPlayer();
         this.videoContainer = new MediaContainer();
         this.videoContainer.clipChildren = true;
         this.mediaFactory = new DefaultMediaFactory();
         var unsupportedMediaTypes:Array = ["org.osmf.elements.video.dvr.dvrcast","org.osmf.elements.image","org.osmf.elements.swf"];
         for each(mediaType in unsupportedMediaTypes)
         {
            mediaFactoryItem = this.mediaFactory.getItemById(mediaType);
            if(Boolean(mediaFactoryItem))
            {
               this.mediaFactory.removeItem(mediaFactoryItem);
            }
         }
         this.videoPlayer.addEventListener(DisplayObjectEvent.MEDIA_SIZE_CHANGE,this.videoPlayer_mediaSizeChangeHandler);
         this.videoPlayer.addEventListener(AudioEvent.VOLUME_CHANGE,this.videoPlayer_volumeChangeHandler);
         this.videoPlayer.addEventListener(AudioEvent.MUTED_CHANGE,this.videoPlayer_mutedChangeHandler);
         this.videoPlayer.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE,this.videoPlayer_mediaPlayerStateChangeHandler);
         this.videoPlayer.addEventListener(TimeEvent.CURRENT_TIME_CHANGE,dispatchEvent);
         this.videoPlayer.addEventListener(LoadEvent.BYTES_LOADED_CHANGE,dispatchEvent);
         this.videoPlayer.addEventListener(TimeEvent.DURATION_CHANGE,this.videoPlayer_durationChangeHandler);
         this.videoPlayer.addEventListener(TimeEvent.COMPLETE,dispatchEvent);
         addChild(this.videoContainer);
      }
      
      private function setUpSource() : void
      {
         var streamingSource:DynamicStreamingVideoSource = null;
         var dsr:DynamicStreamingResource = null;
         var n:int = 0;
         var item:DynamicStreamingVideoItem = null;
         var dsi:DynamicStreamingItem = null;
         var streamItems:Vector.<DynamicStreamingItem> = null;
         var i:int = 0;
         var urlResource:URLResource = null;
         var layout:LayoutMetadata = null;
         this.cleanUpSource();
         if(Boolean(this.videoPlayer.media) && Boolean(this.videoContainer.containsMediaElement(this.videoPlayer.media)))
         {
            this.videoContainer.removeMediaElement(this.videoPlayer.media);
         }
         var videoElement:MediaElement = null;
         if(this.source is DynamicStreamingVideoSource)
         {
            streamingSource = this.source as DynamicStreamingVideoSource;
            if(streamingSource.host is String)
            {
               dsr = new DynamicStreamingResource(streamingSource.host as String,streamingSource.streamType);
            }
            else if(streamingSource.host is URL)
            {
               dsr = new DynamicStreamingResource(URL(streamingSource.host).host,streamingSource.streamType);
            }
            if(Boolean(dsr))
            {
               n = int(streamingSource.streamItems.length);
               streamItems = new Vector.<DynamicStreamingItem>(n);
               for(i = 0; i < n; i++)
               {
                  item = streamingSource.streamItems[i];
                  dsi = new DynamicStreamingItem(item.streamName,item.bitrate);
                  streamItems[i] = dsi;
               }
               dsr.streamItems = streamItems;
               dsr.initialIndex = streamingSource.initialIndex;
               dsr.mediaType = MediaType.VIDEO;
               videoElement = new VideoElement(dsr,new RTMPDynamicStreamingNetLoader());
            }
         }
         else if(this.source is String && this.source != "")
         {
            urlResource = new URLResource(this.source as String);
            videoElement = this.mediaFactory.createMediaElement(urlResource);
            if(videoElement == null)
            {
               urlResource.mediaType = MediaType.VIDEO;
               videoElement = this.mediaFactory.createMediaElement(urlResource);
            }
         }
         else if(this.source is MediaResourceBase)
         {
            videoElement = this.mediaFactory.createMediaElement(MediaResourceBase(this.source));
         }
         else if(this.source is VideoElement)
         {
            videoElement = this.source as VideoElement;
         }
         this.playTheVideoOnVisible = true;
         this.changePlayback(false,false);
         if(Boolean(videoElement) && (Boolean(!this.autoPlay || !this.shouldBePlaying)) && this.autoDisplayFirstFrame)
         {
            this.load();
         }
         this.videoPlayer.media = videoElement;
         if(Boolean(videoElement))
         {
            if(!isNaN(this.oldCurrentTimeUpdateInterval))
            {
               this.videoPlayer.currentTimeUpdateInterval = this.oldCurrentTimeUpdateInterval;
               this.videoPlayer.bytesLoadedUpdateInterval = this.oldBytesLoadedUpdateInterval;
            }
            if(videoElement.getMetadata(LayoutMetadata.LAYOUT_NAMESPACE) == null)
            {
               layout = new LayoutMetadata();
               layout.scaleMode = this.scaleMode;
               layout.verticalAlign = VerticalAlign.MIDDLE;
               layout.horizontalAlign = HorizontalAlign.CENTER;
               layout.percentWidth = 100;
               layout.percentHeight = 100;
               videoElement.addMetadata(LayoutMetadata.LAYOUT_NAMESPACE,layout);
            }
            if(Boolean(videoElement) && !this.videoContainer.containsMediaElement(videoElement))
            {
               this.videoContainer.addMediaElement(videoElement);
            }
         }
         else
         {
            invalidateSize();
         }
      }
      
      private function load() : void
      {
         this.inLoadingState1 = true;
         this.videoPlayer.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE,this.videoPlayer_mediaPlayerStateChangeHandlerForLoading);
      }
      
      private function get shouldBePlaying() : Boolean
      {
         if(!this.effectiveEnabled)
         {
            return false;
         }
         if(this.pauseWhenHidden)
         {
            if(!this._isOnDisplayList)
            {
               return false;
            }
            if(!this.effectiveVisibility)
            {
               return false;
            }
         }
         return true;
      }
      
      private function changePlayback(causePause:Boolean, causePlay:Boolean) : void
      {
         if(this.shouldBePlaying)
         {
            this.videoPlayer.autoPlay = this.autoPlay;
            if(causePlay && (this.playTheVideoOnVisible && this.autoPlay))
            {
               this.playTheVideoOnVisible = false;
               if(this.inLoadingState1)
               {
                  this.cancelLoadAndPlay();
               }
               else if(this.videoPlayer.canPlay)
               {
                  this.videoPlayer.play();
               }
            }
         }
         else
         {
            if(causePause && (this.playing || this.videoPlayer.state == MediaPlayerState.LOADING && this.autoPlay))
            {
               this.playTheVideoOnVisible = true;
            }
            this.videoPlayer.autoPlay = false;
            if(causePause)
            {
               if(!this.inLoadingState1 && Boolean(this.videoPlayer.canPause))
               {
                  this.videoPlayer.pause();
               }
               else if(!this.videoPlayer.canPause && this.autoDisplayFirstFrame)
               {
                  this.load();
               }
            }
         }
      }
      
      private function cancelLoadAndPlay() : void
      {
         if(this.inLoadingState1)
         {
            if(this.inLoadingState2)
            {
               if(!this.inLoadingState3)
               {
                  this.videoPlayer.muted = this.beforeLoadMuted;
                  if(Boolean(this.videoPlayer.displayObject))
                  {
                     this.videoPlayer.displayObject.visible = true;
                  }
                  this.videoPlayer.removeEventListener(TimeEvent.CURRENT_TIME_CHANGE,this.videoPlayer_currentTimeChangeHandler);
                  this.videoPlayer.removeEventListener(MediaPlayerCapabilityChangeEvent.CAN_SEEK_CHANGE,this.videoPlayer_canSeekChangeHandler);
               }
               else
               {
                  this.videoPlayer.removeEventListener(SeekEvent.SEEKING_CHANGE,this.videoPlayer_seekChangeHandler);
                  this.videoPlayer.muted = this.beforeLoadMuted;
                  if(Boolean(this.videoPlayer.displayObject))
                  {
                     this.videoPlayer.displayObject.visible = true;
                  }
                  if(this.videoPlayer.canPlay)
                  {
                     this.videoPlayer.play();
                  }
               }
            }
            this.inLoadingState1 = false;
            this.inLoadingState2 = false;
            this.inLoadingState3 = false;
         }
      }
      
      private function cleanUpSource() : void
      {
         this.videoPlayer.removeEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE,this.videoPlayer_mediaPlayerStateChangeHandlerForLoading);
         if(this.inLoadingState1)
         {
            if(this.inLoadingState2)
            {
               if(!this.inLoadingState3)
               {
                  this.videoPlayer.muted = this.beforeLoadMuted;
                  this.videoPlayer.displayObject.visible = true;
                  this.videoPlayer.pause();
               }
               else
               {
                  this.videoPlayer.removeEventListener(SeekEvent.SEEKING_CHANGE,this.videoPlayer_seekChangeHandler);
                  this.videoPlayer.muted = this.beforeLoadMuted;
                  this.videoPlayer.displayObject.visible = true;
               }
            }
            this.inLoadingState1 = false;
            this.inLoadingState2 = false;
            this.inLoadingState3 = false;
         }
      }
      
      private function addedToStageHandler(event:Event) : void
      {
         this._isOnDisplayList = true;
         if(this.pauseWhenHidden)
         {
            this.addVisibilityListeners();
         }
         this.addEnabledListeners();
         this.computeEffectiveVisibilityAndEnabled();
         if(!isNaN(this.oldCurrentTimeUpdateInterval))
         {
            this.videoPlayer.currentTimeUpdateInterval = this.oldCurrentTimeUpdateInterval;
            this.videoPlayer.bytesLoadedUpdateInterval = this.oldBytesLoadedUpdateInterval;
            this.oldCurrentTimeUpdateInterval = NaN;
            this.oldBytesLoadedUpdateInterval = NaN;
         }
         this.changePlayback(false,this.pauseWhenHidden);
      }
      
      private function removedFromStageHandler(event:Event) : void
      {
         this._isOnDisplayList = false;
         if(this.pauseWhenHidden)
         {
            this.removeVisibilityListeners();
         }
         this.removeEnabledListeners();
         if(this.pauseWhenHidden)
         {
            this.oldCurrentTimeUpdateInterval = this.videoPlayer.currentTimeUpdateInterval;
            this.oldBytesLoadedUpdateInterval = this.videoPlayer.bytesLoadedUpdateInterval;
            this.videoPlayer.currentTimeUpdateInterval = -1;
            this.videoPlayer.bytesLoadedUpdateInterval = -1;
         }
         this.changePlayback(this.pauseWhenHidden,false);
      }
      
      private function addVisibilityListeners() : void
      {
         var current:IVisualElement = this;
         while(Boolean(current))
         {
            current.addEventListener(FlexEvent.HIDE,this.visibilityChangedHandler,false,0,true);
            current.addEventListener(FlexEvent.SHOW,this.visibilityChangedHandler,false,0,true);
            if(Boolean(current.designLayer))
            {
               current.designLayer.addEventListener("layerPropertyChange",this.designLayer_layerPropertyChangeHandler,false,0,true);
            }
            current = current.parent as IVisualElement;
         }
      }
      
      private function addEnabledListeners() : void
      {
         var current:IVisualElement = this;
         while(Boolean(current))
         {
            current.addEventListener("enabledChanged",this.enabledChangedHandler,false,0,true);
            current.addEventListener("enabledChanged",this.enabledChangedHandler,false,0,true);
            current = current.parent as IVisualElement;
         }
      }
      
      private function removeVisibilityListeners() : void
      {
         var current:IVisualElement = this;
         while(Boolean(current))
         {
            current.removeEventListener(FlexEvent.HIDE,this.visibilityChangedHandler,false);
            current.removeEventListener(FlexEvent.SHOW,this.visibilityChangedHandler,false);
            if(Boolean(current.designLayer))
            {
               current.designLayer.removeEventListener("layerPropertyChange",this.designLayer_layerPropertyChangeHandler,false);
            }
            current = current.parent as IVisualElement;
         }
      }
      
      private function removeEnabledListeners() : void
      {
         var current:IVisualElement = this;
         while(Boolean(current))
         {
            current.removeEventListener("enabledChanged",this.enabledChangedHandler,false);
            current.removeEventListener("enabledChanged",this.enabledChangedHandler,false);
            current = current.parent as IVisualElement;
         }
      }
      
      private function visibilityChangedHandler(event:FlexEvent) : void
      {
         this.effectiveVisibilityChanged = true;
         invalidateProperties();
      }
      
      private function designLayer_layerPropertyChangeHandler(event:PropertyChangeEvent) : void
      {
         if(event.property == "effectiveVisibility")
         {
            this.effectiveVisibilityChanged = true;
            invalidateProperties();
         }
      }
      
      private function enabledChangedHandler(event:Event) : void
      {
         this.effectiveEnabledChanged = true;
         invalidateProperties();
      }
      
      private function computeEffectiveVisibilityAndEnabled() : void
      {
         this.effectiveVisibility = true;
         this.effectiveEnabled = true;
         var current:IVisualElement = this;
         while(Boolean(current))
         {
            if(!current.visible || Boolean(current.designLayer) && Boolean(!current.designLayer.effectiveVisibility))
            {
               this.effectiveVisibility = false;
               if(!this.effectiveEnabled)
               {
                  break;
               }
            }
            if(current is IUIComponent && !IUIComponent(current).enabled)
            {
               this.effectiveEnabled = false;
               if(!this.effectiveVisibility)
               {
                  break;
               }
            }
            current = current.parent as IVisualElement;
         }
      }
      
      private function videoPlayer_volumeChangeHandler(event:AudioEvent) : void
      {
         dispatchEvent(new Event("volumeChanged"));
      }
      
      private function videoPlayer_mutedChangeHandler(event:AudioEvent) : void
      {
         dispatchEvent(new Event("volumeChanged"));
      }
      
      private function videoPlayer_mediaPlayerStateChangeHandler(event:MediaPlayerStateChangeEvent) : void
      {
         if(event.state == MediaPlayerState.PLAYBACK_ERROR)
         {
            invalidateSize();
         }
         dispatchEvent(event);
      }
      
      private function videoPlayer_mediaPlayerStateChangeHandlerForLoading(event:MediaPlayerStateChangeEvent) : void
      {
         if(event.state == MediaPlayerState.READY)
         {
            this.videoPlayer.removeEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE,this.videoPlayer_mediaPlayerStateChangeHandlerForLoading);
            if(this.videoPlayer.playing)
            {
               return;
            }
            if(this.inLoadingState1)
            {
               this.beforeLoadMuted = this.videoPlayer.muted;
               this.videoPlayer.muted = true;
               if(Boolean(this.videoPlayer.displayObject))
               {
                  this.videoPlayer.displayObject.visible = false;
               }
               this.inLoadingState2 = true;
            }
            this.videoPlayer.play();
         }
      }
      
      private function videoPlayer_mediaSizeChangeHandler(event:DisplayObjectEvent) : void
      {
         invalidateSize();
         if(this.inLoadingState2)
         {
            if(Boolean(this.videoPlayer.canSeek) && Boolean(this.videoPlayer.canSeekTo(0)))
            {
               this.inLoadingState3 = true;
               callLater(this.pauseAndSeekCallBack);
            }
            else if(this.duration < 0)
            {
               this.videoPlayer.addEventListener(TimeEvent.CURRENT_TIME_CHANGE,this.videoPlayer_currentTimeChangeHandler);
            }
            else
            {
               this.videoPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.CAN_SEEK_CHANGE,this.videoPlayer_canSeekChangeHandler);
            }
         }
      }
      
      private function pauseAndSeekCallBack() : void
      {
         this.videoPlayer.addEventListener(SeekEvent.SEEKING_CHANGE,this.videoPlayer_seekChangeHandler);
         this.videoPlayer.pause();
         this.videoPlayer.seek(0);
      }
      
      private function videoPlayer_canSeekChangeHandler(event:Event) : void
      {
         this.videoPlayer.removeEventListener(MediaPlayerCapabilityChangeEvent.CAN_SEEK_CHANGE,this.videoPlayer_canSeekChangeHandler);
         if(this.inLoadingState2)
         {
            if(Boolean(this.videoPlayer.canSeek) && Boolean(this.videoPlayer.canSeekTo(0)))
            {
               this.inLoadingState3 = true;
               callLater(this.pauseAndSeekCallBack);
            }
         }
      }
      
      private function videoPlayer_seekChangeHandler(event:SeekEvent) : void
      {
         if(!event.seeking)
         {
            this.inLoadingState1 = false;
            this.inLoadingState2 = false;
            this.inLoadingState3 = false;
            this.videoPlayer.removeEventListener(SeekEvent.SEEKING_CHANGE,this.videoPlayer_seekChangeHandler);
            this.videoPlayer.muted = this.beforeLoadMuted;
            if(Boolean(this.videoPlayer.displayObject))
            {
               this.videoPlayer.displayObject.visible = true;
            }
            if(!isNaN(this.oldCurrentTimeUpdateInterval))
            {
               this.videoPlayer.currentTimeUpdateInterval = -1;
               this.videoPlayer.bytesLoadedUpdateInterval = -1;
            }
         }
      }
      
      private function videoPlayer_currentTimeChangeHandler(event:TimeEvent) : void
      {
         this.videoPlayer.removeEventListener(TimeEvent.CURRENT_TIME_CHANGE,this.videoPlayer_currentTimeChangeHandler);
         this.videoPlayer.removeEventListener(MediaPlayerCapabilityChangeEvent.CAN_SEEK_CHANGE,this.videoPlayer_canSeekChangeHandler);
         this.videoPlayer.pause();
         this.videoPlayer.muted = this.beforeLoadMuted;
         if(Boolean(this.videoPlayer.displayObject))
         {
            this.videoPlayer.displayObject.visible = true;
         }
         this.inLoadingState1 = false;
         this.inLoadingState2 = false;
         this.inLoadingState3 = false;
         if(!isNaN(this.oldCurrentTimeUpdateInterval))
         {
            this.videoPlayer.currentTimeUpdateInterval = -1;
            this.videoPlayer.bytesLoadedUpdateInterval = -1;
         }
      }
      
      private function videoPlayer_durationChangeHandler(event:TimeEvent) : void
      {
         dispatchEvent(event);
         if(this.inLoadingState2)
         {
            if(event.time < 0)
            {
               this.videoPlayer.addEventListener(TimeEvent.CURRENT_TIME_CHANGE,this.videoPlayer_currentTimeChangeHandler);
            }
         }
      }
   }
}

