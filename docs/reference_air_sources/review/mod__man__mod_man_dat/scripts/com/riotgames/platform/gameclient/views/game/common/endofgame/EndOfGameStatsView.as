package com.riotgames.platform.gameclient.views.game.common.endofgame
{
   import blix.assets.proxy.DisplayAdapter;
   import blix.assets.proxy.SpriteProxy;
   import blix.signals.ISignal;
   import com.adobe.effects.SaturationFade;
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.common.commands.ICommand;
   import com.riotgames.platform.common.components.controls.ToggleButtonBar;
   import com.riotgames.platform.common.provider.ChromeContextAlertProviderProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.Models.MaxViewableTeamSize;
   import com.riotgames.platform.gameclient.chat.IChatRoomView;
   import com.riotgames.platform.gameclient.chat.IChatViewProvider;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.gameclient.components.GradientTextField;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.configurations.ShareMatchHistoryConfig;
   import com.riotgames.platform.gameclient.contextAlert.AlertLocation;
   import com.riotgames.platform.gameclient.contextAlert.AlertParameters;
   import com.riotgames.platform.gameclient.domain.GameStatusLogicTable;
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.platform.gameclient.domain.PlayerStat;
   import com.riotgames.platform.gameclient.domain.RawStatType;
   import com.riotgames.platform.gameclient.domain.TeamSkinRentalDTO;
   import com.riotgames.platform.gameclient.domain.game.GameMode;
   import com.riotgames.platform.gameclient.domain.game.QueueType;
   import com.riotgames.platform.gameclient.domain.kudos.PendingKudos;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamStatus;
   import com.riotgames.platform.gameclient.domain.summoner.LevelUpInfo;
   import com.riotgames.platform.gameclient.kudos.IKudosProfileTotalsCache;
   import com.riotgames.platform.gameclient.kudos.KudosFactoryProxy;
   import com.riotgames.platform.gameclient.leagues.LeagueUpdateItem;
   import com.riotgames.platform.gameclient.utils.DateUtil;
   import com.riotgames.platform.gameclient.views.game.common.ChampionImages;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.contextualeducation.IContextualEducationProvider;
   import com.riotgames.pvpnet.game.controllers.EndOfGameStatsController;
   import com.riotgames.pvpnet.game.controllers.GameConfig;
   import com.riotgames.pvpnet.game.controllers.InGameController;
   import com.riotgames.pvpnet.game.variants.GameFlowVariant;
   import com.riotgames.pvpnet.game.variants.GameFlowVariantFactory;
   import com.riotgames.pvpnet.game.variants.GameStatsType;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.pvpnet.watch.IWatchReplayButton;
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
   import mx.binding.utils.BindingUtils;
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.containers.Canvas;
   import mx.containers.HBox;
   import mx.containers.ViewStack;
   import mx.containers.utilityClasses.ConstraintColumn;
   import mx.containers.utilityClasses.ConstraintRow;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.controls.SWFLoader;
   import mx.core.UIComponent;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.effects.Fade;
   import mx.events.EffectEvent;
   import mx.events.FlexEvent;
   import mx.events.IndexChangedEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.ResizeEvent;
   import mx.styles.*;
   import mx.utils.StringUtil;
   
   use namespace mx_internal;
   
   public class EndOfGameStatsView extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static const OVERVIEW_SCOREBOARD_KDA_ICON:Class = EndOfGameStatsView_OVERVIEW_SCOREBOARD_KDA_ICON;
      
      public static const OVERVIEW_FIRST_WIN_ICON:Class = EndOfGameStatsView_OVERVIEW_FIRST_WIN_ICON;
      
      public static const OVERVIEW_PRACTICE_XP_ICON:Class = EndOfGameStatsView_OVERVIEW_PRACTICE_XP_ICON;
      
      public static const CHAT_TEXTURED_BACKGROUND:Class = EndOfGameStatsView_CHAT_TEXTURED_BACKGROUND;
      
      public static const MINISERIES_WIN_ICON:Class = EndOfGameStatsView_MINISERIES_WIN_ICON;
      
      public static const MINISERIES_LOSS_ICON:Class = EndOfGameStatsView_MINISERIES_LOSS_ICON;
      
      public static const MINISERIES_NULL_ICON:Class = EndOfGameStatsView_MINISERIES_NULL_ICON;
      
      public static const CHAT_PANEL_BACKGROUND:Class = EndOfGameStatsView_CHAT_PANEL_BACKGROUND;
      
      public static const OVERVIEW_SCOREBOARD_NEXUS_HEALTH_GREEN:Class = EndOfGameStatsView_OVERVIEW_SCOREBOARD_NEXUS_HEALTH_GREEN;
      
      public static const OVERVIEW_SCOREBOARD_NEXUS_HEALTH_RED:Class = EndOfGameStatsView_OVERVIEW_SCOREBOARD_NEXUS_HEALTH_RED;
      
      public static const OVERVIEW_SCOREBOARD_NEXUS_HEALTH_BLUE:Class = EndOfGameStatsView_OVERVIEW_SCOREBOARD_NEXUS_HEALTH_BLUE;
      
      public static const OVERVIEW_SCOREBOARD_NEXUS_HEALTH_PURPLE:Class = EndOfGameStatsView_OVERVIEW_SCOREBOARD_NEXUS_HEALTH_PURPLE;
      
      public static const OVERVIEW_RANKING_GOLD:Class = EndOfGameStatsView_OVERVIEW_RANKING_GOLD;
      
      public static const OVERVIEW_RANKING_SILVER:Class = EndOfGameStatsView_OVERVIEW_RANKING_SILVER;
      
      public static const OVERVIEW_RANKING_BRONZE:Class = EndOfGameStatsView_OVERVIEW_RANKING_BRONZE;
      
      public static const OVERVIEW_SKIN_MASK:Class = EndOfGameStatsView_OVERVIEW_SKIN_MASK;
      
      public static const OVERVIEW_OBSERVER_SKIN:Class = EndOfGameStatsView_OVERVIEW_OBSERVER_SKIN;
      
      private static const TEAM_STATS_HEIGHT_STANDARD:int = 157;
      
      private static const TEAM_STATS_HEIGHT_EXTENDED:int = 189;
      
      private static const LAYOUT_MODE_REROLLS:uint = 1;
      
      private static const LAYOUT_MODE_CONTEXTUAL_EDUCATION_TIPS:uint = 2;
      
      private var _1459115697RerollBreakdown:HBox;
      
      private var _268058841isDominionStatType:Boolean;
      
      private var saveReplayButton:IWatchReplayButton;
      
      private var _265437237mainPanel:Canvas;
      
      private var _1181217948ipGainDisplay:Label;
      
      private var _552497218midColumn:ConstraintColumn;
      
      public var _EndOfGameStatsView_Image13:Image;
      
      public var _EndOfGameStatsView_Image14:Image;
      
      public var _EndOfGameStatsView_Image15:Image;
      
      private var _1392722108potentialIpEarned:int = 0;
      
      private var _2033792215replaysForEndOfGameStatsEnabled:Boolean;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      private var _364261990enemyTeamStats:EndOfGameStatsTeam;
      
      private var _348423736xpOverlay:Canvas;
      
      private var _494117997leagueDisplay:Label;
      
      private var _597162968nexusHealthIconRight:Image;
      
      private var useAlternateColor:Boolean = false;
      
      private var _615655144returnToLobby_btn:SoundEffectButton;
      
      private var _868055995topRow:ConstraintRow;
      
      private var kudosTotalsCache:IKudosProfileTotalsCache = KudosFactoryProxy.getInstance().getKudosProfileTotalsCache();
      
      private var _1354751959playAgain_btn:SoundEffectButton;
      
      private var _1613087374rerollDisplay:Label;
      
      private var _1171872581mapNameDisplay:Label;
      
      private var _912668519allChat:Canvas;
      
      private var _204468622championImage:Image;
      
      private var _533461831seriesDisplay2:Image;
      
      private var _1655307837leftColumn:ConstraintColumn;
      
      private var contextualEducationContainerAdapter:DisplayAdapter;
      
      private var _637373136normalRankedDisplay:HBox;
      
      private var newChat:IChatRoomView;
      
      private var firstWinAvailable:Boolean;
      
      private var _743604255limitedIPTimeLeftLabel:Label;
      
      private var _noIPXPrewardAlert:AlertParameters;
      
      public var _EndOfGameStatsView_Canvas9:Canvas;
      
      private var _533461833seriesDisplay4:Image;
      
      private var contextualEducationDisplay:SpriteProxy;
      
      private var _1434484347firstWinTimeLabel:Label;
      
      private var gameResultLabel:GradientTextField = new GradientTextField();
      
      private var _1084929065friendlyTeamStats:EndOfGameStatsTeam;
      
      private var LAYOUT_MODE:uint = 0;
      
      private var shareMatchHistoryUrlTemplate:ConfigurationModel;
      
      private var practiceRewardAvailable:Boolean;
      
      private var _763144006IPBreakdown:HBox;
      
      private var _1253918131gameModeDisplay:Label;
      
      [Inject]
      public var inGameController:InGameController;
      
      private var ipSegmentArray:Array = [];
      
      private var _1604667535eogViews:ViewStack;
      
      private var lossesNumber:GradientTextField = new GradientTextField();
      
      private var _1853405429advancedGameDetails_btn:SoundEffectButton;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      private var firstWinSeconds:int;
      
      private var _454164327eogRewards:SoundEffectButton;
      
      private var _1282133823fadeIn:Fade;
      
      private var _1075140139xpGainDisplay:Label;
      
      private var _1076167252purpleFilter:GlowFilter;
      
      private var oldChat:EndOfGameChatWindow;
      
      [Inject]
      private var _1164646953endOfGameStatsController:EndOfGameStatsController;
      
      private var _1618256303eogGraph:EndOfGameGraph;
      
      private var winsNumber:GradientTextField = new GradientTextField();
      
      private var _1848699506shareGame_btn:SoundEffectButton;
      
      private var _1914859983rankingIcon:Image;
      
      private var _757620806enableShareEndOfGameButton:Boolean;
      
      private var _1582693220endOfGameChat:Canvas;
      
      private var _679945551enableAdvancedDetailsButton:Boolean;
      
      private var _1653546737leaveFilter:GlowFilter;
      
      private var _1730126747eogTabBar:ToggleButtonBar;
      
      private var _1971344875teamCanvas:Canvas;
      
      public var session:Session = Session.instance;
      
      private var _416760718blueFilter:GlowFilter;
      
      private var _533461830seriesDisplay1:Image;
      
      private var _1947610615XPBreakdown:HBox;
      
      private var _1595022061loseFilter:GlowFilter;
      
      private var _873431918rightColumn:ConstraintColumn;
      
      private var _522112108satFadeOut:SaturationFade;
      
      private var shareMatchHistoryEnabled:ConfigurationModel;
      
      private var practiceRewardSeconds:int;
      
      private var _1057212487limitedIPTimeIcon:Image;
      
      private var _1967381782endOfGameChatBackground:Image;
      
      private var _2084348899normalRankedDisplayText:Label;
      
      private var _1081725324winFilter:GlowFilter;
      
      private var _2032065264overrideBack_btn:SoundEffectButton;
      
      private var _1696229848endOfGameScoreboard:EndOfGameScoreboard;
      
      private var _801401613rerollGainDisplay:Label;
      
      private var _533461832seriesDisplay3:Image;
      
      private var _2084678807normalRankedDisplayIcon:Image;
      
      private var advancedDetailsUrlTemplate:ConfigurationModel;
      
      private var chatViewProvider:IChatViewProvider;
      
      private var teamOverall:GradientTextField = new GradientTextField();
      
      private var needsShow:Boolean = true;
      
      private var timer:Timer = new Timer(350,1);
      
      private var _430026366contextualTipCanvas:UIComponent;
      
      private var _1366027387nexusHealthIconLeft:Image;
      
      private var advancedDetailsEnabled:ConfigurationModel;
      
      private var _2013929970teamStatsViewHeight:int = 157;
      
      private var _1144184291gameTimeDisplay:Label;
      
      private var _885120682XPDisplay:Label;
      
      private var _1855392849bottomRow:ConstraintRow;
      
      private var _1050744568gridParentCanvas:Canvas;
      
      mx_internal var _watchers:Array = [];
      
      private var _1817957447satFadeIn:SaturationFade;
      
      private var enemyOverall:GradientTextField = new GradientTextField();
      
      private var _533461834seriesDisplay5:Image;
      
      private var _1093953784overviewContainer:Canvas;
      
      private var _81172224rerollOverlay:Canvas;
      
      private var _1690436905ipOverlay:Canvas;
      
      private var _1269534117firstWinIcon:Image;
      
      mx_internal var _bindings:Array = [];
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":ViewStack,
               "id":"eogViews",
               "events":{"change":"__eogViews_change"},
               "stylesFactory":function():void
               {
                  this.left = "3";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "width":832,
                     "height":702,
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":Canvas,
                        "id":"mainPanel",
                        "events":{"creationComplete":"__mainPanel_creationComplete"},
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentWidth":100,
                              "percentHeight":100,
                              "styleName":"endOfGameMainPanel",
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":Canvas,
                                 "propertiesFactory":function():Object
                                 {
                                    return {
                                       "width":817,
                                       "height":217,
                                       "x":8,
                                       "y":8,
                                       "childDescriptors":[new UIComponentDescriptor({
                                          "type":Image,
                                          "id":"championImage",
                                          "effects":["showEffect"],
                                          "stylesFactory":function():void
                                          {
                                             this.right = "2";
                                             this.top = "2";
                                             this.bottom = "1";
                                             this.showEffect = "fadeIn";
                                          },
                                          "propertiesFactory":function():Object
                                          {
                                             return {
                                                "smoothBitmapContent":true,
                                                "width":365,
                                                "maintainAspectRatio":false
                                             };
                                          }
                                       }),new UIComponentDescriptor({
                                          "type":Canvas,
                                          "id":"overviewContainer",
                                          "events":{"creationComplete":"__overviewContainer_creationComplete"},
                                          "stylesFactory":function():void
                                          {
                                             this.horizontalCenter = "0";
                                             this.verticalCenter = "0";
                                          },
                                          "propertiesFactory":function():Object
                                          {
                                             return {
                                                "width":817,
                                                "height":217,
                                                "styleName":"eogOverview",
                                                "childDescriptors":[new UIComponentDescriptor({
                                                   "type":Label,
                                                   "id":"mapNameDisplay",
                                                   "stylesFactory":function():void
                                                   {
                                                      this.left = "7";
                                                      this.top = "7";
                                                      this.fontSize = 14;
                                                      this.color = 15658734;
                                                   },
                                                   "propertiesFactory":function():Object
                                                   {
                                                      return {
                                                         "height":20,
                                                         "width":300
                                                      };
                                                   }
                                                }),new UIComponentDescriptor({
                                                   "type":Label,
                                                   "id":"gameModeDisplay",
                                                   "stylesFactory":function():void
                                                   {
                                                      this.left = "7";
                                                      this.top = "27";
                                                      this.fontSize = 14;
                                                      this.color = 15658734;
                                                   },
                                                   "propertiesFactory":function():Object
                                                   {
                                                      return {
                                                         "height":20,
                                                         "width":300
                                                      };
                                                   }
                                                }),new UIComponentDescriptor({
                                                   "type":HBox,
                                                   "id":"normalRankedDisplay",
                                                   "stylesFactory":function():void
                                                   {
                                                      this.left = "7";
                                                      this.top = "47";
                                                      this.horizontalGap = 0;
                                                   },
                                                   "propertiesFactory":function():Object
                                                   {
                                                      return {
                                                         "height":20,
                                                         "width":300,
                                                         "horizontalScrollPolicy":"off",
                                                         "verticalScrollPolicy":"off",
                                                         "childDescriptors":[new UIComponentDescriptor({
                                                            "type":Label,
                                                            "id":"normalRankedDisplayText",
                                                            "stylesFactory":function():void
                                                            {
                                                               this.fontSize = 14;
                                                               this.color = 15658734;
                                                            }
                                                         }),new UIComponentDescriptor({
                                                            "type":Image,
                                                            "id":"normalRankedDisplayIcon",
                                                            "propertiesFactory":function():Object
                                                            {
                                                               return {
                                                                  "height":18,
                                                                  "visible":false,
                                                                  "scaleContent":true,
                                                                  "maintainAspectRatio":true,
                                                                  "smoothBitmapContent":true
                                                               };
                                                            }
                                                         })]
                                                      };
                                                   }
                                                }),new UIComponentDescriptor({
                                                   "type":Label,
                                                   "id":"leagueDisplay",
                                                   "stylesFactory":function():void
                                                   {
                                                      this.left = "7";
                                                      this.fontSize = 14;
                                                      this.color = 15658734;
                                                   },
                                                   "propertiesFactory":function():Object
                                                   {
                                                      return {
                                                         "height":20,
                                                         "width":300,
                                                         "visible":false
                                                      };
                                                   }
                                                }),new UIComponentDescriptor({
                                                   "type":Label,
                                                   "id":"gameTimeDisplay",
                                                   "stylesFactory":function():void
                                                   {
                                                      this.left = "7";
                                                      this.fontSize = 14;
                                                      this.color = 16764672;
                                                   },
                                                   "propertiesFactory":function():Object
                                                   {
                                                      return {
                                                         "height":20,
                                                         "width":300
                                                      };
                                                   }
                                                }),new UIComponentDescriptor({
                                                   "type":Image,
                                                   "id":"seriesDisplay1",
                                                   "stylesFactory":function():void
                                                   {
                                                      this.left = "7";
                                                   },
                                                   "propertiesFactory":function():Object
                                                   {
                                                      return {
                                                         "height":15,
                                                         "width":15,
                                                         "visible":false,
                                                         "smoothBitmapContent":true
                                                      };
                                                   }
                                                }),new UIComponentDescriptor({
                                                   "type":Image,
                                                   "id":"seriesDisplay2",
                                                   "stylesFactory":function():void
                                                   {
                                                      this.left = "27";
                                                   },
                                                   "propertiesFactory":function():Object
                                                   {
                                                      return {
                                                         "height":15,
                                                         "width":15,
                                                         "visible":false,
                                                         "smoothBitmapContent":true
                                                      };
                                                   }
                                                }),new UIComponentDescriptor({
                                                   "type":Image,
                                                   "id":"seriesDisplay3",
                                                   "stylesFactory":function():void
                                                   {
                                                      this.left = "47";
                                                   },
                                                   "propertiesFactory":function():Object
                                                   {
                                                      return {
                                                         "height":15,
                                                         "width":15,
                                                         "visible":false,
                                                         "smoothBitmapContent":true
                                                      };
                                                   }
                                                }),new UIComponentDescriptor({
                                                   "type":Image,
                                                   "id":"seriesDisplay4",
                                                   "stylesFactory":function():void
                                                   {
                                                      this.left = "67";
                                                   },
                                                   "propertiesFactory":function():Object
                                                   {
                                                      return {
                                                         "height":15,
                                                         "width":15,
                                                         "visible":false,
                                                         "smoothBitmapContent":true
                                                      };
                                                   }
                                                }),new UIComponentDescriptor({
                                                   "type":Image,
                                                   "id":"seriesDisplay5",
                                                   "stylesFactory":function():void
                                                   {
                                                      this.left = "87";
                                                   },
                                                   "propertiesFactory":function():Object
                                                   {
                                                      return {
                                                         "height":15,
                                                         "width":15,
                                                         "visible":false,
                                                         "smoothBitmapContent":true
                                                      };
                                                   }
                                                }),new UIComponentDescriptor({
                                                   "type":HBox,
                                                   "id":"IPBreakdown",
                                                   "stylesFactory":function():void
                                                   {
                                                      this.horizontalGap = 0;
                                                      this.backgroundAlpha = 1;
                                                      this.backgroundColor = 0;
                                                   },
                                                   "propertiesFactory":function():Object
                                                   {
                                                      return {
                                                         "width":432,
                                                         "height":24,
                                                         "y":75,
                                                         "horizontalScrollPolicy":"off"
                                                      };
                                                   }
                                                }),new UIComponentDescriptor({
                                                   "type":Canvas,
                                                   "id":"ipOverlay",
                                                   "stylesFactory":function():void
                                                   {
                                                      this.horizontalCenter = "0";
                                                   },
                                                   "propertiesFactory":function():Object
                                                   {
                                                      return {
                                                         "styleName":"ipXpBar",
                                                         "width":441,
                                                         "height":34,
                                                         "y":70,
                                                         "mouseEnabled":false,
                                                         "mouseChildren":false
                                                      };
                                                   }
                                                }),new UIComponentDescriptor({
                                                   "type":Label,
                                                   "id":"ipGainDisplay",
                                                   "stylesFactory":function():void
                                                   {
                                                      this.fontSize = 14;
                                                      this.color = 16777215;
                                                      this.textAlign = "right";
                                                   },
                                                   "propertiesFactory":function():Object
                                                   {
                                                      return {
                                                         "width":100,
                                                         "height":25,
                                                         "y":76
                                                      };
                                                   }
                                                }),new UIComponentDescriptor({
                                                   "type":HBox,
                                                   "id":"XPBreakdown",
                                                   "stylesFactory":function():void
                                                   {
                                                      this.horizontalGap = 0;
                                                      this.backgroundAlpha = 1;
                                                      this.backgroundColor = 0;
                                                   },
                                                   "propertiesFactory":function():Object
                                                   {
                                                      return {
                                                         "width":432,
                                                         "height":24,
                                                         "y":130,
                                                         "horizontalScrollPolicy":"off"
                                                      };
                                                   }
                                                }),new UIComponentDescriptor({
                                                   "type":Canvas,
                                                   "id":"xpOverlay",
                                                   "stylesFactory":function():void
                                                   {
                                                      this.horizontalCenter = "0";
                                                   },
                                                   "propertiesFactory":function():Object
                                                   {
                                                      return {
                                                         "styleName":"ipXpBar",
                                                         "width":441,
                                                         "height":34,
                                                         "y":125,
                                                         "mouseEnabled":false,
                                                         "mouseChildren":false
                                                      };
                                                   }
                                                }),new UIComponentDescriptor({
                                                   "type":Label,
                                                   "id":"XPDisplay",
                                                   "stylesFactory":function():void
                                                   {
                                                      this.textAlign = "center";
                                                   },
                                                   "propertiesFactory":function():Object
                                                   {
                                                      return {
                                                         "width":432,
                                                         "height":24,
                                                         "y":131,
                                                         "styleName":"XPBarText",
                                                         "mouseEnabled":false,
                                                         "mouseChildren":false
                                                      };
                                                   }
                                                }),new UIComponentDescriptor({
                                                   "type":Label,
                                                   "id":"xpGainDisplay",
                                                   "stylesFactory":function():void
                                                   {
                                                      this.fontSize = 14;
                                                      this.color = 16777215;
                                                      this.textAlign = "right";
                                                   },
                                                   "propertiesFactory":function():Object
                                                   {
                                                      return {
                                                         "width":100,
                                                         "height":25,
                                                         "y":131,
                                                         "mouseChildren":false,
                                                         "mouseEnabled":false
                                                      };
                                                   }
                                                }),new UIComponentDescriptor({
                                                   "type":SoundEffectButton,
                                                   "id":"eogRewards",
                                                   "events":{"click":"__eogRewards_click"},
                                                   "propertiesFactory":function():Object
                                                   {
                                                      return {
                                                         "styleName":"infoButtonBlue",
                                                         "x":633,
                                                         "y":126,
                                                         "width":37,
                                                         "height":33,
                                                         "enabled":true,
                                                         "visible":false,
                                                         "buttonMode":true,
                                                         "useHandCursor":true
                                                      };
                                                   }
                                                }),new UIComponentDescriptor({
                                                   "type":HBox,
                                                   "id":"RerollBreakdown",
                                                   "stylesFactory":function():void
                                                   {
                                                      this.horizontalGap = 0;
                                                      this.backgroundAlpha = 1;
                                                      this.backgroundColor = 0;
                                                   },
                                                   "propertiesFactory":function():Object
                                                   {
                                                      return {
                                                         "width":432,
                                                         "height":24,
                                                         "y":150,
                                                         "horizontalScrollPolicy":"off",
                                                         "visible":false
                                                      };
                                                   }
                                                }),new UIComponentDescriptor({
                                                   "type":Canvas,
                                                   "id":"rerollOverlay",
                                                   "stylesFactory":function():void
                                                   {
                                                      this.horizontalCenter = "0";
                                                   },
                                                   "propertiesFactory":function():Object
                                                   {
                                                      return {
                                                         "styleName":"ipXpBar",
                                                         "width":441,
                                                         "height":34,
                                                         "y":145,
                                                         "mouseEnabled":false,
                                                         "mouseChildren":false,
                                                         "visible":false
                                                      };
                                                   }
                                                }),new UIComponentDescriptor({
                                                   "type":Label,
                                                   "id":"rerollDisplay",
                                                   "stylesFactory":function():void
                                                   {
                                                      this.textAlign = "center";
                                                   },
                                                   "propertiesFactory":function():Object
                                                   {
                                                      return {
                                                         "width":432,
                                                         "height":24,
                                                         "y":151,
                                                         "styleName":"XPBarText",
                                                         "mouseEnabled":false,
                                                         "mouseChildren":false,
                                                         "visible":false,
                                                         "text":""
                                                      };
                                                   }
                                                }),new UIComponentDescriptor({
                                                   "type":Label,
                                                   "id":"rerollGainDisplay",
                                                   "stylesFactory":function():void
                                                   {
                                                      this.fontSize = 14;
                                                      this.color = 16777215;
                                                      this.textAlign = "right";
                                                   },
                                                   "propertiesFactory":function():Object
                                                   {
                                                      return {
                                                         "width":150,
                                                         "height":25,
                                                         "y":151,
                                                         "mouseChildren":false,
                                                         "mouseEnabled":false,
                                                         "text":"Reroll",
                                                         "visible":false
                                                      };
                                                   }
                                                }),new UIComponentDescriptor({
                                                   "type":Image,
                                                   "id":"limitedIPTimeIcon",
                                                   "stylesFactory":function():void
                                                   {
                                                      this.left = "10";
                                                      this.bottom = "9";
                                                   },
                                                   "propertiesFactory":function():Object
                                                   {
                                                      return {"toolTip":""};
                                                   }
                                                }),new UIComponentDescriptor({
                                                   "type":Label,
                                                   "id":"limitedIPTimeLeftLabel",
                                                   "stylesFactory":function():void
                                                   {
                                                      this.left = "38";
                                                      this.bottom = "6";
                                                      this.fontSize = 13;
                                                      this.color = 11842740;
                                                   },
                                                   "propertiesFactory":function():Object
                                                   {
                                                      return {
                                                         "text":"**155 mynoots",
                                                         "height":20,
                                                         "width":300
                                                      };
                                                   }
                                                }),new UIComponentDescriptor({
                                                   "type":Image,
                                                   "id":"firstWinIcon",
                                                   "stylesFactory":function():void
                                                   {
                                                      this.left = "10";
                                                   },
                                                   "propertiesFactory":function():Object
                                                   {
                                                      return {"toolTip":"**First win of the day DOOD"};
                                                   }
                                                }),new UIComponentDescriptor({
                                                   "type":Label,
                                                   "id":"firstWinTimeLabel",
                                                   "stylesFactory":function():void
                                                   {
                                                      this.left = "38";
                                                      this.fontSize = 13;
                                                      this.color = 11842740;
                                                   },
                                                   "propertiesFactory":function():Object
                                                   {
                                                      return {
                                                         "text":"00:00:00",
                                                         "height":20,
                                                         "width":300
                                                      };
                                                   }
                                                }),new UIComponentDescriptor({
                                                   "type":SoundEffectButton,
                                                   "id":"advancedGameDetails_btn",
                                                   "events":{"click":"__advancedGameDetails_btn_click"},
                                                   "propertiesFactory":function():Object
                                                   {
                                                      return {
                                                         "styleName":"correctLargeButtonBlue",
                                                         "width":175,
                                                         "x":633,
                                                         "y":175,
                                                         "height":33,
                                                         "buttonMode":true,
                                                         "useHandCursor":true
                                                      };
                                                   }
                                                }),new UIComponentDescriptor({
                                                   "type":Image,
                                                   "id":"rankingIcon",
                                                   "stylesFactory":function():void
                                                   {
                                                      this.right = "5";
                                                      this.bottom = "2";
                                                   }
                                                })]
                                             };
                                          }
                                       })]
                                    };
                                 }
                              }),new UIComponentDescriptor({
                                 "type":Image,
                                 "id":"nexusHealthIconLeft",
                                 "stylesFactory":function():void
                                 {
                                    this.horizontalCenter = "-16";
                                 },
                                 "propertiesFactory":function():Object
                                 {
                                    return {"y":230};
                                 }
                              }),new UIComponentDescriptor({
                                 "type":Image,
                                 "id":"nexusHealthIconRight",
                                 "stylesFactory":function():void
                                 {
                                    this.horizontalCenter = "16";
                                 },
                                 "propertiesFactory":function():Object
                                 {
                                    return {"y":230};
                                 }
                              }),new UIComponentDescriptor({
                                 "type":Image,
                                 "id":"_EndOfGameStatsView_Image13",
                                 "stylesFactory":function():void
                                 {
                                    this.horizontalCenter = "8";
                                 },
                                 "propertiesFactory":function():Object
                                 {
                                    return {"y":233};
                                 }
                              }),new UIComponentDescriptor({
                                 "type":EndOfGameScoreboard,
                                 "id":"endOfGameScoreboard",
                                 "propertiesFactory":function():Object
                                 {
                                    return {
                                       "x":8,
                                       "y":260,
                                       "width":814,
                                       "height":440
                                    };
                                 }
                              }),new UIComponentDescriptor({
                                 "type":UIComponent,
                                 "id":"contextualTipCanvas",
                                 "propertiesFactory":function():Object
                                 {
                                    return {
                                       "height":0,
                                       "width":817,
                                       "x":8,
                                       "y":155,
                                       "visible":true
                                    };
                                 }
                              })]
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Canvas,
                        "id":"gridParentCanvas",
                        "propertiesFactory":function():Object
                        {
                           return {"styleName":"endOfGameGrid"};
                        }
                     }),new UIComponentDescriptor({
                        "type":Canvas,
                        "id":"_EndOfGameStatsView_Canvas9",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentWidth":100,
                              "percentHeight":100,
                              "styleName":"endOfGameGraph",
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":EndOfGameGraph,
                                 "id":"eogGraph",
                                 "stylesFactory":function():void
                                 {
                                    this.top = "7";
                                    this.left = "7";
                                    this.right = "7";
                                    this.bottom = "7";
                                 },
                                 "propertiesFactory":function():Object
                                 {
                                    return {
                                       "percentWidth":100,
                                       "percentHeight":100
                                    };
                                 }
                              })]
                           };
                        }
                     })]
                  };
               }
            }),new UIComponentDescriptor({
               "type":ToggleButtonBar,
               "id":"eogTabBar",
               "stylesFactory":function():void
               {
                  this.buttonWidth = 140;
                  this.buttonHeight = 25;
                  this.textAlign = "left";
                  this.horizontalGap = -1;
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "tabEnabled":false,
                     "tabChildren":false,
                     "x":3,
                     "y":3,
                     "autoLayout":false,
                     "styleName":"eogMainTab"
                  };
               }
            }),new UIComponentDescriptor({
               "type":Canvas,
               "id":"teamCanvas",
               "stylesFactory":function():void
               {
                  this.right = "5";
                  this.top = "3";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "cacheAsBitmap":true,
                     "width":420,
                     "horizontalScrollPolicy":"off",
                     "verticalScrollPolicy":"off",
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":Image,
                        "id":"_EndOfGameStatsView_Image14",
                        "stylesFactory":function():void
                        {
                           this.left = "0";
                           this.right = "0";
                           this.top = "0";
                           this.bottom = "0";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "scaleContent":true,
                              "maintainAspectRatio":false
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Image,
                        "id":"_EndOfGameStatsView_Image15",
                        "stylesFactory":function():void
                        {
                           this.left = "7";
                           this.right = "7";
                           this.top = "7";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "scaleContent":true,
                              "maintainAspectRatio":false
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":EndOfGameStatsTeam,
                        "id":"friendlyTeamStats",
                        "stylesFactory":function():void
                        {
                           this.left = "4";
                           this.right = "4";
                           this.top = "13";
                        }
                     }),new UIComponentDescriptor({
                        "type":EndOfGameStatsTeam,
                        "id":"enemyTeamStats",
                        "stylesFactory":function():void
                        {
                           this.left = "4";
                           this.right = "4";
                        }
                     }),new UIComponentDescriptor({
                        "type":Canvas,
                        "id":"endOfGameChat",
                        "events":{"creationComplete":"__endOfGameChat_creationComplete"},
                        "stylesFactory":function():void
                        {
                           this.left = "7";
                           this.right = "7";
                           this.bottom = "7";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {"childDescriptors":[new UIComponentDescriptor({
                              "type":Image,
                              "id":"endOfGameChatBackground",
                              "stylesFactory":function():void
                              {
                                 this.left = "0";
                                 this.right = "0";
                                 this.bottom = "33";
                                 this.top = "0";
                              },
                              "propertiesFactory":function():Object
                              {
                                 return {
                                    "scaleContent":true,
                                    "maintainAspectRatio":false
                                 };
                              }
                           })]};
                        }
                     })]
                  };
               }
            }),new UIComponentDescriptor({
               "type":Canvas,
               "id":"allChat",
               "stylesFactory":function():void
               {
                  this.right = "3";
                  this.bottom = "40";
                  this.backgroundAlpha = 0;
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "cacheAsBitmap":true,
                     "horizontalScrollPolicy":"off",
                     "verticalScrollPolicy":"off",
                     "width":420,
                     "height":300
                  };
               }
            }),new UIComponentDescriptor({
               "type":SoundEffectButton,
               "id":"playAgain_btn",
               "events":{"click":"__playAgain_btn_click"},
               "stylesFactory":function():void
               {
                  this.right = "3";
                  this.bottom = "2";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "styleName":"correctLargeButtonBlue",
                     "width":297,
                     "height":39,
                     "buttonMode":true,
                     "useHandCursor":true
                  };
               }
            }),new UIComponentDescriptor({
               "type":SoundEffectButton,
               "id":"shareGame_btn",
               "events":{"click":"__shareGame_btn_click"},
               "stylesFactory":function():void
               {
                  this.bottom = "41";
                  this.right = "3";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "styleName":"correctLargeButtonBlue",
                     "width":297,
                     "height":39,
                     "buttonMode":true,
                     "useHandCursor":true
                  };
               }
            }),new UIComponentDescriptor({
               "type":SoundEffectButton,
               "id":"returnToLobby_btn",
               "events":{"click":"__returnToLobby_btn_click"},
               "stylesFactory":function():void
               {
                  this.bottom = "2";
                  this.right = "300";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "styleName":"correctLargeButtonBlue",
                     "width":127,
                     "buttonMode":true,
                     "useHandCursor":true
                  };
               }
            }),new UIComponentDescriptor({
               "type":SoundEffectButton,
               "id":"overrideBack_btn",
               "events":{"click":"__overrideBack_btn_click"},
               "stylesFactory":function():void
               {
                  this.right = "3";
                  this.bottom = "2";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "styleName":"correctLargeButtonBlue",
                     "width":423,
                     "height":39,
                     "buttonMode":true,
                     "useHandCursor":true
                  };
               }
            })]};
         }
      });
      
      public function EndOfGameStatsView()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.percentWidth = 100;
         this.percentHeight = 100;
         this.constraintColumns = [this._EndOfGameStatsView_ConstraintColumn1_i(),this._EndOfGameStatsView_ConstraintColumn2_i(),this._EndOfGameStatsView_ConstraintColumn3_i()];
         this.constraintRows = [this._EndOfGameStatsView_ConstraintRow1_i(),this._EndOfGameStatsView_ConstraintRow2_i()];
         this._EndOfGameStatsView_GlowFilter4_i();
         this._EndOfGameStatsView_Fade1_i();
         this._EndOfGameStatsView_GlowFilter3_i();
         this._EndOfGameStatsView_GlowFilter2_i();
         this._EndOfGameStatsView_GlowFilter5_i();
         this._EndOfGameStatsView_SaturationFade2_i();
         this._EndOfGameStatsView_SaturationFade1_i();
         this._EndOfGameStatsView_GlowFilter1_i();
         this.addEventListener("show",this.___EndOfGameStatsView_Canvas1_show);
         this.addEventListener("hide",this.___EndOfGameStatsView_Canvas1_hide);
         this.addEventListener("creationComplete",this.___EndOfGameStatsView_Canvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         EndOfGameStatsView._watcherSetupUtil = param1;
      }
      
      public function set XPBreakdown(param1:HBox) : void
      {
         var _loc2_:Object = this._1947610615XPBreakdown;
         if(_loc2_ !== param1)
         {
            this._1947610615XPBreakdown = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"XPBreakdown",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get normalRankedDisplayText() : Label
      {
         return this._2084348899normalRankedDisplayText;
      }
      
      private function set teamStatsViewHeight(param1:int) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._2013929970teamStatsViewHeight;
         if(_loc2_ !== param1)
         {
            this._2013929970teamStatsViewHeight = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamStatsViewHeight",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get limitedIPTimeLeftLabel() : Label
      {
         return this._743604255limitedIPTimeLeftLabel;
      }
      
      private function onPlayAgainButtonClicked(param1:MouseEvent) : void
      {
         this.endOfGameStatsController.playAnotherGame();
         this.handleEndOfGameStatsViewExit();
      }
      
      [Bindable(event="propertyChange")]
      public function get playAgain_btn() : SoundEffectButton
      {
         return this._1354751959playAgain_btn;
      }
      
      public function set teamCanvas(param1:Canvas) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._1971344875teamCanvas;
         if(_loc2_ !== param1)
         {
            this._1971344875teamCanvas = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamCanvas",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get nexusHealthIconRight() : Image
      {
         return this._597162968nexusHealthIconRight;
      }
      
      private function updateSeriesDisplayIcons(param1:Boolean, param2:uint, param3:uint) : void
      {
         this.seriesDisplay1.visible = true;
         this.seriesDisplay2.visible = true;
         this.seriesDisplay3.visible = true;
         this.seriesDisplay4.visible = param1;
         this.seriesDisplay5.visible = param1;
         var _loc4_:int = 0;
         while(_loc4_ < param2)
         {
            this["seriesDisplay" + (_loc4_ + 1).toString()].source = MINISERIES_WIN_ICON;
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < param3)
         {
            this["seriesDisplay" + (param2 + _loc4_ + 1).toString()].source = MINISERIES_LOSS_ICON;
            _loc4_++;
         }
      }
      
      public function set normalRankedDisplayText(param1:Label) : void
      {
         var _loc2_:Object = this._2084348899normalRankedDisplayText;
         if(_loc2_ !== param1)
         {
            this._2084348899normalRankedDisplayText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"normalRankedDisplayText",_loc2_,param1));
         }
      }
      
      private function requestAndDisplayPendingKudos() : void
      {
         var _loc1_:ICommand = KudosFactoryProxy.getInstance().createShowReceivedKudosCommand();
         _loc1_.addResponder(this.handlePendingKudosRetrieved);
         _loc1_.execute();
      }
      
      private function _EndOfGameStatsView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = eogTabBar.y + eogTabBar.height - 1;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            eogViews.setStyle("top",param1);
         },"eogViews.top");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("endOfGame_overview_header","Overview");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            mainPanel.label = param1;
         },"mainPanel.label");
         result[1] = binding;
         binding = new Binding(this,function():Boolean
         {
            return championImage.source != null;
         },function(param1:Boolean):void
         {
            championImage.visible = param1;
         },"championImage.visible");
         result[2] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !leagueDisplay.visible;
         },function(param1:Boolean):void
         {
            normalRankedDisplay.visible = param1;
         },"normalRankedDisplay.visible");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = gameModeDisplay.y + gameModeDisplay.height;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            leagueDisplay.setStyle("top",param1);
         },"leagueDisplay.top");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = seriesDisplay1.visible ? seriesDisplay1.y + seriesDisplay1.height : normalRankedDisplay.y + normalRankedDisplay.height;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            gameTimeDisplay.setStyle("top",param1);
         },"gameTimeDisplay.top");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = normalRankedDisplay.y + normalRankedDisplay.height + 2;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            seriesDisplay1.setStyle("top",param1);
         },"seriesDisplay1.top");
         result[6] = binding;
         binding = new Binding(this,function():Object
         {
            return MINISERIES_NULL_ICON;
         },function(param1:Object):void
         {
            seriesDisplay1.source = param1;
         },"seriesDisplay1.source");
         result[7] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = normalRankedDisplay.y + normalRankedDisplay.height + 2;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            seriesDisplay2.setStyle("top",param1);
         },"seriesDisplay2.top");
         result[8] = binding;
         binding = new Binding(this,function():Object
         {
            return MINISERIES_NULL_ICON;
         },function(param1:Object):void
         {
            seriesDisplay2.source = param1;
         },"seriesDisplay2.source");
         result[9] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = normalRankedDisplay.y + normalRankedDisplay.height + 2;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            seriesDisplay3.setStyle("top",param1);
         },"seriesDisplay3.top");
         result[10] = binding;
         binding = new Binding(this,function():Object
         {
            return MINISERIES_NULL_ICON;
         },function(param1:Object):void
         {
            seriesDisplay3.source = param1;
         },"seriesDisplay3.source");
         result[11] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = normalRankedDisplay.y + normalRankedDisplay.height + 2;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            seriesDisplay4.setStyle("top",param1);
         },"seriesDisplay4.top");
         result[12] = binding;
         binding = new Binding(this,function():Object
         {
            return MINISERIES_NULL_ICON;
         },function(param1:Object):void
         {
            seriesDisplay4.source = param1;
         },"seriesDisplay4.source");
         result[13] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = normalRankedDisplay.y + normalRankedDisplay.height + 2;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            seriesDisplay5.setStyle("top",param1);
         },"seriesDisplay5.top");
         result[14] = binding;
         binding = new Binding(this,function():Object
         {
            return MINISERIES_NULL_ICON;
         },function(param1:Object):void
         {
            seriesDisplay5.source = param1;
         },"seriesDisplay5.source");
         result[15] = binding;
         binding = new Binding(this,function():Number
         {
            return ipOverlay.x + 5;
         },function(param1:Number):void
         {
            IPBreakdown.x = param1;
         },"IPBreakdown.x");
         result[16] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ipOverlay.x + ipOverlay.width + 3;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            ipGainDisplay.setStyle("right",param1);
         },"ipGainDisplay.right");
         result[17] = binding;
         binding = new Binding(this,function():Number
         {
            return ipOverlay.x + 5;
         },function(param1:Number):void
         {
            XPBreakdown.x = param1;
         },"XPBreakdown.x");
         result[18] = binding;
         binding = new Binding(this,function():Array
         {
            return [new GlowFilter(0,0.7)];
         },function(param1:Array):void
         {
            XPDisplay.filters = param1;
         },"XPDisplay.filters");
         result[19] = binding;
         binding = new Binding(this,function():Number
         {
            return ipOverlay.x + 5;
         },function(param1:Number):void
         {
            XPDisplay.x = param1;
         },"XPDisplay.x");
         result[20] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("BuddyListTooltip_summonerLevel","Level 9000",[this.endOfGameStatsController.levelUpInfo.currentLevel]);
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            XPDisplay.text = param1;
         },"XPDisplay.text");
         result[21] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = xpOverlay.x + xpOverlay.width + 3;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            xpGainDisplay.setStyle("right",param1);
         },"xpGainDisplay.right");
         result[22] = binding;
         binding = new Binding(this,function():Number
         {
            return ipOverlay.x + 5;
         },function(param1:Number):void
         {
            RerollBreakdown.x = param1;
         },"RerollBreakdown.x");
         result[23] = binding;
         binding = new Binding(this,function():Array
         {
            return [new GlowFilter(0,0.7)];
         },function(param1:Array):void
         {
            rerollDisplay.filters = param1;
         },"rerollDisplay.filters");
         result[24] = binding;
         binding = new Binding(this,function():Number
         {
            return ipOverlay.x + 5;
         },function(param1:Number):void
         {
            rerollDisplay.x = param1;
         },"rerollDisplay.x");
         result[25] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = rerollOverlay.x + rerollOverlay.width + 3;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            rerollGainDisplay.setStyle("right",param1);
         },"rerollGainDisplay.right");
         result[26] = binding;
         binding = new Binding(this,function():Object
         {
            return OVERVIEW_PRACTICE_XP_ICON;
         },function(param1:Object):void
         {
            limitedIPTimeIcon.source = param1;
         },"limitedIPTimeIcon.source");
         result[27] = binding;
         binding = new Binding(this,function():Object
         {
            return OVERVIEW_FIRST_WIN_ICON;
         },function(param1:Object):void
         {
            firstWinIcon.source = param1;
         },"firstWinIcon.source");
         result[28] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = limitedIPTimeIcon.visible ? 37 : 9;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            firstWinIcon.setStyle("bottom",param1);
         },"firstWinIcon.bottom");
         result[29] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = limitedIPTimeIcon.visible ? 34 : 6;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            firstWinTimeLabel.setStyle("bottom",param1);
         },"firstWinTimeLabel.bottom");
         result[30] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("endOfGame_shareGameButton_detailsButtonLabel","View Advanced Details");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            advancedGameDetails_btn.label = param1;
         },"advancedGameDetails_btn.label");
         result[31] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("endOfGame_shareGameButton_detailsButtonTooltip","View more match details online.");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            advancedGameDetails_btn.toolTip = param1;
         },"advancedGameDetails_btn.toolTip");
         result[32] = binding;
         binding = new Binding(this,function():Boolean
         {
            return enableAdvancedDetailsButton;
         },function(param1:Boolean):void
         {
            advancedGameDetails_btn.visible = param1;
         },"advancedGameDetails_btn.visible");
         result[33] = binding;
         binding = new Binding(this,function():Boolean
         {
            return enableAdvancedDetailsButton;
         },function(param1:Boolean):void
         {
            advancedGameDetails_btn.includeInLayout = param1;
         },"advancedGameDetails_btn.includeInLayout");
         result[34] = binding;
         binding = new Binding(this,function():Object
         {
            return null;
         },function(param1:Object):void
         {
            rankingIcon.source = param1;
         },"rankingIcon.source");
         result[35] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("end_of_game_overview_ranking_icon_tooltip","Overall rank on your team");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            rankingIcon.toolTip = param1;
         },"rankingIcon.toolTip");
         result[36] = binding;
         binding = new Binding(this,function():Boolean
         {
            return isDominionStatType;
         },function(param1:Boolean):void
         {
            nexusHealthIconLeft.visible = param1;
         },"nexusHealthIconLeft.visible");
         result[37] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.getNexusHealthTooltip();
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            nexusHealthIconLeft.toolTip = param1;
         },"nexusHealthIconLeft.toolTip");
         result[38] = binding;
         binding = new Binding(this,function():Boolean
         {
            return isDominionStatType;
         },function(param1:Boolean):void
         {
            nexusHealthIconRight.visible = param1;
         },"nexusHealthIconRight.visible");
         result[39] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.getNexusHealthTooltip();
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            nexusHealthIconRight.toolTip = param1;
         },"nexusHealthIconRight.toolTip");
         result[40] = binding;
         binding = new Binding(this,function():Object
         {
            return OVERVIEW_SCOREBOARD_KDA_ICON;
         },function(param1:Object):void
         {
            _EndOfGameStatsView_Image13.source = param1;
         },"_EndOfGameStatsView_Image13.source");
         result[41] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !isDominionStatType;
         },function(param1:Boolean):void
         {
            _EndOfGameStatsView_Image13.visible = param1;
         },"_EndOfGameStatsView_Image13.visible");
         result[42] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getStatResourceString(RawStatType.CHAMPION_KILLS,"Kills") + "/" + RiotResourceLoader.getStatResourceString(RawStatType.DEATHS,"Deaths") + "/" + RiotResourceLoader.getStatResourceString(RawStatType.ASSISTS,"Assists");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _EndOfGameStatsView_Image13.toolTip = param1;
         },"_EndOfGameStatsView_Image13.toolTip");
         result[43] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("endOfGame_grid_header","Grid");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            gridParentCanvas.label = param1;
         },"gridParentCanvas.label");
         result[44] = binding;
         binding = new Binding(this,function():Number
         {
            return eogViews.width;
         },function(param1:Number):void
         {
            gridParentCanvas.width = param1;
         },"gridParentCanvas.width");
         result[45] = binding;
         binding = new Binding(this,function():Number
         {
            return eogViews.height;
         },function(param1:Number):void
         {
            gridParentCanvas.height = param1;
         },"gridParentCanvas.height");
         result[46] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("endOfGame_graph_header","Graph");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _EndOfGameStatsView_Canvas9.label = param1;
         },"_EndOfGameStatsView_Canvas9.label");
         result[47] = binding;
         binding = new Binding(this,function():EndOfGameStatsController
         {
            return this.endOfGameStatsController;
         },function(param1:EndOfGameStatsController):void
         {
            eogGraph.endOfGameStatsController = param1;
         },"eogGraph.endOfGameStatsController");
         result[48] = binding;
         binding = new Binding(this,function():Object
         {
            return this.eogViews;
         },function(param1:Object):void
         {
            eogTabBar.dataProvider = param1;
         },"eogTabBar.dataProvider");
         result[49] = binding;
         binding = new Binding(this,function():Number
         {
            return enableShareEndOfGameButton ? 648 : 686;
         },function(param1:Number):void
         {
            teamCanvas.height = param1;
         },"teamCanvas.height");
         result[50] = binding;
         binding = new Binding(this,function():Object
         {
            return CHAT_PANEL_BACKGROUND;
         },function(param1:Object):void
         {
            _EndOfGameStatsView_Image14.source = param1;
         },"_EndOfGameStatsView_Image14.source");
         result[51] = binding;
         binding = new Binding(this,function():Object
         {
            return CHAT_TEXTURED_BACKGROUND;
         },function(param1:Object):void
         {
            _EndOfGameStatsView_Image15.source = param1;
         },"_EndOfGameStatsView_Image15.source");
         result[52] = binding;
         binding = new Binding(this,function():Number
         {
            return teamStatsViewHeight * 2;
         },function(param1:Number):void
         {
            _EndOfGameStatsView_Image15.height = param1;
         },"_EndOfGameStatsView_Image15.height");
         result[53] = binding;
         binding = new Binding(this,function():Number
         {
            return teamStatsViewHeight;
         },function(param1:Number):void
         {
            friendlyTeamStats.height = param1;
         },"friendlyTeamStats.height");
         result[54] = binding;
         binding = new Binding(this,function():IList
         {
            return endOfGameStatsController.endOfGameStats.teamPlayerParticipantStats;
         },function(param1:IList):void
         {
            friendlyTeamStats.dataProvider = param1;
         },"friendlyTeamStats.dataProvider");
         result[55] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = 10 + teamStatsViewHeight;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            enemyTeamStats.setStyle("top",param1);
         },"enemyTeamStats.top");
         result[56] = binding;
         binding = new Binding(this,function():Number
         {
            return teamStatsViewHeight;
         },function(param1:Number):void
         {
            enemyTeamStats.height = param1;
         },"enemyTeamStats.height");
         result[57] = binding;
         binding = new Binding(this,function():IList
         {
            return endOfGameStatsController.endOfGameStats.otherTeamPlayerParticipantStats;
         },function(param1:IList):void
         {
            enemyTeamStats.dataProvider = param1;
         },"enemyTeamStats.dataProvider");
         result[58] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = enemyTeamStats.y + enemyTeamStats.height + 1;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            endOfGameChat.setStyle("top",param1);
         },"endOfGameChat.top");
         result[59] = binding;
         binding = new Binding(this,function():Object
         {
            return CHAT_TEXTURED_BACKGROUND;
         },function(param1:Object):void
         {
            endOfGameChatBackground.source = param1;
         },"endOfGameChatBackground.source");
         result[60] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_showStats_playAgainButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            playAgain_btn.label = param1;
         },"playAgain_btn.label");
         result[61] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_showStats_playAgainButton_tooltip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            playAgain_btn.toolTip = param1;
         },"playAgain_btn.toolTip");
         result[62] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.endOfGameStatsController.allowedToPlayAgain;
         },function(param1:Boolean):void
         {
            playAgain_btn.enabled = param1;
         },"playAgain_btn.enabled");
         result[63] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.endOfGameStatsController.overrideHomeButtonLabel == null;
         },function(param1:Boolean):void
         {
            playAgain_btn.visible = param1;
         },"playAgain_btn.visible");
         result[64] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("endOfGame_shareGameButton_shareGameLabel","Share Match");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            shareGame_btn.label = param1;
         },"shareGame_btn.label");
         result[65] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("endOfGame_shareGameButton_shareGameTooltip","View match details online.");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            shareGame_btn.toolTip = param1;
         },"shareGame_btn.toolTip");
         result[66] = binding;
         binding = new Binding(this,function():Boolean
         {
            return enableShareEndOfGameButton;
         },function(param1:Boolean):void
         {
            shareGame_btn.visible = param1;
         },"shareGame_btn.visible");
         result[67] = binding;
         binding = new Binding(this,function():Boolean
         {
            return enableShareEndOfGameButton;
         },function(param1:Boolean):void
         {
            shareGame_btn.includeInLayout = param1;
         },"shareGame_btn.includeInLayout");
         result[68] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_showStats_returnToLobbyButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            returnToLobby_btn.label = param1;
         },"returnToLobby_btn.label");
         result[69] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_showStats_returnToLobbyButton_tooltip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            returnToLobby_btn.toolTip = param1;
         },"returnToLobby_btn.toolTip");
         result[70] = binding;
         binding = new Binding(this,function():Number
         {
            return enableShareEndOfGameButton ? 78 : 39;
         },function(param1:Number):void
         {
            returnToLobby_btn.height = param1;
         },"returnToLobby_btn.height");
         result[71] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.endOfGameStatsController.overrideHomeButtonLabel == null;
         },function(param1:Boolean):void
         {
            returnToLobby_btn.visible = param1;
         },"returnToLobby_btn.visible");
         result[72] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.endOfGameStatsController.overrideHomeButtonLabel;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            overrideBack_btn.label = param1;
         },"overrideBack_btn.label");
         result[73] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.endOfGameStatsController.overrideHomeButtonLabel != null;
         },function(param1:Boolean):void
         {
            overrideBack_btn.visible = param1;
         },"overrideBack_btn.visible");
         result[74] = binding;
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get topRow() : ConstraintRow
      {
         return this._868055995topRow;
      }
      
      private function _EndOfGameStatsView_ConstraintRow2_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.bottomRow = _loc1_;
         _loc1_.percentHeight = 67;
         _loc1_.initialized(this,"bottomRow");
         return _loc1_;
      }
      
      public function set nexusHealthIconRight(param1:Image) : void
      {
         var _loc2_:Object = this._597162968nexusHealthIconRight;
         if(_loc2_ !== param1)
         {
            this._597162968nexusHealthIconRight = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"nexusHealthIconRight",_loc2_,param1));
         }
      }
      
      public function set playAgain_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._1354751959playAgain_btn;
         if(_loc2_ !== param1)
         {
            this._1354751959playAgain_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playAgain_btn",_loc2_,param1));
         }
      }
      
      public function set limitedIPTimeLeftLabel(param1:Label) : void
      {
         var _loc2_:Object = this._743604255limitedIPTimeLeftLabel;
         if(_loc2_ !== param1)
         {
            this._743604255limitedIPTimeLeftLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"limitedIPTimeLeftLabel",_loc2_,param1));
         }
      }
      
      public function ___EndOfGameStatsView_Canvas1_hide(param1:FlexEvent) : void
      {
         this.onHide();
      }
      
      private function tweakLayout() : void
      {
         var _loc10_:Number = NaN;
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         var _loc7_:Number = 0;
         var _loc8_:Boolean = true;
         var _loc9_:Boolean = true;
         if(this.LAYOUT_MODE & LAYOUT_MODE_CONTEXTUAL_EDUCATION_TIPS)
         {
            _loc4_ += 70;
            _loc2_ += -7;
            _loc3_ += -15;
            _loc7_ += -20;
            _loc6_ += 12;
            _loc9_ = false;
            _loc8_ = false;
         }
         else if(this.LAYOUT_MODE & LAYOUT_MODE_REROLLS)
         {
            _loc2_ += -9;
            _loc3_ += -23;
         }
         _loc10_ = _loc4_ - _loc5_;
         var _loc11_:Number = _loc10_ + _loc6_;
         this.gameResultLabel.y = 10 + _loc1_;
         this.IPBreakdown.y = 75 + _loc2_;
         this.ipOverlay.y = 70 + _loc2_;
         this.ipGainDisplay.y = 76 + _loc2_;
         this.XPBreakdown.y = 130 + _loc3_;
         this.xpOverlay.y = 125 + _loc3_;
         this.XPDisplay.y = 131 + _loc3_;
         this.xpGainDisplay.y = 131 + _loc3_;
         this.eogRewards.y = 126 + _loc3_;
         this.gameModeDisplay.setVisible(_loc9_);
         this.normalRankedDisplay.setStyle("top",47 + _loc7_);
         this.winsNumber.setStyle("bottom",7 + _loc10_);
         this.lossesNumber.setStyle("bottom",7 + _loc10_);
         this.winsNumber.setVisible(_loc8_);
         this.lossesNumber.setVisible(_loc8_);
         this.limitedIPTimeIcon.setStyle("bottom",9 + _loc11_);
         this.limitedIPTimeLeftLabel.setStyle("bottom",6 + _loc11_);
         this.firstWinIcon.setStyle("bottom",(this.limitedIPTimeIcon.visible ? 37 : 9) + _loc11_);
         this.firstWinTimeLabel.setStyle("bottom",(this.limitedIPTimeIcon.visible ? 34 : 6) + _loc11_);
         this.contextualTipCanvas.height = _loc4_;
         this.RerollBreakdown.visible = this.rerollOverlay.visible = this.rerollDisplay.visible = this.rerollGainDisplay.visible = this.LAYOUT_MODE & LAYOUT_MODE_REROLLS;
      }
      
      public function set xpGainDisplay(param1:Label) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._1075140139xpGainDisplay;
         if(_loc2_ !== param1)
         {
            this._1075140139xpGainDisplay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"xpGainDisplay",_loc2_,param1));
         }
      }
      
      public function __eogViews_change(param1:IndexChangedEvent) : void
      {
         this.onViewChange(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get limitedIPTimeIcon() : Image
      {
         return this._1057212487limitedIPTimeIcon;
      }
      
      private function setupEndOfGameRewardsMessages() : void
      {
         this.eogRewards.visible = this.endOfGameStatsController.endOfGameAlertParser.hasRewards();
      }
      
      [Bindable(event="propertyChange")]
      public function get satFadeOut() : SaturationFade
      {
         return this._522112108satFadeOut;
      }
      
      private function isRerollServiceEnabled() : Boolean
      {
         return Boolean(this.endOfGameStatsController.endOfGameStats.rerollEnabled) && Boolean(this.endOfGameStatsController.rerollProvider.getRerollEnabled());
      }
      
      [Bindable(event="propertyChange")]
      public function get satFadeIn() : SaturationFade
      {
         return this._1817957447satFadeIn;
      }
      
      public function set xpOverlay(param1:Canvas) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._348423736xpOverlay;
         if(_loc2_ !== param1)
         {
            this._348423736xpOverlay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"xpOverlay",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get blueFilter() : GlowFilter
      {
         return this._416760718blueFilter;
      }
      
      [Bindable(event="propertyChange")]
      public function get nexusHealthIconLeft() : Image
      {
         return this._1366027387nexusHealthIconLeft;
      }
      
      private function onChampImageLoadComplete(param1:Event) : void
      {
         var _loc2_:SWFLoader = param1.target as SWFLoader;
         var _loc3_:int = int(_loc2_.contentWidth);
         var _loc4_:int = int(_loc2_.contentHeight);
         if(_loc3_ % 4)
         {
            _loc3_ += 4 - _loc3_ % 4;
         }
         if(_loc4_ % 4)
         {
            _loc4_ += 4 - _loc4_ % 4;
         }
         var _loc5_:BitmapData = new BitmapData(_loc3_,_loc4_,false,0);
         _loc5_.draw(_loc2_.content,new Matrix());
         this.championImage.source = new Bitmap(_loc5_,"auto",true);
         this.fadeIn.play([this.championImage]);
      }
      
      public function set leftColumn(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._1655307837leftColumn;
         if(_loc2_ !== param1)
         {
            this._1655307837leftColumn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leftColumn",_loc2_,param1));
         }
      }
      
      public function set topRow(param1:ConstraintRow) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._868055995topRow;
         if(_loc2_ !== param1)
         {
            this._868055995topRow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"topRow",_loc2_,param1));
         }
      }
      
      public function set limitedIPTimeIcon(param1:Image) : void
      {
         var _loc2_:Object = this._1057212487limitedIPTimeIcon;
         if(_loc2_ !== param1)
         {
            this._1057212487limitedIPTimeIcon = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"limitedIPTimeIcon",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rightColumn() : ConstraintColumn
      {
         return this._873431918rightColumn;
      }
      
      public function resetView() : void
      {
         this.needsShow = true;
         this.eogViews.selectedIndex = 0;
         this.gridParentCanvas.removeAllChildren();
         this.removeEventListener(Event.ENTER_FRAME,this.updatefirstWinSeconds);
         if(this.eogGraph)
         {
            this.eogGraph.endOfGameStatsController = null;
         }
         if(this.saveReplayButton != null)
         {
            this.saveReplayButton.removeFromParent();
            this.saveReplayButton = null;
         }
         if(this.contextualEducationDisplay != null && this.contextualEducationContainerAdapter != null)
         {
            this.contextualEducationDisplay.setVisible(false);
            this.contextualEducationContainerAdapter.removeChild(this.contextualEducationDisplay);
         }
         this.championImage.source = null;
         this.championImage.alpha = 0;
      }
      
      private function _EndOfGameStatsView_ConstraintRow1_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.topRow = _loc1_;
         _loc1_.percentHeight = 33;
         _loc1_.initialized(this,"topRow");
         return _loc1_;
      }
      
      private function mainPanelReady() : void
      {
         this.mainPanel.addChild(this.teamOverall);
         this.mainPanel.addChild(this.enemyOverall);
      }
      
      [Bindable(event="propertyChange")]
      public function get allChat() : Canvas
      {
         return this._912668519allChat;
      }
      
      [Bindable(event="propertyChange")]
      public function get endOfGameChat() : Canvas
      {
         return this._1582693220endOfGameChat;
      }
      
      private function showRankedEloResult(param1:int, param2:int, param3:Boolean) : void
      {
         if(!param3 || param1 <= 0)
         {
            this.normalRankedDisplayText.htmlText = RiotResourceLoader.getString("practiceGame_showStats_gameType_rankedUnranked","**Ranked");
         }
         else if(param2 < 0)
         {
            this.normalRankedDisplayText.htmlText = RiotResourceLoader.getString("practiceGame_showStats_gameType_rankedShowEloNegative","**Ranked",[param1,Math.abs(param2)]);
         }
         else
         {
            this.normalRankedDisplayText.htmlText = RiotResourceLoader.getString("practiceGame_showStats_gameType_rankedShowEloPositive","**Ranked",[param1,Math.abs(param2)]);
         }
      }
      
      public function set gameModeDisplay(param1:Label) : void
      {
         var _loc2_:Object = this._1253918131gameModeDisplay;
         if(_loc2_ !== param1)
         {
            this._1253918131gameModeDisplay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameModeDisplay",_loc2_,param1));
         }
      }
      
      public function set eogGraph(param1:EndOfGameGraph) : void
      {
         var _loc2_:Object = this._1618256303eogGraph;
         if(_loc2_ !== param1)
         {
            this._1618256303eogGraph = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"eogGraph",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get ipGainDisplay() : Label
      {
         return this._1181217948ipGainDisplay;
      }
      
      public function set satFadeIn(param1:SaturationFade) : void
      {
         var _loc2_:Object = this._1817957447satFadeIn;
         if(_loc2_ !== param1)
         {
            this._1817957447satFadeIn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"satFadeIn",_loc2_,param1));
         }
      }
      
      private function updateOverallScores() : void
      {
         var _loc2_:PlayerStat = null;
         var _loc3_:PlayerStat = null;
         var _loc4_:PlayerStat = null;
         var _loc5_:PlayerStat = null;
         if(this.endOfGameStatsController.localPlayer == null)
         {
            this.teamOverall.setStyle("fillColors",GradientTextField.BLUE_COLORS);
            this.enemyOverall.setStyle("fillColors",GradientTextField.PURPLE_COLORS);
         }
         else
         {
            this.teamOverall.setStyle("fillColors",GradientTextField.GREEN_COLORS);
            this.enemyOverall.setStyle("fillColors",GradientTextField.RED_COLORS);
         }
         var _loc1_:Boolean = GameStatsType.DOMINION == this.endOfGameStatsController.getCurrentStatsType();
         if(_loc1_)
         {
            _loc2_ = PlayerStat.findStat(RawStatType.VICTORY_POINT_TOTAL,this.endOfGameStatsController.endOfGameStats.teamPlayerParticipantStats[0].statistics,true);
            if(_loc2_)
            {
               this.teamOverall.text = _loc2_.value.toString();
            }
            else
            {
               this.teamOverall.text = "";
            }
            if(this.endOfGameStatsController.endOfGameStats.otherTeamPlayerParticipantStats.length > 0)
            {
               _loc2_ = PlayerStat.findStat(RawStatType.VICTORY_POINT_TOTAL,this.endOfGameStatsController.endOfGameStats.otherTeamPlayerParticipantStats[0].statistics,true);
               if(_loc2_)
               {
                  this.enemyOverall.text = _loc2_.value.toString();
               }
               else
               {
                  this.enemyOverall.text = "0";
               }
            }
            else
            {
               this.enemyOverall.text = "0";
            }
         }
         else
         {
            _loc3_ = PlayerStat.findStat(RawStatType.CHAMPION_KILLS,this.endOfGameStatsController.combinedTeamStats[0].statistics);
            _loc4_ = PlayerStat.findStat(RawStatType.DEATHS,this.endOfGameStatsController.combinedTeamStats[0].statistics);
            _loc5_ = PlayerStat.findStat(RawStatType.ASSISTS,this.endOfGameStatsController.combinedTeamStats[0].statistics);
            if(Boolean(_loc3_) && Boolean(_loc4_) && Boolean(_loc5_))
            {
               this.teamOverall.text = _loc3_.value.toString() + "/" + _loc4_.value.toString() + "/" + _loc5_.value.toString();
            }
            _loc3_ = PlayerStat.findStat(RawStatType.CHAMPION_KILLS,this.endOfGameStatsController.combinedTeamStats[1].statistics);
            _loc4_ = PlayerStat.findStat(RawStatType.DEATHS,this.endOfGameStatsController.combinedTeamStats[1].statistics);
            _loc5_ = PlayerStat.findStat(RawStatType.ASSISTS,this.endOfGameStatsController.combinedTeamStats[1].statistics);
            if(Boolean(_loc3_) && Boolean(_loc4_) && Boolean(_loc5_))
            {
               this.enemyOverall.text = _loc3_.value.toString() + "/" + _loc4_.value.toString() + "/" + _loc5_.value.toString();
            }
            else
            {
               this.enemyOverall.text = "0/0/0";
            }
         }
      }
      
      public function set purpleFilter(param1:GlowFilter) : void
      {
         var _loc2_:Object = this._1076167252purpleFilter;
         if(_loc2_ !== param1)
         {
            this._1076167252purpleFilter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"purpleFilter",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get IPBreakdown() : HBox
      {
         return this._763144006IPBreakdown;
      }
      
      [Bindable(event="propertyChange")]
      public function get mapNameDisplay() : Label
      {
         return this._1171872581mapNameDisplay;
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeIn() : Fade
      {
         return this._1282133823fadeIn;
      }
      
      [Bindable(event="propertyChange")]
      public function get potentialIpEarned() : int
      {
         return this._1392722108potentialIpEarned;
      }
      
      private function onReturnToLobbyButtonClicked(param1:MouseEvent) : void
      {
         this.endOfGameStatsController.returnToLobby();
         this.handleEndOfGameStatsViewExit();
      }
      
      private function handleIpEarned(param1:PlayerStat) : void
      {
         var _loc3_:String = null;
         if(this.endOfGameStatsController.endOfGameStats.basePoints > 0)
         {
            if(Boolean(param1) && param1.value == 1)
            {
               _loc3_ = IpBreakdownEvent.IP_TYPE_BASE_WIN;
            }
            else
            {
               _loc3_ = IpBreakdownEvent.IP_TYPE_BASE_LOST;
            }
            this.ipSegmentArray.push(this.IPBreakdown.addChild(this.createIpSegment("basePoints",_loc3_)));
         }
         if(this.endOfGameStatsController.endOfGameStats.firstWinBonus > 0)
         {
            this.ipSegmentArray.push(this.IPBreakdown.addChild(this.createIpSegment("firstWinBonus",IpBreakdownEvent.IP_TYPE_FIRST_WIN_BONUS)));
         }
         if(this.endOfGameStatsController.endOfGameStats.queueBonusEarned > 0)
         {
            this.ipSegmentArray.push(this.IPBreakdown.addChild(this.createIpSegment("queueBonusEarned",IpBreakdownEvent.IP_TYPE_QUEUE_BONUS)));
         }
         var _loc2_:Boolean = GameStatsType.DOMINION == this.endOfGameStatsController.getCurrentStatsType();
         if(_loc2_)
         {
            if(this.endOfGameStatsController.endOfGameStats.odinBonusIp > 0)
            {
               this.ipSegmentArray.push(this.IPBreakdown.addChild(this.createIpSegment("odinBonusIp",IpBreakdownEvent.IP_TYPE_ODIN_BONUS)));
            }
         }
         if(this.endOfGameStatsController.endOfGameStats.loyaltyBoostIpEarned > 0)
         {
            this.ipSegmentArray.push(this.IPBreakdown.addChild(this.createIpSegment("loyaltyBoostIpEarned",IpBreakdownEvent.IP_TYPE_BOOST_LOYALTY)));
         }
         if(this.endOfGameStatsController.endOfGameStats.locationBoostIpEarned > 0)
         {
            this.ipSegmentArray.push(this.IPBreakdown.addChild(this.createIpSegment("locationBoostIpEarned",IpBreakdownEvent.IP_TYPE_BOOST_LOCATION)));
         }
         if(this.endOfGameStatsController.endOfGameStats.boostIpEarned > 0)
         {
            this.ipSegmentArray.push(this.IPBreakdown.addChild(this.createIpSegment("boostIpEarned",IpBreakdownEvent.IP_TYPE_BOOST)));
         }
         if(this.endOfGameStatsController.endOfGameStats.boostIpEarned == 0 && this.endOfGameStatsController.potentialBoostIp > 0)
         {
            this.ipSegmentArray.push(this.IPBreakdown.addChild(this.createIpSegment("potentialBoostIp",IpBreakdownEvent.IP_TYPE_BOOST_DISABLED,true)));
         }
      }
      
      public function set satFadeOut(param1:SaturationFade) : void
      {
         var _loc2_:Object = this._522112108satFadeOut;
         if(_loc2_ !== param1)
         {
            this._522112108satFadeOut = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"satFadeOut",_loc2_,param1));
         }
      }
      
      private function _EndOfGameStatsView_GlowFilter5_i() : GlowFilter
      {
         var _loc1_:GlowFilter = new GlowFilter();
         this.purpleFilter = _loc1_;
         _loc1_.color = 11403519;
         _loc1_.alpha = 0.8;
         return _loc1_;
      }
      
      private function setupIpBar() : void
      {
         this.IPBreakdown.removeAllChildren();
         this.ipSegmentArray = [];
         this.potentialIpEarned = this.endOfGameStatsController.endOfGameStats.ipEarned;
         this.ipGainDisplay.text = RiotResourceLoader.getString("endOfGame_ip_label","IP",[this.potentialIpEarned.toString()]);
         if(this.endOfGameStatsController.endOfGameStats.boostIpEarned <= 0)
         {
            this.potentialIpEarned += this.endOfGameStatsController.potentialBoostIp;
         }
         var _loc1_:PlayerStat = PlayerStat.findStat(RawStatType.WIN,this.endOfGameStatsController.localPlayer.statistics,true);
         this._noIPXPrewardAlert = null;
         if(this.potentialIpEarned == 0)
         {
            this.handleZeroIpEarned();
         }
         else
         {
            this.handleIpEarned(_loc1_);
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get isDominionStatType() : Boolean
      {
         return this._268058841isDominionStatType;
      }
      
      public function set blueFilter(param1:GlowFilter) : void
      {
         var _loc2_:Object = this._416760718blueFilter;
         if(_loc2_ !== param1)
         {
            this._416760718blueFilter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"blueFilter",_loc2_,param1));
         }
      }
      
      public function set firstWinTimeLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1434484347firstWinTimeLabel;
         if(_loc2_ !== param1)
         {
            this._1434484347firstWinTimeLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"firstWinTimeLabel",_loc2_,param1));
         }
      }
      
      private function onTeamSkinRentalChanged(param1:ISignal, param2:TeamSkinRentalDTO) : void
      {
         param1.remove(this.onTeamSkinRentalChanged);
         this.showTeamSkinRental(param2);
      }
      
      [Bindable(event="propertyChange")]
      public function get rerollGainDisplay() : Label
      {
         return this._801401613rerollGainDisplay;
      }
      
      public function set championImage(param1:Image) : void
      {
         var _loc2_:Object = this._204468622championImage;
         if(_loc2_ !== param1)
         {
            this._204468622championImage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championImage",_loc2_,param1));
         }
      }
      
      public function set nexusHealthIconLeft(param1:Image) : void
      {
         var _loc2_:Object = this._1366027387nexusHealthIconLeft;
         if(_loc2_ !== param1)
         {
            this._1366027387nexusHealthIconLeft = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"nexusHealthIconLeft",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rerollOverlay() : Canvas
      {
         return this._81172224rerollOverlay;
      }
      
      [Bindable(event="propertyChange")]
      public function get gridParentCanvas() : Canvas
      {
         return this._1050744568gridParentCanvas;
      }
      
      [Bindable(event="propertyChange")]
      public function get leaveFilter() : GlowFilter
      {
         return this._1653546737leaveFilter;
      }
      
      public function set winFilter(param1:GlowFilter) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._1081725324winFilter;
         if(_loc2_ !== param1)
         {
            this._1081725324winFilter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"winFilter",_loc2_,param1));
         }
      }
      
      private function _EndOfGameStatsView_GlowFilter4_i() : GlowFilter
      {
         var _loc1_:GlowFilter = new GlowFilter();
         this.blueFilter = _loc1_;
         _loc1_.color = 40191;
         _loc1_.alpha = 0.8;
         return _loc1_;
      }
      
      private function setupIpAndXpAndReroll() : void
      {
         if(this.isRerollServiceEnabled())
         {
            this.LAYOUT_MODE |= LAYOUT_MODE_REROLLS;
         }
         this.setupIpBar();
         this.setupXpBar();
         this.setupRerollBar();
      }
      
      public function set rightColumn(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._873431918rightColumn;
         if(_loc2_ !== param1)
         {
            this._873431918rightColumn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rightColumn",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get ipOverlay() : Canvas
      {
         return this._1690436905ipOverlay;
      }
      
      private function onShareEndOfGameButtonClicked(param1:MouseEvent) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         var _loc2_:String = this.shareMatchHistoryUrlTemplate.getString();
         var _loc3_:String = ClientConfig.instance.locale.substr(0,2);
         var _loc4_:String = RiotResourceLoader.getString("endOfGame_shareGameButton_locale",_loc3_);
         if(_loc3_ != "" && _loc2_ != null)
         {
            _loc5_ = this.endOfGameStatsController.endOfGameStats.reportGameId ? Number(this.endOfGameStatsController.endOfGameStats.reportGameId) : Number(this.endOfGameStatsController.endOfGameStats.gameId);
            _loc6_ = Number(this.endOfGameStatsController.endOfGameStats.userId);
            _loc7_ = StringUtil.substitute(_loc2_,_loc5_,_loc6_,_loc3_);
            navigateToURL(new URLRequest(_loc7_),"_blank");
         }
      }
      
      private function onCreationComplete() : void
      {
         this.winsNumber.setStyle("horizontalCenter",-60);
         this.winsNumber.setStyle("bottom",7);
         this.winsNumber.setStyle("fontSize",26);
         this.winsNumber.setStyle("fillColors",GradientTextField.GOLD_COLORS);
         this.lossesNumber.setStyle("horizontalCenter",60);
         this.lossesNumber.setStyle("bottom",7);
         this.lossesNumber.setStyle("fontSize",26);
         this.lossesNumber.setStyle("fillColors",GradientTextField.SILVER_COLORS);
         this.gameResultLabel.setStyle("fontSize",38);
         this.gameResultLabel.setStyle("horizontalCenter",0);
         this.gameResultLabel.y = 10;
         this.teamOverall.y = 225;
         this.teamOverall.setStyle("horizontalCenter",-85);
         this.teamOverall.setStyle("fontSize",24);
         this.teamOverall.setStyle("fillColors",GradientTextField.GREEN_COLORS);
         this.enemyOverall.y = 225;
         this.enemyOverall.setStyle("horizontalCenter",85);
         this.enemyOverall.setStyle("fontSize",24);
         this.enemyOverall.setStyle("fillColors",GradientTextField.RED_COLORS);
      }
      
      public function set endOfGameChat(param1:Canvas) : void
      {
         var _loc2_:Object = this._1582693220endOfGameChat;
         if(_loc2_ !== param1)
         {
            this._1582693220endOfGameChat = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"endOfGameChat",_loc2_,param1));
         }
      }
      
      public function set allChat(param1:Canvas) : void
      {
         var _loc2_:Object = this._912668519allChat;
         if(_loc2_ !== param1)
         {
            this._912668519allChat = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"allChat",_loc2_,param1));
         }
      }
      
      public function set ipGainDisplay(param1:Label) : void
      {
         var _loc2_:Object = this._1181217948ipGainDisplay;
         if(_loc2_ !== param1)
         {
            this._1181217948ipGainDisplay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ipGainDisplay",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get enableAdvancedDetailsButton() : Boolean
      {
         return this._679945551enableAdvancedDetailsButton;
      }
      
      public function set XPDisplay(param1:Label) : void
      {
         var _loc2_:Object = this._885120682XPDisplay;
         if(_loc2_ !== param1)
         {
            this._885120682XPDisplay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"XPDisplay",_loc2_,param1));
         }
      }
      
      private function _EndOfGameStatsView_GlowFilter3_i() : GlowFilter
      {
         var _loc1_:GlowFilter = new GlowFilter();
         this.leaveFilter = _loc1_;
         _loc1_.color = 8912896;
         _loc1_.alpha = 0.8;
         return _loc1_;
      }
      
      public function set RerollBreakdown(param1:HBox) : void
      {
         var _loc2_:Object = this._1459115697RerollBreakdown;
         if(_loc2_ !== param1)
         {
            this._1459115697RerollBreakdown = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"RerollBreakdown",_loc2_,param1));
         }
      }
      
      public function __overviewContainer_creationComplete(param1:FlexEvent) : void
      {
         this.overviewContainerReady();
      }
      
      public function set mapNameDisplay(param1:Label) : void
      {
         var _loc2_:Object = this._1171872581mapNameDisplay;
         if(_loc2_ !== param1)
         {
            this._1171872581mapNameDisplay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapNameDisplay",_loc2_,param1));
         }
      }
      
      public function set potentialIpEarned(param1:int) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._1392722108potentialIpEarned;
         if(_loc2_ !== param1)
         {
            this._1392722108potentialIpEarned = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"potentialIpEarned",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rerollDisplay() : Label
      {
         return this._1613087374rerollDisplay;
      }
      
      public function set IPBreakdown(param1:HBox) : void
      {
         var _loc2_:Object = this._763144006IPBreakdown;
         if(_loc2_ !== param1)
         {
            this._763144006IPBreakdown = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"IPBreakdown",_loc2_,param1));
         }
      }
      
      private function onShow() : void
      {
         var _loc2_:PlayerStat = null;
         var _loc3_:int = 0;
         var _loc4_:SWFLoader = null;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:uint = 0;
         var _loc10_:String = null;
         var _loc11_:IContextualEducationProvider = null;
         var _loc12_:PlayerParticipantStatsSummary = null;
         if(!this.needsShow)
         {
            return;
         }
         this.useAlternateColor = false;
         this.LAYOUT_MODE = 0;
         this.initializeView();
         this.isDominionStatType = GameStatsType.DOMINION == this.endOfGameStatsController.getCurrentStatsType();
         var _loc1_:GameFlowVariant = GameFlowVariantFactory.instance.getVariant(this.endOfGameStatsController.endOfGameStats.gameMutators,this.endOfGameStatsController.endOfGameStats.gameMode);
         if(this.endOfGameStatsController.localPlayer != null)
         {
            this.overviewContainer.setStyle("backgroundImage",OVERVIEW_SKIN_MASK);
            this.IPBreakdown.visible = this.ipOverlay.visible = this.ipGainDisplay.visible = this.XPBreakdown.visible = this.xpOverlay.visible = this.XPDisplay.visible = this.xpGainDisplay.visible = true;
            this.RerollBreakdown.visible = this.rerollOverlay.visible = this.rerollDisplay.visible = this.rerollGainDisplay.visible = this.isRerollServiceEnabled();
            this.nexusHealthIconLeft.source = OVERVIEW_SCOREBOARD_NEXUS_HEALTH_GREEN;
            this.nexusHealthIconRight.source = OVERVIEW_SCOREBOARD_NEXUS_HEALTH_RED;
            _loc2_ = PlayerStat.findStat(RawStatType.WIN,this.endOfGameStatsController.localPlayer.statistics,true);
            _loc3_ = int(this.endOfGameStatsController.endOfGameStats.skinIndex);
            if(_loc3_ < 0)
            {
               _loc3_ = 0;
            }
            _loc4_ = new SWFLoader();
            _loc4_.addEventListener(Event.COMPLETE,this.onChampImageLoadComplete,false,0,true);
            _loc4_.load(ChampionImages.getSplashPath(this.endOfGameStatsController.localPlayer.skinName,_loc3_));
            this.setupIpAndXpAndReroll();
            _loc5_ = GameStatsType.DOMINION == this.endOfGameStatsController.getCurrentStatsType();
            if(_loc5_)
            {
               if(this.endOfGameStatsController.endOfGameStats.teamPlayerParticipantStats[0] === this.endOfGameStatsController.localPlayer)
               {
                  this.rankingIcon.source = OVERVIEW_RANKING_GOLD;
               }
               else if(this.endOfGameStatsController.endOfGameStats.teamPlayerParticipantStats[1] === this.endOfGameStatsController.localPlayer)
               {
                  this.rankingIcon.source = OVERVIEW_RANKING_SILVER;
               }
               else if(this.endOfGameStatsController.endOfGameStats.teamPlayerParticipantStats[2] === this.endOfGameStatsController.localPlayer)
               {
                  this.rankingIcon.source = OVERVIEW_RANKING_BRONZE;
               }
               else
               {
                  this.rankingIcon.source = null;
               }
            }
            else
            {
               this.rankingIcon.source = null;
            }
            this.winsNumber.visible = this.lossesNumber.visible = true;
            this.winsNumber.text = this.endOfGameStatsController.winsLossesStats[0].value;
            this.winsNumber.toolTip = RiotResourceLoader.getString("end_of_game_wins_tooltip","Wins");
            this.lossesNumber.text = this.endOfGameStatsController.winsLossesStats[1].value;
            this.lossesNumber.toolTip = RiotResourceLoader.getString("end_of_game_losses_tooltip","Losses");
            this.gameResultLabel.y = 10;
            _loc6_ = Boolean(_loc2_) && _loc2_.value == 1;
            _loc7_ = Boolean(this.endOfGameStatsController.localPlayer.leaver);
            _loc8_ = Boolean(this.endOfGameStatsController.endOfGameStats.invalid);
            _loc9_ = uint(GameStatusLogicTable.determineGameResult(_loc6_,_loc7_,_loc8_));
            _loc10_ = null;
            switch(_loc9_)
            {
               case GameStatusLogicTable.LEAVER:
                  this.gameResultLabel.setStyle("fillColors",GradientTextField.RED_COLORS);
                  _loc10_ = "endOfGame_leave";
                  this.gameResultLabel.filters = [this.leaveFilter];
                  this.winsNumber.filters = null;
                  this.lossesNumber.filters = null;
                  break;
               case GameStatusLogicTable.LOSS_P:
                  this.gameResultLabel.setStyle("fillColors",GradientTextField.SILVER_COLORS);
                  _loc10_ = "endOfGame_invalid_defeat";
                  this.gameResultLabel.filters = [this.loseFilter];
                  this.winsNumber.filters = null;
                  this.lossesNumber.filters = null;
                  break;
               case GameStatusLogicTable.VICTORY:
                  this.gameResultLabel.setStyle("fillColors",GradientTextField.GOLD_COLORS);
                  _loc10_ = "endOfGame_victory";
                  this.gameResultLabel.filters = [this.winFilter];
                  if(!QueueType.isCoopVsAI(this.endOfGameStatsController.endOfGameStats.queueType) || this.endOfGameStatsController.endOfGameStats.queueType != QueueType.NONE)
                  {
                     this.winsNumber.filters = [this.winFilter];
                  }
                  else
                  {
                     this.winsNumber.filters = null;
                  }
                  this.lossesNumber.filters = null;
                  break;
               case GameStatusLogicTable.DEFEAT:
                  this.gameResultLabel.setStyle("fillColors",GradientTextField.SILVER_COLORS);
                  _loc10_ = "endOfGame_defeat";
                  this.gameResultLabel.filters = [this.loseFilter];
                  if(!QueueType.isCoopVsAI(this.endOfGameStatsController.endOfGameStats.queueType) || this.endOfGameStatsController.endOfGameStats.queueType != QueueType.NONE)
                  {
                     this.lossesNumber.filters = [this.loseFilter];
                  }
                  else
                  {
                     this.lossesNumber.filters = null;
                  }
                  this.winsNumber.filters = null;
            }
            if(_loc10_ != null)
            {
               this.gameResultLabel.text = _loc1_.getGameResultOverrideText("resources",_loc10_);
            }
            this.friendlyTeamStats.teamName.text = this.endOfGameStatsController.myTeamNameText;
            this.enemyTeamStats.teamName.text = this.endOfGameStatsController.otherTeamNameText;
            this.endOfGameChat.visible = true;
            this.playAgain_btn.visible = true;
            this.setupEndOfGameRewardsMessages();
            if(!this.isRerollServiceEnabled() && Boolean(this.endOfGameStatsController.prepareContextualTip()))
            {
               if(this.contextualEducationContainerAdapter == null)
               {
                  this.contextualEducationContainerAdapter = new DisplayAdapter(this.contextualTipCanvas);
               }
               _loc11_ = this.endOfGameStatsController.contextualEducationProvider;
               this.contextualEducationDisplay = _loc11_.getContextualEducationDisplay();
               if(Boolean(this.contextualEducationDisplay) && Boolean(this.contextualEducationContainerAdapter))
               {
                  this.contextualEducationContainerAdapter.addChild(this.contextualEducationDisplay);
                  this.contextualEducationDisplay.setVisible(true);
                  this.LAYOUT_MODE |= LAYOUT_MODE_CONTEXTUAL_EDUCATION_TIPS;
               }
            }
         }
         else
         {
            this.overviewContainer.setStyle("backgroundImage",OVERVIEW_OBSERVER_SKIN);
            this.nexusHealthIconLeft.source = OVERVIEW_SCOREBOARD_NEXUS_HEALTH_BLUE;
            this.nexusHealthIconRight.source = OVERVIEW_SCOREBOARD_NEXUS_HEALTH_PURPLE;
            this.rankingIcon.source = null;
            this.firstWinTimeLabel.visible = false;
            this.firstWinIcon.visible = false;
            this.limitedIPTimeIcon.visible = false;
            this.limitedIPTimeLeftLabel.visible = false;
            this.IPBreakdown.visible = this.ipOverlay.visible = this.ipGainDisplay.visible = this.XPBreakdown.visible = this.xpOverlay.visible = this.XPDisplay.visible = this.xpGainDisplay.visible = this.RerollBreakdown.visible = this.rerollOverlay.visible = this.rerollDisplay.visible = this.rerollGainDisplay.visible = false;
            this.winsNumber.visible = false;
            this.lossesNumber.visible = false;
            _loc12_ = this.endOfGameStatsController.endOfGameStats.teamPlayerParticipantStats[0] as PlayerParticipantStatsSummary;
            _loc2_ = PlayerStat.findStat(RawStatType.WIN,_loc12_.statistics,true);
            this.gameResultLabel.y = 80;
            if(Boolean(_loc2_) && _loc2_.value == 1)
            {
               this.gameResultLabel.setStyle("fillColors",GradientTextField.BLUE_COLORS);
               this.gameResultLabel.text = RiotResourceLoader.getString("endOfGame_blue_team_victory","**BLUE TEAM WINS");
               this.gameResultLabel.filters = [this.blueFilter];
            }
            else
            {
               this.gameResultLabel.setStyle("fillColors",GradientTextField.PURPLE_COLORS);
               this.gameResultLabel.text = RiotResourceLoader.getString("endOfGame_purple_team_victory","**PURPLE TEAM WINS");
               this.gameResultLabel.filters = [this.purpleFilter];
            }
            this.friendlyTeamStats.teamName.text = RiotResourceLoader.getString("endofgame_stats_blueteam","Blue Team");
            this.enemyTeamStats.teamName.text = RiotResourceLoader.getString("endofgame_stats_purpleteam","Purple Team");
            this.endOfGameChat.visible = false;
            this.playAgain_btn.visible = false;
         }
         this.tweakLayout();
         this.updateOverallScores();
         if(this.endOfGameStatsController.gameMap)
         {
            this.mapNameDisplay.text = RiotResourceLoader.getMapResourceString("displayname",this.endOfGameStatsController.gameMap.mapId,this.endOfGameStatsController.gameMap.displayName);
         }
         else
         {
            this.mapNameDisplay.text = "**Invalid Map";
         }
         this.gameModeDisplay.text = _loc1_.getGameFlowName();
         this.endOfGameStatsController.rerollStatsSet.add(this.onRerollStatsReceived);
         this.seriesDisplay1.visible = this.seriesDisplay2.visible = this.seriesDisplay3.visible = this.seriesDisplay4.visible = this.seriesDisplay5.visible = false;
         if(Boolean(ClientConfig.instance.leagueServiceEnabled) && Boolean(this.endOfGameStatsController.endOfGameStats.ranked))
         {
            this.leagueDisplay.visible = true;
            if(this.endOfGameStatsController.leaguesUpdateModel == null)
            {
               this.leagueDisplay.text = RiotResourceLoader.getString("endofgame_leagues_eogDisplay_loading","**ZOMG LEAGUES LOADING...:");
               this.endOfGameStatsController.leaguesUpdateInfoChangedSignal.add(this.onLeagueUpdateRecieved);
            }
            else
            {
               this.onLeagueUpdateRecieved();
            }
         }
         else
         {
            this.leagueDisplay.visible = false;
            this.showNonLeagueDisplay();
         }
         this.gameTimeDisplay.text = this.endOfGameStatsController.gameTime;
         this.endOfGameScoreboard.show();
         if(this.eogGraph)
         {
            this.eogGraph.endOfGameStatsController = this.endOfGameStatsController;
         }
         this.onShareMatchHistoryConfigChange();
         if(this.isExtendedTeamSize(this.endOfGameStatsController.endOfGameStats.teamPlayerParticipantStats) || this.isExtendedTeamSize(this.endOfGameStatsController.endOfGameStats.otherTeamPlayerParticipantStats))
         {
            this.teamStatsViewHeight = TEAM_STATS_HEIGHT_EXTENDED;
         }
         else
         {
            this.teamStatsViewHeight = TEAM_STATS_HEIGHT_STANDARD;
         }
         this.showTeamSkinRental(GameConfig.instance.currentTeamSkinRental);
         GameConfig.instance.currentTeamSkinRentalChanged.remove(this.onTeamSkinRentalChanged);
         GameConfig.instance.currentTeamSkinRentalChanged.add(this.onTeamSkinRentalChanged);
      }
      
      private function setupXpBar() : void
      {
         this.XPBreakdown.removeAllChildren();
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         if(this.endOfGameStatsController.endOfGameStats.experienceEarned >= this.endOfGameStatsController.levelUpInfo.totalPointsNeededForNextLevel)
         {
            _loc1_ = 0;
            _loc2_ = Number(this.endOfGameStatsController.endOfGameStats.experienceEarned);
         }
         else
         {
            _loc1_ = this.endOfGameStatsController.levelUpInfo.totalExperiencePoints - this.endOfGameStatsController.endOfGameStats.experienceEarned;
            _loc2_ = Number(this.endOfGameStatsController.endOfGameStats.experienceEarned);
         }
         var _loc3_:XPBarSegment = new XPBarSegment();
         _loc3_.height = this.XPBreakdown.height + 1;
         if(this.endOfGameStatsController.levelUpInfo.currentLevel == LevelUpInfo.MAX_LEVEL)
         {
            _loc3_.displayXP = -1;
            _loc3_.width = this.XPBreakdown.width;
            this.xpGainDisplay.visible = false;
            _loc3_.setStyle("styleName","xpBarMaxLevel");
            _loc3_.toolTipText = "";
         }
         else
         {
            _loc3_.displayXP = _loc1_;
            _loc3_.width = this.XPBreakdown.width * (_loc1_ / this.endOfGameStatsController.levelUpInfo.totalPointsNeededForNextLevel);
            this.xpGainDisplay.visible = true;
            _loc3_.setStyle("styleName","xpBar");
            _loc3_.toolTipText = RiotResourceLoader.getString("endofgame_overview_totalpreviousxp",_loc1_.toString(),[_loc1_]);
         }
         this.XPBreakdown.addChild(_loc3_);
         if(_loc2_ > 0 && this.endOfGameStatsController.levelUpInfo.currentLevel != LevelUpInfo.MAX_LEVEL)
         {
            _loc3_ = new XPBarSegment();
            _loc3_.height = this.XPBreakdown.height + 1;
            _loc3_.width = this.XPBreakdown.width * (_loc2_ / this.endOfGameStatsController.levelUpInfo.totalPointsNeededForNextLevel);
            _loc3_.setStyle("styleName","xpBarBoost");
            _loc3_.displayXP = _loc2_;
            this.XPBreakdown.addChild(_loc3_);
            _loc3_.toolTipText = RiotResourceLoader.getString("endofgame_overview_totalxp",_loc2_.toString(),[_loc2_]) + (this.endOfGameStatsController.endOfGameStats.locationBoostXpEarned > 0 ? "\n" + RiotResourceLoader.getString("endofgame_xpbreakdowntooltip_locationBoostXpEarned","Special location XP boost",[this.endOfGameStatsController.endOfGameStats.locationBoostXpEarned]) : "") + (this.endOfGameStatsController.endOfGameStats.loyaltyBoostXpEarned > 0 ? "\n" + RiotResourceLoader.getString("endofgame_xpbreakdowntooltip_loyaltyBoostXpEarned","Special loyalty XP boost",[this.endOfGameStatsController.endOfGameStats.loyaltyBoostXpEarned]) : "");
         }
         if(this.endOfGameStatsController.levelUpInfo.currentLevel != LevelUpInfo.MAX_LEVEL)
         {
            _loc3_ = new XPBarSegment();
            _loc3_.height = this.XPBreakdown.height + 1;
            _loc3_.width = this.XPBreakdown.width * (1 - (_loc2_ + _loc1_) / this.endOfGameStatsController.levelUpInfo.totalPointsNeededForNextLevel);
            _loc3_.setStyle("styleName","xpBarTNL");
            _loc3_.displayXP = _loc2_;
            this.XPBreakdown.addChild(_loc3_);
            this.xpGainDisplay.text = RiotResourceLoader.getString("endOfGame_xp_label","XP",[_loc2_.toString()]);
            _loc3_.toolTipText = RiotResourceLoader.getString("endofgame_overview_xpToNextLevel",this.endOfGameStatsController.levelUpInfo.pointsNeededToLevelUp.toString(),[this.endOfGameStatsController.levelUpInfo.pointsNeededToLevelUp.toString()]);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get contextualTipCanvas() : UIComponent
      {
         return this._430026366contextualTipCanvas;
      }
      
      public function set fadeIn(param1:Fade) : void
      {
         var _loc2_:Object = this._1282133823fadeIn;
         if(_loc2_ !== param1)
         {
            this._1282133823fadeIn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeIn",_loc2_,param1));
         }
      }
      
      public function __returnToLobby_btn_click(param1:MouseEvent) : void
      {
         this.onReturnToLobbyButtonClicked(param1);
      }
      
      private function _EndOfGameStatsView_GlowFilter2_i() : GlowFilter
      {
         var _loc1_:GlowFilter = new GlowFilter();
         this.loseFilter = _loc1_;
         _loc1_.color = 7829367;
         _loc1_.alpha = 0.8;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get enemyTeamStats() : EndOfGameStatsTeam
      {
         return this._364261990enemyTeamStats;
      }
      
      [Bindable(event="propertyChange")]
      public function get shareGame_btn() : SoundEffectButton
      {
         return this._1848699506shareGame_btn;
      }
      
      private function isExtendedTeamSize(param1:ArrayCollection) : Boolean
      {
         return param1 != null && param1.length > MaxViewableTeamSize.TEAM_SIZE_NORMAL_VIEW_LIMIT;
      }
      
      [Bindable(event="propertyChange")]
      public function get firstWinIcon() : Image
      {
         return this._1269534117firstWinIcon;
      }
      
      public function set normalRankedDisplay(param1:HBox) : void
      {
         var _loc2_:Object = this._637373136normalRankedDisplay;
         if(_loc2_ !== param1)
         {
            this._637373136normalRankedDisplay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"normalRankedDisplay",_loc2_,param1));
         }
      }
      
      private function set isDominionStatType(param1:Boolean) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._268058841isDominionStatType;
         if(_loc2_ !== param1)
         {
            this._268058841isDominionStatType = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isDominionStatType",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rankingIcon() : Image
      {
         return this._1914859983rankingIcon;
      }
      
      public function set returnToLobby_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._615655144returnToLobby_btn;
         if(_loc2_ !== param1)
         {
            this._615655144returnToLobby_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"returnToLobby_btn",_loc2_,param1));
         }
      }
      
      public function set endOfGameChatBackground(param1:Image) : void
      {
         var _loc2_:Object = this._1967381782endOfGameChatBackground;
         if(_loc2_ !== param1)
         {
            this._1967381782endOfGameChatBackground = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"endOfGameChatBackground",_loc2_,param1));
         }
      }
      
      private function _EndOfGameStatsView_GlowFilter1_i() : GlowFilter
      {
         var _loc1_:GlowFilter = new GlowFilter();
         this.winFilter = _loc1_;
         _loc1_.color = 8545037;
         _loc1_.alpha = 0.8;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get endOfGameStatsController() : EndOfGameStatsController
      {
         return this._1164646953endOfGameStatsController;
      }
      
      [Bindable(event="propertyChange")]
      public function get endOfGameScoreboard() : EndOfGameScoreboard
      {
         return this._1696229848endOfGameScoreboard;
      }
      
      private function handlePendingKudosRetrieved(param1:Object) : void
      {
         var _loc2_:PendingKudos = param1 as PendingKudos;
         KudosFactoryProxy.getInstance().createKudosContextAlertCommand(_loc2_,false).execute();
      }
      
      public function set loseFilter(param1:GlowFilter) : void
      {
         var _loc2_:Object = this._1595022061loseFilter;
         if(_loc2_ !== param1)
         {
            this._1595022061loseFilter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"loseFilter",_loc2_,param1));
         }
      }
      
      public function set overrideBack_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._2032065264overrideBack_btn;
         if(_loc2_ !== param1)
         {
            this._2032065264overrideBack_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"overrideBack_btn",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameTimeDisplay() : Label
      {
         return this._1144184291gameTimeDisplay;
      }
      
      public function set rerollGainDisplay(param1:Label) : void
      {
         var _loc2_:Object = this._801401613rerollGainDisplay;
         if(_loc2_ !== param1)
         {
            this._801401613rerollGainDisplay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rerollGainDisplay",_loc2_,param1));
         }
      }
      
      public function updatefirstWinSeconds(param1:Event) : void
      {
         this.firstWinSeconds = Math.ceil(this.session.firstWinOfDayTimeRemaining * 0.001);
         this.practiceRewardSeconds = Math.ceil(this.session.customGameRewardResetTimeRemaining * 0.001);
         if(this.firstWinSeconds <= 0)
         {
            if(this.firstWinAvailable == false)
            {
               this.firstWinTimeLabel.text = RiotResourceLoader.getString("endOfGame_reward_available");
               this.satFadeIn.play([this.firstWinIcon]);
               this.firstWinIcon.toolTip = RiotResourceLoader.getString("endOfGame_first_win_tooltip","first win");
               this.firstWinAvailable = true;
            }
         }
         else
         {
            this.firstWinTimeLabel.text = DateUtil.secondsToTimeString(this.firstWinSeconds);
            this.firstWinIcon.toolTip = RiotResourceLoader.getString("endOfGame_next_first_win","next first win",[DateUtil.secondsToTimeString(this.firstWinSeconds)]);
         }
         if(this.limitedIPTimeLeftLabel.visible)
         {
            if(Boolean(this.endOfGameStatsController) && Boolean(this.endOfGameStatsController.endOfGameStats))
            {
               if(QueueType.isCoopVsAI(this.endOfGameStatsController.endOfGameStats.queueType))
               {
                  this.limitedIPTimeIcon.toolTip = RiotResourceLoader.getString("endOfGame_reward_time_left_co_op_vs_ai",null,[this.endOfGameStatsController.endOfGameStats.coOpVsAiMinutesLeftToday,DateUtil.milisecondsToTimeString(this.endOfGameStatsController.endOfGameStats.coOpVsAiMsecsUntilReset)]);
               }
               else
               {
                  this.limitedIPTimeIcon.toolTip = RiotResourceLoader.getString("endOfGame_reward_time_left_custom",null,[this.endOfGameStatsController.endOfGameStats.customMinutesLeftToday,DateUtil.milisecondsToTimeString(this.endOfGameStatsController.endOfGameStats.customMsecsUntilReset)]);
               }
            }
         }
         if(this.practiceRewardSeconds <= 0)
         {
            if(this.practiceRewardAvailable == false)
            {
               this.satFadeIn.play([this.limitedIPTimeIcon]);
               this.practiceRewardAvailable = true;
            }
         }
      }
      
      private function showNormalGameTypeDisplay() : void
      {
         this.normalRankedDisplayText.htmlText = RiotResourceLoader.getString("practiceGame_showStats_gameType_normal","**Normal");
      }
      
      private function onViewChange(param1:IndexChangedEvent) : void
      {
         var _loc2_:EndOfGameGrid = null;
         if(this.eogViews.selectedChild == this.gridParentCanvas && this.gridParentCanvas.numChildren == 0)
         {
            _loc2_ = new EndOfGameGrid();
            this.gridParentCanvas.addChild(_loc2_);
            _loc2_.x = 8;
            _loc2_.y = 8;
            _loc2_.width = this.gridParentCanvas.width - 16;
            _loc2_.height = this.gridParentCanvas.height - 16;
            _loc2_.endOfGameStatsController = this.endOfGameStatsController;
         }
      }
      
      private function _EndOfGameStatsView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.eogTabBar.y + this.eogTabBar.height - 1;
         _loc1_ = RiotResourceLoader.getString("endOfGame_overview_header","Overview");
         _loc1_ = this.championImage.source != null;
         _loc1_ = !this.leagueDisplay.visible;
         _loc1_ = this.gameModeDisplay.y + this.gameModeDisplay.height;
         _loc1_ = this.seriesDisplay1.visible ? this.seriesDisplay1.y + this.seriesDisplay1.height : this.normalRankedDisplay.y + this.normalRankedDisplay.height;
         _loc1_ = this.normalRankedDisplay.y + this.normalRankedDisplay.height + 2;
         _loc1_ = MINISERIES_NULL_ICON;
         _loc1_ = this.normalRankedDisplay.y + this.normalRankedDisplay.height + 2;
         _loc1_ = MINISERIES_NULL_ICON;
         _loc1_ = this.normalRankedDisplay.y + this.normalRankedDisplay.height + 2;
         _loc1_ = MINISERIES_NULL_ICON;
         _loc1_ = this.normalRankedDisplay.y + this.normalRankedDisplay.height + 2;
         _loc1_ = MINISERIES_NULL_ICON;
         _loc1_ = this.normalRankedDisplay.y + this.normalRankedDisplay.height + 2;
         _loc1_ = MINISERIES_NULL_ICON;
         _loc1_ = this.ipOverlay.x + 5;
         _loc1_ = this.ipOverlay.x + this.ipOverlay.width + 3;
         _loc1_ = this.ipOverlay.x + 5;
         _loc1_ = [new GlowFilter(0,0.7)];
         _loc1_ = this.ipOverlay.x + 5;
         _loc1_ = RiotResourceLoader.getString("BuddyListTooltip_summonerLevel","Level 9000",[this.endOfGameStatsController.levelUpInfo.currentLevel]);
         _loc1_ = this.xpOverlay.x + this.xpOverlay.width + 3;
         _loc1_ = this.ipOverlay.x + 5;
         _loc1_ = [new GlowFilter(0,0.7)];
         _loc1_ = this.ipOverlay.x + 5;
         _loc1_ = this.rerollOverlay.x + this.rerollOverlay.width + 3;
         _loc1_ = OVERVIEW_PRACTICE_XP_ICON;
         _loc1_ = OVERVIEW_FIRST_WIN_ICON;
         _loc1_ = this.limitedIPTimeIcon.visible ? 37 : 9;
         _loc1_ = this.limitedIPTimeIcon.visible ? 34 : 6;
         _loc1_ = RiotResourceLoader.getString("endOfGame_shareGameButton_detailsButtonLabel","View Advanced Details");
         _loc1_ = RiotResourceLoader.getString("endOfGame_shareGameButton_detailsButtonTooltip","View more match details online.");
         _loc1_ = this.enableAdvancedDetailsButton;
         _loc1_ = this.enableAdvancedDetailsButton;
         _loc1_ = null;
         _loc1_ = RiotResourceLoader.getString("end_of_game_overview_ranking_icon_tooltip","Overall rank on your team");
         _loc1_ = this.isDominionStatType;
         _loc1_ = this.getNexusHealthTooltip();
         _loc1_ = this.isDominionStatType;
         _loc1_ = this.getNexusHealthTooltip();
         _loc1_ = OVERVIEW_SCOREBOARD_KDA_ICON;
         _loc1_ = !this.isDominionStatType;
         _loc1_ = RiotResourceLoader.getStatResourceString(RawStatType.CHAMPION_KILLS,"Kills") + "/" + RiotResourceLoader.getStatResourceString(RawStatType.DEATHS,"Deaths") + "/" + RiotResourceLoader.getStatResourceString(RawStatType.ASSISTS,"Assists");
         _loc1_ = RiotResourceLoader.getString("endOfGame_grid_header","Grid");
         _loc1_ = this.eogViews.width;
         _loc1_ = this.eogViews.height;
         _loc1_ = RiotResourceLoader.getString("endOfGame_graph_header","Graph");
         _loc1_ = this.endOfGameStatsController;
         _loc1_ = this.eogViews;
         _loc1_ = this.enableShareEndOfGameButton ? 648 : 686;
         _loc1_ = CHAT_PANEL_BACKGROUND;
         _loc1_ = CHAT_TEXTURED_BACKGROUND;
         _loc1_ = this.teamStatsViewHeight * 2;
         _loc1_ = this.teamStatsViewHeight;
         _loc1_ = this.endOfGameStatsController.endOfGameStats.teamPlayerParticipantStats;
         _loc1_ = 10 + this.teamStatsViewHeight;
         _loc1_ = this.teamStatsViewHeight;
         _loc1_ = this.endOfGameStatsController.endOfGameStats.otherTeamPlayerParticipantStats;
         _loc1_ = this.enemyTeamStats.y + this.enemyTeamStats.height + 1;
         _loc1_ = CHAT_TEXTURED_BACKGROUND;
         _loc1_ = resourceManager.getString("resources","practiceGame_showStats_playAgainButtonLabel");
         _loc1_ = resourceManager.getString("resources","practiceGame_showStats_playAgainButton_tooltip");
         _loc1_ = this.endOfGameStatsController.allowedToPlayAgain;
         _loc1_ = this.endOfGameStatsController.overrideHomeButtonLabel == null;
         _loc1_ = RiotResourceLoader.getString("endOfGame_shareGameButton_shareGameLabel","Share Match");
         _loc1_ = RiotResourceLoader.getString("endOfGame_shareGameButton_shareGameTooltip","View match details online.");
         _loc1_ = this.enableShareEndOfGameButton;
         _loc1_ = this.enableShareEndOfGameButton;
         _loc1_ = resourceManager.getString("resources","practiceGame_showStats_returnToLobbyButtonLabel");
         _loc1_ = resourceManager.getString("resources","practiceGame_showStats_returnToLobbyButton_tooltip");
         _loc1_ = this.enableShareEndOfGameButton ? 78 : 39;
         _loc1_ = this.endOfGameStatsController.overrideHomeButtonLabel == null;
         _loc1_ = this.endOfGameStatsController.overrideHomeButtonLabel;
         _loc1_ = this.endOfGameStatsController.overrideHomeButtonLabel != null;
      }
      
      public function set rerollOverlay(param1:Canvas) : void
      {
         var _loc2_:Object = this._81172224rerollOverlay;
         if(_loc2_ !== param1)
         {
            this._81172224rerollOverlay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rerollOverlay",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get XPBreakdown() : HBox
      {
         return this._1947610615XPBreakdown;
      }
      
      public function set gridParentCanvas(param1:Canvas) : void
      {
         var _loc2_:Object = this._1050744568gridParentCanvas;
         if(_loc2_ !== param1)
         {
            this._1050744568gridParentCanvas = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gridParentCanvas",_loc2_,param1));
         }
      }
      
      public function ___EndOfGameStatsView_Canvas1_show(param1:FlexEvent) : void
      {
         this.onShow();
      }
      
      [Bindable(event="propertyChange")]
      public function get teamCanvas() : Canvas
      {
         return this._1971344875teamCanvas;
      }
      
      public function set advancedGameDetails_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._1853405429advancedGameDetails_btn;
         if(_loc2_ !== param1)
         {
            this._1853405429advancedGameDetails_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"advancedGameDetails_btn",_loc2_,param1));
         }
      }
      
      public function set overviewContainer(param1:Canvas) : void
      {
         var _loc2_:Object = this._1093953784overviewContainer;
         if(_loc2_ !== param1)
         {
            this._1093953784overviewContainer = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"overviewContainer",_loc2_,param1));
         }
      }
      
      public function __playAgain_btn_click(param1:MouseEvent) : void
      {
         this.onPlayAgainButtonClicked(param1);
      }
      
      [Bindable(event="propertyChange")]
      private function get teamStatsViewHeight() : int
      {
         return this._2013929970teamStatsViewHeight;
      }
      
      public function set leaveFilter(param1:GlowFilter) : void
      {
         var _loc2_:Object = this._1653546737leaveFilter;
         if(_loc2_ !== param1)
         {
            this._1653546737leaveFilter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leaveFilter",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get xpGainDisplay() : Label
      {
         return this._1075140139xpGainDisplay;
      }
      
      private function onAnimationEnd(param1:EffectEvent) : void
      {
         (param1.target as IPBarSegment).removeEventListener(EffectEvent.EFFECT_END,this.onAnimationEnd);
         this.timer.start();
      }
      
      [Bindable(event="propertyChange")]
      public function get xpOverlay() : Canvas
      {
         return this._348423736xpOverlay;
      }
      
      [Bindable(event="propertyChange")]
      public function get leftColumn() : ConstraintColumn
      {
         return this._1655307837leftColumn;
      }
      
      private function getNexusHealthTooltip() : String
      {
         if(this.endOfGameStatsController.endOfGameStats == null)
         {
            return "";
         }
         var _loc1_:GameFlowVariant = GameFlowVariantFactory.instance.getVariant(this.endOfGameStatsController.endOfGameStats.gameMutators,this.endOfGameStatsController.endOfGameStats.gameMode);
         return _loc1_.getNexusFinalHealthTooltip();
      }
      
      private function createNewEogChat() : void
      {
         var _loc1_:UIComponent = new UIComponent();
         this.endOfGameChat.addChild(_loc1_);
         var _loc2_:DisplayAdapter = new DisplayAdapter(_loc1_);
         this.newChat = this.chatViewProvider.getChatRoomView(_loc2_);
         this.newChat.setExplicitSize(this.endOfGameChat.width - 1,this.endOfGameChat.height - 1);
         this.endOfGameChat.addEventListener(ResizeEvent.RESIZE,this.resizeHandler);
         _loc2_.addChild(this.newChat);
         this.endOfGameChatBackground.setStyle("bottom",0);
      }
      
      [Bindable(event="propertyChange")]
      public function get gameModeDisplay() : Label
      {
         return this._1253918131gameModeDisplay;
      }
      
      public function initializeView() : void
      {
         this.addEventListener(Event.ENTER_FRAME,this.updatefirstWinSeconds);
         this.firstWinSeconds = Math.ceil(this.session.firstWinOfDayTimeRemaining * 0.001);
         this.practiceRewardSeconds = Math.ceil(this.session.customGameRewardResetTimeRemaining * 0.001);
         this.firstWinTimeLabel.visible = this.endOfGameStatsController.endOfGameStats.queueType != QueueType.NONE;
         this.firstWinIcon.visible = this.endOfGameStatsController.endOfGameStats.queueType != QueueType.NONE;
         if(this.firstWinSeconds <= 0)
         {
            this.firstWinTimeLabel.text = RiotResourceLoader.getString("endOfGame_reward_available");
            this.firstWinIcon.toolTip = RiotResourceLoader.getString("endOfGame_first_win_tooltip","first win");
            this.satFadeIn.play([this.firstWinIcon]);
            this.firstWinAvailable = true;
         }
         else
         {
            this.firstWinAvailable = false;
            this.firstWinTimeLabel.text = DateUtil.secondsToTimeString(this.firstWinSeconds);
            this.firstWinIcon.toolTip = RiotResourceLoader.getString("endOfGame_first_win_tooltip","first win");
            this.satFadeOut.play([this.firstWinIcon]);
         }
         if(this.endOfGameStatsController.endOfGameStats.queueType == QueueType.NONE && this.endOfGameStatsController.endOfGameStats.customMinutesLeftToday >= 0)
         {
            this.limitedIPTimeLeftLabel.visible = true;
            this.limitedIPTimeIcon.visible = true;
            this.practiceRewardSeconds = this.endOfGameStatsController.endOfGameStats.customMsecsUntilReset / 1000;
            this.limitedIPTimeLeftLabel.text = RiotResourceLoader.getString("endOfGame_reward_time_minutes","minutes",[this.endOfGameStatsController.endOfGameStats.customMinutesLeftToday.toString()]);
            this.limitedIPTimeIcon.toolTip = RiotResourceLoader.getString("endOfGame_reward_time_left_custom","Time left",[this.endOfGameStatsController.endOfGameStats.customMinutesLeftToday,DateUtil.milisecondsToTimeString(this.endOfGameStatsController.endOfGameStats.customMsecsUntilReset)]);
            if(this.endOfGameStatsController.endOfGameStats.customMinutesLeftToday <= 0)
            {
               this.practiceRewardAvailable = false;
               this.satFadeOut.play([this.limitedIPTimeIcon]);
            }
            else
            {
               this.practiceRewardAvailable = true;
               this.satFadeIn.play([this.limitedIPTimeIcon]);
            }
         }
         else if(Boolean(QueueType.isCoopVsAI(this.endOfGameStatsController.endOfGameStats.queueType)) && this.endOfGameStatsController.endOfGameStats.coOpVsAiMinutesLeftToday >= 0)
         {
            this.limitedIPTimeLeftLabel.visible = true;
            this.limitedIPTimeIcon.visible = true;
            this.practiceRewardSeconds = this.endOfGameStatsController.endOfGameStats.coOpVsAiMsecsUntilReset / 1000;
            this.limitedIPTimeLeftLabel.text = RiotResourceLoader.getString("endOfGame_reward_time_minutes","minutes",[this.endOfGameStatsController.endOfGameStats.coOpVsAiMinutesLeftToday.toString()]);
            this.limitedIPTimeIcon.toolTip = RiotResourceLoader.getString("endOfGame_reward_time_left_co_op_vs_ai","Time left",[this.endOfGameStatsController.endOfGameStats.coOpVsAiMinutesLeftToday,DateUtil.milisecondsToTimeString(this.endOfGameStatsController.endOfGameStats.coOpVsAiMsecsUntilReset)]);
            if(this.endOfGameStatsController.endOfGameStats.coOpVsAiMinutesLeftToday <= 0)
            {
               this.practiceRewardAvailable = false;
               this.satFadeOut.play([this.limitedIPTimeIcon]);
            }
            else
            {
               this.practiceRewardAvailable = true;
               this.satFadeIn.play([this.limitedIPTimeIcon]);
            }
         }
         else
         {
            this.limitedIPTimeIcon.visible = false;
            this.limitedIPTimeLeftLabel.visible = false;
         }
         this.eogRewards.visible = false;
         this.shareMatchHistoryEnabled = DynamicClientConfigManager.getConfiguration(ShareMatchHistoryConfig.NAMESPACE,ShareMatchHistoryConfig.SHARE_BUTTON_ENABLED,false,this.onShareMatchHistoryConfigChange);
         this.shareMatchHistoryUrlTemplate = DynamicClientConfigManager.getConfiguration(ShareMatchHistoryConfig.NAMESPACE,ShareMatchHistoryConfig.SHARE_GAME_URL_TEMPLATE,"",this.onShareMatchHistoryConfigChange);
         this.advancedDetailsEnabled = DynamicClientConfigManager.getConfiguration(ShareMatchHistoryConfig.NAMESPACE,ShareMatchHistoryConfig.ADVANCED_DETAILS_BUTTON_ENABLED,false,this.onShareMatchHistoryConfigChange);
         this.advancedDetailsUrlTemplate = DynamicClientConfigManager.getConfiguration(ShareMatchHistoryConfig.NAMESPACE,ShareMatchHistoryConfig.ADVANCED_GAME_DETAILS_URL_TEMPLATE,"",this.onShareMatchHistoryConfigChange);
      }
      
      [Bindable(event="propertyChange")]
      public function get eogGraph() : EndOfGameGraph
      {
         return this._1618256303eogGraph;
      }
      
      public function set ipOverlay(param1:Canvas) : void
      {
         var _loc2_:Object = this._1690436905ipOverlay;
         if(_loc2_ !== param1)
         {
            this._1690436905ipOverlay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ipOverlay",_loc2_,param1));
         }
      }
      
      public function __endOfGameChat_creationComplete(param1:FlexEvent) : void
      {
         this.onEndOfGameChatCreation();
      }
      
      private function set replaysForEndOfGameStatsEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._2033792215replaysForEndOfGameStatsEnabled;
         if(_loc2_ !== param1)
         {
            this._2033792215replaysForEndOfGameStatsEnabled = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"replaysForEndOfGameStatsEnabled",_loc2_,param1));
         }
      }
      
      private function _EndOfGameStatsView_ConstraintColumn3_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.rightColumn = _loc1_;
         _loc1_.width = 424;
         _loc1_.initialized(this,"rightColumn");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get purpleFilter() : GlowFilter
      {
         return this._1076167252purpleFilter;
      }
      
      private function createIpSegment(param1:String, param2:String, param3:Boolean = false) : IPBarSegment
      {
         var _loc4_:IPBarSegment = new IPBarSegment();
         _loc4_.height = this.IPBreakdown.height;
         if(param1 == null)
         {
            _loc4_.ipTotal = 0;
            _loc4_.width = this.IPBreakdown.width;
            _loc4_.ipGain = 0;
            _loc4_.ipType = IpBreakdownEvent.IP_TYPE_ZERO_EARNED;
            _loc4_.setStyle("styleName","ipBarBoostDisabled");
            return _loc4_;
         }
         if(!this.endOfGameStatsController.endOfGameStats.hasOwnProperty(param1))
         {
            if(this.endOfGameStatsController.hasOwnProperty(param1))
            {
               _loc4_.ipTotal = this.potentialIpEarned;
               _loc4_.totalWidth = this.IPBreakdown.width;
               _loc4_.ipGain = this.endOfGameStatsController[param1];
               _loc4_.ipType = param2;
               if(param3)
               {
                  _loc4_.setStyle("styleName","ipBarBoostDisabled");
               }
               else
               {
                  _loc4_.setStyle("styleName",this.useAlternateColor ? "ipBarAlternate" : "ipBar");
                  if(_loc4_.ipGain > 0)
                  {
                     this.useAlternateColor = !this.useAlternateColor;
                  }
               }
               return _loc4_;
            }
            return null;
         }
         _loc4_.ipTotal = this.potentialIpEarned;
         _loc4_.totalWidth = this.IPBreakdown.width;
         _loc4_.ipGain = this.endOfGameStatsController.endOfGameStats[param1];
         _loc4_.ipType = param2;
         if(param3)
         {
            _loc4_.setStyle("styleName","ipBarBoostDisabled");
         }
         else
         {
            _loc4_.setStyle("styleName",this.useAlternateColor ? "ipBarAlternate" : "ipBar");
            if(_loc4_.ipGain > 0)
            {
               this.useAlternateColor = !this.useAlternateColor;
            }
         }
         return _loc4_;
      }
      
      [Bindable(event="propertyChange")]
      public function get championImage() : Image
      {
         return this._204468622championImage;
      }
      
      [Bindable(event="propertyChange")]
      public function get firstWinTimeLabel() : Label
      {
         return this._1434484347firstWinTimeLabel;
      }
      
      [Bindable(event="propertyChange")]
      public function get winFilter() : GlowFilter
      {
         return this._1081725324winFilter;
      }
      
      public function set seriesDisplay1(param1:Image) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._533461830seriesDisplay1;
         if(_loc2_ !== param1)
         {
            this._533461830seriesDisplay1 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"seriesDisplay1",_loc2_,param1));
         }
      }
      
      public function set seriesDisplay2(param1:Image) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._533461831seriesDisplay2;
         if(_loc2_ !== param1)
         {
            this._533461831seriesDisplay2 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"seriesDisplay2",_loc2_,param1));
         }
      }
      
      public function __eogRewards_click(param1:MouseEvent) : void
      {
         this.onClickEOGRewards(param1);
      }
      
      public function set seriesDisplay4(param1:Image) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._533461833seriesDisplay4;
         if(_loc2_ !== param1)
         {
            this._533461833seriesDisplay4 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"seriesDisplay4",_loc2_,param1));
         }
      }
      
      public function set seriesDisplay5(param1:Image) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._533461834seriesDisplay5;
         if(_loc2_ !== param1)
         {
            this._533461834seriesDisplay5 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"seriesDisplay5",_loc2_,param1));
         }
      }
      
      public function set seriesDisplay3(param1:Image) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._533461832seriesDisplay3;
         if(_loc2_ !== param1)
         {
            this._533461832seriesDisplay3 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"seriesDisplay3",_loc2_,param1));
         }
      }
      
      private function set enableAdvancedDetailsButton(param1:Boolean) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._679945551enableAdvancedDetailsButton;
         if(_loc2_ !== param1)
         {
            this._679945551enableAdvancedDetailsButton = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enableAdvancedDetailsButton",_loc2_,param1));
         }
      }
      
      private function handleEndOfGameStatsViewExit() : void
      {
         if(ClientConfig.instance.kudosPullNotifications)
         {
            this.requestAndDisplayPendingKudos();
            this.kudosTotalsCache.clearCache();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get XPDisplay() : Label
      {
         return this._885120682XPDisplay;
      }
      
      private function _EndOfGameStatsView_ConstraintColumn2_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.midColumn = _loc1_;
         _loc1_.percentWidth = 100;
         _loc1_.initialized(this,"midColumn");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get RerollBreakdown() : HBox
      {
         return this._1459115697RerollBreakdown;
      }
      
      private function setupRerollBar() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:XPBarSegment = null;
         var _loc7_:Number = NaN;
         if(this.isRerollServiceEnabled())
         {
            _loc1_ = this.endOfGameStatsController.endOfGameStats.rerollEarned + this.endOfGameStatsController.endOfGameStats.rerollBonusEarned;
            _loc2_ = 0;
            _loc3_ = 0;
            _loc4_ = 0;
            _loc5_ = Number(this.endOfGameStatsController.rerollProvider.getRerollProgress());
            this.RerollBreakdown.removeAllChildren();
            this.rerollDisplay.text = RiotResourceLoader.getString("endOfGame_rerollPoints_bar_label","RerollPointsBarLabel",[this.endOfGameStatsController.rerollProvider.getRerollCount().toString(),this.endOfGameStatsController.rerollProvider.getMaxRerollCount().toString()]);
            if(_loc5_ < _loc1_)
            {
               _loc2_ = 0;
               _loc4_ = Math.min(this.endOfGameStatsController.endOfGameStats.rerollBonusEarned,_loc5_);
               _loc3_ = _loc5_ > this.endOfGameStatsController.endOfGameStats.rerollBonusEarned ? _loc5_ - this.endOfGameStatsController.endOfGameStats.rerollBonusEarned : 0;
            }
            else
            {
               _loc2_ = _loc5_ - _loc1_;
               _loc3_ = Number(this.endOfGameStatsController.endOfGameStats.rerollEarned);
               _loc4_ = Number(this.endOfGameStatsController.endOfGameStats.rerollBonusEarned);
            }
            _loc6_ = new XPBarSegment();
            _loc6_.height = this.RerollBreakdown.height + 1;
            if(this.endOfGameStatsController.rerollProvider.getRerollCount() == this.endOfGameStatsController.rerollProvider.getMaxRerollCount())
            {
               _loc6_.displayXP = -1;
               _loc6_.width = this.RerollBreakdown.width;
               this.rerollGainDisplay.visible = false;
               _loc6_.setStyle("styleName","rerollBarMaxLevel");
               _loc6_.toolTipText = "";
            }
            else
            {
               _loc6_.displayXP = _loc2_;
               _loc6_.width = this.RerollBreakdown.width * (_loc2_ / this.endOfGameStatsController.rerollProvider.getMaxRerollProgress());
               this.rerollGainDisplay.visible = true;
               _loc6_.setStyle("styleName","rerollBar");
               _loc6_.toolTipText = RiotResourceLoader.getString("endofgame_overview_totalPreviousRerollPoints",_loc2_.toString(),[_loc2_]);
            }
            this.RerollBreakdown.addChild(_loc6_);
            if(_loc3_ > 0 && this.endOfGameStatsController.rerollProvider.getRerollCount() != this.endOfGameStatsController.rerollProvider.getMaxRerollCount())
            {
               _loc6_ = new XPBarSegment();
               _loc6_.height = this.RerollBreakdown.height + 1;
               _loc6_.width = this.RerollBreakdown.width * (_loc3_ / this.endOfGameStatsController.rerollProvider.getMaxRerollProgress());
               _loc6_.setStyle("styleName","rerollBarBoost");
               _loc6_.displayXP = _loc3_;
               this.RerollBreakdown.addChild(_loc6_);
               _loc6_.toolTipText = RiotResourceLoader.getString("endofgame_overview_baseRerollPoints",_loc3_.toString(),[_loc3_]);
            }
            if(_loc4_ > 0 && this.endOfGameStatsController.rerollProvider.getRerollCount() != this.endOfGameStatsController.rerollProvider.getMaxRerollCount())
            {
               _loc6_ = new XPBarSegment();
               _loc6_.height = this.RerollBreakdown.height + 1;
               _loc6_.width = this.RerollBreakdown.width * (_loc4_ / this.endOfGameStatsController.rerollProvider.getMaxRerollProgress());
               _loc6_.setStyle("styleName","rerollBarBonusBoost");
               _loc6_.displayXP = _loc4_;
               this.RerollBreakdown.addChild(_loc6_);
               _loc6_.toolTipText = RiotResourceLoader.getString("endofgame_overview_bonusRerollPoints",_loc4_.toString(),[_loc4_]);
            }
            if(this.endOfGameStatsController.rerollProvider.getRerollCount() != this.endOfGameStatsController.rerollProvider.getMaxRerollCount())
            {
               _loc7_ = this.endOfGameStatsController.rerollProvider.getMaxRerollProgress() - _loc5_;
               _loc6_ = new XPBarSegment();
               _loc6_.height = this.RerollBreakdown.height + 1;
               _loc6_.width = this.RerollBreakdown.width * (_loc7_ / this.endOfGameStatsController.rerollProvider.getMaxRerollProgress());
               _loc6_.setStyle("styleName","rerollBarTNL");
               _loc6_.displayXP = _loc3_;
               this.RerollBreakdown.addChild(_loc6_);
               this.rerollGainDisplay.text = RiotResourceLoader.getString("endOfGame_rerollPoints_label","RerollPoints",[_loc1_.toString()]);
               _loc6_.toolTipText = RiotResourceLoader.getString("endofgame_overview_rerollPointsToNextLevel",_loc7_.toString(),[_loc7_.toString()]);
            }
         }
      }
      
      public function set normalRankedDisplayIcon(param1:Image) : void
      {
         var _loc2_:Object = this._2084678807normalRankedDisplayIcon;
         if(_loc2_ !== param1)
         {
            this._2084678807normalRankedDisplayIcon = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"normalRankedDisplayIcon",_loc2_,param1));
         }
      }
      
      public function set eogRewards(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._454164327eogRewards;
         if(_loc2_ !== param1)
         {
            this._454164327eogRewards = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"eogRewards",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get normalRankedDisplay() : HBox
      {
         return this._637373136normalRankedDisplay;
      }
      
      private function onLeagueUpdateRecieved() : void
      {
         var _loc1_:LeagueUpdateItem = null;
         var _loc2_:Boolean = false;
         var _loc3_:String = null;
         var _loc4_:String = null;
         _loc1_ = this.endOfGameStatsController.leaguesUpdateModel;
         this.seriesDisplay1.visible = this.seriesDisplay2.visible = this.seriesDisplay3.visible = this.seriesDisplay4.visible = this.seriesDisplay5.visible = false;
         switch(_loc1_.type)
         {
            case LeagueUpdateItem.NOT_YET_SEEDED:
               this.leagueDisplay.text = RiotResourceLoader.getString("endofgame_leagues_eogDisplay_notEnoughGames","**ZOMG PLAY MORE! >=D");
               break;
            case LeagueUpdateItem.LEAGUE_PROMOTED:
               this.leagueDisplay.text = RiotResourceLoader.getString("endofgame_leagues_eogDisplay_promoted","**ZOMG PROMOTED! =)");
               break;
            case LeagueUpdateItem.LEAGUE_DEMOTED:
               this.leagueDisplay.text = RiotResourceLoader.getString("endofgame_leagues_eogDisplay_demoted","**ZOMG DEMOTED! =(" + _loc1_.tier + _loc1_.rank,[RiotResourceLoader.getString("leagues_tier_" + _loc1_.tier,_loc1_.tier),RiotResourceLoader.getString("leagues_rank_" + _loc1_.rank,_loc1_.rank)]);
               break;
            case LeagueUpdateItem.MINISERIES_START:
               this.leagueDisplay.text = RiotResourceLoader.getString("endofgame_leagues_eogDisplay_seriesStart","**ZOMG STARTING SERIES! =D");
               break;
            case LeagueUpdateItem.MINISERIES_LOST:
               this.leagueDisplay.text = RiotResourceLoader.getString("endofgame_leagues_eogDisplay_divisionSeriesLost","**ZOMG SERIES LOST! >=(");
               break;
            case LeagueUpdateItem.MINISERIES_CANCEL:
               _loc2_ = _loc1_.miniSeries.target > 2;
               if(_loc2_)
               {
                  this.leagueDisplay.text = RiotResourceLoader.getString("endofgame_leagues_eogDisplay_promotionSeriesCanceled","**ZOMG SERIES CANCELED! =/");
               }
               else
               {
                  this.leagueDisplay.text = RiotResourceLoader.getString("endofgame_leagues_eogDisplay_seriesCanceled","**ZOMG SERIES CANCELED! =/");
               }
               break;
            case LeagueUpdateItem.LEAGUE_SEEDED:
            case LeagueUpdateItem.LEAGUE_POINTS_UPDATE:
               if(_loc1_.miniSeries == null)
               {
                  _loc3_ = "";
                  if(_loc1_.leaguePointsDelta > 0)
                  {
                     _loc3_ = "<font color=\'#00CC00\'>+";
                  }
                  else if(_loc1_.leaguePointsDelta < 0)
                  {
                     _loc3_ = "<font color=\'#EE0000\'>";
                  }
                  else
                  {
                     _loc3_ = "<font color=\'#FFFFFF\'>+";
                  }
                  _loc3_ += _loc1_.leaguePointsDelta.toString();
                  _loc3_ += "</font>";
                  _loc4_ = _loc1_.tier == "CHALLENGER" ? "" : RiotResourceLoader.getString("leagues_tier_" + _loc1_.rank,"**" + _loc1_.rank);
                  this.leagueDisplay.htmlText = RiotResourceLoader.getString("endofgame_leagues_eogDisplay_pointsUpdate","**ZOMG POINTS UPDATE! ^^ " + _loc1_.leaguePoints,[RiotResourceLoader.getString("leagues_rank_" + _loc1_.tier,"**" + _loc1_.tier),_loc4_,_loc1_.leaguePoints,_loc3_]);
               }
               else
               {
                  _loc2_ = _loc1_.miniSeries.target > 2;
                  if(_loc2_)
                  {
                     this.leagueDisplay.text = RiotResourceLoader.getString("endofgame_leagues_eogDisplay_promotionSeriesUpdate","**ZOMG SERIES UPDATE! ^^;");
                  }
                  else
                  {
                     this.leagueDisplay.text = RiotResourceLoader.getString("endofgame_leagues_eogDisplay_divisionUpdate","**ZOMG SERIES UPDATE! ^^;");
                  }
                  this.updateSeriesDisplayIcons(_loc2_,_loc1_.miniSeries.wins,_loc1_.miniSeries.losses);
               }
               break;
            case LeagueUpdateItem.QUEUE_DODGE:
         }
      }
      
      public function set eogViews(param1:ViewStack) : void
      {
         var _loc2_:Object = this._1604667535eogViews;
         if(_loc2_ !== param1)
         {
            this._1604667535eogViews = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"eogViews",_loc2_,param1));
         }
      }
      
      private function showNonLeagueDisplay() : void
      {
         this.normalRankedDisplayText.visible = this.normalRankedDisplayText.includeInLayout = true;
         this.normalRankedDisplayIcon.visible = this.normalRankedDisplayIcon.includeInLayout = false;
         if(this.endOfGameStatsController.endOfGameStats.myTeamInfo)
         {
            this.showRankedEloResult(this.endOfGameStatsController.endOfGameStats.elo,this.endOfGameStatsController.endOfGameStats.eloChange,this.endOfGameStatsController.endOfGameStats.myTeamStatus == TeamStatus.RANKED);
         }
         else if(this.endOfGameStatsController.endOfGameStats.ranked)
         {
            this.showRankedEloResult(this.endOfGameStatsController.endOfGameStats.elo,this.endOfGameStatsController.endOfGameStats.eloChange,this.endOfGameStatsController.showRankedElo);
         }
         else if(QueueType.isCoopVsAI(this.endOfGameStatsController.endOfGameStats.queueType))
         {
            this.showCoOpVsAIDisplay();
         }
         else
         {
            this.showNormalGameTypeDisplay();
         }
      }
      
      private function _EndOfGameStatsView_ConstraintColumn1_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.leftColumn = _loc1_;
         _loc1_.percentWidth = 23;
         _loc1_.initialized(this,"leftColumn");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get endOfGameChatBackground() : Image
      {
         return this._1967381782endOfGameChatBackground;
      }
      
      public function set rerollDisplay(param1:Label) : void
      {
         var _loc2_:Object = this._1613087374rerollDisplay;
         if(_loc2_ !== param1)
         {
            this._1613087374rerollDisplay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rerollDisplay",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get loseFilter() : GlowFilter
      {
         return this._1595022061loseFilter;
      }
      
      private function _EndOfGameStatsView_SaturationFade2_i() : SaturationFade
      {
         var _loc1_:SaturationFade = new SaturationFade();
         this.satFadeIn = _loc1_;
         _loc1_.duration = 1000;
         _loc1_.saturationFrom = 0;
         _loc1_.saturationTo = 1;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get returnToLobby_btn() : SoundEffectButton
      {
         return this._615655144returnToLobby_btn;
      }
      
      private function showCoOpVsAIDisplay() : void
      {
         var _loc1_:GameFlowVariant = GameFlowVariantFactory.instance.getVariant(this.endOfGameStatsController.endOfGameStats.gameMutators,this.endOfGameStatsController.endOfGameStats.gameMode);
         var _loc2_:String = _loc1_.getEndOfGameCoOpVsAiText(this.endOfGameStatsController.endOfGameStats.difficulty);
         this.normalRankedDisplayText.visible = this.normalRankedDisplayText.includeInLayout = _loc2_ != null;
         this.normalRankedDisplayText.htmlText = _loc2_;
         var _loc3_:String = _loc1_.getEndOfGameCoOpVsAiIcon(this.endOfGameStatsController.endOfGameStats.difficulty);
         this.normalRankedDisplayIcon.visible = this.normalRankedDisplayIcon.includeInLayout = _loc3_ != null;
         this.normalRankedDisplayIcon.source = ImagePackLookup.instance.getClassFromSwfRef(_loc3_);
      }
      
      [Bindable(event="propertyChange")]
      public function get overrideBack_btn() : SoundEffectButton
      {
         return this._2032065264overrideBack_btn;
      }
      
      private function onEndOfGameChatCreation() : void
      {
         ProviderLookup.getProvider(IChatViewProvider,this.onChatViewProvider);
      }
      
      public function set contextualTipCanvas(param1:UIComponent) : void
      {
         var _loc2_:Object = this._430026366contextualTipCanvas;
         if(_loc2_ !== param1)
         {
            this._430026366contextualTipCanvas = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"contextualTipCanvas",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get overviewContainer() : Canvas
      {
         return this._1093953784overviewContainer;
      }
      
      [Bindable(event="propertyChange")]
      public function get advancedGameDetails_btn() : SoundEffectButton
      {
         return this._1853405429advancedGameDetails_btn;
      }
      
      public function __mainPanel_creationComplete(param1:FlexEvent) : void
      {
         this.mainPanelReady();
      }
      
      private function onChatRoomChanged(param1:ChatRoom) : void
      {
         if(ClientConfig.instance.useNewEogChat)
         {
            this.newChat.setModel(param1);
         }
         else
         {
            this.oldChat.chatRoom = param1;
         }
      }
      
      public function set shareGame_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._1848699506shareGame_btn;
         if(_loc2_ !== param1)
         {
            this._1848699506shareGame_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"shareGame_btn",_loc2_,param1));
         }
      }
      
      private function onChatViewProvider(param1:IChatViewProvider) : void
      {
         this.chatViewProvider = param1;
         if(ClientConfig.instance.useNewEogChat)
         {
            this.createNewEogChat();
         }
         else
         {
            this.createOldEogChat();
         }
         BindingUtils.bindSetter(this.onChatRoomChanged,this,["endOfGameStatsController","chatRoom"]);
      }
      
      private function _EndOfGameStatsView_SaturationFade1_i() : SaturationFade
      {
         var _loc1_:SaturationFade = new SaturationFade();
         this.satFadeOut = _loc1_;
         _loc1_.duration = 1000;
         _loc1_.saturationFrom = 1;
         _loc1_.saturationTo = 0;
         return _loc1_;
      }
      
      public function set leagueDisplay(param1:Label) : void
      {
         var _loc2_:Object = this._494117997leagueDisplay;
         if(_loc2_ !== param1)
         {
            this._494117997leagueDisplay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leagueDisplay",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get replaysForEndOfGameStatsEnabled() : Boolean
      {
         return this._2033792215replaysForEndOfGameStatsEnabled;
      }
      
      public function set enemyTeamStats(param1:EndOfGameStatsTeam) : void
      {
         var _loc2_:Object = this._364261990enemyTeamStats;
         if(_loc2_ !== param1)
         {
            this._364261990enemyTeamStats = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enemyTeamStats",_loc2_,param1));
         }
      }
      
      public function set eogTabBar(param1:ToggleButtonBar) : void
      {
         var _loc2_:Object = this._1730126747eogTabBar;
         if(_loc2_ !== param1)
         {
            this._1730126747eogTabBar = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"eogTabBar",_loc2_,param1));
         }
      }
      
      private function onClickEOGRewards(param1:Event) : void
      {
         this.endOfGameStatsController.endOfGameAlertParser.showRewardsAlert();
      }
      
      [Bindable(event="propertyChange")]
      public function get seriesDisplay1() : Image
      {
         return this._533461830seriesDisplay1;
      }
      
      [Bindable(event="propertyChange")]
      public function get seriesDisplay3() : Image
      {
         return this._533461832seriesDisplay3;
      }
      
      [Bindable(event="propertyChange")]
      public function get seriesDisplay4() : Image
      {
         return this._533461833seriesDisplay4;
      }
      
      [Bindable(event="propertyChange")]
      public function get seriesDisplay2() : Image
      {
         return this._533461831seriesDisplay2;
      }
      
      private function onAdvancedGameGameButtonClicked(param1:MouseEvent) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         var _loc2_:String = this.advancedDetailsUrlTemplate.getString();
         var _loc3_:String = ClientConfig.instance.locale.substr(0,2);
         var _loc4_:String = RiotResourceLoader.getString("endOfGame_shareGameButton_locale",_loc3_);
         if(_loc3_ != "" && _loc2_ != null)
         {
            _loc5_ = this.endOfGameStatsController.endOfGameStats.reportGameId ? Number(this.endOfGameStatsController.endOfGameStats.reportGameId) : Number(this.endOfGameStatsController.endOfGameStats.gameId);
            _loc6_ = Number(this.endOfGameStatsController.endOfGameStats.userId);
            _loc7_ = StringUtil.substitute(_loc2_,_loc5_,_loc6_,_loc3_);
            navigateToURL(new URLRequest(_loc7_),"_blank");
         }
      }
      
      public function ___EndOfGameStatsView_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      public function __overrideBack_btn_click(param1:MouseEvent) : void
      {
         this.onOverrideBackButtonClicked(param1);
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
      
      private function _EndOfGameStatsView_Fade1_i() : Fade
      {
         var _loc1_:Fade = new Fade();
         this.fadeIn = _loc1_;
         _loc1_.duration = 100;
         _loc1_.alphaFrom = 0;
         _loc1_.alphaTo = 1;
         return _loc1_;
      }
      
      public function set firstWinIcon(param1:Image) : void
      {
         var _loc2_:Object = this._1269534117firstWinIcon;
         if(_loc2_ !== param1)
         {
            this._1269534117firstWinIcon = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"firstWinIcon",_loc2_,param1));
         }
      }
      
      private function onOverrideBackButtonClicked(param1:MouseEvent) : void
      {
         this.endOfGameStatsController.overrideHomeButtonCallback();
      }
      
      [Bindable(event="propertyChange")]
      public function get normalRankedDisplayIcon() : Image
      {
         return this._2084678807normalRankedDisplayIcon;
      }
      
      [Bindable(event="propertyChange")]
      public function get seriesDisplay5() : Image
      {
         return this._533461834seriesDisplay5;
      }
      
      [Bindable(event="propertyChange")]
      public function get eogRewards() : SoundEffectButton
      {
         return this._454164327eogRewards;
      }
      
      [Bindable(event="propertyChange")]
      public function get eogViews() : ViewStack
      {
         return this._1604667535eogViews;
      }
      
      private function overviewContainerReady() : void
      {
         this.overviewContainer.addChild(this.winsNumber);
         this.overviewContainer.addChild(this.lossesNumber);
         this.overviewContainer.addChild(this.gameResultLabel);
      }
      
      public function set midColumn(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._552497218midColumn;
         if(_loc2_ !== param1)
         {
            this._552497218midColumn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"midColumn",_loc2_,param1));
         }
      }
      
      public function __advancedGameDetails_btn_click(param1:MouseEvent) : void
      {
         this.onAdvancedGameGameButtonClicked(param1);
      }
      
      private function set enableShareEndOfGameButton(param1:Boolean) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._757620806enableShareEndOfGameButton;
         if(_loc2_ !== param1)
         {
            this._757620806enableShareEndOfGameButton = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enableShareEndOfGameButton",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:EndOfGameStatsView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._EndOfGameStatsView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameStatsViewWatcherSetupUtil");
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
      public function get leagueDisplay() : Label
      {
         return this._494117997leagueDisplay;
      }
      
      private function handleZeroIpEarned() : void
      {
         this.ipSegmentArray.push(this.IPBreakdown.addChild(this.createIpSegment(null,IpBreakdownEvent.IP_TYPE_ZERO_EARNED,true)));
         if(this.endOfGameStatsController.localPlayer != null && this.endOfGameStatsController.endOfGameStats.gameMode != GameMode.TUTORIAL && this.inGameController.currentState == InGameController.PLAYING_CONNECTED)
         {
            this._noIPXPrewardAlert = new AlertParameters();
            this._noIPXPrewardAlert.requiresThickChromeState = false;
            this._noIPXPrewardAlert.location = AlertLocation.IP_BAR;
            this._noIPXPrewardAlert.title = RiotResourceLoader.getString("endofgame_overview_zeroIPrewardReasonTitle");
            this._noIPXPrewardAlert.message = RiotResourceLoader.getString("endofgame_overview_zeroIPrewardReasonDescription");
            ChromeContextAlertProviderProxy.instance.showAlertForParameters(this._noIPXPrewardAlert);
         }
      }
      
      private function showTeamSkinRental(param1:TeamSkinRentalDTO) : void
      {
         EndOfGameAssetsFactory.instance.removeTeamSkinRentalAsset();
         EndOfGameAssetsFactory.instance.addTeamSkinRentalAsset(param1,this.overviewContainer,this.IPBreakdown.x + this.IPBreakdown.width + 14,this.IPBreakdown.y);
      }
      
      public function set mainPanel(param1:Canvas) : void
      {
         var _loc2_:Object = this._265437237mainPanel;
         if(_loc2_ !== param1)
         {
            this._265437237mainPanel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mainPanel",_loc2_,param1));
         }
      }
      
      public function set rankingIcon(param1:Image) : void
      {
         var _loc2_:Object = this._1914859983rankingIcon;
         if(_loc2_ !== param1)
         {
            this._1914859983rankingIcon = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankingIcon",_loc2_,param1));
         }
      }
      
      private function onShareMatchHistoryConfigChange() : *
      {
         var _loc1_:String = ClientConfig.instance.locale.substr(0,2);
         var _loc2_:String = RiotResourceLoader.getString("endOfGame_shareGameButton_locale",_loc1_);
         var _loc3_:String = this.shareMatchHistoryUrlTemplate.getString();
         this.enableShareEndOfGameButton = Boolean(this.shareMatchHistoryEnabled.getBoolean()) && _loc3_ != null && _loc3_ != "" && this.endOfGameStatsController.overrideHomeButtonLabel == null && !this.replaysForEndOfGameStatsEnabled && _loc2_ != "";
         var _loc4_:String = this.advancedDetailsUrlTemplate.getString();
         this.enableAdvancedDetailsButton = Boolean(this.advancedDetailsEnabled.getBoolean()) && _loc4_ != null && _loc4_ != "";
      }
      
      [Bindable(event="propertyChange")]
      public function get eogTabBar() : ToggleButtonBar
      {
         return this._1730126747eogTabBar;
      }
      
      public function set friendlyTeamStats(param1:EndOfGameStatsTeam) : void
      {
         var _loc2_:Object = this._1084929065friendlyTeamStats;
         if(_loc2_ !== param1)
         {
            this._1084929065friendlyTeamStats = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"friendlyTeamStats",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bottomRow() : ConstraintRow
      {
         return this._1855392849bottomRow;
      }
      
      public function set endOfGameScoreboard(param1:EndOfGameScoreboard) : void
      {
         var _loc2_:Object = this._1696229848endOfGameScoreboard;
         if(_loc2_ !== param1)
         {
            this._1696229848endOfGameScoreboard = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"endOfGameScoreboard",_loc2_,param1));
         }
      }
      
      public function set endOfGameStatsController(param1:EndOfGameStatsController) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._1164646953endOfGameStatsController;
         if(_loc2_ !== param1)
         {
            this._1164646953endOfGameStatsController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"endOfGameStatsController",_loc2_,param1));
         }
      }
      
      public function __shareGame_btn_click(param1:MouseEvent) : void
      {
         this.onShareEndOfGameButtonClicked(param1);
      }
      
      [Bindable(event="propertyChange")]
      private function get enableShareEndOfGameButton() : Boolean
      {
         return this._757620806enableShareEndOfGameButton;
      }
      
      [Bindable(event="propertyChange")]
      public function get midColumn() : ConstraintColumn
      {
         return this._552497218midColumn;
      }
      
      private function onHide() : void
      {
         ChromeContextAlertProviderProxy.instance.removeAlert(this._noIPXPrewardAlert);
         if(Boolean(this.endOfGameStatsController) && Boolean(this.endOfGameStatsController.endOfGameAlertParser))
         {
            this.endOfGameStatsController.endOfGameAlertParser.removeAlert();
         }
         this.needsShow = true;
         this.resetView();
         this._noIPXPrewardAlert = null;
      }
      
      public function set gameTimeDisplay(param1:Label) : void
      {
         var _loc2_:Object = this._1144184291gameTimeDisplay;
         if(_loc2_ !== param1)
         {
            this._1144184291gameTimeDisplay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameTimeDisplay",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mainPanel() : Canvas
      {
         return this._265437237mainPanel;
      }
      
      [Bindable(event="propertyChange")]
      public function get friendlyTeamStats() : EndOfGameStatsTeam
      {
         return this._1084929065friendlyTeamStats;
      }
      
      private function createOldEogChat() : void
      {
         this.oldChat = new EndOfGameChatWindow();
         this.oldChat.percentWidth = 100;
         this.oldChat.percentHeight = 100;
         this.endOfGameChat.addChild(this.oldChat);
      }
      
      private function onRerollStatsReceived() : void
      {
         this.setupIpAndXpAndReroll();
      }
      
      private function resizeHandler(param1:ResizeEvent) : void
      {
         if(this.newChat != null)
         {
            this.newChat.setExplicitSize(this.endOfGameChat.width - 1,this.endOfGameChat.height - 1);
         }
      }
   }
}

