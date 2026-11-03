package com.riotgames.platform.gameclient.views.summoner.stats
{
   import com.riotgames.platform.gameclient.Models.ChampionListPresentationModel;
   import com.riotgames.platform.gameclient.controllers.summoner.SummonerProfileController;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.game.CompetitiveSeason;
   import com.riotgames.platform.gameclient.utils.ChampionListUtil;
   import com.riotgames.platform.gameclient.views.IViewLifecycle;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
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
   import mx.binding.utils.ChangeWatcher;
   import mx.containers.Canvas;
   import mx.containers.TabNavigator;
   import mx.containers.utilityClasses.ConstraintColumn;
   import mx.containers.utilityClasses.ConstraintRow;
   import mx.controls.Button;
   import mx.controls.ComboBox;
   import mx.controls.HorizontalList;
   import mx.controls.Label;
   import mx.controls.Text;
   import mx.controls.dataGridClasses.DataGridColumn;
   import mx.core.ClassFactory;
   import mx.core.IFactory;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.IndexChangedEvent;
   import mx.events.ListEvent;
   import mx.events.PropertyChangeEvent;
   import mx.formatters.NumberFormatter;
   import mx.resources.ResourceManager;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class ProfileStatsView extends Canvas implements IViewLifecycle, IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _521401509rowBottom:ConstraintRow;
      
      private var _masterGameController:MasterGameController;
      
      private var championStatsChanged:ChangeWatcher = null;
      
      private var _1895424275clientConfig:ClientConfig = ClientConfig.instance;
      
      private var _1144311788championListView:HorizontalList;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      private var _908054948filterLabel:Label;
      
      private var _1060399231numberFormatter:NumberFormatter;
      
      private var _2099120006statViews:TabNavigator;
      
      private var _selectedSeason:int;
      
      private var initializeOnCreation:Boolean = true;
      
      mx_internal var _watchers:Array = [];
      
      public var _ProfileStatsView_Button1:Button;
      
      public var _ProfileStatsView_Button2:Button;
      
      private var _925103845rowTop:ConstraintRow;
      
      private var _948491687colLeft:ConstraintColumn;
      
      public var _ProfileStatsView_ProfileStatsLifetimeView1:ProfileStatsLifetimeView;
      
      private var _655867780colRight:ConstraintColumn;
      
      private var _159335554profileLifetimeStatsPresentationModel:ProfileLifetimeStatsPresentationModel;
      
      private var _1001989926totalNumberOfChampions:int;
      
      private var _257845681avgNumberFormatter:NumberFormatter;
      
      public var _ProfileStatsView_Text1:Text;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      private var _747801660seasonSelectComboBox:ComboBox;
      
      public var _ProfileStatsView_ChampionStatsGraphs1:ChampionStatsGraphs;
      
      mx_internal var _bindings:Array = [];
      
      private var _summonerProfileController:SummonerProfileController;
      
      private var _270584999championList:ChampionListPresentationModel = null;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {
               "width":1100,
               "height":540,
               "childDescriptors":[new UIComponentDescriptor({
                  "type":TabNavigator,
                  "id":"statViews",
                  "events":{"change":"__statViews_change"},
                  "stylesFactory":function():void
                  {
                     this.horizontalCenter = "0";
                     this.top = "rowTop:15";
                     this.bottom = "rowTop:-5";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "percentWidth":95,
                        "styleName":"profileTabNav",
                        "tabEnabled":false,
                        "tabChildren":false,
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":ProfileStatsLifetimeView,
                           "id":"_ProfileStatsView_ProfileStatsLifetimeView1",
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "percentWidth":100,
                                 "percentHeight":100,
                                 "x":0,
                                 "y":0
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":ChampionStatsGraphs,
                           "id":"_ProfileStatsView_ChampionStatsGraphs1",
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "x":0,
                                 "y":0,
                                 "percentWidth":100,
                                 "percentHeight":100
                              };
                           }
                        })]
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Button,
                  "id":"_ProfileStatsView_Button1",
                  "events":{"click":"___ProfileStatsView_Button1_click"},
                  "stylesFactory":function():void
                  {
                     this.top = "rowTop:8";
                     this.right = "15";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "buttonMode":true,
                        "styleName":"removeButton",
                        "useHandCursor":true
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":ComboBox,
                  "id":"seasonSelectComboBox",
                  "stylesFactory":function():void
                  {
                     this.color = 0;
                     this.fontFamily = "ApplicationFont2";
                     this.fontSize = 12;
                     this.top = "rowTop:14";
                     this.right = "50";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "height":20,
                        "width":125
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Label,
                  "id":"filterLabel",
                  "stylesFactory":function():void
                  {
                     this.top = "rowBottom:18";
                     this.horizontalCenter = "0";
                     this.textAlign = "center";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"styleName":"statsHeader"};
                  }
               }),new UIComponentDescriptor({
                  "type":Text,
                  "id":"_ProfileStatsView_Text1",
                  "stylesFactory":function():void
                  {
                     this.fontSize = 12;
                     this.top = "rowBottom:22";
                     this.textAlign = "left";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"styleName":"statsBigStats"};
                  }
               }),new UIComponentDescriptor({
                  "type":Button,
                  "id":"_ProfileStatsView_Button2",
                  "events":{"click":"___ProfileStatsView_Button2_click"},
                  "stylesFactory":function():void
                  {
                     this.top = "rowBottom:5";
                     this.right = "78";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "buttonMode":true,
                        "styleName":"s1FormButton",
                        "useHandCursor":true
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":HorizontalList,
                  "id":"championListView",
                  "events":{"change":"__championListView_change"},
                  "stylesFactory":function():void
                  {
                     this.horizontalCenter = "0";
                     this.bottom = "rowBottom:20";
                     this.backgroundAlpha = 0.8;
                     this.backgroundColor = 12691300;
                     this.borderColor = 10058542;
                     this.horizontalScrollBarStyleName = "yellow";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "percentWidth":85,
                        "height":100,
                        "allowMultipleSelection":true,
                        "columnWidth":70,
                        "rowHeight":90
                     };
                  }
               })]
            };
         }
      });
      
      public function ProfileStatsView()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.width = 1100;
         this.height = 540;
         this.constraintColumns = [this._ProfileStatsView_ConstraintColumn1_i(),this._ProfileStatsView_ConstraintColumn2_i()];
         this.constraintRows = [this._ProfileStatsView_ConstraintRow1_i(),this._ProfileStatsView_ConstraintRow2_i()];
         this._ProfileStatsView_NumberFormatter2_i();
         this._ProfileStatsView_NumberFormatter1_i();
         this.addEventListener("show",this.___ProfileStatsView_Canvas1_show);
         this.addEventListener("hide",this.___ProfileStatsView_Canvas1_hide);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         ProfileStatsView._watcherSetupUtil = param1;
      }
      
      public function set numberFormatter(param1:NumberFormatter) : void
      {
         var _loc2_:Object = this._1060399231numberFormatter;
         if(_loc2_ !== param1)
         {
            this._1060399231numberFormatter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"numberFormatter",_loc2_,param1));
         }
      }
      
      private function formatValueAverage(param1:Object, param2:DataGridColumn) : String
      {
         var _loc3_:Number = Number(param1.value);
         if(this.summonerProfileController.totalGamesPlayed > 0)
         {
            _loc3_ /= this.summonerProfileController.totalGamesPlayed;
         }
         return this.avgNumberFormatter.format(_loc3_);
      }
      
      private function _ProfileStatsView_ConstraintColumn2_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.colRight = _loc1_;
         _loc1_.percentWidth = 50;
         _loc1_.initialized(this,"colRight");
         return _loc1_;
      }
      
      private function set _566834807summonerProfileController(param1:SummonerProfileController) : void
      {
         if(this._summonerProfileController === param1 || param1 == null)
         {
            return;
         }
         this._summonerProfileController = param1;
         if(this._summonerProfileController != null)
         {
            this.onInjected();
         }
      }
      
      private function updateTopPlayedChampionList() : void
      {
         ChampionListUtil.inventoryController = this._summonerProfileController.inventoryController;
         ChampionListUtil.championSummaryStats = this.summonerProfileController.championSummaryStats;
         ChampionListUtil.reset();
         this.championListView.dataProvider = ChampionListUtil.championList.sortedChampions;
      }
      
      public function ___ProfileStatsView_Canvas1_show(param1:FlexEvent) : void
      {
         this.initializeView();
      }
      
      private function _ProfileStatsView_ConstraintRow1_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.rowTop = _loc1_;
         _loc1_.percentHeight = 70;
         _loc1_.initialized(this,"rowTop");
         return _loc1_;
      }
      
      public function ___ProfileStatsView_Button2_click(param1:MouseEvent) : void
      {
         this.onFilterCleared();
      }
      
      private function set profileLifetimeStatsPresentationModel(param1:ProfileLifetimeStatsPresentationModel) : void
      {
         var _loc2_:Object = this._159335554profileLifetimeStatsPresentationModel;
         if(_loc2_ !== param1)
         {
            this._159335554profileLifetimeStatsPresentationModel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"profileLifetimeStatsPresentationModel",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rowTop() : ConstraintRow
      {
         return this._925103845rowTop;
      }
      
      [Bindable(event="propertyChange")]
      private function get totalNumberOfChampions() : int
      {
         return this._1001989926totalNumberOfChampions;
      }
      
      private function closeLeagueSystemStatsView() : void
      {
         this.summonerProfileController.closeLeagueStats.dispatch();
      }
      
      [Inject]
      public function get masterGameController() : MasterGameController
      {
         return this._masterGameController;
      }
      
      private function formatLabel(param1:Object, param2:DataGridColumn) : String
      {
         return param1.displayName.toString() + ":";
      }
      
      private function _ProfileStatsView_ConstraintColumn1_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.colLeft = _loc1_;
         _loc1_.percentWidth = 50;
         _loc1_.initialized(this,"colLeft");
         return _loc1_;
      }
      
      public function set rowTop(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._925103845rowTop;
         if(_loc2_ !== param1)
         {
            this._925103845rowTop = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rowTop",_loc2_,param1));
         }
      }
      
      private function _ProfileStatsView_NumberFormatter2_i() : NumberFormatter
      {
         var _loc1_:NumberFormatter = new NumberFormatter();
         this.avgNumberFormatter = _loc1_;
         _loc1_.precision = 3;
         _loc1_.rounding = "none";
         _loc1_.useThousandsSeparator = true;
         _loc1_.useNegativeSign = true;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get seasonSelectComboBox() : ComboBox
      {
         return this._747801660seasonSelectComboBox;
      }
      
      public function ___ProfileStatsView_Canvas1_hide(param1:FlexEvent) : void
      {
         this.resetView();
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
      
      [Bindable(event="propertyChange")]
      public function get avgNumberFormatter() : NumberFormatter
      {
         return this._257845681avgNumberFormatter;
      }
      
      public function set rowBottom(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._521401509rowBottom;
         if(_loc2_ !== param1)
         {
            this._521401509rowBottom = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rowBottom",_loc2_,param1));
         }
      }
      
      public function initializeView() : void
      {
         if(!this.masterGameController || !this.summonerProfileController || this.statViews == null)
         {
            this.initializeOnCreation = true;
            return;
         }
         this._selectedSeason = this.summonerProfileController.currentStatsSeason;
         if(!ClientConfig.instance.leagueServiceEnabled)
         {
            this.addUpdatedStatsListeners();
         }
         ClientConfig.instance.getLeagueServiceEnabledChanged().add(this.onLeagueServiceEnabledChanged);
         this.updateTopPlayedChampionList();
         this.championList = ChampionListUtil.championList;
         this.totalNumberOfChampions = this.masterGameController.inventory.championCount;
         if(this.championStatsChanged == null)
         {
            this.championStatsChanged = ChangeWatcher.watch(this.summonerProfileController,"championSummaryStats",this.onChampionStatsChanged);
         }
         this.statViews.selectedIndex = 0;
         this.seasonSelectComboBox.addEventListener(ListEvent.CHANGE,this.updateStatsDisplay);
         this.seasonSelectComboBox.selectedIndex = this.summonerProfileController.currentStatsSeason;
      }
      
      private function set totalNumberOfChampions(param1:int) : void
      {
         var _loc2_:Object = this._1001989926totalNumberOfChampions;
         if(_loc2_ !== param1)
         {
            this._1001989926totalNumberOfChampions = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"totalNumberOfChampions",_loc2_,param1));
         }
      }
      
      private function set championList(param1:ChampionListPresentationModel) : void
      {
         var _loc2_:Object = this._270584999championList;
         if(_loc2_ !== param1)
         {
            this._270584999championList = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championList",_loc2_,param1));
         }
      }
      
      public function set masterGameController(param1:MasterGameController) : void
      {
         if(this._masterGameController === param1 || param1 == null)
         {
            return;
         }
         this._masterGameController = param1;
         if(this._masterGameController != null)
         {
            this.onInjected();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get filterLabel() : Label
      {
         return this._908054948filterLabel;
      }
      
      private function onFilterCleared() : void
      {
         this.championListView.selectedItems = [];
         this.summonerProfileController.viewChampionDetails(0,[]);
      }
      
      [Inject]
      public function get summonerProfileController() : SummonerProfileController
      {
         return this._summonerProfileController;
      }
      
      public function set seasonSelectComboBox(param1:ComboBox) : void
      {
         var _loc2_:Object = this._747801660seasonSelectComboBox;
         if(_loc2_ !== param1)
         {
            this._747801660seasonSelectComboBox = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"seasonSelectComboBox",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get statViews() : TabNavigator
      {
         return this._2099120006statViews;
      }
      
      [Bindable(event="propertyChange")]
      public function get colRight() : ConstraintColumn
      {
         return this._655867780colRight;
      }
      
      private function _ProfileStatsView_NumberFormatter1_i() : NumberFormatter
      {
         var _loc1_:NumberFormatter = new NumberFormatter();
         this.numberFormatter = _loc1_;
         _loc1_.precision = 0;
         _loc1_.rounding = "none";
         _loc1_.useThousandsSeparator = true;
         _loc1_.useNegativeSign = true;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get numberFormatter() : NumberFormatter
      {
         return this._1060399231numberFormatter;
      }
      
      [Bindable(event="propertyChange")]
      private function get profileLifetimeStatsPresentationModel() : ProfileLifetimeStatsPresentationModel
      {
         return this._159335554profileLifetimeStatsPresentationModel;
      }
      
      public function __championListView_change(param1:ListEvent) : void
      {
         this.onChampionClicked();
      }
      
      private function updateStatsDisplay(param1:ListEvent) : void
      {
         var _loc2_:ComboBox = param1.currentTarget as ComboBox;
         if(_loc2_.selectedIndex + 1 != this._selectedSeason)
         {
            this._selectedSeason = _loc2_.selectedIndex + 1;
            this.summonerProfileController.loadAggregatedStats(this._selectedSeason);
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:ProfileStatsView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._ProfileStatsView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_summoner_stats_ProfileStatsViewWatcherSetupUtil");
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
      
      public function resetView() : void
      {
         if(this.championStatsChanged != null)
         {
            this.championStatsChanged.unwatch();
            this.championStatsChanged = null;
         }
      }
      
      private function onTabChanged() : void
      {
         this.summonerProfileController.setLifetimeStatsState(this.statViews.selectedIndex);
      }
      
      private function onChampionStatsChanged(param1:PropertyChangeEvent) : void
      {
         if(this.championList)
         {
            this.championList.refreshSortedList();
         }
      }
      
      public function set avgNumberFormatter(param1:NumberFormatter) : void
      {
         var _loc2_:Object = this._257845681avgNumberFormatter;
         if(_loc2_ !== param1)
         {
            this._257845681avgNumberFormatter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"avgNumberFormatter",_loc2_,param1));
         }
      }
      
      private function onChampionClicked() : void
      {
         var _loc3_:Object = null;
         var _loc4_:Champion = null;
         var _loc1_:Number = 0;
         var _loc2_:Array = new Array();
         if(this.championListView.selectedItems)
         {
            for each(_loc3_ in this.championListView.selectedItems)
            {
               _loc4_ = _loc3_ as Champion;
               if(_loc4_)
               {
                  _loc2_[_loc4_.championId] = true;
                  if(_loc1_ == 0)
                  {
                     _loc1_ = Number(_loc4_.championId);
                  }
               }
            }
         }
         this.summonerProfileController.viewChampionDetails(_loc1_,_loc2_);
      }
      
      [Bindable(event="propertyChange")]
      public function get colLeft() : ConstraintColumn
      {
         return this._948491687colLeft;
      }
      
      [Bindable(event="propertyChange")]
      public function get rowBottom() : ConstraintRow
      {
         return this._521401509rowBottom;
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
      
      private function formatValue(param1:Object, param2:DataGridColumn) : String
      {
         return this.numberFormatter.format(param1.value);
      }
      
      public function ___ProfileStatsView_Button1_click(param1:MouseEvent) : void
      {
         this.closeLeagueSystemStatsView();
      }
      
      private function _ProfileStatsView_ConstraintRow2_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.rowBottom = _loc1_;
         _loc1_.percentHeight = 30;
         _loc1_.initialized(this,"rowBottom");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      private function get championList() : ChampionListPresentationModel
      {
         return this._270584999championList;
      }
      
      private function _ProfileStatsView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ResourceManager.getInstance().getString("resources","summonerProfile_stats_lifetime_label");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ProfileStatsView_ProfileStatsLifetimeView1.label = param1;
         },"_ProfileStatsView_ProfileStatsLifetimeView1.label");
         result[0] = binding;
         binding = new Binding(this,function():SummonerProfileController
         {
            return this.summonerProfileController;
         },function(param1:SummonerProfileController):void
         {
            _ProfileStatsView_ProfileStatsLifetimeView1.summonerProfileController = param1;
         },"_ProfileStatsView_ProfileStatsLifetimeView1.summonerProfileController");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ResourceManager.getInstance().getString("resources","summonerProfile_stats_graph_label");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ProfileStatsView_ChampionStatsGraphs1.label = param1;
         },"_ProfileStatsView_ChampionStatsGraphs1.label");
         result[2] = binding;
         binding = new Binding(this,function():SummonerProfileController
         {
            return this.summonerProfileController;
         },function(param1:SummonerProfileController):void
         {
            _ProfileStatsView_ChampionStatsGraphs1.summonerProfileController = param1;
         },"_ProfileStatsView_ChampionStatsGraphs1.summonerProfileController");
         result[3] = binding;
         binding = new Binding(this,function():Boolean
         {
            return ClientConfig.instance.leagueServiceEnabled;
         },function(param1:Boolean):void
         {
            _ProfileStatsView_Button1.visible = param1;
         },"_ProfileStatsView_Button1.visible");
         result[4] = binding;
         binding = new Binding(this,function():Object
         {
            return CompetitiveSeason.getLocalizedNameList();
         },function(param1:Object):void
         {
            seasonSelectComboBox.dataProvider = param1;
         },"seasonSelectComboBox.dataProvider");
         result[5] = binding;
         binding = new Binding(this,function():Boolean
         {
            return clientConfig.archivedStatsEnabled;
         },function(param1:Boolean):void
         {
            seasonSelectComboBox.visible = param1;
         },"seasonSelectComboBox.visible");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ResourceManager.getInstance().getString("resources","summonerProfile_stats_championFilter");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            filterLabel.htmlText = param1;
         },"filterLabel.htmlText");
         result[7] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ResourceManager.getInstance().getString("resources","summonerProfile_stats_championWinsCounter",[this.summonerProfileController.championWinCount,totalNumberOfChampions]);
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ProfileStatsView_Text1.htmlText = param1;
         },"_ProfileStatsView_Text1.htmlText");
         result[8] = binding;
         binding = new Binding(this,function():Number
         {
            return championListView.x;
         },function(param1:Number):void
         {
            _ProfileStatsView_Text1.x = param1;
         },"_ProfileStatsView_Text1.x");
         result[9] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.summonerProfileController.baseSummoner.acctId == this.summonerProfileController.statsSummoner.acctId;
         },function(param1:Boolean):void
         {
            _ProfileStatsView_Text1.visible = param1;
         },"_ProfileStatsView_Text1.visible");
         result[10] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ResourceManager.getInstance().getString("resources","summonerProfile_stats_clearFilter");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ProfileStatsView_Button2.label = param1;
         },"_ProfileStatsView_Button2.label");
         result[11] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.profileLifetimeStatsPresentationModel.championId != 0;
         },function(param1:Boolean):void
         {
            _ProfileStatsView_Button2.visible = param1;
         },"_ProfileStatsView_Button2.visible");
         result[12] = binding;
         binding = new Binding(this,function():IFactory
         {
            return new ClassFactory(ProfileStatsChampionRenderer);
         },function(param1:IFactory):void
         {
            championListView.itemRenderer = param1;
         },"championListView.itemRenderer");
         result[13] = binding;
         binding = new Binding(this,function():Object
         {
            return championList.sortedChampions;
         },function(param1:Object):void
         {
            championListView.dataProvider = param1;
         },"championListView.dataProvider");
         result[14] = binding;
         return result;
      }
      
      private function removeUpdatedStatsListeners() : void
      {
         this.summonerProfileController.championStatsChanged.remove(this.updateTopPlayedChampionList);
      }
      
      public function set championListView(param1:HorizontalList) : void
      {
         var _loc2_:Object = this._1144311788championListView;
         if(_loc2_ !== param1)
         {
            this._1144311788championListView = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championListView",_loc2_,param1));
         }
      }
      
      private function addUpdatedStatsListeners() : void
      {
         this.summonerProfileController.championStatsChanged.add(this.updateTopPlayedChampionList);
         this.summonerProfileController.loadAggregatedStats(this._selectedSeason);
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
      
      private function onInjected() : void
      {
         if(this.initializeOnCreation)
         {
            this.initializeOnCreation = false;
            this.initializeView();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get championListView() : HorizontalList
      {
         return this._1144311788championListView;
      }
      
      public function set statViews(param1:TabNavigator) : void
      {
         var _loc2_:Object = this._2099120006statViews;
         if(_loc2_ !== param1)
         {
            this._2099120006statViews = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statViews",_loc2_,param1));
         }
      }
      
      public function __statViews_change(param1:IndexChangedEvent) : void
      {
         this.onTabChanged();
      }
      
      private function onLeagueServiceEnabledChanged(param1:Boolean, param2:Boolean) : void
      {
         if(param2)
         {
            this.addUpdatedStatsListeners();
         }
         else
         {
            this.removeUpdatedStatsListeners();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get clientConfig() : ClientConfig
      {
         return this._1895424275clientConfig;
      }
      
      private function _ProfileStatsView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = ResourceManager.getInstance().getString("resources","summonerProfile_stats_lifetime_label");
         _loc1_ = this.summonerProfileController;
         _loc1_ = ResourceManager.getInstance().getString("resources","summonerProfile_stats_graph_label");
         _loc1_ = this.summonerProfileController;
         _loc1_ = ClientConfig.instance.leagueServiceEnabled;
         _loc1_ = CompetitiveSeason.getLocalizedNameList();
         _loc1_ = this.clientConfig.archivedStatsEnabled;
         _loc1_ = ResourceManager.getInstance().getString("resources","summonerProfile_stats_championFilter");
         _loc1_ = ResourceManager.getInstance().getString("resources","summonerProfile_stats_championWinsCounter",[this.summonerProfileController.championWinCount,this.totalNumberOfChampions]);
         _loc1_ = this.championListView.x;
         _loc1_ = this.summonerProfileController.baseSummoner.acctId == this.summonerProfileController.statsSummoner.acctId;
         _loc1_ = ResourceManager.getInstance().getString("resources","summonerProfile_stats_clearFilter");
         _loc1_ = this.profileLifetimeStatsPresentationModel.championId != 0;
         _loc1_ = new ClassFactory(ProfileStatsChampionRenderer);
         _loc1_ = this.championList.sortedChampions;
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
   }
}

