package com.riotgames.platform.gameclient.controllers.game.views
{
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.domain.game.GameState;
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
   import mx.controls.Label;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   public class ChampionSelectProgressBar extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _739426066pickText:Label;
      
      protected var championSelectionModelChanged:Boolean = false;
      
      private var _1354886545colBan:ConstraintColumn;
      
      private var _337734180banText:Label;
      
      private var _2043573683activeGlow:GlowFilter;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array = [];
      
      private var _1131509414progressBar:cs_progressBar;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object = {};
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object = {};
      
      private var _668534783colDraft:ConstraintColumn;
      
      private var _championSelectionModel:ChampionSelectionModel;
      
      private var _2086543831selectedBackground:Canvas;
      
      private var _1538344519freeText:Label;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array = [];
      
      private var _948325388colFree:ConstraintColumn;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {
               "width":400,
               "height":30,
               "childDescriptors":[new UIComponentDescriptor({
                  "type":cs_progressBar,
                  "id":"progressBar",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "x":0,
                        "y":0
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Canvas,
                  "id":"selectedBackground",
                  "stylesFactory":function():void
                  {
                     this.borderStyle = "solid";
                     this.borderThickness = 1;
                     this.borderColor = 26367;
                     this.cornerRadius = 5;
                     this.backgroundAlpha = 0.4;
                     this.backgroundColor = 26367;
                     this.verticalCenter = "-1";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "cacheAsBitmap":true,
                        "width":127,
                        "height":22,
                        "x":3
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Label,
                  "id":"banText",
                  "stylesFactory":function():void
                  {
                     this.verticalCenter = "0";
                     this.horizontalCenter = "colBan:0";
                     this.textAlign = "center";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"styleName":"championSelectProgressBarText"};
                  }
               }),new UIComponentDescriptor({
                  "type":Label,
                  "id":"pickText",
                  "stylesFactory":function():void
                  {
                     this.verticalCenter = "0";
                     this.horizontalCenter = "colDraft:0";
                     this.textAlign = "center";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"styleName":"championSelectProgressBarText"};
                  }
               }),new UIComponentDescriptor({
                  "type":Label,
                  "id":"freeText",
                  "stylesFactory":function():void
                  {
                     this.verticalCenter = "0";
                     this.horizontalCenter = "colFree:0";
                     this.textAlign = "center";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"styleName":"championSelectProgressBarText"};
                  }
               })]
            };
         }
      });
      
      public function ChampionSelectProgressBar()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.width = 400;
         this.height = 30;
         this.constraintColumns = [this._ChampionSelectProgressBar_ConstraintColumn1_i(),this._ChampionSelectProgressBar_ConstraintColumn2_i(),this._ChampionSelectProgressBar_ConstraintColumn3_i()];
         this._ChampionSelectProgressBar_GlowFilter1_i();
         this.addEventListener("creationComplete",this.___ChampionSelectProgressBar_Canvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         ChampionSelectProgressBar._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get colDraft() : ConstraintColumn
      {
         return this._668534783colDraft;
      }
      
      public function set colDraft(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._668534783colDraft;
         if(_loc2_ !== param1)
         {
            this._668534783colDraft = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"colDraft",_loc2_,param1));
         }
      }
      
      private function _ChampionSelectProgressBar_ConstraintColumn1_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.colBan = _loc1_;
         _loc1_.percentWidth = 33;
         _loc1_.initialized(this,"colBan");
         return _loc1_;
      }
      
      public function set championSelectionModel(param1:ChampionSelectionModel) : void
      {
         if(this._championSelectionModel == param1)
         {
            return;
         }
         if(this.championSelectionModel)
         {
            this.championSelectionModel.removeEventListener(ChampionSelectionModel.CHAMPION_SELECTION_STATE_CHANGED,this.onSelectionStateChanged);
         }
         this._championSelectionModel = param1;
         this.championSelectionModelChanged = true;
         if(this.championSelectionModel)
         {
            this.championSelectionModel.addEventListener(ChampionSelectionModel.CHAMPION_SELECTION_STATE_CHANGED,this.onSelectionStateChanged,false,0,true);
         }
         invalidateProperties();
      }
      
      private function _ChampionSelectProgressBar_ConstraintColumn3_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.colFree = _loc1_;
         _loc1_.percentWidth = 33;
         _loc1_.initialized(this,"colFree");
         return _loc1_;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:ChampionSelectProgressBar = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._ChampionSelectProgressBar_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_controllers_game_views_ChampionSelectProgressBarWatcherSetupUtil");
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
      
      private function _ChampionSelectProgressBar_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","championSelection_championSelectProgressBar_ban");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            banText.text = param1;
         },"banText.text");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","championSelection_championSelectProgressBar_pick");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            pickText.text = param1;
         },"pickText.text");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","championSelection_championSelectProgressBar_free");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            freeText.text = param1;
         },"freeText.text");
         result[2] = binding;
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get colFree() : ConstraintColumn
      {
         return this._948325388colFree;
      }
      
      public function set colFree(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._948325388colFree;
         if(_loc2_ !== param1)
         {
            this._948325388colFree = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"colFree",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedBackground() : Canvas
      {
         return this._2086543831selectedBackground;
      }
      
      [Bindable(event="propertyChange")]
      public function get progressBar() : cs_progressBar
      {
         return this._1131509414progressBar;
      }
      
      private function _ChampionSelectProgressBar_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = resourceManager.getString("resources","championSelection_championSelectProgressBar_ban");
         _loc1_ = resourceManager.getString("resources","championSelection_championSelectProgressBar_pick");
         _loc1_ = resourceManager.getString("resources","championSelection_championSelectProgressBar_free");
      }
      
      private function onCreationComplete() : void
      {
         if(this.championSelectionModel)
         {
            this.setLabelTexts();
            this.championSelectionModelChanged = false;
         }
      }
      
      public function set banText(param1:Label) : void
      {
         var _loc2_:Object = this._337734180banText;
         if(_loc2_ !== param1)
         {
            this._337734180banText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"banText",_loc2_,param1));
         }
      }
      
      private function _ChampionSelectProgressBar_GlowFilter1_i() : GlowFilter
      {
         var _loc1_:GlowFilter = new GlowFilter();
         this.activeGlow = _loc1_;
         _loc1_.alpha = 0.8;
         _loc1_.blurX = 30;
         _loc1_.blurY = 30;
         _loc1_.color = 26367;
         return _loc1_;
      }
      
      public function ___ChampionSelectProgressBar_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      private function setLabelInactive(param1:Label) : void
      {
         if(!param1)
         {
            return;
         }
         param1.filters = [];
         param1.setStyle("color","#555555");
      }
      
      [Bindable(event="propertyChange")]
      public function get freeText() : Label
      {
         return this._1538344519freeText;
      }
      
      [Bindable(event="propertyChange")]
      public function get activeGlow() : GlowFilter
      {
         return this._2043573683activeGlow;
      }
      
      public function get championSelectionModel() : ChampionSelectionModel
      {
         return this._championSelectionModel;
      }
      
      public function set selectedBackground(param1:Canvas) : void
      {
         var _loc2_:Object = this._2086543831selectedBackground;
         if(_loc2_ !== param1)
         {
            this._2086543831selectedBackground = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedBackground",_loc2_,param1));
         }
      }
      
      private function _ChampionSelectProgressBar_ConstraintColumn2_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.colDraft = _loc1_;
         _loc1_.percentWidth = 33;
         _loc1_.initialized(this,"colDraft");
         return _loc1_;
      }
      
      private function setLabelTexts() : void
      {
         if(this.selectedBackground)
         {
            this.selectedBackground.visible = true;
         }
         var _loc1_:Number = 3;
         switch(this.championSelectionModel.championSelectionState)
         {
            case GameState.PRE_CHAMPION_SELECTION:
               this.setLabelActive(this.banText);
               this.setLabelUpcoming(this.pickText);
               this.setLabelUpcoming(this.freeText);
               this.selectedBackground.x = _loc1_;
               break;
            case GameState.CHAMPION_SELECTION:
               this.setLabelInactive(this.banText);
               this.setLabelActive(this.pickText);
               this.setLabelUpcoming(this.freeText);
               this.selectedBackground.x = this.width * 0.3333 + _loc1_;
               break;
            case GameState.POST_CHAMPION_SELECTION:
               this.setLabelInactive(this.banText);
               this.setLabelInactive(this.pickText);
               this.setLabelActive(this.freeText);
               this.selectedBackground.x = this.width * 0.6666 + _loc1_;
         }
      }
      
      private function setLabelActive(param1:Label) : void
      {
         if(!param1)
         {
            return;
         }
         param1.filters = [this.activeGlow];
         param1.setStyle("color","#ffffff");
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.championSelectionModelChanged && Boolean(this.championSelectionModel))
         {
            this.setLabelTexts();
            this.championSelectionModelChanged = false;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get banText() : Label
      {
         return this._337734180banText;
      }
      
      public function set colBan(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._1354886545colBan;
         if(_loc2_ !== param1)
         {
            this._1354886545colBan = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"colBan",_loc2_,param1));
         }
      }
      
      public function set pickText(param1:Label) : void
      {
         var _loc2_:Object = this._739426066pickText;
         if(_loc2_ !== param1)
         {
            this._739426066pickText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pickText",_loc2_,param1));
         }
      }
      
      public function set progressBar(param1:cs_progressBar) : void
      {
         var _loc2_:Object = this._1131509414progressBar;
         if(_loc2_ !== param1)
         {
            this._1131509414progressBar = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"progressBar",_loc2_,param1));
         }
      }
      
      private function setLabelUpcoming(param1:Label) : void
      {
         if(!param1)
         {
            return;
         }
         param1.filters = [];
         param1.setStyle("color","#e1e1e1");
      }
      
      [Bindable(event="propertyChange")]
      public function get colBan() : ConstraintColumn
      {
         return this._1354886545colBan;
      }
      
      private function onSelectionStateChanged(param1:Event) : void
      {
         this.championSelectionModelChanged = true;
         invalidateProperties();
      }
      
      public function set freeText(param1:Label) : void
      {
         var _loc2_:Object = this._1538344519freeText;
         if(_loc2_ !== param1)
         {
            this._1538344519freeText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"freeText",_loc2_,param1));
         }
      }
      
      public function set activeGlow(param1:GlowFilter) : void
      {
         var _loc2_:Object = this._2043573683activeGlow;
         if(_loc2_ !== param1)
         {
            this._2043573683activeGlow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"activeGlow",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get pickText() : Label
      {
         return this._739426066pickText;
      }
   }
}

