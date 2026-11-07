package com.riotgames.platform.gameclient.module.rt.view.profile
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.assets.proxy.screen_profile.ProfileTeamStatusPanel;
   import blix.components.timeline.StatefulView;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.resource.RTContext;
   import com.riotgames.platform.gameclient.module.rt.resource.RTResource;
   import com.riotgames.rust.components.FlashFlexComponent;
   import flash.events.MouseEvent;
   
   public class ProfileStatusInfo extends FlashFlexComponent
   {
      
      private var bullet1:TextFieldProxy;
      
      private var statusStates:StatefulView;
      
      private var infoPanel:StatefulView;
      
      private var hitBox:SpriteProxy;
      
      private var statusText:TextFieldProxy;
      
      public function ProfileStatusInfo(param1:RTContext)
      {
         super(param1,"rt.ProfileTeamStatusPanel");
         var _loc2_:ProfileTeamStatusPanel = new ProfileTeamStatusPanel();
         this.statusStates = new StatefulView(this.view);
         this.view.setTimelineChild(_loc2_.statusStates,this.statusStates);
         this.infoPanel = new StatefulView(this.view);
         this.view.setTimelineChild(_loc2_.infoPanel,this.infoPanel);
         this.infoPanel.setCurrentState("hide");
         this.bullet1 = _loc2_.infoPanel.bullet1.create(this.view);
         this.statusText = _loc2_.statusStates.statusText.create(this.view);
         this.hitBox = _loc2_.hitBox.create(this.view);
         this.hitBox.setAlpha(0);
         this.statusStates.setMouseEnabled(false);
         this.statusStates.setMouseChildren(false);
         this.hitBox.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         this.hitBox.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         RTFacade.instance.registerMediator(new ProfileStatusInfoMediator(this));
      }
      
      override protected function createView() : DisplayObjectProxy
      {
         return new SpriteProxy(_context);
      }
      
      public function setStatusState(param1:String, param2:String) : void
      {
         this.statusStates.setCurrentState(param1);
         this.bullet1.setText(RTResource.getString("Status_" + param1 + "_bullet1"));
         this.statusText.setText(param2);
      }
      
      public function setBulletText(param1:String) : void
      {
         this.bullet1.setText(param1);
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         this.infoPanel.setCurrentState("hide");
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         this.infoPanel.setCurrentState("show");
      }
      
      public function get view() : SpriteProxy
      {
         return _view as SpriteProxy;
      }
   }
}

