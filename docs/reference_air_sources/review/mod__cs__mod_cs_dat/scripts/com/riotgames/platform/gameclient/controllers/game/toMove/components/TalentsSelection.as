package com.riotgames.platform.gameclient.controllers.game.toMove.components
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
   import mx.controls.Button;
   import mx.core.Application;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   public class TalentsSelection extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static const TALENTS_FINISHED_EVENT:String = "talentsFinished";
      
      public var _TalentsSelection_Canvas2:Canvas;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object;
      
      private var _1770111376deactivated:Boolean;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array;
      
      private var _1058326740invitePlayersClose_btn:Button;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array;
      
      private var _488583240masteriesPage_c:ChampSelectMasteriesParentView;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public function TalentsSelection()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":Canvas,
                  "id":"_TalentsSelection_Canvas2",
                  "stylesFactory":function():void
                  {
                     this.verticalCenter = "0";
                     this.horizontalCenter = "0";
                     this.backgroundColor = 15592650;
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "width":1080,
                        "height":535,
                        "horizontalScrollPolicy":"off",
                        "verticalScrollPolicy":"off",
                        "styleName":"popupTablet",
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":ChampSelectMasteriesParentView,
                           "id":"masteriesPage_c",
                           "stylesFactory":function():void
                           {
                              this.verticalCenter = "0";
                              this.horizontalCenter = "0";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "height":535,
                                 "width":1050
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Button,
                           "id":"invitePlayersClose_btn",
                           "events":{"click":"__invitePlayersClose_btn_click"},
                           "stylesFactory":function():void
                           {
                              this.top = "4";
                              this.right = "4";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {"styleName":"chooseGameExitButton"};
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
            this.backgroundAlpha = 0.7;
            this.backgroundColor = 0;
         };
         this.cacheAsBitmap = true;
         this.addEventListener("initialize",this.___TalentsSelection_Canvas1_initialize);
         this.addEventListener("creationComplete",this.___TalentsSelection_Canvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         TalentsSelection._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get invitePlayersClose_btn() : Button
      {
         return this._1058326740invitePlayersClose_btn;
      }
      
      [Bindable(event="propertyChange")]
      public function get masteriesPage_c() : ChampSelectMasteriesParentView
      {
         return this._488583240masteriesPage_c;
      }
      
      private function onCloseClicked() : void
      {
         this.dispatchEvent(new Event(TALENTS_FINISHED_EVENT));
      }
      
      private function onInitialize() : void
      {
         this.deactivated = false;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:TalentsSelection = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._TalentsSelection_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_controllers_game_toMove_components_TalentsSelectionWatcherSetupUtil");
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
      
      private function _TalentsSelection_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Number
         {
            return (Application.application as DisplayObject).scaleX;
         },function(param1:Number):void
         {
            _TalentsSelection_Canvas2.scaleX = param1;
         },"_TalentsSelection_Canvas2.scaleX");
         result[0] = binding;
         binding = new Binding(this,function():Number
         {
            return (Application.application as DisplayObject).scaleY;
         },function(param1:Number):void
         {
            _TalentsSelection_Canvas2.scaleY = param1;
         },"_TalentsSelection_Canvas2.scaleY");
         result[1] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !this.deactivated;
         },function(param1:Boolean):void
         {
            masteriesPage_c.enabled = param1;
         },"masteriesPage_c.enabled");
         result[2] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !this.deactivated;
         },function(param1:Boolean):void
         {
            invitePlayersClose_btn.enabled = param1;
         },"invitePlayersClose_btn.enabled");
         result[3] = binding;
         return result;
      }
      
      public function __invitePlayersClose_btn_click(param1:MouseEvent) : void
      {
         this.onCloseClicked();
      }
      
      public function ___TalentsSelection_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      [Bindable(event="propertyChange")]
      private function get deactivated() : Boolean
      {
         return this._1770111376deactivated;
      }
      
      private function set deactivated(param1:Boolean) : void
      {
         var _loc2_:Object = this._1770111376deactivated;
         if(_loc2_ !== param1)
         {
            this._1770111376deactivated = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"deactivated",_loc2_,param1));
         }
      }
      
      private function onSaveSuccess() : void
      {
      }
      
      public function set masteriesPage_c(param1:ChampSelectMasteriesParentView) : void
      {
         var _loc2_:Object = this._488583240masteriesPage_c;
         if(_loc2_ !== param1)
         {
            this._488583240masteriesPage_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"masteriesPage_c",_loc2_,param1));
         }
      }
      
      public function set invitePlayersClose_btn(param1:Button) : void
      {
         var _loc2_:Object = this._1058326740invitePlayersClose_btn;
         if(_loc2_ !== param1)
         {
            this._1058326740invitePlayersClose_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"invitePlayersClose_btn",_loc2_,param1));
         }
      }
      
      private function _TalentsSelection_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = (Application.application as DisplayObject).scaleX;
         _loc1_ = (Application.application as DisplayObject).scaleY;
         _loc1_ = !this.deactivated;
         _loc1_ = !this.deactivated;
      }
      
      private function onCreationComplete() : void
      {
      }
      
      public function ___TalentsSelection_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      private function onTalentsSaved() : void
      {
         this.dispatchEvent(new Event(TALENTS_FINISHED_EVENT));
      }
   }
}

