package blix.assets.proxy.FeaturedGamesSlider
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   
   public class TeamOneAsset extends InstanceMapping
   {
      
      public var player1ThumbAsset:PlayerThumbAsset;
      
      public var player2ThumbAsset:PlayerThumbAsset;
      
      public var player3ThumbAsset:PlayerThumbAsset;
      
      public var player4ThumbAsset:PlayerThumbAsset;
      
      public var player5ThumbAsset:PlayerThumbAsset;
      
      public function TeamOneAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.player1ThumbAsset = new PlayerThumbAsset("player1ThumbAsset",this);
         this.player2ThumbAsset = new PlayerThumbAsset("player2ThumbAsset",this);
         this.player3ThumbAsset = new PlayerThumbAsset("player3ThumbAsset",this);
         this.player4ThumbAsset = new PlayerThumbAsset("player4ThumbAsset",this);
         this.player5ThumbAsset = new PlayerThumbAsset("player5ThumbAsset",this);
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

