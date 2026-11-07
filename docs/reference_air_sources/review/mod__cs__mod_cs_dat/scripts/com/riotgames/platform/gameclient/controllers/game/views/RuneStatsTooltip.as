package com.riotgames.platform.gameclient.controllers.game.views
{
   import com.riotgames.platform.gameclient.domain.SpellBookPageDTO;
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
   import mx.containers.VBox;
   import mx.controls.List;
   import mx.controls.Text;
   import mx.core.ClassFactory;
   import mx.core.IToolTip;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   public class RuneStatsTooltip extends VBox implements IBindingClient, IToolTip
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _110371416title:Text;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object;
      
      public var _text:String;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array;
      
      private var _162756857statsTitle:Text;
      
      public var _RuneStatsTooltip_List1:List;
      
      private var _145475834statsArray:ArrayCollection;
      
      public var yOffset:Number = 0;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public function RuneStatsTooltip()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":VBox,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":Text,
                  "id":"title",
                  "stylesFactory":function():void
                  {
                     this.horizontalCenter = "0";
                     this.paddingTop = 10;
                     this.fontSize = 12;
                     this.textAlign = "center";
                     this.color = 0;
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "width":300,
                        "styleName":"spellTitle",
                        "selectable":false
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Text,
                  "id":"statsTitle",
                  "stylesFactory":function():void
                  {
                     this.paddingLeft = 5;
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "percentWidth":100,
                        "styleName":"runeStatsTitle",
                        "selectable":false
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":List,
                  "id":"_RuneStatsTooltip_List1",
                  "stylesFactory":function():void
                  {
                     this.backgroundAlpha = 0;
                     this.borderStyle = "none";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "percentWidth":100,
                        "selectable":false,
                        "dragEnabled":false,
                        "horizontalScrollPolicy":"off",
                        "verticalScrollPolicy":"off",
                        "itemRenderer":_RuneStatsTooltip_ClassFactory1_c()
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
            this.backgroundColor = 15592650;
            this.borderStyle = "solid";
            this.borderColor = 0;
            this.borderThickness = 1;
            this.cornerRadius = 4;
         };
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         RuneStatsTooltip._watcherSetupUtil = param1;
      }
      
      private function _RuneStatsTooltip_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = RuneStatsTooltip_inlineComponent1;
         _loc1_.properties = {"outerDocument":this};
         return _loc1_;
      }
      
      private function set statsArray(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._145475834statsArray;
         if(_loc2_ !== param1)
         {
            this._145475834statsArray = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statsArray",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get statsArray() : ArrayCollection
      {
         return this._145475834statsArray;
      }
      
      private function _RuneStatsTooltip_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.data.displayName;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            title.htmlText = param1;
         },"title.htmlText");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","runebook_book_statsHeaderLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            statsTitle.htmlText = param1;
         },"statsTitle.htmlText");
         result[1] = binding;
         binding = new Binding(this,function():Number
         {
            return this.statsArray.length * 55;
         },function(param1:Number):void
         {
            _RuneStatsTooltip_List1.height = param1;
         },"_RuneStatsTooltip_List1.height");
         result[2] = binding;
         binding = new Binding(this,function():Object
         {
            return this.statsArray;
         },function(param1:Object):void
         {
            _RuneStatsTooltip_List1.dataProvider = param1;
         },"_RuneStatsTooltip_List1.dataProvider");
         result[3] = binding;
         return result;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:RuneStatsTooltip = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._RuneStatsTooltip_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_controllers_game_views_RuneStatsTooltipWatcherSetupUtil");
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
      
      override public function set data(param1:Object) : void
      {
         var _loc3_:int = 0;
         super.data = param1;
         var _loc2_:SpellBookPageDTO = param1 as SpellBookPageDTO;
         if(_loc2_)
         {
            this.statsArray = _loc2_.getCombinedStats();
            if(this.statsArray)
            {
               _loc3_ = this.statsArray.length - 4;
               if(_loc3_ > 0)
               {
                  this.yOffset = -55 * _loc3_;
               }
            }
         }
      }
      
      public function set text(param1:String) : void
      {
      }
      
      private function _RuneStatsTooltip_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.data.displayName;
         _loc1_ = resourceManager.getString("resources","runebook_book_statsHeaderLabel");
         _loc1_ = this.statsArray.length * 55;
         _loc1_ = this.statsArray;
      }
      
      public function set statsTitle(param1:Text) : void
      {
         var _loc2_:Object = this._162756857statsTitle;
         if(_loc2_ !== param1)
         {
            this._162756857statsTitle = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statsTitle",_loc2_,param1));
         }
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      [Bindable(event="propertyChange")]
      public function get title() : Text
      {
         return this._110371416title;
      }
      
      public function set title(param1:Text) : void
      {
         var _loc2_:Object = this._110371416title;
         if(_loc2_ !== param1)
         {
            this._110371416title = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"title",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get statsTitle() : Text
      {
         return this._162756857statsTitle;
      }
   }
}

