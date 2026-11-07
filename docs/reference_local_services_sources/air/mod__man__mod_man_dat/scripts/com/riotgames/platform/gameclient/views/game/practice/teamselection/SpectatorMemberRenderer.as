package com.riotgames.platform.gameclient.views.game.practice.teamselection
{
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.buddyImages.BuddyImages;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.domain.PresenceStatusData;
   import com.riotgames.platform.gameclient.chat.renderer.BuddyTooltip;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.components.summoner.SummonerIcon;
   import com.riotgames.platform.gameclient.components.summoner.SummonerQuickViewData;
   import com.riotgames.platform.gameclient.domain.GameObserver;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import com.riotgames.platform.gameclient.domain.game.practice.Team;
   import com.riotgames.platform.gameclient.views.ViewMediator;
   import com.riotgames.pvpnet.game.controllers.TeamSelectionController;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.game.controllers.practice.TeamSelectionSlot;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.alerter.AlerterProviderProxy;
   import com.riotgames.pvpnet.system.alerter.IAlerterProvider;
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
   import mx.collections.ArrayCollection;
   import mx.containers.Canvas;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.controls.Menu;
   import mx.core.IToolTip;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.ToolTipEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class SpectatorMemberRenderer extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static const STATE_BLUE_TEAM:String = Team.TEAM_BLUE;
      
      public static const STATE_PURPLE_TEAM:String = Team.TEAM_PURPLE;
      
      private static const MAX_SLOT_ORDINAL:int = 4;
      
      protected var _2042256638isLastSlot:Boolean = false;
      
      public var alerter:IAlerterProvider = AlerterProviderProxy.instance;
      
      [Inject]
      public var chatController:ChatController;
      
      private var _embed_mxml________ClientAssets_imageEmbeds_teamSelection_gameOwner_png_1567169566:Class = SpectatorMemberRenderer__embed_mxml________ClientAssets_imageEmbeds_teamSelection_gameOwner_png_1567169566;
      
      [Inject]
      public var lobbyController:ILobbyViewController;
      
      protected var _1714654783playerImagePath:Object;
      
      private var _1276666629presence:PresenceStatusData;
      
      private var _711327457viewProfile_btn:SoundEffectButton;
      
      private var _2055495612isBuddy:Boolean = false;
      
      private var _767422259participant:GameParticipant;
      
      private var _535120997gameOwner_img:Image;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      private var _3533310slot:TeamSelectionSlot;
      
      public var _SpectatorMemberRenderer_SoundEffectButton4:SoundEffectButton;
      
      private var _504079896summonerData:SummonerQuickViewData = null;
      
      private var _2120674566kickBan_btn:SoundEffectButton;
      
      public var _SpectatorMemberRenderer_Canvas2:Canvas;
      
      public var _SpectatorMemberRenderer_Canvas3:Canvas;
      
      private var _3239319playerIconImg:SummonerIcon;
      
      public var session:Session = Session.instance;
      
      mx_internal var _watchers:Array = [];
      
      private var _embed_mxml________ClientAssets_imageEmbeds_teamSelection_separator_centered_blue_png_359335774:Class = SpectatorMemberRenderer__embed_mxml________ClientAssets_imageEmbeds_teamSelection_separator_centered_blue_png_359335774;
      
      private var _1816216387playerName_txt:Label;
      
      [Inject]
      public var viewMediator:ViewMediator;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      [Inject]
      private var _843995307teamSelectionController:TeamSelectionController;
      
      protected var playerTooltip:Menu;
      
      protected var _100462653isBot:Boolean = false;
      
      mx_internal var _bindings:Array = [];
      
      private var _1736312644addFriend_btn:SoundEffectButton;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":Canvas,
               "id":"_SpectatorMemberRenderer_Canvas2",
               "events":{
                  "toolTipCreate":"___SpectatorMemberRenderer_Canvas2_toolTipCreate",
                  "toolTipHide":"___SpectatorMemberRenderer_Canvas2_toolTipHide",
                  "toolTipShow":"___SpectatorMemberRenderer_Canvas2_toolTipShow"
               },
               "stylesFactory":function():void
               {
                  this.top = "0";
                  this.left = "0";
                  this.right = "0";
                  this.bottom = "0";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "horizontalScrollPolicy":"off",
                     "verticalScrollPolicy":"off",
                     "toolTip":"unused",
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":Image,
                        "stylesFactory":function():void
                        {
                           this.horizontalCenter = "0";
                           this.bottom = "0";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentWidth":80,
                              "height":1,
                              "maintainAspectRatio":false,
                              "smoothBitmapContent":false,
                              "source":_embed_mxml________ClientAssets_imageEmbeds_teamSelection_separator_centered_blue_png_359335774
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":SoundEffectButton,
                        "id":"kickBan_btn",
                        "events":{"click":"__kickBan_btn_click"},
                        "propertiesFactory":function():Object
                        {
                           return {
                              "x":0,
                              "y":0,
                              "height":26,
                              "width":26,
                              "styleName":"removeButton",
                              "useHandCursor":true,
                              "buttonMode":true
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Image,
                        "id":"gameOwner_img",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "y":0,
                              "width":26,
                              "height":26,
                              "source":_embed_mxml________ClientAssets_imageEmbeds_teamSelection_gameOwner_png_1567169566
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":SummonerIcon,
                        "id":"playerIconImg",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "y":0,
                              "width":26,
                              "height":26
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":SoundEffectButton,
                        "id":"addFriend_btn",
                        "events":{"click":"__addFriend_btn_click"},
                        "propertiesFactory":function():Object
                        {
                           return {
                              "y":0,
                              "height":26,
                              "width":26,
                              "styleName":"addButton",
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
                              "height":26,
                              "width":26,
                              "styleName":"viewProfileButton",
                              "useHandCursor":true,
                              "buttonMode":true
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Label,
                        "id":"playerName_txt",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "y":0,
                              "styleName":"teamMemberName"
                           };
                        }
                     })]
                  };
               }
            }),new UIComponentDescriptor({
               "type":Canvas,
               "id":"_SpectatorMemberRenderer_Canvas3",
               "stylesFactory":function():void
               {
                  this.top = "0";
                  this.left = "0";
                  this.right = "0";
                  this.bottom = "0";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "horizontalScrollPolicy":"off",
                     "verticalScrollPolicy":"off",
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":SoundEffectButton,
                        "id":"_SpectatorMemberRenderer_SoundEffectButton4",
                        "events":{"click":"___SpectatorMemberRenderer_SoundEffectButton4_click"},
                        "stylesFactory":function():void
                        {
                           this.horizontalCenter = "0";
                           this.verticalCenter = "0";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {"styleName":"longButtonBlue"};
                        }
                     })]
                  };
               }
            })]};
         }
      });
      
      protected var _1923681872championSelections:ArrayCollection;
      
      public function SpectatorMemberRenderer()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.addEventListener("initialize",this.___SpectatorMemberRenderer_Canvas1_initialize);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         SpectatorMemberRenderer._watcherSetupUtil = param1;
      }
      
      private function set slot(param1:TeamSelectionSlot) : void
      {
         var _loc2_:Object = this._3533310slot;
         if(_loc2_ !== param1)
         {
            this._3533310slot = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"slot",_loc2_,param1));
         }
      }
      
      private function createPlayerParticipant(param1:GameObserver) : void
      {
         var _loc2_:PresenceStatusData = this.teamSelectionController.userDataMap[param1.summonerName];
         this.fillFakeParticipant(_loc2_,param1);
         if(_loc2_ == null)
         {
            this.teamSelectionController.addEventListener("presenceUpdated",this.updateParticipant,false,0,true);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get kickBan_btn() : SoundEffectButton
      {
         return this._2120674566kickBan_btn;
      }
      
      public function ___SpectatorMemberRenderer_Canvas2_toolTipCreate(param1:ToolTipEvent) : void
      {
         this.createBuddyTooltip(param1);
      }
      
      protected function set isLastSlot(param1:Boolean) : void
      {
         var _loc2_:Object = this._2042256638isLastSlot;
         if(_loc2_ !== param1)
         {
            this._2042256638isLastSlot = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isLastSlot",_loc2_,param1));
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
      
      [Bindable(event="propertyChange")]
      protected function get isLastSlot() : Boolean
      {
         return this._2042256638isLastSlot;
      }
      
      private function set presence(param1:PresenceStatusData) : void
      {
         var _loc2_:Object = this._1276666629presence;
         if(_loc2_ !== param1)
         {
            this._1276666629presence = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"presence",_loc2_,param1));
         }
      }
      
      public function ___SpectatorMemberRenderer_Canvas2_toolTipShow(param1:ToolTipEvent) : void
      {
         this.showBuddyTooltip(param1);
      }
      
      [Bindable(event="propertyChange")]
      private function get summonerData() : SummonerQuickViewData
      {
         return this._504079896summonerData;
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
      
      [Bindable(event="propertyChange")]
      private function get participant() : GameParticipant
      {
         return this._767422259participant;
      }
      
      [Bindable(event="propertyChange")]
      protected function get isBot() : Boolean
      {
         return this._100462653isBot;
      }
      
      public function ___SpectatorMemberRenderer_Canvas2_toolTipHide(param1:ToolTipEvent) : void
      {
         this.hideBuddyTooltip(param1);
      }
      
      [Bindable(event="propertyChange")]
      protected function get playerImagePath() : Object
      {
         return this._1714654783playerImagePath;
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:GameObserver = null;
         super.data = param1;
         this.slot = param1 as TeamSelectionSlot;
         this.participant = this.slot.participant;
         this.isBot = false;
         if(this.slot)
         {
            if(this.slot.type == Team.TEAM_BLUE)
            {
               this.championSelections = this.teamSelectionController.blueTeamChampionSelections;
            }
            else
            {
               this.championSelections = this.teamSelectionController.purpleTeamChampionSelections;
            }
            this.isLastSlot = this.slot.slotOrdinal >= MAX_SLOT_ORDINAL;
         }
         if(this.playerTooltip != null)
         {
            this.playerTooltip.hide();
            this.playerTooltip = null;
         }
         if(this.participant is GameObserver)
         {
            _loc2_ = this.participant as GameObserver;
            this.createPlayerParticipant(_loc2_);
            if(this.session.summoner.sumId == _loc2_.summonerId || Boolean(this.chatController.isSummonerBuddy(this.summonerData.summonerName)))
            {
               this.isBuddy = false;
            }
            else
            {
               this.isBuddy = true;
            }
         }
         else
         {
            this.fillFakeParticipant(null,this.participant);
            this.isBuddy = false;
         }
         this.updateIcons();
      }
      
      public function set teamSelectionController(param1:TeamSelectionController) : void
      {
         var _loc2_:Object = this._843995307teamSelectionController;
         if(_loc2_ !== param1)
         {
            this._843995307teamSelectionController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamSelectionController",_loc2_,param1));
         }
      }
      
      protected function set championSelections(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1923681872championSelections;
         if(_loc2_ !== param1)
         {
            this._1923681872championSelections = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championSelections",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameOwner_img() : Image
      {
         return this._535120997gameOwner_img;
      }
      
      private function set participant(param1:GameParticipant) : void
      {
         var _loc2_:Object = this._767422259participant;
         if(_loc2_ !== param1)
         {
            this._767422259participant = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"participant",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get playerIconImg() : SummonerIcon
      {
         return this._3239319playerIconImg;
      }
      
      private function onTakeSlotClicked() : void
      {
         this.teamSelectionController.takeSlot(this.slot,this.onServiceRequestError,this.onServiceRequestError);
      }
      
      public function __addFriend_btn_click(param1:MouseEvent) : void
      {
         this.onAddBuddyClicked();
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
      
      private function createBuddyTooltip(param1:ToolTipEvent) : void
      {
         BuddyTooltip.hideLastBuddyTooltip();
         var _loc2_:IToolTip = this.createOnlineTooltip();
         param1.toolTip = _loc2_;
         if(_loc2_)
         {
            BuddyTooltip.lastBuddyTooltip = _loc2_ as BuddyTooltip;
         }
      }
      
      public function set playerName_txt(param1:Label) : void
      {
         var _loc2_:Object = this._1816216387playerName_txt;
         if(_loc2_ !== param1)
         {
            this._1816216387playerName_txt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerName_txt",_loc2_,param1));
         }
      }
      
      protected function set playerImagePath(param1:Object) : void
      {
         var _loc2_:Object = this._1714654783playerImagePath;
         if(_loc2_ !== param1)
         {
            this._1714654783playerImagePath = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerImagePath",_loc2_,param1));
         }
      }
      
      protected function set isBot(param1:Boolean) : void
      {
         var _loc2_:Object = this._100462653isBot;
         if(_loc2_ !== param1)
         {
            this._100462653isBot = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isBot",_loc2_,param1));
         }
      }
      
      private function set isBuddy(param1:Boolean) : void
      {
         var _loc2_:Object = this._2055495612isBuddy;
         if(_loc2_ !== param1)
         {
            this._2055495612isBuddy = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isBuddy",_loc2_,param1));
         }
      }
      
      public function ___SpectatorMemberRenderer_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      private function createOnlineTooltip() : IToolTip
      {
         var _loc1_:BuddyTooltip = new BuddyTooltip();
         _loc1_.chatController = this.chatController;
         _loc1_.setBuddyData(this.summonerData.summonerName,this.presence);
         return _loc1_;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:SpectatorMemberRenderer = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._SpectatorMemberRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_practice_teamselection_SpectatorMemberRendererWatcherSetupUtil");
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
      
      private function fillFakeParticipant(param1:PresenceStatusData, param2:GameParticipant) : void
      {
         var _loc5_:GameObserver = null;
         var _loc3_:SummonerQuickViewData = new SummonerQuickViewData();
         var _loc4_:GameObserver = param2 as GameObserver;
         this.presence = param1;
         if(Boolean(param1) && Boolean(_loc4_))
         {
            _loc3_.level = param1.level;
            _loc3_.rankedLosses = param1.rankedLosses;
            _loc3_.summonerId = _loc4_.summonerId;
            _loc3_.summonerName = _loc4_.summonerName;
            _loc3_.wins = param1.wins;
            _loc3_.rankedQueueType = param1.rankedQueueName;
            _loc3_.rankedRating = param1.rankedRating;
            _loc3_.rankedWins = param1.rankedWins;
            _loc3_.iconSource = BuddyImages.getSummonerIconSafely(param1.profileIconId);
            _loc3_.tier = param1.tier;
         }
         else
         {
            _loc3_.rankedQueueType = "";
            _loc3_.rankedRating = 0;
            _loc3_.rankedWins = 0;
            _loc3_.wins = 0;
            _loc3_.rankedLosses = 0;
            if(_loc4_)
            {
               _loc5_ = param2 as GameObserver;
               _loc3_.iconSource = BuddyImages.getSummonerIconSafely(_loc5_.profileIconId);
               _loc3_.level = 0;
               _loc3_.summonerId = _loc5_.summonerId;
            }
            else
            {
               _loc3_.iconSource = "";
               _loc3_.level = 0;
               _loc3_.summonerId = 0;
            }
            if(param2)
            {
               _loc3_.summonerName = param2.summonerName;
            }
         }
         this.summonerData = _loc3_;
      }
      
      protected function onKickBanButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         var _loc3_:AlertAction = new AlertAction(_loc2_.getString("resources","practiceGame_teamMemberRenderer_verifykickban_title"),_loc2_.getString("resources","practiceGame_teamMemberRenderer_verifykickban_message",[this.participant.summonerName]));
         _loc3_.showNegative = true;
         _loc3_.affirmativeDefault = false;
         _loc3_.setYesNoLabels();
         _loc3_.getCompleted().addOnce(this.handleKickBanPlayer);
         _loc3_.add();
      }
      
      protected function onServiceRequestError(param1:ServerError = null) : void
      {
         var _loc2_:IResourceManager = null;
         var _loc3_:AlertAction = null;
         if(param1)
         {
            _loc2_ = ResourceManager.getInstance();
            _loc3_ = new AlertAction(_loc2_.getString("resources","general_generalAlertErrorTitle"),_loc2_.getString("resources",param1.errorCode,param1.messageArguments));
            _loc3_.add();
         }
      }
      
      [Bindable(event="propertyChange")]
      protected function get championSelections() : ArrayCollection
      {
         return this._1923681872championSelections;
      }
      
      private function updateParticipant(param1:PropertyChangeEvent) : void
      {
         if(this.participant is GameObserver)
         {
            if(param1.property == this.participant.summonerName)
            {
               this.fillFakeParticipant(PresenceStatusData(param1.newValue),GameObserver(this.participant));
            }
         }
      }
      
      private function _SpectatorMemberRenderer_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.participant != null;
         _loc1_ = ResourceManager.getInstance().getString("resources","practiceGame_teamMemberRenderer_tooltip_kick");
         _loc1_ = !this.participant.isGameOwner && this.teamSelectionController.isOwner;
         _loc1_ = ResourceManager.getInstance().getString("resources","practiceGame_teamMemberRenderer_tooltip_owner");
         _loc1_ = this.participant != null && this.participant.isGameOwner;
         _loc1_ = this.playerImagePath;
         _loc1_ = this.isBuddy;
         _loc1_ = ResourceManager.getInstance().getString("resources","practiceGame_teamMemberRenderer_tooltip_addFriend");
         _loc1_ = RiotResourceLoader.getString("practiceGame_teamMemberRenderer_tooltip_viewProfile");
         _loc1_ = this.summonerData.summonerName;
         _loc1_ = this.participant == null;
         _loc1_ = RiotResourceLoader.getString("practiceGame_spectatorRenderer_takeSlotLabel");
         _loc1_ = !this.teamSelectionController.isBusy;
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get teamSelectionController() : TeamSelectionController
      {
         return this._843995307teamSelectionController;
      }
      
      [Bindable(event="propertyChange")]
      public function get addFriend_btn() : SoundEffectButton
      {
         return this._1736312644addFriend_btn;
      }
      
      private function _SpectatorMemberRenderer_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Boolean
         {
            return this.participant != null;
         },function(param1:Boolean):void
         {
            _SpectatorMemberRenderer_Canvas2.visible = param1;
         },"_SpectatorMemberRenderer_Canvas2.visible");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ResourceManager.getInstance().getString("resources","practiceGame_teamMemberRenderer_tooltip_kick");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            kickBan_btn.toolTip = param1;
         },"kickBan_btn.toolTip");
         result[1] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !participant.isGameOwner && Boolean(teamSelectionController.isOwner);
         },function(param1:Boolean):void
         {
            kickBan_btn.visible = param1;
         },"kickBan_btn.visible");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ResourceManager.getInstance().getString("resources","practiceGame_teamMemberRenderer_tooltip_owner");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            gameOwner_img.toolTip = param1;
         },"gameOwner_img.toolTip");
         result[3] = binding;
         binding = new Binding(this,function():Boolean
         {
            return participant != null && Boolean(participant.isGameOwner);
         },function(param1:Boolean):void
         {
            gameOwner_img.visible = param1;
         },"gameOwner_img.visible");
         result[4] = binding;
         binding = new Binding(this,function():Object
         {
            return playerImagePath;
         },function(param1:Object):void
         {
            playerIconImg.iconPath = param1;
         },"playerIconImg.iconPath");
         result[5] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.isBuddy;
         },function(param1:Boolean):void
         {
            addFriend_btn.visible = param1;
         },"addFriend_btn.visible");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ResourceManager.getInstance().getString("resources","practiceGame_teamMemberRenderer_tooltip_addFriend");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            addFriend_btn.toolTip = param1;
         },"addFriend_btn.toolTip");
         result[7] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("practiceGame_teamMemberRenderer_tooltip_viewProfile");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            viewProfile_btn.toolTip = param1;
         },"viewProfile_btn.toolTip");
         result[8] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = summonerData.summonerName;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            playerName_txt.text = param1;
         },"playerName_txt.text");
         result[9] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.participant == null;
         },function(param1:Boolean):void
         {
            _SpectatorMemberRenderer_Canvas3.visible = param1;
         },"_SpectatorMemberRenderer_Canvas3.visible");
         result[10] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("practiceGame_spectatorRenderer_takeSlotLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _SpectatorMemberRenderer_SoundEffectButton4.label = param1;
         },"_SpectatorMemberRenderer_SoundEffectButton4.label");
         result[11] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !teamSelectionController.isBusy;
         },function(param1:Boolean):void
         {
            _SpectatorMemberRenderer_SoundEffectButton4.enabled = param1;
         },"_SpectatorMemberRenderer_SoundEffectButton4.enabled");
         result[12] = binding;
         return result;
      }
      
      private function hideBuddyTooltip(param1:ToolTipEvent) : void
      {
         BuddyTooltip.clearLastBuddyTooltip();
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
      
      [Bindable(event="propertyChange")]
      private function get isBuddy() : Boolean
      {
         return this._2055495612isBuddy;
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
      
      protected function onInitialize() : void
      {
      }
      
      public function __viewProfile_btn_click(param1:MouseEvent) : void
      {
         this.lobbyController.searchForSummoner(this.summonerData.summonerName,null);
      }
      
      public function set playerIconImg(param1:SummonerIcon) : void
      {
         var _loc2_:Object = this._3239319playerIconImg;
         if(_loc2_ !== param1)
         {
            this._3239319playerIconImg = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerIconImg",_loc2_,param1));
         }
      }
      
      private function updateIcons() : void
      {
         if(this.summonerData)
         {
            this.playerImagePath = this.summonerData.iconSource;
         }
         else
         {
            this.playerImagePath = null;
         }
         this.gameOwner_img.x = this.kickBan_btn.visible ? this.kickBan_btn.x + this.kickBan_btn.width + 2 : Number(this.kickBan_btn.x);
         this.playerIconImg.x = this.gameOwner_img.visible ? this.gameOwner_img.x + this.gameOwner_img.width + 2 : Number(this.gameOwner_img.x);
         this.addFriend_btn.x = this.playerIconImg.visible ? this.playerIconImg.x + this.playerIconImg.width + 2 : Number(this.playerIconImg.x);
         this.viewProfile_btn.x = this.addFriend_btn.visible ? this.addFriend_btn.x + this.addFriend_btn.width + 2 : Number(this.addFriend_btn.x);
         this.playerName_txt.x = this.viewProfile_btn.visible ? this.viewProfile_btn.x + this.viewProfile_btn.width + 2 : Number(this.viewProfile_btn.x);
      }
      
      [Bindable(event="propertyChange")]
      public function get playerName_txt() : Label
      {
         return this._1816216387playerName_txt;
      }
      
      [Bindable(event="propertyChange")]
      public function get viewProfile_btn() : SoundEffectButton
      {
         return this._711327457viewProfile_btn;
      }
      
      private function onAddBuddyClicked() : void
      {
         this.chatController.addBuddy(this.summonerData.summonerName);
         this.isBuddy = true;
      }
      
      protected function handleKickBanPlayer(param1:AlertAction) : void
      {
         if(param1.affirmativeResponse)
         {
            this.teamSelectionController.banObserverFromGame(GameObserver(this.participant),this.onServiceRequestError);
         }
      }
      
      private function showBuddyTooltip(param1:ToolTipEvent) : void
      {
      }
      
      [Bindable(event="propertyChange")]
      private function get presence() : PresenceStatusData
      {
         return this._1276666629presence;
      }
      
      public function ___SpectatorMemberRenderer_SoundEffectButton4_click(param1:MouseEvent) : void
      {
         this.onTakeSlotClicked();
      }
      
      [Bindable(event="propertyChange")]
      private function get slot() : TeamSelectionSlot
      {
         return this._3533310slot;
      }
   }
}

