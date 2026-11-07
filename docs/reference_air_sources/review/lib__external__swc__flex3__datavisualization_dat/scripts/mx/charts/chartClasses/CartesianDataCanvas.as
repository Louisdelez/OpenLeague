package mx.charts.chartClasses
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import mx.core.IFlexDisplayObject;
   import mx.core.IUIComponent;
   
   [DefaultProperty("dataChildren")]
   public class CartesianDataCanvas extends ChartElement implements IDataCanvas
   {
      
      private var _yMap:Dictionary;
      
      private var borderWidth:Number = 0;
      
      private var _oldUW:Number;
      
      private var _horizontalAxis:IAxis;
      
      private var _bAxesDirty:Boolean = false;
      
      private var _verticalAxis:IAxis;
      
      private var _childMap:Dictionary;
      
      private var _hDataDesc:DataDescription;
      
      private var _vDataDesc:DataDescription;
      
      private var _dataCache:CartesianDataCache;
      
      private var _filterDirty:Boolean = true;
      
      private var _mappingDirty:Boolean = true;
      
      private var _opCodes:Array = [];
      
      private var _data:*;
      
      private var _xMap:Dictionary;
      
      private var _dataChildren:Array = [];
      
      private var _offset:Number;
      
      private var _dataCacheDirty:Boolean = true;
      
      private var _includeInRanges:Boolean = false;
      
      private var _transformDirty:Boolean = true;
      
      private var _oldUH:Number;
      
      public function CartesianDataCanvas()
      {
         super();
         _hDataDesc = new DataDescription();
         _vDataDesc = new DataDescription();
         _childMap = new Dictionary(true);
         dataTransform = new CartesianTransform();
      }
      
      public function curveTo(controlX:*, controlY:*, anchorX:*, anchorY:*) : void
      {
         pushOp(CartesianOpCode.CURVE_TO,{
            "controlX":controlX,
            "controlY":controlY,
            "anchorX":anchorX,
            "anchorY":anchorY,
            "borderWidth":borderWidth
         });
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function dataChildChangeHandler(e:Event) : void
      {
         dataChildren = dataChildren;
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
      
      override public function addChild(child:DisplayObject) : DisplayObject
      {
         var dc:CartesianDataChild = new CartesianDataChild(child);
         _childMap[child] = dc;
         _dataChildren.push(dc);
         dc.addEventListener("change",dataChildChangeHandler,false,0,true);
         invalidateOpCodes();
         return super.addChild(child);
      }
      
      override public function describeData(dimension:String, requiredFields:uint) : Array
      {
         updateMapping();
         var result:Array = [];
         if(_includeInRanges)
         {
            if(dimension == CartesianTransform.VERTICAL_AXIS)
            {
               if(_dataCache.xCache.length > 0)
               {
                  result.push(_vDataDesc);
               }
            }
            else if(dimension == CartesianTransform.HORIZONTAL_AXIS)
            {
               if(_dataCache.yCache.length > 0)
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
      
      private function split(v:*) : void
      {
         if(v is CartesianCanvasValue)
         {
            _data = v.value;
            _offset = v.offset;
            if(isNaN(_offset))
            {
               _offset = 0;
            }
         }
         else
         {
            _data = v;
            _offset = 0;
         }
      }
      
      public function lineStyle(thickness:Number, color:uint = 0, alpha:Number = 1, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3) : void
      {
         borderWidth = thickness;
         pushOp(CartesianOpCode.LINE_STYLE,{
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
      
      override public function localToData(v:Point) : Array
      {
         return dataTransform.invertTransform(v.x - this.x,v.y - this.y);
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
      
      public function drawCircle(x:*, y:*, radius:Number) : void
      {
         pushOp(CartesianOpCode.DRAW_CIRCLE,{
            "x":x,
            "y":y,
            "radius":radius,
            "borderWidth":borderWidth
         });
      }
      
      [Inspectable(category="Data")]
      public function get verticalAxis() : IAxis
      {
         return _verticalAxis;
      }
      
      public function moveTo(x:*, y:*) : void
      {
         pushOp(CartesianOpCode.MOVE_TO,{
            "x":x,
            "y":y,
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
      
      public function drawRect(left:*, top:*, right:*, bottom:*) : void
      {
         pushOp(CartesianOpCode.DRAW_RECT,{
            "left":left,
            "top":top,
            "right":right,
            "bottom":bottom,
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
      
      private function positionChildren() : void
      {
         var aChild:* = undefined;
         var dc:CartesianDataChild = null;
         var left:Number = NaN;
         var right:Number = NaN;
         var top:Number = NaN;
         var bottom:Number = NaN;
         var hCenter:Number = NaN;
         var vCenter:Number = NaN;
         var width:Number = NaN;
         var height:Number = NaN;
         for(aChild in _childMap)
         {
            dc = _childMap[aChild];
            if(dc.horizontalCenter != undefined)
            {
               hCenter = _dataCache.x(data(dc.horizontalCenter)) + offset(dc.horizontalCenter);
               width = widthFor(dc.child);
               left = hCenter - width / 2;
               right = hCenter + width / 2;
            }
            else if(dc.right == undefined)
            {
               left = _dataCache.x(data(dc.left)) + offset(dc.left);
               right = left + widthFor(dc.child);
            }
            else if(dc.left == undefined)
            {
               right = _dataCache.x(data(dc.right)) + offset(dc.right);
               left = right - widthFor(dc.child);
            }
            else
            {
               left = _dataCache.x(data(dc.left)) + offset(dc.left);
               right = _dataCache.x(data(dc.right)) + offset(dc.right);
            }
            if(dc.verticalCenter != undefined)
            {
               vCenter = _dataCache.y(data(dc.verticalCenter)) + offset(dc.verticalCenter);
               height = heightFor(dc.child);
               top = vCenter - height / 2;
               bottom = vCenter + height / 2;
            }
            else if(dc.bottom == undefined)
            {
               top = _dataCache.y(data(dc.top)) + offset(dc.top);
               bottom = top + heightFor(dc.child);
            }
            else if(dc.top == undefined)
            {
               bottom = _dataCache.y(data(dc.bottom)) + offset(dc.bottom);
               top = bottom - heightFor(dc.child);
            }
            else
            {
               top = _dataCache.y(data(dc.top)) + offset(dc.top);
               bottom = _dataCache.y(data(dc.bottom)) + offset(dc.bottom);
            }
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
      
      public function drawRoundedRect(left:*, top:*, right:*, bottom:*, cornerRadius:Number) : void
      {
         pushOp(CartesianOpCode.DRAW_ROUNDRECT,{
            "left":left,
            "top":top,
            "right":right,
            "bottom":bottom,
            "borderWidth":borderWidth,
            "cornerRadius":cornerRadius
         });
      }
      
      public function set verticalAxis(value:IAxis) : void
      {
         _verticalAxis = value;
         _bAxesDirty = true;
         invalidateData();
         invalidateProperties();
      }
      
      private function mapChildren() : void
      {
         var width:Number = NaN;
         var height:Number = NaN;
         var aChild:* = undefined;
         var dc:CartesianDataChild = null;
         for(aChild in _childMap)
         {
            dc = _childMap[aChild];
            if(dc.horizontalCenter != undefined)
            {
               width = widthFor(dc.child);
               split(dc.horizontalCenter);
               _dataCache.storeX(_data,width / 2 - _offset,width / 2 + _offset);
            }
            else if(dc.right == undefined)
            {
               split(dc.left);
               _dataCache.storeX(_data,-_offset,widthFor(dc.child) + _offset);
            }
            else if(dc.left == undefined)
            {
               split(dc.right);
               _dataCache.storeX(_data,widthFor(dc.child) - _offset,_offset);
            }
            else
            {
               split(dc.left);
               _dataCache.storeX(_data,-_offset,_offset);
               split(dc.right);
               _dataCache.storeX(_data,-_offset,_offset);
            }
            if(dc.verticalCenter != undefined)
            {
               height = heightFor(dc.child);
               split(dc.verticalCenter);
               _dataCache.storeY(_data,height / 2 - _offset,height / 2 + _offset);
            }
            else if(dc.bottom == undefined)
            {
               split(dc.top);
               _dataCache.storeY(_data,-_offset,heightFor(dc.child) + _offset);
            }
            else if(dc.top == undefined)
            {
               split(dc.bottom);
               _dataCache.storeY(_data,heightFor(dc.child) - _offset,_offset);
            }
            else
            {
               split(dc.top);
               _dataCache.storeY(_data,-_offset,_offset);
               split(dc.bottom);
               _dataCache.storeY(_data,-_offset,_offset);
            }
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
      
      override public function addChildAt(child:DisplayObject, index:int) : DisplayObject
      {
         var dc:CartesianDataChild = new CartesianDataChild(child);
         _childMap[child] = dc;
         _dataChildren.push(dc);
         dc.addEventListener("change",dataChildChangeHandler,false,0,true);
         invalidateOpCodes();
         return super.addChildAt(child,index);
      }
      
      public function lineTo(x:*, y:*) : void
      {
         pushOp(CartesianOpCode.LINE_TO,{
            "x":x,
            "y":y,
            "borderWidth":borderWidth
         });
      }
      
      public function set dataChildren(value:Array) : void
      {
         var aChild:* = undefined;
         var i:int = 0;
         var dc:CartesianDataChild = null;
         for(aChild in _childMap)
         {
            removeChild(_childMap[aChild].child);
         }
         _childMap = new Dictionary(true);
         _dataChildren = value;
         for(i = 0; i < value.length; i++)
         {
            if(value[i] is CartesianDataChild)
            {
               dc = value[i];
            }
            else
            {
               dc = new CartesianDataChild(value[i]);
            }
            _childMap[dc.child] = dc;
            dc.addEventListener("change",dataChildChangeHandler,false,0,true);
            super.addChild(dc.child);
         }
         invalidateOpCodes();
      }
      
      private function offset(v:*) : *
      {
         if(v is CartesianCanvasValue)
         {
            return v.offset;
         }
         return 0;
      }
      
      private function pushOp(code:int, params:Object = null) : CartesianOpCode
      {
         var op:CartesianOpCode = new CartesianOpCode(this,code,params);
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
         dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).filterCache(_dataCache.yCache,"mappedValue","filteredValue");
         dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).filterCache(_dataCache.xCache,"mappedValue","filteredValue");
         for(var i:int = 0; i < _dataCache.xCache.length; i++)
         {
            if(isNaN(_dataCache.xCache[i].filteredValue))
            {
               delete _dataCache.xMap[_dataCache.xCache[i].value];
            }
         }
         for(i = 0; i < _dataCache.yCache.length; i++)
         {
            if(isNaN(_dataCache.yCache[i].filteredValue))
            {
               delete _dataCache.yMap[_dataCache.yCache[i].value];
            }
         }
         stripNaNs(_dataCache.xCache,"filteredValue");
         stripNaNs(_dataCache.yCache,"filteredValue");
         _filterDirty = false;
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
      
      protected function updateTransform() : Boolean
      {
         var i:int = 0;
         var record:Object = null;
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
            dataTransform.transformCache(_dataCache.yCache,null,null,"mappedValue","pixelValue");
            for(i = 0; i < _dataCache.xCache.length; i++)
            {
               record = _dataCache.xCache[i];
               _dataCache.xMap[record.value] = record.pixelValue;
            }
            for(i = 0; i < _dataCache.yCache.length; i++)
            {
               record = _dataCache.yCache[i];
               _dataCache.yMap[record.value] = record.pixelValue;
            }
         }
         return updated;
      }
      
      private function data(v:*) : *
      {
         if(v is CartesianCanvasValue)
         {
            return v.value;
         }
         return v;
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
      
      [ArrayElementType("CartesianOpCode")]
      private function get opCodes() : Array
      {
         return _opCodes;
      }
      
      [Inspectable(category="General")]
      public function get dataChildren() : Array
      {
         return _dataChildren;
      }
      
      public function beginFill(color:uint, alpha:Number = 1) : void
      {
         pushOp(CartesianOpCode.BEGIN_FILL,{
            "color":color,
            "alpha":alpha
         });
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
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
         var c:CartesianChart = CartesianChart(chart);
         if(Boolean(c))
         {
            if(!_horizontalAxis)
            {
               if(dataTransform.axes[CartesianTransform.HORIZONTAL_AXIS] != c.horizontalAxis)
               {
                  CartesianTransform(dataTransform).setAxis(CartesianTransform.HORIZONTAL_AXIS,c.horizontalAxis);
               }
            }
            if(!_verticalAxis)
            {
               if(dataTransform.axes[CartesianTransform.VERTICAL_AXIS] != c.verticalAxis)
               {
                  CartesianTransform(dataTransform).setAxis(CartesianTransform.VERTICAL_AXIS,c.verticalAxis);
               }
            }
         }
         dataTransform.elements = [this];
         invalidateOpCodes();
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
            _dataCache = new CartesianDataCache();
            for(i = 0; i < _opCodes.length; i++)
            {
               _opCodes[i].collectValues(_dataCache);
            }
            mapChildren();
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
            _dataCacheDirty = false;
            _mappingDirty = true;
         }
         if(_mappingDirty)
         {
            dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).mapCache(_dataCache.yCache,"value","mappedValue",true);
            dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).mapCache(_dataCache.xCache,"value","mappedValue",true);
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
      
      public function updateDataChild(child:DisplayObject, left:* = undefined, top:* = undefined, right:* = undefined, bottom:* = undefined, hCenter:* = undefined, vCenter:* = undefined) : void
      {
         var dc:CartesianDataChild = _childMap[child];
         dc.left = left;
         dc.top = top;
         dc.right = right;
         dc.bottom = bottom;
         dc.horizontalCenter = hCenter;
         dc.verticalCenter = vCenter;
         invalidateOpCodes();
      }
      
      public function set horizontalAxis(value:IAxis) : void
      {
         _horizontalAxis = value;
         _bAxesDirty = true;
         invalidateData();
         invalidateProperties();
      }
      
      public function beginBitmapFill(bitmap:BitmapData, x:* = undefined, y:* = undefined, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = true) : void
      {
         pushOp(CartesianOpCode.BEGIN_BITMAP_FILL,{
            "bitmap":bitmap,
            "x":x,
            "y":y,
            "repeat":repeat,
            "smooth":smooth,
            "matrix":matrix
         });
      }
      
      [Inspectable(category="Data")]
      public function get horizontalAxis() : IAxis
      {
         return _horizontalAxis;
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
      
      public function addDataChild(child:DisplayObject, left:* = undefined, top:* = undefined, right:* = undefined, bottom:* = undefined, hCenter:* = undefined, vCenter:* = undefined) : void
      {
         var dc:CartesianDataChild = new CartesianDataChild(child,left,top,right,bottom);
         dc.addEventListener("change",dataChildChangeHandler,false,0,true);
         addChild(child);
         updateDataChild(child,left,top,right,bottom,hCenter,vCenter);
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
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var i:int = 0;
         var g:Graphics = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         validateData();
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
      
      public function drawEllipse(left:*, top:*, right:*, bottom:*) : void
      {
         pushOp(CartesianOpCode.DRAW_ELLIPSE,{
            "left":left,
            "top":top,
            "right":right,
            "bottom":bottom,
            "borderWidth":borderWidth
         });
      }
      
      public function endFill() : void
      {
         pushOp(CartesianOpCode.END_FILL);
      }
   }
}

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.geom.Matrix;
import flash.utils.Dictionary;
import mx.charts.chartClasses.BoundedValue;
import mx.charts.chartClasses.CartesianCanvasValue;
import mx.charts.chartClasses.CartesianDataCanvas;

class CartesianDataCache
{
   
   public var yMap:Dictionary;
   
   public var xMap:Dictionary;
   
   public var yBoundedValues:Dictionary;
   
   public var xBoundedValues:Dictionary;
   
   public var yCache:Array;
   
   public var xCache:Array;
   
   public function CartesianDataCache()
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
      if(leftMargin < 0)
      {
         leftMargin = 0;
      }
      if(rightMargin < 0)
      {
         rightMargin = 0;
      }
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

class CartesianOpCode
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
   
   private var _data:*;
   
   public var code:int;
   
   private var _offset:Number;
   
   public var canvas:CartesianDataCanvas;
   
   public function CartesianOpCode(canvas:CartesianDataCanvas, code:int, params:Object = null)
   {
      super();
      this.canvas = canvas;
      this.code = code;
      this.params = params == null ? {} : params;
   }
   
   private function offset(v:*) : *
   {
      if(v is CartesianCanvasValue)
      {
         return v.offset;
      }
      return 0;
   }
   
   private function data(v:*) : *
   {
      if(v is CartesianCanvasValue)
      {
         return v.value;
      }
      return v;
   }
   
   §§namespace("http://www.adobe.com/2006/flex/mx/internal") function render(target:CartesianDataCanvas, cache:CartesianDataCache) : void
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
      var m:Matrix = null;
      var d:* = undefined;
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
            d = data(params.x);
            if(d != undefined)
            {
               m.tx = cache.x(d);
            }
            m.tx += offset(params.x);
            d = data(params.y);
            if(d != undefined)
            {
               m.ty = cache.y(d);
            }
            m.ty += offset(params.y);
            g.beginBitmapFill(params.bitmap,m,params.repeat,params.smooth);
            break;
         case BEGIN_FILL:
            g.beginFill(params.color,params.alpha);
            break;
         case CURVE_TO:
            controlX = cache.x(data(params.controlX)) + offset(params.controlX);
            controlY = cache.y(data(params.controlY)) + offset(params.controlY);
            anchorX = cache.x(data(params.anchorX)) + offset(params.anchorX);
            anchorY = cache.y(data(params.anchorY)) + offset(params.anchorY);
            if(isNaN(controlX) || isNaN(controlY) || isNaN(anchorX) || isNaN(anchorY))
            {
               return;
            }
            g.curveTo(controlX,controlY,anchorX,anchorY);
            break;
         case DRAW_CIRCLE:
            x = cache.x(data(params.x)) + offset(params.x);
            y = cache.y(data(params.y)) + offset(params.y);
            if(isNaN(x) || isNaN(y))
            {
               return;
            }
            g.drawCircle(x,y,params.radius);
            break;
         case DRAW_ELLIPSE:
            left = cache.x(data(params.left)) + offset(params.left);
            top = cache.y(data(params.top)) + offset(params.top);
            right = cache.x(data(params.right)) + offset(params.right);
            bottom = cache.y(data(params.bottom)) + offset(params.bottom);
            if(isNaN(left) || isNaN(top) || isNaN(right) || isNaN(bottom))
            {
               return;
            }
            g.drawEllipse(left,top,right - left,bottom - top);
            break;
         case DRAW_RECT:
            left = cache.x(data(params.left)) + offset(params.left);
            top = cache.y(data(params.top)) + offset(params.top);
            right = cache.x(data(params.right)) + offset(params.right);
            bottom = cache.y(data(params.bottom)) + offset(params.bottom);
            if(isNaN(left) || isNaN(top) || isNaN(right) || isNaN(bottom))
            {
               return;
            }
            g.drawRect(left,top,right - left,bottom - top);
            break;
         case DRAW_ROUNDRECT:
            left = cache.x(data(params.left)) + offset(params.left);
            top = cache.y(data(params.top)) + offset(params.top);
            right = cache.x(data(params.right)) + offset(params.right);
            bottom = cache.y(data(params.bottom)) + offset(params.bottom);
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
            x = cache.x(data(params.x)) + offset(params.x);
            y = cache.y(data(params.y)) + offset(params.y);
            if(isNaN(x) || isNaN(y))
            {
               return;
            }
            g.moveTo(x,y);
            break;
         case LINE_TO:
            x = cache.x(data(params.x)) + offset(params.x);
            y = cache.y(data(params.y)) + offset(params.y);
            if(isNaN(x) || isNaN(y))
            {
               return;
            }
            g.lineTo(x,y);
      }
   }
   
   private function split(v:*) : void
   {
      if(v is CartesianCanvasValue)
      {
         _data = v.value;
         _offset = v.offset;
         if(isNaN(_offset))
         {
            _offset = 0;
         }
      }
      else
      {
         _data = v;
         _offset = 0;
      }
   }
   
   §§namespace("http://www.adobe.com/2006/flex/mx/internal") function collectValues(cache:CartesianDataCache) : void
   {
      switch(code)
      {
         case BEGIN_BITMAP_FILL:
            split(params.x);
            if(_data != undefined)
            {
               cache.storeX(_data,-_offset,_offset);
            }
            split(params.y);
            if(_data != undefined)
            {
               cache.storeY(_data,-_offset,_offset);
            }
            break;
         case CURVE_TO:
            split(params.anchorX);
            cache.storeX(_data,-_offset + params.borderWidth / 2,_offset + params.borderWidth / 2);
            split(params.anchorY);
            cache.storeY(_data,-_offset + params.borderWidth / 2,_offset + params.borderWidth / 2);
            split(params.controlX);
            cache.storeX(_data,-_offset + params.borderWidth / 2,_offset + params.borderWidth / 2);
            split(params.controlY);
            cache.storeY(_data,-_offset + params.borderWidth / 2,_offset + params.borderWidth / 2);
            break;
         case DRAW_CIRCLE:
            split(params.x);
            cache.storeX(_data,-_offset + params.borderWidth / 2,_offset + params.borderWidth / 2);
            split(params.y);
            cache.storeY(_data,-_offset + params.borderWidth / 2,_offset + params.borderWidth / 2);
            break;
         case MOVE_TO:
         case LINE_TO:
            split(params.x);
            cache.storeX(_data,-_offset + params.borderWidth / 2,_offset + params.borderWidth / 2);
            split(params.y);
            cache.storeY(_data,-_offset + params.borderWidth / 2,_offset + params.borderWidth / 2);
            break;
         case DRAW_ELLIPSE:
            split(params.left);
            cache.storeX(_data,-_offset + params.borderWidth / 2,_offset + params.borderWidth / 2);
            split(params.top);
            cache.storeY(_data,-_offset + params.borderWidth / 2,_offset + params.borderWidth / 2);
            split(params.right);
            cache.storeX(_data,-_offset + params.borderWidth / 2,_offset + params.borderWidth / 2);
            split(params.bottom);
            cache.storeY(_data,-_offset + params.borderWidth / 2,_offset + params.borderWidth / 2);
            break;
         case DRAW_RECT:
            split(params.left);
            cache.storeX(_data,-_offset + params.borderWidth / 2,_offset + params.borderWidth / 2);
            split(params.top);
            cache.storeY(_data,-_offset + params.borderWidth / 2,_offset + params.borderWidth / 2);
            split(params.right);
            cache.storeX(_data,-_offset + params.borderWidth / 2,_offset + params.borderWidth / 2);
            split(params.bottom);
            cache.storeY(_data,-_offset + params.borderWidth / 2,_offset + params.borderWidth / 2);
            break;
         case DRAW_ROUNDRECT:
            split(params.left);
            cache.storeX(_data,-_offset + params.borderWidth / 2,_offset + params.borderWidth / 2);
            split(params.top);
            cache.storeY(_data,-_offset + params.borderWidth / 2,_offset + params.borderWidth / 2);
            split(params.right);
            cache.storeX(_data,-_offset + params.borderWidth / 2,_offset + params.borderWidth / 2);
            split(params.bottom);
            cache.storeY(_data,-_offset + params.borderWidth / 2,_offset + params.borderWidth / 2);
      }
   }
}

[Event("change")]
[DefaultProperty("content")]
class CartesianDataChild extends EventDispatcher
{
   
   public var right:*;
   
   public var left:*;
   
   public var bottom:*;
   
   public var top:*;
   
   public var horizontalCenter:*;
   
   public var verticalCenter:*;
   
   public var child:DisplayObject;
   
   public function CartesianDataChild(child:DisplayObject = null, left:* = undefined, top:* = undefined, right:* = undefined, bottom:* = undefined, horizontalCenter:* = undefined, verticalCenter:* = undefined)
   {
      super();
      this.child = child;
      this.left = left;
      this.top = top;
      this.bottom = bottom;
      this.right = right;
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
