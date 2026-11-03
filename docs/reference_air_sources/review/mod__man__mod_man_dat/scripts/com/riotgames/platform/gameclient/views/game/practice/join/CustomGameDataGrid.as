package com.riotgames.platform.gameclient.views.game.practice.join
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.game.practice.PracticeGameSearchResult;
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
   import mx.controls.DataGrid;
   import mx.controls.dataGridClasses.DataGridColumn;
   import mx.controls.dataGridClasses.DataGridItemRenderer;
   import mx.core.ClassFactory;
   import mx.core.IFactory;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class CustomGameDataGrid extends DataGrid implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      mx_internal var _watchers:Array;
      
      protected var _observerModeEnabled:Boolean = true;
      
      private var _1975438043spectatorColumn:DataGridColumn;
      
      private var _709517335ownerColumn:DataGridColumn;
      
      private var _1210718783nameColumn:DataGridColumn;
      
      private var _159741625privateColumn:DataGridColumn;
      
      private var _450031570mapColumn:DataGridColumn;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      mx_internal var _bindingsByDestination:Object;
      
      protected var observerModeChanged:Boolean = false;
      
      private var _1988306453slotsColumn:DataGridColumn;
      
      mx_internal var _bindings:Array;
      
      public function CustomGameDataGrid()
      {
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         if(!this.styleDeclaration)
         {
            this.styleDeclaration = new CSSStyleDeclaration();
         }
         this.styleDeclaration.defaultFactory = function():void
         {
            this.verticalScrollBarStyleName = "blueGlassScrollBar";
            this.horizontalGridLines = false;
            this.textSelectedColor = 16777215;
            this.textRollOverColor = 16777215;
            this.color = 16777215;
            this.fontSize = 15;
            this.fontFamily = "ApplicationFont2";
         };
         this.styleName = "gameGrid";
         this.verticalScrollPolicy = "on";
         this.draggableColumns = false;
         this.columns = [this._CustomGameDataGrid_DataGridColumn1_i(),this._CustomGameDataGrid_DataGridColumn2_i(),this._CustomGameDataGrid_DataGridColumn3_i(),this._CustomGameDataGrid_DataGridColumn4_i(),this._CustomGameDataGrid_DataGridColumn5_i(),this._CustomGameDataGrid_DataGridColumn6_i()];
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         CustomGameDataGrid._watcherSetupUtil = param1;
      }
      
      private function _CustomGameDataGrid_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Function
         {
            return CustomGameSortFunctions.sortByPrivateGame;
         },function(param1:Function):void
         {
            privateColumn.sortCompareFunction = param1;
         },"privateColumn.sortCompareFunction");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_createOrJoinGame_gameNameColumnHeader");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            nameColumn.headerText = param1;
         },"nameColumn.headerText");
         result[1] = binding;
         binding = new Binding(this,function():IFactory
         {
            return getDataGridItemRenderer();
         },function(param1:IFactory):void
         {
            nameColumn.itemRenderer = param1;
         },"nameColumn.itemRenderer");
         result[2] = binding;
         binding = new Binding(this,function():Function
         {
            return CustomGameSortFunctions.sortByGameName;
         },function(param1:Function):void
         {
            nameColumn.sortCompareFunction = param1;
         },"nameColumn.sortCompareFunction");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_createOrJoinGame_gameOwnerColumnHeader");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            ownerColumn.headerText = param1;
         },"ownerColumn.headerText");
         result[4] = binding;
         binding = new Binding(this,function():IFactory
         {
            return getDataGridItemRenderer();
         },function(param1:IFactory):void
         {
            ownerColumn.itemRenderer = param1;
         },"ownerColumn.itemRenderer");
         result[5] = binding;
         binding = new Binding(this,function():Function
         {
            return CustomGameSortFunctions.sortByOwnerName;
         },function(param1:Function):void
         {
            ownerColumn.sortCompareFunction = param1;
         },"ownerColumn.sortCompareFunction");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_createOrJoinGame_numberOfPlayersAvailableColumnHeader");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            slotsColumn.headerText = param1;
         },"slotsColumn.headerText");
         result[7] = binding;
         binding = new Binding(this,function():IFactory
         {
            return getDataGridItemRenderer();
         },function(param1:IFactory):void
         {
            slotsColumn.itemRenderer = param1;
         },"slotsColumn.itemRenderer");
         result[8] = binding;
         binding = new Binding(this,function():Function
         {
            return CustomGameSortFunctions.sortByNumberOfPlayersAvailable;
         },function(param1:Function):void
         {
            slotsColumn.sortCompareFunction = param1;
         },"slotsColumn.sortCompareFunction");
         result[9] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("practiceGame_createOrJoinGame_spectatorsColumnHeader");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            spectatorColumn.headerText = param1;
         },"spectatorColumn.headerText");
         result[10] = binding;
         binding = new Binding(this,function():IFactory
         {
            return getDataGridItemRenderer();
         },function(param1:IFactory):void
         {
            spectatorColumn.itemRenderer = param1;
         },"spectatorColumn.itemRenderer");
         result[11] = binding;
         binding = new Binding(this,function():Function
         {
            return CustomGameSortFunctions.sortBySpectatorSlots;
         },function(param1:Function):void
         {
            spectatorColumn.sortCompareFunction = param1;
         },"spectatorColumn.sortCompareFunction");
         result[12] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_createOrJoinGame_mapColumnHeader");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            mapColumn.headerText = param1;
         },"mapColumn.headerText");
         result[13] = binding;
         binding = new Binding(this,function():IFactory
         {
            return getDataGridItemRenderer();
         },function(param1:IFactory):void
         {
            mapColumn.itemRenderer = param1;
         },"mapColumn.itemRenderer");
         result[14] = binding;
         binding = new Binding(this,function():Function
         {
            return CustomGameSortFunctions.sortByMapName;
         },function(param1:Function):void
         {
            mapColumn.sortCompareFunction = param1;
         },"mapColumn.sortCompareFunction");
         result[15] = binding;
         return result;
      }
      
      public function set nameColumn(param1:DataGridColumn) : void
      {
         var _loc2_:Object = this._1210718783nameColumn;
         if(_loc2_ !== param1)
         {
            this._1210718783nameColumn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"nameColumn",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         var i:uint;
         var target:CustomGameDataGrid = null;
         var watcherSetupUtilClass:Object = null;
         var bindings:Array = this._CustomGameDataGrid_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_practice_join_CustomGameDataGridWatcherSetupUtil");
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
      
      protected function getDataGridItemRenderer() : IFactory
      {
         var _loc1_:ClassFactory = new ClassFactory(DataGridItemRenderer);
         _loc1_.properties = {"styleName":"dataGridItemRendererVerticalAlign"};
         return _loc1_;
      }
      
      public function set mapColumn(param1:DataGridColumn) : void
      {
         var _loc2_:Object = this._450031570mapColumn;
         if(_loc2_ !== param1)
         {
            this._450031570mapColumn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapColumn",_loc2_,param1));
         }
      }
      
      protected function mapNameLabelFunction(param1:Object, param2:DataGridColumn) : String
      {
         var _loc3_:PracticeGameSearchResult = param1 as PracticeGameSearchResult;
         if(Boolean(_loc3_) && Boolean(_loc3_.gameMap))
         {
            return RiotResourceLoader.getMapResourceString("displayname",_loc3_.gameMap.mapId,"");
         }
         return "";
      }
      
      private function _CustomGameDataGrid_DataGridColumn4_i() : DataGridColumn
      {
         var _loc1_:DataGridColumn = new DataGridColumn();
         this.slotsColumn = _loc1_;
         _loc1_.dataField = "playersAvailable";
         BindingManager.executeBindings(this,"slotsColumn",this.slotsColumn);
         return _loc1_;
      }
      
      private function _CustomGameDataGrid_DataGridColumn6_i() : DataGridColumn
      {
         var _loc1_:DataGridColumn = new DataGridColumn();
         this.mapColumn = _loc1_;
         _loc1_.dataField = "gameMap";
         _loc1_.minWidth = 170;
         _loc1_.labelFunction = this.mapNameLabelFunction;
         BindingManager.executeBindings(this,"mapColumn",this.mapColumn);
         return _loc1_;
      }
      
      private function _CustomGameDataGrid_DataGridColumn2_i() : DataGridColumn
      {
         var _loc1_:DataGridColumn = new DataGridColumn();
         this.nameColumn = _loc1_;
         _loc1_.dataField = "name";
         _loc1_.width = 320;
         BindingManager.executeBindings(this,"nameColumn",this.nameColumn);
         return _loc1_;
      }
      
      protected function ownerNameLabelFunction(param1:Object, param2:DataGridColumn) : String
      {
         if(Boolean(param1) && Boolean(param1.owner))
         {
            return param1.owner.summonerName;
         }
         return "";
      }
      
      [Bindable(event="propertyChange")]
      public function get privateColumn() : DataGridColumn
      {
         return this._159741625privateColumn;
      }
      
      private function _CustomGameDataGrid_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = PrivateCustomGameRenderer;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get nameColumn() : DataGridColumn
      {
         return this._1210718783nameColumn;
      }
      
      private function _CustomGameDataGrid_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = CustomGameSortFunctions.sortByPrivateGame;
         _loc1_ = resourceManager.getString("resources","practiceGame_createOrJoinGame_gameNameColumnHeader");
         _loc1_ = this.getDataGridItemRenderer();
         _loc1_ = CustomGameSortFunctions.sortByGameName;
         _loc1_ = resourceManager.getString("resources","practiceGame_createOrJoinGame_gameOwnerColumnHeader");
         _loc1_ = this.getDataGridItemRenderer();
         _loc1_ = CustomGameSortFunctions.sortByOwnerName;
         _loc1_ = resourceManager.getString("resources","practiceGame_createOrJoinGame_numberOfPlayersAvailableColumnHeader");
         _loc1_ = this.getDataGridItemRenderer();
         _loc1_ = CustomGameSortFunctions.sortByNumberOfPlayersAvailable;
         _loc1_ = RiotResourceLoader.getString("practiceGame_createOrJoinGame_spectatorsColumnHeader");
         _loc1_ = this.getDataGridItemRenderer();
         _loc1_ = CustomGameSortFunctions.sortBySpectatorSlots;
         _loc1_ = resourceManager.getString("resources","practiceGame_createOrJoinGame_mapColumnHeader");
         _loc1_ = this.getDataGridItemRenderer();
         _loc1_ = CustomGameSortFunctions.sortByMapName;
      }
      
      [Bindable(event="propertyChange")]
      public function get spectatorColumn() : DataGridColumn
      {
         return this._1975438043spectatorColumn;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.observerModeChanged && Boolean(this.spectatorColumn))
         {
            this.spectatorColumn.visible = this.observerModeEnabled;
            this.observerModeChanged = false;
         }
      }
      
      public function set observerModeEnabled(param1:Boolean) : void
      {
         this._observerModeEnabled = param1;
         this.observerModeChanged = true;
         invalidateProperties();
      }
      
      [Bindable(event="propertyChange")]
      public function get mapColumn() : DataGridColumn
      {
         return this._450031570mapColumn;
      }
      
      public function set slotsColumn(param1:DataGridColumn) : void
      {
         var _loc2_:Object = this._1988306453slotsColumn;
         if(_loc2_ !== param1)
         {
            this._1988306453slotsColumn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"slotsColumn",_loc2_,param1));
         }
      }
      
      public function set ownerColumn(param1:DataGridColumn) : void
      {
         var _loc2_:Object = this._709517335ownerColumn;
         if(_loc2_ !== param1)
         {
            this._709517335ownerColumn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ownerColumn",_loc2_,param1));
         }
      }
      
      public function set spectatorColumn(param1:DataGridColumn) : void
      {
         var _loc2_:Object = this._1975438043spectatorColumn;
         if(_loc2_ !== param1)
         {
            this._1975438043spectatorColumn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spectatorColumn",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get ownerColumn() : DataGridColumn
      {
         return this._709517335ownerColumn;
      }
      
      private function _CustomGameDataGrid_DataGridColumn3_i() : DataGridColumn
      {
         var _loc1_:DataGridColumn = new DataGridColumn();
         this.ownerColumn = _loc1_;
         _loc1_.dataField = "owner";
         _loc1_.minWidth = 60;
         _loc1_.labelFunction = this.ownerNameLabelFunction;
         BindingManager.executeBindings(this,"ownerColumn",this.ownerColumn);
         return _loc1_;
      }
      
      private function _CustomGameDataGrid_DataGridColumn5_i() : DataGridColumn
      {
         var _loc1_:DataGridColumn = new DataGridColumn();
         this.spectatorColumn = _loc1_;
         _loc1_.dataField = "spectatorSlotText";
         BindingManager.executeBindings(this,"spectatorColumn",this.spectatorColumn);
         return _loc1_;
      }
      
      public function get observerModeEnabled() : Boolean
      {
         return this._observerModeEnabled;
      }
      
      public function set privateColumn(param1:DataGridColumn) : void
      {
         var _loc2_:Object = this._159741625privateColumn;
         if(_loc2_ !== param1)
         {
            this._159741625privateColumn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"privateColumn",_loc2_,param1));
         }
      }
      
      private function _CustomGameDataGrid_DataGridColumn1_i() : DataGridColumn
      {
         var _loc1_:DataGridColumn = new DataGridColumn();
         this.privateColumn = _loc1_;
         _loc1_.dataField = "privateGame";
         _loc1_.width = 30;
         _loc1_.headerText = "";
         _loc1_.itemRenderer = this._CustomGameDataGrid_ClassFactory1_c();
         BindingManager.executeBindings(this,"privateColumn",this.privateColumn);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get slotsColumn() : DataGridColumn
      {
         return this._1988306453slotsColumn;
      }
   }
}

