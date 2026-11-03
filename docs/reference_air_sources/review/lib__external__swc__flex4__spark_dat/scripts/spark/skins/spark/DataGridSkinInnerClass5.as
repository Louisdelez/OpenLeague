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
   public class DataGridSkinInnerClass5 extends Rect implements IGridVisualElement
   {
      
      private var _225390506hoverIndicatorFill:SolidColor;
      
      private var _88844982outerDocument:DataGridSkin;
      
      public function DataGridSkinInnerClass5()
      {
         super();
         this.fill = this._DataGridSkinInnerClass5_SolidColor1_i();
      }
      
      public function prepareGridVisualElement(grid:Grid, rowIndex:int, columnIndex:int) : void
      {
         var dataGrid:DataGrid = grid.dataGrid;
         if(!dataGrid)
         {
            return;
         }
         var color:uint = uint(dataGrid.getStyle("rollOverColor"));
         this.hoverIndicatorFill.color = color;
      }
      
      private function _DataGridSkinInnerClass5_SolidColor1_i() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 13556719;
         this.hoverIndicatorFill = _loc1_;
         BindingManager.executeBindings(this,"hoverIndicatorFill",this.hoverIndicatorFill);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get hoverIndicatorFill() : SolidColor
      {
         return this._225390506hoverIndicatorFill;
      }
      
      public function set hoverIndicatorFill(param1:SolidColor) : void
      {
         var _loc2_:Object = this._225390506hoverIndicatorFill;
         if(_loc2_ !== param1)
         {
            this._225390506hoverIndicatorFill = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hoverIndicatorFill",_loc2_,param1));
            }
         }
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
   }
}

