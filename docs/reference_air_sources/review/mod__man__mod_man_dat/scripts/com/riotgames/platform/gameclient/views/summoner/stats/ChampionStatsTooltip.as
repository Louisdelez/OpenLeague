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
   import mx.containers.VBox;
   import mx.containers.utilityClasses.ConstraintColumn;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.core.IToolTip;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.formatters.NumberFormatter;
   import mx.resources.ResourceManager;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class ChampionStatsTooltip extends GradientCanvas implements IBindingClient, IToolTip
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public var _text:String;
      
      mx_internal var _watchers:Array;
      
      private var _948491687colLeft:ConstraintColumn;
      
      private var _655867780colRight:ConstraintColumn;
      
      public var _ChampionStatsTooltip_VBox1:VBox;
      
      private var _1534232614winsOrKDALabel:Label;
      
      private var _2087385744kdaRatioText:Label;
      
      private var formatter:NumberFormatter;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      private var _270489730championIcon:Image;
      
      private var _1434259050champName:Label;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindings:Array;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public var summonerProfileController:SummonerProfileController;
      
      public function ChampionStatsTooltip()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":GradientCanvas,
            "propertiesFactory":function():Object
            {
               return {
                  "width":350,
                  "height":80,
                  "childDescriptors":[new UIComponentDescriptor({
                     "type":Image,
                     "id":"championIcon",
                     "stylesFactory":function():void
                     {
                        this.left = "10";
                        this.top = "5";
                     }
                  }),new UIComponentDescriptor({
                     "type":Label,
                     "id":"champName",
                     "stylesFactory":function():void
                     {
                        this.top = "2";
                        this.left = "colRight:5";
                        this.textAlign = "left";
                        this.textDecoration = "underline";
                     },
                     "propertiesFactory":function():Object
                     {
                        return {"styleName":"champStatsName"};
                     }
                  }),new UIComponentDescriptor({
                     "type":VBox,
                     "id":"_ChampionStatsTooltip_VBox1",
                     "stylesFactory":function():void
                     {
                        this.left = "colRight:5";
                        this.verticalGap = -4;
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "verticalScrollPolicy":"off",
                           "childDescriptors":[new UIComponentDescriptor({
                              "type":Label,
                              "id":"winsOrKDALabel",
                              "stylesFactory":function():void
                              {
                                 this.textAlign = "center";
                              },
                              "propertiesFactory":function():Object
                              {
                                 return {
                                    "styleName":"champSatsStatus",
                                    "percentWidth":100
                                 };
                              }
                           }),new UIComponentDescriptor({
                              "type":Label,
                              "id":"kdaRatioText",
                              "stylesFactory":function():void
                              {
                                 this.textAlign = "center";
                              },
                              "propertiesFactory":function():Object
                              {
                                 return {
                                    "styleName":"champSatsStatus",
                                    "percentWidth":100
                                 };
                              }
                           })]
                        };
                     }
                  })]
               };
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
         this.styleName = "chatBackground";
         this.verticalScrollPolicy = "off";
         this.horizontalScrollPolicy = "off";
         this.width = 350;
         this.height = 80;
         this.constraintColumns = [this._ChampionStatsTooltip_ConstraintColumn1_i(),this._ChampionStatsTooltip_ConstraintColumn2_i()];
         this.addEventListener("addedToStage",this.___ChampionStatsTooltip_GradientCanvas1_addedToStage);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         ChampionStatsTooltip._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get championIcon() : Image
      {
         return this._270489730championIcon;
      }
      
      [Bindable(event="propertyChange")]
      public function get colRight() : ConstraintColumn
      {
         return this._655867780colRight;
      }
      
      public function set championIcon(param1:Image) : void
      {
         var _loc2_:Object = this._270489730championIcon;
         if(_loc2_ !== param1)
         {
            this._270489730championIcon = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championIcon",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:ChampionStatsTooltip = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._ChampionStatsTooltip_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_summoner_stats_ChampionStatsTooltipWatcherSetupUtil");
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
      
      public function ___ChampionStatsTooltip_GradientCanvas1_addedToStage(param1:Event) : void
      {
         this.onInjection();
      }
      
      [Bindable(event="propertyChange")]
      public function get winsOrKDALabel() : Label
      {
         return this._1534232614winsOrKDALabel;
      }
      
      [Bindable(event="propertyChange")]
      public function get colLeft() : ConstraintColumn
      {
         return this._948491687colLeft;
      }
      
      [Bindable(event="propertyChange")]
      public function get kdaRatioText() : Label
      {
         return this._2087385744kdaRatioText;
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      private function _ChampionStatsTooltip_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.colLeft.width * 0.75;
         _loc1_ = this.data.displayName + " - " + this.data.description;
         _loc1_ = this.champName.y + this.champName.height;
      }
      
      public function shouldShowStats() : Boolean
      {
         return this.summonerProfileController.isViewingOtherSummonerStats;
      }
      
      private function _ChampionStatsTooltip_ConstraintColumn2_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.colRight = _loc1_;
         _loc1_.percentWidth = 75;
         _loc1_.initialized(this,"colRight");
         return _loc1_;
      }
      
      private function onInjection() : void
      {
         invalidateProperties();
      }
      
      public function set kdaRatioText(param1:Label) : void
      {
         var _loc2_:Object = this._2087385744kdaRatioText;
         if(_loc2_ !== param1)
         {
            this._2087385744kdaRatioText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"kdaRatioText",_loc2_,param1));
         }
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
      
      override protected function commitProperties() : void
      {
         var _loc9_:String = null;
         if(this.formatter == null)
         {
            this.formatter = new NumberFormatter();
            this.formatter.rounding = "nearest";
            this.formatter.useNegativeSign = true;
            this.formatter.decimalSeparatorTo = RiotResourceLoader.getString("decimal_seperator",".");
            this.formatter.thousandsSeparatorTo = RiotResourceLoader.getString("thousands_seperator",",");
            this.formatter.decimalSeparatorFrom = ".";
            this.formatter.thousandsSeparatorFrom = ",";
            this.formatter.precision = 1;
         }
         if(!this.summonerProfileController || !this.championIcon || !data)
         {
            return;
         }
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = 100;
         var _loc5_:Number = -1;
         this.championIcon.source = ChampionImages.getIconPath(this.data.skinName);
         var _loc6_:ChampionSummaryStatsData = this.summonerProfileController.championSummaryStats[this.data.championId];
         if(_loc6_)
         {
            _loc1_ = Number(_loc6_.wins);
            _loc2_ = Number(_loc6_.totalGames);
            if(_loc2_ > 0)
            {
               _loc4_ = _loc1_ / _loc2_ * 100;
            }
            _loc5_ = Number(_loc6_.getKDARatio());
         }
         if(this.summonerProfileController.totalGamesPlayed > 0)
         {
            _loc3_ = _loc2_ / this.summonerProfileController.totalGamesPlayed * 100;
         }
         var _loc7_:String = "<font color=\'#FF771C\'>";
         var _loc8_:String = "</font>";
         if(this.shouldShowStats())
         {
            this.winsOrKDALabel.htmlText = ResourceManager.getInstance().getString("resources","summonerProfile_champion_tooltip_wins",[_loc7_ + _loc1_.toString() + _loc8_,_loc7_ + this.formatter.format(_loc4_) + "%" + _loc8_]);
         }
         if(_loc5_ >= 0)
         {
            _loc9_ = this.formatter.format(_loc5_);
            if(this.shouldShowStats())
            {
               this.kdaRatioText.htmlText = ResourceManager.getInstance().getString("resources","summonerProfile_champion_tooltip_kda",[_loc7_ + _loc9_ + _loc8_]);
            }
            else
            {
               this.winsOrKDALabel.htmlText = ResourceManager.getInstance().getString("resources","summonerProfile_champion_tooltip_kda",[_loc7_ + _loc9_ + _loc8_]);
            }
         }
         else
         {
            this.kdaRatioText.includeInLayout = false;
         }
      }
      
      public function set winsOrKDALabel(param1:Label) : void
      {
         var _loc2_:Object = this._1534232614winsOrKDALabel;
         if(_loc2_ !== param1)
         {
            this._1534232614winsOrKDALabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"winsOrKDALabel",_loc2_,param1));
         }
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         invalidateProperties();
      }
      
      public function set champName(param1:Label) : void
      {
         var _loc2_:Object = this._1434259050champName;
         if(_loc2_ !== param1)
         {
            this._1434259050champName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"champName",_loc2_,param1));
         }
      }
      
      public function set text(param1:String) : void
      {
      }
      
      [Bindable(event="propertyChange")]
      public function get champName() : Label
      {
         return this._1434259050champName;
      }
      
      private function _ChampionStatsTooltip_ConstraintColumn1_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.colLeft = _loc1_;
         _loc1_.percentWidth = 25;
         _loc1_.initialized(this,"colLeft");
         return _loc1_;
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
      
      private function _ChampionStatsTooltip_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Number
         {
            return colLeft.width * 0.75;
         },function(param1:Number):void
         {
            championIcon.width = param1;
         },"championIcon.width");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.data.displayName + " - " + this.data.description;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            champName.htmlText = param1;
         },"champName.htmlText");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = champName.y + champName.height;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ChampionStatsTooltip_VBox1.setStyle("top",param1);
         },"_ChampionStatsTooltip_VBox1.top");
         result[2] = binding;
         return result;
      }
   }
}

