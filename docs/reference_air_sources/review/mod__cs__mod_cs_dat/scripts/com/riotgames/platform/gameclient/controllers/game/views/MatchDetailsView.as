package com.riotgames.platform.gameclient.controllers.game.views
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.components.containers.GradientCanvas;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.platform.gameclient.domain.game.GameMode;
   import com.riotgames.platform.gameclient.domain.game.GameType;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfig;
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
   import mx.containers.utilityClasses.ConstraintRow;
   import mx.controls.Label;
   import mx.controls.Text;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   public class MatchDetailsView extends GradientCanvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _868055995topRow:ConstraintRow;
      
      private var _655255227centerRow:ConstraintRow;
      
      private var currentGame:GameDTO;
      
      private var gameMap:GameMap;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array;
      
      private var _1115259087header_c:GradientCanvas;
      
      private var gameTypeConfig:GameTypeConfig;
      
      protected var gamePropertiesChanged:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object;
      
      private var _12089446header_c_label:Label;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object;
      
      private var _2032551281detailsText:Text;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public function MatchDetailsView()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":GradientCanvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":Canvas,
                  "stylesFactory":function():void
                  {
                     this.bottom = "0";
                     this.left = "0";
                     this.right = "0";
                     this.top = "0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "horizontalScrollPolicy":"off",
                        "verticalScrollPolicy":"off",
                        "constraintRows":[_MatchDetailsView_ConstraintRow1_i(),_MatchDetailsView_ConstraintRow2_i()],
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":GradientCanvas,
                           "id":"header_c",
                           "stylesFactory":function():void
                           {
                              this.borderStyle = "none";
                              this.bottom = "topRow:0";
                              this.left = "0";
                              this.right = "0";
                              this.top = "topRow:0";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "horizontalScrollPolicy":"off",
                                 "styleName":"blueHeaderBackground",
                                 "verticalScrollPolicy":"off",
                                 "childDescriptors":[new UIComponentDescriptor({
                                    "type":Label,
                                    "id":"header_c_label",
                                    "stylesFactory":function():void
                                    {
                                       this.left = "5";
                                       this.verticalCenter = "0";
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {"styleName":"spectatorPanelHeaderText"};
                                    }
                                 })]
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Text,
                           "id":"detailsText",
                           "stylesFactory":function():void
                           {
                              this.bottom = "centerRow:0";
                              this.left = "5";
                              this.textAlign = "left";
                              this.top = "centerRow:1";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "selectable":false,
                                 "styleName":"matchDetailsText"
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
            this.backgroundAlpha = 0;
            this.borderSides = "left top";
            this.cornerRadius = 2;
         };
         this.horizontalScrollPolicy = "off";
         this.styleName = "blueParchmentTablet";
         this.verticalScrollPolicy = "off";
         this.cacheAsBitmap = true;
         this.addEventListener("creationComplete",this.___MatchDetailsView_GradientCanvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         MatchDetailsView._watcherSetupUtil = param1;
      }
      
      public function set topRow(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._868055995topRow;
         if(_loc2_ !== param1)
         {
            this._868055995topRow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"topRow",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get detailsText() : Text
      {
         return this._2032551281detailsText;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:MatchDetailsView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._MatchDetailsView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_controllers_game_views_MatchDetailsViewWatcherSetupUtil");
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
      
      private function _MatchDetailsView_ConstraintRow1_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.topRow = _loc1_;
         _loc1_.height = 25;
         _loc1_.initialized(this,"topRow");
         return _loc1_;
      }
      
      public function set detailsText(param1:Text) : void
      {
         var _loc2_:Object = this._2032551281detailsText;
         if(_loc2_ !== param1)
         {
            this._2032551281detailsText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"detailsText",_loc2_,param1));
         }
      }
      
      public function set centerRow(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._655255227centerRow;
         if(_loc2_ !== param1)
         {
            this._655255227centerRow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"centerRow",_loc2_,param1));
         }
      }
      
      private function _MatchDetailsView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = RiotResourceLoader.getString("matchDetails_title");
      }
      
      [Bindable(event="propertyChange")]
      public function get header_c() : GradientCanvas
      {
         return this._1115259087header_c;
      }
      
      private function onCreationComplete() : void
      {
         if(Boolean(this.gameMap) && Boolean(this.gameTypeConfig) && Boolean(this.currentGame))
         {
            this.applyGameProperties();
            this.gamePropertiesChanged = false;
         }
      }
      
      public function ___MatchDetailsView_GradientCanvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      [Bindable(event="propertyChange")]
      public function get centerRow() : ConstraintRow
      {
         return this._655255227centerRow;
      }
      
      public function setGameProperties(param1:GameDTO, param2:GameMap, param3:GameTypeConfig) : void
      {
         this.currentGame = param1;
         this.gameMap = param2;
         this.gameTypeConfig = param3;
         this.gamePropertiesChanged = true;
         invalidateProperties();
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.gamePropertiesChanged)
         {
            this.applyGameProperties();
            this.gamePropertiesChanged = false;
         }
      }
      
      protected function applyGameProperties() : void
      {
         var _loc1_:String = null;
         if(this.gameTypeConfig)
         {
            _loc1_ = RiotResourceLoader.getString("practiceGame_gameMode_" + this.gameTypeConfig.name);
         }
         var _loc2_:String = "<font color=\'#FFFFFF\'>";
         this.detailsText.htmlText = _loc2_;
         if(this.gameMap != null)
         {
            this.detailsText.htmlText += RiotResourceLoader.getString("practiceGame_mapName_label") + "</font><font color=\'#FFFFFF\'>  " + this.gameMap.displayName + "</font>\n";
         }
         if(this.currentGame)
         {
            this.detailsText.htmlText += _loc2_ + RiotResourceLoader.getString("practiceGame_teamSize_label") + "</font><font color=\'#FFFFFF\'>  " + (this.currentGame.maxNumPlayers / 2 + "x" + this.currentGame.maxNumPlayers / 2).toString() + "</font>\n";
         }
         if(this.currentGame != null && Boolean(this.currentGame.gameMode))
         {
            this.detailsText.htmlText += _loc2_ + this.getGameModeName();
         }
         if(this.currentGame != null && this.currentGame.gameMode != GameMode.TUTORIAL)
         {
            this.detailsText.htmlText += _loc2_ + RiotResourceLoader.getString("practiceGame_pickType_label") + "</font><font color=\'#FFFFFF\'>  " + _loc1_ + "</font>\n";
         }
         if(this.currentGame)
         {
            this.detailsText.htmlText += _loc2_ + RiotResourceLoader.getString("practiceGame_showStats_gameType_label") + "</font><font color=\'#FFFFFF\'>  " + RiotResourceLoader.getString("practiceGame_gameMode_" + this.currentGame.gameType) + "</font>\n";
         }
         if(Boolean(this.currentGame) && this.currentGame.gameType == GameType.PRACTICE_GAME)
         {
            this.detailsText.htmlText += _loc2_ + RiotResourceLoader.getString("practiceGame_gameName_label") + "</font><font color=\'#FFFFFF\'>  " + this.currentGame.name + "</font>\n";
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get topRow() : ConstraintRow
      {
         return this._868055995topRow;
      }
      
      private function getGameModeName() : String
      {
         var _loc2_:GameFlowVariant = null;
         var _loc1_:String = null;
         if(this.currentGame.gameMode.toLowerCase() == GameMode.TUTORIAL.toLowerCase())
         {
            if(this.currentGame.gameType == GameType.TUTORIAL_GAME)
            {
               _loc1_ = RiotResourceLoader.getString("practiceGame_gameMode_label") + "</font><font color=\'#FFFFFF\'>  " + RiotResourceLoader.getString("advanced_" + this.currentGame.gameMode.toLowerCase() + "_game_mode_title") + "</font>\n";
            }
            else
            {
               _loc1_ = RiotResourceLoader.getString("practiceGame_gameMode_label") + "</font><font color=\'#FFFFFF\'>  " + RiotResourceLoader.getString("basic_" + this.currentGame.gameMode.toLowerCase() + "_game_mode_title") + "</font>\n";
            }
         }
         else
         {
            _loc2_ = GameFlowVariantFactory.instance.getVariant(this.currentGame.gameMutators,this.currentGame.gameMode);
            _loc1_ = RiotResourceLoader.getString("practiceGame_gameMode_label") + "</font><font color=\'#FFFFFF\'>  " + _loc2_.getGameFlowName() + "</font>\n";
         }
         return _loc1_;
      }
      
      private function _MatchDetailsView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("matchDetails_title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            header_c_label.text = param1;
         },"header_c_label.text");
         result[0] = binding;
         return result;
      }
      
      public function set header_c_label(param1:Label) : void
      {
         var _loc2_:Object = this._12089446header_c_label;
         if(_loc2_ !== param1)
         {
            this._12089446header_c_label = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"header_c_label",_loc2_,param1));
         }
      }
      
      private function _MatchDetailsView_ConstraintRow2_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.centerRow = _loc1_;
         _loc1_.percentHeight = 100;
         _loc1_.initialized(this,"centerRow");
         return _loc1_;
      }
      
      public function set header_c(param1:GradientCanvas) : void
      {
         var _loc2_:Object = this._1115259087header_c;
         if(_loc2_ !== param1)
         {
            this._1115259087header_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"header_c",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get header_c_label() : Label
      {
         return this._12089446header_c_label;
      }
   }
}

