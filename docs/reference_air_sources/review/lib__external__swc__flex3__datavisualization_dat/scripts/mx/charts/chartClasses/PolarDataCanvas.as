package mx.charts.chartClasses
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import mx.charts.CategoryAxis;
   import mx.charts.PieChart;
   import mx.core.IFlexDisplayObject;
   import mx.core.IUIComponent;
   
   [DefaultProperty("dataChildren")]
   public class PolarDataCanvas extends ChartElement implements IDataCanvas
   {
      
      private var _yMap:Dictionary;
      
      private var _xCache:Array;
      
      private var _oldUW:Number;
      
      private var _bAxesDirty:Boolean = false;
      
      private var _radialAxis:IAxis;
      
      private var borderWidth:Number = 0;
      
      private var _oldUH:Number;
      
      private var _totalValue:Number = 100;
      
      private var _hDataDesc:DataDescription;
      
      private var _vDataDesc:DataDescription;
      
      private var _dataCache:PolarDataCache;
      
      private var _filterDirty:Boolean = true;
      
      private var _mappingDirty:Boolean = true;
      
      private var _opCodes:Array = [];
      
      private var _yCache:Array;
      
      private var _xMap:Dictionary;
      
      private var _dataChildren:Array = [];
      
      private var _dataCacheDirty:Boolean = true;
      
      private var _angularAxis:IAxis;
      
      private var _transformDirty:Boolean = true;
      
      private var _includeInRanges:Boolean = false;
      
      private var _childMap:Dictionary;
      
      public function PolarDataCanvas()
      {
         super();
         _hDataDesc = new DataDescription();
         _vDataDesc = new DataDescription();
         _childMap = new Dictionary(true);
         dataTransform = new PolarTransform();
      }
      
      public function endFill() : void
      {
         pushOp(PolarOpCode.END_FILL);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function dataChildChangeHandler(e:Event) : void
      {
         dataChildren = dataChildren;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var i:int = 0;
         var g:Graphics = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         validateData();
         mapChildren();
         var updated:Boolean = validateTransform();
         if(updated)
         {
            g = graphics;
            g.clear();
            for(i = 0; i < _opCodes.length; i++)
            {
               _opCodes[i].render(this,_dataCache);
            }
            positionChildren();
         }
      }
      
      protected function stripNaNs(cache:Array, field:String) : void
      {
         var i:int = 0;
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
      
      override public function describeData(dimension:String, requiredFields:uint) : Array
      {
         updateMapping();
         var result:Array = [];
         if(_includeInRanges)
         {
            if(dimension == PolarTransform.RADIAL_AXIS)
            {
               if(Boolean(_dataCache.xCache.length))
               {
                  result.push(_vDataDesc);
               }
            }
            else if(dimension == PolarTransform.ANGULAR_AXIS)
            {
               if(Boolean(_dataCache.yCache.length))
               {
                  result.push(_hDataDesc);
               }
            }
         }
         return result;
      }
      
      private function invalidateOpCodes() : void
      {
         dataChanged();
         invalidateDisplayList();
      }
      
      public function set totalValue(value:Number) : void
      {
         _totalValue = value;
         invalidateData();
         invalidateProperties();
      }
      
      public function lineStyle(thickness:Number, color:uint = 0, alpha:Number = 1, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3) : void
      {
         borderWidth = thickness;
         pushOp(PolarOpCode.LINE_STYLE,{
            "thickness":thickness,
            "color":color,
            "alpha":alpha,
            "pixelHinting":pixelHinting,
            "scaleMode":scaleMode,
            "caps":caps,
            "joints":joints,
            "miterLimit":miterLimit
         });
      }
      
      override public function mappingChanged() : void
      {
         invalidateDisplayList();
      }
      
      private function heightFor(child:DisplayObject) : Number
      {
         return child is IUIComponent ? IUIComponent(child).getExplicitOrMeasuredHeight() + 2 : (child is IFlexDisplayObject ? IFlexDisplayObject(child).measuredHeight + 2 : child.height);
      }
      
      [Inspectable(category="General")]
      public function get includeInRanges() : Boolean
      {
         return _includeInRanges;
      }
      
      private function widthFor(child:DisplayObject) : Number
      {
         return child is IUIComponent ? IUIComponent(child).getExplicitOrMeasuredWidth() + 2 : (child is IFlexDisplayObject ? IFlexDisplayObject(child).measuredWidth + 2 : child.width);
      }
      
      public function drawCircle(angle:*, radial:*, radius:Number) : void
      {
         pushOp(PolarOpCode.DRAW_CIRCLE,{
            "angle":angle,
            "radial":radial,
            "radius":radius,
            "borderWidth":borderWidth
         });
      }
      
      public function moveTo(angle:*, radial:*) : void
      {
         pushOp(PolarOpCode.MOVE_TO,{
            "angle":angle,
            "radial":radial,
            "borderWidth":borderWidth
         });
      }
      
      override public function invalidateDisplayList() : void
      {
         _dataCacheDirty = true;
         _mappingDirty = true;
         _filterDirty = true;
         _transformDirty = true;
         super.invalidateDisplayList();
      }
      
      public function drawRect(angleLeft:*, radialTop:*, angleRight:*, radialBottom:*) : void
      {
         pushOp(PolarOpCode.DRAW_RECT,{
            "angleLeft":angleLeft,
            "radialTop":radialTop,
            "angleRight":angleRight,
            "radialBottom":radialBottom,
            "borderWidth":borderWidth
         });
      }
      
      override public function removeChildAt(index:int) : DisplayObject
      {
         var child:DisplayObject = super.removeChildAt(index);
         if(child in _childMap)
         {
            delete _childMap[child];
         }
         _dataChildren.splice(index,1);
         return child;
      }
      
      public function clear() : void
      {
         _opCodes = [];
         invalidateOpCodes();
      }
      
      public function set includeInRanges(value:Boolean) : void
      {
         if(_includeInRanges == value)
         {
            return;
         }
         _includeInRanges = value;
         dataChanged();
      }
      
      public function set angularAxis(value:IAxis) : void
      {
         _angularAxis = value;
         _bAxesDirty = true;
         invalidateData();
         invalidateProperties();
      }
      
      [Inspectable(category="Data")]
      public function get radialAxis() : IAxis
      {
         return _radialAxis;
      }
      
      public function drawRoundedRect(angleLeft:*, radialTop:*, angleRight:*, radialBottom:*, cornerRadius:Number) : void
      {
         pushOp(PolarOpCode.DRAW_ROUNDRECT,{
            "angleLeft":angleLeft,
            "radialTop":radialTop,
            "angleRight":angleRight,
            "radialBottom":radialBottom,
            "borderWidth":borderWidth,
            "cornerRadius":cornerRadius
         });
      }
      
      private function positionChildren() : void
      {
         var aChild:* = undefined;
         var dc:PolarDataChild = null;
         var left:Number = NaN;
         var right:Number = NaN;
         var top:Number = NaN;
         var bottom:Number = NaN;
         var width:Number = NaN;
         var height:Number = NaN;
         var dataTransform:PolarTransform = PolarTransform(dataTransform);
         for(aChild in _childMap)
         {
            dc = _childMap[aChild];
            left = dc.renderLeft;
            right = left + widthFor(dc.child);
            top = dc.renderTop;
            bottom = top + heightFor(dc.child);
            if(isNaN(left) || isNaN(right) || isNaN(top) || isNaN(bottom))
            {
               removeChild(aChild);
            }
            else if(dc.child is IFlexDisplayObject)
            {
               IFlexDisplayObject(dc.child).setActualSize(right - left,bottom - top);
               IFlexDisplayObject(dc.child).move(left,top);
            }
            else
            {
               dc.child.width = right - left;
               dc.child.height = bottom - top;
               dc.child.x = left;
               dc.child.y = top;
            }
         }
      }
      
      private function mapChildren() : void
      {
         var width:Number = NaN;
         var height:Number = NaN;
         var aChild:* = undefined;
         var dc:PolarDataChild = null;
         var pt:Point = null;
         var dataTransform:PolarTransform = null;
         var data:Object = null;
         var da:Array = null;
         for(aChild in _childMap)
         {
            dc = _childMap[aChild];
            dataTransform = PolarTransform(dataTransform);
            data = {};
            da = [data];
            if(dc.aCenter != undefined)
            {
               data["d0"] = dc.aCenter;
               dataTransform.getAxis(PolarTransform.ANGULAR_AXIS).mapCache(da,"d0","v0");
               if(chart is PieChart && !(angularAxis is CategoryAxis))
               {
                  data["v0"] = data["v0"] * 100 / totalValue;
               }
            }
            else if(dc.right != undefined)
            {
               data["d0"] = dc.right;
               dataTransform.getAxis(PolarTransform.ANGULAR_AXIS).mapCache(da,"d0","v0");
               if(chart is PieChart && !(angularAxis is CategoryAxis))
               {
                  data["v0"] = data["v0"] * 100 / totalValue;
               }
            }
            else
            {
               data["d0"] = dc.left;
               dataTransform.getAxis(PolarTransform.ANGULAR_AXIS).mapCache(da,"d0","v0");
               if(chart is PieChart && !(angularAxis is CategoryAxis))
               {
                  data["v0"] = data["v0"] * 100 / totalValue;
               }
            }
            if(!(chart is PieChart))
            {
               if(dc.rCenter != undefined)
               {
                  data["d1"] = dc.rCenter;
                  dataTransform.getAxis(PolarTransform.RADIAL_AXIS).mapCache(da,"d1","v1");
                  dataTransform.transformCache(da,"v0","s0","v1","s1");
                  pt = new Point(dataTransform.origin.x + Math.cos(data.s0) * data.s1 - widthFor(dc.child) / 2,dataTransform.origin.y - Math.sin(data.s0) * data.s1 - heightFor(dc.child) / 2);
               }
               else if(dc.bottom != undefined)
               {
                  data["d1"] = dc.bottom;
                  dataTransform.getAxis(PolarTransform.RADIAL_AXIS).mapCache(da,"d1","v1");
                  dataTransform.transformCache(da,"v0","s0","v1","s1");
                  pt = new Point(dataTransform.origin.x + Math.cos(data.s0) * data.s1 - widthFor(dc.child),dataTransform.origin.y - Math.sin(data.s0) * data.s1 - heightFor(dc.child));
               }
               else if(dc.top != undefined)
               {
                  data["d1"] = dc.top;
                  dataTransform.getAxis(PolarTransform.RADIAL_AXIS).mapCache(da,"d1","v1");
                  dataTransform.transformCache(da,"v0","s0","v1","s1");
                  pt = new Point(dataTransform.origin.x + Math.cos(data.s0) * data.s1,dataTransform.origin.y - Math.sin(data.s0) * data.s1);
               }
            }
            else
            {
               dataTransform.transformCache(da,"v0","s0",null,null);
               if(dc.aCenter != undefined)
               {
                  if(dc.rCenter == undefined)
                  {
                     dc.rCenter = 1;
                  }
                  pt = new Point(dataTransform.origin.x + Math.cos(data.s0) * dc.rCenter - widthFor(dc.child) / 2,dataTransform.origin.y - Math.sin(data.s0) * dc.rCenter - heightFor(dc.child) / 2);
               }
               if(dc.right != undefined)
               {
                  if(dc.bottom == undefined)
                  {
                     dc.bottom = 1;
                  }
                  pt = new Point(dataTransform.origin.x + Math.cos(data.s0) * dc.bottom - widthFor(dc.child),dataTransform.origin.y - Math.sin(data.s0) * dc.bottom - heightFor(dc.child));
               }
               else
               {
                  if(dc.top == undefined)
                  {
                     dc.top = 1;
                  }
                  pt = new Point(dataTransform.origin.x + Math.cos(data.s0) * dc.top,dataTransform.origin.y - Math.sin(data.s0) * dc.top);
               }
            }
            dc.renderLeft = pt.x;
            dc.renderTop = pt.y;
         }
      }
      
      protected function invalidateData(invalid:Boolean = true) : void
      {
         if(invalid)
         {
            invalidateDisplayList();
         }
      }
      
      private function set opCodes(value:Array) : void
      {
         _opCodes = value;
         invalidateOpCodes();
      }
      
      public function get totalValue() : Number
      {
         return _totalValue;
      }
      
      override public function addChildAt(child:DisplayObject, index:int) : DisplayObject
      {
         var dc:PolarDataChild = new PolarDataChild(child);
         _childMap[child] = dc;
         _dataChildren.push(dc);
         dc.addEventListener("change",dataChildChangeHandler,false,0,true);
         invalidateOpCodes();
         return super.addChildAt(child,index);
      }
      
      public function lineTo(angle:*, radial:*) : void
      {
         pushOp(PolarOpCode.LINE_TO,{
            "angle":angle,
            "radial":radial,
            "borderWidth":borderWidth
         });
      }
      
      public function set dataChildren(value:Array) : void
      {
         var aChild:* = undefined;
         var i:int = 0;
         var dc:PolarDataChild = null;
         for(aChild in _childMap)
         {
            removeChild(_childMap[aChild].child);
         }
         _childMap = new Dictionary(true);
         _dataChildren = value;
         for(i = 0; i < value.length; i++)
         {
            if(value[i] is PolarDataChild)
            {
               dc = value[i];
            }
            else
            {
               dc = new PolarDataChild(value[i]);
            }
            _childMap[dc.child] = dc;
            dc.left = 0;
            dc.top = 0;
            dc.addEventListener("change",dataChildChangeHandler,false,0,true);
            super.addChild(dc.child);
         }
         invalidateOpCodes();
      }
      
      private function pushOp(code:int, params:Object = null) : PolarOpCode
      {
         var op:PolarOpCode = new PolarOpCode(this,code,params);
         _opCodes.push(op);
         invalidateOpCodes();
         return op;
      }
      
      public function removeAllChildren() : void
      {
         var len:int = int(_dataChildren.length);
         for(var i:int = len - 1; i >= 0; i--)
         {
            removeChildAt(i);
         }
      }
      
      protected function updateFilter() : void
      {
         for(var i:int = 0; i < _dataCache.xCache.length; i++)
         {
            if(isNaN(_dataCache.xCache[i].mappedValue))
            {
               delete _dataCache.xMap[_dataCache.xCache[i].value];
            }
         }
         if(!(chart is PieChart))
         {
            for(i = 0; i < _dataCache.yCache.length; i++)
            {
               if(isNaN(_dataCache.yCache[i].mappedValue))
               {
                  delete _dataCache.yMap[_dataCache.yCache[i].value];
               }
            }
         }
         stripNaNs(_dataCache.xCache,"mappedValue");
         if(!(chart is PieChart))
         {
            stripNaNs(_dataCache.yCache,"mappedValue");
         }
         _filterDirty = false;
      }
      
      [Inspectable(category="Data")]
      public function get angularAxis() : IAxis
      {
         return _angularAxis;
      }
      
      protected function updateTransform() : Boolean
      {
         var i:int = 0;
         var record:Object = null;
         var pt:Point = null;
         var dataTransform:PolarTransform = PolarTransform(dataTransform);
         var updated:Boolean = false;
         if(_transformDirty == false)
         {
            if(unscaledHeight != _oldUW || unscaledWidth != _oldUW)
            {
               _transformDirty = true;
               _oldUW = unscaledWidth;
               _oldUH = unscaledHeight;
            }
         }
         if(_transformDirty)
         {
            updated = true;
            _transformDirty = false;
            dataTransform.transformCache(_dataCache.xCache,"mappedValue","pixelValue",null,null);
            for(i = 0; i < _dataCache.xCache.length; i++)
            {
               _dataCache.xMap[_dataCache.xCache[i].value] = _dataCache.xCache[i].pixelValue;
            }
            if(!(chart is PieChart))
            {
               dataTransform.transformCache(_dataCache.yCache,null,null,"mappedValue","pixelValue");
               for(i = 0; i < _dataCache.yCache.length; i++)
               {
                  _dataCache.yMap[_dataCache.yCache[i].value] = _dataCache.yCache[i].pixelValue;
               }
            }
            else
            {
               for(i = 0; i < _dataCache.yCache.length; i++)
               {
                  _dataCache.yMap[_dataCache.yCache[i].value] = _dataCache.yCache[i].value;
               }
            }
         }
         return updated;
      }
      
      public function set radialAxis(value:IAxis) : void
      {
         _radialAxis = value;
         _bAxesDirty = true;
         invalidateData();
         invalidateProperties();
      }
      
      override public function set dataTransform(value:DataTransform) : void
      {
         var axis:String = null;
         if(Boolean(value))
         {
            super.dataTransform = value;
         }
         else
         {
            for(axis in dataTransform.axes)
            {
               dataTransform.getAxis(axis).unregisterDataTransform(dataTransform);
            }
         }
      }
      
      [ArrayElementType("PolarOpCode")]
      private function get opCodes() : Array
      {
         return _opCodes;
      }
      
      public function updateDataChild(child:DisplayObject, angleLeft:* = undefined, radialTop:* = undefined, angleRight:* = undefined, radialBottom:* = undefined, angleCenter:* = undefined, radialCenter:* = undefined) : void
      {
         var dc:PolarDataChild = _childMap[child];
         dc.left = angleLeft;
         dc.top = radialTop;
         dc.right = angleRight;
         dc.bottom = radialBottom;
         dc.aCenter = angleCenter;
         dc.rCenter = radialCenter;
         invalidateOpCodes();
      }
      
      public function beginFill(color:uint, alpha:Number = 1) : void
      {
         pushOp(PolarOpCode.BEGIN_FILL,{
            "color":color,
            "alpha":alpha
         });
      }
      
      public function curveTo(controlAngle:*, controlRadial:*, anchorAngle:*, anchorRadial:*) : void
      {
         pushOp(PolarOpCode.CURVE_TO,{
            "controlAngle":controlAngle,
            "controlRadial":controlRadial,
            "anchorAngle":anchorAngle,
            "anchorRadial":anchorRadial,
            "borderWidth":borderWidth
         });
      }
      
      protected function updateMapping() : void
      {
         var i:int = 0;
         var key:* = undefined;
         var record:* = undefined;
         var value:* = undefined;
         var boundedValue:BoundedValue = null;
         var boundedValues:Array = null;
         if(_dataCacheDirty)
         {
            _dataCache = new PolarDataCache();
            for(i = 0; i < _opCodes.length; i++)
            {
               _opCodes[i].collectValues(_dataCache);
            }
            _dataCache.xCache = [];
            _dataCache.yCache = [];
            _hDataDesc.min = Number.MAX_VALUE;
            _hDataDesc.max = Number.MIN_VALUE;
            _vDataDesc.min = Number.MAX_VALUE;
            _vDataDesc.max = Number.MIN_VALUE;
            for(key in _dataCache.xMap)
            {
               value = _dataCache.xMap[key];
               _dataCache.xCache.push({"value":value});
            }
            for(key in _dataCache.yMap)
            {
               value = _dataCache.yMap[key];
               _dataCache.yCache.push({"value":value});
            }
            _mappingDirty = true;
            _dataCacheDirty = false;
         }
         if(_mappingDirty)
         {
            dataTransform.getAxis(PolarTransform.ANGULAR_AXIS).mapCache(_dataCache.xCache,"value","mappedValue");
            if(!(angularAxis is CategoryAxis))
            {
               for(i = 0; i < _dataCache.xCache.length; i++)
               {
                  _dataCache.xCache[i].mappedValue = _dataCache.xCache[i].mappedValue * 100 / totalValue;
               }
            }
            if(!(chart is PieChart))
            {
               dataTransform.getAxis(PolarTransform.RADIAL_AXIS).mapCache(_dataCache.yCache,"value","mappedValue");
            }
            _transformDirty = true;
            _mappingDirty = false;
            _filterDirty = true;
            boundedValues = [];
            for(i = 0; i < _dataCache.xCache.length; i++)
            {
               value = _dataCache.xCache[i];
               boundedValue = _dataCache.xBoundedValues[value.value];
               if(Boolean(boundedValue))
               {
                  boundedValue.value = value.mappedValue;
                  boundedValues.push(boundedValue);
               }
            }
            if(boundedValues.length > 0)
            {
               _hDataDesc.boundedValues = boundedValues;
               boundedValues = [];
            }
            for(i = 0; i < _dataCache.yCache.length; i++)
            {
               value = _dataCache.yCache[i];
               boundedValue = _dataCache.yBoundedValues[value.value];
               if(Boolean(boundedValue))
               {
                  boundedValue.value = value.mappedValue;
                  boundedValues.push(boundedValue);
               }
            }
            if(boundedValues.length > 0)
            {
               _vDataDesc.boundedValues = boundedValues;
            }
            for(i = 0; i < _dataCache.yCache.length; i++)
            {
               record = _dataCache.yCache[i];
               _vDataDesc.min = Math.min(_vDataDesc.min,record.mappedValue);
               _vDataDesc.max = Math.max(_vDataDesc.max,record.mappedValue);
            }
            for(i = 0; i < _dataCache.xCache.length; i++)
            {
               record = _dataCache.xCache[i];
               _hDataDesc.min = Math.min(_hDataDesc.min,record.mappedValue);
               _hDataDesc.max = Math.max(_hDataDesc.max,record.mappedValue);
            }
         }
      }
      
      [Inspectable(category="General")]
      public function get dataChildren() : Array
      {
         return _dataChildren;
      }
      
      public function beginBitmapFill(bitmap:BitmapData, x:* = undefined, y:* = undefined, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = true) : void
      {
         pushOp(PolarOpCode.BEGIN_BITMAP_FILL,{
            "bitmap":bitmap,
            "x":x,
            "y":y,
            "repeat":repeat,
            "smooth":smooth,
            "matrix":matrix
         });
      }
      
      protected function validateData() : void
      {
         if(Boolean(dataTransform))
         {
            if(_mappingDirty)
            {
               updateMapping();
            }
            if(_filterDirty)
            {
               updateFilter();
            }
         }
      }
      
      public function addDataChild(child:DisplayObject, angleLeft:* = undefined, radialTop:* = undefined, angleRight:* = undefined, radialBottom:* = undefined, angleCenter:* = undefined, radialCenter:* = undefined) : void
      {
         var dc:PolarDataChild = new PolarDataChild(child,angleLeft,radialTop,angleRight,radialBottom);
         dc.addEventListener("change",dataChildChangeHandler,false,0,true);
         addChild(child);
         updateDataChild(child,angleLeft,radialTop,angleRight,radialBottom,angleCenter,radialCenter);
         invalidateOpCodes();
      }
      
      protected function validateTransform() : Boolean
      {
         var updated:Boolean = false;
         if(Boolean(dataTransform) && _transformDirty)
         {
            updated = updateTransform();
         }
         return updated;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(_bAxesDirty)
         {
            if(Boolean(dataTransform))
            {
               if(Boolean(_angularAxis))
               {
                  dataTransform.setAxis(PolarTransform.ANGULAR_AXIS,_angularAxis);
               }
               if(Boolean(_radialAxis))
               {
                  dataTransform.setAxis(PolarTransform.RADIAL_AXIS,_radialAxis);
               }
            }
            _bAxesDirty = false;
         }
         var c:PolarChart = PolarChart(chart);
         if(Boolean(c))
         {
            if(!_angularAxis)
            {
               PolarTransform(dataTransform).setAxis(PolarTransform.ANGULAR_AXIS,c.angularAxis);
            }
            if(!_radialAxis)
            {
               PolarTransform(dataTransform).setAxis(PolarTransform.RADIAL_AXIS,c.radialAxis);
            }
         }
         dataTransform.elements = [this];
         invalidateOpCodes();
      }
      
      override public function removeChild(child:DisplayObject) : DisplayObject
      {
         super.removeChild(child);
         if(child in _childMap)
         {
            delete _childMap[child];
         }
         _dataChildren.splice(_dataChildren.indexOf(child),1);
         return child;
      }
      
      public function drawEllipse(angleLeft:*, radialTop:*, angleRight:*, radialBottom:*) : void
      {
         pushOp(PolarOpCode.DRAW_ELLIPSE,{
            "angleLeft":angleLeft,
            "radialTop":radialTop,
            "angleRight":angleRight,
            "radialBottom":radialBottom,
            "borderWidth":borderWidth
         });
      }
      
      override public function addChild(child:DisplayObject) : DisplayObject
      {
         var dc:PolarDataChild = new PolarDataChild(child);
         dc.left = 0;
         dc.top = 0;
         _childMap[child] = dc;
         _dataChildren.push(dc);
         dc.addEventListener("change",dataChildChangeHandler,false,0,true);
         invalidateOpCodes();
         return super.addChild(child);
      }
   }
}

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.utils.Dictionary;
import mx.charts.chartClasses.BoundedValue;
import mx.charts.chartClasses.PolarDataCanvas;
import mx.charts.chartClasses.PolarTransform;

[Event("change")]
[DefaultProperty("content")]
class PolarDataChild extends EventDispatcher
{
   
   public var right:*;
   
   public var aCenter:*;
   
   public var renderTop:*;
   
   public var left:*;
   
   public var rCenter:*;
   
   public var bottom:*;
   
   public var top:*;
   
   public var child:DisplayObject;
   
   public var renderLeft:*;
   
   public function PolarDataChild(child:DisplayObject = null, left:* = undefined, top:* = undefined, right:* = undefined, bottom:* = undefined, aCenter:* = undefined, rCenter:* = undefined)
   {
      super();
      this.child = child;
      this.left = left;
      this.top = top;
      this.bottom = bottom;
      this.right = right;
      this.aCenter = aCenter;
      this.rCenter = rCenter;
   }
   
   public function set content(value:*) : void
   {
      if(value is DisplayObject)
      {
         child = value;
      }
      else if(value is Class)
      {
         child = new value();
      }
      dispatchEvent(new Event("change"));
   }
}

class PolarOpCode
{
   
   public static const BEGIN_BITMAP_FILL:int = 0;
   
   public static const BEGIN_FILL:int = 1;
   
   public static const CURVE_TO:int = 2;
   
   public static const DRAW_CIRCLE:int = 3;
   
   public static const DRAW_ELLIPSE:int = 4;
   
   public static const DRAW_RECT:int = 5;
   
   public static const DRAW_ROUNDRECT:int = 6;
   
   public static const END_FILL:int = 7;
   
   public static const LINE_STYLE:int = 8;
   
   public static const LINE_TO:int = 9;
   
   public static const MOVE_TO:int = 10;
   
   public var params:Object;
   
   public var canvas:PolarDataCanvas;
   
   public var code:int;
   
   public function PolarOpCode(canvas:PolarDataCanvas, code:int, params:Object = null)
   {
      super();
      this.canvas = canvas;
      this.code = code;
      this.params = params == null ? {} : params;
   }
   
   §§namespace("http://www.adobe.com/2006/flex/mx/internal") function render(target:PolarDataCanvas, cache:PolarDataCache) : void
   {
      var left:Number = NaN;
      var top:Number = NaN;
      var right:Number = NaN;
      var bottom:Number = NaN;
      var controlX:Number = NaN;
      var controlY:Number = NaN;
      var anchorX:Number = NaN;
      var anchorY:Number = NaN;
      var x:Number = NaN;
      var y:Number = NaN;
      var pt:Point = null;
      var dataTransform:PolarTransform = null;
      var m:Matrix = null;
      var d:* = undefined;
      dataTransform = PolarTransform(dataTransform);
      var data:Object = {};
      var da:Array = [data];
      var g:Graphics = target.graphics;
      switch(code)
      {
         case BEGIN_BITMAP_FILL:
            if(!params.matrix)
            {
               m = new Matrix();
            }
            else
            {
               m = params.matrix.clone();
            }
            d = params.x;
            if(d != undefined)
            {
               m.tx = cache.x(d);
            }
            d = params.y;
            if(d != undefined)
            {
               m.ty = cache.y(d);
            }
            g.beginBitmapFill(params.bitmap,m,params.repeat,params.smooth);
            break;
         case BEGIN_FILL:
            g.beginFill(params.color,params.alpha);
            break;
         case CURVE_TO:
            controlX = cache.x(params.controlAngle);
            controlY = cache.y(params.controlRadial);
            pt = new Point(PolarTransform(canvas.dataTransform).origin.x + Math.cos(controlX) * controlY,PolarTransform(canvas.dataTransform).origin.y - Math.sin(controlX) * controlY);
            controlX = pt.x;
            controlY = pt.y;
            anchorX = cache.x(params.anchorAngle);
            anchorY = cache.y(params.anchorRadial);
            pt = new Point(PolarTransform(canvas.dataTransform).origin.x + Math.cos(anchorX) * anchorY,PolarTransform(canvas.dataTransform).origin.y - Math.sin(anchorX) * anchorY);
            anchorX = pt.x;
            anchorY = pt.y;
            if(isNaN(controlX) || isNaN(controlY) || isNaN(anchorX) || isNaN(anchorY))
            {
               return;
            }
            g.curveTo(controlX,controlY,anchorX,anchorY);
            break;
         case DRAW_CIRCLE:
            x = cache.x(params.angle);
            y = cache.y(params.radial);
            pt = new Point(PolarTransform(canvas.dataTransform).origin.x + Math.cos(x) * y,PolarTransform(canvas.dataTransform).origin.y - Math.sin(x) * y);
            x = pt.x;
            y = pt.y;
            if(isNaN(x) || isNaN(y))
            {
               return;
            }
            g.drawCircle(x,y,params.radius);
            break;
         case DRAW_ELLIPSE:
            left = cache.x(params.angleLeft);
            top = cache.y(params.radialTop);
            pt = new Point(PolarTransform(canvas.dataTransform).origin.x + Math.cos(left) * top,PolarTransform(canvas.dataTransform).origin.y - Math.sin(left) * top);
            left = pt.x;
            top = pt.y;
            right = cache.x(params.angleRight);
            bottom = cache.y(params.radialBottom);
            pt = new Point(PolarTransform(canvas.dataTransform).origin.x + Math.cos(right) * bottom,PolarTransform(canvas.dataTransform).origin.y - Math.sin(right) * bottom);
            right = pt.x;
            bottom = pt.y;
            if(isNaN(left) || isNaN(top) || isNaN(right) || isNaN(bottom))
            {
               return;
            }
            g.drawEllipse(left,top,right - left,bottom - top);
            break;
         case DRAW_RECT:
            left = cache.x(params.angleLeft);
            top = cache.y(params.radialTop);
            pt = new Point(PolarTransform(canvas.dataTransform).origin.x + Math.cos(left) * top,PolarTransform(canvas.dataTransform).origin.y - Math.sin(left) * top);
            left = pt.x;
            top = pt.y;
            right = cache.x(params.angleRight);
            bottom = cache.y(params.radialBottom);
            pt = new Point(PolarTransform(canvas.dataTransform).origin.x + Math.cos(right) * bottom,PolarTransform(canvas.dataTransform).origin.y - Math.sin(right) * bottom);
            right = pt.x;
            bottom = pt.y;
            if(isNaN(left) || isNaN(top) || isNaN(right) || isNaN(bottom))
            {
               return;
            }
            g.drawRect(left,top,right - left,bottom - top);
            break;
         case DRAW_ROUNDRECT:
            left = cache.x(params.angleLeft);
            top = cache.y(params.radialTop);
            pt = new Point(PolarTransform(canvas.dataTransform).origin.x + Math.cos(left) * top,PolarTransform(canvas.dataTransform).origin.y - Math.sin(left) * top);
            left = pt.x;
            top = pt.y;
            right = cache.x(params.angleRight);
            bottom = cache.y(params.radialBottom);
            pt = new Point(PolarTransform(canvas.dataTransform).origin.x + Math.cos(right) * bottom,PolarTransform(canvas.dataTransform).origin.y - Math.sin(right) * bottom);
            right = pt.x;
            bottom = pt.y;
            if(isNaN(left) || isNaN(top) || isNaN(right) || isNaN(bottom))
            {
               return;
            }
            g.drawRoundRect(left,top,right - left,bottom - top,params.cornerRadius,params.cornerRadius);
            break;
         case END_FILL:
            g.endFill();
            break;
         case LINE_STYLE:
            g.lineStyle(params.thickness,params.color,params.alpha,params.pixleHinting,params.scaleMode,params.caps,params.joints,params.miterLimit);
            break;
         case MOVE_TO:
            x = cache.x(params.angle);
            y = cache.y(params.radial);
            pt = new Point(PolarTransform(canvas.dataTransform).origin.x + Math.cos(x) * y,PolarTransform(canvas.dataTransform).origin.y - Math.sin(x) * y);
            x = pt.x;
            y = pt.y;
            if(isNaN(x) || isNaN(y))
            {
               return;
            }
            g.moveTo(x,y);
            break;
         case LINE_TO:
            x = cache.x(params.angle);
            y = cache.y(params.radial);
            pt = new Point(PolarTransform(canvas.dataTransform).origin.x + Math.cos(x) * y,PolarTransform(canvas.dataTransform).origin.y - Math.sin(x) * y);
            x = pt.x;
            y = pt.y;
            if(isNaN(x) || isNaN(y))
            {
               return;
            }
            g.lineTo(x,y);
      }
   }
   
   §§namespace("http://www.adobe.com/2006/flex/mx/internal") function collectValues(cache:PolarDataCache) : void
   {
      switch(code)
      {
         case BEGIN_BITMAP_FILL:
            cache.storeX(params.x);
            cache.storeY(params.y);
            break;
         case CURVE_TO:
            cache.storeX(params.anchorAngle);
            cache.storeY(params.anchorRadial);
            cache.storeX(params.controlAngle);
            cache.storeY(params.controlRadial);
            break;
         case DRAW_CIRCLE:
         case MOVE_TO:
         case LINE_TO:
            cache.storeX(params.angle);
            cache.storeY(params.radial);
            break;
         case DRAW_ELLIPSE:
            cache.storeX(params.angleLeft);
            cache.storeY(params.radialTop);
            cache.storeX(params.angleRight);
            cache.storeY(params.radialBottom);
            break;
         case DRAW_RECT:
            cache.storeX(params.angleLeft);
            cache.storeY(params.radialTop);
            cache.storeX(params.angleRight);
            cache.storeY(params.radialBottom);
            break;
         case DRAW_ROUNDRECT:
            cache.storeX(params.angleLeft);
            cache.storeY(params.radialTop);
            cache.storeX(params.angleRight);
            cache.storeY(params.radialBottom);
      }
   }
}

class PolarDataCache
{
   
   public var yMap:Dictionary;
   
   public var xMap:Dictionary;
   
   public var yBoundedValues:Dictionary;
   
   public var xBoundedValues:Dictionary;
   
   public var yCache:Array;
   
   public var xCache:Array;
   
   public function PolarDataCache()
   {
      super();
      xMap = new Dictionary(true);
      yMap = new Dictionary(true);
      xCache = [];
      yCache = [];
      xBoundedValues = new Dictionary(true);
      yBoundedValues = new Dictionary(true);
   }
   
   §§namespace("http://www.adobe.com/2006/flex/mx/internal") function storeX(value:*, leftMargin:Number = 0, rightMargin:Number = 0) : void
   {
      var bounds:BoundedValue = null;
      xMap[value] = value;
      if(leftMargin != 0 || rightMargin != 0)
      {
         bounds = xBoundedValues[value];
      }
      if(leftMargin > 0)
      {
         leftMargin += 2;
      }
      if(rightMargin > 0)
      {
         rightMargin += 2;
      }
      if(!bounds)
      {
         xBoundedValues[value] = bounds = new BoundedValue(0,leftMargin,rightMargin);
      }
      else
      {
         bounds.lowerMargin = Math.max(bounds.lowerMargin,leftMargin);
         bounds.upperMargin = Math.max(bounds.upperMargin,rightMargin);
      }
   }
   
   §§namespace("http://www.adobe.com/2006/flex/mx/internal") function storeY(value:*, topMargin:Number = 0, bottomMargin:Number = 0) : void
   {
      var bounds:BoundedValue = null;
      yMap[value] = value;
      if(topMargin != 0 || bottomMargin != 0)
      {
         bounds = yBoundedValues[value];
         if(!bounds)
         {
            yBoundedValues[value] = bounds = new BoundedValue(0,bottomMargin,topMargin);
         }
         else
         {
            bounds.lowerMargin = Math.max(bounds.lowerMargin,bottomMargin);
            bounds.upperMargin = Math.max(bounds.upperMargin,topMargin);
         }
      }
   }
   
   §§namespace("http://www.adobe.com/2006/flex/mx/internal") function y(value:*) : Number
   {
      return Number(yMap[value]);
   }
   
   §§namespace("http://www.adobe.com/2006/flex/mx/internal") function x(value:*) : Number
   {
      return Number(xMap[value]);
   }
}
