package blix.assets.proxy
{
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   
   public class TwistedTreelineSummary extends InstanceMapping
   {
      
      public var queueText:TextFieldMapping;
      
      public var rankText:TextFieldMapping;
      
      public var topRatingText:TextFieldMapping;
      
      public var totalWinsText:TextFieldMapping;
      
      public var totalLossesText:TextFieldMapping;
      
      public function TwistedTreelineSummary(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.queueText = new TextFieldMapping("queueText",this);
         this.rankText = new TextFieldMapping("rankText",this);
         this.topRatingText = new TextFieldMapping("topRatingText",this);
         this.totalWinsText = new TextFieldMapping("totalWinsText",this);
         this.totalLossesText = new TextFieldMapping("totalLossesText",this);
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

