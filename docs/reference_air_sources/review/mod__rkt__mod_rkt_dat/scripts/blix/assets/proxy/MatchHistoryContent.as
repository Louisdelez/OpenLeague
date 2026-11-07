package blix.assets.proxy
{
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.topTab.moredetails;
   import blix.context.Context;
   
   public class MatchHistoryContent extends InstanceMapping
   {
      
      public static const LINKAGE:String = "mh.MatchHistoryContent";
      
      public var overviewHeader:OverviewHeader;
      
      public var matchDetailDecorator:noMatchFiller;
      
      public var matchDetailProxy:blix.assets.proxy.matchDetailProxy;
      
      public var matchListProxy:blix.assets.proxy.matchListProxy;
      
      public var completeDetailsButton:moredetails;
      
      public function MatchHistoryContent(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.overviewHeader = new OverviewHeader("overviewHeader",this);
         this.matchDetailDecorator = new noMatchFiller("matchDetailDecorator",this);
         this.matchDetailProxy = new blix.assets.proxy.matchDetailProxy("matchDetailProxy",this);
         this.matchListProxy = new blix.assets.proxy.matchListProxy("matchListProxy",this);
         this.completeDetailsButton = new moredetails("completeDetailsButton",this);
      }
      
      public static function create(param1:Context) : SpriteProxy
      {
         var _loc2_:SpriteProxy = new SpriteProxy(param1);
         _loc2_.setLinkage(LINKAGE);
         return _loc2_;
      }
      
      public function clone(param1:Context) : SpriteProxy
      {
         return MatchHistoryContent.create(param1);
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

