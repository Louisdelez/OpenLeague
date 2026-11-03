package blix.assets.proxy
{
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   
   public class buttonContent extends InstanceMapping
   {
      
      public var timestampText:TextFieldMapping;
      
      public var killsText:TextFieldMapping;
      
      public var opposingTeamText:TextFieldMapping;
      
      public var deathsText:TextFieldMapping;
      
      public var vsText:TextFieldMapping;
      
      public var kdaText:TextFieldMapping;
      
      public function buttonContent(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.timestampText = new TextFieldMapping("timestampText",this);
         this.killsText = new TextFieldMapping("killsText",this);
         this.opposingTeamText = new TextFieldMapping("opposingTeamText",this);
         this.deathsText = new TextFieldMapping("deathsText",this);
         this.vsText = new TextFieldMapping("vsText",this);
         this.kdaText = new TextFieldMapping("kdaText",this);
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

