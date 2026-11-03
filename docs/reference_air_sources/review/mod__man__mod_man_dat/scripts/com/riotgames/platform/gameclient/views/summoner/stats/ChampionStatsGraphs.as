package com.riotgames.platform.gameclient.views.summoner.stats
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.controllers.summoner.SummonerProfileController;
   import com.riotgames.platform.gameclient.domain.AggregatedStatType;
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
   import mx.charts.AxisRenderer;
   import mx.charts.CategoryAxis;
   import mx.charts.ColumnChart;
   import mx.charts.Legend;
   import mx.charts.LinearAxis;
   import mx.charts.PieChart;
   import mx.charts.chartClasses.IAxis;
   import mx.charts.effects.SeriesInterpolate;
   import mx.charts.series.ColumnSeries;
   import mx.charts.series.PieSeries;
   import mx.containers.Canvas;
   import mx.containers.HBox;
   import mx.containers.ViewStack;
   import mx.controls.ComboBox;
   import mx.controls.HRule;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.controls.RadioButton;
   import mx.controls.RadioButtonGroup;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.ListEvent;
   import mx.events.PropertyChangeEvent;
   import mx.graphics.IFill;
   import mx.graphics.IStroke;
   import mx.graphics.SolidColor;
   import mx.graphics.Stroke;
   import mx.resources.ResourceManager;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class ChampionStatsGraphs extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private static const statIndexToStatId:Array = [AggregatedStatType.STAT_TYPE_TOTAL_CHAMPION_KILLS,AggregatedStatType.TOTAL_DAMAGE_DEALT,AggregatedStatType.STAT_TYPE_TOTAL_CHAMPION_DEATHS,AggregatedStatType.TOTAL_ASSISTS,AggregatedStatType.TOTAL_DOUBLE_KILLS,AggregatedStatType.TOTAL_GOLD_EARNED,AggregatedStatType.MOST_CHAMPION_KILLS_PER_SESSION,AggregatedStatType.TOTAL_MAGIC_DAMAGE_DEALT,AggregatedStatType.TOTAL_PHYSICAL_DAMAGE_DEALT,AggregatedStatType.TOTAL_MINION_KILLS,AggregatedStatType.TOTAL_PENTA_KILLS,AggregatedStatType.TOTAL_QUADRA_KILLS,AggregatedStatType.TOTAL_TRIPLE_KILLS,AggregatedStatType.TOTAL_TURRETS_KILLED];
      
      private var _1696849603friendlyStroke:Stroke;
      
      private var _94623710chart:ColumnChart;
      
      private var _986003130selectedStatName:String = "";
      
      private var _2106739372statNames:Array = ["CHAMPION_KILLS","TOTAL_DAMAGE_DEALT","STAT_TYPE_TOTAL_CHAMPION_DEATHS","TOTAL_ASSISTS","TOTAL_DOUBLE_KILLS","TOTAL_GOLD_EARNED","MOST_CHAMPION_KILLS_PER_SESSION","TOTAL_MAGIC_DAMAGE_DEALT","TOTAL_PHYSICAL_DAMAGE_DEALT","TOTAL_MINION_KILLS","TOTAL_PENTA_KILLS","TOTAL_QUADRA_KILLS","TOTAL_TRIPLE_KILLS","TOTAL_TURRETS_KILLED"];
      
      mx_internal var _bindingsByDestination:Object = {};
      
      private var _908054948filterLabel:Label;
      
      public var _ChampionStatsGraphs_PieSeries1:PieSeries;
      
      private var _48909625axisStroke:Stroke;
      
      private var _1482851730myChart:PieChart;
      
      private var _1425279352friendlyColor:SolidColor;
      
      private var _781807815pieCharView:Canvas;
      
      private var _1575111221tickStroke:Stroke;
      
      public var _ChampionStatsGraphs_AxisRenderer1:AxisRenderer;
      
      public var _ChampionStatsGraphs_AxisRenderer2:AxisRenderer;
      
      private var _2024689190graphStack:ViewStack;
      
      private var _113801146yAxis:LinearAxis;
      
      mx_internal var _watchers:Array = [];
      
      public var _ChampionStatsGraphs_Image1:Image;
      
      public var _ChampionStatsGraphs_ColumnSeries1:ColumnSeries;
      
      private var _2035817007graphGroup:RadioButtonGroup;
      
      private var _280640434barCharView:Canvas;
      
      public var _ChampionStatsGraphs_Legend1:Legend;
      
      private var _112877625xAxis:CategoryAxis;
      
      private var _559326726interpolateIn:SeriesInterpolate;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      private var _2100480379statTypes:ComboBox;
      
      public var _ChampionStatsGraphs_RadioButton1:RadioButton;
      
      public var _ChampionStatsGraphs_RadioButton2:RadioButton;
      
      private var _1115752950currentSelectedStatIndex:uint = 0;
      
      mx_internal var _bindings:Array = [];
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":HBox,
               "stylesFactory":function():void
               {
                  this.top = "0";
                  this.left = "5";
                  this.borderStyle = "solid";
                  this.borderThickness = 1;
                  this.borderColor = 0;
               },
               "propertiesFactory":function():Object
               {
                  return {"childDescriptors":[new UIComponentDescriptor({
                     "type":RadioButton,
                     "id":"_ChampionStatsGraphs_RadioButton1",
                     "stylesFactory":function():void
                     {
                        this.color = 0;
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "styleName":"rankedStatsGraphSelectorRadioButtonStyle",
                           "selected":true,
                           "value":0
                        };
                     }
                  }),new UIComponentDescriptor({
                     "type":RadioButton,
                     "id":"_ChampionStatsGraphs_RadioButton2",
                     "stylesFactory":function():void
                     {
                        this.color = 0;
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "styleName":"rankedStatsGraphSelectorRadioButtonStyle",
                           "selected":false,
                           "value":1
                        };
                     }
                  })]};
               }
            }),new UIComponentDescriptor({
               "type":HRule,
               "stylesFactory":function():void
               {
                  this.horizontalCenter = "0";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "styleName":"parchment",
                     "percentWidth":98,
                     "y":35
                  };
               }
            }),new UIComponentDescriptor({
               "type":ViewStack,
               "id":"graphStack",
               "stylesFactory":function():void
               {
                  this.top = "40";
                  this.bottom = "0";
                  this.left = "0";
                  this.right = "0";
               },
               "propertiesFactory":function():Object
               {
                  return {"childDescriptors":[new UIComponentDescriptor({
                     "type":Canvas,
                     "id":"barCharView",
                     "propertiesFactory":function():Object
                     {
                        return {
                           "cacheAsBitmap":true,
                           "x":0,
                           "y":0,
                           "percentWidth":100,
                           "percentHeight":100,
                           "horizontalScrollPolicy":"off",
                           "verticalScrollPolicy":"off",
                           "label":"BarChart",
                           "childDescriptors":[new UIComponentDescriptor({
                              "type":ColumnChart,
                              "id":"chart",
                              "propertiesFactory":function():Object
                              {
                                 return {
                                    "percentWidth":100,
                                    "percentHeight":100,
                                    "x":0,
                                    "y":0,
                                    "styleName":"championStatsGraphColumnChart",
                                    "showDataTips":true,
                                    "horizontalAxis":_ChampionStatsGraphs_CategoryAxis1_i(),
                                    "verticalAxis":_ChampionStatsGraphs_LinearAxis1_i(),
                                    "horizontalAxisRenderers":[_ChampionStatsGraphs_AxisRenderer1_i()],
                                    "verticalAxisRenderers":[_ChampionStatsGraphs_AxisRenderer2_i()],
                                    "series":[_ChampionStatsGraphs_ColumnSeries1_i()]
                                 };
                              }
                           })]
                        };
                     }
                  }),new UIComponentDescriptor({
                     "type":Canvas,
                     "id":"pieCharView",
                     "propertiesFactory":function():Object
                     {
                        return {
                           "cacheAsBitmap":true,
                           "x":0,
                           "y":0,
                           "percentWidth":100,
                           "percentHeight":100,
                           "horizontalScrollPolicy":"off",
                           "verticalScrollPolicy":"off",
                           "label":"PieChart",
                           "childDescriptors":[new UIComponentDescriptor({
                              "type":PieChart,
                              "id":"myChart",
                              "stylesFactory":function():void
                              {
                                 this.horizontalCenter = "0";
                                 this.verticalCenter = "0";
                                 this.color = 0;
                              },
                              "propertiesFactory":function():Object
                              {
                                 return {
                                    "percentHeight":90,
                                    "showDataTips":true,
                                    "series":[_ChampionStatsGraphs_PieSeries1_i()]
                                 };
                              }
                           }),new UIComponentDescriptor({
                              "type":Legend,
                              "id":"_ChampionStatsGraphs_Legend1",
                              "propertiesFactory":function():Object
                              {
                                 return {
                                    "x":0,
                                    "y":0,
                                    "percentHeight":100
                                 };
                              }
                           })]
                        };
                     }
                  }),new UIComponentDescriptor({
                     "type":Canvas,
                     "propertiesFactory":function():Object
                     {
                        return {
                           "cacheAsBitmap":true,
                           "percentWidth":100,
                           "horizontalScrollPolicy":"off",
                           "childDescriptors":[new UIComponentDescriptor({
                              "type":Label,
                              "events":{"initialize":"___ChampionStatsGraphs_Label1_initialize"},
                              "stylesFactory":function():void
                              {
                                 this.horizontalCenter = "0";
                                 this.verticalCenter = "0";
                                 this.color = 0;
                                 this.fontSize = 21;
                              },
                              "propertiesFactory":function():Object
                              {
                                 return {
                                    "percentWidth":90,
                                    "styleName":"endOfGameStatsText"
                                 };
                              }
                           })]
                        };
                     }
                  })]};
               }
            }),new UIComponentDescriptor({
               "type":Image,
               "id":"_ChampionStatsGraphs_Image1"
            }),new UIComponentDescriptor({
               "type":Label,
               "id":"filterLabel",
               "stylesFactory":function():void
               {
                  this.top = "1";
                  this.horizontalCenter = "0";
                  this.textAlign = "center";
               },
               "propertiesFactory":function():Object
               {
                  return {"styleName":"statsHeader"};
               }
            }),new UIComponentDescriptor({
               "type":ComboBox,
               "id":"statTypes",
               "events":{"change":"__statTypes_change"},
               "stylesFactory":function():void
               {
                  this.top = "0";
                  this.right = "0";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "styleName":"runeSelectionComboBox",
                     "width":270,
                     "rowCount":18
                  };
               }
            })]};
         }
      });
      
      private var _summonerProfileController:SummonerProfileController;
      
      public function ChampionStatsGraphs()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this._ChampionStatsGraphs_Stroke2_i();
         this._ChampionStatsGraphs_SolidColor1_i();
         this._ChampionStatsGraphs_Stroke1_i();
         this._ChampionStatsGraphs_RadioButtonGroup1_i();
         this._ChampionStatsGraphs_SeriesInterpolate1_i();
         this._ChampionStatsGraphs_Stroke3_i();
         this.addEventListener("initialize",this.___ChampionStatsGraphs_Canvas1_initialize);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         ChampionStatsGraphs._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get interpolateIn() : SeriesInterpolate
      {
         return this._559326726interpolateIn;
      }
      
      public function set interpolateIn(param1:SeriesInterpolate) : void
      {
         var _loc2_:Object = this._559326726interpolateIn;
         if(_loc2_ !== param1)
         {
            this._559326726interpolateIn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"interpolateIn",_loc2_,param1));
         }
      }
      
      public function set statTypes(param1:ComboBox) : void
      {
         var _loc2_:Object = this._2100480379statTypes;
         if(_loc2_ !== param1)
         {
            this._2100480379statTypes = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statTypes",_loc2_,param1));
         }
      }
      
      private function set currentSelectedStatIndex(param1:uint) : void
      {
         var _loc2_:Object = this._1115752950currentSelectedStatIndex;
         if(_loc2_ !== param1)
         {
            this._1115752950currentSelectedStatIndex = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentSelectedStatIndex",_loc2_,param1));
         }
      }
      
      private function localizeStats() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.statNames.length)
         {
            this.statNames[_loc1_] = RiotResourceLoader.getStatResourceString(this.statNames[_loc1_],this.statNames[_loc1_]);
            _loc1_++;
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get currentSelectedStatIndex() : uint
      {
         return this._1115752950currentSelectedStatIndex;
      }
      
      private function _ChampionStatsGraphs_Stroke2_i() : Stroke
      {
         var _loc1_:Stroke = new Stroke();
         this.axisStroke = _loc1_;
         _loc1_.color = 16777215;
         _loc1_.alpha = 1;
         _loc1_.weight = 2;
         _loc1_.caps = "none";
         return _loc1_;
      }
      
      public function set myChart(param1:PieChart) : void
      {
         var _loc2_:Object = this._1482851730myChart;
         if(_loc2_ !== param1)
         {
            this._1482851730myChart = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"myChart",_loc2_,param1));
         }
      }
      
      private function statTypeChanged() : void
      {
         this.setStatTypeByIndex(this.statTypes.selectedIndex);
      }
      
      [Bindable(event="propertyChange")]
      public function get tickStroke() : Stroke
      {
         return this._1575111221tickStroke;
      }
      
      [Bindable(event="propertyChange")]
      public function get axisStroke() : Stroke
      {
         return this._48909625axisStroke;
      }
      
      [Bindable(event="propertyChange")]
      public function get xAxis() : CategoryAxis
      {
         return this._112877625xAxis;
      }
      
      private function _ChampionStatsGraphs_ColumnSeries1_i() : ColumnSeries
      {
         var _loc1_:ColumnSeries = new ColumnSeries();
         this._ChampionStatsGraphs_ColumnSeries1 = _loc1_;
         _loc1_.xField = "championDisplayName";
         _loc1_.yField = "value";
         _loc1_.setStyle("color",0);
         _loc1_.id = "_ChampionStatsGraphs_ColumnSeries1";
         BindingManager.executeBindings(this,"_ChampionStatsGraphs_ColumnSeries1",this._ChampionStatsGraphs_ColumnSeries1);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get barCharView() : Canvas
      {
         return this._280640434barCharView;
      }
      
      [Bindable(event="propertyChange")]
      private function get statNames() : Array
      {
         return this._2106739372statNames;
      }
      
      [Bindable(event="propertyChange")]
      public function get filterLabel() : Label
      {
         return this._908054948filterLabel;
      }
      
      private function _ChampionStatsGraphs_Stroke1_i() : Stroke
      {
         var _loc1_:Stroke = new Stroke();
         this.friendlyStroke = _loc1_;
         _loc1_.color = 10058542;
         _loc1_.alpha = 1;
         _loc1_.weight = 1;
         return _loc1_;
      }
      
      private function onGraphChoiceChanged() : void
      {
      }
      
      public function set axisStroke(param1:Stroke) : void
      {
         var _loc2_:Object = this._48909625axisStroke;
         if(_loc2_ !== param1)
         {
            this._48909625axisStroke = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"axisStroke",_loc2_,param1));
         }
      }
      
      public function set yAxis(param1:LinearAxis) : void
      {
         var _loc2_:Object = this._113801146yAxis;
         if(_loc2_ !== param1)
         {
            this._113801146yAxis = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"yAxis",_loc2_,param1));
         }
      }
      
      private function onInitialized() : void
      {
         this.localizeStats();
      }
      
      [Inject]
      public function get summonerProfileController() : SummonerProfileController
      {
         return this._summonerProfileController;
      }
      
      [Bindable(event="propertyChange")]
      public function get friendlyColor() : SolidColor
      {
         return this._1425279352friendlyColor;
      }
      
      public function set tickStroke(param1:Stroke) : void
      {
         var _loc2_:Object = this._1575111221tickStroke;
         if(_loc2_ !== param1)
         {
            this._1575111221tickStroke = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tickStroke",_loc2_,param1));
         }
      }
      
      private function setStatTypeByIndex(param1:uint) : void
      {
         this.currentSelectedStatIndex = param1;
         this.summonerProfileController.setSelectedStat(statIndexToStatId[this.currentSelectedStatIndex]);
         this.selectedStatName = this.statNames[this.currentSelectedStatIndex];
      }
      
      private function set selectedStatName(param1:String) : void
      {
         var _loc2_:Object = this._986003130selectedStatName;
         if(_loc2_ !== param1)
         {
            this._986003130selectedStatName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedStatName",_loc2_,param1));
         }
      }
      
      public function set xAxis(param1:CategoryAxis) : void
      {
         var _loc2_:Object = this._112877625xAxis;
         if(_loc2_ !== param1)
         {
            this._112877625xAxis = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"xAxis",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get statTypes() : ComboBox
      {
         return this._2100480379statTypes;
      }
      
      public function set friendlyStroke(param1:Stroke) : void
      {
         var _loc2_:Object = this._1696849603friendlyStroke;
         if(_loc2_ !== param1)
         {
            this._1696849603friendlyStroke = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"friendlyStroke",_loc2_,param1));
         }
      }
      
      public function set pieCharView(param1:Canvas) : void
      {
         var _loc2_:Object = this._781807815pieCharView;
         if(_loc2_ !== param1)
         {
            this._781807815pieCharView = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pieCharView",_loc2_,param1));
         }
      }
      
      public function __statTypes_change(param1:ListEvent) : void
      {
         this.statTypeChanged();
      }
      
      [Bindable(event="propertyChange")]
      public function get myChart() : PieChart
      {
         return this._1482851730myChart;
      }
      
      private function _ChampionStatsGraphs_AxisRenderer2_i() : AxisRenderer
      {
         var _loc1_:AxisRenderer = new AxisRenderer();
         this._ChampionStatsGraphs_AxisRenderer2 = _loc1_;
         _loc1_.id = "_ChampionStatsGraphs_AxisRenderer2";
         BindingManager.executeBindings(this,"_ChampionStatsGraphs_AxisRenderer2",this._ChampionStatsGraphs_AxisRenderer2);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChampionStatsGraphs_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = ResourceManager.getInstance().getString("resources","summonerProfile_stats_barGraph");
         _loc1_ = this.graphGroup;
         _loc1_ = ResourceManager.getInstance().getString("resources","summonerProfile_stats_pieGrap");
         _loc1_ = this.graphGroup;
         _loc1_ = this.summonerProfileController.viewingMultipleChamps ? this.graphGroup.selectedValue as int : 2;
         _loc1_ = this.summonerProfileController.lifetimeStats;
         _loc1_ = this.xAxis;
         _loc1_ = this.axisStroke;
         _loc1_ = this.tickStroke;
         _loc1_ = this.tickStroke;
         _loc1_ = this.yAxis;
         _loc1_ = this.axisStroke;
         _loc1_ = this.tickStroke;
         _loc1_ = this.tickStroke;
         _loc1_ = this.friendlyColor;
         _loc1_ = this.friendlyStroke;
         _loc1_ = this.selectedStatName;
         _loc1_ = this.interpolateIn;
         _loc1_ = this.summonerProfileController.lifetimeStats;
         _loc1_ = this.selectedStatName;
         _loc1_ = this.interpolateIn;
         _loc1_ = this.myChart;
         _loc1_ = this.filterLabel.x - 8;
         _loc1_ = this.filterLabel.y - 2;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_profile_runes_headerFlame");
         _loc1_ = this.selectedStatName;
         _loc1_ = this.statNames;
         _loc1_ = this.currentSelectedStatIndex;
      }
      
      private function _ChampionStatsGraphs_SolidColor1_i() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         this.friendlyColor = _loc1_;
         _loc1_.color = 15920086;
         _loc1_.alpha = 1;
         return _loc1_;
      }
      
      public function set barCharView(param1:Canvas) : void
      {
         var _loc2_:Object = this._280640434barCharView;
         if(_loc2_ !== param1)
         {
            this._280640434barCharView = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"barCharView",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:ChampionStatsGraphs = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._ChampionStatsGraphs_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_summoner_stats_ChampionStatsGraphsWatcherSetupUtil");
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
      
      private function _ChampionStatsGraphs_RadioButtonGroup1_i() : RadioButtonGroup
      {
         var _loc1_:RadioButtonGroup = new RadioButtonGroup();
         this.graphGroup = _loc1_;
         _loc1_.addEventListener("change",this.__graphGroup_change);
         _loc1_.initialized(this,"graphGroup");
         return _loc1_;
      }
      
      private function champGraphInstructions_initializeHandler(param1:Event) : void
      {
         var _loc2_:Label = param1.target as Label;
         var _loc3_:String = Capabilities.os.toLowerCase();
         if(_loc3_.indexOf("windows") >= 0)
         {
            _loc2_.text = ResourceManager.getInstance().getString("resources","summonerProfile_stats_selectChampionsGraphInstructions_win");
         }
         else if(_loc3_.indexOf("mac") >= 0)
         {
            _loc2_.text = ResourceManager.getInstance().getString("resources","summonerProfile_stats_selectChampionsGraphInstructions_mac");
         }
      }
      
      public function set graphGroup(param1:RadioButtonGroup) : void
      {
         var _loc2_:Object = this._2035817007graphGroup;
         if(_loc2_ !== param1)
         {
            this._2035817007graphGroup = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"graphGroup",_loc2_,param1));
         }
      }
      
      private function _ChampionStatsGraphs_SeriesInterpolate1_i() : SeriesInterpolate
      {
         var _loc1_:SeriesInterpolate = new SeriesInterpolate();
         this.interpolateIn = _loc1_;
         _loc1_.duration = 1000;
         return _loc1_;
      }
      
      private function set statNames(param1:Array) : void
      {
         var _loc2_:Object = this._2106739372statNames;
         if(_loc2_ !== param1)
         {
            this._2106739372statNames = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statNames",_loc2_,param1));
         }
      }
      
      public function set filterLabel(param1:Label) : void
      {
         var _loc2_:Object = this._908054948filterLabel;
         if(_loc2_ !== param1)
         {
            this._908054948filterLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"filterLabel",_loc2_,param1));
         }
      }
      
      public function ___ChampionStatsGraphs_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialized();
      }
      
      [Bindable(event="propertyChange")]
      public function get yAxis() : LinearAxis
      {
         return this._113801146yAxis;
      }
      
      public function set graphStack(param1:ViewStack) : void
      {
         var _loc2_:Object = this._2024689190graphStack;
         if(_loc2_ !== param1)
         {
            this._2024689190graphStack = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"graphStack",_loc2_,param1));
         }
      }
      
      public function set chart(param1:ColumnChart) : void
      {
         var _loc2_:Object = this._94623710chart;
         if(_loc2_ !== param1)
         {
            this._94623710chart = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chart",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get pieCharView() : Canvas
      {
         return this._781807815pieCharView;
      }
      
      [Bindable(event="propertyChange")]
      private function get selectedStatName() : String
      {
         return this._986003130selectedStatName;
      }
      
      [Bindable(event="propertyChange")]
      public function get friendlyStroke() : Stroke
      {
         return this._1696849603friendlyStroke;
      }
      
      private function _ChampionStatsGraphs_CategoryAxis1_i() : CategoryAxis
      {
         var _loc1_:CategoryAxis = new CategoryAxis();
         this.xAxis = _loc1_;
         _loc1_.categoryField = "championDisplayName";
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get graphGroup() : RadioButtonGroup
      {
         return this._2035817007graphGroup;
      }
      
      [Bindable(event="propertyChange")]
      public function get chart() : ColumnChart
      {
         return this._94623710chart;
      }
      
      private function _ChampionStatsGraphs_Stroke3_i() : Stroke
      {
         var _loc1_:Stroke = new Stroke();
         this.tickStroke = _loc1_;
         _loc1_.color = 16777215;
         _loc1_.alpha = 1;
         _loc1_.weight = 1;
         return _loc1_;
      }
      
      private function _ChampionStatsGraphs_AxisRenderer1_i() : AxisRenderer
      {
         var _loc1_:AxisRenderer = new AxisRenderer();
         this._ChampionStatsGraphs_AxisRenderer1 = _loc1_;
         _loc1_.setStyle("canStagger",true);
         _loc1_.setStyle("textAlign","center");
         _loc1_.id = "_ChampionStatsGraphs_AxisRenderer1";
         BindingManager.executeBindings(this,"_ChampionStatsGraphs_AxisRenderer1",this._ChampionStatsGraphs_AxisRenderer1);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get graphStack() : ViewStack
      {
         return this._2024689190graphStack;
      }
      
      [Bindable(event="propertyChange")]
      public function set summonerProfileController(param1:SummonerProfileController) : void
      {
         var _loc2_:Object = this.summonerProfileController;
         if(_loc2_ !== param1)
         {
            this._566834807summonerProfileController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerProfileController",_loc2_,param1));
         }
      }
      
      public function ___ChampionStatsGraphs_Label1_initialize(param1:FlexEvent) : void
      {
         this.champGraphInstructions_initializeHandler(param1);
      }
      
      private function _ChampionStatsGraphs_LinearAxis1_i() : LinearAxis
      {
         var _loc1_:LinearAxis = new LinearAxis();
         this.yAxis = _loc1_;
         return _loc1_;
      }
      
      private function _ChampionStatsGraphs_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ResourceManager.getInstance().getString("resources","summonerProfile_stats_barGraph");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ChampionStatsGraphs_RadioButton1.label = param1;
         },"_ChampionStatsGraphs_RadioButton1.label");
         result[0] = binding;
         binding = new Binding(this,function():RadioButtonGroup
         {
            return graphGroup;
         },function(param1:RadioButtonGroup):void
         {
            _ChampionStatsGraphs_RadioButton1.group = param1;
         },"_ChampionStatsGraphs_RadioButton1.group");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ResourceManager.getInstance().getString("resources","summonerProfile_stats_pieGrap");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ChampionStatsGraphs_RadioButton2.label = param1;
         },"_ChampionStatsGraphs_RadioButton2.label");
         result[2] = binding;
         binding = new Binding(this,function():RadioButtonGroup
         {
            return graphGroup;
         },function(param1:RadioButtonGroup):void
         {
            _ChampionStatsGraphs_RadioButton2.group = param1;
         },"_ChampionStatsGraphs_RadioButton2.group");
         result[3] = binding;
         binding = new Binding(this,function():int
         {
            return this.summonerProfileController.viewingMultipleChamps ? graphGroup.selectedValue as int : 2;
         },function(param1:int):void
         {
            graphStack.selectedIndex = param1;
         },"graphStack.selectedIndex");
         result[4] = binding;
         binding = new Binding(this,function():Object
         {
            return this.summonerProfileController.lifetimeStats;
         },function(param1:Object):void
         {
            chart.dataProvider = param1;
         },"chart.dataProvider");
         result[5] = binding;
         binding = new Binding(this,function():IAxis
         {
            return xAxis;
         },function(param1:IAxis):void
         {
            _ChampionStatsGraphs_AxisRenderer1.axis = param1;
         },"_ChampionStatsGraphs_AxisRenderer1.axis");
         result[6] = binding;
         binding = new Binding(this,function():IStroke
         {
            return axisStroke;
         },function(param1:IStroke):void
         {
            _ChampionStatsGraphs_AxisRenderer1.setStyle("axisStroke",param1);
         },"_ChampionStatsGraphs_AxisRenderer1.axisStroke");
         result[7] = binding;
         binding = new Binding(this,function():IStroke
         {
            return tickStroke;
         },function(param1:IStroke):void
         {
            _ChampionStatsGraphs_AxisRenderer1.setStyle("tickStroke",param1);
         },"_ChampionStatsGraphs_AxisRenderer1.tickStroke");
         result[8] = binding;
         binding = new Binding(this,function():IStroke
         {
            return tickStroke;
         },function(param1:IStroke):void
         {
            _ChampionStatsGraphs_AxisRenderer1.setStyle("minorTickStroke",param1);
         },"_ChampionStatsGraphs_AxisRenderer1.minorTickStroke");
         result[9] = binding;
         binding = new Binding(this,function():IAxis
         {
            return yAxis;
         },function(param1:IAxis):void
         {
            _ChampionStatsGraphs_AxisRenderer2.axis = param1;
         },"_ChampionStatsGraphs_AxisRenderer2.axis");
         result[10] = binding;
         binding = new Binding(this,function():IStroke
         {
            return axisStroke;
         },function(param1:IStroke):void
         {
            _ChampionStatsGraphs_AxisRenderer2.setStyle("axisStroke",param1);
         },"_ChampionStatsGraphs_AxisRenderer2.axisStroke");
         result[11] = binding;
         binding = new Binding(this,function():IStroke
         {
            return tickStroke;
         },function(param1:IStroke):void
         {
            _ChampionStatsGraphs_AxisRenderer2.setStyle("tickStroke",param1);
         },"_ChampionStatsGraphs_AxisRenderer2.tickStroke");
         result[12] = binding;
         binding = new Binding(this,function():IStroke
         {
            return tickStroke;
         },function(param1:IStroke):void
         {
            _ChampionStatsGraphs_AxisRenderer2.setStyle("minorTickStroke",param1);
         },"_ChampionStatsGraphs_AxisRenderer2.minorTickStroke");
         result[13] = binding;
         binding = new Binding(this,function():IFill
         {
            return friendlyColor;
         },function(param1:IFill):void
         {
            _ChampionStatsGraphs_ColumnSeries1.setStyle("fill",param1);
         },"_ChampionStatsGraphs_ColumnSeries1.fill");
         result[14] = binding;
         binding = new Binding(this,function():IStroke
         {
            return friendlyStroke;
         },function(param1:IStroke):void
         {
            _ChampionStatsGraphs_ColumnSeries1.setStyle("stroke",param1);
         },"_ChampionStatsGraphs_ColumnSeries1.stroke");
         result[15] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = selectedStatName;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ChampionStatsGraphs_ColumnSeries1.displayName = param1;
         },"_ChampionStatsGraphs_ColumnSeries1.displayName");
         result[16] = binding;
         binding = new Binding(this,function():*
         {
            return interpolateIn;
         },function(param1:*):void
         {
            _ChampionStatsGraphs_ColumnSeries1.setStyle("showDataEffect",param1);
         },"_ChampionStatsGraphs_ColumnSeries1.showDataEffect");
         result[17] = binding;
         binding = new Binding(this,function():Object
         {
            return this.summonerProfileController.lifetimeStats;
         },function(param1:Object):void
         {
            myChart.dataProvider = param1;
         },"myChart.dataProvider");
         result[18] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = selectedStatName;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ChampionStatsGraphs_PieSeries1.displayName = param1;
         },"_ChampionStatsGraphs_PieSeries1.displayName");
         result[19] = binding;
         binding = new Binding(this,function():*
         {
            return interpolateIn;
         },function(param1:*):void
         {
            _ChampionStatsGraphs_PieSeries1.setStyle("showDataEffect",param1);
         },"_ChampionStatsGraphs_PieSeries1.showDataEffect");
         result[20] = binding;
         binding = new Binding(this,function():Object
         {
            return myChart;
         },function(param1:Object):void
         {
            _ChampionStatsGraphs_Legend1.dataProvider = param1;
         },"_ChampionStatsGraphs_Legend1.dataProvider");
         result[21] = binding;
         binding = new Binding(this,function():Number
         {
            return filterLabel.x - 8;
         },function(param1:Number):void
         {
            _ChampionStatsGraphs_Image1.x = param1;
         },"_ChampionStatsGraphs_Image1.x");
         result[22] = binding;
         binding = new Binding(this,function():Number
         {
            return filterLabel.y - 2;
         },function(param1:Number):void
         {
            _ChampionStatsGraphs_Image1.y = param1;
         },"_ChampionStatsGraphs_Image1.y");
         result[23] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_profile_runes_headerFlame");
         },function(param1:Object):void
         {
            _ChampionStatsGraphs_Image1.source = param1;
         },"_ChampionStatsGraphs_Image1.source");
         result[24] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.selectedStatName;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            filterLabel.htmlText = param1;
         },"filterLabel.htmlText");
         result[25] = binding;
         binding = new Binding(this,function():Object
         {
            return this.statNames;
         },function(param1:Object):void
         {
            statTypes.dataProvider = param1;
         },"statTypes.dataProvider");
         result[26] = binding;
         binding = new Binding(this,function():int
         {
            return this.currentSelectedStatIndex;
         },function(param1:int):void
         {
            statTypes.selectedIndex = param1;
         },"statTypes.selectedIndex");
         result[27] = binding;
         return result;
      }
      
      public function set friendlyColor(param1:SolidColor) : void
      {
         var _loc2_:Object = this._1425279352friendlyColor;
         if(_loc2_ !== param1)
         {
            this._1425279352friendlyColor = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"friendlyColor",_loc2_,param1));
         }
      }
      
      private function _ChampionStatsGraphs_PieSeries1_i() : PieSeries
      {
         var _loc1_:PieSeries = new PieSeries();
         this._ChampionStatsGraphs_PieSeries1 = _loc1_;
         _loc1_.field = "value";
         _loc1_.nameField = "championDisplayName";
         _loc1_.explodeRadius = 0.075;
         _loc1_.setStyle("labelPosition","inside");
         _loc1_.id = "_ChampionStatsGraphs_PieSeries1";
         BindingManager.executeBindings(this,"_ChampionStatsGraphs_PieSeries1",this._ChampionStatsGraphs_PieSeries1);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function set _566834807summonerProfileController(param1:SummonerProfileController) : void
      {
         if(param1 === this._summonerProfileController)
         {
            return;
         }
         this._summonerProfileController = param1;
         if(this._summonerProfileController != null)
         {
            this.localizeStats();
            this.setStatTypeByIndex(0);
         }
      }
      
      public function __graphGroup_change(param1:Event) : void
      {
         this.onGraphChoiceChanged();
      }
   }
}

