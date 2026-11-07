package blix.assets.proxy.abilities
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.common.Empty;
   import blix.assets.proxy.common.HitArea;
   import blix.assets.proxy.common.loadingAnimation;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   
   public class AbilitiesVideoAsset extends InstanceMapping
   {
      
      public var bufferingAnimation:loadingAnimation;
      
      public var pauseButton:HitArea;
      
      public var playButton:VideoPlayButton;
      
      public var videoUnavailableText:TextFieldMapping;
      
      public var stillImageContainer:Empty;
      
      public var videoContainer:Empty;
      
      public var videoSizer:HitArea;
      
      public function AbilitiesVideoAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.bufferingAnimation = new loadingAnimation("bufferingAnimation",this);
         this.pauseButton = new HitArea("pauseButton",this);
         this.playButton = new VideoPlayButton("playButton",this);
         this.videoUnavailableText = new TextFieldMapping("videoUnavailableText",this);
         this.stillImageContainer = new Empty("stillImageContainer",this);
         this.videoContainer = new Empty("videoContainer",this);
         this.videoSizer = new HitArea("videoSizer",this);
      }
      
      public function create(param1:DisplayObjectContainerProxy) : SpriteProxy
      {
         var _loc2_:String = getName();
         var _loc3_:SpriteProxy = new SpriteProxy(param1);
         param1.setTimelineChildByName(_loc2_,_loc3_);
         return _loc3_;
      }
   }
}

