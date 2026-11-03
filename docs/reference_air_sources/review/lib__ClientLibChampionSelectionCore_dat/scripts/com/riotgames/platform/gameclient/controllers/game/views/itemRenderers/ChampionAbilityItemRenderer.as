package com.riotgames.platform.gameclient.controllers.game.views.itemRenderers
{
   import com.riotgames.platform.common.ImagePackLookup;
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
   import mx.controls.Image;
   import mx.controls.Text;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   public class ChampionAbilityItemRenderer extends GradientCanvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _285988654ability_img:Image;
      
      private var _13610857separator_img:Image;
      
      private var _986191789description_txt:Text;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array;
      
      private var _1840918204name_txt:Text;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public function ChampionAbilityItemRenderer()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":GradientCanvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":Text,
                  "id":"name_txt",
                  "stylesFactory":function():void
                  {
                     this.fontWeight = "normal";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "percentWidth":100,
                        "styleName":"championAbilityItemName",
                        "x":2
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Image,
                  "id":"ability_img",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "x":2,
                        "y":22,
                        "width":48,
                        "height":48
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Image,
                  "id":"separator_img",
                  "propertiesFactory":function():Object
                  {
                     return {"y":22};
                  }
               }),new UIComponentDescriptor({
                  "type":Text,
                  "id":"description_txt",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "styleName":"championAbilityItemDescription",
                        "percentWidth":100
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
            this.borderColor = 13421772;
            this.borderStyle = "solid";
            this.borderThickness = 1;
         };
         this.percentWidth = 100;
         this.percentHeight = 100;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.addEventListener("creationComplete",this.___ChampionAbilityItemRenderer_GradientCanvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         ChampionAbilityItemRenderer._watcherSetupUtil = param1;
      }
      
      private function _ChampionAbilityItemRenderer_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.data.name;
         _loc1_ = this.data.iconSource;
         _loc1_ = this.ability_img.x + this.ability_img.width + 5;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_championQuickViewSeparator");
         _loc1_ = this.separator_img.x;
         _loc1_ = this.separator_img.y + this.separator_img.height + 3;
         _loc1_ = this.data.description;
      }
      
      private function _ChampionAbilityItemRenderer_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.data.name;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            name_txt.text = param1;
         },"name_txt.text");
         result[0] = binding;
         binding = new Binding(this,function():Object
         {
            return this.data.iconSource;
         },function(param1:Object):void
         {
            ability_img.source = param1;
         },"ability_img.source");
         result[1] = binding;
         binding = new Binding(this,function():Number
         {
            return this.ability_img.x + this.ability_img.width + 5;
         },function(param1:Number):void
         {
            separator_img.x = param1;
         },"separator_img.x");
         result[2] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_championQuickViewSeparator");
         },function(param1:Object):void
         {
            separator_img.source = param1;
         },"separator_img.source");
         result[3] = binding;
         binding = new Binding(this,function():Number
         {
            return this.separator_img.x;
         },function(param1:Number):void
         {
            description_txt.x = param1;
         },"description_txt.x");
         result[4] = binding;
         binding = new Binding(this,function():Number
         {
            return this.separator_img.y + this.separator_img.height + 3;
         },function(param1:Number):void
         {
            description_txt.y = param1;
         },"description_txt.y");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.data.description;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            description_txt.htmlText = param1;
         },"description_txt.htmlText");
         result[6] = binding;
         return result;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:ChampionAbilityItemRenderer = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._ChampionAbilityItemRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_controllers_game_views_itemRenderers_ChampionAbilityItemRendererWatcherSetupUtil");
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
      
      public function set separator_img(param1:Image) : void
      {
         var _loc2_:Object = this._13610857separator_img;
         if(_loc2_ !== param1)
         {
            this._13610857separator_img = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"separator_img",_loc2_,param1));
         }
      }
      
      public function ___ChampionAbilityItemRenderer_GradientCanvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      public function set ability_img(param1:Image) : void
      {
         var _loc2_:Object = this._285988654ability_img;
         if(_loc2_ !== param1)
         {
            this._285988654ability_img = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ability_img",_loc2_,param1));
         }
      }
      
      public function set description_txt(param1:Text) : void
      {
         var _loc2_:Object = this._986191789description_txt;
         if(_loc2_ !== param1)
         {
            this._986191789description_txt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"description_txt",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get separator_img() : Image
      {
         return this._13610857separator_img;
      }
      
      [Bindable(event="propertyChange")]
      public function get ability_img() : Image
      {
         return this._285988654ability_img;
      }
      
      [Bindable(event="propertyChange")]
      public function get description_txt() : Text
      {
         return this._986191789description_txt;
      }
      
      private function onCreationComplete() : void
      {
         this.setStyle("fillAlphas",[1,1]);
         this.setStyle("fillColors",[3355443,0]);
      }
      
      public function set name_txt(param1:Text) : void
      {
         var _loc2_:Object = this._1840918204name_txt;
         if(_loc2_ !== param1)
         {
            this._1840918204name_txt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"name_txt",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get name_txt() : Text
      {
         return this._1840918204name_txt;
      }
   }
}

