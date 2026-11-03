package mx.charts.chartClasses
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import mx.charts.AxisRenderer;
   import mx.charts.ChartItem;
   import mx.charts.GridLines;
   import mx.charts.LinearAxis;
   import mx.charts.events.ChartItemEvent;
   import mx.charts.styles.HaloDefaults;
   import mx.collections.ArrayCollection;
   import mx.collections.ICollectionView;
   import mx.collections.IList;
   import mx.collections.ListCollectionView;
   import mx.collections.XMLListCollection;
   import mx.core.IUIComponent;
   import mx.core.UIComponent;
   import mx.graphics.SolidColor;
   import mx.graphics.Stroke;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   [Style(name="verticalAxisStyleNames",type="Array",arrayType="String",inherit="no")]
   [Style(name="horizontalAxisStyleNames",type="Array",arrayType="String",inherit="no")]
   [Style(name="verticalAxisStyleName",type="String",inherit="no",deprecatedReplacement="verticalAxisStyleNames")]
   [Style(name="secondVerticalAxisStyleName",type="String",inherit="no",deprecatedReplacement="verticalAxisStyleNames")]
   [Style(name="secondHorizontalAxisStyleName",type="String",inherit="no",deprecatedReplacement="horizontalAxisStyleNames")]
   [Style(name="horizontalAxisStyleName",type="String",inherit="no",deprecatedReplacement="horizontalAxisStyleNames")]
   [Style(name="gutterTop",type="Number",format="Length",inherit="no")]
   [Style(name="gutterRight",type="Number",format="Length",inherit="no")]
   [Style(name="gutterLeft",type="Number",format="Length",inherit="no")]
   [Style(name="gutterBottom",type="Number",format="Length",inherit="no")]
   [Style(name="gridLinesStyleName",type="String",inherit="no")]
   [Style(name="axisTitleStyleName",type="String",inherit="yes")]
   [Style(name="textIndent",type="Number",format="Length",inherit="yes")]
   [Style(name="textDecoration",type="String",enumeration="none,underline",inherit="yes")]
   [Style(name="textAlign",type="String",enumeration="left,center,right",inherit="yes")]
   [Style(name="letterSpacing",type="Number",inherit="yes")]
   [Style(name="kerning",type="Boolean",inherit="yes")]
   [Style(name="fontWeight",type="String",enumeration="normal,bold",inherit="yes")]
   [Style(name="fontThickness",type="Number",inherit="yes")]
   [Style(name="fontStyle",type="String",enumeration="normal,italic",inherit="yes")]
   [Style(name="fontSize",type="Number",format="Length",inherit="yes")]
   [Style(name="fontSharpness",type="Number",inherit="yes")]
   [Style(name="fontGridFitType",type="String",enumeration="none,pixel,subpixel",inherit="yes")]
   [Style(name="fontFamily",type="String",inherit="yes")]
   [Style(name="fontAntiAliasType",type="String",enumeration="normal,advanced",inherit="yes")]
   [Style(name="disabledColor",type="uint",format="Color",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   public class CartesianChart extends ChartBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var stylesInited:Boolean = initStyles();
      
      private var _verticalAxisRenderer:IAxisRenderer;
      
      private var _transformBounds:Rectangle = new Rectangle();
      
      private var _bAxisLayoutDirty:Boolean = true;
      
      [Inspectable(category="Data")]
      public var verticalAxisRatio:Number = 0.33;
      
      private var _horizontalAxis:IAxis;
      
      private var _verticalAxis:IAxis;
      
      private var _topRenderers:Array = [];
      
      [Inspectable(category="Data")]
      public var horizontalAxisRatio:Number = 0.33;
      
      private var _horizontalAxisRenderer2:IAxisRenderer;
      
      private var _bDualMode:Boolean = false;
      
      private var _bAxisStylesDirty:Boolean = true;
      
      private var _verticalAxisRenderer2:IAxisRenderer;
      
      private var _series2:Array;
      
      private var _bAxesRenderersDirty:Boolean = false;
      
      private var _horizontalAxisRenderers:Array = [];
      
      private var _rightRenderers:Array = [];
      
      private var _defaultGridLines:GridLines;
      
      private var _userSeries2:Array;
      
      private var _verticalAxisRenderers:Array = [];
      
      private var _labelElements2:Array;
      
      private var _computedGutters:Rectangle = new Rectangle();
      
      private var _horizontalAxis2:IAxis;
      
      private var _leftRenderers:Array = [];
      
      private var _bgridLinesStyleNameDirty:Boolean = true;
      
      private var _dataProvider2:ICollectionView;
      
      private var _verticalAxis2:IAxis;
      
      private var _horizontalAxisRenderer:IAxisRenderer;
      
      private var _bottomRenderers:Array = [];
      
      private var _allSeries:Array = [];
      
      public function CartesianChart()
      {
         super();
         StyleManager.registerInheritingStyle("axisTitleStyleName");
         horizontalAxis = new LinearAxis();
         verticalAxis = new LinearAxis();
         _series2 = _userSeries2 = [];
         transforms = [new CartesianTransform()];
         var gridLines:GridLines = new GridLines();
         backgroundElements = [gridLines];
         _defaultGridLines = gridLines;
         addEventListener("axisPlacementChange",axisPlacementChangeHandler);
      }
      
      private static function initStyles() : Boolean
      {
         var cartesianChartStyle:CSSStyleDeclaration;
         HaloDefaults.init();
         cartesianChartStyle = HaloDefaults.createSelector("CartesianChart");
         cartesianChartStyle.defaultFactory = function():void
         {
            this.axisColor = 14016221;
            this.chartSeriesStyles = HaloDefaults.chartBaseChartSeriesStyles;
            this.dataTipRenderer = DataTip;
            this.fill = new SolidColor(16777215,0);
            this.calloutStroke = new Stroke(8947848,2);
            this.fontSize = 10;
            this.horizontalAxisStyleName = "blockCategoryAxis";
            this.secondHorizontalAxisStyleName = "blockCategoryAxis";
            this.secondVerticalAxisStyleName = "blockNumericAxis";
            this.verticalAxisStyleName = "blockNumericAxis";
            this.horizontalAxisStyleNames = ["blockCategoryAxis"];
            this.verticalAxisStyleNames = ["blockNumericAxis"];
         };
         return true;
      }
      
      protected function initSecondaryMode() : void
      {
         _bDualMode = true;
         transforms = [_transforms[0],new CartesianTransform()];
      }
      
      public function set secondHorizontalAxis(value:IAxis) : void
      {
         _horizontalAxis2 = value;
         if(!_bDualMode)
         {
            initSecondaryMode();
         }
         _bAxesRenderersDirty = true;
         invalidateData();
         invalidateProperties();
      }
      
      [Deprecated(replacement="IChartElement2.localToData()")]
      override public function localToData(v:Point) : Array
      {
         return _transforms[0].invertTransform(v.x - _transformBounds.left,v.y - _transformBounds.top);
      }
      
      [Inspectable(category="Data",arrayType="mx.charts.chartClasses.Series")]
      [Deprecated(replacement="CartesianChart.series")]
      public function get secondSeries() : Array
      {
         return _series2;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function updateData() : void
      {
         if(dataProvider != null)
         {
            applyDataProvider(ICollectionView(dataProvider),_transforms[0]);
         }
         if(_dataProvider2 != null && _transforms.length >= 2)
         {
            applyDataProvider(_dataProvider2,_transforms[1]);
         }
      }
      
      public function set secondSeries(value:Array) : void
      {
         value = value == null ? [] : value;
         _userSeries2 = value;
         for(var i:int = 0; i < value.length; i++)
         {
            if(value[i] is Series)
            {
               (value[i] as Series).owner = this;
            }
         }
         if(!_bDualMode)
         {
            initSecondaryMode();
         }
         invalidateSeries();
         invalidateData();
         legendDataChanged();
      }
      
      [Deprecated(replacement="CartesianChart.verticalAxisRenderers")]
      [Inspectable(category="Data")]
      public function get verticalAxisRenderer() : IAxisRenderer
      {
         return _verticalAxisRenderer;
      }
      
      private function updateMultipleAxesRenderers() : void
      {
         var hLen:uint = _horizontalAxisRenderers.length;
         var vLen:uint = _verticalAxisRenderers.length;
         for(var i:int = 0; i < hLen; i++)
         {
            addChild(DisplayObject(_horizontalAxisRenderers[i]));
         }
         for(i = 0; i < vLen; i++)
         {
            addChild(DisplayObject(_verticalAxisRenderers[i]));
         }
         adjustAxesPlacements();
         invalidateDisplayList();
      }
      
      override public function getPreviousItem(direction:String) : ChartItem
      {
         if(direction == ChartBase.HORIZONTAL)
         {
            return getPreviousSeriesItem(_allSeries);
         }
         if(direction == ChartBase.VERTICAL)
         {
            return getPreviousSeries(_allSeries);
         }
         return null;
      }
      
      override public function getNextItem(direction:String) : ChartItem
      {
         if(direction == ChartBase.HORIZONTAL)
         {
            return getNextSeriesItem(_allSeries);
         }
         if(direction == ChartBase.VERTICAL)
         {
            return getNextSeries(_allSeries);
         }
         return null;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getTopMostRenderer() : IAxisRenderer
      {
         var n:int = int(_topRenderers.length);
         if(n > 0)
         {
            return _topRenderers[n - 1];
         }
         return null;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getBottomMostRenderer() : IAxisRenderer
      {
         var n:int = int(_bottomRenderers.length);
         if(n > 0)
         {
            return _bottomRenderers[n - 1];
         }
         return null;
      }
      
      override public function getFirstItem(direction:String) : ChartItem
      {
         var item:ChartItem = null;
         if(Boolean(_caretItem))
         {
            item = Series(_caretItem.element).items[0];
         }
         else
         {
            item = getNextSeriesItem(_allSeries);
         }
         return item;
      }
      
      public function set verticalAxisRenderers(value:Array) : void
      {
         var i:int = 0;
         if(Boolean(_verticalAxisRenderers))
         {
            for(i = 0; i < _verticalAxisRenderers.length; i++)
            {
               if(DisplayObject(_verticalAxisRenderers[i]).parent == this)
               {
                  removeChild(DisplayObject(_verticalAxisRenderers[i]));
               }
            }
         }
         _verticalAxisRenderers = value;
         for(i = 0; i < value.length; i++)
         {
            _verticalAxisRenderers[i].horizontal = false;
         }
         invalidateProperties();
         _bAxisStylesDirty = true;
         _bAxesRenderersDirty = true;
         invalidateProperties();
      }
      
      public function set verticalAxisRenderer(value:IAxisRenderer) : void
      {
         if(Boolean(_verticalAxisRenderer))
         {
            if(DisplayObject(_verticalAxisRenderer).parent == this)
            {
               removeChild(DisplayObject(_verticalAxisRenderer));
            }
         }
         _verticalAxisRenderer = value;
         if(Boolean(_verticalAxisRenderer.axis))
         {
            verticalAxis = _verticalAxisRenderer.axis;
         }
         _verticalAxisRenderer.horizontal = false;
         _bAxisStylesDirty = true;
         _bAxesRenderersDirty = true;
         invalidateChildOrder();
         invalidateProperties();
      }
      
      [Inspectable(category="Data")]
      public function get verticalAxis() : IAxis
      {
         return _verticalAxis;
      }
      
      [Deprecated(replacement="series.getAxis()")]
      public function getSecondAxis(dimension:String) : IAxis
      {
         return transforms[0].getAxis(dimension);
      }
      
      override protected function get dataRegion() : Rectangle
      {
         return _transformBounds;
      }
      
      override public function getLastItem(direction:String) : ChartItem
      {
         var item:ChartItem = null;
         if(Boolean(_caretItem))
         {
            item = Series(_caretItem.element).items[Series(_caretItem.element).items.length - 1];
         }
         else
         {
            item = getPreviousSeriesItem(_allSeries);
         }
         return item;
      }
      
      private function updateMultipleAxesStyles() : void
      {
         var hsNames:Array = getStyle("horizontalAxisStyleNames");
         var vsNames:Array = getStyle("verticalAxisStyleNames");
         var hlen:uint = _horizontalAxisRenderers.length;
         var vlen:uint = _verticalAxisRenderers.length;
         var hslen:uint = hsNames.length;
         var vslen:uint = vsNames.length;
         for(var i:int = 0; i < hlen; i++)
         {
            if(_horizontalAxisRenderers[i] is DualStyleObject)
            {
               DualStyleObject(_horizontalAxisRenderers[i]).internalStyleName = hsNames[i % hslen];
            }
         }
         for(i = 0; i < vlen; i++)
         {
            if(_verticalAxisRenderers[i] is DualStyleObject)
            {
               DualStyleObject(_verticalAxisRenderers[i]).internalStyleName = vsNames[i % vslen];
            }
         }
      }
      
      [Deprecated(replacement="series.getAxis()")]
      public function setSecondAxis(dimension:String, value:IAxis) : void
      {
         transforms[0].setAxis(dimension,value);
      }
      
      [Deprecated(replacement="CartesianChart.dataProvider")]
      [Inspectable(category="Data")]
      public function get secondDataProvider() : Object
      {
         return _dataProvider2;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getSeriesTransformState(seriesObject:Object) : Boolean
      {
         var bState:Boolean = false;
         var j:int = 0;
         if(seriesObject is StackedSeries)
         {
            for(j = 0; j < (seriesObject as StackedSeries).series.length; j++)
            {
               bState = getSeriesTransformState((seriesObject as StackedSeries).series[j]);
               if(bState)
               {
                  return true;
               }
            }
            return false;
         }
         return seriesObject.getTransformState();
      }
      
      override protected function setChartState(value:uint) : void
      {
         if(chartState == value)
         {
            return;
         }
         var oldState:uint = chartState;
         super.setChartState(value);
         if(Boolean(_horizontalAxisRenderer))
         {
            _horizontalAxisRenderer.chartStateChanged(oldState,value);
         }
         if(Boolean(_verticalAxisRenderer))
         {
            _verticalAxisRenderer.chartStateChanged(oldState,value);
         }
         if(Boolean(_horizontalAxisRenderer2))
         {
            _horizontalAxisRenderer2.chartStateChanged(oldState,value);
         }
         if(Boolean(_verticalAxisRenderer2))
         {
            _verticalAxisRenderer2.chartStateChanged(oldState,value);
         }
         var hLen:uint = _horizontalAxisRenderers.length;
         var vLen:uint = _verticalAxisRenderers.length;
         for(var i:uint = 0; i < hLen; i++)
         {
            _horizontalAxisRenderers[i].chartStateChanged(oldState,value);
         }
         for(i = 0; i < vLen; i++)
         {
            _verticalAxisRenderers[i].chartStateChanged(oldState,value);
         }
      }
      
      public function set secondVerticalAxisRenderer(value:IAxisRenderer) : void
      {
         if(Boolean(_verticalAxisRenderer2))
         {
            if(DisplayObject(_verticalAxisRenderer2).parent == this)
            {
               removeChild(DisplayObject(_verticalAxisRenderer2));
            }
         }
         _verticalAxisRenderer2 = value;
         if(Boolean(_verticalAxisRenderer2.axis))
         {
            secondVerticalAxis = _verticalAxisRenderer2.axis;
         }
         _verticalAxisRenderer2.horizontal = false;
         _bAxisStylesDirty = true;
         _bAxesRenderersDirty = true;
         invalidateChildOrder();
         invalidateProperties();
      }
      
      public function set horizontalAxisRenderers(value:Array) : void
      {
         var i:int = 0;
         if(Boolean(_horizontalAxisRenderers))
         {
            for(i = 0; i < _horizontalAxisRenderers.length; i++)
            {
               if(DisplayObject(_horizontalAxisRenderers[i]).parent == this)
               {
                  removeChild(DisplayObject(_horizontalAxisRenderers[i]));
               }
               _horizontalAxisRenderers[i].otherAxes = null;
            }
         }
         _horizontalAxisRenderers = value;
         for(i = 0; i < value.length; i++)
         {
            _horizontalAxisRenderers[i].horizontal = true;
         }
         invalidateProperties();
         _bAxesRenderersDirty = true;
         _bAxisStylesDirty = true;
         invalidateChildOrder();
         invalidateProperties();
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(Boolean(_horizontalAxisRenderer))
         {
            measuredMinHeight = _horizontalAxisRenderer.minHeight + 40;
         }
         if(Boolean(_verticalAxisRenderer))
         {
            measuredMinWidth = _verticalAxisRenderer.minWidth + 40;
         }
         if(Boolean(_horizontalAxisRenderer2))
         {
            measuredMinHeight += _horizontalAxisRenderer2.minHeight;
         }
         if(Boolean(_verticalAxisRenderer2))
         {
            measuredMinWidth += _verticalAxisRenderer2.minWidth;
         }
         for(var i:int = 0; i < _horizontalAxisRenderers.length; i++)
         {
            measuredMinHeight += _horizontalAxisRenderers[i].minHeight + 40;
         }
         for(i = 0; i < _verticalAxisRenderers.length; i++)
         {
            measuredMinWidth += _verticalAxisRenderers[i].minWidth + 40;
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function updateAxisOrder(nextIndex:int) : int
      {
         if(Boolean(_horizontalAxisRenderer))
         {
            setChildIndex(DisplayObject(_horizontalAxisRenderer),nextIndex++);
         }
         if(Boolean(_verticalAxisRenderer))
         {
            setChildIndex(DisplayObject(_verticalAxisRenderer),nextIndex++);
         }
         if(Boolean(_horizontalAxisRenderer2))
         {
            setChildIndex(DisplayObject(_horizontalAxisRenderer2),nextIndex++);
         }
         if(Boolean(_verticalAxisRenderer2))
         {
            setChildIndex(DisplayObject(_verticalAxisRenderer2),nextIndex++);
         }
         for(var i:int = 0; i < _horizontalAxisRenderers.length; i++)
         {
            setChildIndex(DisplayObject(_horizontalAxisRenderers[i]),nextIndex++);
         }
         for(i = 0; i < _verticalAxisRenderers.length; i++)
         {
            setChildIndex(DisplayObject(_verticalAxisRenderers[i]),nextIndex++);
         }
         return nextIndex;
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         if(selectionMode == "none")
         {
            return;
         }
         var item:ChartItem = null;
         var bSpace:Boolean = false;
         switch(event.keyCode)
         {
            case Keyboard.UP:
               item = getNextItem(ChartBase.VERTICAL);
               break;
            case Keyboard.DOWN:
               item = getPreviousItem(ChartBase.VERTICAL);
               break;
            case Keyboard.LEFT:
               item = getPreviousItem(ChartBase.HORIZONTAL);
               break;
            case Keyboard.RIGHT:
               item = getNextItem(ChartBase.HORIZONTAL);
               break;
            case Keyboard.END:
            case Keyboard.PAGE_DOWN:
               item = getLastItem(ChartBase.HORIZONTAL);
               break;
            case Keyboard.HOME:
            case Keyboard.PAGE_UP:
               item = getFirstItem(ChartBase.HORIZONTAL);
               break;
            case Keyboard.SPACE:
               handleSpace(event);
               event.stopPropagation();
               return;
         }
         if(Boolean(item))
         {
            event.stopImmediatePropagation();
            handleNavigation(item,event);
         }
      }
      
      public function set verticalAxis(value:IAxis) : void
      {
         _verticalAxis = value;
         _bAxesRenderersDirty = true;
         invalidateData();
         invalidateChildOrder();
         invalidateProperties();
      }
      
      [Deprecated(replacement="CartesianChart.horizontalAxisRenderers")]
      [Inspectable(category="Data")]
      public function get secondHorizontalAxisRenderer() : IAxisRenderer
      {
         return _horizontalAxisRenderer2;
      }
      
      [Deprecated(replacement="horizontalAxis in individual series")]
      [Inspectable(category="Data")]
      public function get secondHorizontalAxis() : IAxis
      {
         return _horizontalAxis2;
      }
      
      override public function get selectedChartItems() : Array
      {
         var j:int = 0;
         var arr:Array = [];
         for(var i:int = 0; i < _allSeries.length; i++)
         {
            for(j = 0; j < _allSeries[i].selectedItems.length; j++)
            {
               arr.push(_allSeries[i].selectedItems[j]);
            }
         }
         return arr;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getLeftMostRenderer() : IAxisRenderer
      {
         var n:int = int(_leftRenderers.length);
         if(n > 0)
         {
            return _leftRenderers[n - 1];
         }
         return null;
      }
      
      override public function set backgroundElements(value:Array) : void
      {
         super.backgroundElements = value;
         _defaultGridLines = null;
      }
      
      public function set horizontalAxisRenderer(value:IAxisRenderer) : void
      {
         if(Boolean(_horizontalAxisRenderer))
         {
            if(DisplayObject(_horizontalAxisRenderer).parent == this)
            {
               removeChild(DisplayObject(_horizontalAxisRenderer));
            }
            _horizontalAxisRenderer.otherAxes = null;
         }
         _horizontalAxisRenderer = value;
         if(Boolean(_horizontalAxisRenderer.axis))
         {
            horizontalAxis = _horizontalAxisRenderer.axis;
         }
         _horizontalAxisRenderer.horizontal = true;
         _bAxesRenderersDirty = true;
         _bAxisStylesDirty = true;
         invalidateChildOrder();
         invalidateProperties();
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function updateKeyboardCache() : void
      {
         var arrItems:Array = null;
         var index:int = 0;
         var j:int = 0;
         loop0:
         for(var i:int = 0; i < _transforms.length; )
         {
            j = 0;
            while(true)
            {
               if(j >= _transforms[i].elements.length)
               {
                  i++;
                  continue loop0;
               }
               if(_transforms[i].elements[j] is Series && getSeriesTransformState(_transforms[i].elements[j]) == true)
               {
                  break;
               }
               j++;
            }
            return;
         }
         var arrObjects:Array = [];
         var arrSelect:Array = [];
         var bExistingSelection:Boolean = false;
         var nCount:int = 0;
         for(i = 0; i < _allSeries.length; i++)
         {
            arrItems = _allSeries[i].items;
            if(Boolean(arrItems) && _allSeries[i].selectedItems.length > 0)
            {
               bExistingSelection = true;
               for(j = 0; j < arrItems.length; j++)
               {
                  arrObjects.push(arrItems[j].item);
               }
               nCount += _allSeries[i].selectedItems.length;
               for(j = 0; j < _allSeries[i].selectedItems.length; j++)
               {
                  index = arrObjects.indexOf(_allSeries[i].selectedItems[j].item);
                  if(index != -1)
                  {
                     arrSelect.push(_allSeries[i].items[index]);
                  }
               }
               arrObjects = [];
               _allSeries[i].emptySelectedItems();
            }
         }
         if(bExistingSelection)
         {
            selectSpecificChartItems(arrSelect);
            if(nCount != arrSelect.length)
            {
               dispatchEvent(new ChartItemEvent(ChartItemEvent.CHANGE,null,null,this));
            }
         }
      }
      
      public function set secondVerticalAxis(value:IAxis) : void
      {
         _verticalAxis2 = value;
         if(!_bDualMode)
         {
            initSecondaryMode();
         }
         _bAxesRenderersDirty = true;
         invalidateData();
         invalidateProperties();
      }
      
      [Inspectable(category="Data",arrayType="mx.charts.chartClasses.IAxisRenderer")]
      public function get verticalAxisRenderers() : Array
      {
         return _verticalAxisRenderers;
      }
      
      private function axisPlacementChangeHandler(event:Event) : void
      {
         adjustAxesPlacements();
         invalidateDisplayList();
      }
      
      public function set secondDataProvider(value:Object) : void
      {
         if(value is Array)
         {
            value = new ArrayCollection(value as Array);
         }
         else if(!(value is ICollectionView))
         {
            if(value is IList)
            {
               value = new ListCollectionView(value as IList);
            }
            else if(value is XMLList)
            {
               value = new XMLListCollection(XMLList(value));
            }
            else if(value != null)
            {
               value = new ArrayCollection([value]);
            }
            else
            {
               value = new ArrayCollection();
            }
         }
         _dataProvider2 = ICollectionView(value);
         if(!_bDualMode)
         {
            initSecondaryMode();
         }
         invalidateData();
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function updateSeries() : void
      {
         var i:int = 0;
         var c:DisplayObject = null;
         var g:IChartElement = null;
         var labelLayer:UIComponent = null;
         var displayedSeries:Array = applySeriesSet(series,_transforms[0]);
         if(_userSeries2 != null && _transforms.length >= 2)
         {
            _series2 = applySeriesSet(_userSeries2,_transforms[1]);
         }
         var len:int = Boolean(displayedSeries) ? int(displayedSeries.length) : 0;
         removeElements(_backgroundElementHolder,true);
         removeElements(_seriesFilterer,false);
         removeElements(_annotationElementHolder,true);
         addElements(backgroundElements,_transforms[0],_backgroundElementHolder);
         allElements = backgroundElements.concat();
         addElements(displayedSeries,_transforms[0],_seriesFilterer);
         allElements = allElements.concat(displayedSeries);
         addElements(_series2,_transforms[1],_seriesFilterer);
         allElements = allElements.concat(_series2);
         labelElements = [];
         for(i = 0; i < displayedSeries.length; i++)
         {
            g = displayedSeries[i] as IChartElement;
            if(g)
            {
               Series(g).invalidateProperties();
               labelLayer = UIComponent(g.labelContainer);
               if(Boolean(labelLayer))
               {
                  labelElements.push(labelLayer);
               }
            }
         }
         for(i = 0; i < _series2.length; i++)
         {
            g = _series2[i] as IChartElement;
            if(g)
            {
               Series(g).invalidateProperties();
               labelLayer = UIComponent(g.labelContainer);
               if(Boolean(labelLayer))
               {
                  labelElements.push(labelLayer);
               }
            }
         }
         addElements(labelElements,_transforms[0],_annotationElementHolder);
         allElements = allElements.concat(labelElements);
         addElements(annotationElements,_transforms[0],_annotationElementHolder);
         allElements = allElements.concat(annotationElements);
         _transforms[0].elements = annotationElements.concat(displayedSeries).concat(backgroundElements);
         if(_transforms.length >= 2)
         {
            _transforms[1].elements = _series2;
         }
         _allSeries = getSeriesObjects(series);
         if(Boolean(secondSeries))
         {
            _allSeries = _allSeries.concat(getSeriesObjects(secondSeries));
         }
         invalidateData();
         invalidateSeriesStyles();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function adjustAxesPlacements() : void
      {
         var leftLen:uint = 0;
         var rightLen:uint = 0;
         var topLen:uint = 0;
         var bottomLen:uint = 0;
         var emptyhLen:uint = 0;
         var emptyvLen:uint = 0;
         var emptyhorizontalRenderers:Array = [];
         var emptyverticalRenderers:Array = [];
         _leftRenderers = [];
         _rightRenderers = [];
         _bottomRenderers = [];
         _topRenderers = [];
         var hLen:uint = _horizontalAxisRenderers.length;
         var vLen:uint = _verticalAxisRenderers.length;
         for(var i:int = 0; i < hLen; i++)
         {
            if(_horizontalAxisRenderers[i].placement == "bottom")
            {
               _bottomRenderers.push(_horizontalAxisRenderers[i]);
            }
            else if(_horizontalAxisRenderers[i].placement == "top")
            {
               _topRenderers.push(_horizontalAxisRenderers[i]);
            }
            else
            {
               emptyhorizontalRenderers.push(_horizontalAxisRenderers[i]);
            }
         }
         for(i = 0; i < vLen; i++)
         {
            if(_verticalAxisRenderers[i].placement == "left")
            {
               _leftRenderers.push(_verticalAxisRenderers[i]);
            }
            else if(_verticalAxisRenderers[i].placement == "right")
            {
               _rightRenderers.push(_verticalAxisRenderers[i]);
            }
            else
            {
               emptyverticalRenderers.push(_verticalAxisRenderers[i]);
            }
         }
         if(Boolean(_horizontalAxisRenderer))
         {
            if(_horizontalAxisRenderer.placement == "bottom")
            {
               _bottomRenderers.push(_horizontalAxisRenderer);
            }
            else if(_horizontalAxisRenderer.placement == "top")
            {
               _topRenderers.push(_horizontalAxisRenderer);
            }
            else
            {
               emptyhorizontalRenderers.push(_horizontalAxisRenderer);
            }
         }
         if(Boolean(_verticalAxisRenderer))
         {
            if(_verticalAxisRenderer.placement == "left")
            {
               _leftRenderers.push(_verticalAxisRenderer);
            }
            else if(_verticalAxisRenderer.placement == "right")
            {
               _rightRenderers.push(_verticalAxisRenderer);
            }
            else
            {
               emptyverticalRenderers.push(_verticalAxisRenderer);
            }
         }
         if(Boolean(_horizontalAxisRenderer2))
         {
            if(_horizontalAxisRenderer2.placement == "bottom")
            {
               _bottomRenderers.push(_horizontalAxisRenderer2);
            }
            else if(_horizontalAxisRenderer2.placement == "top")
            {
               _topRenderers.push(_horizontalAxisRenderer2);
            }
            else
            {
               emptyhorizontalRenderers.push(_horizontalAxisRenderer2);
            }
         }
         if(Boolean(_verticalAxisRenderer2))
         {
            if(_verticalAxisRenderer2.placement == "left")
            {
               _leftRenderers.push(_verticalAxisRenderer2);
            }
            else if(_verticalAxisRenderer2.placement == "right")
            {
               _rightRenderers.push(_verticalAxisRenderer2);
            }
            else
            {
               emptyverticalRenderers.push(_verticalAxisRenderer2);
            }
         }
         leftLen = _leftRenderers.length;
         rightLen = _rightRenderers.length;
         topLen = _topRenderers.length;
         bottomLen = _bottomRenderers.length;
         emptyhLen = emptyhorizontalRenderers.length;
         emptyvLen = emptyverticalRenderers.length;
         var nCount:uint = 0;
         if(leftLen > rightLen)
         {
            nCount = 0;
            while(nCount < leftLen - rightLen && nCount < emptyvLen)
            {
               _rightRenderers.push(emptyverticalRenderers[nCount]);
               emptyverticalRenderers[nCount].placement = "right";
               nCount++;
            }
         }
         else if(leftLen < rightLen)
         {
            nCount = 0;
            while(nCount < rightLen - leftLen && nCount < emptyvLen)
            {
               _leftRenderers.push(emptyverticalRenderers[nCount]);
               emptyverticalRenderers[nCount].placement = "left";
               nCount++;
            }
         }
         for(i = int(nCount); i < emptyvLen; i++)
         {
            if(i % 2 == 0)
            {
               _leftRenderers.push(emptyverticalRenderers[i]);
               emptyverticalRenderers[i].placement = "left";
            }
            else
            {
               _rightRenderers.push(emptyverticalRenderers[i]);
               emptyverticalRenderers[i].placement = "right";
            }
         }
         if(bottomLen > topLen)
         {
            nCount = 0;
            while(nCount < bottomLen - topLen && nCount < emptyhLen)
            {
               _topRenderers.push(emptyhorizontalRenderers[nCount]);
               emptyhorizontalRenderers[nCount].placement = "top";
               nCount++;
            }
         }
         else if(topLen < bottomLen)
         {
            nCount = 0;
            while(nCount < topLen - bottomLen && nCount < emptyhLen)
            {
               _bottomRenderers.push(emptyhorizontalRenderers[nCount]);
               emptyhorizontalRenderers[nCount].placement = "bottom";
               nCount++;
            }
         }
         for(i = int(nCount); i < emptyhLen; i++)
         {
            if(i % 2 == 0)
            {
               _bottomRenderers.push(emptyhorizontalRenderers[i]);
               emptyhorizontalRenderers[i].placement = "bottom";
            }
            else
            {
               _topRenderers.push(emptyhorizontalRenderers[i]);
               emptyhorizontalRenderers[i].placement = "top";
            }
         }
      }
      
      [Inspectable(category="Data",arrayType="mx.charts.chartClasses.IAxisRenderer")]
      public function get horizontalAxisRenderers() : Array
      {
         return _horizontalAxisRenderers;
      }
      
      [Deprecated(replacement="IChartElement2.dataToLocal()")]
      override public function dataToLocal(... dataValues) : Point
      {
         var data:Object = {};
         var da:Array = [data];
         var n:int = int(dataValues.length);
         if(n > 0)
         {
            data["d0"] = dataValues[0];
            _transforms[0].getAxis(CartesianTransform.HORIZONTAL_AXIS).mapCache(da,"d0","v0");
         }
         if(n > 1)
         {
            data["d1"] = dataValues[1];
            _transforms[0].getAxis(CartesianTransform.VERTICAL_AXIS).mapCache(da,"d1","v1");
         }
         _transforms[0].transformCache(da,"v0","s0","v1","s1");
         return new Point(data.s0 + _transformBounds.left,data.s1 + _transformBounds.top);
      }
      
      [Deprecated(replacement="CartesianChart.verticalAxisRenderers")]
      [Inspectable(category="Data")]
      public function get secondVerticalAxisRenderer() : IAxisRenderer
      {
         return _verticalAxisRenderer2;
      }
      
      public function set secondHorizontalAxisRenderer(value:IAxisRenderer) : void
      {
         if(Boolean(_horizontalAxisRenderer2))
         {
            if(DisplayObject(_horizontalAxisRenderer2).parent == this)
            {
               removeChild(DisplayObject(_horizontalAxisRenderer2));
            }
            _horizontalAxisRenderer2.otherAxes = null;
         }
         _horizontalAxisRenderer2 = value;
         if(!_bDualMode)
         {
            initSecondaryMode();
         }
         _horizontalAxisRenderer2.horizontal = true;
         if(Boolean(_horizontalAxisRenderer2.axis))
         {
            secondHorizontalAxis = _horizontalAxisRenderer2.axis;
         }
         _bAxesRenderersDirty = true;
         _bAxisStylesDirty = true;
         invalidateChildOrder();
         invalidateProperties();
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         if(styleProp == null || Boolean(_horizontalAxisRenderer) && Boolean(styleProp == "horizontalAxisStyleName"))
         {
            _bAxisStylesDirty = true;
            invalidateDisplayList();
         }
         if(styleProp == null || Boolean(_verticalAxisRenderer) && Boolean(styleProp == "verticalAxisStyleName"))
         {
            _bAxisStylesDirty = true;
            invalidateDisplayList();
         }
         if(styleProp == null || Boolean(_horizontalAxisRenderer2) && Boolean(styleProp == "secondHorizontalAxisStyleName"))
         {
            _bAxisStylesDirty = true;
            invalidateDisplayList();
         }
         if(styleProp == null || Boolean(_verticalAxisRenderer2) && Boolean(styleProp == "secondVerticalAxisStyleName"))
         {
            _bAxisStylesDirty = true;
            invalidateDisplayList();
         }
         if(Boolean(_defaultGridLines) && styleProp == "gridLinesStyleName")
         {
            _bgridLinesStyleNameDirty = true;
            _defaultGridLines.internalStyleName = getStyle("gridLinesStyleName");
            invalidateDisplayList();
         }
         if(styleProp == null || styleProp.indexOf("gutter") == 0)
         {
            _bAxisLayoutDirty = true;
            invalidateDisplayList();
         }
         if(styleProp == null || _horizontalAxisRenderers.length > 0 && styleProp == "horizontalAxisStyleNames")
         {
            _bAxisStylesDirty = true;
            invalidateDisplayList();
         }
         if(styleProp == null || _verticalAxisRenderers.length > 0 && styleProp == "verticalAxisStyleNames")
         {
            _bAxisStylesDirty = true;
            invalidateDisplayList();
         }
         super.styleChanged(styleProp);
      }
      
      [Deprecated(replacement="CartesianChart.horizontalAxisRenderers")]
      [Inspectable(category="Data")]
      public function get horizontalAxisRenderer() : IAxisRenderer
      {
         return _horizontalAxisRenderer;
      }
      
      public function set horizontalAxis(value:IAxis) : void
      {
         _horizontalAxis = value;
         _bAxesRenderersDirty = true;
         invalidateData();
         invalidateProperties();
      }
      
      [Deprecated(replacement="verticalAxis in individual series")]
      [Inspectable(category="Data")]
      public function get secondVerticalAxis() : IAxis
      {
         return _verticalAxis2;
      }
      
      override protected function commitProperties() : void
      {
         var addIndex:int = 0;
         var i:int = 0;
         var g:Series = null;
         var h:Object = null;
         if(_horizontalAxisRenderers.length == 0 && !_horizontalAxisRenderer)
         {
            horizontalAxisRenderer = new AxisRenderer();
         }
         if(_verticalAxisRenderers.length == 0 && !_verticalAxisRenderer)
         {
            verticalAxisRenderer = new AxisRenderer();
         }
         if(_bAxesRenderersDirty)
         {
            addIndex = dataTipLayerIndex - 1;
            if(Boolean(_horizontalAxisRenderer))
            {
               addChild(DisplayObject(_horizontalAxisRenderer));
            }
            if(Boolean(_verticalAxisRenderer))
            {
               addChild(DisplayObject(_verticalAxisRenderer));
            }
            if(Boolean(_horizontalAxisRenderer2))
            {
               addChild(DisplayObject(_horizontalAxisRenderer2));
            }
            if(Boolean(_verticalAxisRenderer2))
            {
               addChild(DisplayObject(_verticalAxisRenderer2));
            }
            invalidateDisplayList();
            if(Boolean(_transforms))
            {
               CartesianTransform(_transforms[0]).setAxis(CartesianTransform.HORIZONTAL_AXIS,_horizontalAxis);
               CartesianTransform(_transforms[0]).setAxis(CartesianTransform.VERTICAL_AXIS,_verticalAxis);
               if(_transforms.length > 1)
               {
                  CartesianTransform(_transforms[1]).setAxis(CartesianTransform.HORIZONTAL_AXIS,_horizontalAxis2 == null ? _horizontalAxis : _horizontalAxis2);
                  CartesianTransform(_transforms[1]).setAxis(CartesianTransform.VERTICAL_AXIS,_verticalAxis2 == null ? _verticalAxis : _verticalAxis2);
               }
            }
            if(Boolean(_horizontalAxisRenderer))
            {
               _horizontalAxisRenderer.axis = _horizontalAxis;
            }
            if(Boolean(_verticalAxisRenderer))
            {
               _verticalAxisRenderer.axis = _verticalAxis;
            }
            if(Boolean(_horizontalAxisRenderer2))
            {
               _horizontalAxisRenderer2.axis = _horizontalAxis2 == null ? _horizontalAxis : _horizontalAxis2;
            }
            if(Boolean(_verticalAxisRenderer2))
            {
               if(!_verticalAxis2)
               {
                  _verticalAxisRenderer2.axis = _verticalAxis;
               }
               else
               {
                  _verticalAxisRenderer2.axis = _verticalAxis2;
               }
            }
            updateMultipleAxesRenderers();
            for(i = 0; i < series.length; i++)
            {
               g = series[i];
               if(g)
               {
                  g.invalidateProperties();
               }
            }
            for(i = 0; i < _series2.length; i++)
            {
               g = _series2[i];
               if(g)
               {
                  g.invalidateProperties();
               }
            }
            for(i = 0; i < annotationElements.length; i++)
            {
               h = annotationElements[i];
               if(h)
               {
                  if(h is IDataCanvas)
                  {
                     h.invalidateProperties();
                  }
               }
            }
            for(i = 0; i < backgroundElements.length; i++)
            {
               h = backgroundElements[i];
               if(h)
               {
                  if(h is IDataCanvas)
                  {
                     h.invalidateProperties();
                  }
               }
            }
            _bAxesRenderersDirty = false;
         }
         if(_bAxisStylesDirty)
         {
            if(Boolean(_horizontalAxisRenderer) && _horizontalAxisRenderer is DualStyleObject)
            {
               DualStyleObject(_horizontalAxisRenderer).internalStyleName = getStyle("horizontalAxisStyleName");
            }
            if(Boolean(_verticalAxisRenderer) && _verticalAxisRenderer is DualStyleObject)
            {
               DualStyleObject(_verticalAxisRenderer).internalStyleName = getStyle("verticalAxisStyleName");
            }
            if(Boolean(_horizontalAxisRenderer2) && _horizontalAxisRenderer2 is DualStyleObject)
            {
               DualStyleObject(_horizontalAxisRenderer2).internalStyleName = getStyle("secondHorizontalAxisStyleName");
            }
            if(Boolean(_verticalAxisRenderer2) && _verticalAxisRenderer2 is DualStyleObject)
            {
               DualStyleObject(_verticalAxisRenderer2).internalStyleName = getStyle("secondVerticalAxisStyleName");
            }
            updateMultipleAxesStyles();
            _bAxisStylesDirty = false;
         }
         if(_bgridLinesStyleNameDirty)
         {
            if(Boolean(_defaultGridLines))
            {
               _defaultGridLines.internalStyleName = getStyle("gridLinesStyleName");
            }
            _bgridLinesStyleNameDirty = false;
         }
         super.commitProperties();
      }
      
      protected function updateAxisLayout(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var otherAxes:Array = null;
         var harPlacement:String = null;
         var varPlacement:String = null;
         var prevLeftOffset:Number = NaN;
         var prevRightOffset:Number = NaN;
         var prevBottomOffset:Number = NaN;
         var prevTopOffset:Number = NaN;
         var maxTopGutter:Number = NaN;
         var maxBottomGutter:Number = NaN;
         var other:Array = null;
         var rect:Rectangle = null;
         var c:DisplayObject = null;
         var paddingLeft:Number = Number(getStyle("paddingLeft"));
         var paddingRight:Number = Number(getStyle("paddingRight"));
         var paddingTop:Number = Number(getStyle("paddingTop"));
         var paddingBottom:Number = Number(getStyle("paddingBottom"));
         var gutterLeft:Object = getStyle("gutterLeft");
         var gutterRight:Object = getStyle("gutterRight");
         var gutterTop:Object = getStyle("gutterTop");
         var gutterBottom:Object = getStyle("gutterBottom");
         var i:int = 0;
         var n:int = 0;
         var hLen:uint = _horizontalAxisRenderers.length;
         var vLen:uint = _verticalAxisRenderers.length;
         var leftLen:uint = _leftRenderers.length;
         var rightLen:uint = _rightRenderers.length;
         var bottomLen:uint = _bottomRenderers.length;
         var topLen:uint = _topRenderers.length;
         var adjustable:Object = {};
         var offset:Object = {
            "left":0,
            "top":0,
            "right":0,
            "bottom":0
         };
         if(!isNaN(horizontalAxisRatio))
         {
            if(Boolean(_horizontalAxisRenderer))
            {
               _horizontalAxisRenderer.heightLimit = horizontalAxisRatio * unscaledHeight;
            }
            for(i = 0; i < hLen; i++)
            {
               _horizontalAxisRenderers[i].heightLimit = horizontalAxisRatio * unscaledHeight;
            }
         }
         if(!isNaN(verticalAxisRatio))
         {
            if(Boolean(_verticalAxisRenderer))
            {
               _verticalAxisRenderer.heightLimit = verticalAxisRatio * unscaledWidth;
            }
            for(i = 0; i < vLen; i++)
            {
               _verticalAxisRenderers[i].heightLimit = verticalAxisRatio * unscaledWidth;
            }
         }
         if(Boolean(_horizontalAxisRenderer))
         {
            _horizontalAxisRenderer.setActualSize(unscaledWidth - paddingLeft - paddingRight,unscaledHeight - paddingTop - paddingBottom);
            _horizontalAxisRenderer.move(paddingLeft,paddingTop);
         }
         for(i = 0; i < hLen; i++)
         {
            _horizontalAxisRenderers[i].setActualSize(unscaledWidth - paddingLeft - paddingRight,unscaledHeight - paddingTop - paddingBottom);
            _horizontalAxisRenderers[i].move(paddingLeft,paddingTop);
         }
         if(Boolean(_verticalAxisRenderer))
         {
            _verticalAxisRenderer.setActualSize(unscaledWidth - paddingLeft - paddingRight,unscaledHeight - paddingTop - paddingBottom);
            _verticalAxisRenderer.move(paddingLeft,paddingTop);
         }
         for(i = 0; i < vLen; i++)
         {
            _verticalAxisRenderers[i].setActualSize(unscaledWidth - paddingLeft - paddingRight,unscaledHeight - paddingTop - paddingBottom);
            _verticalAxisRenderers[i].move(paddingLeft,paddingTop);
         }
         if(Boolean(_horizontalAxisRenderer2))
         {
            _horizontalAxisRenderer2.setActualSize(unscaledWidth - paddingLeft - paddingRight,unscaledHeight - paddingTop - paddingBottom);
            _horizontalAxisRenderer2.move(paddingLeft,paddingTop);
         }
         if(Boolean(_verticalAxisRenderer2))
         {
            _verticalAxisRenderer2.setActualSize(unscaledWidth - paddingLeft - paddingRight,unscaledHeight - paddingTop - paddingBottom);
            _verticalAxisRenderer2.move(paddingLeft,paddingTop);
         }
         if(vLen == 0 && hLen == 0)
         {
            if(_horizontalAxisRenderer.placement == "")
            {
               _horizontalAxisRenderer.placement = "bottom";
            }
            if(_verticalAxisRenderer.placement == "")
            {
               _verticalAxisRenderer.placement = "left";
            }
            if(Boolean(_horizontalAxisRenderer2))
            {
               harPlacement = _horizontalAxisRenderer.placement;
               switch(harPlacement)
               {
                  case "left":
                  case "bottom":
                     _horizontalAxisRenderer2.placement = "right";
                     break;
                  case "top":
                  case "right":
                     _horizontalAxisRenderer2.placement = "left";
               }
            }
            if(Boolean(_verticalAxisRenderer2))
            {
               varPlacement = _verticalAxisRenderer.placement;
               switch(varPlacement)
               {
                  case "left":
                  case "bottom":
                     _verticalAxisRenderer2.placement = "top";
                     break;
                  case "top":
                  case "right":
                     _verticalAxisRenderer2.placement = "bottom";
               }
            }
            _computedGutters = new Rectangle();
            if(gutterLeft != null)
            {
               _computedGutters.left = Number(gutterLeft);
               adjustable.left = false;
            }
            if(gutterRight != null)
            {
               _computedGutters.right = Number(gutterRight);
               adjustable.right = false;
            }
            if(gutterTop != null)
            {
               _computedGutters.top = Number(gutterTop);
               adjustable.top = false;
            }
            if(gutterBottom != null)
            {
               _computedGutters.bottom = Number(gutterBottom);
               adjustable.bottom = false;
            }
            otherAxes = [];
            otherAxes.push(_verticalAxisRenderer);
            if(Boolean(_verticalAxisRenderer2))
            {
               otherAxes.push(_verticalAxisRenderer2);
            }
            _horizontalAxisRenderer.otherAxes = otherAxes;
            if(Boolean(_horizontalAxisRenderer2))
            {
               _horizontalAxisRenderer2.otherAxes = otherAxes;
            }
            _computedGutters = _verticalAxisRenderer.adjustGutters(_computedGutters,adjustable);
            if(Boolean(_verticalAxisRenderer2))
            {
               _computedGutters = _verticalAxisRenderer2.adjustGutters(_computedGutters,adjustable);
            }
            if(Boolean(_horizontalAxisRenderer2))
            {
               _computedGutters = _horizontalAxisRenderer2.adjustGutters(_computedGutters,adjustable);
            }
            _computedGutters = _horizontalAxisRenderer.adjustGutters(_computedGutters,adjustable);
            _verticalAxisRenderer.gutters = _computedGutters;
            if(Boolean(_verticalAxisRenderer2))
            {
               _verticalAxisRenderer2.gutters = _computedGutters;
            }
            if(Boolean(_horizontalAxisRenderer2))
            {
               _horizontalAxisRenderer2.gutters = _computedGutters;
            }
         }
         else
         {
            _computedGutters = new Rectangle();
            if(gutterLeft != null)
            {
               offset.left = Number(gutterLeft) / leftLen;
               adjustable.left = false;
            }
            if(gutterRight != null)
            {
               offset.right = Number(gutterRight) / rightLen;
               adjustable.right = false;
            }
            if(gutterTop != null)
            {
               offset.top = Number(gutterTop) / topLen;
               adjustable.top = false;
            }
            if(gutterBottom != null)
            {
               offset.bottom = Number(gutterBottom) / bottomLen;
               adjustable.bottom = false;
            }
            prevLeftOffset = 0;
            prevRightOffset = 0;
            prevBottomOffset = 0;
            prevTopOffset = 0;
            maxTopGutter = 0;
            maxBottomGutter = 0;
            for(i = 0; i < leftLen; i++)
            {
               if(offset.left == 0)
               {
                  _computedGutters.left = 0;
               }
               else
               {
                  _computedGutters.left = offset.left * (i + 1);
               }
               _computedGutters = _leftRenderers[i].adjustGutters(_computedGutters,adjustable);
               rect = _computedGutters.clone();
               if(rect.top > maxTopGutter)
               {
                  maxTopGutter = rect.top;
               }
               if(rect.bottom > maxBottomGutter)
               {
                  maxBottomGutter = rect.bottom;
               }
               if(offset.left == 0)
               {
                  rect.left += prevLeftOffset;
               }
               if(rect.left > unscaledWidth)
               {
                  rect.left = unscaledWidth;
               }
               _leftRenderers[i].gutters = rect;
               if(offset.left == 0)
               {
                  prevLeftOffset += _computedGutters.left;
               }
            }
            if(prevLeftOffset > unscaledWidth)
            {
               prevLeftOffset = unscaledWidth;
            }
            if(offset.left == 0)
            {
               _computedGutters.left = prevLeftOffset;
            }
            else
            {
               _computedGutters.left = Number(gutterLeft);
            }
            for(i = 0; i < rightLen; i++)
            {
               if(offset.right == 0)
               {
                  _computedGutters.right = 0;
               }
               else
               {
                  _computedGutters.right = offset.right * (i + 1);
               }
               _computedGutters = _rightRenderers[i].adjustGutters(_computedGutters,adjustable);
               rect = _computedGutters.clone();
               if(rect.top > maxTopGutter)
               {
                  maxTopGutter = rect.top;
               }
               if(rect.bottom > maxBottomGutter)
               {
                  maxBottomGutter = rect.bottom;
               }
               if(offset.right == 0)
               {
                  rect.right += prevRightOffset;
               }
               if(rect.right > unscaledWidth)
               {
                  rect.right = unscaledWidth;
               }
               _rightRenderers[i].gutters = rect;
               if(offset.right == 0)
               {
                  prevRightOffset += _computedGutters.right;
               }
            }
            if(prevRightOffset > unscaledWidth)
            {
               prevRightOffset = unscaledWidth;
            }
            if(offset.right == 0)
            {
               _computedGutters.right = prevRightOffset;
            }
            else
            {
               _computedGutters.right = Number(gutterRight);
            }
            other = [];
            if(leftLen > 0)
            {
               other.push(_leftRenderers[leftLen - 1]);
            }
            if(rightLen > 0)
            {
               other.push(_rightRenderers[rightLen - 1]);
            }
            for(i = 0; i < bottomLen; i++)
            {
               if(offset.bottom == 0)
               {
                  _computedGutters.bottom = 0;
               }
               else
               {
                  _computedGutters.bottom = offset.bottom * (i + 1);
               }
               _bottomRenderers[i].otherAxes = other;
               _computedGutters = _bottomRenderers[i].adjustGutters(_computedGutters,adjustable);
               rect = _computedGutters.clone();
               if(offset.bottom == 0)
               {
                  rect.bottom += prevBottomOffset;
               }
               if(rect.bottom > unscaledHeight)
               {
                  rect.bottom = unscaledHeight;
               }
               _bottomRenderers[i].gutters = rect;
               if(offset.bottom == 0)
               {
                  prevBottomOffset += _computedGutters.bottom;
               }
            }
            if(prevBottomOffset > unscaledHeight)
            {
               prevBottomOffset = unscaledHeight;
            }
            for(i = 0; i < topLen; i++)
            {
               if(offset.top == 0)
               {
                  _computedGutters.top = 0;
               }
               else
               {
                  _computedGutters.top = offset.top * (i + 1);
               }
               _topRenderers[i].otherAxes = other;
               _computedGutters = _topRenderers[i].adjustGutters(_computedGutters,adjustable);
               rect = _computedGutters.clone();
               if(offset.top == 0)
               {
                  rect.top += prevTopOffset;
               }
               if(rect.top > unscaledHeight)
               {
                  rect.top = unscaledHeight;
               }
               _topRenderers[i].gutters = rect;
               if(offset.top == 0)
               {
                  prevTopOffset += _computedGutters.top;
               }
            }
            if(prevTopOffset > unscaledHeight)
            {
               prevTopOffset = unscaledHeight;
            }
            if(offset.bottom == 0)
            {
               _computedGutters.bottom = prevBottomOffset;
            }
            else
            {
               _computedGutters.bottom = Number(gutterBottom);
            }
            if(offset.top == 0)
            {
               _computedGutters.top = prevTopOffset;
            }
            else
            {
               _computedGutters.top = Number(gutterTop);
            }
            if(topLen == 0)
            {
               _computedGutters.top += maxTopGutter;
            }
            if(bottomLen == 0)
            {
               _computedGutters.bottom += maxBottomGutter;
            }
            for(i = 0; i < leftLen; i++)
            {
               rect = _leftRenderers[i].gutters;
               rect.top = _computedGutters.top;
               rect.bottom = _computedGutters.bottom;
               _leftRenderers[i].gutters = rect;
            }
            for(i = 0; i < rightLen; i++)
            {
               rect = _rightRenderers[i].gutters;
               rect.top = _computedGutters.top;
               rect.bottom = _computedGutters.bottom;
               _rightRenderers[i].gutters = rect;
            }
         }
         _transformBounds = new Rectangle(_computedGutters.left + paddingLeft,_computedGutters.top + paddingTop,unscaledWidth - _computedGutters.right - paddingRight - (_computedGutters.left + paddingLeft),unscaledHeight - _computedGutters.bottom - paddingBottom - (_computedGutters.top + paddingTop));
         if(Boolean(_transforms))
         {
            for(i = 0; i < _transforms.length; i++)
            {
               _transforms[i].pixelWidth = _transformBounds.width;
               _transforms[i].pixelHeight = _transformBounds.height;
            }
         }
         n = int(allElements.length);
         for(i = 0; i < n; i++)
         {
            c = allElements[i];
            if(c is IUIComponent)
            {
               (c as IUIComponent).setActualSize(_transformBounds.width,_transformBounds.height);
            }
            else
            {
               c.width = _transformBounds.width;
               c.height = _transformBounds.height;
            }
            if(c is Series && Boolean(Series(c).dataTransform))
            {
               CartesianTransform(Series(c).dataTransform).pixelWidth = _transformBounds.width;
               CartesianTransform(Series(c).dataTransform).pixelHeight = _transformBounds.height;
            }
            if(c is IDataCanvas && Boolean((c as Object).dataTransform))
            {
               CartesianTransform((c as Object).dataTransform).pixelWidth = _transformBounds.width;
               CartesianTransform((c as Object).dataTransform).pixelHeight = _transformBounds.height;
            }
         }
         if(Boolean(_seriesHolder.mask))
         {
            _seriesHolder.mask.width = _transformBounds.width;
            _seriesHolder.mask.height = _transformBounds.height;
         }
         if(Boolean(_backgroundElementHolder.mask))
         {
            _backgroundElementHolder.mask.width = _transformBounds.width;
            _backgroundElementHolder.mask.height = _transformBounds.height;
         }
         if(Boolean(_annotationElementHolder.mask))
         {
            _annotationElementHolder.mask.width = _transformBounds.width;
            _annotationElementHolder.mask.height = _transformBounds.height;
         }
         _seriesHolder.x = _transformBounds.left;
         _seriesHolder.y = _transformBounds.top;
         _backgroundElementHolder.move(_transformBounds.left,_transformBounds.top);
         _annotationElementHolder.move(_transformBounds.left,_transformBounds.top);
         _bAxisLayoutDirty = false;
      }
      
      [Inspectable(category="Data")]
      public function get horizontalAxis() : IAxis
      {
         return _horizontalAxis;
      }
      
      [Inspectable(environment="none")]
      public function get computedGutters() : Rectangle
      {
         return _computedGutters;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getRightMostRenderer() : IAxisRenderer
      {
         var n:int = int(_rightRenderers.length);
         if(n > 0)
         {
            return _rightRenderers[n - 1];
         }
         return null;
      }
      
      private function getSeriesObjects(s:Array) : Array
      {
         var arrSeries:Array = [];
         for(var i:int = 0; i < s.length; i++)
         {
            if(s[i] is StackedSeries)
            {
               arrSeries = arrSeries.concat(getSeriesObjects(s[i].series));
            }
            else
            {
               arrSeries.push(s[i]);
            }
         }
         return arrSeries;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         updateAxisLayout(unscaledWidth,unscaledHeight);
         advanceEffectState();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function measureLabels() : Object
      {
         return null;
      }
   }
}

