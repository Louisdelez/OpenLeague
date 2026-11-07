package spark.skins.spark
{
   import mx.binding.BindingManager;
   import mx.events.PropertyChangeEvent;
   import mx.graphics.SolidColor;
   import spark.components.DataGrid;
   import spark.components.Grid;
   import spark.components.gridClasses.IGridVisualElement;
   import spark.primitives.Rect;
   
   [ExcludeClass]
   public class DataGridSkinInnerClass7 extends Rect implements IGridVisualElement
   {
      
      private var _88844982outerDocument:DataGridSkin;
      
      private var _2024155654selectionIndicatorFill:SolidColor;
      
      public function DataGridSkinInnerClass7()
      {
         super();
         this.fill = this._DataGridSkinInnerClass7_SolidColor1_i();
      }
      
      public function prepareGridVisualElement(grid:Grid, rowIndex:int, columnIndex:int) : void
      {
         var dataGrid:DataGrid = grid.dataGrid;
         if(!dataGrid)
         {
            return;
         }
         var color:uint = uint(dataGrid.getStyle("selectionColor"));
         this.selectionIndicatorFill.color = color;
      }
      
      private function _DataGridSkinInnerClass7_SolidColor1_i() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 11060974;
         this.selectionIndicatorFill = _loc1_;
         BindingManager.executeBindings(this,"selectionIndicatorFill",this.selectionIndicatorFill);
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
      public function get selectionIndicatorFill() : SolidColor
      {
         return this._2024155654selectionIndicatorFill;
      }
      
      public function set selectionIndicatorFill(param1:SolidColor) : void
      {
         var _loc2_:Object = this._2024155654selectionIndicatorFill;
         if(_loc2_ !== param1)
         {
            this._2024155654selectionIndicatorFill = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectionIndicatorFill",_loc2_,param1));
            }
         }
      }
   }
}

