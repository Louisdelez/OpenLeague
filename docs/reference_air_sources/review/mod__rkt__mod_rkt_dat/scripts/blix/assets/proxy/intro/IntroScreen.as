package blix.assets.proxy.intro
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.linkHolder;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   import blix.assets.proxy.topTab.CreateTeamButton;
   import blix.context.Context;
   
   public class IntroScreen extends InstanceMapping
   {
      
      public static const LINKAGE:String = "rt.IntroScreen";
      
      public var createButton:CreateTeamButton;
      
      public var linkHolder:blix.assets.proxy.linkHolder;
      
      public var notLevel30Text:TextFieldMapping;
      
      public function IntroScreen(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.createButton = new CreateTeamButton("createButton",this);
         this.linkHolder = new blix.assets.proxy.linkHolder("linkHolder",this);
         this.notLevel30Text = new TextFieldMapping("notLevel30Text",this);
      }
      
      public static function create(param1:Context) : SpriteProxy
      {
         var _loc2_:SpriteProxy = new SpriteProxy(param1);
         _loc2_.setLinkage(LINKAGE);
         return _loc2_;
      }
      
      public function clone(param1:Context) : SpriteProxy
      {
         return IntroScreen.create(param1);
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

