package spark.skins.spark
{
   import flash.accessibility.*;
   import flash.debugger.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.geom.*;
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
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.graphics.SolidColor;
   import mx.styles.*;
   import spark.components.DataGrid;
   import spark.components.Grid;
   import spark.components.gridClasses.IGridVisualElement;
   import spark.primitives.Rect;
   
   [ExcludeClass]
   public class DataGridSkinInnerClass0 extends Rect implements IGridVisualElement
   {
      
      private var _88844982outerDocument:DataGridSkin;
      
      private var _1247411672rowBackgroundFillColor:SolidColor;
      
      public function DataGridSkinInnerClass0()
      {
         super();
         this.fill = this._DataGridSkinInnerClass0_SolidColor1_i();
      }
      
      public function prepareGridVisualElement(grid:Grid, rowIndex:int, columnIndex:int) : void
      {
         var dataGrid:DataGrid = grid.dataGrid;
         if(!dataGrid)
         {
            return;
         }
         var colors:Array = dataGrid.getStyle("alternatingRowColors");
         if(Boolean(colors) && colors.length > 0)
         {
            dataGrid.styleManager.getColorNames(colors);
            this.rowBackgroundFillColor.color = colors[rowIndex % colors.length];
         }
         else
         {
            this.rowBackgroundFillColor.color = 16777215;
         }
      }
      
      private function _DataGridSkinInnerClass0_SolidColor1_i() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 16777215;
         this.rowBackgroundFillColor = _loc1_;
         BindingManager.executeBindings(this,"rowBackgroundFillColor",this.rowBackgroundFillColor);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get outerDocument() : DataGridSkin
      {
         return this._88844982outerDocument;
      }
      
      public function set outerDocument(param1:DataGridSkin) : void
      {
         var _loc2_:Object = this._88844982outerDocument;
         if(_loc2_ !== param1)
         {
            this._88844982outerDocument = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"outerDocument",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rowBackgroundFillColor() : SolidColor
      {
         return this._1247411672rowBackgroundFillColor;
      }
      
      public function set rowBackgroundFillColor(param1:SolidColor) : void
      {
         var _loc2_:Object = this._1247411672rowBackgroundFillColor;
         if(_loc2_ !== param1)
         {
            this._1247411672rowBackgroundFillColor = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rowBackgroundFillColor",_loc2_,param1));
            }
         }
      }
   }
}

