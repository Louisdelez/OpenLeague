package blix.assets.proxy
{
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   
   public class rating_shield extends InstanceMapping
   {
      
      public var teamRatingText:TextFieldMapping;
      
      public var teamWinPercentText:TextFieldMapping;
      
      public function rating_shield(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.teamRatingText = new TextFieldMapping("teamRatingText",this);
         this.teamWinPercentText = new TextFieldMapping("teamWinPercentText",this);
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

