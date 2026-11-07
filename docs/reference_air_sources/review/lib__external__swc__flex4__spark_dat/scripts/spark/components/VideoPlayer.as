package spark.components
{
   import flash.display.DisplayObject;
   import flash.display.StageDisplayState;
   import flash.events.Event;
   import flash.events.FullScreenEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.media.Video;
   import flash.system.ApplicationDomain;
   import flash.utils.Timer;
   import mx.core.FlexGlobals;
   import mx.core.IVisualElementContainer;
   import mx.events.FlexEvent;
   import mx.managers.PopUpManager;
   import mx.utils.BitFlagUtil;
   import org.osmf.events.LoadEvent;
   import org.osmf.events.MediaPlayerStateChangeEvent;
   import org.osmf.events.TimeEvent;
   import org.osmf.media.MediaPlayerState;
   import spark.components.mediaClasses.MuteButton;
   import spark.components.mediaClasses.ScrubBar;
   import spark.components.mediaClasses.VolumeBar;
   import spark.components.supportClasses.ButtonBase;
   import spark.components.supportClasses.SkinnableComponent;
   import spark.components.supportClasses.ToggleButtonBase;
   import spark.core.IDisplayText;
   import spark.events.TrackBaseEvent;
   
   [DiscouragedForProfile("mobileDevice")]
   [IconFile("VideoPlayer.png")]
   [DefaultProperty("source")]
   [AccessibilityClass(implementation="spark.accessibility.VideoPlayerAccImpl")]
   [Exclude(name="focusThickness",kind="style")]
   [Exclude(name="focusBlendMode",kind="style")]
   [SkinState("disabledAndFullScreen")]
   [SkinState("playbackErrorAndFullScreen")]
   [SkinState("bufferingAndFullScreen")]
   [SkinState("pausedAndFullScreen")]
   [SkinState("playingAndFullScreen")]
   [SkinState("readyAndFullScreen")]
   [SkinState("loadingAndFullScreen")]
   [SkinState("uninitializedAndFullScreen")]
   [SkinState("disabled")]
   [SkinState("playbackError")]
   [SkinState("buffering")]
   [SkinState("paused")]
   [SkinState("playing")]
   [SkinState("ready")]
   [SkinState("loading")]
   [SkinState("uninitialized")]
   [Style(name="symbolColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="fullScreenHideControlsDelay",type="Number",format="Time",inherit="no")]
   [Style(name="dropShadowVisible",type="Boolean",inherit="no",theme="spark")]
   [Style(name="typographicCase",type="String",enumeration="default,capsToSmallCaps,uppercase,lowercase,lowercaseToSmallCaps",inherit="yes")]
   [Style(name="trackingRight",type="Object",inherit="yes")]
   [Style(name="trackingLeft",type="Object",inherit="yes")]
   [Style(name="textJustify",type="String",enumeration="interWord,distribute",inherit="yes")]
   [Style(name="textDecoration",type="String",enumeration="none,underline",inherit="yes")]
   [Style(name="textAlpha",type="Number",inherit="yes",minValue="0.0",maxValue="1.0")]
   [Style(name="textAlignLast",type="String",enumeration="start,end,left,right,center,justify",inherit="yes")]
   [Style(name="textAlign",type="String",enumeration="start,end,left,right,center,justify",inherit="yes")]
   [Style(name="renderingMode",type="String",enumeration="cff,normal",inherit="yes")]
   [Style(name="locale",type="String",inherit="yes")]
   [Style(name="lineThrough",type="Boolean",inherit="yes")]
   [Style(name="lineHeight",type="Object",inherit="yes")]
   [Style(name="ligatureLevel",type="String",enumeration="common,minimum,uncommon,exotic",inherit="yes")]
   [Style(name="letterSpacing",type="Number",inherit="yes",theme="mobile")]
   [Style(name="leading",type="Number",format="Length",inherit="yes",theme="mobile")]
   [Style(name="kerning",type="String",enumeration="auto,on,off",inherit="yes")]
   [Style(name="justificationStyle",type="String",enumeration="auto,prioritizeLeastAdjustment,pushInKinsoku,pushOutOnly",inherit="yes")]
   [Style(name="justificationRule",type="String",enumeration="auto,space,eastAsian",inherit="yes")]
   [Style(name="fontWeight",type="String",enumeration="normal,bold",inherit="yes")]
   [Style(name="fontStyle",type="String",enumeration="normal,italic",inherit="yes")]
   [Style(name="fontSize",type="Number",format="Length",inherit="yes",minValue="1.0",maxValue="720.0")]
   [Style(name="fontLookup",type="String",enumeration="auto,device,embeddedCFF",inherit="yes")]
   [Style(name="fontFamily",type="String",inherit="yes")]
   [Style(name="dominantBaseline",type="String",enumeration="auto,roman,ascent,descent,ideographicTop,ideographicCenter,ideographicBottom",inherit="yes")]
   [Style(name="direction",type="String",enumeration="ltr,rtl",inherit="yes")]
   [Style(name="digitWidth",type="String",enumeration="default,proportional,tabular",inherit="yes")]
   [Style(name="digitCase",type="String",enumeration="default,lining,oldStyle",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Style(name="cffHinting",type="String",enumeration="horizontalStem,none",inherit="yes")]
   [Style(name="baselineShift",type="Object",inherit="yes")]
   [Style(name="alignmentBaseline",type="String",enumeration="useDominantBaseline,roman,ascent,descent,ideographicTop,ideographicCenter,ideographicBottom",inherit="yes")]
   [Event(name="mediaPlayerStateChange",type="org.osmf.events.MediaPlayerStateChangeEvent")]
   [Event(name="durationChange",type="org.osmf.events.TimeEvent")]
   [Event(name="currentTimeChange",type="org.osmf.events.TimeEvent")]
   [Event(name="complete",type="org.osmf.events.TimeEvent")]
   [Event(name="bytesLoadedChange",type="org.osmf.events.LoadEvent")]
   public class VideoPlayer extends SkinnableComponent
   {
      
      private static var _screenClass:Class;
      
      private static var checkedForScreenClass:Boolean;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const AUTO_DISPLAY_FIRST_FRAME_PROPERTY_FLAG:uint = 1 << 0;
      
      private static const AUTO_PLAY_PROPERTY_FLAG:uint = 1 << 1;
      
      private static const AUTO_REWIND_PROPERTY_FLAG:uint = 1 << 2;
      
      private static const LOOP_PROPERTY_FLAG:uint = 1 << 3;
      
      private static const SCALE_MODE_PROPERTY_FLAG:uint = 1 << 4;
      
      private static const MUTED_PROPERTY_FLAG:uint = 1 << 5;
      
      private static const SOURCE_PROPERTY_FLAG:uint = 1 << 6;
      
      private static const VOLUME_PROPERTY_FLAG:uint = 1 << 7;
      
      private static const PAUSE_WHEN_HIDDEN_PROPERTY_FLAG:uint = 1 << 8;
      
      private static const THUMBNAIL_SOURCE_PROPERTY_FLAG:uint = 1 << 9;
      
      private static var _skinParts:Object = {
         "pauseButton":false,
         "stopButton":false,
         "videoDisplay":true,
         "playerControls":false,
         "fullScreenButton":false,
         "muteButton":false,
         "volumeBar":false,
         "scrubBar":false,
         "durationDisplay":false,
         "currentTimeDisplay":false,
         "playButton":false,
         "playPauseButton":false
      };
      
      [SkinPart(required="true")]
      public var videoDisplay:VideoDisplay;
      
      [SkinPart(required="false")]
      public var currentTimeDisplay:IDisplayText;
      
      [SkinPart(required="false")]
      public var fullScreenButton:ButtonBase;
      
      [SkinPart(required="false")]
      public var muteButton:MuteButton;
      
      [SkinPart(required="false")]
      public var pauseButton:ButtonBase;
      
      [SkinPart(required="false")]
      public var playButton:ButtonBase;
      
      [SkinPart(required="false")]
      public var playerControls:DisplayObject;
      
      [SkinPart(required="false")]
      public var playPauseButton:ToggleButtonBase;
      
      [SkinPart(required="false")]
      public var scrubBar:ScrubBar;
      
      [SkinPart(required="false")]
      public var stopButton:ButtonBase;
      
      [SkinPart(required="false")]
      public var durationDisplay:IDisplayText;
      
      [SkinPart(required="false")]
      public var volumeBar:VolumeBar;
      
      private var videoDisplayProperties:Object = {};
      
      private var exitingFullScreenPauseWhenHidden:Boolean;
      
      private var needsToUpdatePauseWhenHidden:Boolean = false;
      
      private var videoDisplay_updateCompleteHandlerProperties:Object;
      
      private var fullScreen:Boolean = false;
      
      private var beforeFullScreenInfo:Object;
      
      private var fullScreenHideControlTimer:Timer;
      
      private var scrubBarMouseCaptured:Boolean;
      
      private var wasPlayingBeforeSeeking:Boolean;
      
      private var scrubBarChanging:Boolean;
      
      public function VideoPlayer()
      {
         super();
      }
      
      private static function get screenClass() : Class
      {
         if(!checkedForScreenClass)
         {
            checkedForScreenClass = true;
            if(ApplicationDomain.currentDomain.hasDefinition("flash.display::Screen"))
            {
               _screenClass = Class(ApplicationDomain.currentDomain.getDefinition("flash.display::Screen"));
            }
         }
         return _screenClass;
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get autoDisplayFirstFrame() : Boolean
      {
         var v:* = undefined;
         if(Boolean(this.videoDisplay))
         {
            return this.videoDisplay.autoDisplayFirstFrame;
         }
         v = this.videoDisplayProperties.autoDisplayFirstFrame;
         return v === undefined ? true : Boolean(v);
      }
      
      public function set autoDisplayFirstFrame(value:Boolean) : void
      {
         if(Boolean(this.videoDisplay))
         {
            this.videoDisplay.autoDisplayFirstFrame = value;
            this.videoDisplayProperties = BitFlagUtil.update(this.videoDisplayProperties as uint,AUTO_DISPLAY_FIRST_FRAME_PROPERTY_FLAG,true);
         }
         else
         {
            this.videoDisplayProperties.autoDisplayFirstFrame = value;
         }
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get autoPlay() : Boolean
      {
         var v:* = undefined;
         if(Boolean(this.videoDisplay))
         {
            return this.videoDisplay.autoPlay;
         }
         v = this.videoDisplayProperties.autoPlay;
         return v === undefined ? true : Boolean(v);
      }
      
      public function set autoPlay(value:Boolean) : void
      {
         if(Boolean(this.videoDisplay))
         {
            this.videoDisplay.autoPlay = value;
            this.videoDisplayProperties = BitFlagUtil.update(this.videoDisplayProperties as uint,AUTO_PLAY_PROPERTY_FLAG,true);
         }
         else
         {
            this.videoDisplayProperties.autoPlay = value;
         }
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get autoRewind() : Boolean
      {
         var v:* = undefined;
         if(Boolean(this.videoDisplay))
         {
            return this.videoDisplay.autoRewind;
         }
         v = this.videoDisplayProperties.autoRewind;
         return v === undefined ? true : Boolean(v);
      }
      
      public function set autoRewind(value:Boolean) : void
      {
         if(Boolean(this.videoDisplay))
         {
            this.videoDisplay.autoRewind = value;
            this.videoDisplayProperties = BitFlagUtil.update(this.videoDisplayProperties as uint,AUTO_REWIND_PROPERTY_FLAG,true);
         }
         else
         {
            this.videoDisplayProperties.autoRewind = value;
         }
      }
      
      [Bindable("mediaPlayerStateChange")]
      [Bindable("bytesLoadedChange")]
      [Inspectable(Category="General",defaultValue="0")]
      public function get bytesLoaded() : Number
      {
         if(Boolean(this.videoDisplay))
         {
            return this.videoDisplay.bytesLoaded;
         }
         return 0;
      }
      
      [Bindable("mediaPlayerStateChange")]
      [Inspectable(Category="General",defaultValue="0")]
      public function get bytesTotal() : Number
      {
         if(Boolean(this.videoDisplay))
         {
            return this.videoDisplay.bytesTotal;
         }
         return 0;
      }
      
      [Bindable("mediaPlayerStateChange")]
      [Bindable("currentTimeChange")]
      [Inspectable(Category="General",defaultValue="0")]
      public function get currentTime() : Number
      {
         if(Boolean(this.videoDisplay))
         {
            return this.videoDisplay.currentTime;
         }
         return 0;
      }
      
      [Bindable("mediaPlayerStateChange")]
      [Bindable("durationChange")]
      [Inspectable(Category="General",defaultValue="0")]
      public function get duration() : Number
      {
         if(Boolean(this.videoDisplay))
         {
            return this.videoDisplay.duration;
         }
         return 0;
      }
      
      [Inspectable(Category="General",defaultValue="false")]
      public function get loop() : Boolean
      {
         var v:* = undefined;
         if(Boolean(this.videoDisplay))
         {
            return this.videoDisplay.loop;
         }
         v = this.videoDisplayProperties.loop;
         return v === undefined ? false : Boolean(v);
      }
      
      public function set loop(value:Boolean) : void
      {
         if(Boolean(this.videoDisplay))
         {
            this.videoDisplay.loop = value;
            this.videoDisplayProperties = BitFlagUtil.update(this.videoDisplayProperties as uint,LOOP_PROPERTY_FLAG,true);
         }
         else
         {
            this.videoDisplayProperties.loop = value;
         }
      }
      
      [Bindable("mediaPlayerStateChange")]
      [Inspectable(category="General",defaultValue="uninitialized")]
      public function get mediaPlayerState() : String
      {
         if(Boolean(this.videoDisplay))
         {
            return this.videoDisplay.mediaPlayerState;
         }
         return MediaPlayerState.UNINITIALIZED;
      }
      
      [Bindable("volumeChanged")]
      [Inspectable(category="General",defaultValue="false")]
      public function get muted() : Boolean
      {
         var v:* = undefined;
         if(Boolean(this.videoDisplay))
         {
            return this.videoDisplay.muted;
         }
         v = this.videoDisplayProperties.muted;
         return v === undefined ? false : Boolean(v);
      }
      
      public function set muted(value:Boolean) : void
      {
         if(Boolean(this.videoDisplay))
         {
            this.videoDisplay.muted = value;
            this.videoDisplayProperties = BitFlagUtil.update(this.videoDisplayProperties as uint,MUTED_PROPERTY_FLAG,true);
         }
         else
         {
            this.videoDisplayProperties.muted = value;
         }
         if(Boolean(this.volumeBar))
         {
            this.volumeBar.muted = value;
         }
         if(Boolean(this.muteButton))
         {
            this.muteButton.muted = value;
         }
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get pauseWhenHidden() : Boolean
      {
         var v:* = undefined;
         if(this.needsToUpdatePauseWhenHidden)
         {
            return this.exitingFullScreenPauseWhenHidden;
         }
         if(Boolean(this.videoDisplay))
         {
            return this.videoDisplay.pauseWhenHidden;
         }
         v = this.videoDisplayProperties.pauseWhenHidden;
         return v === undefined ? false : Boolean(v);
      }
      
      public function set pauseWhenHidden(value:Boolean) : void
      {
         if(this.needsToUpdatePauseWhenHidden)
         {
            this.exitingFullScreenPauseWhenHidden = value;
         }
         else if(Boolean(this.videoDisplay))
         {
            this.videoDisplay.pauseWhenHidden = value;
            this.videoDisplayProperties = BitFlagUtil.update(this.videoDisplayProperties as uint,PAUSE_WHEN_HIDDEN_PROPERTY_FLAG,true);
         }
         else
         {
            this.videoDisplayProperties.pauseWhenHidden = value;
         }
      }
      
      [Bindable("mediaPlayerStateChange")]
      [Inspectable(category="General")]
      public function get playing() : Boolean
      {
         if(Boolean(this.videoDisplay))
         {
            return this.videoDisplay.playing;
         }
         return false;
      }
      
      [Inspectable(Category="General",enumeration="none,stretch,letterbox,zoom",defaultValue="letterbox")]
      public function get scaleMode() : String
      {
         var v:* = undefined;
         if(Boolean(this.videoDisplay))
         {
            return this.videoDisplay.scaleMode;
         }
         v = this.videoDisplayProperties.scaleMode;
         return v === undefined ? "letterbox" : v;
      }
      
      public function set scaleMode(value:String) : void
      {
         if(Boolean(this.videoDisplay))
         {
            this.videoDisplay.scaleMode = value;
            this.videoDisplayProperties = BitFlagUtil.update(this.videoDisplayProperties as uint,SCALE_MODE_PROPERTY_FLAG,true);
         }
         else
         {
            this.videoDisplayProperties.scaleMode = value;
         }
      }
      
      [Bindable("sourceChanged")]
      [Inspectable(category="General",defaultValue="null")]
      public function get source() : Object
      {
         var v:* = undefined;
         if(Boolean(this.videoDisplay))
         {
            return this.videoDisplay.source;
         }
         v = this.videoDisplayProperties.source;
         return v === undefined ? null : v;
      }
      
      public function set source(value:Object) : void
      {
         if(Boolean(this.videoDisplay))
         {
            this.videoDisplay.source = value;
            this.videoDisplayProperties = BitFlagUtil.update(this.videoDisplayProperties as uint,SOURCE_PROPERTY_FLAG,true);
         }
         else
         {
            this.videoDisplayProperties.source = value;
         }
      }
      
      [Inspectable(category="General")]
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get thumbnailSource() : Object
      {
         var v:* = undefined;
         if(Boolean(this.videoDisplay))
         {
            return this.videoDisplay.thumbnailSource;
         }
         v = this.videoDisplayProperties.thumbnailSource;
         return v === undefined ? null : v;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set thumbnailSource(value:Object) : void
      {
         if(Boolean(this.videoDisplay))
         {
            this.videoDisplay.thumbnailSource = value;
            this.videoDisplayProperties = BitFlagUtil.update(this.videoDisplayProperties as uint,THUMBNAIL_SOURCE_PROPERTY_FLAG,true);
         }
         else
         {
            this.videoDisplayProperties.thumbnailSource = value;
         }
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get videoObject() : Video
      {
         if(Boolean(this.videoDisplay))
         {
            return this.videoDisplay.videoObject;
         }
         return null;
      }
      
      [Bindable("volumeChanged")]
      [Inspectable(category="General",defaultValue="1.0",minValue="0.0",maxValue="1.0")]
      public function get volume() : Number
      {
         var v:* = undefined;
         if(Boolean(this.videoDisplay))
         {
            return this.videoDisplay.volume;
         }
         v = this.videoDisplayProperties.volume;
         return v === undefined ? 1 : Number(v);
      }
      
      public function set volume(value:Number) : void
      {
         if(Boolean(this.videoDisplay))
         {
            this.videoDisplay.volume = value;
            this.videoDisplayProperties = BitFlagUtil.update(this.videoDisplayProperties as uint,VOLUME_PROPERTY_FLAG,true);
         }
         else
         {
            this.videoDisplayProperties.volume = value;
         }
         if(Boolean(this.volumeBar))
         {
            this.volumeBar.value = value;
         }
      }
      
      override protected function initializeAccessibility() : void
      {
         if(VideoPlayer.createAccessibilityImplementation != null)
         {
            VideoPlayer.createAccessibilityImplementation(this);
         }
      }
      
      override protected function getCurrentSkinState() : String
      {
         if(!this.videoDisplay || !this.videoDisplay.videoPlayer)
         {
            return null;
         }
         var state:String = this.videoDisplay.videoPlayer.state;
         if(!enabled)
         {
            state = "disabled";
         }
         if(this.fullScreen)
         {
            return state + "AndFullScreen";
         }
         return state;
      }
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         var newVideoProperties:uint = 0;
         super.partAdded(partName,instance);
         if(instance == this.videoDisplay)
         {
            this.videoDisplay.addEventListener(TimeEvent.CURRENT_TIME_CHANGE,this.videoDisplay_currentTimeChangeHandler);
            this.videoDisplay.addEventListener(LoadEvent.BYTES_LOADED_CHANGE,this.videoDisplay_bytesLoadedChangeHandler);
            this.videoDisplay.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE,this.videoDisplay_mediaPlayerStateChangeHandler);
            this.videoDisplay.addEventListener(TimeEvent.DURATION_CHANGE,this.videoDisplay_durationChangeHandler);
            this.videoDisplay.addEventListener(TimeEvent.COMPLETE,dispatchEvent);
            this.videoDisplay.addEventListener("sourceChanged",dispatchEvent);
            this.videoDisplay.addEventListener("volumeChanged",this.videoDisplay_volumeChangedHandler);
            newVideoProperties = 0;
            if(this.videoDisplayProperties.source !== undefined)
            {
               this.videoDisplay.source = this.videoDisplayProperties.source;
               newVideoProperties = uint(BitFlagUtil.update(newVideoProperties as uint,SOURCE_PROPERTY_FLAG,true));
            }
            if(this.videoDisplayProperties.autoPlay !== undefined)
            {
               this.videoDisplay.autoPlay = this.videoDisplayProperties.autoPlay;
               newVideoProperties = uint(BitFlagUtil.update(newVideoProperties as uint,AUTO_PLAY_PROPERTY_FLAG,true));
            }
            if(this.videoDisplayProperties.volume !== undefined)
            {
               this.videoDisplay.volume = this.videoDisplayProperties.volume;
               newVideoProperties = uint(BitFlagUtil.update(newVideoProperties as uint,VOLUME_PROPERTY_FLAG,true));
            }
            if(this.videoDisplayProperties.autoRewind !== undefined)
            {
               this.videoDisplay.autoRewind = this.videoDisplayProperties.autoRewind;
               newVideoProperties = uint(BitFlagUtil.update(newVideoProperties as uint,AUTO_REWIND_PROPERTY_FLAG,true));
            }
            if(this.videoDisplayProperties.loop !== undefined)
            {
               this.videoDisplay.loop = this.videoDisplayProperties.loop;
               newVideoProperties = uint(BitFlagUtil.update(newVideoProperties as uint,LOOP_PROPERTY_FLAG,true));
            }
            if(this.videoDisplayProperties.scaleMode !== undefined)
            {
               this.videoDisplay.scaleMode = this.videoDisplayProperties.scaleMode;
               newVideoProperties = uint(BitFlagUtil.update(newVideoProperties as uint,SCALE_MODE_PROPERTY_FLAG,true));
            }
            if(this.videoDisplayProperties.muted !== undefined)
            {
               this.videoDisplay.muted = this.videoDisplayProperties.muted;
               newVideoProperties = uint(BitFlagUtil.update(newVideoProperties as uint,MUTED_PROPERTY_FLAG,true));
            }
            if(this.videoDisplayProperties.pauseWhenHidden !== undefined)
            {
               this.videoDisplay.pauseWhenHidden = this.videoDisplayProperties.pauseWhenHidden;
               newVideoProperties = uint(BitFlagUtil.update(newVideoProperties as uint,PAUSE_WHEN_HIDDEN_PROPERTY_FLAG,true));
            }
            if(this.videoDisplayProperties.autoDisplayFirstFrame !== undefined)
            {
               this.videoDisplay.autoDisplayFirstFrame = this.videoDisplayProperties.autoDisplayFirstFrame;
               newVideoProperties = uint(BitFlagUtil.update(newVideoProperties as uint,AUTO_DISPLAY_FIRST_FRAME_PROPERTY_FLAG,true));
            }
            if(this.videoDisplayProperties.thumbnailSource !== undefined)
            {
               this.videoDisplay.thumbnailSource = this.videoDisplayProperties.thumbnailSource;
               newVideoProperties = uint(BitFlagUtil.update(newVideoProperties as uint,THUMBNAIL_SOURCE_PROPERTY_FLAG,true));
            }
            if(this.videoDisplayProperties.currentTime !== undefined || this.videoDisplayProperties.playing !== undefined)
            {
               this.videoDisplay_updateCompleteHandlerProperties = {
                  "autoPlay":this.videoDisplay.autoPlay,
                  "playing":this.videoDisplayProperties.playing,
                  "currentTime":this.videoDisplayProperties.currentTime
               };
               this.videoDisplay.autoPlay = false;
               this.videoDisplay.addEventListener(FlexEvent.UPDATE_COMPLETE,this.videoDisplay_updateCompleteHandler);
            }
            this.videoDisplayProperties = newVideoProperties;
            if(Boolean(this.volumeBar))
            {
               this.volumeBar.value = this.videoDisplay.volume;
               this.volumeBar.muted = this.videoDisplay.muted;
            }
            if(Boolean(this.muteButton))
            {
               this.muteButton.volume = this.videoDisplay.volume;
               this.muteButton.muted = this.videoDisplay.muted;
            }
            if(Boolean(this.scrubBar))
            {
               this.updateScrubBar();
            }
            if(Boolean(this.currentTimeDisplay))
            {
               this.updateCurrentTime();
            }
            if(Boolean(this.durationDisplay))
            {
               this.updateDuration();
            }
         }
         else if(instance == this.playButton)
         {
            this.playButton.addEventListener(MouseEvent.CLICK,this.playButton_clickHandler);
         }
         else if(instance == this.pauseButton)
         {
            this.pauseButton.addEventListener(MouseEvent.CLICK,this.pauseButton_clickHandler);
         }
         else if(instance == this.playPauseButton)
         {
            this.playPauseButton.addEventListener(MouseEvent.CLICK,this.playPauseButton_clickHandler);
         }
         else if(instance == this.stopButton)
         {
            this.stopButton.addEventListener(MouseEvent.CLICK,this.stopButton_clickHandler);
         }
         else if(instance == this.muteButton)
         {
            if(Boolean(this.videoDisplay))
            {
               this.muteButton.muted = this.muted;
               this.muteButton.volume = this.volume;
            }
            this.muteButton.addEventListener(FlexEvent.MUTED_CHANGE,this.muteButton_mutedChangeHandler);
         }
         else if(instance == this.volumeBar)
         {
            this.volumeBar.minimum = 0;
            this.volumeBar.maximum = 1;
            if(Boolean(this.videoDisplay))
            {
               this.volumeBar.value = this.volume;
               this.volumeBar.muted = this.muted;
            }
            this.volumeBar.addEventListener(Event.CHANGE,this.volumeBar_changeHandler);
            this.volumeBar.addEventListener(FlexEvent.MUTED_CHANGE,this.volumeBar_mutedChangeHandler);
         }
         else if(instance == this.scrubBar)
         {
            if(Boolean(this.videoDisplay))
            {
               this.updateScrubBar();
            }
            this.scrubBar.addEventListener(TrackBaseEvent.THUMB_PRESS,this.scrubBar_thumbPressHandler);
            this.scrubBar.addEventListener(TrackBaseEvent.THUMB_RELEASE,this.scrubBar_thumbReleaseHandler);
            this.scrubBar.addEventListener(Event.CHANGE,this.scrubBar_changeHandler);
            this.scrubBar.addEventListener(FlexEvent.CHANGE_END,this.scrubBar_changeEndHandler);
            this.scrubBar.addEventListener(FlexEvent.CHANGE_START,this.scrubBar_changeStartHandler);
         }
         else if(instance == this.fullScreenButton)
         {
            this.fullScreenButton.addEventListener(MouseEvent.CLICK,this.fullScreenButton_clickHandler);
         }
         else if(instance == this.currentTimeDisplay)
         {
            if(Boolean(this.videoDisplay))
            {
               this.updateCurrentTime();
            }
         }
         else if(instance == this.durationDisplay)
         {
            if(Boolean(this.videoDisplay))
            {
               this.updateDuration();
            }
         }
      }
      
      private function videoDisplay_updateCompleteHandler(event:FlexEvent) : void
      {
         if(Boolean(this.videoDisplay_updateCompleteHandlerProperties.autoPlay))
         {
            this.videoDisplay.autoPlay = true;
         }
         if(this.videoDisplay_updateCompleteHandlerProperties.currentTime !== undefined)
         {
            this.videoDisplay.seek(this.videoDisplay_updateCompleteHandlerProperties.currentTime);
         }
         if(Boolean(this.videoDisplay_updateCompleteHandlerProperties.playing))
         {
            this.videoDisplay.play();
         }
         this.videoDisplay_updateCompleteHandlerProperties = null;
         this.videoDisplay.removeEventListener(FlexEvent.UPDATE_COMPLETE,this.videoDisplay_updateCompleteHandler);
      }
      
      override protected function partRemoved(partName:String, instance:Object) : void
      {
         var newVideoProperties:Object = null;
         super.partRemoved(partName,instance);
         if(instance == this.videoDisplay)
         {
            this.videoDisplay.validateNow();
            newVideoProperties = {};
            if(BitFlagUtil.isSet(this.videoDisplayProperties as uint,SOURCE_PROPERTY_FLAG))
            {
               newVideoProperties.source = this.videoDisplay.source;
            }
            if(BitFlagUtil.isSet(this.videoDisplayProperties as uint,AUTO_PLAY_PROPERTY_FLAG))
            {
               newVideoProperties.autoPlay = this.videoDisplay.autoPlay;
            }
            if(BitFlagUtil.isSet(this.videoDisplayProperties as uint,VOLUME_PROPERTY_FLAG))
            {
               newVideoProperties.volume = this.videoDisplay.volume;
            }
            if(BitFlagUtil.isSet(this.videoDisplayProperties as uint,AUTO_REWIND_PROPERTY_FLAG))
            {
               newVideoProperties.autoRewind = this.videoDisplay.autoRewind;
            }
            if(BitFlagUtil.isSet(this.videoDisplayProperties as uint,LOOP_PROPERTY_FLAG))
            {
               newVideoProperties.loop = this.videoDisplay.loop;
            }
            if(BitFlagUtil.isSet(this.videoDisplayProperties as uint,SCALE_MODE_PROPERTY_FLAG))
            {
               newVideoProperties.scaleMode = this.videoDisplay.scaleMode;
            }
            if(BitFlagUtil.isSet(this.videoDisplayProperties as uint,MUTED_PROPERTY_FLAG))
            {
               newVideoProperties.muted = this.videoDisplay.muted;
            }
            if(BitFlagUtil.isSet(this.videoDisplayProperties as uint,PAUSE_WHEN_HIDDEN_PROPERTY_FLAG))
            {
               newVideoProperties.pauseWhenHidden = this.videoDisplay.pauseWhenHidden;
            }
            if(BitFlagUtil.isSet(this.videoDisplayProperties as uint,AUTO_DISPLAY_FIRST_FRAME_PROPERTY_FLAG))
            {
               newVideoProperties.autoDisplayFirstFrame = this.videoDisplay.autoDisplayFirstFrame;
            }
            if(BitFlagUtil.isSet(this.videoDisplayProperties as uint,THUMBNAIL_SOURCE_PROPERTY_FLAG))
            {
               newVideoProperties.thumbnailSource = this.videoDisplay.thumbnailSource;
            }
            newVideoProperties.currentTime = this.videoDisplay.currentTime;
            newVideoProperties.playing = this.videoDisplay.playing;
            this.videoDisplay.stop();
            this.videoDisplayProperties = newVideoProperties;
            this.videoDisplay.removeEventListener(TimeEvent.CURRENT_TIME_CHANGE,this.videoDisplay_currentTimeChangeHandler);
            this.videoDisplay.removeEventListener(LoadEvent.BYTES_LOADED_CHANGE,this.videoDisplay_bytesLoadedChangeHandler);
            this.videoDisplay.removeEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE,this.videoDisplay_mediaPlayerStateChangeHandler);
            this.videoDisplay.removeEventListener(TimeEvent.DURATION_CHANGE,this.videoDisplay_durationChangeHandler);
            this.videoDisplay.removeEventListener(TimeEvent.COMPLETE,dispatchEvent);
            this.videoDisplay.removeEventListener("sourceChanged",dispatchEvent);
            this.videoDisplay.removeEventListener("volumeChanged",this.videoDisplay_volumeChangedHandler);
         }
         else if(instance == this.playButton)
         {
            this.playButton.removeEventListener(MouseEvent.CLICK,this.playButton_clickHandler);
         }
         else if(instance == this.pauseButton)
         {
            this.pauseButton.removeEventListener(MouseEvent.CLICK,this.pauseButton_clickHandler);
         }
         else if(instance == this.playPauseButton)
         {
            this.playPauseButton.removeEventListener(MouseEvent.CLICK,this.playPauseButton_clickHandler);
         }
         else if(instance == this.stopButton)
         {
            this.stopButton.removeEventListener(MouseEvent.CLICK,this.stopButton_clickHandler);
         }
         else if(instance == this.muteButton)
         {
            this.playButton.removeEventListener(FlexEvent.MUTED_CHANGE,this.muteButton_mutedChangeHandler);
         }
         else if(instance == this.volumeBar)
         {
            this.volumeBar.removeEventListener(Event.CHANGE,this.volumeBar_changeHandler);
            this.volumeBar.removeEventListener(FlexEvent.MUTED_CHANGE,this.volumeBar_mutedChangeHandler);
         }
         else if(instance == this.scrubBar)
         {
            this.scrubBar.removeEventListener(TrackBaseEvent.THUMB_PRESS,this.scrubBar_thumbPressHandler);
            this.scrubBar.removeEventListener(TrackBaseEvent.THUMB_RELEASE,this.scrubBar_thumbReleaseHandler);
            this.scrubBar.removeEventListener(Event.CHANGE,this.scrubBar_changeHandler);
            this.scrubBar.removeEventListener(FlexEvent.CHANGE_END,this.scrubBar_changeEndHandler);
            this.scrubBar.removeEventListener(FlexEvent.CHANGE_START,this.scrubBar_changeStartHandler);
         }
         else if(instance == this.fullScreenButton)
         {
            this.fullScreenButton.removeEventListener(MouseEvent.CLICK,this.fullScreenButton_clickHandler);
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.needsToUpdatePauseWhenHidden)
         {
            this.needsToUpdatePauseWhenHidden = false;
            this.pauseWhenHidden = this.exitingFullScreenPauseWhenHidden;
         }
      }
      
      public function pause() : void
      {
         this.videoDisplay.pause();
      }
      
      public function play() : void
      {
         this.videoDisplay.play();
      }
      
      public function seek(time:Number) : void
      {
         this.videoDisplay.seek(time);
      }
      
      public function stop() : void
      {
         this.videoDisplay.stop();
      }
      
      private function updateScrubBar() : void
      {
         if(!this.videoDisplay)
         {
            return;
         }
         if(!this.scrubBarMouseCaptured && !this.scrubBarChanging)
         {
            this.scrubBar.minimum = 0;
            this.scrubBar.maximum = this.videoDisplay.duration;
            this.scrubBar.value = this.videoDisplay.currentTime;
         }
         if(!this.videoDisplay.videoPlayer.canLoad)
         {
            this.scrubBar.loadedRangeEnd = this.videoDisplay.duration;
         }
         else if(this.videoDisplay.bytesTotal == 0)
         {
            this.scrubBar.loadedRangeEnd = 0;
         }
         else
         {
            this.scrubBar.loadedRangeEnd = this.videoDisplay.bytesLoaded / this.videoDisplay.bytesTotal * this.videoDisplay.duration;
         }
      }
      
      private function updateDuration() : void
      {
         this.durationDisplay.text = this.formatTimeValue(this.duration);
      }
      
      protected function formatTimeValue(value:Number) : String
      {
         value = Math.round(value);
         var hours:uint = Math.floor(value / 3600) % 24;
         var minutes:uint = Math.floor(value / 60) % 60;
         var seconds:uint = value % 60;
         var result:String = "";
         if(hours != 0)
         {
            result = hours + ":";
         }
         if(Boolean(result) && minutes < 10)
         {
            result += "0" + minutes + ":";
         }
         else
         {
            result += minutes + ":";
         }
         if(seconds < 10)
         {
            result += "0" + seconds;
         }
         else
         {
            result += seconds;
         }
         return result;
      }
      
      private function updateCurrentTime() : void
      {
         this.currentTimeDisplay.text = this.formatTimeValue(this.currentTime);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getScreenBounds() : Rectangle
      {
         var nativeWindowBounds:Rectangle = null;
         var currentScreen:Object = null;
         var resultRect:Rectangle = new Rectangle(0,0,stage.fullScreenWidth,stage.fullScreenHeight);
         if(Boolean(screenClass))
         {
            try
            {
               nativeWindowBounds = stage["nativeWindow"]["bounds"];
               currentScreen = screenClass["getScreensForRectangle"](nativeWindowBounds)[0];
               resultRect = currentScreen["bounds"];
            }
            catch(e:Error)
            {
            }
         }
         return resultRect;
      }
      
      private function videoDisplay_currentTimeChangeHandler(event:TimeEvent) : void
      {
         if(Boolean(this.scrubBar))
         {
            this.updateScrubBar();
         }
         if(Boolean(this.currentTimeDisplay))
         {
            this.updateCurrentTime();
         }
         dispatchEvent(event);
      }
      
      private function videoDisplay_bytesLoadedChangeHandler(event:LoadEvent) : void
      {
         if(Boolean(this.scrubBar))
         {
            this.updateScrubBar();
         }
         dispatchEvent(event);
      }
      
      private function videoDisplay_mediaPlayerStateChangeHandler(event:MediaPlayerStateChangeEvent) : void
      {
         invalidateSkinState();
         if(Boolean(this.scrubBar))
         {
            this.updateScrubBar();
         }
         if(Boolean(this.durationDisplay))
         {
            this.updateDuration();
         }
         if(Boolean(this.currentTimeDisplay))
         {
            this.updateCurrentTime();
         }
         if(Boolean(this.playPauseButton))
         {
            this.playPauseButton.selected = this.playing;
         }
         dispatchEvent(event);
      }
      
      private function videoDisplay_durationChangeHandler(event:TimeEvent) : void
      {
         if(Boolean(this.scrubBar))
         {
            this.updateScrubBar();
         }
         if(Boolean(this.durationDisplay))
         {
            this.updateDuration();
         }
         dispatchEvent(event);
      }
      
      private function videoDisplay_volumeChangedHandler(event:Event) : void
      {
         if(Boolean(this.volumeBar))
         {
            this.volumeBar.value = this.volume;
            this.volumeBar.muted = this.muted;
         }
         if(Boolean(this.muteButton))
         {
            this.muteButton.muted = this.muted;
            this.muteButton.volume = this.volume;
         }
         dispatchEvent(event);
      }
      
      private function fullScreenButton_clickHandler(event:MouseEvent) : void
      {
         var screenBounds:Rectangle = null;
         var oldPauseWhenHidden:Boolean = false;
         var fullScreenHideControlsDelay:Number = NaN;
         var ivec:IVisualElementContainer = null;
         if(!this.fullScreen)
         {
            if(!systemManager.getTopLevelRoot())
            {
               return;
            }
            screenBounds = this.getScreenBounds();
            this.fullScreen = true;
            invalidateSkinState();
            oldPauseWhenHidden = this.pauseWhenHidden;
            this.beforeFullScreenInfo = {
               "parent":this.parent,
               "x":this.x,
               "y":this.y,
               "explicitWidth":this.explicitWidth,
               "explicitHeight":this.explicitHeight,
               "percentWidth":this.percentWidth,
               "percentHeight":this.percentHeight,
               "isPopUp":this.isPopUp
            };
            this.pauseWhenHidden = false;
            if(!isPopUp)
            {
               if(parent is IVisualElementContainer)
               {
                  ivec = IVisualElementContainer(parent);
                  this.beforeFullScreenInfo.childIndex = ivec.getElementIndex(this);
                  ivec.removeElement(this);
               }
               else
               {
                  this.beforeFullScreenInfo.childIndex = parent.getChildIndex(this);
                  parent.removeChild(this);
               }
               PopUpManager.addPopUp(this,FlexGlobals.topLevelApplication as DisplayObject,false,null,moduleFactory);
            }
            setLayoutBoundsSize(screenBounds.width,screenBounds.height,true);
            this.explicitWidth = width;
            this.explicitHeight = height;
            setLayoutBoundsPosition(0,0,true);
            if(Boolean(this.videoDisplay.videoObject))
            {
               this.beforeFullScreenInfo.smoothing = this.videoDisplay.videoObject.smoothing;
               this.beforeFullScreenInfo.deblocking = this.videoDisplay.videoObject.deblocking;
               this.videoDisplay.videoObject.smoothing = false;
               this.videoDisplay.videoObject.deblocking = 0;
            }
            this.validateNow();
            systemManager.stage.addEventListener(FullScreenEvent.FULL_SCREEN,this.fullScreenEventHandler);
            systemManager.stage.displayState = StageDisplayState.FULL_SCREEN;
            this.pauseWhenHidden = oldPauseWhenHidden;
            fullScreenHideControlsDelay = Number(getStyle("fullScreenHideControlsDelay"));
            if(fullScreenHideControlsDelay == 0)
            {
               this.playerControls.visible = false;
               if(Boolean(this.volumeBar))
               {
                  this.volumeBar.closeDropDown(true);
               }
            }
            else if(fullScreenHideControlsDelay < Infinity)
            {
               this.fullScreenHideControlTimer = new Timer(fullScreenHideControlsDelay,1);
               this.fullScreenHideControlTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.fullScreenHideControlTimer_timerCompleteHandler,false,0,true);
               systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_DOWN,this.resetFullScreenHideControlTimer);
               systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_MOVE,this.resetFullScreenHideControlTimer);
               systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_WHEEL,this.resetFullScreenHideControlTimer);
               systemManager.getSandboxRoot().addEventListener(KeyboardEvent.KEY_DOWN,this.resetFullScreenHideControlTimer);
               this.fullScreenHideControlTimer.start();
            }
         }
         else
         {
            systemManager.stage.displayState = StageDisplayState.NORMAL;
         }
      }
      
      private function fullScreenHideControlTimer_timerCompleteHandler(event:TimerEvent) : void
      {
         this.playerControls.visible = false;
         if(Boolean(this.volumeBar))
         {
            this.volumeBar.closeDropDown(true);
         }
      }
      
      private function resetFullScreenHideControlTimer(event:Event) : void
      {
         this.playerControls.visible = true;
         if(Boolean(this.fullScreenHideControlTimer))
         {
            this.fullScreenHideControlTimer.reset();
            this.fullScreenHideControlTimer.start();
         }
         else
         {
            this.fullScreenHideControlTimer = new Timer(getStyle("fullScreenHideControlsDelay"),1);
            this.fullScreenHideControlTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.fullScreenHideControlTimer_timerCompleteHandler,false,0,true);
         }
      }
      
      private function fullScreenEventHandler(event:FullScreenEvent) : void
      {
         if(event.fullScreen)
         {
            return;
         }
         this.exitingFullScreenPauseWhenHidden = this.pauseWhenHidden;
         this.pauseWhenHidden = false;
         this.fullScreen = false;
         systemManager.stage.removeEventListener(FullScreenEvent.FULL_SCREEN,this.fullScreenEventHandler);
         systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_DOWN,this.resetFullScreenHideControlTimer);
         systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE,this.resetFullScreenHideControlTimer);
         systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_WHEEL,this.resetFullScreenHideControlTimer);
         systemManager.getSandboxRoot().removeEventListener(KeyboardEvent.KEY_DOWN,this.resetFullScreenHideControlTimer);
         if(Boolean(this.fullScreenHideControlTimer))
         {
            this.fullScreenHideControlTimer.stop();
            this.fullScreenHideControlTimer = null;
         }
         this.playerControls.visible = true;
         this.x = this.beforeFullScreenInfo.x;
         this.y = this.beforeFullScreenInfo.y;
         this.explicitWidth = this.beforeFullScreenInfo.explicitWidth;
         this.explicitHeight = this.beforeFullScreenInfo.explicitHeight;
         this.percentWidth = this.beforeFullScreenInfo.percentWidth;
         this.percentHeight = this.beforeFullScreenInfo.percentHeight;
         if(Boolean(this.videoDisplay.videoObject) && this.beforeFullScreenInfo.smoothing !== undefined)
         {
            this.videoDisplay.videoObject.smoothing = this.beforeFullScreenInfo.smoothing;
            this.videoDisplay.videoObject.deblocking = this.beforeFullScreenInfo.deblocking;
         }
         if(!this.beforeFullScreenInfo.isPopUp)
         {
            PopUpManager.removePopUp(this);
            if(this.beforeFullScreenInfo.parent is IVisualElementContainer)
            {
               this.beforeFullScreenInfo.parent.addElementAt(this,this.beforeFullScreenInfo.childIndex);
            }
            else
            {
               this.beforeFullScreenInfo.parent.addChildAt(this,this.beforeFullScreenInfo.childIndex);
            }
         }
         if(this.exitingFullScreenPauseWhenHidden)
         {
            this.needsToUpdatePauseWhenHidden = true;
            invalidateProperties();
         }
         this.beforeFullScreenInfo = null;
         invalidateSkinState();
         invalidateSize();
         invalidateDisplayList();
      }
      
      private function playButton_clickHandler(event:MouseEvent) : void
      {
         if(!this.playing)
         {
            this.play();
         }
      }
      
      private function pauseButton_clickHandler(event:MouseEvent) : void
      {
         this.pause();
      }
      
      private function stopButton_clickHandler(event:MouseEvent) : void
      {
         this.stop();
      }
      
      private function playPauseButton_clickHandler(event:MouseEvent) : void
      {
         if(this.playing)
         {
            this.pause();
         }
         else
         {
            this.play();
         }
         this.playPauseButton.selected = this.playing;
      }
      
      private function muteButton_mutedChangeHandler(event:FlexEvent) : void
      {
         this.muted = this.muteButton.muted;
      }
      
      private function volumeBar_changeHandler(event:Event) : void
      {
         if(this.volume != this.volumeBar.value)
         {
            this.volume = this.volumeBar.value;
         }
      }
      
      private function volumeBar_mutedChangeHandler(event:FlexEvent) : void
      {
         if(this.muted != this.volumeBar.muted)
         {
            this.muted = this.volumeBar.muted;
         }
      }
      
      private function scrubBar_changeStartHandler(event:Event) : void
      {
         this.scrubBarChanging = true;
      }
      
      private function scrubBar_thumbPressHandler(event:TrackBaseEvent) : void
      {
         this.scrubBarMouseCaptured = true;
         if(this.playing)
         {
            this.pause();
            this.wasPlayingBeforeSeeking = true;
         }
      }
      
      private function scrubBar_thumbReleaseHandler(event:TrackBaseEvent) : void
      {
         this.scrubBarMouseCaptured = false;
         if(this.wasPlayingBeforeSeeking)
         {
            this.play();
            this.wasPlayingBeforeSeeking = false;
         }
      }
      
      private function scrubBar_changeHandler(event:Event) : void
      {
         this.seek(this.scrubBar.value);
      }
      
      private function scrubBar_changeEndHandler(event:Event) : void
      {
         this.scrubBarChanging = false;
      }
   }
}

