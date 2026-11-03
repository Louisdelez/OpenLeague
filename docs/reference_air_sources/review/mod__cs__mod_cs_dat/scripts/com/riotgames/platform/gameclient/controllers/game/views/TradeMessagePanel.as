package com.riotgames.platform.gameclient.controllers.game.views
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
   import mx.containers.VBox;
   import mx.controls.Label;
   import mx.controls.Text;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   public class TradeMessagePanel extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _954925063message:String;
      
      private var _128697948tradeMenuMessage:cs_tradeMenuMessage;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object = {};
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object = {};
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array = [];
      
      public var _TradeMessagePanel_Label1:Label;
      
      public var _TradeMessagePanel_Text1:Text;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array = [];
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {
               "width":300,
               "height":87,
               "childDescriptors":[new UIComponentDescriptor({
                  "type":cs_tradeMenuMessage,
                  "id":"tradeMenuMessage"
               }),new UIComponentDescriptor({
                  "type":VBox,
                  "stylesFactory":function():void
                  {
                     this.left = "50";
                     this.right = "10";
                     this.top = "5";
                     this.verticalGap = 5;
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "percentHeight":100,
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":Label,
                           "id":"_TradeMessagePanel_Label1",
                           "stylesFactory":function():void
                           {
                              this.textAlign = "center";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "percentWidth":100,
                                 "truncateToFit":true,
                                 "styleName":"tradeTitle"
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Text,
                           "id":"_TradeMessagePanel_Text1",
                           "stylesFactory":function():void
                           {
                              this.textAlign = "center";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "percentWidth":100,
                                 "selectable":false,
                                 "styleName":"tradeText"
                              };
                           }
                        })]
                     };
                  }
               })]
            };
         }
      });
      
      private var _110371416title:String;
      
      public function TradeMessagePanel()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.width = 300;
         this.height = 87;
         this.addEventListener("creationComplete",this.___TradeMessagePanel_Canvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         TradeMessagePanel._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get message() : String
      {
         return this._954925063message;
      }
      
      public function set tradeMenuMessage(param1:cs_tradeMenuMessage) : void
      {
         var _loc2_:Object = this._128697948tradeMenuMessage;
         if(_loc2_ !== param1)
         {
            this._128697948tradeMenuMessage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tradeMenuMessage",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:TradeMessagePanel = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._TradeMessagePanel_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_controllers_game_views_TradeMessagePanelWatcherSetupUtil");
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
      
      public function set message(param1:String) : void
      {
         var _loc2_:Object = this._954925063message;
         if(_loc2_ !== param1)
         {
            this._954925063message = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"message",_loc2_,param1));
         }
      }
      
      private function _TradeMessagePanel_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.title;
         _loc1_ = this.message;
      }
      
      public function ___TradeMessagePanel_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      [Bindable(event="propertyChange")]
      public function get title() : String
      {
         return this._110371416title;
      }
      
      [Bindable(event="propertyChange")]
      public function get tradeMenuMessage() : cs_tradeMenuMessage
      {
         return this._128697948tradeMenuMessage;
      }
      
      public function set title(param1:String) : void
      {
         var _loc2_:Object = this._110371416title;
         if(_loc2_ !== param1)
         {
            this._110371416title = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"title",_loc2_,param1));
         }
      }
      
      private function _TradeMessagePanel_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.title;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _TradeMessagePanel_Label1.text = param1;
         },"_TradeMessagePanel_Label1.text");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.message;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _TradeMessagePanel_Text1.text = param1;
         },"_TradeMessagePanel_Text1.text");
         result[1] = binding;
         return result;
      }
      
      private function onCreationComplete() : void
      {
      }
   }
}

