package mx.containers
{
   import mx.containers.utilityClasses.CanvasLayout;
   import mx.containers.utilityClasses.ConstraintColumn;
   import mx.containers.utilityClasses.ConstraintRow;
   import mx.containers.utilityClasses.IConstraintLayout;
   import mx.core.Container;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [IconFile("Canvas.png")]
   [Exclude(name="focusOutEffect",kind="effect")]
   [Exclude(name="focusInEffect",kind="effect")]
   [Exclude(name="paddingTop",kind="style")]
   [Exclude(name="paddingRight",kind="style")]
   [Exclude(name="paddingLeft",kind="style")]
   [Exclude(name="paddingBottom",kind="style")]
   [Exclude(name="focusThickness",kind="style")]
   [Exclude(name="focusSkin",kind="style")]
   [Exclude(name="focusBlendMode",kind="style")]
   [Exclude(name="focusOut",kind="event")]
   [Exclude(name="focusIn",kind="event")]
   public class Canvas extends Container implements IConstraintLayout
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      [Inspectable(arrayType="mx.containers.utilityClasses.ConstraintColumn")]
      [ArrayElementType("mx.containers.utilityClasses.ConstraintColumn")]
      private var _constraintColumns:Array = [];
      
      private var layoutObject:CanvasLayout = new CanvasLayout();
      
      [Inspectable(arrayType="mx.containers.utilityClasses.ConstraintRow")]
      [ArrayElementType("mx.containers.utilityClasses.ConstraintRow")]
      private var _constraintRows:Array = [];
      
      public function Canvas()
      {
         super();
         layoutObject.target = this;
      }
      
      public function get constraintColumns() : Array
      {
         return _constraintColumns;
      }
      
      override mx_internal function get usePadding() : Boolean
      {
         return false;
      }
      
      public function set constraintRows(value:Array) : void
      {
         var n:int = 0;
         var i:int = 0;
         if(value != _constraintRows)
         {
            n = int(value.length);
            for(i = 0; i < n; i++)
            {
               ConstraintRow(value[i]).container = this;
            }
            _constraintRows = value;
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      public function get constraintRows() : Array
      {
         return _constraintRows;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         layoutObject.updateDisplayList(unscaledWidth,unscaledHeight);
      }
      
      public function set constraintColumns(value:Array) : void
      {
         var n:int = 0;
         var i:int = 0;
         if(value != _constraintColumns)
         {
            n = int(value.length);
            for(i = 0; i < n; i++)
            {
               ConstraintColumn(value[i]).container = this;
            }
            _constraintColumns = value;
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         layoutObject.measure();
      }
   }
}

