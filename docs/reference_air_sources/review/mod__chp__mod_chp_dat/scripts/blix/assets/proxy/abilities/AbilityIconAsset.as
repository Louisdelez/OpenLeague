package blix.assets.proxy.abilities
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.common.Empty;
   import blix.assets.proxy.common.HitArea;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   import blix.context.Context;
   
   public class AbilityIconAsset extends InstanceMapping
   {
      
      public static const LINKAGE:String = "abilities.AbilityIconAsset";
      
      public var hitAreaClip:HitArea;
      
      public var imageSizer:HitArea;
      
      public var label:TextFieldMapping;
      
      public var hotkey:TextFieldMapping;
      
      public var iconHolder:Empty;
      
      public function AbilityIconAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.hitAreaClip = new HitArea("hitAreaClip",this);
         this.imageSizer = new HitArea("imageSizer",this);
         this.label = new TextFieldMapping("label",this);
         this.hotkey = new TextFieldMapping("hotkey",this);
         this.iconHolder = new Empty("iconHolder",this);
      }
      
      public static function create(param1:Context) : MovieClipProxy
      {
         var _loc2_:MovieClipProxy = new MovieClipProxy(param1);
         _loc2_.setLinkage(LINKAGE);
         return _loc2_;
      }
      
      public function clone(param1:Context) : MovieClipProxy
      {
         return AbilityIconAsset.create(param1);
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

