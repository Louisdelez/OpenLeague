package com.riotgames.platform.gameclient.module.rt.view.profile
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.assets.proxy.screen_profile.ProfileRosterItem;
   import blix.components.timeline.StatefulView;
   import blix.context.Context;
   import com.riotgames.platform.gameclient.chat.config.ChatConfig;
   import com.riotgames.platform.gameclient.chat.domain.Buddy;
   import com.riotgames.platform.gameclient.chat.utils.RiotPresence;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.resource.RTResource;
   import com.riotgames.platform.gameclient.utils.DateUtil;
   import com.riotgames.pvpnet.component.DeprecatedAudioButton;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.IConfigurationRegistry;
   import flash.events.MouseEvent;
   import mx.core.IToolTip;
   import mx.managers.ToolTipManager;
   
   public class ProfileRosterItemView extends SpriteProxy
   {
      
      private var winsText:TextFieldProxy;
      
      private var _isMobileEnabled:Boolean;
      
      private var statusTip:IToolTip;
      
      private var statusIcon:StatefulView;
      
      private var _info:ProfileRosterItemData;
      
      private var addFriendButton:DeprecatedAudioButton;
      
      private var viewProfileButton:DeprecatedAudioButton;
      
      private var nameText:TextFieldProxy;
      
      private var statusTooltipText:String = "";
      
      public function ProfileRosterItemView(param1:Context)
      {
         super(param1);
      }
      
      private function onAddFriend(param1:MouseEvent) : void
      {
         RTFacade.instance.rtProvider.requestAddFriend(this._info.info.playerName);
         this.addFriendButton.setVisible(false);
      }
      
      private function onStatusRollOut(param1:MouseEvent) : void
      {
         if(this.statusTip)
         {
            ToolTipManager.destroyToolTip(this.statusTip);
         }
      }
      
      private function onStatusRollOver(param1:MouseEvent) : void
      {
         var _loc2_:Number = Number(getAsset().stage.mouseX);
         var _loc3_:Number = Number(getAsset().stage.mouseY);
         this.statusTip = ToolTipManager.createToolTip(this.statusTooltipText,_loc2_,_loc3_);
      }
      
      private function onViewProfile(param1:MouseEvent) : void
      {
         RTFacade.instance.rtProvider.requestViewSummonerProfile(this._info.info.playerName);
      }
      
      public function setTeamMember(param1:ProfileRosterItemData) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:RiotPresence = null;
         this._info = param1;
         if(param1)
         {
            _loc2_ = RTFacade.instance.rtProvider.session.summoner.sumId == param1.info.playerId;
            _loc3_ = param1.buddy != null;
            _loc4_ = !_loc2_ && !_loc3_;
            this.addFriendButton.setVisible(_loc4_);
            this.statusIcon.setVisible(!_loc4_);
            if(this._info.buddy != null)
            {
               if(this._info.buddy.getStatus() == Buddy.STATUS_ONLINE)
               {
                  _loc5_ = RiotPresence.fromXiffPresence(param1.buddy.getBusyStatus(),this._isMobileEnabled);
                  switch(_loc5_)
                  {
                     case RiotPresence.AWAY:
                        this.statusIcon.setCurrentState("away");
                        this.statusTooltipText = RTResource.getString("profileRosterStatusAway");
                        break;
                     case RiotPresence.MOBILE:
                        this.statusIcon.setCurrentState("m");
                        this.statusTooltipText = RTResource.getString("profileRosterStatusMobile");
                        break;
                     case RiotPresence.DND:
                        this.statusIcon.setCurrentState("busy");
                        this.statusTooltipText = RTResource.getString("profileRosterStatusInGame");
                        break;
                     case RiotPresence.CHAT:
                     default:
                        this.statusIcon.setCurrentState("online");
                        this.statusTooltipText = RTResource.getString("profileRosterStatusOnline");
                  }
               }
               else
               {
                  this.statusIcon.setCurrentState("offline");
                  this.statusTooltipText = RTResource.getString("profileRosterStatusOffline");
               }
            }
            else if(_loc2_)
            {
               this.statusIcon.setCurrentState("online");
               this.statusTooltipText = RTResource.getString("profileRosterStatusOnline");
            }
            else
            {
               this.statusIcon.setCurrentState("offline");
               this.statusTooltipText = RTResource.getString("profileRosterStatusOffline");
            }
            setVisible(true);
            this.nameText.setText(param1.info.playerName);
            if(param1.info.joinDate)
            {
               this.winsText.setText(DateUtil.getDateString(param1.info.joinDate));
            }
         }
         else
         {
            setVisible(false);
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:ProfileRosterItem = new ProfileRosterItem();
         this.nameText = _loc1_.nameText.create(this);
         this.winsText = _loc1_.winsText.create(this);
         this.viewProfileButton = new DeprecatedAudioButton(this);
         this.viewProfileButton.tooltip = RTResource.getString("tooltipViewProfile");
         this.viewProfileButton.flexContext = null;
         setTimelineChild(_loc1_.viewProfileButton,this.viewProfileButton);
         this.viewProfileButton.addEventListener(MouseEvent.CLICK,this.onViewProfile);
         this.addFriendButton = new DeprecatedAudioButton(this);
         this.addFriendButton.tooltip = RTResource.getString("tooltipAddFriend");
         this.addFriendButton.flexContext = null;
         setTimelineChild(_loc1_.addFriendButton,this.addFriendButton);
         this.addFriendButton.addEventListener(MouseEvent.CLICK,this.onAddFriend);
         this.statusIcon = new StatefulView(this);
         setTimelineChild(_loc1_.statusIcon,this.statusIcon);
         this.statusIcon.addEventListener(MouseEvent.ROLL_OVER,this.onStatusRollOver);
         this.statusIcon.addEventListener(MouseEvent.ROLL_OUT,this.onStatusRollOut);
         var _loc2_:IConfigurationRegistry = this.getDependency(IConfigurationRegistry);
         var _loc3_:ConfigurationModel = _loc2_.getConfigurationModel(ChatConfig.NAMESPACE,ChatConfig.MOBILE_ENABLED);
         this._isMobileEnabled = _loc3_.getValue();
         this.setTeamMember(null);
      }
   }
}

