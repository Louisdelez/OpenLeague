package mx.charts.chartClasses
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   import mx.collections.ArrayCollection;
   import mx.collections.ICollectionView;
   import mx.collections.IList;
   import mx.collections.IViewCursor;
   import mx.collections.ListCollectionView;
   import mx.collections.XMLListCollection;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   
   public class ChartElement extends DualStyleObject implements IChartElement2
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var nextID:uint = 0;
      
      private var _userDataProvider:Object;
      
      private var _glyphID:uint;
      
      protected var cursor:IViewCursor;
      
      private var _dataProvider:ICollectionView;
      
      private var _dataTransform:DataTransform;
      
      public function ChartElement()
      {
         super();
         _glyphID = generateGlyphID();
      }
      
      private static function generateGlyphID() : uint
      {
         return nextID++;
      }
      
      public function set dataTransform(value:DataTransform) : void
      {
         var g:DisplayObject = null;
         _dataTransform = value;
         for(var i:uint = 0; i < numChildren; i++)
         {
            g = getChildAt(i);
            if(Boolean(_dataTransform) && g is IChartElement)
            {
               IChartElement(g).dataTransform = _dataTransform;
            }
         }
         if(Boolean(_dataTransform))
         {
            _dataTransform.dataChanged();
         }
         invalidateDisplayList();
      }
      
      protected function processNewDataProvider(value:Object) : void
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
            if(value is IList)
            {
               value = new ListCollectionView(IList(value));
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
         cursor = _dataProvider.createCursor();
         if(_dataProvider != null)
         {
            _dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler,false,0,true);
         }
         dataChanged();
      }
      
      public function mappingChanged() : void
      {
      }
      
      override public function addChildAt(child:DisplayObject, index:int) : DisplayObject
      {
         super.addChildAt(child,index);
         if(Boolean(_dataTransform) && child is IChartElement)
         {
            IChartElement(child).dataTransform = _dataTransform;
         }
         return child;
      }
      
      [Inspectable]
      public function get dataProvider() : Object
      {
         return _dataProvider;
      }
      
      private function collectionChangeHandler(event:CollectionEvent = null) : void
      {
         if(Boolean(event) && event.kind == CollectionEventKind.RESET)
         {
            cursor = _dataProvider.createCursor();
         }
         dataChanged();
      }
      
      public function describeData(dimension:String, requiredFields:uint) : Array
      {
         return [];
      }
      
      protected function get chart() : ChartBase
      {
         var p:DisplayObject = parent;
         while(!(p is ChartBase) && Boolean(p))
         {
            p = p.parent;
         }
         return p as ChartBase;
      }
      
      public function localToData(pt:Point) : Array
      {
         return null;
      }
      
      protected function createDataID(dataPointID:Number) : Number
      {
         return (_glyphID << 16) + dataPointID;
      }
      
      [Inspectable(environment="none")]
      public function get dataTransform() : DataTransform
      {
         return _dataTransform;
      }
      
      public function dataToLocal(... dataValues) : Point
      {
         return null;
      }
      
      protected function dataChanged() : void
      {
         invalidateDisplayList();
         if(Boolean(_dataTransform))
         {
            _dataTransform.dataChanged();
         }
      }
      
      [Inspectable(environment="none")]
      public function get labelContainer() : Sprite
      {
         return null;
      }
      
      public function chartStateChanged(oldState:uint, v:uint) : void
      {
         var c:IChartElement = null;
         var n:int = int(numChildren);
         for(var i:int = 0; i < n; i++)
         {
            c = getChildAt(i) as IChartElement;
            if(Boolean(c))
            {
               c.chartStateChanged(oldState,v);
            }
         }
      }
      
      [Inspectable(environment="none")]
      public function set chartDataProvider(value:Object) : void
      {
         if(_userDataProvider == null)
         {
            processNewDataProvider(value);
         }
      }
      
      public function set dataProvider(value:Object) : void
      {
         _userDataProvider = value;
         processNewDataProvider(value);
      }
      
      public function getAllDataPoints() : Array
      {
         var g:IChartElement2 = null;
         var hds:Array = null;
         var result:Array = [];
         for(var i:int = numChildren - 1; i >= 0; i--)
         {
            g = getChildAt(i) as IChartElement2;
            if(!(!g || g.visible == false))
            {
               hds = g.getAllDataPoints();
               if(hds.length != 0)
               {
                  result = result.concat(hds);
               }
            }
         }
         return result;
      }
      
      public function collectTransitions(chartState:Number, transitions:Array) : void
      {
         var c:IChartElement = null;
         var n:int = int(numChildren);
         for(var i:int = 0; i < n; i++)
         {
            c = getChildAt(i) as IChartElement;
            if(Boolean(c))
            {
               c.collectTransitions(chartState,transitions);
            }
         }
      }
      
      override public function addChild(child:DisplayObject) : DisplayObject
      {
         super.addChild(child);
         if(Boolean(_dataTransform) && child is IChartElement)
         {
            IChartElement(child).dataTransform = _dataTransform;
         }
         return child;
      }
      
      public function claimStyles(styles:Array, firstAvailable:uint) : uint
      {
         return firstAvailable;
      }
      
      public function findDataPoints(x:Number, y:Number, sensitivity2:Number) : Array
      {
         var g:IChartElement = null;
         var hds:Array = null;
         var result:Array = [];
         for(var i:int = numChildren - 1; i >= 0; i--)
         {
            g = getChildAt(i) as IChartElement;
            if(!(!g || g.visible == false))
            {
               hds = g.findDataPoints(x,y,sensitivity2);
               if(hds.length != 0)
               {
                  result = result.concat(hds);
               }
            }
         }
         return result;
      }
   }
}

