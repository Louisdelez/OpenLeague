package blix.assets.proxy.tipsScreen
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   
   public class dominionItemsHolder extends InstanceMapping
   {
      
      public var item0:ItemIconButton;
      
      public var item1:ItemIconButton;
      
      public var item2:ItemIconButton;
      
      public var item3:ItemIconButton;
      
      public var item4:ItemIconButton;
      
      public var item5:ItemIconButton;
      
      public var title:TextFieldMapping;
      
      public function dominionItemsHolder(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.item0 = new ItemIconButton("item0",this);
         this.item1 = new ItemIconButton("item1",this);
         this.item2 = new ItemIconButton("item2",this);
         this.item3 = new ItemIconButton("item3",this);
         this.item4 = new ItemIconButton("item4",this);
         this.item5 = new ItemIconButton("item5",this);
         this.title = new TextFieldMapping("title",this);
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

