package com.riotgames.platform.gameclient.views.game.practice.create
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.components.containers.GradientCanvas;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.pvpnet.game.controllers.practice.CreatePracticeGameController;
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
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class ChooseMapRenderer extends GradientCanvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      [Inject]
      private var _1576335205createPracticeGameController:CreatePracticeGameController;
      
      private var _1754851640selectedGlow:GlowFilter;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _watchers:Array;
      
      private var _437162452mapCanvas:Canvas;
      
      mx_internal var _bindings:Array;
      
      private var _158535007mapImage:Image;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      private var _2096692277map_c_label:Label;
      
      public function ChooseMapRenderer()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":GradientCanvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":Canvas,
                  "id":"mapCanvas",
                  "stylesFactory":function():void
                  {
                     this.horizontalCenter = "0";
                     this.verticalCenter = "0";
                     this.cornerRadius = 3;
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "width":289,
                        "height":155,
                        "styleName":"blueParchmentTablet",
                        "clipContent":true,
                        "horizontalScrollPolicy":"off",
                        "verticalScrollPolicy":"off",
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":Image,
                           "id":"mapImage",
                           "stylesFactory":function():void
                           {
                              this.top = "0";
                              this.right = "0";
                              this.bottom = "0";
                              this.left = "0";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {"maintainAspectRatio":true};
                           }
                        }),new UIComponentDescriptor({
                           "type":Label,
                           "id":"map_c_label",
                           "stylesFactory":function():void
                           {
                              this.right = "5";
                              this.bottom = "-2";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {"styleName":"mapRendererMapName"};
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
            this.borderThickness = 0;
         };
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.cacheAsBitmap = true;
         this._ChooseMapRenderer_GlowFilter1_i();
         this.addEventListener("initialize",this.___ChooseMapRenderer_GradientCanvas1_initialize);
         this.addEventListener("creationComplete",this.___ChooseMapRenderer_GradientCanvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         ChooseMapRenderer._watcherSetupUtil = param1;
      }
      
      private function _ChooseMapRenderer_GlowFilter1_i() : GlowFilter
      {
         var _loc1_:GlowFilter = new GlowFilter();
         this.selectedGlow = _loc1_;
         _loc1_.color = 9419506;
         _loc1_.blurX = 8;
         _loc1_.blurY = 8;
         _loc1_.alpha = 0.5;
         _loc1_.strength = 5;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedGlow() : GlowFilter
      {
         return this._1754851640selectedGlow;
      }
      
      [Bindable(event="propertyChange")]
      public function get mapCanvas() : Canvas
      {
         return this._437162452mapCanvas;
      }
      
      private function setGlow() : void
      {
         var _loc1_:Boolean = false;
         if(Boolean(this.createPracticeGameController) && Boolean(this.createPracticeGameController.game.gameMap != null) && this.data != null)
         {
            if(this.createPracticeGameController.game.gameMap.mapId == this.data.mapId)
            {
               _loc1_ = true;
            }
         }
         if(_loc1_)
         {
            this.filters = [this.selectedGlow];
         }
         else
         {
            this.filters = [];
         }
      }
      
      private function onGameMapChanged() : void
      {
         this.setGlow();
      }
      
      private function onInitialize() : void
      {
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:ChooseMapRenderer = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._ChooseMapRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_practice_create_ChooseMapRendererWatcherSetupUtil");
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
      
      private function _ChooseMapRenderer_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.data.displayName;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            map_c_label.text = param1;
         },"map_c_label.text");
         result[0] = binding;
         return result;
      }
      
      override public function set data(param1:Object) : void
      {
         var map:GameMap;
         var value:Object = param1;
         super.data = value;
         map = value as GameMap;
         try
         {
            this.mapImage.source = ImagePackLookup.instance.getMapSource(map);
            this.map_c_label.filters = [new GlowFilter(0,1,6,6,2.3,1,false)];
         }
         catch(e:Error)
         {
            mapImage.source = ImagePackLookup.instance.getClassFromSwfRef("e_map_error");
         }
      }
      
      public function set createPracticeGameController(param1:CreatePracticeGameController) : void
      {
         var _loc2_:Object = this._1576335205createPracticeGameController;
         if(_loc2_ !== param1)
         {
            this._1576335205createPracticeGameController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"createPracticeGameController",_loc2_,param1));
         }
      }
      
      public function ___ChooseMapRenderer_GradientCanvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get createPracticeGameController() : CreatePracticeGameController
      {
         return this._1576335205createPracticeGameController;
      }
      
      [Bindable(event="propertyChange")]
      public function get mapImage() : Image
      {
         return this._158535007mapImage;
      }
      
      private function _ChooseMapRenderer_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.data.displayName;
      }
      
      public function set map_c_label(param1:Label) : void
      {
         var _loc2_:Object = this._2096692277map_c_label;
         if(_loc2_ !== param1)
         {
            this._2096692277map_c_label = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"map_c_label",_loc2_,param1));
         }
      }
      
      public function set mapCanvas(param1:Canvas) : void
      {
         var _loc2_:Object = this._437162452mapCanvas;
         if(_loc2_ !== param1)
         {
            this._437162452mapCanvas = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapCanvas",_loc2_,param1));
         }
      }
      
      public function set selectedGlow(param1:GlowFilter) : void
      {
         var _loc2_:Object = this._1754851640selectedGlow;
         if(_loc2_ !== param1)
         {
            this._1754851640selectedGlow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedGlow",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get map_c_label() : Label
      {
         return this._2096692277map_c_label;
      }
      
      private function onCreationComplete() : void
      {
         this.setGlow();
         this.createPracticeGameController.mapChanged.add(this.onGameMapChanged);
      }
      
      public function ___ChooseMapRenderer_GradientCanvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      public function set mapImage(param1:Image) : void
      {
         var _loc2_:Object = this._158535007mapImage;
         if(_loc2_ !== param1)
         {
            this._158535007mapImage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapImage",_loc2_,param1));
         }
      }
   }
}

