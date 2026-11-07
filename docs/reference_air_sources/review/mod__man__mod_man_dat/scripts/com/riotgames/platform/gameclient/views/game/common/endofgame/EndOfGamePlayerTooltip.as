package com.riotgames.platform.gameclient.views.game.common.endofgame
{
   import com.riotgames.platform.gameclient.buddyImages.BuddyImages;
   import com.riotgames.platform.gameclient.components.containers.GradientCanvas;
   import com.riotgames.platform.gameclient.components.summoner.SummonerIcon;
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.pvpnet.game.controllers.EndOfGameStatsController;
   import com.riotgames.pvpnet.game.variants.GameFlowVariant;
   import com.riotgames.pvpnet.game.variants.GameFlowVariantFactory;
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
   import mx.containers.VBox;
   import mx.containers.utilityClasses.ConstraintColumn;
   import mx.controls.Text;
   import mx.core.IToolTip;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class EndOfGamePlayerTooltip extends GradientCanvas implements IBindingClient, IToolTip
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public var _text:String;
      
      mx_internal var _watchers:Array;
      
      private var _303392796playerInfoBox:VBox;
      
      public var _EndOfGamePlayerTooltip_SummonerIcon1:SummonerIcon;
      
      private var _948410958colInfo:ConstraintColumn;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      private var _177356226profileIcon:Canvas;
      
      private var _1656229167levelText:Text;
      
      private var _664066117colImage:ConstraintColumn;
      
      public var endOfGameStatsController:EndOfGameStatsController;
      
      private var _1380553871winsHTMLText:String = "";
      
      mx_internal var _bindings:Array;
      
      private var _1666359150clickToFriendText:Text;
      
      private var _270636692championName:Text;
      
      private var _610355075profileIconSource:BitmapData;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      private var _1102346780winsText:Text;
      
      public function EndOfGamePlayerTooltip()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":GradientCanvas,
            "propertiesFactory":function():Object
            {
               return {
                  "width":280,
                  "childDescriptors":[new UIComponentDescriptor({
                     "type":Canvas,
                     "id":"profileIcon",
                     "stylesFactory":function():void
                     {
                        this.borderColor = 16777215;
                        this.borderThickness = 1;
                        this.verticalCenter = "-1";
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "cacheAsBitmap":true,
                           "styleName":"stoneTablet",
                           "x":3,
                           "childDescriptors":[new UIComponentDescriptor({
                              "type":SummonerIcon,
                              "id":"_EndOfGamePlayerTooltip_SummonerIcon1",
                              "stylesFactory":function():void
                              {
                                 this.top = "0";
                                 this.left = "0";
                                 this.right = "0";
                                 this.bottom = "0";
                              }
                           })]
                        };
                     }
                  }),new UIComponentDescriptor({
                     "type":VBox,
                     "id":"playerInfoBox",
                     "stylesFactory":function():void
                     {
                        this.left = "colInfo:0";
                        this.right = "colInfo:0";
                        this.horizontalAlign = "center";
                        this.verticalGap = -4;
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "percentHeight":100,
                           "verticalScrollPolicy":"off",
                           "horizontalScrollPolicy":"off",
                           "childDescriptors":[new UIComponentDescriptor({
                              "type":Text,
                              "id":"championName",
                              "propertiesFactory":function():Object
                              {
                                 return {"styleName":"endGameTooltip1"};
                              }
                           }),new UIComponentDescriptor({
                              "type":Text,
                              "id":"levelText",
                              "propertiesFactory":function():Object
                              {
                                 return {"styleName":"endGameTooltip2"};
                              }
                           }),new UIComponentDescriptor({
                              "type":Text,
                              "id":"winsText",
                              "propertiesFactory":function():Object
                              {
                                 return {"styleName":"endGameTooltip3"};
                              }
                           }),new UIComponentDescriptor({
                              "type":Text,
                              "id":"clickToFriendText",
                              "stylesFactory":function():void
                              {
                                 this.textAlign = "center";
                              },
                              "propertiesFactory":function():Object
                              {
                                 return {
                                    "width":200,
                                    "styleName":"endGameTooltip4"
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
         this.width = 280;
         this.constraintColumns = [this._EndOfGamePlayerTooltip_ConstraintColumn1_i(),this._EndOfGamePlayerTooltip_ConstraintColumn2_i()];
         this.addEventListener("addedToStage",this.___EndOfGamePlayerTooltip_GradientCanvas1_addedToStage);
         this.addEventListener("show",this.___EndOfGamePlayerTooltip_GradientCanvas1_show);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         EndOfGamePlayerTooltip._watcherSetupUtil = param1;
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
      
      public function set colImage(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._664066117colImage;
         if(_loc2_ !== param1)
         {
            this._664066117colImage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"colImage",_loc2_,param1));
         }
      }
      
      public function set profileIcon(param1:Canvas) : void
      {
         var _loc2_:Object = this._177356226profileIcon;
         if(_loc2_ !== param1)
         {
            this._177356226profileIcon = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"profileIcon",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get winsHTMLText() : String
      {
         return this._1380553871winsHTMLText;
      }
      
      public function ___EndOfGamePlayerTooltip_GradientCanvas1_show(param1:FlexEvent) : void
      {
         this.onVisibleChanged();
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:EndOfGamePlayerTooltip = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._EndOfGamePlayerTooltip_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGamePlayerTooltipWatcherSetupUtil");
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
      public function get championName() : Text
      {
         return this._270636692championName;
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
      
      private function onVisibleChanged() : void
      {
         var _loc1_:PlayerParticipantStatsSummary = this.data as PlayerParticipantStatsSummary;
         if(Boolean(_loc1_.isBotPlayer()) || this.endOfGameStatsController.localPlayer == null)
         {
            this.visible = false;
         }
         else
         {
            this.visible = true;
         }
         if(_loc1_.isMe)
         {
            this.clickToFriendText.visible = false;
         }
         else
         {
            this.clickToFriendText.visible = true;
         }
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
      
      public function set colInfo(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._948410958colInfo;
         if(_loc2_ !== param1)
         {
            this._948410958colInfo = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"colInfo",_loc2_,param1));
         }
      }
      
      private function _EndOfGamePlayerTooltip_ConstraintColumn2_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.colInfo = _loc1_;
         _loc1_.width = 211;
         _loc1_.initialized(this,"colInfo");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      private function get profileIconSource() : BitmapData
      {
         return this._610355075profileIconSource;
      }
      
      [Bindable(event="propertyChange")]
      public function get playerInfoBox() : VBox
      {
         return this._303392796playerInfoBox;
      }
      
      public function get text() : String
      {
         return this._text;
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
      
      private function updateWinsLosses() : void
      {
         var _loc1_:String = resourceManager.getString("resources","BuddyListTooltip_summonerWins");
         if(_loc1_ == null)
         {
            _loc1_ = "**Won: ";
         }
         var _loc2_:Number = Number(this.data.wins);
         this.winsHTMLText = _loc1_;
         this.winsHTMLText += "<font color=\'#00FF00\'>";
         this.winsHTMLText += _loc2_.toString();
         this.winsHTMLText += "</font>";
      }
      
      private function onInjection() : void
      {
      }
      
      public function ___EndOfGamePlayerTooltip_GradientCanvas1_addedToStage(param1:Event) : void
      {
         this.onInjection();
      }
      
      private function _EndOfGamePlayerTooltip_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Number
         {
            return colImage.width - 7;
         },function(param1:Number):void
         {
            profileIcon.height = param1;
         },"profileIcon.height");
         result[0] = binding;
         binding = new Binding(this,function():Number
         {
            return profileIcon.height;
         },function(param1:Number):void
         {
            profileIcon.width = param1;
         },"profileIcon.width");
         result[1] = binding;
         binding = new Binding(this,function():Object
         {
            return this.profileIconSource;
         },function(param1:Object):void
         {
            _EndOfGamePlayerTooltip_SummonerIcon1.iconPath = param1;
         },"_EndOfGamePlayerTooltip_SummonerIcon1.iconPath");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.data.summonerName;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            championName.text = param1;
         },"championName.text");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","BuddyListTooltip_summonerLevel",[this.data.level]);
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            levelText.text = param1;
         },"levelText.text");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.winsHTMLText;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            winsText.htmlText = param1;
         },"winsText.htmlText");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","endofgame_player_tooltip_clicktofriend");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            clickToFriendText.text = param1;
         },"clickToFriendText.text");
         result[6] = binding;
         return result;
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
      
      private function _EndOfGamePlayerTooltip_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.colImage.width - 7;
         _loc1_ = this.profileIcon.height;
         _loc1_ = this.profileIconSource;
         _loc1_ = this.data.summonerName;
         _loc1_ = resourceManager.getString("resources","BuddyListTooltip_summonerLevel",[this.data.level]);
         _loc1_ = this.winsHTMLText;
         _loc1_ = resourceManager.getString("resources","endofgame_player_tooltip_clicktofriend");
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
      
      [Bindable(event="propertyChange")]
      public function get profileIcon() : Canvas
      {
         return this._177356226profileIcon;
      }
      
      [Bindable(event="propertyChange")]
      public function get levelText() : Text
      {
         return this._1656229167levelText;
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         var _loc2_:GameFlowVariant = GameFlowVariantFactory.instance.getVariant(this.endOfGameStatsController.endOfGameStats.gameMutators,this.endOfGameStatsController.endOfGameStats.gameMode);
         var _loc3_:PlayerParticipantStatsSummary = this.data as PlayerParticipantStatsSummary;
         this.profileIconSource = BuddyImages.getSummonerIconSafely(_loc2_.getEndOfGameProfileIcon(_loc3_));
         this.updateWinsLosses();
      }
      
      public function set text(param1:String) : void
      {
      }
      
      public function set clickToFriendText(param1:Text) : void
      {
         var _loc2_:Object = this._1666359150clickToFriendText;
         if(_loc2_ !== param1)
         {
            this._1666359150clickToFriendText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clickToFriendText",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get colImage() : ConstraintColumn
      {
         return this._664066117colImage;
      }
      
      [Bindable(event="propertyChange")]
      public function get winsText() : Text
      {
         return this._1102346780winsText;
      }
      
      private function _EndOfGamePlayerTooltip_ConstraintColumn1_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.colImage = _loc1_;
         _loc1_.width = 69;
         _loc1_.initialized(this,"colImage");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get clickToFriendText() : Text
      {
         return this._1666359150clickToFriendText;
      }
      
      [Bindable(event="propertyChange")]
      public function get colInfo() : ConstraintColumn
      {
         return this._948410958colInfo;
      }
   }
}

