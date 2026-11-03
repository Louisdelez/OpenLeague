package blix.assets.proxy
{
   import blix.assets.proxy.debugWindow.DebugWindowAsset;
   import blix.assets.proxy.errorDialog.ErrorDialogAsset;
   import blix.assets.proxy.frame.SideBarAsset;
   import blix.assets.proxy.frame.close.CloseButton;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.overview.Owned;
   import blix.assets.proxy.purchaseScreen.PurchaseScreenAsset;
   import blix.assets.proxy.unlockButton.UnlockAreaAsset;
   import blix.context.Context;
   
   public class MainAsset extends InstanceMapping
   {
      
      public static const LINKAGE:String = "MainAsset";
      
      public var debugWindow:DebugWindowAsset;
      
      public var errorDialog:ErrorDialogAsset;
      
      public var purchaseScreen:PurchaseScreenAsset;
      
      public var closeButton:CloseButton;
      
      public var sideBar:SideBarAsset;
      
      public var ownedClip:Owned;
      
      public var unlockArea:UnlockAreaAsset;
      
      public var contentScroller:ContentScroller;
      
      public function MainAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.debugWindow = new DebugWindowAsset("debugWindow",this);
         this.errorDialog = new ErrorDialogAsset("errorDialog",this);
         this.purchaseScreen = new PurchaseScreenAsset("purchaseScreen",this);
         this.closeButton = new CloseButton("closeButton",this);
         this.sideBar = new SideBarAsset("sideBar",this);
         this.ownedClip = new Owned("ownedClip",this);
         this.unlockArea = new UnlockAreaAsset("unlockArea",this);
         this.contentScroller = new ContentScroller("contentScroller",this);
      }
      
      public static function create(param1:Context) : SpriteProxy
      {
         var _loc2_:SpriteProxy = new SpriteProxy(param1);
         _loc2_.setLinkage(LINKAGE);
         return _loc2_;
      }
      
      public function clone(param1:Context) : SpriteProxy
      {
         return MainAsset.create(param1);
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

