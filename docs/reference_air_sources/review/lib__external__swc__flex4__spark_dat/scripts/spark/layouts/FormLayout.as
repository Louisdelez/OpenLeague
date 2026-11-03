package spark.layouts
{
   import mx.containers.utilityClasses.ConstraintColumn;
   import mx.containers.utilityClasses.Flex;
   import mx.core.ILayoutElement;
   import spark.components.supportClasses.GroupBase;
   import spark.components.supportClasses.SkinnableComponent;
   import spark.layouts.supportClasses.LayoutBase;
   
   public class FormLayout extends VerticalLayout
   {
      
      private var columnWidthsOverride:Vector.<Number>;
      
      public function FormLayout()
      {
         super();
      }
      
      private static function calculateColumnWidthsSum(columnWidths:Vector.<Number>) : Number
      {
         if(columnWidths == null)
         {
            return 0;
         }
         var sum:Number = 0;
         var columnWidthsLength:int = int(columnWidths.length);
         for(var i:int = 0; i < columnWidthsLength; i++)
         {
            sum += columnWidths[i];
         }
         return sum;
      }
      
      private static function getElementLayout(elt:ILayoutElement) : LayoutBase
      {
         var skin:GroupBase = null;
         var layout:LayoutBase = null;
         if(elt is SkinnableComponent)
         {
            skin = SkinnableComponent(elt).skin as GroupBase;
            if(Boolean(skin))
            {
               layout = skin.layout;
            }
         }
         else if(elt is GroupBase)
         {
            layout = GroupBase(elt).layout;
         }
         return layout;
      }
      
      private static function getFormItems(layoutTarget:GroupBase) : Vector.<ILayoutElement>
      {
         var elt:ILayoutElement = null;
         if(!layoutTarget)
         {
            return new Vector.<ILayoutElement>();
         }
         var nElts:int = layoutTarget.numElements;
         var formItems:Vector.<ILayoutElement> = new Vector.<ILayoutElement>();
         for(var i:int = 0; i < nElts; i++)
         {
            elt = layoutTarget.getElementAt(i);
            if(elt.includeInLayout)
            {
               if(getElementLayout(elt) is FormItemLayout)
               {
                  formItems.push(elt);
               }
            }
         }
         return formItems;
      }
      
      override public function set target(value:GroupBase) : void
      {
         var layout:LayoutBase = null;
         var nElts:int = 0;
         var elt:ILayoutElement = null;
         var i:int = 0;
         if(target == value)
         {
            return;
         }
         if(value == null)
         {
            nElts = target.numElements;
            for(i = 0; i < nElts; i++)
            {
               elt = target.getElementAt(i);
               if(elt.includeInLayout)
               {
                  layout = getElementLayout(elt);
                  if(layout is FormItemLayout)
                  {
                     (layout as FormItemLayout).setLayoutColumnWidths(null);
                  }
               }
            }
         }
         super.target = value;
      }
      
      public function getMeasuredColumnWidths() : Vector.<Number>
      {
         var layoutTarget:GroupBase = target;
         if(!layoutTarget)
         {
            return null;
         }
         var formItems:Vector.<ILayoutElement> = getFormItems(layoutTarget);
         return this.calculateColumnMaxWidths(formItems);
      }
      
      public function setLayoutColumnWidths(value:Vector.<Number>) : void
      {
         this.columnWidthsOverride = value;
      }
      
      override public function measure() : void
      {
         super.measure();
         var layoutTarget:GroupBase = target;
         if(!layoutTarget)
         {
            return;
         }
         var formItems:Vector.<ILayoutElement> = getFormItems(layoutTarget);
         var hPadding:Number = paddingLeft + paddingRight;
         var columnMaxWidths:Vector.<Number> = this.columnWidthsOverride == null ? this.calculateColumnMaxWidths(formItems) : this.columnWidthsOverride;
         var formWidth:Number = calculateColumnWidthsSum(columnMaxWidths) + hPadding;
         this.constrainPercentColumnWidths(columnMaxWidths,0,formItems);
         var formMinWidth:Number = calculateColumnWidthsSum(columnMaxWidths) + hPadding;
         layoutTarget.measuredWidth = Math.max(formWidth,layoutTarget.measuredWidth);
         layoutTarget.measuredMinWidth = Math.max(formMinWidth,layoutTarget.measuredMinWidth);
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var formItem:ILayoutElement = null;
         var contentWidth:Number = NaN;
         var fiLayout:FormItemLayout = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var layoutTarget:GroupBase = target;
         if(!layoutTarget)
         {
            return;
         }
         var formItems:Vector.<ILayoutElement> = getFormItems(layoutTarget);
         var columnMaxWidths:Vector.<Number> = this.columnWidthsOverride == null ? this.calculateColumnMaxWidths(formItems) : this.columnWidthsOverride;
         var hPadding:Number = paddingLeft + paddingRight;
         if(columnMaxWidths.length > 0)
         {
            this.constrainPercentColumnWidths(columnMaxWidths,unscaledWidth - hPadding,formItems);
            for each(formItem in formItems)
            {
               fiLayout = getElementLayout(formItem) as FormItemLayout;
               fiLayout.setLayoutColumnWidths(columnMaxWidths);
            }
            contentWidth = calculateColumnWidthsSum(columnMaxWidths);
            layoutTarget.setContentSize(contentWidth + hPadding,layoutTarget.contentHeight);
         }
      }
      
      private function calculateColumnMaxWidths(formItems:Vector.<ILayoutElement>) : Vector.<Number>
      {
         var formItem:ILayoutElement = null;
         var fiLayout:FormItemLayout = null;
         var colWidths:Vector.<Number> = null;
         var k:int = 0;
         var j:int = 0;
         if(formItems.length == 0)
         {
            return new Vector.<Number>();
         }
         var columnMaxWidths:Vector.<Number> = new Vector.<Number>();
         var lastColumnCount:Number = NaN;
         for each(formItem in formItems)
         {
            fiLayout = getElementLayout(formItem) as FormItemLayout;
            colWidths = fiLayout.getMeasuredColumnWidths();
            if(isNaN(lastColumnCount))
            {
               lastColumnCount = colWidths.length;
            }
            if(columnMaxWidths.length == 0)
            {
               for(j = 0; j < colWidths.length; j++)
               {
                  columnMaxWidths[j] = 0;
               }
            }
            if(lastColumnCount != colWidths.length)
            {
               throw new Error("The Form must have form items with the same number of constraint columns");
            }
            for(k = 0; k < colWidths.length; k++)
            {
               columnMaxWidths[k] = Math.max(columnMaxWidths[k],colWidths[k]);
            }
         }
         return columnMaxWidths;
      }
      
      private function constrainPercentColumnWidths(colWidths:Vector.<Number>, constrainedWidth:Number, formItems:Vector.<ILayoutElement>) : void
      {
         var fiLayout:FormItemLayout = null;
         var constraintColumns:Vector.<ConstraintColumn> = null;
         var col:ConstraintColumn = null;
         var childInfo:ColumnFlexChildInfo = null;
         var roundOff:Number = NaN;
         var colWidth:Number = NaN;
         if(formItems.length == 0)
         {
            return;
         }
         fiLayout = getElementLayout(formItems[0]) as FormItemLayout;
         constraintColumns = fiLayout.constraintColumns;
         var numCols:int = int(constraintColumns.length);
         var childInfoArray:Array = [];
         var remainingWidth:Number = constrainedWidth;
         var percentMinWidths:Number = 0;
         var totalPercent:Number = 0;
         for(var i:int = 0; i < numCols; i++)
         {
            col = constraintColumns[i];
            if(!isNaN(col.percentWidth))
            {
               colWidths[i] = !isNaN(col.minWidth) ? Math.ceil(Math.max(col.minWidth,0)) : 0;
               percentMinWidths += colWidths[i];
               totalPercent += col.percentWidth;
               childInfo = new ColumnFlexChildInfo();
               childInfo.index = i;
               childInfo.percent = col.percentWidth;
               childInfo.min = col.minWidth;
               childInfo.max = col.maxWidth;
               childInfoArray.push(childInfo);
            }
            else
            {
               remainingWidth -= colWidths[i];
            }
         }
         if(remainingWidth > percentMinWidths)
         {
            Flex.flexChildrenProportionally(constrainedWidth,remainingWidth,totalPercent,childInfoArray);
            roundOff = 0;
            for each(childInfo in childInfoArray)
            {
               colWidth = Math.round(childInfo.size + roundOff);
               roundOff += childInfo.size - colWidth;
               colWidths[childInfo.index] = colWidth;
               remainingWidth -= colWidth;
            }
         }
      }
   }
}

import mx.containers.utilityClasses.FlexChildInfo;

class ColumnFlexChildInfo extends FlexChildInfo
{
   
   public var index:int;
   
   public function ColumnFlexChildInfo()
   {
      super();
   }
}
