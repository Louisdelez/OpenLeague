package com.riotgames.platform.gameclient.views.lobby
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.domain.game.GamePropertiesListData;
   import com.riotgames.pvpnet.game.variants.GameFlowVariant;
   import com.riotgames.pvpnet.game.variants.GameFlowVariantFactory;
   import com.riotgames.util.string.RiotStringUtil;
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
   import mx.controls.Label;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.StateChangeEvent;
   import mx.states.State;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class ChooseGameOptionsRepeatedRenderer extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static const OPTION_LIST_SINGLE_LINE_ITEM_SELECTED:Class = ChooseGameOptionsRepeatedRenderer_OPTION_LIST_SINGLE_LINE_ITEM_SELECTED;
      
      public static const OPTION_LIST_SINGLE_LINE_ITEM_OVER:Class = ChooseGameOptionsRepeatedRenderer_OPTION_LIST_SINGLE_LINE_ITEM_OVER;
      
      public static const OPTION_LIST_DOUBLE_LINE_ITEM_SELECTED:Class = ChooseGameOptionsRepeatedRenderer_OPTION_LIST_DOUBLE_LINE_ITEM_SELECTED;
      
      public static const OPTION_LIST_DOUBLE_LINE_ITEM_OVER:Class = ChooseGameOptionsRepeatedRenderer_OPTION_LIST_DOUBLE_LINE_ITEM_OVER;
      
      public static const LOCK_ICON:Class = ChooseGameOptionsRepeatedRenderer_LOCK_ICON;
      
      public static const UP:String = "up";
      
      public static const OVER:String = "over";
      
      public static const SELECTED:String = "selected";
      
      public var _ChooseGameOptionsRepeatedRenderer_State1:State;
      
      public var _ChooseGameOptionsRepeatedRenderer_State2:State;
      
      public var _ChooseGameOptionsRepeatedRenderer_State3:State;
      
      private var _1292595405backgroundImage:Image;
      
      mx_internal var _watchers:Array;
      
      private var _1220155939titleIconOverride:Image;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public var index:int;
      
      mx_internal var _bindings:Array;
      
      private var _943105161lockIconImage:Image;
      
      private var _1672427580item_subtitle:Label;
      
      private var _1951390164item_title:Label;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      private var lines:int = 1;
      
      public function ChooseGameOptionsRepeatedRenderer()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":Image,
                  "id":"backgroundImage",
                  "propertiesFactory":function():Object
                  {
                     return {"percentHeight":100};
                  }
               }),new UIComponentDescriptor({
                  "type":Image,
                  "id":"titleIconOverride",
                  "stylesFactory":function():void
                  {
                     this.verticalAlign = "middle";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "percentHeight":100,
                        "scaleContent":false,
                        "maintainAspectRatio":true,
                        "y":1,
                        "x":2,
                        "visible":false
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Label,
                  "id":"item_title",
                  "stylesFactory":function():void
                  {
                     this.fontSize = 15;
                     this.textAlign = "left";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "width":186,
                        "truncateToFit":true,
                        "styleName":"gameOptionsTitleText",
                        "y":1,
                        "x":2,
                        "selectable":false
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Label,
                  "id":"item_subtitle",
                  "stylesFactory":function():void
                  {
                     this.fontSize = 13;
                     this.textAlign = "left";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "width":186,
                        "truncateToFit":true,
                        "styleName":"gameOptionsSubTitleText",
                        "y":19,
                        "x":2,
                        "selectable":false
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Image,
                  "id":"lockIconImage",
                  "stylesFactory":function():void
                  {
                     this.right = "3";
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
            this.backgroundColor = 0;
         };
         this.percentWidth = 100;
         this.verticalScrollPolicy = "off";
         this.horizontalScrollPolicy = "off";
         this.states = [this._ChooseGameOptionsRepeatedRenderer_State1_i(),this._ChooseGameOptionsRepeatedRenderer_State2_i(),this._ChooseGameOptionsRepeatedRenderer_State3_i()];
         this.addEventListener("dataChange",this.___ChooseGameOptionsRepeatedRenderer_Canvas1_dataChange);
         this.addEventListener("currentStateChange",this.___ChooseGameOptionsRepeatedRenderer_Canvas1_currentStateChange);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         ChooseGameOptionsRepeatedRenderer._watcherSetupUtil = param1;
      }
      
      private function verifyHeight() : void
      {
         if(this.item_subtitle.text == "")
         {
            if(this.currentState == OVER)
            {
               this.backgroundImage.source = OPTION_LIST_SINGLE_LINE_ITEM_OVER;
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lockIconImage() : Image
      {
         return this._943105161lockIconImage;
      }
      
      public function set item_subtitle(param1:Label) : void
      {
         var _loc2_:Object = this._1672427580item_subtitle;
         if(_loc2_ !== param1)
         {
            this._1672427580item_subtitle = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"item_subtitle",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:ChooseGameOptionsRepeatedRenderer = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._ChooseGameOptionsRepeatedRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_lobby_ChooseGameOptionsRepeatedRendererWatcherSetupUtil");
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
      
      public function ___ChooseGameOptionsRepeatedRenderer_Canvas1_dataChange(param1:FlexEvent) : void
      {
         this.init();
      }
      
      public function set backgroundImage(param1:Image) : void
      {
         var _loc2_:Object = this._1292595405backgroundImage;
         if(_loc2_ !== param1)
         {
            this._1292595405backgroundImage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"backgroundImage",_loc2_,param1));
         }
      }
      
      private function applyVariants(param1:GamePropertiesListData) : void
      {
         var _loc2_:GameFlowVariant = GameFlowVariantFactory.instance.getVariantForGameKey(param1.gameKey);
         var _loc3_:String = _loc2_.getGameFlowQueueTitleIcon();
         if(!RiotStringUtil.isEmpty(_loc3_))
         {
            this.titleIconOverride.source = ImagePackLookup.instance.getClassFromSwfRef(_loc3_);
            this.titleIconOverride.visible = true;
            this.item_title.visible = this.item_subtitle.visible = false;
         }
         else
         {
            this.titleIconOverride.visible = false;
            this.item_title.visible = this.item_subtitle.visible = true;
         }
         var _loc4_:uint = uint(_loc2_.getGameFlowOptionsColor(param1.isAspirational));
         this.item_title.setStyle("color",_loc4_);
         this.item_subtitle.setStyle("color",_loc4_);
      }
      
      protected function onCurrentStateChange(param1:StateChangeEvent) : void
      {
      }
      
      private function init() : void
      {
         var _loc1_:GamePropertiesListData = null;
         if(this.data)
         {
            _loc1_ = this.data as GamePropertiesListData;
            this.item_title.text = _loc1_.displayTitle;
            if(_loc1_.subTitle != "")
            {
               this.height = 40;
               this.lines = 2;
               this.item_subtitle.text = _loc1_.subTitle;
            }
            else
            {
               this.item_subtitle.text = "";
               this.lines = 1;
               this.height = 26;
            }
            if(_loc1_.isAspirational)
            {
               this.toolTip = _loc1_.aspirationalToolTip;
               this.lockIconImage.visible = true;
            }
            else
            {
               this.toolTip = _loc1_.toolTip;
               this.lockIconImage.visible = false;
            }
            this.applyVariants(_loc1_);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get item_title() : Label
      {
         return this._1951390164item_title;
      }
      
      private function _ChooseGameOptionsRepeatedRenderer_State2_i() : State
      {
         var _loc1_:State = new State();
         this._ChooseGameOptionsRepeatedRenderer_State2 = _loc1_;
         BindingManager.executeBindings(this,"_ChooseGameOptionsRepeatedRenderer_State2",this._ChooseGameOptionsRepeatedRenderer_State2);
         return _loc1_;
      }
      
      public function set titleIconOverride(param1:Image) : void
      {
         var _loc2_:Object = this._1220155939titleIconOverride;
         if(_loc2_ !== param1)
         {
            this._1220155939titleIconOverride = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"titleIconOverride",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get item_subtitle() : Label
      {
         return this._1672427580item_subtitle;
      }
      
      private function _ChooseGameOptionsRepeatedRenderer_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = UP;
         _loc1_ = OVER;
         _loc1_ = SELECTED;
         _loc1_ = LOCK_ICON;
      }
      
      [Bindable(event="propertyChange")]
      public function get backgroundImage() : Image
      {
         return this._1292595405backgroundImage;
      }
      
      public function set item_title(param1:Label) : void
      {
         var _loc2_:Object = this._1951390164item_title;
         if(_loc2_ !== param1)
         {
            this._1951390164item_title = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"item_title",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get titleIconOverride() : Image
      {
         return this._1220155939titleIconOverride;
      }
      
      private function _ChooseGameOptionsRepeatedRenderer_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = UP;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ChooseGameOptionsRepeatedRenderer_State1.name = param1;
         },"_ChooseGameOptionsRepeatedRenderer_State1.name");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = OVER;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ChooseGameOptionsRepeatedRenderer_State2.name = param1;
         },"_ChooseGameOptionsRepeatedRenderer_State2.name");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = SELECTED;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ChooseGameOptionsRepeatedRenderer_State3.name = param1;
         },"_ChooseGameOptionsRepeatedRenderer_State3.name");
         result[2] = binding;
         binding = new Binding(this,function():Object
         {
            return LOCK_ICON;
         },function(param1:Object):void
         {
            lockIconImage.source = param1;
         },"lockIconImage.source");
         result[3] = binding;
         return result;
      }
      
      public function set lockIconImage(param1:Image) : void
      {
         var _loc2_:Object = this._943105161lockIconImage;
         if(_loc2_ !== param1)
         {
            this._943105161lockIconImage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lockIconImage",_loc2_,param1));
         }
      }
      
      public function redraw() : void
      {
         switch(this.currentState)
         {
            case UP:
               this.backgroundImage.source = null;
               break;
            case OVER:
               if(this.lines == 1)
               {
                  this.backgroundImage.source = OPTION_LIST_SINGLE_LINE_ITEM_OVER;
               }
               else
               {
                  this.backgroundImage.source = OPTION_LIST_DOUBLE_LINE_ITEM_OVER;
               }
               break;
            case SELECTED:
               if(this.lines == 1)
               {
                  this.backgroundImage.source = OPTION_LIST_SINGLE_LINE_ITEM_SELECTED;
               }
               else
               {
                  this.backgroundImage.source = OPTION_LIST_DOUBLE_LINE_ITEM_SELECTED;
               }
         }
         if(this.lines == 1)
         {
            this.lockIconImage.setStyle("bottom",5);
         }
         else
         {
            this.lockIconImage.setStyle("bottom",4);
         }
      }
      
      private function _ChooseGameOptionsRepeatedRenderer_State3_i() : State
      {
         var _loc1_:State = new State();
         this._ChooseGameOptionsRepeatedRenderer_State3 = _loc1_;
         BindingManager.executeBindings(this,"_ChooseGameOptionsRepeatedRenderer_State3",this._ChooseGameOptionsRepeatedRenderer_State3);
         return _loc1_;
      }
      
      public function ___ChooseGameOptionsRepeatedRenderer_Canvas1_currentStateChange(param1:StateChangeEvent) : void
      {
         this.onCurrentStateChange(param1);
      }
      
      private function _ChooseGameOptionsRepeatedRenderer_State1_i() : State
      {
         var _loc1_:State = new State();
         this._ChooseGameOptionsRepeatedRenderer_State1 = _loc1_;
         BindingManager.executeBindings(this,"_ChooseGameOptionsRepeatedRenderer_State1",this._ChooseGameOptionsRepeatedRenderer_State1);
         return _loc1_;
      }
   }
}

