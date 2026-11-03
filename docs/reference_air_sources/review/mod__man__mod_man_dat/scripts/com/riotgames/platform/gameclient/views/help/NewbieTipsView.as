package com.riotgames.platform.gameclient.views.help
{
   import com.riotgames.platform.gameclient.controllers.help.NewbieTipsController;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
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
   import mx.binding.utils.ChangeWatcher;
   import mx.containers.Canvas;
   import mx.controls.Button;
   import mx.controls.CheckBox;
   import mx.controls.Label;
   import mx.controls.Text;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class NewbieTipsView extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public var _NewbieTipsView_Label2:Label;
      
      private var _1311656856tipText:Text;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      private var _714097634toggleOff_chk:CheckBox;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _watchers:Array;
      
      private var _1166031975headerLabel:Label;
      
      [Inject]
      private var _1295553550newbieTipsController:NewbieTipsController;
      
      mx_internal var _bindings:Array;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public function NewbieTipsView()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {
                  "width":260,
                  "height":135,
                  "childDescriptors":[new UIComponentDescriptor({
                     "type":Button,
                     "events":{"click":"___NewbieTipsView_Button1_click"},
                     "stylesFactory":function():void
                     {
                        this.top = "0";
                        this.right = "0";
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "buttonMode":true,
                           "styleName":"chooseGameExitButton"
                        };
                     }
                  }),new UIComponentDescriptor({
                     "type":Label,
                     "id":"headerLabel",
                     "stylesFactory":function():void
                     {
                        this.top = "5";
                        this.left = "1";
                        this.right = "25";
                        this.textAlign = "center";
                     },
                     "propertiesFactory":function():Object
                     {
                        return {"styleName":"newbieTipHeaderText"};
                     }
                  }),new UIComponentDescriptor({
                     "type":Text,
                     "id":"tipText",
                     "stylesFactory":function():void
                     {
                        this.textAlign = "left";
                        this.horizontalCenter = "0";
                        this.top = "35";
                        this.bottom = "20";
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "percentWidth":98,
                           "styleName":"newbieTipText",
                           "selectable":false
                        };
                     }
                  }),new UIComponentDescriptor({
                     "type":ListLineDivider,
                     "propertiesFactory":function():Object
                     {
                        return {
                           "percentWidth":90,
                           "horizontalCenter":0,
                           "bottom":20
                        };
                     }
                  }),new UIComponentDescriptor({
                     "type":Label,
                     "id":"_NewbieTipsView_Label2",
                     "stylesFactory":function():void
                     {
                        this.left = "1";
                        this.bottom = "1";
                        this.textAlign = "right";
                     },
                     "propertiesFactory":function():Object
                     {
                        return {"styleName":"newbieTipFooter"};
                     }
                  }),new UIComponentDescriptor({
                     "type":CheckBox,
                     "id":"toggleOff_chk",
                     "events":{"change":"__toggleOff_chk_change"},
                     "stylesFactory":function():void
                     {
                        this.right = "5";
                        this.bottom = "4";
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
            this.backgroundAlpha = 1;
            this.cornerRadius = 5;
         };
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "auto";
         this.verticalScrollPolicy = "off";
         this.styleName = "stoneTablet";
         this.width = 260;
         this.height = 135;
         this.addEventListener("keyUp",this.___NewbieTipsView_Canvas1_keyUp);
         this.addEventListener("mouseDown",this.___NewbieTipsView_Canvas1_mouseDown);
         this.addEventListener("mouseUp",this.___NewbieTipsView_Canvas1_mouseUp);
         this.addEventListener("addedToStage",this.___NewbieTipsView_Canvas1_addedToStage);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         NewbieTipsView._watcherSetupUtil = param1;
      }
      
      private function onKey(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ESCAPE)
         {
            this.onClosePressed();
         }
      }
      
      private function onMouseUp() : void
      {
         this.stopDrag();
      }
      
      public function set toggleOff_chk(param1:CheckBox) : void
      {
         var _loc2_:Object = this._714097634toggleOff_chk;
         if(_loc2_ !== param1)
         {
            this._714097634toggleOff_chk = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"toggleOff_chk",_loc2_,param1));
         }
      }
      
      private function onMouseDown() : void
      {
         this.startDrag();
      }
      
      private function onTipsToggleChanged() : void
      {
         UserPreferencesManager.userPrefs.newbieTipsEnabled = !this.toggleOff_chk.selected;
         if(this.toggleOff_chk.selected)
         {
            this.onClosePressed();
         }
      }
      
      public function set headerLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1166031975headerLabel;
         if(_loc2_ !== param1)
         {
            this._1166031975headerLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"headerLabel",_loc2_,param1));
         }
      }
      
      private function onClosePressed() : void
      {
         var _loc1_:Number = Number(this.x);
         var _loc2_:Number = Number(this.y);
         this.newbieTipsController.closeTip();
      }
      
      private function _NewbieTipsView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Boolean
         {
            return this.newbieTipsController.isOpen;
         },function(param1:Boolean):void
         {
            this.visible = param1;
         },"this.visible");
         result[0] = binding;
         binding = new Binding(this,function():Number
         {
            return this.newbieTipsController.xPos;
         },function(param1:Number):void
         {
            this.x = param1;
         },"this.x");
         result[1] = binding;
         binding = new Binding(this,function():Number
         {
            return this.newbieTipsController.yPos;
         },function(param1:Number):void
         {
            this.y = param1;
         },"this.y");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.newbieTipsController.tipHeader;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            headerLabel.text = param1;
         },"headerLabel.text");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.newbieTipsController.tipContent;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            tipText.text = param1;
         },"tipText.text");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = toggleOff_chk.width + 15;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _NewbieTipsView_Label2.setStyle("right",param1);
         },"_NewbieTipsView_Label2.right");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","newbieTip_footer_toggleOff");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _NewbieTipsView_Label2.text = param1;
         },"_NewbieTipsView_Label2.text");
         result[6] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !UserPreferencesManager.userPrefs.newbieTipsEnabled;
         },function(param1:Boolean):void
         {
            toggleOff_chk.selected = param1;
         },"toggleOff_chk.selected");
         result[7] = binding;
         return result;
      }
      
      public function ___NewbieTipsView_Button1_click(param1:MouseEvent) : void
      {
         this.onClosePressed();
      }
      
      public function __toggleOff_chk_change(param1:Event) : void
      {
         this.onTipsToggleChanged();
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:NewbieTipsView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._NewbieTipsView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_help_NewbieTipsViewWatcherSetupUtil");
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
      
      private function _NewbieTipsView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.newbieTipsController.isOpen;
         _loc1_ = this.newbieTipsController.xPos;
         _loc1_ = this.newbieTipsController.yPos;
         _loc1_ = this.newbieTipsController.tipHeader;
         _loc1_ = this.newbieTipsController.tipContent;
         _loc1_ = this.toggleOff_chk.width + 15;
         _loc1_ = resourceManager.getString("resources","newbieTip_footer_toggleOff");
         _loc1_ = !UserPreferencesManager.userPrefs.newbieTipsEnabled;
      }
      
      [Bindable(event="propertyChange")]
      public function get toggleOff_chk() : CheckBox
      {
         return this._714097634toggleOff_chk;
      }
      
      public function set newbieTipsController(param1:NewbieTipsController) : void
      {
         var _loc2_:Object = this._1295553550newbieTipsController;
         if(_loc2_ !== param1)
         {
            this._1295553550newbieTipsController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"newbieTipsController",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get headerLabel() : Label
      {
         return this._1166031975headerLabel;
      }
      
      [Bindable(event="propertyChange")]
      public function get tipText() : Text
      {
         return this._1311656856tipText;
      }
      
      public function ___NewbieTipsView_Canvas1_addedToStage(param1:Event) : void
      {
         this.onInjection();
      }
      
      public function ___NewbieTipsView_Canvas1_keyUp(param1:KeyboardEvent) : void
      {
         this.onKey(param1);
      }
      
      public function set tipText(param1:Text) : void
      {
         var _loc2_:Object = this._1311656856tipText;
         if(_loc2_ !== param1)
         {
            this._1311656856tipText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tipText",_loc2_,param1));
         }
      }
      
      public function ___NewbieTipsView_Canvas1_mouseUp(param1:MouseEvent) : void
      {
         this.onMouseUp();
      }
      
      private function onInjection() : void
      {
         ChangeWatcher.watch(this.newbieTipsController,"xPos",this.onPosChanged);
         ChangeWatcher.watch(this.newbieTipsController,"yPos",this.onPosChanged);
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get newbieTipsController() : NewbieTipsController
      {
         return this._1295553550newbieTipsController;
      }
      
      public function ___NewbieTipsView_Canvas1_mouseDown(param1:MouseEvent) : void
      {
         this.onMouseDown();
      }
      
      private function onPosChanged(param1:PropertyChangeEvent) : void
      {
         this.tipText.x = this.newbieTipsController.xPos;
         this.tipText.y = this.newbieTipsController.yPos;
      }
   }
}

