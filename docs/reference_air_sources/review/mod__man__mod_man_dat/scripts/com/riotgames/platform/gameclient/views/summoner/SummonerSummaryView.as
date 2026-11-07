package com.riotgames.platform.gameclient.views.summoner
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.common.components.controls.ToggleButtonBar;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.components.WingedHeader;
   import com.riotgames.platform.gameclient.controllers.summoner.SummonerProfileController;
   import com.riotgames.platform.gameclient.domain.PlayerChampionStats;
   import com.riotgames.platform.gameclient.domain.game.CompetitiveSeason;
   import com.riotgames.platform.gameclient.domain.game.GameMode;
   import com.riotgames.platform.gameclient.views.summoner.stats.ProfileStatsRankingView;
   import com.riotgames.platform.gameclient.views.summoner.stats.ProfileStatsSummaryPresentationModel;
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
   import mx.containers.utilityClasses.ConstraintColumn;
   import mx.containers.utilityClasses.ConstraintRow;
   import mx.controls.ComboBox;
   import mx.controls.HRule;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.controls.List;
   import mx.core.ClassFactory;
   import mx.core.IFactory;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.effects.Fade;
   import mx.effects.Sequence;
   import mx.effects.SetPropertyAction;
   import mx.events.FlexEvent;
   import mx.events.ListEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class SummonerSummaryView extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static const LOADING_SPINNER:Class = SummonerSummaryView_LOADING_SPINNER;
      
      private var _1691604874colChampions:ConstraintColumn;
      
      private var _1282133823fadeIn:Sequence;
      
      private var _203698510champViewbackground:Image;
      
      private var _1184262209fadeInNoDelay:Sequence;
      
      private var _742530493statsTabBar:ToggleButtonBar;
      
      private var _890874032fadeOutNoDelay:Sequence;
      
      private var _635768853rowFooter:ConstraintRow;
      
      private var _1499252765championsSpinnerBackground:Image;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      private var _271737193champions_rf:Canvas;
      
      private var _166081505champions_rfh:WingedHeader;
      
      private var _1773554352statsViewHolder:Canvas;
      
      private var _349866748modeSelectComboBox:ComboBox;
      
      private var _566834807summonerProfileController:SummonerProfileController;
      
      private var _selectedSeason:int;
      
      private var _1398853558rightSpace:ConstraintColumn;
      
      mx_internal var _watchers:Array = [];
      
      private var _654621953colStats:ConstraintColumn;
      
      private var statsLoadedWatcher:ChangeWatcher;
      
      private var _197941977rowTopSpacer:ConstraintRow;
      
      private var _1008437926rowSpacer:ConstraintRow;
      
      private var _1038603282statsViewbackground:Image;
      
      private var _1565573630statsOverviewHeaderIcon:Image;
      
      private var _1326310780profileSignitureHeader:SummonerInfoQuickView;
      
      private var _552009446headerSpinnerBackground:Image;
      
      private var _1091442799fadeIn2:Sequence;
      
      private var _298879973statsOverviewHeader:Label;
      
      [Inject]
      private var _1292102721profileStatsSummaryPresentationModel:ProfileStatsSummaryPresentationModel;
      
      private var _1730759999leftSpace:ConstraintColumn;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      private var _192213542quickViewChampions_lst:List;
      
      private var _1685962393headerHolder:Canvas;
      
      private var _541410632statsSpinnerBackground:Image;
      
      private var _1395425681rowProfile:ConstraintRow;
      
      private var _32649957rowStats:ConstraintRow;
      
      mx_internal var _bindings:Array = [];
      
      private var _2072900636statsView:ProfileStatsRankingView;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":Canvas,
               "id":"headerHolder",
               "stylesFactory":function():void
               {
                  this.left = "colStats:-15";
                  this.right = "colChampions:-17";
                  this.top = "rowProfile:-7";
                  this.bottom = "rowProfile:0";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "cacheAsBitmap":true,
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":SummonerInfoQuickView,
                        "id":"profileSignitureHeader",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentWidth":100,
                              "percentHeight":100
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Image,
                        "id":"headerSpinnerBackground"
                     })]
                  };
               }
            }),new UIComponentDescriptor({
               "type":Image,
               "id":"statsOverviewHeaderIcon",
               "stylesFactory":function():void
               {
                  this.bottom = "rowProfile:5";
                  this.left = "colStats:0";
               }
            }),new UIComponentDescriptor({
               "type":Label,
               "id":"statsOverviewHeader",
               "stylesFactory":function():void
               {
                  this.bottom = "rowProfile:0";
                  this.left = "colStats:5";
                  this.fontFamily = "ApplicationFont1";
                  this.color = 4460817;
                  this.fontSize = 22;
               }
            }),new UIComponentDescriptor({
               "type":HRule,
               "stylesFactory":function():void
               {
                  this.top = "rowSpacer:0";
                  this.left = "colStats:0";
                  this.right = "colChampions:0";
               },
               "propertiesFactory":function():Object
               {
                  return {"styleName":"parchment"};
               }
            }),new UIComponentDescriptor({
               "type":ComboBox,
               "id":"modeSelectComboBox",
               "stylesFactory":function():void
               {
                  this.bottom = "rowSpacer:5";
                  this.right = "colStats:33";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "height":25,
                     "width":150,
                     "styleName":"summonerSummaryBox"
                  };
               }
            }),new UIComponentDescriptor({
               "type":Image,
               "id":"statsViewbackground",
               "stylesFactory":function():void
               {
                  this.top = "rowStats:0";
                  this.left = "colStats:0";
               }
            }),new UIComponentDescriptor({
               "type":Canvas,
               "id":"statsViewHolder",
               "stylesFactory":function():void
               {
                  this.top = "rowStats:0";
                  this.left = "colStats:0";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "cacheAsBitmap":true,
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":ProfileStatsRankingView,
                        "id":"statsView",
                        "stylesFactory":function():void
                        {
                           this.top = "5";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentWidth":100,
                              "percentHeight":100,
                              "creationPolicy":"all"
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Image,
                        "id":"statsSpinnerBackground"
                     })]
                  };
               }
            }),new UIComponentDescriptor({
               "type":ToggleButtonBar,
               "id":"statsTabBar",
               "stylesFactory":function():void
               {
                  this.left = "colStats:0";
                  this.bottom = "rowSpacer:-3";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "styleName":"profileStatsTabBar",
                     "tabEnabled":false,
                     "tabChildren":false
                  };
               }
            }),new UIComponentDescriptor({
               "type":Image,
               "id":"champViewbackground",
               "stylesFactory":function():void
               {
                  this.top = "rowStats:0";
                  this.right = "colChampions:0";
               }
            }),new UIComponentDescriptor({
               "type":Canvas,
               "id":"champions_rf",
               "stylesFactory":function():void
               {
                  this.top = "rowStats:0";
                  this.right = "colChampions:0";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "cacheAsBitmap":true,
                     "horizontalScrollPolicy":"off",
                     "verticalScrollPolicy":"off",
                     "tabEnabled":false,
                     "tabChildren":false,
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":WingedHeader,
                        "id":"champions_rfh",
                        "stylesFactory":function():void
                        {
                           this.textAlign = "left";
                           this.left = "5";
                           this.top = "0";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "styleName":"profileHeaderText",
                              "height":37
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":List,
                        "id":"quickViewChampions_lst",
                        "events":{"itemClick":"__quickViewChampions_lst_itemClick"},
                        "stylesFactory":function():void
                        {
                           this.top = "36";
                           this.backgroundAlpha = 0;
                           this.borderStyle = "none";
                           this.useRollOver = true;
                           this.paddingBottom = 0;
                           this.paddingTop = 0;
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentWidth":100,
                              "rowHeight":70,
                              "selectable":false,
                              "horizontalScrollPolicy":"off",
                              "verticalScrollPolicy":"off"
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Image,
                        "id":"championsSpinnerBackground"
                     })]
                  };
               }
            })]};
         }
      });
      
      public function SummonerSummaryView()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.percentWidth = 100;
         this.percentHeight = 100;
         this.constraintColumns = [this._SummonerSummaryView_ConstraintColumn1_i(),this._SummonerSummaryView_ConstraintColumn2_i(),this._SummonerSummaryView_ConstraintColumn3_i(),this._SummonerSummaryView_ConstraintColumn4_i()];
         this.constraintRows = [this._SummonerSummaryView_ConstraintRow1_i(),this._SummonerSummaryView_ConstraintRow2_i(),this._SummonerSummaryView_ConstraintRow3_i(),this._SummonerSummaryView_ConstraintRow4_i(),this._SummonerSummaryView_ConstraintRow5_i()];
         this._SummonerSummaryView_Sequence1_i();
         this._SummonerSummaryView_Sequence2_i();
         this._SummonerSummaryView_Sequence3_i();
         this._SummonerSummaryView_Sequence4_i();
         this.addEventListener("creationComplete",this.___SummonerSummaryView_Canvas1_creationComplete);
         this.addEventListener("initialize",this.___SummonerSummaryView_Canvas1_initialize);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         SummonerSummaryView._watcherSetupUtil = param1;
      }
      
      private static function getLocalizedSeasonGameModeList() : Array
      {
         return [{
            "name":GameMode.CLASSIC,
            "label":RiotResourceLoader.getString(GameMode.CLASSIC.toLowerCase() + "_shortened_game_mode_name",GameMode.CLASSIC.toLowerCase())
         },{
            "name":GameMode.DOMINION,
            "label":RiotResourceLoader.getString(GameMode.DOMINION.toLowerCase() + "_shortened_game_mode_name",GameMode.DOMINION.toLowerCase())
         },{
            "name":GameMode.ARAM,
            "label":RiotResourceLoader.getString(GameMode.ARAM.toLowerCase() + "_shortened_game_mode_name",GameMode.ARAM.toLowerCase())
         }];
      }
      
      private function onChampionClick(param1:ListEvent) : void
      {
         var _loc2_:PlayerChampionStats = this.summonerProfileController.quickChampions.getItemAt(param1.rowIndex) as PlayerChampionStats;
      }
      
      [Bindable(event="propertyChange")]
      public function get statsOverviewHeaderIcon() : Image
      {
         return this._1565573630statsOverviewHeaderIcon;
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeIn() : Sequence
      {
         return this._1282133823fadeIn;
      }
      
      private function _SummonerSummaryView_ConstraintRow1_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.rowTopSpacer = _loc1_;
         _loc1_.percentHeight = 5;
         _loc1_.initialized(this,"rowTopSpacer");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get colStats() : ConstraintColumn
      {
         return this._654621953colStats;
      }
      
      public function set profileSignitureHeader(param1:SummonerInfoQuickView) : void
      {
         var _loc2_:Object = this._1326310780profileSignitureHeader;
         if(_loc2_ !== param1)
         {
            this._1326310780profileSignitureHeader = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"profileSignitureHeader",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get statsViewbackground() : Image
      {
         return this._1038603282statsViewbackground;
      }
      
      public function set colChampions(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._1691604874colChampions;
         if(_loc2_ !== param1)
         {
            this._1691604874colChampions = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"colChampions",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rowFooter() : ConstraintRow
      {
         return this._635768853rowFooter;
      }
      
      private function _SummonerSummaryView_Fade4_c() : Fade
      {
         var _loc1_:Fade = new Fade();
         _loc1_.duration = 375;
         _loc1_.alphaFrom = 1;
         _loc1_.alphaTo = 0;
         _loc1_.startDelay = 0;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get championsSpinnerBackground() : Image
      {
         return this._1499252765championsSpinnerBackground;
      }
      
      public function set statsOverviewHeaderIcon(param1:Image) : void
      {
         var _loc2_:Object = this._1565573630statsOverviewHeaderIcon;
         if(_loc2_ !== param1)
         {
            this._1565573630statsOverviewHeaderIcon = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statsOverviewHeaderIcon",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get champions_rfh() : WingedHeader
      {
         return this._166081505champions_rfh;
      }
      
      [Bindable(event="propertyChange")]
      public function get headerSpinnerBackground() : Image
      {
         return this._552009446headerSpinnerBackground;
      }
      
      private function _SummonerSummaryView_ConstraintRow4_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.rowStats = _loc1_;
         _loc1_.percentHeight = 48;
         _loc1_.initialized(this,"rowStats");
         return _loc1_;
      }
      
      public function set statsViewbackground(param1:Image) : void
      {
         var _loc2_:Object = this._1038603282statsViewbackground;
         if(_loc2_ !== param1)
         {
            this._1038603282statsViewbackground = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statsViewbackground",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get quickViewChampions_lst() : List
      {
         return this._192213542quickViewChampions_lst;
      }
      
      [Bindable(event="propertyChange")]
      public function get rowTopSpacer() : ConstraintRow
      {
         return this._197941977rowTopSpacer;
      }
      
      public function set fadeIn2(param1:Sequence) : void
      {
         var _loc2_:Object = this._1091442799fadeIn2;
         if(_loc2_ !== param1)
         {
            this._1091442799fadeIn2 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeIn2",_loc2_,param1));
         }
      }
      
      private function _SummonerSummaryView_ConstraintColumn4_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.rightSpace = _loc1_;
         _loc1_.percentWidth = 3;
         _loc1_.initialized(this,"rightSpace");
         return _loc1_;
      }
      
      private function _SummonerSummaryView_SetPropertyAction3_c() : SetPropertyAction
      {
         var _loc1_:SetPropertyAction = new SetPropertyAction();
         _loc1_.name = "alpha";
         _loc1_.value = 0;
         return _loc1_;
      }
      
      public function set rowFooter(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._635768853rowFooter;
         if(_loc2_ !== param1)
         {
            this._635768853rowFooter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rowFooter",_loc2_,param1));
         }
      }
      
      public function set headerHolder(param1:Canvas) : void
      {
         var _loc2_:Object = this._1685962393headerHolder;
         if(_loc2_ !== param1)
         {
            this._1685962393headerHolder = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"headerHolder",_loc2_,param1));
         }
      }
      
      private function onCreationComplete() : void
      {
         this._selectedSeason = this.summonerProfileController.currentStatsSeason;
      }
      
      public function set championsSpinnerBackground(param1:Image) : void
      {
         var _loc2_:Object = this._1499252765championsSpinnerBackground;
         if(_loc2_ !== param1)
         {
            this._1499252765championsSpinnerBackground = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championsSpinnerBackground",_loc2_,param1));
         }
      }
      
      private function _SummonerSummaryView_Sequence4_i() : Sequence
      {
         var _loc1_:Sequence = new Sequence();
         this.fadeOutNoDelay = _loc1_;
         _loc1_.children = [this._SummonerSummaryView_SetPropertyAction4_c(),this._SummonerSummaryView_Fade4_c()];
         return _loc1_;
      }
      
      public function set champions_rfh(param1:WingedHeader) : void
      {
         var _loc2_:Object = this._166081505champions_rfh;
         if(_loc2_ !== param1)
         {
            this._166081505champions_rfh = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"champions_rfh",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeInNoDelay() : Sequence
      {
         return this._1184262209fadeInNoDelay;
      }
      
      [Bindable(event="propertyChange")]
      public function get statsSpinnerBackground() : Image
      {
         return this._541410632statsSpinnerBackground;
      }
      
      public function __quickViewChampions_lst_itemClick(param1:ListEvent) : void
      {
         this.onChampionClick(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get leftSpace() : ConstraintColumn
      {
         return this._1730759999leftSpace;
      }
      
      [Bindable(event="propertyChange")]
      public function get rightSpace() : ConstraintColumn
      {
         return this._1398853558rightSpace;
      }
      
      public function set quickViewChampions_lst(param1:List) : void
      {
         var _loc2_:Object = this._192213542quickViewChampions_lst;
         if(_loc2_ !== param1)
         {
            this._192213542quickViewChampions_lst = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"quickViewChampions_lst",_loc2_,param1));
         }
      }
      
      public function initializeView() : void
      {
         if(!this.visible)
         {
            return;
         }
         this.statsView.initializeView();
      }
      
      public function set headerSpinnerBackground(param1:Image) : void
      {
         var _loc2_:Object = this._552009446headerSpinnerBackground;
         if(_loc2_ !== param1)
         {
            this._552009446headerSpinnerBackground = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"headerSpinnerBackground",_loc2_,param1));
         }
      }
      
      private function _SummonerSummaryView_Fade3_c() : Fade
      {
         var _loc1_:Fade = new Fade();
         _loc1_.duration = 375;
         _loc1_.alphaFrom = 0;
         _loc1_.alphaTo = 1;
         _loc1_.startDelay = 0;
         return _loc1_;
      }
      
      public function set rowSpacer(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._1008437926rowSpacer;
         if(_loc2_ !== param1)
         {
            this._1008437926rowSpacer = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rowSpacer",_loc2_,param1));
         }
      }
      
      public function set rowTopSpacer(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._197941977rowTopSpacer;
         if(_loc2_ !== param1)
         {
            this._197941977rowTopSpacer = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rowTopSpacer",_loc2_,param1));
         }
      }
      
      public function set fadeOutNoDelay(param1:Sequence) : void
      {
         var _loc2_:Object = this._890874032fadeOutNoDelay;
         if(_loc2_ !== param1)
         {
            this._890874032fadeOutNoDelay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeOutNoDelay",_loc2_,param1));
         }
      }
      
      private function _SummonerSummaryView_ConstraintRow3_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.rowSpacer = _loc1_;
         _loc1_.percentHeight = 7;
         _loc1_.initialized(this,"rowSpacer");
         return _loc1_;
      }
      
      public function set champViewbackground(param1:Image) : void
      {
         var _loc2_:Object = this._203698510champViewbackground;
         if(_loc2_ !== param1)
         {
            this._203698510champViewbackground = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"champViewbackground",_loc2_,param1));
         }
      }
      
      public function set statsViewHolder(param1:Canvas) : void
      {
         var _loc2_:Object = this._1773554352statsViewHolder;
         if(_loc2_ !== param1)
         {
            this._1773554352statsViewHolder = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statsViewHolder",_loc2_,param1));
         }
      }
      
      private function _SummonerSummaryView_ConstraintColumn3_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.colChampions = _loc1_;
         _loc1_.percentWidth = 25;
         _loc1_.initialized(this,"colChampions");
         return _loc1_;
      }
      
      private function _SummonerSummaryView_SetPropertyAction2_c() : SetPropertyAction
      {
         var _loc1_:SetPropertyAction = new SetPropertyAction();
         _loc1_.name = "alpha";
         _loc1_.value = 0;
         return _loc1_;
      }
      
      private function _SummonerSummaryView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():*
         {
            return fadeIn;
         },function(param1:*):void
         {
            this.setStyle("showEffect",param1);
         },"this.showEffect");
         result[0] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.summonerProfileController.isSummonerStatsLoaded;
         },function(param1:Boolean):void
         {
            profileSignitureHeader.visible = param1;
         },"profileSignitureHeader.visible");
         result[1] = binding;
         binding = new Binding(this,function():Number
         {
            return headerHolder.width * 0.5 - 50;
         },function(param1:Number):void
         {
            headerSpinnerBackground.x = param1;
         },"headerSpinnerBackground.x");
         result[2] = binding;
         binding = new Binding(this,function():Number
         {
            return headerHolder.height * 0.5 - 24;
         },function(param1:Number):void
         {
            headerSpinnerBackground.y = param1;
         },"headerSpinnerBackground.y");
         result[3] = binding;
         binding = new Binding(this,function():Object
         {
            return LOADING_SPINNER;
         },function(param1:Object):void
         {
            headerSpinnerBackground.source = param1;
         },"headerSpinnerBackground.source");
         result[4] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !this.summonerProfileController.isSummonerStatsLoaded;
         },function(param1:Boolean):void
         {
            headerSpinnerBackground.visible = param1;
         },"headerSpinnerBackground.visible");
         result[5] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_pvp_headerFlame_brown");
         },function(param1:Object):void
         {
            statsOverviewHeaderIcon.source = param1;
         },"statsOverviewHeaderIcon.source");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","summonerProfile_profile_StatsOverviewHeader");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            statsOverviewHeader.text = param1;
         },"statsOverviewHeader.text");
         result[7] = binding;
         binding = new Binding(this,function():Object
         {
            return getLocalizedSeasonGameModeList();
         },function(param1:Object):void
         {
            modeSelectComboBox.dataProvider = param1;
         },"modeSelectComboBox.dataProvider");
         result[8] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_statstabs_bg");
         },function(param1:Object):void
         {
            statsViewbackground.source = param1;
         },"statsViewbackground.source");
         result[9] = binding;
         binding = new Binding(this,function():Number
         {
            return statsViewbackground.width;
         },function(param1:Number):void
         {
            statsViewHolder.width = param1;
         },"statsViewHolder.width");
         result[10] = binding;
         binding = new Binding(this,function():Number
         {
            return statsViewbackground.height;
         },function(param1:Number):void
         {
            statsViewHolder.height = param1;
         },"statsViewHolder.height");
         result[11] = binding;
         binding = new Binding(this,function():SummonerProfileController
         {
            return this.summonerProfileController;
         },function(param1:SummonerProfileController):void
         {
            statsView.summonerProfileController = param1;
         },"statsView.summonerProfileController");
         result[12] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = modeSelectComboBox.selectedItem.name;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            statsView.gameMode = param1;
         },"statsView.gameMode");
         result[13] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.summonerProfileController.isSummonerStatsLoaded;
         },function(param1:Boolean):void
         {
            statsView.visible = param1;
         },"statsView.visible");
         result[14] = binding;
         binding = new Binding(this,function():Number
         {
            return statsViewHolder.width * 0.5 - 50;
         },function(param1:Number):void
         {
            statsSpinnerBackground.x = param1;
         },"statsSpinnerBackground.x");
         result[15] = binding;
         binding = new Binding(this,function():Number
         {
            return statsViewHolder.height * 0.5 - 24;
         },function(param1:Number):void
         {
            statsSpinnerBackground.y = param1;
         },"statsSpinnerBackground.y");
         result[16] = binding;
         binding = new Binding(this,function():Object
         {
            return LOADING_SPINNER;
         },function(param1:Object):void
         {
            statsSpinnerBackground.source = param1;
         },"statsSpinnerBackground.source");
         result[17] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !this.summonerProfileController.isSummonerStatsLoaded;
         },function(param1:Boolean):void
         {
            statsSpinnerBackground.visible = param1;
         },"statsSpinnerBackground.visible");
         result[18] = binding;
         binding = new Binding(this,function():Object
         {
            return statsView;
         },function(param1:Object):void
         {
            statsTabBar.dataProvider = param1;
         },"statsTabBar.dataProvider");
         result[19] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_mostplayedchamps");
         },function(param1:Object):void
         {
            champViewbackground.source = param1;
         },"champViewbackground.source");
         result[20] = binding;
         binding = new Binding(this,function():*
         {
            return fadeInNoDelay;
         },function(param1:*):void
         {
            champViewbackground.setStyle("showEffect",param1);
         },"champViewbackground.showEffect");
         result[21] = binding;
         binding = new Binding(this,function():*
         {
            return fadeOutNoDelay;
         },function(param1:*):void
         {
            champViewbackground.setStyle("hideEffect",param1);
         },"champViewbackground.hideEffect");
         result[22] = binding;
         binding = new Binding(this,function():Number
         {
            return champViewbackground.width;
         },function(param1:Number):void
         {
            champions_rf.width = param1;
         },"champions_rf.width");
         result[23] = binding;
         binding = new Binding(this,function():Number
         {
            return champViewbackground.height;
         },function(param1:Number):void
         {
            champions_rf.height = param1;
         },"champions_rf.height");
         result[24] = binding;
         binding = new Binding(this,function():*
         {
            return fadeInNoDelay;
         },function(param1:*):void
         {
            champions_rf.setStyle("showEffect",param1);
         },"champions_rf.showEffect");
         result[25] = binding;
         binding = new Binding(this,function():*
         {
            return fadeOutNoDelay;
         },function(param1:*):void
         {
            champions_rf.setStyle("hideEffect",param1);
         },"champions_rf.hideEffect");
         result[26] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","summonerProfile_profile_mostPlayedChampionsHeaderLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            champions_rfh.headerText = param1;
         },"champions_rfh.headerText");
         result[27] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = WingedHeader.NONE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            champions_rfh.currentState = param1;
         },"champions_rfh.currentState");
         result[28] = binding;
         binding = new Binding(this,function():Object
         {
            return this.summonerProfileController.quickChampions;
         },function(param1:Object):void
         {
            quickViewChampions_lst.dataProvider = param1;
         },"quickViewChampions_lst.dataProvider");
         result[29] = binding;
         binding = new Binding(this,function():IFactory
         {
            return new ClassFactory(QuickViewChampionsRenderer);
         },function(param1:IFactory):void
         {
            quickViewChampions_lst.itemRenderer = param1;
         },"quickViewChampions_lst.itemRenderer");
         result[30] = binding;
         binding = new Binding(this,function():*
         {
            return fadeIn2;
         },function(param1:*):void
         {
            quickViewChampions_lst.setStyle("showEffect",param1);
         },"quickViewChampions_lst.showEffect");
         result[31] = binding;
         binding = new Binding(this,function():Number
         {
            return champions_rf.width * 0.5 - 25;
         },function(param1:Number):void
         {
            championsSpinnerBackground.x = param1;
         },"championsSpinnerBackground.x");
         result[32] = binding;
         binding = new Binding(this,function():Number
         {
            return champions_rf.height * 0.5;
         },function(param1:Number):void
         {
            championsSpinnerBackground.y = param1;
         },"championsSpinnerBackground.y");
         result[33] = binding;
         binding = new Binding(this,function():Object
         {
            return LOADING_SPINNER;
         },function(param1:Object):void
         {
            championsSpinnerBackground.source = param1;
         },"championsSpinnerBackground.source");
         result[34] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !this.summonerProfileController.isSummonerStatsLoaded;
         },function(param1:Boolean):void
         {
            championsSpinnerBackground.visible = param1;
         },"championsSpinnerBackground.visible");
         result[35] = binding;
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get rowProfile() : ConstraintRow
      {
         return this._1395425681rowProfile;
      }
      
      public function ___SummonerSummaryView_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      public function set statsTabBar(param1:ToggleButtonBar) : void
      {
         var _loc2_:Object = this._742530493statsTabBar;
         if(_loc2_ !== param1)
         {
            this._742530493statsTabBar = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statsTabBar",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get champions_rf() : Canvas
      {
         return this._271737193champions_rf;
      }
      
      private function indexChanged(param1:Event) : void
      {
         if(this.statsView.selectedIndex == 1 && this._selectedSeason != CompetitiveSeason.currentSeason)
         {
            this._selectedSeason = CompetitiveSeason.currentSeason;
            this.summonerProfileController.refreshSummonerDetails(this._selectedSeason);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerProfileController() : SummonerProfileController
      {
         return this._566834807summonerProfileController;
      }
      
      public function set fadeIn(param1:Sequence) : void
      {
         var _loc2_:Object = this._1282133823fadeIn;
         if(_loc2_ !== param1)
         {
            this._1282133823fadeIn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeIn",_loc2_,param1));
         }
      }
      
      private function _SummonerSummaryView_Sequence3_i() : Sequence
      {
         var _loc1_:Sequence = new Sequence();
         this.fadeInNoDelay = _loc1_;
         _loc1_.children = [this._SummonerSummaryView_SetPropertyAction3_c(),this._SummonerSummaryView_Fade3_c()];
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get profileSignitureHeader() : SummonerInfoQuickView
      {
         return this._1326310780profileSignitureHeader;
      }
      
      public function set leftSpace(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._1730759999leftSpace;
         if(_loc2_ !== param1)
         {
            this._1730759999leftSpace = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leftSpace",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:SummonerSummaryView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._SummonerSummaryView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_summoner_SummonerSummaryViewWatcherSetupUtil");
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
      public function get colChampions() : ConstraintColumn
      {
         return this._1691604874colChampions;
      }
      
      public function resetView() : void
      {
         if(this.statsView)
         {
            this.statsView.resetView();
         }
         if(this.profileSignitureHeader)
         {
            this.profileSignitureHeader.resetView();
         }
      }
      
      private function _SummonerSummaryView_Fade2_c() : Fade
      {
         var _loc1_:Fade = new Fade();
         _loc1_.duration = 375;
         _loc1_.alphaFrom = 0;
         _loc1_.alphaTo = 1;
         _loc1_.startDelay = 500;
         return _loc1_;
      }
      
      private function _SummonerSummaryView_ConstraintRow2_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.rowProfile = _loc1_;
         _loc1_.percentHeight = 37;
         _loc1_.initialized(this,"rowProfile");
         return _loc1_;
      }
      
      private function _SummonerSummaryView_ConstraintColumn2_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.colStats = _loc1_;
         _loc1_.percentWidth = 69;
         _loc1_.initialized(this,"colStats");
         return _loc1_;
      }
      
      private function _SummonerSummaryView_SetPropertyAction1_c() : SetPropertyAction
      {
         var _loc1_:SetPropertyAction = new SetPropertyAction();
         _loc1_.name = "alpha";
         _loc1_.value = 0;
         return _loc1_;
      }
      
      public function set profileStatsSummaryPresentationModel(param1:ProfileStatsSummaryPresentationModel) : void
      {
         var _loc2_:Object = this._1292102721profileStatsSummaryPresentationModel;
         if(_loc2_ !== param1)
         {
            this._1292102721profileStatsSummaryPresentationModel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"profileStatsSummaryPresentationModel",_loc2_,param1));
         }
      }
      
      public function set rightSpace(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._1398853558rightSpace;
         if(_loc2_ !== param1)
         {
            this._1398853558rightSpace = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rightSpace",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rowSpacer() : ConstraintRow
      {
         return this._1008437926rowSpacer;
      }
      
      private function updateStatsDisplay(param1:ListEvent) : void
      {
         var _loc2_:ComboBox = param1.currentTarget as ComboBox;
         if(_loc2_.selectedItem.name != this._selectedSeason)
         {
            this._selectedSeason = _loc2_.selectedIndex;
            this.summonerProfileController.refreshSummonerDetails(this._selectedSeason);
         }
      }
      
      public function set fadeInNoDelay(param1:Sequence) : void
      {
         var _loc2_:Object = this._1184262209fadeInNoDelay;
         if(_loc2_ !== param1)
         {
            this._1184262209fadeInNoDelay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeInNoDelay",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get headerHolder() : Canvas
      {
         return this._1685962393headerHolder;
      }
      
      [Bindable(event="propertyChange")]
      public function get champViewbackground() : Image
      {
         return this._203698510champViewbackground;
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeIn2() : Sequence
      {
         return this._1091442799fadeIn2;
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeOutNoDelay() : Sequence
      {
         return this._890874032fadeOutNoDelay;
      }
      
      public function set statsSpinnerBackground(param1:Image) : void
      {
         var _loc2_:Object = this._541410632statsSpinnerBackground;
         if(_loc2_ !== param1)
         {
            this._541410632statsSpinnerBackground = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statsSpinnerBackground",_loc2_,param1));
         }
      }
      
      private function _SummonerSummaryView_Sequence2_i() : Sequence
      {
         var _loc1_:Sequence = new Sequence();
         this.fadeIn2 = _loc1_;
         _loc1_.children = [this._SummonerSummaryView_SetPropertyAction2_c(),this._SummonerSummaryView_Fade2_c()];
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get statsTabBar() : ToggleButtonBar
      {
         return this._742530493statsTabBar;
      }
      
      public function set rowStats(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._32649957rowStats;
         if(_loc2_ !== param1)
         {
            this._32649957rowStats = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rowStats",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get profileStatsSummaryPresentationModel() : ProfileStatsSummaryPresentationModel
      {
         return this._1292102721profileStatsSummaryPresentationModel;
      }
      
      private function onInitialize() : void
      {
         this.statsLoadedWatcher = ChangeWatcher.watch(this.summonerProfileController,"isSummonerStatsLoaded",this.onSummonerStatsLoaded);
         this.statsView.addEventListener(Event.CHANGE,this.indexChanged);
      }
      
      public function set statsOverviewHeader(param1:Label) : void
      {
         var _loc2_:Object = this._298879973statsOverviewHeader;
         if(_loc2_ !== param1)
         {
            this._298879973statsOverviewHeader = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statsOverviewHeader",_loc2_,param1));
         }
      }
      
      public function set statsView(param1:ProfileStatsRankingView) : void
      {
         var _loc2_:Object = this._2072900636statsView;
         if(_loc2_ !== param1)
         {
            this._2072900636statsView = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statsView",_loc2_,param1));
         }
      }
      
      public function set champions_rf(param1:Canvas) : void
      {
         var _loc2_:Object = this._271737193champions_rf;
         if(_loc2_ !== param1)
         {
            this._271737193champions_rf = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"champions_rf",_loc2_,param1));
         }
      }
      
      private function _SummonerSummaryView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.fadeIn;
         _loc1_ = this.summonerProfileController.isSummonerStatsLoaded;
         _loc1_ = this.headerHolder.width * 0.5 - 50;
         _loc1_ = this.headerHolder.height * 0.5 - 24;
         _loc1_ = LOADING_SPINNER;
         _loc1_ = !this.summonerProfileController.isSummonerStatsLoaded;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_pvp_headerFlame_brown");
         _loc1_ = resourceManager.getString("resources","summonerProfile_profile_StatsOverviewHeader");
         _loc1_ = getLocalizedSeasonGameModeList();
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_statstabs_bg");
         _loc1_ = this.statsViewbackground.width;
         _loc1_ = this.statsViewbackground.height;
         _loc1_ = this.summonerProfileController;
         _loc1_ = this.modeSelectComboBox.selectedItem.name;
         _loc1_ = this.summonerProfileController.isSummonerStatsLoaded;
         _loc1_ = this.statsViewHolder.width * 0.5 - 50;
         _loc1_ = this.statsViewHolder.height * 0.5 - 24;
         _loc1_ = LOADING_SPINNER;
         _loc1_ = !this.summonerProfileController.isSummonerStatsLoaded;
         _loc1_ = this.statsView;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_mostplayedchamps");
         _loc1_ = this.fadeInNoDelay;
         _loc1_ = this.fadeOutNoDelay;
         _loc1_ = this.champViewbackground.width;
         _loc1_ = this.champViewbackground.height;
         _loc1_ = this.fadeInNoDelay;
         _loc1_ = this.fadeOutNoDelay;
         _loc1_ = resourceManager.getString("resources","summonerProfile_profile_mostPlayedChampionsHeaderLabel");
         _loc1_ = WingedHeader.NONE;
         _loc1_ = this.summonerProfileController.quickChampions;
         _loc1_ = new ClassFactory(QuickViewChampionsRenderer);
         _loc1_ = this.fadeIn2;
         _loc1_ = this.champions_rf.width * 0.5 - 25;
         _loc1_ = this.champions_rf.height * 0.5;
         _loc1_ = LOADING_SPINNER;
         _loc1_ = !this.summonerProfileController.isSummonerStatsLoaded;
      }
      
      public function set rowProfile(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._1395425681rowProfile;
         if(_loc2_ !== param1)
         {
            this._1395425681rowProfile = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rowProfile",_loc2_,param1));
         }
      }
      
      public function ___SummonerSummaryView_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      private function _SummonerSummaryView_ConstraintRow5_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.rowFooter = _loc1_;
         _loc1_.percentHeight = 3;
         _loc1_.initialized(this,"rowFooter");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get rowStats() : ConstraintRow
      {
         return this._32649957rowStats;
      }
      
      [Bindable(event="propertyChange")]
      public function get statsViewHolder() : Canvas
      {
         return this._1773554352statsViewHolder;
      }
      
      [Bindable(event="propertyChange")]
      public function get statsView() : ProfileStatsRankingView
      {
         return this._2072900636statsView;
      }
      
      private function _SummonerSummaryView_ConstraintColumn1_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.leftSpace = _loc1_;
         _loc1_.percentWidth = 3;
         _loc1_.initialized(this,"leftSpace");
         return _loc1_;
      }
      
      private function _SummonerSummaryView_Fade1_c() : Fade
      {
         var _loc1_:Fade = new Fade();
         _loc1_.duration = 375;
         _loc1_.alphaFrom = 0;
         _loc1_.alphaTo = 1;
         _loc1_.startDelay = 300;
         return _loc1_;
      }
      
      private function _SummonerSummaryView_SetPropertyAction4_c() : SetPropertyAction
      {
         var _loc1_:SetPropertyAction = new SetPropertyAction();
         _loc1_.name = "alpha";
         _loc1_.value = 0;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get statsOverviewHeader() : Label
      {
         return this._298879973statsOverviewHeader;
      }
      
      public function set summonerProfileController(param1:SummonerProfileController) : void
      {
         var _loc2_:Object = this._566834807summonerProfileController;
         if(_loc2_ !== param1)
         {
            this._566834807summonerProfileController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerProfileController",_loc2_,param1));
         }
      }
      
      private function onSummonerStatsLoaded(param1:PropertyChangeEvent) : void
      {
         if(!this.profileStatsSummaryPresentationModel)
         {
            return;
         }
         if(Boolean(this.summonerProfileController.isSummonerStatsLoaded) && Boolean(this.statsTabBar))
         {
            this._selectedSeason = this.summonerProfileController.currentStatsSeason;
            if(this.profileStatsSummaryPresentationModel.totalRankedWins > 0 && Boolean(this.profileStatsSummaryPresentationModel.showStats) && this.modeSelectComboBox.selectedItem.name == GameMode.CLASSIC)
            {
               this.statsTabBar.selectedIndex = 0;
            }
            else
            {
               this.statsTabBar.selectedIndex = 1;
            }
         }
      }
      
      public function set modeSelectComboBox(param1:ComboBox) : void
      {
         var _loc2_:Object = this._349866748modeSelectComboBox;
         if(_loc2_ !== param1)
         {
            this._349866748modeSelectComboBox = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"modeSelectComboBox",_loc2_,param1));
         }
      }
      
      private function _SummonerSummaryView_Sequence1_i() : Sequence
      {
         var _loc1_:Sequence = new Sequence();
         this.fadeIn = _loc1_;
         _loc1_.children = [this._SummonerSummaryView_SetPropertyAction1_c(),this._SummonerSummaryView_Fade1_c()];
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get modeSelectComboBox() : ComboBox
      {
         return this._349866748modeSelectComboBox;
      }
      
      public function set colStats(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._654621953colStats;
         if(_loc2_ !== param1)
         {
            this._654621953colStats = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"colStats",_loc2_,param1));
         }
      }
   }
}

