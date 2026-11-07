package com.riotgames.platform.gameclient.controllers.game.views
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.controllers.game.toMove.GradientTextField;
   import com.riotgames.platform.gameclient.controllers.game.toMove.GreenProgressBar;
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
   import mx.controls.Label;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   public class SpectatorWaitBar extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _delayLabelString:String = RiotResourceLoader.getString("spectator_delay_label","Delay remaining:") + " ";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array = [];
      
      private var _1131509414progressBar:GreenProgressBar;
      
      private var delayChanged:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object = {};
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object = {};
      
      public var _SpectatorWaitBar_Label2:Label;
      
      private var _1133912373timeRemainingLabel:Label;
      
      private var _championSelectionModel:ChampionSelectionModel;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array = [];
      
      private var _359802693spectatorLabel:GradientTextField;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {
               "width":790,
               "height":53,
               "childDescriptors":[new UIComponentDescriptor({
                  "type":cs_messageCenter,
                  "id":"bg",
                  "propertiesFactory":function():Object
                  {
                     return {"horizontalCenter":-1};
                  }
               }),new UIComponentDescriptor({
                  "type":GreenProgressBar,
                  "id":"progressBar",
                  "stylesFactory":function():void
                  {
                     this.right = "110";
                     this.bottom = "3";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "width":128,
                        "height":23
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Label,
                  "id":"timeRemainingLabel",
                  "stylesFactory":function():void
                  {
                     this.top = "5";
                     this.right = "110";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"styleName":"whiteText"};
                  }
               }),new UIComponentDescriptor({
                  "type":Label,
                  "id":"_SpectatorWaitBar_Label2",
                  "stylesFactory":function():void
                  {
                     this.left = "110";
                     this.top = "5";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"styleName":"whiteText"};
                  }
               }),new UIComponentDescriptor({
                  "type":GradientTextField,
                  "id":"spectatorLabel",
                  "stylesFactory":function():void
                  {
                     this.left = "110";
                     this.bottom = "3";
                     this.fontSize = 16;
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"text":"..."};
                  }
               })]
            };
         }
      });
      
      private var _3141bg:cs_messageCenter;
      
      public function SpectatorWaitBar()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.width = 790;
         this.height = 53;
         this.clipContent = false;
         this.addEventListener("creationComplete",this.___SpectatorWaitBar_Canvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         SpectatorWaitBar._watcherSetupUtil = param1;
      }
      
      private function _SpectatorWaitBar_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("spectator_delay_period_label","Delay Period");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _SpectatorWaitBar_Label2.text = param1;
         },"_SpectatorWaitBar_Label2.text");
         result[0] = binding;
         binding = new Binding(this,function():Array
         {
            return GradientTextField.GREEN_COLORS;
         },function(param1:Array):void
         {
            spectatorLabel.setStyle("fillColors",param1);
         },"spectatorLabel.fillColors");
         result[1] = binding;
         return result;
      }
      
      public function set spectatorLabel(param1:GradientTextField) : void
      {
         var _loc2_:Object = this._359802693spectatorLabel;
         if(_loc2_ !== param1)
         {
            this._359802693spectatorLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spectatorLabel",_loc2_,param1));
         }
      }
      
      public function set championSelectionModel(param1:ChampionSelectionModel) : void
      {
         if(this._championSelectionModel == param1)
         {
            return;
         }
         this.unsetChampionSelectionModel();
         this._championSelectionModel = param1;
         this.setChampionSelectionModel();
      }
      
      public function ___SpectatorWaitBar_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      public function set bg(param1:cs_messageCenter) : void
      {
         var _loc2_:Object = this._3141bg;
         if(_loc2_ !== param1)
         {
            this._3141bg = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bg",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:SpectatorWaitBar = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._SpectatorWaitBar_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_controllers_game_views_SpectatorWaitBarWatcherSetupUtil");
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
      
      public function set timeRemainingLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1133912373timeRemainingLabel;
         if(_loc2_ !== param1)
         {
            this._1133912373timeRemainingLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"timeRemainingLabel",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get progressBar() : GreenProgressBar
      {
         return this._1131509414progressBar;
      }
      
      private function onCreationComplete() : void
      {
         this.onGameStateChanged(null);
         if(this.spectatorLabel)
         {
            this.spectatorLabel.text = RiotResourceLoader.getString("spectator_delay_period_value","Spectating will begin shortly.");
         }
         this.updateDisplay();
         this.delayChanged = false;
      }
      
      private function updateDisplay() : void
      {
         if(this.championSelectionModel)
         {
            if(this.progressBar)
            {
               this.progressBar.currentPercentage = this.championSelectionModel.spectatorDelayProgress;
            }
            if(this.timeRemainingLabel)
            {
               this.timeRemainingLabel.text = this._delayLabelString + this.formatTime(this.championSelectionModel.spectatorDelaySecondsRemaining);
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get spectatorLabel() : GradientTextField
      {
         return this._359802693spectatorLabel;
      }
      
      public function get championSelectionModel() : ChampionSelectionModel
      {
         return this._championSelectionModel;
      }
      
      private function setChampionSelectionModel() : void
      {
         if(!this.championSelectionModel)
         {
            return;
         }
         this.updateGameState();
         this.championSelectionModel.addEventListener("spectatorDelayProgressChanged",this.onSpectatorProgressChanged,false,0,true);
         this.championSelectionModel.addEventListener("spectatorDelaySecondsRemainingChanged",this.onSpectatorProgressChanged,false,0,true);
         this.championSelectionModel.addEventListener(ChampionSelectionModel.CHAMPION_SELECTION_STATE_CHANGED,this.onGameStateChanged,false,0,true);
      }
      
      [Bindable(event="propertyChange")]
      public function get timeRemainingLabel() : Label
      {
         return this._1133912373timeRemainingLabel;
      }
      
      private function unsetChampionSelectionModel() : void
      {
         if(!this.championSelectionModel)
         {
            return;
         }
         this.visible = false;
         this.championSelectionModel.removeEventListener("spectatorDelayProgressChanged",this.onSpectatorProgressChanged);
         this.championSelectionModel.removeEventListener("spectatorDelaySecondsRemainingChanged",this.onSpectatorProgressChanged);
         this.championSelectionModel.removeEventListener(ChampionSelectionModel.CHAMPION_SELECTION_STATE_CHANGED,this.onGameStateChanged);
      }
      
      public function set progressBar(param1:GreenProgressBar) : void
      {
         var _loc2_:Object = this._1131509414progressBar;
         if(_loc2_ !== param1)
         {
            this._1131509414progressBar = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"progressBar",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bg() : cs_messageCenter
      {
         return this._3141bg;
      }
      
      private function onSpectatorProgressChanged(param1:Event) : void
      {
         this.delayChanged = true;
         invalidateProperties();
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.delayChanged)
         {
            this.updateDisplay();
            this.delayChanged = false;
         }
      }
      
      private function _SpectatorWaitBar_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = RiotResourceLoader.getString("spectator_delay_period_label","Delay Period");
         _loc1_ = GradientTextField.GREEN_COLORS;
      }
      
      private function formatTime(param1:int) : String
      {
         var _loc2_:String = "";
         var _loc3_:int = Math.floor(param1 / 60);
         if(_loc3_ > 0)
         {
            _loc2_ += _loc3_;
         }
         else
         {
            _loc2_ = "0";
         }
         _loc2_ += ":";
         param1 -= _loc3_ * 60;
         if(param1 < 10)
         {
            _loc2_ += "0";
         }
         return _loc2_ + param1;
      }
      
      private function onGameStateChanged(param1:Event) : void
      {
         this.updateGameState();
      }
      
      private function updateGameState() : void
      {
         if(GameState.isInChampionSelectionState(this.championSelectionModel.championSelectionState))
         {
            visible = false;
         }
         else
         {
            visible = true;
         }
      }
   }
}

