package com.riotgames.platform.gameclient.views.lobby
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.controllers.lobby.ChooseGameFlowViewController;
   import com.riotgames.platform.gameclient.domain.game.GamePropertiesListData;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
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
   import mx.binding.utils.ChangeWatcher;
   import mx.containers.Canvas;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.controls.Text;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.effects.Fade;
   import mx.effects.Glow;
   import mx.effects.Sequence;
   import mx.effects.SetPropertyAction;
   import mx.effects.effectClasses.SetPropertyActionInstance;
   import mx.events.EffectEvent;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class ChooseGameViewInfoPanel extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static const INFO_DISPLAY_TITLE_BREAK_LINE:Class = ChooseGameViewInfoPanel_INFO_DISPLAY_TITLE_BREAK_LINE;
      
      public static const INFO_DISPLAY_DEFAULT_BG:Class = ChooseGameViewInfoPanel_INFO_DISPLAY_DEFAULT_BG;
      
      public static const INFO_DISPLAY_SUMMONERS_RIFT_BG:Class = ChooseGameViewInfoPanel_INFO_DISPLAY_SUMMONERS_RIFT_BG;
      
      public static const INFO_DISPLAY_SUMMONERS_RIFT_UPDATE_BG:Class = ChooseGameViewInfoPanel_INFO_DISPLAY_SUMMONERS_RIFT_UPDATE_BG;
      
      public static const INFO_DISPLAY_SUMMONERS_RIFT_AUTUMN_BG:Class = ChooseGameViewInfoPanel_INFO_DISPLAY_SUMMONERS_RIFT_AUTUMN_BG;
      
      public static const INFO_DISPLAY_TWISTED_TREELINE_BG:Class = ChooseGameViewInfoPanel_INFO_DISPLAY_TWISTED_TREELINE_BG;
      
      public static const INFO_DISPLAY_ODIN_MAP_BG:Class = ChooseGameViewInfoPanel_INFO_DISPLAY_ODIN_MAP_BG;
      
      public static const INFO_DISPLAY_ODIN_MODE_BG:Class = ChooseGameViewInfoPanel_INFO_DISPLAY_ODIN_MODE_BG;
      
      public static const INFO_DISPLAY_PROVING_GROUNDS_BG:Class = ChooseGameViewInfoPanel_INFO_DISPLAY_PROVING_GROUNDS_BG;
      
      public static const INFO_DISPLAY_PVE_CLASSIC_BG:Class = ChooseGameViewInfoPanel_INFO_DISPLAY_PVE_CLASSIC_BG;
      
      public static const INFO_DISPLAY_PVE_ODIN_BG:Class = ChooseGameViewInfoPanel_INFO_DISPLAY_PVE_ODIN_BG;
      
      public static const INFO_DISPLAY_PVP_CLASSIC_BG:Class = ChooseGameViewInfoPanel_INFO_DISPLAY_PVP_CLASSIC_BG;
      
      public static const INFO_DISPLAY_CUSTOM_BG:Class = ChooseGameViewInfoPanel_INFO_DISPLAY_CUSTOM_BG;
      
      public static const INFO_DISPLAY_PVP_ARAM_BG:Class = ChooseGameViewInfoPanel_INFO_DISPLAY_PVP_ARAM_BG;
      
      public static const INFO_DISPLAY_PVE_ARAM_BG:Class = ChooseGameViewInfoPanel_INFO_DISPLAY_PVE_ARAM_BG;
      
      public static const INFO_DISPLAY_FRELJORD_MODE_BG:Class = ChooseGameViewInfoPanel_INFO_DISPLAY_FRELJORD_MODE_BG;
      
      public static const INFO_DISPLAY_FRELJORD_MAP_BG:Class = ChooseGameViewInfoPanel_INFO_DISPLAY_FRELJORD_MAP_BG;
      
      public static const INFO_DISPLAY_FEATURED_OFA_BG:Class = ChooseGameViewInfoPanel_INFO_DISPLAY_FEATURED_OFA_BG;
      
      public static const INFO_DISPLAY_FEATURED_OFAX_BG:Class = ChooseGameViewInfoPanel_INFO_DISPLAY_FEATURED_OFAX_BG;
      
      public static const INFO_DISPLAY_FEATURED_FBL_BG:Class = ChooseGameViewInfoPanel_INFO_DISPLAY_FEATURED_FBL_BG;
      
      public static const INFO_DISPLAY_FEATURED_6V6_SR_BG:Class = ChooseGameViewInfoPanel_INFO_DISPLAY_FEATURED_6V6_SR_BG;
      
      public static const INFO_DISPLAY_FEATURED_6V6_TT_BG:Class = ChooseGameViewInfoPanel_INFO_DISPLAY_FEATURED_6V6_TT_BG;
      
      public static const INFO_DISPLAY_FEATURED_URF_BG:Class = ChooseGameViewInfoPanel_INFO_DISPLAY_FEATURED_URF_BG;
      
      public static const INFO_DISPLAY_FEATURED_NBOTS_BG:Class = ChooseGameViewInfoPanel_INFO_DISPLAY_FEATURED_NBOTS_BG;
      
      public static const INFO_DISPLAY_TEAM_BUILDER:Class = ChooseGameViewInfoPanel_INFO_DISPLAY_TEAM_BUILDER;
      
      public static const INFO_DISPLAY_FEATURED_ASC_BG:Class = ChooseGameViewInfoPanel_INFO_DISPLAY_FEATURED_ASC_BG;
      
      private var _1282133823fadeIn:Sequence;
      
      private var _3175821glow:Sequence;
      
      public var _ChooseGameViewInfoPanel_Image3:Image;
      
      mx_internal var _watchers:Array = [];
      
      private var _1108203988mapDescriptionLabel:Text;
      
      [Inject]
      private var _962434184chooseGameFlowViewController:ChooseGameFlowViewController;
      
      private var _1404305435modeDescriptionLabel:Text;
      
      private var _2039815407modeLabel:Label;
      
      private var _1888947991cancel_btn:SoundEffectButton;
      
      private var _392875489bg_image_layer2:Image;
      
      private var override_queue_image:ConfigurationModel;
      
      private var _160948984mapLabel:Label;
      
      private var info_bg_list:Dictionary = new Dictionary();
      
      mx_internal var _bindingsByDestination:Object = {};
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      private var _392875490bg_image_layer1:Image;
      
      mx_internal var _bindings:Array = [];
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":Image,
               "id":"bg_image_layer1",
               "propertiesFactory":function():Object
               {
                  return {
                     "percentWidth":100,
                     "percentHeight":100,
                     "visible":true
                  };
               }
            }),new UIComponentDescriptor({
               "type":Image,
               "id":"bg_image_layer2",
               "propertiesFactory":function():Object
               {
                  return {
                     "percentWidth":100,
                     "percentHeight":100,
                     "visible":true,
                     "alpha":0,
                     "includeInLayout":false
                  };
               }
            }),new UIComponentDescriptor({
               "type":Label,
               "id":"modeLabel",
               "stylesFactory":function():void
               {
                  this.top = "10";
                  this.left = "17";
                  this.fontSize = 36;
                  this.color = 16777215;
               },
               "propertiesFactory":function():Object
               {
                  return {"width":100};
               }
            }),new UIComponentDescriptor({
               "type":Label,
               "id":"mapLabel",
               "stylesFactory":function():void
               {
                  this.top = "50";
                  this.left = "17";
                  this.fontSize = 22;
                  this.color = 16777215;
               }
            }),new UIComponentDescriptor({
               "type":Image,
               "id":"_ChooseGameViewInfoPanel_Image3",
               "stylesFactory":function():void
               {
                  this.left = "17";
                  this.top = "95";
               }
            }),new UIComponentDescriptor({
               "type":Text,
               "id":"modeDescriptionLabel",
               "stylesFactory":function():void
               {
                  this.top = "110";
                  this.left = "17";
                  this.fontSize = 15;
                  this.color = 14869218;
                  this.leading = 1;
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "width":390,
                     "selectable":false
                  };
               }
            }),new UIComponentDescriptor({
               "type":Text,
               "id":"mapDescriptionLabel",
               "stylesFactory":function():void
               {
                  this.left = "17";
                  this.fontSize = 15;
                  this.color = 14869218;
                  this.leading = 1;
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "width":390,
                     "selectable":false
                  };
               }
            }),new UIComponentDescriptor({
               "type":SoundEffectButton,
               "id":"cancel_btn",
               "events":{"click":"__cancel_btn_click"},
               "stylesFactory":function():void
               {
                  this.left = "7";
                  this.bottom = "6";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "width":96,
                     "height":36,
                     "useHandCursor":true,
                     "styleName":"longButtonBlue"
                  };
               }
            })]};
         }
      });
      
      private var nextBG:Class = INFO_DISPLAY_DEFAULT_BG;
      
      public function ChooseGameViewInfoPanel()
      {
         super();
         mx_internal::_document = this;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this._ChooseGameViewInfoPanel_Sequence1_i();
         this._ChooseGameViewInfoPanel_Sequence2_i();
         this.addEventListener("creationComplete",this.___ChooseGameViewInfoPanel_Canvas1_creationComplete);
         this.addEventListener("addedToStage",this.___ChooseGameViewInfoPanel_Canvas1_addedToStage);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         ChooseGameViewInfoPanel._watcherSetupUtil = param1;
      }
      
      public function set fadeIn(param1:Sequence) : void
      {
         var _loc2_:Object = this._1282133823fadeIn;
         if(_loc2_ !== param1)
         {
            this._1282133823fadeIn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeIn",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mapLabel() : Label
      {
         return this._160948984mapLabel;
      }
      
      public function set chooseGameFlowViewController(param1:ChooseGameFlowViewController) : void
      {
         var _loc2_:Object = this._962434184chooseGameFlowViewController;
         if(_loc2_ !== param1)
         {
            this._962434184chooseGameFlowViewController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chooseGameFlowViewController",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get glow() : Sequence
      {
         return this._3175821glow;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:ChooseGameViewInfoPanel = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._ChooseGameViewInfoPanel_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_lobby_ChooseGameViewInfoPanelWatcherSetupUtil");
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
      
      public function setModeTextColor(param1:uint) : void
      {
         this.modeLabel.setStyle("color",param1);
      }
      
      private function onMapTextChange(param1:FlexEvent) : void
      {
         callLater(this.updateModeLabelSize,[[this.mapLabel,this.mapDescriptionLabel]]);
      }
      
      [Bindable(event="propertyChange")]
      public function get modeDescriptionLabel() : Text
      {
         return this._1404305435modeDescriptionLabel;
      }
      
      private function _ChooseGameViewInfoPanel_SetPropertyAction1_c() : SetPropertyAction
      {
         var _loc1_:SetPropertyAction = new SetPropertyAction();
         _loc1_.name = "alpha";
         _loc1_.value = 0;
         return _loc1_;
      }
      
      private function _ChooseGameViewInfoPanel_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Object
         {
            return INFO_DISPLAY_PVE_CLASSIC_BG;
         },function(param1:Object):void
         {
            bg_image_layer1.source = param1;
         },"bg_image_layer1.source");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.chooseGameFlowViewController.gameModeDisplayName;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            modeLabel.text = param1;
         },"modeLabel.text");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.chooseGameFlowViewController.gameMapDisplayName;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            mapLabel.text = param1;
         },"mapLabel.text");
         result[2] = binding;
         binding = new Binding(this,function():Object
         {
            return INFO_DISPLAY_TITLE_BREAK_LINE;
         },function(param1:Object):void
         {
            _ChooseGameViewInfoPanel_Image3.source = param1;
         },"_ChooseGameViewInfoPanel_Image3.source");
         result[3] = binding;
         binding = new Binding(this,function():Boolean
         {
            return modeLabel.text != "";
         },function(param1:Boolean):void
         {
            _ChooseGameViewInfoPanel_Image3.visible = param1;
         },"_ChooseGameViewInfoPanel_Image3.visible");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.chooseGameFlowViewController.gameModeDisplayDescription;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            modeDescriptionLabel.htmlText = param1;
         },"modeDescriptionLabel.htmlText");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = modeDescriptionLabel.y + modeDescriptionLabel.height + 10;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            mapDescriptionLabel.setStyle("top",param1);
         },"mapDescriptionLabel.top");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.chooseGameFlowViewController.gameMapDisplayDescription;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            mapDescriptionLabel.htmlText = param1;
         },"mapDescriptionLabel.htmlText");
         result[7] = binding;
         return result;
      }
      
      private function onModeTextChange(param1:FlexEvent) : void
      {
         callLater(this.updateModeLabelSize,[[this.modeLabel,this.modeDescriptionLabel]]);
      }
      
      private function onAddedToStage() : void
      {
         this.chooseGameFlowViewController.registerStartupFunction(this.startup);
      }
      
      private function _ChooseGameViewInfoPanel_Sequence2_i() : Sequence
      {
         var _loc1_:Sequence = new Sequence();
         this.glow = _loc1_;
         _loc1_.children = [this._ChooseGameViewInfoPanel_Glow1_c()];
         return _loc1_;
      }
      
      public function set mapDescriptionLabel(param1:Text) : void
      {
         var _loc2_:Object = this._1108203988mapDescriptionLabel;
         if(_loc2_ !== param1)
         {
            this._1108203988mapDescriptionLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapDescriptionLabel",_loc2_,param1));
         }
      }
      
      public function set glow(param1:Sequence) : void
      {
         var _loc2_:Object = this._3175821glow;
         if(_loc2_ !== param1)
         {
            this._3175821glow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"glow",_loc2_,param1));
         }
      }
      
      private function _ChooseGameViewInfoPanel_Glow1_c() : Glow
      {
         var _loc1_:Glow = new Glow();
         _loc1_.duration = 650;
         _loc1_.alphaFrom = 0.1;
         _loc1_.alphaTo = 0.8;
         _loc1_.blurXFrom = 5;
         _loc1_.blurXTo = 10;
         _loc1_.blurYFrom = 5;
         _loc1_.blurYTo = 10;
         _loc1_.strength = 3;
         _loc1_.color = 26367;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get bg_image_layer1() : Image
      {
         return this._392875490bg_image_layer1;
      }
      
      private function onImageEffectEnd(param1:EffectEvent) : void
      {
         if(param1.effectInstance is SetPropertyActionInstance)
         {
            return;
         }
         if(param1.target === this.bg_image_layer1)
         {
            this.removeChild(this.bg_image_layer2);
         }
         else if(param1.target === this.bg_image_layer2)
         {
            this.removeChild(this.bg_image_layer1);
         }
      }
      
      public function switchBackgrounds() : void
      {
         var _loc1_:Image = null;
         if(this.fadeIn.isPlaying)
         {
            this.fadeIn.end();
            this.bg_image_layer1.alpha = 1;
            this.bg_image_layer2.alpha = 1;
         }
         if(this.contains(this.bg_image_layer1))
         {
            if(this.bg_image_layer1.source == this.nextBG)
            {
               this.nextBG = null;
               return;
            }
            _loc1_ = this.bg_image_layer2;
            this.addChildAt(this.bg_image_layer2,this.getChildIndex(this.bg_image_layer1) + 1);
            if(!UserPreferencesManager.globalPrefs.enableAnimations)
            {
               this.removeChild(this.bg_image_layer1);
            }
         }
         else
         {
            if(this.bg_image_layer2.source == this.nextBG)
            {
               this.nextBG = null;
               return;
            }
            _loc1_ = this.bg_image_layer1;
            this.addChildAt(this.bg_image_layer1,this.getChildIndex(this.bg_image_layer2) + 1);
            if(!UserPreferencesManager.globalPrefs.enableAnimations)
            {
               this.removeChild(this.bg_image_layer2);
            }
         }
         if(_loc1_.source != this.nextBG)
         {
            _loc1_.source = this.nextBG;
         }
         if(UserPreferencesManager.globalPrefs.enableAnimations)
         {
            this.fadeIn.play([_loc1_]);
         }
         else
         {
            _loc1_.alpha = 1;
         }
         this.nextBG = null;
      }
      
      public function set cancel_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._1888947991cancel_btn;
         if(_loc2_ !== param1)
         {
            this._1888947991cancel_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cancel_btn",_loc2_,param1));
         }
      }
      
      public function set modeDescriptionLabel(param1:Text) : void
      {
         var _loc2_:Object = this._1404305435modeDescriptionLabel;
         if(_loc2_ !== param1)
         {
            this._1404305435modeDescriptionLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"modeDescriptionLabel",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bg_image_layer2() : Image
      {
         return this._392875489bg_image_layer2;
      }
      
      [Bindable(event="propertyChange")]
      public function get cancel_btn() : SoundEffectButton
      {
         return this._1888947991cancel_btn;
      }
      
      public function set bg_image_layer2(param1:Image) : void
      {
         var _loc2_:Object = this._392875489bg_image_layer2;
         if(_loc2_ !== param1)
         {
            this._392875489bg_image_layer2 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bg_image_layer2",_loc2_,param1));
         }
      }
      
      public function ___ChooseGameViewInfoPanel_Canvas1_addedToStage(param1:Event) : void
      {
         this.onAddedToStage();
      }
      
      public function __cancel_btn_click(param1:MouseEvent) : void
      {
         this.chooseGameFlowViewController.cancelFlow();
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeIn() : Sequence
      {
         return this._1282133823fadeIn;
      }
      
      private function _ChooseGameViewInfoPanel_Fade1_c() : Fade
      {
         var _loc1_:Fade = new Fade();
         _loc1_.duration = 375;
         _loc1_.alphaFrom = 0;
         _loc1_.alphaTo = 1;
         _loc1_.startDelay = 0;
         return _loc1_;
      }
      
      public function set modeLabel(param1:Label) : void
      {
         var _loc2_:Object = this._2039815407modeLabel;
         if(_loc2_ !== param1)
         {
            this._2039815407modeLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"modeLabel",_loc2_,param1));
         }
      }
      
      public function set bg_image_layer1(param1:Image) : void
      {
         var _loc2_:Object = this._392875490bg_image_layer1;
         if(_loc2_ !== param1)
         {
            this._392875490bg_image_layer1 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bg_image_layer1",_loc2_,param1));
         }
      }
      
      private function _ChooseGameViewInfoPanel_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = INFO_DISPLAY_PVE_CLASSIC_BG;
         _loc1_ = this.chooseGameFlowViewController.gameModeDisplayName;
         _loc1_ = this.chooseGameFlowViewController.gameMapDisplayName;
         _loc1_ = INFO_DISPLAY_TITLE_BREAK_LINE;
         _loc1_ = this.modeLabel.text != "";
         _loc1_ = this.chooseGameFlowViewController.gameModeDisplayDescription;
         _loc1_ = this.modeDescriptionLabel.y + this.modeDescriptionLabel.height + 10;
         _loc1_ = this.chooseGameFlowViewController.gameMapDisplayDescription;
      }
      
      public function ___ChooseGameViewInfoPanel_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.creationCompleteHandler(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get modeLabel() : Label
      {
         return this._2039815407modeLabel;
      }
      
      [Bindable(event="propertyChange")]
      public function get mapDescriptionLabel() : Text
      {
         return this._1108203988mapDescriptionLabel;
      }
      
      private function updateModeLabelSize(param1:Array) : void
      {
         this.modeLabel.width = this.modeLabel.textWidth + 15;
         if(UserPreferencesManager.globalPrefs.enableAnimations)
         {
            this.fadeIn.play(param1);
         }
         else
         {
            this.modeLabel.alpha = 1;
            this.mapLabel.alpha = 1;
            this.modeDescriptionLabel.alpha = 1;
            this.mapDescriptionLabel.alpha = 1;
         }
      }
      
      private function _ChooseGameViewInfoPanel_Sequence1_i() : Sequence
      {
         var _loc1_:Sequence = new Sequence();
         this.fadeIn = _loc1_;
         _loc1_.children = [this._ChooseGameViewInfoPanel_SetPropertyAction1_c(),this._ChooseGameViewInfoPanel_Fade1_c()];
         return _loc1_;
      }
      
      protected function creationCompleteHandler(param1:FlexEvent) : void
      {
         this.override_queue_image = DynamicClientConfigManager.getConfiguration("QueueImages","OverrideQueueImage",false);
         this.info_bg_list["default"] = INFO_DISPLAY_DEFAULT_BG;
         this.info_bg_list["summoners_rift"] = INFO_DISPLAY_SUMMONERS_RIFT_BG;
         this.info_bg_list["twisted_treeline"] = INFO_DISPLAY_TWISTED_TREELINE_BG;
         this.info_bg_list["crystal_scar"] = INFO_DISPLAY_ODIN_MAP_BG;
         this.info_bg_list["pvp_odin"] = INFO_DISPLAY_ODIN_MODE_BG;
         this.info_bg_list["proving_grounds"] = INFO_DISPLAY_PROVING_GROUNDS_BG;
         this.info_bg_list["battle_training"] = INFO_DISPLAY_SUMMONERS_RIFT_BG;
         this.info_bg_list["pve_classic"] = INFO_DISPLAY_PVE_CLASSIC_BG;
         this.info_bg_list["pve_odin"] = INFO_DISPLAY_PVE_ODIN_BG;
         this.info_bg_list["pvp_classic"] = INFO_DISPLAY_PVP_CLASSIC_BG;
         this.info_bg_list["promotionmap_sru"] = INFO_DISPLAY_SUMMONERS_RIFT_UPDATE_BG;
         this.info_bg_list["custom_create"] = INFO_DISPLAY_CUSTOM_BG;
         this.info_bg_list["custom_tournament"] = INFO_DISPLAY_CUSTOM_BG;
         this.info_bg_list["pvp_aram"] = INFO_DISPLAY_PVP_ARAM_BG;
         this.info_bg_list["pve_aram"] = INFO_DISPLAY_PVE_ARAM_BG;
         this.info_bg_list["freljord_mode"] = INFO_DISPLAY_FRELJORD_MODE_BG;
         this.info_bg_list["freljord_map"] = INFO_DISPLAY_FRELJORD_MAP_BG;
         this.info_bg_list["featured_ofa"] = INFO_DISPLAY_FEATURED_OFA_BG;
         this.info_bg_list["featured_ofax"] = INFO_DISPLAY_FEATURED_OFAX_BG;
         this.info_bg_list["featured_fbl"] = INFO_DISPLAY_FEATURED_FBL_BG;
         this.info_bg_list["featured_sr6"] = INFO_DISPLAY_FEATURED_6V6_SR_BG;
         this.info_bg_list["featured_tt6"] = INFO_DISPLAY_FEATURED_6V6_TT_BG;
         this.info_bg_list["featured_urf"] = INFO_DISPLAY_FEATURED_URF_BG;
         this.info_bg_list["featured_nbots"] = INFO_DISPLAY_FEATURED_NBOTS_BG;
         this.info_bg_list["featured_asc"] = INFO_DISPLAY_FEATURED_ASC_BG;
         this.info_bg_list["custom_ofa"] = INFO_DISPLAY_FEATURED_OFA_BG;
         this.info_bg_list["custom_ofax"] = INFO_DISPLAY_FEATURED_OFAX_BG;
         this.info_bg_list["custom_fbl"] = INFO_DISPLAY_FEATURED_FBL_BG;
         this.info_bg_list["custom_sr6"] = INFO_DISPLAY_FEATURED_6V6_SR_BG;
         this.info_bg_list["custom_tt6"] = INFO_DISPLAY_FEATURED_6V6_TT_BG;
         this.info_bg_list["custom_urf"] = INFO_DISPLAY_FEATURED_URF_BG;
         this.info_bg_list["team_builder"] = INFO_DISPLAY_TEAM_BUILDER;
         this.info_bg_list["custom_asc"] = INFO_DISPLAY_FEATURED_ASC_BG;
         this.bg_image_layer1.addEventListener(EffectEvent.EFFECT_END,this.onImageEffectEnd);
         this.bg_image_layer2.addEventListener(EffectEvent.EFFECT_END,this.onImageEffectEnd);
         this.removeChild(this.bg_image_layer2);
         var _loc2_:GlowFilter = new GlowFilter(0,1,6,6,3,1,false);
         var _loc3_:DropShadowFilter = new DropShadowFilter(4,45,8947848,0.7,4,4,0.5);
         this.modeLabel.filters = [_loc2_];
         this.mapLabel.filters = [_loc2_];
         this.modeDescriptionLabel.filters = [_loc3_,_loc2_];
         this.mapDescriptionLabel.filters = [_loc3_,_loc2_];
         ChangeWatcher.watch(this.modeLabel,"text",this.onModeTextChange);
         ChangeWatcher.watch(this.mapLabel,"text",this.onMapTextChange);
      }
      
      public function set mapLabel(param1:Label) : void
      {
         var _loc2_:Object = this._160948984mapLabel;
         if(_loc2_ !== param1)
         {
            this._160948984mapLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapLabel",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get chooseGameFlowViewController() : ChooseGameFlowViewController
      {
         return this._962434184chooseGameFlowViewController;
      }
      
      public function startup() : void
      {
         this.cancel_btn.label = RiotResourceLoader.getString("cancel_btn_label","Home");
      }
      
      public function setInfoBackground(param1:GamePropertiesListData = null, param2:GamePropertiesListData = null, param3:GamePropertiesListData = null) : void
      {
         if(param1 == null)
         {
            this.nextBG = this.info_bg_list["default"];
         }
         else if(Boolean(param3) && param3.modifierProperties["gameType"] == "cap")
         {
            this.nextBG = this.info_bg_list["team_builder"];
         }
         else if(Boolean(this.override_queue_image.getBoolean() && param1 && param1.internalName == "pvp_classic" && param2 && param2.internalName == "summoners_rift") && Boolean(param3) && param3.modifierProperties["gameType"] == "blind_pick")
         {
            this.nextBG = this.info_bg_list["promotionmap_sru"];
         }
         else
         {
            this.nextBG = this.info_bg_list[param1.internalName];
         }
      }
   }
}

