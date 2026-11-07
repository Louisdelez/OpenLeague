package com.riotgames.platform.gameclient.components.summoner
{
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
   import mx.core.FlexBitmap;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   public class SummonerIcon extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object = {};
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array = [];
      
      private var _2096171365player_img:Image;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object = {};
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array = [];
      
      private var _586803091_iconSource:Object;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":Image,
               "id":"player_img",
               "stylesFactory":function():void
               {
                  this.horizontalCenter = "0";
                  this.verticalCenter = "0";
               },
               "propertiesFactory":function():Object
               {
                  return {"smoothBitmapContent":true};
               }
            })]};
         }
      });
      
      public function SummonerIcon()
      {
         super();
         mx_internal::_document = this;
         this.clipContent = false;
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         SummonerIcon._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      private function get _iconSource() : Object
      {
         return this._586803091_iconSource;
      }
      
      [Bindable(event="propertyChange")]
      public function get player_img() : Image
      {
         return this._2096171365player_img;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:SummonerIcon = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._SummonerIcon_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_components_summoner_SummonerIconWatcherSetupUtil");
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
      
      public function set player_img(param1:Image) : void
      {
         var _loc2_:Object = this._2096171365player_img;
         if(_loc2_ !== param1)
         {
            this._2096171365player_img = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"player_img",_loc2_,param1));
         }
      }
      
      private function set _iconSource(param1:Object) : void
      {
         var _loc2_:Object = this._586803091_iconSource;
         if(_loc2_ !== param1)
         {
            this._586803091_iconSource = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_iconSource",_loc2_,param1));
         }
      }
      
      private function _SummonerIcon_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Number
         {
            return Math.floor(this.height);
         },function(param1:Number):void
         {
            player_img.height = param1;
         },"player_img.height");
         result[0] = binding;
         binding = new Binding(this,function():Number
         {
            return Math.floor(this.width);
         },function(param1:Number):void
         {
            player_img.width = param1;
         },"player_img.width");
         result[1] = binding;
         binding = new Binding(this,function():Object
         {
            return this._iconSource;
         },function(param1:Object):void
         {
            player_img.source = param1;
         },"player_img.source");
         result[2] = binding;
         return result;
      }
      
      private function _SummonerIcon_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = Math.floor(this.height);
         _loc1_ = Math.floor(this.width);
         _loc1_ = this._iconSource;
      }
      
      public function set iconPath(param1:Object) : void
      {
         var _loc2_:BitmapData = null;
         if(param1 is BitmapData)
         {
            _loc2_ = BitmapData(param1);
            this._iconSource = new FlexBitmap(_loc2_,"auto",true);
         }
         else
         {
            this._iconSource = param1;
         }
         this.dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
      }
   }
}

