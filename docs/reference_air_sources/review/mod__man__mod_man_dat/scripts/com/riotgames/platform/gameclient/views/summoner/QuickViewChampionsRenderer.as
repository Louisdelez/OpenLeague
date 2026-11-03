package com.riotgames.platform.gameclient.views.summoner
{
   import com.riotgames.platform.gameclient.controllers.summoner.SummonerProfileController;
   import com.riotgames.platform.gameclient.domain.PlayerChampionStats;
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
   import mx.controls.Image;
   import mx.controls.Text;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class QuickViewChampionsRenderer extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      private var _728116771totalGames:uint = 0;
      
      mx_internal var _watchers:Array;
      
      private var _948491687colLeft:ConstraintColumn;
      
      private var _1096968431losses:uint = 0;
      
      private var _655867780colRight:ConstraintColumn;
      
      private var _1354879453colImg:ConstraintColumn;
      
      private var _3649559wins:uint = 0;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      mx_internal var _bindingsByDestination:Object;
      
      private var _2100886088championDeaths:uint = 0;
      
      private var _204468622championImage:Image;
      
      private var _1542437247championAssists:uint = 0;
      
      mx_internal var _bindings:Array;
      
      private var _270636692championName:Text;
      
      private var _202730004championKills:uint = 0;
      
      [Inject]
      private var _566834807summonerProfileController:SummonerProfileController;
      
      private var _221242161winsLosses_num:Text;
      
      public function QuickViewChampionsRenderer()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":Image,
                  "id":"championImage",
                  "stylesFactory":function():void
                  {
                     this.left = "5";
                     this.verticalCenter = "0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"maintainAspectRatio":true};
                  }
               }),new UIComponentDescriptor({
                  "type":Text,
                  "id":"championName",
                  "stylesFactory":function():void
                  {
                     this.fontSize = 18;
                     this.left = "colLeft:2";
                     this.right = "colRight:0";
                     this.textAlign = "left";
                     this.top = "14";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "styleName":"summonerStatsTextLarge",
                        "selectable":false
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Text,
                  "id":"winsLosses_num",
                  "stylesFactory":function():void
                  {
                     this.top = "36";
                     this.color = 0;
                     this.textAlign = "left";
                     this.left = "colLeft:2";
                     this.right = "colRight:0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "styleName":"summonerStatsTextSmall",
                        "selectable":false
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
            this.backgroundAlpha = 0;
         };
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.percentWidth = 100;
         this.percentHeight = 100;
         this.constraintColumns = [this._QuickViewChampionsRenderer_ConstraintColumn1_i(),this._QuickViewChampionsRenderer_ConstraintColumn2_i(),this._QuickViewChampionsRenderer_ConstraintColumn3_i()];
         this.addEventListener("initialize",this.___QuickViewChampionsRenderer_Canvas1_initialize);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         QuickViewChampionsRenderer._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      private function get championAssists() : uint
      {
         return this._1542437247championAssists;
      }
      
      private function set championAssists(param1:uint) : void
      {
         var _loc2_:Object = this._1542437247championAssists;
         if(_loc2_ !== param1)
         {
            this._1542437247championAssists = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championAssists",_loc2_,param1));
         }
      }
      
      private function _QuickViewChampionsRenderer_ConstraintColumn2_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.colLeft = _loc1_;
         _loc1_.percentWidth = 32.5;
         _loc1_.initialized(this,"colLeft");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get summonerProfileController() : SummonerProfileController
      {
         return this._566834807summonerProfileController;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:QuickViewChampionsRenderer = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._QuickViewChampionsRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_summoner_QuickViewChampionsRendererWatcherSetupUtil");
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
      private function get losses() : uint
      {
         return this._1096968431losses;
      }
      
      [Bindable(event="propertyChange")]
      public function get championName() : Text
      {
         return this._270636692championName;
      }
      
      [Bindable(event="propertyChange")]
      private function get championKills() : uint
      {
         return this._202730004championKills;
      }
      
      public function set winsLosses_num(param1:Text) : void
      {
         var _loc2_:Object = this._221242161winsLosses_num;
         if(_loc2_ !== param1)
         {
            this._221242161winsLosses_num = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"winsLosses_num",_loc2_,param1));
         }
      }
      
      private function set championDeaths(param1:uint) : void
      {
         var _loc2_:Object = this._2100886088championDeaths;
         if(_loc2_ !== param1)
         {
            this._2100886088championDeaths = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championDeaths",_loc2_,param1));
         }
      }
      
      private function set losses(param1:uint) : void
      {
         var _loc2_:Object = this._1096968431losses;
         if(_loc2_ !== param1)
         {
            this._1096968431losses = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"losses",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get wins() : uint
      {
         return this._3649559wins;
      }
      
      [Bindable(event="propertyChange")]
      public function get colLeft() : ConstraintColumn
      {
         return this._948491687colLeft;
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
      
      [Bindable(event="propertyChange")]
      public function get colImg() : ConstraintColumn
      {
         return this._1354879453colImg;
      }
      
      private function set wins(param1:uint) : void
      {
         var _loc2_:Object = this._3649559wins;
         if(_loc2_ !== param1)
         {
            this._3649559wins = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"wins",_loc2_,param1));
         }
      }
      
      private function set totalGames(param1:uint) : void
      {
         var _loc2_:Object = this._728116771totalGames;
         if(_loc2_ !== param1)
         {
            this._728116771totalGames = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"totalGames",_loc2_,param1));
         }
      }
      
      private function _QuickViewChampionsRenderer_ConstraintColumn1_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.colImg = _loc1_;
         _loc1_.percentWidth = 25;
         _loc1_.initialized(this,"colImg");
         return _loc1_;
      }
      
      private function _QuickViewChampionsRenderer_ConstraintColumn3_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.colRight = _loc1_;
         _loc1_.percentWidth = 42.5;
         _loc1_.initialized(this,"colRight");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      private function get championDeaths() : uint
      {
         return this._2100886088championDeaths;
      }
      
      private function _QuickViewChampionsRenderer_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Number
         {
            return this.height - 10;
         },function(param1:Number):void
         {
            championImage.height = param1;
         },"championImage.height");
         result[0] = binding;
         binding = new Binding(this,function():Object
         {
            return ChampionImages.getIconPath(this.data.champion.skinName);
         },function(param1:Object):void
         {
            championImage.source = param1;
         },"championImage.source");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.data.champion.displayName;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            championName.text = param1;
         },"championName.text");
         result[2] = binding;
         return result;
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
      
      private function onInitialize() : void
      {
      }
      
      public function set colImg(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._1354879453colImg;
         if(_loc2_ !== param1)
         {
            this._1354879453colImg = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"colImg",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get winsLosses_num() : Text
      {
         return this._221242161winsLosses_num;
      }
      
      private function set championKills(param1:uint) : void
      {
         var _loc2_:Object = this._202730004championKills;
         if(_loc2_ !== param1)
         {
            this._202730004championKills = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championKills",_loc2_,param1));
         }
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         var _loc2_:PlayerChampionStats = param1 as PlayerChampionStats;
         if(_loc2_ == null)
         {
            return;
         }
         this.totalGames = _loc2_.getTotalGames();
         this.wins = _loc2_.getWins();
         this.losses = _loc2_.getLosses();
         this.championKills = _loc2_.getKills();
         this.championDeaths = _loc2_.getDeaths();
         this.championAssists = _loc2_.getAssists();
         this.winsLosses_num.htmlText = resourceManager.getString("resources","summonerProfile_profile_statsGamesPlayed") + ": " + this.totalGames;
      }
      
      [Bindable(event="propertyChange")]
      private function get totalGames() : uint
      {
         return this._728116771totalGames;
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
      
      public function ___QuickViewChampionsRenderer_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      [Bindable(event="propertyChange")]
      public function get championImage() : Image
      {
         return this._204468622championImage;
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
      
      public function set colRight(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._655867780colRight;
         if(_loc2_ !== param1)
         {
            this._655867780colRight = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"colRight",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get colRight() : ConstraintColumn
      {
         return this._655867780colRight;
      }
      
      private function _QuickViewChampionsRenderer_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.height - 10;
         _loc1_ = ChampionImages.getIconPath(this.data.champion.skinName);
         _loc1_ = this.data.champion.displayName;
      }
   }
}

