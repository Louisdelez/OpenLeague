package com.riotgames.platform.gameclient.views.game.common.endofgame
{
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.buddyImages.BuddyImages;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.controllers.PrivacyListController;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.platform.gameclient.domain.game.GameType;
   import com.riotgames.platform.gameclient.kudos.IKudosButton;
   import com.riotgames.platform.gameclient.kudos.IKudosFactory;
   import com.riotgames.platform.gameclient.kudos.KudosFactoryProxy;
   import com.riotgames.platform.gameclient.views.game.common.ChampionImages;
   import com.riotgames.pvpnet.game.controllers.EndOfGameStatsController;
   import com.riotgames.pvpnet.game.variants.GameFlowVariant;
   import com.riotgames.pvpnet.game.variants.GameFlowVariantFactory;
   import com.riotgames.pvpnet.system.config.ClientConfig;
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
   import mx.containers.Canvas;
   import mx.containers.HBox;
   import mx.containers.utilityClasses.ConstraintColumn;
   import mx.containers.utilityClasses.ConstraintRow;
   import mx.controls.Button;
   import mx.controls.FlexNativeMenu;
   import mx.controls.Image;
   import mx.controls.Menu;
   import mx.controls.Spacer;
   import mx.controls.Text;
   import mx.controls.menuClasses.IMenuItemRenderer;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.FlexNativeMenuEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.ToolTipEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class EndOfGameTeamMemberRenderer extends Canvas implements IBindingClient, IMenuItemRenderer
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _1288238822buddyGift_img:SoundEffectButton;
      
      private var _260828015reportGutter:Spacer;
      
      private var gaveKudo:Boolean = false;
      
      private var _1890749655addBuddy_img:SoundEffectButton;
      
      private var _1712502929imageColumn:ConstraintColumn;
      
      private var showAddFriend:Boolean = false;
      
      private var menuXML:XML;
      
      private var isBot:Boolean = false;
      
      private var _2055495612isBuddy:Boolean = false;
      
      private var _1105858304shouldShowKudosButton:Boolean = false;
      
      mx_internal var _bindingsByDestination:Object;
      
      private var _giftingEnabled:Boolean;
      
      private var kudosButton:IKudosButton;
      
      private var _663557259champColumn:ConstraintColumn;
      
      private var _1922955064contextButtonsColumn:ConstraintColumn;
      
      private var _868055995topRow:ConstraintRow;
      
      [Inject]
      public var privacyListController:PrivacyListController;
      
      private var _780305218showHandCursorOnPlayer:Boolean = true;
      
      private var itemContextMenu:FlexNativeMenu;
      
      private var _1816216387playerName_txt:Text;
      
      public var showReportAPlayer:Boolean = true;
      
      private var _1703772473_giftButtonIsVisible:Boolean;
      
      private var _358153877buttonHBox:HBox;
      
      private var _1384829680blocked_img:Image;
      
      private var _1324270486_canEnableGiftButton:Boolean;
      
      private var _1895424275clientConfig:ClientConfig;
      
      private var _1482198321_giftButtonToolTipText:String;
      
      private var showIgnore:Boolean = false;
      
      private var _985752863player:PlayerParticipantStatsSummary;
      
      private var _394383708addBuddy_img_visible:Boolean = false;
      
      private var _1389014755textColumn:ConstraintColumn;
      
      private var _1733337065isUserBlocked:Boolean = false;
      
      private var _386506055reportButton_visible:Boolean = true;
      
      private var _3241058isMe:Boolean = false;
      
      private var _117682566reportButton:Button;
      
      private var _1855392849bottomRow:ConstraintRow;
      
      private var _1697198172enableAddFriend:Boolean = false;
      
      protected var kudosFactory:IKudosFactory;
      
      mx_internal var _watchers:Array;
      
      private var _1434773187champ_img:Image;
      
      protected var dataChanged:Boolean = true;
      
      private var _501509644iconSource:BitmapData;
      
      private var _1797213037reportEnabled:Boolean = true;
      
      private var _79931679playerNameBox:HBox;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      [Inject]
      public var endOfGameStatsController:EndOfGameStatsController;
      
      [Inject]
      private var _1019249940chatController:ChatController;
      
      mx_internal var _bindings:Array;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      private var _1648878571playerNameContextButton:Canvas;
      
      private var _1266648534endGutter:Spacer;
      
      public function EndOfGameTeamMemberRenderer()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":HBox,
                  "id":"buttonHBox",
                  "stylesFactory":function():void
                  {
                     this.horizontalGap = 3;
                     this.right = "0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "height":24,
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":SoundEffectButton,
                           "id":"addBuddy_img",
                           "events":{"click":"__addBuddy_img_click"},
                           "stylesFactory":function():void
                           {
                              this.verticalCenter = "0";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "height":20,
                                 "width":20,
                                 "styleName":"playerSummaryAddButton",
                                 "buttonMode":true,
                                 "useHandCursor":true
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":SoundEffectButton,
                           "id":"buddyGift_img",
                           "events":{"click":"__buddyGift_img_click"},
                           "stylesFactory":function():void
                           {
                              this.verticalCenter = "0";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "height":20,
                                 "width":20,
                                 "styleName":"playerSummaryGiftButton",
                                 "buttonMode":true,
                                 "useHandCursor":true
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Spacer,
                           "id":"reportGutter",
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "width":10,
                                 "height":20
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Button,
                           "id":"reportButton",
                           "events":{"click":"__reportButton_click"},
                           "stylesFactory":function():void
                           {
                              this.right = "0";
                              this.verticalCenter = "0";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "height":20,
                                 "width":20,
                                 "styleName":"playerSummaryReportAPlayer"
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Spacer,
                           "id":"endGutter",
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "width":10,
                                 "height":20
                              };
                           }
                        })]
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Image,
                  "id":"champ_img",
                  "stylesFactory":function():void
                  {
                     this.verticalCenter = "0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"x":0};
                  }
               }),new UIComponentDescriptor({
                  "type":HBox,
                  "id":"playerNameBox",
                  "stylesFactory":function():void
                  {
                     this.verticalAlign = "bottom";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "height":21,
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":Text,
                           "id":"playerName_txt",
                           "stylesFactory":function():void
                           {
                              this.top = "3";
                              this.right = "100";
                              this.fontFamily = "ApplicationFont2";
                              this.fontSize = 14;
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "height":21,
                                 "selectable":false
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Image,
                           "id":"blocked_img",
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "height":16,
                                 "width":16,
                                 "mouseEnabled":false,
                                 "mouseChildren":false,
                                 "source":""
                              };
                           }
                        })]
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Canvas,
                  "id":"playerNameContextButton",
                  "events":{
                     "click":"__playerNameContextButton_click",
                     "rightClick":"__playerNameContextButton_rightClick",
                     "toolTipCreate":"__playerNameContextButton_toolTipCreate"
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "cacheAsBitmap":true,
                        "horizontalScrollPolicy":"off",
                        "verticalScrollPolicy":"off",
                        "buttonMode":true,
                        "toolTip":"unused"
                     };
                  }
               })]};
            }
         });
         this._1895424275clientConfig = ClientConfig.instance;
         this.kudosFactory = KudosFactoryProxy.getInstance();
         this.menuXML = <root>
                    <menuitem label='**Add Buddy' data='addBudy'/>
                    <menuitem label='**Block' data='blockUser'/>
                    <menuitem label='**Report Player' data='reportPlayer'/>
                </root>;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         if(!this.styleDeclaration)
         {
            this.styleDeclaration = new CSSStyleDeclaration();
         }
         this.styleDeclaration.defaultFactory = function():void
         {
            this.borderStyle = "none";
            this.backgroundAlpha = 0;
         };
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.includeInLayout = false;
         this.constraintColumns = [this._EndOfGameTeamMemberRenderer_ConstraintColumn1_i(),this._EndOfGameTeamMemberRenderer_ConstraintColumn2_i(),this._EndOfGameTeamMemberRenderer_ConstraintColumn3_i(),this._EndOfGameTeamMemberRenderer_ConstraintColumn4_i()];
         this.constraintRows = [this._EndOfGameTeamMemberRenderer_ConstraintRow1_i(),this._EndOfGameTeamMemberRenderer_ConstraintRow2_i()];
         this.addEventListener("initialize",this.___EndOfGameTeamMemberRenderer_Canvas1_initialize);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         EndOfGameTeamMemberRenderer._watcherSetupUtil = param1;
      }
      
      private function set shouldShowKudosButton(param1:Boolean) : void
      {
         var _loc2_:Object = this._1105858304shouldShowKudosButton;
         if(_loc2_ !== param1)
         {
            this._1105858304shouldShowKudosButton = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"shouldShowKudosButton",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get playerNameContextButton() : Canvas
      {
         return this._1648878571playerNameContextButton;
      }
      
      [Bindable(event="propertyChange")]
      private function get isUserBlocked() : Boolean
      {
         return this._1733337065isUserBlocked;
      }
      
      public function set chatController(param1:ChatController) : void
      {
         var _loc2_:Object = this._1019249940chatController;
         if(_loc2_ !== param1)
         {
            this._1019249940chatController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatController",_loc2_,param1));
         }
      }
      
      private function _EndOfGameTeamMemberRenderer_ConstraintColumn3_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.textColumn = _loc1_;
         _loc1_.width = 300;
         _loc1_.initialized(this,"textColumn");
         return _loc1_;
      }
      
      private function updateGiftButton() : void
      {
         if(!this._giftingEnabled)
         {
            if(this.buttonHBox.contains(this.buddyGift_img))
            {
               this.buttonHBox.removeChild(this.buddyGift_img);
            }
         }
         else
         {
            this.buttonHBox.addChildAt(this.buddyGift_img,this.buttonHBox.getChildIndex(this.reportGutter) - 1);
         }
      }
      
      private function set isUserBlocked(param1:Boolean) : void
      {
         var _loc2_:Object = this._1733337065isUserBlocked;
         if(_loc2_ !== param1)
         {
            this._1733337065isUserBlocked = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isUserBlocked",_loc2_,param1));
         }
      }
      
      public function set playerNameContextButton(param1:Canvas) : void
      {
         var _loc2_:Object = this._1648878571playerNameContextButton;
         if(_loc2_ !== param1)
         {
            this._1648878571playerNameContextButton = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerNameContextButton",_loc2_,param1));
         }
      }
      
      private function isOnMyTeam() : Boolean
      {
         if(!this.player || !this.endOfGameStatsController || !this.endOfGameStatsController.endOfGameStats)
         {
            return false;
         }
         if(this.endOfGameStatsController.endOfGameStats.teamPlayerParticipantStats[0].teamId == this.player.teamId)
         {
            return true;
         }
         return false;
      }
      
      public function set buddyGift_img(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._1288238822buddyGift_img;
         if(_loc2_ !== param1)
         {
            this._1288238822buddyGift_img = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"buddyGift_img",_loc2_,param1));
         }
      }
      
      public function __playerNameContextButton_toolTipCreate(param1:ToolTipEvent) : void
      {
         this.createPlayerTooltip(param1);
      }
      
      private function _EndOfGameTeamMemberRenderer_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.enableAddFriend;
         _loc1_ = this.addBuddy_img_visible;
         _loc1_ = this.isUserBlocked ? resourceManager.getString("resources","cantAddBuddy_eog_ignoredUser") : (this.enableAddFriend ? resourceManager.getString("resources","addBuddyWindow_infoLabel") : resourceManager.getString("resources","cantAddBuddy_eog_alreadyFriends"));
         _loc1_ = this._canEnableGiftButton;
         _loc1_ = this._giftButtonIsVisible;
         _loc1_ = this._giftButtonToolTipText;
         _loc1_ = this.reportButton_visible;
         _loc1_ = this.reportEnabled;
         _loc1_ = resourceManager.getString("resources","summonerContext_reportPlayer_label");
         _loc1_ = this.height * 0.8;
         _loc1_ = this.champ_img.height;
         _loc1_ = RiotResourceLoader.getChampionResourceString("name",this.player.skinName,"**" + this.player.skinName);
         _loc1_ = ChampionImages.getIconPath(this.player.skinName);
         _loc1_ = this.champ_img.x + this.champ_img.width;
         _loc1_ = this.player.teamTagText + this.player.summonerName;
         _loc1_ = this.champ_img.x + this.champ_img.width;
         _loc1_ = this.player.leaver ? 11141120 : (this.player.inChat ? 16777215 : 8947848);
         _loc1_ = this.isUserBlocked && !this.isMe;
         _loc1_ = this.champ_img.x;
         _loc1_ = this.champ_img.y;
         _loc1_ = this.playerName_txt.width + this.champ_img.width;
         _loc1_ = this.playerName_txt.height;
         _loc1_ = this.showHandCursorOnPlayer;
      }
      
      public function set playerNameBox(param1:HBox) : void
      {
         var _loc2_:Object = this._79931679playerNameBox;
         if(_loc2_ !== param1)
         {
            this._79931679playerNameBox = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerNameBox",_loc2_,param1));
         }
      }
      
      public function __buddyGift_img_click(param1:MouseEvent) : void
      {
         this.onGiftBuddyClick();
      }
      
      [Bindable(event="propertyChange")]
      public function get topRow() : ConstraintRow
      {
         return this._868055995topRow;
      }
      
      private function createPlayerTooltip(param1:ToolTipEvent) : void
      {
         var _loc2_:EndOfGamePlayerTooltip = new EndOfGamePlayerTooltip();
         _loc2_.endOfGameStatsController = this.endOfGameStatsController;
         _loc2_.data = this.player;
         param1.toolTip = _loc2_;
      }
      
      private function getGiverId() : Number
      {
         var _loc1_:Session = Session.instance;
         return Number(_loc1_.getSummonerId());
      }
      
      public function onAddBuddyClick() : void
      {
         this.chatController.addBuddy(this.player.summonerName);
         this.enableAddFriend = false;
      }
      
      public function set addBuddy_img(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._1890749655addBuddy_img;
         if(_loc2_ !== param1)
         {
            this._1890749655addBuddy_img = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"addBuddy_img",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get enableAddFriend() : Boolean
      {
         return this._1697198172enableAddFriend;
      }
      
      [Bindable(event="propertyChange")]
      private function get isMe() : Boolean
      {
         return this._3241058isMe;
      }
      
      private function _EndOfGameTeamMemberRenderer_ConstraintColumn2_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.champColumn = _loc1_;
         _loc1_.width = 25;
         _loc1_.initialized(this,"champColumn");
         return _loc1_;
      }
      
      private function onContextMenuClick(param1:FlexNativeMenuEvent) : void
      {
         var _loc2_:int = int(param1.index);
         var _loc3_:String = ChatController.jidFromSummonerId(this.player.userId);
         if(_loc2_ == 0)
         {
            this.onAddBuddyClick();
         }
         else if(_loc2_ == 1)
         {
            if(this.isUserBlocked)
            {
               if(this.privacyListController.unblock(_loc3_))
               {
                  this.isUserBlocked = false;
                  this.enableAddFriend = true;
               }
            }
            else
            {
               this.privacyListController.blockAndConfirm(_loc3_,this.player.summonerName,this.onBlockAndConfirm);
            }
         }
         else if(_loc2_ == 2)
         {
            this.onReportButtonClicked();
         }
      }
      
      private function _EndOfGameTeamMemberRenderer_ConstraintRow2_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.bottomRow = _loc1_;
         _loc1_.percentHeight = 60;
         _loc1_.initialized(this,"bottomRow");
         return _loc1_;
      }
      
      public function set topRow(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._868055995topRow;
         if(_loc2_ !== param1)
         {
            this._868055995topRow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"topRow",_loc2_,param1));
         }
      }
      
      private function set showHandCursorOnPlayer(param1:Boolean) : void
      {
         var _loc2_:Object = this._780305218showHandCursorOnPlayer;
         if(_loc2_ !== param1)
         {
            this._780305218showHandCursorOnPlayer = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showHandCursorOnPlayer",_loc2_,param1));
         }
      }
      
      private function updateGiftButtonToolTipText() : void
      {
         if(this.player != null)
         {
            this._giftButtonToolTipText = this.endOfGameStatsController.getGiftToolTipText(this.player,this.isBuddy);
            if(this._giftButtonToolTipText == "")
            {
               this._giftButtonToolTipText = resourceManager.getString("resources","summonerContext_cantGiftPlayer_label");
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get imageColumn() : ConstraintColumn
      {
         return this._1712502929imageColumn;
      }
      
      [Bindable(event="propertyChange")]
      public function get buttonHBox() : HBox
      {
         return this._358153877buttonHBox;
      }
      
      public function ___EndOfGameTeamMemberRenderer_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      private function onLeftClick(param1:MouseEvent) : void
      {
         if(!this.isBot)
         {
            this.itemContextMenu.display(stage,param1.stageX,param1.stageY);
         }
      }
      
      public function get measuredIconWidth() : Number
      {
         return 0;
      }
      
      private function _EndOfGameTeamMemberRenderer_ConstraintColumn1_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.imageColumn = _loc1_;
         _loc1_.width = 25;
         _loc1_.initialized(this,"imageColumn");
         return _loc1_;
      }
      
      private function updateRenderer() : void
      {
         var _loc1_:String = null;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         if(Boolean(this.player) && Boolean(this.privacyListController))
         {
            _loc1_ = ChatController.jidFromSummonerId(this.player.userId);
            this.isMe = this.player.isMe;
            this.isUserBlocked = this.privacyListController.isBlocked(_loc1_);
            this.isBuddy = this.chatController.isSummonerBuddy(this.player.summonerName);
            this.enableAddFriend = !this.isBuddy && !this.isMe && !this.isUserBlocked && Boolean(this.chatController.canAddBuddyToBuddyList) && !this.player.isBotPlayer();
            this.showHandCursorOnPlayer = !this.player.isBotPlayer() && !this.isMe;
            this.isBot = this.player.isBotPlayer();
            this.reportEnabled = this.endOfGameStatsController.localPlayer != null;
            this.showReportAPlayer = Boolean(this.clientConfig.reportAPlayerAvailable) && !this.isBot && !this.isMe;
            this.shouldShowKudosButton = this.showReportAPlayer && !this.isCustomGame();
            this.showIgnore = this.showAddFriend = !this.isMe && !this.isBot;
            this.reportButton.enabled = Boolean(this.player.reportEnabled) && Boolean(this.endOfGameStatsController.localPlayer);
            this._giftingEnabled = this.endOfGameStatsController.endOfGameGiftEnabled;
            this._giftButtonIsVisible = !this.isMe && !this.isBot;
            _loc2_ = Boolean(this.endOfGameStatsController.canEnableGiftButton(this._giftButtonIsVisible,this.player,this.isBuddy));
            if(_loc2_ != this._canEnableGiftButton)
            {
               this._canEnableGiftButton = _loc2_;
               this.updateGiftButtonToolTipText();
            }
            this.updateGiftButton();
            this.blocked_img.source = BuddyImages.getBlockedIconSource();
            this.setLegacyButtonVisibility();
            if(this.kudosButton)
            {
               this.kudosButton.cleanup();
               this.kudosButton = null;
            }
            if(this.shouldShowKudosButton && Boolean(this.buttonHBox))
            {
               _loc3_ = int(this.buttonHBox.getChildIndex(this.reportGutter));
               this.kudosButton = this.kudosFactory.getKudosButton(this.buttonHBox,_loc3_,this.isOnMyTeam(),this.getGiverId(),this.player,this.getGameId(),this.buttonHBox,this.endOfGameStatsController.disableKudos,this.endOfGameStatsController.handleKudosGiven);
               this.kudosButton.enabled = this.isKudosButtonEnabled(this.player,this.endOfGameStatsController);
            }
         }
      }
      
      private function set enableAddFriend(param1:Boolean) : void
      {
         var _loc2_:Object = this._1697198172enableAddFriend;
         if(_loc2_ !== param1)
         {
            this._1697198172enableAddFriend = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enableAddFriend",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get reportButton_visible() : Boolean
      {
         return this._386506055reportButton_visible;
      }
      
      [Bindable(event="propertyChange")]
      public function get playerName_txt() : Text
      {
         return this._1816216387playerName_txt;
      }
      
      private function set addBuddy_img_visible(param1:Boolean) : void
      {
         var _loc2_:Object = this._394383708addBuddy_img_visible;
         if(_loc2_ !== param1)
         {
            this._394383708addBuddy_img_visible = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"addBuddy_img_visible",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get champ_img() : Image
      {
         return this._1434773187champ_img;
      }
      
      private function set isMe(param1:Boolean) : void
      {
         var _loc2_:Object = this._3241058isMe;
         if(_loc2_ !== param1)
         {
            this._3241058isMe = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isMe",_loc2_,param1));
         }
      }
      
      private function _EndOfGameTeamMemberRenderer_ConstraintRow1_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.topRow = _loc1_;
         _loc1_.percentHeight = 40;
         _loc1_.initialized(this,"topRow");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      private function get _giftButtonIsVisible() : Boolean
      {
         return this._1703772473_giftButtonIsVisible;
      }
      
      [Bindable(event="propertyChange")]
      public function get contextButtonsColumn() : ConstraintColumn
      {
         return this._1922955064contextButtonsColumn;
      }
      
      public function set menu(param1:Menu) : void
      {
      }
      
      public function onInitialize() : void
      {
         this.endOfGameStatsController.onEndOfGameGiftEnabledChanged.add(this.onGiftEnabledChange);
         this.localizeContextMenuXML();
         this.createContextMenu();
         this.updateRenderer();
         this.updateGiftButtonToolTipText();
      }
      
      public function __addBuddy_img_click(param1:MouseEvent) : void
      {
         this.onAddBuddyClick();
      }
      
      public function setLegacyButtonVisibility() : void
      {
         this.addBuddy_img_visible = this.showAddFriend;
         this.reportButton_visible = this.showReportAPlayer;
      }
      
      private function set reportEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._1797213037reportEnabled;
         if(_loc2_ !== param1)
         {
            this._1797213037reportEnabled = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"reportEnabled",_loc2_,param1));
         }
      }
      
      public function set reportGutter(param1:Spacer) : void
      {
         var _loc2_:Object = this._260828015reportGutter;
         if(_loc2_ !== param1)
         {
            this._260828015reportGutter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"reportGutter",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get player() : PlayerParticipantStatsSummary
      {
         return this._985752863player;
      }
      
      private function onGiftEnabledChange() : void
      {
         if(this.endOfGameStatsController)
         {
            this._giftingEnabled = this.endOfGameStatsController.endOfGameGiftEnabled;
            this.updateRenderer();
            this.updateGiftButtonToolTipText();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get textColumn() : ConstraintColumn
      {
         return this._1389014755textColumn;
      }
      
      public function set champColumn(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._663557259champColumn;
         if(_loc2_ !== param1)
         {
            this._663557259champColumn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"champColumn",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get clientConfig() : ClientConfig
      {
         return this._1895424275clientConfig;
      }
      
      [Bindable(event="propertyChange")]
      private function get _giftButtonToolTipText() : String
      {
         return this._1482198321_giftButtonToolTipText;
      }
      
      [Bindable(event="propertyChange")]
      public function get blocked_img() : Image
      {
         return this._1384829680blocked_img;
      }
      
      public function __playerNameContextButton_click(param1:MouseEvent) : void
      {
         this.onLeftClick(param1);
      }
      
      [Bindable(event="propertyChange")]
      private function get shouldShowKudosButton() : Boolean
      {
         return this._1105858304shouldShowKudosButton;
      }
      
      public function get summonerId() : Number
      {
         return this.player.userId;
      }
      
      public function set reportButton(param1:Button) : void
      {
         var _loc2_:Object = this._117682566reportButton;
         if(_loc2_ !== param1)
         {
            this._117682566reportButton = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"reportButton",_loc2_,param1));
         }
      }
      
      protected function createContextMenu() : void
      {
         this.itemContextMenu = new FlexNativeMenu();
         this.itemContextMenu.labelField = "@label";
         this.itemContextMenu.showRoot = false;
         this.itemContextMenu.addEventListener(FlexNativeMenuEvent.ITEM_CLICK,this.onContextMenuClick);
         this.itemContextMenu.addEventListener(FlexNativeMenuEvent.MENU_SHOW,this.onContextMenuShow);
         this.itemContextMenu.setContextMenu(this);
         if(!this.isMe)
         {
            this.itemContextMenu.dataProvider = this.menuXML;
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get chatController() : ChatController
      {
         return this._1019249940chatController;
      }
      
      public function __playerNameContextButton_rightClick(param1:MouseEvent) : void
      {
         this.onLeftClick(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get buddyGift_img() : SoundEffectButton
      {
         return this._1288238822buddyGift_img;
      }
      
      [Bindable(event="propertyChange")]
      public function get playerNameBox() : HBox
      {
         return this._79931679playerNameBox;
      }
      
      public function set imageColumn(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._1712502929imageColumn;
         if(_loc2_ !== param1)
         {
            this._1712502929imageColumn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"imageColumn",_loc2_,param1));
         }
      }
      
      public function set buttonHBox(param1:HBox) : void
      {
         var _loc2_:Object = this._358153877buttonHBox;
         if(_loc2_ !== param1)
         {
            this._358153877buttonHBox = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"buttonHBox",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get addBuddy_img() : SoundEffectButton
      {
         return this._1890749655addBuddy_img;
      }
      
      private function set _canEnableGiftButton(param1:Boolean) : void
      {
         var _loc2_:Object = this._1324270486_canEnableGiftButton;
         if(_loc2_ !== param1)
         {
            this._1324270486_canEnableGiftButton = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_canEnableGiftButton",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get showHandCursorOnPlayer() : Boolean
      {
         return this._780305218showHandCursorOnPlayer;
      }
      
      [Bindable(event="propertyChange")]
      private function get addBuddy_img_visible() : Boolean
      {
         return this._394383708addBuddy_img_visible;
      }
      
      public function set bottomRow(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._1855392849bottomRow;
         if(_loc2_ !== param1)
         {
            this._1855392849bottomRow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bottomRow",_loc2_,param1));
         }
      }
      
      public function get menu() : Menu
      {
         return null;
      }
      
      public function onReportButtonClicked() : void
      {
         this.endOfGameStatsController.reportPlayer(this.player);
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         this.player = data as PlayerParticipantStatsSummary;
         this.dataChanged = true;
         this.updateGiftButtonToolTipText();
         super.invalidateProperties();
      }
      
      [Bindable(event="propertyChange")]
      private function get reportEnabled() : Boolean
      {
         return this._1797213037reportEnabled;
      }
      
      public function __reportButton_click(param1:MouseEvent) : void
      {
         this.onReportButtonClicked();
      }
      
      private function onGiftBuddyClick() : void
      {
         this.endOfGameStatsController.initializeGiftWindow(this.player,this.isBuddy,this.disableGiftButton,this.onCloseGiftWindow);
      }
      
      private function set reportButton_visible(param1:Boolean) : void
      {
         var _loc2_:Object = this._386506055reportButton_visible;
         if(_loc2_ !== param1)
         {
            this._386506055reportButton_visible = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"reportButton_visible",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get champColumn() : ConstraintColumn
      {
         return this._663557259champColumn;
      }
      
      [Bindable(event="propertyChange")]
      public function get reportGutter() : Spacer
      {
         return this._260828015reportGutter;
      }
      
      private function onBlockAndConfirm(param1:Boolean) : *
      {
         if(param1)
         {
            this.isUserBlocked = true;
            this.enableAddFriend = false;
         }
      }
      
      private function onCloseGiftWindow() : void
      {
         this._canEnableGiftButton = true;
      }
      
      private function isKudosButtonEnabled(param1:PlayerParticipantStatsSummary, param2:EndOfGameStatsController) : Boolean
      {
         return Boolean(param1.kudosEnabled) && Boolean(param2.localPlayer) && !param1.leaver;
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
      
      public function set playerName_txt(param1:Text) : void
      {
         var _loc2_:Object = this._1816216387playerName_txt;
         if(_loc2_ !== param1)
         {
            this._1816216387playerName_txt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerName_txt",_loc2_,param1));
         }
      }
      
      public function set champ_img(param1:Image) : void
      {
         var _loc2_:Object = this._1434773187champ_img;
         if(_loc2_ !== param1)
         {
            this._1434773187champ_img = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"champ_img",_loc2_,param1));
         }
      }
      
      private function disableGiftButton() : void
      {
         this._canEnableGiftButton = false;
         this.updateGiftButtonToolTipText();
      }
      
      public function get measuredTypeIconWidth() : Number
      {
         return 0;
      }
      
      private function set _giftButtonIsVisible(param1:Boolean) : void
      {
         var _loc2_:Object = this._1703772473_giftButtonIsVisible;
         if(_loc2_ !== param1)
         {
            this._1703772473_giftButtonIsVisible = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_giftButtonIsVisible",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:EndOfGameTeamMemberRenderer = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._EndOfGameTeamMemberRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameTeamMemberRendererWatcherSetupUtil");
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
      
      [Bindable(event="propertyChange")]
      public function get reportButton() : Button
      {
         return this._117682566reportButton;
      }
      
      [Bindable(event="propertyChange")]
      private function get _canEnableGiftButton() : Boolean
      {
         return this._1324270486_canEnableGiftButton;
      }
      
      private function set _giftButtonToolTipText(param1:String) : void
      {
         var _loc2_:Object = this._1482198321_giftButtonToolTipText;
         if(_loc2_ !== param1)
         {
            this._1482198321_giftButtonToolTipText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_giftButtonToolTipText",_loc2_,param1));
         }
      }
      
      public function set contextButtonsColumn(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._1922955064contextButtonsColumn;
         if(_loc2_ !== param1)
         {
            this._1922955064contextButtonsColumn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"contextButtonsColumn",_loc2_,param1));
         }
      }
      
      public function get measuredBranchIconWidth() : Number
      {
         return 0;
      }
      
      public function set endGutter(param1:Spacer) : void
      {
         var _loc2_:Object = this._1266648534endGutter;
         if(_loc2_ !== param1)
         {
            this._1266648534endGutter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"endGutter",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bottomRow() : ConstraintRow
      {
         return this._1855392849bottomRow;
      }
      
      private function getGameId() : Number
      {
         return this.endOfGameStatsController.endOfGameStats.reportGameId;
      }
      
      [Bindable(event="propertyChange")]
      private function get isBuddy() : Boolean
      {
         return this._2055495612isBuddy;
      }
      
      public function set player(param1:PlayerParticipantStatsSummary) : void
      {
         var _loc2_:Object = this._985752863player;
         if(_loc2_ !== param1)
         {
            this._985752863player = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"player",_loc2_,param1));
         }
      }
      
      public function set textColumn(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._1389014755textColumn;
         if(_loc2_ !== param1)
         {
            this._1389014755textColumn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"textColumn",_loc2_,param1));
         }
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:GameFlowVariant = null;
         var _loc2_:PlayerParticipantStatsSummary = null;
         super.commitProperties();
         if(this.dataChanged)
         {
            if(this.player)
            {
               _loc1_ = GameFlowVariantFactory.instance.getVariant(this.endOfGameStatsController.endOfGameStats.gameMutators,this.endOfGameStatsController.endOfGameStats.gameMode);
               _loc2_ = this.data as PlayerParticipantStatsSummary;
               this.iconSource = BuddyImages.getSummonerIconSafely(_loc1_.getEndOfGameProfileIcon(_loc2_));
            }
            this.updateRenderer();
            this.dataChanged = false;
         }
      }
      
      private function isCustomGame() : Boolean
      {
         if(!this.endOfGameStatsController)
         {
            return false;
         }
         if(this.endOfGameStatsController.gameType == GameType.PRACTICE_GAME)
         {
            return true;
         }
         return false;
      }
      
      [Bindable(event="propertyChange")]
      public function get endGutter() : Spacer
      {
         return this._1266648534endGutter;
      }
      
      public function set blocked_img(param1:Image) : void
      {
         var _loc2_:Object = this._1384829680blocked_img;
         if(_loc2_ !== param1)
         {
            this._1384829680blocked_img = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"blocked_img",_loc2_,param1));
         }
      }
      
      public function set clientConfig(param1:ClientConfig) : void
      {
         var _loc2_:Object = this._1895424275clientConfig;
         if(_loc2_ !== param1)
         {
            this._1895424275clientConfig = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clientConfig",_loc2_,param1));
         }
      }
      
      private function set iconSource(param1:BitmapData) : void
      {
         var _loc2_:Object = this._501509644iconSource;
         if(_loc2_ !== param1)
         {
            this._501509644iconSource = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"iconSource",_loc2_,param1));
         }
      }
      
      private function _EndOfGameTeamMemberRenderer_ConstraintColumn4_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.contextButtonsColumn = _loc1_;
         _loc1_.width = 62;
         _loc1_.initialized(this,"contextButtonsColumn");
         return _loc1_;
      }
      
      private function _EndOfGameTeamMemberRenderer_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Boolean
         {
            return this.enableAddFriend;
         },function(param1:Boolean):void
         {
            addBuddy_img.enabled = param1;
         },"addBuddy_img.enabled");
         result[0] = binding;
         binding = new Binding(this,function():Boolean
         {
            return addBuddy_img_visible;
         },function(param1:Boolean):void
         {
            addBuddy_img.visible = param1;
         },"addBuddy_img.visible");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.isUserBlocked ? resourceManager.getString("resources","cantAddBuddy_eog_ignoredUser") : (enableAddFriend ? resourceManager.getString("resources","addBuddyWindow_infoLabel") : resourceManager.getString("resources","cantAddBuddy_eog_alreadyFriends"));
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            addBuddy_img.toolTip = param1;
         },"addBuddy_img.toolTip");
         result[2] = binding;
         binding = new Binding(this,function():Boolean
         {
            return _canEnableGiftButton;
         },function(param1:Boolean):void
         {
            buddyGift_img.enabled = param1;
         },"buddyGift_img.enabled");
         result[3] = binding;
         binding = new Binding(this,function():Boolean
         {
            return _giftButtonIsVisible;
         },function(param1:Boolean):void
         {
            buddyGift_img.visible = param1;
         },"buddyGift_img.visible");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = _giftButtonToolTipText;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            buddyGift_img.toolTip = param1;
         },"buddyGift_img.toolTip");
         result[5] = binding;
         binding = new Binding(this,function():Boolean
         {
            return reportButton_visible;
         },function(param1:Boolean):void
         {
            reportButton.visible = param1;
         },"reportButton.visible");
         result[6] = binding;
         binding = new Binding(this,function():Boolean
         {
            return reportEnabled;
         },function(param1:Boolean):void
         {
            reportButton.enabled = param1;
         },"reportButton.enabled");
         result[7] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","summonerContext_reportPlayer_label");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            reportButton.toolTip = param1;
         },"reportButton.toolTip");
         result[8] = binding;
         binding = new Binding(this,function():Number
         {
            return this.height * 0.8;
         },function(param1:Number):void
         {
            champ_img.height = param1;
         },"champ_img.height");
         result[9] = binding;
         binding = new Binding(this,function():Number
         {
            return champ_img.height;
         },function(param1:Number):void
         {
            champ_img.width = param1;
         },"champ_img.width");
         result[10] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getChampionResourceString("name",player.skinName,"**" + player.skinName);
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            champ_img.toolTip = param1;
         },"champ_img.toolTip");
         result[11] = binding;
         binding = new Binding(this,function():Object
         {
            return ChampionImages.getIconPath(player.skinName);
         },function(param1:Object):void
         {
            champ_img.source = param1;
         },"champ_img.source");
         result[12] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = champ_img.x + champ_img.width;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            playerNameBox.setStyle("left",param1);
         },"playerNameBox.left");
         result[13] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = player.teamTagText + player.summonerName;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            playerName_txt.text = param1;
         },"playerName_txt.text");
         result[14] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = champ_img.x + champ_img.width;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            playerName_txt.setStyle("left",param1);
         },"playerName_txt.left");
         result[15] = binding;
         binding = new Binding(this,function():uint
         {
            return player.leaver ? 11141120 : (player.inChat ? 16777215 : 8947848);
         },function(param1:uint):void
         {
            playerName_txt.setStyle("color",param1);
         },"playerName_txt.color");
         result[16] = binding;
         binding = new Binding(this,function():Boolean
         {
            return isUserBlocked && !this.isMe;
         },function(param1:Boolean):void
         {
            blocked_img.visible = param1;
         },"blocked_img.visible");
         result[17] = binding;
         binding = new Binding(this,function():Number
         {
            return champ_img.x;
         },function(param1:Number):void
         {
            playerNameContextButton.x = param1;
         },"playerNameContextButton.x");
         result[18] = binding;
         binding = new Binding(this,function():Number
         {
            return champ_img.y;
         },function(param1:Number):void
         {
            playerNameContextButton.y = param1;
         },"playerNameContextButton.y");
         result[19] = binding;
         binding = new Binding(this,function():Number
         {
            return playerName_txt.width + champ_img.width;
         },function(param1:Number):void
         {
            playerNameContextButton.width = param1;
         },"playerNameContextButton.width");
         result[20] = binding;
         binding = new Binding(this,function():Number
         {
            return playerName_txt.height;
         },function(param1:Number):void
         {
            playerNameContextButton.height = param1;
         },"playerNameContextButton.height");
         result[21] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.showHandCursorOnPlayer;
         },function(param1:Boolean):void
         {
            playerNameContextButton.useHandCursor = param1;
         },"playerNameContextButton.useHandCursor");
         result[22] = binding;
         return result;
      }
      
      private function onContextMenuShow(param1:FlexNativeMenuEvent) : void
      {
         var _loc2_:String = null;
         if(this.isMe || this.isBot)
         {
            param1.nativeMenu.removeAllItems();
            return;
         }
         if(!this.showReportAPlayer)
         {
            if(param1.nativeMenu.numItems > 2)
            {
               param1.nativeMenu.removeItemAt(2);
            }
         }
         if(this.player)
         {
            _loc2_ = ChatController.jidFromSummonerId(this.player.userId);
            this.isUserBlocked = this.privacyListController.isBlocked(_loc2_);
            param1.nativeMenu.getItemAt(1).checked = this.isUserBlocked;
            param1.nativeMenu.getItemAt(0).enabled = !this.isMe && this.enableAddFriend;
            if((!this.player.reportEnabled || !this.endOfGameStatsController.localPlayer) && param1.nativeMenu.numItems > 2)
            {
               param1.nativeMenu.getItemAt(2).enabled = false;
            }
         }
         else
         {
            param1.nativeMenu.getItemAt(0).enabled = false;
         }
      }
      
      protected function localizeContextMenuXML() : void
      {
         this.menuXML.menuitem[0].@label = resourceManager.getString("resources","BuddyListTreeRenderer_groupAddBuddy");
         this.menuXML.menuitem[1].@label = resourceManager.getString("resources","summonerContext_blockUser_label");
         this.menuXML.menuitem[2].@label = resourceManager.getString("resources","summonerContext_reportPlayer_label");
      }
      
      [Bindable(event="propertyChange")]
      private function get iconSource() : BitmapData
      {
         return this._501509644iconSource;
      }
   }
}

