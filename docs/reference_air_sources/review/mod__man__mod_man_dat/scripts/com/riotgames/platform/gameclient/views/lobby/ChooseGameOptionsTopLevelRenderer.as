package com.riotgames.platform.gameclient.views.lobby
{
   import com.adobe.effects.SaturationFade;
   import com.riotgames.platform.gameclient.domain.game.GameOptionsList;
   import com.riotgames.platform.gameclient.domain.game.GamePropertiesListData;
   import com.riotgames.pvpnet.game.variants.GameFlowVariantFactory;
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
   import mx.collections.ArrayCollection;
   import mx.containers.Canvas;
   import mx.controls.Image;
   import mx.controls.TextArea;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.StateChangeEvent;
   import mx.states.State;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class ChooseGameOptionsTopLevelRenderer extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static const TOP_LEVEL_LIST_FIRST_ITEM_SELECTED:Class = ChooseGameOptionsTopLevelRenderer_TOP_LEVEL_LIST_FIRST_ITEM_SELECTED;
      
      public static const TOP_LEVEL_LIST_MIDDLE_ITEM_SELECTED:Class = ChooseGameOptionsTopLevelRenderer_TOP_LEVEL_LIST_MIDDLE_ITEM_SELECTED;
      
      public static const TOP_LEVEL_LIST_LAST_ITEM_SELECTED:Class = ChooseGameOptionsTopLevelRenderer_TOP_LEVEL_LIST_LAST_ITEM_SELECTED;
      
      public static const TOP_LEVEL_LIST_ITEM_UP:Class = ChooseGameOptionsTopLevelRenderer_TOP_LEVEL_LIST_ITEM_UP;
      
      public static const TOP_LEVEL_LIST_ITEM_OVER:Class = ChooseGameOptionsTopLevelRenderer_TOP_LEVEL_LIST_ITEM_OVER;
      
      public static const TOP_LEVEL_LIST_ITEM_DOWN:Class = ChooseGameOptionsTopLevelRenderer_TOP_LEVEL_LIST_ITEM_DOWN;
      
      public static const LOCK_ICON:Class = ChooseGameOptionsTopLevelRenderer_LOCK_ICON;
      
      public static const STAR_ICON:Class = ChooseGameOptionsTopLevelRenderer_STAR_ICON;
      
      public static const UP:String = "up";
      
      public static const OVER:String = "over";
      
      public static const DOWN:String = "down";
      
      public static const SELECTED:String = "selected";
      
      public static const ENABLED_CHANGE_EVENT:String = "enabled_change";
      
      private var _1292595405backgroundImage:Image;
      
      mx_internal var _watchers:Array = [];
      
      private var _1817957447satFadeIn:SaturationFade;
      
      private var initialy:int = 2147483647;
      
      private var dataEnabled:Boolean = true;
      
      public var _ChooseGameOptionsTopLevelRenderer_State2:State;
      
      public var _ChooseGameOptionsTopLevelRenderer_State3:State;
      
      public var _ChooseGameOptionsTopLevelRenderer_State4:State;
      
      public var _ChooseGameOptionsTopLevelRenderer_State1:State;
      
      private var _522112108satFadeOut:SaturationFade;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      public var index:int;
      
      private var _1212645098listlabel:TextArea;
      
      private var _133204432starIconImage:Image;
      
      mx_internal var _bindings:Array = [];
      
      private var _943105161lockIconImage:Image;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {
               "height":60,
               "childDescriptors":[new UIComponentDescriptor({
                  "type":Image,
                  "id":"backgroundImage"
               }),new UIComponentDescriptor({
                  "type":TextArea,
                  "id":"listlabel",
                  "stylesFactory":function():void
                  {
                     this.verticalCenter = "0";
                     this.fontSize = 17;
                     this.textAlign = "center";
                     this.color = 14540253;
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "percentWidth":93,
                        "height":20,
                        "selectable":false,
                        "editable":false
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Image,
                  "id":"lockIconImage",
                  "stylesFactory":function():void
                  {
                     this.right = "8";
                     this.verticalCenter = "2";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "visible":false,
                        "includeInLayout":false
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Image,
                  "id":"starIconImage",
                  "stylesFactory":function():void
                  {
                     this.right = "8";
                     this.verticalCenter = "2";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "visible":false,
                        "includeInLayout":false
                     };
                  }
               })]
            };
         }
      });
      
      public function ChooseGameOptionsTopLevelRenderer()
      {
         super();
         mx_internal::_document = this;
         this.percentWidth = 100;
         this.height = 60;
         this.styleName = "optionsFlowTopLevelListItemRenderer";
         this.verticalScrollPolicy = "off";
         this.horizontalScrollPolicy = "off";
         this.states = [this._ChooseGameOptionsTopLevelRenderer_State1_i(),this._ChooseGameOptionsTopLevelRenderer_State2_i(),this._ChooseGameOptionsTopLevelRenderer_State3_i(),this._ChooseGameOptionsTopLevelRenderer_State4_i()];
         this._ChooseGameOptionsTopLevelRenderer_SaturationFade2_i();
         this._ChooseGameOptionsTopLevelRenderer_SaturationFade1_i();
         this.addEventListener("creationComplete",this.___ChooseGameOptionsTopLevelRenderer_Canvas1_creationComplete);
         this.addEventListener("currentStateChange",this.___ChooseGameOptionsTopLevelRenderer_Canvas1_currentStateChange);
         this.addEventListener("render",this.___ChooseGameOptionsTopLevelRenderer_Canvas1_render);
         this.addEventListener("dataChange",this.___ChooseGameOptionsTopLevelRenderer_Canvas1_dataChange);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         ChooseGameOptionsTopLevelRenderer._watcherSetupUtil = param1;
      }
      
      private static function findChildItems(param1:Object, param2:Array) : void
      {
         var _loc3_:ArrayCollection = null;
         var _loc4_:int = 0;
         var _loc5_:GamePropertiesListData = null;
         if(param1 is ArrayCollection)
         {
            _loc3_ = param1 as ArrayCollection;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc5_ = _loc3_.getItemAt(_loc4_) as GamePropertiesListData;
               if(_loc5_ != null)
               {
                  param2.push(_loc5_);
                  findChildItems(_loc5_.nextStep,param2);
               }
               _loc4_++;
            }
         }
      }
      
      public function set satFadeIn(param1:SaturationFade) : void
      {
         var _loc2_:Object = this._1817957447satFadeIn;
         if(_loc2_ !== param1)
         {
            this._1817957447satFadeIn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"satFadeIn",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:ChooseGameOptionsTopLevelRenderer = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._ChooseGameOptionsTopLevelRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_lobby_ChooseGameOptionsTopLevelRendererWatcherSetupUtil");
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
      
      private function init() : void
      {
         if(this.data)
         {
            this.listlabel.text = this.data.displayName;
         }
         this.currentState = UP;
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
      
      [Bindable(event="propertyChange")]
      public function get listlabel() : TextArea
      {
         return this._1212645098listlabel;
      }
      
      private function _ChooseGameOptionsTopLevelRenderer_SaturationFade2_i() : SaturationFade
      {
         var _loc1_:SaturationFade = new SaturationFade();
         this.satFadeIn = _loc1_;
         _loc1_.saturationFrom = 0;
         _loc1_.saturationTo = 1;
         _loc1_.duration = 1;
         return _loc1_;
      }
      
      private function _ChooseGameOptionsTopLevelRenderer_State2_i() : State
      {
         var _loc1_:State = new State();
         this._ChooseGameOptionsTopLevelRenderer_State2 = _loc1_;
         BindingManager.executeBindings(this,"_ChooseGameOptionsTopLevelRenderer_State2",this._ChooseGameOptionsTopLevelRenderer_State2);
         return _loc1_;
      }
      
      public function ___ChooseGameOptionsTopLevelRenderer_Canvas1_currentStateChange(param1:StateChangeEvent) : void
      {
         this.onCurrentStateChange(param1);
      }
      
      public function offsetY(param1:int) : void
      {
         if(this.initialy == int.MAX_VALUE)
         {
            this.initialy = this.y;
         }
         this.y = this.initialy + param1;
      }
      
      protected function onCurrentStateChange(param1:StateChangeEvent) : void
      {
         this.backgroundImage.y = 3;
         switch(param1.newState)
         {
            case UP:
               this.backgroundImage.source = TOP_LEVEL_LIST_ITEM_UP;
               break;
            case OVER:
               this.backgroundImage.source = TOP_LEVEL_LIST_ITEM_OVER;
               break;
            case DOWN:
               this.backgroundImage.source = TOP_LEVEL_LIST_ITEM_DOWN;
               break;
            case SELECTED:
               if(this.index == 0)
               {
                  this.backgroundImage.source = TOP_LEVEL_LIST_FIRST_ITEM_SELECTED;
               }
               else if(this.index == 3)
               {
                  this.backgroundImage.source = TOP_LEVEL_LIST_LAST_ITEM_SELECTED;
                  this.backgroundImage.y = 0;
               }
               else
               {
                  this.backgroundImage.source = TOP_LEVEL_LIST_MIDDLE_ITEM_SELECTED;
                  this.backgroundImage.y = 0;
               }
         }
      }
      
      private function _ChooseGameOptionsTopLevelRenderer_State4_i() : State
      {
         var _loc1_:State = new State();
         this._ChooseGameOptionsTopLevelRenderer_State4 = _loc1_;
         BindingManager.executeBindings(this,"_ChooseGameOptionsTopLevelRenderer_State4",this._ChooseGameOptionsTopLevelRenderer_State4);
         return _loc1_;
      }
      
      private function _ChooseGameOptionsTopLevelRenderer_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = UP;
         _loc1_ = OVER;
         _loc1_ = DOWN;
         _loc1_ = SELECTED;
         _loc1_ = LOCK_ICON;
         _loc1_ = STAR_ICON;
      }
      
      public function set listlabel(param1:TextArea) : void
      {
         var _loc2_:Object = this._1212645098listlabel;
         if(_loc2_ !== param1)
         {
            this._1212645098listlabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"listlabel",_loc2_,param1));
         }
      }
      
      public function ___ChooseGameOptionsTopLevelRenderer_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.init();
      }
      
      public function ___ChooseGameOptionsTopLevelRenderer_Canvas1_dataChange(param1:FlexEvent) : void
      {
         this.onDataChange();
      }
      
      [Bindable(event="propertyChange")]
      public function get starIconImage() : Image
      {
         return this._133204432starIconImage;
      }
      
      private function onDataChange() : void
      {
         var _loc1_:GameOptionsList = null;
         if(this.data)
         {
            _loc1_ = this.data as GameOptionsList;
            if(_loc1_.isAspirational)
            {
               this.toolTip = _loc1_.aspirationalToolTip;
               this.lockIconImage.visible = this.lockIconImage.includeInLayout = true;
            }
            else
            {
               this.toolTip = _loc1_.tooltip;
               this.lockIconImage.visible = this.lockIconImage.includeInLayout = false;
            }
            this.starIconImage.visible = this.starIconImage.includeInLayout = this.determineStarIconUsage(_loc1_);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get satFadeIn() : SaturationFade
      {
         return this._1817957447satFadeIn;
      }
      
      [Bindable(event="propertyChange")]
      public function get backgroundImage() : Image
      {
         return this._1292595405backgroundImage;
      }
      
      public function ___ChooseGameOptionsTopLevelRenderer_Canvas1_render(param1:Event) : void
      {
         this.onRender();
      }
      
      private function onRender() : void
      {
         var _loc1_:Event = null;
         if(Boolean(this.data) && this.data.enabled != this.dataEnabled)
         {
            this.dataEnabled = this.data.enabled;
            if(this.dataEnabled)
            {
               this.satFadeIn.play([this]);
            }
            else
            {
               this.satFadeOut.play([this]);
            }
            _loc1_ = new Event(ENABLED_CHANGE_EVENT);
            this.dispatchEvent(_loc1_);
         }
      }
      
      private function _ChooseGameOptionsTopLevelRenderer_SaturationFade1_i() : SaturationFade
      {
         var _loc1_:SaturationFade = new SaturationFade();
         this.satFadeOut = _loc1_;
         _loc1_.saturationFrom = 1;
         _loc1_.saturationTo = 0;
         _loc1_.duration = 200;
         return _loc1_;
      }
      
      private function _ChooseGameOptionsTopLevelRenderer_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = UP;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ChooseGameOptionsTopLevelRenderer_State1.name = param1;
         },"_ChooseGameOptionsTopLevelRenderer_State1.name");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = OVER;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ChooseGameOptionsTopLevelRenderer_State2.name = param1;
         },"_ChooseGameOptionsTopLevelRenderer_State2.name");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = DOWN;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ChooseGameOptionsTopLevelRenderer_State3.name = param1;
         },"_ChooseGameOptionsTopLevelRenderer_State3.name");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = SELECTED;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ChooseGameOptionsTopLevelRenderer_State4.name = param1;
         },"_ChooseGameOptionsTopLevelRenderer_State4.name");
         result[3] = binding;
         binding = new Binding(this,function():Object
         {
            return LOCK_ICON;
         },function(param1:Object):void
         {
            lockIconImage.source = param1;
         },"lockIconImage.source");
         result[4] = binding;
         binding = new Binding(this,function():Object
         {
            return STAR_ICON;
         },function(param1:Object):void
         {
            starIconImage.source = param1;
         },"starIconImage.source");
         result[5] = binding;
         return result;
      }
      
      public function set satFadeOut(param1:SaturationFade) : void
      {
         var _loc2_:Object = this._522112108satFadeOut;
         if(_loc2_ !== param1)
         {
            this._522112108satFadeOut = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"satFadeOut",_loc2_,param1));
         }
      }
      
      public function set starIconImage(param1:Image) : void
      {
         var _loc2_:Object = this._133204432starIconImage;
         if(_loc2_ !== param1)
         {
            this._133204432starIconImage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"starIconImage",_loc2_,param1));
         }
      }
      
      private function _ChooseGameOptionsTopLevelRenderer_State1_i() : State
      {
         var _loc1_:State = new State();
         this._ChooseGameOptionsTopLevelRenderer_State1 = _loc1_;
         BindingManager.executeBindings(this,"_ChooseGameOptionsTopLevelRenderer_State1",this._ChooseGameOptionsTopLevelRenderer_State1);
         return _loc1_;
      }
      
      private function determineStarIconUsage(param1:GameOptionsList) : Boolean
      {
         var _loc3_:Array = null;
         var _loc4_:GamePropertiesListData = null;
         if(this.lockIconImage.visible)
         {
            return false;
         }
         var _loc2_:Boolean = false;
         if(ChooseGameViewLayoutPVP.INTERNAL_NAME == param1.internalName || ChooseGameViewLayoutPVE.INTERNAL_NAME == param1.internalName)
         {
            _loc3_ = [];
            findChildItems(param1,_loc3_);
            for each(_loc4_ in _loc3_)
            {
               if(GameFlowVariantFactory.instance.getVariantForGameKey(_loc4_.gameKey).showsGameFlowOptionsStar())
               {
                  _loc2_ = true;
                  break;
               }
            }
         }
         return _loc2_;
      }
      
      [Bindable(event="propertyChange")]
      public function get satFadeOut() : SaturationFade
      {
         return this._522112108satFadeOut;
      }
      
      [Bindable(event="propertyChange")]
      public function get lockIconImage() : Image
      {
         return this._943105161lockIconImage;
      }
      
      private function _ChooseGameOptionsTopLevelRenderer_State3_i() : State
      {
         var _loc1_:State = new State();
         this._ChooseGameOptionsTopLevelRenderer_State3 = _loc1_;
         BindingManager.executeBindings(this,"_ChooseGameOptionsTopLevelRenderer_State3",this._ChooseGameOptionsTopLevelRenderer_State3);
         return _loc1_;
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
   }
}

