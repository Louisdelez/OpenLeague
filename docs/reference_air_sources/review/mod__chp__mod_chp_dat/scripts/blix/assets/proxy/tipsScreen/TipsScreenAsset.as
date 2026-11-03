package blix.assets.proxy.tipsScreen
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   
   public class TipsScreenAsset extends InstanceMapping
   {
      
      public var title:TextFieldMapping;
      
      public var content:TextFieldMapping;
      
      public var opposingTitle:TextFieldMapping;
      
      public var opposingContent:TextFieldMapping;
      
      public function TipsScreenAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.title = new TextFieldMapping("title",this);
         this.content = new TextFieldMapping("content",this);
         this.opposingTitle = new TextFieldMapping("opposingTitle",this);
         this.opposingContent = new TextFieldMapping("opposingContent",this);
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

