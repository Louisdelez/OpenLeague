package blix.assets.proxy.FeaturedGamesSlider
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   
   public class SummonerNamesAsset extends InstanceMapping
   {
      
      public var player101Asset:TextFieldMapping;
      
      public var player102Asset:TextFieldMapping;
      
      public var player103Asset:TextFieldMapping;
      
      public var player104Asset:TextFieldMapping;
      
      public var player105Asset:TextFieldMapping;
      
      public var player201Asset:TextFieldMapping;
      
      public var player202Asset:TextFieldMapping;
      
      public var player203Asset:TextFieldMapping;
      
      public var player204Asset:TextFieldMapping;
      
      public var player205Asset:TextFieldMapping;
      
      public function SummonerNamesAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.player101Asset = new TextFieldMapping("player101Asset",this);
         this.player102Asset = new TextFieldMapping("player102Asset",this);
         this.player103Asset = new TextFieldMapping("player103Asset",this);
         this.player104Asset = new TextFieldMapping("player104Asset",this);
         this.player105Asset = new TextFieldMapping("player105Asset",this);
         this.player201Asset = new TextFieldMapping("player201Asset",this);
         this.player202Asset = new TextFieldMapping("player202Asset",this);
         this.player203Asset = new TextFieldMapping("player203Asset",this);
         this.player204Asset = new TextFieldMapping("player204Asset",this);
         this.player205Asset = new TextFieldMapping("player205Asset",this);
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

