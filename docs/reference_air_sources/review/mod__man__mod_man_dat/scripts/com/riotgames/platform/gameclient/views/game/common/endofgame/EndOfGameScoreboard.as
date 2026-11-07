package com.riotgames.platform.gameclient.views.game.common.endofgame
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.Models.MaxViewableTeamSize;
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.platform.gameclient.domain.RawStatType;
   import com.riotgames.platform.gameclient.views.IScoreboard;
   import com.riotgames.pvpnet.game.controllers.EndOfGameStatsController;
   import com.riotgames.pvpnet.game.variants.GameFlowVariant;
   import com.riotgames.pvpnet.game.variants.GameFlowVariantFactory;
   import com.riotgames.pvpnet.game.variants.GameStatsType;
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
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class EndOfGameScoreboard extends Canvas implements IScoreboard, IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static const BLUE_SCOREBOARD_LEFT_SIDE:Class = EndOfGameScoreboard_BLUE_SCOREBOARD_LEFT_SIDE;
      
      public static const BLUE_SCOREBOARD_SIDE:Class = EndOfGameScoreboard_BLUE_SCOREBOARD_SIDE;
      
      public static const PURPLE_SCOREBOARD_LEFT_SIDE:Class = EndOfGameScoreboard_PURPLE_SCOREBOARD_LEFT_SIDE;
      
      public static const PURPLE_SCOREBOARD_SIDE:Class = EndOfGameScoreboard_PURPLE_SCOREBOARD_SIDE;
      
      public static const GREEN_SCOREBOARD_LEFT_SIDE:Class = EndOfGameScoreboard_GREEN_SCOREBOARD_LEFT_SIDE;
      
      public static const GREEN_SCOREBOARD_SIDE:Class = EndOfGameScoreboard_GREEN_SCOREBOARD_SIDE;
      
      public static const RED_SCOREBOARD_LEFT_SIDE:Class = EndOfGameScoreboard_RED_SCOREBOARD_LEFT_SIDE;
      
      public static const RED_SCOREBOARD_SIDE:Class = EndOfGameScoreboard_RED_SCOREBOARD_SIDE;
      
      public static const OVERVIEW_SCOREBOARD_DIVIDER:Class = EndOfGameScoreboard_OVERVIEW_SCOREBOARD_DIVIDER;
      
      public static const OVERVIEW_SCOREBOARD_SUMMONER_ICON:Class = EndOfGameScoreboard_OVERVIEW_SCOREBOARD_SUMMONER_ICON;
      
      public static const OVERVIEW_SCOREBOARD_KDA_ICON:Class = EndOfGameScoreboard_OVERVIEW_SCOREBOARD_KDA_ICON;
      
      public static const OVERVIEW_SCOREBOARD_SPELLS_ICON:Class = EndOfGameScoreboard_OVERVIEW_SCOREBOARD_SPELLS_ICON;
      
      public static const OVERVIEW_SCOREBOARD_ITEMS_ICON:Class = EndOfGameScoreboard_OVERVIEW_SCOREBOARD_ITEMS_ICON;
      
      public static const OVERVIEW_SCOREBOARD_POINT_CAP_ICON:Class = EndOfGameScoreboard_OVERVIEW_SCOREBOARD_POINT_CAP_ICON;
      
      public static const OVERVIEW_SCOREBOARD_POINT_NEUT_ICON:Class = EndOfGameScoreboard_OVERVIEW_SCOREBOARD_POINT_NEUT_ICON;
      
      public static const OVERVIEW_SCOREBOARD_GOLD_ICON:Class = EndOfGameScoreboard_OVERVIEW_SCOREBOARD_GOLD_ICON;
      
      public static const OVERVIEW_SCOREBOARD_MINIONS_ICON:Class = EndOfGameScoreboard_OVERVIEW_SCOREBOARD_MINIONS_ICON;
      
      public static const OVERVIEW_SCOREBOARD_RENOWN_ICON:Class = EndOfGameScoreboard_OVERVIEW_SCOREBOARD_RENOWN_ICON;
      
      private static const HEADER_SPACE:int = 30;
      
      private static const ROW_HEIGHT_STANDARD:int = 39;
      
      private static const ROW_HEIGHT_EXTENDED:int = 32;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":Canvas,
               "id":"eogScoreboardBase",
               "propertiesFactory":function():Object
               {
                  return {
                     "styleName":"eogScoreboardCanvas",
                     "width":814,
                     "height":434,
                     "x":0,
                     "y":0,
                     "verticalScrollPolicy":"off",
                     "horizontalScrollPolicy":"off",
                     "clipContent":false,
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":Image,
                        "id":"_EndOfGameScoreboard_Image1",
                        "stylesFactory":function():void
                        {
                           this.left = "0";
                           this.right = "0";
                           this.top = "30";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "mouseEnabled":false,
                              "mouseChildren":false
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Image,
                        "id":"topSideColorImageLeft",
                        "stylesFactory":function():void
                        {
                           this.left = "3";
                           this.top = "31";
                           this.bottom = "202";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "mouseEnabled":false,
                              "mouseChildren":false
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Image,
                        "id":"bottomSideColorImageLeft",
                        "stylesFactory":function():void
                        {
                           this.left = "3";
                           this.top = "233";
                           this.bottom = "0";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "mouseEnabled":false,
                              "mouseChildren":false
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Image,
                        "id":"topSideColorImageRight",
                        "stylesFactory":function():void
                        {
                           this.right = "2";
                           this.top = "31";
                           this.bottom = "202";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "mouseEnabled":false,
                              "mouseChildren":false
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Image,
                        "id":"bottomSideColorImageRight",
                        "stylesFactory":function():void
                        {
                           this.right = "2";
                           this.top = "233";
                           this.bottom = "0";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "mouseEnabled":false,
                              "mouseChildren":false
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Canvas,
                        "id":"eogScoreboard",
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
                              "verticalScrollPolicy":"off",
                              "horizontalScrollPolicy":"off",
                              "clipContent":false
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Image,
                        "id":"_EndOfGameScoreboard_Image6",
                        "stylesFactory":function():void
                        {
                           this.left = "0";
                           this.right = "0";
                           this.top = "230";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "mouseEnabled":false,
                              "mouseChildren":false
                           };
                        }
                     })]
                  };
               }
            }),new UIComponentDescriptor({
               "type":Image,
               "id":"_EndOfGameScoreboard_Image7",
               "propertiesFactory":function():Object
               {
                  return {
                     "x":13,
                     "y":6
                  };
               }
            }),new UIComponentDescriptor({
               "type":Image,
               "id":"_EndOfGameScoreboard_Image8",
               "propertiesFactory":function():Object
               {
                  return {"y":8};
               }
            }),new UIComponentDescriptor({
               "type":Image,
               "id":"_EndOfGameScoreboard_Image9",
               "propertiesFactory":function():Object
               {
                  return {"y":8};
               }
            }),new UIComponentDescriptor({
               "type":Image,
               "id":"_EndOfGameScoreboard_Image10",
               "propertiesFactory":function():Object
               {
                  return {"y":6};
               }
            }),new UIComponentDescriptor({
               "type":Image,
               "id":"_EndOfGameScoreboard_Image11",
               "propertiesFactory":function():Object
               {
                  return {
                     "x":715,
                     "y":7,
                     "scaleX":0.8,
                     "scaleY":0.8
                  };
               }
            }),new UIComponentDescriptor({
               "type":Image,
               "id":"_EndOfGameScoreboard_Image12",
               "propertiesFactory":function():Object
               {
                  return {
                     "x":722,
                     "y":8
                  };
               }
            }),new UIComponentDescriptor({
               "type":Image,
               "id":"_EndOfGameScoreboard_Image13",
               "propertiesFactory":function():Object
               {
                  return {
                     "x":782,
                     "y":6
                  };
               }
            }),new UIComponentDescriptor({
               "type":Image,
               "id":"_EndOfGameScoreboard_Image14",
               "propertiesFactory":function():Object
               {
                  return {
                     "x":777,
                     "y":8,
                     "scaleX":0.8,
                     "scaleY":0.8
                  };
               }
            })]};
         }
      });
      
      private var _268058841isDominionStatType:Boolean;
      
      mx_internal var _watchers:Array = [];
      
      private var _756942961eogScoreboard:Canvas;
      
      private var _334914747toolTipKDA:String;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      private var _449715486eogScoreboardBase:Canvas;
      
      private var _301952673bottomSideColorImageLeft:Image;
      
      public var _EndOfGameScoreboard_Image10:Image;
      
      public var _EndOfGameScoreboard_Image11:Image;
      
      public var _EndOfGameScoreboard_Image12:Image;
      
      public var _EndOfGameScoreboard_Image13:Image;
      
      public var _EndOfGameScoreboard_Image14:Image;
      
      public var _EndOfGameScoreboard_Image1:Image;
      
      public var _EndOfGameScoreboard_Image6:Image;
      
      public var _EndOfGameScoreboard_Image7:Image;
      
      public var _EndOfGameScoreboard_Image8:Image;
      
      public var _EndOfGameScoreboard_Image9:Image;
      
      private var _1736862552topSideColorImageRight:Image;
      
      private var _403534680showPointCapIcon:Boolean;
      
      mx_internal var _bindings:Array = [];
      
      private var _776259266bottomSideColorImageRight:Image;
      
      private var _498344117topSideColorImageLeft:Image;
      
      private var highlightedPlayerRenderer:EndOfGameScoreboardPlayerRenderer;
      
      [Inject]
      public var endOfGameStatsController:EndOfGameStatsController;
      
      public function EndOfGameScoreboard()
      {
         super();
         mx_internal::_document = this;
         this.clipContent = false;
         this.verticalScrollPolicy = "off";
         this.horizontalScrollPolicy = "off";
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         EndOfGameScoreboard._watcherSetupUtil = param1;
      }
      
      private function onScoreboardMouseMove(param1:MouseEvent) : void
      {
         var _loc3_:EndOfGameScoreboardPlayerRenderer = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.eogScoreboard.numChildren)
         {
            _loc3_ = this.eogScoreboard.getChildAt(_loc2_) as EndOfGameScoreboardPlayerRenderer;
            if(_loc3_.hitTestPoint(param1.stageX,param1.stageY))
            {
               _loc3_.selected = true;
               if(Boolean(this.highlightedPlayerRenderer) && this.highlightedPlayerRenderer !== _loc3_)
               {
                  this.highlightedPlayerRenderer.selected = false;
               }
               this.highlightedPlayerRenderer = _loc3_;
            }
            else
            {
               _loc3_.selected = false;
            }
            _loc2_++;
         }
      }
      
      public function show() : void
      {
         if(this.endOfGameStatsController.localPlayer != null)
         {
            this.topSideColorImageLeft.source = GREEN_SCOREBOARD_LEFT_SIDE;
            this.topSideColorImageRight.source = GREEN_SCOREBOARD_SIDE;
            this.bottomSideColorImageLeft.source = RED_SCOREBOARD_LEFT_SIDE;
            this.bottomSideColorImageRight.source = RED_SCOREBOARD_SIDE;
         }
         else
         {
            this.topSideColorImageLeft.source = BLUE_SCOREBOARD_LEFT_SIDE;
            this.topSideColorImageRight.source = BLUE_SCOREBOARD_SIDE;
            this.bottomSideColorImageLeft.source = PURPLE_SCOREBOARD_LEFT_SIDE;
            this.bottomSideColorImageRight.source = PURPLE_SCOREBOARD_SIDE;
         }
         this.eogScoreboard.removeAllChildren();
         var _loc1_:Boolean = this.isExtendedTeamSize(this.endOfGameStatsController.endOfGameStats.teamPlayerParticipantStats) || this.isExtendedTeamSize(this.endOfGameStatsController.endOfGameStats.otherTeamPlayerParticipantStats);
         var _loc2_:int = _loc1_ ? ROW_HEIGHT_EXTENDED : ROW_HEIGHT_STANDARD;
         var _loc3_:int = 0;
         this.addTeamRenderers(_loc3_,_loc2_,4,this.endOfGameStatsController.endOfGameStats.teamPlayerParticipantStats);
         _loc3_ = _loc1_ ? int(MaxViewableTeamSize.MAX_VIEWABLE_TEAM_SIZE) : int(MaxViewableTeamSize.TEAM_SIZE_NORMAL_VIEW_LIMIT);
         this.addTeamRenderers(_loc3_,_loc2_,10,this.endOfGameStatsController.endOfGameStats.otherTeamPlayerParticipantStats);
         this.eogScoreboard.addEventListener(MouseEvent.MOUSE_MOVE,this.onScoreboardMouseMove,false,0,true);
         this.eogScoreboard.addEventListener(MouseEvent.MOUSE_OUT,this.onScoreboardMouseMove,false,0,true);
         this.updateForStatType();
      }
      
      [Bindable(event="propertyChange")]
      public function get bottomSideColorImageRight() : Image
      {
         return this._776259266bottomSideColorImageRight;
      }
      
      private function set toolTipKDA(param1:String) : void
      {
         var _loc2_:Object = this._334914747toolTipKDA;
         if(_loc2_ !== param1)
         {
            this._334914747toolTipKDA = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"toolTipKDA",_loc2_,param1));
         }
      }
      
      public function set bottomSideColorImageRight(param1:Image) : void
      {
         var _loc2_:Object = this._776259266bottomSideColorImageRight;
         if(_loc2_ !== param1)
         {
            this._776259266bottomSideColorImageRight = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bottomSideColorImageRight",_loc2_,param1));
         }
      }
      
      private function updateForStatType() : void
      {
         this.isDominionStatType = GameStatsType.DOMINION == this.endOfGameStatsController.getCurrentStatsType();
         var _loc1_:GameFlowVariant = null;
         if(this.endOfGameStatsController.endOfGameStats != null)
         {
            _loc1_ = GameFlowVariantFactory.instance.getVariant(this.endOfGameStatsController.endOfGameStats.gameMutators,this.endOfGameStatsController.endOfGameStats.gameMode);
         }
         this.showPointCapIcon = _loc1_ != null ? this.isDominionStatType && Boolean(_loc1_.showPointsInfo()) : false;
         if(_loc1_ == null)
         {
            this.toolTipKDA = RiotResourceLoader.getStatResourceString("CHAMPION_KDA_CLASSIC","Kills/Deaths/Assists");
         }
         else if(_loc1_.useClassicKDATooltip())
         {
            this.toolTipKDA = RiotResourceLoader.getStatResourceString("CHAMPION_KDA_CLASSIC","Kills/Deaths/Assists");
         }
         else if(this.isDominionStatType)
         {
            this.toolTipKDA = RiotResourceLoader.getStatResourceString("CHAMPION_KDA_DOMINION","Kills/Deaths/Assists");
         }
      }
      
      private function addTeamRenderers(param1:int, param2:int, param3:int, param4:ArrayCollection) : void
      {
         var _loc5_:PlayerParticipantStatsSummary = null;
         var _loc6_:EndOfGameScoreboardPlayerRenderer = null;
         for each(_loc5_ in param4)
         {
            _loc6_ = new EndOfGameScoreboardPlayerRenderer(_loc5_,this.endOfGameStatsController);
            _loc6_.x = 5;
            _loc6_.y = HEADER_SPACE + param3 + param1 * param2;
            this.eogScoreboard.addChild(_loc6_);
            param1++;
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:EndOfGameScoreboard = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._EndOfGameScoreboard_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameScoreboardWatcherSetupUtil");
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
      
      public function set topSideColorImageLeft(param1:Image) : void
      {
         var _loc2_:Object = this._498344117topSideColorImageLeft;
         if(_loc2_ !== param1)
         {
            this._498344117topSideColorImageLeft = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"topSideColorImageLeft",_loc2_,param1));
         }
      }
      
      private function isExtendedTeamSize(param1:ArrayCollection) : Boolean
      {
         return param1 != null && param1.length > MaxViewableTeamSize.TEAM_SIZE_NORMAL_VIEW_LIMIT;
      }
      
      private function _EndOfGameScoreboard_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = OVERVIEW_SCOREBOARD_DIVIDER;
         _loc1_ = OVERVIEW_SCOREBOARD_DIVIDER;
         _loc1_ = OVERVIEW_SCOREBOARD_SUMMONER_ICON;
         _loc1_ = RiotResourceLoader.getString("end_of_game_scoreboard_summoner_tooltip","Summoner");
         _loc1_ = OVERVIEW_SCOREBOARD_KDA_ICON;
         _loc1_ = this.isDominionStatType ? 318 : 322;
         _loc1_ = this.toolTipKDA;
         _loc1_ = OVERVIEW_SCOREBOARD_SPELLS_ICON;
         _loc1_ = this.isDominionStatType ? 390 : 418;
         _loc1_ = RiotResourceLoader.getString("end_of_game_scoreboard_spells_tooltip","Selected spells");
         _loc1_ = OVERVIEW_SCOREBOARD_ITEMS_ICON;
         _loc1_ = this.isDominionStatType ? 528 : 562;
         _loc1_ = RiotResourceLoader.getString("end_of_game_scoreboard_items_tooltip","Selected spells");
         _loc1_ = OVERVIEW_SCOREBOARD_POINT_CAP_ICON;
         _loc1_ = this.showPointCapIcon;
         _loc1_ = RiotResourceLoader.getString("dominion_points_captured_or_neutralized");
         _loc1_ = OVERVIEW_SCOREBOARD_GOLD_ICON;
         _loc1_ = !this.isDominionStatType;
         _loc1_ = RiotResourceLoader.getStatResourceString(RawStatType.GOLD_EARNED,"Gold earned");
         _loc1_ = OVERVIEW_SCOREBOARD_MINIONS_ICON;
         _loc1_ = !this.isDominionStatType;
         _loc1_ = RiotResourceLoader.getStatResourceString(RawStatType.MINIONS_KILLED,"Minions killed");
         _loc1_ = OVERVIEW_SCOREBOARD_RENOWN_ICON;
         _loc1_ = this.isDominionStatType;
         _loc1_ = RiotResourceLoader.getStatResourceString(RawStatType.TOTAL_PLAYER_SCORE,"Total renown");
      }
      
      private function set isDominionStatType(param1:Boolean) : void
      {
         var _loc2_:Object = this._268058841isDominionStatType;
         if(_loc2_ !== param1)
         {
            this._268058841isDominionStatType = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isDominionStatType",_loc2_,param1));
         }
      }
      
      public function set topSideColorImageRight(param1:Image) : void
      {
         var _loc2_:Object = this._1736862552topSideColorImageRight;
         if(_loc2_ !== param1)
         {
            this._1736862552topSideColorImageRight = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"topSideColorImageRight",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bottomSideColorImageLeft() : Image
      {
         return this._301952673bottomSideColorImageLeft;
      }
      
      [Bindable(event="propertyChange")]
      private function get toolTipKDA() : String
      {
         return this._334914747toolTipKDA;
      }
      
      private function _EndOfGameScoreboard_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Object
         {
            return OVERVIEW_SCOREBOARD_DIVIDER;
         },function(param1:Object):void
         {
            _EndOfGameScoreboard_Image1.source = param1;
         },"_EndOfGameScoreboard_Image1.source");
         result[0] = binding;
         binding = new Binding(this,function():Object
         {
            return OVERVIEW_SCOREBOARD_DIVIDER;
         },function(param1:Object):void
         {
            _EndOfGameScoreboard_Image6.source = param1;
         },"_EndOfGameScoreboard_Image6.source");
         result[1] = binding;
         binding = new Binding(this,function():Object
         {
            return OVERVIEW_SCOREBOARD_SUMMONER_ICON;
         },function(param1:Object):void
         {
            _EndOfGameScoreboard_Image7.source = param1;
         },"_EndOfGameScoreboard_Image7.source");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("end_of_game_scoreboard_summoner_tooltip","Summoner");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _EndOfGameScoreboard_Image7.toolTip = param1;
         },"_EndOfGameScoreboard_Image7.toolTip");
         result[3] = binding;
         binding = new Binding(this,function():Object
         {
            return OVERVIEW_SCOREBOARD_KDA_ICON;
         },function(param1:Object):void
         {
            _EndOfGameScoreboard_Image8.source = param1;
         },"_EndOfGameScoreboard_Image8.source");
         result[4] = binding;
         binding = new Binding(this,function():Number
         {
            return isDominionStatType ? 318 : 322;
         },function(param1:Number):void
         {
            _EndOfGameScoreboard_Image8.x = param1;
         },"_EndOfGameScoreboard_Image8.x");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = toolTipKDA;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _EndOfGameScoreboard_Image8.toolTip = param1;
         },"_EndOfGameScoreboard_Image8.toolTip");
         result[6] = binding;
         binding = new Binding(this,function():Object
         {
            return OVERVIEW_SCOREBOARD_SPELLS_ICON;
         },function(param1:Object):void
         {
            _EndOfGameScoreboard_Image9.source = param1;
         },"_EndOfGameScoreboard_Image9.source");
         result[7] = binding;
         binding = new Binding(this,function():Number
         {
            return isDominionStatType ? 390 : 418;
         },function(param1:Number):void
         {
            _EndOfGameScoreboard_Image9.x = param1;
         },"_EndOfGameScoreboard_Image9.x");
         result[8] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("end_of_game_scoreboard_spells_tooltip","Selected spells");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _EndOfGameScoreboard_Image9.toolTip = param1;
         },"_EndOfGameScoreboard_Image9.toolTip");
         result[9] = binding;
         binding = new Binding(this,function():Object
         {
            return OVERVIEW_SCOREBOARD_ITEMS_ICON;
         },function(param1:Object):void
         {
            _EndOfGameScoreboard_Image10.source = param1;
         },"_EndOfGameScoreboard_Image10.source");
         result[10] = binding;
         binding = new Binding(this,function():Number
         {
            return isDominionStatType ? 528 : 562;
         },function(param1:Number):void
         {
            _EndOfGameScoreboard_Image10.x = param1;
         },"_EndOfGameScoreboard_Image10.x");
         result[11] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("end_of_game_scoreboard_items_tooltip","Selected spells");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _EndOfGameScoreboard_Image10.toolTip = param1;
         },"_EndOfGameScoreboard_Image10.toolTip");
         result[12] = binding;
         binding = new Binding(this,function():Object
         {
            return OVERVIEW_SCOREBOARD_POINT_CAP_ICON;
         },function(param1:Object):void
         {
            _EndOfGameScoreboard_Image11.source = param1;
         },"_EndOfGameScoreboard_Image11.source");
         result[13] = binding;
         binding = new Binding(this,function():Boolean
         {
            return showPointCapIcon;
         },function(param1:Boolean):void
         {
            _EndOfGameScoreboard_Image11.visible = param1;
         },"_EndOfGameScoreboard_Image11.visible");
         result[14] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("dominion_points_captured_or_neutralized");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _EndOfGameScoreboard_Image11.toolTip = param1;
         },"_EndOfGameScoreboard_Image11.toolTip");
         result[15] = binding;
         binding = new Binding(this,function():Object
         {
            return OVERVIEW_SCOREBOARD_GOLD_ICON;
         },function(param1:Object):void
         {
            _EndOfGameScoreboard_Image12.source = param1;
         },"_EndOfGameScoreboard_Image12.source");
         result[16] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !isDominionStatType;
         },function(param1:Boolean):void
         {
            _EndOfGameScoreboard_Image12.visible = param1;
         },"_EndOfGameScoreboard_Image12.visible");
         result[17] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getStatResourceString(RawStatType.GOLD_EARNED,"Gold earned");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _EndOfGameScoreboard_Image12.toolTip = param1;
         },"_EndOfGameScoreboard_Image12.toolTip");
         result[18] = binding;
         binding = new Binding(this,function():Object
         {
            return OVERVIEW_SCOREBOARD_MINIONS_ICON;
         },function(param1:Object):void
         {
            _EndOfGameScoreboard_Image13.source = param1;
         },"_EndOfGameScoreboard_Image13.source");
         result[19] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !isDominionStatType;
         },function(param1:Boolean):void
         {
            _EndOfGameScoreboard_Image13.visible = param1;
         },"_EndOfGameScoreboard_Image13.visible");
         result[20] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getStatResourceString(RawStatType.MINIONS_KILLED,"Minions killed");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _EndOfGameScoreboard_Image13.toolTip = param1;
         },"_EndOfGameScoreboard_Image13.toolTip");
         result[21] = binding;
         binding = new Binding(this,function():Object
         {
            return OVERVIEW_SCOREBOARD_RENOWN_ICON;
         },function(param1:Object):void
         {
            _EndOfGameScoreboard_Image14.source = param1;
         },"_EndOfGameScoreboard_Image14.source");
         result[22] = binding;
         binding = new Binding(this,function():Boolean
         {
            return isDominionStatType;
         },function(param1:Boolean):void
         {
            _EndOfGameScoreboard_Image14.visible = param1;
         },"_EndOfGameScoreboard_Image14.visible");
         result[23] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getStatResourceString(RawStatType.TOTAL_PLAYER_SCORE,"Total renown");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _EndOfGameScoreboard_Image14.toolTip = param1;
         },"_EndOfGameScoreboard_Image14.toolTip");
         result[24] = binding;
         return result;
      }
      
      public function set eogScoreboardBase(param1:Canvas) : void
      {
         var _loc2_:Object = this._449715486eogScoreboardBase;
         if(_loc2_ !== param1)
         {
            this._449715486eogScoreboardBase = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"eogScoreboardBase",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get isDominionStatType() : Boolean
      {
         return this._268058841isDominionStatType;
      }
      
      private function set showPointCapIcon(param1:Boolean) : void
      {
         var _loc2_:Object = this._403534680showPointCapIcon;
         if(_loc2_ !== param1)
         {
            this._403534680showPointCapIcon = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showPointCapIcon",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get topSideColorImageRight() : Image
      {
         return this._1736862552topSideColorImageRight;
      }
      
      [Bindable(event="propertyChange")]
      private function get showPointCapIcon() : Boolean
      {
         return this._403534680showPointCapIcon;
      }
      
      public function set eogScoreboard(param1:Canvas) : void
      {
         var _loc2_:Object = this._756942961eogScoreboard;
         if(_loc2_ !== param1)
         {
            this._756942961eogScoreboard = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"eogScoreboard",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get eogScoreboard() : Canvas
      {
         return this._756942961eogScoreboard;
      }
      
      [Bindable(event="propertyChange")]
      public function get topSideColorImageLeft() : Image
      {
         return this._498344117topSideColorImageLeft;
      }
      
      [Bindable(event="propertyChange")]
      public function get eogScoreboardBase() : Canvas
      {
         return this._449715486eogScoreboardBase;
      }
      
      public function set bottomSideColorImageLeft(param1:Image) : void
      {
         var _loc2_:Object = this._301952673bottomSideColorImageLeft;
         if(_loc2_ !== param1)
         {
            this._301952673bottomSideColorImageLeft = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bottomSideColorImageLeft",_loc2_,param1));
         }
      }
   }
}

