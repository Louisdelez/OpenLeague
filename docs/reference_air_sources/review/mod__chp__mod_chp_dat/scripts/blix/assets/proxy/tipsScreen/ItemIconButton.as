package blix.assets.proxy.tipsScreen
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.context.Context;
   
   public class ItemIconButton extends InstanceMapping
   {
      
      public static const LINKAGE:String = "ItemIconButton";
      
      public var iconMask:ItemIconHolder;
      
      public var iconHolder:ItemIconHolder;
      
      public var hoverGlowEffect:ItemIconHolder;
      
      public function ItemIconButton(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.iconMask = new ItemIconHolder("iconMask",this);
         this.iconHolder = new ItemIconHolder("iconHolder",this);
         this.hoverGlowEffect = new ItemIconHolder("hoverGlowEffect",this);
      }
      
      public static function create(param1:Context) : MovieClipProxy
      {
         var _loc2_:MovieClipProxy = new MovieClipProxy(param1);
         _loc2_.setLinkage(LINKAGE);
         return _loc2_;
      }
      
      public function clone(param1:Context) : MovieClipProxy
      {
         return ItemIconButton.create(param1);
      }
      
      public function create(param1:DisplayObjectContainerProxy) : MovieClipProxy
      {
         var _loc2_:String = getName();
         var _loc3_:MovieClipProxy = new MovieClipProxy(param1);
         param1.setTimelineChildByName(_loc2_,_loc3_);
         return _loc3_;
      }
   }
}

