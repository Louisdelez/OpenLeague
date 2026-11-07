package blix.assets.proxy.topTab
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.holder;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   
   public class tabStates extends InstanceMapping
   {
      
      public var tabText:TextFieldMapping;
      
      public var dropdownMarker:holder;
      
      public var pendingAlert:pendingInvitationIcon;
      
      public function tabStates(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.tabText = new TextFieldMapping("tabText",this);
         this.dropdownMarker = new holder("dropdownMarker",this);
         this.pendingAlert = new pendingInvitationIcon("pendingAlert",this);
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

