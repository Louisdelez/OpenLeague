package com.riotgames.platform.gameclient.module.rt.view.profile
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.screen_profile.profileInviteNotification;
   import blix.components.button.ButtonX;
   import blix.signals.Signal;
   import com.riotgames.rust.components.FlashFlexComponent;
   import com.riotgames.rust.context.RustContext;
   import flash.events.MouseEvent;
   
   public class ProfileInvitedControl extends FlashFlexComponent
   {
      
      private var declineButton:ButtonX;
      
      public var declineClicked:Signal = new Signal();
      
      private var acceptButton:ButtonX;
      
      public var acceptClicked:Signal = new Signal();
      
      public function ProfileInvitedControl(param1:RustContext)
      {
         super(param1,"rt.ProfileInviteNotification");
         var _loc2_:profileInviteNotification = new profileInviteNotification();
         this.acceptButton = param1.viewUtil.wireButton(this.view,_loc2_.acceptButton,this.onAccept);
         this.declineButton = param1.viewUtil.wireButton(this.view,_loc2_.declineButton,this.onDecline);
      }
      
      override protected function createView() : DisplayObjectProxy
      {
         return new SpriteProxy(_context);
      }
      
      public function get view() : SpriteProxy
      {
         return _view as SpriteProxy;
      }
      
      private function onAccept(param1:MouseEvent) : void
      {
         this.acceptClicked.dispatch();
      }
      
      private function onDecline(param1:MouseEvent) : void
      {
         this.declineClicked.dispatch();
      }
   }
}

