package com.riotgames.platform.gameclient.views.game.normal.normalTeamSelection
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.buddyImages.BuddyImages;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.IChatRosterProvider;
   import com.riotgames.platform.gameclient.chat.IPresenceProvider;
   import com.riotgames.platform.gameclient.chat.domain.PresenceStatusData;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.components.summoner.SummonerQuickView;
   import com.riotgames.platform.gameclient.components.summoner.SummonerQuickViewData;
   import com.riotgames.platform.gameclient.domain.PlayerParticipant;
   import com.riotgames.platform.gameclient.domain.Summoner;
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipant;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.invite.IInviteController;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import flash.accessibility.*;
   import flash.data.*;
   import flash.debugger.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filesystem.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.html.*;
   import flash.html.script.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import mx.binding.*;
   import mx.binding.utils.ChangeWatcher;
   import mx.containers.Canvas;
   import mx.containers.HBox;
   import mx.controls.Image;
   import mx.controls.Menu;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.styles.*;
   import org.igniterealtime.xiff.conference.RoomOccupant;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.data.Presence;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   import org.igniterealtime.xiff.data.muc.MUCItem;
   import org.igniterealtime.xiff.data.muc.MUCUserExtension;
   
   use namespace mx_internal;
   
   public class NormalTeamMemberRenderer extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private static const ICON_SIZE:int = 26;
      
      private static const BOTTOM_PADDING:int = 5;
      
      public var presenceProvider:IPresenceProvider;
      
      public var lobbyController:ILobbyViewController;
      
      private var _embed_mxml________ClientAssets_imageEmbeds_buttons_icon_inviteEnable_active_png_1650412432:Class = NormalTeamMemberRenderer__embed_mxml________ClientAssets_imageEmbeds_buttons_icon_inviteEnable_active_png_1650412432;
      
      private var _1957065706transferOwnershipButton:SoundEffectButton;
      
      private var _711327457viewProfile_btn:SoundEffectButton;
      
      private var _1295807567kickBanActive:Boolean = false;
      
      private var _458524140canPassInvitePrivileges:Boolean = false;
      
      private var _535120997gameOwner_img:Image;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      private var _504079896summonerData:SummonerQuickViewData = null;
      
      private var _2120674566kickBan_btn:SoundEffectButton;
      
      private var statusWatcher:ChangeWatcher = null;
      
      private var _2097213312invitePower_img:Image;
      
      private var _240972149canDelegate:Boolean = false;
      
      public var inviteController:IInviteController;
      
      public var session:Session;
      
      mx_internal var _watchers:Array = [];
      
      private var _1688880603delegateInvitePowerBtn:SoundEffectButton;
      
      private var _chatRosterProvider:IChatRosterProvider;
      
      private var _800044587isCurrentSummonerMe:Boolean = false;
      
      private var _766763099isCurrentSummonerFriend:Boolean = false;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      protected var playerTooltip:Menu;
      
      private var _1696059544summonerQuickView_c:SummonerQuickView;
      
      mx_internal var _bindings:Array = [];
      
      private var _1736312644addFriend_btn:SoundEffectButton;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":SummonerQuickView,
               "id":"summonerQuickView_c",
               "stylesFactory":function():void
               {
                  this.left = "3";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "percentHeight":100,
                     "percentWidth":100
                  };
               }
            }),new UIComponentDescriptor({
               "type":Image,
               "id":"gameOwner_img",
               "stylesFactory":function():void
               {
                  this.left = "80";
               }
            }),new UIComponentDescriptor({
               "type":Image,
               "id":"invitePower_img",
               "stylesFactory":function():void
               {
                  this.left = "80";
               },
               "propertiesFactory":function():Object
               {
                  return {"source":_embed_mxml________ClientAssets_imageEmbeds_buttons_icon_inviteEnable_active_png_1650412432};
               }
            }),new UIComponentDescriptor({
               "type":HBox,
               "id":"optionsButtons",
               "stylesFactory":function():void
               {
                  this.horizontalGap = 2;
               },
               "propertiesFactory":function():Object
               {
                  return {"childDescriptors":[new UIComponentDescriptor({
                     "type":SoundEffectButton,
                     "id":"kickBan_btn",
                     "events":{"click":"__kickBan_btn_click"},
                     "propertiesFactory":function():Object
                     {
                        return {
                           "styleName":"removeButton",
                           "useHandCursor":true,
                           "buttonMode":true
                        };
                     }
                  }),new UIComponentDescriptor({
                     "type":SoundEffectButton,
                     "id":"viewProfile_btn",
                     "events":{"click":"__viewProfile_btn_click"},
                     "propertiesFactory":function():Object
                     {
                        return {
                           "styleName":"viewProfileButton",
                           "useHandCursor":true,
                           "buttonMode":true
                        };
                     }
                  }),new UIComponentDescriptor({
                     "type":SoundEffectButton,
                     "id":"addFriend_btn",
                     "events":{"click":"__addFriend_btn_click"},
                     "propertiesFactory":function():Object
                     {
                        return {
                           "styleName":"addButton",
                           "useHandCursor":true,
                           "buttonMode":true
                        };
                     }
                  }),new UIComponentDescriptor({
                     "type":SoundEffectButton,
                     "id":"delegateInvitePowerBtn",
                     "events":{
                        "change":"__delegateInvitePowerBtn_change",
                        "addedToStage":"__delegateInvitePowerBtn_addedToStage"
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "toggle":true,
                           "styleName":"delegateInvitePower"
                        };
                     }
                  }),new UIComponentDescriptor({
                     "type":SoundEffectButton,
                     "id":"transferOwnershipButton",
                     "events":{"click":"__transferOwnershipButton_click"},
                     "propertiesFactory":function():Object
                     {
                        return {
                           "styleName":"transferOwner",
                           "buttonMode":true
                        };
                     }
                  })]};
               }
            })]};
         }
      });
      
      private var _1352273578isCurrentSummonerOwner:Boolean = false;
      
      public var inviteGroup:InviteGroup;
      
      private var _1815362813optionsButtons:HBox;
      
      public function NormalTeamMemberRenderer()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.addEventListener("initialize",this.___NormalTeamMemberRenderer_Canvas1_initialize);
         this.addEventListener("removedFromStage",this.___NormalTeamMemberRenderer_Canvas1_removedFromStage);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         NormalTeamMemberRenderer._watcherSetupUtil = param1;
      }
      
      public function set invitePower_img(param1:Image) : void
      {
         var _loc2_:Object = this._2097213312invitePower_img;
         if(_loc2_ !== param1)
         {
            this._2097213312invitePower_img = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"invitePower_img",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get optionsButtons() : HBox
      {
         return this._1815362813optionsButtons;
      }
      
      [Bindable(event="propertyChange")]
      public function get kickBan_btn() : SoundEffectButton
      {
         return this._2120674566kickBan_btn;
      }
      
      protected function onRollOverSummonerName(param1:MouseEvent) : void
      {
         if(this.data == null)
         {
            if(this.playerTooltip != null)
            {
               this.playerTooltip.hide();
               this.playerTooltip = null;
            }
         }
      }
      
      public function set optionsButtons(param1:HBox) : void
      {
         var _loc2_:Object = this._1815362813optionsButtons;
         if(_loc2_ !== param1)
         {
            this._1815362813optionsButtons = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"optionsButtons",_loc2_,param1));
         }
      }
      
      public function set kickBan_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._2120674566kickBan_btn;
         if(_loc2_ !== param1)
         {
            this._2120674566kickBan_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"kickBan_btn",_loc2_,param1));
         }
      }
      
      public function __delegateInvitePowerBtn_addedToStage(param1:Event) : void
      {
         this.setDelegatePower();
      }
      
      [Bindable(event="propertyChange")]
      public function get delegateInvitePowerBtn() : SoundEffectButton
      {
         return this._1688880603delegateInvitePowerBtn;
      }
      
      [Bindable(event="propertyChange")]
      private function get summonerData() : SummonerQuickViewData
      {
         return this._504079896summonerData;
      }
      
      public function __delegateInvitePowerBtn_change(param1:Event) : void
      {
         this.onDelegateChanged();
      }
      
      [Bindable(event="propertyChange")]
      public function get transferOwnershipButton() : SoundEffectButton
      {
         return this._1957065706transferOwnershipButton;
      }
      
      public function __kickBan_btn_click(param1:MouseEvent) : void
      {
         this.onKickBanButtonClicked(param1);
      }
      
      private function set summonerData(param1:SummonerQuickViewData) : void
      {
         var _loc2_:Object = this._504079896summonerData;
         if(_loc2_ !== param1)
         {
            this._504079896summonerData = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerData",_loc2_,param1));
         }
      }
      
      private function createSummonerData() : void
      {
         var _loc3_:RoomOccupant = null;
         var _loc5_:Presence = null;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:MUCItem = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:PresenceStatusData = null;
         var _loc12_:Summoner = null;
         if(this.statusWatcher != null)
         {
            this.statusWatcher.unwatch();
            this.statusWatcher = null;
         }
         var _loc1_:InviteParticipant = this.data as InviteParticipant;
         var _loc2_:RosterItemVO = RosterItemVO.get(_loc1_.jid,false);
         var _loc4_:SummonerQuickViewData = new SummonerQuickViewData();
         if(_loc2_)
         {
            _loc5_ = _loc2_.getPrimaryPresence();
            _loc6_ = _loc2_.displayName;
            _loc9_ = "";
            _loc10_ = "";
            if(_loc5_)
            {
               _loc7_ = _loc5_.getAllExtensionsByNS(MUCUserExtension.NS);
               _loc9_ = _loc5_.show;
               _loc10_ = _loc5_.status;
               this.statusWatcher = ChangeWatcher.watch(_loc5_,"status",this.onStatusChanged);
            }
            if(_loc7_)
            {
               _loc8_ = _loc7_[0].getAllItems()[0];
            }
            if(_loc8_)
            {
               _loc3_ = new RoomOccupant(_loc6_,_loc9_,_loc8_.affiliation,_loc8_.role,_loc8_.jid ? _loc8_.jid.unescaped : null,null,_loc10_);
            }
            else
            {
               _loc3_ = new RoomOccupant(_loc6_,_loc9_,"","",_loc1_.jid,null,_loc10_);
            }
            _loc4_.fillSummonerData(_loc3_,_loc1_);
         }
         else if(Boolean(this.session.summoner) && _loc1_.summonerId == this.session.summoner.sumId)
         {
            _loc11_ = this.presenceProvider.selfPresenceData;
            _loc12_ = this.session.summoner;
            _loc4_.summonerId = _loc12_.sumId;
            _loc4_.summonerName = _loc12_.name;
            _loc4_.iconSource = BuddyImages.getSummonerIconSafely(_loc11_.profileIconId);
            _loc4_.odinWins = _loc11_.odinWins;
            _loc4_.level = _loc11_.level;
            _loc4_.tier = _loc11_.tier;
            _loc4_.wins = _loc11_.wins;
            _loc4_.rankedLeagueDivision = _loc11_.rankedLeagueDivision;
            _loc4_.rankedLeagueName = _loc11_.rankedLeagueName;
            _loc4_.rankedLeagueTier = _loc11_.rankedLeagueTier;
            _loc4_.rankedLosses = _loc11_.rankedLosses;
            _loc4_.rankedQueueType = _loc11_.rankedLeagueQueueType;
            _loc4_.rankedRating = _loc11_.rankedRating;
            _loc4_.rankedWins = _loc11_.rankedWins;
         }
         else
         {
            _loc4_.summonerId = _loc1_.summonerId;
            _loc4_.summonerName = _loc1_.name;
            _loc4_.iconSource = BuddyImages.getSummonerIconSafely(0);
         }
         this.summonerData = _loc4_;
      }
      
      public function __transferOwnershipButton_click(param1:MouseEvent) : void
      {
         this.onOwnershipTransferClicked();
      }
      
      public function set delegateInvitePowerBtn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._1688880603delegateInvitePowerBtn;
         if(_loc2_ !== param1)
         {
            this._1688880603delegateInvitePowerBtn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"delegateInvitePowerBtn",_loc2_,param1));
         }
      }
      
      private function onOwnershipTransferClicked() : void
      {
         this.inviteController.transferOwnership(this.summonerData.summonerId);
      }
      
      public function set transferOwnershipButton(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._1957065706transferOwnershipButton;
         if(_loc2_ !== param1)
         {
            this._1957065706transferOwnershipButton = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"transferOwnershipButton",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get kickBanActive() : Boolean
      {
         return this._1295807567kickBanActive;
      }
      
      private function onChatRosterProvider(param1:IChatRosterProvider) : void
      {
         this._chatRosterProvider = param1;
         this.data = this.data;
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         if(this.playerTooltip != null)
         {
            this.playerTooltip.hide();
            this.playerTooltip = null;
         }
         if(!this._chatRosterProvider)
         {
            ProviderLookup.getProvider(IChatRosterProvider,this.onChatRosterProvider);
         }
         this.createSummonerData();
         this.setOwnershipInfo();
         this.updateSummonerState();
      }
      
      public function ___NormalTeamMemberRenderer_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      [Bindable(event="propertyChange")]
      private function get isCurrentSummonerOwner() : Boolean
      {
         return this._1352273578isCurrentSummonerOwner;
      }
      
      private function setDelegatePower() : void
      {
         var _loc2_:InviteParticipant = null;
         this.canDelegate = !this.isCurrentSummonerOwner && !this.isCurrentSummonerMe && Boolean(this.inviteGroup) && Boolean(this.inviteGroup.isOwner);
         var _loc1_:ConfigurationModel = DynamicClientConfigManager.getConfiguration("GameInvites","ServiceEnabled",true,null);
         this.canPassInvitePrivileges = this.canDelegate && Boolean(_loc1_.getBoolean());
         if(Boolean(this.inviteGroup) && Boolean(this.summonerData) && Boolean(this.delegateInvitePowerBtn))
         {
            _loc2_ = this.inviteGroup.getParticipantByName(this.summonerData.summonerName);
            this.delegateInvitePowerBtn.selected = _loc2_ ? Boolean(_loc2_.hasDelegatedInvitePower) : false;
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get isCurrentSummonerFriend() : Boolean
      {
         return this._766763099isCurrentSummonerFriend;
      }
      
      [Bindable(event="propertyChange")]
      public function get gameOwner_img() : Image
      {
         return this._535120997gameOwner_img;
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerQuickView_c() : SummonerQuickView
      {
         return this._1696059544summonerQuickView_c;
      }
      
      public function __addFriend_btn_click(param1:MouseEvent) : void
      {
         this.onAddBuddyClicked();
      }
      
      [Bindable(event="propertyChange")]
      private function get canDelegate() : Boolean
      {
         return this._240972149canDelegate;
      }
      
      public function set addFriend_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._1736312644addFriend_btn;
         if(_loc2_ !== param1)
         {
            this._1736312644addFriend_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"addFriend_btn",_loc2_,param1));
         }
      }
      
      private function setOwnershipInfo() : void
      {
         if(!this.inviteGroup || !this.inviteGroup.ownerParticipant || !this.inviteGroup.ownerParticipant.jid || !this.data || !this.data.jid)
         {
            return;
         }
         this.isCurrentSummonerOwner = this.data.jid.bareJID == this.inviteGroup.ownerParticipant.jid.bareJID;
      }
      
      private function _NormalTeamMemberRenderer_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.summonerData;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_selectionGameOwner");
         _loc1_ = BOTTOM_PADDING;
         _loc1_ = ICON_SIZE;
         _loc1_ = ICON_SIZE;
         _loc1_ = this.isCurrentSummonerOwner;
         _loc1_ = RiotResourceLoader.getString("practiceGame_teamMemberRenderer_tooltip_owner");
         _loc1_ = BOTTOM_PADDING;
         _loc1_ = ICON_SIZE;
         _loc1_ = ICON_SIZE;
         _loc1_ = this.canDelegate;
         _loc1_ = RiotResourceLoader.getString("practiceGame_teamMemberRenderer_tooltip_invitePower");
         _loc1_ = this.gameOwner_img.visible ? this.gameOwner_img.x + this.gameOwner_img.width : 79;
         _loc1_ = BOTTOM_PADDING;
         _loc1_ = ICON_SIZE;
         _loc1_ = ICON_SIZE;
         _loc1_ = ICON_SIZE;
         _loc1_ = RiotResourceLoader.getString("practiceGame_teamMemberRenderer_tooltip_kick");
         _loc1_ = this.kickBanActive;
         _loc1_ = this.kickBanActive;
         _loc1_ = ICON_SIZE;
         _loc1_ = ICON_SIZE;
         _loc1_ = RiotResourceLoader.getString("practiceGame_teamMemberRenderer_tooltip_viewProfile");
         _loc1_ = !this.isCurrentSummonerMe;
         _loc1_ = !this.isCurrentSummonerMe;
         _loc1_ = ICON_SIZE;
         _loc1_ = ICON_SIZE;
         _loc1_ = RiotResourceLoader.getString("practiceGame_teamMemberRenderer_tooltip_addFriend");
         _loc1_ = !this.isCurrentSummonerFriend;
         _loc1_ = !this.isCurrentSummonerFriend;
         _loc1_ = ICON_SIZE;
         _loc1_ = ICON_SIZE;
         _loc1_ = RiotResourceLoader.getString("practiceGame_teamMemberRenderer_tooltip_delegateInvitePower");
         _loc1_ = this.canDelegate;
         _loc1_ = this.canDelegate;
         _loc1_ = ICON_SIZE;
         _loc1_ = ICON_SIZE;
         _loc1_ = RiotResourceLoader.getString("practiceGame_teamMemberRenderer_tooltip_transferOwnership");
         _loc1_ = this.canPassInvitePrivileges;
         _loc1_ = this.canPassInvitePrivileges;
      }
      
      [Bindable(event="propertyChange")]
      public function get invitePower_img() : Image
      {
         return this._2097213312invitePower_img;
      }
      
      private function onViewProfileClicked() : void
      {
         this.lobbyController.searchForSummoner(this.summonerData.summonerName,null);
      }
      
      private function resetView() : void
      {
         if(this.statusWatcher != null)
         {
            this.statusWatcher.unwatch();
            this.statusWatcher = null;
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:NormalTeamMemberRenderer = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._NormalTeamMemberRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_normal_normalTeamSelection_NormalTeamMemberRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },bindings,watchers);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         super.initialize();
      }
      
      private function updateSummonerState() : void
      {
         this.isCurrentSummonerMe = this.session && this.summonerData && Boolean(this.session.summoner) && this.session.summoner.sumId == this.summonerData.summonerId;
         this.kickBanActive = !this.isCurrentSummonerOwner && !this.isCurrentSummonerMe && Boolean(this.inviteGroup) && Boolean(this.inviteGroup.isOwner);
         this.isCurrentSummonerFriend = this.isCurrentSummonerMe || this.summonerData && this._chatRosterProvider && this._chatRosterProvider.isSummonerBuddy(this.summonerData.summonerName) || !this._chatRosterProvider;
         this.setDelegatePower();
      }
      
      private function set kickBanActive(param1:Boolean) : void
      {
         var _loc2_:Object = this._1295807567kickBanActive;
         if(_loc2_ !== param1)
         {
            this._1295807567kickBanActive = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"kickBanActive",_loc2_,param1));
         }
      }
      
      protected function onDelegateChanged() : void
      {
         if(!this.data || !this.summonerData)
         {
            return;
         }
         var _loc1_:UnescapedJID = new UnescapedJID(ChatController.jidFromSummonerId(this.summonerData.summonerId));
         var _loc2_:InviteParticipant = new InviteParticipant(_loc1_,this.summonerData.summonerId,this.summonerData.summonerName);
         if(this.delegateInvitePowerBtn.selected)
         {
            this.inviteController.delegateInvitePower(_loc2_);
         }
         else
         {
            this.inviteController.revokeInvitePower(_loc2_);
         }
      }
      
      private function _NormalTeamMemberRenderer_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Object
         {
            return this.summonerData;
         },function(param1:Object):void
         {
            summonerQuickView_c.data = param1;
         },"summonerQuickView_c.data");
         result[0] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_selectionGameOwner");
         },function(param1:Object):void
         {
            gameOwner_img.source = param1;
         },"gameOwner_img.source");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = BOTTOM_PADDING;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            gameOwner_img.setStyle("bottom",param1);
         },"gameOwner_img.bottom");
         result[2] = binding;
         binding = new Binding(this,function():Number
         {
            return ICON_SIZE;
         },function(param1:Number):void
         {
            gameOwner_img.height = param1;
         },"gameOwner_img.height");
         result[3] = binding;
         binding = new Binding(this,function():Number
         {
            return ICON_SIZE;
         },function(param1:Number):void
         {
            gameOwner_img.width = param1;
         },"gameOwner_img.width");
         result[4] = binding;
         binding = new Binding(this,function():Boolean
         {
            return isCurrentSummonerOwner;
         },function(param1:Boolean):void
         {
            gameOwner_img.visible = param1;
         },"gameOwner_img.visible");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("practiceGame_teamMemberRenderer_tooltip_owner");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            gameOwner_img.toolTip = param1;
         },"gameOwner_img.toolTip");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = BOTTOM_PADDING;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            invitePower_img.setStyle("bottom",param1);
         },"invitePower_img.bottom");
         result[7] = binding;
         binding = new Binding(this,function():Number
         {
            return ICON_SIZE;
         },function(param1:Number):void
         {
            invitePower_img.height = param1;
         },"invitePower_img.height");
         result[8] = binding;
         binding = new Binding(this,function():Number
         {
            return ICON_SIZE;
         },function(param1:Number):void
         {
            invitePower_img.width = param1;
         },"invitePower_img.width");
         result[9] = binding;
         binding = new Binding(this,function():Boolean
         {
            return canDelegate;
         },function(param1:Boolean):void
         {
            invitePower_img.visible = param1;
         },"invitePower_img.visible");
         result[10] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("practiceGame_teamMemberRenderer_tooltip_invitePower");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            invitePower_img.toolTip = param1;
         },"invitePower_img.toolTip");
         result[11] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = gameOwner_img.visible ? gameOwner_img.x + gameOwner_img.width : 79;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            optionsButtons.setStyle("left",param1);
         },"optionsButtons.left");
         result[12] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = BOTTOM_PADDING;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            optionsButtons.setStyle("bottom",param1);
         },"optionsButtons.bottom");
         result[13] = binding;
         binding = new Binding(this,function():Number
         {
            return ICON_SIZE;
         },function(param1:Number):void
         {
            optionsButtons.height = param1;
         },"optionsButtons.height");
         result[14] = binding;
         binding = new Binding(this,function():Number
         {
            return ICON_SIZE;
         },function(param1:Number):void
         {
            kickBan_btn.height = param1;
         },"kickBan_btn.height");
         result[15] = binding;
         binding = new Binding(this,function():Number
         {
            return ICON_SIZE;
         },function(param1:Number):void
         {
            kickBan_btn.width = param1;
         },"kickBan_btn.width");
         result[16] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("practiceGame_teamMemberRenderer_tooltip_kick");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            kickBan_btn.toolTip = param1;
         },"kickBan_btn.toolTip");
         result[17] = binding;
         binding = new Binding(this,function():Boolean
         {
            return kickBanActive;
         },function(param1:Boolean):void
         {
            kickBan_btn.visible = param1;
         },"kickBan_btn.visible");
         result[18] = binding;
         binding = new Binding(this,function():Boolean
         {
            return kickBanActive;
         },function(param1:Boolean):void
         {
            kickBan_btn.includeInLayout = param1;
         },"kickBan_btn.includeInLayout");
         result[19] = binding;
         binding = new Binding(this,function():Number
         {
            return ICON_SIZE;
         },function(param1:Number):void
         {
            viewProfile_btn.height = param1;
         },"viewProfile_btn.height");
         result[20] = binding;
         binding = new Binding(this,function():Number
         {
            return ICON_SIZE;
         },function(param1:Number):void
         {
            viewProfile_btn.width = param1;
         },"viewProfile_btn.width");
         result[21] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("practiceGame_teamMemberRenderer_tooltip_viewProfile");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            viewProfile_btn.toolTip = param1;
         },"viewProfile_btn.toolTip");
         result[22] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !isCurrentSummonerMe;
         },function(param1:Boolean):void
         {
            viewProfile_btn.visible = param1;
         },"viewProfile_btn.visible");
         result[23] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !isCurrentSummonerMe;
         },function(param1:Boolean):void
         {
            viewProfile_btn.includeInLayout = param1;
         },"viewProfile_btn.includeInLayout");
         result[24] = binding;
         binding = new Binding(this,function():Number
         {
            return ICON_SIZE;
         },function(param1:Number):void
         {
            addFriend_btn.height = param1;
         },"addFriend_btn.height");
         result[25] = binding;
         binding = new Binding(this,function():Number
         {
            return ICON_SIZE;
         },function(param1:Number):void
         {
            addFriend_btn.width = param1;
         },"addFriend_btn.width");
         result[26] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("practiceGame_teamMemberRenderer_tooltip_addFriend");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            addFriend_btn.toolTip = param1;
         },"addFriend_btn.toolTip");
         result[27] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !isCurrentSummonerFriend;
         },function(param1:Boolean):void
         {
            addFriend_btn.visible = param1;
         },"addFriend_btn.visible");
         result[28] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !isCurrentSummonerFriend;
         },function(param1:Boolean):void
         {
            addFriend_btn.includeInLayout = param1;
         },"addFriend_btn.includeInLayout");
         result[29] = binding;
         binding = new Binding(this,function():Number
         {
            return ICON_SIZE;
         },function(param1:Number):void
         {
            delegateInvitePowerBtn.height = param1;
         },"delegateInvitePowerBtn.height");
         result[30] = binding;
         binding = new Binding(this,function():Number
         {
            return ICON_SIZE;
         },function(param1:Number):void
         {
            delegateInvitePowerBtn.width = param1;
         },"delegateInvitePowerBtn.width");
         result[31] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("practiceGame_teamMemberRenderer_tooltip_delegateInvitePower");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            delegateInvitePowerBtn.toolTip = param1;
         },"delegateInvitePowerBtn.toolTip");
         result[32] = binding;
         binding = new Binding(this,function():Boolean
         {
            return canDelegate;
         },function(param1:Boolean):void
         {
            delegateInvitePowerBtn.visible = param1;
         },"delegateInvitePowerBtn.visible");
         result[33] = binding;
         binding = new Binding(this,function():Boolean
         {
            return canDelegate;
         },function(param1:Boolean):void
         {
            delegateInvitePowerBtn.includeInLayout = param1;
         },"delegateInvitePowerBtn.includeInLayout");
         result[34] = binding;
         binding = new Binding(this,function():Number
         {
            return ICON_SIZE;
         },function(param1:Number):void
         {
            transferOwnershipButton.height = param1;
         },"transferOwnershipButton.height");
         result[35] = binding;
         binding = new Binding(this,function():Number
         {
            return ICON_SIZE;
         },function(param1:Number):void
         {
            transferOwnershipButton.width = param1;
         },"transferOwnershipButton.width");
         result[36] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("practiceGame_teamMemberRenderer_tooltip_transferOwnership");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            transferOwnershipButton.toolTip = param1;
         },"transferOwnershipButton.toolTip");
         result[37] = binding;
         binding = new Binding(this,function():Boolean
         {
            return canPassInvitePrivileges;
         },function(param1:Boolean):void
         {
            transferOwnershipButton.visible = param1;
         },"transferOwnershipButton.visible");
         result[38] = binding;
         binding = new Binding(this,function():Boolean
         {
            return canPassInvitePrivileges;
         },function(param1:Boolean):void
         {
            transferOwnershipButton.includeInLayout = param1;
         },"transferOwnershipButton.includeInLayout");
         result[39] = binding;
         return result;
      }
      
      protected function onKickBanButtonClicked(param1:MouseEvent) : void
      {
         if(!this.data)
         {
            return;
         }
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         var _loc3_:AlertAction = new AlertAction(_loc2_.getString("resources","practiceGame_teamMemberRenderer_verifykickban_title"),_loc2_.getString("resources","practiceGame_teamMemberRenderer_verifykickban_message",[this.summonerData.summonerName]));
         _loc3_.showNegative = true;
         _loc3_.affirmativeDefault = false;
         _loc3_.setYesNoLabels();
         _loc3_.getCompleted().addOnce(this.handleKickBanPlayer);
         _loc3_.add();
      }
      
      private function set isCurrentSummonerOwner(param1:Boolean) : void
      {
         var _loc2_:Object = this._1352273578isCurrentSummonerOwner;
         if(_loc2_ !== param1)
         {
            this._1352273578isCurrentSummonerOwner = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isCurrentSummonerOwner",_loc2_,param1));
         }
      }
      
      private function set isCurrentSummonerMe(param1:Boolean) : void
      {
         var _loc2_:Object = this._800044587isCurrentSummonerMe;
         if(_loc2_ !== param1)
         {
            this._800044587isCurrentSummonerMe = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isCurrentSummonerMe",_loc2_,param1));
         }
      }
      
      private function set isCurrentSummonerFriend(param1:Boolean) : void
      {
         var _loc2_:Object = this._766763099isCurrentSummonerFriend;
         if(_loc2_ !== param1)
         {
            this._766763099isCurrentSummonerFriend = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isCurrentSummonerFriend",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get addFriend_btn() : SoundEffectButton
      {
         return this._1736312644addFriend_btn;
      }
      
      public function set viewProfile_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._711327457viewProfile_btn;
         if(_loc2_ !== param1)
         {
            this._711327457viewProfile_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"viewProfile_btn",_loc2_,param1));
         }
      }
      
      private function onStatusChanged(param1:PropertyChangeEvent) : void
      {
         this.createSummonerData();
      }
      
      public function set gameOwner_img(param1:Image) : void
      {
         var _loc2_:Object = this._535120997gameOwner_img;
         if(_loc2_ !== param1)
         {
            this._535120997gameOwner_img = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameOwner_img",_loc2_,param1));
         }
      }
      
      protected function onRollOutSummonerName(param1:MouseEvent) : void
      {
         if(this.playerTooltip != null)
         {
            this.playerTooltip.hide();
         }
      }
      
      protected function onInitialize() : void
      {
         this.setOwnershipInfo();
      }
      
      [Bindable(event="propertyChange")]
      private function get isCurrentSummonerMe() : Boolean
      {
         return this._800044587isCurrentSummonerMe;
      }
      
      public function set summonerQuickView_c(param1:SummonerQuickView) : void
      {
         var _loc2_:Object = this._1696059544summonerQuickView_c;
         if(_loc2_ !== param1)
         {
            this._1696059544summonerQuickView_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerQuickView_c",_loc2_,param1));
         }
      }
      
      private function set canPassInvitePrivileges(param1:Boolean) : void
      {
         var _loc2_:Object = this._458524140canPassInvitePrivileges;
         if(_loc2_ !== param1)
         {
            this._458524140canPassInvitePrivileges = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"canPassInvitePrivileges",_loc2_,param1));
         }
      }
      
      public function __viewProfile_btn_click(param1:MouseEvent) : void
      {
         this.onViewProfileClicked();
      }
      
      [Bindable(event="propertyChange")]
      public function get viewProfile_btn() : SoundEffectButton
      {
         return this._711327457viewProfile_btn;
      }
      
      private function onAddBuddyClicked() : void
      {
         if(this._chatRosterProvider)
         {
            this._chatRosterProvider.addBuddy(this.summonerData.summonerName);
            this.isCurrentSummonerFriend = true;
         }
      }
      
      protected function handleKickBanPlayer(param1:AlertAction) : void
      {
         var _loc2_:PlayerParticipant = null;
         if(param1.affirmativeResponse)
         {
            _loc2_ = new PlayerParticipant();
            _loc2_.summonerId = this.summonerData.summonerId;
            this.inviteController.cancelPlayerParticipant(_loc2_);
         }
      }
      
      private function set canDelegate(param1:Boolean) : void
      {
         var _loc2_:Object = this._240972149canDelegate;
         if(_loc2_ !== param1)
         {
            this._240972149canDelegate = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"canDelegate",_loc2_,param1));
         }
      }
      
      public function ___NormalTeamMemberRenderer_Canvas1_removedFromStage(param1:Event) : void
      {
         this.resetView();
      }
      
      [Bindable(event="propertyChange")]
      private function get canPassInvitePrivileges() : Boolean
      {
         return this._458524140canPassInvitePrivileges;
      }
   }
}

