package mx.charts
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.charts.chartClasses.ChartBase;
   import mx.charts.events.LegendMouseEvent;
   import mx.charts.styles.HaloDefaults;
   import mx.collections.ArrayCollection;
   import mx.collections.ICollectionView;
   import mx.collections.IList;
   import mx.collections.ListCollectionView;
   import mx.containers.Tile;
   import mx.core.EdgeMetrics;
   import mx.core.IUIComponent;
   import mx.core.ScrollPolicy;
   import mx.styles.CSSStyleDeclaration;
   
   [IconFile("Legend.png")]
   [DefaultTriggerEvent("itemClick")]
   [DefaultBindingProperty(destination="dataProvider")]
   [Exclude(name="verticalScrollPolicy",kind="property")]
   [Exclude(name="tileWidth",kind="property")]
   [Exclude(name="tileHeight",kind="property")]
   [Exclude(name="label",kind="property")]
   [Exclude(name="icon",kind="property")]
   [Exclude(name="horizontalScrollPolicy",kind="property")]
   [Exclude(name="defaultButton",kind="property")]
   [Style(name="stroke",type="Object",inherit="no")]
   [Style(name="markerWidth",type="Number",format="Length",inherit="yes")]
   [Style(name="markerHeight",type="Number",format="Length",inherit="yes")]
   [Style(name="labelPlacement",type="String",enumeration="top,bottom,right,left",inherit="yes")]
   [Style(name="borderStyle",type="String",enumeration="inset,outset,solid,none",inherit="no")]
   [Style(name="backgroundColor",type="uint",format="Color",inherit="no")]
   [Style(name="paddingRight",type="Number",format="Length",inherit="no")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no")]
   [Style(name="verticalGap",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no")]
   [Event(name="itemMouseUp",type="mx.charts.events.LegendMouseEvent")]
   [Event(name="itemMouseOver",type="mx.charts.events.LegendMouseEvent")]
   [Event(name="itemMouseOut",type="mx.charts.events.LegendMouseEvent")]
   [Event(name="itemMouseDown",type="mx.charts.events.LegendMouseEvent")]
   [Event(name="itemClick",type="mx.charts.events.LegendMouseEvent")]
   public class Legend extends Tile
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var stylesInited:Boolean = initStyles();
      
      private static var legendItemLinkage:LegendItem = null;
      
      private var _actualMajorAxisLength:Number;
      
      private var _childrenDirty:Boolean = false;
      
      public var legendItemClass:Class = LegendItem;
      
      private var _unscaledHeight:Number;
      
      private var _dataProvider:Object;
      
      private var _unscaledWidth:Number;
      
      private var _preferredMajorAxisLength:Number;
      
      private var _dataProviderChanged:Boolean = false;
      
      public function Legend()
      {
         super();
         direction = "vertical";
         addEventListener(MouseEvent.CLICK,childMouseEventHandler);
         addEventListener(MouseEvent.MOUSE_OVER,childMouseEventHandler);
         addEventListener(MouseEvent.MOUSE_OUT,childMouseEventHandler);
         addEventListener(MouseEvent.MOUSE_UP,childMouseEventHandler);
         addEventListener(MouseEvent.MOUSE_DOWN,childMouseEventHandler);
         _dataProvider = new ArrayCollection();
      }
      
      private static function initStyles() : Boolean
      {
         var o:CSSStyleDeclaration;
         HaloDefaults.init();
         o = HaloDefaults.createSelector("Legend");
         o.defaultFactory = function():void
         {
            this.borderStyle = "none";
            this.horizontalGap = 20;
            this.maintainAspectRatio = true;
            this.paddingBottom = 5;
            this.paddingLeft = 5;
            this.paddingRight = 5;
            this.paddingTop = 5;
            this.verticalGap = 7;
         };
         return true;
      }
      
      private function layoutVertical() : void
      {
         var child:IUIComponent = null;
         var col:int = 0;
         var colWidth:Number = NaN;
         var childWidth:Number = NaN;
         var childHeight:Number = NaN;
         var xOffset:Number = NaN;
         var yOffset:Number = NaN;
         var n:Number = Number(numChildren);
         var vm:EdgeMetrics = viewMetricsAndPadding;
         var horizontalGap:Number = Number(getStyle("horizontalGap"));
         var verticalGap:Number = Number(getStyle("verticalGap"));
         var horizontalAlign:String = getStyle("horizontalAlign");
         var verticalAlign:String = getStyle("verticalAlign");
         var xPos:Number = Number(vm.left);
         var yPos:Number = Number(vm.top);
         var yEnd:Number = unscaledHeight - vm.bottom;
         var rowCount:int = Math.min(n,Math.max(1,Math.floor((yEnd - yPos + verticalGap) / (cellHeight + verticalGap))));
         var columnSizes:Array = [];
         columnSizes = calcColumnWidthsForHeight(yEnd - yPos);
         var nColumns:int = int(columnSizes.length);
         for(var i:Number = 0; i < n; i++)
         {
            child = IUIComponent(getChildAt(i));
            col = Math.floor(i / rowCount);
            colWidth = Number(columnSizes[col]);
            if(child.percentWidth > 0)
            {
               childWidth = Math.min(colWidth,colWidth * child.percentWidth / 100);
            }
            else
            {
               childWidth = Number(child.getExplicitOrMeasuredWidth());
            }
            if(child.percentHeight > 0)
            {
               childHeight = Math.min(cellHeight,cellHeight * child.percentHeight / 100);
            }
            else
            {
               childHeight = Number(child.getExplicitOrMeasuredHeight());
            }
            child.setActualSize(childWidth,childHeight);
            xOffset = Math.floor(calcHorizontalOffset(child.width,horizontalAlign));
            yOffset = Math.floor(calcVerticalOffset(child.height,verticalAlign));
            child.move(xPos + xOffset,yPos + yOffset);
            if(i % rowCount == rowCount - 1)
            {
               yPos = Number(vm.top);
               xPos += colWidth + horizontalGap;
            }
            else
            {
               yPos += cellHeight + verticalGap;
            }
         }
         if(rowCount != _preferredMajorAxisLength)
         {
            _actualMajorAxisLength = rowCount;
            invalidateSize();
         }
      }
      
      private function addLegendItem(legendData:Object) : void
      {
         var c:Class = legendItemClass;
         var newItem:LegendItem = new c();
         newItem.marker = legendData.marker;
         if(legendData.label != "")
         {
            newItem.label = legendData.label;
         }
         if(Boolean(legendData.element))
         {
            newItem.element = legendData.element;
         }
         if("fill" in legendData)
         {
            newItem.setStyle("fill",legendData["fill"]);
         }
         newItem.markerAspectRatio = legendData.aspectRatio;
         newItem.legendData = legendData;
         newItem.percentWidth = 100;
         newItem.percentHeight = 100;
         addChild(newItem);
         newItem.setStyle("backgroundColor",15658751);
      }
      
      private function calcColumnWidthsForWidth(w:Number) : Array
      {
         var columnSizes:Array = null;
         var child:IUIComponent = null;
         var childPreferredWidth:Number = NaN;
         var col:int = 0;
         var n:Number = Number(numChildren);
         var horizontalGap:Number = Number(getStyle("horizontalGap"));
         var xPos:Number = 0;
         var xEnd:Number = w;
         var nColumns:int = 0;
         for(var i:Number = 0; i < n; i++)
         {
            child = IUIComponent(getChildAt(i));
            childPreferredWidth = Number(child.getExplicitOrMeasuredWidth());
            if(xPos + childPreferredWidth > xEnd)
            {
               break;
            }
            xPos += childPreferredWidth + horizontalGap;
            nColumns++;
         }
         var columnsTooWide:Boolean = true;
         while(nColumns > 1 && columnsTooWide)
         {
            columnSizes = [];
            for(i = 0; i < nColumns; i++)
            {
               columnSizes[i] = 0;
            }
            for(i = 0; i < n; i++)
            {
               col = i % nColumns;
               columnSizes[col] = Math.max(columnSizes[col],IUIComponent(getChildAt(i)).getExplicitOrMeasuredWidth());
            }
            xPos = 0;
            for(i = 0; i < nColumns; i++)
            {
               if(xPos + columnSizes[i] > xEnd)
               {
                  break;
               }
               xPos += columnSizes[i] + horizontalGap;
            }
            if(i == nColumns)
            {
               columnsTooWide = false;
            }
            else
            {
               nColumns--;
            }
         }
         if(nColumns <= 1)
         {
            nColumns = 1;
            columnSizes = [cellWidth];
         }
         return columnSizes;
      }
      
      private function populateFromArray(dp:Object) : void
      {
         var curItem:Object = null;
         var curList:Array = null;
         var itemLen:int = 0;
         var j:int = 0;
         if(dp is ChartBase)
         {
            dp = dp.legendData;
         }
         removeAllChildren();
         for(var i:int = 0; i < dp.length; i++)
         {
            curList = dp[i] as Array;
            if(!curList)
            {
               curItem = dp[i];
               addLegendItem(curItem);
            }
            else
            {
               itemLen = int(curList.length);
               for(j = 0; j < itemLen; j++)
               {
                  curItem = curList[j];
                  addLegendItem(curItem);
               }
            }
         }
         _actualMajorAxisLength = NaN;
      }
      
      override public function set horizontalScrollPolicy(value:String) : void
      {
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(_childrenDirty)
         {
            populateFromArray(_dataProvider);
            _childrenDirty = false;
         }
      }
      
      private function legendDataChangedHandler(e:Event = null) : void
      {
         invalidateProperties();
         invalidateSize();
         _childrenDirty = true;
      }
      
      override protected function measure() : void
      {
         var minWidth:Number = NaN;
         var minHeight:Number = NaN;
         var preferredWidth:Number = NaN;
         var preferredHeight:Number = NaN;
         var vm:EdgeMetrics = null;
         var colCount:int = 0;
         var i:int = 0;
         var horizontalGap:Number = NaN;
         var verticalGap:Number = NaN;
         var columns:Array = null;
         var rowCount:int = 0;
         var bCalcColumns:Boolean = false;
         super.measure();
         findCellSize();
         minWidth = Number(cellWidth);
         minHeight = Number(cellHeight);
         var numChildren:int = int(this.numChildren);
         if(numChildren > 0)
         {
            horizontalGap = Number(getStyle("horizontalGap"));
            verticalGap = Number(getStyle("verticalGap"));
            vm = viewMetricsAndPadding;
            if(direction == "vertical")
            {
               bCalcColumns = false;
               if(!isNaN(explicitHeight))
               {
                  preferredHeight = explicitHeight - vm.top - vm.bottom;
                  bCalcColumns = true;
               }
               else if(!isNaN(_actualMajorAxisLength))
               {
                  preferredHeight = _actualMajorAxisLength * cellHeight + (_actualMajorAxisLength - 1) * verticalGap;
                  _actualMajorAxisLength = NaN;
                  bCalcColumns = true;
               }
               if(bCalcColumns)
               {
                  columns = calcColumnWidthsForHeight(preferredHeight);
                  preferredWidth = 0;
                  colCount = int(columns.length);
                  for(i = 0; i < colCount; i++)
                  {
                     preferredWidth += columns[i];
                  }
                  preferredWidth += (colCount - 1) * horizontalGap;
                  rowCount = Math.min(numChildren,Math.max(1,Math.floor((preferredHeight + verticalGap) / (cellHeight + verticalGap))));
                  preferredHeight = rowCount * cellHeight + (rowCount - 1) * verticalGap;
                  _preferredMajorAxisLength = rowCount;
               }
               else
               {
                  preferredHeight = numChildren * cellHeight + (numChildren - 1) * verticalGap;
                  preferredWidth = Number(cellWidth);
                  _preferredMajorAxisLength = numChildren;
               }
            }
            else
            {
               if(!isNaN(explicitWidth))
               {
                  preferredWidth = explicitWidth - vm.left - vm.right;
               }
               else if(!isNaN(_actualMajorAxisLength))
               {
                  preferredWidth = _actualMajorAxisLength - vm.left - vm.right;
                  _actualMajorAxisLength = NaN;
               }
               else
               {
                  preferredWidth = screen.width - vm.left - vm.right;
               }
               columns = calcColumnWidthsForWidth(preferredWidth);
               preferredWidth = 0;
               colCount = int(columns.length);
               for(i = 0; i < colCount; i++)
               {
                  preferredWidth += columns[i];
               }
               preferredWidth += (colCount - 1) * horizontalGap;
               rowCount = Math.ceil(numChildren / colCount);
               preferredHeight = rowCount * cellHeight + (rowCount - 1) * verticalGap;
               _preferredMajorAxisLength = colCount;
            }
         }
         else
         {
            preferredWidth = minWidth;
            preferredHeight = minHeight;
         }
         vm = viewMetricsAndPadding;
         var hExtra:Number = vm.left + vm.right;
         var vExtra:Number = vm.top + vm.bottom;
         minWidth += hExtra;
         preferredWidth += hExtra;
         minHeight += vExtra;
         preferredHeight += vExtra;
         measuredMinWidth = minWidth;
         measuredMinHeight = minHeight;
         measuredWidth = preferredWidth;
         measuredHeight = preferredHeight;
      }
      
      private function calcColumnWidthsForHeight(h:Number) : Array
      {
         var columnSizes:Array = null;
         var i:int = 0;
         var child:IUIComponent = null;
         var col:int = 0;
         var n:Number = Number(numChildren);
         var verticalGap:Number = Number(getStyle("verticalGap"));
         if(isNaN(verticalGap))
         {
            verticalGap = 0;
         }
         var rowCount:int = Math.min(n,Math.max(1,Math.floor((h + verticalGap) / (cellHeight + verticalGap))));
         var nColumns:int = rowCount == 0 ? 0 : int(Math.ceil(n / rowCount));
         if(nColumns <= 1)
         {
            columnSizes = [cellWidth];
         }
         else
         {
            columnSizes = [];
            for(i = 0; i < nColumns; i++)
            {
               columnSizes[i] = 0;
            }
            for(i = 0; i < n; i++)
            {
               child = IUIComponent(getChildAt(i));
               col = Math.floor(i / rowCount);
               columnSizes[col] = Math.max(columnSizes[col],child.getExplicitOrMeasuredWidth());
            }
         }
         return columnSizes;
      }
      
      private function childMouseEventHandler(e:MouseEvent) : void
      {
         var p:DisplayObject = DisplayObject(e.target);
         while(p != this && p.parent != this)
         {
            p = p.parent;
         }
         if(p is LegendItem)
         {
            dispatchEvent(new LegendMouseEvent(e.type,e,LegendItem(p)));
         }
      }
      
      override public function get horizontalScrollPolicy() : String
      {
         return ScrollPolicy.OFF;
      }
      
      override public function set verticalScrollPolicy(value:String) : void
      {
      }
      
      private function widthPadding(numChildren:Number) : Number
      {
         var vm:EdgeMetrics = viewMetricsAndPadding;
         var padding:Number = vm.left + vm.right;
         if(numChildren > 1 && direction == "horizontal")
         {
            padding += getStyle("horizontalGap") * (numChildren - 1);
         }
         return padding;
      }
      
      private function getHorizontalAlignValue() : Number
      {
         var horizontalAlign:String = getStyle("horizontalAlign");
         if(horizontalAlign == "center")
         {
            return 0.5;
         }
         if(horizontalAlign == "right")
         {
            return 1;
         }
         return 0;
      }
      
      private function layoutHorizontal() : void
      {
         var columnSizes:Array = null;
         var child:IUIComponent = null;
         var col:int = 0;
         var colWidth:Number = NaN;
         var childWidth:Number = NaN;
         var childHeight:Number = NaN;
         var xOffset:Number = NaN;
         var yOffset:Number = NaN;
         var n:Number = Number(numChildren);
         var vm:EdgeMetrics = viewMetricsAndPadding;
         var horizontalGap:Number = Number(getStyle("horizontalGap"));
         var verticalGap:Number = Number(getStyle("verticalGap"));
         var horizontalAlign:String = getStyle("horizontalAlign");
         var verticalAlign:String = getStyle("verticalAlign");
         var xPos:Number = Number(vm.left);
         var xEnd:Number = _unscaledWidth - vm.right;
         var yPos:Number = Number(vm.top);
         var nColumns:int = 0;
         columnSizes = calcColumnWidthsForWidth(xEnd - xPos);
         nColumns = int(columnSizes.length);
         for(var i:Number = 0; i < n; i++)
         {
            child = IUIComponent(getChildAt(i));
            col = i % nColumns;
            colWidth = Number(columnSizes[col]);
            if(child.percentWidth > 0)
            {
               childWidth = Math.min(colWidth,colWidth * child.percentWidth / 100);
            }
            else
            {
               childWidth = Number(child.getExplicitOrMeasuredWidth());
            }
            if(child.percentHeight > 0)
            {
               childHeight = Math.min(cellHeight,cellHeight * child.percentHeight / 100);
            }
            else
            {
               childHeight = Number(child.getExplicitOrMeasuredHeight());
            }
            child.setActualSize(childWidth,childHeight);
            xOffset = Math.floor(calcHorizontalOffset(child.width,horizontalAlign));
            yOffset = Math.floor(calcVerticalOffset(child.height,verticalAlign));
            child.move(xPos + xOffset,yPos + yOffset);
            if(col == nColumns - 1)
            {
               xPos = Number(vm.left);
               yPos += cellHeight + verticalGap;
            }
            else
            {
               xPos += columnSizes[col] + horizontalGap;
            }
         }
         if(nColumns != _preferredMajorAxisLength)
         {
            _actualMajorAxisLength = _unscaledWidth;
            invalidateSize();
         }
      }
      
      private function heightPadding(numChildren:Number) : Number
      {
         var vm:EdgeMetrics = viewMetricsAndPadding;
         var padding:Number = vm.top + vm.bottom;
         if(numChildren > 1 && direction == "vertical")
         {
            padding += getStyle("verticalGap") * (numChildren - 1);
         }
         return padding;
      }
      
      override public function get verticalScrollPolicy() : String
      {
         return ScrollPolicy.OFF;
      }
      
      public function set dataProvider(value:Object) : void
      {
         if(_dataProvider is ChartBase)
         {
            _dataProvider.removeEventListener("legendDataChanged",legendDataChangedHandler);
         }
         _dataProvider = Boolean(value) ? value : [];
         if(_dataProvider is ChartBase)
         {
            _dataProvider.addEventListener("legendDataChanged",legendDataChangedHandler,false,0,true);
         }
         else if(!(_dataProvider is ICollectionView))
         {
            if(_dataProvider is IList)
            {
               _dataProvider = new ListCollectionView(IList(_dataProvider));
            }
            else if(_dataProvider is Array)
            {
               _dataProvider = new ArrayCollection(_dataProvider as Array);
            }
            else if(_dataProvider != null)
            {
               _dataProvider = new ArrayCollection([_dataProvider]);
            }
            else
            {
               _dataProvider = new ArrayCollection();
            }
         }
         invalidateProperties();
         invalidateSize();
         _childrenDirty = true;
         dispatchEvent(new Event("collectionChange"));
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         _unscaledWidth = unscaledWidth;
         _unscaledHeight = unscaledHeight;
         if(isNaN(cellWidth))
         {
            findCellSize();
         }
         if(direction == "vertical")
         {
            layoutVertical();
         }
         else
         {
            layoutHorizontal();
         }
      }
      
      private function getVerticalAlignValue() : Number
      {
         var verticalAlign:String = getStyle("verticalAlign");
         if(verticalAlign == "middle")
         {
            return 0.5;
         }
         if(verticalAlign == "bottom")
         {
            return 1;
         }
         return 0;
      }
      
      [Inspectable(category="Data")]
      [Bindable("collectionChange")]
      public function get dataProvider() : Object
      {
         return _dataProvider;
      }
   }
}

