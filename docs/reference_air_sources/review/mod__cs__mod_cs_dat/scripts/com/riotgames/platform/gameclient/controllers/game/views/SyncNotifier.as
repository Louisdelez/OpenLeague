package com.riotgames.platform.gameclient.controllers.game.views
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
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
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   public class SyncNotifier extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static const SYNCING_IMAGE:Class = SyncNotifier_SYNCING_IMAGE;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object = {};
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object = {};
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array = [];
      
      private var _1742521560syncImg:Image;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array = [];
      
      private var _122941533_isSynced:Boolean = false;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {
               "width":18,
               "height":18,
               "childDescriptors":[new UIComponentDescriptor({
                  "type":Image,
                  "id":"syncImg"
               })]
            };
         }
      });
      
      public function SyncNotifier()
      {
         super();
         mx_internal::_document = this;
         this.width = 18;
         this.height = 18;
         this.addEventListener("addedToStage",this.___SyncNotifier_Canvas1_addedToStage);
         this.addEventListener("removedFromStage",this.___SyncNotifier_Canvas1_removedFromStage);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         SyncNotifier._watcherSetupUtil = param1;
      }
      
      private function onRemoved() : void
      {
         if(this.syncImg)
         {
            this.syncImg.source = null;
         }
      }
      
      private function set _isSynced(param1:Boolean) : void
      {
         var _loc2_:Object = this._122941533_isSynced;
         if(_loc2_ !== param1)
         {
            this._122941533_isSynced = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_isSynced",_loc2_,param1));
         }
      }
      
      public function set isSynced(param1:Boolean) : void
      {
         this._isSynced = param1;
         this.update();
      }
      
      private function update() : void
      {
         if(Boolean(this.syncImg) && Boolean(parent))
         {
            if(this._isSynced)
            {
               this.syncImg.source = ImagePackLookup.instance.getClassFromSwfRef("e_checkbox".toUpperCase());
               this.syncImg.scaleX = 1;
               this.syncImg.scaleY = 1;
               this.syncImg.y = 3;
            }
            else
            {
               this.syncImg.source = SYNCING_IMAGE;
               this.syncImg.scaleX = 0.4;
               this.syncImg.scaleY = 0.4;
               this.syncImg.y = 0;
            }
         }
         else
         {
            this.onRemoved();
         }
      }
      
      public function ___SyncNotifier_Canvas1_addedToStage(param1:Event) : void
      {
         this.onAdded();
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:SyncNotifier = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._SyncNotifier_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_controllers_game_views_SyncNotifierWatcherSetupUtil");
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
      
      public function ___SyncNotifier_Canvas1_removedFromStage(param1:Event) : void
      {
         this.onRemoved();
      }
      
      private function _SyncNotifier_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this._isSynced ? RiotResourceLoader.getString("championSelection_SyncedTooltip") : RiotResourceLoader.getString("championSelection_SynchingTooltip");
      }
      
      private function onAdded() : void
      {
         this.update();
      }
      
      [Bindable(event="propertyChange")]
      private function get _isSynced() : Boolean
      {
         return this._122941533_isSynced;
      }
      
      [Bindable(event="propertyChange")]
      public function get syncImg() : Image
      {
         return this._1742521560syncImg;
      }
      
      private function _SyncNotifier_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = _isSynced ? RiotResourceLoader.getString("championSelection_SyncedTooltip") : RiotResourceLoader.getString("championSelection_SynchingTooltip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            this.toolTip = param1;
         },"this.toolTip");
         result[0] = binding;
         return result;
      }
      
      public function set syncImg(param1:Image) : void
      {
         var _loc2_:Object = this._1742521560syncImg;
         if(_loc2_ !== param1)
         {
            this._1742521560syncImg = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"syncImg",_loc2_,param1));
         }
      }
   }
}

