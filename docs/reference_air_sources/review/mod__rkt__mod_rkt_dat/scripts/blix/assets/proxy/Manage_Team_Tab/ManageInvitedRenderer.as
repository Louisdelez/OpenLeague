package blix.assets.proxy.Manage_Team_Tab
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   import blix.context.Context;
   
   public class ManageInvitedRenderer extends InstanceMapping
   {
      
      public static const LINKAGE:String = "rt.ManageInvitedRenderer";
      
      public var labelText:TextFieldMapping;
      
      public var cancelButton:cancelInviteButton;
      
      public var detailText:TextFieldMapping;
      
      public function ManageInvitedRenderer(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.labelText = new TextFieldMapping("labelText",this);
         this.cancelButton = new cancelInviteButton("cancelButton",this);
         this.detailText = new TextFieldMapping("detailText",this);
      }
      
      public static function create(param1:Context) : MovieClipProxy
      {
         var _loc2_:MovieClipProxy = new MovieClipProxy(param1);
         _loc2_.setLinkage(LINKAGE);
         return _loc2_;
      }
      
      public function clone(param1:Context) : MovieClipProxy
      {
         return ManageInvitedRenderer.create(param1);
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

