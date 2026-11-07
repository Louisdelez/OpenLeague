package com.riotgames.platform.gameclient.controllers.game.views.popup
{
   import com.riotgames.platform.gameclient.controllers.game.toMove.components.DialogFrame;
   import com.riotgames.platform.gameclient.domain.AggregatedStat;
   import com.riotgames.platform.gameclient.domain.AggregatedStatType;
   import com.riotgames.platform.gameclient.domain.PlayerParticipant;
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
   import mx.controls.Label;
   import mx.controls.Menu;
   import mx.controls.menuClasses.IMenuItemRenderer;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   public class PlayerProfileTooltip extends Canvas implements IBindingClient, IMenuItemRenderer
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _457199278playerLosses:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array = [];
      
      private var _1897126717stats_c:HBox;
      
      private var _1213857322summonerName_txt:Label;
      
      private var _1729065546summonerWins_txt:Label;
      
      private var _607252975frame_c:DialogFrame;
      
      private var _2095933080playerWins:Number;
      
      private var _721437744summonerLosses_txt:Label;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object = {};
      
      private var _1506219410playerParticipant:PlayerParticipant;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object = {};
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array = [];
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {
               "width":300,
               "height":100,
               "childDescriptors":[new UIComponentDescriptor({
                  "type":DialogFrame,
                  "id":"frame_c",
                  "stylesFactory":function():void
                  {
                     this.backgroundAlpha = 0.5;
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "percentHeight":100,
                        "percentWidth":100
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Label,
                  "id":"summonerName_txt"
               }),new UIComponentDescriptor({
                  "type":Label,
                  "id":"summonerLevel_txt",
                  "stylesFactory":function():void
                  {
                     this.textAlign = "center";
                     this.color = 13421772;
                  }
               }),new UIComponentDescriptor({
                  "type":HBox,
                  "id":"stats_c",
                  "stylesFactory":function():void
                  {
                     this.horizontalAlign = "center";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"childDescriptors":[new UIComponentDescriptor({
                        "type":Label,
                        "id":"summonerWins_txt",
                        "stylesFactory":function():void
                        {
                           this.fontSize = 14;
                        }
                     }),new UIComponentDescriptor({
                        "type":Label,
                        "id":"summonerLosses_txt",
                        "stylesFactory":function():void
                        {
                           this.fontSize = 14;
                        }
                     })]};
                  }
               })]
            };
         }
      });
      
      private var _380062087summonerLevel_txt:Label;
      
      public function PlayerProfileTooltip()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.width = 300;
         this.height = 100;
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         PlayerProfileTooltip._watcherSetupUtil = param1;
      }
      
      public function set summonerName_txt(param1:Label) : void
      {
         var _loc2_:Object = this._1213857322summonerName_txt;
         if(_loc2_ !== param1)
         {
            this._1213857322summonerName_txt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerName_txt",_loc2_,param1));
         }
      }
      
      public function set stats_c(param1:HBox) : void
      {
         var _loc2_:Object = this._1897126717stats_c;
         if(_loc2_ !== param1)
         {
            this._1897126717stats_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"stats_c",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerLevel_txt() : Label
      {
         return this._380062087summonerLevel_txt;
      }
      
      public function get measuredTypeIconWidth() : Number
      {
         return 0;
      }
      
      public function set summonerLevel_txt(param1:Label) : void
      {
         var _loc2_:Object = this._380062087summonerLevel_txt;
         if(_loc2_ !== param1)
         {
            this._380062087summonerLevel_txt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerLevel_txt",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get frame_c() : DialogFrame
      {
         return this._607252975frame_c;
      }
      
      [Bindable(event="propertyChange")]
      private function get playerParticipant() : PlayerParticipant
      {
         return this._1506219410playerParticipant;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:PlayerProfileTooltip = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._PlayerProfileTooltip_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_controllers_game_views_popup_PlayerProfileTooltipWatcherSetupUtil");
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
      
      public function set frame_c(param1:DialogFrame) : void
      {
         var _loc2_:Object = this._607252975frame_c;
         if(_loc2_ !== param1)
         {
            this._607252975frame_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"frame_c",_loc2_,param1));
         }
      }
      
      private function set playerParticipant(param1:PlayerParticipant) : void
      {
         var _loc2_:Object = this._1506219410playerParticipant;
         if(_loc2_ !== param1)
         {
            this._1506219410playerParticipant = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerParticipant",_loc2_,param1));
         }
      }
      
      public function get measuredIconWidth() : Number
      {
         return 0;
      }
      
      public function get measuredBranchIconWidth() : Number
      {
         return 0;
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerLosses_txt() : Label
      {
         return this._721437744summonerLosses_txt;
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerName_txt() : Label
      {
         return this._1213857322summonerName_txt;
      }
      
      private function set playerWins(param1:Number) : void
      {
         var _loc2_:Object = this._2095933080playerWins;
         if(_loc2_ !== param1)
         {
            this._2095933080playerWins = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerWins",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get playerWins() : Number
      {
         return this._2095933080playerWins;
      }
      
      private function set playerLosses(param1:Number) : void
      {
         var _loc2_:Object = this._457199278playerLosses;
         if(_loc2_ !== param1)
         {
            this._457199278playerLosses = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerLosses",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerWins_txt() : Label
      {
         return this._1729065546summonerWins_txt;
      }
      
      [Bindable(event="propertyChange")]
      public function get stats_c() : HBox
      {
         return this._1897126717stats_c;
      }
      
      public function set menu(param1:Menu) : void
      {
      }
      
      [Bindable(event="propertyChange")]
      private function get playerLosses() : Number
      {
         return this._457199278playerLosses;
      }
      
      private function setStats() : void
      {
         if(this.playerParticipant == null)
         {
            return;
         }
         var _loc1_:AggregatedStat = this.playerParticipant.getAggregatedStatistic(AggregatedStatType.STAT_TYPE_WINS,0);
         this.playerWins = _loc1_ != null ? Number(_loc1_.value) : 0;
         _loc1_ = this.playerParticipant.getAggregatedStatistic(AggregatedStatType.STAT_TYPE_LOSSES,0);
         this.playerLosses = _loc1_ != null ? Number(_loc1_.value) : 0;
      }
      
      private function _PlayerProfileTooltip_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.frame_c.innerLeft - 15;
         _loc1_ = this.frame_c.innerTop - 15;
         _loc1_ = this.playerParticipant.summonerName;
         _loc1_ = this.frame_c.innerWidth;
         _loc1_ = this.summonerName_txt.y + this.summonerName_txt.height + 2;
         _loc1_ = resourceManager.getString("resources","playerProfile_levelLabel") + this.playerParticipant.summonerLevel;
         _loc1_ = this.frame_c.width;
         _loc1_ = this.summonerLevel_txt.y + this.summonerLevel_txt.height + 2;
         _loc1_ = this.summonerLevel_txt.width;
         _loc1_ = resourceManager.getString("resources","playerProfile_winsLabel") + " " + this.playerWins;
         _loc1_ = resourceManager.getString("resources","playerProfile_lossesLabel") + " " + this.playerLosses;
      }
      
      public function get menu() : Menu
      {
         return null;
      }
      
      public function set summonerLosses_txt(param1:Label) : void
      {
         var _loc2_:Object = this._721437744summonerLosses_txt;
         if(_loc2_ !== param1)
         {
            this._721437744summonerLosses_txt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerLosses_txt",_loc2_,param1));
         }
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         if(this.data != null)
         {
            this.playerParticipant = param1 as PlayerParticipant;
            this.setStats();
         }
      }
      
      override public function set visible(param1:Boolean) : void
      {
         this.setStats();
         super.visible = param1;
      }
      
      private function _PlayerProfileTooltip_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Number
         {
            return frame_c.innerLeft - 15;
         },function(param1:Number):void
         {
            summonerName_txt.x = param1;
         },"summonerName_txt.x");
         result[0] = binding;
         binding = new Binding(this,function():Number
         {
            return frame_c.innerTop - 15;
         },function(param1:Number):void
         {
            summonerName_txt.y = param1;
         },"summonerName_txt.y");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.playerParticipant.summonerName;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            summonerName_txt.htmlText = param1;
         },"summonerName_txt.htmlText");
         result[2] = binding;
         binding = new Binding(this,function():Number
         {
            return frame_c.innerWidth;
         },function(param1:Number):void
         {
            summonerName_txt.width = param1;
         },"summonerName_txt.width");
         result[3] = binding;
         binding = new Binding(this,function():Number
         {
            return this.summonerName_txt.y + this.summonerName_txt.height + 2;
         },function(param1:Number):void
         {
            summonerLevel_txt.y = param1;
         },"summonerLevel_txt.y");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","playerProfile_levelLabel") + this.playerParticipant.summonerLevel;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            summonerLevel_txt.htmlText = param1;
         },"summonerLevel_txt.htmlText");
         result[5] = binding;
         binding = new Binding(this,function():Number
         {
            return this.frame_c.width;
         },function(param1:Number):void
         {
            summonerLevel_txt.width = param1;
         },"summonerLevel_txt.width");
         result[6] = binding;
         binding = new Binding(this,function():Number
         {
            return this.summonerLevel_txt.y + this.summonerLevel_txt.height + 2;
         },function(param1:Number):void
         {
            stats_c.y = param1;
         },"stats_c.y");
         result[7] = binding;
         binding = new Binding(this,function():Number
         {
            return this.summonerLevel_txt.width;
         },function(param1:Number):void
         {
            stats_c.width = param1;
         },"stats_c.width");
         result[8] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","playerProfile_winsLabel") + " " + this.playerWins;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            summonerWins_txt.text = param1;
         },"summonerWins_txt.text");
         result[9] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","playerProfile_lossesLabel") + " " + this.playerLosses;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            summonerLosses_txt.text = param1;
         },"summonerLosses_txt.text");
         result[10] = binding;
         return result;
      }
      
      public function set summonerWins_txt(param1:Label) : void
      {
         var _loc2_:Object = this._1729065546summonerWins_txt;
         if(_loc2_ !== param1)
         {
            this._1729065546summonerWins_txt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerWins_txt",_loc2_,param1));
         }
      }
   }
}

