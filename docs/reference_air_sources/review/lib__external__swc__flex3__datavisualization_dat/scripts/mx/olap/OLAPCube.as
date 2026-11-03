package mx.olap
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Proxy;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import mx.collections.ArrayCollection;
   import mx.collections.ICollectionView;
   import mx.collections.IList;
   import mx.collections.Sort;
   import mx.events.CubeEvent;
   import mx.resources.ResourceManager;
   import mx.rpc.AsyncToken;
   import mx.rpc.IResponder;
   
   [ResourceBundle("olap")]
   [DefaultProperty("elements")]
   [Event(name="queryProgress",type="mx.events.CubeEvent")]
   [Event(name="progress",type="mx.events.CubeEvent")]
   [Event(name="complete",type="mx.events.CubeEvent")]
   public class OLAPCube extends Proxy implements IOLAPCube, IEventDispatcher
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var prepare:Boolean = false;
      
      private var _dataProvider:ICollectionView;
      
      private var _cubeImpl:IOLAPCubeImpl = new DefaultCubeImpl();
      
      private var dimIndex:int = 0;
      
      private var progress:int;
      
      private var _queryToken:Dictionary = new Dictionary(true);
      
      private var ev:EventDispatcher;
      
      private var cubeBuildingTimer:Timer;
      
      private var _measures:IList;
      
      private var total:int;
      
      protected var workDuration:int = 50;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _defaultTupleMembers:Array;
      
      protected var measureDimensionName:String = "Measures";
      
      private var queryTimer:Timer;
      
      protected var resultClass:Class = OLAPResult;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var defaultMeasure:OLAPMeasure;
      
      private var oldSort:Sort;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var attributeToIndex:Dictionary;
      
      private var _attributeLevels:Array;
      
      protected var queryBuildingTimeInterval:int = 1;
      
      private var _queriesPending:Array = [];
      
      private var _dimensions:IList = new ArrayCollection();
      
      private var _dimensionMap:Dictionary = new Dictionary(true);
      
      private var _name:String;
      
      protected var cubeBuildingTimeInterval:int = 5;
      
      public function OLAPCube(name:String = null)
      {
         OLAPTrace.traceMsg("Creating cube: " + name,OLAPTrace.TRACE_LEVEL_3);
         super();
         this.name = name;
         ev = new EventDispatcher(this);
      }
      
      public function cancelRefresh() : void
      {
         prepare = false;
         progress = 0;
         _cubeImpl.cancelRefresh();
         if(Boolean(cubeBuildingTimer))
         {
            cubeBuildingTimer.stop();
            cubeBuildingTimer.removeEventListener(TimerEvent.TIMER,updateDimensions);
            cubeBuildingTimer.removeEventListener(TimerEvent.TIMER,buildCube);
            cubeBuildingTimer = null;
         }
         if(Boolean(oldSort))
         {
            dataProvider.sort = oldSort;
            dataProvider.refresh();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set cubeImpl(value:IOLAPCubeImpl) : void
      {
         _cubeImpl = value;
         _cubeImpl.cube = this;
      }
      
      private function getAxisHierarchies(axis:IOLAPQueryAxis) : Array
      {
         var tempSet:OLAPSet = null;
         var tuples:Array = null;
         var tupleIndex:int = 0;
         var tempTuple:OLAPTuple = null;
         var list:IList = null;
         var memIndex:int = 0;
         var tempHeirarchy:OLAPHierarchy = null;
         var axisHierarchies:Array = [];
         var sets:Array = axis.sets;
         for(var setIndex:int = 0; setIndex < sets.length; setIndex++)
         {
            tempSet = sets[setIndex];
            tuples = tempSet.tuples;
            for(tupleIndex = 0; tupleIndex < tuples.length; tupleIndex++)
            {
               tempTuple = tuples[tupleIndex];
               list = tempTuple.explicitMembers;
               for(memIndex = 0; memIndex < list.length; memIndex++)
               {
                  tempHeirarchy = list.getItemAt(memIndex).hierarchy as OLAPHierarchy;
                  if(Boolean(tempHeirarchy))
                  {
                     axisHierarchies.push(tempHeirarchy);
                  }
               }
            }
         }
         return axisHierarchies;
      }
      
      public function execute(query:IOLAPQuery) : AsyncToken
      {
         if(_queriesPending.indexOf(query) != -1)
         {
            return null;
         }
         var token:AsyncToken = new AsyncToken(null);
         _queriesPending.push(query);
         _queryToken[query] = {"tok":token};
         if(!queryTimer)
         {
            queryTimer = new Timer(queryBuildingTimeInterval);
            queryTimer.addEventListener(TimerEvent.TIMER,executeQuery);
            queryTimer.start();
         }
         return token;
      }
      
      private function updateDimensions(event:TimerEvent) : void
      {
         if(!prepare)
         {
            oldSort = dataProvider.sort;
            prepare = true;
            dimIndex = 0;
            dispatchCubeProgress(dimIndex,dimensions.length,"Processing dimension: " + dimensions.getItemAt(dimIndex).name);
            return;
         }
         if(dimIndex < dimensions.length)
         {
            dispatchCubeProgress(dimIndex,dimensions.length,"Processing dimension: " + dimensions.getItemAt(dimIndex).name);
            dimensions.getItemAt(dimIndex).refresh();
            ++dimIndex;
            return;
         }
         dispatchCubeProgress(dimIndex,dimensions.length);
         prepare = false;
         cubeBuildingTimer.stop();
         cubeBuildingTimer.removeEventListener(TimerEvent.TIMER,updateDimensions);
         dataProvider.sort = oldSort;
         oldSort = null;
         dataProvider.refresh();
         if(Boolean(cubeImpl))
         {
            cubeImpl.cube = this;
            cubeImpl.refresh();
            cubeBuildingTimer.addEventListener(TimerEvent.TIMER,buildCube);
            cubeBuildingTimer.start();
            progress = 0;
            total = dataProvider.length;
         }
      }
      
      public function set elements(value:Array) : void
      {
         var element:Object = null;
         var dims:ArrayCollection = new ArrayCollection();
         var userMeasures:ArrayCollection = new ArrayCollection();
         for each(element in value)
         {
            if(element is OLAPDimension)
            {
               dims.addItem(element);
            }
            else if(element is OLAPMeasure)
            {
               userMeasures.addItem(element);
            }
            else
            {
               OLAPTrace.traceMsg("Invalid element specified for cube elements");
            }
         }
         dimensions = dims;
         measures = userMeasures;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return ev.willTrigger(type);
      }
      
      public function cancelQuery(query:IOLAPQuery) : void
      {
         var queryIndex:int = _queriesPending.indexOf(query);
         if(queryIndex != -1)
         {
            if(queryIndex == 0)
            {
               _cubeImpl.cancelQuery(query);
            }
            _queriesPending.splice(queryIndex,1);
            delete _queryToken[query];
            if(_queriesPending.length == 0)
            {
               queryTimer.stop();
               queryTimer = null;
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get defaultTupleMembers() : Array
      {
         var aIndex:int = 0;
         var index:int = 0;
         var attr:OLAPAttribute = null;
         if(!_defaultTupleMembers)
         {
            _defaultTupleMembers = new Array(attributeLevels.length / 2);
            attributeToIndex = new Dictionary();
            aIndex = 0;
            for(index = 0; index < attributeLevels.length; index += 2)
            {
               attr = attributeLevels[index].attribute;
               attributeToIndex[attr] = aIndex;
               _defaultTupleMembers[aIndex++] = attr.defaultMember;
            }
         }
         return _defaultTupleMembers.slice();
      }
      
      public function refresh() : void
      {
         var measuresDim:OLAPDimension = null;
         var measuresHierarchy:OLAPHierarchy = null;
         var measuresLevel:OLAPLevel = null;
         var mIndex:int = 0;
         var message:String = null;
         var m:OLAPMeasure = null;
         _attributeLevels = null;
         if(!findDimension(measureDimensionName))
         {
            measuresDim = createDimension(measureDimensionName);
            measuresHierarchy = measuresDim.createHierarchy(measureDimensionName);
            measuresHierarchy.hasAll = false;
            measuresHierarchy.dimension = measuresDim;
            measuresLevel = measuresHierarchy.createLevel(measureDimensionName);
            measuresDim.setAsMeasure(true);
            measuresDim.refresh();
            if(!_measures || _measures.length == 0)
            {
               message = ResourceManager.getInstance().getString("olap","noMeasures");
               throw Error(message);
            }
            for(mIndex = 0; mIndex < _measures.length; mIndex++)
            {
               m = _measures.getItemAt(mIndex) as OLAPMeasure;
               m.dimension = measuresDim;
               measuresLevel.addMember(m);
            }
         }
         defaultMeasure = _measures.getItemAt(0) as OLAPMeasure;
         if(!dataProvider)
         {
            return;
         }
         cubeBuildingTimer = new Timer(cubeBuildingTimeInterval);
         cubeBuildingTimer.addEventListener(TimerEvent.TIMER,updateDimensions);
         cubeBuildingTimer.start();
      }
      
      public function set name(value:String) : void
      {
         _name = value;
      }
      
      private function dispatchCubeProgress(progress:int, total:int, message:String = null) : void
      {
         var ev:CubeEvent = new CubeEvent(CubeEvent.CUBE_PROGRESS);
         ev.progress = progress;
         ev.total = total;
         ev.message = message;
         dispatchEvent(ev);
      }
      
      public function set dimensions(value:IList) : void
      {
         var dim:OLAPDimension = null;
         _attributeLevels = null;
         _dimensions = value;
         for(var dimIndex:int = 0; dimIndex < value.length; dimIndex++)
         {
            dim = value.getItemAt(dimIndex) as OLAPDimension;
            dim.cube = this;
            _dimensionMap[dim.name] = dim;
         }
      }
      
      public function toString() : String
      {
         return name;
      }
      
      private function findDuplicateHierarchies(axisHierarchies1:Array, axisHierarchies2:Array) : OLAPHierarchy
      {
         var h:OLAPHierarchy = null;
         var foundIndex:int = 0;
         for each(h in axisHierarchies1)
         {
            foundIndex = axisHierarchies2.indexOf(h);
            if(foundIndex > -1)
            {
               return h;
            }
         }
         return null;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get attributeLevels() : Array
      {
         var a:OLAPAttribute = null;
         var dim:IOLAPDimension = null;
         var h:OLAPHierarchy = null;
         var hLevels:IList = null;
         var length:int = 0;
         var index:int = 0;
         if(Boolean(_attributeLevels))
         {
            return _attributeLevels;
         }
         _attributeLevels = [];
         for each(dim in dimensions)
         {
            if(!dim.isMeasure)
            {
               for each(a in dim.attributes)
               {
                  if(!a.userHierarchyLevel)
                  {
                     _attributeLevels = _attributeLevels.concat(a.allLevels.toArray());
                  }
               }
               for each(h in dim.hierarchies)
               {
                  hLevels = h.levels;
                  length = int(hLevels.length);
                  for(index = 0; index < length; index++)
                  {
                     a = OLAPLevel(hLevels.getItemAt(index)).attribute;
                     _attributeLevels = _attributeLevels.concat(a.allLevels.toArray());
                  }
               }
            }
         }
         return _attributeLevels;
      }
      
      public function set measures(value:IList) : void
      {
         _measures = value;
      }
      
      public function get dataProvider() : ICollectionView
      {
         return _dataProvider;
      }
      
      public function dispatchEvent(event:Event) : Boolean
      {
         return ev.dispatchEvent(event);
      }
      
      public function findDimension(name:String) : IOLAPDimension
      {
         return _dimensionMap[name];
      }
      
      public function createDimension(name:String) : OLAPDimension
      {
         var dim:OLAPDimension = new OLAPDimension(name);
         dim.cube = this;
         _dimensions.addItem(dim);
         _dimensionMap[name] = dim;
         return dim;
      }
      
      private function buildCube(event:TimerEvent) : void
      {
         var cubeBuilt:Boolean = false;
         if(progress == total + 1)
         {
            dispatchCubeProgress(progress - 1,total,"Finalizing...Please wait");
            ++progress;
            return;
         }
         var startTime:int = getTimer();
         var timeTaken:int = 0;
         while(timeTaken < workDuration)
         {
            cubeBuilt = cubeImpl.buildCubeIteratively();
            if(cubeBuilt)
            {
               break;
            }
            if(progress > total)
            {
               dispatchCubeProgress(total,total,"Finalizing...Please wait");
            }
            else
            {
               dispatchCubeProgress(progress++,total,"Processing data Row: " + progress + " of " + total);
            }
            timeTaken = getTimer() - startTime;
         }
         if(cubeBuilt)
         {
            dispatchEvent(new CubeEvent(CubeEvent.CUBE_COMPLETE));
            cubeBuildingTimer.stop();
            cubeBuildingTimer = null;
         }
      }
      
      public function get dimensions() : IList
      {
         return _dimensions;
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         ev.removeEventListener(type,listener,useCapture);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function isTupleValid(tuple:OLAPTuple) : Boolean
      {
         return DefaultCubeImpl(cubeImpl).isTupleValid(tuple);
      }
      
      private function executeQuery(event:TimerEvent) : void
      {
         var token:AsyncToken = null;
         var responder:IResponder = null;
         var result:OLAPResult = null;
         var q:IOLAPQuery = null;
         var deleteEntry:Boolean = false;
         var holder:Object = _queryToken[_queriesPending[0]];
         token = holder.tok;
         if(token.hasResponder())
         {
            q = _queriesPending[0];
            deleteEntry = true;
            try
            {
               if(!holder.hasOwnProperty("result"))
               {
                  validateQuery(q);
                  holder["result"] = result = new resultClass();
               }
               else
               {
                  result = holder.result;
               }
               if(!_cubeImpl.execute(q,result))
               {
                  deleteEntry = false;
                  return;
               }
            }
            catch(qe:QueryError)
            {
               for each(responder in token.responders)
               {
                  responder.fault(qe.message);
               }
               result = null;
            }
            catch(e:Error)
            {
               for each(responder in token.responders)
               {
                  responder.fault(e.message);
               }
               result = null;
            }
            finally
            {
               if(deleteEntry)
               {
                  _queriesPending.splice(0,1);
                  delete _queryToken[q];
                  if(_queriesPending.length == 0)
                  {
                     queryTimer.stop();
                     queryTimer = null;
                  }
               }
            }
            if(Boolean(result))
            {
               for each(responder in token.responders)
               {
                  responder.result(result);
               }
            }
         }
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         ev.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return ev.hasEventListener(type);
      }
      
      public function set dataProvider(value:ICollectionView) : void
      {
         var collection:ICollectionView = value as ICollectionView;
         _dataProvider = collection;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get cubeImpl() : IOLAPCubeImpl
      {
         return _cubeImpl;
      }
      
      private function validateQuery(q:IOLAPQuery) : void
      {
         var axisHierarchies1:Array = null;
         var axisIndex:int = 0;
         var axisHierarchies2:Array = null;
         var dup:OLAPHierarchy = null;
         var message:String = null;
         var axes:Array = OLAPQuery(q).axes;
         loop0:
         for(var prevAxisIndex:int = 0; prevAxisIndex < axes.length; )
         {
            axisHierarchies1 = getAxisHierarchies(axes[prevAxisIndex]);
            axisIndex = prevAxisIndex + 1;
            while(true)
            {
               if(axisIndex >= axes.length)
               {
                  prevAxisIndex++;
                  continue loop0;
               }
               axisHierarchies2 = getAxisHierarchies(axes[axisIndex]);
               dup = findDuplicateHierarchies(axisHierarchies1,axisHierarchies2);
               if(Boolean(dup))
               {
                  break;
               }
               axisIndex++;
            }
            message = ResourceManager.getInstance().getString("olap","duplicateHierarchyOnAxes",[dup.name,prevAxisIndex,axisIndex]);
            throw new QueryError(message);
         }
      }
   }
}

