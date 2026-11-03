package com.riotgames.platform.gameclient.views.game.practice.teamselection
{
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.gameclient.components.containers.GradientCanvas;
   import com.riotgames.pvpnet.game.controllers.TeamSelectionController;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.alerter.AlerterProviderProxy;
   import com.riotgames.pvpnet.system.alerter.IAlerterProvider;
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
   import mx.collections.ArrayCollection;
   import mx.containers.Canvas;
   import mx.containers.utilityClasses.ConstraintRow;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.controls.List;
   import mx.core.ClassFactory;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class TeamPanel2 extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _868055995topRow:ConstraintRow;
      
      private var _655255227centerRow:ConstraintRow;
      
      public var alerter:IAlerterProvider;
      
      mx_internal var _watchers:Array;
      
      private var _584045572teamMembers:ArrayCollection;
      
      private var _1115259087header_c:GradientCanvas;
      
      mx_internal var _bindingsByDestination:Object;
      
      private var _12089446header_c_label:Label;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      [Inject]
      private var _843995307teamSelectionController:TeamSelectionController;
      
      private var gameMapWatcher:ChangeWatcher = null;
      
      private var isOwnerWatcher:ChangeWatcher = null;
      
      private var _193839465teamLabel:String;
      
      private var _embed_mxml________ClientAssets_imageEmbeds_teamSelection_pvp_headerFlame_blue_png_1953900226:Class;
      
      mx_internal var _bindings:Array;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      private var _1668243733team_lst:List;
      
      private var isBusyWatcher:ChangeWatcher = null;
      
      public function TeamPanel2()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":GradientCanvas,
                  "id":"header_c",
                  "stylesFactory":function():void
                  {
                     this.top = "0";
                     this.left = "0";
                     this.bottom = "topRow:0";
                     this.borderStyle = "none";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "styleName":"blueHeaderBackground",
                        "percentWidth":100,
                        "horizontalScrollPolicy":"off",
                        "verticalScrollPolicy":"off",
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":Image,
                           "stylesFactory":function():void
                           {
                              this.verticalCenter = "0";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "x":0,
                                 "source":_embed_mxml________ClientAssets_imageEmbeds_teamSelection_pvp_headerFlame_blue_png_1953900226
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Label,
                           "id":"header_c_label",
                           "stylesFactory":function():void
                           {
                              this.left = "10";
                              this.verticalCenter = "0";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {"styleName":"blueThemeHeaderText"};
                           }
                        })]
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":List,
                  "id":"team_lst",
                  "stylesFactory":function():void
                  {
                     this.left = "5";
                     this.right = "5";
                     this.top = "centerRow:1";
                     this.bottom = "centerRow:0";
                     this.paddingLeft = 0;
                     this.backgroundAlpha = 0;
                     this.borderStyle = "none";
                     this.useRollOver = false;
                     this.paddingBottom = 1;
                     this.paddingTop = 2;
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "itemRenderer":_TeamPanel2_ClassFactory1_c(),
                        "rowHeight":70,
                        "selectable":false,
                        "horizontalScrollPolicy":"off",
                        "verticalScrollPolicy":"off"
                     };
                  }
               })]};
            }
         });
         this.alerter = AlerterProviderProxy.instance;
         this._embed_mxml________ClientAssets_imageEmbeds_teamSelection_pvp_headerFlame_blue_png_1953900226 = TeamPanel2__embed_mxml________ClientAssets_imageEmbeds_teamSelection_pvp_headerFlame_blue_png_1953900226;
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
         };
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.constraintRows = [this._TeamPanel2_ConstraintRow1_i(),this._TeamPanel2_ConstraintRow2_i()];
         this.addEventListener("initialize",this.___TeamPanel2_Canvas1_initialize);
         this.addEventListener("addedToStage",this.___TeamPanel2_Canvas1_addedToStage);
         this.addEventListener("removedFromStage",this.___TeamPanel2_Canvas1_removedFromStage);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         TeamPanel2._watcherSetupUtil = param1;
      }
      
      private function _TeamPanel2_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.teamLabel;
         _loc1_ = this.teamMembers;
      }
      
      public function ___TeamPanel2_Canvas1_removedFromStage(param1:Event) : void
      {
         this.onRemovedFromStage();
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:TeamPanel2 = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._TeamPanel2_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_practice_teamselection_TeamPanel2WatcherSetupUtil");
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
      
      public function set centerRow(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._655255227centerRow;
         if(_loc2_ !== param1)
         {
            this._655255227centerRow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"centerRow",_loc2_,param1));
         }
      }
      
      private function _TeamPanel2_ConstraintRow1_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.topRow = _loc1_;
         _loc1_.height = 30;
         _loc1_.initialized(this,"topRow");
         return _loc1_;
      }
      
      private function onIsOwnerChange(param1:Event) : void
      {
         this.changeBotsVisible();
      }
      
      [Bindable(event="propertyChange")]
      public function get teamLabel() : String
      {
         return this._193839465teamLabel;
      }
      
      private function onAddedToStage() : void
      {
         if(this.isBusyWatcher == null)
         {
            this.isBusyWatcher = ChangeWatcher.watch(this.teamSelectionController,"isBusy",this.onIsBusyChange);
            this.gameMapWatcher = ChangeWatcher.watch(this.teamSelectionController,"gameMap",this.onGameMapChange);
            this.isOwnerWatcher = ChangeWatcher.watch(this.teamSelectionController,"isOwner",this.onIsOwnerChange);
         }
      }
      
      public function set teamLabel(param1:String) : void
      {
         var _loc2_:Object = this._193839465teamLabel;
         if(_loc2_ !== param1)
         {
            this._193839465teamLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamLabel",_loc2_,param1));
         }
      }
      
      protected function onServiceRequestError(param1:ServerError) : void
      {
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         var _loc3_:AlertAction = new AlertAction(_loc2_.getString("resources","general_generalAlertErrorTitle"),_loc2_.getString("resources",param1.errorCode,param1.messageArguments));
         _loc3_.add();
      }
      
      [Bindable(event="propertyChange")]
      public function get header_c() : GradientCanvas
      {
         return this._1115259087header_c;
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get teamSelectionController() : TeamSelectionController
      {
         return this._843995307teamSelectionController;
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
      
      private function _TeamPanel2_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = teamLabel;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            header_c_label.text = param1;
         },"header_c_label.text");
         result[0] = binding;
         binding = new Binding(this,function():Object
         {
            return this.teamMembers;
         },function(param1:Object):void
         {
            team_lst.dataProvider = param1;
         },"team_lst.dataProvider");
         result[1] = binding;
         return result;
      }
      
      private function onGameMapChange(param1:Event) : void
      {
         this.changeBotsVisible();
      }
      
      public function ___TeamPanel2_Canvas1_addedToStage(param1:Event) : void
      {
         this.onAddedToStage();
      }
      
      private function changeBotsEnabled() : void
      {
      }
      
      private function onInitialize() : void
      {
      }
      
      private function _TeamPanel2_ConstraintRow2_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.centerRow = _loc1_;
         _loc1_.percentHeight = 100;
         _loc1_.initialized(this,"centerRow");
         return _loc1_;
      }
      
      private function onIsBusyChange(param1:Event = null) : void
      {
         this.changeBotsEnabled();
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
      
      public function set header_c_label(param1:Label) : void
      {
         var _loc2_:Object = this._12089446header_c_label;
         if(_loc2_ !== param1)
         {
            this._12089446header_c_label = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"header_c_label",_loc2_,param1));
         }
      }
      
      public function set team_lst(param1:List) : void
      {
         var _loc2_:Object = this._1668243733team_lst;
         if(_loc2_ !== param1)
         {
            this._1668243733team_lst = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"team_lst",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get header_c_label() : Label
      {
         return this._12089446header_c_label;
      }
      
      [Bindable(event="propertyChange")]
      public function get centerRow() : ConstraintRow
      {
         return this._655255227centerRow;
      }
      
      public function ___TeamPanel2_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      private function _TeamPanel2_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = TeamMemberRenderer2;
         return _loc1_;
      }
      
      private function onRemovedFromStage() : void
      {
         if(this.isBusyWatcher)
         {
            this.isBusyWatcher.unwatch();
            this.isBusyWatcher = null;
         }
         if(this.gameMapWatcher)
         {
            this.gameMapWatcher.unwatch();
            this.gameMapWatcher = null;
         }
         if(this.isOwnerWatcher)
         {
            this.isOwnerWatcher.unwatch();
            this.isOwnerWatcher = null;
         }
      }
      
      public function set teamSelectionController(param1:TeamSelectionController) : void
      {
         var _loc2_:Object = this._843995307teamSelectionController;
         if(_loc2_ !== param1)
         {
            this._843995307teamSelectionController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamSelectionController",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get team_lst() : List
      {
         return this._1668243733team_lst;
      }
      
      [Bindable(event="propertyChange")]
      public function get teamMembers() : ArrayCollection
      {
         return this._584045572teamMembers;
      }
      
      private function changeBotsVisible() : void
      {
      }
      
      [Bindable(event="propertyChange")]
      public function get topRow() : ConstraintRow
      {
         return this._868055995topRow;
      }
      
      public function set teamMembers(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._584045572teamMembers;
         if(_loc2_ !== param1)
         {
            this._584045572teamMembers = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamMembers",_loc2_,param1));
         }
      }
   }
}

