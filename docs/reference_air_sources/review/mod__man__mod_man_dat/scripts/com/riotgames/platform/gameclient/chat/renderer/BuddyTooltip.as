package com.riotgames.platform.gameclient.chat.renderer
{
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.common.xmpp.data.invite.PresenceStatusXML;
   import com.riotgames.platform.gameclient.buddyImages.BuddyImages;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.controllers.PresenceController;
   import com.riotgames.platform.gameclient.chat.domain.PresenceStatusData;
   import com.riotgames.platform.gameclient.components.summoner.SummonerIcon;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.tracking.ICrossModuleTrackerProvider;
   import com.riotgames.pvpnet.tracking.trackers.friend.IFriendListBehaviorTracker;
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
   import mx.containers.VBox;
   import mx.controls.HRule;
   import mx.controls.Spacer;
   import mx.controls.Text;
   import mx.core.IToolTip;
   import mx.core.UIComponent;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.styles.*;
   import org.igniterealtime.xiff.data.Presence;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   use namespace mx_internal;
   
   public class BuddyTooltip extends Canvas implements IBindingClient, IToolTip
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private static var logger:ILogger = Log.getLogger("com.riotgames.platform.gameclient.chat.renderer.BuddyTooltip");
      
      private static var _1609594047enabled:Boolean = true;
      
      private static var _showNoteChanged:Boolean = false;
      
      private static var _showNote:Boolean = false;
      
      private static var _lastBuddyTooltip:Dictionary = new Dictionary(true);
      
      private static const maxMinsElapsed:Number = 120;
      
      private static const FLOATING_TOOLTIP_SCALE:Number = 0.76;
      
      private static const DOCKED_TOOLTIP_SCALE:Number = 1;
      
      private static var _staticBindingEventDispatcher:EventDispatcher = new EventDispatcher();
      
      private var _610355075profileIconSource:BitmapData;
      
      private var _1890945756_presenceData:PresenceStatusData;
      
      public var _text:String;
      
      private var _2070216145statusMsg:Text;
      
      private var _1568738932gameStateText:Text;
      
      private var _503224744minsElapsedText:Text;
      
      private var _1945385533infoBox:VBox;
      
      private var isAway:Boolean;
      
      private var _chatController:ChatController;
      
      private var _2146395967gameStatusColor:Number;
      
      mx_internal var _bindingsByDestination:Object;
      
      private var _177356226profileIcon:SummonerIcon;
      
      private var _2020295326showMinsElapsed:Boolean = true;
      
      private var _245594301timeStampText:String = "";
      
      private var _303392796playerInfoBox:VBox;
      
      private var _1102346780winsText:Text;
      
      private var _270636692championName:Text;
      
      private var _1137005412rankedGameLeagueNameText:String = "";
      
      private var _1495734619rankedGameLeagueStandingText:String = "";
      
      private var _1581129791noteText:Text;
      
      mx_internal var _watchers:Array;
      
      private var _631264373inGameDetails:String = "";
      
      private var _627231364gameStatus:String = "";
      
      private var _1945880709showDetails:Boolean = true;
      
      private var _537644451showWinDetails:Boolean = false;
      
      private var _friendTracker:IFriendListBehaviorTracker;
      
      private var _rosterNote:String;
      
      private var _1753362831buddyName:String;
      
      private var _550761194showLeagueDetails:Boolean = false;
      
      private var _1656229167levelText:Text;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public var _BuddyTooltip_Text5:Text;
      
      public var _BuddyTooltip_Text6:Text;
      
      private var _1380553871winsHTMLText:String = "";
      
      mx_internal var _bindings:Array;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      private var _1424181744gameDetails:Text;
      
      public function BuddyTooltip()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":HBox,
                  "stylesFactory":function():void
                  {
                     this.horizontalGap = 0;
                     this.paddingBottom = 10;
                     this.paddingRight = 10;
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "x":10,
                        "y":10,
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":SummonerIcon,
                           "id":"profileIcon",
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "x":5,
                                 "height":70
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":VBox,
                           "id":"infoBox",
                           "stylesFactory":function():void
                           {
                              this.horizontalAlign = "center";
                              this.verticalGap = -2;
                              this.paddingBottom = 0;
                              this.paddingTop = 0;
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "x":10,
                                 "width":205,
                                 "percentHeight":100,
                                 "verticalScrollPolicy":"off",
                                 "horizontalScrollPolicy":"off",
                                 "childDescriptors":[new UIComponentDescriptor({
                                    "type":Text,
                                    "id":"championName",
                                    "stylesFactory":function():void
                                    {
                                       this.fontSize = 15;
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {"styleName":"buddyName"};
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":HRule,
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "percentWidth":90,
                                          "styleName":"hRule"
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":Spacer,
                                    "propertiesFactory":function():Object
                                    {
                                       return {"height":5};
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":VBox,
                                    "id":"playerInfoBox",
                                    "stylesFactory":function():void
                                    {
                                       this.horizontalAlign = "center";
                                       this.verticalGap = -4;
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "percentWidth":100,
                                          "percentHeight":100,
                                          "verticalScrollPolicy":"off",
                                          "horizontalScrollPolicy":"off",
                                          "childDescriptors":[new UIComponentDescriptor({
                                             "type":Text,
                                             "id":"levelText",
                                             "stylesFactory":function():void
                                             {
                                                this.color = 16777215;
                                             },
                                             "propertiesFactory":function():Object
                                             {
                                                return {"styleName":"buddyStatus"};
                                             }
                                          }),new UIComponentDescriptor({
                                             "type":Text,
                                             "id":"statusMsg",
                                             "stylesFactory":function():void
                                             {
                                                this.color = 16750848;
                                                this.textAlign = "center";
                                             },
                                             "propertiesFactory":function():Object
                                             {
                                                return {
                                                   "styleName":"buddyStatus",
                                                   "truncateToFit":true
                                                };
                                             }
                                          }),new UIComponentDescriptor({
                                             "type":Text,
                                             "id":"winsText",
                                             "stylesFactory":function():void
                                             {
                                                this.color = 16777215;
                                             },
                                             "propertiesFactory":function():Object
                                             {
                                                return {"styleName":"buddyStatusLarge"};
                                             }
                                          }),new UIComponentDescriptor({
                                             "type":Text,
                                             "id":"_BuddyTooltip_Text5",
                                             "stylesFactory":function():void
                                             {
                                                this.color = 16750848;
                                             },
                                             "propertiesFactory":function():Object
                                             {
                                                return {"styleName":"buddyStatusLarge"};
                                             }
                                          }),new UIComponentDescriptor({
                                             "type":Text,
                                             "id":"_BuddyTooltip_Text6",
                                             "stylesFactory":function():void
                                             {
                                                this.color = 16750848;
                                             },
                                             "propertiesFactory":function():Object
                                             {
                                                return {"styleName":"buddyStatusLarge"};
                                             }
                                          }),new UIComponentDescriptor({
                                             "type":Text,
                                             "id":"gameStateText",
                                             "propertiesFactory":function():Object
                                             {
                                                return {"styleName":"buddyStatus"};
                                             }
                                          }),new UIComponentDescriptor({
                                             "type":Text,
                                             "id":"gameDetails",
                                             "stylesFactory":function():void
                                             {
                                                this.color = 15197497;
                                             },
                                             "propertiesFactory":function():Object
                                             {
                                                return {"styleName":"buddyStatus"};
                                             }
                                          }),new UIComponentDescriptor({
                                             "type":Text,
                                             "id":"minsElapsedText",
                                             "stylesFactory":function():void
                                             {
                                                this.color = 15197497;
                                             },
                                             "propertiesFactory":function():Object
                                             {
                                                return {"styleName":"buddyStatus"};
                                             }
                                          })]
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":Text,
                                    "id":"noteText",
                                    "stylesFactory":function():void
                                    {
                                       this.color = 15658734;
                                       this.textAlign = "center";
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "x":87,
                                          "y":5,
                                          "percentWidth":100,
                                          "styleName":"buddyStatus",
                                          "visible":false,
                                          "includeInLayout":false
                                       };
                                    }
                                 })]
                              };
                           }
                        })]
                     };
                  }
               })]};
            }
         });
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
            this.borderStyle = "solid";
            this.borderThickness = 2;
            this.borderColor = 1118481;
            this.dropShadowEnabled = true;
            this.shadowDistance = 10;
            this.shadowDirection = "right";
         };
         this.styleName = "glassSeeThroughPanel";
         this.verticalScrollPolicy = "off";
         this.horizontalScrollPolicy = "off";
         this.mouseEnabled = false;
         this.mouseChildren = false;
         this.minHeight = 40;
         this.addEventListener("initialize",this.___BuddyTooltip_Canvas1_initialize);
         this.addEventListener("creationComplete",this.___BuddyTooltip_Canvas1_creationComplete);
      }
      
      public static function clearLastBuddyTooltip() : void
      {
         var _loc1_:* = undefined;
         for each(_loc1_ in _lastBuddyTooltip)
         {
            if(_loc1_ != null)
            {
               delete _lastBuddyTooltip[_loc1_];
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public static function get enabled() : Boolean
      {
         return BuddyTooltip._1609594047enabled;
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         BuddyTooltip._watcherSetupUtil = param1;
      }
      
      public static function set enabled(param1:Boolean) : void
      {
         var _loc3_:IEventDispatcher = null;
         var _loc2_:Object = BuddyTooltip._1609594047enabled;
         if(_loc2_ !== param1)
         {
            BuddyTooltip._1609594047enabled = param1;
            _loc3_ = BuddyTooltip.staticEventDispatcher;
            if(_loc3_ != null)
            {
               _loc3_.dispatchEvent(PropertyChangeEvent.createUpdateEvent(BuddyTooltip,"enabled",_loc2_,param1));
            }
         }
      }
      
      public static function get showNote() : Boolean
      {
         return _showNote;
      }
      
      public static function get lastBuddyTooltip() : BuddyTooltip
      {
         var _loc1_:* = undefined;
         for each(_loc1_ in _lastBuddyTooltip)
         {
            if(_loc1_ != null)
            {
               return _loc1_ as BuddyTooltip;
            }
         }
         return null;
      }
      
      public static function set showNote(param1:Boolean) : void
      {
         if(param1 == _showNote || lastBuddyTooltip == null)
         {
            return;
         }
         _showNote = param1;
         _showNoteChanged = true;
         lastBuddyTooltip.invalidateProperties();
      }
      
      public static function get staticEventDispatcher() : IEventDispatcher
      {
         return _staticBindingEventDispatcher;
      }
      
      public static function set lastBuddyTooltip(param1:BuddyTooltip) : void
      {
         clearLastBuddyTooltip();
         if(param1 != null)
         {
            _lastBuddyTooltip[param1] = param1;
         }
      }
      
      public static function hideLastBuddyTooltip() : void
      {
         var _loc2_:UIComponent = null;
         var _loc1_:BuddyTooltip = lastBuddyTooltip;
         if(_loc1_ != null)
         {
            _loc1_.visible = false;
            _loc2_ = _loc1_.parent as UIComponent;
            if(_loc2_ != null)
            {
               _loc2_.removeChild(_loc1_);
            }
         }
      }
      
      private function set profileIconSource(param1:BitmapData) : void
      {
         var _loc2_:Object = this._610355075profileIconSource;
         if(_loc2_ !== param1)
         {
            this._610355075profileIconSource = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"profileIconSource",_loc2_,param1));
         }
      }
      
      private function set gameStatus(param1:String) : void
      {
         var _loc2_:Object = this._627231364gameStatus;
         if(_loc2_ !== param1)
         {
            this._627231364gameStatus = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameStatus",_loc2_,param1));
         }
      }
      
      private function set showDetails(param1:Boolean) : void
      {
         var _loc2_:Object = this._1945880709showDetails;
         if(_loc2_ !== param1)
         {
            this._1945880709showDetails = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showDetails",_loc2_,param1));
         }
      }
      
      public function get chatController() : ChatController
      {
         return this._chatController;
      }
      
      private function set inGameDetails(param1:String) : void
      {
         var _loc2_:Object = this._631264373inGameDetails;
         if(_loc2_ !== param1)
         {
            this._631264373inGameDetails = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inGameDetails",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get playerInfoBox() : VBox
      {
         return this._303392796playerInfoBox;
      }
      
      [Bindable(event="propertyChange")]
      private function get showLeagueDetails() : Boolean
      {
         return this._550761194showLeagueDetails;
      }
      
      public function set gameStateText(param1:Text) : void
      {
         var _loc2_:Object = this._1568738932gameStateText;
         if(_loc2_ !== param1)
         {
            this._1568738932gameStateText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameStateText",_loc2_,param1));
         }
      }
      
      private function set winsHTMLText(param1:String) : void
      {
         var _loc2_:Object = this._1380553871winsHTMLText;
         if(_loc2_ !== param1)
         {
            this._1380553871winsHTMLText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"winsHTMLText",_loc2_,param1));
         }
      }
      
      public function set championName(param1:Text) : void
      {
         var _loc2_:Object = this._270636692championName;
         if(_loc2_ !== param1)
         {
            this._270636692championName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championName",_loc2_,param1));
         }
      }
      
      private function updateGameStatus() : void
      {
         var _loc2_:String = null;
         var _loc1_:String = PresenceStatusXML.getStatusShowMode(this.presenceData.gameType);
         this.gameStatusColor = _loc1_ == Presence.SHOW_CHAT ? 1956152 : 15197497;
         this.gameStatus = RiotResourceLoader.getString("BuddyListTreeRenderer_gameStatus_" + this.presenceData.gameType,"");
         if(this.presenceData.gameType == PresenceStatusXML.GAME_STATUS_IN_GAME)
         {
            if(this.presenceData.skinname == Champion.RANDOM_SKIN_NAME)
            {
               _loc2_ = RiotResourceLoader.getString("championSelection_randomChampion_displayName");
            }
            else
            {
               _loc2_ = RiotResourceLoader.getChampionResourceString("name",this.presenceData.skinname,"");
            }
            this.inGameDetails = RiotResourceLoader.getString("BuddyListTooltip_inGameInfo",null,[_loc2_]);
            if(this.inGameDetails == null)
            {
               this.inGameDetails = RiotResourceLoader.getString("BuddyListTreeRenderer_gameStatus_playingAs") + _loc2_;
            }
         }
         this.updateTimestamp();
      }
      
      [Bindable(event="propertyChange")]
      public function get statusMsg() : Text
      {
         return this._2070216145statusMsg;
      }
      
      private function onGetCrossModuleTrackerProvider(param1:ICrossModuleTrackerProvider) : void
      {
         this._friendTracker = param1.getFriendListBehaviorTracker();
      }
      
      private function onCreationComplete() : void
      {
         this._friendTracker.incrementFriendTooltipLooked_InASession();
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      [Bindable(event="propertyChange")]
      public function get infoBox() : VBox
      {
         return this._1945385533infoBox;
      }
      
      [Bindable(event="propertyChange")]
      public function get noteText() : Text
      {
         return this._1581129791noteText;
      }
      
      public function setRosterItem(param1:RosterItemVO) : void
      {
         this.initializeRenderer();
         if(param1 == null)
         {
            return;
         }
         this.isAway = param1.show == Presence.SHOW_AWAY;
         this.buddyName = param1.displayName;
         this.presenceData = PresenceController.getPresenceData(param1.status);
         if(param1.status == null || param1.status == "Available" || param1.status == "Offline" || this.presenceData == null || this.presenceData.level == 0)
         {
            this.showDetails = false;
         }
         else
         {
            this.showDetails = true;
         }
         this._rosterNote = param1.note;
      }
      
      private function get presenceData() : PresenceStatusData
      {
         return this._presenceData;
      }
      
      [Bindable(event="propertyChange")]
      private function get gameStatusColor() : Number
      {
         return this._2146395967gameStatusColor;
      }
      
      public function set playerInfoBox(param1:VBox) : void
      {
         var _loc2_:Object = this._303392796playerInfoBox;
         if(_loc2_ !== param1)
         {
            this._303392796playerInfoBox = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerInfoBox",_loc2_,param1));
         }
      }
      
      private function set _presenceData(param1:PresenceStatusData) : void
      {
         var _loc2_:Object = this._1890945756_presenceData;
         if(_loc2_ !== param1)
         {
            this._1890945756_presenceData = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_presenceData",_loc2_,param1));
         }
      }
      
      private function set showMinsElapsed(param1:Boolean) : void
      {
         var _loc2_:Object = this._2020295326showMinsElapsed;
         if(_loc2_ !== param1)
         {
            this._2020295326showMinsElapsed = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showMinsElapsed",_loc2_,param1));
         }
      }
      
      private function updateTimestamp() : void
      {
         var _loc1_:Date = null;
         var _loc2_:int = 0;
         if(this.presenceData.gameType == PresenceStatusXML.GAME_STATUS_IN_QUEUE || this.presenceData.gameType == PresenceStatusXML.GAME_STATUS_IN_GAME)
         {
            _loc1_ = new Date();
            _loc2_ = int((_loc1_.time - this.presenceData.timeStamp) / 60000);
            this.showMinsElapsed = _loc2_ < maxMinsElapsed;
            if(_loc2_ < 0)
            {
               this.timeStampText = "";
            }
            else if(_loc2_ == 0)
            {
               this.timeStampText = RiotResourceLoader.getString("BuddyListTooltip_elapsedtime_zero");
            }
            else if(_loc2_ == 1)
            {
               this.timeStampText = RiotResourceLoader.getString("BuddyListTooltip_elapsedtime_singluar");
            }
            else
            {
               this.timeStampText = RiotResourceLoader.getString("BuddyListTooltip_elapsedtime",null,[_loc2_]);
            }
            if(this.timeStampText == null)
            {
               this.timeStampText = "**for " + _loc2_.toString() + " minutes.";
            }
         }
         else
         {
            this.timeStampText = "";
         }
      }
      
      public function setBuddyData(param1:String, param2:PresenceStatusData) : void
      {
         this.initializeRenderer();
         this.showDetails = param2 != null && param2.level > 0;
         this.isAway = false;
         this.buddyName = param1;
         this.presenceData = param2;
      }
      
      public function set minsElapsedText(param1:Text) : void
      {
         var _loc2_:Object = this._503224744minsElapsedText;
         if(_loc2_ !== param1)
         {
            this._503224744minsElapsedText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minsElapsedText",_loc2_,param1));
         }
      }
      
      private function set rankedGameLeagueStandingText(param1:String) : void
      {
         var _loc2_:Object = this._1495734619rankedGameLeagueStandingText;
         if(_loc2_ !== param1)
         {
            this._1495734619rankedGameLeagueStandingText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankedGameLeagueStandingText",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get timeStampText() : String
      {
         return this._245594301timeStampText;
      }
      
      override public function set data(param1:Object) : void
      {
         throw new Error("deprecated, set rosterVO item directly");
      }
      
      private function set showLeagueDetails(param1:Boolean) : void
      {
         var _loc2_:Object = this._550761194showLeagueDetails;
         if(_loc2_ !== param1)
         {
            this._550761194showLeagueDetails = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showLeagueDetails",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _presenceData() : PresenceStatusData
      {
         return this._1890945756_presenceData;
      }
      
      public function set statusMsg(param1:Text) : void
      {
         var _loc2_:Object = this._2070216145statusMsg;
         if(_loc2_ !== param1)
         {
            this._2070216145statusMsg = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statusMsg",_loc2_,param1));
         }
      }
      
      public function ___BuddyTooltip_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      [Bindable(event="propertyChange")]
      private function get rankedGameLeagueNameText() : String
      {
         return this._1137005412rankedGameLeagueNameText;
      }
      
      [Bindable(event="propertyChange")]
      public function set chatController(param1:ChatController) : void
      {
         var _loc2_:Object = this.chatController;
         if(_loc2_ !== param1)
         {
            this._1019249940chatController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatController",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get buddyName() : String
      {
         return this._1753362831buddyName;
      }
      
      public function set text(param1:String) : void
      {
      }
      
      private function initializeRenderer() : void
      {
         if(this.chatController == null)
         {
            return;
         }
         this.scaleX = this.scaleY = DOCKED_TOOLTIP_SCALE;
      }
      
      public function ___BuddyTooltip_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      public function set infoBox(param1:VBox) : void
      {
         var _loc2_:Object = this._1945385533infoBox;
         if(_loc2_ !== param1)
         {
            this._1945385533infoBox = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"infoBox",_loc2_,param1));
         }
      }
      
      public function set noteText(param1:Text) : void
      {
         var _loc2_:Object = this._1581129791noteText;
         if(_loc2_ !== param1)
         {
            this._1581129791noteText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"noteText",_loc2_,param1));
         }
      }
      
      public function get leaguesEnabled() : Boolean
      {
         return ClientConfig.instance.leagueServiceEnabled;
      }
      
      private function set timeStampText(param1:String) : void
      {
         var _loc2_:Object = this._245594301timeStampText;
         if(_loc2_ !== param1)
         {
            this._245594301timeStampText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"timeStampText",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function set presenceData(param1:PresenceStatusData) : void
      {
         var _loc2_:Object = this.presenceData;
         if(_loc2_ !== param1)
         {
            this._212536133presenceData = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"presenceData",_loc2_,param1));
         }
      }
      
      public function set profileIcon(param1:SummonerIcon) : void
      {
         var _loc2_:Object = this._177356226profileIcon;
         if(_loc2_ !== param1)
         {
            this._177356226profileIcon = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"profileIcon",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameStateText() : Text
      {
         return this._1568738932gameStateText;
      }
      
      private function set gameStatusColor(param1:Number) : void
      {
         var _loc2_:Object = this._2146395967gameStatusColor;
         if(_loc2_ !== param1)
         {
            this._2146395967gameStatusColor = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameStatusColor",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get winsHTMLText() : String
      {
         return this._1380553871winsHTMLText;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:BuddyTooltip = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._BuddyTooltip_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_chat_renderer_BuddyTooltipWatcherSetupUtil");
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
      private function get gameStatus() : String
      {
         return this._627231364gameStatus;
      }
      
      [Bindable(event="propertyChange")]
      private function get profileIconSource() : BitmapData
      {
         return this._610355075profileIconSource;
      }
      
      [Bindable(event="propertyChange")]
      private function get inGameDetails() : String
      {
         return this._631264373inGameDetails;
      }
      
      [Bindable(event="propertyChange")]
      public function get championName() : Text
      {
         return this._270636692championName;
      }
      
      public function set levelText(param1:Text) : void
      {
         var _loc2_:Object = this._1656229167levelText;
         if(_loc2_ !== param1)
         {
            this._1656229167levelText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"levelText",_loc2_,param1));
         }
      }
      
      private function _BuddyTooltip_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.profileIconSource;
         _loc1_ = this.profileIcon.height;
         _loc1_ = this.showDetails;
         _loc1_ = this.showDetails;
         _loc1_ = this.buddyName;
         _loc1_ = resourceManager.getString("resources","BuddyListTooltip_summonerLevel",[this.presenceData.level]);
         _loc1_ = this.showDetails;
         _loc1_ = this.showDetails;
         _loc1_ = this.presenceData.statusMsg.substr(0,25);
         _loc1_ = this.playerInfoBox.width;
         _loc1_ = this.showDetails;
         _loc1_ = this.showDetails;
         _loc1_ = this.winsHTMLText;
         _loc1_ = this.showWinDetails;
         _loc1_ = this.showWinDetails;
         _loc1_ = this.rankedGameLeagueStandingText;
         _loc1_ = this.showLeagueDetails && this.leaguesEnabled;
         _loc1_ = this.showLeagueDetails && this.leaguesEnabled;
         _loc1_ = this.rankedGameLeagueNameText;
         _loc1_ = this.showLeagueDetails && this.rankedGameLeagueNameText != "" && this.leaguesEnabled;
         _loc1_ = this.showLeagueDetails && this.rankedGameLeagueNameText != "" && this.leaguesEnabled;
         _loc1_ = this.gameStatusColor;
         _loc1_ = this.gameStatus;
         _loc1_ = this.showDetails;
         _loc1_ = this.showDetails;
         _loc1_ = this.inGameDetails;
         _loc1_ = this.showDetails && this.presenceData.gameType == PresenceStatusXML.GAME_STATUS_IN_GAME;
         _loc1_ = this.showDetails && this.presenceData.gameType == PresenceStatusXML.GAME_STATUS_IN_GAME;
         _loc1_ = this.timeStampText;
         _loc1_ = this.showDetails && this.showMinsElapsed && (this.presenceData.gameType == PresenceStatusXML.GAME_STATUS_IN_GAME || this.presenceData.gameType == PresenceStatusXML.GAME_STATUS_IN_QUEUE);
         _loc1_ = this.showDetails && (this.presenceData.gameType == PresenceStatusXML.GAME_STATUS_IN_GAME || this.presenceData.gameType == PresenceStatusXML.GAME_STATUS_IN_QUEUE);
      }
      
      private function set _212536133presenceData(param1:PresenceStatusData) : void
      {
         this._presenceData = param1;
         this.profileIconSource = BuddyImages.getSummonerIconSafely(this.presenceData.profileIconId);
         if(this.isAway)
         {
            this.gameStatusColor = 16711680;
            this.gameStatus = RiotResourceLoader.getString("BuddyListTreeRenderer_gameStatus_away","*away");
         }
         else
         {
            this.updateGameStatus();
         }
         this.updateWinsLosses();
      }
      
      [Bindable(event="propertyChange")]
      private function get rankedGameLeagueStandingText() : String
      {
         return this._1495734619rankedGameLeagueStandingText;
      }
      
      [Bindable(event="propertyChange")]
      private function get showDetails() : Boolean
      {
         return this._1945880709showDetails;
      }
      
      [Bindable(event="propertyChange")]
      public function get minsElapsedText() : Text
      {
         return this._503224744minsElapsedText;
      }
      
      private function set showWinDetails(param1:Boolean) : void
      {
         var _loc2_:Object = this._537644451showWinDetails;
         if(_loc2_ !== param1)
         {
            this._537644451showWinDetails = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showWinDetails",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get showWinDetails() : Boolean
      {
         return this._537644451showWinDetails;
      }
      
      private function set _1019249940chatController(param1:ChatController) : void
      {
         this._chatController = param1;
         this.initializeRenderer();
      }
      
      private function updateWinsLosses() : void
      {
         var _loc3_:String = null;
         var _loc1_:int = this.presenceData.wins + this.presenceData.odinWins;
         var _loc2_:int = int(this.presenceData.rankedWins);
         this.winsHTMLText = "";
         if(_loc2_ > 0)
         {
            this.winsHTMLText = RiotResourceLoader.getString("customGame_RankedWins",null,[_loc2_.toString()]);
            this.showWinDetails = true;
         }
         else if(_loc1_ > 0)
         {
            this.winsHTMLText = RiotResourceLoader.getString("customGame_NormalWins",null,[_loc1_.toString()]);
            this.showWinDetails = true;
         }
         if(this.presenceData.rankedLeagueName != null && this.presenceData.rankedLeagueName != "")
         {
            _loc3_ = RiotResourceLoader.getString("leagues_rank_" + this.presenceData.rankedLeagueTier);
            this.showLeagueDetails = true;
            this.rankedGameLeagueStandingText = "<font color=\'#ee9501\'>";
            this.rankedGameLeagueNameText = "";
            if(this.presenceData.rankedLeagueTier == "CHALLENGER")
            {
               this.rankedGameLeagueStandingText += RiotResourceLoader.getString("leagues_rank_CHALLENGER_NODIV");
               this.rankedGameLeagueNameText = "<font color=\'#ee9501\'>";
               this.rankedGameLeagueNameText += RiotResourceLoader.getString("league_queue_" + this.presenceData.rankedLeagueQueueType);
               this.rankedGameLeagueNameText += "</font>";
            }
            else if(this.presenceData.rankedLeagueTier == "MASTER")
            {
               this.rankedGameLeagueStandingText += RiotResourceLoader.getString("leagues_rank_MASTER_NODIV");
               this.rankedGameLeagueNameText = "<font color=\'#ee9501\'>";
               this.rankedGameLeagueNameText += RiotResourceLoader.getString("league_queue_" + this.presenceData.rankedLeagueQueueType);
               this.rankedGameLeagueNameText += "</font>";
            }
            else
            {
               this.rankedGameLeagueStandingText += RiotResourceLoader.getString("profile_devision_display","**profile_devision_display",[_loc3_,this.presenceData.rankedLeagueDivision]);
               this.rankedGameLeagueNameText = "<font color=\'#ee9501\'>";
               this.rankedGameLeagueNameText += ServiceProxy.instance.leagueService.cache.parseLeagueName(this.presenceData.rankedLeagueName);
               this.rankedGameLeagueNameText += "</font>";
            }
            this.rankedGameLeagueStandingText += "</font>";
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get showMinsElapsed() : Boolean
      {
         return this._2020295326showMinsElapsed;
      }
      
      [Bindable(event="propertyChange")]
      public function get profileIcon() : SummonerIcon
      {
         return this._177356226profileIcon;
      }
      
      public function set winsText(param1:Text) : void
      {
         var _loc2_:Object = this._1102346780winsText;
         if(_loc2_ !== param1)
         {
            this._1102346780winsText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"winsText",_loc2_,param1));
         }
      }
      
      private function onInitialize() : void
      {
         if(!this._friendTracker)
         {
            ProviderLookup.getProvider(ICrossModuleTrackerProvider,this.onGetCrossModuleTrackerProvider);
         }
      }
      
      override protected function commitProperties() : void
      {
         if(_showNoteChanged)
         {
            if(this.noteText != null)
            {
               this.noteText.text = this._rosterNote;
               this.noteText.visible = showNote;
               if(showNote && this._rosterNote == "" || this._rosterNote == null)
               {
                  this.noteText.text = RiotResourceLoader.getString("buddyNoteSuggestionText");
               }
               this.noteText.includeInLayout = showNote;
            }
            if(this.playerInfoBox != null)
            {
               this.playerInfoBox.visible = !showNote;
               this.playerInfoBox.includeInLayout = !showNote;
            }
            _showNoteChanged = false;
         }
         super.commitProperties();
      }
      
      private function set rankedGameLeagueNameText(param1:String) : void
      {
         var _loc2_:Object = this._1137005412rankedGameLeagueNameText;
         if(_loc2_ !== param1)
         {
            this._1137005412rankedGameLeagueNameText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankedGameLeagueNameText",_loc2_,param1));
         }
      }
      
      public function set gameDetails(param1:Text) : void
      {
         var _loc2_:Object = this._1424181744gameDetails;
         if(_loc2_ !== param1)
         {
            this._1424181744gameDetails = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameDetails",_loc2_,param1));
         }
      }
      
      public function set buddyName(param1:String) : void
      {
         var _loc2_:Object = this._1753362831buddyName;
         if(_loc2_ !== param1)
         {
            this._1753362831buddyName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"buddyName",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get winsText() : Text
      {
         return this._1102346780winsText;
      }
      
      [Bindable(event="propertyChange")]
      public function get levelText() : Text
      {
         return this._1656229167levelText;
      }
      
      [Bindable(event="propertyChange")]
      public function get gameDetails() : Text
      {
         return this._1424181744gameDetails;
      }
      
      private function _BuddyTooltip_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Object
         {
            return this.profileIconSource;
         },function(param1:Object):void
         {
            profileIcon.iconPath = param1;
         },"profileIcon.iconPath");
         result[0] = binding;
         binding = new Binding(this,function():Number
         {
            return profileIcon.height;
         },function(param1:Number):void
         {
            profileIcon.width = param1;
         },"profileIcon.width");
         result[1] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.showDetails;
         },function(param1:Boolean):void
         {
            profileIcon.visible = param1;
         },"profileIcon.visible");
         result[2] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.showDetails;
         },function(param1:Boolean):void
         {
            profileIcon.includeInLayout = param1;
         },"profileIcon.includeInLayout");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.buddyName;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            championName.text = param1;
         },"championName.text");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","BuddyListTooltip_summonerLevel",[this.presenceData.level]);
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            levelText.text = param1;
         },"levelText.text");
         result[5] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.showDetails;
         },function(param1:Boolean):void
         {
            levelText.visible = param1;
         },"levelText.visible");
         result[6] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.showDetails;
         },function(param1:Boolean):void
         {
            levelText.includeInLayout = param1;
         },"levelText.includeInLayout");
         result[7] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.presenceData.statusMsg.substr(0,25);
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            statusMsg.text = param1;
         },"statusMsg.text");
         result[8] = binding;
         binding = new Binding(this,function():Number
         {
            return playerInfoBox.width;
         },function(param1:Number):void
         {
            statusMsg.width = param1;
         },"statusMsg.width");
         result[9] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.showDetails;
         },function(param1:Boolean):void
         {
            statusMsg.visible = param1;
         },"statusMsg.visible");
         result[10] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.showDetails;
         },function(param1:Boolean):void
         {
            statusMsg.includeInLayout = param1;
         },"statusMsg.includeInLayout");
         result[11] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.winsHTMLText;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            winsText.htmlText = param1;
         },"winsText.htmlText");
         result[12] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.showWinDetails;
         },function(param1:Boolean):void
         {
            winsText.visible = param1;
         },"winsText.visible");
         result[13] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.showWinDetails;
         },function(param1:Boolean):void
         {
            winsText.includeInLayout = param1;
         },"winsText.includeInLayout");
         result[14] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.rankedGameLeagueStandingText;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _BuddyTooltip_Text5.htmlText = param1;
         },"_BuddyTooltip_Text5.htmlText");
         result[15] = binding;
         binding = new Binding(this,function():Boolean
         {
            return Boolean(this.showLeagueDetails) && this.leaguesEnabled;
         },function(param1:Boolean):void
         {
            _BuddyTooltip_Text5.visible = param1;
         },"_BuddyTooltip_Text5.visible");
         result[16] = binding;
         binding = new Binding(this,function():Boolean
         {
            return Boolean(this.showLeagueDetails) && this.leaguesEnabled;
         },function(param1:Boolean):void
         {
            _BuddyTooltip_Text5.includeInLayout = param1;
         },"_BuddyTooltip_Text5.includeInLayout");
         result[17] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.rankedGameLeagueNameText;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _BuddyTooltip_Text6.htmlText = param1;
         },"_BuddyTooltip_Text6.htmlText");
         result[18] = binding;
         binding = new Binding(this,function():Boolean
         {
            return Boolean(this.showLeagueDetails) && this.rankedGameLeagueNameText != "" && this.leaguesEnabled;
         },function(param1:Boolean):void
         {
            _BuddyTooltip_Text6.visible = param1;
         },"_BuddyTooltip_Text6.visible");
         result[19] = binding;
         binding = new Binding(this,function():Boolean
         {
            return Boolean(this.showLeagueDetails) && this.rankedGameLeagueNameText != "" && this.leaguesEnabled;
         },function(param1:Boolean):void
         {
            _BuddyTooltip_Text6.includeInLayout = param1;
         },"_BuddyTooltip_Text6.includeInLayout");
         result[20] = binding;
         binding = new Binding(this,function():uint
         {
            return this.gameStatusColor;
         },function(param1:uint):void
         {
            gameStateText.setStyle("color",param1);
         },"gameStateText.color");
         result[21] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.gameStatus;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            gameStateText.text = param1;
         },"gameStateText.text");
         result[22] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.showDetails;
         },function(param1:Boolean):void
         {
            gameStateText.visible = param1;
         },"gameStateText.visible");
         result[23] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.showDetails;
         },function(param1:Boolean):void
         {
            gameStateText.includeInLayout = param1;
         },"gameStateText.includeInLayout");
         result[24] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.inGameDetails;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            gameDetails.text = param1;
         },"gameDetails.text");
         result[25] = binding;
         binding = new Binding(this,function():Boolean
         {
            return Boolean(this.showDetails) && this.presenceData.gameType == PresenceStatusXML.GAME_STATUS_IN_GAME;
         },function(param1:Boolean):void
         {
            gameDetails.visible = param1;
         },"gameDetails.visible");
         result[26] = binding;
         binding = new Binding(this,function():Boolean
         {
            return Boolean(this.showDetails) && this.presenceData.gameType == PresenceStatusXML.GAME_STATUS_IN_GAME;
         },function(param1:Boolean):void
         {
            gameDetails.includeInLayout = param1;
         },"gameDetails.includeInLayout");
         result[27] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.timeStampText;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            minsElapsedText.text = param1;
         },"minsElapsedText.text");
         result[28] = binding;
         binding = new Binding(this,function():Boolean
         {
            return Boolean(this.showDetails) && Boolean(this.showMinsElapsed) && (this.presenceData.gameType == PresenceStatusXML.GAME_STATUS_IN_GAME || this.presenceData.gameType == PresenceStatusXML.GAME_STATUS_IN_QUEUE);
         },function(param1:Boolean):void
         {
            minsElapsedText.visible = param1;
         },"minsElapsedText.visible");
         result[29] = binding;
         binding = new Binding(this,function():Boolean
         {
            return Boolean(this.showDetails) && (this.presenceData.gameType == PresenceStatusXML.GAME_STATUS_IN_GAME || this.presenceData.gameType == PresenceStatusXML.GAME_STATUS_IN_QUEUE);
         },function(param1:Boolean):void
         {
            minsElapsedText.includeInLayout = param1;
         },"minsElapsedText.includeInLayout");
         result[30] = binding;
         return result;
      }
   }
}

