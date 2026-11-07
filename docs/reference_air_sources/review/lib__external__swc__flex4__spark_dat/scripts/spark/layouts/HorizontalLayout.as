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
   
   public class HorizontalLayout extends LayoutBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var llv:LinearLayoutVector;
      
      private var _alignmentBaseline:Object = "maxAscent:0";
      
      private var _gap:int = 6;
      
      private var _columnCount:int = -1;
      
      private var _paddingLeft:Number = 0;
      
      private var _paddingRight:Number = 0;
      
      private var _paddingTop:Number = 0;
      
      private var _paddingBottom:Number = 0;
      
      private var _requestedMaxColumnCount:int = -1;
      
      private var _requestedMinColumnCount:int = -1;
      
      private var _requestedColumnCount:int = -1;
      
      private var _columnWidth:Number;
      
      private var _variableColumnWidth:Boolean = true;
      
      private var _firstIndexInView:int = -1;
      
      private var _lastIndexInView:int = -1;
      
      private var _horizontalAlign:String = "left";
      
      private var _verticalAlign:String = "top";
      
      public function HorizontalLayout()
      {
         super();
         dragScrollRegionSizeVertical = 0;
      }
      
      private static function calculatePercentHeight(layoutElement:ILayoutElement, height:Number) : Number
      {
         var percentHeight:Number = NaN;
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_6)
         {
            percentHeight = LayoutElementHelper.pinBetween(Math.round(layoutElement.percentHeight * 0.01 * height),layoutElement.getMinBoundsHeight(),layoutElement.getMaxBoundsHeight());
            return percentHeight < height ? percentHeight : height;
         }
         return LayoutElementHelper.pinBetween(Math.min(Math.round(layoutElement.percentHeight * 0.01 * height),height),layoutElement.getMinBoundsHeight(),layoutElement.getMaxBoundsHeight());
      }
      
      private static function sizeLayoutElement(layoutElement:ILayoutElement, height:Number, verticalAlign:String, restrictedHeight:Number, width:Number, variableColumnWidth:Boolean, columnWidth:Number) : void
      {
         var newHeight:Number = NaN;
         if(verticalAlign == VerticalAlign.JUSTIFY || verticalAlign == VerticalAlign.CONTENT_JUSTIFY)
         {
            newHeight = restrictedHeight;
         }
         else if(!isNaN(layoutElement.percentHeight))
         {
            newHeight = calculatePercentHeight(layoutElement,height);
         }
         if(variableColumnWidth)
         {
            layoutElement.setLayoutBoundsSize(width,newHeight);
         }
         else
         {
            layoutElement.setLayoutBoundsSize(columnWidth,newHeight);
         }
      }
      
      private static function findIndexAt(x:Number, gap:int, g:GroupBase, i0:int, i1:int) : int
      {
         var index:int = (i0 + i1) / 2;
         var element:ILayoutElement = g.getElementAt(index);
         var elementX:Number = Number(element.getLayoutBoundsX());
         if(x >= elementX && x < elementX + element.getLayoutBoundsWidth() + gap)
         {
            return index;
         }
         if(i0 == i1)
         {
            return -1;
         }
         if(x < elementX)
         {
            return findIndexAt(x,gap,g,i0,Math.max(i0,index - 1));
         }
         return findIndexAt(x,gap,g,Math.min(index + 1,i1),i1);
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get alignmentBaseline() : Object
      {
         return this._alignmentBaseline;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set alignmentBaseline(value:Object) : void
      {
         if(this._alignmentBaseline == value)
         {
            return;
         }
         this._alignmentBaseline = value;
         this.invalidateTargetSizeAndDisplayList();
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
      public function get columnCount() : int
      {
         return this._columnCount;
      }
      
      private function setColumnCount(value:int) : void
      {
         if(this._columnCount == value)
         {
            return;
         }
         var oldValue:int = this._columnCount;
         this._columnCount = value;
         dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"columnCount",oldValue,value));
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
      public function get requestedMaxColumnCount() : int
      {
         return this._requestedMaxColumnCount;
      }
      
      public function set requestedMaxColumnCount(value:int) : void
      {
         if(this._requestedMaxColumnCount == value)
         {
            return;
         }
         this._requestedMaxColumnCount = value;
         if(Boolean(target))
         {
            target.invalidateSize();
         }
      }
      
      [Inspectable(category="General",minValue="-1")]
      public function get requestedMinColumnCount() : int
      {
         return this._requestedMinColumnCount;
      }
      
      public function set requestedMinColumnCount(value:int) : void
      {
         if(this._requestedMinColumnCount == value)
         {
            return;
         }
         this._requestedMinColumnCount = value;
         if(Boolean(target))
         {
            target.invalidateSize();
         }
      }
      
      [Inspectable(category="General",minValue="-1")]
      public function get requestedColumnCount() : int
      {
         return this._requestedColumnCount;
      }
      
      public function set requestedColumnCount(value:int) : void
      {
         if(this._requestedColumnCount == value)
         {
            return;
         }
         this._requestedColumnCount = value;
         if(Boolean(target))
         {
            target.invalidateSize();
         }
      }
      
      [Inspectable(category="General",minValue="0.0")]
      public function get columnWidth() : Number
      {
         var elt:ILayoutElement = null;
         if(!isNaN(this._columnWidth))
         {
            return this._columnWidth;
         }
         elt = typicalLayoutElement;
         return Boolean(elt) ? Number(elt.getPreferredBoundsWidth()) : 0;
      }
      
      public function set columnWidth(value:Number) : void
      {
         if(this._columnWidth == value)
         {
            return;
         }
         this._columnWidth = value;
         this.invalidateTargetSizeAndDisplayList();
      }
      
      [Inspectable(category="General",enumeration="true,false")]
      public function get variableColumnWidth() : Boolean
      {
         return this._variableColumnWidth;
      }
      
      public function set variableColumnWidth(value:Boolean) : void
      {
         if(value == this._variableColumnWidth)
         {
            return;
         }
         this._variableColumnWidth = value;
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
      
      [Inspectable(category="General",enumeration="left,right,center",defaultValue="left")]
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
      
      [Inspectable(category="General",enumeration="top,bottom,middle,justify,contentJustify,baseline",defaultValue="top")]
      public function get verticalAlign() : String
      {
         return this._verticalAlign;
      }
      
      public function set verticalAlign(value:String) : void
      {
         var layoutTarget:GroupBase = null;
         if(value == this._verticalAlign)
         {
            return;
         }
         var oldValue:String = this._verticalAlign;
         this._verticalAlign = value;
         if(oldValue == VerticalAlign.BASELINE || value == VerticalAlign.BASELINE)
         {
            this.invalidateTargetSizeAndDisplayList();
         }
         else
         {
            layoutTarget = target;
            if(Boolean(layoutTarget))
            {
               layoutTarget.invalidateDisplayList();
            }
         }
      }
      
      private function setIndexInView(firstIndex:int, lastIndex:int) : void
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
         var hAlign:String = this.horizontalAlign;
         if(hAlign == HorizontalAlign.CENTER || hAlign == HorizontalAlign.RIGHT)
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
         var eltX:Number = NaN;
         var eltWidth:Number = NaN;
         var elt:ILayoutElement = null;
         var g:GroupBase = target;
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
            eltX = this.llv.start(index);
            eltWidth = this.llv.getMajorSize(index);
         }
         else
         {
            elt = g.getElementAt(index);
            if(!elt || !elt.includeInLayout)
            {
               return 0;
            }
            eltX = Number(elt.getLayoutBoundsX());
            eltWidth = Number(elt.getLayoutBoundsWidth());
         }
         var x0:Number = g.horizontalScrollPosition;
         var x1:Number = x0 + g.width;
         var ix0:Number = eltX;
         var ix1:Number = ix0 + eltWidth;
         if(ix0 >= ix1)
         {
            return 1;
         }
         if(ix0 >= x0 && ix1 <= x1)
         {
            return 1;
         }
         return (Math.min(x1,ix1) - Math.max(x0,ix0)) / (ix1 - ix0);
      }
      
      override protected function scrollPositionChanged() : void
      {
         var i0:int = 0;
         var i1:int = 0;
         var index0:int = 0;
         var element0:ILayoutElement = null;
         var element0X:Number = NaN;
         var element0Width:Number = NaN;
         var index1:int = 0;
         var element1:ILayoutElement = null;
         var element1X:Number = NaN;
         var element1Width:Number = NaN;
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
         var x0:Number = scrollR.left;
         var x1:Number = scrollR.right - 0.0001;
         if(x1 <= x0)
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
            i0 = this.llv.indexOf(x0);
            i1 = this.llv.indexOf(x1);
         }
         else
         {
            i0 = findIndexAt(x0 + this.gap,this.gap,g,0,n);
            i1 = findIndexAt(x1,this.gap,g,0,n);
         }
         if(i0 == -1)
         {
            index0 = findLayoutElementIndex(g,0,1);
            if(index0 != -1)
            {
               element0 = g.getElementAt(index0);
               element0X = Number(element0.getLayoutBoundsX());
               element0Width = Number(element0.getLayoutBoundsWidth());
               if(element0X < x1 && element0X + element0Width > x0)
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
               element1X = Number(element1.getLayoutBoundsX());
               element1Width = Number(element1.getLayoutBoundsWidth());
               if(element1X < x1 && element1X + element1Width > x0)
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
            if(!firstElement || !lastElement || scrollRect.left < firstElement.getLayoutBoundsX() || scrollRect.right >= lastElement.getLayoutBoundsX() + lastElement.getLayoutBoundsWidth())
            {
               g.invalidateDisplayList();
            }
         }
         this.setIndexInView(i0,i1);
      }
      
      private function findLayoutElementBounds(g:GroupBase, i:int, dir:int, r:Rectangle) : Rectangle
      {
         var elementR:Rectangle = null;
         var overlapsLeft:Boolean = false;
         var overlapsRight:Boolean = false;
         var n:int = g.numElements;
         if(this.fractionOfElementInView(i) >= 1)
         {
            i += dir;
            if(i < 0)
            {
               return new Rectangle(0,0,this.paddingLeft,0);
            }
            if(i >= n)
            {
               return new Rectangle(this.getElementBounds(n - 1).right,0,this.paddingRight,0);
            }
         }
         while(i >= 0 && i < n)
         {
            elementR = this.getElementBounds(i);
            if(Boolean(elementR))
            {
               overlapsLeft = dir == -1 && elementR.left == r.left && elementR.right >= r.right;
               overlapsRight = dir == 1 && elementR.right == r.right && elementR.left <= r.left;
               if(!(overlapsLeft || overlapsRight))
               {
                  return elementR;
               }
            }
            i += dir;
         }
         return null;
      }
      
      override protected function getElementBoundsLeftOfScrollRect(scrollRect:Rectangle) : Rectangle
      {
         return this.findLayoutElementBounds(target,this.firstIndexInView,-1,scrollRect);
      }
      
      override protected function getElementBoundsRightOfScrollRect(scrollRect:Rectangle) : Rectangle
      {
         return this.findLayoutElementBounds(target,this.lastIndexInView,1,scrollRect);
      }
      
      private function getElementWidth(element:ILayoutElement, fixedColumnWidth:Number, result:SizesAndLimit) : void
      {
         var elementPreferredWidth:Number = isNaN(fixedColumnWidth) ? Math.ceil(element.getPreferredBoundsWidth()) : fixedColumnWidth;
         var flexibleWidth:Boolean = !isNaN(element.percentWidth);
         var elementMinWidth:Number = flexibleWidth ? Math.ceil(element.getMinBoundsWidth()) : elementPreferredWidth;
         result.preferredSize = elementPreferredWidth;
         result.minSize = elementMinWidth;
      }
      
      private function getElementHeight(element:ILayoutElement, justify:Boolean, result:SizesAndLimit) : void
      {
         var elementPreferredHeight:Number = Math.ceil(element.getPreferredBoundsHeight());
         var flexibleHeight:Boolean = !isNaN(element.percentHeight) || justify;
         var elementMinHeight:Number = flexibleHeight ? Math.ceil(element.getMinBoundsHeight()) : elementPreferredHeight;
         result.preferredSize = elementPreferredHeight;
         result.minSize = elementMinHeight;
      }
      
      private function calculateBaselineTopBottom(calculateBottom:Boolean) : Array
      {
         var calculateTop:Boolean = false;
         var element:ILayoutElement = null;
         var elementBaseline:Number = NaN;
         var baselinePosition:Number = NaN;
         var elementBaselineTop:Number = NaN;
         var elementHeight:Number = NaN;
         var elementBaselineBottom:Number = NaN;
         var elementBaselineBottomMin:Number = NaN;
         var baselineOffset:Number = 0;
         var baselineTop:Number = 0;
         var baselineBottom:Number = 0;
         var baselineBottomMin:Number = 0;
         var temp:Array = LayoutElementHelper.parseConstraintExp(this.alignmentBaseline);
         if(temp.length == 2 && temp[1] == "maxAscent")
         {
            baselineOffset = Number(temp[0]);
            calculateTop = true;
         }
         else
         {
            calculateTop = false;
            baselineTop = Number(temp[0]);
            if(isNaN(baselineTop))
            {
               baselineTop = 0;
               calculateTop = true;
            }
         }
         var count:int = target.numElements;
         for(var i:int = 0; i < count; i++)
         {
            element = target.getElementAt(i);
            if(!(!element || !element.includeInLayout))
            {
               elementBaseline = element.baseline as Number;
               if(isNaN(elementBaseline))
               {
                  elementBaseline = 0;
               }
               baselinePosition = Number(element.baselinePosition);
               elementBaselineTop = baselinePosition - elementBaseline;
               if(calculateTop)
               {
                  baselineTop = Math.max(elementBaselineTop,baselineTop);
               }
               if(calculateBottom)
               {
                  elementHeight = Number(element.getPreferredBoundsHeight());
                  elementBaselineBottom = elementHeight - elementBaselineTop;
                  elementBaselineBottomMin = elementBaselineBottom;
                  if(!isNaN(element.percentHeight))
                  {
                     elementBaselineBottomMin = element.getMinBoundsHeight() - elementBaselineTop;
                  }
                  baselineBottom = Math.max(elementBaselineBottom,baselineBottom);
               }
            }
         }
         if(calculateTop)
         {
            baselineTop += baselineOffset;
         }
         return [baselineTop,baselineBottom,baselineBottomMin];
      }
      
      private function getColumsToMeasure(numElementsInLayout:int) : int
      {
         var columnsToMeasure:int = 0;
         if(this.requestedColumnCount != -1)
         {
            columnsToMeasure = this.requestedColumnCount;
         }
         else
         {
            columnsToMeasure = numElementsInLayout;
            if(this.requestedMaxColumnCount != -1)
            {
               columnsToMeasure = Math.min(this.requestedMaxColumnCount,columnsToMeasure);
            }
            if(this.requestedMinColumnCount != -1)
            {
               columnsToMeasure = Math.max(this.requestedMinColumnCount,columnsToMeasure);
            }
         }
         return columnsToMeasure;
      }
      
      private function measureReal(layoutTarget:GroupBase) : void
      {
         var element:ILayoutElement = null;
         var result:Array = null;
         var top:Number = NaN;
         var bottom:Number = NaN;
         var bottomMin:Number = NaN;
         var hgap:Number = NaN;
         var size:SizesAndLimit = new SizesAndLimit();
         var alignToBaseline:Boolean = this.verticalAlign == VerticalAlign.BASELINE;
         var justify:Boolean = this.verticalAlign == VerticalAlign.JUSTIFY;
         var numElements:int = layoutTarget.numElements;
         var numElementsInLayout:int = numElements;
         var requestedColumnCount:int = this.requestedColumnCount;
         var columnsMeasured:int = 0;
         var preferredHeight:Number = 0;
         var preferredWidth:Number = 0;
         var minHeight:Number = 0;
         var minWidth:Number = 0;
         var fixedColumnWidth:Number = NaN;
         if(!this.variableColumnWidth)
         {
            fixedColumnWidth = this.columnWidth;
         }
         var columnsToMeasure:int = this.getColumsToMeasure(numElementsInLayout);
         for(var i:int = 0; i < numElements; i++)
         {
            element = layoutTarget.getElementAt(i);
            if(!element || !element.includeInLayout)
            {
               numElementsInLayout--;
            }
            else
            {
               if(!alignToBaseline)
               {
                  this.getElementHeight(element,justify,size);
                  preferredHeight = Math.max(preferredHeight,size.preferredSize);
                  minHeight = Math.max(minHeight,size.minSize);
               }
               if(columnsMeasured < columnsToMeasure)
               {
                  this.getElementWidth(element,fixedColumnWidth,size);
                  preferredWidth += size.preferredSize;
                  minWidth += size.minSize;
                  columnsMeasured++;
               }
            }
         }
         columnsToMeasure = this.getColumsToMeasure(numElementsInLayout);
         if(columnsMeasured < columnsToMeasure)
         {
            element = typicalLayoutElement;
            if(Boolean(element))
            {
               if(!alignToBaseline)
               {
                  this.getElementHeight(element,justify,size);
                  preferredHeight = Math.max(preferredHeight,size.preferredSize);
                  minHeight = Math.max(minHeight,size.minSize);
               }
               this.getElementWidth(element,fixedColumnWidth,size);
               preferredWidth += size.preferredSize * (columnsToMeasure - columnsMeasured);
               minWidth += size.minSize * (columnsToMeasure - columnsMeasured);
               columnsMeasured = columnsToMeasure;
            }
         }
         if(alignToBaseline)
         {
            result = this.calculateBaselineTopBottom(true);
            top = Number(result[0]);
            bottom = Number(result[1]);
            bottomMin = Number(result[2]);
            preferredHeight = Math.ceil(top + bottom);
            minHeight = Math.ceil(top + bottomMin);
         }
         if(columnsMeasured > 1)
         {
            hgap = this.gap * (columnsMeasured - 1);
            preferredWidth += hgap;
            minWidth += hgap;
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
            this.llv = new LinearLayoutVector(LinearLayoutVector.HORIZONTAL);
            this.llv.defaultMinorSize = 22;
            this.llv.defaultMajorSize = 71;
         }
         var typicalElt:ILayoutElement = typicalLayoutElement;
         if(Boolean(typicalElt))
         {
            typicalWidth = Number(typicalElt.getPreferredBoundsWidth());
            typicalHeight = Number(typicalElt.getPreferredBoundsHeight());
            this.llv.defaultMinorSize = typicalHeight;
            this.llv.defaultMajorSize = typicalWidth;
         }
         if(!isNaN(this._columnWidth))
         {
            this.llv.defaultMajorSize = this._columnWidth;
         }
         if(Boolean(layoutTarget))
         {
            this.llv.length = layoutTarget.numElements;
         }
         this.llv.gap = this.gap;
         this.llv.majorAxisOffset = this.paddingLeft;
      }
      
      override public function elementAdded(index:int) : void
      {
         if(index >= 0 && useVirtualLayout && Boolean(this.llv))
         {
            this.llv.insert(index);
         }
      }
      
      override public function elementRemoved(index:int) : void
      {
         if(index >= 0 && useVirtualLayout && Boolean(this.llv))
         {
            this.llv.remove(index);
         }
      }
      
      private function measureVirtual(layoutTarget:GroupBase) : void
      {
         var oldLength:int = 0;
         var measuredWidth:Number = NaN;
         var dataGroupTarget:DataGroup = null;
         var indices:Vector.<int> = null;
         var i:int = 0;
         var element:ILayoutElement = null;
         var hgap:Number = NaN;
         var eltCount:int = layoutTarget.numElements;
         var measuredEltCount:int = this.getColumsToMeasure(eltCount);
         var hPadding:Number = this.paddingLeft + this.paddingRight;
         var vPadding:Number = this.paddingTop + this.paddingBottom;
         if(measuredEltCount <= 0)
         {
            layoutTarget.measuredWidth = layoutTarget.measuredMinWidth = hPadding;
            layoutTarget.measuredHeight = layoutTarget.measuredMinHeight = vPadding;
            return;
         }
         this.updateLLV(layoutTarget);
         if(this.variableColumnWidth)
         {
            oldLength = -1;
            if(measuredEltCount > this.llv.length)
            {
               oldLength = int(this.llv.length);
               this.llv.length = measuredEltCount;
            }
            measuredWidth = this.llv.end(measuredEltCount - 1) + this.paddingRight;
            dataGroupTarget = layoutTarget as DataGroup;
            if(Boolean(dataGroupTarget))
            {
               indices = dataGroupTarget.getItemIndicesInView();
               for each(i in indices)
               {
                  element = dataGroupTarget.getElementAt(i);
                  if(Boolean(element))
                  {
                     measuredWidth -= this.llv.getMajorSize(i);
                     measuredWidth += element.getPreferredBoundsWidth();
                  }
               }
            }
            layoutTarget.measuredWidth = measuredWidth;
            if(oldLength != -1)
            {
               this.llv.length = oldLength;
            }
         }
         else
         {
            hgap = measuredEltCount > 1 ? (measuredEltCount - 1) * this.gap : 0;
            layoutTarget.measuredWidth = measuredEltCount * this.columnWidth + hgap + hPadding;
         }
         layoutTarget.measuredHeight = this.llv.minorSize + vPadding;
         layoutTarget.measuredMinWidth = layoutTarget.measuredWidth;
         layoutTarget.measuredMinHeight = this.verticalAlign == VerticalAlign.JUSTIFY ? this.llv.minMinorSize + vPadding : Number(layoutTarget.measuredHeight);
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
         var x:Number = NaN;
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
            if(navigationUnit == NavigationUnit.LEFT)
            {
               return arrowKeysWrapFocus ? maxIndex : -1;
            }
            if(navigationUnit == NavigationUnit.RIGHT)
            {
               return 0;
            }
         }
         currentIndex = Math.max(0,Math.min(maxIndex,currentIndex));
         switch(navigationUnit)
         {
            case NavigationUnit.LEFT:
               if(arrowKeysWrapFocus && currentIndex == 0)
               {
                  newIndex = maxIndex;
               }
               else
               {
                  newIndex = currentIndex - 1;
               }
               break;
            case NavigationUnit.RIGHT:
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
            case NavigationUnit.PAGE_LEFT:
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
                     x = getHorizontalScrollPositionDelta(NavigationUnit.PAGE_LEFT) + getScrollRect().left;
                  }
                  else
                  {
                     x = this.getElementBounds(currentIndex).right - getScrollRect().width;
                  }
                  newIndex = currentIndex - 1;
                  while(0 <= newIndex)
                  {
                     bounds = this.getElementBounds(newIndex);
                     if(Boolean(bounds) && bounds.left < x)
                     {
                        newIndex = Math.min(currentIndex - 1,newIndex + 1);
                        break;
                     }
                     newIndex--;
                  }
               }
               break;
            case NavigationUnit.PAGE_DOWN:
            case NavigationUnit.PAGE_RIGHT:
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
                     x = getHorizontalScrollPositionDelta(NavigationUnit.PAGE_RIGHT) + getScrollRect().right;
                  }
                  else
                  {
                     x = this.getElementBounds(currentIndex).left + getScrollRect().width;
                  }
                  newIndex = currentIndex + 1;
                  while(newIndex <= maxIndex)
                  {
                     bounds = this.getElementBounds(newIndex);
                     if(Boolean(bounds) && bounds.right > x)
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
      
      private function calculateElementHeight(elt:ILayoutElement, targetHeight:Number, containerHeight:Number) : Number
      {
         var height:Number = NaN;
         var percentHeight:Number = Number(elt.percentHeight);
         if(!isNaN(percentHeight))
         {
            height = percentHeight * 0.01 * targetHeight;
            return Math.min(targetHeight,Math.min(elt.getMaxBoundsHeight(),Math.max(elt.getMinBoundsHeight(),height)));
         }
         switch(this.verticalAlign)
         {
            case VerticalAlign.JUSTIFY:
               return targetHeight;
            case VerticalAlign.CONTENT_JUSTIFY:
               return Math.max(elt.getPreferredBoundsHeight(),containerHeight);
            default:
               return NaN;
         }
      }
      
      private function calculateElementY(elt:ILayoutElement, eltHeight:Number, containerHeight:Number) : Number
      {
         switch(this.verticalAlign)
         {
            case VerticalAlign.MIDDLE:
               return Math.round((containerHeight - eltHeight) * 0.5);
            case VerticalAlign.BOTTOM:
               return containerHeight - eltHeight;
            default:
               return 0;
         }
      }
      
      private function updateDisplayListVirtual() : void
      {
         var contentWidth:Number = NaN;
         var paddedContentWidth:Number = NaN;
         var elt:ILayoutElement = null;
         var w:Number = NaN;
         var h:Number = NaN;
         var y:Number = NaN;
         var excessWidth:Number = NaN;
         var dx:Number = NaN;
         var hAlign:String = null;
         var layoutTarget:GroupBase = target;
         var eltCount:int = layoutTarget.numElements;
         var targetHeight:Number = Math.max(0,layoutTarget.height - this.paddingTop - this.paddingBottom);
         var minVisibleX:Number = layoutTarget.horizontalScrollPosition;
         var maxVisibleX:Number = minVisibleX + layoutTarget.width;
         this.updateLLV(layoutTarget);
         var startIndex:int = this.llv.indexOf(Math.max(0,minVisibleX + this.gap));
         if(startIndex == -1)
         {
            contentWidth = this.llv.end(this.llv.length - 1) - this.paddingLeft;
            paddedContentWidth = Math.ceil(contentWidth + this.paddingLeft + this.paddingRight);
            layoutTarget.setContentSize(paddedContentWidth,layoutTarget.contentHeight);
            return;
         }
         var fixedColumnWidth:Number = NaN;
         if(!this.variableColumnWidth)
         {
            fixedColumnWidth = this.columnWidth;
         }
         var justifyHeights:Boolean = this.verticalAlign == VerticalAlign.JUSTIFY;
         var eltWidth:Number = NaN;
         var eltHeight:Number = justifyHeights ? Math.max(this.llv.minMinorSize,targetHeight) : this.llv.minorSize;
         var contentHeight:Number = justifyHeights ? Math.max(this.llv.minMinorSize,targetHeight) : this.llv.minorSize;
         var containerHeight:Number = Math.max(contentHeight,targetHeight);
         var x:Number = this.llv.start(startIndex);
         var index:int = startIndex;
         var y0:Number = this.paddingTop;
         while(x < maxVisibleX && index < eltCount)
         {
            elt = layoutTarget.getVirtualElementAt(index);
            w = fixedColumnWidth;
            h = this.calculateElementHeight(elt,targetHeight,containerHeight);
            elt.setLayoutBoundsSize(w,h);
            w = Number(elt.getLayoutBoundsWidth());
            h = Number(elt.getLayoutBoundsHeight());
            y = y0 + this.calculateElementY(elt,h,containerHeight);
            elt.setLayoutBoundsPosition(x,y);
            this.llv.cacheDimensions(index,elt);
            x += w + this.gap;
            index++;
         }
         var endIndex:int = index - 1;
         if(!justifyHeights && this.llv.minorSize != contentHeight)
         {
            contentHeight = this.llv.minorSize;
            containerHeight = Math.max(contentHeight,targetHeight);
            if(this.verticalAlign != VerticalAlign.TOP && this.verticalAlign != VerticalAlign.JUSTIFY)
            {
               for(index = startIndex; index <= endIndex; index++)
               {
                  elt = layoutTarget.getElementAt(index);
                  h = this.calculateElementHeight(elt,targetHeight,containerHeight);
                  elt.setLayoutBoundsSize(elt.getLayoutBoundsWidth(),h);
                  h = Number(elt.getLayoutBoundsHeight());
                  y = y0 + this.calculateElementY(elt,h,containerHeight);
                  elt.setLayoutBoundsPosition(elt.getLayoutBoundsX(),y);
               }
            }
         }
         contentWidth = this.llv.end(this.llv.length - 1) - this.paddingLeft;
         var targetWidth:Number = Math.max(0,layoutTarget.width - this.paddingLeft - this.paddingRight);
         if(contentWidth < targetWidth)
         {
            excessWidth = targetWidth - contentWidth;
            dx = 0;
            hAlign = this.horizontalAlign;
            if(hAlign == HorizontalAlign.CENTER)
            {
               dx = Math.round(excessWidth / 2);
            }
            else if(hAlign == HorizontalAlign.RIGHT)
            {
               dx = excessWidth;
            }
            if(dx > 0)
            {
               for(index = startIndex; index <= endIndex; index++)
               {
                  elt = layoutTarget.getElementAt(index);
                  elt.setLayoutBoundsPosition(dx + elt.getLayoutBoundsX(),elt.getLayoutBoundsY());
               }
               contentWidth += dx;
            }
         }
         this.setColumnCount(index - startIndex);
         this.setIndexInView(startIndex,endIndex);
         paddedContentWidth = Math.ceil(contentWidth + this.paddingLeft + this.paddingRight);
         var paddedContentHeight:Number = Math.ceil(contentHeight + this.paddingTop + this.paddingBottom);
         layoutTarget.setContentSize(paddedContentWidth,paddedContentHeight);
      }
      
      private function updateDisplayListReal() : void
      {
         var layoutElement:ILayoutElement = null;
         var i:int = 0;
         var layoutElementHeight:Number = NaN;
         var result:Array = null;
         var hAlign:String = null;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var y:Number = NaN;
         var elementBaseline:Number = NaN;
         var baselinePosition:Number = NaN;
         var layoutTarget:GroupBase = target;
         var targetWidth:Number = Math.max(0,layoutTarget.width - this.paddingLeft - this.paddingRight);
         var targetHeight:Number = Math.max(0,layoutTarget.height - this.paddingTop - this.paddingBottom);
         var count:int = layoutTarget.numElements;
         var containerHeight:Number = targetHeight;
         if(this.verticalAlign == VerticalAlign.CONTENT_JUSTIFY || clipAndEnableScrolling && (this.verticalAlign == VerticalAlign.MIDDLE || this.verticalAlign == VerticalAlign.BOTTOM))
         {
            for(i = 0; i < count; i++)
            {
               layoutElement = layoutTarget.getElementAt(i);
               if(!(!layoutElement || !layoutElement.includeInLayout))
               {
                  if(!isNaN(layoutElement.percentHeight))
                  {
                     layoutElementHeight = calculatePercentHeight(layoutElement,targetHeight);
                  }
                  else
                  {
                     layoutElementHeight = Number(layoutElement.getPreferredBoundsHeight());
                  }
                  containerHeight = Math.max(containerHeight,Math.ceil(layoutElementHeight));
               }
            }
         }
         var excessWidth:Number = this.distributeWidth(targetWidth,targetHeight,containerHeight);
         var vAlign:Number = 0;
         if(this.verticalAlign == VerticalAlign.MIDDLE)
         {
            vAlign = 0.5;
         }
         else if(this.verticalAlign == VerticalAlign.BOTTOM)
         {
            vAlign = 1;
         }
         var actualBaseline:Number = 0;
         var alignToBaseline:Boolean = this.verticalAlign == VerticalAlign.BASELINE;
         if(alignToBaseline)
         {
            result = this.calculateBaselineTopBottom(false);
            actualBaseline = Number(result[0]);
         }
         var visibleColumns:uint = 0;
         var minVisibleX:Number = layoutTarget.horizontalScrollPosition;
         var maxVisibleX:Number = minVisibleX + targetWidth;
         var x:Number = this.paddingLeft;
         var y0:Number = this.paddingTop;
         var maxX:Number = this.paddingLeft;
         var maxY:Number = this.paddingTop;
         var firstColInView:int = -1;
         var lastColInView:int = -1;
         if(excessWidth > 0 || !clipAndEnableScrolling)
         {
            hAlign = this.horizontalAlign;
            if(hAlign == HorizontalAlign.CENTER)
            {
               x = this.paddingLeft + Math.round(excessWidth / 2);
            }
            else if(hAlign == HorizontalAlign.RIGHT)
            {
               x = this.paddingLeft + excessWidth;
            }
         }
         for(var index:int = 0; index < count; index++)
         {
            layoutElement = layoutTarget.getElementAt(index);
            if(!(!layoutElement || !layoutElement.includeInLayout))
            {
               dx = Math.ceil(layoutElement.getLayoutBoundsWidth());
               dy = Math.ceil(layoutElement.getLayoutBoundsHeight());
               if(alignToBaseline)
               {
                  elementBaseline = layoutElement.baseline as Number;
                  if(isNaN(elementBaseline))
                  {
                     elementBaseline = 0;
                  }
                  baselinePosition = Number(layoutElement.baselinePosition);
                  y = y0 + actualBaseline + elementBaseline - baselinePosition;
               }
               else
               {
                  y = y0 + (containerHeight - dy) * vAlign;
                  if(vAlign == 0.5)
                  {
                     y = Math.round(y);
                  }
               }
               layoutElement.setLayoutBoundsPosition(x,y);
               maxX = Math.max(maxX,x + dx);
               maxY = Math.max(maxY,y + dy);
               if(!clipAndEnableScrolling || x < maxVisibleX && x + dx > minVisibleX || dx <= 0 && (x == maxVisibleX || x == minVisibleX))
               {
                  visibleColumns += 1;
                  if(firstColInView == -1)
                  {
                     firstColInView = lastColInView = index;
                  }
                  else
                  {
                     lastColInView = index;
                  }
               }
               x += dx + this.gap;
            }
         }
         this.setColumnCount(visibleColumns);
         this.setIndexInView(firstColInView,lastColInView);
         layoutTarget.setContentSize(Math.ceil(maxX + this.paddingRight),Math.ceil(maxY + this.paddingBottom));
      }
      
      private function distributeWidth(width:Number, height:Number, restrictedHeight:Number) : Number
      {
         var childInfo:HLayoutElementFlexChildInfo = null;
         var newHeight:Number = NaN;
         var layoutElement:ILayoutElement = null;
         var roundOff:Number = NaN;
         var childSize:int = 0;
         var spaceToDistribute:Number = width;
         var totalPercentWidth:Number = 0;
         var childInfoArray:Array = [];
         var cw:Number = this.variableColumnWidth ? 0 : Math.ceil(this.columnWidth);
         var count:int = target.numElements;
         var totalCount:int = count;
         for(var index:int = 0; index < count; index++)
         {
            layoutElement = target.getElementAt(index);
            if(!layoutElement || !layoutElement.includeInLayout)
            {
               totalCount--;
            }
            else if(!isNaN(layoutElement.percentWidth) && this.variableColumnWidth)
            {
               totalPercentWidth += layoutElement.percentWidth;
               childInfo = new HLayoutElementFlexChildInfo();
               childInfo.layoutElement = layoutElement;
               childInfo.percent = layoutElement.percentWidth;
               childInfo.min = layoutElement.getMinBoundsWidth();
               childInfo.max = layoutElement.getMaxBoundsWidth();
               childInfoArray.push(childInfo);
            }
            else
            {
               sizeLayoutElement(layoutElement,height,this.verticalAlign,restrictedHeight,NaN,this.variableColumnWidth,cw);
               spaceToDistribute -= Math.ceil(layoutElement.getLayoutBoundsWidth());
            }
         }
         if(totalCount > 1)
         {
            spaceToDistribute -= (totalCount - 1) * this.gap;
         }
         if(Boolean(totalPercentWidth))
         {
            Flex.flexChildrenProportionally(width,spaceToDistribute,totalPercentWidth,childInfoArray);
            roundOff = 0;
            for each(childInfo in childInfoArray)
            {
               childSize = Math.round(childInfo.size + roundOff);
               roundOff += childInfo.size - childSize;
               sizeLayoutElement(childInfo.layoutElement,height,this.verticalAlign,restrictedHeight,childSize,this.variableColumnWidth,cw);
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
            this.setColumnCount(0);
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
         var centerX:Number = NaN;
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
               if(elementBounds.left <= x && x <= elementBounds.right)
               {
                  centerX = elementBounds.x + elementBounds.width / 2;
                  return x < centerX ? i : int(i + 1);
               }
               curDistance = Math.min(Math.abs(x - elementBounds.left),Math.abs(x - elementBounds.right));
               if(curDistance < minDistance)
               {
                  minDistance = curDistance;
                  bestIndex = x < elementBounds.left ? i : int(i + 1);
               }
            }
         }
         if(bestIndex == -1)
         {
            bestIndex = this.getElementBounds(0).x < x ? count : 0;
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
         var emptySpaceLeft:Number = 0;
         if(target.numElements > 0)
         {
            emptySpaceLeft = dropIndex < count ? this.getElementBounds(dropIndex).left - emptySpace : this.getElementBounds(dropIndex - 1).right + gap - emptySpace;
         }
         var width:Number = emptySpace;
         var height:Number = Math.max(target.height,target.contentHeight) - this.paddingTop - this.paddingBottom;
         if(dropIndicator is IVisualElement)
         {
            element = IVisualElement(dropIndicator);
            width = Math.max(Math.min(width,element.getMaxBoundsWidth(false)),element.getMinBoundsWidth(false));
         }
         var x:Number = emptySpaceLeft + Math.round((emptySpace - width) / 2);
         x = Math.max(-Math.ceil(width / 2),Math.min(target.contentWidth - Math.ceil(width / 2),x));
         var y:Number = this.paddingTop;
         return new Rectangle(x,y,width,height);
      }
      
      override protected function calculateDragScrollDelta(dropLocation:DropLocation, elapsedTime:Number) : Point
      {
         var delta:Point = super.calculateDragScrollDelta(dropLocation,elapsedTime);
         if(Boolean(delta))
         {
            delta.y = 0;
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
         var index:int = this.llv.indexOf(position.x);
         if(index == -1)
         {
            index = position.x < 0 ? 0 : int(g.numElements - 1);
         }
         var bounds:Rectangle = this.llv.getBounds(index);
         if((elementComparePoint == "topRight" || elementComparePoint == "bottomRight") && index > 0)
         {
            adjacentBounds = this.llv.getBounds(index - 1);
            if(Point.distance(position,adjacentBounds.bottomRight) < Point.distance(position,bounds.bottomRight))
            {
               index--;
            }
         }
         if((elementComparePoint == "topLeft" || elementComparePoint == "bottomLeft") && index < g.numElements - 1)
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

class HLayoutElementFlexChildInfo extends FlexChildInfo
{
   
   public var layoutElement:ILayoutElement;
   
   public function HLayoutElementFlexChildInfo()
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
