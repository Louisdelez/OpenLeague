package com.riotgames.platform.gameclient.views.summoner.stats
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
   import mx.controls.DataGrid;
   import mx.controls.dataGridClasses.DataGridColumn;
   import mx.core.mx_internal;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class LifetimeStatsGrid extends DataGrid implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      mx_internal var _watchers:Array;
      
      public var _LifetimeStatsGrid_DataGridColumn1:DataGridColumn;
      
      public var _LifetimeStatsGrid_DataGridColumn2:DataGridColumn;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      mx_internal var _bindingsByDestination:Object;
      
      public var statFormatter:Function = null;
      
      mx_internal var _bindings:Array;
      
      public function LifetimeStatsGrid()
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
            this.horizontalGridLines = false;
            this.horizontalGridLineColor = 10058542;
            this.verticalGridLines = false;
            this.useRollOver = false;
            this.dropShadowEnabled = false;
            this.verticalScrollBarStyleName = "yellow";
         };
         this.rowHeight = 23;
         this.draggableColumns = false;
         this.selectable = false;
         this.styleName = "profileDataGridStats";
         this.resizableColumns = false;
         this.verticalScrollPolicy = "auto";
         this.showHeaders = false;
         this.mouseEnabled = true;
         this.mouseChildren = true;
         this.columns = [this._LifetimeStatsGrid_DataGridColumn1_i(),this._LifetimeStatsGrid_DataGridColumn2_i()];
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         LifetimeStatsGrid._watcherSetupUtil = param1;
      }
      
      private function _LifetimeStatsGrid_DataGridColumn1_i() : DataGridColumn
      {
         var _loc1_:DataGridColumn = new DataGridColumn();
         this._LifetimeStatsGrid_DataGridColumn1 = _loc1_;
         _loc1_.dataField = "displayName";
         _loc1_.setStyle("textAlign","right");
         _loc1_.setStyle("color",0);
         BindingManager.executeBindings(this,"_LifetimeStatsGrid_DataGridColumn1",this._LifetimeStatsGrid_DataGridColumn1);
         return _loc1_;
      }
      
      private function _LifetimeStatsGrid_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Number
         {
            return this.width * 0.7;
         },function(param1:Number):void
         {
            _LifetimeStatsGrid_DataGridColumn1.width = param1;
         },"_LifetimeStatsGrid_DataGridColumn1.width");
         result[0] = binding;
         binding = new Binding(this,function():Number
         {
            return this.width * 0.3;
         },function(param1:Number):void
         {
            _LifetimeStatsGrid_DataGridColumn2.width = param1;
         },"_LifetimeStatsGrid_DataGridColumn2.width");
         result[1] = binding;
         return result;
      }
      
      override public function initialize() : void
      {
         var i:uint;
         var target:LifetimeStatsGrid = null;
         var watcherSetupUtilClass:Object = null;
         var bindings:Array = this._LifetimeStatsGrid_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_summoner_stats_LifetimeStatsGridWatcherSetupUtil");
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
      
      private function formatValue(param1:Object, param2:DataGridColumn) : String
      {
         if(this.statFormatter != null)
         {
            return this.statFormatter(param1,param2);
         }
         return param1.value;
      }
      
      private function _LifetimeStatsGrid_DataGridColumn2_i() : DataGridColumn
      {
         var _loc1_:DataGridColumn = new DataGridColumn();
         this._LifetimeStatsGrid_DataGridColumn2 = _loc1_;
         _loc1_.dataField = "value";
         _loc1_.labelFunction = this.formatValue;
         _loc1_.setStyle("textAlign","left");
         _loc1_.setStyle("color",12467968);
         BindingManager.executeBindings(this,"_LifetimeStatsGrid_DataGridColumn2",this._LifetimeStatsGrid_DataGridColumn2);
         return _loc1_;
      }
      
      private function _LifetimeStatsGrid_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.width * 0.7;
         _loc1_ = this.width * 0.3;
      }
   }
}

