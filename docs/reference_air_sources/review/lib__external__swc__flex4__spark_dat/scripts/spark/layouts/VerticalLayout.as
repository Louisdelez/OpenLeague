package spark.layouts
{
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.containers.utilityClasses.Flex;
   import mx.core.FlexVersion;
   import mx.core.ILayoutElement;
   import mx.core.IVisualElement;
   import mx.events.PropertyChangeEvent;
   import spark.components.DataGroup;
   import spark.components.supportClasses.GroupBase;
   import spark.core.NavigationUnit;
   import spark.layouts.supportClasses.DropLocation;
   import spark.layouts.supportClasses.LayoutBase;
   import spark.layouts.supportClasses.LayoutElementHelper;
   import spark.layouts.supportClasses.LinearLayoutVector;
   
   public class VerticalLayout extends LayoutBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var llv:LinearLayoutVector;
      
      private var _gap:int = 6;
      
      private var _rowCount:int = -1;
      
      private var _horizontalAlign:String = "left";
      
      private var _verticalAlign:String = "top";
      
      private var _paddingLeft:Number = 0;
      
      private var _paddingRight:Number = 0;
      
      private var _paddingTop:Number = 0;
      
      private var _paddingBottom:Number = 0;
      
      private var _requestedMaxRowCount:int = -1;
      
      private var _requestedMinRowCount:int = -1;
      
      private var _requestedRowCount:int = -1;
      
      private var _rowHeight:Number;
      
      private var _variableRowHeight:Boolean = true;
      
      private var _firstIndexInView:int = -1;
      
      private var _lastIndexInView:int = -1;
      
      public function VerticalLayout()
      {
         super();
         dragScrollRegionSizeHorizontal = 0;
      }
      
      private static function calculatePercentWidth(layoutElement:ILayoutElement, width:Number) : Number
      {
         var percentWidth:Number = NaN;
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_6)
         {
            percentWidth = LayoutElementHelper.pinBetween(Math.round(layoutElement.percentWidth * 0.01 * width),layoutElement.getMinBoundsWidth(),layoutElement.getMaxBoundsWidth());
            return percentWidth < width ? percentWidth : width;
         }
         return LayoutElementHelper.pinBetween(Math.min(Math.round(layoutElement.percentWidth * 0.01 * width),width),layoutElement.getMinBoundsWidth(),layoutElement.getMaxBoundsWidth());
      }
      
      private static function sizeLayoutElement(layoutElement:ILayoutElement, width:Number, horizontalAlign:String, restrictedWidth:Number, height:Number, variableRowHeight:Boolean, rowHeight:Number) : void
      {
         var newWidth:Number = NaN;
         if(horizontalAlign == HorizontalAlign.JUSTIFY || horizontalAlign == HorizontalAlign.CONTENT_JUSTIFY)
         {
            newWidth = restrictedWidth;
         }
         else if(!isNaN(layoutElement.percentWidth))
         {
            newWidth = calculatePercentWidth(layoutElement,width);
         }
         if(variableRowHeight)
         {
            layoutElement.setLayoutBoundsSize(newWidth,height);
         }
         else
         {
            layoutElement.setLayoutBoundsSize(newWidth,rowHeight);
         }
      }
      
      private static function findIndexAt(y:Number, gap:int, g:GroupBase, i0:int, i1:int) : int
      {
         var index:int = (i0 + i1) / 2;
         var element:ILayoutElement = g.getElementAt(index);
         var elementY:Number = Number(element.getLayoutBoundsY());
         var elementHeight:Number = Number(element.getLayoutBoundsHeight());
         if(y >= elementY && y < elementY + elementHeight + gap)
         {
            return index;
         }
         if(i0 == i1)
         {
            return -1;
         }
         if(y < elementY)
         {
            return findIndexAt(y,gap,g,i0,Math.max(i0,index - 1));
         }
         return findIndexAt(y,gap,g,Math.min(index + 1,i1),i1);
      }
      
      private static function findLayoutElementIndex(g:GroupBase, i:int, dir:int) : int
      {
         var element:ILayoutElement = null;
         var n:int = g.numElements;
         while(i >= 0 && i < n)
         {
            element = g.getElementAt(i);
            if(Boolean(element) && Boolean(element.includeInLayout))
            {
               return i;
            }
            i += dir;
         }
         return -1;
      }
      
      [Inspectable(category="General")]
      public function get gap() : int
      {
         return this._gap;
      }
      
      public function set gap(value:int) : void
      {
         if(this._gap == value)
         {
            return;
         }
         this._gap = value;
         this.invalidateTargetSizeAndDisplayList();
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get rowCount() : int
      {
         return this._rowCount;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setRowCount(value:int) : void
      {
         if(this._rowCount == value)
         {
            return;
         }
         var oldValue:int = this._rowCount;
         this._rowCount = value;
         dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rowCount",oldValue,value));
      }
      
      [Inspectable(category="General",enumeration="left,right,center,justify,contentJustify",defaultValue="left")]
      public function get horizontalAlign() : String
      {
         return this._horizontalAlign;
      }
      
      public function set horizontalAlign(value:String) : void
      {
         if(value == this._horizontalAlign)
         {
            return;
         }
         this._horizontalAlign = value;
         var layoutTarget:GroupBase = target;
         if(Boolean(layoutTarget))
         {
            layoutTarget.invalidateDisplayList();
         }
      }
      
      [Inspectable(category="General",enumeration="top,bottom,middle",defaultValue="top")]
      public function get verticalAlign() : String
      {
         return this._verticalAlign;
      }
      
      public function set verticalAlign(value:String) : void
      {
         if(value == this._verticalAlign)
         {
            return;
         }
         this._verticalAlign = value;
         var layoutTarget:GroupBase = target;
         if(Boolean(layoutTarget))
         {
            layoutTarget.invalidateDisplayList();
         }
      }
      
      [Inspectable(category="General")]
      public function get paddingLeft() : Number
      {
         return this._paddingLeft;
      }
      
      public function set paddingLeft(value:Number) : void
      {
         if(this._paddingLeft == value)
         {
            return;
         }
         this._paddingLeft = value;
         this.invalidateTargetSizeAndDisplayList();
      }
      
      [Inspectable(category="General")]
      public function get paddingRight() : Number
      {
         return this._paddingRight;
      }
      
      public function set paddingRight(value:Number) : void
      {
         if(this._paddingRight == value)
         {
            return;
         }
         this._paddingRight = value;
         this.invalidateTargetSizeAndDisplayList();
      }
      
      [Inspectable(category="General")]
      public function get paddingTop() : Number
      {
         return this._paddingTop;
      }
      
      public function set paddingTop(value:Number) : void
      {
         if(this._paddingTop == value)
         {
            return;
         }
         this._paddingTop = value;
         this.invalidateTargetSizeAndDisplayList();
      }
      
      [Inspectable(category="General")]
      public function get paddingBottom() : Number
      {
         return this._paddingBottom;
      }
      
      public function set paddingBottom(value:Number) : void
      {
         if(this._paddingBottom == value)
         {
            return;
         }
         this._paddingBottom = value;
         this.invalidateTargetSizeAndDisplayList();
      }
      
      [Inspectable(category="General",minValue="-1")]
      public function get requestedMaxRowCount() : int
      {
         return this._requestedMaxRowCount;
      }
      
      public function set requestedMaxRowCount(value:int) : void
      {
         if(this._requestedMaxRowCount == value)
         {
            return;
         }
         this._requestedMaxRowCount = value;
         if(Boolean(target))
         {
            target.invalidateSize();
         }
      }
      
      [Inspectable(category="General",minValue="-1")]
      public function get requestedMinRowCount() : int
      {
         return this._requestedMinRowCount;
      }
      
      public function set requestedMinRowCount(value:int) : void
      {
         if(this._requestedMinRowCount == value)
         {
            return;
         }
         this._requestedMinRowCount = value;
         if(Boolean(target))
         {
            target.invalidateSize();
         }
      }
      
      [Inspectable(category="General",minValue="-1")]
      public function get requestedRowCount() : int
      {
         return this._requestedRowCount;
      }
      
      public function set requestedRowCount(value:int) : void
      {
         if(this._requestedRowCount == value)
         {
            return;
         }
         this._requestedRowCount = value;
         if(Boolean(target))
         {
            target.invalidateSize();
         }
      }
      
      [Inspectable(category="General",minValue="0.0")]
      public function get rowHeight() : Number
      {
         var elt:ILayoutElement = null;
         if(!isNaN(this._rowHeight))
         {
            return this._rowHeight;
         }
         elt = typicalLayoutElement;
         return Boolean(elt) ? Number(elt.getPreferredBoundsHeight()) : 0;
      }
      
      public function set rowHeight(value:Number) : void
      {
         if(this._rowHeight == value)
         {
            return;
         }
         this._rowHeight = value;
         this.invalidateTargetSizeAndDisplayList();
      }
      
      [Inspectable(category="General",enumeration="true,false")]
      public function get variableRowHeight() : Boolean
      {
         return this._variableRowHeight;
      }
      
      public function set variableRowHeight(value:Boolean) : void
      {
         if(value == this._variableRowHeight)
         {
            return;
         }
         this._variableRowHeight = value;
         this.invalidateTargetSizeAndDisplayList();
      }
      
      [Bindable("indexInViewChanged")]
      [Inspectable(category="General")]
      public function get firstIndexInView() : int
      {
         return this._firstIndexInView;
      }
      
      [Bindable("indexInViewChanged")]
      [Inspectable(category="General")]
      public function get lastIndexInView() : int
      {
         return this._lastIndexInView;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setIndexInView(firstIndex:int, lastIndex:int) : void
      {
         if(this._firstIndexInView == firstIndex && this._lastIndexInView == lastIndex)
         {
            return;
         }
         this._firstIndexInView = firstIndex;
         this._lastIndexInView = lastIndex;
         dispatchEvent(new Event("indexInViewChanged"));
      }
      
      override public function set clipAndEnableScrolling(value:Boolean) : void
      {
         var g:GroupBase = null;
         super.clipAndEnableScrolling = value;
         var vAlign:String = this.verticalAlign;
         if(vAlign == VerticalAlign.MIDDLE || vAlign == VerticalAlign.BOTTOM)
         {
            g = target;
            if(Boolean(g))
            {
               g.invalidateDisplayList();
            }
         }
      }
      
      override public function clearVirtualLayoutCache() : void
      {
         this.llv = null;
         var g:GroupBase = GroupBase(target);
         if(!g)
         {
            return;
         }
         target.invalidateSize();
         target.invalidateDisplayList();
      }
      
      override public function getElementBounds(index:int) : Rectangle
      {
         if(!useVirtualLayout)
         {
            return super.getElementBounds(index);
         }
         var g:GroupBase = GroupBase(target);
         if(!g || index < 0 || index >= g.numElements || !this.llv)
         {
            return null;
         }
         return this.llv.getBounds(index);
      }
      
      public function fractionOfElementInView(index:int) : Number
      {
         var eltY:Number = NaN;
         var eltHeight:Number = NaN;
         var elt:ILayoutElement = null;
         var g:GroupBase = GroupBase(target);
         if(!g)
         {
            return 0;
         }
         if(index < 0 || index >= g.numElements)
         {
            return 0;
         }
         if(!clipAndEnableScrolling)
         {
            return 1;
         }
         var r0:int = this.firstIndexInView;
         var r1:int = this.lastIndexInView;
         if(r0 == -1 || r1 == -1 || index < r0 || index > r1)
         {
            return 0;
         }
         if(index > r0 && index < r1)
         {
            return 1;
         }
         if(useVirtualLayout)
         {
            if(!this.llv)
            {
               return 0;
            }
            eltY = this.llv.start(index);
            eltHeight = this.llv.getMajorSize(index);
         }
         else
         {
            elt = g.getElementAt(index);
            if(!elt || !elt.includeInLayout)
            {
               return 0;
            }
            eltY = Number(elt.getLayoutBoundsY());
            eltHeight = Number(elt.getLayoutBoundsHeight());
         }
         var y0:Number = g.verticalScrollPosition;
         var y1:Number = y0 + g.height;
         var iy0:Number = eltY;
         var iy1:Number = iy0 + eltHeight;
         if(iy0 >= iy1)
         {
            return 1;
         }
         if(iy0 >= y0 && iy1 <= y1)
         {
            return 1;
         }
         return (Math.min(y1,iy1) - Math.max(y0,iy0)) / (iy1 - iy0);
      }
      
      override protected function scrollPositionChanged() : void
      {
         var i0:int = 0;
         var i1:int = 0;
         var index0:int = 0;
         var element0:ILayoutElement = null;
         var element0Y:Number = NaN;
         var elementHeight:Number = NaN;
         var index1:int = 0;
         var element1:ILayoutElement = null;
         var element1Y:Number = NaN;
         var element1Height:Number = NaN;
         var firstElement:ILayoutElement = null;
         var lastElement:ILayoutElement = null;
         var scrollRect:Rectangle = null;
         super.scrollPositionChanged();
         var g:GroupBase = target;
         if(!g)
         {
            return;
         }
         var n:int = g.numElements - 1;
         if(n < 0)
         {
            this.setIndexInView(-1,-1);
            return;
         }
         var scrollR:Rectangle = getScrollRect();
         if(!scrollR)
         {
            this.setIndexInView(0,n);
            return;
         }
         var y0:Number = scrollR.top;
         var y1:Number = scrollR.bottom - 0.0001;
         if(y1 <= y0)
         {
            this.setIndexInView(-1,-1);
            return;
         }
         if(useVirtualLayout && !this.llv)
         {
            this.setIndexInView(-1,-1);
            return;
         }
         if(useVirtualLayout)
         {
            i0 = this.llv.indexOf(y0);
            i1 = this.llv.indexOf(y1);
         }
         else
         {
            i0 = findIndexAt(y0 + this.gap,this.gap,g,0,n);
            i1 = findIndexAt(y1,this.gap,g,0,n);
         }
         if(i0 == -1)
         {
            index0 = findLayoutElementIndex(g,0,1);
            if(index0 != -1)
            {
               element0 = g.getElementAt(index0);
               element0Y = Number(element0.getLayoutBoundsY());
               elementHeight = Number(element0.getLayoutBoundsHeight());
               if(element0Y < y1 && element0Y + elementHeight > y0)
               {
                  i0 = index0;
               }
            }
         }
         if(i1 == -1)
         {
            index1 = findLayoutElementIndex(g,n,-1);
            if(index1 != -1)
            {
               element1 = g.getElementAt(index1);
               element1Y = Number(element1.getLayoutBoundsY());
               element1Height = Number(element1.getLayoutBoundsHeight());
               if(element1Y < y1 && element1Y + element1Height > y0)
               {
                  i1 = index1;
               }
            }
         }
         if(useVirtualLayout)
         {
            firstElement = g.getElementAt(this._firstIndexInView);
            lastElement = g.getElementAt(this._lastIndexInView);
            scrollRect = getScrollRect();
            if(!firstElement || !lastElement || scrollRect.top < firstElement.getLayoutBoundsY() || scrollRect.bottom >= lastElement.getLayoutBoundsY() + lastElement.getLayoutBoundsHeight())
            {
               g.invalidateDisplayList();
            }
         }
         this.setIndexInView(i0,i1);
      }
      
      private function findLayoutElementBounds(g:GroupBase, i:int, dir:int, r:Rectangle) : Rectangle
      {
         var elementR:Rectangle = null;
         var overlapsTop:Boolean = false;
         var overlapsBottom:Boolean = false;
         var n:int = g.numElements;
         if(this.fractionOfElementInView(i) >= 1)
         {
            i += dir;
            if(i < 0)
            {
               return new Rectangle(0,0,0,this.paddingTop);
            }
            if(i >= n)
            {
               return new Rectangle(0,this.getElementBounds(n - 1).bottom,0,this.paddingBottom);
            }
         }
         while(i >= 0 && i < n)
         {
            elementR = this.getElementBounds(i);
            if(Boolean(elementR))
            {
               overlapsTop = dir == -1 && elementR.top == r.top && elementR.bottom >= r.bottom;
               overlapsBottom = dir == 1 && elementR.bottom == r.bottom && elementR.top <= r.top;
               if(!(overlapsTop || overlapsBottom))
               {
                  return elementR;
               }
            }
            i += dir;
         }
         return null;
      }
      
      override protected function getElementBoundsAboveScrollRect(scrollRect:Rectangle) : Rectangle
      {
         return this.findLayoutElementBounds(target,this.firstIndexInView,-1,scrollRect);
      }
      
      override protected function getElementBoundsBelowScrollRect(scrollRect:Rectangle) : Rectangle
      {
         return this.findLayoutElementBounds(target,this.lastIndexInView,1,scrollRect);
      }
      
      private function getElementWidth(element:ILayoutElement, justify:Boolean, result:SizesAndLimit) : void
      {
         var elementPreferredWidth:Number = Math.ceil(element.getPreferredBoundsWidth());
         var flexibleWidth:Boolean = !isNaN(element.percentWidth) || justify;
         var elementMinWidth:Number = flexibleWidth ? Math.ceil(element.getMinBoundsWidth()) : elementPreferredWidth;
         result.preferredSize = elementPreferredWidth;
         result.minSize = elementMinWidth;
      }
      
      private function getElementHeight(element:ILayoutElement, fixedRowHeight:Number, result:SizesAndLimit) : void
      {
         var elementPreferredHeight:Number = isNaN(fixedRowHeight) ? Math.ceil(element.getPreferredBoundsHeight()) : fixedRowHeight;
         var flexibleHeight:Boolean = !isNaN(element.percentHeight);
         var elementMinHeight:Number = flexibleHeight ? Math.ceil(element.getMinBoundsHeight()) : elementPreferredHeight;
         result.preferredSize = elementPreferredHeight;
         result.minSize = elementMinHeight;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getRowsToMeasure(numElementsInLayout:int) : int
      {
         var rowsToMeasure:int = 0;
         if(this.requestedRowCount != -1)
         {
            rowsToMeasure = this.requestedRowCount;
         }
         else
         {
            rowsToMeasure = numElementsInLayout;
            if(this.requestedMaxRowCount != -1)
            {
               rowsToMeasure = Math.min(this.requestedMaxRowCount,rowsToMeasure);
            }
            if(this.requestedMinRowCount != -1)
            {
               rowsToMeasure = Math.max(this.requestedMinRowCount,rowsToMeasure);
            }
         }
         return rowsToMeasure;
      }
      
      private function measureReal(layoutTarget:GroupBase) : void
      {
         var element:ILayoutElement = null;
         var vgap:Number = NaN;
         var size:SizesAndLimit = new SizesAndLimit();
         var justify:Boolean = this.horizontalAlign == HorizontalAlign.JUSTIFY;
         var numElements:int = layoutTarget.numElements;
         var numElementsInLayout:int = numElements;
         var requestedRowCount:int = this.requestedRowCount;
         var rowsMeasured:int = 0;
         var preferredHeight:Number = 0;
         var preferredWidth:Number = 0;
         var minHeight:Number = 0;
         var minWidth:Number = 0;
         var fixedRowHeight:Number = NaN;
         if(!this.variableRowHeight)
         {
            fixedRowHeight = this.rowHeight;
         }
         var rowsToMeasure:int = this.getRowsToMeasure(numElementsInLayout);
         for(var i:int = 0; i < numElements; i++)
         {
            element = layoutTarget.getElementAt(i);
            if(!element || !element.includeInLayout)
            {
               numElementsInLayout--;
            }
            else
            {
               if(rowsMeasured < rowsToMeasure)
               {
                  this.getElementHeight(element,fixedRowHeight,size);
                  preferredHeight += size.preferredSize;
                  minHeight += size.minSize;
                  rowsMeasured++;
               }
               this.getElementWidth(element,justify,size);
               preferredWidth = Math.max(preferredWidth,size.preferredSize);
               minWidth = Math.max(minWidth,size.minSize);
            }
         }
         rowsToMeasure = this.getRowsToMeasure(numElementsInLayout);
         if(rowsMeasured < rowsToMeasure)
         {
            element = typicalLayoutElement;
            if(Boolean(element))
            {
               this.getElementHeight(element,fixedRowHeight,size);
               preferredHeight += size.preferredSize * (rowsToMeasure - rowsMeasured);
               minHeight += size.minSize * (rowsToMeasure - rowsMeasured);
               this.getElementWidth(element,justify,size);
               preferredWidth = Math.max(preferredWidth,size.preferredSize);
               minWidth = Math.max(minWidth,size.minSize);
               rowsMeasured = rowsToMeasure;
            }
         }
         if(rowsMeasured > 1)
         {
            vgap = this.gap * (rowsMeasured - 1);
            preferredHeight += vgap;
            minHeight += vgap;
         }
         var hPadding:Number = this.paddingLeft + this.paddingRight;
         var vPadding:Number = this.paddingTop + this.paddingBottom;
         layoutTarget.measuredHeight = preferredHeight + vPadding;
         layoutTarget.measuredWidth = preferredWidth + hPadding;
         layoutTarget.measuredMinHeight = minHeight + vPadding;
         layoutTarget.measuredMinWidth = minWidth + hPadding;
      }
      
      private function updateLLV(layoutTarget:GroupBase) : void
      {
         var typicalWidth:Number = NaN;
         var typicalHeight:Number = NaN;
         if(!this.llv)
         {
            this.llv = new LinearLayoutVector();
            this.llv.defaultMinorSize = 71;
            this.llv.defaultMajorSize = 22;
         }
         var typicalElt:ILayoutElement = typicalLayoutElement;
         if(Boolean(typicalElt))
         {
            typicalWidth = Number(typicalElt.getPreferredBoundsWidth());
            typicalHeight = Number(typicalElt.getPreferredBoundsHeight());
            this.llv.defaultMinorSize = typicalWidth;
            this.llv.defaultMajorSize = typicalHeight;
         }
         if(!isNaN(this._rowHeight))
         {
            this.llv.defaultMajorSize = this._rowHeight;
         }
         if(Boolean(layoutTarget))
         {
            this.llv.length = layoutTarget.numElements;
         }
         this.llv.gap = this.gap;
         this.llv.majorAxisOffset = this.paddingTop;
      }
      
      override public function elementAdded(index:int) : void
      {
         if(Boolean(this.llv) && Boolean(index >= 0) && useVirtualLayout)
         {
            this.llv.insert(index);
         }
      }
      
      override public function elementRemoved(index:int) : void
      {
         if(Boolean(this.llv) && Boolean(index >= 0) && useVirtualLayout)
         {
            this.llv.remove(index);
         }
      }
      
      private function measureVirtual(layoutTarget:GroupBase) : void
      {
         var oldLength:int = 0;
         var measuredHeight:Number = NaN;
         var dataGroupTarget:DataGroup = null;
         var indices:Vector.<int> = null;
         var i:int = 0;
         var element:ILayoutElement = null;
         var vgap:Number = NaN;
         var eltCount:int = layoutTarget.numElements;
         var measuredEltCount:int = this.getRowsToMeasure(eltCount);
         var hPadding:Number = this.paddingLeft + this.paddingRight;
         var vPadding:Number = this.paddingTop + this.paddingBottom;
         if(measuredEltCount <= 0)
         {
            layoutTarget.measuredWidth = layoutTarget.measuredMinWidth = hPadding;
            layoutTarget.measuredHeight = layoutTarget.measuredMinHeight = vPadding;
            return;
         }
         this.updateLLV(layoutTarget);
         if(this.variableRowHeight)
         {
            oldLength = -1;
            if(measuredEltCount > this.llv.length)
            {
               oldLength = int(this.llv.length);
               this.llv.length = measuredEltCount;
            }
            measuredHeight = this.llv.end(measuredEltCount - 1) + this.paddingBottom;
            dataGroupTarget = layoutTarget as DataGroup;
            if(Boolean(dataGroupTarget))
            {
               indices = dataGroupTarget.getItemIndicesInView();
               for each(i in indices)
               {
                  element = dataGroupTarget.getElementAt(i);
                  if(Boolean(element))
                  {
                     measuredHeight -= this.llv.getMajorSize(i);
                     measuredHeight += element.getPreferredBoundsHeight();
                  }
               }
            }
            layoutTarget.measuredHeight = measuredHeight;
            if(oldLength != -1)
            {
               this.llv.length = oldLength;
            }
         }
         else
         {
            vgap = measuredEltCount > 1 ? (measuredEltCount - 1) * this.gap : 0;
            layoutTarget.measuredHeight = measuredEltCount * this.rowHeight + vgap + vPadding;
         }
         layoutTarget.measuredWidth = this.llv.minorSize + hPadding;
         layoutTarget.measuredMinWidth = this.horizontalAlign == HorizontalAlign.JUSTIFY ? this.llv.minMinorSize + hPadding : Number(layoutTarget.measuredWidth);
         layoutTarget.measuredMinHeight = layoutTarget.measuredHeight;
      }
      
      override public function measure() : void
      {
         var layoutTarget:GroupBase = target;
         if(!layoutTarget)
         {
            return;
         }
         if(useVirtualLayout)
         {
            this.measureVirtual(layoutTarget);
         }
         else
         {
            this.measureReal(layoutTarget);
         }
         layoutTarget.measuredWidth = Math.ceil(layoutTarget.measuredWidth);
         layoutTarget.measuredHeight = Math.ceil(layoutTarget.measuredHeight);
         layoutTarget.measuredMinWidth = Math.ceil(layoutTarget.measuredMinWidth);
         layoutTarget.measuredMinHeight = Math.ceil(layoutTarget.measuredMinHeight);
      }
      
      override public function getNavigationDestinationIndex(currentIndex:int, navigationUnit:uint, arrowKeysWrapFocus:Boolean) : int
      {
         var newIndex:int = 0;
         var bounds:Rectangle = null;
         var y:Number = NaN;
         var firstVisible:int = 0;
         var firstFullyVisible:int = 0;
         var lastVisible:int = 0;
         var lastFullyVisible:int = 0;
         if(!target || target.numElements < 1)
         {
            return -1;
         }
         var maxIndex:int = target.numElements - 1;
         if(currentIndex == -1)
         {
            if(navigationUnit == NavigationUnit.UP)
            {
               return arrowKeysWrapFocus ? maxIndex : -1;
            }
            if(navigationUnit == NavigationUnit.DOWN)
            {
               return 0;
            }
         }
         currentIndex = Math.max(0,Math.min(maxIndex,currentIndex));
         switch(navigationUnit)
         {
            case NavigationUnit.UP:
               if(arrowKeysWrapFocus && currentIndex == 0)
               {
                  newIndex = maxIndex;
               }
               else
               {
                  newIndex = currentIndex - 1;
               }
               break;
            case NavigationUnit.DOWN:
               if(arrowKeysWrapFocus && currentIndex == maxIndex)
               {
                  newIndex = 0;
               }
               else
               {
                  newIndex = currentIndex + 1;
               }
               break;
            case NavigationUnit.PAGE_UP:
               firstVisible = this.firstIndexInView;
               firstFullyVisible = firstVisible;
               if(this.fractionOfElementInView(firstFullyVisible) < 1)
               {
                  firstFullyVisible += 1;
               }
               if(firstFullyVisible < currentIndex && currentIndex <= this.lastIndexInView)
               {
                  newIndex = firstFullyVisible;
               }
               else
               {
                  if(currentIndex == firstFullyVisible || currentIndex == firstVisible)
                  {
                     y = getVerticalScrollPositionDelta(NavigationUnit.PAGE_UP) + getScrollRect().top;
                  }
                  else
                  {
                     y = this.getElementBounds(currentIndex).bottom - getScrollRect().height;
                  }
                  newIndex = currentIndex - 1;
                  while(0 <= newIndex)
                  {
                     bounds = this.getElementBounds(newIndex);
                     if(Boolean(bounds) && bounds.top < y)
                     {
                        newIndex = Math.min(currentIndex - 1,newIndex + 1);
                        break;
                     }
                     newIndex--;
                  }
               }
               break;
            case NavigationUnit.PAGE_DOWN:
               lastVisible = this.lastIndexInView;
               lastFullyVisible = lastVisible;
               if(this.fractionOfElementInView(lastFullyVisible) < 1)
               {
                  lastFullyVisible -= 1;
               }
               if(this.firstIndexInView <= currentIndex && currentIndex < lastFullyVisible)
               {
                  newIndex = lastFullyVisible;
               }
               else
               {
                  if(currentIndex == lastFullyVisible || currentIndex == lastVisible)
                  {
                     y = getVerticalScrollPositionDelta(NavigationUnit.PAGE_DOWN) + getScrollRect().bottom;
                  }
                  else
                  {
                     y = this.getElementBounds(currentIndex).top + getScrollRect().height;
                  }
                  newIndex = currentIndex + 1;
                  while(newIndex <= maxIndex)
                  {
                     bounds = this.getElementBounds(newIndex);
                     if(Boolean(bounds) && bounds.bottom > y)
                     {
                        newIndex = Math.max(currentIndex + 1,newIndex - 1);
                        break;
                     }
                     newIndex++;
                  }
               }
               break;
            default:
               return super.getNavigationDestinationIndex(currentIndex,navigationUnit,arrowKeysWrapFocus);
         }
         return Math.max(0,Math.min(maxIndex,newIndex));
      }
      
      private function calculateElementWidth(elt:ILayoutElement, targetWidth:Number, containerWidth:Number) : Number
      {
         var width:Number = NaN;
         var percentWidth:Number = Number(elt.percentWidth);
         if(!isNaN(percentWidth))
         {
            width = percentWidth * 0.01 * targetWidth;
            return Math.min(targetWidth,Math.min(elt.getMaxBoundsWidth(),Math.max(elt.getMinBoundsWidth(),width)));
         }
         switch(this.horizontalAlign)
         {
            case HorizontalAlign.JUSTIFY:
               return targetWidth;
            case HorizontalAlign.CONTENT_JUSTIFY:
               return Math.max(elt.getPreferredBoundsWidth(),containerWidth);
            default:
               return NaN;
         }
      }
      
      private function calculateElementX(elt:ILayoutElement, eltWidth:Number, containerWidth:Number) : Number
      {
         switch(this.horizontalAlign)
         {
            case HorizontalAlign.CENTER:
               return Math.round((containerWidth - eltWidth) * 0.5);
            case HorizontalAlign.RIGHT:
               return containerWidth - eltWidth;
            default:
               return 0;
         }
      }
      
      private function updateDisplayListVirtual() : void
      {
         var contentHeight:Number = NaN;
         var paddedContentHeight:Number = NaN;
         var elt:ILayoutElement = null;
         var w:Number = NaN;
         var h:Number = NaN;
         var x:Number = NaN;
         var excessHeight:Number = NaN;
         var dy:Number = NaN;
         var vAlign:String = null;
         var layoutTarget:GroupBase = target;
         var eltCount:int = layoutTarget.numElements;
         var targetWidth:Number = Math.max(0,layoutTarget.width - this.paddingLeft - this.paddingRight);
         var minVisibleY:Number = layoutTarget.verticalScrollPosition;
         var maxVisibleY:Number = minVisibleY + layoutTarget.height;
         this.updateLLV(layoutTarget);
         var startIndex:int = this.llv.indexOf(Math.max(0,minVisibleY + this.gap));
         if(startIndex == -1)
         {
            contentHeight = this.llv.end(this.llv.length - 1) - this.paddingTop;
            paddedContentHeight = Math.ceil(contentHeight + this.paddingTop + this.paddingBottom);
            layoutTarget.setContentSize(layoutTarget.contentWidth,paddedContentHeight);
            return;
         }
         var fixedRowHeight:Number = NaN;
         if(!this.variableRowHeight)
         {
            fixedRowHeight = this.rowHeight;
         }
         var justifyWidths:Boolean = this.horizontalAlign == HorizontalAlign.JUSTIFY;
         var eltWidth:Number = justifyWidths ? targetWidth : NaN;
         var eltHeight:Number = NaN;
         var contentWidth:Number = justifyWidths ? Math.max(this.llv.minMinorSize,targetWidth) : this.llv.minorSize;
         var containerWidth:Number = Math.max(contentWidth,targetWidth);
         var y:Number = this.llv.start(startIndex);
         var index:int = startIndex;
         var x0:Number = this.paddingLeft;
         while(y < maxVisibleY && index < eltCount)
         {
            elt = layoutTarget.getVirtualElementAt(index,eltWidth,eltHeight);
            w = this.calculateElementWidth(elt,targetWidth,containerWidth);
            h = fixedRowHeight;
            elt.setLayoutBoundsSize(w,h);
            w = Number(elt.getLayoutBoundsWidth());
            h = Number(elt.getLayoutBoundsHeight());
            x = x0 + this.calculateElementX(elt,w,containerWidth);
            elt.setLayoutBoundsPosition(x,y);
            this.llv.cacheDimensions(index,elt);
            y += h + this.gap;
            index++;
         }
         var endIndex:int = index - 1;
         if(!justifyWidths && this.llv.minorSize != contentWidth)
         {
            contentWidth = this.llv.minorSize;
            containerWidth = Math.max(contentWidth,targetWidth);
            if(this.horizontalAlign != HorizontalAlign.LEFT)
            {
               for(index = startIndex; index <= endIndex; index++)
               {
                  elt = layoutTarget.getElementAt(index);
                  w = this.calculateElementWidth(elt,targetWidth,containerWidth);
                  elt.setLayoutBoundsSize(w,elt.getLayoutBoundsHeight());
                  w = Number(elt.getLayoutBoundsWidth());
                  x = x0 + this.calculateElementX(elt,w,containerWidth);
                  elt.setLayoutBoundsPosition(x,elt.getLayoutBoundsY());
               }
            }
         }
         contentHeight = this.llv.end(this.llv.length - 1) - this.paddingTop;
         var targetHeight:Number = Math.max(0,layoutTarget.height - this.paddingTop - this.paddingBottom);
         if(contentHeight < targetHeight)
         {
            excessHeight = targetHeight - contentHeight;
            dy = 0;
            vAlign = this.verticalAlign;
            if(vAlign == VerticalAlign.MIDDLE)
            {
               dy = Math.round(excessHeight / 2);
            }
            else if(vAlign == VerticalAlign.BOTTOM)
            {
               dy = excessHeight;
            }
            if(dy > 0)
            {
               for(index = startIndex; index <= endIndex; index++)
               {
                  elt = layoutTarget.getElementAt(index);
                  elt.setLayoutBoundsPosition(elt.getLayoutBoundsX(),dy + elt.getLayoutBoundsY());
               }
               contentHeight += dy;
            }
         }
         this.setRowCount(index - startIndex);
         this.setIndexInView(startIndex,endIndex);
         var paddedContentWidth:Number = Math.ceil(contentWidth + this.paddingLeft + this.paddingRight);
         paddedContentHeight = Math.ceil(contentHeight + this.paddingTop + this.paddingBottom);
         layoutTarget.setContentSize(paddedContentWidth,paddedContentHeight);
      }
      
      private function updateDisplayListReal() : void
      {
         var layoutElement:ILayoutElement = null;
         var i:int = 0;
         var layoutElementWidth:Number = NaN;
         var vAlign:String = null;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var x:Number = NaN;
         var layoutTarget:GroupBase = target;
         var targetWidth:Number = Math.max(0,layoutTarget.width - this.paddingLeft - this.paddingRight);
         var targetHeight:Number = Math.max(0,layoutTarget.height - this.paddingTop - this.paddingBottom);
         var count:int = layoutTarget.numElements;
         var containerWidth:Number = targetWidth;
         if(this.horizontalAlign == HorizontalAlign.CONTENT_JUSTIFY || clipAndEnableScrolling && (this.horizontalAlign == HorizontalAlign.CENTER || this.horizontalAlign == HorizontalAlign.RIGHT))
         {
            for(i = 0; i < count; i++)
            {
               layoutElement = layoutTarget.getElementAt(i);
               if(!(!layoutElement || !layoutElement.includeInLayout))
               {
                  if(!isNaN(layoutElement.percentWidth))
                  {
                     layoutElementWidth = calculatePercentWidth(layoutElement,targetWidth);
                  }
                  else
                  {
                     layoutElementWidth = Number(layoutElement.getPreferredBoundsWidth());
                  }
                  containerWidth = Math.max(containerWidth,Math.ceil(layoutElementWidth));
               }
            }
         }
         var excessHeight:Number = this.distributeHeight(targetWidth,targetHeight,containerWidth);
         var hAlign:Number = 0;
         if(this.horizontalAlign == HorizontalAlign.CENTER)
         {
            hAlign = 0.5;
         }
         else if(this.horizontalAlign == HorizontalAlign.RIGHT)
         {
            hAlign = 1;
         }
         var visibleRows:uint = 0;
         var minVisibleY:Number = layoutTarget.verticalScrollPosition;
         var maxVisibleY:Number = minVisibleY + targetHeight;
         var x0:Number = this.paddingLeft;
         var y:Number = this.paddingTop;
         var maxX:Number = this.paddingLeft;
         var maxY:Number = this.paddingTop;
         var firstRowInView:int = -1;
         var lastRowInView:int = -1;
         if(excessHeight > 0 || !clipAndEnableScrolling)
         {
            vAlign = this.verticalAlign;
            if(vAlign == VerticalAlign.MIDDLE)
            {
               y = this.paddingTop + Math.round(excessHeight / 2);
            }
            else if(vAlign == VerticalAlign.BOTTOM)
            {
               y = this.paddingTop + excessHeight;
            }
         }
         for(var index:int = 0; index < count; index++)
         {
            layoutElement = layoutTarget.getElementAt(index);
            if(!(!layoutElement || !layoutElement.includeInLayout))
            {
               dx = Math.ceil(layoutElement.getLayoutBoundsWidth());
               dy = Math.ceil(layoutElement.getLayoutBoundsHeight());
               x = x0 + (containerWidth - dx) * hAlign;
               if(hAlign == 0.5)
               {
                  x = Math.round(x);
               }
               layoutElement.setLayoutBoundsPosition(x,y);
               maxX = Math.max(maxX,x + dx);
               maxY = Math.max(maxY,y + dy);
               if(!clipAndEnableScrolling || y < maxVisibleY && y + dy > minVisibleY || dy <= 0 && (y == maxVisibleY || y == minVisibleY))
               {
                  visibleRows += 1;
                  if(firstRowInView == -1)
                  {
                     firstRowInView = lastRowInView = index;
                  }
                  else
                  {
                     lastRowInView = index;
                  }
               }
               y += dy + this.gap;
            }
         }
         this.setRowCount(visibleRows);
         this.setIndexInView(firstRowInView,lastRowInView);
         layoutTarget.setContentSize(Math.ceil(maxX + this.paddingRight),Math.ceil(maxY + this.paddingBottom));
      }
      
      private function distributeHeight(width:Number, height:Number, restrictedWidth:Number) : Number
      {
         var childInfo:LayoutElementFlexChildInfo = null;
         var layoutElement:ILayoutElement = null;
         var roundOff:Number = NaN;
         var childSize:int = 0;
         var spaceToDistribute:Number = height;
         var totalPercentHeight:Number = 0;
         var childInfoArray:Array = [];
         var rh:Number = this.variableRowHeight ? 0 : Math.ceil(this.rowHeight);
         var count:int = target.numElements;
         var totalCount:int = count;
         for(var index:int = 0; index < count; index++)
         {
            layoutElement = target.getElementAt(index);
            if(!layoutElement || !layoutElement.includeInLayout)
            {
               totalCount--;
            }
            else if(!isNaN(layoutElement.percentHeight) && this.variableRowHeight)
            {
               totalPercentHeight += layoutElement.percentHeight;
               childInfo = new LayoutElementFlexChildInfo();
               childInfo.layoutElement = layoutElement;
               childInfo.percent = layoutElement.percentHeight;
               childInfo.min = layoutElement.getMinBoundsHeight();
               childInfo.max = layoutElement.getMaxBoundsHeight();
               childInfoArray.push(childInfo);
            }
            else
            {
               sizeLayoutElement(layoutElement,width,this.horizontalAlign,restrictedWidth,NaN,this.variableRowHeight,rh);
               spaceToDistribute -= Math.ceil(layoutElement.getLayoutBoundsHeight());
            }
         }
         if(totalCount > 1)
         {
            spaceToDistribute -= (totalCount - 1) * this.gap;
         }
         if(Boolean(totalPercentHeight))
         {
            Flex.flexChildrenProportionally(height,spaceToDistribute,totalPercentHeight,childInfoArray);
            roundOff = 0;
            for each(childInfo in childInfoArray)
            {
               childSize = Math.round(childInfo.size + roundOff);
               roundOff += childInfo.size - childSize;
               sizeLayoutElement(childInfo.layoutElement,width,this.horizontalAlign,restrictedWidth,childSize,this.variableRowHeight,rh);
               spaceToDistribute -= childSize;
            }
         }
         return spaceToDistribute;
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var layoutTarget:GroupBase = target;
         if(!layoutTarget)
         {
            return;
         }
         if(layoutTarget.numElements == 0 || unscaledWidth == 0 || unscaledHeight == 0)
         {
            this.setRowCount(0);
            this.setIndexInView(-1,-1);
            if(layoutTarget.numElements == 0)
            {
               layoutTarget.setContentSize(Math.ceil(this.paddingLeft + this.paddingRight),Math.ceil(this.paddingTop + this.paddingBottom));
            }
            return;
         }
         if(useVirtualLayout)
         {
            this.updateDisplayListVirtual();
         }
         else
         {
            this.updateDisplayListReal();
         }
      }
      
      private function invalidateTargetSizeAndDisplayList() : void
      {
         var g:GroupBase = target;
         if(!g)
         {
            return;
         }
         g.invalidateSize();
         g.invalidateDisplayList();
      }
      
      override protected function calculateDropIndex(x:Number, y:Number) : int
      {
         var elementBounds:Rectangle = null;
         var curDistance:Number = NaN;
         var centerY:Number = NaN;
         var layoutTarget:GroupBase = target;
         var count:int = layoutTarget.numElements;
         if(count == 0)
         {
            return 0;
         }
         var minDistance:Number = Number.MAX_VALUE;
         var bestIndex:int = -1;
         var start:int = this.firstIndexInView;
         var end:int = this.lastIndexInView;
         for(var i:int = start; i <= end; i++)
         {
            elementBounds = this.getElementBounds(i);
            if(elementBounds)
            {
               if(elementBounds.top <= y && y <= elementBounds.bottom)
               {
                  centerY = elementBounds.y + elementBounds.height / 2;
                  return y < centerY ? i : int(i + 1);
               }
               curDistance = Math.min(Math.abs(y - elementBounds.top),Math.abs(y - elementBounds.bottom));
               if(curDistance < minDistance)
               {
                  minDistance = curDistance;
                  bestIndex = y < elementBounds.top ? i : int(i + 1);
               }
            }
         }
         if(bestIndex == -1)
         {
            bestIndex = this.getElementBounds(0).y < y ? count : 0;
         }
         return bestIndex;
      }
      
      override protected function calculateDropIndicatorBounds(dropLocation:DropLocation) : Rectangle
      {
         var element:IVisualElement = null;
         var dropIndex:int = dropLocation.dropIndex;
         var count:int = target.numElements;
         var gap:Number = this.gap;
         if(gap < 0 && dropIndex == count)
         {
            gap = 0;
         }
         var emptySpace:Number = 0 < gap ? gap : 0;
         var emptySpaceTop:Number = 0;
         if(target.numElements > 0)
         {
            emptySpaceTop = dropIndex < count ? this.getElementBounds(dropIndex).top - emptySpace : this.getElementBounds(dropIndex - 1).bottom + gap - emptySpace;
         }
         var width:Number = Math.max(target.width,target.contentWidth) - this.paddingLeft - this.paddingRight;
         var height:Number = emptySpace;
         if(dropIndicator is IVisualElement)
         {
            element = IVisualElement(dropIndicator);
            height = Math.max(Math.min(height,element.getMaxBoundsHeight(false)),element.getMinBoundsHeight(false));
         }
         var x:Number = this.paddingLeft;
         var y:Number = emptySpaceTop + Math.round((emptySpace - height) / 2);
         y = Math.max(-1,Math.min(target.contentHeight - height + 1,y));
         return new Rectangle(x,y,width,height);
      }
      
      override protected function calculateDragScrollDelta(dropLocation:DropLocation, elapsedTime:Number) : Point
      {
         var delta:Point = super.calculateDragScrollDelta(dropLocation,elapsedTime);
         if(Boolean(delta))
         {
            delta.x = 0;
         }
         return delta;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getElementNearestScrollPosition(position:Point, elementComparePoint:String = "center") : int
      {
         var adjacentBounds:Rectangle = null;
         if(!useVirtualLayout)
         {
            return super.getElementNearestScrollPosition(position,elementComparePoint);
         }
         var g:GroupBase = GroupBase(target);
         if(!g)
         {
            return -1;
         }
         this.updateLLV(g);
         var index:int = this.llv.indexOf(position.y);
         if(index == -1)
         {
            index = position.y < 0 ? 0 : int(g.numElements - 1);
         }
         var bounds:Rectangle = this.llv.getBounds(index);
         if((elementComparePoint == "bottomLeft" || elementComparePoint == "bottomRight") && index > 0)
         {
            adjacentBounds = this.llv.getBounds(index - 1);
            if(Point.distance(position,adjacentBounds.bottomRight) < Point.distance(position,bounds.bottomRight))
            {
               index--;
            }
         }
         if((elementComparePoint == "topLeft" || elementComparePoint == "topRight") && index < g.numElements - 1)
         {
            adjacentBounds = this.llv.getBounds(index + 1);
            if(Point.distance(position,adjacentBounds.topLeft) < Point.distance(position,bounds.topLeft))
            {
               index++;
            }
         }
         return index;
      }
   }
}

import mx.containers.utilityClasses.FlexChildInfo;
import mx.core.ILayoutElement;

class LayoutElementFlexChildInfo extends FlexChildInfo
{
   
   public var layoutElement:ILayoutElement;
   
   public function LayoutElementFlexChildInfo()
   {
      super();
   }
}

class SizesAndLimit
{
   
   public var preferredSize:Number;
   
   public var minSize:Number;
   
   public function SizesAndLimit()
   {
      super();
   }
}
