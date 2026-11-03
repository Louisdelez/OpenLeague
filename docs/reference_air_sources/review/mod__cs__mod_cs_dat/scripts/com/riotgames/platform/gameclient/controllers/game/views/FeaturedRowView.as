package com.riotgames.platform.gameclient.controllers.game.views
{
   import blix.assets.proxy.DisplayAdapter;
   import com.riotgames.platform.gameclient.components.containers.GradientCanvas;
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
   import mx.core.UIComponent;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   public class FeaturedRowView extends GradientCanvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _868055995topRow:ConstraintRow;
      
      private var _655255227centerRow:ConstraintRow;
      
      public var _FeaturedRowView_Label1:Label;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object;
      
      private var _1166031975headerLabel:String;
      
      private var _1115259087header_c:GradientCanvas;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object;
      
      private var _featuredContentComponent:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      private var _1707945992contentContainer:Canvas;
      
      public function FeaturedRowView()
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
                     this.right = "0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "horizontalScrollPolicy":"off",
                        "styleName":"blueHeaderBackground",
                        "verticalScrollPolicy":"off",
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":Label,
                           "id":"_FeaturedRowView_Label1",
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
                  "id":"contentContainer",
                  "events":{"initialize":"__contentContainer_initialize"},
                  "stylesFactory":function():void
                  {
                     this.top = "centerRow:0";
                     this.right = "0";
                     this.bottom = "0";
                     this.left = "0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"clipContent":true};
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
         this.constraintRows = [this._FeaturedRowView_ConstraintRow1_i(),this._FeaturedRowView_ConstraintRow2_i()];
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         FeaturedRowView._watcherSetupUtil = param1;
      }
      
      private function _FeaturedRowView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = headerLabel;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _FeaturedRowView_Label1.text = param1;
         },"_FeaturedRowView_Label1.text");
         result[0] = binding;
         return result;
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
      
      private function _FeaturedRowView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.headerLabel;
      }
      
      public function __contentContainer_initialize(param1:FlexEvent) : void
      {
         this.onContentContainerInitialized();
      }
      
      [Bindable(event="propertyChange")]
      public function get contentContainer() : Canvas
      {
         return this._1707945992contentContainer;
      }
      
      private function _FeaturedRowView_ConstraintRow1_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.topRow = _loc1_;
         _loc1_.height = 25;
         _loc1_.initialized(this,"topRow");
         return _loc1_;
      }
      
      private function _FeaturedRowView_ConstraintRow2_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.centerRow = _loc1_;
         _loc1_.percentHeight = 100;
         _loc1_.initialized(this,"centerRow");
         return _loc1_;
      }
      
      private function onContentContainerInitialized() : void
      {
         this.addFeaturedContentComponent();
      }
      
      public function set headerLabel(param1:String) : void
      {
         var _loc2_:Object = this._1166031975headerLabel;
         if(_loc2_ !== param1)
         {
            this._1166031975headerLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"headerLabel",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:FeaturedRowView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._FeaturedRowView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_controllers_game_views_FeaturedRowViewWatcherSetupUtil");
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
      
      private function addFeaturedContentComponent() : void
      {
         var _loc1_:UIComponent = null;
         var _loc2_:DisplayAdapter = null;
         if(Boolean(this.contentContainer.initialized) && this._featuredContentComponent != null)
         {
            _loc1_ = new UIComponent();
            _loc2_ = new DisplayAdapter(_loc1_);
            _loc2_.addChild(this._featuredContentComponent);
            this.contentContainer.addChild(_loc1_);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get centerRow() : ConstraintRow
      {
         return this._655255227centerRow;
      }
      
      [Bindable(event="propertyChange")]
      public function get headerLabel() : String
      {
         return this._1166031975headerLabel;
      }
      
      public function set featuredContentComponent(param1:Object) : void
      {
         if(this.contentContainer.initialized)
         {
            this.contentContainer.removeAllChildren();
         }
         this._featuredContentComponent = param1;
         this.addFeaturedContentComponent();
      }
      
      public function set contentContainer(param1:Canvas) : void
      {
         var _loc2_:Object = this._1707945992contentContainer;
         if(_loc2_ !== param1)
         {
            this._1707945992contentContainer = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"contentContainer",_loc2_,param1));
         }
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
      public function get topRow() : ConstraintRow
      {
         return this._868055995topRow;
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
      
      [Bindable(event="propertyChange")]
      public function get header_c() : GradientCanvas
      {
         return this._1115259087header_c;
      }
      
      public function clearFeaturedContentComponent() : void
      {
         if(this.contentContainer.initialized)
         {
            this.contentContainer.removeAllChildren();
         }
      }
   }
}

