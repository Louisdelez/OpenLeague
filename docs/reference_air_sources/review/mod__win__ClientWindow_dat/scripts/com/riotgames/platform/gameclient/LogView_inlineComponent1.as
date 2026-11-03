package com.riotgames.platform.gameclient
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
   import mx.controls.Text;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class LogView_inlineComponent1 extends Text implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      private var _88844982outerDocument:LogView;
      
      public function LogView_inlineComponent1()
      {
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         if(!this.styleDeclaration)
         {
            this.styleDeclaration = new CSSStyleDeclaration();
         }
         this.styleDeclaration.defaultFactory = function():void
         {
            this.color = 0;
            this.paddingTop = 1;
            this.paddingBottom = 1;
         };
         this.percentWidth = 100;
         this.percentHeight = 100;
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         LogView_inlineComponent1._watcherSetupUtil = param1;
      }
      
      public function set outerDocument(param1:LogView) : void
      {
         var _loc2_:Object = this._88844982outerDocument;
         if(_loc2_ !== param1)
         {
            this._88844982outerDocument = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"outerDocument",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get outerDocument() : LogView
      {
         return this._88844982outerDocument;
      }
      
      private function _LogView_inlineComponent1_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = data.toString();
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            this.htmlText = param1;
         },"this.htmlText");
         result[0] = binding;
         return result;
      }
      
      override public function initialize() : void
      {
         var i:uint;
         var target:LogView_inlineComponent1 = null;
         var watcherSetupUtilClass:Object = null;
         var bindings:Array = this._LogView_inlineComponent1_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_LogView_inlineComponent1WatcherSetupUtil");
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
      
      private function _LogView_inlineComponent1_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = data.toString();
      }
   }
}

