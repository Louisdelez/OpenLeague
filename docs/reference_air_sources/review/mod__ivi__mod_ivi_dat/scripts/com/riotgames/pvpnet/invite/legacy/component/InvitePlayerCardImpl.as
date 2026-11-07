package com.riotgames.pvpnet.invite.legacy.component
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.IToolTipManager;
   import blix.context.IContext;
   import blix.signals.Signal;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.gameclient.buddyImages.BuddyImages;
   import com.riotgames.platform.gameclient.chat.controllers.PresenceController;
   import com.riotgames.pvpnet.invite.legacy.controller.InviteBayController;
   import com.riotgames.pvpnet.invite.rules.IInviteBayRules;
   import com.riotgames.pvpnet.tips.TipsProviderProxy;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public class InvitePlayerCardImpl extends StatefulView
   {
      
      private var _data:Object;
      
      private var playerName:TextFieldProxy;
      
      private var _actionSignal:Signal = new Signal();
      
      private var avatarBitmap:BitmapProxy;
      
      public var inviteRules:IInviteBayRules;
      
      private var avatarContainer:SpriteProxy;
      
      public var isAddBuddy:Boolean = true;
      
      private var avatarSizer:SpriteProxy;
      
      private var tooltipHitArea:SpriteProxy;
      
      public function InvitePlayerCardImpl(param1:IContext)
      {
         super(param1);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this.avatarBitmap.setExplicitSize(this.avatarSizer.getWidth(),this.avatarSizer.getHeight());
         return new Rectangle(0,0,this.avatarSizer.getWidth(),this.avatarSizer.getHeight());
      }
      
      public function set data(param1:RosterItemVO) : void
      {
         var _loc2_:RosterItemVO = param1;
         this._data = param1;
         this.avatarContainer.removeChild(this.avatarBitmap);
         this.avatarBitmap.setBitmapData(BuddyImages.getSummonerIconSafely(PresenceController.getProfileIcon(_loc2_.status)));
         this.avatarBitmap.setExplicitSize(this.avatarSizer.getWidth(),this.avatarSizer.getHeight());
         this.avatarContainer.addChild(this.avatarBitmap);
         this.playerName.setText(_loc2_.displayName);
         if(Boolean(this.inviteRules) && Boolean(this.inviteRules.allowGuestInvites) && Boolean(this.inviteRules.isPlayerGuest(InviteBayController.retrieveSummonerIdFromRosterItemVO(_loc2_))))
         {
            this.setCurrentState("guest");
         }
         else
         {
            this.setCurrentState("player");
         }
      }
      
      private function onButtonClick(param1:MouseEvent) : void
      {
         this.actionSignal.dispatch();
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         registerDependency(IToolTipManager,TipsProviderProxy.instance.createWindowToolTipManager(this));
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:ScalingTransformBehavior = new ScalingTransformBehavior();
         this.playerName = new TextFieldProxy(this);
         this.avatarContainer = new SpriteProxy(this);
         this.avatarSizer = new SpriteProxy(this);
         this.avatarBitmap = new BitmapProxy(this);
         this.tooltipHitArea = new SpriteProxy(this);
         this.setTimelineChildByName("playerName",this.playerName);
         this.setTimelineChildByName("avatarContainer",this.avatarContainer);
         this.setTimelineChildByName("avatarSizer",this.avatarSizer);
         this.setTimelineChildByName("tooltipHitArea",this.tooltipHitArea);
         _loc1_.setMaintainAspectRatio(true);
         this.avatarBitmap.setTransformBehavior(_loc1_);
         this.avatarBitmap.setSmoothing(true);
         this.avatarBitmap.getLayoutInvalidated().add(this.invalidateLayout);
         this.avatarContainer.addChild(this.avatarBitmap);
         this.setCurrentState("player");
      }
      
      public function get actionSignal() : Signal
      {
         return this._actionSignal;
      }
   }
}

