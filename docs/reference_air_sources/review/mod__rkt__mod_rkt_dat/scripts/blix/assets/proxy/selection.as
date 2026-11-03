package blix.assets.proxy
{
   import blix.assets.proxy.mappings.InstanceMapping;
   
   public class selection extends InstanceMapping
   {
      
      public var content:buttonContent;
      
      public var mapChoiceToggle:mapChoice;
      
      public var resultState:winloss_mc;
      
      public function selection(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.content = new buttonContent("content",this);
         this.mapChoiceToggle = new mapChoice("mapChoiceToggle",this);
         this.resultState = new winloss_mc("resultState",this);
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

