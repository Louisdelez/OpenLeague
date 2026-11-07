package mx.containers
{
   import flash.display.DisplayObject;
   import mx.containers.gridClasses.GridColumnInfo;
   import mx.containers.gridClasses.GridRowInfo;
   import mx.containers.utilityClasses.Flex;
   import mx.core.EdgeMetrics;
   import mx.core.ScrollPolicy;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [Exclude(name="moveEffect",kind="effect")]
   [Exclude(name="focusOutEffect",kind="effect")]
   [Exclude(name="focusInEffect",kind="effect")]
   [Exclude(name="verticalScrollBarStyleName",kind="style")]
   [Exclude(name="verticalGap",kind="style")]
   [Exclude(name="horizontalScrollBarStyleName",kind="style")]
   [Exclude(name="horizontalGap",kind="style")]
   [Exclude(name="focusThickness",kind="style")]
   [Exclude(name="focusSkin",kind="style")]
   [Exclude(name="focusBlendMode",kind="style")]
   [Exclude(name="scroll",kind="event")]
   [Exclude(name="move",kind="event")]
   [Exclude(name="focusOut",kind="event")]
   [Exclude(name="focusIn",kind="event")]
   [Exclude(name="setFocus",kind="method")]
   [Exclude(name="isOurFocus",kind="method")]
   [Exclude(name="getFocus",kind="method")]
   [Exclude(name="adjustFocusRect",kind="method")]
   [Exclude(name="verticalScrollPosition",kind="property")]
   [Exclude(name="verticalScrollPolicy",kind="property")]
   [Exclude(name="verticalScrollBar",kind="property")]
   [Exclude(name="verticalPageScrollSize",kind="property")]
   [Exclude(name="verticalLineScrollSize",kind="property")]
   [Exclude(name="mouseFocusEnabled",kind="property")]
   [Exclude(name="maxVerticalScrollPosition",kind="property")]
   [Exclude(name="maxHorizontalScrollPosition",kind="property")]
   [Exclude(name="horizontalScrollPosition",kind="property")]
   [Exclude(name="horizontalScrollPolicy",kind="property")]
   [Exclude(name="horizontalScrollBar",kind="property")]
   [Exclude(name="horizontalPageScrollSize",kind="property")]
   [Exclude(name="horizontalLineScrollSize",kind="property")]
   [Exclude(name="focusPane",kind="property")]
   [Exclude(name="focusManager",kind="property")]
   [Exclude(name="focusEnabled",kind="property")]
   [Exclude(name="direction",kind="property")]
   [Exclude(name="clipContent",kind="property")]
   [Style(name="verticalAlign",type="String",enumeration="bottom,middle,top",inherit="no")]
   [Style(name="horizontalAlign",type="String",enumeration="left,center,right",inherit="no")]
   public class GridRow extends HBox
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      internal var rowIndex:int = 0;
      
      internal var columnWidths:Array;
      
      internal var rowHeights:Array;
      
      internal var numGridItems:int;
      
      public function GridRow()
      {
         super();
         super.clipContent = false;
      }
      
      override public function getStyle(styleProp:String) : *
      {
         return styleProp == "horizontalGap" && Boolean(parent) ? Grid(parent).getStyle("horizontalGap") : super.getStyle(styleProp);
      }
      
      override public function invalidateDisplayList() : void
      {
         super.invalidateDisplayList();
         if(Boolean(parent))
         {
            Grid(parent).invalidateDisplayList();
         }
      }
      
      [Inspectable(environment="none")]
      override public function get clipContent() : Boolean
      {
         return false;
      }
      
      override public function set horizontalScrollPolicy(value:String) : void
      {
      }
      
      override public function set clipContent(value:Boolean) : void
      {
      }
      
      internal function doRowLayout(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var child:GridItem = null;
         var colIndex:int = 0;
         var x:Number = NaN;
         var y:Number = NaN;
         var percentHeight:Number = NaN;
         var finalColIndex:int = 0;
         var finalCol:GridColumnInfo = null;
         var w:Number = NaN;
         var finalRowIndex:int = 0;
         var finalRow:GridRowInfo = null;
         var h:Number = NaN;
         var diff:Number = NaN;
         layoutChrome(unscaledWidth,unscaledHeight);
         var n:Number = numChildren;
         if(n == 0)
         {
            return;
         }
         var oldSizeFlag:Boolean = invalidateSizeFlag;
         var oldDisplayListFlag:Boolean = invalidateDisplayListFlag;
         invalidateSizeFlag = true;
         invalidateDisplayListFlag = true;
         if(parent.getChildIndex(this) == 0 || isNaN(columnWidths[0].x) || columnWidths.minWidth != minWidth || columnWidths.maxWidth != maxWidth || columnWidths.preferredWidth != getExplicitOrMeasuredWidth() || columnWidths.percentWidth != percentWidth || columnWidths.width != unscaledWidth || columnWidths.paddingLeft != getStyle("paddingLeft") || columnWidths.paddingRight != getStyle("paddingRight") || columnWidths.horizontalAlign != getStyle("horizontalAlign") || columnWidths.borderStyle != getStyle("borderStyle"))
         {
            calculateColumnWidths();
            columnWidths.minWidth = minWidth;
            columnWidths.maxWidth = maxWidth;
            columnWidths.preferredWidth = getExplicitOrMeasuredWidth();
            columnWidths.percentWidth = percentWidth;
            columnWidths.width = unscaledWidth;
            columnWidths.paddingLeft = getStyle("paddingLeft");
            columnWidths.paddingRight = getStyle("paddingRight");
            columnWidths.horizontalAlign = getStyle("horizontalAlign");
            columnWidths.borderStyle = getStyle("borderStyle");
         }
         var vm:EdgeMetrics = viewMetricsAndPadding;
         for(var i:int = 0; i < n; i++)
         {
            child = GridItem(getChildAt(i));
            colIndex = child.colIndex;
            x = Number(columnWidths[colIndex].x);
            y = vm.top;
            percentHeight = child.percentHeight;
            finalColIndex = Math.min(colIndex + child.colSpan,columnWidths.length);
            finalCol = columnWidths[finalColIndex - 1];
            w = finalCol.x + finalCol.width - x;
            finalRowIndex = Math.min(rowIndex + child.rowSpan,rowHeights.length);
            finalRow = rowHeights[finalRowIndex - 1];
            h = finalRow.y + finalRow.height - rowHeights[rowIndex].y - vm.top - vm.bottom;
            diff = w - child.maxWidth;
            if(diff > 0)
            {
               x += diff * layoutObject.getHorizontalAlignValue();
               w -= diff;
            }
            diff = h - child.maxHeight;
            if(Boolean(percentHeight) && percentHeight < 100)
            {
               diff = Math.max(diff,h * (100 - percentHeight));
            }
            if(diff > 0)
            {
               y = diff * layoutObject.getVerticalAlignValue();
               h -= diff;
            }
            w = Math.ceil(w);
            h = Math.ceil(h);
            child.move(x,y);
            child.setActualSize(w,h);
         }
         invalidateSizeFlag = oldSizeFlag;
         invalidateDisplayListFlag = oldDisplayListFlag;
      }
      
      private function calculateColumnWidths() : void
      {
         var spaceToDistribute:Number = NaN;
         var columnInfo:GridColumnInfo = null;
         var left:Number = NaN;
         var i:int = 0;
         var percentWidth:Number = NaN;
         var width:Number = NaN;
         var numFlexChildren:int = 0;
         var vm:EdgeMetrics = viewMetricsAndPadding;
         var gap:Number = getStyle("horizontalGap");
         var numChildren:int = int(columnWidths.length);
         var spaceForChildren:Number = unscaledWidth - vm.left - vm.right - (numChildren - 1) * gap;
         var totalPercentWidth:Number = 0;
         var flexibleColumnWidths:Array = [];
         spaceToDistribute = spaceForChildren;
         for(i = 0; i < numChildren; i++)
         {
            columnInfo = columnWidths[i];
            percentWidth = columnInfo.percent;
            if(Boolean(percentWidth))
            {
               totalPercentWidth += percentWidth;
               flexibleColumnWidths.push(columnInfo);
            }
            else
            {
               width = columnInfo.width = columnInfo.preferred;
               spaceToDistribute -= width;
            }
         }
         if(Boolean(totalPercentWidth))
         {
            spaceToDistribute = Flex.flexChildrenProportionally(spaceForChildren,spaceToDistribute,totalPercentWidth,flexibleColumnWidths);
            numFlexChildren = int(flexibleColumnWidths.length);
            for(i = 0; i < numFlexChildren; i++)
            {
               columnInfo = flexibleColumnWidths[i];
               columnInfo.width = columnInfo.size;
            }
         }
         left = vm.left + spaceToDistribute * layoutObject.getHorizontalAlignValue();
         for(i = 0; i < numChildren; i++)
         {
            columnInfo = columnWidths[i];
            columnInfo.x = left;
            left += columnInfo.width + gap;
         }
      }
      
      [Inspectable(environment="none")]
      override public function get horizontalScrollPolicy() : String
      {
         return ScrollPolicy.OFF;
      }
      
      override public function invalidateSize() : void
      {
         super.invalidateSize();
         if(Boolean(parent))
         {
            Grid(parent).invalidateSize();
         }
      }
      
      internal function updateRowMeasurements() : void
      {
         var hPadding:Number = NaN;
         var child:GridColumnInfo = null;
         var numChildren:Number = columnWidths.length;
         var minWidth:Number = 0;
         var preferredWidth:Number = 0;
         for(var i:int = 0; i < numChildren; i++)
         {
            child = columnWidths[i];
            minWidth += child.min;
            preferredWidth += child.preferred;
         }
         var wPadding:Number = layoutObject.widthPadding(numChildren);
         hPadding = layoutObject.heightPadding(0);
         var rowInfo:GridRowInfo = rowHeights[rowIndex];
         measuredMinWidth = minWidth + wPadding;
         measuredMinHeight = rowInfo.min + hPadding;
         measuredWidth = preferredWidth + wPadding;
         measuredHeight = rowInfo.preferred + hPadding;
      }
      
      override public function set verticalScrollPolicy(value:String) : void
      {
      }
      
      [Inspectable(environment="none")]
      override public function get verticalScrollPolicy() : String
      {
         return ScrollPolicy.OFF;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
      }
      
      override public function setChildIndex(child:DisplayObject, newIndex:int) : void
      {
         super.setChildIndex(child,newIndex);
         Grid(parent).invalidateSize();
         Grid(parent).invalidateDisplayList();
      }
   }
}

