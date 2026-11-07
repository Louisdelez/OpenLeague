package spark.layouts
{
   import spark.components.supportClasses.GroupBase;
   
   public class FormItemLayout extends ConstraintLayout
   {
      
      private var layoutColumnWidths:Vector.<Number> = null;
      
      public function FormItemLayout()
      {
         super();
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         checkUseVirtualLayout();
         var layoutTarget:GroupBase = target;
         if(!layoutTarget)
         {
            return;
         }
         measureAndPositionColumnsAndRows(unscaledWidth,unscaledHeight);
         if(Boolean(this.layoutColumnWidths))
         {
            setColumnWidths(this.layoutColumnWidths);
         }
         layoutContent(unscaledWidth,unscaledHeight);
      }
      
      public function getMeasuredColumnWidths() : Vector.<Number>
      {
         return measureColumns();
      }
      
      public function setLayoutColumnWidths(value:Vector.<Number>) : void
      {
         this.layoutColumnWidths = value;
         setColumnWidths(this.layoutColumnWidths);
         target.invalidateDisplayList();
      }
   }
}

