package blix.assets.proxy.unlockButton
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   
   public class UnlockButtonAsset extends InstanceMapping
   {
      
      public var textField:TextFieldMapping;
      
      public var glow:UnlockButton_glowAnim;
      
      public function UnlockButtonAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.textField = new TextFieldMapping("textField",this);
         this.glow = new UnlockButton_glowAnim("glow",this);
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

