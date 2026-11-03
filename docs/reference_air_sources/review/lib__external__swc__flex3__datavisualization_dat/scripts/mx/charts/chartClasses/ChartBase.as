package mx.charts.chartClasses
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.*;
   import mx.charts.ChartItem;
   import mx.charts.HitData;
   import mx.charts.events.ChartEvent;
   import mx.charts.events.ChartItemEvent;
   import mx.charts.styles.HaloDefaults;
   import mx.collections.ArrayCollection;
   import mx.collections.ICollectionView;
   import mx.collections.IList;
   import mx.collections.ListCollectionView;
   import mx.collections.XMLListCollection;
   import mx.core.DragSource;
   import mx.core.EventPriority;
   import mx.core.FlexShape;
   import mx.core.IDataRenderer;
   import mx.core.IFlexDisplayObject;
   import mx.core.IUIComponent;
   import mx.core.UIComponent;
   import mx.effects.Parallel;
   import mx.effects.effectClasses.ParallelInstance;
   import mx.events.DragEvent;
   import mx.events.EffectEvent;
   import mx.graphics.IFill;
   import mx.graphics.IStroke;
   import mx.graphics.SolidColor;
   import mx.graphics.Stroke;
   import mx.managers.DragManager;
   import mx.managers.IFocusManagerComponent;
   import mx.managers.ILayoutManagerClient;
   import mx.styles.CSSStyleDeclaration;
   
   [DefaultProperty("dataProvider")]
   [Style(name="showDataTipTargets",type="Boolean",inherit="no")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no")]
   [Style(name="maximumDataTipCount",type="int",inherit="no")]
   [Style(name="fill",type="mx.graphics.IFill",inherit="no")]
   [Style(name="dataTipRenderer",type="Class",inherit="no")]
   [Style(name="dataTipCalloutStroke",type="mx.graphics.IStroke",inherit="no")]
   [Style(name="itemDisabledColor",type="uint",format="Color",inherit="yes")]
   [Style(name="itemRollOverColor",type="uint",format="Color",inherit="yes")]
   [Style(name="itemSelectionColor",type="uint",format="Color",inherit="yes")]
   [Style(name="chartSeriesStyles",type="Array",arrayType="String",inherit="no")]
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
   [Style(name="paddingRight",type="Number",format="Length",inherit="no")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no")]
   [Event(name="change",type="mx.charts.events.ChartItemEvent")]
   [Event(name="itemMouseMove",type="mx.charts.events.ChartItemEvent")]
   [Event(name="itemRollOut",type="mx.charts.events.ChartItemEvent")]
   [Event(name="itemRollOver",type="mx.charts.events.ChartItemEvent")]
   [Event(name="itemMouseUp",type="mx.charts.events.ChartItemEvent")]
   [Event(name="itemMouseDown",type="mx.charts.events.ChartItemEvent")]
   [Event(name="itemDoubleClick",type="mx.charts.events.ChartItemEvent")]
   [Event(name="itemClick",type="mx.charts.events.ChartItemEvent")]
   [Event(name="chartDoubleClick",type="mx.charts.events.ChartEvent")]
   [Event(name="chartClick",type="mx.charts.events.ChartEvent")]
   public class ChartBase extends UIComponent implements IFocusManagerComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var stylesInited:Boolean = initStyles();
      
      private static const TOOLTIP_TARGET_INNER_RADIUS:Number = 1.5;
      
      private static const TOOLTIP_TARGET_RADIUS:Number = 4.5;
      
      private static var ITEM_EVENTS:Object = {
         "chartClick":true,
         "chartDoubleClick":true,
         "itemClick":true,
         "itemDoubleClick":true,
         "itemMouseDown":true,
         "itemMouseUp":true,
         "itemMouseMove":true,
         "itemRollOver":true,
         "itemRollOut":true
      };
      
      public static const HORIZONTAL:String = "H";
      
      public static const VERTICAL:String = "V";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const DRAG_THRESHOLD:int = 4;
      
      private var _allDataTipOverlay:Shape;
      
      private var _transitionState:uint = 0;
      
      protected var labelElements:Array = [];
      
      private var _dataTipMode:String = "multiple";
      
      private var dRight:Number = 0;
      
      private var _dragMoveEnabled:Boolean = false;
      
      protected var _transforms:Array;
      
      private var _description:String = "";
      
      public var dataTipItemsSet:Boolean = false;
      
      private var dTop:Number = 0;
      
      private var _annotationElementMask:Shape;
      
      private var tX:Number;
      
      private var tY:Number;
      
      private var dLeft:Number = 0;
      
      private var _seriesStylesDirty:Boolean = true;
      
      private var _mouseEventsInitialzed:Boolean = false;
      
      private var _dataTipOverlay:Shape;
      
      private var _mouseDownItem:ChartItem = null;
      
      private var _allTipCache:InstanceCache;
      
      private var _currentHitSet:Array;
      
      public var mouseSensitivity:Number = 5;
      
      private var rangeItemRenderer:RangeSelector = null;
      
      protected var _seriesHolder:UIComponent;
      
      private var _backgroundElements:Array = [];
      
      private var _backgroundElementMask:Shape;
      
      private var _tipCache:InstanceCache;
      
      protected var _anchorItem:ChartItem = null;
      
      private var _mouseDownPoint:Point = null;
      
      private var _commitPropertiesCalled:Boolean = false;
      
      protected var _selectedSeries:Series = null;
      
      private var _childOrderDirty:Boolean = false;
      
      private var _rangeEventsInitialzed:Boolean = false;
      
      private var _showAllDataTips:Boolean = false;
      
      private var _selectionMode:String = "none";
      
      private var _clipContent:Boolean = true;
      
      private var _mouseDown:Boolean = false;
      
      private var dataRegionForRange:Rectangle = null;
      
      [Inspectable(category="Data")]
      public var dataTipFunction:Function;
      
      private var _dropEnabled:Boolean = false;
      
      protected var _annotationElementHolder:UIComponent;
      
      private var _dataProvider:ICollectionView;
      
      private var _seriesMask:Shape;
      
      private var _bDataDirty:Boolean = false;
      
      private var _transitionEffect:ParallelInstance;
      
      private var _dragEnabled:Boolean = false;
      
      private var dBottom:Number = 0;
      
      protected var _caretItem:ChartItem = null;
      
      private var _bSeriesDirty:Boolean = false;
      
      protected var allElements:Array = [];
      
      private var _userSeries:Array = [];
      
      protected var _seriesFilterer:UIComponent;
      
      private var _annotationElements:Array = [];
      
      protected var _backgroundElementHolder:UIComponent;
      
      private var _showDataTips:Boolean = false;
      
      public function ChartBase()
      {
         var g:Graphics = null;
         super();
         tabEnabled = false;
         _seriesHolder = new UIComponent();
         _seriesFilterer = new UIComponent();
         _seriesHolder.addChild(_seriesFilterer);
         addChild(_seriesHolder);
         _backgroundElementHolder = new UIComponent();
         addChild(_backgroundElementHolder);
         _annotationElementHolder = new UIComponent();
         addChild(_annotationElementHolder);
         _dataTipOverlay = new FlexShape();
         _dataTipOverlay.name = "dataTipOverlay";
         addChild(_dataTipOverlay);
         _allDataTipOverlay = new FlexShape();
         _allDataTipOverlay.name = "allDataTipOverlay";
         addChild(_allDataTipOverlay);
         _seriesMask = new FlexShape();
         _seriesMask.name = "seriesMask";
         g = _seriesMask.graphics;
         g.clear();
         g.beginFill(0,100);
         g.drawRect(0,0,10,10);
         g.endFill();
         _seriesMask.visible = false;
         _backgroundElementMask = new FlexShape();
         _backgroundElementMask.name = "backgroundElementMask";
         g = _backgroundElementMask.graphics;
         g.clear();
         g.beginFill(0,100);
         g.drawRect(0,0,10,10);
         g.endFill();
         _backgroundElementMask.visible = false;
         _annotationElementMask = new FlexShape();
         _annotationElementMask.name = "annotationElementMask";
         g = _annotationElementMask.graphics;
         g.clear();
         g.beginFill(0,100);
         g.drawRect(0,0,10,10);
         g.endFill();
         _annotationElementMask.visible = false;
         _seriesHolder.addChild(_seriesMask);
         _seriesHolder.mask = _seriesMask;
         _backgroundElementHolder.addChild(_backgroundElementMask);
         _backgroundElementHolder.mask = _backgroundElementMask;
         _annotationElementHolder.addChild(_annotationElementMask);
         _annotationElementHolder.mask = _annotationElementMask;
         _currentHitSet = [];
         invalidateChildOrder();
      }
      
      private static function initStyles() : Boolean
      {
         var selector:CSSStyleDeclaration;
         var chartBaseFill:IFill = null;
         HaloDefaults.init();
         chartBaseFill = IFill(new SolidColor(16777215,0));
         selector = HaloDefaults.createSelector("ChartBase");
         selector.defaultFactory = function():void
         {
            this.chartSeriesStyles = HaloDefaults.chartBaseChartSeriesStyles;
            this.fill = chartBaseFill;
            this.calloutStroke = new Stroke(8947848,2);
            this.dataTipRenderer = DataTip;
            this.fontSize = 10;
         };
         return true;
      }
      
      private function mouseOverHandler(event:MouseEvent) : void
      {
         var n:int = 0;
         var i:int = 0;
         var ti:IFlexDisplayObject = null;
         var p:Point = null;
         var hitPoints:Array = null;
         if(Boolean(_tipCache))
         {
            n = _tipCache.count;
            for(i = 0; i < n; i++)
            {
               ti = _tipCache.instances[i];
               if(event.target == ti || ti is DisplayObjectContainer && (ti as DisplayObjectContainer).contains(event.target as DisplayObject))
               {
                  return;
               }
               if(Boolean(event.relatedObject) && (ti == event.relatedObject || ti is DisplayObjectContainer && (ti as DisplayObjectContainer).contains(event.relatedObject)))
               {
                  return;
               }
            }
         }
         if(!event.relatedObject || event.relatedObject != this && !contains(event.relatedObject))
         {
            p = new Point(event.localX,event.localY);
            p = globalToLocal(DisplayObject(event.target).localToGlobal(p));
            hitPoints = findDataPoints(p.x,p.y);
            processRollEvents(hitPoints,event);
         }
      }
      
      public function hideDropFeedback(event:DragEvent) : void
      {
         drawFocus(false);
      }
      
      public function dragStartHandler(event:DragEvent) : void
      {
         if(event.isDefaultPrevented())
         {
            return;
         }
         var dragSource:DragSource = new DragSource();
         addDragData(dragSource);
         var proxyOrigin:Point = event.target.localToGlobal(new Point(event.localX,event.localY));
         proxyOrigin = globalToLocal(proxyOrigin);
         var xOffset:Number = -(proxyOrigin.x - event.localX);
         var yOffset:Number = -(proxyOrigin.y - event.localY);
         DragManager.doDrag(this,dragSource,event,dragImage,xOffset,yOffset,0.5,dragMoveEnabled);
      }
      
      protected function dragOverHandler(event:DragEvent) : void
      {
         if(event.isDefaultPrevented())
         {
            return;
         }
         if(event.dragSource.hasFormat("chartitems"))
         {
            DragManager.showFeedback(event.ctrlKey ? DragManager.COPY : DragManager.MOVE);
            showDropFeedback(event);
            return;
         }
         hideDropFeedback(event);
         DragManager.showFeedback(DragManager.NONE);
      }
      
      public function set clipContent(value:Boolean) : void
      {
         if(_clipContent == value)
         {
            return;
         }
         _clipContent = value;
         _seriesHolder.mask = _clipContent ? _seriesMask : null;
         _backgroundElementHolder.mask = _clipContent ? _backgroundElementMask : null;
         _annotationElementHolder.mask = _clipContent ? _annotationElementMask : null;
      }
      
      [Deprecated(replacement="Series.getAxis()")]
      public function getAxis(dimension:String) : IAxis
      {
         return transforms[0].getAxis(dimension);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function updateData() : void
      {
         if(_dataProvider != null)
         {
            applyDataProvider(_dataProvider,_transforms[0]);
         }
         var len:uint = series.length;
         for(var i:int = 0; i < len; i++)
         {
            applyDataProvider(ICollectionView(dataProvider),series[i].dataTransform);
         }
      }
      
      public function hideData() : void
      {
         if(Boolean(_transitionEffect))
         {
            setChartState(ChartState.NONE);
            _transitionEffect.end();
            _transitionEffect = null;
         }
         setChartState(ChartState.PREPARING_TO_HIDE_DATA);
      }
      
      public function getNextItem(direction:String) : ChartItem
      {
         return null;
      }
      
      [Inspectable(category="Data",defaultValue="false")]
      public function get showDataTips() : Boolean
      {
         return _showDataTips;
      }
      
      [Deprecated(replacement="IChartElement2.localToData()")]
      public function localToData(pt:Point) : Array
      {
         return null;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function seriesSelectionChanged(seriesObject:Series, arrItems:Array) : void
      {
         var nextSeries:Series = null;
         var i:int = 0;
         if(_selectionMode == "none")
         {
            return;
         }
         if(!_selectedSeries)
         {
            setChartItemsToDisabled();
         }
         else
         {
            seriesObject.clearSeriesItemsState(true,ChartItem.DISABLED);
         }
         if(arrItems.length == 0)
         {
            nextSeries = getSelectedSeries(seriesObject);
            if(!nextSeries)
            {
               clearSelection();
            }
            else
            {
               _selectedSeries = nextSeries;
            }
         }
         else
         {
            if(_selectionMode == "single")
            {
               if(Boolean(_selectedSeries) && _selectedSeries != seriesObject)
               {
                  _selectedSeries.removeItemfromSelection(_selectedSeries.selectedItem);
               }
               seriesObject.addItemtoSelection(arrItems[arrItems.length - 1]);
            }
            else
            {
               for(i = 0; i < arrItems.length; i++)
               {
                  seriesObject.addItemtoSelection(arrItems[i]);
               }
            }
            _selectedSeries = seriesObject;
         }
         if(Boolean(_selectedSeries))
         {
            _caretItem = _selectedSeries.selectedItem;
            _caretItem.currentState = ChartItem.FOCUSEDSELECTED;
            _anchorItem = _caretItem;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function selectItem(item:ChartItem, event:MouseEvent) : void
      {
         var id:int = 0;
         var nextSeries:Series = null;
         var seriesObject:Series = null;
         var bSelectionChanged:Boolean = false;
         var bAddToSelection:Boolean = false;
         var index:int = -1;
         seriesObject = Series(item.element);
         if(event.shiftKey && Boolean(_anchorItem))
         {
            handleShift(item);
            bSelectionChanged = true;
            if(seriesObject.selectedItems.length > 1)
            {
               id = seriesObject.selectedItems.indexOf(item);
               seriesObject.selectedItems.splice(id,1);
               seriesObject.selectedItems.push(item);
               _selectedSeries = seriesObject;
            }
         }
         else if(_selectionMode != "none" && seriesObject.selectable)
         {
            if(seriesObject.selectedItems.indexOf(item) == -1)
            {
               bAddToSelection = true;
            }
            if(bAddToSelection)
            {
               if(!_selectedSeries)
               {
                  setChartItemsToDisabled();
               }
               else if(_selectionMode == "single")
               {
                  if(selectedChartItems.length > 1)
                  {
                     clearSelection();
                     setChartItemsToDisabled();
                  }
                  else
                  {
                     _selectedSeries.removeItemfromSelection(_selectedSeries.selectedItem);
                  }
               }
               else if(!event.ctrlKey)
               {
                  clearSelection();
                  setChartItemsToDisabled();
               }
               seriesObject.addItemtoSelection(item);
               _selectedSeries = seriesObject;
               bSelectionChanged = true;
            }
            else if(_selectionMode == "multiple")
            {
               if(event.ctrlKey)
               {
                  seriesObject.removeItemfromSelection(item);
                  if(_selectedSeries.selectedItems.length == 0)
                  {
                     nextSeries = seriesObject;
                     nextSeries = getSelectedSeries(seriesObject);
                     if(!nextSeries)
                     {
                        clearSelection();
                     }
                     else
                     {
                        _selectedSeries = nextSeries;
                     }
                  }
                  bSelectionChanged = true;
               }
               else if(seriesObject == _selectedSeries && !getSelectedSeries(seriesObject) && _selectedSeries.selectedItems.length == 1)
               {
                  bSelectionChanged = false;
               }
               else
               {
                  clearSelection();
                  setChartItemsToDisabled();
                  seriesObject.addItemtoSelection(item);
                  _selectedSeries = seriesObject;
                  bSelectionChanged = true;
               }
               item.currentState = ChartItem.ROLLOVER;
            }
            else
            {
               if(selectedChartItems.length > 1)
               {
                  clearSelection();
                  seriesObject.addItemtoSelection(item);
               }
               _selectedSeries = seriesObject;
            }
         }
         if(bSelectionChanged)
         {
            if(Boolean(_selectedSeries))
            {
               if(Boolean(_caretItem))
               {
                  if(Series(_caretItem.element).selectedItems.indexOf(_caretItem) != -1)
                  {
                     _caretItem.currentState = ChartItem.SELECTED;
                  }
                  else
                  {
                     _caretItem.currentState = ChartItem.DISABLED;
                  }
               }
               _caretItem = _selectedSeries.selectedItem;
               _caretItem.currentState = ChartItem.FOCUSEDSELECTED;
               if(!_anchorItem || !event.shiftKey)
               {
                  _anchorItem = _caretItem;
               }
            }
            dispatchEvent(new ChartItemEvent(ChartItemEvent.CHANGE,null,event,this));
         }
      }
      
      private function dataEffectEndHandler(event:EffectEvent) : void
      {
         event.target.removeEventListener(EffectEvent.EFFECT_END,dataEffectEndHandler);
         if(chartState == ChartState.HIDING_DATA)
         {
            setChartState(ChartState.PREPARING_TO_SHOW_DATA);
         }
         else
         {
            setChartState(ChartState.NONE);
         }
         _transitionEffect = null;
         invalidateDisplayList();
      }
      
      private function collectTransitions() : Array
      {
         var g:IChartElement = null;
         var a:Array = [];
         var n:int = int(allElements.length);
         for(var i:int = 0; i < n; i++)
         {
            g = allElements[i] as IChartElement;
            if(Boolean(g))
            {
               g.collectTransitions(_transitionState,a);
            }
         }
         return a;
      }
      
      protected function dragCompleteHandler(event:DragEvent) : void
      {
         _mouseDown = false;
         _mouseDownItem = null;
         _mouseDownPoint = null;
         if(event.isDefaultPrevented())
         {
            return;
         }
      }
      
      public function updateAllDataTips() : void
      {
         var hitSet:Array = null;
         var i:int = 0;
         var tipClass:* = undefined;
         var currentHitData:HitData = null;
         var tipInstance:IFlexDisplayObject = null;
         if(!showAllDataTips && !dataTipItemsSet)
         {
            hitSet = [];
         }
         else
         {
            hitSet = getAllDataPoints();
         }
         var tipCount:Number = hitSet.length;
         if(tipCount == 0)
         {
            if(Boolean(_allTipCache))
            {
               _allTipCache.count = 0;
            }
         }
         else
         {
            if(!_allTipCache)
            {
               tipClass = getStyle("dataTipRenderer");
               _allTipCache = new InstanceCache(tipClass,this);
               _allTipCache.discard = true;
               _allTipCache.remove = true;
            }
            _allTipCache.count = tipCount;
            for(i = 0; i < tipCount; i++)
            {
               currentHitData = hitSet[i];
               tipInstance = _allTipCache.instances[i];
               if(dataTipFunction != null)
               {
                  currentHitData.dataTipFunction = invokeDTFunction;
               }
               if(tipInstance is IDataRenderer)
               {
                  (tipInstance as IDataRenderer).data = currentHitData;
               }
            }
         }
         positionAllDataTips(hitSet);
      }
      
      public function set showDataTips(value:Boolean) : void
      {
         if(_showDataTips == value)
         {
            return;
         }
         _showDataTips = value;
         if(_showDataTips)
         {
            if(_mouseEventsInitialzed == false)
            {
               setupMouseDispatching();
            }
         }
         updateDataTips();
      }
      
      public function getLastItem(direction:String) : ChartItem
      {
         return null;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setDescription(value:String) : void
      {
         _description = value;
      }
      
      [Inspectable(arrayType="mx.charts.chartClasses.ChartElement")]
      public function get backgroundElements() : Array
      {
         return _backgroundElements;
      }
      
      private function setupRangeDispatching() : void
      {
         _rangeEventsInitialzed = true;
         addEventListener(RangeEvent.REGION_CHANGE,regionChangeHandler);
      }
      
      protected function positionDataTips() : void
      {
         var pData:Array = null;
         var i:int = 0;
         var data:TipPositionData = null;
         var minX:Number = NaN;
         var maxX:Number = NaN;
         var len:int = 0;
         var stacks:Array = null;
         var currentStack:TipStack = null;
         var hitData:HitData = null;
         var tipInstance:IFlexDisplayObject = null;
         var pts:Point = null;
         var xpos:Number = NaN;
         var ypos:Number = NaN;
         var screenTL:Point = null;
         var screenBR:Point = null;
         var splitPoint:int = 0;
         var tipData:TipPositionData = null;
         var bResetMaxX:Boolean = false;
         var bResetMinX:Boolean = false;
         var chartLocalPts:Point = null;
         var j:int = 0;
         var tipColor:uint = 0;
         var tipCount:int = Boolean(_tipCache) ? _tipCache.count : 0;
         var rc:Rectangle = dataRegion;
         var g:Graphics = _dataTipOverlay.graphics;
         var pLeft:Array = [];
         var pRight:Array = [];
         var sortList:Array = [];
         var calloutStroke:IStroke = getStyle("calloutStroke");
         var dataTipHOffset:Number = Number(getStyle("horizontalDataTipOffset"));
         var dataTipVOffset:Number = Number(getStyle("horizontalDataTipOffset"));
         if(isNaN(dataTipHOffset))
         {
            dataTipHOffset = 6;
         }
         if(isNaN(dataTipVOffset))
         {
            dataTipVOffset = 6;
         }
         g.clear();
         if(tipCount == 0)
         {
            return;
         }
         var showTargetValue:Object = getStyle("showDataTipTargets");
         var showTarget:Boolean = showTargetValue != false && showTargetValue != "false";
         pData = _tipCache.instances.slice(0,tipCount);
         var localPts:Point = new Point();
         for(i = 0; i < tipCount; i++)
         {
            hitData = _currentHitSet[i];
            tipInstance = pData[i];
            localPts.x = Math.max(rc.left,Math.min(hitData.x,rc.right));
            localPts.y = Math.max(rc.top,Math.min(hitData.y,rc.bottom));
            pts = localToGlobal(localPts);
            if(tipInstance is ILayoutManagerClient)
            {
               ILayoutManagerClient(tipInstance).validateSize();
            }
            data = new TipPositionData(tipInstance,hitData,localPts.x,localPts.y,pts.x,pts.y);
            if(data.gy - dataTipVOffset - tipInstance.measuredHeight > 0)
            {
               data.py = data.gy - dataTipVOffset - tipInstance.measuredHeight;
            }
            else
            {
               data.py = data.gy + dataTipVOffset;
            }
            sortList.push(data);
            pData[i] = data;
         }
         if(sortList.length > 0)
         {
            sortList.sortOn("gx",Array.NUMERIC);
            minX = Number(sortList[0].gx);
            maxX = Number(sortList[sortList.length - 1].gx);
            screenTL = new Point(4,4);
            screenBR = new Point(screen.width - 4,screen.height - 4);
            i = 0;
            splitPoint = Math.floor(sortList.length / 2);
            if(pLeft.length > pRight.length)
            {
               splitPoint = Math.max(0,splitPoint - (pLeft.length - pRight.length));
            }
            else if(pRight.length > pLeft.length)
            {
               splitPoint = Math.min(sortList.length,splitPoint + (pRight.length - pLeft.length));
            }
            pLeft = pLeft.concat(sortList.slice(0,splitPoint));
            pRight = pRight.concat(sortList.slice(splitPoint,sortList.length));
         }
         pRight.sortOn("gy");
         len = int(pRight.length);
         stacks = [];
         currentStack = null;
         for(i = 0; i < len; i++)
         {
            data = pRight[i];
            data.isRight = true;
            data.px = data.gx + dataTipHOffset;
            if(Boolean(currentStack))
            {
               if(data.py < currentStack.gy + currentStack.height)
               {
                  currentStack.addTip(data,screen.height);
               }
               else
               {
                  reduceStacks(stacks,currentStack);
                  currentStack = new TipStack();
                  currentStack.addTip(data,screen.height);
               }
            }
            else
            {
               currentStack = new TipStack();
               currentStack.addTip(data,screen.height);
            }
         }
         if(Boolean(currentStack))
         {
            reduceStacks(stacks,currentStack);
         }
         var startTarget:Number = 0;
         var endTarget:Number = 0;
         len = int(stacks.length);
         for(i = 0; i < len; i++)
         {
            stacks[i].positionY();
         }
         pLeft.sortOn("gy");
         len = int(pLeft.length);
         stacks = [];
         currentStack = null;
         for(i = 0; i < len; i++)
         {
            data = pLeft[i];
            data.isRight = false;
            data.px = data.gx - data.width - dataTipHOffset;
            if(Boolean(currentStack))
            {
               if(data.py < currentStack.gy + currentStack.height)
               {
                  currentStack.addTip(data,screen.height);
               }
               else
               {
                  reduceStacks(stacks,currentStack);
                  currentStack = new TipStack();
                  currentStack.addTip(data,screen.height);
               }
            }
            else
            {
               currentStack = new TipStack();
               currentStack.addTip(data,screen.height);
            }
         }
         if(Boolean(currentStack))
         {
            reduceStacks(stacks,currentStack);
         }
         len = int(stacks.length);
         for(i = 0; i < len; i++)
         {
            stacks[i].positionY();
         }
         pData.sortOn("py");
         len = int(pData.length);
         maxX = -Infinity;
         minX = Infinity;
         var minForRightTips:Number = -Infinity;
         var maxForLeftTips:Number = Infinity;
         var repeatLayout:Boolean = true;
         var repeatCount:Number = 0;
         while(repeatLayout && repeatCount <= 2)
         {
            repeatLayout = false;
            repeatCount++;
            for(i = 0; i < len; i++)
            {
               tipData = pData[i];
               bResetMaxX = false;
               bResetMinX = false;
               while(startTarget < pData.length && pData[startTarget].gy + TOOLTIP_TARGET_RADIUS < tipData.py)
               {
                  if(pData[startTarget].gx >= maxX)
                  {
                     bResetMaxX = true;
                  }
                  if(pData[startTarget].gx <= minX)
                  {
                     bResetMinX = true;
                  }
                  startTarget++;
               }
               endTarget = Math.max(endTarget,startTarget);
               while(endTarget < pData.length && pData[endTarget].gy - TOOLTIP_TARGET_RADIUS < tipData.py + tipData.height)
               {
                  if(pData[endTarget].gx >= maxX)
                  {
                     bResetMaxX = false;
                     maxX = Number(pData[endTarget].gx);
                  }
                  if(pData[endTarget].gx <= minX)
                  {
                     bResetMinX = false;
                     minX = Number(pData[endTarget].gx);
                  }
                  endTarget++;
               }
               if(bResetMaxX || bResetMinX)
               {
                  maxX = -Infinity;
                  minX = Infinity;
                  for(j = startTarget; j < endTarget; j++)
                  {
                     maxX = Math.max(maxX,pData[j].gx);
                     minX = Math.min(minX,pData[j].gx);
                  }
               }
               if(tipData.isRight)
               {
                  tipData.px = Math.max(tipData.px,maxX + TOOLTIP_TARGET_RADIUS);
                  tipData.px = Math.max(minForRightTips,tipData.px);
                  if(tipData.px > screenBR.x - tipData.width)
                  {
                     tipData.px = screenBR.x - tipData.width;
                     if(maxForLeftTips > tipData.px)
                     {
                        maxForLeftTips = tipData.px;
                        repeatLayout = true;
                     }
                  }
               }
               else
               {
                  tipData.px = Math.min(tipData.px,minX - TOOLTIP_TARGET_RADIUS - tipData.width);
                  tipData.px = Math.min(maxForLeftTips - tipData.width,tipData.px);
                  if(tipData.px < screenTL.x)
                  {
                     tipData.px = screenTL.x;
                     if(tipData.px + tipData.width > minForRightTips)
                     {
                        minForRightTips = tipData.px + tipData.width;
                        repeatLayout = true;
                     }
                  }
               }
               pts.x = tipData.px;
               pts.y = tipData.py;
               localPts = this.parentApplication.systemManager.getSandboxRoot().globalToLocal(pts);
               chartLocalPts = globalToLocal(pts);
               tipData.tip.move(localPts.x,localPts.y);
               if(showTarget)
               {
                  if(len > 1)
                  {
                     if(Boolean(calloutStroke))
                     {
                        calloutStroke.apply(g);
                        if(tipData.isRight)
                        {
                           g.moveTo(chartLocalPts.x,chartLocalPts.y + tipData.height / 2);
                           g.lineTo(tipData.x,chartLocalPts.y + tipData.height / 2);
                           g.lineTo(tipData.x,tipData.y);
                        }
                        else
                        {
                           g.moveTo(chartLocalPts.x + tipData.width,chartLocalPts.y + tipData.height / 2);
                           g.lineTo(tipData.x,chartLocalPts.y + tipData.height / 2);
                           g.lineTo(tipData.x,tipData.y);
                        }
                     }
                  }
                  tipColor = tipData.hd.contextColor;
                  g.lineStyle(1,tipColor,100);
                  g.moveTo(tipData.x,tipData.y);
                  g.beginFill(16777215,1);
                  g.drawCircle(tipData.x,tipData.y,TOOLTIP_TARGET_RADIUS);
                  g.endFill();
                  g.beginFill(tipColor,1);
                  g.drawCircle(tipData.x,tipData.y,TOOLTIP_TARGET_INNER_RADIUS);
                  g.endFill();
               }
            }
         }
      }
      
      override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         if(_mouseEventsInitialzed == false && ITEM_EVENTS[type] == true)
         {
            setupMouseDispatching();
         }
         super.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function applyDataProvider(dp:ICollectionView, transform:DataTransform) : void
      {
         var dimension:String = null;
         var elements:Array = null;
         var i:int = 0;
         var axes:Object = transform.axes;
         for(dimension in axes)
         {
            axes[dimension].chartDataProvider = dp;
         }
         elements = transform.elements;
         for(i = 0; i < elements.length; i++)
         {
            if(elements[i] is Series)
            {
               elements[i].chartDataProvider = dp;
            }
         }
         clearSelection();
      }
      
      private function mouseMoveHandler(event:MouseEvent) : void
      {
         var n:int = 0;
         var i:int = 0;
         var ti:IFlexDisplayObject = null;
         if(Boolean(_tipCache))
         {
            n = _tipCache.count;
            for(i = 0; i < n; i++)
            {
               ti = _tipCache.instances[i];
               if(event.target == ti || ti is DisplayObjectContainer && (ti as DisplayObjectContainer).contains(event.target as DisplayObject))
               {
                  return;
               }
            }
         }
         var p:Point = new Point(event.localX,event.localY);
         p = globalToLocal(DisplayObject(event.target).localToGlobal(p));
         var hitPoints:Array = findDataPoints(p.x,p.y);
         processRollEvents(hitPoints,event);
      }
      
      [Inspectable(defaultValue="false")]
      public function get dragMoveEnabled() : Boolean
      {
         return _dragMoveEnabled;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function handleNavigation(item:ChartItem, event:KeyboardEvent) : void
      {
         var seriesObject:Series = null;
         var caretSeriesObject:Series = null;
         var caretSeries:Series = null;
         var tempItem:ChartItem = null;
         var index1:int = 0;
         var index2:int = 0;
         var temp:int = 0;
         var bSelectionChanged:Boolean = false;
         var bControl:Boolean = false;
         var bShift:Boolean = false;
         seriesObject = Series(item.element);
         if(event.ctrlKey)
         {
            bControl = true;
         }
         if(event.shiftKey)
         {
            bShift = true;
            bControl = false;
         }
         if(bControl)
         {
            if(Boolean(_caretItem))
            {
               caretSeries = Series(_caretItem.element);
               if(caretSeries.selectable)
               {
                  if(caretSeries.selectedItems.indexOf(_caretItem) != -1)
                  {
                     _caretItem.currentState = ChartItem.SELECTED;
                  }
                  else if(Boolean(_selectedSeries))
                  {
                     _caretItem.currentState = ChartItem.DISABLED;
                  }
                  else
                  {
                     _caretItem.currentState = ChartItem.NONE;
                  }
               }
            }
            item.currentState = ChartItem.FOCUSED;
         }
         else
         {
            if(!bShift || !_anchorItem)
            {
               if(!_selectedSeries)
               {
                  setChartItemsToDisabled();
               }
               else if(selectionMode == "single")
               {
                  _selectedSeries.removeItemfromSelection(_selectedSeries.selectedItem);
               }
               else
               {
                  clearSelection();
                  setChartItemsToDisabled();
               }
               seriesObject.addItemtoSelection(item);
               _selectedSeries = seriesObject;
               item.currentState = ChartItem.FOCUSEDSELECTED;
            }
            else
            {
               if(selectionMode == "single")
               {
                  _selectedSeries.removeItemfromSelection(_selectedSeries.selectedItem);
                  seriesObject.addItemtoSelection(item);
               }
               else
               {
                  tempItem = _anchorItem;
                  index1 = Series(_anchorItem.element).items.indexOf(_anchorItem);
                  index2 = seriesObject.items.indexOf(item);
                  clearSelection();
                  setChartItemsToDisabled();
                  _anchorItem = tempItem;
                  if(Series(_anchorItem.element) == seriesObject)
                  {
                     if(index1 > index2)
                     {
                        temp = index1;
                        index1 = index2;
                        index2 = temp;
                     }
                     for(temp = index1; temp <= index2; temp++)
                     {
                        seriesObject.addItemtoSelection(seriesObject.items[temp]);
                     }
                  }
                  else
                  {
                     Series(_anchorItem.element).addItemtoSelection(_anchorItem);
                     seriesObject.addItemtoSelection(item);
                  }
               }
               _selectedSeries = seriesObject;
               item.currentState = ChartItem.FOCUSEDSELECTED;
            }
            bSelectionChanged = true;
         }
         _caretItem = item;
         if(bSelectionChanged && Boolean(_selectedSeries))
         {
            if(!bShift || Boolean(_selectedSeries) && Boolean(!_anchorItem))
            {
               _anchorItem = _selectedSeries.selectedItem;
            }
            dispatchEvent(new ChartItemEvent(ChartItemEvent.CHANGE,null,null,this));
         }
      }
      
      private function mouseDownHandler(event:MouseEvent) : void
      {
         var p:Point = new Point(event.localX,event.localY);
         p = globalToLocal(DisplayObject(event.target).localToGlobal(p));
         var hitPoints:Array = findDataPoints(p.x,p.y);
         processRollEvents(hitPoints,event);
         if(Boolean(_currentHitSet))
         {
            dispatchEvent(new ChartItemEvent(ChartItemEvent.ITEM_MOUSE_DOWN,_currentHitSet,event,this));
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getNextSeriesItem(seriesArray:Array) : ChartItem
      {
         var caretSeries:Series = null;
         var index:int = 0;
         if(!_caretItem)
         {
            return getNextSeries(seriesArray);
         }
         caretSeries = Series(_caretItem.element);
         index = caretSeries.items.indexOf(_caretItem);
         if(index == caretSeries.items.length - 1)
         {
            return null;
         }
         return caretSeries.items[++index];
      }
      
      [Inspectable(category="Data",arrayType="mx.charts.chartClasses.Series")]
      public function get series() : Array
      {
         return _userSeries;
      }
      
      protected function dragExitHandler(event:DragEvent) : void
      {
         if(event.isDefaultPrevented())
         {
            return;
         }
         hideDropFeedback(event);
         DragManager.showFeedback(DragManager.NONE);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getPreviousSeriesItem(seriesArray:Array) : ChartItem
      {
         var caretSeries:Series = null;
         var index:int = 0;
         if(!_caretItem)
         {
            return getPreviousSeries(seriesArray);
         }
         caretSeries = Series(_caretItem.element);
         index = caretSeries.items.indexOf(_caretItem);
         if(index == 0)
         {
            return null;
         }
         return caretSeries.items[--index];
      }
      
      [Deprecated(replacement="IChartElement2.dataTransform")]
      protected function get transforms() : Array
      {
         return _transforms;
      }
      
      public function set backgroundElements(value:Array) : void
      {
         _backgroundElements = value;
         invalidateSeries();
      }
      
      public function set annotationElements(value:Array) : void
      {
         _annotationElements = value;
         invalidateSeries();
      }
      
      protected function get dragImage() : IUIComponent
      {
         var image:ChartItemDragProxy = new ChartItemDragProxy();
         image.owner = this;
         return image;
      }
      
      private function mouseDoubleClickHandler(event:MouseEvent) : void
      {
         var p:Point = new Point(event.localX,event.localY);
         p = globalToLocal(DisplayObject(event.target).localToGlobal(p));
         var hitPoints:Array = findDataPoints(p.x,p.y);
         processRollEvents(hitPoints,event);
         if(Boolean(_currentHitSet) && _currentHitSet.length > 0)
         {
            dispatchEvent(new ChartItemEvent(ChartItemEvent.ITEM_DOUBLE_CLICK,_currentHitSet,event,this));
         }
         else
         {
            dispatchEvent(new ChartEvent(ChartEvent.CHART_DOUBLE_CLICK,event,this));
         }
      }
      
      protected function applySeriesSet(seriesSet:Array, transform:DataTransform) : Array
      {
         var newSeries:IChartElement = null;
         for(var i:int = 0; i < seriesSet.length; i++)
         {
            newSeries = seriesSet[i];
            if(newSeries is Series)
            {
               customizeSeries(Series(seriesSet[i]),i);
            }
         }
         return seriesSet;
      }
      
      protected function customizeSeries(seriesGlyph:Series, i:uint) : void
      {
      }
      
      public function getItemsInRegion(value:Rectangle) : Array
      {
         var i:int = 0;
         var arrAllItems:Array = [];
         if(Boolean(_transforms))
         {
            for(i = 0; i < _transforms.length; i++)
            {
               arrAllItems = arrAllItems.concat(getItemsInRegionFromElements(_transforms[i],value));
            }
         }
         return arrAllItems;
      }
      
      public function set selectionMode(value:String) : void
      {
         if(_selectionMode == value)
         {
            return;
         }
         _selectionMode = value;
         invalidateProperties();
      }
      
      [Deprecated(replacement="IChartElement2.dataToLocal()")]
      public function dataToLocal(... dataValues) : Point
      {
         return null;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function updateSeries() : void
      {
         var i:int = 0;
         var c:DisplayObject = null;
         var g:IChartElement = null;
         var labelLayer:UIComponent = null;
         var displayedSeries:Array = applySeriesSet(_userSeries,_transforms[0]);
         var len:int = Boolean(displayedSeries) ? int(displayedSeries.length) : 0;
         len = int(labelElements.numChildren);
         removeElements(_backgroundElementHolder,true);
         removeElements(_seriesFilterer,false);
         removeElements(_annotationElementHolder,true);
         addElements(_backgroundElements,_transforms[0],_backgroundElementHolder);
         allElements = _backgroundElements.concat();
         addElements(displayedSeries,_transforms[0],_seriesFilterer);
         allElements = allElements.concat(displayedSeries);
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
         addElements(labelElements,_transforms[0],_annotationElementHolder);
         allElements = allElements.concat(labelElements);
         addElements(_annotationElements,_transforms[0],_annotationElementHolder);
         allElements = allElements.concat(_annotationElements);
         _transforms[0].elements = _annotationElements.concat(displayedSeries).concat(_backgroundElements);
         _bDataDirty = true;
         invalidateSeriesStyles();
      }
      
      private function mouseOutHandler(event:MouseEvent) : void
      {
         var n:int = 0;
         var i:int = 0;
         var ti:IFlexDisplayObject = null;
         if(Boolean(_tipCache))
         {
            n = _tipCache.count;
            for(i = 0; i < n; i++)
            {
               ti = _tipCache.instances[i];
               if(event.target == ti || ti is DisplayObjectContainer && (ti as DisplayObjectContainer).contains(event.target as DisplayObject))
               {
                  return;
               }
               if(Boolean(event.relatedObject) && (ti == event.relatedObject || ti is DisplayObjectContainer && (ti as DisplayObjectContainer).contains(event.relatedObject)))
               {
                  return;
               }
            }
         }
         if(!event.relatedObject || event.relatedObject != this && !contains(event.relatedObject))
         {
            processRollEvents([],event);
         }
      }
      
      public function set dropEnabled(value:Boolean) : void
      {
         if(_dropEnabled && !value)
         {
            removeEventListener(DragEvent.DRAG_ENTER,dragEnterHandler,false);
            removeEventListener(DragEvent.DRAG_EXIT,dragExitHandler,false);
            removeEventListener(DragEvent.DRAG_OVER,dragOverHandler,false);
            removeEventListener(DragEvent.DRAG_DROP,dragDropHandler,false);
         }
         _dropEnabled = value;
         if(value)
         {
            addEventListener(DragEvent.DRAG_ENTER,dragEnterHandler,false,EventPriority.DEFAULT_HANDLER);
            addEventListener(DragEvent.DRAG_EXIT,dragExitHandler,false,EventPriority.DEFAULT_HANDLER);
            addEventListener(DragEvent.DRAG_OVER,dragOverHandler,false,EventPriority.DEFAULT_HANDLER);
            addEventListener(DragEvent.DRAG_DROP,dragDropHandler,false,EventPriority.DEFAULT_HANDLER);
         }
      }
      
      protected function dragEnterHandler(event:DragEvent) : void
      {
         if(event.isDefaultPrevented())
         {
            return;
         }
         if(event.dragSource.hasFormat("chartitems"))
         {
            DragManager.acceptDragDrop(this);
            DragManager.showFeedback(event.ctrlKey ? DragManager.COPY : DragManager.MOVE);
            showDropFeedback(event);
            return;
         }
         hideDropFeedback(event);
         DragManager.showFeedback(DragManager.NONE);
      }
      
      private function selectRectangleRegion(r:Rectangle, bPreserveSelection:Boolean = false) : void
      {
         var arrItems:Array = getItemsInRegion(r);
         if(bPreserveSelection)
         {
            arrItems = arrItems.concat(selectedChartItems);
         }
         selectSpecificChartItems(arrItems);
      }
      
      private function cancelEffect() : void
      {
         if(Boolean(_transitionEffect))
         {
            _transitionEffect.end();
            _transitionEffect = null;
         }
         setChartState(ChartState.NONE);
      }
      
      public function set dragMoveEnabled(value:Boolean) : void
      {
         _dragMoveEnabled = value;
      }
      
      private function endTracking(e:MouseEvent) : void
      {
         systemManager.getSandboxRoot().removeEventListener("mouseUp",endTracking,true);
         systemManager.getSandboxRoot().removeEventListener("mouseMove",track,true);
         rangeItemRenderer.clear();
         removeChild(rangeItemRenderer);
         rangeItemRenderer = null;
         dispatchRegionChange(e);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addElements(elements:Array, transform:DataTransform, elementParent:UIComponent) : void
      {
         var c:DisplayObject = null;
         var g:IChartElement = null;
         for(var i:int = 0; i < elements.length; i++)
         {
            c = elements[i];
            g = c as IChartElement;
            if(Boolean(g) && Boolean(!(g is Series)) && !(g is IDataCanvas))
            {
               g.dataTransform = transform;
            }
            elementParent.addChild(c);
         }
      }
      
      override public function setActualSize(w:Number, h:Number) : void
      {
         if(w != this.width || h != this.height)
         {
            cancelEffect();
         }
         super.setActualSize(w,h);
      }
      
      protected function addDragData(ds:Object) : void
      {
         ds.addData(selectedChartItems,"chartitems");
      }
      
      public function set dragEnabled(value:Boolean) : void
      {
         if(_dragEnabled && !value)
         {
            removeEventListener(DragEvent.DRAG_COMPLETE,dragCompleteHandler,false);
         }
         _dragEnabled = value;
         if(value)
         {
            addEventListener(DragEvent.DRAG_COMPLETE,dragCompleteHandler,false,EventPriority.DEFAULT_HANDLER);
         }
      }
      
      private function regionChangeHandler(event:RangeEvent) : void
      {
         var bSelected:Boolean = true;
         if(!_selectedSeries)
         {
            bSelected = false;
         }
         selectRectangleRegion(event.regionSelected,event.mouseEvent.ctrlKey || event.mouseEvent.shiftKey);
         if((Boolean(bSelected) || Boolean(_selectedSeries)) && !event.mouseEvent.buttonDown)
         {
            dispatchEvent(new ChartItemEvent(ChartItemEvent.CHANGE,null,event.mouseEvent,this));
         }
      }
      
      public function set series(value:Array) : void
      {
         value = value == null ? [] : value;
         _userSeries = value;
         for(var i:int = 0; i < value.length; i++)
         {
            if(value[i] is Series)
            {
               (value[i] as Series).owner = this;
            }
         }
         invalidateSeries();
         invalidateData();
         legendDataChanged();
      }
      
      override public function set showInAutomationHierarchy(value:Boolean) : void
      {
      }
      
      private function invokeDTFunction(hd:HitData) : String
      {
         return dataTipFunction(hd);
      }
      
      private function getItemsInRegionFromElements(transform:DataTransform, value:Rectangle) : Array
      {
         var elements:Array = transform.elements;
         var arrItems:Array = [];
         for(var i:int = 0; i < elements.length; i++)
         {
            if(Boolean(elements[i] is Series) && Boolean(elements[i].selectable) && Boolean(elements[i].visible))
            {
               arrItems = arrItems.concat(elements[i].getItemsInRegion(value));
            }
         }
         return arrItems;
      }
      
      [Inspectable(defaultValue="true")]
      public function get clipContent() : Boolean
      {
         return _clipContent;
      }
      
      private function mouseUpHandler(event:MouseEvent) : void
      {
         var p:Point = new Point(event.localX,event.localY);
         p = globalToLocal(DisplayObject(event.target).localToGlobal(p));
         var hitPoints:Array = findDataPoints(p.x,p.y);
         processRollEvents(hitPoints,event);
         if(Boolean(_currentHitSet))
         {
            dispatchEvent(new ChartItemEvent(ChartItemEvent.ITEM_MOUSE_UP,_currentHitSet,event,this));
         }
      }
      
      public function set showAllDataTips(value:Boolean) : void
      {
         if(_showAllDataTips == value)
         {
            return;
         }
         _showAllDataTips = value;
         updateAllDataTips();
      }
      
      protected function set transforms(value:Array) : void
      {
         _transforms = value;
         invalidateProperties();
         invalidateSeries();
         invalidateData();
         legendDataChanged();
      }
      
      public function set seriesFilters(value:Array) : void
      {
         _seriesFilterer.filters = value;
      }
      
      public function invalidateSeriesStyles() : void
      {
         if(!_seriesStylesDirty)
         {
            _seriesStylesDirty = true;
            invalidateProperties();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get labelElementsArray() : Array
      {
         return labelElements;
      }
      
      public function getPreviousItem(direction:String) : ChartItem
      {
         return null;
      }
      
      [Deprecated(replacement="Series.setAxis()")]
      public function setAxis(dimension:String, value:IAxis) : void
      {
         transforms[0].setAxis(dimension,value);
      }
      
      public function getFirstItem(direction:String) : ChartItem
      {
         return null;
      }
      
      public function showDropFeedback(event:DragEvent) : void
      {
         drawFocus(true);
      }
      
      private function startTracking(e:MouseEvent) : void
      {
         var mouseVals:Array = null;
         if(dataRegion.contains(mouseX,mouseY) == false)
         {
            return;
         }
         if(Boolean(rangeItemRenderer))
         {
            rangeItemRenderer.clear();
            removeChild(rangeItemRenderer);
         }
         rangeItemRenderer = new RangeSelector();
         addChild(rangeItemRenderer);
         dataRegionForRange = dataRegion;
         systemManager.getSandboxRoot().addEventListener("mouseUp",endTracking,true);
         systemManager.getSandboxRoot().addEventListener("mouseMove",track,true);
         tX = mouseX;
         tY = mouseY;
         mouseVals = [tX,tY];
         updateTrackBounds(mouseVals);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function handleShift(item:ChartItem) : void
      {
         var arrItems:Array = null;
         var pt:Point = null;
         var tempItem:ChartItem = _anchorItem;
         var tempCaretItem:ChartItem = _caretItem;
         if(!_anchorItem.itemRenderer || !item.itemRenderer)
         {
            return;
         }
         var rc:Rectangle = new Rectangle();
         var pt1:Point = new Point(_anchorItem.itemRenderer.x,_anchorItem.itemRenderer.y);
         var pt2:Point = new Point(item.itemRenderer.x,item.itemRenderer.y);
         pt1 = Series(_anchorItem.element).localToGlobal(pt1);
         pt2 = Series(item.element).localToGlobal(pt2);
         rc.left = Math.min(pt1.x,pt2.x,pt1.x + _anchorItem.itemRenderer.width,pt2.x + item.itemRenderer.width);
         rc.top = Math.min(pt1.y,pt2.y,pt1.y + _anchorItem.itemRenderer.height,pt2.y + item.itemRenderer.height);
         rc.right = Math.max(pt1.x,pt2.x,pt1.x + _anchorItem.itemRenderer.width,pt2.x + item.itemRenderer.width);
         rc.bottom = Math.max(pt1.y,pt2.y,pt1.y + _anchorItem.itemRenderer.height,pt2.y + item.itemRenderer.height);
         rc.left += 2;
         rc.top += 2;
         rc.right -= 2;
         rc.bottom -= 2;
         selectRectangleRegion(rc);
         _anchorItem = tempItem;
         _caretItem = tempCaretItem;
      }
      
      protected function get dataRegion() : Rectangle
      {
         return null;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getNextSeries(seriesArray:Array) : ChartItem
      {
         var index:int = 0;
         var itemFound:Boolean = false;
         if(!_caretItem)
         {
            index = -1;
         }
         else
         {
            index = seriesArray.indexOf(Series(_caretItem.element));
         }
         while(!itemFound && index < seriesArray.length - 1)
         {
            index++;
            if(Boolean(seriesArray[index].selectable) && Boolean(seriesArray[index].visible) && seriesArray[index].items.length > 0)
            {
               itemFound = true;
            }
         }
         if(itemFound)
         {
            return seriesArray[index].items[0];
         }
         return null;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function updateChildOrder() : void
      {
         var nextindex:int = 0;
         setChildIndex(_backgroundElementHolder,nextindex++);
         nextindex = updateAxisOrder(nextindex);
         setChildIndex(_seriesHolder,nextindex++);
         setChildIndex(_annotationElementHolder,nextindex++);
         setChildIndex(_allDataTipOverlay,nextindex++);
         setChildIndex(_dataTipOverlay,nextindex++);
      }
      
      protected function invalidateChildOrder() : void
      {
         if(_childOrderDirty == false)
         {
            _childOrderDirty = true;
            invalidateProperties();
         }
      }
      
      [Inspectable(arrayType="mx.charts.chartClasses.ChartElement")]
      public function get annotationElements() : Array
      {
         return _annotationElements;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getPreviousSeries(seriesArray:Array) : ChartItem
      {
         var index:int = 0;
         var itemFound:Boolean = false;
         if(!_caretItem)
         {
            index = int(seriesArray.length);
         }
         else
         {
            index = seriesArray.indexOf(Series(_caretItem.element));
         }
         while(!itemFound && index > 0)
         {
            index--;
            if(Boolean(seriesArray[index].selectable) && Boolean(seriesArray[index].visible) && seriesArray[index].items.length > 0)
            {
               itemFound = true;
            }
         }
         if(itemFound)
         {
            return seriesArray[index].items[0];
         }
         return null;
      }
      
      [Inspectable(category="General",enumeration="none,single,multiple",defaultValue="none")]
      public function get selectionMode() : String
      {
         return _selectionMode;
      }
      
      [Inspectable(environment="none")]
      public function get chartState() : uint
      {
         return _transitionState;
      }
      
      protected function setChartState(value:uint) : void
      {
         var g:IChartElement = null;
         if(_transitionState == value)
         {
            return;
         }
         var oldState:uint = _transitionState;
         _transitionState = value;
         var n:int = int(allElements.length);
         for(var i:int = 0; i < n; i++)
         {
            g = allElements[i] as IChartElement;
            if(Boolean(g))
            {
               g.chartStateChanged(oldState,value);
            }
         }
         invalidateDisplayList();
      }
      
      [Inspectable(environment="none")]
      [Bindable("legendDataChanged")]
      public function get legendData() : Array
      {
         var s:Series = null;
         var keyItems:Array = [];
         var n:int = int(allElements.length);
         for(var i:int = 0; i < n; i++)
         {
            s = allElements[i] as Series;
            if(Boolean(s))
            {
               keyItems = keyItems.concat(s.legendData);
            }
         }
         return keyItems;
      }
      
      private function track(e:MouseEvent) : void
      {
         if(e.buttonDown == false)
         {
            endTracking(e);
            return;
         }
         updateTrackBounds([mouseX,mouseY]);
         dispatchRegionChange(e);
         e.stopPropagation();
      }
      
      public function legendDataChanged() : void
      {
         dispatchEvent(new Event("legendDataChanged"));
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function updateAxisOrder(nextindex:int) : int
      {
         return nextindex;
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredWidth = 400;
         measuredHeight = 400;
      }
      
      private function updateTrackBounds(mouseVals:Array) : void
      {
         dRight = Math.max(tX,mouseVals[0]);
         dLeft = Math.min(tX,mouseVals[0]);
         dTop = Math.min(tY,mouseVals[1]);
         dBottom = Math.max(tY,mouseVals[1]);
         dLeft = Math.max(dLeft,dataRegionForRange.left);
         dTop = Math.max(dTop,dataRegionForRange.y);
         dRight = Math.min(dRight,dataRegionForRange.x + dataRegionForRange.width);
         dBottom = Math.min(dBottom,dataRegionForRange.y + dataRegionForRange.height);
         rangeItemRenderer.move(dLeft,dTop);
         rangeItemRenderer.setActualSize(dRight - dLeft,dBottom - dTop);
      }
      
      public function get dragEnabled() : Boolean
      {
         return _dragEnabled;
      }
      
      protected function get dataTipLayerIndex() : int
      {
         return getChildIndex(_dataTipOverlay);
      }
      
      public function set dataProvider(value:Object) : void
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
         _dataProvider = ICollectionView(value);
         invalidateData();
      }
      
      [Inspectable(category="Data")]
      public function get selectedChartItems() : Array
      {
         var j:int = 0;
         var arr:Array = [];
         for(var i:int = 0; i < series.length; i++)
         {
            for(j = 0; j < series[i].selectedItems.length; j++)
            {
               arr.push(series[i].selectedItems[j]);
            }
         }
         return arr;
      }
      
      [Inspectable(defaultValue="false")]
      public function get dropEnabled() : Boolean
      {
         return _dropEnabled;
      }
      
      private function dispatchRegionChange(e:MouseEvent) : void
      {
         var leftTop:Point = new Point(dLeft,dTop);
         var rightBottom:Point = new Point(dRight,dBottom);
         leftTop = localToGlobal(leftTop);
         rightBottom = localToGlobal(rightBottom);
         var r:Rectangle = new Rectangle(leftTop.x,leftTop.y,rightBottom.x - leftTop.x,rightBottom.y - leftTop.y);
         dispatchEvent(new RangeEvent(RangeEvent.REGION_CHANGE,r,e));
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get allElementsArray() : Array
      {
         return allElements;
      }
      
      public function get seriesFilters() : Array
      {
         return _seriesFilterer.filters;
      }
      
      protected function invalidateData() : void
      {
         _bDataDirty = true;
         invalidateProperties();
      }
      
      [Inspectable(category="Data",defaultValue="false")]
      public function get showAllDataTips() : Boolean
      {
         return _showAllDataTips;
      }
      
      protected function dragDropHandler(event:DragEvent) : void
      {
         if(event.isDefaultPrevented())
         {
            return;
         }
         hideDropFeedback(event);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function selectSpecificChartItems(arrItems:Array) : void
      {
         var seriesArray:Array = [];
         var seriesObject:Series = null;
         var item:ChartItem = null;
         var index:int = -1;
         var bDisabled:Boolean = false;
         clearSelection();
         for(var i:int = 0; i < arrItems.length; i++)
         {
            seriesObject = Series(arrItems[i].element);
            if(seriesObject.selectable)
            {
               if(!bDisabled)
               {
                  bDisabled = true;
                  setChartItemsToDisabled();
               }
               if(_selectionMode == "single" && Boolean(_selectedSeries))
               {
                  _selectedSeries.removeItemfromSelection(_selectedSeries.selectedItem);
               }
               if(seriesObject.selectedItems.indexOf(arrItems[i]) == -1)
               {
                  seriesObject.addItemtoSelection(arrItems[i]);
               }
               _selectedSeries = seriesObject;
            }
         }
         if(Boolean(_selectedSeries))
         {
            _caretItem = _selectedSeries.selectedItem;
            _caretItem.currentState = ChartItem.FOCUSEDSELECTED;
            _anchorItem = _caretItem;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getSeriesTransformState(seriesObject:Object) : Boolean
      {
         return seriesObject.getTransformState();
      }
      
      protected function invalidateSeries() : void
      {
         if(_bSeriesDirty == false)
         {
            _bSeriesDirty = true;
            invalidateProperties();
            invalidateDisplayList();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function updateKeyboardCache() : void
      {
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeElements(parent:UIComponent, hasMask:Boolean) : void
      {
         var c:DisplayObject = null;
         var g:IChartElement = null;
         var n:int = int(parent.numChildren);
         var stopIndex:int = hasMask ? 1 : 0;
         var i:int = n - 1;
         while(i >= stopIndex)
         {
            c = parent.removeChildAt(i);
            g = c as IChartElement;
            if(Boolean(g))
            {
               g.dataTransform = null;
            }
            i--;
         }
      }
      
      protected function advanceEffectState() : void
      {
         var p:Parallel = null;
         var transitionChildren:Array = null;
         var i:int = 0;
         if(_transitionState == ChartState.PREPARING_TO_HIDE_DATA)
         {
            transitionChildren = collectTransitions();
            if(transitionChildren.length == 0)
            {
               setChartState(ChartState.PREPARING_TO_SHOW_DATA);
            }
            else
            {
               setChartState(ChartState.HIDING_DATA);
               p = new Parallel();
               _transitionEffect = ParallelInstance(p.createInstance());
               for(i = 0; i < transitionChildren.length; i++)
               {
                  _transitionEffect.addChildSet([transitionChildren[i]]);
               }
               _transitionEffect.addEventListener(EffectEvent.EFFECT_END,dataEffectEndHandler);
               _transitionEffect.play();
            }
         }
         if(_transitionState == ChartState.PREPARING_TO_SHOW_DATA)
         {
            transitionChildren = collectTransitions();
            if(transitionChildren.length == 0)
            {
               setChartState(ChartState.NONE);
            }
            else
            {
               setChartState(ChartState.SHOWING_DATA);
               p = new Parallel();
               _transitionEffect = ParallelInstance(p.createInstance());
               for(i = 0; i < transitionChildren.length; i++)
               {
                  _transitionEffect.addChildSet([transitionChildren[i]]);
               }
               _transitionEffect.addEventListener(EffectEvent.EFFECT_END,dataEffectEndHandler);
               _transitionEffect.play();
            }
         }
         invalidateDisplayList();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rollOverItem(hitSet:Array, removedSet:Array) : void
      {
         var data:HitData = null;
         var seriesObject:Series = null;
         var i:int = 0;
         var index:int = 0;
         if(hitSet.length > 0)
         {
            data = hitSet[0];
            if(_selectionMode != "none" && Series(data.chartItem.element).selectable)
            {
               data.chartItem.currentState = ChartItem.ROLLOVER;
            }
         }
         if(removedSet.length > 0)
         {
            for(i = 0; i < removedSet.length; i++)
            {
               data = removedSet[i];
               seriesObject = Series(data.chartItem.element);
               if(seriesObject.selectable)
               {
                  index = seriesObject.selectedItems.indexOf(data.chartItem);
                  if(index == -1)
                  {
                     if(!_selectedSeries)
                     {
                        data.chartItem.currentState = ChartItem.NONE;
                     }
                     else
                     {
                        data.chartItem.currentState = ChartItem.DISABLED;
                     }
                  }
                  else
                  {
                     data.chartItem.currentState = ChartItem.SELECTED;
                  }
               }
            }
         }
      }
      
      public function set dataTipMode(value:String) : void
      {
         _dataTipMode = value;
         updateDataTips();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function updateSeriesStyles() : void
      {
         var nextAvailableStyle:uint = 0;
         var styles:Array = null;
         var n:int = 0;
         var i:int = 0;
         var g:IChartElement = null;
         if(_seriesStylesDirty)
         {
            _seriesStylesDirty = false;
            nextAvailableStyle = 0;
            styles = getStyle("chartSeriesStyles");
            if(Boolean(styles))
            {
               n = int(allElements.length);
               for(i = 0; i < n; i++)
               {
                  g = allElements[i] as IChartElement;
                  if(Boolean(g))
                  {
                     nextAvailableStyle = g.claimStyles(styles,nextAvailableStyle);
                  }
               }
            }
         }
      }
      
      [Inspectable(category="Data",arrayType="Object")]
      public function get dataProvider() : Object
      {
         return _dataProvider;
      }
      
      [Inspectable(category="Data")]
      public function get selectedChartItem() : ChartItem
      {
         if(Boolean(_selectedSeries))
         {
            return _selectedSeries.selectedItem;
         }
         return null;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function handleSpace(event:KeyboardEvent) : void
      {
         var caretSeries:Series = null;
         var nextSeries:Series = null;
         var item:ChartItem = null;
         if(!_caretItem)
         {
            return;
         }
         var bSelectionChanged:Boolean = false;
         var bControl:Boolean = false;
         var bShift:Boolean = false;
         if(event.ctrlKey)
         {
            bControl = true;
         }
         if(event.shiftKey)
         {
            bShift = true;
            bControl = false;
         }
         caretSeries = Series(_caretItem.element);
         if(caretSeries.selectable)
         {
            if(caretSeries.selectedItems.indexOf(_caretItem) != -1)
            {
               if(bControl)
               {
                  caretSeries.removeItemfromSelection(_caretItem);
                  _caretItem.currentState = ChartItem.FOCUSED;
                  if(selectionMode == "single")
                  {
                     clearSelection();
                  }
                  else if(_selectedSeries.selectedItems.length == 0)
                  {
                     nextSeries = caretSeries;
                     nextSeries = getSelectedSeries(caretSeries);
                     if(!nextSeries)
                     {
                        clearSelection();
                     }
                     else
                     {
                        _selectedSeries = nextSeries;
                     }
                  }
                  bSelectionChanged = true;
               }
            }
            else
            {
               if(_selectionMode == "single" || _selectionMode == "multiple" && !bControl)
               {
                  item = _caretItem;
                  clearSelection();
                  _caretItem = item;
                  _anchorItem = item;
               }
               if(!_selectedSeries)
               {
                  setChartItemsToDisabled();
               }
               _selectedSeries = caretSeries;
               _selectedSeries.addItemtoSelection(_caretItem);
               _caretItem.currentState = ChartItem.FOCUSEDSELECTED;
               bSelectionChanged = true;
            }
         }
         if(bSelectionChanged)
         {
            if(Boolean(_selectedSeries) && (!bShift || !_anchorItem))
            {
               _anchorItem = _selectedSeries.selectedItem;
            }
            dispatchEvent(new ChartItemEvent(ChartItemEvent.CHANGE,null,null,this));
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setChartItemsToDisabled() : void
      {
         var j:int = 0;
         for(var i:int = 0; i < _transforms.length; i++)
         {
            for(j = 0; j < _transforms[i].elements.length; j++)
            {
               if(_transforms[i].elements[j] is Series)
               {
                  _transforms[i].elements[j].clearSeriesItemsState(false,ChartItem.DISABLED);
               }
            }
         }
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         if(styleProp == null || styleProp == "chartSeriesStyles")
         {
            invalidateSeries();
         }
         super.styleChanged(styleProp);
      }
      
      private function processRollEvents(hitSet:Array, event:MouseEvent) : void
      {
         var seriesObject:Series = null;
         var mousePt:Point = null;
         var dragEvent:DragEvent = null;
         var removedSet:Array = [];
         var addedSet:Array = [];
         var unchangedSet:Array = [];
         var newLen:int = int(hitSet.length);
         var oldLen:int = int(_currentHitSet.length);
         var oldIndex:int = 0;
         var newIndex:int = 0;
         var pt:Point = null;
         if(hitSet.length == 0 && _currentHitSet.length == 0)
         {
            if(_selectionMode == "single" && event.type == MouseEvent.MOUSE_DOWN)
            {
               clearSelection();
               return;
            }
            if(_selectionMode == "multiple" && event.type == MouseEvent.MOUSE_DOWN)
            {
               startTracking(event);
               return;
            }
            return;
         }
         var sortingSet:Array = hitSet.concat();
         if(newLen > 1)
         {
            sortingSet.sortOn("id",Array.NUMERIC);
         }
         while(oldIndex < oldLen || newIndex < newLen)
         {
            if(newIndex == newLen || oldIndex < oldLen && _currentHitSet[oldIndex].id < sortingSet[newIndex].id)
            {
               removedSet.push(_currentHitSet[oldIndex]);
               oldIndex++;
            }
            else if(oldIndex == oldLen || newIndex < newLen && _currentHitSet[oldIndex].id > sortingSet[newIndex].id)
            {
               addedSet.push(sortingSet[newIndex]);
               newIndex++;
            }
            else
            {
               unchangedSet.push(sortingSet[newIndex]);
               newIndex++;
               oldIndex++;
            }
         }
         if(removedSet.length > 0)
         {
            dispatchEvent(new ChartItemEvent(ChartItemEvent.ITEM_ROLL_OUT,removedSet,event,this));
         }
         if(addedSet.length > 0)
         {
            dispatchEvent(new ChartItemEvent(ChartItemEvent.ITEM_ROLL_OVER,addedSet,event,this));
         }
         if(unchangedSet.length > 0)
         {
            dispatchEvent(new ChartItemEvent(ChartItemEvent.ITEM_MOUSE_MOVE,unchangedSet,event,this));
         }
         if(event.type == MouseEvent.MOUSE_DOWN)
         {
            if(_dragEnabled && !DragManager.isDragging)
            {
               _mouseDown = true;
               pt = new Point(event.localX,event.localY);
               pt = DisplayObject(event.target).localToGlobal(pt);
               _mouseDownPoint = globalToLocal(pt);
               _mouseDownItem = hitSet[0].chartItem;
            }
            else if(hitSet.length > 0)
            {
               selectItem(hitSet[0].chartItem,event);
            }
         }
         if(event.type == MouseEvent.MOUSE_UP)
         {
            if(_dragEnabled && _mouseDown && !DragManager.isDragging)
            {
               selectItem(_mouseDownItem,event);
            }
            _mouseDown = false;
            _mouseDownPoint = null;
            _mouseDownItem = null;
         }
         if(event.type != MouseEvent.MOUSE_DOWN && event.type != MouseEvent.MOUSE_UP)
         {
            if(!DragManager.isDragging)
            {
               rollOverItem(hitSet,removedSet);
            }
         }
         if(event.type == MouseEvent.MOUSE_MOVE)
         {
            pt = new Point(event.localX,event.localY);
            pt = DisplayObject(event.target).localToGlobal(pt);
            pt = globalToLocal(pt);
            if(_dragEnabled && _mouseDown && !DragManager.isDragging && (Math.abs(_mouseDownPoint.x - pt.x) > DRAG_THRESHOLD || Math.abs(_mouseDownPoint.y - pt.y) > DRAG_THRESHOLD))
            {
               seriesObject = Series(_mouseDownItem.element);
               if(seriesObject.selectedItems.indexOf(_mouseDownItem) == -1)
               {
                  selectItem(_mouseDownItem,event);
               }
               if(Boolean(_selectedSeries))
               {
                  mousePt = localToGlobal(_mouseDownPoint);
                  mousePt = _selectedSeries.globalToLocal(mousePt);
                  dragEvent = new DragEvent(DragEvent.DRAG_START);
                  dragEvent.dragInitiator = this;
                  dragEvent.localX = mousePt.x;
                  dragEvent.localY = mousePt.y;
                  dragEvent.buttonDown = true;
                  _selectedSeries.dispatchEvent(dragEvent);
               }
            }
         }
         _currentHitSet = hitSet;
         if(_dragEnabled && _mouseDown && Boolean(DragManager.isDragging))
         {
            updateDataTipToMatchHitSet([]);
         }
         else
         {
            updateDataTipToMatchHitSet(_currentHitSet);
         }
      }
      
      public function findDataPoints(x:Number, y:Number) : Array
      {
         var n:int = 0;
         var i:int = 0;
         var g:IChartElement = null;
         var hds:Array = null;
         var result:Array = [];
         if(dataRegion.contains(x,y) == false)
         {
            return result;
         }
         n = int(allElements.length);
         for(i = n - 1; i >= 0; i--)
         {
            g = allElements[i] as IChartElement;
            if(!(!g || g.visible == false))
            {
               hds = g.findDataPoints(x - _seriesHolder.x,y - _seriesHolder.y,mouseSensitivity);
               if(hds.length != 0)
               {
                  result = result.concat(hds);
               }
            }
         }
         for(i = 0; i < result.length; i++)
         {
            result[i].x += _seriesHolder.x;
            result[i].y += _seriesHolder.y;
         }
         return result;
      }
      
      private function tipCreated(tip:IEventDispatcher, cache:InstanceCache) : void
      {
         tip.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
         tip.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
         tip.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
      }
      
      public function clearSelection() : void
      {
         var i:int = 0;
         var j:int = 0;
         if(Boolean(_selectedSeries))
         {
            for(i = 0; i < _transforms.length; i++)
            {
               for(j = 0; j < _transforms[i].elements.length; j++)
               {
                  if(_transforms[i].elements[j] is Series)
                  {
                     _transforms[i].elements[j].clearSeriesItemsState(true);
                  }
               }
            }
            _selectedSeries = null;
            _caretItem = null;
            _anchorItem = null;
         }
      }
      
      private function updateDataTipToMatchHitSet(hitSet:Array) : void
      {
         var tipCount:Number = NaN;
         var i:int = 0;
         var tipClass:* = undefined;
         var currentHitData:HitData = null;
         var tipInstance:IFlexDisplayObject = null;
         if(_showDataTips == false)
         {
            tipCount = 0;
         }
         else if(_dataTipMode == "multiple")
         {
            tipCount = Number(getStyle("maximumDataTipCount"));
            if(isNaN(tipCount))
            {
               tipCount = hitSet.length;
            }
            else
            {
               tipCount = Math.min(tipCount,hitSet.length);
            }
         }
         else
         {
            tipCount = Math.min(hitSet.length,1);
         }
         if(tipCount == 0)
         {
            if(Boolean(_tipCache))
            {
               _tipCache.count = 0;
            }
         }
         else
         {
            if(!_tipCache)
            {
               tipClass = getStyle("dataTipRenderer");
               _tipCache = new InstanceCache(tipClass,systemManager.toolTipChildren);
               _tipCache.discard = true;
               _tipCache.remove = true;
               _tipCache.creationCallback = tipCreated;
            }
            _tipCache.count = tipCount;
            for(i = 0; i < tipCount; i++)
            {
               currentHitData = hitSet[i];
               tipInstance = _tipCache.instances[i];
               if(dataTipFunction != null)
               {
                  currentHitData.dataTipFunction = invokeDTFunction;
               }
               if(tipInstance is IDataRenderer)
               {
                  (tipInstance as IDataRenderer).data = currentHitData;
               }
            }
         }
         positionDataTips();
      }
      
      [Inspectable(category="Data",enumeration="single,multiple",defaultValue="single")]
      public function get dataTipMode() : String
      {
         return _dataTipMode;
      }
      
      override protected function commitProperties() : void
      {
         _commitPropertiesCalled = true;
         super.commitProperties();
         if(_bSeriesDirty)
         {
            updateSeries();
            _selectedSeries = null;
            _bSeriesDirty = false;
         }
         updateSeriesStyles();
         if(_bDataDirty)
         {
            updateData();
            _bDataDirty = false;
         }
         if(_childOrderDirty)
         {
            updateChildOrder();
            _childOrderDirty = false;
         }
         if(_selectionMode != "none")
         {
            if(_mouseEventsInitialzed == false)
            {
               setupMouseDispatching();
            }
            if(_rangeEventsInitialzed == false)
            {
               setupRangeDispatching();
            }
            tabEnabled = true;
         }
         else
         {
            tabEnabled = false;
            dragEnabled = false;
         }
      }
      
      protected function positionAllDataTips(hitSet:Array) : void
      {
         var pData:Array = null;
         var i:int = 0;
         var data:TipPositionData = null;
         var minX:Number = NaN;
         var maxX:Number = NaN;
         var len:int = 0;
         var stacks:Array = null;
         var currentStack:TipStack = null;
         var hitData:HitData = null;
         var tipInstance:IFlexDisplayObject = null;
         var pts:Point = null;
         var xpos:Number = NaN;
         var ypos:Number = NaN;
         var screenTL:Point = null;
         var screenBR:Point = null;
         var splitPoint:int = 0;
         var tipData:TipPositionData = null;
         var bResetMaxX:Boolean = false;
         var bResetMinX:Boolean = false;
         var j:int = 0;
         var tipColor:uint = 0;
         var tipCount:int = Boolean(_allTipCache) ? _allTipCache.count : 0;
         var rc:Rectangle = dataRegion;
         var g:Graphics = _allDataTipOverlay.graphics;
         var pLeft:Array = [];
         var pRight:Array = [];
         var sortList:Array = [];
         var calloutStroke:IStroke = getStyle("calloutStroke");
         var dataTipHOffset:Number = Number(getStyle("horizontalDataTipOffset"));
         var dataTipVOffset:Number = Number(getStyle("horizontalDataTipOffset"));
         if(isNaN(dataTipHOffset))
         {
            dataTipHOffset = 6;
         }
         if(isNaN(dataTipVOffset))
         {
            dataTipVOffset = 6;
         }
         g.clear();
         if(tipCount == 0)
         {
            return;
         }
         var showTargetValue:Object = getStyle("showDataTipTargets");
         var showTarget:Boolean = showTargetValue != false && showTargetValue != "false";
         pData = _allTipCache.instances.slice(0,tipCount);
         var localPts:Point = new Point();
         for(i = 0; i < tipCount; i++)
         {
            hitData = hitSet[i];
            tipInstance = pData[i];
            localPts.x = Math.max(rc.left,Math.min(hitData.x,rc.right));
            localPts.y = Math.max(rc.top,Math.min(hitData.y,rc.bottom));
            pts = localToGlobal(localPts);
            if(tipInstance is ILayoutManagerClient)
            {
               ILayoutManagerClient(tipInstance).validateSize();
            }
            data = new TipPositionData(tipInstance,hitData,localPts.x,localPts.y,pts.x,pts.y);
            if(data.gy - dataTipVOffset - tipInstance.measuredHeight > 0)
            {
               data.py = data.gy - dataTipVOffset - tipInstance.measuredHeight;
            }
            else
            {
               data.py = data.gy + dataTipVOffset;
            }
            sortList.push(data);
            pData[i] = data;
         }
         if(sortList.length > 0)
         {
            sortList.sortOn("gx",Array.NUMERIC);
            minX = Number(sortList[0].gx);
            maxX = Number(sortList[sortList.length - 1].gx);
            screenTL = new Point(4,4);
            screenBR = new Point(screen.width - 4,screen.height - 4);
            i = 0;
            splitPoint = Math.floor(sortList.length / 2);
            if(pLeft.length > pRight.length)
            {
               splitPoint = Math.max(0,splitPoint - (pLeft.length - pRight.length));
            }
            else if(pRight.length > pLeft.length)
            {
               splitPoint = Math.min(sortList.length,splitPoint + (pRight.length - pLeft.length));
            }
            pLeft = pLeft.concat(sortList.slice(0,splitPoint));
            pRight = pRight.concat(sortList.slice(splitPoint,sortList.length));
         }
         pRight.sortOn("gy");
         len = int(pRight.length);
         stacks = [];
         currentStack = null;
         for(i = 0; i < len; i++)
         {
            data = pRight[i];
            data.isRight = true;
            data.px = data.gx + dataTipHOffset;
            if(Boolean(currentStack))
            {
               if(data.py < currentStack.gy + currentStack.height)
               {
                  currentStack.addTip(data,screen.height);
               }
               else
               {
                  reduceStacks(stacks,currentStack);
                  currentStack = new TipStack();
                  currentStack.addTip(data,screen.height);
               }
            }
            else
            {
               currentStack = new TipStack();
               currentStack.addTip(data,screen.height);
            }
         }
         if(Boolean(currentStack))
         {
            reduceStacks(stacks,currentStack);
         }
         var startTarget:Number = 0;
         var endTarget:Number = 0;
         len = int(stacks.length);
         for(i = 0; i < len; i++)
         {
            stacks[i].positionY();
         }
         pLeft.sortOn("gy");
         len = int(pLeft.length);
         stacks = [];
         currentStack = null;
         for(i = 0; i < len; i++)
         {
            data = pLeft[i];
            data.isRight = false;
            data.px = data.gx - data.width - dataTipHOffset;
            if(Boolean(currentStack))
            {
               if(data.py < currentStack.gy + currentStack.height)
               {
                  currentStack.addTip(data,screen.height);
               }
               else
               {
                  reduceStacks(stacks,currentStack);
                  currentStack = new TipStack();
                  currentStack.addTip(data,screen.height);
               }
            }
            else
            {
               currentStack = new TipStack();
               currentStack.addTip(data,screen.height);
            }
         }
         if(Boolean(currentStack))
         {
            reduceStacks(stacks,currentStack);
         }
         len = int(stacks.length);
         for(i = 0; i < len; i++)
         {
            stacks[i].positionY();
         }
         pData.sortOn("py");
         len = int(pData.length);
         maxX = -Infinity;
         minX = Infinity;
         var minForRightTips:Number = -Infinity;
         var maxForLeftTips:Number = Infinity;
         var repeatLayout:Boolean = true;
         var repeatCount:Number = 0;
         while(repeatLayout && repeatCount <= 2)
         {
            repeatLayout = false;
            repeatCount++;
            for(i = 0; i < len; i++)
            {
               tipData = pData[i];
               bResetMaxX = false;
               bResetMinX = false;
               while(startTarget < pData.length && pData[startTarget].gy + TOOLTIP_TARGET_RADIUS < tipData.py)
               {
                  if(pData[startTarget].gx >= maxX)
                  {
                     bResetMaxX = true;
                  }
                  if(pData[startTarget].gx <= minX)
                  {
                     bResetMinX = true;
                  }
                  startTarget++;
               }
               endTarget = Math.max(endTarget,startTarget);
               while(endTarget < pData.length && pData[endTarget].gy - TOOLTIP_TARGET_RADIUS < tipData.py + tipData.height)
               {
                  if(pData[endTarget].gx >= maxX)
                  {
                     bResetMaxX = false;
                     maxX = Number(pData[endTarget].gx);
                  }
                  if(pData[endTarget].gx <= minX)
                  {
                     bResetMinX = false;
                     minX = Number(pData[endTarget].gx);
                  }
                  endTarget++;
               }
               if(bResetMaxX || bResetMinX)
               {
                  maxX = -Infinity;
                  minX = Infinity;
                  for(j = startTarget; j < endTarget; j++)
                  {
                     maxX = Math.max(maxX,pData[j].gx);
                     minX = Math.min(minX,pData[j].gx);
                  }
               }
               if(tipData.isRight)
               {
                  tipData.px = Math.max(tipData.px,maxX + TOOLTIP_TARGET_RADIUS);
                  tipData.px = Math.max(minForRightTips,tipData.px);
                  if(tipData.px > screenBR.x - tipData.width)
                  {
                     tipData.px = screenBR.x - tipData.width;
                     if(maxForLeftTips > tipData.px)
                     {
                        maxForLeftTips = tipData.px;
                        repeatLayout = true;
                     }
                  }
               }
               else
               {
                  tipData.px = Math.min(tipData.px,minX - TOOLTIP_TARGET_RADIUS - tipData.width);
                  tipData.px = Math.min(maxForLeftTips - tipData.width,tipData.px);
                  if(tipData.px < screenTL.x)
                  {
                     tipData.px = screenTL.x;
                     if(tipData.px + tipData.width > minForRightTips)
                     {
                        minForRightTips = tipData.px + tipData.width;
                        repeatLayout = true;
                     }
                  }
               }
               pts.x = tipData.px;
               pts.y = tipData.py;
               localPts = globalToLocal(pts);
               tipData.tip.move(localPts.x,localPts.y);
               if(showTarget)
               {
                  if(len > 1)
                  {
                     if(Boolean(calloutStroke))
                     {
                        calloutStroke.apply(g);
                        if(tipData.isRight)
                        {
                           g.moveTo(localPts.x,localPts.y + tipData.height / 2);
                           g.lineTo(tipData.x,localPts.y + tipData.height / 2);
                           g.lineTo(tipData.x,tipData.y);
                        }
                        else
                        {
                           g.moveTo(localPts.x + tipData.width,localPts.y + tipData.height / 2);
                           g.lineTo(tipData.x,localPts.y + tipData.height / 2);
                           g.lineTo(tipData.x,tipData.y);
                        }
                     }
                  }
                  tipColor = tipData.hd.contextColor;
                  g.lineStyle(1,tipColor,100);
                  g.moveTo(tipData.x,tipData.y);
                  g.beginFill(16777215,1);
                  g.drawCircle(tipData.x,tipData.y,TOOLTIP_TARGET_RADIUS);
                  g.endFill();
                  g.beginFill(tipColor,1);
                  g.drawCircle(tipData.x,tipData.y,TOOLTIP_TARGET_INNER_RADIUS);
                  g.endFill();
               }
            }
         }
      }
      
      override public function invalidateSize() : void
      {
         cancelEffect();
         super.invalidateSize();
      }
      
      private function setupMouseDispatching() : void
      {
         _mouseEventsInitialzed = true;
         super.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
         super.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
         super.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
         super.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
         super.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
         super.addEventListener(MouseEvent.CLICK,mouseClickHandler);
         super.addEventListener(MouseEvent.DOUBLE_CLICK,mouseDoubleClickHandler);
      }
      
      private function mouseClickHandler(event:MouseEvent) : void
      {
         var p:Point = new Point(event.localX,event.localY);
         p = globalToLocal(DisplayObject(event.target).localToGlobal(p));
         var hitPoints:Array = findDataPoints(p.x,p.y);
         processRollEvents(hitPoints,event);
         if(Boolean(_currentHitSet) && _currentHitSet.length > 0)
         {
            dispatchEvent(new ChartItemEvent(ChartItemEvent.ITEM_CLICK,_currentHitSet,event,this));
         }
         else
         {
            dispatchEvent(new ChartEvent(ChartEvent.CHART_CLICK,event,this));
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getSelectedSeries(seriesObject:Series) : Series
      {
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
               if(_transforms[i].elements[j] is Series && _transforms[i].elements[j] != seriesObject && _transforms[i].elements[j].selectedItems.length != 0)
               {
                  break;
               }
               j++;
            }
            return _transforms[i].elements[j];
         }
         return null;
      }
      
      private function updateDataTips() : void
      {
         var hitPoints:Array = findDataPoints(mouseX,mouseY);
         _currentHitSet = hitPoints;
         updateDataTipToMatchHitSet(_currentHitSet);
      }
      
      private function reduceStacks(stacks:Array, currentStack:TipStack) : void
      {
         var prevStack:TipStack = null;
         while(stacks.length > 0)
         {
            prevStack = stacks[stacks.length - 1];
            if(prevStack.gy + prevStack.height < currentStack.gy)
            {
               break;
            }
            prevStack.merge(currentStack,screen.height);
            currentStack = stacks.pop();
         }
         stacks.push(currentStack);
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(_commitPropertiesCalled == false)
         {
            commitProperties();
         }
         graphics.clear();
         graphics.lineStyle(0,0,0);
         var fill:IFill = GraphicsUtilities.fillFromStyle(getStyle("fill"));
         GraphicsUtilities.fillRect(graphics,0,0,unscaledWidth,unscaledHeight,fill);
      }
      
      public function set description(value:String) : void
      {
         setDescription(value);
         tabEnabled = true;
      }
      
      [Inspectable(defaultValue="")]
      public function get description() : String
      {
         return _description;
      }
      
      public function getAllDataPoints() : Array
      {
         var n:int = 0;
         var i:int = 0;
         var g:IChartElement2 = null;
         var hds:Array = null;
         var result:Array = [];
         n = int(allElements.length);
         for(i = n - 1; i >= 0; i--)
         {
            g = allElements[i] as IChartElement2;
            if(!(!g || g.visible == false))
            {
               hds = g.getAllDataPoints();
               if(hds.length != 0)
               {
                  result = result.concat(hds);
               }
            }
         }
         for(i = 0; i < result.length; i++)
         {
            result[i].x += _seriesHolder.x;
            result[i].y += _seriesHolder.y;
         }
         return result;
      }
   }
}

import flash.display.*;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.*;
import mx.charts.HitData;
import mx.core.IFlexDisplayObject;
import mx.skins.ProgrammaticSkin;

class RangeSelector extends ProgrammaticSkin
{
   
   public function RangeSelector()
   {
      super();
   }
   
   public function clear() : void
   {
      var g:Graphics = graphics;
      g.clear();
   }
   
   override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
   {
      super.updateDisplayList(unscaledWidth,unscaledHeight);
      var g:Graphics = graphics;
      g.clear();
      g.moveTo(0,0);
      g.beginFill(14348799,0.5);
      g.lineStyle(1,40447);
      g.drawRect(0,0,width,height);
      g.endFill();
   }
}

class RangeEvent extends Event
{
   
   §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
   
   public static const REGION_CHANGE:String = "regionChange";
   
   public var mouseEvent:MouseEvent;
   
   [Inspectable(environment="none")]
   public var regionSelected:Rectangle;
   
   public function RangeEvent(type:String, rect:Rectangle, e:MouseEvent)
   {
      super(type);
      this.regionSelected = rect;
      this.mouseEvent = e;
   }
   
   override public function clone() : Event
   {
      return new RangeEvent(type,regionSelected,mouseEvent);
   }
}

class TipPositionData
{
   
   public var y:Number;
   
   public var width:Number;
   
   public var height:Number;
   
   public var px:Number;
   
   public var py:Number;
   
   public var isRight:Boolean;
   
   public var gx:Number;
   
   public var gy:Number;
   
   public var tip:IFlexDisplayObject;
   
   public var hd:HitData;
   
   public var x:Number;
   
   public function TipPositionData(tipInstance:IFlexDisplayObject, hitData:HitData, x:Number, y:Number, gx:Number, gy:Number)
   {
      super();
      tip = tipInstance;
      hd = hitData;
      this.x = x;
      this.y = y;
      this.gx = gx;
      this.gy = gy;
      this.width = tipInstance.measuredWidth;
      this.height = tipInstance.measuredHeight + 4;
   }
}

class TipStack
{
   
   public var gy:Number;
   
   public var height:Number;
   
   public var tips:Array = [];
   
   public function TipStack()
   {
      super();
   }
   
   public function addTip(tip:TipPositionData, screenHeight:Number) : void
   {
      tips.push(tip);
      if(tips.length == 1)
      {
         gy = tip.py;
         height = tip.height;
      }
      else if(tips.length == 2)
      {
         height += tip.height;
         gy = Math.min(screenHeight - height,Math.max(0,(tips[0].gy + tips[1].gy) / 2) - height / 2);
      }
      else
      {
         height += tip.height;
         gy = Math.min(screenHeight - height,Math.max(0,((gy + height / 2) * (tips.length - 1) + tip.gy) / tips.length - height / 2));
      }
   }
   
   public function positionY() : void
   {
      var tipData:TipPositionData = null;
      var gy:Number = Number(this.gy);
      for(var i:int = 0; i < tips.length; i++)
      {
         tipData = tips[i];
         tipData.py = gy;
         gy += tipData.height;
      }
   }
   
   public function merge(ts:TipStack, screenHeight:Number) : void
   {
      tips = tips.concat(ts.tips);
      var newHeight:Number = ts.gy + ts.height - gy;
      gy = Math.max(0,gy - (gy + height - ts.gy) / 2);
      if(gy + newHeight > screenHeight)
      {
         gy = Math.max(0,screenHeight - newHeight);
      }
      height = newHeight;
   }
}
