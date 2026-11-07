package com.riotgames.platform.gameclient.controllers.game.views
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.components.containers.GradientCanvas;
   import com.riotgames.platform.gameclient.controllers.game.views.itemRenderers.ChampionBanRenderer;
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
   import mx.containers.utilityClasses.ConstraintRow;
   import mx.controls.Label;
   import mx.controls.List;
   import mx.core.ClassFactory;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   public class BannedChampionsView extends GradientCanvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private static const MAX_BANS:uint = 4;
      
      private var _868055995topRow:ConstraintRow;
      
      private var _655255227centerRow:ConstraintRow;
      
      private var _12089446header_c_label:Label;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object;
      
      private var _337399907ban_lst:List;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array;
      
      private var _664874450bannedChamps:ArrayCollection;
      
      private var _1115259087header_c:GradientCanvas;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public function BannedChampionsView()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":GradientCanvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":Canvas,
                  "stylesFactory":function():void
                  {
                     this.bottom = "0";
                     this.left = "0";
                     this.right = "0";
                     this.top = "0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "horizontalScrollPolicy":"off",
                        "verticalScrollPolicy":"off",
                        "constraintRows":[_BannedChampionsView_ConstraintRow1_i(),_BannedChampionsView_ConstraintRow2_i()],
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":GradientCanvas,
                           "id":"header_c",
                           "stylesFactory":function():void
                           {
                              this.borderStyle = "none";
                              this.bottom = "topRow:0";
                              this.left = "0";
                              this.top = "0";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "horizontalScrollPolicy":"off",
                                 "styleName":"blueHeaderBackground",
                                 "verticalScrollPolicy":"off",
                                 "width":249,
                                 "childDescriptors":[new UIComponentDescriptor({
                                    "type":Label,
                                    "id":"header_c_label",
                                    "stylesFactory":function():void
                                    {
                                       this.left = "10";
                                       this.verticalCenter = "0";
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {"styleName":"spectatorPanelHeaderText"};
                                    }
                                 })]
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":List,
                           "id":"ban_lst",
                           "stylesFactory":function():void
                           {
                              this.backgroundAlpha = 0;
                              this.borderStyle = "none";
                              this.bottom = "centerRow:0";
                              this.left = "5";
                              this.paddingBottom = 1;
                              this.paddingLeft = 0;
                              this.paddingTop = 2;
                              this.right = "5";
                              this.top = "centerRow:1";
                              this.useRollOver = false;
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "horizontalScrollPolicy":"off",
                                 "selectable":false,
                                 "verticalScrollPolicy":"off",
                                 "itemRenderer":_BannedChampionsView_ClassFactory1_c(),
                                 "rowHeight":34
                              };
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
            this.backgroundAlpha = 0;
            this.borderSides = "left top";
            this.cornerRadius = 2;
         };
         this.horizontalScrollPolicy = "off";
         this.styleName = "blueParchmentTablet";
         this.verticalScrollPolicy = "off";
         this.cacheAsBitmap = true;
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         BannedChampionsView._watcherSetupUtil = param1;
      }
      
      public function set header_c(param1:GradientCanvas) : void
      {
         var _loc2_:Object = this._1115259087header_c;
         if(_loc2_ !== param1)
         {
            this._1115259087header_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"header_c",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:BannedChampionsView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._BannedChampionsView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_controllers_game_views_BannedChampionsViewWatcherSetupUtil");
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
      
      public function set header_c_label(param1:Label) : void
      {
         var _loc2_:Object = this._12089446header_c_label;
         if(_loc2_ !== param1)
         {
            this._12089446header_c_label = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"header_c_label",_loc2_,param1));
         }
      }
      
      private function _BannedChampionsView_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = ChampionBanRenderer;
         return _loc1_;
      }
      
      public function set centerRow(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._655255227centerRow;
         if(_loc2_ !== param1)
         {
            this._655255227centerRow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"centerRow",_loc2_,param1));
         }
      }
      
      private function _BannedChampionsView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("championSelection_bannedChampions");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            header_c_label.text = param1;
         },"header_c_label.text");
         result[0] = binding;
         binding = new Binding(this,function():Object
         {
            return bannedChamps;
         },function(param1:Object):void
         {
            ban_lst.dataProvider = param1;
         },"ban_lst.dataProvider");
         result[1] = binding;
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get ban_lst() : List
      {
         return this._337399907ban_lst;
      }
      
      private function _BannedChampionsView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = RiotResourceLoader.getString("championSelection_bannedChampions");
         _loc1_ = this.bannedChamps;
      }
      
      [Bindable(event="propertyChange")]
      public function get centerRow() : ConstraintRow
      {
         return this._655255227centerRow;
      }
      
      [Bindable(event="propertyChange")]
      public function get bannedChamps() : ArrayCollection
      {
         return this._664874450bannedChamps;
      }
      
      private function _BannedChampionsView_ConstraintRow1_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.topRow = _loc1_;
         _loc1_.height = 25;
         _loc1_.initialized(this,"topRow");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get header_c() : GradientCanvas
      {
         return this._1115259087header_c;
      }
      
      [Bindable(event="propertyChange")]
      public function get topRow() : ConstraintRow
      {
         return this._868055995topRow;
      }
      
      [Bindable(event="propertyChange")]
      public function get header_c_label() : Label
      {
         return this._12089446header_c_label;
      }
      
      public function set topRow(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._868055995topRow;
         if(_loc2_ !== param1)
         {
            this._868055995topRow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"topRow",_loc2_,param1));
         }
      }
      
      public function set ban_lst(param1:List) : void
      {
         var _loc2_:Object = this._337399907ban_lst;
         if(_loc2_ !== param1)
         {
            this._337399907ban_lst = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ban_lst",_loc2_,param1));
         }
      }
      
      private function _BannedChampionsView_ConstraintRow2_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.centerRow = _loc1_;
         _loc1_.percentHeight = 100;
         _loc1_.initialized(this,"centerRow");
         return _loc1_;
      }
      
      public function set bannedChamps(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._664874450bannedChamps;
         if(_loc2_ !== param1)
         {
            this._664874450bannedChamps = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bannedChamps",_loc2_,param1));
         }
      }
   }
}

