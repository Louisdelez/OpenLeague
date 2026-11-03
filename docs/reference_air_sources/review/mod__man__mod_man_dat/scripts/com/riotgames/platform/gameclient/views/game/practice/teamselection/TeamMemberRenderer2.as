package com.riotgames.platform.gameclient.views.game.practice.teamselection
{
   import blix.action.IAction;
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.buddyImages.BuddyImages;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.domain.PresenceStatusData;
   import com.riotgames.platform.gameclient.chat.renderer.BuddyTooltip;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.components.comboBox.SoundComboBox;
   import com.riotgames.platform.gameclient.components.list.BotChampionList;
   import com.riotgames.platform.gameclient.components.summoner.SummonerIcon;
   import com.riotgames.platform.gameclient.components.summoner.SummonerQuickViewData;
   import com.riotgames.platform.gameclient.domain.BotParticipant;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import com.riotgames.platform.gameclient.domain.PlayerParticipant;
   import com.riotgames.platform.gameclient.domain.game.ParticipantChampionSelection;
   import com.riotgames.platform.gameclient.domain.game.practice.GameTeam;
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipant;
   import com.riotgames.platform.gameclient.views.ViewMediator;
   import com.riotgames.platform.gameclient.views.game.common.ChampionImages;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.game.action.BanPlayerFromPracticeGameAction;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.game.controllers.TeamSelectionController;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.game.controllers.practice.TeamSelectionSlot;
   import com.riotgames.pvpnet.invite.IInviteController;
   import com.riotgames.pvpnet.invite.IInviteProvider;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.alerter.AlerterProviderProxy;
   import com.riotgames.pvpnet.system.alerter.IAlerterProvider;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.util.logging.getLogger;
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
   import mx.containers.HBox;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.controls.Menu;
   import mx.controls.Text;
   import mx.core.ClassFactory;
   import mx.core.IToolTip;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.ListEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.ToolTipEvent;
   import mx.logging.ILogger;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.styles.*;
   import org.igniterealtime.xiff.core.UnescapedJID;
   
   use namespace mx_internal;
   
   public class TeamMemberRenderer2 extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static const STATE_BLUE_TEAM:String = GameTeam.TEAM_BLUE;
      
      public static const STATE_PURPLE_TEAM:String = GameTeam.TEAM_PURPLE;
      
      private static const MAX_SLOT_ORDINAL:int = 4;
      
      public var _TeamMemberRenderer2_Image2:Image;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":Image,
               "id":"_TeamMemberRenderer2_Image1",
               "stylesFactory":function():void
               {
                  this.right = "0";
                  this.bottom = "0";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "x":0,
                     "y":0,
                     "maintainAspectRatio":false,
                     "smoothBitmapContent":false,
                     "source":_embed_mxml________ClientAssets_imageEmbeds_teamSelection_customLobby_playerItemBackground_png_440232390
                  };
               }
            }),new UIComponentDescriptor({
               "type":Image,
               "id":"_TeamMemberRenderer2_Image2",
               "stylesFactory":function():void
               {
                  this.horizontalCenter = "0";
                  this.bottom = "0";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "maintainAspectRatio":false,
                     "smoothBitmapContent":false,
                     "source":_embed_mxml________ClientAssets_imageEmbeds_teamSelection_separator_centered_blue_png_359335774
                  };
               }
            }),new UIComponentDescriptor({
               "type":Canvas,
               "id":"_TeamMemberRenderer2_Canvas2",
               "events":{
                  "toolTipCreate":"___TeamMemberRenderer2_Canvas2_toolTipCreate",
                  "toolTipHide":"___TeamMemberRenderer2_Canvas2_toolTipHide",
                  "toolTipShow":"___TeamMemberRenderer2_Canvas2_toolTipShow"
               },
               "stylesFactory":function():void
               {
                  this.left = "8";
                  this.verticalCenter = "0";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "width":48,
                     "height":48,
                     "toolTip":"unused",
                     "horizontalScrollPolicy":"off",
                     "verticalScrollPolicy":"off",
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":SummonerIcon,
                        "id":"_TeamMemberRenderer2_SummonerIcon1",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "width":48,
                              "height":48
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Canvas,
                        "id":"_TeamMemberRenderer2_Canvas3",
                        "stylesFactory":function():void
                        {
                           this.bottom = "-5";
                           this.right = "-5";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "width":26,
                              "height":22,
                              "styleName":"teamMemberLevelInset",
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":Label,
                                 "id":"_TeamMemberRenderer2_Label1",
                                 "stylesFactory":function():void
                                 {
                                    this.right = "5";
                                    this.left = "0";
                                    this.textAlign = "center";
                                    this.verticalCenter = "-2";
                                 },
                                 "propertiesFactory":function():Object
                                 {
                                    return {"styleName":"teamMemberLevelInsetLabel"};
                                 }
                              })]
                           };
                        }
                     })]
                  };
               }
            }),new UIComponentDescriptor({
               "type":Canvas,
               "id":"_TeamMemberRenderer2_Canvas4",
               "stylesFactory":function():void
               {
                  this.top = "0";
                  this.left = "0";
                  this.right = "0";
                  this.bottom = "0";
               },
               "propertiesFactory":function():Object
               {
                  return {"childDescriptors":[new UIComponentDescriptor({
                     "type":Image,
                     "id":"gameOwner_img",
                     "stylesFactory":function():void
                     {
                        this.top = "6";
                        this.left = "64";
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "height":26,
                           "width":26
                        };
                     }
                  }),new UIComponentDescriptor({
                     "type":Label,
                     "id":"playerName_txt",
                     "stylesFactory":function():void
                     {
                        this.right = "50";
                        this.top = "6";
                     },
                     "propertiesFactory":function():Object
                     {
                        return {"styleName":"teamMemberName"};
                     }
                  }),new UIComponentDescriptor({
                     "type":HBox,
                     "id":"optionsButtons",
                     "stylesFactory":function():void
                     {
                        this.left = "64";
                        this.bottom = "5";
                        this.horizontalGap = 2;
                     },
                     "propertiesFactory":function():Object
                     {
                        return {"childDescriptors":[new UIComponentDescriptor({
                           "type":SoundEffectButton,
                           "id":"kickBan_btn",
                           "events":{
                              "click":"__kickBan_btn_click",
                              "addedToStage":"__kickBan_btn_addedToStage"
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "x":0,
                                 "height":26,
                                 "width":26,
                                 "styleName":"removeButton",
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
                           "type":SoundEffectButton,
                           "id":"delegateInvitePowerBtn",
                           "events":{
                              "change":"__delegateInvitePowerBtn_change",
                              "addedToStage":"__delegateInvitePowerBtn_addedToStage"
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "height":26,
                                 "width":26,
                                 "toggle":true,
                                 "styleName":"delegateInvitePower"
                              };
                           }
                        })]};
                     }
                  }),new UIComponentDescriptor({
                     "type":Text,
                     "id":"participantStatsText",
                     "stylesFactory":function():void
                     {
                        this.right = "5";
                        this.verticalCenter = "0";
                        this.textAlign = "right";
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "width":300,
                           "styleName":"practiceGameStats",
                           "selectable":false
                        };
                     }
                  })]};
               }
            }),new UIComponentDescriptor({
               "type":Canvas,
               "id":"_TeamMemberRenderer2_Canvas5",
               "stylesFactory":function():void
               {
                  this.top = "0";
                  this.left = "0";
                  this.right = "0";
                  this.bottom = "0";
               },
               "propertiesFactory":function():Object
               {
                  return {"childDescriptors":[new UIComponentDescriptor({
                     "type":SoundEffectButton,
                     "id":"takeSlot_btn",
                     "events":{"click":"__takeSlot_btn_click"},
                     "stylesFactory":function():void
                     {
                        this.horizontalCenter = "0";
                        this.verticalCenter = "0";
                     },
                     "propertiesFactory":function():Object
                     {
                        return {"styleName":"longButtonBlue"};
                     }
                  }),new UIComponentDescriptor({
                     "type":SoundEffectButton,
                     "id":"addBot_btn",
                     "events":{"click":"__addBot_btn_click"},
                     "stylesFactory":function():void
                     {
                        this.right = "5";
                        this.verticalCenter = "0";
                     },
                     "propertiesFactory":function():Object
                     {
                        return {"styleName":"s1FormButton"};
                     }
                  })]};
               }
            }),new UIComponentDescriptor({
               "type":Canvas,
               "id":"_TeamMemberRenderer2_Canvas6",
               "stylesFactory":function():void
               {
                  this.top = "0";
                  this.left = "0";
                  this.right = "0";
                  this.bottom = "0";
               },
               "propertiesFactory":function():Object
               {
                  return {"childDescriptors":[new UIComponentDescriptor({
                     "type":SoundComboBox,
                     "id":"botChampions_cb",
                     "events":{
                        "change":"__botChampions_cb_change",
                        "click":"__botChampions_cb_click"
                     },
                     "stylesFactory":function():void
                     {
                        this.top = "21";
                        this.left = "80";
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "styleName":"botSelectComboBox",
                           "width":170,
                           "itemRenderer":_TeamMemberRenderer2_ClassFactory1_c(),
                           "dropdownFactory":_TeamMemberRenderer2_ClassFactory2_c()
                        };
                     }
                  }),new UIComponentDescriptor({
                     "type":SoundComboBox,
                     "id":"botDifficulty_cb",
                     "events":{"change":"__botDifficulty_cb_change"},
                     "stylesFactory":function():void
                     {
                        this.left = "272";
                        this.top = "21";
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "styleName":"botSelectComboBox",
                           "width":140
                        };
                     }
                  }),new UIComponentDescriptor({
                     "type":SoundEffectButton,
                     "events":{"click":"___TeamMemberRenderer2_SoundEffectButton7_click"},
                     "stylesFactory":function():void
                     {
                        this.right = "5";
                        this.verticalCenter = "0";
                     },
                     "propertiesFactory":function():Object
                     {
                        return {"styleName":"blueCloseButton"};
                     }
                  })]};
               }
            })]};
         }
      });
      
      protected var _309226796participantStats:String;
      
      public var _TeamMemberRenderer2_Image1:Image;
      
      [Inject]
      public var lobbyController:ILobbyViewController;
      
      [Inject]
      public var masterGameController:MasterGameController;
      
      private var _1977174019addBot_btn:SoundEffectButton;
      
      private var _767422259participant:GameParticipant;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      private var _3533310slot:TeamSelectionSlot;
      
      private var _504079896summonerData:SummonerQuickViewData = null;
      
      private var _2120674566kickBan_btn:SoundEffectButton;
      
      public var session:Session = Session.instance;
      
      private var _1816216387playerName_txt:Label;
      
      [Inject]
      public var viewMediator:ViewMediator;
      
      public var _TeamMemberRenderer2_Canvas2:Canvas;
      
      public var _TeamMemberRenderer2_Canvas3:Canvas;
      
      public var _TeamMemberRenderer2_Canvas4:Canvas;
      
      public var _TeamMemberRenderer2_Canvas5:Canvas;
      
      public var _TeamMemberRenderer2_Canvas6:Canvas;
      
      protected var _100462653isBot:Boolean = false;
      
      protected var _2114729341isSpectatorSlot:Boolean = false;
      
      protected var _1385335883playerImageSource:Object;
      
      protected var _1923681872championSelections:ArrayCollection;
      
      protected var _2042256638isLastSlot:Boolean = false;
      
      public var alerter:IAlerterProvider = AlerterProviderProxy.instance;
      
      [Inject]
      public var chatController:ChatController;
      
      private var _1276666629presence:PresenceStatusData;
      
      private var _711327457viewProfile_btn:SoundEffectButton;
      
      private var _1144280868botDifficulty_cb:SoundComboBox;
      
      private var _inviteGroup:InviteGroup;
      
      private var _535120997gameOwner_img:Image;
      
      private var _1223095531canTakeSlot:Boolean = false;
      
      private var _2105164037botChampions_cb:SoundComboBox;
      
      private var _1831991510_canAddBuddy:Boolean = false;
      
      private var _embed_mxml________ClientAssets_imageEmbeds_teamSelection_customLobby_playerItemBackground_png_440232390:Class = TeamMemberRenderer2__embed_mxml________ClientAssets_imageEmbeds_teamSelection_customLobby_playerItemBackground_png_440232390;
      
      private var _1140099650takeSlot_btn:SoundEffectButton;
      
      public var _TeamMemberRenderer2_Label1:Label;
      
      private var _228658714_canDelegateInvitePower:Boolean = false;
      
      private var _1387238153_canKick:Boolean = false;
      
      mx_internal var _watchers:Array = [];
      
      private var logger:ILogger = getLogger(this);
      
      public var _TeamMemberRenderer2_SummonerIcon1:SummonerIcon;
      
      private var _1688880603delegateInvitePowerBtn:SoundEffectButton;
      
      private var _embed_mxml________ClientAssets_imageEmbeds_teamSelection_separator_centered_blue_png_359335774:Class = TeamMemberRenderer2__embed_mxml________ClientAssets_imageEmbeds_teamSelection_separator_centered_blue_png_359335774;
      
      [Inject]
      private var _843995307teamSelectionController:TeamSelectionController;
      
      private var _1349376141_canViewProfile:Boolean = false;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      private var _771993721participantStatsText:Text;
      
      protected var playerTooltip:Menu;
      
      private var _inviteController:IInviteController;
      
      mx_internal var _bindings:Array = [];
      
      private var _1815362813optionsButtons:HBox;
      
      private var _1736312644addFriend_btn:SoundEffectButton;
      
      public function TeamMemberRenderer2()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.addEventListener("initialize",this.___TeamMemberRenderer2_Canvas1_initialize);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         TeamMemberRenderer2._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get addBot_btn() : SoundEffectButton
      {
         return this._1977174019addBot_btn;
      }
      
      public function set addBot_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._1977174019addBot_btn;
         if(_loc2_ !== param1)
         {
            this._1977174019addBot_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"addBot_btn",_loc2_,param1));
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
      
      public function set optionsButtons(param1:HBox) : void
      {
         var _loc2_:Object = this._1815362813optionsButtons;
         if(_loc2_ !== param1)
         {
            this._1815362813optionsButtons = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"optionsButtons",_loc2_,param1));
         }
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
      
      [Bindable(event="propertyChange")]
      private function get summonerData() : SummonerQuickViewData
      {
         return this._504079896summonerData;
      }
      
      public function __delegateInvitePowerBtn_addedToStage(param1:Event) : void
      {
         this.refreshDelegatePower();
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
      
      [Bindable(event="propertyChange")]
      public function get delegateInvitePowerBtn() : SoundEffectButton
      {
         return this._1688880603delegateInvitePowerBtn;
      }
      
      private function _TeamMemberRenderer2_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Boolean
         {
            return participant != null;
         },function(param1:Boolean):void
         {
            _TeamMemberRenderer2_Image1.visible = param1;
         },"_TeamMemberRenderer2_Image1.visible");
         result[0] = binding;
         binding = new Binding(this,function():Boolean
         {
            return participant == null && !isLastSlot;
         },function(param1:Boolean):void
         {
            _TeamMemberRenderer2_Image2.visible = param1;
         },"_TeamMemberRenderer2_Image2.visible");
         result[1] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.participant != null;
         },function(param1:Boolean):void
         {
            _TeamMemberRenderer2_Canvas2.visible = param1;
         },"_TeamMemberRenderer2_Canvas2.visible");
         result[2] = binding;
         binding = new Binding(this,function():Object
         {
            return playerImageSource;
         },function(param1:Object):void
         {
            _TeamMemberRenderer2_SummonerIcon1.iconPath = param1;
         },"_TeamMemberRenderer2_SummonerIcon1.iconPath");
         result[3] = binding;
         binding = new Binding(this,function():Boolean
         {
            return summonerData.level > 0;
         },function(param1:Boolean):void
         {
            _TeamMemberRenderer2_Canvas3.visible = param1;
         },"_TeamMemberRenderer2_Canvas3.visible");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = summonerData.level;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _TeamMemberRenderer2_Label1.htmlText = param1;
         },"_TeamMemberRenderer2_Label1.htmlText");
         result[5] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.participant != null && (!isBot || !teamSelectionController.isOwner);
         },function(param1:Boolean):void
         {
            _TeamMemberRenderer2_Canvas4.visible = param1;
         },"_TeamMemberRenderer2_Canvas4.visible");
         result[6] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_selectionGameOwner");
         },function(param1:Object):void
         {
            gameOwner_img.source = param1;
         },"gameOwner_img.source");
         result[7] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ResourceManager.getInstance().getString("resources","practiceGame_teamMemberRenderer_tooltip_owner");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            gameOwner_img.toolTip = param1;
         },"gameOwner_img.toolTip");
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
         binding = new Binding(this,function():String
         {
            var _loc1_:* = gameOwner_img.visible ? gameOwner_img.x + gameOwner_img.width + 0 : 64;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            playerName_txt.setStyle("left",param1);
         },"playerName_txt.left");
         result[10] = binding;
         binding = new Binding(this,function():Boolean
         {
            return _canKick;
         },function(param1:Boolean):void
         {
            kickBan_btn.visible = param1;
         },"kickBan_btn.visible");
         result[11] = binding;
         binding = new Binding(this,function():Boolean
         {
            return _canKick;
         },function(param1:Boolean):void
         {
            kickBan_btn.includeInLayout = param1;
         },"kickBan_btn.includeInLayout");
         result[12] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ResourceManager.getInstance().getString("resources","practiceGame_teamMemberRenderer_tooltip_kick");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            kickBan_btn.toolTip = param1;
         },"kickBan_btn.toolTip");
         result[13] = binding;
         binding = new Binding(this,function():Boolean
         {
            return _canAddBuddy;
         },function(param1:Boolean):void
         {
            addFriend_btn.visible = param1;
         },"addFriend_btn.visible");
         result[14] = binding;
         binding = new Binding(this,function():Boolean
         {
            return _canAddBuddy;
         },function(param1:Boolean):void
         {
            addFriend_btn.includeInLayout = param1;
         },"addFriend_btn.includeInLayout");
         result[15] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ResourceManager.getInstance().getString("resources","practiceGame_teamMemberRenderer_tooltip_addFriend");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            addFriend_btn.toolTip = param1;
         },"addFriend_btn.toolTip");
         result[16] = binding;
         binding = new Binding(this,function():Boolean
         {
            return _canViewProfile;
         },function(param1:Boolean):void
         {
            viewProfile_btn.visible = param1;
         },"viewProfile_btn.visible");
         result[17] = binding;
         binding = new Binding(this,function():Boolean
         {
            return _canViewProfile;
         },function(param1:Boolean):void
         {
            viewProfile_btn.includeInLayout = param1;
         },"viewProfile_btn.includeInLayout");
         result[18] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("practiceGame_teamMemberRenderer_tooltip_viewProfile");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            viewProfile_btn.toolTip = param1;
         },"viewProfile_btn.toolTip");
         result[19] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("practiceGame_teamMemberRenderer_tooltip_delegateInvitePower");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            delegateInvitePowerBtn.toolTip = param1;
         },"delegateInvitePowerBtn.toolTip");
         result[20] = binding;
         binding = new Binding(this,function():Boolean
         {
            return _canDelegateInvitePower;
         },function(param1:Boolean):void
         {
            delegateInvitePowerBtn.visible = param1;
         },"delegateInvitePowerBtn.visible");
         result[21] = binding;
         binding = new Binding(this,function():Boolean
         {
            return _canDelegateInvitePower;
         },function(param1:Boolean):void
         {
            delegateInvitePowerBtn.includeInLayout = param1;
         },"delegateInvitePowerBtn.includeInLayout");
         result[22] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = participantStats;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            participantStatsText.htmlText = param1;
         },"participantStatsText.htmlText");
         result[23] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.participant == null;
         },function(param1:Boolean):void
         {
            _TeamMemberRenderer2_Canvas5.visible = param1;
         },"_TeamMemberRenderer2_Canvas5.visible");
         result[24] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("practiceGame_teamMemberRenderer_takeSlotLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            takeSlot_btn.label = param1;
         },"takeSlot_btn.label");
         result[25] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !teamSelectionController.isBusy;
         },function(param1:Boolean):void
         {
            takeSlot_btn.enabled = param1;
         },"takeSlot_btn.enabled");
         result[26] = binding;
         binding = new Binding(this,function():Boolean
         {
            return canTakeSlot;
         },function(param1:Boolean):void
         {
            takeSlot_btn.visible = param1;
         },"takeSlot_btn.visible");
         result[27] = binding;
         binding = new Binding(this,function():Boolean
         {
            return teamSelectionController.canAddBotsToGame;
         },function(param1:Boolean):void
         {
            addBot_btn.visible = param1;
         },"addBot_btn.visible");
         result[28] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("practiceGame_teamMemberRenderer_addBotLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            addBot_btn.label = param1;
         },"addBot_btn.label");
         result[29] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !teamSelectionController.isBusy;
         },function(param1:Boolean):void
         {
            addBot_btn.enabled = param1;
         },"addBot_btn.enabled");
         result[30] = binding;
         binding = new Binding(this,function():Boolean
         {
            return Boolean(this.teamSelectionController.isOwner) && isBot;
         },function(param1:Boolean):void
         {
            _TeamMemberRenderer2_Canvas6.visible = param1;
         },"_TeamMemberRenderer2_Canvas6.visible");
         result[31] = binding;
         binding = new Binding(this,function():Boolean
         {
            return true;
         },function(param1:Boolean):void
         {
            botChampions_cb.enabled = param1;
         },"botChampions_cb.enabled");
         result[32] = binding;
         binding = new Binding(this,function():Object
         {
            return championSelections;
         },function(param1:Object):void
         {
            botChampions_cb.dataProvider = param1;
         },"botChampions_cb.dataProvider");
         result[33] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_champion_prompt");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            botChampions_cb.prompt = param1;
         },"botChampions_cb.prompt");
         result[34] = binding;
         binding = new Binding(this,function():Boolean
         {
            return true;
         },function(param1:Boolean):void
         {
            botDifficulty_cb.enabled = param1;
         },"botDifficulty_cb.enabled");
         result[35] = binding;
         binding = new Binding(this,function():Object
         {
            return this.teamSelectionController.availableBotDifficulties;
         },function(param1:Object):void
         {
            botDifficulty_cb.dataProvider = param1;
         },"botDifficulty_cb.dataProvider");
         result[36] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_botDifficulty_prompt");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            botDifficulty_cb.prompt = param1;
         },"botDifficulty_cb.prompt");
         result[37] = binding;
         return result;
      }
      
      private function set canTakeSlot(param1:Boolean) : void
      {
         var _loc2_:Object = this._1223095531canTakeSlot;
         if(_loc2_ !== param1)
         {
            this._1223095531canTakeSlot = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"canTakeSlot",_loc2_,param1));
         }
      }
      
      public function __addBot_btn_click(param1:MouseEvent) : void
      {
         this.onAddBotClicked();
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
      protected function get isBot() : Boolean
      {
         return this._100462653isBot;
      }
      
      private function onAddBotClicked() : void
      {
         this.teamSelectionController.addDefaultBotToGame(this.slot.type,this.onServiceRequestError);
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
      
      protected function set participantStats(param1:String) : void
      {
         var _loc2_:Object = this._309226796participantStats;
         if(_loc2_ !== param1)
         {
            this._309226796participantStats = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"participantStats",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get takeSlot_btn() : SoundEffectButton
      {
         return this._1140099650takeSlot_btn;
      }
      
      private function getChampionSelectionIndex(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:ParticipantChampionSelection = null;
         if(this.championSelections)
         {
            _loc2_ = 0;
            while(_loc2_ < this.championSelections.length)
            {
               _loc3_ = this.championSelections[_loc2_] as ParticipantChampionSelection;
               if(_loc3_.champion.championId == param1)
               {
                  return _loc2_;
               }
               _loc2_++;
            }
         }
         return -1;
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
      
      public function __addFriend_btn_click(param1:MouseEvent) : void
      {
         this.onAddBuddyClicked();
      }
      
      public function ___TeamMemberRenderer2_Canvas2_toolTipCreate(param1:ToolTipEvent) : void
      {
         this.createBuddyTooltip(param1);
      }
      
      public function ___TeamMemberRenderer2_Canvas2_toolTipShow(param1:ToolTipEvent) : void
      {
         this.showBuddyTooltip(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get participantStatsText() : Text
      {
         return this._771993721participantStatsText;
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
      
      [Bindable(event="propertyChange")]
      public function get gameOwner_img() : Image
      {
         return this._535120997gameOwner_img;
      }
      
      [Bindable(event="propertyChange")]
      protected function get isSpectatorSlot() : Boolean
      {
         return this._2114729341isSpectatorSlot;
      }
      
      public function set takeSlot_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._1140099650takeSlot_btn;
         if(_loc2_ !== param1)
         {
            this._1140099650takeSlot_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"takeSlot_btn",_loc2_,param1));
         }
      }
      
      private function isBotsEnabled() : Boolean
      {
         return !this.teamSelectionController.isBusy;
      }
      
      public function __botDifficulty_cb_change(param1:ListEvent) : void
      {
         this.onBotSelectionChanged();
      }
      
      private function createOnlineTooltip() : IToolTip
      {
         var _loc1_:BuddyTooltip = new BuddyTooltip();
         _loc1_.chatController = this.chatController;
         _loc1_.setBuddyData(this.summonerData.summonerName,this.presence);
         return _loc1_;
      }
      
      private function fillFakeParticipant(param1:PresenceStatusData, param2:GameParticipant) : void
      {
         var _loc3_:SummonerQuickViewData = new SummonerQuickViewData();
         var _loc4_:PlayerParticipant = param2 as PlayerParticipant;
         this.presence = param1;
         if(Boolean(param1) && Boolean(_loc4_))
         {
            _loc3_.level = param1.level;
            _loc3_.rankedLosses = param1.rankedLosses;
            _loc3_.summonerId = _loc4_.summonerId;
            _loc3_.summonerName = _loc4_.summonerName;
            _loc3_.wins = param1.wins;
            _loc3_.odinWins = param1.odinWins;
            _loc3_.rankedQueueType = param1.rankedQueueName;
            _loc3_.rankedRating = param1.rankedRating;
            _loc3_.rankedWins = param1.rankedWins;
            _loc3_.iconSource = BuddyImages.getSummonerIconSafely(_loc4_.profileIconId);
            _loc3_.rankedLeagueName = param1.rankedLeagueName;
            _loc3_.rankedLeagueDivision = param1.rankedLeagueDivision;
            _loc3_.rankedLeagueTier = param1.rankedLeagueTier;
         }
         else
         {
            _loc3_.rankedQueueType = "";
            _loc3_.rankedRating = 0;
            _loc3_.rankedWins = 0;
            _loc3_.wins = 0;
            _loc3_.odinWins = 0;
            _loc3_.rankedLosses = 0;
            if(_loc4_)
            {
               _loc3_.iconSource = BuddyImages.getSummonerIconSafely(_loc4_.profileIconId);
               _loc3_.level = _loc4_.summonerLevel;
               _loc3_.summonerId = _loc4_.summonerId;
            }
            else
            {
               _loc3_.iconSource = null;
               _loc3_.level = 0;
               _loc3_.summonerId = 0;
            }
            if(param2)
            {
               _loc3_.summonerName = param2.summonerName;
            }
         }
         var _loc5_:BotParticipant = param2 as BotParticipant;
         if(_loc5_)
         {
            _loc3_.summonerName = RiotResourceLoader.getChampionResourceString("name",_loc5_.champion.skinName,"**" + _loc5_.champion.displayName);
            _loc3_.summonerName += " [" + _loc5_.botSkillLevelName + "]";
            _loc3_.iconSource = ChampionImages.getIconPath(_loc5_.champion.skinName);
            this.botChampions_cb.selectedIndex = this.getChampionSelectionIndex(_loc5_.champion.championId);
            this.botDifficulty_cb.selectedIndex = _loc5_.botSkillLevel;
            this.isBot = true;
         }
         this.summonerData = _loc3_;
         this.updateStatsText();
      }
      
      public function ___TeamMemberRenderer2_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      public function __kickBan_btn_addedToStage(param1:Event) : void
      {
         this.updateKickAvailability();
      }
      
      private function updateParticipant(param1:PropertyChangeEvent) : void
      {
         if(this.participant is PlayerParticipant)
         {
            if(param1.property == this.participant.summonerName)
            {
               this.fillFakeParticipant(PresenceStatusData(param1.newValue),PlayerParticipant(this.participant));
            }
         }
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
      
      [Bindable(event="propertyChange")]
      public function get playerName_txt() : Label
      {
         return this._1816216387playerName_txt;
      }
      
      private function hideBuddyTooltip(param1:ToolTipEvent) : void
      {
         BuddyTooltip.clearLastBuddyTooltip();
      }
      
      public function ___TeamMemberRenderer2_Canvas2_toolTipHide(param1:ToolTipEvent) : void
      {
         this.hideBuddyTooltip(param1);
      }
      
      private function _TeamMemberRenderer2_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.participant != null;
         _loc1_ = this.participant == null && !this.isLastSlot;
         _loc1_ = this.participant != null;
         _loc1_ = this.playerImageSource;
         _loc1_ = this.summonerData.level > 0;
         _loc1_ = this.summonerData.level;
         _loc1_ = this.participant != null && (!this.isBot || !this.teamSelectionController.isOwner);
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_selectionGameOwner");
         _loc1_ = ResourceManager.getInstance().getString("resources","practiceGame_teamMemberRenderer_tooltip_owner");
         _loc1_ = this.summonerData.summonerName;
         _loc1_ = this.gameOwner_img.visible ? this.gameOwner_img.x + this.gameOwner_img.width + 0 : 64;
         _loc1_ = this._canKick;
         _loc1_ = this._canKick;
         _loc1_ = ResourceManager.getInstance().getString("resources","practiceGame_teamMemberRenderer_tooltip_kick");
         _loc1_ = this._canAddBuddy;
         _loc1_ = this._canAddBuddy;
         _loc1_ = ResourceManager.getInstance().getString("resources","practiceGame_teamMemberRenderer_tooltip_addFriend");
         _loc1_ = this._canViewProfile;
         _loc1_ = this._canViewProfile;
         _loc1_ = RiotResourceLoader.getString("practiceGame_teamMemberRenderer_tooltip_viewProfile");
         _loc1_ = RiotResourceLoader.getString("practiceGame_teamMemberRenderer_tooltip_delegateInvitePower");
         _loc1_ = this._canDelegateInvitePower;
         _loc1_ = this._canDelegateInvitePower;
         _loc1_ = this.participantStats;
         _loc1_ = this.participant == null;
         _loc1_ = RiotResourceLoader.getString("practiceGame_teamMemberRenderer_takeSlotLabel");
         _loc1_ = !this.teamSelectionController.isBusy;
         _loc1_ = this.canTakeSlot;
         _loc1_ = this.teamSelectionController.canAddBotsToGame;
         _loc1_ = RiotResourceLoader.getString("practiceGame_teamMemberRenderer_addBotLabel");
         _loc1_ = !this.teamSelectionController.isBusy;
         _loc1_ = this.teamSelectionController.isOwner && this.isBot;
         _loc1_ = true;
         _loc1_ = this.championSelections;
         _loc1_ = resourceManager.getString("resources","practiceGame_champion_prompt");
         _loc1_ = true;
         _loc1_ = this.teamSelectionController.availableBotDifficulties;
         _loc1_ = resourceManager.getString("resources","practiceGame_botDifficulty_prompt");
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
         ClientConfig.instance.getLeagueServiceEnabledChanged().add(function(param1:Boolean, param2:Boolean):void
         {
            updateStatsText();
         });
      }
      
      public function __viewProfile_btn_click(param1:MouseEvent) : void
      {
         this.lobbyController.searchForSummoner(this.summonerData.summonerName,null);
      }
      
      public function ___TeamMemberRenderer2_SoundEffectButton7_click(param1:MouseEvent) : void
      {
         this.onKickBanButtonClicked(null);
      }
      
      [Bindable(event="propertyChange")]
      public function get botDifficulty_cb() : SoundComboBox
      {
         return this._1144280868botDifficulty_cb;
      }
      
      [Bindable(event="propertyChange")]
      private function get _canAddBuddy() : Boolean
      {
         return this._1831991510_canAddBuddy;
      }
      
      private function _TeamMemberRenderer2_ClassFactory2_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = BotChampionList;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get viewProfile_btn() : SoundEffectButton
      {
         return this._711327457viewProfile_btn;
      }
      
      private function updateIcon() : void
      {
         if(this.summonerData)
         {
            this.playerImageSource = this.summonerData.iconSource;
         }
         else
         {
            this.playerImageSource = null;
         }
      }
      
      private function set _canViewProfile(param1:Boolean) : void
      {
         var _loc2_:Object = this._1349376141_canViewProfile;
         if(_loc2_ !== param1)
         {
            this._1349376141_canViewProfile = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_canViewProfile",_loc2_,param1));
         }
      }
      
      protected function handleKickBanPlayer(param1:AlertAction) : void
      {
         if(param1.affirmativeResponse)
         {
            this.teamSelectionController.banPlayerFromGame(PlayerParticipant(this.participant),this.onServiceRequestError);
         }
      }
      
      public function set participantStatsText(param1:Text) : void
      {
         var _loc2_:Object = this._771993721participantStatsText;
         if(_loc2_ !== param1)
         {
            this._771993721participantStatsText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"participantStatsText",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _canKick() : Boolean
      {
         return this._1387238153_canKick;
      }
      
      [Bindable(event="propertyChange")]
      public function get botChampions_cb() : SoundComboBox
      {
         return this._2105164037botChampions_cb;
      }
      
      [Bindable(event="propertyChange")]
      protected function get isLastSlot() : Boolean
      {
         return this._2042256638isLastSlot;
      }
      
      [Bindable(event="propertyChange")]
      private function get presence() : PresenceStatusData
      {
         return this._1276666629presence;
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
      
      private function onBotSelectionChanged() : void
      {
         var _loc1_:int = int(this.botDifficulty_cb.selectedIndex);
         if(this.botDifficulty_cb.selectedIndex == -1)
         {
            _loc1_ = 0;
         }
         var _loc2_:ParticipantChampionSelection = this.botChampions_cb.selectedItem as ParticipantChampionSelection;
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:BotParticipant = this.participant as BotParticipant;
         if(_loc3_ != null)
         {
            this.teamSelectionController.removeAndAddBot(_loc3_,this.slot.type,_loc1_,_loc2_.champion,this.onBotSelectionError);
         }
      }
      
      protected function set isSpectatorSlot(param1:Boolean) : void
      {
         var _loc2_:Object = this._2114729341isSpectatorSlot;
         if(_loc2_ !== param1)
         {
            this._2114729341isSpectatorSlot = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isSpectatorSlot",_loc2_,param1));
         }
      }
      
      private function getInviteProvider() : void
      {
         ProviderLookup.getProvider(IInviteProvider,this.onInviteProvider);
      }
      
      [Bindable(event="propertyChange")]
      private function get canTakeSlot() : Boolean
      {
         return this._1223095531canTakeSlot;
      }
      
      private function _TeamMemberRenderer2_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = BotChampionRenderer;
         return _loc1_;
      }
      
      public function __delegateInvitePowerBtn_change(param1:Event) : void
      {
         this.onDelegateChanged();
      }
      
      public function __kickBan_btn_click(param1:MouseEvent) : void
      {
         this.onKickBanButtonClicked(param1);
      }
      
      public function __takeSlot_btn_click(param1:MouseEvent) : void
      {
         this.onTakeSlotClicked();
      }
      
      [Bindable(event="propertyChange")]
      protected function get participantStats() : String
      {
         return this._309226796participantStats;
      }
      
      private function setDelegatePower() : void
      {
         if(!this._inviteGroup)
         {
            this.getInviteProvider();
            return;
         }
         var _loc1_:ConfigurationModel = DynamicClientConfigManager.getConfiguration("GameInvites","ServiceEnabled",true,null);
         this._canDelegateInvitePower = _loc1_.getBoolean() && !this.isCurrentSummonerOwner() && !this.isCurrentSummonerMe() && this._inviteGroup && Boolean(this._inviteGroup.isOwner) && !this.isBot;
      }
      
      [Bindable(event="propertyChange")]
      private function get participant() : GameParticipant
      {
         return this._767422259participant;
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:PlayerParticipant = null;
         var _loc3_:String = null;
         super.data = param1;
         this.slot = param1 as TeamSelectionSlot;
         this.participant = this.slot.participant;
         this.isBot = false;
         if(this.slot)
         {
            this.isSpectatorSlot = this.slot.type == GameTeam.SPECTATOR;
            if(this.slot.type == GameTeam.TEAM_BLUE && Boolean(this.teamSelectionController))
            {
               this.championSelections = this.teamSelectionController.blueTeamChampionSelections;
            }
            else if(this.teamSelectionController)
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
         if(this.participant is PlayerParticipant)
         {
            _loc2_ = this.participant as PlayerParticipant;
            this.createPlayerParticipant(PlayerParticipant(this.participant));
            if(this.session.summoner.sumId == _loc2_.summonerId || Boolean(this.chatController.isSummonerBuddy(this.summonerData.summonerName)))
            {
               this._canAddBuddy = false;
            }
            else
            {
               this._canAddBuddy = true;
            }
         }
         else
         {
            this.fillFakeParticipant(null,this.participant);
            this._canAddBuddy = false;
         }
         this.gameOwner_img.visible = this.participant != null && Boolean(this.participant.isGameOwner);
         if(this.masterGameController.currentGame)
         {
            _loc3_ = this.masterGameController.currentGame.getTeamNameForSummoner(this.session.summoner.name);
            this.canTakeSlot = this.slot.type != _loc3_;
         }
         this.refreshDelegatePower();
         this.setViewProfile();
         this.updateKickAvailability();
         this.updateIcon();
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
      
      private function onTakeSlotClicked() : void
      {
         this.teamSelectionController.takeSlot(this.slot,this.onServiceRequestError,this.onServiceRequestError);
      }
      
      protected function refreshDelegatePower() : void
      {
         this.setDelegatePower();
         this.setHasDelegatedInvitePower();
      }
      
      protected function botChampions_cb_clickHandler(param1:MouseEvent) : void
      {
         if(this.stage)
         {
            this.stage.focus = this.botChampions_cb.dropdown;
         }
      }
      
      protected function set playerImageSource(param1:Object) : void
      {
         var _loc2_:Object = this._1385335883playerImageSource;
         if(_loc2_ !== param1)
         {
            this._1385335883playerImageSource = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerImageSource",_loc2_,param1));
         }
      }
      
      private function onBotSelectionError(param1:ServerError) : void
      {
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         var _loc3_:AlertAction = new AlertAction(_loc2_.getString("resources","GEN-0005"),_loc2_.getString("resources",param1.errorCode,param1.messageArguments));
         _loc3_.add();
      }
      
      public function __botChampions_cb_change(param1:ListEvent) : void
      {
         this.onBotSelectionChanged();
      }
      
      private function isCurrentSummonerOwner() : Boolean
      {
         return this._inviteGroup && this.summonerData && Boolean(this._inviteGroup.ownerParticipant) && this._inviteGroup.ownerParticipant.summonerId == this.summonerData.summonerId;
      }
      
      public function __botChampions_cb_click(param1:MouseEvent) : void
      {
         this.botChampions_cb_clickHandler(param1);
      }
      
      private function setHasDelegatedInvitePower() : void
      {
         var _loc1_:InviteParticipant = null;
         if(Boolean(this.summonerData) && Boolean(this._inviteGroup))
         {
            _loc1_ = this._inviteGroup.getParticipantBySummonerId(this.summonerData.summonerId);
            if(_loc1_)
            {
               this.delegateInvitePowerBtn.selected = _loc1_.hasDelegatedInvitePower;
            }
         }
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
      
      protected function kickBotFromGame(param1:BotParticipant) : void
      {
         this.teamSelectionController.kickBotFromGame(param1,this.onServiceRequestError);
      }
      
      private function setViewProfile() : void
      {
         this._canViewProfile = !this.isCurrentSummonerMe() && !this.isBot;
      }
      
      [Bindable(event="propertyChange")]
      private function get _canViewProfile() : Boolean
      {
         return this._1349376141_canViewProfile;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:TeamMemberRenderer2 = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._TeamMemberRenderer2_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_practice_teamselection_TeamMemberRenderer2WatcherSetupUtil");
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
      
      protected function onKickBanButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:IAction = null;
         if(this.participant is BotParticipant)
         {
            this.kickBotFromGame(this.participant as BotParticipant);
         }
         else
         {
            _loc2_ = new BanPlayerFromPracticeGameAction(this.participant as PlayerParticipant,this.masterGameController.currentGame.id,this._inviteController,ServiceProxy.instance.gameService);
            _loc2_.invoke();
         }
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
      
      private function updateKickAvailability() : void
      {
         this._canKick = !this.isCurrentSummonerOwner() && Boolean(this._inviteGroup) && Boolean(this._inviteGroup.isOwner);
      }
      
      private function set _canAddBuddy(param1:Boolean) : void
      {
         var _loc2_:Object = this._1831991510_canAddBuddy;
         if(_loc2_ !== param1)
         {
            this._1831991510_canAddBuddy = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_canAddBuddy",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      protected function get playerImageSource() : Object
      {
         return this._1385335883playerImageSource;
      }
      
      [Bindable(event="propertyChange")]
      protected function get championSelections() : ArrayCollection
      {
         return this._1923681872championSelections;
      }
      
      public function set botDifficulty_cb(param1:SoundComboBox) : void
      {
         var _loc2_:Object = this._1144280868botDifficulty_cb;
         if(_loc2_ !== param1)
         {
            this._1144280868botDifficulty_cb = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"botDifficulty_cb",_loc2_,param1));
         }
      }
      
      private function updateStatsText() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         this.participantStats = "";
         if(this.summonerData)
         {
            if(ClientConfig.instance.leagueServiceEnabled)
            {
               _loc1_ = Boolean(this.summonerData.rankedLeagueTier) && Boolean(this.summonerData.rankedLeagueDivision) && Boolean(this.summonerData.rankedLeagueName);
               _loc2_ = _loc1_ && (this.summonerData.rankedLeagueTier != "" && this.summonerData.rankedLeagueDivision != "" && this.summonerData.rankedLeagueName != "");
               _loc3_ = _loc1_ && _loc2_;
               if(_loc3_)
               {
                  _loc4_ = RiotResourceLoader.getString("leagues_rank_" + this.summonerData.rankedLeagueTier);
                  this.participantStats += "<font color=\'#ee9501\'>";
                  if(this.summonerData.rankedLeagueTier == "CHALLENGER")
                  {
                     this.participantStats += RiotResourceLoader.getString("leagues_rank_CHALLENGER_NODIV");
                  }
                  else
                  {
                     this.participantStats += RiotResourceLoader.getString("profile_devision_display","**profile_devision_display",[_loc4_,this.summonerData.rankedLeagueDivision]);
                     this.participantStats += "\n" + ServiceProxy.instance.leagueService.cache.parseLeagueName(this.summonerData.rankedLeagueName);
                  }
                  this.participantStats += "</font>\n";
               }
            }
            if(this.summonerData.rankedWins > 0)
            {
               this.participantStats += RiotResourceLoader.getString("customGame_RankedWins",null,[this.summonerData.rankedWins]);
            }
            else if(this.summonerData.wins > 0 || this.summonerData.odinWins > 0)
            {
               this.participantStats += RiotResourceLoader.getString("customGame_NormalWins",null,[this.summonerData.wins + this.summonerData.odinWins]);
            }
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
            this._inviteController.delegateInvitePower(_loc2_);
         }
         else
         {
            this._inviteController.revokeInvitePower(_loc2_);
         }
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
      
      private function set _canDelegateInvitePower(param1:Boolean) : void
      {
         var _loc2_:Object = this._228658714_canDelegateInvitePower;
         if(_loc2_ !== param1)
         {
            this._228658714_canDelegateInvitePower = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_canDelegateInvitePower",_loc2_,param1));
         }
      }
      
      private function onInviteProvider(param1:IInviteProvider) : void
      {
         this._inviteController = param1.getInviteController();
         this._inviteGroup = param1.getInviteGroup();
         this._inviteGroup.getIsOwnerChangedSignal().add(this.updateKickAvailability);
         this._inviteGroup.getIsOwnerChangedSignal().add(this.refreshDelegatePower);
         this.refreshDelegatePower();
         this.updateKickAvailability();
         this.setViewProfile();
      }
      
      private function isCurrentSummonerMe() : Boolean
      {
         return this._inviteGroup && this.summonerData && this._inviteGroup.mySummonerId > 0 && this._inviteGroup.mySummonerId == this.summonerData.summonerId;
      }
      
      private function onAddBuddyClicked() : void
      {
         this.chatController.addBuddy(this.summonerData.summonerName);
         this._canAddBuddy = false;
      }
      
      [Bindable(event="propertyChange")]
      private function get _canDelegateInvitePower() : Boolean
      {
         return this._228658714_canDelegateInvitePower;
      }
      
      private function set _canKick(param1:Boolean) : void
      {
         var _loc2_:Object = this._1387238153_canKick;
         if(_loc2_ !== param1)
         {
            this._1387238153_canKick = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_canKick",_loc2_,param1));
         }
      }
      
      private function createPlayerParticipant(param1:PlayerParticipant) : void
      {
         var _loc2_:PresenceStatusData = this.teamSelectionController.userDataMap[param1.summonerName];
         this.fillFakeParticipant(_loc2_,param1);
         if(_loc2_ == null)
         {
            this.teamSelectionController.addEventListener("presenceUpdated",this.updateParticipant,false,0,true);
         }
      }
      
      private function showBuddyTooltip(param1:ToolTipEvent) : void
      {
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
      
      public function set botChampions_cb(param1:SoundComboBox) : void
      {
         var _loc2_:Object = this._2105164037botChampions_cb;
         if(_loc2_ !== param1)
         {
            this._2105164037botChampions_cb = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"botChampions_cb",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get slot() : TeamSelectionSlot
      {
         return this._3533310slot;
      }
   }
}

