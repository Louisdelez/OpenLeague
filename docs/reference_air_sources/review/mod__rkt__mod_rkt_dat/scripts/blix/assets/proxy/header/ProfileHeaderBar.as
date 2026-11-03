package blix.assets.proxy.header
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   import blix.assets.proxy.tabLayoutHolder;
   import blix.context.Context;
   
   public class ProfileHeaderBar extends InstanceMapping
   {
      
      public static const LINKAGE:String = "rt.ProfileHeaderBar";
      
      public var tabLayoutHolder:blix.assets.proxy.tabLayoutHolder;
      
      public var findTeamText:TextFieldMapping;
      
      public function ProfileHeaderBar(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.tabLayoutHolder = new blix.assets.proxy.tabLayoutHolder("tabLayoutHolder",this);
         this.findTeamText = new TextFieldMapping("findTeamText",this);
      }
      
      public static function create(param1:Context) : MovieClipProxy
      {
         var _loc2_:MovieClipProxy = new MovieClipProxy(param1);
         _loc2_.setLinkage(LINKAGE);
         return _loc2_;
      }
      
      public function clone(param1:Context) : MovieClipProxy
      {
         return ProfileHeaderBar.create(param1);
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

