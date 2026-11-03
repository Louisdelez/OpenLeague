package mx.charts
{
   import flash.filters.DropShadowFilter;
   import mx.charts.chartClasses.CartesianChart;
   import mx.charts.chartClasses.CartesianTransform;
   import mx.charts.chartClasses.DataTip;
   import mx.charts.chartClasses.DataTransform;
   import mx.charts.chartClasses.IChartElement;
   import mx.charts.chartClasses.IStackable;
   import mx.charts.chartClasses.NumericAxis;
   import mx.charts.chartClasses.Series;
   import mx.charts.series.ColumnSeries;
   import mx.charts.series.ColumnSet;
   import mx.charts.series.items.ColumnSeriesItem;
   import mx.charts.styles.HaloDefaults;
   import mx.controls.Label;
   import mx.graphics.SolidColor;
   import mx.graphics.Stroke;
   import mx.styles.CSSStyleDeclaration;
   
   [IconFile("ColumnChart.png")]
   [DefaultTriggerEvent("itemClick")]
   [DefaultBindingProperty(destination="dataProvider")]
   [Style(name="maxColumnWidth",type="Number",format="Length",inherit="no")]
   [Style(name="columnWidthRatio",type="Number",inherit="no")]
   public class ColumnChart extends CartesianChart
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var stylesInited:Boolean = initStyles();
      
      private static var INVALIDATING_STYLES:Object = {
         "columnWidthRatio":1,
         "maxColumnWidth":1
      };
      
      private var _tempField:Label;
      
      private var _perSeriescolumnWidthRatio:Number;
      
      private var _needLabels:Boolean = false;
      
      private var _leftOffset:Number;
      
      private var _showLabelVertically:Boolean = false;
      
      private var _perSeriesMaxColumnWidth:Number;
      
      private var _extendLabelToEnd:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var allLabelsMeasured:Boolean = false;
      
      private var _type:String = "clustered";
      
      private var _maxLabelWidth:int = 50;
      
      private var _allItems:Array = [];
      
      public function ColumnChart()
      {
         super();
         LinearAxis(horizontalAxis).autoAdjust = false;
         dataTipMode = "single";
         seriesFilters = [new DropShadowFilter(2,45,0.2 * 16777215)];
      }
      
      private static function initStyles() : Boolean
      {
         var columnChartStyle:CSSStyleDeclaration;
         HaloDefaults.init();
         columnChartStyle = HaloDefaults.createSelector("ColumnChart");
         columnChartStyle.defaultFactory = function():void
         {
            this.axisColor = 14016221;
            this.chartSeriesStyles = HaloDefaults.chartBaseChartSeriesStyles;
            this.columnWidthRatio = 0.65;
            this.dataTipRenderer = DataTip;
            this.fontSize = 10;
            this.fill = new SolidColor(16777215,0);
            this.calloutStroke = new Stroke(8947848,2);
            this.horizontalAxisStyleName = "blockCategoryAxis";
            this.secondHorizontalAxisStyleName = "blockCategoryAxis";
            this.secondVerticalAxisStyleName = "blockNumericAxis";
            this.textAlign = "left";
            this.verticalAxisStyleName = "blockNumericAxis";
            this.horizontalAxisStyleNames = ["blockCategoryAxis"];
            this.verticalAxisStyleNames = ["blockNumericAxis"];
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
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function measureLabels() : Object
      {
         var v:ColumnSeriesItem = null;
         var columnSeries:ColumnSeries = null;
         var labelPosition:String = null;
         var base:Number = NaN;
         var size:Number = NaN;
         var labelRotation:Number = NaN;
         var labelSizeLimit:Number = NaN;
         var labelScale:Number = NaN;
         var j:int = 0;
         var k:int = 0;
         var r:Number = NaN;
         var tempItem:ColumnSeriesItem = null;
         var prevY:Number = NaN;
         var align:String = null;
         getSeriesLabelPosSet();
         if(!_needLabels)
         {
            return null;
         }
         var len:int = int(series.length);
         var secondSeriesLen:int = int(secondSeries.length);
         var allSeriesTransform:Boolean = true;
         if(type == "stacked" || type == "overlaid" || type == "100%")
         {
            allLabelsMeasured = false;
         }
         _allItems = [];
         for(var i:int = 0; i < len; i++)
         {
            getChartItems(series[i]);
         }
         for(i = 0; i < secondSeriesLen; i++)
         {
            getChartItems(secondSeries[i]);
         }
         _allItems.sort(sortOnX);
         var itemsLen:Number = _allItems.length;
         for(i = 0; i < itemsLen; i++)
         {
            v = _allItems[i];
            columnSeries = ColumnSeries(ColumnSeriesItem(_allItems[i]).element);
            labelPosition = columnSeries.labelPos;
            if(labelPosition == "inside" || labelPosition == "outside")
            {
               base = Number(columnSeries.seriesRenderData.renderedBase);
               size = Number(columnSeries.getStyle("fontSize"));
               if(columnSeries.labelFunction != null)
               {
                  columnSeries.measuringField.text = v.labelText = columnSeries.labelFunction(v,columnSeries);
               }
               else if(columnSeries.labelField != null)
               {
                  columnSeries.measuringField.text = v.labelText = v.item[columnSeries.labelField];
               }
               else if(columnSeries.dataFunction != null)
               {
                  columnSeries.measuringField.text = v.labelText = columnSeries.dataFunction(this,v.item,"yNumber");
               }
               else
               {
                  columnSeries.measuringField.text = v.labelText = v.item[columnSeries.yField];
               }
               columnSeries.measuringField.validateNow();
               labelRotation = columnSeries.labelAngle;
               labelSizeLimit = columnSeries.maxLabelSize;
               if(labelPosition == "outside" && (type == "overlaid" || type == "stacked" || type == "100%"))
               {
                  columnSeries.labelPos = "inside";
                  labelPosition = "inside";
               }
               if(labelPosition == "outside")
               {
                  if(!showLabelVertically)
                  {
                     v.labelIsHorizontal = true;
                     if(extendLabelToEnd)
                     {
                        v.labelWidth = Math.abs((this.dataRegion.right - (v.x + columnSeries.seriesRenderData.renderedXOffset - columnSeries.seriesRenderData.renderedHalfWidth)) / Math.cos(0));
                     }
                     else
                     {
                        v.labelWidth = Math.min(Math.abs((this.dataRegion.right - (v.x + columnSeries.seriesRenderData.renderedXOffset - columnSeries.seriesRenderData.renderedHalfWidth)) / Math.cos(0)),maxLabelWidth);
                     }
                     v.labelHeight = columnSeries.measuringField.textHeight + 2;
                  }
                  else
                  {
                     v.labelIsHorizontal = true;
                     v.labelWidth = 2 * columnSeries.seriesRenderData.renderedHalfWidth;
                     v.labelHeight = columnSeries.measuringField.textHeight + 2;
                     if(columnSeries.measuringField.textWidth + 5 > 2 * columnSeries.seriesRenderData.renderedHalfWidth && Boolean(columnSeries.measuringField.embedFonts))
                     {
                        v.labelIsHorizontal = false;
                        v.labelHeight = 2 * columnSeries.seriesRenderData.renderedHalfWidth;
                        if(!isNaN(labelRotation) && labelRotation != -90)
                        {
                           r = -labelRotation / Math.PI * 180;
                           if(type == "clustered")
                           {
                              if(i < itemsLen - len)
                              {
                                 v.labelWidth = Math.abs((_allItems[i + len - i % len].x + ColumnSeries(_allItems[i + len - i % len].element).seriesRenderData.renderedXOffset - ColumnSeries(_allItems[i + len - i % len].element).seriesRenderData.renderedHalfWidth - (v.x + columnSeries.seriesRenderData.renderedXOffset - columnSeries.seriesRenderData.renderedHalfWidth)) / Math.cos(r));
                              }
                              else
                              {
                                 v.labelWidth = Math.abs((_allItems[itemsLen - 1].x + ColumnSeries(_allItems[itemsLen - 1].element).seriesRenderData.renderedXOffset + ColumnSeries(_allItems[itemsLen - 1].element).seriesRenderData.renderedHalfWidth - (v.x + columnSeries.seriesRenderData.renderedXOffset - columnSeries.seriesRenderData.renderedHalfWidth)) / Math.cos(r));
                              }
                           }
                        }
                        else if(v.y < (isNaN(v.min) ? base : v.min))
                        {
                           v.labelWidth = dataToLocal(0,v.yNumber).y - dataToLocal(0,NumericAxis(columnSeries.dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS)).computedMaximum).y;
                           v.labelY = v.y;
                           if(v.labelY < this.dataRegion.top)
                           {
                              v.labelWidth = Math.abs(v.y - (isNaN(v.min) ? base : v.min));
                              v.labelY = isNaN(v.min) ? base : v.min;
                           }
                        }
                        else
                        {
                           v.labelWidth = dataToLocal(0,NumericAxis(columnSeries.dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS)).computedMinimum).y - dataToLocal(0,v.yNumber).y;
                           v.labelY = v.y + v.labelWidth;
                           if(v.labelY > this.dataRegion.bottom)
                           {
                              v.labelWidth = Math.abs(v.y - (isNaN(v.min) ? base : v.min));
                              v.labelY = v.y;
                           }
                        }
                        v.labelX = v.x - columnSeries.seriesRenderData.renderedHalfWidth + columnSeries.seriesRenderData.renderedXOffset;
                     }
                  }
                  labelScale = 1;
                  if(columnSeries.measuringField.textWidth + 5 > v.labelWidth || columnSeries.measuringField.textHeight > v.labelHeight)
                  {
                     labelScale = v.labelWidth / (columnSeries.measuringField.textWidth + 5);
                     labelScale = Math.min(labelScale,v.labelHeight / columnSeries.measuringField.textHeight);
                     if(size * labelScale > labelSizeLimit)
                     {
                        columnSeries.seriesRenderData.labelScale = Math.min(labelScale,columnSeries.seriesRenderData.labelScale);
                     }
                     else
                     {
                        _tempField.setStyle("fontSize",size);
                        if(_tempField.textWidth > v.labelWidth || columnSeries.measuringField.textHeight > v.labelHeight)
                        {
                           labelScale = v.labelWidth / _tempField.textWidth;
                           labelScale = Math.min(labelScale,v.labelHeight / columnSeries.measuringField.textHeight);
                           if(size * labelScale > labelSizeLimit)
                           {
                              columnSeries.seriesRenderData.labelScale = Math.min(labelScale,columnSeries.seriesRenderData.labelScale);
                           }
                           else
                           {
                              v.labelText = "";
                              v.labelWidth = 1;
                              v.labelHeight = 0;
                           }
                        }
                     }
                  }
                  if(!isNaN(labelRotation) && labelRotation != -90 && Boolean(columnSeries.measuringField.embedFonts))
                  {
                     v.labelHeight = columnSeries.measuringField.textHeight + 2;
                     if(v.y < (isNaN(v.min) ? base : v.min))
                     {
                        v.labelY = v.y - v.labelHeight;
                     }
                     else
                     {
                        v.labelY = v.y + v.labelHeight;
                     }
                  }
                  if(v.labelIsHorizontal)
                  {
                     if(v.y < (isNaN(v.min) ? base : v.min))
                     {
                        v.labelY = v.y - v.labelHeight;
                        if(v.labelY < this.dataRegion.top)
                        {
                           v.labelY = v.y;
                        }
                     }
                     else
                     {
                        v.labelY = v.y;
                        if(v.labelY > this.dataRegion.bottom)
                        {
                           v.labelY = v.y - v.labelHeight;
                        }
                     }
                     v.labelX = v.x - columnSeries.seriesRenderData.renderedHalfWidth + columnSeries.seriesRenderData.renderedXOffset;
                  }
                  v.labelTextWidth = columnSeries.measuringField.textWidth;
                  j = 0;
                  if(!extendLabelToEnd)
                  {
                     for(j = i - 1; j >= 1; )
                     {
                        if(_allItems[j].x < v.x - maxLabelWidth)
                        {
                           break;
                        }
                        j--;
                     }
                     if(j < 0)
                     {
                        j = i;
                     }
                  }
                  for(k = j; k < i; k++)
                  {
                     tempItem = _allItems[k];
                     if(tempItem.labelIsHorizontal)
                     {
                        if(v.labelX + 0.0001 < Math.min(tempItem.labelX + tempItem.labelWidth,tempItem.labelX + tempItem.labelTextWidth))
                        {
                           if(v.labelIsHorizontal)
                           {
                              if(v.labelY + v.labelHeight > tempItem.labelY && v.labelY + v.labelHeight < tempItem.labelY + tempItem.labelHeight || v.labelY > tempItem.labelY && v.labelY < tempItem.labelY + tempItem.labelHeight || v.labelY == tempItem.labelY && tempItem.labelY + tempItem.labelHeight == v.labelY + v.labelHeight && v.labelX > tempItem.labelX && v.labelX < tempItem.labelX + tempItem.labelWidth || v.labelY <= tempItem.labelY && v.labelY + v.labelHeight > tempItem.labelY + tempItem.labelHeight || v.labelY < tempItem.labelY && v.labelY + v.labelHeight >= tempItem.labelY + tempItem.labelHeight)
                              {
                                 if(v.y < (isNaN(v.min) ? base : v.min))
                                 {
                                    v.labelY = tempItem.labelY - v.labelHeight;
                                 }
                                 else
                                 {
                                    v.labelY = tempItem.labelY + tempItem.labelHeight;
                                 }
                              }
                           }
                           else if(v.labelY > tempItem.labelY && v.labelY - v.labelWidth < tempItem.labelY || v.labelY - v.labelWidth >= tempItem.labelY && v.labelY > tempItem.labelY - tempItem.labelHeight)
                           {
                              prevY = v.labelY;
                              if(v.y < (isNaN(v.min) ? base : v.min))
                              {
                                 v.labelY = tempItem.labelY - tempItem.labelHeight;
                                 v.labelWidth -= prevY - v.labelY;
                              }
                              else
                              {
                                 v.labelY = tempItem.labelY + tempItem.labelHeight;
                                 v.labelWidth -= v.labelY - prevY;
                              }
                           }
                        }
                     }
                  }
               }
               else if(labelPosition == "inside")
               {
                  v.labelIsHorizontal = true;
                  v.labelWidth = 2 * columnSeries.seriesRenderData.renderedHalfWidth;
                  v.labelHeight = columnSeries.measuringField.textHeight + 2;
                  if(columnSeries.measuringField.textWidth + 5 > 2 * columnSeries.seriesRenderData.renderedHalfWidth && Boolean(columnSeries.measuringField.embedFonts))
                  {
                     v.labelIsHorizontal = false;
                     v.labelWidth = Math.abs(v.y - (isNaN(v.min) ? base : v.min));
                     v.labelHeight = 2 * columnSeries.seriesRenderData.renderedHalfWidth;
                     if(v.y < (isNaN(v.min) ? base : v.min))
                     {
                        v.labelY = isNaN(v.min) ? base : v.min;
                     }
                     else
                     {
                        v.labelY = v.y;
                     }
                     v.labelX = v.x - v.labelHeight / 2 + columnSeries.seriesRenderData.renderedXOffset;
                  }
                  labelScale = 1;
                  if(columnSeries.measuringField.textWidth + 5 > v.labelWidth || columnSeries.measuringField.textHeight > v.labelHeight)
                  {
                     labelScale = v.labelWidth / (columnSeries.measuringField.textWidth + 5);
                     labelScale = Math.min(labelScale,v.labelHeight / columnSeries.measuringField.textHeight);
                     if(size * labelScale > labelSizeLimit)
                     {
                        columnSeries.seriesRenderData.labelScale = Math.min(labelScale,columnSeries.seriesRenderData.labelScale);
                     }
                     else
                     {
                        _tempField.setStyle("fontSize",size);
                        if(_tempField.textWidth > v.labelWidth || columnSeries.measuringField.textHeight > v.labelHeight)
                        {
                           labelScale = v.labelWidth / _tempField.textWidth;
                           labelScale = Math.min(labelScale,v.labelHeight / columnSeries.measuringField.textHeight);
                           if(size * labelScale > labelSizeLimit)
                           {
                              columnSeries.seriesRenderData.labelScale = Math.min(labelScale,columnSeries.seriesRenderData.labelScale);
                           }
                           else
                           {
                              v.labelText = "";
                              v.labelWidth = 1;
                              v.labelHeight = 0;
                           }
                        }
                     }
                  }
                  if(v.labelIsHorizontal)
                  {
                     align = columnSeries.getStyle("labelAlign");
                     if(align == "top")
                     {
                        if(v.y < (isNaN(v.min) ? base : v.min))
                        {
                           v.labelY = v.y;
                        }
                        else
                        {
                           v.labelY = v.y - v.labelHeight;
                        }
                     }
                     else if(align == "bottom")
                     {
                        if(v.y < (isNaN(v.min) ? base : v.min))
                        {
                           v.labelY = (isNaN(v.min) ? base : v.min) - v.labelHeight;
                        }
                        else
                        {
                           v.labelY = isNaN(v.min) ? base : v.min;
                        }
                     }
                     else if(v.y < (isNaN(v.min) ? base : v.min))
                     {
                        v.labelY = v.y + Math.abs(v.y - (isNaN(v.min) ? base : v.min)) / 2 - v.labelHeight / 2;
                     }
                     else
                     {
                        v.labelY = v.y - Math.abs(v.y - (isNaN(v.min) ? base : v.min)) / 2 + v.labelHeight / 2;
                     }
                     v.labelX = v.x - columnSeries.seriesRenderData.renderedHalfWidth + columnSeries.seriesRenderData.renderedXOffset;
                  }
                  v.labelTextWidth = columnSeries.measuringField.textWidth;
                  j = 0;
                  if(!extendLabelToEnd)
                  {
                     for(j = i - 1; j >= 1; )
                     {
                        if(_allItems[j].x < v.x - maxLabelWidth)
                        {
                           break;
                        }
                        j--;
                     }
                     if(j < 0)
                     {
                        j = i;
                     }
                  }
                  for(k = j; k < i; k++)
                  {
                     tempItem = _allItems[k];
                     if(tempItem.labelIsHorizontal)
                     {
                        if(v.labelX + 0.0001 < Math.min(tempItem.labelX + tempItem.labelWidth,tempItem.labelX + tempItem.labelTextWidth))
                        {
                           if(v.labelIsHorizontal)
                           {
                              if(v.labelY + v.labelHeight > tempItem.labelY && v.labelY + v.labelHeight < tempItem.labelY + tempItem.labelHeight || v.labelY > tempItem.labelY && v.labelY < tempItem.labelY + tempItem.labelHeight || v.labelY == tempItem.labelY && tempItem.labelY + tempItem.labelHeight == v.labelY + v.labelHeight && v.labelX > tempItem.labelX && v.labelX < tempItem.labelX + tempItem.labelWidth || v.labelY <= tempItem.labelY && v.labelY + v.labelHeight > tempItem.labelY + tempItem.labelHeight || v.labelY < tempItem.labelY && v.labelY + v.labelHeight >= tempItem.labelY + tempItem.labelHeight)
                              {
                                 if(v.y < (isNaN(v.min) ? base : v.min))
                                 {
                                    v.labelY = tempItem.labelY - v.labelHeight;
                                 }
                                 else
                                 {
                                    v.labelY = tempItem.labelY + tempItem.labelHeight;
                                 }
                              }
                              else if(v.labelY < tempItem.labelY && v.labelY + v.labelHeight > tempItem.labelY || v.labelY > tempItem.labelY && v.labelY < tempItem.labelY + tempItem.labelHeight || v.labelY == tempItem.labelY)
                              {
                                 if(v.yNumber >= tempItem.yNumber)
                                 {
                                    tempItem.labelText = "";
                                    tempItem.labelWidth = 1;
                                 }
                                 else
                                 {
                                    v.labelText = "";
                                    v.labelWidth = 1;
                                 }
                              }
                           }
                           else if(v.labelY > tempItem.labelY && v.labelY - Math.min(v.labelWidth,v.labelTextWidth) < tempItem.labelY || v.labelY - v.labelWidth >= tempItem.labelY && v.labelY > tempItem.labelY - tempItem.labelHeight)
                           {
                              prevY = v.labelY;
                              if(v.y < (isNaN(v.min) ? base : v.min))
                              {
                                 v.labelY = tempItem.labelY - tempItem.labelHeight;
                                 v.labelWidth -= prevY - v.labelY;
                              }
                              else
                              {
                                 v.labelY = tempItem.labelY + tempItem.labelHeight;
                                 v.labelWidth -= v.labelY - prevY;
                              }
                           }
                        }
                     }
                     else if(v.labelX == tempItem.labelX)
                     {
                        if(v.labelY <= tempItem.labelY && v.labelY > tempItem.labelY - Math.min(tempItem.labelWidth,tempItem.labelTextWidth) + 0.0001 || v.labelY >= tempItem.labelY && v.labelY - Math.min(v.labelWidth,v.labelTextWidth) + 0.0001 < tempItem.labelY)
                        {
                           if(v.yNumber < tempItem.yNumber)
                           {
                              v.labelText = "";
                              v.labelWidth = 1;
                           }
                           else
                           {
                              tempItem.labelText = "";
                              tempItem.labelWidth = 1;
                           }
                        }
                     }
                  }
               }
            }
            else
            {
               columnSeries.seriesRenderData.labelData = null;
               columnSeries.labelCache.count = 0;
            }
         }
         allLabelsMeasured = true;
         for(i = 0; i < len; i++)
         {
            invalidateDisplay(series[i]);
         }
         for(i = 0; i < secondSeriesLen; i++)
         {
            invalidateDisplay(secondSeries[i]);
         }
         return null;
      }
      
      [Inspectable(category="General")]
      public function get extendLabelToEnd() : Boolean
      {
         return _extendLabelToEnd;
      }
      
      public function set extendLabelToEnd(value:Boolean) : void
      {
         _extendLabelToEnd = value;
         measureLabels();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getSeriesLabelPos(series:Series) : void
      {
         var columnSeries:ColumnSeries = null;
         var position:String = null;
         var setSeries:Array = null;
         var i:int = 0;
         if(series is ColumnSeries)
         {
            columnSeries = ColumnSeries(series);
            position = columnSeries.labelPos;
            if(position == "inside" || position == "outside" || position == "none")
            {
               _needLabels = true;
            }
         }
         else if(series is ColumnSet)
         {
            setSeries = ColumnSet(series).series;
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
         if(!secondVerticalAxis)
         {
            secondVerticalAxis = new LinearAxis();
         }
         if(!secondVerticalAxisRenderer)
         {
            secondVerticalAxisRenderer = new AxisRenderer();
         }
      }
      
      [Inspectable(category="General")]
      public function get showLabelVertically() : Boolean
      {
         return _showLabelVertically;
      }
      
      override protected function applySeriesSet(seriesSet:Array, transform:DataTransform) : Array
      {
         var g:IChartElement = null;
         var n:int = 0;
         var i:int = 0;
         var newSeriesGlyph:ColumnSet = null;
         var columnWidthRatio:Number = Number(getStyle("columnWidthRatio"));
         var maxColumnWidth:Number = Number(getStyle("maxColumnWidth"));
         switch(_type)
         {
            case "stacked":
            case "100%":
               n = int(seriesSet.length);
               for(i = 0; i < n; i++)
               {
                  seriesSet[i].offset = 0;
               }
               newSeriesGlyph = new ColumnSet();
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
               if(!isNaN(columnWidthRatio))
               {
                  newSeriesGlyph.columnWidthRatio = columnWidthRatio;
               }
               if(!isNaN(maxColumnWidth))
               {
                  newSeriesGlyph.maxColumnWidth = maxColumnWidth;
               }
               newSeriesGlyph.type = _type;
               invalidateData();
               return [newSeriesGlyph];
            case "clustered":
               break;
            case "overlaid":
               _perSeriescolumnWidthRatio = columnWidthRatio;
               _perSeriesMaxColumnWidth = maxColumnWidth;
               _leftOffset = 0;
               return super.applySeriesSet(seriesSet,transform);
         }
         _perSeriescolumnWidthRatio = columnWidthRatio / seriesSet.length;
         _perSeriesMaxColumnWidth = maxColumnWidth / seriesSet.length;
         _leftOffset = (1 - columnWidthRatio) / 2 + _perSeriescolumnWidthRatio / 2 - 0.5;
         return super.applySeriesSet(seriesSet,transform);
      }
      
      private function invalidateDisplay(series:Series) : void
      {
         var setSeries:Array = null;
         var i:int = 0;
         if(series is ColumnSeries)
         {
            ColumnSeries(series).updateLabels();
         }
         else if(series is ColumnSet)
         {
            setSeries = ColumnSet(series).series;
            for(i = 0; i < setSeries.length; i++)
            {
               invalidateDisplay(setSeries[i]);
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
      
      override protected function customizeSeries(seriesGlyph:Series, i:uint) : void
      {
         var series:Object = null;
         var stackSeries:IStackable = null;
         if(seriesGlyph is ColumnSeries || seriesGlyph is ColumnSet)
         {
            series = seriesGlyph;
            if(!isNaN(_perSeriescolumnWidthRatio))
            {
               series.columnWidthRatio = _perSeriescolumnWidthRatio;
            }
            if(!isNaN(_perSeriesMaxColumnWidth))
            {
               series.maxColumnWidth = _perSeriesMaxColumnWidth;
            }
            if(_type == "overlaid")
            {
               series.offset = 0;
            }
            else
            {
               series.offset = _leftOffset + i * _perSeriescolumnWidthRatio;
            }
            if(series is IStackable)
            {
               stackSeries = IStackable(series);
               stackSeries.stacker = null;
               stackSeries.stackTotals = null;
            }
         }
      }
      
      private function sortOnX(a:ColumnSeriesItem, b:ColumnSeriesItem) : int
      {
         var offset1:Number = Number(ColumnSeries(a.element).seriesRenderData.renderedXOffset);
         var offset2:Number = Number(ColumnSeries(b.element).seriesRenderData.renderedXOffset);
         if(a.x + offset1 > b.x + offset2)
         {
            return 1;
         }
         if(a.x + offset1 < b.x + offset2)
         {
            return -1;
         }
         if(a.yNumber > b.yNumber)
         {
            return 1;
         }
         if(a.yNumber < b.yNumber)
         {
            return -1;
         }
         return 0;
      }
      
      public function set maxLabelWidth(value:int) : void
      {
         _maxLabelWidth = value;
         measureLabels();
      }
      
      public function set showLabelVertically(value:Boolean) : void
      {
         _showLabelVertically = value;
         measureLabels();
      }
      
      private function getChartItems(series:Series) : void
      {
         var columnSeries:ColumnSeries = null;
         var seriesItems:Array = null;
         var seriesLen:int = 0;
         var j:int = 0;
         var setSeries:Array = null;
         if(series is ColumnSeries)
         {
            columnSeries = ColumnSeries(series);
            seriesItems = columnSeries.seriesRenderData.filteredCache;
            seriesLen = int(seriesItems.length);
            columnSeries.labelCache.count = seriesLen;
            columnSeries.seriesRenderData.labelData = columnSeries.labelContainer;
            columnSeries.seriesRenderData.labelScale = 1;
            for(j = 0; j < seriesLen; j++)
            {
               _allItems.push(ColumnSeriesItem(seriesItems[j]));
            }
         }
         else if(series is ColumnSet)
         {
            setSeries = ColumnSet(series).series;
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
      
      public function set type(value:String) : void
      {
         if(_type == value)
         {
            return;
         }
         _type = value;
         invalidateSeries();
         invalidateData();
      }
      
      [Inspectable(category="General")]
      public function get maxLabelWidth() : int
      {
         return _maxLabelWidth;
      }
   }
}

