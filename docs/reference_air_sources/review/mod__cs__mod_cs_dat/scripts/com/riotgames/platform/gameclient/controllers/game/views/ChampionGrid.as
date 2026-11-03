package com.riotgames.platform.gameclient.controllers.game.views
{
   import com.riotgames.platform.common.components.AnimatedTileList;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.controllers.game.views.itemRenderers.BannableChampionSelectRenderer;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import com.riotgames.platform.gameclient.domain.game.GameState;
   import com.riotgames.pvpnet.championselection.views.ChampionSelectRenderer;
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
   import mx.collections.ArrayCollection;
   import mx.containers.Canvas;
   import mx.core.ClassFactory;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.effects.DefaultTileListEffect;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   public class ChampionGrid extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      protected static const GRAYSCALE_MATRIX:Array = [0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0];
      
      private var _1078708046interactiveRenderers:Boolean = true;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object = {};
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array = [];
      
      private var _2106232724tileList:AnimatedTileList;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object = {};
      
      private var _championSelectionModel:ChampionSelectionModel = null;
      
      public var soundManager:ISoundProvider;
      
      private var _1655827171tileListEffect:DefaultTileListEffect;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array = [];
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":AnimatedTileList,
               "id":"tileList",
               "stylesFactory":function():void
               {
                  this.backgroundAlpha = 0;
                  this.paddingLeft = 6;
                  this.paddingTop = 6;
                  this.paddingBottom = 6;
                  this.paddingRight = 6;
                  this.scrollBarStyle = "blueGlassScrollBar";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "percentWidth":100,
                     "percentHeight":100,
                     "tileWidth":69,
                     "tileHeight":65
                  };
               }
            })]};
         }
      });
      
      public function ChampionGrid()
      {
         super();
         mx_internal::_document = this;
         this.verticalScrollPolicy = "off";
         this.horizontalScrollPolicy = "off";
         this._ChampionGrid_DefaultTileListEffect1_i();
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         ChampionGrid._watcherSetupUtil = param1;
      }
      
      protected function getTileListAnimation(param1:Boolean) : DefaultTileListEffect
      {
         if(param1)
         {
            return this.tileListEffect;
         }
         return null;
      }
      
      [Bindable(event="propertyChange")]
      public function get tileList() : AnimatedTileList
      {
         return this._2106232724tileList;
      }
      
      protected function getTileListRenderer(param1:String) : ClassFactory
      {
         var _loc2_:ClassFactory = null;
         if(param1 == GameState.PRE_CHAMPION_SELECTION && this.isPotentialBanner())
         {
            _loc2_ = new ClassFactory(BannableChampionSelectRenderer);
         }
         else
         {
            _loc2_ = new ClassFactory(ChampionSelectRenderer);
         }
         _loc2_.properties = {
            "mouseChildren":false,
            "buttonMode":true
         };
         return _loc2_;
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
         this.championSelectionModel.addEventListener(ChampionSelectionModel.PICK_TURN_CHANGED,this.onChampionSelectionStateChanged,false,0,true);
         this.championSelectionModel.addEventListener(ChampionSelectionModel.CHAMPION_SELECTION_STATE_CHANGED,this.onChampionSelectionStateChanged,false,0,true);
         this.updateSaturationFilter();
      }
      
      public function set filterText(param1:String) : void
      {
         if(this.championSelectionModel)
         {
            this.championSelectionModel.championSelections.filterString = param1;
            this.championSelectionModel.championSelections.refresh();
         }
      }
      
      private function _ChampionGrid_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Boolean
         {
            return interactiveRenderers;
         },function(param1:Boolean):void
         {
            tileList.interactiveRenderers = param1;
         },"tileList.interactiveRenderers");
         result[0] = binding;
         binding = new Binding(this,function():ClassFactory
         {
            return getTileListRenderer(this.championSelectionModel.championSelectionState);
         },function(param1:ClassFactory):void
         {
            tileList.itemRenderer = param1;
         },"tileList.itemRenderer");
         result[1] = binding;
         binding = new Binding(this,function():ArrayCollection
         {
            return this.championSelectionModel.championSelections;
         },function(param1:ArrayCollection):void
         {
            tileList.dataProvider = param1;
         },"tileList.dataProvider");
         result[2] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.championSelectionModel.showChampionGrid;
         },function(param1:Boolean):void
         {
            tileList.visible = param1;
         },"tileList.visible");
         result[3] = binding;
         binding = new Binding(this,function():*
         {
            return getTileListAnimation(UserPreferencesManager.userPrefs.enableAnimations);
         },function(param1:*):void
         {
            tileList.setStyle("itemsChangeEffect",param1);
         },"tileList.itemsChangeEffect");
         result[4] = binding;
         return result;
      }
      
      private function onChampionSelectionStateChanged(param1:Event) : void
      {
         this.updateSaturationFilter();
      }
      
      private function unsetChampionSelectionModel() : void
      {
         if(!this.championSelectionModel)
         {
            return;
         }
         this.championSelectionModel.removeEventListener(ChampionSelectionModel.PICK_TURN_CHANGED,this.onChampionSelectionStateChanged);
         this.championSelectionModel.removeEventListener(ChampionSelectionModel.CHAMPION_SELECTION_STATE_CHANGED,this.onChampionSelectionStateChanged);
      }
      
      protected function updateSaturationFilter() : void
      {
         var _loc1_:ColorMatrixFilter = null;
         if(!this.championSelectionModel || !this.tileList)
         {
            return;
         }
         if(this.isPotentialBanner() && this.championSelectionModel.championSelectionState == GameState.PRE_CHAMPION_SELECTION || this.championSelectionModel.championSelectionState != GameState.PRE_CHAMPION_SELECTION || Boolean(this.championSelectionModel.isSpectating))
         {
            this.tileList.filters = [];
         }
         else if(Boolean(this.championSelectionModel.currentPlayerParticipant) && this.championSelectionModel.currentPickMode != GameParticipant.PICK_MODE_ACTIVE)
         {
            _loc1_ = new ColorMatrixFilter();
            _loc1_.matrix = GRAYSCALE_MATRIX;
            this.tileList.filters = [_loc1_];
         }
      }
      
      private function _ChampionGrid_DefaultTileListEffect1_i() : DefaultTileListEffect
      {
         var _loc1_:DefaultTileListEffect = new DefaultTileListEffect();
         this.tileListEffect = _loc1_;
         _loc1_.fadeOutDuration = 300;
         _loc1_.fadeInDuration = 300;
         _loc1_.moveDuration = 300;
         return _loc1_;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:ChampionGrid = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._ChampionGrid_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_controllers_game_views_ChampionGridWatcherSetupUtil");
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
      
      private function set _1044583878championSelectionModel(param1:ChampionSelectionModel) : void
      {
         if(this.championSelectionModel == param1)
         {
            return;
         }
         this.unsetChampionSelectionModel();
         this._championSelectionModel = param1;
         this.setChampionSelectionModel();
      }
      
      [Bindable(event="propertyChange")]
      public function set championSelectionModel(param1:ChampionSelectionModel) : void
      {
         var _loc2_:Object = this.championSelectionModel;
         if(_loc2_ !== param1)
         {
            this._1044583878championSelectionModel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championSelectionModel",_loc2_,param1));
         }
      }
      
      public function set interactiveRenderers(param1:Boolean) : void
      {
         var _loc2_:Object = this._1078708046interactiveRenderers;
         if(_loc2_ !== param1)
         {
            this._1078708046interactiveRenderers = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"interactiveRenderers",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get tileListEffect() : DefaultTileListEffect
      {
         return this._1655827171tileListEffect;
      }
      
      private function isPotentialBanner() : Boolean
      {
         var _loc1_:ArrayCollection = this.championSelectionModel.currentTeam;
         var _loc2_:GameParticipant = _loc1_.getItemAt(0) as GameParticipant;
         return _loc2_.isMe;
      }
      
      [Bindable(event="propertyChange")]
      public function get interactiveRenderers() : Boolean
      {
         return this._1078708046interactiveRenderers;
      }
      
      public function set tileList(param1:AnimatedTileList) : void
      {
         var _loc2_:Object = this._2106232724tileList;
         if(_loc2_ !== param1)
         {
            this._2106232724tileList = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tileList",_loc2_,param1));
         }
      }
      
      private function _ChampionGrid_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.interactiveRenderers;
         _loc1_ = this.getTileListRenderer(this.championSelectionModel.championSelectionState);
         _loc1_ = this.championSelectionModel.championSelections;
         _loc1_ = this.championSelectionModel.showChampionGrid;
         _loc1_ = this.getTileListAnimation(UserPreferencesManager.userPrefs.enableAnimations);
      }
      
      public function set tileListEffect(param1:DefaultTileListEffect) : void
      {
         var _loc2_:Object = this._1655827171tileListEffect;
         if(_loc2_ !== param1)
         {
            this._1655827171tileListEffect = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tileListEffect",_loc2_,param1));
         }
      }
   }
}

