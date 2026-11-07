package blix.assets.proxy
{
   import blix.assets.proxy.mappings.InstanceMapping;
   
   public class AnimatedChampBar extends InstanceMapping
   {
      
      public var champMask:champBarMask;
      
      public var champContent:ChampionBar;
      
      public function AnimatedChampBar(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.champMask = new champBarMask("champMask",this);
         this.champContent = new ChampionBar("champContent",this);
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

