package com.riotgames.platform.gameclient.controllers.game.views
{
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.controllers.game.enums.MenuStates;
   import com.riotgames.platform.gameclient.controllers.game.event.SpellSelectEvent;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.controllers.game.views.popup.SpellToolTip;
   import com.riotgames.pvpnet.model.SpellSelection;
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
   import mx.containers.HBox;
   import mx.containers.VBox;
   import mx.controls.Spacer;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.ToolTipEvent;
   import mx.styles.*;
   
   public class SpellSelectionView extends VBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private static const DISABLED_ALPHA:Number = 0.25;
      
      private static const ENABLED_ALPHA:Number = 1;
      
      public var _SpellSelectionView_SoundEffectButton1:SoundEffectButton;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array;
      
      private var _championSelectionModel:ChampionSelectionModel;
      
      private var _1527390804spellSlot2:SpellSelectRendererAS;
      
      private var _1527390805spellSlot1:SpellSelectRendererAS;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array;
      
      public function SpellSelectionView()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":VBox,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":HBox,
                  "stylesFactory":function():void
                  {
                     this.horizontalAlign = "right";
                     this.horizontalGap = 6;
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "percentWidth":90,
                        "height":50,
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":Spacer,
                           "propertiesFactory":function():Object
                           {
                              return {"percentWidth":100};
                           }
                        }),new UIComponentDescriptor({
                           "type":SpellSelectRendererAS,
                           "id":"spellSlot1",
                           "events":{
                              "toolTipCreate":"__spellSlot1_toolTipCreate",
                              "click":"__spellSlot1_click"
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "height":50,
                                 "width":50,
                                 "toolTip":"unused",
                                 "buttonMode":true,
                                 "mouseChildren":false,
                                 "selectionText":"1",
                                 "showName":false
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":SpellSelectRendererAS,
                           "id":"spellSlot2",
                           "events":{
                              "toolTipCreate":"__spellSlot2_toolTipCreate",
                              "click":"__spellSlot2_click"
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "height":50,
                                 "width":50,
                                 "toolTip":"unused",
                                 "buttonMode":true,
                                 "mouseChildren":false,
                                 "showName":false,
                                 "selectionText":"2"
                              };
                           }
                        })]
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":SoundEffectButton,
                  "id":"_SpellSelectionView_SoundEffectButton1",
                  "events":{"click":"___SpellSelectionView_SoundEffectButton1_click"},
                  "propertiesFactory":function():Object
                  {
                     return {
                        "width":165,
                        "height":30,
                        "styleName":"correctLargeButtonBlue"
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
            this.horizontalAlign = "center";
            this.verticalAlign = "top";
            this.verticalGap = 2;
         };
         this.cacheAsBitmap = true;
         this.mouseEnabled = true;
         this.addEventListener("creationComplete",this.___SpellSelectionView_VBox1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         SpellSelectionView._watcherSetupUtil = param1;
      }
      
      private function createSpell1Tooltip(param1:ToolTipEvent) : void
      {
         var _loc2_:SpellToolTip = new SpellToolTip();
         _loc2_.data = this.championSelectionModel.currentPlayerSelection.spell1;
         param1.toolTip = _loc2_;
      }
      
      private function spell2Clicked() : void
      {
         if(this.championSelectionModel.spellsMenuState == MenuStates.SMALL_MENU_STATE_ACTIVE)
         {
            dispatchEvent(new SpellSelectEvent(SpellSelectEvent.CHANGE_SPELL_2_REQUESTED,this.championSelectionModel.currentPlayerSelection.spell1,this.championSelectionModel.currentPlayerSelection.spell2,true,false));
         }
      }
      
      private function onSpellOut(param1:DisplayObject, param2:DisplayObject) : void
      {
         if(param1)
         {
            param1.filters = [];
         }
         if(param2)
         {
            param2.visible = false;
         }
      }
      
      public function get championSelectionModel() : ChampionSelectionModel
      {
         return this._championSelectionModel;
      }
      
      protected function setChampionSelectionModel() : void
      {
         this.updateSpells(null);
         if(!(this.championSelectionModel && this.championSelectionModel.currentPlayerSelection))
         {
            return;
         }
         this.championSelectionModel.currentPlayerSelection.addEventListener("spell1Changed",this.updateSpellImages,false,0,true);
         this.championSelectionModel.currentPlayerSelection.addEventListener("spell2Changed",this.updateSpellImages,false,0,true);
         this.championSelectionModel.addEventListener(ChampionSelectionModel.SPELLS_BUSY_CHANGED,this.updateAlpha,false,0,true);
      }
      
      public function __spellSlot1_toolTipCreate(param1:ToolTipEvent) : void
      {
         this.createSpell1Tooltip(param1);
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:SpellSelectionView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._SpellSelectionView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_controllers_game_views_SpellSelectionViewWatcherSetupUtil");
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
      
      public function getSpellResourceString(param1:String, param2:String, param3:String) : String
      {
         var _loc4_:String = resourceManager.getString("spell_resources","summoner_data_spell_" + param1 + "_" + param2);
         if(_loc4_ != null)
         {
            return _loc4_;
         }
         return param3;
      }
      
      public function ___SpellSelectionView_VBox1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      public function __spellSlot1_click(param1:MouseEvent) : void
      {
         this.spell1Clicked();
      }
      
      private function updateAlpha(param1:Event) : void
      {
         if(Boolean(this.championSelectionModel && !this.championSelectionModel.spellsBusy && this.championSelectionModel.currentPlayerSelection) && Boolean(this.championSelectionModel.currentPlayerSelection.spell1 != null) && this.championSelectionModel.currentPlayerSelection.spell2 != null)
         {
            this.alpha = ENABLED_ALPHA;
         }
         else
         {
            this.alpha = DISABLED_ALPHA;
         }
      }
      
      private function _SpellSelectionView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","championSelection_chooseBothSpells");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _SpellSelectionView_SoundEffectButton1.label = param1;
         },"_SpellSelectionView_SoundEffectButton1.label");
         result[0] = binding;
         return result;
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
      
      public function __spellSlot2_click(param1:MouseEvent) : void
      {
         this.spell2Clicked();
      }
      
      private function spell1Clicked() : void
      {
         if(this.championSelectionModel.spellsMenuState == MenuStates.SMALL_MENU_STATE_ACTIVE)
         {
            dispatchEvent(new SpellSelectEvent(SpellSelectEvent.CHANGE_SPELL_1_REQUESTED,this.championSelectionModel.currentPlayerSelection.spell1,this.championSelectionModel.currentPlayerSelection.spell2,true,false));
         }
      }
      
      private function createSpell2Tooltip(param1:ToolTipEvent) : void
      {
         var _loc2_:SpellToolTip = new SpellToolTip();
         _loc2_.data = this.championSelectionModel.currentPlayerSelection.spell2;
         param1.toolTip = _loc2_;
      }
      
      public function __spellSlot2_toolTipCreate(param1:ToolTipEvent) : void
      {
         this.createSpell2Tooltip(param1);
      }
      
      protected function removeChampionSelectionModel() : void
      {
         if(Boolean(this.championSelectionModel) && Boolean(this.championSelectionModel.currentPlayerSelection))
         {
            this.championSelectionModel.currentPlayerSelection.removeEventListener("spell1Changed",this.updateSpellImages);
            this.championSelectionModel.currentPlayerSelection.removeEventListener("spell2Changed",this.updateSpellImages);
         }
         if(this.championSelectionModel)
         {
            this.championSelectionModel.removeEventListener(ChampionSelectionModel.SPELLS_BUSY_CHANGED,this.updateAlpha);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get spellSlot1() : SpellSelectRendererAS
      {
         return this._1527390805spellSlot1;
      }
      
      private function openSpellSelection() : void
      {
         if(this.championSelectionModel.spellsMenuState == MenuStates.SMALL_MENU_STATE_ACTIVE)
         {
            dispatchEvent(new SpellSelectEvent(SpellSelectEvent.OPEN_SPELL_SELECT,null,null,true,false));
         }
      }
      
      private function _SpellSelectionView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = resourceManager.getString("resources","championSelection_chooseBothSpells");
      }
      
      [Bindable(event="propertyChange")]
      public function get spellSlot2() : SpellSelectRendererAS
      {
         return this._1527390804spellSlot2;
      }
      
      private function updateSpells(param1:Event) : void
      {
         this.updateAlpha(param1);
         this.updateSpellImages(param1);
      }
      
      private function onCreationComplete() : void
      {
         this.updateSpells(null);
      }
      
      public function set spellSlot1(param1:SpellSelectRendererAS) : void
      {
         var _loc2_:Object = this._1527390805spellSlot1;
         if(_loc2_ !== param1)
         {
            this._1527390805spellSlot1 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spellSlot1",_loc2_,param1));
         }
      }
      
      public function set spellSlot2(param1:SpellSelectRendererAS) : void
      {
         var _loc2_:Object = this._1527390804spellSlot2;
         if(_loc2_ !== param1)
         {
            this._1527390804spellSlot2 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spellSlot2",_loc2_,param1));
         }
      }
      
      private function onSpellOver(param1:DisplayObject, param2:DisplayObject) : void
      {
         var _loc3_:Array = null;
         var _loc4_:ColorMatrixFilter = null;
         var _loc5_:Array = null;
         if(param1)
         {
            _loc3_ = new Array();
            _loc3_ = _loc3_.concat([1,0,0,0,45]);
            _loc3_ = _loc3_.concat([0,1,0,0,45]);
            _loc3_ = _loc3_.concat([0,0,1,0,45]);
            _loc3_ = _loc3_.concat([0,0,0,1,0]);
            _loc4_ = new ColorMatrixFilter(_loc3_);
            _loc5_ = new Array();
            _loc5_.push(_loc4_);
            param1.filters = _loc5_;
         }
         if(param2)
         {
            param2.visible = true;
         }
      }
      
      private function updateSpellImages(param1:Event) : void
      {
         var _loc2_:DisplayObject = null;
         if(!this.championSelectionModel)
         {
            if(this.spellSlot1)
            {
               this.spellSlot1.data = null;
            }
            if(this.spellSlot2)
            {
               this.spellSlot2.data = null;
            }
         }
         if(Boolean(this.championSelectionModel) && Boolean(this.championSelectionModel.currentPlayerSelection) && this.championSelectionModel.currentPlayerSelection.spell1 != null)
         {
            this.spellSlot1.data = new SpellSelection(this.championSelectionModel.currentPlayerSelection.spell1,true,true);
         }
         else
         {
            this.spellSlot1.data = null;
         }
         if(Boolean(this.championSelectionModel) && Boolean(this.championSelectionModel.currentPlayerSelection) && this.championSelectionModel.currentPlayerSelection.spell2 != null)
         {
            this.spellSlot2.data = new SpellSelection(this.championSelectionModel.currentPlayerSelection.spell2,true,true);
         }
         else
         {
            this.spellSlot2.data = null;
         }
      }
      
      public function ___SpellSelectionView_SoundEffectButton1_click(param1:MouseEvent) : void
      {
         this.openSpellSelection();
      }
   }
}

