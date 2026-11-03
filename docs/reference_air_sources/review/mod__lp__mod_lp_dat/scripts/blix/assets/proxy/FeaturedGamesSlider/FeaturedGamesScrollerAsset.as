package blix.assets.proxy.FeaturedGamesSlider
{
   import blix.assets.proxy.Common.FeaturedGamesHitAreaAsset;
   import blix.assets.proxy.Common.empty;
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.next_btn;
   import blix.assets.proxy.prev_btn;
   
   public class FeaturedGamesScrollerAsset extends InstanceMapping
   {
      
      public var watchNowAsset:watchbtn;
      
      public var prevGameAsset:prev_btn;
      
      public var nextGameAsset:next_btn;
      
      public var indicatorContainerAsset:empty;
      
      public var callToActionAsset:FeaturedGamesHitAreaAsset;
      
      public var featuredGameAsset:FeaturedGameAsset;
      
      public function FeaturedGamesScrollerAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.watchNowAsset = new watchbtn("watchNowAsset",this);
         this.prevGameAsset = new prev_btn("prevGameAsset",this);
         this.nextGameAsset = new next_btn("nextGameAsset",this);
         this.indicatorContainerAsset = new empty("indicatorContainerAsset",this);
         this.callToActionAsset = new FeaturedGamesHitAreaAsset("callToActionAsset",this);
         this.featuredGameAsset = new FeaturedGameAsset("featuredGameAsset",this);
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

