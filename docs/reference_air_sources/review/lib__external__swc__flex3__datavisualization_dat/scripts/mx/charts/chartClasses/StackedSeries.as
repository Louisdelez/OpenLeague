package mx.charts.chartClasses
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import mx.charts.HitData;
   import mx.core.IUIComponent;
   
   public class StackedSeries extends Series
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _horizontalAxis:IAxis;
      
      protected var posTotalsByPrimaryAxis:Dictionary;
      
      private var _bAxesDirty:Boolean = false;
      
      private var _verticalAxis:IAxis;
      
      private var stackingDirty:Boolean = true;
      
      private var _type:String;
      
      private var _series:Array = [];
      
      protected var negTotalsByPrimaryAxis:Dictionary;
      
      private var _seriesDirty:Boolean = true;
      
      private var _allowNeg:Boolean = false;
      
      protected var stackedMinimum:Number;
      
      protected var stackedMaximum:Number;
      
      public function StackedSeries()
      {
         super();
         dataTransform = new CartesianTransform();
         invalidateProperties();
      }
      
      override public function mappingChanged() : void
      {
         var c:IChartElement = null;
         var n:int = int(numChildren);
         for(var i:int = 0; i < n; i++)
         {
            c = getChildAt(i) as IChartElement;
            if(Boolean(c))
            {
               c.mappingChanged();
            }
         }
         super.mappingChanged();
      }
      
      override protected function processNewDataProvider(value:Object) : void
      {
         super.processNewDataProvider(value);
         var n:int = int(_series.length);
         for(var i:int = 0; i < n; i++)
         {
            IChartElement(_series[i]).chartDataProvider = dataProvider;
         }
      }
      
      public function stack() : void
      {
         var i:int = 0;
         var series:IStackable2 = null;
         var obj:Object = null;
         var cachedDataDescriptions:Array = null;
         var n:int = int(_series.length);
         posTotalsByPrimaryAxis = new Dictionary(false);
         negTotalsByPrimaryAxis = new Dictionary(false);
         stackedMaximum = 0;
         var previousSeries:IStackable2 = null;
         for(i = 0; i < n; i++)
         {
            series = _series[i];
            if(_type == "stacked" && _allowNeg)
            {
               obj = series.stackAll(posTotalsByPrimaryAxis,negTotalsByPrimaryAxis,previousSeries);
               stackedMaximum = Math.max(stackedMaximum,obj.maxValue);
               stackedMinimum = isNaN(stackedMinimum) ? Number(obj.minValue) : Math.min(stackedMinimum,obj.minValue);
            }
            else
            {
               stackedMaximum = Math.max(stackedMaximum,series.stack(posTotalsByPrimaryAxis,previousSeries));
               if(_type == "100%")
               {
                  stackedMinimum = 0;
               }
               else
               {
                  cachedDataDescriptions = Series(series).describeData(CartesianTransform.VERTICAL_AXIS,DataDescription.REQUIRED_MIN_MAX | DataDescription.REQUIRED_BOUNDED_VALUES);
                  if(Boolean(cachedDataDescriptions.length))
                  {
                     stackedMinimum = isNaN(stackedMinimum) ? Number(cachedDataDescriptions[0].min) : Math.min(stackedMinimum,cachedDataDescriptions[0].min);
                  }
               }
            }
            previousSeries = series;
         }
         var totals:Dictionary = _type == "100%" ? posTotalsByPrimaryAxis : null;
         for(i = 0; i < n; i++)
         {
            series = _series[i];
            series.stackTotals = totals;
         }
      }
      
      override public function localToData(v:Point) : Array
      {
         return dataTransform.invertTransform(v.x - this.x,v.y - this.y);
      }
      
      override public function describeData(dimension:String, requiredFields:uint) : Array
      {
         var desc:DataDescription = null;
         var n:int = 0;
         var i:int = 0;
         var vCache:Array = null;
         updateStacking();
         validateData();
         var result:Array = [];
         if(type == "100%")
         {
            if(dimension == CartesianTransform.VERTICAL_AXIS)
            {
               desc = new DataDescription();
               desc.min = 0;
               desc.max = 100;
               result = [desc];
            }
            else
            {
               n = int(series.length);
               for(i = 0; i < n; i++)
               {
                  result = result.concat(series[i].describeData(dimension,requiredFields));
               }
            }
         }
         else if(type == "stacked")
         {
            if(dimension == CartesianTransform.VERTICAL_AXIS)
            {
               vCache = [{"value":stackedMinimum},{"value":stackedMaximum}];
               dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).mapCache(vCache,"value","number");
               desc = new DataDescription();
               desc.min = vCache[0].number;
               desc.max = vCache[1].number;
               result = [desc];
            }
            else
            {
               n = int(series.length);
               for(i = 0; i < n; i++)
               {
                  result = result.concat(series[i].describeData(dimension,requiredFields));
               }
            }
         }
         else
         {
            n = int(series.length);
            for(i = 0; i < n; i++)
            {
               result = result.concat(series[i].describeData(dimension,requiredFields));
            }
         }
         return result;
      }
      
      protected function invalidateSeries() : void
      {
         if(_seriesDirty == false)
         {
            _seriesDirty = true;
            invalidateProperties();
         }
      }
      
      override public function getItemsInRegion(r:Rectangle) : Array
      {
         var j:int = 0;
         var arrItems:Array = null;
         var s:Series = null;
         var arrAllItems:Array = [];
         for(j = 0; j < series.length; j++)
         {
            s = series[j];
            arrItems = s.getItemsInRegion(r);
            arrAllItems = arrAllItems.concat(arrItems);
         }
         return arrAllItems;
      }
      
      protected function customizeSeries(g:IChartElement, i:uint) : void
      {
         g.chartDataProvider = dataProvider;
      }
      
      protected function buildSubSeries() : void
      {
         var g:IChartElement = null;
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
         for(var i:int = _series.length - 1; i >= 0; i--)
         {
            g = IChartElement(_series[i]);
            customizeSeries(g,i);
            addChild(g as DisplayObject);
         }
         var s:ChartBase = chart;
         if(Boolean(s))
         {
            s.invalidateSeriesStyles();
         }
      }
      
      override public function dataToLocal(... dataValues) : Point
      {
         var data:Object = {};
         var da:Array = [data];
         var n:int = int(dataValues.length);
         if(n > 0)
         {
            data["d0"] = dataValues[0];
            dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).mapCache(da,"d0","v0");
         }
         if(n > 1)
         {
            data["d1"] = dataValues[1];
            dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).mapCache(da,"d1","v1");
         }
         dataTransform.transformCache(da,"v0","s0","v1","s1");
         return new Point(data.s0 + this.x,data.s1 + this.y);
      }
      
      public function invalidateStacking() : void
      {
         if(stackingDirty == false)
         {
            stackingDirty = true;
            invalidateProperties();
         }
      }
      
      [Inspectable(category="Data")]
      public function get verticalAxis() : IAxis
      {
         return _verticalAxis;
      }
      
      [Inspectable]
      public function get type() : String
      {
         return _type;
      }
      
      protected function formatDataTip(hitData:HitData) : String
      {
         return "";
      }
      
      override public function claimStyles(styles:Array, firstAvailable:uint) : uint
      {
         var c:IChartElement = null;
         var n:int = int(_series.length);
         for(var i:int = 0; i < n; i++)
         {
            c = _series[i];
            firstAvailable = c.claimStyles(styles,firstAvailable);
         }
         return firstAvailable;
      }
      
      public function set allowNegativeForStacked(value:Boolean) : void
      {
         invalidateStacking();
         invalidateSeries();
         _allowNeg = value;
      }
      
      protected function updateStacking() : void
      {
         if(stackingDirty == false)
         {
            return;
         }
         var stacker:StackedSeries = null;
         if(!_series)
         {
            return;
         }
         if(_type == "stacked" || _type == "100%")
         {
            stacker = this;
         }
         var n:int = int(_series.length);
         for(var i:int = 0; i < n; i++)
         {
            if(_series[i] is IStackable)
            {
               _series[i].stacker = stacker;
            }
         }
         if(_type == "stacked" || _type == "100%")
         {
            stack();
         }
         stackingDirty = false;
      }
      
      override public function findDataPoints(x:Number, y:Number, sensitivity:Number) : Array
      {
         var i:int = 0;
         var hds:Array = super.findDataPoints(x,y,sensitivity);
         var n:int = int(hds.length);
         if(n > 0 && (_type == "stacked" || _type == "100%"))
         {
            for(i = 0; i < n; i++)
            {
               hds[i].dataTipFunction = formatDataTip;
            }
         }
         return hds;
      }
      
      public function set horizontalAxis(value:IAxis) : void
      {
         _horizontalAxis = value;
         _bAxesDirty = true;
         invalidateData();
         invalidateProperties();
      }
      
      override protected function commitProperties() : void
      {
         var c:CartesianChart = null;
         super.commitProperties();
         updateStacking();
         if(_seriesDirty)
         {
            _seriesDirty = false;
            buildSubSeries();
         }
         if(_bAxesDirty)
         {
            if(Boolean(dataTransform))
            {
               if(Boolean(_horizontalAxis))
               {
                  _horizontalAxis.chartDataProvider = dataProvider;
                  CartesianTransform(dataTransform).setAxis(CartesianTransform.HORIZONTAL_AXIS,_horizontalAxis);
               }
               if(Boolean(_verticalAxis))
               {
                  _verticalAxis.chartDataProvider = dataProvider;
                  CartesianTransform(dataTransform).setAxis(CartesianTransform.VERTICAL_AXIS,_verticalAxis);
               }
            }
            _bAxesDirty = false;
         }
         var parentChart:Object = chart;
         if(Boolean(parentChart) && parentChart is CartesianChart)
         {
            c = CartesianChart(parentChart);
            if(!_horizontalAxis)
            {
               if(c.secondSeries.indexOf(this) != -1 && Boolean(c.secondHorizontalAxis))
               {
                  if(dataTransform.axes[CartesianTransform.HORIZONTAL_AXIS] != c.secondHorizontalAxis)
                  {
                     CartesianTransform(dataTransform).setAxis(CartesianTransform.HORIZONTAL_AXIS,c.secondHorizontalAxis);
                  }
               }
               else if(dataTransform.axes[CartesianTransform.HORIZONTAL_AXIS] != c.horizontalAxis)
               {
                  CartesianTransform(dataTransform).setAxis(CartesianTransform.HORIZONTAL_AXIS,c.horizontalAxis);
               }
            }
            if(!_verticalAxis)
            {
               if(c.secondSeries.indexOf(this) != -1 && Boolean(c.secondVerticalAxis))
               {
                  if(dataTransform.axes[CartesianTransform.VERTICAL_AXIS] != c.secondVerticalAxis)
                  {
                     CartesianTransform(dataTransform).setAxis(CartesianTransform.VERTICAL_AXIS,c.secondVerticalAxis);
                  }
               }
               else if(dataTransform.axes[CartesianTransform.VERTICAL_AXIS] != c.verticalAxis)
               {
                  CartesianTransform(dataTransform).setAxis(CartesianTransform.VERTICAL_AXIS,c.verticalAxis);
               }
            }
         }
         dataTransform.elements = [this];
      }
      
      override public function get legendData() : Array
      {
         var ld:Object = null;
         var keyItems:Array = [];
         var n:int = int(_series.length);
         for(var i:int = 0; i < n; i++)
         {
            ld = _series[i].legendData;
            if(Boolean(ld))
            {
               keyItems = keyItems.concat(ld);
            }
         }
         return keyItems;
      }
      
      [Inspectable]
      public function get allowNegativeForStacked() : Boolean
      {
         return _allowNeg;
      }
      
      [Inspectable(category="Data")]
      public function get horizontalAxis() : IAxis
      {
         return _horizontalAxis;
      }
      
      override public function chartStateChanged(oldState:uint, v:uint) : void
      {
         updateData();
         super.chartStateChanged(oldState,v);
      }
      
      public function set verticalAxis(value:IAxis) : void
      {
         _verticalAxis = value;
         _bAxesDirty = true;
         invalidateData();
         invalidateProperties();
      }
      
      public function set type(value:String) : void
      {
         invalidateStacking();
         invalidateSeries();
         _type = value;
      }
      
      public function set series(value:Array) : void
      {
         _series = value == null ? [] : value;
         invalidateSeries();
         var s:ChartBase = chart;
         if(Boolean(s))
         {
            s.invalidateSeriesStyles();
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var n:int = int(numChildren);
         for(var i:int = 0; i < n; i++)
         {
            IUIComponent(getChildAt(i)).setActualSize(unscaledWidth,unscaledHeight);
         }
      }
      
      override public function getAllDataPoints() : Array
      {
         var i:int = 0;
         var hds:Array = super.getAllDataPoints();
         var n:int = int(hds.length);
         if(n > 0 && (_type == "stacked" || _type == "100%"))
         {
            for(i = 0; i < n; i++)
            {
               hds[i].dataTipFunction = formatDataTip;
            }
         }
         return hds;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function clearSeriesItemsState(clear:Boolean, state:String = "none") : void
      {
         var s:Series = null;
         var j:int = 0;
         super.clearSeriesItemsState(clear,state);
         for(j = 0; j < series.length; j++)
         {
            s = series[j];
            s.clearSeriesItemsState(clear,state);
         }
      }
      
      [Inspectable]
      public function get series() : Array
      {
         return _series;
      }
   }
}

