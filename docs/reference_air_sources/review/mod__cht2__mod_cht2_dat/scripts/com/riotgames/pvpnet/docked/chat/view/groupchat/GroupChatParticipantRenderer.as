package com.riotgames.pvpnet.docked.chat.view.groupchat
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.renderer.IItemRenderer;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.common.xmpp.data.invite.PresenceStatusXML;
   import com.riotgames.platform.gameclient.buddyImages.BuddyImages;
   import com.riotgames.platform.gameclient.chat.RosterUtility;
   import com.riotgames.platform.gameclient.chat.config.ChatConfig;
   import com.riotgames.platform.gameclient.chat.controllers.PresenceController;
   import com.riotgames.platform.gameclient.chat.domain.Buddy;
   import com.riotgames.platform.gameclient.chat.domain.PresenceStatusData;
   import com.riotgames.platform.gameclient.chat.utils.RiotPresence;
   import com.riotgames.platform.gameclient.chat.views.ChatViewMediator;
   import com.riotgames.pvpnet.chat.ChatBuddyTooltipView;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.IConfigurationRegistry;
   import com.riotgames.pvpnet.tips.TipsProviderProxy;
   import com.riotgames.pvpnet.tips.config.RectPosition;
   import com.riotgames.pvpnet.tips.config.ToolTipConfig;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.events.PropertyChangeEvent;
   import org.igniterealtime.xiff.conference.RoomOccupant;
   import org.igniterealtime.xiff.data.Presence;
   
   public class GroupChatParticipantRenderer extends SpriteProxy implements IItemRenderer
   {
      
      private static const PRESENCE_DEFAULT_COLOR:uint = 16777215;
      
      private var _iconContainer:SpriteProxy;
      
      private var _iconBitmap:BitmapProxy;
      
      private var _summonerNameText:TextFieldProxy;
      
      private var _statusIndicator:StatefulView;
      
      private var _background:SpriteProxy;
      
      private var _index:uint;
      
      private var _occupant:RoomOccupant;
      
      private var _viewMediator:ChatViewMediator;
      
      private var _isMobileEnabled:Boolean;
      
      public function GroupChatParticipantRenderer(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         setLinkage("chat.GroupChatParticipantRenderer");
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this._viewMediator = getDependency(ChatViewMediator);
         this._viewMediator.getPrivacyListController().getActivePrivacyListUpdated().add(this.updatePresenceAndStatus);
         var _loc1_:IConfigurationRegistry = getDependency(IConfigurationRegistry);
         var _loc2_:ConfigurationModel = _loc1_.getConfigurationModel(ChatConfig.NAMESPACE,ChatConfig.MOBILE_ENABLED);
         this._isMobileEnabled = _loc2_.getValue();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._iconContainer = new SpriteProxy(this);
         setTimelineChildByName("iconSizer",this._iconContainer);
         this._iconBitmap = new BitmapProxy(this);
         var _loc1_:ScalingTransformBehavior = new ScalingTransformBehavior();
         _loc1_.setMaintainAspectRatio(true);
         this._iconBitmap.setTransformBehavior(_loc1_);
         this._iconBitmap.setSmoothing(true);
         addChild(this._iconBitmap);
         this._summonerNameText = new TextFieldProxy(this);
         this._summonerNameText.setMouseEnabled(false);
         setTimelineChildByName("chatParticipantName",this._summonerNameText);
         this._statusIndicator = new StatefulView(this);
         setTimelineChildByName("statusIndicator",this._statusIndicator);
         this._background = new SpriteProxy(this);
         setTimelineChildByName("background",this._background);
         addEventListener(MouseEvent.RIGHT_CLICK,this.handleContextMenu);
      }
      
      private function handleContextMenu(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         if(this._occupant == null)
         {
            return;
         }
         var _loc2_:Buddy = RosterUtility.getBuddy(this._occupant.rosterItem);
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:GroupChatParticipantMenu = new GroupChatParticipantMenu(this._occupant,this._viewMediator);
         var _loc4_:Point = this.localToGlobal(new Point(param1.localX,param1.localY));
         _loc3_.display(this.getStage(),_loc4_.x,_loc4_.y);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._iconBitmap.setExplicitSize(this._iconContainer.getWidth(),this._iconContainer.getHeight());
         this._iconBitmap.setExplicitPosition(this._iconContainer.getX(),this._iconContainer.getY());
         return new Rectangle(0,0,this._background.getWidth(),this._background.getHeight());
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
      
      public function setIndex(param1:uint) : void
      {
         this._index = param1;
      }
      
      public function getData() : *
      {
         return this._occupant;
      }
      
      public function updateName() : void
      {
         this._summonerNameText.setText(this._occupant.displayName);
      }
      
      public function updatePresenceAndStatus(param1:Event = null) : void
      {
         var _loc2_:BitmapData = null;
         var _loc4_:PresenceStatusData = null;
         if(this._occupant == null)
         {
            return;
         }
         if(this._viewMediator.getPrivacyListController().isBlocked(this._occupant.jid.bareJID))
         {
            _loc2_ = BuddyImages.getBlockedIcon();
         }
         else
         {
            _loc2_ = BuddyImages.getSummonerIconSafely(PresenceController.getProfileIcon(this._occupant.status));
         }
         this._iconBitmap.setBitmapData(_loc2_);
         if(this._occupant.show == null)
         {
            _loc4_ = PresenceController.getPresenceData(this._occupant.status);
            if(PresenceStatusXML.getStatusShowMode(_loc4_.gameType) == Presence.SHOW_DND)
            {
               this._occupant.show = Presence.SHOW_DND;
            }
         }
         var _loc3_:RiotPresence = RiotPresence.fromXiffPresence(this._occupant.show,this._isMobileEnabled);
         this._statusIndicator.setCurrentState(_loc3_.assetKey);
         if(_loc3_ == RiotPresence.CHAT)
         {
            this._summonerNameText.setTextColor(PRESENCE_DEFAULT_COLOR);
         }
         else
         {
            this._summonerNameText.setTextColor(_loc3_.color);
         }
         this._occupant.rosterItem.status = this._occupant.status;
         this.refreshBuddyTooltip();
      }
      
      public function setData(param1:*) : void
      {
         if(this._occupant != null)
         {
            this._occupant.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.updatePresenceAndStatus);
         }
         this._occupant = param1 as RoomOccupant;
         if(this._occupant != null)
         {
            this._summonerNameText.setText(this._occupant.displayName);
            this.updatePresenceAndStatus();
            this._occupant.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.updatePresenceAndStatus);
            this.refreshBuddyTooltip();
         }
      }
      
      private function refreshBuddyTooltip() : void
      {
         var _loc1_:ToolTipConfig = new ToolTipConfig();
         _loc1_.showDelay = 0;
         _loc1_.toolTipPosition = new RectPosition(RectPosition.TOP_LEFT,RectPosition.TOP_RIGHT,new Point(-6,0));
         var _loc2_:Buddy = RosterUtility.getBuddy(this._occupant.rosterItem);
         RosterUtility.populateBuddyFromRosterItem(_loc2_,this._occupant.rosterItem);
         TipsProviderProxy.instance.assignCustomToolTip(this,_loc2_,ChatBuddyTooltipView,_loc1_);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.setData(null);
      }
   }
}

