package blix.assets.proxy.frame
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.common.Empty;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   import blix.context.Context;
   
   public class SideBarAsset extends InstanceMapping
   {
      
      public static const LINKAGE:String = "SideBarAsset";
      
      public var titleText:TextFieldMapping;
      
      public var iconHolder:Empty;
      
      public var overviewButton:SideBarButtonAsset;
      
      public var loreButton:SideBarButtonAsset;
      
      public var abilitiesButton:SideBarButtonAsset;
      
      public var tipsButton:SideBarButtonAsset;
      
      public function SideBarAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.titleText = new TextFieldMapping("titleText",this);
         this.iconHolder = new Empty("iconHolder",this);
         this.overviewButton = new SideBarButtonAsset("overviewButton",this);
         this.loreButton = new SideBarButtonAsset("loreButton",this);
         this.abilitiesButton = new SideBarButtonAsset("abilitiesButton",this);
         this.tipsButton = new SideBarButtonAsset("tipsButton",this);
      }
      
      public static function create(param1:Context) : SpriteProxy
      {
         var _loc2_:SpriteProxy = new SpriteProxy(param1);
         _loc2_.setLinkage(LINKAGE);
         return _loc2_;
      }
      
      public function clone(param1:Context) : SpriteProxy
      {
         return SideBarAsset.create(param1);
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

