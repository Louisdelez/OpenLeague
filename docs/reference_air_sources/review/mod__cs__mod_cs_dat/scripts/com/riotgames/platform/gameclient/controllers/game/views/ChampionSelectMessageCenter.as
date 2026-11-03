package com.riotgames.platform.gameclient.controllers.game.views
{
   import com.riotgames.platform.gameclient.controllers.game.GlowComponentController;
   import com.riotgames.platform.gameclient.controllers.game.GlowLocation;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import com.riotgames.platform.gameclient.domain.game.GameState;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
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
   import mx.controls.Text;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.effects.Zoom;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   public class ChampionSelectMessageCenter extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private static const TIMER_STATE_ACTIVE:String = "active";
      
      private static const TIMER_STATE_ACTIVE_OTHER:String = "activeOther";
      
      private static const TIMER_STATE_INACTIVE:String = "inactive";
      
      private var _1690732311messageTxt:Text;
      
      private var stateDescriptionChanged:Boolean = false;
      
      private var _1058971836zoomEffect:Zoom;
      
      private var _328044242yourTimer:cs_timerLeft;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array = [];
      
      private var teamVisibleChanged:Boolean = false;
      
      private var _2029103300messageCenter:cs_messageCenter;
      
      public var glowComponentController:GlowComponentController;
      
      private var timeRemainingChanged:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object = {};
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object = {};
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array = [];
      
      private var _1804254365enemyTimer:cs_timerRight;
      
      private var _championSelectionModel:ChampionSelectionModel;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {
               "width":790,
               "height":53,
               "childDescriptors":[new UIComponentDescriptor({
                  "type":cs_timerLeft,
                  "id":"yourTimer",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "top":1,
                        "left":3
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":cs_timerRight,
                  "id":"enemyTimer",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "top":1,
                        "x":688
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":cs_messageCenter,
                  "id":"messageCenter",
                  "propertiesFactory":function():Object
                  {
                     return {"horizontalCenter":-1};
                  }
               }),new UIComponentDescriptor({
                  "type":Text,
                  "id":"messageTxt",
                  "stylesFactory":function():void
                  {
                     this.horizontalCenter = "0";
                     this.verticalCenter = "0";
                     this.textAlign = "center";
                     this.fontAntiAliasType = "advanced";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "width":588,
                        "styleName":"messageCenterText",
                        "selectable":false
                     };
                  }
               })]
            };
         }
      });
      
      public function ChampionSelectMessageCenter()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.width = 790;
         this.height = 53;
         this.clipContent = false;
         this._ChampionSelectMessageCenter_Zoom1_i();
         this.addEventListener("creationComplete",this.___ChampionSelectMessageCenter_Canvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         ChampionSelectMessageCenter._watcherSetupUtil = param1;
      }
      
      public function set zoomEffect(param1:Zoom) : void
      {
         var _loc2_:Object = this._1058971836zoomEffect;
         if(_loc2_ !== param1)
         {
            this._1058971836zoomEffect = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"zoomEffect",_loc2_,param1));
         }
      }
      
      public function set championSelectionModel(param1:ChampionSelectionModel) : void
      {
         if(this._championSelectionModel == param1)
         {
            return;
         }
         this.removeChampionSelectionModel();
         this._championSelectionModel = param1;
         this.setChampionSelectionModel();
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:ChampionSelectMessageCenter = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._ChampionSelectMessageCenter_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_controllers_game_views_ChampionSelectMessageCenterWatcherSetupUtil");
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
      public function get enemyTimer() : cs_timerRight
      {
         return this._1804254365enemyTimer;
      }
      
      private function _ChampionSelectMessageCenter_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Object
         {
            return messageTxt;
         },function(param1:Object):void
         {
            zoomEffect.target = param1;
         },"zoomEffect.target");
         result[0] = binding;
         return result;
      }
      
      private function onStateDescriptionChanged(param1:Event) : void
      {
         this.stateDescriptionChanged = true;
         this.invalidateProperties();
      }
      
      public function set yourTimer(param1:cs_timerLeft) : void
      {
         var _loc2_:Object = this._328044242yourTimer;
         if(_loc2_ !== param1)
         {
            this._328044242yourTimer = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"yourTimer",_loc2_,param1));
         }
      }
      
      private function onCreationComplete() : void
      {
         this.updateTimers();
         if(Boolean(this.yourTimer) && Boolean(this.glowComponentController))
         {
            this.glowComponentController.registerGlowTarget(GlowLocation.CHAMPION_SELECT_TIMER,this.yourTimer);
         }
         this.updateStateDescriptionText();
         this.stateDescriptionChanged = false;
      }
      
      public function set enemyTimer(param1:cs_timerRight) : void
      {
         var _loc2_:Object = this._1804254365enemyTimer;
         if(_loc2_ !== param1)
         {
            this._1804254365enemyTimer = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enemyTimer",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get messageCenter() : cs_messageCenter
      {
         return this._2029103300messageCenter;
      }
      
      [Bindable(event="propertyChange")]
      public function get zoomEffect() : Zoom
      {
         return this._1058971836zoomEffect;
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
         this.championSelectionModel.addEventListener(ChampionSelectionModel.CURRENT_TEAM_ACTIVE_CHANGED,this.onFriendlyTeamActiveChanged,false,0,true);
         this.championSelectionModel.addEventListener(ChampionSelectionModel.TIME_REMAINING_SECONDS_CHANGED,this.onTimeChanged,false,0,true);
         this.championSelectionModel.addEventListener(ChampionSelectionModel.CURRENT_PICK_MODE_CHANGED,this.onPickModeChanged,false,0,true);
         this.championSelectionModel.addEventListener(ChampionSelectionModel.PICK_TURN_CHANGED,this.onPickModeChanged,false,0,true);
         this.championSelectionModel.addEventListener(ChampionSelectionModel.STATE_DESCRIPTION_TEXT_CHANGED,this.onStateDescriptionChanged,false,0,true);
         this.championSelectionModel.addEventListener(ChampionSelectionModel.CHAMPION_SELECTION_STATE_CHANGED,this.onGameStateChanged,false,0,true);
         this.updateTimers();
         this.updateStateDescriptionText();
      }
      
      private function onTimeChanged(param1:Event) : void
      {
         this.timeRemainingChanged = true;
         this.invalidateProperties();
      }
      
      private function onPickModeChanged(param1:Event) : void
      {
         if(this.championSelectionModel.currentPickMode == GameParticipant.PICK_MODE_ACTIVE)
         {
            this.invalidateProperties();
         }
      }
      
      public function set messageTxt(param1:Text) : void
      {
         var _loc2_:Object = this._1690732311messageTxt;
         if(_loc2_ !== param1)
         {
            this._1690732311messageTxt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"messageTxt",_loc2_,param1));
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.timeRemainingChanged || this.teamVisibleChanged)
         {
            this.updateTimers();
            this.teamVisibleChanged = false;
            this.timeRemainingChanged = false;
         }
         if(this.stateDescriptionChanged)
         {
            this.updateStateDescriptionText();
            this.stateDescriptionChanged = false;
         }
      }
      
      private function _ChampionSelectMessageCenter_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.messageTxt;
      }
      
      private function _ChampionSelectMessageCenter_Zoom1_i() : Zoom
      {
         var _loc1_:Zoom = new Zoom();
         this.zoomEffect = _loc1_;
         _loc1_.zoomWidthFrom = 2;
         _loc1_.zoomWidthTo = 1;
         _loc1_.zoomHeightFrom = 2;
         _loc1_.zoomHeightTo = 1;
         _loc1_.duration = 750;
         BindingManager.executeBindings(this,"zoomEffect",this.zoomEffect);
         return _loc1_;
      }
      
      public function ___ChampionSelectMessageCenter_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      private function onFriendlyTeamActiveChanged(param1:Event) : void
      {
         this.teamVisibleChanged = true;
         this.invalidateProperties();
      }
      
      private function updateStateDescriptionText() : void
      {
         if(!this.messageTxt)
         {
            return;
         }
         if(!this.championSelectionModel)
         {
            this.messageTxt.htmlText = "";
            return;
         }
         if(this.messageTxt.htmlText == this.championSelectionModel.stateDescriptionText)
         {
            return;
         }
         this.messageTxt.htmlText = this.championSelectionModel.stateDescriptionText;
         if(UserPreferencesManager.userPrefs.enableAnimations)
         {
            this.startNewTurnEffect();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get messageTxt() : Text
      {
         return this._1690732311messageTxt;
      }
      
      private function removeChampionSelectionModel() : void
      {
         if(!this.championSelectionModel)
         {
            return;
         }
         this.championSelectionModel.removeEventListener(ChampionSelectionModel.CURRENT_TEAM_ACTIVE_CHANGED,this.onFriendlyTeamActiveChanged);
         this.championSelectionModel.removeEventListener(ChampionSelectionModel.TIME_REMAINING_SECONDS_CHANGED,this.onTimeChanged);
         this.championSelectionModel.removeEventListener(ChampionSelectionModel.CURRENT_PICK_MODE_CHANGED,this.onPickModeChanged);
         this.championSelectionModel.removeEventListener(ChampionSelectionModel.PICK_TURN_CHANGED,this.onPickModeChanged);
         this.championSelectionModel.removeEventListener(ChampionSelectionModel.STATE_DESCRIPTION_TEXT_CHANGED,this.onStateDescriptionChanged);
         this.championSelectionModel.removeEventListener(ChampionSelectionModel.CHAMPION_SELECTION_STATE_CHANGED,this.onGameStateChanged);
      }
      
      private function startNewTurnEffect() : void
      {
         if(!this.messageTxt)
         {
            return;
         }
         if(this.zoomEffect.isPlaying)
         {
            return;
         }
         this.zoomEffect.play();
         this.messageCenter.flash();
      }
      
      private function updateTimers() : void
      {
         if(!this.championSelectionModel)
         {
            return;
         }
         var _loc1_:Boolean = false;
         if(this.yourTimer)
         {
            _loc1_ = Boolean(this.championSelectionModel.currentTeamActive) || this.championSelectionModel.championSelectionState == GameState.POST_CHAMPION_SELECTION;
            if(this.championSelectionModel.currentPickMode == GameParticipant.PICK_MODE_ACTIVE && !this.championSelectionModel.isSpectating)
            {
               this.yourTimer.currentState = TIMER_STATE_ACTIVE;
            }
            else if(!GameState.isInChampionSelectionState(this.championSelectionModel.championSelectionState))
            {
               _loc1_ = false;
               this.yourTimer.currentState = TIMER_STATE_INACTIVE;
            }
            else
            {
               this.yourTimer.currentState = this.championSelectionModel.currentTeamActive ? TIMER_STATE_ACTIVE_OTHER : TIMER_STATE_INACTIVE;
            }
            if(this.championSelectionModel.isSpectating)
            {
               this.yourTimer.currentState = TIMER_STATE_INACTIVE;
            }
            this.updateTimer(this.yourTimer,_loc1_);
         }
         if(this.enemyTimer)
         {
            this.enemyTimer.currentState = !this.championSelectionModel.currentTeamActive ? TIMER_STATE_ACTIVE_OTHER : TIMER_STATE_INACTIVE;
            _loc1_ = !this.championSelectionModel.currentTeamActive || this.championSelectionModel.championSelectionState == GameState.POST_CHAMPION_SELECTION;
            if(!GameState.isInChampionSelectionState(this.championSelectionModel.championSelectionState))
            {
               _loc1_ = false;
               this.enemyTimer.currentState = TIMER_STATE_INACTIVE;
            }
            if(this.championSelectionModel.isSpectating)
            {
               this.enemyTimer.currentState = TIMER_STATE_INACTIVE;
            }
            this.updateTimer(this.enemyTimer,_loc1_);
         }
      }
      
      public function set messageCenter(param1:cs_messageCenter) : void
      {
         var _loc2_:Object = this._2029103300messageCenter;
         if(_loc2_ !== param1)
         {
            this._2029103300messageCenter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"messageCenter",_loc2_,param1));
         }
      }
      
      private function onGameStateChanged(param1:Event) : void
      {
         this.timeRemainingChanged = true;
         this.invalidateProperties();
      }
      
      private function updateTimer(param1:Object, param2:Boolean) : void
      {
         if(!param2 || this.championSelectionModel.timeRemainingSeconds <= 0)
         {
            param1.currentState = TIMER_STATE_INACTIVE;
            param1.timerTxtMc.timerTxt.text = "";
         }
         else if(this.championSelectionModel.timeRemainingSeconds > 180)
         {
            param1.timerTxtMc.timerTxt.htmlText = "&#8734;";
         }
         else
         {
            param1.timerTxtMc.timerTxt.htmlText = this.championSelectionModel.timeRemainingSeconds.toString();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get yourTimer() : cs_timerLeft
      {
         return this._328044242yourTimer;
      }
   }
}

