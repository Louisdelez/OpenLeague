package mx.charts.chartClasses
{
   import flash.display.DisplayObject;
   import flash.events.KeyboardEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import mx.charts.ChartItem;
   import mx.charts.LinearAxis;
   import mx.charts.events.ChartItemEvent;
   import mx.charts.styles.HaloDefaults;
   import mx.core.IUIComponent;
   import mx.graphics.SolidColor;
   import mx.graphics.Stroke;
   import mx.styles.CSSStyleDeclaration;
   
   public class PolarChart extends ChartBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var stylesInited:Boolean = initStyles();
      
      private var _angularAxis:IAxis;
      
      private var axisLayoutDirty:Boolean = true;
      
      private var _axisDirty:Boolean = false;
      
      public function PolarChart()
      {
         super();
         transforms = [new PolarTransform()];
         var aa:LinearAxis = new LinearAxis();
         aa.autoAdjust = false;
         angularAxis = aa;
      }
      
      private static function initStyles() : Boolean
      {
         var polarChartStyle:CSSStyleDeclaration;
         HaloDefaults.init();
         polarChartStyle = HaloDefaults.createSelector("PolarChart");
         polarChartStyle.defaultFactory = function():void
         {
            this.dataTipRenderer = DataTip;
            this.fill = new SolidColor(16777215,0);
            this.calloutStroke = new Stroke(8947848,2);
            this.fontSize = 10;
         };
         return true;
      }
      
      [Inspectable(category="Data")]
      public function get radialAxis() : IAxis
      {
         return _transforms[0].getAxis(PolarTransform.RADIAL_AXIS);
      }
      
      [Inspectable(category="Data")]
      public function get angularAxis() : IAxis
      {
         return _angularAxis;
      }
      
      private function calcAngle(x:Number, y:Number) : Number
      {
         var angle:Number = NaN;
         var twoMP:Number = Math.PI * 2;
         var at:Number = Math.atan(-y / x);
         if(x < 0)
         {
            angle = at + Math.PI;
         }
         else if(y < 0)
         {
            angle = at;
         }
         else
         {
            angle = at + twoMP;
         }
         return angle;
      }
      
      public function set angularAxis(value:IAxis) : void
      {
         _transforms[0].setAxis(PolarTransform.ANGULAR_AXIS,value);
         _angularAxis = value;
         _axisDirty = true;
         invalidateData();
         invalidateProperties();
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
            event.stopPropagation();
            handleNavigation(item,event);
         }
      }
      
      override protected function commitProperties() : void
      {
         var i:int = 0;
         var h:Object = null;
         super.commitProperties();
         if(_axisDirty == true)
         {
            for(i = 0; i < series.length; i++)
            {
               series[i].invalidateProperties();
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
            _axisDirty = false;
         }
      }
      
      [Deprecated(replacement="IChartElement2.dataToLocal()")]
      override public function dataToLocal(... dataValues) : Point
      {
         var data:Object = {};
         var da:Array = [data];
         var len:int = int(dataValues.length);
         if(len > 0)
         {
            data["d0"] = dataValues[0];
            _transforms[0].getAxis(PolarTransform.ANGULAR_AXIS).mapCache(da,"d0","v0");
         }
         if(len > 1)
         {
            data["d1"] = dataValues[1];
            _transforms[0].getAxis(PolarTransform.RADIAL_AXIS).mapCache(da,"d1","v1");
         }
         _transforms[0].transformCache(da,"v0","s0","v1","s1");
         return new Point(_transforms[0].origin.x + Math.cos(data.s0) * data.s1,_transforms[0].origin.y - Math.sin(data.s0) * data.s1);
      }
      
      public function set radialAxis(value:IAxis) : void
      {
         _transforms[0].setAxis(PolarTransform.RADIAL_AXIS,value);
         _axisDirty = true;
         invalidateData();
         invalidateProperties();
      }
      
      [Deprecated(replacement="IChartElement2.localToData()")]
      override public function localToData(v:Point) : Array
      {
         var dx:Number = v.x - _transforms[0].origin.x;
         var dy:Number = v.y - _transforms[0].origin.y;
         var a:Number = calcAngle(dx,dy);
         var r:Number = Math.sqrt(dx * dx + dy * dy);
         return _transforms[0].invertTransform(a,r);
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
            item = getNextSeriesItem(series);
         }
         return item;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var i:int = 0;
         var c:DisplayObject = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         _angularAxis.getLabelEstimate();
         var paddingLeft:Number = Number(getStyle("paddingLeft"));
         var paddingRight:Number = Number(getStyle("paddingRight"));
         var paddingTop:Number = Number(getStyle("paddingTop"));
         var paddingBottom:Number = Number(getStyle("paddingBottom"));
         var rcElements:Rectangle = new Rectangle(paddingLeft,paddingTop,unscaledWidth - paddingLeft - paddingRight,unscaledHeight - paddingTop - paddingBottom);
         for(i = 0; i < _transforms.length; i++)
         {
            _transforms[i].setSize(rcElements.width,rcElements.height);
         }
         var n:int = int(allElements.length);
         for(i = 0; i < n; i++)
         {
            c = allElements[i];
            if(c is IUIComponent)
            {
               (c as IUIComponent).setActualSize(rcElements.width,rcElements.height);
            }
            else
            {
               c.width = rcElements.width;
               c.height = rcElements.height;
            }
            if(c is Series)
            {
               PolarTransform((c as Series).dataTransform).setSize(rcElements.width,rcElements.height);
            }
            if(c is IDataCanvas)
            {
               PolarTransform((c as Object).dataTransform).setSize(rcElements.width,rcElements.height);
            }
         }
         if(Boolean(_seriesHolder.mask))
         {
            _seriesHolder.mask.width = rcElements.width;
            _seriesHolder.mask.height = rcElements.height;
         }
         if(Boolean(_backgroundElementHolder.mask))
         {
            _backgroundElementHolder.mask.width = rcElements.width;
            _backgroundElementHolder.mask.height = rcElements.height;
         }
         if(Boolean(_annotationElementHolder.mask))
         {
            _annotationElementHolder.mask.width = rcElements.width;
            _annotationElementHolder.mask.height = rcElements.height;
         }
         _seriesHolder.move(rcElements.left,rcElements.top);
         _backgroundElementHolder.move(rcElements.left,rcElements.top);
         _annotationElementHolder.move(rcElements.left,rcElements.top);
         axisLayoutDirty = false;
         advanceEffectState();
      }
      
      override public function getPreviousItem(direction:String) : ChartItem
      {
         if(direction == ChartBase.HORIZONTAL)
         {
            return getPreviousSeriesItem(series);
         }
         if(direction == ChartBase.VERTICAL)
         {
            return getPreviousSeries(series);
         }
         return null;
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
         for(i = 0; i < series.length; i++)
         {
            arrItems = series[i].items;
            if(Boolean(arrItems) && series[i].selectedItems.length > 0)
            {
               bExistingSelection = true;
               for(j = 0; j < arrItems.length; j++)
               {
                  arrObjects.push(arrItems[j].item);
               }
               nCount += series[i].selectedItems.length;
               for(j = 0; j < series[i].selectedItems.length; j++)
               {
                  index = arrObjects.indexOf(series[i].selectedItems[j].item);
                  if(index != -1)
                  {
                     arrSelect.push(series[i].items[index]);
                  }
               }
               arrObjects = [];
               series[i].emptySelectedItems();
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
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function handleShift(item:ChartItem) : void
      {
         var anchorSeries:Series = Series(_anchorItem.element);
         var itemSeries:Series = Series(item.element);
         if(anchorSeries != itemSeries)
         {
            return;
         }
         var index1:int = anchorSeries.items.indexOf(_anchorItem);
         var index2:int = itemSeries.items.indexOf(item);
         var len:int = int(anchorSeries.items.length);
         if(index1 > index2)
         {
            index1 = 0;
            index2 = len - 1;
         }
         var temp:ChartItem = _anchorItem;
         clearSelection();
         _anchorItem = temp;
         for(var i:int = index1; i <= index2; i++)
         {
            anchorSeries.addItemtoSelection(anchorSeries.items[i]);
         }
         _selectedSeries = anchorSeries;
         _caretItem = item;
      }
      
      override public function getNextItem(direction:String) : ChartItem
      {
         if(direction == ChartBase.HORIZONTAL)
         {
            return getNextSeriesItem(series);
         }
         if(direction == ChartBase.VERTICAL)
         {
            return getNextSeries(series);
         }
         return null;
      }
      
      override protected function get dataRegion() : Rectangle
      {
         return getBounds(this);
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
            item = getPreviousSeriesItem(series);
         }
         return item;
      }
   }
}

