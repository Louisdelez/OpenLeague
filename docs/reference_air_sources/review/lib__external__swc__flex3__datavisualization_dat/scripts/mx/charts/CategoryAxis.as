package mx.charts
{
   import flash.events.Event;
   import mx.charts.chartClasses.AxisBase;
   import mx.charts.chartClasses.AxisLabelSet;
   import mx.charts.chartClasses.IAxis;
   import mx.collections.ArrayCollection;
   import mx.collections.CursorBookmark;
   import mx.collections.ICollectionView;
   import mx.collections.IViewCursor;
   import mx.collections.XMLListCollection;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.PropertyChangeEvent;
   
   public class CategoryAxis extends AxisBase implements IAxis
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _userDataProvider:Object;
      
      private var _dataProvider:ICollectionView;
      
      private var _categoryField:String = "";
      
      private var _labelSet:AxisLabelSet;
      
      private var _cachedTicks:Array = null;
      
      private var _catMap:Object;
      
      private var _chartDataProvider:Object;
      
      private var _padding:Number = 0.5;
      
      private var _labelsMatchToCategoryValuesByIndex:Array;
      
      private var _categoryValues:Array;
      
      private var _cachedMinorTicks:Array = null;
      
      private var _604694401_dataFunction:Function = null;
      
      private var _labelFunction:Function = null;
      
      private var _ticksBetweenLabels:Boolean = true;
      
      private var _cursor:IViewCursor;
      
      public function CategoryAxis()
      {
         super();
         workingDataProvider = new ArrayCollection();
      }
      
      private function generateTicks() : Array
      {
         var n:int = 0;
         var min:Number = NaN;
         var max:Number = NaN;
         var alen:Number = NaN;
         var i:Number = NaN;
         var start:Number = NaN;
         var end:Number = NaN;
         if(!_cachedTicks)
         {
            _cachedTicks = [];
            if(_ticksBetweenLabels == false)
            {
               n = int(_categoryValues.length);
               min = -_padding;
               max = n - 1 + _padding;
               alen = max - min;
               for(i = 0; i < n; i++)
               {
                  _cachedTicks.push((i - min) / alen);
               }
            }
            else
            {
               _cachedMinorTicks = [];
               n = int(_categoryValues.length);
               min = -_padding;
               max = n - 1 + _padding;
               alen = max - min;
               start = _padding < 0.5 ? 0.5 : -0.5;
               end = _padding < 0.5 ? n - 1.5 : n - 0.5;
               for(i = start; i <= end; i += 1)
               {
                  _cachedTicks.push((i - min) / alen);
               }
            }
         }
         return _cachedTicks;
      }
      
      public function filterCache(cache:Array, field:String, filteredField:String) : void
      {
         var v:Number = NaN;
         update();
         var computedMaximum:Number = _categoryValues.length - 1 + _padding + 0.000001;
         var computedMinimum:Number = -_padding - 0.000001;
         var n:int = int(cache.length);
         for(var i:int = 0; i < n; i++)
         {
            v = Number(cache[i][field]);
            cache[i][filteredField] = v >= computedMinimum && v < computedMaximum ? v : NaN;
         }
      }
      
      private function collectionChangeHandler(event:CollectionEvent = null) : void
      {
         if(Boolean(event) && event.kind == CollectionEventKind.RESET)
         {
            _cursor = _dataProvider.createCursor();
         }
         invalidateCategories();
      }
      
      [Bindable(event="propertyChange")]
      private function get _dataFunction() : Function
      {
         return this._604694401_dataFunction;
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
      
      public function mapCache(cache:Array, field:String, convertedField:String, indexValues:Boolean = false) : void
      {
         var v:Object = null;
         update();
         var n:int = int(cache.length);
         for(var i:int = 0; i < n; i++)
         {
            if(cache[i][field] != null)
            {
               break;
            }
         }
         if(i == n)
         {
            return;
         }
         var value:Object = cache[i][field];
         if(value is XML || value is XMLList)
         {
            while(i < n)
            {
               cache[i][convertedField] = _catMap[cache[i][field].toString()];
               i++;
            }
         }
         else if((value is Number || value is int || value is uint) && indexValues == true)
         {
            for(i = 0; i < n; i++)
            {
               v = cache[i];
               v[convertedField] = v[field];
            }
         }
         else
         {
            while(i < n)
            {
               cache[i][convertedField] = _catMap[cache[i][field]];
               i++;
            }
         }
      }
      
      public function reduceLabels(intervalStart:AxisLabel, intervalEnd:AxisLabel) : AxisLabelSet
      {
         var skipCount:int = _catMap[intervalEnd.value] - _catMap[intervalStart.value] + 1;
         if(skipCount <= 0)
         {
            return null;
         }
         var newLabels:Array = [];
         var newTicks:Array = [];
         var min:Number = -_padding;
         var max:Number = _categoryValues.length - 1 + _padding;
         var alen:Number = max - min;
         for(var i:int = 0; i < _categoryValues.length; i += skipCount)
         {
            newLabels.push(_labelsMatchToCategoryValuesByIndex[i]);
            newTicks.push(_labelsMatchToCategoryValuesByIndex[i].position);
         }
         var axisLabelSet:AxisLabelSet = new AxisLabelSet();
         axisLabelSet.labels = newLabels;
         axisLabelSet.minorTicks = minorTicks;
         axisLabelSet.ticks = generateTicks();
         return axisLabelSet;
      }
      
      [Inspectable(category="General")]
      public function get padding() : Number
      {
         return _padding;
      }
      
      [Inspectable(category="General")]
      public function get categoryField() : String
      {
         return _categoryField;
      }
      
      public function getLabelEstimate() : AxisLabelSet
      {
         update();
         return _labelSet;
      }
      
      private function set workingDataProvider(value:Object) : void
      {
         if(_dataProvider != null)
         {
            _dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler);
         }
         if(value is Array)
         {
            value = new ArrayCollection(value as Array);
         }
         else if(!(value is ICollectionView))
         {
            if(value is XMLList)
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
         _dataProvider = ICollectionView(value);
         _cursor = value.createCursor();
         if(Boolean(_dataProvider))
         {
            _dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler,false,0,true);
         }
         collectionChangeHandler();
      }
      
      [Inspectable(category="General")]
      public function get dataFunction() : Function
      {
         return _dataFunction;
      }
      
      public function set padding(value:Number) : void
      {
         _padding = value;
         invalidateCategories();
         dispatchEvent(new Event("mappingChange"));
         dispatchEvent(new Event("axisChange"));
      }
      
      public function set ticksBetweenLabels(value:Boolean) : void
      {
         _ticksBetweenLabels = value;
      }
      
      public function invertTransform(value:Number) : Object
      {
         update();
         var min:Number = -_padding;
         var max:Number = _categoryValues.length - 1 + _padding;
         var alen:Number = max - min;
         return _categoryValues[Math.round(value * alen + min)];
      }
      
      private function invalidateCategories() : void
      {
         _labelSet = null;
         _cachedMinorTicks = null;
         _cachedTicks = null;
         dispatchEvent(new Event("mappingChange"));
         dispatchEvent(new Event("axisChange"));
      }
      
      public function set categoryField(value:String) : void
      {
         _categoryField = value;
         collectionChangeHandler();
      }
      
      [Inspectable(category="General")]
      public function get dataProvider() : Object
      {
         return _dataProvider;
      }
      
      private function get minorTicks() : Array
      {
         var n:int = 0;
         var min:Number = NaN;
         var max:Number = NaN;
         var alen:Number = NaN;
         var i:Number = NaN;
         var start:Number = NaN;
         var end:Number = NaN;
         if(!_cachedMinorTicks)
         {
            _cachedMinorTicks = [];
            if(_ticksBetweenLabels == false)
            {
               n = int(_categoryValues.length);
               min = -_padding;
               max = n - 1 + _padding;
               alen = max - min;
               start = min <= -0.5 ? 0 : 1;
               end = max >= n - 0.5 ? n : n - 1;
               for(i = start; i <= end; i++)
               {
                  _cachedMinorTicks.push((i - 0.5 - min) / alen);
               }
            }
            else
            {
               n = int(_categoryValues.length);
               min = -_padding;
               max = n - 1 + _padding;
               alen = max - min;
               for(i = 0; i < n; i++)
               {
                  _cachedMinorTicks.push((i - min) / alen);
               }
            }
         }
         return _cachedMinorTicks;
      }
      
      [Inspectable(environment="none")]
      public function get baseline() : Number
      {
         return -_padding;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getCategoryValues() : Array
      {
         return _categoryValues;
      }
      
      public function update() : void
      {
         var prop:Object = null;
         var categoryItems:Array = null;
         var i:int = 0;
         var axisLabels:Array = null;
         var min:Number = NaN;
         var max:Number = NaN;
         var alen:Number = NaN;
         var label:AxisLabel = null;
         var n:int = 0;
         var previousValue:Object = null;
         if(!_labelSet)
         {
            _catMap = {};
            _categoryValues = [];
            _labelsMatchToCategoryValuesByIndex = [];
            categoryItems = [];
            if(_dataFunction != null)
            {
               _cursor.seek(CursorBookmark.FIRST);
               i = 0;
               while(!_cursor.afterLast)
               {
                  categoryItems[i] = _cursor.current;
                  prop = dataFunction(this,categoryItems[i]);
                  if(Boolean(prop))
                  {
                     _catMap[prop.toString()] = i;
                  }
                  _categoryValues[i] = prop;
                  i++;
                  _cursor.moveNext();
               }
            }
            else if(_categoryField == "")
            {
               _cursor.seek(CursorBookmark.FIRST);
               i = 0;
               while(!_cursor.afterLast)
               {
                  prop = _cursor.current;
                  if(prop != null)
                  {
                     _catMap[prop.toString()] = i;
                  }
                  _categoryValues[i] = categoryItems[i] = prop;
                  _cursor.moveNext();
                  i++;
               }
            }
            else
            {
               _cursor.seek(CursorBookmark.FIRST);
               i = 0;
               while(!_cursor.afterLast)
               {
                  categoryItems[i] = _cursor.current;
                  if(Boolean(categoryItems[i]) && _categoryField in categoryItems[i])
                  {
                     prop = categoryItems[i][_categoryField];
                     if(prop != null)
                     {
                        _catMap[prop.toString()] = i;
                     }
                     _categoryValues[i] = prop;
                  }
                  else
                  {
                     _categoryValues[i] = null;
                  }
                  i++;
                  _cursor.moveNext();
               }
            }
            axisLabels = [];
            min = -_padding;
            max = _categoryValues.length - 1 + _padding;
            alen = max - min;
            n = int(_categoryValues.length);
            if(_labelFunction != null)
            {
               previousValue = null;
               for(i = 0; i < n; i++)
               {
                  if(_categoryValues[i] != null)
                  {
                     label = new AxisLabel((i - min) / alen,_categoryValues[i],_labelFunction(_categoryValues[i],previousValue,this,categoryItems[i]));
                     _labelsMatchToCategoryValuesByIndex[i] = label;
                     axisLabels.push(label);
                     previousValue = _categoryValues[i];
                  }
               }
            }
            else
            {
               for(i = 0; i < n; i++)
               {
                  if(_categoryValues[i])
                  {
                     label = new AxisLabel((i - min) / alen,_categoryValues[i],_categoryValues[i].toString());
                     _labelsMatchToCategoryValuesByIndex[i] = label;
                     axisLabels.push(label);
                  }
               }
            }
            _labelSet = new AxisLabelSet();
            _labelSet.labels = axisLabels;
            _labelSet.accurate = true;
            _labelSet.minorTicks = minorTicks;
            _labelSet.ticks = generateTicks();
         }
      }
      
      [Inspectable]
      public function get ticksBetweenLabels() : Boolean
      {
         return _ticksBetweenLabels;
      }
      
      public function set dataFunction(value:Function) : void
      {
         _dataFunction = value;
         collectionChangeHandler();
      }
      
      public function formatForScreen(value:Object) : String
      {
         var catValue:Object = null;
         if(value is Number && value < _categoryValues.length)
         {
            catValue = _categoryValues[Math.round(Number(value))];
            return catValue == null ? value.toString() : catValue.toString();
         }
         return value.toString();
      }
      
      public function set labelFunction(value:Function) : void
      {
         _labelFunction = value;
         invalidateCategories();
      }
      
      [Inspectable(category="General")]
      public function get labelFunction() : Function
      {
         return _labelFunction;
      }
      
      public function set dataProvider(value:Object) : void
      {
         _userDataProvider = value;
         if(_userDataProvider != null)
         {
            workingDataProvider = _userDataProvider;
         }
         else
         {
            workingDataProvider = _chartDataProvider;
         }
      }
      
      override public function set chartDataProvider(value:Object) : void
      {
         if(_chartDataProvider != value)
         {
            _chartDataProvider = value;
            if(!_userDataProvider)
            {
               workingDataProvider = _chartDataProvider;
            }
         }
      }
      
      public function getLabels(minimumAxisLength:Number) : AxisLabelSet
      {
         update();
         return _labelSet;
      }
      
      public function transformCache(cache:Array, field:String, convertedField:String) : void
      {
         update();
         var min:Number = -_padding;
         var max:Number = _categoryValues.length - 1 + _padding;
         var alen:Number = max - min;
         var n:int = int(cache.length);
         for(var i:int = 0; i < n; i++)
         {
            cache[i][convertedField] = (cache[i][field] - min) / alen;
         }
      }
      
      public function preferDropLabels() : Boolean
      {
         return false;
      }
   }
}

