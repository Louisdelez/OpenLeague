package com.riotgames.platform.gameclient.controllers.game.views
{
   import blix.context.IContext;
   import com.riotgames.platform.common.provider.IRerollProvider;
   import com.riotgames.platform.common.provider.InventoryProviderProxy;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.common.utils.app.ApplicationUtil;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.controllers.game.GlowComponentController;
   import com.riotgames.platform.gameclient.controllers.game.GlowLocation;
   import com.riotgames.platform.gameclient.controllers.game.controllers.AdvancedToolTipManager;
   import com.riotgames.platform.gameclient.controllers.game.enums.MenuStates;
   import com.riotgames.platform.gameclient.controllers.game.event.ChampionSelectionEvent;
   import com.riotgames.platform.gameclient.controllers.game.event.ItemSelectEvent;
   import com.riotgames.platform.gameclient.controllers.game.event.MasterySelectionEvent;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.controllers.game.views.mutators.ChampionSelectionMutatorSupport;
   import com.riotgames.platform.gameclient.controllers.game.views.popup.PlayerProfileTooltip;
   import com.riotgames.platform.gameclient.controllers.game.views.voting.allteam.VoteItemFactory;
   import com.riotgames.platform.gameclient.controllers.game.views.voting.allteam.VotePlayerSelectionUtils;
   import com.riotgames.platform.gameclient.controllers.game.views.voting.allteam.VoteTracker;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import com.riotgames.platform.gameclient.domain.PlayerParticipant;
   import com.riotgames.platform.gameclient.domain.SpellBookDTO;
   import com.riotgames.platform.gameclient.domain.game.ChampionVoteInfo;
   import com.riotgames.platform.gameclient.domain.game.GameState;
   import com.riotgames.platform.gameclient.domain.game.GameType;
   import com.riotgames.platform.gameclient.domain.game.ParticipantChampionSelection;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfig;
   import com.riotgames.platform.masteries.objects.MasteryPageInfoSummary;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.alerter.AlertWaitAction;
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
   import mx.containers.ViewStack;
   import mx.containers.utilityClasses.ConstraintColumn;
   import mx.containers.utilityClasses.ConstraintRow;
   import mx.controls.Button;
   import mx.controls.ComboBox;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.controls.Menu;
   import mx.controls.Text;
   import mx.controls.TextInput;
   import mx.core.ClassFactory;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.DropdownEvent;
   import mx.events.FlexEvent;
   import mx.events.ListEvent;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.styles.*;
   
   public class ChampionSelectionView extends Canvas implements IChampionSelectionView, IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static const REROLL_BUTTON_ICON:Class = ChampionSelectionView_REROLL_BUTTON_ICON;
      
      public static const SUNSET_BG:Class = ChampionSelectionView_SUNSET_BG;
      
      protected static const DETAILS_DELAY:int = 400;
      
      public var _ChampionSelectionView_Text1:Text;
      
      public var _ChampionSelectionView_Text2:Text;
      
      private var _1498771382spellsMenu:cs_smallMenu;
      
      private var _1679765393featuredRowView:FeaturedRowView;
      
      private var _2029103300messageCenter:ChampionSelectMessageCenter;
      
      protected var selectedMasteryPageChanged:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object;
      
      private var _894196291charactersPage_c:ChampionGrid;
      
      private var championSelectionMutatorSupport:ChampionSelectionMutatorSupport;
      
      public var _ChampionSelectionView_SyncNotifier1:SyncNotifier;
      
      public var _ChampionSelectionView_SyncNotifier2:SyncNotifier;
      
      private var _455523767championSearchFilter:TextInput;
      
      public var _ChampionSelectionView_SoundEffectButton1:SoundEffectButton;
      
      private var _glowComponentController:GlowComponentController;
      
      private var _1050181115enemyTeam:ChampionSelectPlayerList;
      
      private var _1399514947matchDetails:MatchDetailsView;
      
      private var _1218371858lockInButtonLabel:String;
      
      private var _948491687colLeft:ConstraintColumn;
      
      private var _599482671lockInMenu:cs_mediumMenu;
      
      private var _655867780colRight:ConstraintColumn;
      
      private var _rootContext:IContext;
      
      private var _434478175championSummary_c:ChampionSummaryView;
      
      private var _773964069spellsSelection_c:SpellSelectionView;
      
      private var _1634913538embeddedChat:ChampionSelectChatWindow;
      
      private var _971507617quitTutorialButton:SoundEffectButton;
      
      protected var rollOverTimer:Timer;
      
      private var _1309663158chooseOptionsState:ViewStack;
      
      private var busyWaitAction:AlertWaitAction;
      
      private var _championSelectionModel:ChampionSelectionModel;
      
      private var voteTracker:VoteTracker;
      
      private var _1593324064masterySelecter:ComboBox;
      
      private var lockInButtonStyleName:String;
      
      private var _990909443runeSelecter:RunePageSelecter;
      
      private var alerter:IAlerterProvider;
      
      private var _1805069635bkgImage:Image;
      
      private var _462115240friendlyTeam:ChampionSelectPlayerList;
      
      private var _849584180masteriesMenu:cs_mediumMenu;
      
      private var _652366718rerollButton:Button;
      
      protected var _selectedMasteryPage:MasteryPageInfoSummary;
      
      private var _1032946214championSkinBrowser_c:ChampionSkinSelector;
      
      private var _chatController:ChatController;
      
      private var _277266178lockInButton:Button;
      
      private var _1386038354rowChat:ConstraintRow;
      
      private var rerollProvider:IRerollProvider;
      
      private var _999696181colMiddle:ConstraintColumn;
      
      private var _8648008mainMenu:cs_mainMenu;
      
      private var _1849727379teamTwoBans:BannedChampionsView;
      
      private var _1440278701teamOneBans:BannedChampionsView;
      
      private var _134469313rowContent:ConstraintRow;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array;
      
      private var _606211670tutorialCanvas:Canvas;
      
      private var championDetails:ParticipantChampionSelection;
      
      private var _1131509414progressBar:ChampionSelectProgressBar;
      
      private var logger:ILogger;
      
      private var _2120455012matchMapView:MatchMapView;
      
      private var masteryTooltip:DisplayObject;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object;
      
      private var playerTooltip:Menu;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array;
      
      private var _embed_mxml___________ClientAssets_imageEmbeds_backgrounds_alertFlat_jpg_2122266545:Class;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public function ChampionSelectionView()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":Image,
                  "id":"bkgImage",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "x":0,
                        "y":0,
                        "alpha":0.333
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":ChampionSelectMessageCenter,
                  "id":"messageCenter",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "width":790,
                        "x":240,
                        "y":31,
                        "mouseChildren":false,
                        "mouseEnabled":false
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":cs_mainMenu,
                  "id":"mainMenu",
                  "events":{"creationComplete":"__mainMenu_creationComplete"},
                  "propertiesFactory":function():Object
                  {
                     return {
                        "horizontalCenter":"colMiddle:0",
                        "top":"rowContent:85",
                        "bottom":"rowContent:100"
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":ViewStack,
                  "id":"chooseOptionsState",
                  "stylesFactory":function():void
                  {
                     this.bottom = "rowContent:120";
                     this.left = "colMiddle:5";
                     this.right = "colMiddle:5";
                     this.top = "rowContent:145";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "horizontalScrollPolicy":"off",
                        "selectedIndex":0,
                        "verticalScrollPolicy":"off",
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":ChampionGrid,
                           "id":"charactersPage_c",
                           "stylesFactory":function():void
                           {
                              this.left = "0";
                              this.top = "0";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "height":267,
                                 "horizontalScrollPolicy":"off",
                                 "verticalScrollPolicy":"off",
                                 "width":712,
                                 "cacheAsBitmap":true
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":ChampionSkinSelector,
                           "id":"championSkinBrowser_c",
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "percentHeight":100,
                                 "percentWidth":100,
                                 "x":0,
                                 "y":0
                              };
                           }
                        })]
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":TextInput,
                  "id":"championSearchFilter",
                  "events":{
                     "change":"__championSearchFilter_change",
                     "click":"__championSearchFilter_click"
                  },
                  "stylesFactory":function():void
                  {
                     this.right = "colMiddle:0";
                     this.top = "rowContent:92";
                     this.paddingTop = 4;
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "styleName":"standard",
                        "width":150
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Canvas,
                  "events":{"click":"___ChampionSelectionView_Canvas2_click"},
                  "stylesFactory":function():void
                  {
                     this.left = "colMiddle:8";
                     this.top = "rowContent:85";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "height":50,
                        "width":100,
                        "buttonMode":true,
                        "cacheAsBitmap":true,
                        "mouseEnabled":true,
                        "useHandCursor":true
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Canvas,
                  "events":{"click":"___ChampionSelectionView_Canvas3_click"},
                  "stylesFactory":function():void
                  {
                     this.left = "colMiddle:125";
                     this.top = "rowContent:85";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "height":50,
                        "width":100,
                        "buttonMode":true,
                        "cacheAsBitmap":true,
                        "mouseEnabled":true,
                        "useHandCursor":true
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":ChampionSelectProgressBar,
                  "id":"progressBar",
                  "stylesFactory":function():void
                  {
                     this.horizontalCenter = "colMiddle:0";
                     this.top = "3";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "mouseChildren":false,
                        "mouseEnabled":false
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":cs_mediumMenu,
                  "id":"masteriesMenu",
                  "events":{"creationComplete":"__masteriesMenu_creationComplete"},
                  "propertiesFactory":function():Object
                  {
                     return {
                        "bottom":"rowContent:5",
                        "horizontalCenter":"colMiddle:-230"
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":RunePageSelecter,
                  "id":"runeSelecter",
                  "stylesFactory":function():void
                  {
                     this.bottom = "rowContent:52";
                     this.left = "colMiddle:28";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"width":200};
                  }
               }),new UIComponentDescriptor({
                  "type":SyncNotifier,
                  "id":"_ChampionSelectionView_SyncNotifier1",
                  "stylesFactory":function():void
                  {
                     this.bottom = "rowContent:56";
                     this.left = "colMiddle:184";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "mouseChildren":false,
                        "mouseEnabled":false
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":ComboBox,
                  "id":"masterySelecter",
                  "events":{
                     "change":"__masterySelecter_change",
                     "close":"__masterySelecter_close",
                     "itemRollOver":"__masterySelecter_itemRollOver",
                     "rollOut":"__masterySelecter_rollOut",
                     "removedFromStage":"__masterySelecter_removedFromStage"
                  },
                  "stylesFactory":function():void
                  {
                     this.bottom = "rowContent:18";
                     this.left = "colMiddle:28";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "width":200,
                        "styleName":"runeSelectionComboBox",
                        "labelField":"pageName",
                        "rowCount":10,
                        "height":24
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":SyncNotifier,
                  "id":"_ChampionSelectionView_SyncNotifier2",
                  "stylesFactory":function():void
                  {
                     this.bottom = "rowContent:22";
                     this.left = "colMiddle:184";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "mouseChildren":false,
                        "mouseEnabled":false
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":SoundEffectButton,
                  "id":"_ChampionSelectionView_SoundEffectButton1",
                  "events":{"click":"___ChampionSelectionView_SoundEffectButton1_click"},
                  "stylesFactory":function():void
                  {
                     this.bottom = "rowContent:15";
                     this.left = "colMiddle:230";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"styleName":"editMasteriesButton"};
                  }
               }),new UIComponentDescriptor({
                  "type":cs_smallMenu,
                  "id":"spellsMenu",
                  "events":{"creationComplete":"__spellsMenu_creationComplete"},
                  "propertiesFactory":function():Object
                  {
                     return {
                        "bottom":"rowContent:5",
                        "horizontalCenter":"colMiddle:30"
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":SpellSelectionView,
                  "id":"spellsSelection_c",
                  "stylesFactory":function():void
                  {
                     this.bottom = "rowContent:5";
                     this.horizontalCenter = "colMiddle:-1";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "height":90,
                        "horizontalScrollPolicy":"off",
                        "verticalScrollPolicy":"off",
                        "width":175
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":cs_mediumMenu,
                  "id":"lockInMenu",
                  "events":{"creationComplete":"__lockInMenu_creationComplete"},
                  "propertiesFactory":function():Object
                  {
                     return {
                        "bottom":"rowContent:5",
                        "horizontalCenter":"colMiddle:230"
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Button,
                  "id":"lockInButton",
                  "events":{"click":"__lockInButton_click"},
                  "stylesFactory":function():void
                  {
                     this.bottom = "rowContent:24";
                     this.right = "colMiddle:38";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "enabled":false,
                        "styleName":"lockInButton",
                        "useHandCursor":true,
                        "buttonMode":true,
                        "visible":true
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Button,
                  "id":"rerollButton",
                  "events":{"click":"__rerollButton_click"},
                  "stylesFactory":function():void
                  {
                     this.bottom = "rowContent:24";
                     this.right = "colMiddle:38";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "styleName":"rerollButton",
                        "labelPlacement":"right",
                        "useHandCursor":true,
                        "buttonMode":true,
                        "visible":false
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":FeaturedRowView,
                  "id":"featuredRowView",
                  "stylesFactory":function():void
                  {
                     this.top = "rowChat:0";
                     this.left = "colMiddle:0";
                     this.right = "colMiddle:0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "height":96,
                        "visible":false,
                        "includeInLayout":false
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":MatchDetailsView,
                  "id":"matchDetails",
                  "stylesFactory":function():void
                  {
                     this.bottom = "3";
                     this.left = "colLeft:12";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "height":196,
                        "width":249
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":MatchMapView,
                  "id":"matchMapView",
                  "stylesFactory":function():void
                  {
                     this.bottom = "3";
                     this.right = "colRight:12";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "height":196,
                        "width":249
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":BannedChampionsView,
                  "id":"teamOneBans",
                  "stylesFactory":function():void
                  {
                     this.bottom = "3";
                     this.left = "colLeft:12";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "height":196,
                        "width":249,
                        "visible":false
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":BannedChampionsView,
                  "id":"teamTwoBans",
                  "stylesFactory":function():void
                  {
                     this.bottom = "3";
                     this.right = "colRight:12";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "height":196,
                        "width":249,
                        "visible":false
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":ChampionSelectChatWindow,
                  "id":"embeddedChat",
                  "stylesFactory":function():void
                  {
                     this.bottom = "3";
                     this.horizontalCenter = "colMiddle:0";
                     this.left = "colMiddle:0";
                     this.right = "colMiddle:0";
                     this.top = "rowChat:0";
                  }
               }),new UIComponentDescriptor({
                  "type":SoundEffectButton,
                  "id":"quitTutorialButton",
                  "events":{"click":"__quitTutorialButton_click"},
                  "stylesFactory":function():void
                  {
                     this.left = "colLeft:15";
                     this.right = "colLeft:11";
                     this.bottom = "5";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "height":32,
                        "styleName":"correctLargeButtonBlue",
                        "useHandCursor":true
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":ChampionSelectPlayerList,
                  "id":"friendlyTeam",
                  "stylesFactory":function():void
                  {
                     this.left = "colLeft:9";
                     this.top = "rowContent:0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"isSpectating":false};
                  }
               }),new UIComponentDescriptor({
                  "type":ChampionSelectPlayerList,
                  "id":"enemyTeam",
                  "stylesFactory":function():void
                  {
                     this.right = "colRight:5";
                     this.top = "rowContent:0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"isSpectating":false};
                  }
               }),new UIComponentDescriptor({
                  "type":ChampionSummaryView,
                  "id":"championSummary_c",
                  "stylesFactory":function():void
                  {
                     this.backgroundAlpha = 1;
                     this.borderStyle = "none";
                     this.bottom = "0";
                     this.left = "0";
                     this.right = "0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "height":199,
                        "styleName":"stoneTablet",
                        "visible":false
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Canvas,
                  "id":"tutorialCanvas",
                  "stylesFactory":function():void
                  {
                     this.backgroundAlpha = 1;
                     this.backgroundColor = 131586;
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "percentHeight":100,
                        "horizontalScrollPolicy":"off",
                        "verticalScrollPolicy":"off",
                        "percentWidth":100,
                        "x":0,
                        "y":0,
                        "cacheAsBitmap":true,
                        "visible":false,
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":Image,
                           "stylesFactory":function():void
                           {
                              this.horizontalCenter = "0";
                              this.verticalCenter = "0";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {"source":_embed_mxml___________ClientAssets_imageEmbeds_backgrounds_alertFlat_jpg_2122266545};
                           }
                        }),new UIComponentDescriptor({
                           "type":Text,
                           "id":"_ChampionSelectionView_Text1",
                           "stylesFactory":function():void
                           {
                              this.fontSize = 15;
                              this.horizontalCenter = "-125";
                              this.textAlign = "center";
                              this.verticalCenter = "-80";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {"styleName":"playGameText"};
                           }
                        }),new UIComponentDescriptor({
                           "type":Text,
                           "id":"_ChampionSelectionView_Text2",
                           "stylesFactory":function():void
                           {
                              this.fontSize = 16;
                              this.horizontalCenter = "0";
                              this.textAlign = "center";
                              this.verticalCenter = "0";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {"styleName":"playGameText"};
                           }
                        })]
                     };
                  }
               })]};
            }
         });
         this.championSelectionMutatorSupport = new ChampionSelectionMutatorSupport();
         this.logger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
         this._embed_mxml___________ClientAssets_imageEmbeds_backgrounds_alertFlat_jpg_2122266545 = ChampionSelectionView__embed_mxml___________ClientAssets_imageEmbeds_backgrounds_alertFlat_jpg_2122266545;
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
            this.backgroundAlpha = 1;
            this.backgroundColor = 0;
            this.left = "0";
            this.right = "0";
            this.bottom = "0";
            this.top = "0";
         };
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.cacheAsBitmap = true;
         this.constraintRows = [this._ChampionSelectionView_ConstraintRow1_i(),this._ChampionSelectionView_ConstraintRow2_i()];
         this.constraintColumns = [this._ChampionSelectionView_ConstraintColumn1_i(),this._ChampionSelectionView_ConstraintColumn2_i(),this._ChampionSelectionView_ConstraintColumn3_i()];
         this.addEventListener("creationComplete",this.___ChampionSelectionView_Canvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         ChampionSelectionView._watcherSetupUtil = param1;
      }
      
      public function __lockInButton_click(param1:MouseEvent) : void
      {
         this.lockInChoicesClicked();
      }
      
      public function set embeddedChat(param1:ChampionSelectChatWindow) : void
      {
         var _loc2_:Object = this._1634913538embeddedChat;
         if(_loc2_ !== param1)
         {
            this._1634913538embeddedChat = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"embeddedChat",_loc2_,param1));
         }
      }
      
      protected function hideChampionOverlay() : void
      {
         if(AdvancedToolTipManager.toolTipOpen)
         {
            AdvancedToolTipManager.destroyCurrentToolTip();
         }
      }
      
      public function set runeSelecter(param1:RunePageSelecter) : void
      {
         var _loc2_:Object = this._990909443runeSelecter;
         if(_loc2_ !== param1)
         {
            this._990909443runeSelecter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"runeSelecter",_loc2_,param1));
         }
      }
      
      public function set lockInButton(param1:Button) : void
      {
         var _loc2_:Object = this._277266178lockInButton;
         if(_loc2_ !== param1)
         {
            this._277266178lockInButton = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lockInButton",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get enemyTeam() : ChampionSelectPlayerList
      {
         return this._1050181115enemyTeam;
      }
      
      public function set enemyTeam(param1:ChampionSelectPlayerList) : void
      {
         var _loc2_:Object = this._1050181115enemyTeam;
         if(_loc2_ !== param1)
         {
            this._1050181115enemyTeam = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enemyTeam",_loc2_,param1));
         }
      }
      
      private function _ChampionSelectionView_ConstraintRow2_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.rowChat = _loc1_;
         _loc1_.height = 130;
         _loc1_.initialized(this,"rowChat");
         return _loc1_;
      }
      
      private function setLockInButtonVisuals() : void
      {
         var _loc1_:GameTypeConfig = null;
         if(this.championSelectionModel != null)
         {
            _loc1_ = this.championSelectionModel.gameTypeConfig;
            if(_loc1_ != null && Boolean(_loc1_.votePickGameTypeConfig))
            {
               this.lockInButtonLabel = RiotResourceLoader.getString("championSelection_vote_button");
               this.lockInButtonStyleName = "lockInVoteButton";
            }
            else
            {
               this.lockInButtonLabel = RiotResourceLoader.getString("championSelection_lockin_button");
               this.lockInButtonStyleName = "lockInButton";
            }
         }
      }
      
      private function _ChampionSelectionView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():ChampionSelectionModel
         {
            return this.championSelectionModel;
         },function(param1:ChampionSelectionModel):void
         {
            messageCenter.championSelectionModel = param1;
         },"messageCenter.championSelectionModel");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = championSelectionModel.mainMenuState;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            mainMenu.currentState = param1;
         },"mainMenu.currentState");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("championSelection_selectChampionLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            charactersPage_c.label = param1;
         },"charactersPage_c.label");
         result[2] = binding;
         binding = new Binding(this,function():ChampionSelectionModel
         {
            return championSelectionModel;
         },function(param1:ChampionSelectionModel):void
         {
            charactersPage_c.championSelectionModel = param1;
         },"charactersPage_c.championSelectionModel");
         result[3] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !championSelectionModel.championSelectionIsBusy;
         },function(param1:Boolean):void
         {
            charactersPage_c.mouseChildren = param1;
         },"charactersPage_c.mouseChildren");
         result[4] = binding;
         binding = new Binding(this,function():Boolean
         {
            return championSelectionModel.showChampionGrid;
         },function(param1:Boolean):void
         {
            championSearchFilter.visible = param1;
         },"championSearchFilter.visible");
         result[5] = binding;
         binding = new Binding(this,function():ChampionSelectionModel
         {
            return this.championSelectionModel;
         },function(param1:ChampionSelectionModel):void
         {
            progressBar.championSelectionModel = param1;
         },"progressBar.championSelectionModel");
         result[6] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.championSelectionModel.progressBarVisible;
         },function(param1:Boolean):void
         {
            progressBar.visible = param1;
         },"progressBar.visible");
         result[7] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = championSelectionModel.masteriesMenuState;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            masteriesMenu.currentState = param1;
         },"masteriesMenu.currentState");
         result[8] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.championSelectionModel.masteriesMenuState == MenuStates.SMALL_MENU_STATE_ACTIVE;
         },function(param1:Boolean):void
         {
            runeSelecter.enabled = param1;
         },"runeSelecter.enabled");
         result[9] = binding;
         binding = new Binding(this,function():SpellBookDTO
         {
            return this.championSelectionModel.runeBook;
         },function(param1:SpellBookDTO):void
         {
            runeSelecter.spellBook = param1;
         },"runeSelecter.spellBook");
         result[10] = binding;
         binding = new Binding(this,function():Boolean
         {
            return championSelectionModel.runePageSynced;
         },function(param1:Boolean):void
         {
            _ChampionSelectionView_SyncNotifier1.isSynced = param1;
         },"_ChampionSelectionView_SyncNotifier1.isSynced");
         result[11] = binding;
         binding = new Binding(this,function():Object
         {
            return championSelectionModel.masteryPages;
         },function(param1:Object):void
         {
            masterySelecter.dataProvider = param1;
         },"masterySelecter.dataProvider");
         result[12] = binding;
         binding = new Binding(this,function():Boolean
         {
            return championSelectionModel.masteriesSynced;
         },function(param1:Boolean):void
         {
            masterySelecter.enabled = param1;
         },"masterySelecter.enabled");
         result[13] = binding;
         binding = new Binding(this,function():Boolean
         {
            return championSelectionModel.masteriesSynced;
         },function(param1:Boolean):void
         {
            _ChampionSelectionView_SyncNotifier2.isSynced = param1;
         },"_ChampionSelectionView_SyncNotifier2.isSynced");
         result[14] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("championSelection_editMasteriesTooltip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ChampionSelectionView_SoundEffectButton1.toolTip = param1;
         },"_ChampionSelectionView_SoundEffectButton1.toolTip");
         result[15] = binding;
         binding = new Binding(this,function():Boolean
         {
            return championSelectionModel.masteriesSynced;
         },function(param1:Boolean):void
         {
            _ChampionSelectionView_SoundEffectButton1.enabled = param1;
         },"_ChampionSelectionView_SoundEffectButton1.enabled");
         result[16] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = championSelectionModel.spellsMenuState;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            spellsMenu.currentState = param1;
         },"spellsMenu.currentState");
         result[17] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.championSelectionModel.lockInState;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            lockInMenu.currentState = param1;
         },"lockInMenu.currentState");
         result[18] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = lockInButtonLabel;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            lockInButton.label = param1;
         },"lockInButton.label");
         result[19] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !championSelectionModel.championSelectionIsBusy;
         },function(param1:Boolean):void
         {
            lockInButton.mouseEnabled = param1;
         },"lockInButton.mouseEnabled");
         result[20] = binding;
         binding = new Binding(this,function():Class
         {
            return REROLL_BUTTON_ICON;
         },function(param1:Class):void
         {
            rerollButton.setStyle("icon",param1);
         },"rerollButton.icon");
         result[21] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !championSelectionModel.championSelectionIsBusy;
         },function(param1:Boolean):void
         {
            rerollButton.mouseEnabled = param1;
         },"rerollButton.mouseEnabled");
         result[22] = binding;
         binding = new Binding(this,function():ChatRoom
         {
            return championSelectionModel.chatRoom;
         },function(param1:ChatRoom):void
         {
            embeddedChat.chatRoom = param1;
         },"embeddedChat.chatRoom");
         result[23] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("championSelection_chat_title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            embeddedChat.chatTitle = param1;
         },"embeddedChat.chatTitle");
         result[24] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","championSelection_quitTutorial_button");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            quitTutorialButton.label = param1;
         },"quitTutorialButton.label");
         result[25] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.championSelectionModel.currentTeamName;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            friendlyTeam.teamColorName = param1;
         },"friendlyTeam.teamColorName");
         result[26] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.championSelectionModel.friendlyTeammatesVisible;
         },function(param1:Boolean):void
         {
            friendlyTeam.teamPlayersVisible = param1;
         },"friendlyTeam.teamPlayersVisible");
         result[27] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.championSelectionModel.enemyTeamName;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            enemyTeam.teamColorName = param1;
         },"enemyTeam.teamColorName");
         result[28] = binding;
         binding = new Binding(this,function():ArrayCollection
         {
            return this.championSelectionModel.enemyTeamSelections;
         },function(param1:ArrayCollection):void
         {
            enemyTeam.teamPlayers = param1;
         },"enemyTeam.teamPlayers");
         result[29] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.championSelectionModel.enemyTeamVisible;
         },function(param1:Boolean):void
         {
            enemyTeam.teamPlayersVisible = param1;
         },"enemyTeam.teamPlayersVisible");
         result[30] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("championSelection_tutorial_alertTitle");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ChampionSelectionView_Text1.text = param1;
         },"_ChampionSelectionView_Text1.text");
         result[31] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("championSelection_tutorial_alertMessage");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ChampionSelectionView_Text2.text = param1;
         },"_ChampionSelectionView_Text2.text");
         result[32] = binding;
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get runeSelecter() : RunePageSelecter
      {
         return this._990909443runeSelecter;
      }
      
      [Bindable(event="propertyChange")]
      public function get masterySelecter() : ComboBox
      {
         return this._1593324064masterySelecter;
      }
      
      private function updateFeaturedLayout() : void
      {
         if(this.championSelectionModel != null && this.championSelectionModel.gameTypeConfig != null && this.championSelectionModel.gameTypeConfig.id == GameTypeConfig.PICK_ID_ALL_TEAM_VOTE_PICK && this.featuredRowView != null)
         {
            if(this.voteTracker == null)
            {
               this.voteTracker = new VoteTracker(this._rootContext);
               this.featuredRowView.headerLabel = RiotResourceLoader.getString("champselect_votepanel_title",null);
               this.featuredRowView.featuredContentComponent = this.voteTracker;
               this.onFeaturedGameInfoUpdated();
            }
            this.setFeaturedView(true);
         }
         else
         {
            if(this.featuredRowView != null)
            {
               this.featuredRowView.clearFeaturedContentComponent();
            }
            this.voteTracker = null;
            this.setFeaturedView(false);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get championSkinBrowser_c() : ChampionSkinSelector
      {
         return this._1032946214championSkinBrowser_c;
      }
      
      public function set chatController(param1:ChatController) : void
      {
         if(param1 == this._chatController)
         {
            return;
         }
         this._chatController = param1;
         if(this.embeddedChat)
         {
            this.embeddedChat.chatController = param1;
         }
      }
      
      private function onSkinsTabClicked() : void
      {
         dispatchEvent(new ChampionSelectionEvent(ChampionSelectionEvent.SKINS_SELECTED));
      }
      
      private function showMasteriesTooltip(param1:ListEvent) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:MasteryPageInfoSummary = null;
         var _loc5_:Point = null;
         if(this.masteryTooltip)
         {
            this.hideMasteriesTooltip();
         }
         var _loc2_:MasteryPageInfoSummary = param1.itemRenderer.data as MasteryPageInfoSummary;
         if(_loc2_ != null)
         {
            _loc3_ = null;
            if(this.championSelectionModel != null)
            {
               for each(_loc4_ in this.championSelectionModel.masteryPages)
               {
                  if(_loc4_.pageID == _loc2_.pageID)
                  {
                     _loc3_ = _loc4_.pageTooltip;
                     break;
                  }
               }
            }
            if(_loc3_ != null)
            {
               this.masteryTooltip = _loc3_;
               _loc5_ = new Point(param1.itemRenderer.x + param1.itemRenderer.width + 5,param1.itemRenderer.y);
               _loc5_ = param1.itemRenderer.localToGlobal(_loc5_);
               this.masteryTooltip.x = _loc5_.x;
               this.masteryTooltip.y = _loc5_.y - this.masteryTooltip.height + 10 - param1.rowIndex * (param1.itemRenderer.height + 4);
               this.stage.addChild(this.masteryTooltip);
            }
         }
      }
      
      public function ___ChampionSelectionView_Canvas2_click(param1:MouseEvent) : void
      {
         this.onChampionsTabClicked();
      }
      
      protected function updateGameType() : void
      {
         this.setQuitButtonState();
         this.setGameState();
         this.setLockInButtonVisuals();
      }
      
      private function onMainMenuStateChanged(param1:Event) : void
      {
         this.updateTabState();
         this.updateChampionGridState();
      }
      
      private function onCurrentParticipantChanged(param1:Event) : void
      {
         this.updateChampionGridState();
      }
      
      private function onChampionTradeUpdated() : void
      {
         this.updateRerollButton();
      }
      
      public function set masterySelecter(param1:ComboBox) : void
      {
         var _loc2_:Object = this._1593324064masterySelecter;
         if(_loc2_ !== param1)
         {
            this._1593324064masterySelecter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"masterySelecter",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get masteriesMenu() : cs_mediumMenu
      {
         return this._849584180masteriesMenu;
      }
      
      private function set lockInButtonLabel(param1:String) : void
      {
         var _loc2_:Object = this._1218371858lockInButtonLabel;
         if(_loc2_ !== param1)
         {
            this._1218371858lockInButtonLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lockInButtonLabel",_loc2_,param1));
         }
      }
      
      public function set championSkinBrowser_c(param1:ChampionSkinSelector) : void
      {
         var _loc2_:Object = this._1032946214championSkinBrowser_c;
         if(_loc2_ !== param1)
         {
            this._1032946214championSkinBrowser_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championSkinBrowser_c",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get chooseOptionsState() : ViewStack
      {
         return this._1309663158chooseOptionsState;
      }
      
      [Bindable(event="propertyChange")]
      public function get rowChat() : ConstraintRow
      {
         return this._1386038354rowChat;
      }
      
      private function _ChampionSelectionView_ConstraintRow1_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.rowContent = _loc1_;
         _loc1_.height = 535;
         _loc1_.initialized(this,"rowContent");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get tutorialCanvas() : Canvas
      {
         return this._606211670tutorialCanvas;
      }
      
      [Bindable(event="propertyChange")]
      public function get spellsMenu() : cs_smallMenu
      {
         return this._1498771382spellsMenu;
      }
      
      [Bindable(event="propertyChange")]
      public function get quitTutorialButton() : SoundEffectButton
      {
         return this._971507617quitTutorialButton;
      }
      
      [Bindable(event="propertyChange")]
      public function get championSearchFilter() : TextInput
      {
         return this._455523767championSearchFilter;
      }
      
      protected function updateSelectedMasteryPage() : void
      {
         if(this.championSelectionModel)
         {
            this.selectedMasteryPage = this.championSelectionModel.selectedMasteryPage;
         }
         else
         {
            this.selectedMasteryPage = null;
         }
      }
      
      public function set lockInMenu(param1:cs_mediumMenu) : void
      {
         var _loc2_:Object = this._599482671lockInMenu;
         if(_loc2_ !== param1)
         {
            this._599482671lockInMenu = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lockInMenu",_loc2_,param1));
         }
      }
      
      protected function updateLockInButton(param1:Event) : void
      {
         if(!this.lockInButton)
         {
            return;
         }
         this.lockInButton.styleName = this.lockInButtonStyleName;
         if(Boolean(this.championSelectionModel && this.championSelectionModel.currentPlayerParticipant && this.championSelectionModel.currentPlayerSelection && this.championSelectionModel.currentPlayerSelection.champion != null && this.championSelectionModel.currentPlayerParticipant.pickMode == GameParticipant.PICK_MODE_ACTIVE && this.championSelectionModel.championSelectionState == GameState.CHAMPION_SELECTION) && Boolean(this.championSelectionModel.lockInState == MenuStates.SMALL_MENU_STATE_ACTIVE) && this.championSelectionModel.timeRemainingSeconds > 0)
         {
            this.lockInButton.enabled = true;
         }
         else
         {
            this.lockInButton.enabled = false;
            if(Boolean(this.championSelectionModel) && Boolean(this.championSelectionModel.championSelectionState == GameState.CHAMPION_SELECTION) && this.championSelectionModel.timeRemainingSeconds <= 0)
            {
            }
         }
      }
      
      public function __lockInMenu_creationComplete(param1:FlexEvent) : void
      {
         this.joinMenusCreated();
      }
      
      private function hideMasteriesTooltip() : void
      {
         if(this.masteryTooltip != null)
         {
            if(this.masteryTooltip.parent)
            {
               this.masteryTooltip.parent.removeChild(this.masteryTooltip);
            }
            this.masteryTooltip = null;
         }
      }
      
      public function set colMiddle(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._999696181colMiddle;
         if(_loc2_ !== param1)
         {
            this._999696181colMiddle = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"colMiddle",_loc2_,param1));
         }
      }
      
      private function getRerollText() : String
      {
         return RiotResourceLoader.getString("championSelection_rerollButtonText","RerollButtonText",[this.rerollProvider.getRerollCount().toString()]);
      }
      
      public function get rootContext() : IContext
      {
         return this._rootContext;
      }
      
      protected function displayChampionDetails(param1:TimerEvent = null) : void
      {
         if(this.rollOverTimer)
         {
            this.rollOverTimer.stop();
         }
         this.turnOnChampionDetails();
         this.showChampionOverlay(this.championDetails);
      }
      
      public function set messageCenter(param1:ChampionSelectMessageCenter) : void
      {
         var _loc2_:Object = this._2029103300messageCenter;
         if(_loc2_ !== param1)
         {
            this._2029103300messageCenter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"messageCenter",_loc2_,param1));
         }
      }
      
      protected function onRollOverChampion(param1:ItemSelectEvent) : void
      {
         var _loc2_:ParticipantChampionSelection = param1.data as ParticipantChampionSelection;
         var _loc3_:Champion = _loc2_.champion;
         if(!_loc3_.skinName || Boolean(_loc3_.isRandomChampion()) || Boolean(_loc3_.isWildCardChampion()))
         {
            return;
         }
         this.championDetails = _loc2_;
         if(!this.rollOverTimer)
         {
            this.rollOverTimer = new Timer(DETAILS_DELAY);
            this.rollOverTimer.addEventListener(TimerEvent.TIMER,this.displayChampionDetails,false,0,true);
         }
         this.rollOverTimer.reset();
         this.rollOverTimer.start();
      }
      
      protected function updateSpells(param1:Event = null) : void
      {
         if(this.spellsSelection_c)
         {
            this.spellsSelection_c.championSelectionModel = this.championSelectionModel;
            if(this.championSelectionModel)
            {
               this.spellsSelection_c.visible = this.championSelectionModel.spellsMenuState == MenuStates.SMALL_MENU_STATE_ACTIVE;
            }
            else
            {
               this.spellsSelection_c.visible = false;
            }
         }
      }
      
      public function set rowContent(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._134469313rowContent;
         if(_loc2_ !== param1)
         {
            this._134469313rowContent = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rowContent",_loc2_,param1));
         }
      }
      
      public function set masteriesMenu(param1:cs_mediumMenu) : void
      {
         var _loc2_:Object = this._849584180masteriesMenu;
         if(_loc2_ !== param1)
         {
            this._849584180masteriesMenu = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"masteriesMenu",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get colRight() : ConstraintColumn
      {
         return this._655867780colRight;
      }
      
      public function __championSearchFilter_change(param1:Event) : void
      {
         this.doChampionFilter();
      }
      
      internal function championSelectionIsBusyChanged(param1:Event = null) : void
      {
         var _loc2_:IResourceManager = null;
         if(Boolean(this.championSelectionModel) && Boolean(this.championSelectionModel.championSelectionIsBusy))
         {
            _loc2_ = ResourceManager.getInstance();
            if(this.busyWaitAction == null)
            {
               this.busyWaitAction = new AlertWaitAction(_loc2_.getString("resources","serverWait_retrievingDataMessage"),_loc2_.getString("resources","serverWait_loadingMessage"));
            }
            this.busyWaitAction.isModal = false;
            this.busyWaitAction.showDelay = 1500;
            this.busyWaitAction.add();
         }
         else if(this.busyWaitAction)
         {
            this.busyWaitAction.complete();
         }
      }
      
      public function __masterySelecter_change(param1:ListEvent) : void
      {
         this.onMasteryPageSelected(param1);
      }
      
      public function set spellsSelection_c(param1:SpellSelectionView) : void
      {
         var _loc2_:Object = this._773964069spellsSelection_c;
         if(_loc2_ !== param1)
         {
            this._773964069spellsSelection_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spellsSelection_c",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rerollButton() : Button
      {
         return this._652366718rerollButton;
      }
      
      public function __masterySelecter_rollOut(param1:MouseEvent) : void
      {
         this.hideMasteriesTooltip();
      }
      
      public function set chooseOptionsState(param1:ViewStack) : void
      {
         var _loc2_:Object = this._1309663158chooseOptionsState;
         if(_loc2_ !== param1)
         {
            this._1309663158chooseOptionsState = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chooseOptionsState",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get matchMapView() : MatchMapView
      {
         return this._2120455012matchMapView;
      }
      
      private function quitTutorialClicked() : void
      {
         if(this.championSearchFilter)
         {
            this.championSearchFilter.text = RiotResourceLoader.getString("championSelection_filterbox_label");
         }
         var _loc1_:AlertAction = new AlertAction(RiotResourceLoader.getString("championSelection_quitConfirmationTitle","Are you sure you want to quit this game?"),RiotResourceLoader.getString("championSelection_quitConfirmationMessage","Quit game?"));
         _loc1_.showNegative = true;
         _loc1_.setYesNoLabels();
         _loc1_.getCompleted().addOnce(this.onQuitClosed);
         _loc1_.add();
      }
      
      public function set spellsMenu(param1:cs_smallMenu) : void
      {
         var _loc2_:Object = this._1498771382spellsMenu;
         if(_loc2_ !== param1)
         {
            this._1498771382spellsMenu = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spellsMenu",_loc2_,param1));
         }
      }
      
      private function onCurrentTeamChanged(param1:Event) : void
      {
         this.updateCurrentTeam();
      }
      
      private function lockInChoicesClicked() : void
      {
         if(this.championSelectionModel.championSelectionIsBusy)
         {
            return;
         }
         if(this.championSearchFilter)
         {
            this.championSearchFilter.text = RiotResourceLoader.getString("championSelection_filterbox_label");
         }
         dispatchEvent(new ChampionSelectionEvent(ChampionSelectionEvent.LOCK_IN_CHOICES));
      }
      
      [Bindable(event="propertyChange")]
      public function get progressBar() : ChampionSelectProgressBar
      {
         return this._1131509414progressBar;
      }
      
      public function set rowChat(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._1386038354rowChat;
         if(_loc2_ !== param1)
         {
            this._1386038354rowChat = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rowChat",_loc2_,param1));
         }
      }
      
      private function doChampionFilter() : void
      {
         if(this.charactersPage_c)
         {
            this.charactersPage_c.filterText = this.championSearchFilter.text.toLowerCase();
         }
      }
      
      protected function updateBans() : void
      {
         if(!this.championSelectionModel)
         {
            return;
         }
         if(this.teamOneBans)
         {
            this.teamOneBans.bannedChamps = this.championSelectionModel.teamOneBans;
         }
         if(this.teamTwoBans)
         {
            this.teamTwoBans.bannedChamps = this.championSelectionModel.teamTwoBans;
         }
      }
      
      public function set tutorialCanvas(param1:Canvas) : void
      {
         var _loc2_:Object = this._606211670tutorialCanvas;
         if(_loc2_ !== param1)
         {
            this._606211670tutorialCanvas = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tutorialCanvas",_loc2_,param1));
         }
      }
      
      private function onSkinSelected(param1:ChampionSelectionEvent) : void
      {
         dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get mainMenu() : cs_mainMenu
      {
         return this._8648008mainMenu;
      }
      
      private function updateChampionGridState() : void
      {
         if(!this.charactersPage_c || !this.championSelectionModel)
         {
            return;
         }
         if(Boolean(this.championSelectionModel) && Boolean(this.championSelectionModel.currentPlayerParticipant) && this.championSelectionModel.currentPlayerParticipant.pickMode == GameParticipant.PICK_MODE_ACTIVE)
         {
            this.charactersPage_c.alpha = 1;
         }
         else
         {
            this.charactersPage_c.alpha = 0.7;
         }
      }
      
      public function __spellsMenu_creationComplete(param1:FlexEvent) : void
      {
         this.joinMenusCreated();
      }
      
      private function turnOnChampionDetails() : void
      {
         this.championSummary_c.visible = true;
         this.championSummary_c.champion = this.championDetails.champion;
      }
      
      public function set quitTutorialButton(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._971507617quitTutorialButton;
         if(_loc2_ !== param1)
         {
            this._971507617quitTutorialButton = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"quitTutorialButton",_loc2_,param1));
         }
      }
      
      public function set championSearchFilter(param1:TextInput) : void
      {
         var _loc2_:Object = this._455523767championSearchFilter;
         if(_loc2_ !== param1)
         {
            this._455523767championSearchFilter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championSearchFilter",_loc2_,param1));
         }
      }
      
      public function __masterySelecter_itemRollOver(param1:ListEvent) : void
      {
         this.showMasteriesTooltip(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get bkgImage() : Image
      {
         return this._1805069635bkgImage;
      }
      
      [Bindable(event="propertyChange")]
      public function get teamOneBans() : BannedChampionsView
      {
         return this._1440278701teamOneBans;
      }
      
      protected function setChampionSelectionModel() : void
      {
         if(this.championSelectionModel)
         {
            this.championSelectionModel.addEventListener(ChampionSelectionModel.ALLOW_CHAMPION_SEARCHING_CHANGED,this.updateTextSearch,false,0,true);
            this.championSelectionModel.addEventListener(ChampionSelectionModel.MAIN_MENU_STATE_CHANGE,this.updateTextSearch,false,0,true);
            this.championSelectionModel.addEventListener(ChampionSelectionModel.MAIN_MENU_STATE_CHANGE,this.onMainMenuStateChanged,false,0,true);
            this.championSelectionModel.addEventListener(ChampionSelectionModel.CURRENT_PICK_MODE_CHANGED,this.onMainMenuStateChanged,false,0,true);
            this.championSelectionModel.addEventListener(ChampionSelectionModel.CHAMPION_SELECTION_STATE_CHANGED,this.updateGameState,false,0,true);
            this.championSelectionModel.addEventListener(ChampionSelectionModel.CURRENT_PLAYER_PARTICIPANT_CHANGED,this.updateLockInButton,false,0,true);
            this.championSelectionModel.addEventListener(ChampionSelectionModel.TIME_REMAINING_SECONDS_CHANGED,this.updateLockInButton,false,0,true);
            this.championSelectionModel.addEventListener(ChampionSelectionModel.LOCK_IN_STATE_CHANGED,this.updateLockInButton,false,0,true);
            this.championSelectionModel.addEventListener(ChampionSelectionModel.SELECTED_CHAMPION_CHANGED,this.updateLockInButton,false,0,true);
            this.championSelectionModel.addEventListener(ChampionSelectionModel.MASTERIES_MENU_CHANGED,this.updateLockInButton,false,0,true);
            this.championSelectionModel.addEventListener(ChampionSelectionModel.CURRENT_TEAM_CHANGED,this.onCurrentTeamChanged,false,0,true);
            this.championSelectionModel.addEventListener(ChampionSelectionModel.SPELLS_MENU_STATE_CHANGED,this.updateSpells,false,0,true);
            this.championSelectionModel.addEventListener(ChampionSelectionModel.CHAMPION_SELECTION_IS_BUSY_CHANGED,this.championSelectionIsBusyChanged,false,0,true);
            this.championSelectionModel.addEventListener("selectedMasteryPageChanged",this.onMasterySelectorDataChange,false,0,true);
            this.championSelectionModel.championTradeUpdated.add(this.onChampionTradeUpdated);
            this.championSelectionModel.featuredGameInfoUpdated.add(this.onFeaturedGameInfoUpdated);
         }
         this.updateSpells();
         this.updateTabState();
         this.updateChampionGridState();
         this.updateGameType();
         this.updateMap();
         this.updateDetails();
         this.updateSkinSelector();
         this.updateBans();
         this.updateChat();
         this.updateCurrentTeam();
         this.updateEnemyTeam();
         this.updateSelectedMasteryPage();
         this.updateLockInButton(null);
         this.updateRerollButton();
         this.updateExtendedLayout();
         this.updateFeaturedLayout();
         this.applyMutatorSupport();
         this.championSelectionIsBusyChanged();
      }
      
      private function onRollOutSummonerName(param1:MouseEvent) : void
      {
         if(this.playerTooltip != null)
         {
            this.playerTooltip.hide();
            this.playerTooltip = null;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get matchDetails() : MatchDetailsView
      {
         return this._1399514947matchDetails;
      }
      
      private function _ChampionSelectionView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.championSelectionModel;
         _loc1_ = this.championSelectionModel.mainMenuState;
         _loc1_ = RiotResourceLoader.getString("championSelection_selectChampionLabel");
         _loc1_ = this.championSelectionModel;
         _loc1_ = !this.championSelectionModel.championSelectionIsBusy;
         _loc1_ = this.championSelectionModel.showChampionGrid;
         _loc1_ = this.championSelectionModel;
         _loc1_ = this.championSelectionModel.progressBarVisible;
         _loc1_ = this.championSelectionModel.masteriesMenuState;
         _loc1_ = this.championSelectionModel.masteriesMenuState == MenuStates.SMALL_MENU_STATE_ACTIVE;
         _loc1_ = this.championSelectionModel.runeBook;
         _loc1_ = this.championSelectionModel.runePageSynced;
         _loc1_ = this.championSelectionModel.masteryPages;
         _loc1_ = this.championSelectionModel.masteriesSynced;
         _loc1_ = this.championSelectionModel.masteriesSynced;
         _loc1_ = RiotResourceLoader.getString("championSelection_editMasteriesTooltip");
         _loc1_ = this.championSelectionModel.masteriesSynced;
         _loc1_ = this.championSelectionModel.spellsMenuState;
         _loc1_ = this.championSelectionModel.lockInState;
         _loc1_ = this.lockInButtonLabel;
         _loc1_ = !this.championSelectionModel.championSelectionIsBusy;
         _loc1_ = REROLL_BUTTON_ICON;
         _loc1_ = !this.championSelectionModel.championSelectionIsBusy;
         _loc1_ = this.championSelectionModel.chatRoom;
         _loc1_ = RiotResourceLoader.getString("championSelection_chat_title");
         _loc1_ = resourceManager.getString("resources","championSelection_quitTutorial_button");
         _loc1_ = this.championSelectionModel.currentTeamName;
         _loc1_ = this.championSelectionModel.friendlyTeammatesVisible;
         _loc1_ = this.championSelectionModel.enemyTeamName;
         _loc1_ = this.championSelectionModel.enemyTeamSelections;
         _loc1_ = this.championSelectionModel.enemyTeamVisible;
         _loc1_ = RiotResourceLoader.getString("championSelection_tutorial_alertTitle");
         _loc1_ = RiotResourceLoader.getString("championSelection_tutorial_alertMessage");
      }
      
      private function onMasterySelectorDataChange(param1:Event) : void
      {
         this.updateSelectedMasteryPage();
      }
      
      private function rerollClicked() : void
      {
         if(this.isRerollEnabled() && this.rerollProvider.getRerollCount() > 0 && !this.championSelectionModel.championSelectionIsBusy)
         {
            dispatchEvent(new ChampionSelectionEvent(ChampionSelectionEvent.REROLL_REQUESTED));
            this.rerollButton.enabled = false;
         }
      }
      
      private function onRollOutActionButton(param1:MouseEvent) : void
      {
      }
      
      private function _ChampionSelectionView_ConstraintColumn3_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.colRight = _loc1_;
         _loc1_.width = 270;
         _loc1_.initialized(this,"colRight");
         return _loc1_;
      }
      
      protected function updateTextSearch(param1:Event) : void
      {
         if(!this.championSearchFilter)
         {
            return;
         }
         if(Boolean(this.championSelectionModel && this.championSelectionModel.allowChampionSerching) && Boolean(this.championSelectionModel.mainMenuState == MenuStates.MAIN_MENU_STATE_CHAMPS_ACTIVE) || this.championSelectionModel.mainMenuState == MenuStates.MAIN_MENU_STATE_CHAMPS_INACTIVE)
         {
            this.championSearchFilter.visible = true;
         }
         else
         {
            this.championSearchFilter.visible = false;
         }
      }
      
      private function onTalentsClicked() : void
      {
         this.dispatchEvent(new MasterySelectionEvent(MasterySelectionEvent.OPEN_MASTERIES,null));
      }
      
      public function set rootContext(param1:IContext) : void
      {
         this._rootContext = param1;
      }
      
      private function isRerollEnabled() : Boolean
      {
         return this.championSelectionModel && this.championSelectionModel.allowReroll && Boolean(this.rerollProvider) && Boolean(this.rerollProvider.getRerollEnabled());
      }
      
      private function updateExtendedLayout() : void
      {
         var _loc1_:Boolean = this.championSelectionModel != null && Boolean(this.championSelectionModel.extendedTeamSizes);
         this.applyConditionalHeight(this.matchDetails,_loc1_,139,196);
         this.applyConditionalHeight(this.matchMapView,_loc1_,139,196);
         this.applyConditionalHeight(this.teamOneBans,_loc1_,139,196);
         this.applyConditionalHeight(this.teamTwoBans,_loc1_,139,196);
         if(this.matchDetails != null)
         {
            this.matchDetails.setStyle("left",_loc1_ ? undefined : "colLeft:12");
            this.matchDetails.setStyle("right",_loc1_ ? "colRight:12" : undefined);
         }
         if(this.matchMapView != null)
         {
            if(_loc1_)
            {
               this.matchMapView.gameMap = null;
            }
            this.matchMapView.setStyle("left",_loc1_ ? "colLeft:12" : undefined);
            this.matchMapView.setStyle("right",_loc1_ ? undefined : "colRight:12");
         }
         if(this.friendlyTeam != null)
         {
            this.friendlyTeam.setThinGap(_loc1_);
         }
         if(this.enemyTeam != null)
         {
            this.enemyTeam.setThinGap(_loc1_);
         }
      }
      
      protected function updateCurrentTeam() : void
      {
         if(Boolean(this.championSelectionModel) && Boolean(this.friendlyTeam))
         {
            this.friendlyTeam.teamPlayers = this.championSelectionModel.currentTeamSelections;
         }
         else if(this.friendlyTeam)
         {
            this.friendlyTeam.teamPlayers = null;
         }
      }
      
      protected function updateGameState(param1:Event) : void
      {
         this.updateLockInButton(param1);
         this.updateSkinSelector();
         this.applyMutatorSupport();
      }
      
      public function set colRight(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._655867780colRight;
         if(_loc2_ !== param1)
         {
            this._655867780colRight = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"colRight",_loc2_,param1));
         }
      }
      
      protected function showChampionOverlay(param1:ParticipantChampionSelection) : void
      {
         var _loc2_:ChampionTooltip = null;
         if(!AdvancedToolTipManager.toolTipOpen)
         {
            _loc2_ = new ChampionTooltip();
            _loc2_.data = param1;
            AdvancedToolTipManager.createCustomToolTip(1000 * ApplicationUtil.application.scaleX,117 * ApplicationUtil.application.scaleY,_loc2_);
         }
      }
      
      private function getRerollTooltip() : String
      {
         return RiotResourceLoader.getString("championSelection_rerollButtonTooltip","RerollButtonTooltip",[this.rerollProvider.getRerollProgress().toString(),this.rerollProvider.getMaxRerollProgress().toString()]);
      }
      
      private function onSpellsOver() : void
      {
         var _loc1_:Array = new Array();
         _loc1_ = _loc1_.concat([1,0,0,0,45]);
         _loc1_ = _loc1_.concat([0,1,0,0,45]);
         _loc1_ = _loc1_.concat([0,0,1,0,45]);
         _loc1_ = _loc1_.concat([0,0,0,1,0]);
         var _loc2_:ColorMatrixFilter = new ColorMatrixFilter(_loc1_);
         var _loc3_:Array = new Array();
         _loc3_.push(_loc2_);
         this.spellsMenu.filters = _loc3_;
      }
      
      private function onRerollProvider(param1:IRerollProvider) : void
      {
         this.rerollProvider = param1;
         this.updateRerollButton();
      }
      
      private function onChampionFilterClicked() : void
      {
         this.championSearchFilter.text = "";
         this.doChampionFilter();
      }
      
      public function set rerollButton(param1:Button) : void
      {
         var _loc2_:Object = this._652366718rerollButton;
         if(_loc2_ !== param1)
         {
            this._652366718rerollButton = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rerollButton",_loc2_,param1));
         }
      }
      
      private function onRollOverSummonerName(param1:MouseEvent) : void
      {
         this.showPlayerTooltip(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get embeddedChat() : ChampionSelectChatWindow
      {
         return this._1634913538embeddedChat;
      }
      
      private function _ChampionSelectionView_ConstraintColumn2_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.colMiddle = _loc1_;
         _loc1_.width = 724;
         _loc1_.initialized(this,"colMiddle");
         return _loc1_;
      }
      
      private function onRollOverActionButton(param1:MouseEvent) : void
      {
      }
      
      [Bindable(event="propertyChange")]
      private function get lockInButtonLabel() : String
      {
         return this._1218371858lockInButtonLabel;
      }
      
      public function __masterySelecter_removedFromStage(param1:Event) : void
      {
         this.hideMasteriesTooltip();
      }
      
      public function get chatController() : ChatController
      {
         return this._chatController;
      }
      
      public function set featuredRowView(param1:FeaturedRowView) : void
      {
         var _loc2_:Object = this._1679765393featuredRowView;
         if(_loc2_ !== param1)
         {
            this._1679765393featuredRowView = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"featuredRowView",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lockInButton() : Button
      {
         return this._277266178lockInButton;
      }
      
      [Bindable(event="propertyChange")]
      public function get spellsSelection_c() : SpellSelectionView
      {
         return this._773964069spellsSelection_c;
      }
      
      public function set teamTwoBans(param1:BannedChampionsView) : void
      {
         var _loc2_:Object = this._1849727379teamTwoBans;
         if(_loc2_ !== param1)
         {
            this._1849727379teamTwoBans = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamTwoBans",_loc2_,param1));
         }
      }
      
      private function onCreationComplete() : void
      {
         this.alerter = AlerterProviderProxy.instance;
         if(!this.rerollProvider)
         {
            ProviderLookup.getProvider(IRerollProvider,this.onRerollProvider);
         }
         if(this.glowComponentController)
         {
            this.glowComponentController.registerGlowTarget(GlowLocation.CHAMPION_SELECT_CHAMPIONS,this.mainMenu);
            this.glowComponentController.registerGlowTarget(GlowLocation.LOCK_IN_BUTTON,this.lockInButton);
            this.glowComponentController.registerGlowTarget(GlowLocation.CHAMPION_SELECT_CHAT,this.embeddedChat);
            this.glowComponentController.registerGlowTarget(GlowLocation.CHAMPION_SELECT_SPELLS,this.spellsMenu);
            this.glowComponentController.registerGlowTarget(GlowLocation.CHAMPION_SELECT_RUNESBOX,this.masteriesMenu);
            this.glowComponentController.registerGlowTarget(GlowLocation.CHAMPION_SELECT_RUNES,this.runeSelecter);
            this.glowComponentController.registerGlowTarget(GlowLocation.CHAMPION_SELECT_MASTERIES,this.masterySelecter);
         }
         this.updateSpells();
         this.updateGameType();
         this.updateMap();
         this.updateDetails();
         this.updateTabState();
         this.updateChampionGridState();
         this.updateSkinSelector();
         this.updateBans();
         this.updateChat();
         this.updateCurrentTeam();
         this.updateEnemyTeam();
         this.updateSelectedMasteryPage();
         this.updateRerollButton();
         this.updateExtendedLayout();
         this.updateFeaturedLayout();
         this.applyMutatorSupport();
         this.bkgImage.source = SUNSET_BG;
         if(this.championSearchFilter)
         {
            this.championSearchFilter.text = RiotResourceLoader.getString("championSelection_filterbox_label");
         }
         this.charactersPage_c.addEventListener(ItemSelectEvent.ROLL_OVER,this.onRollOverChampion);
         this.charactersPage_c.addEventListener(ItemSelectEvent.ROLL_OUT,this.onRollOutChampion);
         this.joinMenusCreated();
         this.mainMenuReady();
      }
      
      protected function updateDetails() : void
      {
         if(Boolean(this.matchDetails) && Boolean(this.championSelectionModel))
         {
            this.matchDetails.setGameProperties(this.championSelectionModel.currentGame,this.championSelectionModel.gameMap,this.championSelectionModel.gameTypeConfig);
         }
         else if(this.matchDetails)
         {
            this.matchDetails.setGameProperties(null,null,null);
         }
      }
      
      private function onRollOutChampion(param1:ItemSelectEvent) : void
      {
         if(this.rollOverTimer)
         {
            this.rollOverTimer.stop();
         }
         this.embeddedChat.visible = true;
         this.championSummary_c.visible = false;
         this.championSummary_c.champion = null;
         this.hideChampionOverlay();
      }
      
      protected function updateEnemyTeam() : void
      {
         if(Boolean(this.championSelectionModel) && Boolean(this.enemyTeam))
         {
            this.enemyTeam.teamPlayers = this.championSelectionModel.enemyTeamSelections;
         }
         else if(this.enemyTeam)
         {
            this.enemyTeam.teamPlayers = null;
         }
      }
      
      private function onChampionsTabClicked() : void
      {
         dispatchEvent(new ChampionSelectionEvent(ChampionSelectionEvent.CHAMPION_LIST_SELECTED));
      }
      
      [Bindable(event="propertyChange")]
      public function get lockInMenu() : cs_mediumMenu
      {
         return this._599482671lockInMenu;
      }
      
      public function set matchMapView(param1:MatchMapView) : void
      {
         var _loc2_:Object = this._2120455012matchMapView;
         if(_loc2_ !== param1)
         {
            this._2120455012matchMapView = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"matchMapView",_loc2_,param1));
         }
      }
      
      public function set championSummary_c(param1:ChampionSummaryView) : void
      {
         var _loc2_:Object = this._434478175championSummary_c;
         if(_loc2_ !== param1)
         {
            this._434478175championSummary_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championSummary_c",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get messageCenter() : ChampionSelectMessageCenter
      {
         return this._2029103300messageCenter;
      }
      
      [Bindable(event="propertyChange")]
      public function get rowContent() : ConstraintRow
      {
         return this._134469313rowContent;
      }
      
      public function __masterySelecter_close(param1:DropdownEvent) : void
      {
         this.hideMasteriesTooltip();
      }
      
      public function set progressBar(param1:ChampionSelectProgressBar) : void
      {
         var _loc2_:Object = this._1131509414progressBar;
         if(_loc2_ !== param1)
         {
            this._1131509414progressBar = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"progressBar",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get colMiddle() : ConstraintColumn
      {
         return this._999696181colMiddle;
      }
      
      public function set friendlyTeam(param1:ChampionSelectPlayerList) : void
      {
         var _loc2_:Object = this._462115240friendlyTeam;
         if(_loc2_ !== param1)
         {
            this._462115240friendlyTeam = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"friendlyTeam",_loc2_,param1));
         }
      }
      
      public function ___ChampionSelectionView_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      public function set colLeft(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._948491687colLeft;
         if(_loc2_ !== param1)
         {
            this._948491687colLeft = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"colLeft",_loc2_,param1));
         }
      }
      
      public function set glowComponentController(param1:GlowComponentController) : void
      {
         this._glowComponentController = param1;
      }
      
      private function _ChampionSelectionView_ConstraintColumn1_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.colLeft = _loc1_;
         _loc1_.width = 270;
         _loc1_.initialized(this,"colLeft");
         return _loc1_;
      }
      
      public function set teamOneBans(param1:BannedChampionsView) : void
      {
         var _loc2_:Object = this._1440278701teamOneBans;
         if(_loc2_ !== param1)
         {
            this._1440278701teamOneBans = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamOneBans",_loc2_,param1));
         }
      }
      
      private function applyMutatorSupport() : void
      {
         this.championSelectionMutatorSupport.mutateChampionSelectionView(this,this._rootContext,this.championSelectionModel);
      }
      
      public function ___ChampionSelectionView_SoundEffectButton1_click(param1:MouseEvent) : void
      {
         this.onTalentsClicked();
      }
      
      public function cleanupView() : void
      {
         this.glowComponentController.unregisterGlowTarget(GlowLocation.CHAMPION_SELECT_CHAMPIONS);
         this.glowComponentController.unregisterGlowTarget(GlowLocation.LOCK_IN_BUTTON);
         this.glowComponentController.unregisterGlowTarget(GlowLocation.CHAMPION_SELECT_CHAT);
         this.glowComponentController.unregisterGlowTarget(GlowLocation.CHAMPION_SELECT_SPELLS);
         this.glowComponentController.unregisterGlowTarget(GlowLocation.CHAMPION_SELECT_RUNESBOX);
         this.glowComponentController.unregisterGlowTarget(GlowLocation.CHAMPION_SELECT_RUNES);
         this.glowComponentController.unregisterGlowTarget(GlowLocation.CHAMPION_SELECT_MASTERIES);
         this.glowComponentController.unregisterGlowTarget(GlowLocation.CHAMPION_SELECT_TIMER);
         this.glowComponentController.unregisterGlowTarget(GlowLocation.CHAMPION_SELECT_TEAMMATE);
         this.hideChampionOverlay();
      }
      
      public function __rerollButton_click(param1:MouseEvent) : void
      {
         this.rerollClicked();
      }
      
      public function ___ChampionSelectionView_Canvas3_click(param1:MouseEvent) : void
      {
         this.onSkinsTabClicked();
      }
      
      private function setFeaturedView(param1:Boolean) : void
      {
         if(this.embeddedChat != null)
         {
            this.embeddedChat.setStyle("top",param1 ? "rowChat:" + 95 : "rowChat:" + 0);
         }
         if(this.championSearchFilter != null)
         {
            this.championSearchFilter.setStyle("top",param1 ? "rowContent:" + 85 : "rowContent:" + 92);
         }
         this.applyConditionalHeight(this.rowContent,param1,465,535);
         this.applyConditionalHeight(this.rowChat,param1,200,130);
         this.applyConditionalHeight(this.championSummary_c,param1,173,199);
         if(this.featuredRowView != null)
         {
            this.featuredRowView.visible = this.featuredRowView.includeInLayout = param1;
         }
      }
      
      public function set mainMenu(param1:cs_mainMenu) : void
      {
         var _loc2_:Object = this._8648008mainMenu;
         if(_loc2_ !== param1)
         {
            this._8648008mainMenu = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mainMenu",_loc2_,param1));
         }
      }
      
      protected function removeChampionSelectionModel() : void
      {
         if(!this.championSelectionModel)
         {
            return;
         }
         this.championSelectionModel.removeEventListener(ChampionSelectionModel.ALLOW_CHAMPION_SEARCHING_CHANGED,this.updateTextSearch);
         this.championSelectionModel.removeEventListener(ChampionSelectionModel.MAIN_MENU_STATE_CHANGE,this.updateTextSearch);
         this.championSelectionModel.removeEventListener(ChampionSelectionModel.MAIN_MENU_STATE_CHANGE,this.onMainMenuStateChanged);
         this.championSelectionModel.removeEventListener(ChampionSelectionModel.CURRENT_PICK_MODE_CHANGED,this.onMainMenuStateChanged);
         this.championSelectionModel.removeEventListener(ChampionSelectionModel.CHAMPION_SELECTION_STATE_CHANGED,this.updateGameState);
         this.championSelectionModel.removeEventListener(ChampionSelectionModel.CURRENT_PLAYER_PARTICIPANT_CHANGED,this.updateLockInButton);
         this.championSelectionModel.removeEventListener(ChampionSelectionModel.TIME_REMAINING_SECONDS_CHANGED,this.updateGameState);
         this.championSelectionModel.removeEventListener(ChampionSelectionModel.LOCK_IN_STATE_CHANGED,this.updateLockInButton);
         this.championSelectionModel.removeEventListener(ChampionSelectionModel.SELECTED_CHAMPION_CHANGED,this.updateLockInButton);
         this.championSelectionModel.removeEventListener(ChampionSelectionModel.MASTERIES_MENU_CHANGED,this.updateLockInButton);
         this.championSelectionModel.removeEventListener(ChampionSelectionModel.CURRENT_TEAM_CHANGED,this.onCurrentTeamChanged);
         this.championSelectionModel.removeEventListener(ChampionSelectionModel.SPELLS_MENU_STATE_CHANGED,this.updateSpells);
         this.championSelectionModel.removeEventListener(ChampionSelectionModel.CHAMPION_SELECTION_IS_BUSY_CHANGED,this.championSelectionIsBusyChanged);
         this.championSelectionModel.removeEventListener("selectedMasteryPageChanged",this.onMasterySelectorDataChange);
         this.championSelectionModel.championTradeUpdated.remove(this.onChampionTradeUpdated);
         this.championSelectionModel.featuredGameInfoUpdated.remove(this.onFeaturedGameInfoUpdated);
         this.updateSpells();
         this.updateMap();
         this.updateDetails();
         this.updateSkinSelector();
         this.updateBans();
         this.updateChat();
         this.updateLockInButton(null);
         this.updateRerollButton();
         this.updateCurrentTeam();
         this.updateEnemyTeam();
         this.updateSelectedMasteryPage();
         this.updateExtendedLayout();
         this.updateFeaturedLayout();
         this.applyMutatorSupport();
      }
      
      public function set bkgImage(param1:Image) : void
      {
         var _loc2_:Object = this._1805069635bkgImage;
         if(_loc2_ !== param1)
         {
            this._1805069635bkgImage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bkgImage",_loc2_,param1));
         }
      }
      
      protected function setGameState() : void
      {
         if(Boolean(this.championSelectionModel) && Boolean(this.championSelectionModel.gameTypeConfig) && Boolean(this.championSelectionModel.currentGame))
         {
            if(this.championSelectionModel.gameTypeConfig.pickMode == GameTypeConfig.PICK_MODE_DRAFT_MODE_SINGLE_PICK || this.championSelectionModel.gameTypeConfig.pickMode == GameTypeConfig.PICK_MODE_TOURNAMENT || this.championSelectionModel.gameTypeConfig.maxAllowableBans > 0 || Boolean(GameType.isRanked(this.championSelectionModel.currentGame.gameType)))
            {
               if(this.teamOneBans)
               {
                  this.teamOneBans.visible = true;
               }
               if(this.teamTwoBans)
               {
                  this.teamTwoBans.visible = true;
               }
               if(this.matchMapView)
               {
                  this.matchMapView.visible = false;
               }
               if(this.matchDetails)
               {
                  this.matchDetails.visible = false;
               }
            }
            else
            {
               if(this.teamOneBans)
               {
                  this.teamOneBans.visible = false;
               }
               if(this.teamTwoBans)
               {
                  this.teamTwoBans.visible = false;
               }
               if(this.matchMapView)
               {
                  this.matchMapView.visible = true;
               }
               if(this.matchDetails)
               {
                  this.matchDetails.visible = true;
               }
            }
         }
      }
      
      private function applyConditionalHeight(param1:Object, param2:Boolean, param3:int, param4:int) : void
      {
         if(param1 != null && param1.hasOwnProperty("height"))
         {
            param1.height = param2 ? param3 : param4;
         }
      }
      
      public function set charactersPage_c(param1:ChampionGrid) : void
      {
         var _loc2_:Object = this._894196291charactersPage_c;
         if(_loc2_ !== param1)
         {
            this._894196291charactersPage_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"charactersPage_c",_loc2_,param1));
         }
      }
      
      public function __quitTutorialButton_click(param1:MouseEvent) : void
      {
         this.quitTutorialClicked();
      }
      
      public function set matchDetails(param1:MatchDetailsView) : void
      {
         var _loc2_:Object = this._1399514947matchDetails;
         if(_loc2_ !== param1)
         {
            this._1399514947matchDetails = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"matchDetails",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get featuredRowView() : FeaturedRowView
      {
         return this._1679765393featuredRowView;
      }
      
      [Bindable(event="propertyChange")]
      public function get teamTwoBans() : BannedChampionsView
      {
         return this._1849727379teamTwoBans;
      }
      
      [Bindable(event="propertyChange")]
      public function set championSelectionModel(param1:ChampionSelectionModel) : void
      {
         var _loc2_:Object = this.championSelectionModel;
         if(_loc2_ !== param1)
         {
            this._1044583878championSelectionModel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championSelectionModel",_loc2_,param1));
         }
      }
      
      private function joinMenusCreated() : void
      {
         var _loc1_:TextFormat = null;
         if(Boolean(this.masteriesMenu) && Boolean(this.spellsMenu) && Boolean(this.lockInMenu))
         {
            this.spellsMenu.smallMenu_nameText.nameTxt.embedFonts = true;
            this.masteriesMenu.smallMenu_nameText.nameTxt.embedFonts = true;
            _loc1_ = this.spellsMenu.smallMenu_nameText.nameTxt.defaultTextFormat;
            _loc1_.font = "ApplicationFont2";
            if(Boolean(this.championSelectionModel) && this.championSelectionModel.locale == "zh_CN")
            {
               _loc1_.bold = false;
            }
            this.spellsMenu.smallMenu_nameText.nameTxt.defaultTextFormat = _loc1_;
            this.masteriesMenu.smallMenu_nameText.nameTxt.defaultTextFormat = _loc1_;
            this.spellsMenu.smallMenu_nameText.nameTxt.text = RiotResourceLoader.getString("championSelection_spellsLabel");
            this.lockInMenu.smallMenu_nameText.nameTxt.text = "";
            this.masteriesMenu.smallMenu_nameText.nameTxt.text = RiotResourceLoader.getString("championSelection_runesMasteriesLabel","Runes & Masteries");
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:ChampionSelectionView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._ChampionSelectionView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_controllers_game_views_ChampionSelectionViewWatcherSetupUtil");
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
      public function get championSummary_c() : ChampionSummaryView
      {
         return this._434478175championSummary_c;
      }
      
      [Bindable(event="propertyChange")]
      public function get colLeft() : ConstraintColumn
      {
         return this._948491687colLeft;
      }
      
      public function get glowComponentController() : GlowComponentController
      {
         return this._glowComponentController;
      }
      
      [Bindable(event="propertyChange")]
      public function get friendlyTeam() : ChampionSelectPlayerList
      {
         return this._462115240friendlyTeam;
      }
      
      [Bindable(event="propertyChange")]
      public function get charactersPage_c() : ChampionGrid
      {
         return this._894196291charactersPage_c;
      }
      
      protected function updateChat() : void
      {
         if(!this.championSelectionModel)
         {
            return;
         }
         if(this.embeddedChat)
         {
            this.embeddedChat.chatController = this.chatController;
         }
      }
      
      public function __masteriesMenu_creationComplete(param1:FlexEvent) : void
      {
         this.joinMenusCreated();
      }
      
      private function mainMenuReady() : void
      {
         this.mainMenu.mainMenu_nameText1.nameTxt.embedFonts = true;
         this.mainMenu.mainMenu_nameText2.nameTxt.embedFonts = true;
         var _loc1_:TextFormat = this.mainMenu.mainMenu_nameText1.nameTxt.defaultTextFormat;
         _loc1_.font = "ApplicationFont2";
         if(Boolean(this.championSelectionModel) && this.championSelectionModel.locale == "zh_CN")
         {
            _loc1_.bold = false;
         }
         this.mainMenu.mainMenu_nameText1.nameTxt.defaultTextFormat = _loc1_;
         this.mainMenu.mainMenu_nameText2.nameTxt.defaultTextFormat = _loc1_;
         this.mainMenu.mainMenu_nameText1.nameTxt.text = RiotResourceLoader.getString("summonerProfile_page_champions");
         this.mainMenu.mainMenu_nameText2.nameTxt.text = RiotResourceLoader.getString("championOverlay_skinPage_label");
      }
      
      public function get championSelectionModel() : ChampionSelectionModel
      {
         return this._championSelectionModel;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(Boolean(this.selectedMasteryPageChanged) && Boolean(this.masterySelecter) && Boolean(this.championSelectionModel))
         {
            this.masterySelecter.selectedItem = this.championSelectionModel.selectedMasteryPage;
            this.selectedMasteryPageChanged = false;
         }
      }
      
      protected function updateMap() : void
      {
         if(Boolean(this.matchMapView) && Boolean(this.championSelectionModel))
         {
            this.matchMapView.gameMap = this.championSelectionModel.gameMap;
         }
         else if(this.matchMapView)
         {
            this.matchMapView.gameMap = null;
         }
      }
      
      public function set selectedMasteryPage(param1:MasteryPageInfoSummary) : void
      {
         this._selectedMasteryPage = param1;
         this.selectedMasteryPageChanged = true;
         this.invalidateProperties();
      }
      
      private function onQuitClosed(param1:AlertAction) : void
      {
         if(param1.affirmativeResponse)
         {
            this.dispatchEvent(new ChampionSelectionEvent(ChampionSelectionEvent.QUIT_GAME));
         }
      }
      
      private function set _1044583878championSelectionModel(param1:ChampionSelectionModel) : void
      {
         if(this._championSelectionModel == param1)
         {
            return;
         }
         this.removeChampionSelectionModel();
         this._championSelectionModel = param1;
         this.setChampionSelectionModel();
      }
      
      private function onSpellsOut() : void
      {
         this.spellsMenu.filters = [];
      }
      
      private function updateTabState(param1:Event = null) : void
      {
         if(!this.championSelectionModel || !this.chooseOptionsState)
         {
            return;
         }
         if(!this.championSelectionModel && Boolean(this.chooseOptionsState))
         {
            this.chooseOptionsState.selectedChild = this.charactersPage_c;
            return;
         }
         if(this.championSelectionModel.mainMenuState == MenuStates.MAIN_MENU_STATE_SKINS_ACTIVE || this.championSelectionModel.mainMenuState == MenuStates.MAIN_MENU_STATE_SKINS_INACTIVE)
         {
            this.chooseOptionsState.selectedChild = this.championSkinBrowser_c;
            if(this.championSkinBrowser_c)
            {
               this.championSkinBrowser_c.addEventListener(ChampionSelectionEvent.SKIN_SELECTED,this.onSkinSelected);
            }
         }
         else
         {
            this.chooseOptionsState.selectedChild = this.charactersPage_c;
         }
      }
      
      private function onMasteryPageSelected(param1:ListEvent) : void
      {
         this.dispatchEvent(new MasterySelectionEvent(MasterySelectionEvent.PAGE_SELECTED,this.masterySelecter.selectedItem as MasteryPageInfoSummary));
      }
      
      public function updateRerollButton() : void
      {
         if(Boolean(this.rerollButton) && Boolean(this.lockInButton))
         {
            if(Boolean(this.isRerollEnabled()) && Boolean(this.rerollProvider) && Boolean(this.championSelectionModel))
            {
               this.rerollButton.label = this.getRerollText();
               this.rerollButton.toolTip = this.getRerollTooltip();
               this.rerollButton.enabled = this.rerollProvider.getRerollCount() > 0 && !this.championSelectionModel.championTradeIsActive;
               this.rerollButton.visible = true;
               this.lockInButton.visible = false;
            }
            else
            {
               this.rerollButton.visible = false;
               this.rerollButton.enabled = false;
               this.lockInButton.visible = true;
            }
         }
      }
      
      private function showPlayerTooltip(param1:MouseEvent) : void
      {
         var _loc6_:Point = null;
         var _loc7_:Number = NaN;
         var _loc2_:Label = param1.currentTarget as Label;
         var _loc3_:Number = parseInt(_loc2_.name);
         var _loc4_:String = _loc2_.text;
         var _loc5_:GameParticipant = this.championSelectionModel.currentPlayerParticipant;
         if(!(_loc5_ is PlayerParticipant))
         {
            return;
         }
         if(this.playerTooltip == null)
         {
            this.playerTooltip = Menu.createMenu(this,PlayerParticipant(_loc5_),false);
            this.playerTooltip.setStyle("styleName","playerTooltip");
            this.playerTooltip.itemRenderer = new ClassFactory(PlayerProfileTooltip);
            this.playerTooltip.selectable = false;
            this.playerTooltip.width = 300;
            this.playerTooltip.height = 100;
            _loc6_ = new Point(_loc2_.x,_loc2_.y + _loc2_.height);
            _loc6_ = this.localToGlobal(_loc6_);
            _loc7_ = DisplayObject(ApplicationUtil.application).width;
            this.playerTooltip.x = Math.min(_loc7_ - this.playerTooltip.width,_loc6_.x);
            this.playerTooltip.y = _loc6_.y;
         }
         this.playerTooltip.show();
      }
      
      private function onFeaturedGameInfoUpdated() : void
      {
         var _loc1_:Array = null;
         var _loc2_:ChampionVoteInfo = null;
         var _loc3_:int = 0;
         if(this.voteTracker != null)
         {
            _loc1_ = null;
            if(this.championSelectionModel.championSelectionState == GameState.CHAMPION_SELECTION)
            {
               _loc2_ = VotePlayerSelectionUtils.getChampionVoteInfo(this.championSelectionModel.currentPlayerSelection,this.championSelectionModel.championSelectionState,this.championSelectionModel.lockInState);
               _loc1_ = VoteItemFactory.createIntermediateVoteItems(InventoryProviderProxy.instance.getInventory().championIdMapping,_loc2_,this.championSelectionModel.featuredGameInfo);
            }
            else if(this.championSelectionModel.championSelectionState == GameState.POST_CHAMPION_SELECTION)
            {
               _loc3_ = int(VotePlayerSelectionUtils.getWinningChampionId(this.championSelectionModel.currentPlayerSelection,this.championSelectionModel.championSelectionState));
               _loc1_ = VoteItemFactory.createFinalVoteItems(_loc3_,this.voteTracker.getModel());
            }
            else if(GameState.isAfterChampionSelectionState(this.championSelectionModel.championSelectionState))
            {
               _loc1_ = this.voteTracker.getModel();
            }
            this.voteTracker.setModel(_loc1_);
         }
      }
      
      protected function setQuitButtonState() : void
      {
         if(this.quitTutorialButton)
         {
            if(Boolean(this.championSelectionModel) && (this.championSelectionModel.currentGame.gameType == GameType.TUTORIAL_GAME || this.championSelectionModel.currentGame.gameType == GameType.PRACTICE_GAME))
            {
               this.quitTutorialButton.visible = this.quitTutorialButton.includeInLayout = true;
            }
            else
            {
               this.quitTutorialButton.visible = this.quitTutorialButton.includeInLayout = false;
            }
         }
      }
      
      public function __championSearchFilter_click(param1:MouseEvent) : void
      {
         this.onChampionFilterClicked();
      }
      
      public function get selectedMasteryPage() : MasteryPageInfoSummary
      {
         return this._selectedMasteryPage;
      }
      
      protected function updateSkinSelector() : void
      {
         if(Boolean(this.championSkinBrowser_c) && Boolean(this.championSelectionModel))
         {
            this.championSkinBrowser_c.playerSelection = this.championSelectionModel.currentPlayerSelection;
            this.championSkinBrowser_c.championSelectionModel = this.championSelectionModel;
         }
      }
      
      public function __mainMenu_creationComplete(param1:FlexEvent) : void
      {
         this.mainMenuReady();
      }
   }
}

