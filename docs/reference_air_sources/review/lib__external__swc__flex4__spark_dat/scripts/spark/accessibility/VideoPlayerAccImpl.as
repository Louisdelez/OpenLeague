package spark.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import mx.accessibility.AccConst;
   import mx.accessibility.AccImpl;
   import mx.core.UIComponent;
   import mx.events.FlexEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import org.osmf.events.TimeEvent;
   import spark.components.VideoPlayer;
   import spark.components.mediaClasses.ScrubBar;
   import spark.components.mediaClasses.VolumeBar;
   import spark.components.supportClasses.ButtonBase;
   import spark.components.supportClasses.ToggleButtonBase;
   import spark.events.SkinPartEvent;
   
   [ResourceBundle("components")]
   public class VideoPlayerAccImpl extends AccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const VIDEOPLAYER_PLAYPAUSEBUTTON:uint = 1;
      
      private static const VIDEOPLAYER_SCRUBBAR:uint = 2;
      
      private static const VIDEOPLAYER_CURRENTTIMEDISPLAY:uint = 3;
      
      private static const VIDEOPLAYER_MUTEBUTTON:uint = 4;
      
      private static const VIDEOPLAYER_VOLUMEBAR:uint = 5;
      
      private static const VIDEOPLAYER_FULLSCREENBUTTON:uint = 6;
      
      private static const VIDEOPLAYER_NUM_ACCESSIBLE_COMPONENTS:uint = 6;
      
      public function VideoPlayerAccImpl(master:UIComponent)
      {
         super(master);
         role = AccConst.ROLE_SYSTEM_PANE;
         var playPauseButton:ToggleButtonBase = VideoPlayer(master).playPauseButton;
         if(Boolean(playPauseButton))
         {
            playPauseButton.addEventListener(Event.CHANGE,this.eventHandler);
            if(VideoPlayer(master).tabIndex > 0 && playPauseButton.tabIndex == -1)
            {
               playPauseButton.tabIndex = VideoPlayer(master).tabIndex;
            }
         }
         var volumeBar:VolumeBar = VideoPlayer(master).volumeBar;
         if(Boolean(volumeBar))
         {
            volumeBar.addEventListener(Event.CHANGE,this.eventHandler);
            volumeBar.addEventListener(FlexEvent.MUTED_CHANGE,this.eventHandler);
            if(VideoPlayer(master).tabIndex > 0 && volumeBar.tabIndex == -1)
            {
               volumeBar.tabIndex = VideoPlayer(master).tabIndex;
            }
         }
         if(Boolean(VideoPlayer(master).scrubBar))
         {
            if(VideoPlayer(master).tabIndex > 0 && VideoPlayer(master).scrubBar.tabIndex == -1)
            {
               VideoPlayer(master).scrubBar.tabIndex = VideoPlayer(master).tabIndex;
            }
         }
         if(Boolean(VideoPlayer(master).fullScreenButton))
         {
            if(VideoPlayer(master).tabIndex > 0 && VideoPlayer(master).fullScreenButton.tabIndex == -1)
            {
               VideoPlayer(master).fullScreenButton.tabIndex = VideoPlayer(master).tabIndex;
            }
         }
      }
      
      public static function enableAccessibility() : void
      {
         VideoPlayer.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new VideoPlayerAccImpl(component);
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat([MouseEvent.CLICK,FocusEvent.FOCUS_IN,TimeEvent.CURRENT_TIME_CHANGE,SkinPartEvent.PART_ADDED,SkinPartEvent.PART_REMOVED]);
      }
      
      override public function accLocation(childID:uint) : *
      {
         var videoPlayer:VideoPlayer = VideoPlayer(master);
         switch(childID)
         {
            case VIDEOPLAYER_PLAYPAUSEBUTTON:
               return Boolean(videoPlayer.playPauseButton) ? videoPlayer.playPauseButton : null;
            case VIDEOPLAYER_SCRUBBAR:
               return Boolean(videoPlayer.scrubBar) ? videoPlayer.scrubBar : null;
            case VIDEOPLAYER_CURRENTTIMEDISPLAY:
               return Boolean(videoPlayer.currentTimeDisplay) ? videoPlayer.currentTimeDisplay : null;
            case VIDEOPLAYER_MUTEBUTTON:
               return Boolean(videoPlayer.volumeBar) ? videoPlayer.volumeBar : null;
            case VIDEOPLAYER_VOLUMEBAR:
               return Boolean(videoPlayer.volumeBar) && Boolean(videoPlayer.volumeBar.dropDown) ? videoPlayer.volumeBar.dropDown : null;
            case VIDEOPLAYER_FULLSCREENBUTTON:
               return Boolean(videoPlayer.fullScreenButton) ? videoPlayer.fullScreenButton : null;
            default:
               return;
         }
      }
      
      override public function getChildIDArray() : Array
      {
         return createChildIDArray(VIDEOPLAYER_NUM_ACCESSIBLE_COMPONENTS);
      }
      
      override public function get_accRole(childID:uint) : uint
      {
         var accRole:uint = uint(AccConst.ROLE_SYSTEM_GRAPHIC);
         switch(childID)
         {
            case 0:
               accRole = uint(role);
               break;
            case VIDEOPLAYER_PLAYPAUSEBUTTON:
               if(!VideoPlayer(master).playPauseButton)
               {
                  break;
               }
               accRole = uint(AccConst.ROLE_SYSTEM_PUSHBUTTON);
               break;
            case VIDEOPLAYER_SCRUBBAR:
               if(!VideoPlayer(master).scrubBar)
               {
                  break;
               }
               accRole = uint(AccConst.ROLE_SYSTEM_SLIDER);
               break;
            case VIDEOPLAYER_CURRENTTIMEDISPLAY:
               if(!VideoPlayer(master).currentTimeDisplay)
               {
                  break;
               }
               accRole = uint(AccConst.ROLE_SYSTEM_STATICTEXT);
               break;
            case VIDEOPLAYER_MUTEBUTTON:
               if(!VideoPlayer(master).volumeBar)
               {
                  break;
               }
               accRole = uint(AccConst.ROLE_SYSTEM_PUSHBUTTON);
               break;
            case VIDEOPLAYER_VOLUMEBAR:
               if(!VideoPlayer(master).volumeBar)
               {
                  break;
               }
               accRole = uint(AccConst.ROLE_SYSTEM_SLIDER);
               break;
            case VIDEOPLAYER_FULLSCREENBUTTON:
               if(!VideoPlayer(master).fullScreenButton)
               {
                  break;
               }
               accRole = uint(AccConst.ROLE_SYSTEM_PUSHBUTTON);
         }
         return accRole;
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var accState:uint = 0;
         var index:uint = this.get_accFocus();
         var videoPlayer:VideoPlayer = VideoPlayer(master);
         accState |= getState(childID);
         if(!videoPlayer.enabled)
         {
            return uint(accState | AccConst.STATE_SYSTEM_UNAVAILABLE);
         }
         if(!videoPlayer.volumeBar || childID == VIDEOPLAYER_VOLUMEBAR && !videoPlayer.volumeBar.isDropDownOpen)
         {
            return uint(accState | AccConst.STATE_SYSTEM_UNAVAILABLE);
         }
         if(childID == VIDEOPLAYER_PLAYPAUSEBUTTON && !videoPlayer.playPauseButton || childID == VIDEOPLAYER_PLAYPAUSEBUTTON && !videoPlayer.playPauseButton.enabled || (childID == VIDEOPLAYER_SCRUBBAR && !videoPlayer.scrubBar || childID == VIDEOPLAYER_SCRUBBAR && !videoPlayer.scrubBar.enabled) || (childID == VIDEOPLAYER_CURRENTTIMEDISPLAY && !videoPlayer.currentTimeDisplay || childID == VIDEOPLAYER_CURRENTTIMEDISPLAY && !(videoPlayer.currentTimeDisplay is UIComponent && Boolean(UIComponent(videoPlayer.currentTimeDisplay).enabled))) || (childID == VIDEOPLAYER_MUTEBUTTON && !videoPlayer.volumeBar || childID == VIDEOPLAYER_MUTEBUTTON && !videoPlayer.volumeBar.enabled) || (childID == VIDEOPLAYER_VOLUMEBAR && !videoPlayer.volumeBar || childID == VIDEOPLAYER_VOLUMEBAR && !videoPlayer.volumeBar.enabled) || (childID == VIDEOPLAYER_FULLSCREENBUTTON && !videoPlayer.fullScreenButton || childID == VIDEOPLAYER_FULLSCREENBUTTON && !videoPlayer.fullScreenButton.enabled))
         {
            return uint(accState | AccConst.STATE_SYSTEM_UNAVAILABLE);
         }
         if(childID != VIDEOPLAYER_CURRENTTIMEDISPLAY)
         {
            accState |= AccConst.STATE_SYSTEM_FOCUSABLE;
         }
         if(childID == index)
         {
            accState |= AccConst.STATE_SYSTEM_FOCUSED;
         }
         return accState;
      }
      
      override public function get_accDefaultAction(childID:uint) : String
      {
         var action:String = "";
         switch(childID)
         {
            case VIDEOPLAYER_PLAYPAUSEBUTTON:
               if(!VideoPlayer(master).playPauseButton)
               {
                  break;
               }
               action = "Toggle";
               break;
            case VIDEOPLAYER_MUTEBUTTON:
               if(!VideoPlayer(master).volumeBar)
               {
                  break;
               }
               action = "Press";
               break;
            case VIDEOPLAYER_FULLSCREENBUTTON:
               if(!VideoPlayer(master).fullScreenButton)
               {
                  break;
               }
               action = "Press";
         }
         return action;
      }
      
      override public function get_accFocus() : uint
      {
         var videoPlayer:VideoPlayer = VideoPlayer(master);
         var index:Number = 0;
         return this.elementToChildID(videoPlayer.getFocus());
      }
      
      override public function accDoDefaultAction(childID:uint) : void
      {
         var clickEvent:MouseEvent = null;
         var mutedChangeEvent:FlexEvent = null;
         var videoPlayer:VideoPlayer = VideoPlayer(master);
         if(master.enabled)
         {
            if(childID == VIDEOPLAYER_PLAYPAUSEBUTTON && Boolean(videoPlayer.playPauseButton))
            {
               clickEvent = new MouseEvent(MouseEvent.CLICK);
               videoPlayer.playPauseButton.dispatchEvent(clickEvent);
            }
            else if(childID == VIDEOPLAYER_MUTEBUTTON && Boolean(videoPlayer.volumeBar))
            {
               videoPlayer.volumeBar.muted = !videoPlayer.volumeBar.muted;
               mutedChangeEvent = new FlexEvent(FlexEvent.MUTED_CHANGE);
               videoPlayer.volumeBar.dispatchEvent(mutedChangeEvent);
            }
            else if(childID == VIDEOPLAYER_FULLSCREENBUTTON && Boolean(videoPlayer.fullScreenButton))
            {
               clickEvent = new MouseEvent(MouseEvent.CLICK);
               videoPlayer.fullScreenButton.dispatchEvent(clickEvent);
            }
         }
      }
      
      override public function get_accValue(childID:uint) : String
      {
         var videoPlayer:VideoPlayer = VideoPlayer(master);
         var accValue:String = "";
         if(childID == VIDEOPLAYER_SCRUBBAR && Boolean(videoPlayer.currentTimeDisplay))
         {
            accValue = videoPlayer.currentTimeDisplay.text;
         }
         else if(childID == VIDEOPLAYER_VOLUMEBAR && Boolean(videoPlayer.volumeBar))
         {
            accValue = String(Math.floor(videoPlayer.volumeBar.value * 100));
         }
         return accValue;
      }
      
      override public function accSelect(selFlag:uint, childID:uint) : void
      {
         var videoPlayer:VideoPlayer = VideoPlayer(master);
         if(selFlag == AccConst.SELFLAG_TAKEFOCUS)
         {
            switch(childID)
            {
               case VIDEOPLAYER_PLAYPAUSEBUTTON:
                  if(Boolean(videoPlayer.playPauseButton))
                  {
                     videoPlayer.playPauseButton.setFocus();
                  }
                  break;
               case VIDEOPLAYER_SCRUBBAR:
                  if(Boolean(videoPlayer.scrubBar))
                  {
                     videoPlayer.scrubBar.setFocus();
                  }
                  break;
               case VIDEOPLAYER_MUTEBUTTON:
                  if(Boolean(videoPlayer.volumeBar))
                  {
                     videoPlayer.volumeBar.setFocus();
                  }
                  break;
               case VIDEOPLAYER_VOLUMEBAR:
                  if(Boolean(videoPlayer.volumeBar))
                  {
                     videoPlayer.volumeBar.setFocus();
                  }
                  break;
               case VIDEOPLAYER_FULLSCREENBUTTON:
                  if(Boolean(videoPlayer.fullScreenButton))
                  {
                     videoPlayer.fullScreenButton.setFocus();
                  }
            }
         }
      }
      
      override protected function getName(childID:uint) : String
      {
         var label:String = null;
         var videoPlayer:VideoPlayer = VideoPlayer(master);
         var resourceManager:IResourceManager = ResourceManager.getInstance();
         var name1:String = "";
         var name2:String = "";
         switch(childID)
         {
            case 0:
               label = Boolean(videoPlayer.accessibilityName) ? videoPlayer.accessibilityName : resourceManager.getString("components","videoPlayerVideoDisplayAccName");
               break;
            case VIDEOPLAYER_PLAYPAUSEBUTTON:
               if(!videoPlayer.playPauseButton)
               {
                  break;
               }
               label = Boolean(videoPlayer.playPauseButton.accessibilityProperties) ? videoPlayer.playPauseButton.accessibilityName : "";
               if(!label)
               {
                  label = resourceManager.getString("components","videoPlayerPlayButtonAccName");
               }
               if(label.indexOf(",") >= 0)
               {
                  name1 = label.split(",",2)[0];
                  name2 = label.split(",",2)[1];
               }
               else
               {
                  name1 = name2 = label;
               }
               label = videoPlayer.playing ? name2 : name1;
               break;
            case VIDEOPLAYER_SCRUBBAR:
               if(!videoPlayer.scrubBar)
               {
                  break;
               }
               label = Boolean(videoPlayer.scrubBar.accessibilityName) ? videoPlayer.scrubBar.accessibilityName : resourceManager.getString("components","videoPlayerScrubBarAccName");
               break;
            case VIDEOPLAYER_CURRENTTIMEDISPLAY:
               if(!videoPlayer.currentTimeDisplay || !videoPlayer.durationDisplay)
               {
                  break;
               }
               label = videoPlayer.currentTimeDisplay.text + "/" + videoPlayer.durationDisplay.text;
               break;
            case VIDEOPLAYER_MUTEBUTTON:
               if(!videoPlayer.volumeBar || !videoPlayer.volumeBar.muteButton)
               {
                  break;
               }
               label = Boolean(videoPlayer.volumeBar.muteButton.accessibilityProperties) ? videoPlayer.volumeBar.muteButton.accessibilityName : "";
               if(!label)
               {
                  label = resourceManager.getString("components","videoPlayerMuteButtonAccName");
               }
               if(label.indexOf(",") >= 0)
               {
                  name1 = label.split(",",2)[0];
                  name2 = label.split(",",2)[1];
               }
               else
               {
                  name1 = name2 = label;
               }
               label = videoPlayer.volumeBar.muted ? name2 : name1;
               break;
            case VIDEOPLAYER_VOLUMEBAR:
               if(!videoPlayer.volumeBar)
               {
                  break;
               }
               label = Boolean(videoPlayer.volumeBar.accessibilityName) ? videoPlayer.volumeBar.accessibilityName : resourceManager.getString("components","videoPlayerVolumeBarAccName");
               break;
            case VIDEOPLAYER_FULLSCREENBUTTON:
               if(!videoPlayer.fullScreenButton)
               {
                  break;
               }
               label = Boolean(videoPlayer.fullScreenButton.accessibilityName) ? videoPlayer.fullScreenButton.accessibilityName : resourceManager.getString("components","videoPlayerFullScreenButtonAccName");
         }
         return label;
      }
      
      private function elementToChildID(obj:Object) : Number
      {
         var index:Number = 0;
         var str:String = String(obj);
         if(str.search("playPauseButton") > 0)
         {
            index = VIDEOPLAYER_PLAYPAUSEBUTTON;
         }
         else if(str.search("scrubBar") > 0)
         {
            index = VIDEOPLAYER_SCRUBBAR;
         }
         else if(str.search("durationDisplay") > 0)
         {
            index = VIDEOPLAYER_CURRENTTIMEDISPLAY;
         }
         else if(str.search("volumeBar") > 0)
         {
            index = VIDEOPLAYER_VOLUMEBAR;
         }
         else if(str.search("fullScreenButton") > 0)
         {
            index = VIDEOPLAYER_FULLSCREENBUTTON;
         }
         return index;
      }
      
      override protected function eventHandler(event:Event) : void
      {
         var playPauseButton:ToggleButtonBase = null;
         var volumeBar:VolumeBar = null;
         var scrubBar:ScrubBar = null;
         var fullScreenButton:ButtonBase = null;
         var msaaEvt:uint = 0;
         $eventHandler(event);
         var childID:Number = this.elementToChildID(event.target);
         switch(event.type)
         {
            case MouseEvent.CLICK:
               Accessibility.sendEvent(master,0,AccConst.EVENT_OBJECT_STATECHANGE);
               Accessibility.updateProperties();
               break;
            case FocusEvent.FOCUS_IN:
               Accessibility.sendEvent(master,this.get_accFocus(),AccConst.EVENT_OBJECT_FOCUS);
               Accessibility.updateProperties();
               break;
            case Event.CHANGE:
               msaaEvt = 0;
               if(childID == VIDEOPLAYER_PLAYPAUSEBUTTON || childID == VIDEOPLAYER_MUTEBUTTON || childID == VIDEOPLAYER_FULLSCREENBUTTON)
               {
                  msaaEvt = uint(AccConst.EVENT_OBJECT_NAMECHANGE);
               }
               else if(childID == VIDEOPLAYER_SCRUBBAR || childID == VIDEOPLAYER_VOLUMEBAR)
               {
                  msaaEvt = uint(AccConst.EVENT_OBJECT_VALUECHANGE);
               }
               if(childID != VIDEOPLAYER_CURRENTTIMEDISPLAY && childID != 0)
               {
                  Accessibility.sendEvent(master,childID,msaaEvt);
                  Accessibility.updateProperties();
                  break;
               }
            case FlexEvent.MUTED_CHANGE:
               Accessibility.sendEvent(master,VIDEOPLAYER_MUTEBUTTON,AccConst.EVENT_OBJECT_NAMECHANGE);
               Accessibility.updateProperties();
               break;
            case TimeEvent.CURRENT_TIME_CHANGE:
               Accessibility.sendEvent(master,VIDEOPLAYER_SCRUBBAR,AccConst.EVENT_OBJECT_VALUECHANGE);
               Accessibility.sendEvent(master,VIDEOPLAYER_CURRENTTIMEDISPLAY,AccConst.EVENT_OBJECT_NAMECHANGE);
               Accessibility.updateProperties();
               break;
            case SkinPartEvent.PART_ADDED:
               playPauseButton = VideoPlayer(master).playPauseButton;
               if(SkinPartEvent(event).instance == playPauseButton)
               {
                  playPauseButton.addEventListener(Event.CHANGE,this.eventHandler);
                  if(VideoPlayer(master).tabIndex > 0 && playPauseButton.tabIndex == -1)
                  {
                     playPauseButton.tabIndex = VideoPlayer(master).tabIndex;
                  }
               }
               volumeBar = VideoPlayer(master).volumeBar;
               if(SkinPartEvent(event).instance == volumeBar)
               {
                  volumeBar.addEventListener(Event.CHANGE,this.eventHandler);
                  volumeBar.addEventListener(FlexEvent.MUTED_CHANGE,this.eventHandler);
                  if(VideoPlayer(master).tabIndex > 0 && volumeBar.tabIndex == -1)
                  {
                     volumeBar.tabIndex = VideoPlayer(master).tabIndex;
                  }
               }
               scrubBar = VideoPlayer(master).scrubBar;
               if(SkinPartEvent(event).instance == scrubBar)
               {
                  if(VideoPlayer(master).tabIndex > 0 && scrubBar.tabIndex == -1)
                  {
                     scrubBar.tabIndex = VideoPlayer(master).tabIndex;
                  }
               }
               fullScreenButton = VideoPlayer(master).fullScreenButton;
               if(SkinPartEvent(event).instance == fullScreenButton)
               {
                  if(VideoPlayer(master).tabIndex > 0 && fullScreenButton.tabIndex == -1)
                  {
                     fullScreenButton.tabIndex = VideoPlayer(master).tabIndex;
                  }
               }
               break;
            case SkinPartEvent.PART_REMOVED:
               playPauseButton = VideoPlayer(master).playPauseButton;
               if(SkinPartEvent(event).instance == playPauseButton)
               {
                  playPauseButton.removeEventListener(Event.CHANGE,this.eventHandler);
               }
               volumeBar = VideoPlayer(master).volumeBar;
               if(SkinPartEvent(event).instance == volumeBar)
               {
                  volumeBar.removeEventListener(Event.CHANGE,this.eventHandler);
                  volumeBar.removeEventListener(FlexEvent.MUTED_CHANGE,this.eventHandler);
               }
         }
      }
   }
}

