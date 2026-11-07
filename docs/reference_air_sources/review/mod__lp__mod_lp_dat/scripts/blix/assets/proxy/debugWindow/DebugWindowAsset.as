package blix.assets.proxy.debugWindow
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   
   public class DebugWindowAsset extends InstanceMapping
   {
      
      public var closeButton:DebugButtonAsset;
      
      public var versionNumber:TextFieldMapping;
      
      public var debugText:TextFieldMapping;
      
      public function DebugWindowAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.closeButton = new DebugButtonAsset("closeButton",this);
         this.versionNumber = new TextFieldMapping("versionNumber",this);
         this.debugText = new TextFieldMapping("debugText",this);
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

