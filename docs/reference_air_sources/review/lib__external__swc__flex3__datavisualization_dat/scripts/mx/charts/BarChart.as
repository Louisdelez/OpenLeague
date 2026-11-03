package mx.charts
{
   import flash.filters.DropShadowFilter;
   import mx.charts.chartClasses.CartesianChart;
   import mx.charts.chartClasses.CartesianTransform;
   import mx.charts.chartClasses.DataTip;
   import mx.charts.chartClasses.DataTransform;
   import mx.charts.chartClasses.IChartElement;
   import mx.charts.chartClasses.NumericAxis;
   import mx.charts.chartClasses.Series;
   import mx.charts.series.BarSeries;
   import mx.charts.series.BarSet;
   import mx.charts.series.items.BarSeriesItem;
   import mx.charts.styles.HaloDefaults;
   import mx.controls.Label;
   import mx.graphics.SolidColor;
   import mx.graphics.Stroke;
   import mx.styles.CSSStyleDeclaration;
   
   [IconFile("BarChart.png")]
   [DefaultTriggerEvent("itemClick")]
   [DefaultBindingProperty(destination="dataProvider")]
   [Style(name="maxBarWidth",type="Number",format="Length",inherit="no")]
   [Style(name="barWidthRatio",type="Number",inherit="no")]
   public class BarChart extends CartesianChart
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var stylesInited:Boolean = initStyles();
      
      private static var INVALIDATING_STYLES:Object = {
         "barWidthRatio":1,
         "maxBarWidth":1
      };
      
      private var _perSeriesMaxBarWidth:Number;
      
      private var _tempField:Label;
      
      private var _rightOffset:Number;
      
      private var _type:String = "clustered";
      
      private var _wasStacked:Boolean = false;
      
      private var _perSeriesBarWidthRatio:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var allLabelsMeasured:Boolean = false;
      
      private var _barSeriesLen:Number;
      
      private var _needLabels:Boolean = false;
      
      private var _allItems:Array = [];
      
      public function BarChart()
      {
         super();
         LinearAxis(verticalAxis).autoAdjust = false;
         dataTipMode = "single";
         seriesFilters = [new DropShadowFilter(2,45,0.2 * 16777215)];
      }
      
      private static function initStyles() : Boolean
      {
         var barChartStyle:CSSStyleDeclaration;
         HaloDefaults.init();
         barChartStyle = HaloDefaults.createSelector("BarChart");
         barChartStyle.defaultFactory = function():void
         {
            this.axisColor = 14016221;
            this.barWidthRatio = 0.65;
            this.chartSeriesStyles = HaloDefaults.chartBaseChartSeriesStyles;
            this.dataTipRenderer = DataTip;
            this.fill = new SolidColor(16777215,0);
            this.calloutStroke = new Stroke(8947848,2);
            this.fontSize = 10;
            this.gridLinesStyleName = "horizontalGridLines";
            this.horizontalAxisStyleName = "blockNumericAxis";
            this.secondHorizontalAxisStyleName = "blockNumericAxis";
            this.secondVerticalAxisStyleName = "blockCategoryAxis";
            this.textAlign = "left";
            this.verticalAxisStyleName = "blockCategoryAxis";
            this.horizontalAxisStyleNames = ["blockNumericAxis"];
            this.verticalAxisStyleNames = ["blockCategoryAxis"];
         };
         return true;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         if(styleProp == null || INVALIDATING_STYLES[styleProp] != undefined)
         {
            invalidateSeries();
         }
         super.styleChanged(styleProp);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getSeriesLabelPos(series:Series) : void
      {
         var barSeries:BarSeries = null;
         var position:String = null;
         var setSeries:Array = null;
         var i:int = 0;
         if(series is BarSeries)
         {
            barSeries = BarSeries(series);
            position = barSeries.labelPos;
            if(position == "inside" || position == "outside" || position == "none")
            {
               _needLabels = true;
            }
         }
         else if(series is BarSet)
         {
            setSeries = BarSet(series).series;
            for(i = 0; i < setSeries.length; i++)
            {
               getSeriesLabelPos(setSeries[i]);
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getSeriesLabelPosSet() : void
      {
         var len:int = int(series.length);
         _needLabels = false;
         for(var i:int = 0; i < len; i++)
         {
            if(_needLabels)
            {
               return;
            }
            getSeriesLabelPos(series[i]);
         }
         len = int(secondSeries.length);
         for(i = 0; i < len; i++)
         {
            if(_needLabels)
            {
               return;
            }
            getSeriesLabelPos(secondSeries[i]);
         }
      }
      
      override protected function initSecondaryMode() : void
      {
         super.initSecondaryMode();
         if(!secondHorizontalAxis)
         {
            secondHorizontalAxis = new LinearAxis();
         }
         if(!secondHorizontalAxisRenderer)
         {
            secondHorizontalAxisRenderer = new AxisRenderer();
         }
      }
      
      override protected function customizeSeries(seriesGlyph:Series, i:uint) : void
      {
         var series:Object = null;
         if(seriesGlyph is BarSeries || seriesGlyph is BarSet)
         {
            series = seriesGlyph;
            if(!isNaN(_perSeriesBarWidthRatio))
            {
               series.barWidthRatio = _perSeriesBarWidthRatio;
            }
            if(!isNaN(_perSeriesMaxBarWidth))
            {
               series.maxBarWidth = _perSeriesMaxBarWidth;
            }
            if(_type == "overlaid")
            {
               series.offset = 0;
            }
            else
            {
               series.offset = _rightOffset - i * _perSeriesBarWidthRatio;
            }
            if(series is BarSeries)
            {
               series.stacker = null;
               series.stackTotals = null;
            }
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         _tempField = new Label();
         _tempField.visible = false;
         _tempField.text = "W...";
         _tempField.toolTip = "";
         addChild(_tempField);
         _tempField.validateNow();
      }
      
      private function sortOnY(a:BarSeriesItem, b:BarSeriesItem) : int
      {
         var offset1:Number = Number(BarSeries(a.element).seriesRenderData.renderedYOffset);
         var offset2:Number = Number(BarSeries(b.element).seriesRenderData.renderedYOffset);
         if(a.y + offset1 > b.y + offset2)
         {
            return 1;
         }
         if(a.y + offset1 < b.y + offset2)
         {
            return -1;
         }
         if(a.xNumber > b.xNumber)
         {
            return 1;
         }
         if(a.xNumber < b.xNumber)
         {
            return -1;
         }
         return 0;
      }
      
      private function invalidateDisplay(series:Series) : void
      {
         var setSeries:Array = null;
         var i:int = 0;
         if(series is BarSeries)
         {
            BarSeries(series).updateLabels();
         }
         else if(series is BarSet)
         {
            setSeries = BarSet(series).series;
            for(i = 0; i < setSeries.length; i++)
            {
               invalidateDisplay(setSeries[i]);
            }
         }
      }
      
      override protected function applySeriesSet(seriesSet:Array, transform:DataTransform) : Array
      {
         var g:IChartElement = null;
         var i:int = 0;
         var newSeriesGlyph:BarSet = null;
         var barWidthRatio:Number = Number(getStyle("barWidthRatio"));
         var maxBarWidth:Number = Number(getStyle("maxBarWidth"));
         switch(_type)
         {
            case "stacked":
            case "100%":
               _wasStacked = true;
               for(i = 0; i < seriesSet.length; i++)
               {
                  seriesSet[i].offset = 0;
               }
               newSeriesGlyph = new BarSet();
               newSeriesGlyph.series = seriesSet;
               for(i = 0; i < seriesSet.length; i++)
               {
                  g = seriesSet[i] as IChartElement;
                  if(g)
                  {
                     if(Boolean(g.labelContainer))
                     {
                        newSeriesGlyph.labelContainer.addChild(seriesSet[i].labelContainer);
                     }
                  }
               }
               if(!isNaN(barWidthRatio))
               {
                  newSeriesGlyph.barWidthRatio = barWidthRatio;
               }
               if(!isNaN(maxBarWidth))
               {
                  newSeriesGlyph.maxBarWidth = maxBarWidth;
               }
               newSeriesGlyph.type = _type;
               invalidateData();
               return [newSeriesGlyph];
            case "clustered":
               break;
            case "overlaid":
               _perSeriesBarWidthRatio = barWidthRatio;
               _perSeriesMaxBarWidth = maxBarWidth;
               _rightOffset = 0;
               super.applySeriesSet(seriesSet,transform);
               return seriesSet;
         }
         _perSeriesBarWidthRatio = barWidthRatio / seriesSet.length;
         _perSeriesMaxBarWidth = maxBarWidth / seriesSet.length;
         _rightOffset = barWidthRatio / 2 - _perSeriesBarWidthRatio / 2;
         return super.applySeriesSet(seriesSet,transform);
      }
      
      public function set type(value:String) : void
      {
         _type = value;
         invalidateSeries();
         invalidateData();
      }
      
      private function getChartItems(series:Series) : void
      {
         var barSeries:BarSeries = null;
         var seriesItems:Array = null;
         var seriesLen:int = 0;
         var j:int = 0;
         var setSeries:Array = null;
         if(series is BarSeries)
         {
            _barSeriesLen += 1;
            barSeries = BarSeries(series);
            seriesItems = barSeries.seriesRenderData.filteredCache;
            seriesLen = int(seriesItems.length);
            barSeries.labelCache.count = seriesLen;
            barSeries.seriesRenderData.labelScale = 1;
            for(j = 0; j < seriesLen; j++)
            {
               _allItems.push(BarSeriesItem(seriesItems[j]));
            }
         }
         else if(series is BarSet)
         {
            setSeries = BarSet(series).series;
            for(j = 0; j < setSeries.length; j++)
            {
               getChartItems(setSeries[j]);
            }
         }
      }
      
      [Inspectable(category="General",enumeration="stacked,100%,clustered,overlaid",defaultValue="clustered")]
      public function get type() : String
      {
         return _type;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function measureLabels() : Object
      {
         var v:BarSeriesItem = null;
         var barSeries:BarSeries = null;
         var labelPosition:String = null;
         var base:Number = NaN;
         var size:Number = NaN;
         var labelRotation:Number = NaN;
         var labelSizeLimit:Number = NaN;
         var labelScale:Number = NaN;
         var r:Number = NaN;
         var prevItemsCount:int = 0;
         var j:int = 0;
         var tempItem:BarSeriesItem = null;
         getSeriesLabelPosSet();
         if(!_needLabels)
         {
            return null;
         }
         var len:int = int(series.length);
         var allSeriesTransform:Boolean = true;
         if(type == "stacked" || type == "overlaid" || type == "100%")
         {
            allLabelsMeasured = false;
         }
         _allItems = [];
         _barSeriesLen = 0;
         for(var i:int = 0; i < len; i++)
         {
            getChartItems(series[i]);
         }
         _allItems.sort(sortOnY);
         var itemsLen:Number = _allItems.length;
         for(i = itemsLen - 1; i >= 0; i--)
         {
            v = _allItems[i];
            barSeries = BarSeries(BarSeriesItem(_allItems[i]).element);
            labelPosition = barSeries.labelPos;
            if(labelPosition == "inside" || labelPosition == "outside")
            {
               base = Number(barSeries.seriesRenderData.renderedBase);
               size = Number(barSeries.getStyle("fontSize"));
               if(barSeries.labelFunction != null)
               {
                  barSeries.measuringField.text = v.labelText = barSeries.labelFunction(v,barSeries);
               }
               else if(barSeries.labelField != null)
               {
                  barSeries.measuringField.text = v.labelText = v.item[barSeries.labelField];
               }
               else if(barSeries.dataFunction != null)
               {
                  barSeries.measuringField.text = v.labelText = barSeries.dataFunction(this,v.item,"xNumber");
               }
               else
               {
                  barSeries.measuringField.text = v.labelText = v.item[barSeries.xField];
               }
               barSeries.measuringField.validateNow();
               labelRotation = barSeries.labelAngle;
               labelSizeLimit = barSeries.maxLabelSize;
               if(labelPosition == "outside" && (type == "stacked" || type == "overlaid" || type == "100%"))
               {
                  labelPosition = "inside";
                  barSeries.labelPos = "inside";
               }
               if(labelPosition == "outside")
               {
                  v.labelHeight = 2 * barSeries.seriesRenderData.renderedHalfWidth;
                  if(!isNaN(labelRotation) && labelRotation != 0 && Boolean(barSeries.measuringField.embedFonts))
                  {
                     r = -labelRotation / Math.PI * 180;
                     if(type == "clustered")
                     {
                        if(i > len - 1)
                        {
                           v.labelWidth = Math.abs((_allItems[i - i % len - 1].y + BarSeries(_allItems[i - i % len - 1].element).seriesRenderData.renderedYOffset + BarSeries(_allItems[i - i % len - 1].element).seriesRenderData.renderedHalfWidth - (v.y + barSeries.seriesRenderData.renderedYOffset - barSeries.seriesRenderData.renderedHalfWidth)) / Math.cos(r));
                        }
                        else
                        {
                           v.labelWidth = Math.abs((_allItems[0].y + BarSeries(_allItems[0].element).seriesRenderData.renderedYOffset - BarSeries(_allItems[0].element).seriesRenderData.renderedHalfWidth - (v.y + barSeries.seriesRenderData.renderedYOffset - barSeries.seriesRenderData.renderedHalfWidth)) / Math.cos(r));
                        }
                     }
                     else if(i > len - 1)
                     {
                        v.labelWidth = Math.abs((_allItems[i - len].y + BarSeries(_allItems[i - len].element).seriesRenderData.renderedYOffset + BarSeries(_allItems[i - len].element).seriesRenderData.renderedHalfWidth - (v.y + barSeries.seriesRenderData.renderedYOffset - barSeries.seriesRenderData.renderedHalfWidth)) / Math.cos(r));
                     }
                     else
                     {
                        v.labelWidth = Math.abs((_allItems[0].y + BarSeries(_allItems[0].element).seriesRenderData.renderedYOffset - BarSeries(_allItems[0].element).seriesRenderData.renderedHalfWidth - (v.y + barSeries.seriesRenderData.renderedYOffset - barSeries.seriesRenderData.renderedHalfWidth)) / Math.cos(r));
                     }
                     v.labelY = v.y + barSeries.seriesRenderData.renderedYOffset + barSeries.seriesRenderData.renderedHalfWidth;
                  }
                  else
                  {
                     if(v.x > (isNaN(v.min) ? base : v.min))
                     {
                        v.labelWidth = dataToLocal(NumericAxis(barSeries.dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS)).computedMaximum,0).x - dataToLocal(v.xNumber,0).x;
                        v.labelX = v.x;
                        if(v.labelWidth == 0)
                        {
                           v.labelWidth = Math.abs(v.x - (isNaN(v.min) ? base : v.min));
                           v.labelX = isNaN(v.min) ? base : v.min;
                        }
                     }
                     else
                     {
                        v.labelWidth = dataToLocal(v.xNumber,0).x - dataToLocal(NumericAxis(barSeries.dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS)).computedMinimum,0).x;
                        v.labelX = v.x - v.labelWidth;
                        if(v.labelWidth == 0)
                        {
                           v.labelWidth = Math.abs(v.x - (isNaN(v.min) ? base : v.min));
                           v.labelX = v.x;
                        }
                     }
                     v.labelY = v.y + barSeries.seriesRenderData.renderedYOffset - barSeries.seriesRenderData.renderedHalfWidth;
                  }
                  labelScale = 1;
                  if(barSeries.measuringField.textWidth > v.labelWidth || barSeries.measuringField.textHeight > v.labelHeight)
                  {
                     labelScale = v.labelWidth / barSeries.measuringField.textWidth;
                     labelScale = Math.min(labelScale,v.labelHeight / barSeries.measuringField.textHeight);
                     if(size * labelScale > labelSizeLimit)
                     {
                        barSeries.seriesRenderData.labelScale = Math.min(labelScale,barSeries.seriesRenderData.labelScale);
                     }
                     else
                     {
                        _tempField.setStyle("fontSize",size);
                        if(_tempField.textWidth > v.labelWidth || _tempField.textHeight > v.labelHeight)
                        {
                           labelScale = v.labelWidth / _tempField.textWidth;
                           labelScale = Math.min(labelScale,v.labelHeight / _tempField.textHeight);
                           if(size * labelScale > labelSizeLimit)
                           {
                              barSeries.seriesRenderData.labelScale = Math.min(labelScale,barSeries.seriesRenderData.labelScale);
                           }
                           else
                           {
                              v.labelText = "";
                              v.labelWidth = 1;
                           }
                        }
                     }
                  }
                  if(!isNaN(labelRotation) && labelRotation != 0 && Boolean(barSeries.measuringField.embedFonts))
                  {
                     v.labelHeight = barSeries.measuringField.textHeight + 2;
                     if(v.x > (isNaN(v.min) ? base : v.min))
                     {
                        v.labelX = v.x + v.labelHeight;
                     }
                     else
                     {
                        v.labelX = v.x - 2 * v.labelHeight;
                     }
                     v.labelY -= v.labelHeight;
                     v.labelWidth -= v.labelHeight;
                  }
               }
               else if(labelPosition == "inside")
               {
                  v.labelWidth = Math.abs(v.x - (isNaN(v.min) ? base : v.min));
                  v.labelHeight = 2 * barSeries.seriesRenderData.renderedHalfWidth;
                  v.labelY = v.y + barSeries.seriesRenderData.renderedYOffset - barSeries.seriesRenderData.renderedHalfWidth;
                  if(v.x > (isNaN(v.min) ? base : v.min))
                  {
                     v.labelX = isNaN(v.min) ? base : v.min;
                  }
                  else
                  {
                     v.labelX = v.x;
                  }
                  labelScale = 1;
                  if(barSeries.measuringField.textWidth > v.labelWidth || barSeries.measuringField.textHeight > v.labelHeight)
                  {
                     labelScale = v.labelWidth / barSeries.measuringField.textWidth;
                     labelScale = Math.min(labelScale,v.labelHeight / barSeries.measuringField.textHeight);
                     if(size * labelScale > labelSizeLimit)
                     {
                        barSeries.seriesRenderData.labelScale = Math.min(labelScale,barSeries.seriesRenderData.labelScale);
                     }
                     else
                     {
                        _tempField.setStyle("fontSize",size);
                        if(_tempField.textWidth > v.labelWidth || _tempField.textHeight + 2 > v.labelHeight)
                        {
                           labelScale = v.labelWidth / _tempField.textWidth;
                           labelScale = Math.min(labelScale,v.labelHeight / _tempField.textHeight);
                           if(size * labelScale > labelSizeLimit)
                           {
                              barSeries.seriesRenderData.labelScale = Math.min(labelScale,barSeries.seriesRenderData.labelScale);
                           }
                           else
                           {
                              v.labelText = "";
                              v.labelWidth = 1;
                           }
                        }
                     }
                  }
                  prevItemsCount = _barSeriesLen - 1 - i % _barSeriesLen;
                  for(j = 1; j <= prevItemsCount; j++)
                  {
                     tempItem = _allItems[i + j];
                     if(v.labelY == tempItem.labelY)
                     {
                        if(v.labelX >= tempItem.labelX && v.labelX < tempItem.labelX + tempItem.labelWidth || v.labelX <= tempItem.labelX && v.labelX + v.labelWidth > tempItem.labelX)
                        {
                           v.labelText = "";
                           v.labelWidth = 1;
                        }
                     }
                  }
               }
            }
            else
            {
               barSeries.seriesRenderData.labelData = null;
               barSeries.labelCache.count = 0;
            }
         }
         allLabelsMeasured = true;
         for(i = 0; i < len; i++)
         {
            invalidateDisplay(series[i]);
         }
         return null;
      }
   }
}

