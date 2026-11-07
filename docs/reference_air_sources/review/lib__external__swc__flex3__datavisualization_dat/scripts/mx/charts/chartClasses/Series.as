package mx.charts.chartClasses
{
   import flash.geom.Rectangle;
   import mx.charts.ChartItem;
   import mx.charts.effects.effectClasses.SeriesEffectInstance;
   import mx.effects.Effect;
   import mx.effects.EffectManager;
   import mx.effects.IEffectInstance;
   import mx.events.DragEvent;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   
   [Effect(name="showDataEffect",event="showData")]
   [Effect(name="hideDataEffect",event="hideData")]
   public class Series extends ChartElement
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _selectionIndicesDirty:Boolean = false;
      
      private var _bHideTransitionDirty:Boolean = false;
      
      private var _selectionIndicesDirtyArray:Array = [];
      
      private var _interactive:Boolean = true;
      
      private var _bMappingDirty:Boolean = true;
      
      private var _bFilterDirty:Boolean = true;
      
      private var _604694401_dataFunction:Function;
      
      private var _transitionRenderData:Object;
      
      private var _bTransformDirty:Boolean = true;
      
      private var _selectionDirtyArray:Array = [];
      
      private var _previousTransitionData:Object;
      
      private var _bDataDirty:Boolean = true;
      
      private var _displayName:String;
      
      private var _selectionDirty:Boolean = false;
      
      private var _1502335886_dataTipItems:Array;
      
      protected var allSeriesTransform:Boolean = true;
      
      private var _selectedItems:Array = [];
      
      private var _filterData:Boolean = true;
      
      private var _selectable:Boolean = true;
      
      public function Series()
      {
         super();
         super.showInAutomationHierarchy = false;
         this.addEventListener(DragEvent.DRAG_START,dragStartHandler);
      }
      
      public function interpolate(interpolationValues:Array, interpolationData:Object) : void
      {
         applyInterpolation(interpolationData,interpolationValues);
      }
      
      private function set _dataFunction(value:Function) : void
      {
         var oldValue:Object = this._604694401_dataFunction;
         if(oldValue !== value)
         {
            this._604694401_dataFunction = value;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_dataFunction",oldValue,value));
         }
      }
      
      override public function mappingChanged() : void
      {
         invalidateMapping();
      }
      
      protected function stripNaNs(cache:Array, field:String) : void
      {
         var i:int = 0;
         if(filterData == false)
         {
            return;
         }
         var len:int = int(cache.length);
         var start:int = -1;
         var end:int = -1;
         if(field == "")
         {
            for(i = cache.length - 1; i >= 0; i--)
            {
               if(isNaN(cache[i]))
               {
                  if(start < 0)
                  {
                     start = end = i;
                  }
                  else if(end - 1 == i)
                  {
                     end = i;
                  }
                  else
                  {
                     cache.splice(end,start - end + 1);
                     start = end = i;
                  }
               }
            }
         }
         else
         {
            for(i = cache.length - 1; i >= 0; i--)
            {
               if(isNaN(cache[i][field]))
               {
                  if(start < 0)
                  {
                     start = end = i;
                  }
                  else if(end - 1 == i)
                  {
                     end = i;
                  }
                  else
                  {
                     cache.splice(end,start - end + 1);
                     start = end = i;
                  }
               }
            }
         }
         if(start >= 0)
         {
            cache.splice(end,start - end + 1);
         }
      }
      
      protected function invalidateMapping(invalid:Boolean = true) : void
      {
         if(invalid)
         {
            _bDataDirty = true;
            _bMappingDirty = true;
            _bFilterDirty = true;
            _bTransformDirty = true;
            invalidateTransitions();
            invalidateDisplayList();
         }
         else
         {
            _bMappingDirty = true;
         }
      }
      
      private function validateSelection() : void
      {
         if(_selectionIndicesDirty)
         {
            _selectionIndicesDirty = false;
            selectedIndices = _selectionIndicesDirtyArray;
            _selectionIndicesDirtyArray = [];
         }
         else if(_selectionDirty == true)
         {
            _selectionDirty = false;
            if(Boolean(chart))
            {
               chart.updateKeyboardCache();
            }
         }
      }
      
      public function getAxis(dimension:String) : IAxis
      {
         return dataTransform.getAxis(dimension);
      }
      
      public function getElementBounds(renderData:Object) : void
      {
      }
      
      private function set _dataTipItems(value:Array) : void
      {
         var oldValue:Object = this._1502335886_dataTipItems;
         if(oldValue !== value)
         {
            this._1502335886_dataTipItems = value;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_dataTipItems",oldValue,value));
         }
      }
      
      public function set selectedIndices(value:Array) : void
      {
         var item:ChartItem = null;
         var i:int = 0;
         if(_selectedItems.length == 0 && value.length == 0)
         {
            return;
         }
         if(Boolean(items))
         {
            item = null;
            _selectionDirtyArray = [];
            for(i = 0; i < value.length; i++)
            {
               item = getChartItemFor(value[i]);
               if(Boolean(item))
               {
                  _selectionDirtyArray.push(item);
               }
            }
            _selectionDirty = true;
            invalidateProperties();
         }
         else
         {
            _selectionIndicesDirty = true;
            _selectionIndicesDirtyArray = value;
            invalidateProperties();
         }
      }
      
      protected function updateData() : void
      {
         _bDataDirty = false;
      }
      
      public function set transitionRenderData(value:Object) : void
      {
         _transitionRenderData = value;
      }
      
      public function setAxis(dimension:String, value:IAxis) : void
      {
         dataTransform.setAxis(dimension,value);
      }
      
      override public function collectTransitions(chartState:Number, transitions:Array) : void
      {
         var instance:IEffectInstance = null;
         var transition:Effect = null;
         if(chartState == ChartState.PREPARING_TO_HIDE_DATA)
         {
            transition = EffectManager.createEffectForType(this,"hideData") as Effect;
            if(Boolean(transition))
            {
               instance = transition.createInstance(this);
               if(instance is SeriesEffectInstance)
               {
                  (instance as SeriesEffectInstance).type = "hide";
               }
            }
         }
         else if(chartState == ChartState.PREPARING_TO_SHOW_DATA)
         {
            validateProperties();
            transition = EffectManager.createEffectForType(this,"showData") as Effect;
            if(Boolean(transition))
            {
               instance = transition.createInstance(this);
               if(instance is SeriesEffectInstance)
               {
                  (instance as SeriesEffectInstance).type = "show";
               }
            }
         }
         if(Boolean(instance))
         {
            transitions.push(instance);
         }
         super.collectTransitions(chartState,transitions);
      }
      
      override public function claimStyles(styles:Array, firstAvailable:uint) : uint
      {
         internalStyleName = styles[firstAvailable];
         return (firstAvailable + 1) % styles.length;
      }
      
      public function set dataFunction(value:Function) : void
      {
         _dataFunction = value;
         dataChanged();
      }
      
      public function getRenderDataForTransition(type:String) : Object
      {
         if(type == "hide")
         {
            return _previousTransitionData;
         }
         validateData();
         validateTransform();
         return renderData;
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get filterData() : Boolean
      {
         return _filterData;
      }
      
      [Inspectable(category="General")]
      public function get selectedItem() : ChartItem
      {
         var len:int = 0;
         len = int(_selectedItems.length);
         if(len > 0)
         {
            return _selectedItems[len - 1];
         }
         return null;
      }
      
      [Inspectable(category="General")]
      public function get selectable() : Boolean
      {
         return _selectable;
      }
      
      protected function legendDataChanged() : void
      {
         var c:ChartBase = chart;
         if(Boolean(c))
         {
            c.legendDataChanged();
         }
      }
      
      [Inspectable(environment="none")]
      public function get legendData() : Array
      {
         return null;
      }
      
      protected function get renderData() : Object
      {
         return null;
      }
      
      protected function cacheDefaultValues(measureName:String, cache:Array, fieldName:String) : Boolean
      {
         var i:int = 0;
         var c:Object = null;
         var n:int = int(cache.length);
         if(_dataFunction != null)
         {
            for(i = 0; i < n; i++)
            {
               c = cache[i];
               c[fieldName] = dataFunction(this,c.item,fieldName);
            }
            return true;
         }
         if(measureName == "" || measureName == null)
         {
            for(i = 0; i < n; i++)
            {
               c = cache[i];
               c[fieldName] = c.item;
            }
            return false;
         }
         for(i = 0; i < n; i++)
         {
            c = cache[i];
            if(c.item != null)
            {
               c[fieldName] = c.item[measureName];
            }
         }
         return true;
      }
      
      public function set dataTipItems(value:Array) : void
      {
         _dataTipItems = value;
         invalidateProperties();
      }
      
      [Inspectable(category="Display")]
      public function get displayName() : String
      {
         return _displayName;
      }
      
      private function getChartItemFor(value:int) : ChartItem
      {
         var items:Array = null;
         var item:ChartItem = null;
         items = Boolean(renderData) ? renderData.filteredCache : [];
         for(var i:int = 0; i < items.length; i++)
         {
            if(items[i].index == value)
            {
               item = items[i];
               break;
            }
         }
         return item;
      }
      
      protected function invalidateTransform(invalid:Boolean = true) : void
      {
         if(invalid)
         {
            _bTransformDirty = true;
            invalidateDisplayList();
         }
         else
         {
            _bTransformDirty = false;
         }
      }
      
      private function transformChangeHandler(event:FlexEvent) : void
      {
         invalidateTransform();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getTransformState() : Boolean
      {
         return _bTransformDirty;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addItemtoSelection(item:ChartItem) : void
      {
         _selectedItems.push(item);
         item.currentState = ChartItem.SELECTED;
      }
      
      [Bindable(event="propertyChange")]
      private function get _dataFunction() : Function
      {
         return this._604694401_dataFunction;
      }
      
      public function beginInterpolation(sourceRenderData:Object, destRenderData:Object) : Object
      {
         return null;
      }
      
      protected function invalidateTransitions() : void
      {
         var s:ChartBase = null;
         if(_bHideTransitionDirty == false)
         {
            _previousTransitionData = renderData;
            s = chart;
            if(Boolean(s))
            {
               s.hideData();
            }
            _bHideTransitionDirty = true;
         }
      }
      
      public function set filterData(value:Boolean) : void
      {
         _filterData = value;
         invalidateFilter();
      }
      
      protected function invalidateData(invalid:Boolean = true) : void
      {
         if(invalid)
         {
            _bDataDirty = true;
            _bMappingDirty = true;
            _bFilterDirty = true;
            _bTransformDirty = true;
            invalidateTransitions();
            invalidateDisplayList();
         }
         else
         {
            _bDataDirty = false;
         }
      }
      
      [Inspectable(category="General")]
      public function get selectedIndices() : Array
      {
         var arrItems:Array = [];
         for(var i:int = 0; i < _selectedItems.length; i++)
         {
            arrItems.push(_selectedItems[i].index);
         }
         return arrItems;
      }
      
      [Bindable(event="propertyChange")]
      private function get _dataTipItems() : Array
      {
         return this._1502335886_dataTipItems;
      }
      
      override public function stylesInitialized() : void
      {
         legendDataChanged();
      }
      
      protected function extractMinMax(cache:Array, measureName:String, desc:DataDescription, calculateInterval:Boolean = false) : void
      {
         var i:int = 0;
         var v:Number = NaN;
         var prevValidValue:Number = NaN;
         var n:int = int(cache.length);
         var minInterval:Number = Number.POSITIVE_INFINITY;
         if(isNaN(desc.min))
         {
            for(i = 0; i < n; i++)
            {
               v = Number(cache[i][measureName]);
               if(isNaN(v) == false)
               {
                  break;
               }
            }
            if(isNaN(v))
            {
               return;
            }
            desc.min = desc.max = v;
            prevValidValue = v;
         }
         for(i++; i < n; i++)
         {
            v = Number(cache[i][measureName]);
            if(!isNaN(v))
            {
               if(v < desc.min)
               {
                  desc.min = v;
               }
               if(v > desc.max)
               {
                  desc.max = v;
               }
               if(calculateInterval && v - prevValidValue < minInterval)
               {
                  minInterval = Math.abs(v - prevValidValue);
               }
               prevValidValue = v;
            }
         }
         if(calculateInterval && minInterval < Number.POSITIVE_INFINITY && (minInterval < desc.minInterval || isNaN(desc.minInterval)))
         {
            desc.minInterval = minInterval;
         }
      }
      
      protected function getMissingInterpolationValues(sourceProps:Object, srcCache:Array, destProps:Object, destCache:Array, index:Number, customData:Object) : void
      {
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function emptySelectedItems() : void
      {
         _selectedItems = [];
      }
      
      protected function invalidateFilter(invalid:Boolean = true) : void
      {
         if(invalid)
         {
            _bFilterDirty = true;
            _bTransformDirty = true;
            invalidateTransitions();
            invalidateDisplayList();
         }
         else
         {
            _bFilterDirty = false;
         }
      }
      
      public function get transitionRenderData() : Object
      {
         return _transitionRenderData;
      }
      
      protected function updateFilter() : void
      {
         _bFilterDirty = false;
      }
      
      [Inspectable(category="General")]
      public function get dataFunction() : Function
      {
         return _dataFunction;
      }
      
      public function set selectedItem(value:ChartItem) : void
      {
         if(_selectedItems.length == 1 && _selectedItems[0] == value)
         {
            return;
         }
         _selectionDirtyArray = [];
         _selectionDirtyArray.push(value);
         _selectionDirty = true;
         invalidateProperties();
      }
      
      public function getItemsInRegion(r:Rectangle) : Array
      {
         return [];
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeItemfromSelection(item:ChartItem, state:String = "disabled") : void
      {
         var index:int = 0;
         index = _selectedItems.indexOf(item);
         _selectedItems.splice(index,1);
         item.currentState = state;
      }
      
      public function set selectable(value:Boolean) : void
      {
         if(_selectable != value)
         {
            _selectable = value;
            invalidateProperties();
         }
      }
      
      [Inspectable(category="General")]
      public function get dataTipItems() : Array
      {
         return _dataTipItems;
      }
      
      protected function cacheIndexValues(measureName:String, cache:Array, fieldName:String) : Boolean
      {
         var i:int = 0;
         var c:Object = null;
         var n:int = int(cache.length);
         if(_dataFunction != null)
         {
            for(i = 0; i < n; i++)
            {
               c = cache[i];
               c[fieldName] = dataFunction(this,c.item,fieldName);
            }
            return true;
         }
         if(measureName == "")
         {
            for(i = 0; i < n; i++)
            {
               c = cache[i];
               c[fieldName] = c.index;
            }
            return false;
         }
         for(i = 0; i < n; i++)
         {
            c = cache[i];
            if(c.item != null)
            {
               c[fieldName] = c.item[measureName];
            }
         }
         return true;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setItemsState(state:String) : void
      {
         var items:Array = null;
         var i:int = 0;
         items = Boolean(renderData) ? renderData.filteredCache : [];
         if(Boolean(items))
         {
            for(i = 0; i < items.length; i++)
            {
               items[i].currentState = state;
            }
         }
      }
      
      public function endInterpolation(interpolationData:Object) : void
      {
         transitionRenderData = null;
      }
      
      override public function setActualSize(w:Number, h:Number) : void
      {
         invalidateTransform();
         super.setActualSize(w,h);
      }
      
      override protected function dataChanged() : void
      {
         invalidateData();
         super.dataChanged();
      }
      
      protected function updateTransform() : void
      {
         _bTransformDirty = false;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getChartSelectedStatus() : Boolean
      {
         if(Boolean(chart))
         {
            return chart.selectedChartItems.length > 0;
         }
         return false;
      }
      
      protected function initializeInterpolationData(srcCache:Array, dstCache:Array, iProps:Object, cacheType:Class = null, customData:Object = null) : Object
      {
         var src:ChartItem = null;
         var dst:ChartItem = null;
         var iobj:ChartItem = null;
         var iSrc:ChartItem = null;
         var delta:ChartItem = null;
         var populated:Boolean = false;
         var missingSrcValues:Object = null;
         var missingDestValues:Object = null;
         var bNeedMissingValues:Boolean = false;
         var aProp:String = null;
         var srcValue:Number = NaN;
         var dstValue:Number = NaN;
         var interpolationCache:Array = [];
         var deltaCache:Array = [];
         var n:int = Math.max(srcCache.length,dstCache.length);
         var interpolationSource:Array = [];
         if(!cacheType)
         {
            cacheType = Object;
         }
         for(var i:int = 0; i < n; i++)
         {
            src = srcCache[i];
            dst = dstCache[i];
            iobj = dst == null ? src.clone() : dst.clone();
            iSrc = src == null ? dst.clone() : src.clone();
            delta = new cacheType();
            populated = false;
            missingSrcValues = {};
            missingDestValues = {};
            bNeedMissingValues = false;
            for(aProp in iProps)
            {
               if(Boolean(src))
               {
                  srcValue = Number(src[aProp]);
               }
               else
               {
                  srcValue = NaN;
               }
               if(Boolean(dst))
               {
                  dstValue = Number(dst[aProp]);
               }
               else
               {
                  dstValue = NaN;
               }
               if(isNaN(srcValue) || isNaN(dstValue))
               {
                  bNeedMissingValues = true;
                  missingSrcValues[aProp] = srcValue;
                  missingDestValues[aProp] = dstValue;
               }
               else
               {
                  iSrc[aProp] = srcValue;
                  iobj[aProp] = srcValue;
                  delta[aProp] = dstValue - srcValue;
               }
            }
            if(bNeedMissingValues)
            {
               getMissingInterpolationValues(missingSrcValues,srcCache,missingDestValues,dstCache,i,customData);
               for(aProp in missingSrcValues)
               {
                  srcValue = Number(missingSrcValues[aProp]);
                  iSrc[aProp] = srcValue;
                  iobj[aProp] = srcValue;
                  delta[aProp] = missingDestValues[aProp] - srcValue;
               }
            }
            interpolationSource[i] = iSrc;
            interpolationCache[i] = iobj;
            deltaCache[i] = delta;
         }
         return {
            "cache":interpolationCache,
            "interpolationSource":interpolationSource,
            "deltaCache":deltaCache,
            "properties":iProps
         };
      }
      
      public function get items() : Array
      {
         return [];
      }
      
      override public function set dataTransform(value:DataTransform) : void
      {
         var axis:String = null;
         if(Boolean(dataTransform))
         {
            dataTransform.removeEventListener(FlexEvent.TRANSFORM_CHANGE,transformChangeHandler);
         }
         if(Boolean(value))
         {
            super.dataTransform = value;
            value.addEventListener(FlexEvent.TRANSFORM_CHANGE,transformChangeHandler,false,0,true);
         }
         else
         {
            for(axis in dataTransform.axes)
            {
               dataTransform.getAxis(axis).unregisterDataTransform(dataTransform);
            }
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(Boolean(_dataTipItems) && Boolean(chart))
         {
            chart.dataTipItemsSet = true;
            invalidateDisplayList();
         }
         if(_selectionDirty)
         {
            _selectionDirty = false;
            if(_selectable && Boolean(chart))
            {
               chart.seriesSelectionChanged(this,_selectionDirtyArray);
            }
         }
      }
      
      public function set selectedItems(value:Array) : void
      {
         if(_selectedItems.length == 0 && value.length == 0)
         {
            return;
         }
         _selectionDirtyArray = value;
         _selectionDirty = true;
         invalidateProperties();
      }
      
      private function applyInterpolation(interpolationData:Object, interpolationValues:Array) : void
      {
         var interpValue:Number = NaN;
         var src:Object = null;
         var delta:Object = null;
         var interp:Object = null;
         var aProp:String = null;
         var n:int = int(interpolationValues.length);
         var srcCache:Array = interpolationData.interpolationSource;
         var deltaCache:Array = interpolationData.deltaCache;
         var interpolationCache:Array = interpolationData.cache;
         var iProps:Object = interpolationData.properties;
         n = int(interpolationCache.length);
         for(var i:int = 0; i < n; i++)
         {
            interpValue = Number(interpolationValues[i]);
            src = srcCache[i];
            delta = deltaCache[i];
            interp = interpolationCache[i];
            for(aProp in iProps)
            {
               interp[aProp] = src[aProp] + delta[aProp] * interpValue;
            }
         }
      }
      
      protected function cacheNamedValues(measureName:String, cache:Array, fieldName:String) : Boolean
      {
         var c:Object = null;
         var i:int = 0;
         var n:int = int(cache.length);
         if(_dataFunction != null)
         {
            for(i = 0; i < n; i++)
            {
               c = cache[i];
               c[fieldName] = dataFunction(this,c.item,fieldName);
            }
            return true;
         }
         if(measureName == "")
         {
            return false;
         }
         for(i = 0; i < n; i++)
         {
            c = cache[i];
            if(c.item != null)
            {
               c[fieldName] = c.item[measureName];
            }
         }
         return true;
      }
      
      public function set displayName(value:String) : void
      {
         _displayName = value;
         var c:ChartBase = chart;
         if(Boolean(c))
         {
            c.legendDataChanged();
         }
      }
      
      protected function updateMapping() : void
      {
         _bMappingDirty = false;
      }
      
      protected function validateData() : void
      {
         if(Boolean(dataTransform))
         {
            if(_bDataDirty)
            {
               _selectionDirty = true;
               updateData();
            }
            if(_bMappingDirty)
            {
               _selectionDirty = true;
               updateMapping();
            }
         }
      }
      
      override public function chartStateChanged(oldState:uint, v:uint) : void
      {
         invalidateDisplayList();
         if(v == ChartState.PREPARING_TO_SHOW_DATA || v == ChartState.NONE)
         {
            transitionRenderData = null;
         }
         super.chartStateChanged(oldState,v);
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get interactive() : Boolean
      {
         return _interactive;
      }
      
      override public function invalidateSize() : void
      {
         invalidateTransform();
         super.invalidateSize();
      }
      
      [Inspectable(category="General")]
      public function get selectedItems() : Array
      {
         return _selectedItems;
      }
      
      public function set interactive(value:Boolean) : void
      {
         _interactive = value;
         invalidateDisplayList();
      }
      
      private function dragStartHandler(event:DragEvent) : void
      {
         if(Boolean(chart))
         {
            chart.dragStartHandler(event);
         }
      }
      
      public function set selectedIndex(value:int) : void
      {
         var item:ChartItem = null;
         if(_selectedItems.length == 1 && _selectedItems[0].index == value)
         {
            return;
         }
         if(Boolean(items))
         {
            item = null;
            item = getChartItemFor(value);
            if(!item)
            {
               return;
            }
            _selectionDirtyArray = [];
            _selectionDirtyArray.push(item);
            _selectionDirty = true;
            invalidateProperties();
         }
         else
         {
            _selectionIndicesDirty = true;
            _selectionIndicesDirtyArray.push(value);
            invalidateProperties();
         }
      }
      
      protected function extractMinInterval(cache:Array, measureName:String, desc:DataDescription) : void
      {
         var i:int = 0;
         var v:Number = NaN;
         var prevValidValue:Number = NaN;
         var n:int = int(cache.length);
         var minInterval:Number = Number.POSITIVE_INFINITY;
         for(i = 0; i < n; i++)
         {
            v = Number(cache[i][measureName]);
            if(isNaN(v) == false)
            {
               break;
            }
         }
         if(isNaN(v))
         {
            return;
         }
         prevValidValue = v;
         for(i++; i < n; i++)
         {
            v = Number(cache[i][measureName]);
            if(!isNaN(v))
            {
               if(v - prevValidValue < minInterval)
               {
                  minInterval = Math.abs(v - prevValidValue);
               }
               prevValidValue = v;
            }
         }
         if(minInterval < Number.POSITIVE_INFINITY && (minInterval < desc.minInterval || isNaN(desc.minInterval)))
         {
            desc.minInterval = minInterval;
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var cs:uint = 0;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(_bHideTransitionDirty)
         {
            _bHideTransitionDirty = false;
         }
         var s:ChartBase = chart;
         if(Boolean(s))
         {
            cs = s.chartState;
         }
         validateData();
         validateTransform();
         validateSelection();
      }
      
      override public function set showInAutomationHierarchy(value:Boolean) : void
      {
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function clearSeriesItemsState(clear:Boolean, state:String = "none") : void
      {
         if(clear)
         {
            _selectedItems = [];
         }
         setItemsState(state);
      }
      
      protected function validateTransform() : void
      {
         if(Boolean(dataTransform))
         {
            if(_bFilterDirty)
            {
               _selectionDirty = true;
               updateFilter();
            }
            if(_bTransformDirty)
            {
               _selectionDirty = true;
               updateTransform();
            }
         }
      }
      
      [Inspectable(category="General")]
      public function get selectedIndex() : int
      {
         var len:int = 0;
         len = int(_selectedItems.length);
         if(len > 0)
         {
            return _selectedItems[len - 1].index;
         }
         return -1;
      }
   }
}

