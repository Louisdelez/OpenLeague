package com.riotgames.platform.gameclient.views.game.common.renderers.teamlobby
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.IToolTipManager;
   import blix.components.tooltip.assignToolTip;
   import blix.layout.LayoutContainerView;
   import blix.layout.algorithms.HorizontalLayout;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.components.summoner.SummonerQuickViewData;
   import com.riotgames.platform.gameclient.domain.PlayerParticipant;
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipant;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.invite.IInviteController;
   import com.riotgames.pvpnet.invite.IInviteRankedTeamController;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.tips.TipsProviderProxy;
   import com.riotgames.rust.context.RustContext;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import mx.binding.utils.ChangeWatcher;
   import mx.events.PropertyChangeEvent;
   import org.igniterealtime.xiff.conference.RoomOccupant;
   import org.igniterealtime.xiff.core.UnescapedJID;
   
   public class TeamLobbyMemberImpl extends StatefulView
   {
      
      private var _data:Object;
      
      private var playerLevelTextfield:TextFieldProxy;
      
      private var enableInvitePowerButton:ButtonX;
      
      [Inject]
      public var chatController:ChatController;
      
      private var lobbyOwnerIcon:SpriteProxy;
      
      private var summonerData:SummonerQuickViewData = null;
      
      [Inject]
      public var lobbyController:ILobbyViewController;
      
      private var session:Session = Session.instance;
      
      private var delegateInvitePowersEnabledIcon:SpriteProxy;
      
      private var viewProfileButton:ButtonX;
      
      private var isOwner:Boolean = false;
      
      public var context:RustContext;
      
      private var _inviteGroup:InviteGroup;
      
      private var isBuddy:Boolean = false;
      
      private var addBuddyButton:ButtonX;
      
      private var playerNameTextfield:TextFieldProxy;
      
      private var buddyIconImage:DisplayObjectProxy;
      
      private var gameHistoryTextfield:TextFieldProxy;
      
      private var kickPlayerButton:ButtonX;
      
      private var isMe:Boolean = false;
      
      private var _inviteController:IInviteController;
      
      private var allowDelegateInvites:Boolean = false;
      
      private var statusWatcher:ChangeWatcher = null;
      
      private var buttonContainer:LayoutContainerView;
      
      public var rankedInviteController:IInviteRankedTeamController;
      
      private var playerIcon:SpriteProxy;
      
      public function TeamLobbyMemberImpl(param1:RustContext = null, param2:InviteGroup = null, param3:IInviteController = null, param4:ChatController = null, param5:ILobbyViewController = null)
      {
         if(param1 != null)
         {
            this.context = param1;
         }
         if(param3 != null)
         {
            this._inviteController = param3;
         }
         if(param4 != null)
         {
            this.chatController = param4;
         }
         if(param5 != null)
         {
            this.lobbyController = param5;
         }
         if(param2 != null)
         {
            this._inviteGroup = param2;
         }
         super(param1);
      }
      
      protected function onDelegateChanged(param1:MouseEvent) : void
      {
         if(!this.data || !this.summonerData)
         {
            return;
         }
         var _loc2_:UnescapedJID = new UnescapedJID(ChatController.jidFromSummonerId(this.summonerData.summonerId));
         var _loc3_:InviteParticipant = new InviteParticipant(_loc2_,this.summonerData.summonerId,this.summonerData.summonerName);
         if(this.enableInvitePowerButton.getSelected())
         {
            this._inviteController.delegateInvitePower(_loc3_);
         }
         else
         {
            this._inviteController.revokeInvitePower(_loc3_);
         }
         this.enableInvitePowerButton.setSelected(!this.enableInvitePowerButton.getSelected());
      }
      
      override protected function createChildren() : void
      {
         this.playerNameTextfield = new TextFieldProxy(this);
         this.setTimelineChildByName("playerNameText",this.playerNameTextfield);
         this.playerLevelTextfield = new TextFieldProxy(this);
         this.setTimelineChildByName("playerLevelText",this.playerLevelTextfield);
         this.gameHistoryTextfield = new TextFieldProxy(this);
         this.setTimelineChildByName("gameHistoryText",this.gameHistoryTextfield);
         this.playerIcon = new SpriteProxy(this);
         this.setTimelineChildByName("avatarSizer",this.playerIcon);
         this.buttonContainer = new LayoutContainerView(this);
         this.setTimelineChildByName("buttonContainer",this.buttonContainer);
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.setGap(2);
         this.buttonContainer.setLayoutAlgorithm(_loc1_);
         this.lobbyOwnerIcon = new SpriteProxy(this);
         this.lobbyOwnerIcon.setLinkage("GameOwnerIcon");
         assignToolTip(this.lobbyOwnerIcon,RiotResourceLoader.getString("practiceGame_teamMemberRenderer_tooltip_owner"));
         this.viewProfileButton = new ButtonX(this);
         this.viewProfileButton.setLinkage("ViewProfileButton");
         this.viewProfileButton.addEventListener(MouseEvent.CLICK,this.onViewLobbyButtonClicked);
         assignToolTip(this.viewProfileButton,RiotResourceLoader.getString("practiceGame_teamMemberRenderer_tooltip_viewProfile"));
         this.kickPlayerButton = new ButtonX(this);
         this.kickPlayerButton.setLinkage("KickPlayerButton");
         this.kickPlayerButton.addEventListener(MouseEvent.CLICK,this.onKickBanButtonClicked);
         assignToolTip(this.kickPlayerButton,RiotResourceLoader.getString("practiceGame_teamMemberRenderer_tooltip_kick"));
         this.enableInvitePowerButton = new ButtonX(this);
         this.enableInvitePowerButton.setLinkage("EnableInviteButton");
         this.enableInvitePowerButton.addEventListener(MouseEvent.CLICK,this.onDelegateChanged);
         this.enableInvitePowerButton.setSelected(false);
         assignToolTip(this.enableInvitePowerButton,RiotResourceLoader.getString("practiceGame_teamMemberRenderer_tooltip_delegateInvitePower"));
         this.delegateInvitePowersEnabledIcon = new SpriteProxy(this);
         this.delegateInvitePowersEnabledIcon.setLinkage("");
         assignToolTip(this.delegateInvitePowersEnabledIcon,RiotResourceLoader.getString("practiceGame_teamMemberRenderer_tooltip_invitePower"));
         this._inviteGroup.allowedToInviteChanged.add(this.onAllowedToInviteChanged);
         this.addBuddyButton = new ButtonX(this);
         this.addBuddyButton.setLinkage("AddFriendButton");
         this.addBuddyButton.addEventListener(MouseEvent.CLICK,this.onAddBuddyClicked);
         assignToolTip(this.addBuddyButton,RiotResourceLoader.getString("practiceGame_teamMemberRenderer_tooltip_addFriend"));
         this.addChild(this.buttonContainer);
      }
      
      private function onViewLobbyButtonClicked(param1:MouseEvent) : void
      {
         this.lobbyController.searchForSummoner(this.summonerData.summonerName,null);
      }
      
      private function onAllowedToInviteChanged(param1:Boolean) : void
      {
         if(this.isMe && !this._inviteGroup.isOwner && param1)
         {
            this.buttonContainer.addChild(this.delegateInvitePowersEnabledIcon);
            this.buttonContainer.addElement(this.delegateInvitePowersEnabledIcon);
         }
         else
         {
            this.buttonContainer.removeChild(this.delegateInvitePowersEnabledIcon);
            this.buttonContainer.removeElement(this.delegateInvitePowersEnabledIcon);
         }
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      protected function onKickBanButtonClicked(param1:MouseEvent) : void
      {
         if(!this.data)
         {
            return;
         }
         var _loc2_:AlertAction = new AlertAction(RiotResourceLoader.getString("practiceGame_teamMemberRenderer_verifykickban_title"),RiotResourceLoader.getString("practiceGame_teamMemberRenderer_verifykickban_message",null,[this.summonerData.summonerName]));
         _loc2_.showNegative = true;
         _loc2_.affirmativeDefault = false;
         _loc2_.setYesNoLabels();
         _loc2_.getCompleted().addOnce(this.handleKickBanPlayer);
         _loc2_.add();
      }
      
      public function createSummonerData(param1:Object) : void
      {
         this._data = param1;
         if(this.statusWatcher != null)
         {
            this.statusWatcher.unwatch();
            this.statusWatcher = null;
         }
         var _loc2_:RoomOccupant = param1 as RoomOccupant;
         if(!_loc2_)
         {
            return;
         }
         if(!_loc2_.rosterItem)
         {
            return;
         }
         var _loc3_:SummonerQuickViewData = new SummonerQuickViewData();
         _loc3_.fillSummonerData(_loc2_);
         this.summonerData = _loc3_;
         this.statusWatcher = ChangeWatcher.watch(_loc2_.rosterItem,"status",this.onStatusChanged);
         if(this.isOwner || !this._inviteGroup.isOwner)
         {
            this.isOwner = true;
         }
         else
         {
            this.isOwner = false;
         }
         if(this.session.summoner.sumId == this.summonerData.summonerId)
         {
            this.isMe = true;
         }
         else
         {
            this.isMe = false;
         }
         if(this.session.summoner.sumId == this.summonerData.summonerId || Boolean(this.chatController.isSummonerBuddy(this.summonerData.summonerName)))
         {
            this.isBuddy = true;
         }
         else
         {
            this.isBuddy = false;
         }
         this.setOwnershipInfo();
         if(Boolean(this._inviteGroup.isOwner) && !this.isOwner && this._inviteController.getSelectedGameQueueConfig() != null && this._inviteController.getSelectedGameQueueConfig().maximumParticipantListSize > 2)
         {
            this.allowDelegateInvites = true;
         }
         else
         {
            this.allowDelegateInvites = false;
         }
         this.setData();
      }
      
      private function onStatusChanged(param1:PropertyChangeEvent) : void
      {
         this.createSummonerData(this.data);
      }
      
      private function setData() : void
      {
         if(!this.summonerData)
         {
            return;
         }
         this.playerNameTextfield.setText(this.summonerData.summonerName);
         this.playerLevelTextfield.setText(RiotResourceLoader.getString("summoner_level_label",null,[this.summonerData.level]));
         this.gameHistoryTextfield.setText("\n" + RiotResourceLoader.getString("summoner_quickview_normal_wins",null,["","",this.summonerData.wins + this.summonerData.odinWins]));
         this.playerIcon.removeAllChildren();
         this.buddyIconImage = new DisplayObjectProxy(this,new Bitmap(this.summonerData.iconSource as BitmapData));
         this.buddyIconImage.setWidth(63);
         this.buddyIconImage.setHeight(63);
         this.playerIcon.addChild(this.buddyIconImage);
         this.buttonContainer.removeAllChildren();
         this.buttonContainer.removeAllElements();
         if(this.isOwner)
         {
            this.buttonContainer.addChild(this.lobbyOwnerIcon);
            this.buttonContainer.addElement(this.lobbyOwnerIcon);
         }
         if(!this.isMe)
         {
            this.buttonContainer.addChild(this.viewProfileButton);
            this.buttonContainer.addElement(this.viewProfileButton);
         }
         if(!this.isOwner && Boolean(this._inviteGroup.isOwner))
         {
            this.buttonContainer.addChild(this.kickPlayerButton);
            this.buttonContainer.addElement(this.kickPlayerButton);
         }
         var _loc1_:InviteParticipant = this._inviteGroup.getParticipantByName(this.summonerData.summonerName);
         if(Boolean(this._inviteGroup.isOwner) && !this.isOwner && !this.rankedInviteController.isPlayerGuest(this.summonerData.summonerId) && this._inviteController.getSelectedGameQueueConfig() != null && this._inviteController.getSelectedGameQueueConfig().maximumParticipantListSize > 2)
         {
            this.buttonContainer.addChild(this.enableInvitePowerButton);
            this.buttonContainer.addElement(this.enableInvitePowerButton);
            this.enableInvitePowerButton.setSelected(_loc1_ ? Boolean(_loc1_.hasDelegatedInvitePower) : false);
         }
         if(this.session.summoner.sumId != this.summonerData.summonerId && !this.chatController.isSummonerBuddy(this.summonerData.summonerName))
         {
            this.buttonContainer.addChild(this.addBuddyButton);
            this.buttonContainer.addElement(this.addBuddyButton);
         }
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         super.updateLayout(param1,param2);
         this.setData();
         if(!this.summonerData)
         {
            return new Rectangle(0,0,param1,param2);
         }
         return new Rectangle(0,0,this.buddyIconImage.getWidth(),this.buddyIconImage.getHeight());
      }
      
      private function onAddBuddyClicked(param1:MouseEvent) : void
      {
         this.chatController.addBuddy(this.summonerData.summonerName);
         invalidateLayout();
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         registerDependency(IToolTipManager,TipsProviderProxy.instance.createWindowToolTipManager(this));
      }
      
      protected function handleKickBanPlayer(param1:AlertAction) : void
      {
         var _loc2_:PlayerParticipant = null;
         if(param1.affirmativeResponse)
         {
            _loc2_ = new PlayerParticipant();
            _loc2_.summonerId = this.summonerData.summonerId;
            this._inviteController.cancelPlayerParticipant(_loc2_);
         }
      }
      
      private function setOwnershipInfo() : void
      {
         if(!this._inviteGroup || !this._inviteGroup.ownerParticipant || !this._inviteGroup.ownerParticipant.jid || !this.data || !this.data.jid)
         {
            return;
         }
         this.isOwner = this.data.jid.bareJID == this._inviteGroup.ownerParticipant.jid.bareJID;
      }
   }
}

