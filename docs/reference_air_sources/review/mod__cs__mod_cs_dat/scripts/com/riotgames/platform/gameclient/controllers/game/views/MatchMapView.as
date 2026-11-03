package com.riotgames.platform.gameclient.controllers.game.views
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.components.containers.GradientCanvas;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
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
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   public class MatchMapView extends GradientCanvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _868055995topRow:ConstraintRow;
      
      private var _655255227centerRow:ConstraintRow;
      
      public var _MatchMapView_Canvas1:Canvas;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array;
      
      private var _mapSource:Class;
      
      protected var mapSourceChanged:Boolean = false;
      
      private var _1115259087header_c:GradientCanvas;
      
      protected var mapTitleChanged:Boolean = false;
      
      private var _mapTitle:String;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object;
      
      private var _gameMap:GameMap;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object;
      
      private var _12089446header_c_label:Label;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array;
      
      private var _158535007mapImage:Image;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public function MatchMapView()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":GradientCanvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":GradientCanvas,
                  "id":"header_c",
                  "stylesFactory":function():void
                  {
                     this.borderStyle = "none";
                     this.bottom = "topRow:0";
                     this.left = "0";
                     this.top = "0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "horizontalScrollPolicy":"off",
                        "styleName":"blueHeaderBackground",
                        "verticalScrollPolicy":"off",
                        "width":249,
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
                  "type":Canvas,
                  "id":"_MatchMapView_Canvas1",
                  "stylesFactory":function():void
                  {
                     this.top = "centerRow:6";
                     this.right = "6";
                     this.bottom = "6";
                     this.left = "6";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "styleName":"blueParchmentTablet",
                        "clipContent":true,
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":Image,
                           "id":"mapImage",
                           "stylesFactory":function():void
                           {
                              this.top = "0";
                              this.right = "0";
                              this.bottom = "0";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {"maintainAspectRatio":true};
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
         this.verticalScrollPolicy = "off";
         this.styleName = "blueParchmentTablet";
         this.cacheAsBitmap = true;
         this.constraintRows = [this._MatchMapView_ConstraintRow1_i(),this._MatchMapView_ConstraintRow2_i()];
         this.addEventListener("creationComplete",this.___MatchMapView_GradientCanvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         MatchMapView._watcherSetupUtil = param1;
      }
      
      private function _MatchMapView_ConstraintRow2_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.centerRow = _loc1_;
         _loc1_.percentHeight = 100;
         _loc1_.initialized(this,"centerRow");
         return _loc1_;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:MatchMapView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._MatchMapView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_controllers_game_views_MatchMapViewWatcherSetupUtil");
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
      
      public function get gameMap() : GameMap
      {
         return this._gameMap;
      }
      
      public function set gameMap(param1:GameMap) : void
      {
         if(this._gameMap == param1)
         {
            return;
         }
         this._gameMap = param1;
         this.setGameMap();
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
      
      public function get mapSource() : Class
      {
         return this._mapSource;
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
      
      public function set mapSource(param1:Class) : void
      {
         if(this._mapSource == param1)
         {
            return;
         }
         this._mapSource = param1;
         this.mapSourceChanged = true;
         invalidateProperties();
      }
      
      [Bindable(event="propertyChange")]
      public function get header_c() : GradientCanvas
      {
         return this._1115259087header_c;
      }
      
      private function onCreationComplete() : void
      {
         if(this.mapTitleChanged && Boolean(this.header_c_label))
         {
            this.setMapTitle();
            this.mapTitleChanged = false;
         }
         if(this.mapSourceChanged && Boolean(this.mapImage))
         {
            this.setMapSource();
            this.mapSourceChanged = false;
         }
      }
      
      private function _MatchMapView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.mapImage.source != null;
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
      
      public function set mapTitle(param1:String) : void
      {
         if(this._mapTitle == param1)
         {
            return;
         }
         this._mapTitle = param1;
         this.mapTitleChanged = true;
         invalidateProperties();
      }
      
      private function _MatchMapView_ConstraintRow1_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.topRow = _loc1_;
         _loc1_.height = 25;
         _loc1_.initialized(this,"topRow");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get centerRow() : ConstraintRow
      {
         return this._655255227centerRow;
      }
      
      public function setGameMap() : void
      {
         if(this.gameMap)
         {
            this.mapTitle = this.gameMap.displayName;
            this.mapSource = ImagePackLookup.instance.getMapSource(this.gameMap);
         }
         else
         {
            this.mapTitle = "";
            this.mapSource = null;
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.mapTitleChanged && Boolean(this.header_c_label))
         {
            this.setMapTitle();
            this.mapTitleChanged = false;
         }
         if(this.mapSourceChanged && Boolean(this.mapImage))
         {
            this.setMapSource();
            this.mapSourceChanged = false;
         }
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
      
      [Bindable(event="propertyChange")]
      public function get topRow() : ConstraintRow
      {
         return this._868055995topRow;
      }
      
      protected function setMapSource() : void
      {
         if(!this.mapImage)
         {
            return;
         }
         this.mapImage.source = this.mapSource;
      }
      
      public function ___MatchMapView_GradientCanvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      public function get mapTitle() : String
      {
         return this._mapTitle;
      }
      
      protected function setMapTitle() : void
      {
         if(!this.mapTitle)
         {
            return;
         }
         this.header_c_label.text = this.mapTitle;
      }
      
      [Bindable(event="propertyChange")]
      public function get mapImage() : Image
      {
         return this._158535007mapImage;
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
      
      private function _MatchMapView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Boolean
         {
            return mapImage.source != null;
         },function(param1:Boolean):void
         {
            _MatchMapView_Canvas1.visible = param1;
         },"_MatchMapView_Canvas1.visible");
         result[0] = binding;
         return result;
      }
   }
}

