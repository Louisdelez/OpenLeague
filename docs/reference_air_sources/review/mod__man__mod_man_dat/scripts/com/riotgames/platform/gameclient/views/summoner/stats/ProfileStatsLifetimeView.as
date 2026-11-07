package com.riotgames.platform.gameclient.views.summoner.stats
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.components.containers.GradientCanvas;
   import com.riotgames.platform.gameclient.controllers.summoner.SummonerProfileController;
   import com.riotgames.platform.gameclient.views.game.common.ChampionImages;
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
   import mx.containers.utilityClasses.ConstraintColumn;
   import mx.controls.HRule;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.controls.dataGridClasses.DataGridColumn;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.formatters.NumberFormatter;
   import mx.resources.ResourceManager;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class ProfileStatsLifetimeView extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _1922107202avgLabel:Label;
      
      private var _summonerProfileController:SummonerProfileController;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":Image,
               "id":"championImage",
               "stylesFactory":function():void
               {
                  this.left = "10";
                  this.top = "20";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "width":64,
                     "height":64
                  };
               }
            }),new UIComponentDescriptor({
               "type":Label,
               "id":"_ProfileStatsLifetimeView_Label1",
               "stylesFactory":function():void
               {
                  this.textAlign = "center";
               },
               "propertiesFactory":function():Object
               {
                  return {"styleName":"statsBigStats"};
               }
            }),new UIComponentDescriptor({
               "type":Label,
               "id":"_ProfileStatsLifetimeView_Label2",
               "stylesFactory":function():void
               {
                  this.textAlign = "center";
               },
               "propertiesFactory":function():Object
               {
                  return {"styleName":"statsBigStats"};
               }
            }),new UIComponentDescriptor({
               "type":GradientCanvas,
               "stylesFactory":function():void
               {
                  this.horizontalCenter = "0";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "percentWidth":50,
                     "y":7,
                     "height":50,
                     "styleName":"parchmentGradient",
                     "horizontalScrollPolicy":"off",
                     "verticalScrollPolicy":"off",
                     "constraintColumns":[_ProfileStatsLifetimeView_ConstraintColumn3_i(),_ProfileStatsLifetimeView_ConstraintColumn4_i(),_ProfileStatsLifetimeView_ConstraintColumn5_i()],
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":Label,
                        "id":"_ProfileStatsLifetimeView_Label3",
                        "stylesFactory":function():void
                        {
                           this.textAlign = "center";
                           this.horizontalCenter = "winsCol:0";
                           this.verticalCenter = "0";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {"styleName":"statsBigStats"};
                        }
                     }),new UIComponentDescriptor({
                        "type":Label,
                        "id":"_ProfileStatsLifetimeView_Label4",
                        "stylesFactory":function():void
                        {
                           this.textAlign = "center";
                           this.horizontalCenter = "lossCol:0";
                           this.verticalCenter = "0";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {"styleName":"statsBigStats"};
                        }
                     }),new UIComponentDescriptor({
                        "type":Label,
                        "id":"_ProfileStatsLifetimeView_Label5",
                        "stylesFactory":function():void
                        {
                           this.textAlign = "center";
                           this.horizontalCenter = "ratioCol:-8";
                           this.verticalCenter = "0";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {"styleName":"statsBigStats"};
                        }
                     }),new UIComponentDescriptor({
                        "type":Label,
                        "id":"_ProfileStatsLifetimeView_Label6",
                        "stylesFactory":function():void
                        {
                           this.textAlign = "center";
                           this.horizontalCenter = "lossCol:0";
                           this.verticalCenter = "0";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {"styleName":"statsBigStats"};
                        }
                     })]
                  };
               }
            }),new UIComponentDescriptor({
               "type":Label,
               "id":"lifeTimeTotalsLabel",
               "stylesFactory":function():void
               {
                  this.color = 4460817;
                  this.horizontalCenter = "leftCol:0";
                  this.textAlign = "center";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "styleName":"statsBigStats",
                     "y":72
                  };
               }
            }),new UIComponentDescriptor({
               "type":Label,
               "id":"avgLabel",
               "stylesFactory":function():void
               {
                  this.color = 4460817;
                  this.horizontalCenter = "rightCol:0";
                  this.textAlign = "center";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "styleName":"statsBigStats",
                     "y":72
                  };
               }
            }),new UIComponentDescriptor({
               "type":GradientCanvas,
               "stylesFactory":function():void
               {
                  this.horizontalCenter = "leftCol:0";
                  this.top = "100";
                  this.bottom = "3";
                  this.backgroundAlpha = 0.8;
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "percentWidth":49,
                     "styleName":"parchmentGradient",
                     "horizontalScrollPolicy":"off",
                     "verticalScrollPolicy":"off",
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":KDAView,
                        "id":"_ProfileStatsLifetimeView_KDAView1",
                        "stylesFactory":function():void
                        {
                           this.top = "5";
                           this.horizontalCenter = "0";
                        }
                     }),new UIComponentDescriptor({
                        "type":HRule,
                        "stylesFactory":function():void
                        {
                           this.horizontalCenter = "0";
                           this.top = "29";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentWidth":95,
                              "styleName":"parchment",
                              "alpha":0.8
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":LifetimeStatsGrid,
                        "id":"_ProfileStatsLifetimeView_LifetimeStatsGrid1",
                        "stylesFactory":function():void
                        {
                           this.top = "30";
                           this.bottom = "0";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "x":0,
                              "percentWidth":50,
                              "statFormatter":formatValue
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":LifetimeStatsGrid,
                        "id":"_ProfileStatsLifetimeView_LifetimeStatsGrid2",
                        "stylesFactory":function():void
                        {
                           this.right = "0";
                           this.top = "30";
                           this.bottom = "0";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentWidth":50,
                              "statFormatter":formatValue
                           };
                        }
                     })]
                  };
               }
            }),new UIComponentDescriptor({
               "type":GradientCanvas,
               "stylesFactory":function():void
               {
                  this.horizontalCenter = "rightCol:0";
                  this.top = "100";
                  this.bottom = "3";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "percentWidth":49,
                     "styleName":"parchmentGradient",
                     "horizontalScrollPolicy":"off",
                     "verticalScrollPolicy":"off",
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":KDAView,
                        "id":"kdaView",
                        "stylesFactory":function():void
                        {
                           this.top = "5";
                           this.horizontalCenter = "0";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {"precision":1};
                        }
                     }),new UIComponentDescriptor({
                        "type":HRule,
                        "stylesFactory":function():void
                        {
                           this.horizontalCenter = "0";
                           this.top = "29";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentWidth":95,
                              "styleName":"parchment",
                              "alpha":0.8
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":LifetimeStatsGrid,
                        "id":"_ProfileStatsLifetimeView_LifetimeStatsGrid3",
                        "stylesFactory":function():void
                        {
                           this.top = "30";
                           this.bottom = "0";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "x":0,
                              "percentWidth":50,
                              "statFormatter":formatValueAverage
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":LifetimeStatsGrid,
                        "id":"_ProfileStatsLifetimeView_LifetimeStatsGrid4",
                        "stylesFactory":function():void
                        {
                           this.right = "0";
                           this.top = "30";
                           this.bottom = "0";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentWidth":50,
                              "statFormatter":formatValueAverage
                           };
                        }
                     })]
                  };
               }
            })]};
         }
      });
      
      private var _1464177956lifeTimeTotalsLabel:Label;
      
      private var _426752373ratioCol:ConstraintColumn;
      
      private var _549826722precisionOneFormatter:NumberFormatter;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      private var _1060399231numberFormatter:NumberFormatter;
      
      private var _55416825leftCol:ConstraintColumn;
      
      public var _ProfileStatsLifetimeView_Label1:Label;
      
      public var _ProfileStatsLifetimeView_Label2:Label;
      
      public var _ProfileStatsLifetimeView_Label3:Label;
      
      public var _ProfileStatsLifetimeView_Label4:Label;
      
      public var _ProfileStatsLifetimeView_Label5:Label;
      
      public var _ProfileStatsLifetimeView_Label6:Label;
      
      private var _1349897705winsCol:ConstraintColumn;
      
      mx_internal var _watchers:Array = [];
      
      public var _ProfileStatsLifetimeView_KDAView1:KDAView;
      
      private var _866191123kdaView:KDAView;
      
      private var _159335554profileLifetimeStatsPresentationModel:ProfileLifetimeStatsPresentationModel;
      
      public var _ProfileStatsLifetimeView_LifetimeStatsGrid1:LifetimeStatsGrid;
      
      public var _ProfileStatsLifetimeView_LifetimeStatsGrid2:LifetimeStatsGrid;
      
      public var _ProfileStatsLifetimeView_LifetimeStatsGrid3:LifetimeStatsGrid;
      
      public var _ProfileStatsLifetimeView_LifetimeStatsGrid4:LifetimeStatsGrid;
      
      private var _257845681avgNumberFormatter:NumberFormatter;
      
      private var _353684317lossCol:ConstraintColumn;
      
      private var _1436106300rightCol:ConstraintColumn;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      private var _204468622championImage:Image;
      
      mx_internal var _bindings:Array = [];
      
      public function ProfileStatsLifetimeView()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.constraintColumns = [this._ProfileStatsLifetimeView_ConstraintColumn1_i(),this._ProfileStatsLifetimeView_ConstraintColumn2_i()];
         this._ProfileStatsLifetimeView_NumberFormatter3_i();
         this._ProfileStatsLifetimeView_NumberFormatter2_i();
         this._ProfileStatsLifetimeView_NumberFormatter1_i();
         this.addEventListener("initialize",this.___ProfileStatsLifetimeView_Canvas1_initialize);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         ProfileStatsLifetimeView._watcherSetupUtil = param1;
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
         var _loc4_:NumberFormatter = null;
         var _loc3_:Number = Number(param1.value);
         if(this.profileLifetimeStatsPresentationModel.totalGames > 0)
         {
            _loc3_ /= this.profileLifetimeStatsPresentationModel.totalGames;
         }
         else
         {
            _loc3_ = 0;
         }
         if(_loc3_ >= 10000)
         {
            _loc4_ = this.numberFormatter;
         }
         else if(_loc3_ >= 100)
         {
            _loc4_ = this.precisionOneFormatter;
         }
         else
         {
            _loc4_ = this.avgNumberFormatter;
         }
         return _loc4_.format(_loc3_);
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
      public function get kdaView() : KDAView
      {
         return this._866191123kdaView;
      }
      
      private function formatMessage(param1:String, param2:Number, param3:String = "", param4:Boolean = false) : String
      {
         var _loc5_:String = "<font color=\'#be3f00\'>";
         var _loc6_:String = "</font>";
         var _loc7_:String = "<b>" + param1 + "</b>" + ": " + _loc5_;
         var _loc8_:String = param2.toString();
         if(param4)
         {
            _loc8_ = this.precisionOneFormatter.format(param2);
         }
         _loc7_ += _loc8_;
         _loc7_ = _loc7_ + param3;
         return _loc7_ + _loc6_;
      }
      
      private function _ProfileStatsLifetimeView_ConstraintColumn2_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.rightCol = _loc1_;
         _loc1_.percentWidth = 50;
         _loc1_.initialized(this,"rightCol");
         return _loc1_;
      }
      
      private function _ProfileStatsLifetimeView_ConstraintColumn5_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.ratioCol = _loc1_;
         _loc1_.percentWidth = 33;
         _loc1_.initialized(this,"ratioCol");
         return _loc1_;
      }
      
      private function _ProfileStatsLifetimeView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = RiotResourceLoader.getString("decimal_seperator",".");
         _loc1_ = RiotResourceLoader.getString("thousands_seperator",",");
         _loc1_ = RiotResourceLoader.getString("thousands_seperator",",");
         _loc1_ = RiotResourceLoader.getString("decimal_seperator",".");
         _loc1_ = RiotResourceLoader.getString("thousands_seperator",",");
         _loc1_ = RiotResourceLoader.getString("decimal_seperator",".");
         _loc1_ = this.profileLifetimeStatsPresentationModel.championId != 0;
         _loc1_ = ChampionImages.getIconPath(this.profileLifetimeStatsPresentationModel.champion.skinName);
         _loc1_ = this.championImage.x + this.championImage.width + 5;
         _loc1_ = this.championImage.y + 16;
         _loc1_ = this.profileLifetimeStatsPresentationModel.champion.displayName;
         _loc1_ = this.profileLifetimeStatsPresentationModel.championId != 0;
         _loc1_ = this.championImage.x + this.championImage.width + 5;
         _loc1_ = this.championImage.y + 32;
         _loc1_ = this.profileLifetimeStatsPresentationModel.champion.description;
         _loc1_ = this.profileLifetimeStatsPresentationModel.championId != 0;
         _loc1_ = this.formatMessage(ResourceManager.getInstance().getString("resources","summonerProfile_stats_lifetime_winLabel"),this.profileLifetimeStatsPresentationModel.totalWins);
         _loc1_ = this.summonerProfileController.isViewingOtherSummonerStats;
         _loc1_ = this.formatMessage(ResourceManager.getInstance().getString("resources","summonerProfile_stats_lifetime_lostLabel"),this.profileLifetimeStatsPresentationModel.totalLosses);
         _loc1_ = this.summonerProfileController.isViewingOtherSummonerStats;
         _loc1_ = this.formatMessage(ResourceManager.getInstance().getString("resources","summonerProfile_stats_lifetime_ratioLabel"),this.profileLifetimeStatsPresentationModel.winRatio,"%",true);
         _loc1_ = this.summonerProfileController.isViewingOtherSummonerStats;
         _loc1_ = this.formatMessage(ResourceManager.getInstance().getString("resources","summonerProfile_stats_lifetime_gamesLabel"),this.profileLifetimeStatsPresentationModel.totalGames);
         _loc1_ = !this.summonerProfileController.isViewingOtherSummonerStats;
         _loc1_ = ResourceManager.getInstance().getString("resources","summonerProfile_stats_lifetime_totals");
         _loc1_ = ResourceManager.getInstance().getString("resources","summonerProfile_stats_lifetime_avg");
         _loc1_ = this.profileLifetimeStatsPresentationModel.totalKills;
         _loc1_ = this.profileLifetimeStatsPresentationModel.totalDeaths;
         _loc1_ = this.profileLifetimeStatsPresentationModel.totalAssists;
         _loc1_ = this.profileLifetimeStatsPresentationModel.totalLeftColStats;
         _loc1_ = this.profileLifetimeStatsPresentationModel.totalRightColStats;
         _loc1_ = this.profileLifetimeStatsPresentationModel.avgKills;
         _loc1_ = this.profileLifetimeStatsPresentationModel.avgDeaths;
         _loc1_ = this.profileLifetimeStatsPresentationModel.avgAssists;
         _loc1_ = this.profileLifetimeStatsPresentationModel.avgLeftColStats;
         _loc1_ = this.profileLifetimeStatsPresentationModel.avgRightColStats;
      }
      
      private function _ProfileStatsLifetimeView_NumberFormatter2_i() : NumberFormatter
      {
         var _loc1_:NumberFormatter = new NumberFormatter();
         this.numberFormatter = _loc1_;
         _loc1_.precision = 0;
         _loc1_.rounding = "none";
         _loc1_.useThousandsSeparator = true;
         _loc1_.useNegativeSign = true;
         BindingManager.executeBindings(this,"numberFormatter",this.numberFormatter);
         return _loc1_;
      }
      
      private function _ProfileStatsLifetimeView_ConstraintColumn1_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.leftCol = _loc1_;
         _loc1_.percentWidth = 50;
         _loc1_.initialized(this,"leftCol");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get avgLabel() : Label
      {
         return this._1922107202avgLabel;
      }
      
      public function set precisionOneFormatter(param1:NumberFormatter) : void
      {
         var _loc2_:Object = this._549826722precisionOneFormatter;
         if(_loc2_ !== param1)
         {
            this._549826722precisionOneFormatter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"precisionOneFormatter",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get avgNumberFormatter() : NumberFormatter
      {
         return this._257845681avgNumberFormatter;
      }
      
      public function ___ProfileStatsLifetimeView_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      private function fillHardcodedStats() : void
      {
      }
      
      [Bindable(event="propertyChange")]
      public function get lossCol() : ConstraintColumn
      {
         return this._353684317lossCol;
      }
      
      private function _ProfileStatsLifetimeView_ConstraintColumn4_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.lossCol = _loc1_;
         _loc1_.percentWidth = 33;
         _loc1_.initialized(this,"lossCol");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get championImage() : Image
      {
         return this._204468622championImage;
      }
      
      private function _ProfileStatsLifetimeView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("decimal_seperator",".");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            precisionOneFormatter.decimalSeparatorTo = param1;
         },"precisionOneFormatter.decimalSeparatorTo");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("thousands_seperator",",");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            precisionOneFormatter.thousandsSeparatorTo = param1;
         },"precisionOneFormatter.thousandsSeparatorTo");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("thousands_seperator",",");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            numberFormatter.thousandsSeparatorTo = param1;
         },"numberFormatter.thousandsSeparatorTo");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("decimal_seperator",".");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            numberFormatter.decimalSeparatorTo = param1;
         },"numberFormatter.decimalSeparatorTo");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("thousands_seperator",",");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            avgNumberFormatter.thousandsSeparatorTo = param1;
         },"avgNumberFormatter.thousandsSeparatorTo");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("decimal_seperator",".");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            avgNumberFormatter.decimalSeparatorTo = param1;
         },"avgNumberFormatter.decimalSeparatorTo");
         result[5] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.profileLifetimeStatsPresentationModel.championId != 0;
         },function(param1:Boolean):void
         {
            championImage.visible = param1;
         },"championImage.visible");
         result[6] = binding;
         binding = new Binding(this,function():Object
         {
            return ChampionImages.getIconPath(this.profileLifetimeStatsPresentationModel.champion.skinName);
         },function(param1:Object):void
         {
            championImage.source = param1;
         },"championImage.source");
         result[7] = binding;
         binding = new Binding(this,function():Number
         {
            return championImage.x + championImage.width + 5;
         },function(param1:Number):void
         {
            _ProfileStatsLifetimeView_Label1.x = param1;
         },"_ProfileStatsLifetimeView_Label1.x");
         result[8] = binding;
         binding = new Binding(this,function():Number
         {
            return championImage.y + 16;
         },function(param1:Number):void
         {
            _ProfileStatsLifetimeView_Label1.y = param1;
         },"_ProfileStatsLifetimeView_Label1.y");
         result[9] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.profileLifetimeStatsPresentationModel.champion.displayName;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ProfileStatsLifetimeView_Label1.htmlText = param1;
         },"_ProfileStatsLifetimeView_Label1.htmlText");
         result[10] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.profileLifetimeStatsPresentationModel.championId != 0;
         },function(param1:Boolean):void
         {
            _ProfileStatsLifetimeView_Label1.visible = param1;
         },"_ProfileStatsLifetimeView_Label1.visible");
         result[11] = binding;
         binding = new Binding(this,function():Number
         {
            return championImage.x + championImage.width + 5;
         },function(param1:Number):void
         {
            _ProfileStatsLifetimeView_Label2.x = param1;
         },"_ProfileStatsLifetimeView_Label2.x");
         result[12] = binding;
         binding = new Binding(this,function():Number
         {
            return championImage.y + 32;
         },function(param1:Number):void
         {
            _ProfileStatsLifetimeView_Label2.y = param1;
         },"_ProfileStatsLifetimeView_Label2.y");
         result[13] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.profileLifetimeStatsPresentationModel.champion.description;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ProfileStatsLifetimeView_Label2.htmlText = param1;
         },"_ProfileStatsLifetimeView_Label2.htmlText");
         result[14] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.profileLifetimeStatsPresentationModel.championId != 0;
         },function(param1:Boolean):void
         {
            _ProfileStatsLifetimeView_Label2.visible = param1;
         },"_ProfileStatsLifetimeView_Label2.visible");
         result[15] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.formatMessage(ResourceManager.getInstance().getString("resources","summonerProfile_stats_lifetime_winLabel"),this.profileLifetimeStatsPresentationModel.totalWins);
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ProfileStatsLifetimeView_Label3.htmlText = param1;
         },"_ProfileStatsLifetimeView_Label3.htmlText");
         result[16] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.summonerProfileController.isViewingOtherSummonerStats;
         },function(param1:Boolean):void
         {
            _ProfileStatsLifetimeView_Label3.visible = param1;
         },"_ProfileStatsLifetimeView_Label3.visible");
         result[17] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.formatMessage(ResourceManager.getInstance().getString("resources","summonerProfile_stats_lifetime_lostLabel"),this.profileLifetimeStatsPresentationModel.totalLosses);
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ProfileStatsLifetimeView_Label4.htmlText = param1;
         },"_ProfileStatsLifetimeView_Label4.htmlText");
         result[18] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.summonerProfileController.isViewingOtherSummonerStats;
         },function(param1:Boolean):void
         {
            _ProfileStatsLifetimeView_Label4.visible = param1;
         },"_ProfileStatsLifetimeView_Label4.visible");
         result[19] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.formatMessage(ResourceManager.getInstance().getString("resources","summonerProfile_stats_lifetime_ratioLabel"),this.profileLifetimeStatsPresentationModel.winRatio,"%",true);
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ProfileStatsLifetimeView_Label5.htmlText = param1;
         },"_ProfileStatsLifetimeView_Label5.htmlText");
         result[20] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.summonerProfileController.isViewingOtherSummonerStats;
         },function(param1:Boolean):void
         {
            _ProfileStatsLifetimeView_Label5.visible = param1;
         },"_ProfileStatsLifetimeView_Label5.visible");
         result[21] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.formatMessage(ResourceManager.getInstance().getString("resources","summonerProfile_stats_lifetime_gamesLabel"),this.profileLifetimeStatsPresentationModel.totalGames);
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ProfileStatsLifetimeView_Label6.htmlText = param1;
         },"_ProfileStatsLifetimeView_Label6.htmlText");
         result[22] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !this.summonerProfileController.isViewingOtherSummonerStats;
         },function(param1:Boolean):void
         {
            _ProfileStatsLifetimeView_Label6.visible = param1;
         },"_ProfileStatsLifetimeView_Label6.visible");
         result[23] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ResourceManager.getInstance().getString("resources","summonerProfile_stats_lifetime_totals");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            lifeTimeTotalsLabel.htmlText = param1;
         },"lifeTimeTotalsLabel.htmlText");
         result[24] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ResourceManager.getInstance().getString("resources","summonerProfile_stats_lifetime_avg");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            avgLabel.htmlText = param1;
         },"avgLabel.htmlText");
         result[25] = binding;
         binding = new Binding(this,function():Number
         {
            return this.profileLifetimeStatsPresentationModel.totalKills;
         },function(param1:Number):void
         {
            _ProfileStatsLifetimeView_KDAView1.kills = param1;
         },"_ProfileStatsLifetimeView_KDAView1.kills");
         result[26] = binding;
         binding = new Binding(this,function():Number
         {
            return this.profileLifetimeStatsPresentationModel.totalDeaths;
         },function(param1:Number):void
         {
            _ProfileStatsLifetimeView_KDAView1.deaths = param1;
         },"_ProfileStatsLifetimeView_KDAView1.deaths");
         result[27] = binding;
         binding = new Binding(this,function():Number
         {
            return this.profileLifetimeStatsPresentationModel.totalAssists;
         },function(param1:Number):void
         {
            _ProfileStatsLifetimeView_KDAView1.assists = param1;
         },"_ProfileStatsLifetimeView_KDAView1.assists");
         result[28] = binding;
         binding = new Binding(this,function():Object
         {
            return this.profileLifetimeStatsPresentationModel.totalLeftColStats;
         },function(param1:Object):void
         {
            _ProfileStatsLifetimeView_LifetimeStatsGrid1.dataProvider = param1;
         },"_ProfileStatsLifetimeView_LifetimeStatsGrid1.dataProvider");
         result[29] = binding;
         binding = new Binding(this,function():Object
         {
            return this.profileLifetimeStatsPresentationModel.totalRightColStats;
         },function(param1:Object):void
         {
            _ProfileStatsLifetimeView_LifetimeStatsGrid2.dataProvider = param1;
         },"_ProfileStatsLifetimeView_LifetimeStatsGrid2.dataProvider");
         result[30] = binding;
         binding = new Binding(this,function():Number
         {
            return this.profileLifetimeStatsPresentationModel.avgKills;
         },function(param1:Number):void
         {
            kdaView.kills = param1;
         },"kdaView.kills");
         result[31] = binding;
         binding = new Binding(this,function():Number
         {
            return this.profileLifetimeStatsPresentationModel.avgDeaths;
         },function(param1:Number):void
         {
            kdaView.deaths = param1;
         },"kdaView.deaths");
         result[32] = binding;
         binding = new Binding(this,function():Number
         {
            return this.profileLifetimeStatsPresentationModel.avgAssists;
         },function(param1:Number):void
         {
            kdaView.assists = param1;
         },"kdaView.assists");
         result[33] = binding;
         binding = new Binding(this,function():Object
         {
            return this.profileLifetimeStatsPresentationModel.avgLeftColStats;
         },function(param1:Object):void
         {
            _ProfileStatsLifetimeView_LifetimeStatsGrid3.dataProvider = param1;
         },"_ProfileStatsLifetimeView_LifetimeStatsGrid3.dataProvider");
         result[34] = binding;
         binding = new Binding(this,function():Object
         {
            return this.profileLifetimeStatsPresentationModel.avgRightColStats;
         },function(param1:Object):void
         {
            _ProfileStatsLifetimeView_LifetimeStatsGrid4.dataProvider = param1;
         },"_ProfileStatsLifetimeView_LifetimeStatsGrid4.dataProvider");
         result[35] = binding;
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get ratioCol() : ConstraintColumn
      {
         return this._426752373ratioCol;
      }
      
      private function _ProfileStatsLifetimeView_NumberFormatter1_i() : NumberFormatter
      {
         var _loc1_:NumberFormatter = new NumberFormatter();
         this.precisionOneFormatter = _loc1_;
         _loc1_.rounding = "nearest";
         _loc1_.useNegativeSign = true;
         _loc1_.precision = 1;
         BindingManager.executeBindings(this,"precisionOneFormatter",this.precisionOneFormatter);
         return _loc1_;
      }
      
      public function get summonerProfileController() : SummonerProfileController
      {
         return this._summonerProfileController;
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
      
      public function set avgLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1922107202avgLabel;
         if(_loc2_ !== param1)
         {
            this._1922107202avgLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"avgLabel",_loc2_,param1));
         }
      }
      
      public function set rightCol(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._1436106300rightCol;
         if(_loc2_ !== param1)
         {
            this._1436106300rightCol = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rightCol",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:ProfileStatsLifetimeView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._ProfileStatsLifetimeView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_summoner_stats_ProfileStatsLifetimeViewWatcherSetupUtil");
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
      
      public function set avgNumberFormatter(param1:NumberFormatter) : void
      {
         var _loc2_:Object = this._257845681avgNumberFormatter;
         if(_loc2_ !== param1)
         {
            this._257845681avgNumberFormatter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"avgNumberFormatter",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get precisionOneFormatter() : NumberFormatter
      {
         return this._549826722precisionOneFormatter;
      }
      
      private function _ProfileStatsLifetimeView_ConstraintColumn3_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.winsCol = _loc1_;
         _loc1_.percentWidth = 33;
         _loc1_.initialized(this,"winsCol");
         return _loc1_;
      }
      
      public function set lifeTimeTotalsLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1464177956lifeTimeTotalsLabel;
         if(_loc2_ !== param1)
         {
            this._1464177956lifeTimeTotalsLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lifeTimeTotalsLabel",_loc2_,param1));
         }
      }
      
      private function formatValue(param1:Object, param2:DataGridColumn) : String
      {
         return this.numberFormatter.format(param1.value);
      }
      
      public function set lossCol(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._353684317lossCol;
         if(_loc2_ !== param1)
         {
            this._353684317lossCol = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lossCol",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rightCol() : ConstraintColumn
      {
         return this._1436106300rightCol;
      }
      
      private function onInitialize() : void
      {
      }
      
      public function set winsCol(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._1349897705winsCol;
         if(_loc2_ !== param1)
         {
            this._1349897705winsCol = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"winsCol",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lifeTimeTotalsLabel() : Label
      {
         return this._1464177956lifeTimeTotalsLabel;
      }
      
      public function set kdaView(param1:KDAView) : void
      {
         var _loc2_:Object = this._866191123kdaView;
         if(_loc2_ !== param1)
         {
            this._866191123kdaView = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"kdaView",_loc2_,param1));
         }
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
      
      [Bindable(event="propertyChange")]
      public function get winsCol() : ConstraintColumn
      {
         return this._1349897705winsCol;
      }
      
      public function set ratioCol(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._426752373ratioCol;
         if(_loc2_ !== param1)
         {
            this._426752373ratioCol = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ratioCol",_loc2_,param1));
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
      
      public function set leftCol(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._55416825leftCol;
         if(_loc2_ !== param1)
         {
            this._55416825leftCol = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leftCol",_loc2_,param1));
         }
      }
      
      private function _ProfileStatsLifetimeView_NumberFormatter3_i() : NumberFormatter
      {
         var _loc1_:NumberFormatter = new NumberFormatter();
         this.avgNumberFormatter = _loc1_;
         _loc1_.precision = 2;
         _loc1_.rounding = "none";
         _loc1_.useThousandsSeparator = true;
         _loc1_.useNegativeSign = true;
         BindingManager.executeBindings(this,"avgNumberFormatter",this.avgNumberFormatter);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get leftCol() : ConstraintColumn
      {
         return this._55416825leftCol;
      }
      
      private function set _566834807summonerProfileController(param1:SummonerProfileController) : void
      {
         if(this._summonerProfileController === param1)
         {
            return;
         }
         this._summonerProfileController = param1;
         if(this._summonerProfileController != null)
         {
            this.profileLifetimeStatsPresentationModel = this._summonerProfileController.profileLifetimeStatsPresentationModel;
         }
         else
         {
            this.profileLifetimeStatsPresentationModel = null;
         }
      }
   }
}

