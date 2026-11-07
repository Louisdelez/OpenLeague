package com.riotgames.platform.gameclient.views.partner
{
   import com.riotgames.platform.gameclient.domain.partner.AntiIndulgenceMessage;
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
   import mx.controls.Text;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class AntiIndulgenceWarningView extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _antiIndulgenceMessage:AntiIndulgenceMessage;
      
      mx_internal var _bindings:Array = [];
      
      private var _1137004143antiIndulgence_txt:Text;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":Text,
               "id":"antiIndulgence_txt",
               "stylesFactory":function():void
               {
                  this.fontFamily = "ApplicationFont1";
                  this.fontSize = 32;
                  this.color = 16711680;
                  this.horizontalCenter = "0";
                  this.textAlign = "center";
               },
               "propertiesFactory":function():Object
               {
                  return {"percentWidth":90};
               }
            })]};
         }
      });
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      mx_internal var _watchers:Array = [];
      
      public function AntiIndulgenceWarningView()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.mouseChildren = false;
         this.mouseEnabled = false;
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         AntiIndulgenceWarningView._watcherSetupUtil = param1;
      }
      
      private function set _1145824663antiIndulgenceMessage(param1:AntiIndulgenceMessage) : void
      {
         this._antiIndulgenceMessage = param1;
         if(this.antiIndulgence_txt != null)
         {
            this.antiIndulgence_txt.percentWidth += 1;
            --this.antiIndulgence_txt.percentWidth;
         }
      }
      
      private function _AntiIndulgenceWarningView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.antiIndulgenceMessage != null;
         _loc1_ = resourceManager.getString("resources",this.antiIndulgenceMessage.messageKey,[this.antiIndulgenceMessage.messageArgument]);
      }
      
      public function get antiIndulgenceMessage() : AntiIndulgenceMessage
      {
         return this._antiIndulgenceMessage;
      }
      
      [Bindable(event="propertyChange")]
      public function get antiIndulgence_txt() : Text
      {
         return this._1137004143antiIndulgence_txt;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:AntiIndulgenceWarningView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._AntiIndulgenceWarningView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_partner_AntiIndulgenceWarningViewWatcherSetupUtil");
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
      
      [Bindable(event="propertyChange")]
      public function set antiIndulgenceMessage(param1:AntiIndulgenceMessage) : void
      {
         var _loc2_:Object = this.antiIndulgenceMessage;
         if(_loc2_ !== param1)
         {
            this._1145824663antiIndulgenceMessage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"antiIndulgenceMessage",_loc2_,param1));
         }
      }
      
      private function _AntiIndulgenceWarningView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Boolean
         {
            return this.antiIndulgenceMessage != null;
         },function(param1:Boolean):void
         {
            this.visible = param1;
         },"this.visible");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources",this.antiIndulgenceMessage.messageKey,[this.antiIndulgenceMessage.messageArgument]);
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            antiIndulgence_txt.htmlText = param1;
         },"antiIndulgence_txt.htmlText");
         result[1] = binding;
         return result;
      }
      
      public function set antiIndulgence_txt(param1:Text) : void
      {
         var _loc2_:Object = this._1137004143antiIndulgence_txt;
         if(_loc2_ !== param1)
         {
            this._1137004143antiIndulgence_txt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"antiIndulgence_txt",_loc2_,param1));
         }
      }
   }
}

