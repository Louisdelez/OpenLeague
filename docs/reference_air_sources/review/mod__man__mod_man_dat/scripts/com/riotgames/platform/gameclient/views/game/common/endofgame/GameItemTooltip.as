package com.riotgames.platform.gameclient.views.game.common.endofgame
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.components.containers.GradientCanvas;
   import com.riotgames.platform.gameclient.domain.GameItem;
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
   import mx.containers.utilityClasses.ConstraintColumn;
   import mx.controls.Image;
   import mx.controls.Text;
   import mx.core.IToolTip;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class GameItemTooltip extends GradientCanvas implements IBindingClient, IToolTip
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public var _text:String;
      
      private var _2124133034imageSource:Object;
      
      private var _1177184812itemIcon:Image;
      
      private var _1148514245cornerOverlay:Image;
      
      private var _1177037892itemDesc:Text;
      
      mx_internal var _watchers:Array;
      
      private var _948730573colText:ConstraintColumn;
      
      private var _948400665colIcon:ConstraintColumn;
      
      private var _1177331774itemName:Text;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      mx_internal var _bindings:Array;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public function GameItemTooltip()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":GradientCanvas,
            "propertiesFactory":function():Object
            {
               return {
                  "width":350,
                  "childDescriptors":[new UIComponentDescriptor({
                     "type":Image,
                     "id":"itemIcon",
                     "stylesFactory":function():void
                     {
                        this.verticalCenter = "0";
                     },
                     "propertiesFactory":function():Object
                     {
                        return {"x":2};
                     }
                  }),new UIComponentDescriptor({
                     "type":Image,
                     "id":"cornerOverlay",
                     "stylesFactory":function():void
                     {
                        this.verticalCenter = "0";
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "x":2,
                           "toolTip":"",
                           "mouseChildren":false,
                           "mouseEnabled":false
                        };
                     }
                  }),new UIComponentDescriptor({
                     "type":Text,
                     "id":"itemName",
                     "stylesFactory":function():void
                     {
                        this.left = "colText:0";
                        this.right = "colText:0";
                        this.textAlign = "center";
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "y":2,
                           "selectable":false,
                           "styleName":"itemTooltipHeader"
                        };
                     }
                  }),new UIComponentDescriptor({
                     "type":Text,
                     "id":"itemDesc",
                     "stylesFactory":function():void
                     {
                        this.left = "colText:0";
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "selectable":false,
                           "styleName":"itemTooltipDesc"
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
            this.backgroundAlpha = 1;
            this.borderStyle = "solid";
            this.borderThickness = 2;
            this.borderColor = 1118481;
            this.dropShadowEnabled = true;
            this.shadowDistance = 10;
            this.shadowDirection = "right";
         };
         this.styleName = "chatBackground";
         this.width = 350;
         this.verticalScrollPolicy = "off";
         this.horizontalScrollPolicy = "off";
         this.constraintColumns = [this._GameItemTooltip_ConstraintColumn1_i(),this._GameItemTooltip_ConstraintColumn2_i()];
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         GameItemTooltip._watcherSetupUtil = param1;
      }
      
      public function set itemDesc(param1:Text) : void
      {
         var _loc2_:Object = this._1177037892itemDesc;
         if(_loc2_ !== param1)
         {
            this._1177037892itemDesc = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"itemDesc",_loc2_,param1));
         }
      }
      
      private function _GameItemTooltip_ConstraintColumn2_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.colText = _loc1_;
         _loc1_.percentWidth = 80;
         _loc1_.initialized(this,"colText");
         return _loc1_;
      }
      
      private function _GameItemTooltip_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Boolean
         {
            return this.data.iconName != GameItemRenderer.EMPTY_ITEM_SLOT;
         },function(param1:Boolean):void
         {
            this.visible = param1;
         },"this.visible");
         result[0] = binding;
         binding = new Binding(this,function():Number
         {
            return colIcon.width - 4;
         },function(param1:Number):void
         {
            itemIcon.width = param1;
         },"itemIcon.width");
         result[1] = binding;
         binding = new Binding(this,function():Number
         {
            return itemIcon.width;
         },function(param1:Number):void
         {
            itemIcon.height = param1;
         },"itemIcon.height");
         result[2] = binding;
         binding = new Binding(this,function():Object
         {
            return this.imageSource;
         },function(param1:Object):void
         {
            itemIcon.source = param1;
         },"itemIcon.source");
         result[3] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_cornerMask");
         },function(param1:Object):void
         {
            cornerOverlay.source = param1;
         },"cornerOverlay.source");
         result[4] = binding;
         binding = new Binding(this,function():Number
         {
            return itemIcon.width;
         },function(param1:Number):void
         {
            cornerOverlay.width = param1;
         },"cornerOverlay.width");
         result[5] = binding;
         binding = new Binding(this,function():Number
         {
            return itemIcon.width;
         },function(param1:Number):void
         {
            cornerOverlay.height = param1;
         },"cornerOverlay.height");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.data.displayName;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            itemName.text = param1;
         },"itemName.text");
         result[7] = binding;
         binding = new Binding(this,function():Number
         {
            return itemName.y + itemName.height + 4;
         },function(param1:Number):void
         {
            itemDesc.y = param1;
         },"itemDesc.y");
         result[8] = binding;
         binding = new Binding(this,function():Number
         {
            return colText.width;
         },function(param1:Number):void
         {
            itemDesc.width = param1;
         },"itemDesc.width");
         result[9] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.data.displayDescription;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            itemDesc.htmlText = param1;
         },"itemDesc.htmlText");
         result[10] = binding;
         return result;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:GameItemTooltip = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._GameItemTooltip_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_common_endofgame_GameItemTooltipWatcherSetupUtil");
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
      
      private function _GameItemTooltip_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.data.iconName != GameItemRenderer.EMPTY_ITEM_SLOT;
         _loc1_ = this.colIcon.width - 4;
         _loc1_ = this.itemIcon.width;
         _loc1_ = this.imageSource;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_cornerMask");
         _loc1_ = this.itemIcon.width;
         _loc1_ = this.itemIcon.width;
         _loc1_ = this.data.displayName;
         _loc1_ = this.itemName.y + this.itemName.height + 4;
         _loc1_ = this.colText.width;
         _loc1_ = this.data.displayDescription;
      }
      
      public function set colText(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._948730573colText;
         if(_loc2_ !== param1)
         {
            this._948730573colText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"colText",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get colIcon() : ConstraintColumn
      {
         return this._948400665colIcon;
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set colIcon(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._948400665colIcon;
         if(_loc2_ !== param1)
         {
            this._948400665colIcon = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"colIcon",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get cornerOverlay() : Image
      {
         return this._1148514245cornerOverlay;
      }
      
      [Bindable(event="propertyChange")]
      public function get itemName() : Text
      {
         return this._1177331774itemName;
      }
      
      [Bindable(event="propertyChange")]
      public function get itemDesc() : Text
      {
         return this._1177037892itemDesc;
      }
      
      private function _GameItemTooltip_ConstraintColumn1_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.colIcon = _loc1_;
         _loc1_.percentWidth = 20;
         _loc1_.initialized(this,"colIcon");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get colText() : ConstraintColumn
      {
         return this._948730573colText;
      }
      
      [Bindable(event="propertyChange")]
      public function get itemIcon() : Image
      {
         return this._1177184812itemIcon;
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         this.imageSource = null;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:GameItem = param1 as GameItem;
         var _loc3_:Class = resourceManager.getClass("images",_loc2_.iconName.toLowerCase());
         var _loc4_:Boolean = _loc3_ != null;
         this.imageSource = _loc4_ ? _loc3_ : ImagePackLookup.instance.getItemSource(_loc2_);
      }
      
      [Bindable(event="propertyChange")]
      private function get imageSource() : Object
      {
         return this._2124133034imageSource;
      }
      
      public function set itemIcon(param1:Image) : void
      {
         var _loc2_:Object = this._1177184812itemIcon;
         if(_loc2_ !== param1)
         {
            this._1177184812itemIcon = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"itemIcon",_loc2_,param1));
         }
      }
      
      private function set imageSource(param1:Object) : void
      {
         var _loc2_:Object = this._2124133034imageSource;
         if(_loc2_ !== param1)
         {
            this._2124133034imageSource = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"imageSource",_loc2_,param1));
         }
      }
      
      public function set text(param1:String) : void
      {
      }
      
      public function set cornerOverlay(param1:Image) : void
      {
         var _loc2_:Object = this._1148514245cornerOverlay;
         if(_loc2_ !== param1)
         {
            this._1148514245cornerOverlay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cornerOverlay",_loc2_,param1));
         }
      }
      
      public function set itemName(param1:Text) : void
      {
         var _loc2_:Object = this._1177331774itemName;
         if(_loc2_ !== param1)
         {
            this._1177331774itemName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"itemName",_loc2_,param1));
         }
      }
   }
}

