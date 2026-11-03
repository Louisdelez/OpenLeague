package com.riotgames.platform.gameclient.controllers.game.views
{
   import com.riotgames.platform.gameclient.domain.ItemEffect;
   import com.riotgames.platform.gameclient.domain.ItemEffectHelper;
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
   import mx.containers.VBox;
   import mx.controls.HRule;
   import mx.controls.Spacer;
   import mx.controls.Text;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   public class RuneStatsTooltip_inlineComponent1 extends VBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object;
      
      public var _RuneStatsTooltip_inlineComponent1_Text2:Text;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array;
      
      private var _88844982outerDocument:RuneStatsTooltip;
      
      private var _1317513983statName:Text;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public function RuneStatsTooltip_inlineComponent1()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":VBox,
            "propertiesFactory":function():Object
            {
               return {
                  "height":50,
                  "childDescriptors":[new UIComponentDescriptor({
                     "type":Text,
                     "id":"statName",
                     "stylesFactory":function():void
                     {
                        this.textAlign = "left";
                        this.color = 0;
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "percentWidth":100,
                           "styleName":"runeStatsStatName",
                           "selectable":false
                        };
                     }
                  }),new UIComponentDescriptor({
                     "type":Text,
                     "id":"_RuneStatsTooltip_inlineComponent1_Text2",
                     "stylesFactory":function():void
                     {
                        this.right = "0";
                        this.left = "0";
                        this.textAlign = "left";
                        this.color = 0;
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "styleName":"summonerStatsTextSmall",
                           "selectable":false
                        };
                     }
                  }),new UIComponentDescriptor({
                     "type":Spacer,
                     "propertiesFactory":function():Object
                     {
                        return {"height":4};
                     }
                  }),new UIComponentDescriptor({
                     "type":HRule,
                     "propertiesFactory":function():Object
                     {
                        return {
                           "percentWidth":99,
                           "styleName":"parchment"
                        };
                     }
                  })]
               };
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
            this.verticalGap = -2;
            this.verticalAlign = "middle";
         };
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.height = 50;
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         RuneStatsTooltip_inlineComponent1._watcherSetupUtil = param1;
      }
      
      private function _RuneStatsTooltip_inlineComponent1_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = data.displayName;
         _loc1_ = "+ " + ItemEffectHelper.getValueFormattingForItemEffect(data as ItemEffect);
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:RuneStatsTooltip_inlineComponent1 = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._RuneStatsTooltip_inlineComponent1_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_controllers_game_views_RuneStatsTooltip_inlineComponent1WatcherSetupUtil");
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
      
      private function _RuneStatsTooltip_inlineComponent1_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = data.displayName;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            statName.text = param1;
         },"statName.text");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = "+ " + ItemEffectHelper.getValueFormattingForItemEffect(data as ItemEffect);
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _RuneStatsTooltip_inlineComponent1_Text2.htmlText = param1;
         },"_RuneStatsTooltip_inlineComponent1_Text2.htmlText");
         result[1] = binding;
         return result;
      }
      
      public function set outerDocument(param1:RuneStatsTooltip) : void
      {
         var _loc2_:Object = this._88844982outerDocument;
         if(_loc2_ !== param1)
         {
            this._88844982outerDocument = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"outerDocument",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get outerDocument() : RuneStatsTooltip
      {
         return this._88844982outerDocument;
      }
      
      public function set statName(param1:Text) : void
      {
         var _loc2_:Object = this._1317513983statName;
         if(_loc2_ !== param1)
         {
            this._1317513983statName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statName",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get statName() : Text
      {
         return this._1317513983statName;
      }
   }
}

