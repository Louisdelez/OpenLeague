package mx.olap
{
   import flash.utils.getTimer;
   import mx.collections.ArrayCollection;
   import mx.collections.CursorBookmark;
   import mx.collections.IList;
   import mx.collections.IViewCursor;
   import mx.collections.Sort;
   import mx.collections.SortField;
   import mx.events.CubeEvent;
   
   public class DefaultCubeImpl implements IOLAPCubeImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _cube:OLAPCube;
      
      private var _queryProgress:int = 0;
      
      private var rowPos:IList;
      
      private var reachedEnd:Boolean = false;
      
      private var slicerPositions:Array;
      
      private var actionFunction:Function;
      
      private var measureInSlice:IOLAPMember;
      
      private var nodeBuilder:CubeNodeBuilder;
      
      private var prepared:Boolean = false;
      
      private var validColumns:Array;
      
      private var queryRowCount:int;
      
      private var colAxis:OLAPResultAxis;
      
      private var queryCubeRowIndex:int;
      
      private var queryColCount:int;
      
      private var newSort:Sort;
      
      private var queryCubeBuilt:Boolean;
      
      private var oldSort:Sort;
      
      private var levels:Array;
      
      private var queryCubeColIndex:int;
      
      private var iterator:IViewCursor = null;
      
      private var resultRowCount:int;
      
      private var queryTuples:Array;
      
      private var rowAxis:OLAPResultAxis;
      
      private var queryTuplesBuilt:Boolean;
      
      private var rowPositions:Array;
      
      private var colPos:IList;
      
      protected var queryProgressEventThreashold:int = 1000;
      
      private var removableSlicerMembers:IList;
      
      private var currentPosition:CursorBookmark = CursorBookmark.FIRST;
      
      private var queryCubeBuilder:QueryCubeBuilder;
      
      private var colPositions:Array;
      
      private var validRowPositions:Boolean = true;
      
      private var tupleIndexObject:Object = {};
      
      private var newResult:OLAPResult;
      
      private var queryTuple:OLAPTuple;
      
      private var slicerAxis:OLAPResultAxis;
      
      private var queryAxisPositions:Array;
      
      private var validRows:Array;
      
      private var _queryTotal:int = 0;
      
      public function DefaultCubeImpl()
      {
         actionFunction = prepareForNewQuery;
         super();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function isTupleValid(tuple:OLAPTuple) : Boolean
      {
         var tupleMember:IOLAPMember = null;
         var generatedTupleMembers:Array = tuple.membersArray;
         var value:* = rootNode;
         var memCount:int = generatedTupleMembers.length - 1;
         for(var tupleIndex:int = 0; tupleIndex < memCount; tupleIndex++)
         {
            tupleMember = generatedTupleMembers[tupleIndex];
            if(tupleMember.isAll)
            {
               value = value[allNodePropertyName];
            }
            else
            {
               value = value[tupleMember.name];
               if(value === undefined)
               {
                  return false;
               }
            }
         }
         return true;
      }
      
      public function cancelRefresh() : void
      {
         prepared = false;
         currentPosition = CursorBookmark.FIRST;
         iterator = null;
         if(Boolean(newSort))
         {
            _cube.dataProvider.sort = oldSort;
            _cube.dataProvider.refresh();
         }
      }
      
      private function prepareResult(query:IOLAPQuery) : void
      {
         var member:IOLAPMember = null;
         var position:OLAPAxisPosition = null;
         var queryPositions:Array = null;
         var t:OLAPTuple = null;
         queryCubeBuilt = false;
         queryTuplesBuilt = false;
         colPositions = [];
         rowPositions = [];
         queryTuples = [];
         queryTuple = new OLAPTuple();
         queryAxisPositions = [];
         var queryIndex:int = 0;
         var queryAxis:OLAPQueryAxis = query.getAxis(queryIndex) as OLAPQueryAxis;
         while(Boolean(queryAxis))
         {
            queryPositions = [];
            for each(t in queryAxis.tuples)
            {
               position = new OLAPAxisPosition();
               for each(member in t.explicitMembers)
               {
                  position.addMember(member);
               }
               queryPositions.push(position);
            }
            if(Boolean(queryPositions.length))
            {
               queryAxisPositions.push(queryPositions);
               newResult.setAxis(queryIndex,new OLAPResultAxis());
               tupleIndexObject[queryIndex] = 0;
            }
            queryIndex++;
            queryAxis = query.getAxis(queryIndex) as OLAPQueryAxis;
         }
         colPositions = queryAxisPositions[0];
         if(Boolean(queryAxisPositions[1]))
         {
            rowPositions = queryAxisPositions[1];
         }
         colAxis = newResult.getAxis(0) as OLAPResultAxis;
         rowAxis = newResult.getAxis(1) as OLAPResultAxis;
         if(!rowAxis)
         {
            rowAxis = new OLAPResultAxis();
            newResult.setAxis(OLAPResult.ROW_AXIS,rowAxis);
         }
         slicerAxis = newResult.getAxis(2) as OLAPResultAxis;
         slicerPositions = queryAxisPositions[2];
      }
      
      private function initNodeBuilder() : void
      {
         if(!nodeBuilder)
         {
            nodeBuilder = new CubeNodeBuilder();
            nodeBuilder.cube = _cube;
            nodeBuilder.levelPreviousToMeasuresIndex = levels.length - 1;
         }
         nodeBuilder.initNodeBuilding();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get rootNode() : CubeNode
      {
         return nodeBuilder.rootNode;
      }
      
      public function get queryProgress() : int
      {
         return _queryProgress;
      }
      
      private function dispatchCubeProgress(progress:int, total:int, message:String = null) : void
      {
         var ev:CubeEvent = new CubeEvent(CubeEvent.QUERY_PROGRESS);
         ev.progress = progress;
         ev.total = total;
         if(!message)
         {
            ev.message = "Processing cell : " + progress + " of " + total;
         }
         ev.message = message;
         _cube.dispatchEvent(ev);
      }
      
      public function buildCubeIteratively() : Boolean
      {
         var level:OLAPLevel = null;
         var attr:OLAPAttribute = null;
         var dim:IOLAPDimension = null;
         var fields:Array = null;
         var field:SortField = null;
         var h:OLAPHierarchy = null;
         var currentData:Object = null;
         var values:Array = null;
         var value:Object = null;
         if(!_cube.dataProvider)
         {
            return true;
         }
         if(!prepared)
         {
            levels = [];
            for each(dim in _cube.dimensions)
            {
               if(!dim.isMeasure)
               {
                  for each(attr in dim.attributes)
                  {
                     if(!attr.userHierarchyLevel)
                     {
                        levels = levels.concat(attr.levels.toArray());
                     }
                  }
                  for each(h in dim.hierarchies)
                  {
                     levels = levels.concat(h.levels.toArray());
                  }
               }
            }
            oldSort = _cube.dataProvider.sort;
            newSort = new Sort();
            fields = [];
            for each(level in levels)
            {
               if(Boolean(level.attribute) && level.attribute.userDataFunction)
               {
                  attr = level.attribute;
                  field = new SortField(attr.dataField);
                  field.compareFunction = attr.dataCompareFunction;
                  fields.push(field);
               }
               else
               {
                  field = new SortField(level.dataField);
                  fields.push(field);
               }
            }
            newSort.fields = fields;
            _cube.dataProvider.sort = newSort;
            _cube.dataProvider.refresh();
            nodeBuilder = null;
            queryCubeBuilder = null;
            initNodeBuilder();
            prepared = true;
            iterator = _cube.dataProvider.createCursor();
            return false;
         }
         iterator.seek(currentPosition);
         if(!iterator.afterLast && currentPosition != CursorBookmark.LAST)
         {
            currentData = iterator.current;
            nodeBuilder.moveToNextRound();
            values = [];
            for each(level in levels)
            {
               value = level.dataFunction(currentData,level.dataField);
               values.push(value);
            }
            nodeBuilder.addValueToNodeBuilder(values,currentData);
            iterator.moveNext();
            currentPosition = iterator.bookmark;
            return false;
         }
         if(!completeNodeBuilder())
         {
            return false;
         }
         prepared = false;
         currentPosition = CursorBookmark.FIRST;
         iterator = null;
         if(Boolean(newSort))
         {
            _cube.dataProvider.sort = oldSort;
            _cube.dataProvider.refresh();
         }
         return true;
      }
      
      private function completeNodeBuilder() : Boolean
      {
         return nodeBuilder.completeNodeBuilding();
      }
      
      private function insertResult() : Boolean
      {
         var mainCubeTuple:OLAPTuple = null;
         var tArray:Array = null;
         var value:* = undefined;
         if(queryCubeColIndex >= colPos.length)
         {
            return true;
         }
         while(queryCubeRowIndex < rowPos.length || rowPos.length == 0 && queryCubeRowIndex == 0)
         {
            tArray = queryTuples[queryCubeRowIndex][queryCubeColIndex];
            if(tArray)
            {
               mainCubeTuple = tArray[0];
               value = undefined;
               if(Boolean(queryRootNode))
               {
                  if(Boolean(removableSlicerMembers) && Boolean(removableSlicerMembers.length))
                  {
                     mainCubeTuple.removeElementsAtEnd(removableSlicerMembers.length);
                     if(Boolean(measureInSlice))
                     {
                        mainCubeTuple.addMember(measureInSlice);
                     }
                  }
                  value = readCubeCell(queryRootNode,false,mainCubeTuple.membersArray);
               }
               else if(value == undefined)
               {
                  value = readCubeCell(rootNode,true,mainCubeTuple.membersArray);
               }
               if(value != undefined)
               {
                  validRows[queryCubeRowIndex] = 1;
                  validColumns[queryCubeColIndex] = 1;
                  newResult.setCell(queryCubeRowIndex,queryCubeColIndex,Number(value));
               }
               ++queryCubeRowIndex;
               return false;
            }
            ++queryCubeRowIndex;
         }
         queryCubeRowIndex = 0;
         ++queryCubeColIndex;
         return false;
      }
      
      private function addMeasureToQueryNodeBuilder(value:Object, data:Object, measure:OLAPMeasure) : void
      {
         queryCubeBuilder.addMeasureValueToNode(value,data,measure);
      }
      
      private function buildQueryTuples(query:IOLAPQuery) : Boolean
      {
         var member:IOLAPMember = null;
         var a:Array = null;
         if(queryCubeColIndex < colPositions.length)
         {
            if(!(queryCubeRowIndex < queryRowCount || !validRowPositions && queryCubeRowIndex == 0))
            {
               queryCubeRowIndex = 0;
               ++queryCubeColIndex;
               return false;
            }
            do
            {
               getNextTuple();
               if(isTupleValid(queryTuple))
               {
                  validRows[queryCubeRowIndex] = 1;
                  validColumns[queryCubeColIndex] = 1;
                  if(!queryTuples[queryCubeRowIndex][queryCubeColIndex])
                  {
                     queryTuples[queryCubeRowIndex][queryCubeColIndex] = [queryTuple];
                  }
                  else
                  {
                     queryTuples[queryCubeRowIndex][queryCubeColIndex].push(queryTuple);
                  }
                  queryTuple = new OLAPTuple();
               }
               else
               {
                  queryTuple.clear();
               }
            }
            while(!reachedEnd && queryCubeColIndex == tupleIndexObject[0] && queryCubeRowIndex == tupleIndexObject[1]);
            ++queryCubeRowIndex;
            return false;
         }
         for(var temp:int = validRows.length - 1; temp > -1; temp--)
         {
            if(validRows[temp] == undefined)
            {
               rowPositions.splice(temp,1);
               queryTuples.splice(temp,1);
            }
         }
         queryRowCount = rowPositions.length;
         for(temp = validColumns.length - 1; temp > -1; temp--)
         {
            if(validColumns[temp] == undefined)
            {
               colPositions.splice(temp,1);
               for each(a in queryTuples)
               {
                  a.splice(temp,1);
               }
            }
         }
         _queryProgress = 0;
         queryCubeRowIndex = 0;
         queryCubeColIndex = 0;
         queryTuplesBuilt = true;
         validRows = validColumns = null;
         return true;
      }
      
      private function addValueToNodeBuilder(value:Object, data:Object) : void
      {
         nodeBuilder.addValueToNodeBuilder(value,data);
      }
      
      private function buildQueryCube(query:IOLAPQuery) : Boolean
      {
         var member:IOLAPMember = null;
         var tuple:OLAPTuple = null;
         var tupleMember:IOLAPMember = null;
         var tArray:Array = null;
         var generatedTupleMembers:Array = null;
         var value:* = undefined;
         var memCount:int = 0;
         var tupleIndex:int = 0;
         var userMembers:Array = null;
         var prevMemberName:String = null;
         var measure:OLAPMeasure = null;
         var a:Array = null;
         var cubeToRead:CubeNode = rootNode;
         if(!queryCubeBuilder)
         {
            initQueryNodeBuilder();
            validRows = new Array(queryRowCount);
            validColumns = new Array(colPositions.length);
            queryCubeRowIndex = 0;
            queryCubeColIndex = 0;
         }
         if(queryCubeColIndex < colPositions.length)
         {
            while(queryCubeRowIndex < queryRowCount || !validRowPositions && queryCubeRowIndex == 0)
            {
               tArray = queryTuples[queryCubeRowIndex][queryCubeColIndex];
               if(tArray)
               {
                  for each(tuple in tArray)
                  {
                     generatedTupleMembers = tuple.membersArray;
                     value = cubeToRead;
                     memCount = generatedTupleMembers.length - 1;
                     userMembers = tuple.explicitMembers.toArray();
                     validRows[queryCubeRowIndex] = 1;
                     validColumns[queryCubeColIndex] = 1;
                     value = cubeToRead;
                     moveToNextRoundQuery();
                     for(tupleIndex = 0; tupleIndex < memCount; tupleIndex++)
                     {
                        tupleMember = generatedTupleMembers[tupleIndex];
                        if(!Boolean(value.hasOwnProperty(tupleMember.name)))
                        {
                           value = undefined;
                           break;
                        }
                        value = value[tupleMember.name];
                        prevMemberName = tupleMember.uniqueName;
                        addValueToQueryNodeBuilder(tupleMember.uniqueName,value);
                     }
                     if(value != undefined)
                     {
                        if(value is CubeNode)
                        {
                           value = value[allNodePropertyName];
                        }
                        measure = generatedTupleMembers[generatedTupleMembers.length - 1] as OLAPMeasure;
                        addMeasureToQueryNodeBuilder(tupleMember.uniqueName,value,measure);
                     }
                  }
                  ++queryCubeRowIndex;
                  return false;
               }
               ++queryCubeRowIndex;
            }
            queryCubeRowIndex = 0;
            ++queryCubeColIndex;
            return false;
         }
         completeQueryNodeBuilding();
         for(var temp:int = validRows.length - 1; temp > -1; temp--)
         {
            if(validRows[temp] == undefined)
            {
               rowPositions.splice(temp,1);
               queryTuples.splice(temp,1);
            }
         }
         queryRowCount = rowPositions.length;
         for(temp = validColumns.length - 1; temp > -1; temp--)
         {
            if(validColumns[temp] == undefined)
            {
               colPositions.splice(temp,1);
               for each(a in queryTuples)
               {
                  a.splice(temp,1);
               }
            }
         }
         _queryProgress = 0;
         queryCubeRowIndex = 0;
         queryCubeColIndex = 0;
         queryCubeBuilt = true;
         return true;
      }
      
      public function get queryTotal() : int
      {
         return _queryTotal;
      }
      
      private function buildQueryCubeAction(query:IOLAPQuery) : Boolean
      {
         var newProgress:int = 0;
         if(Boolean(slicerAxis))
         {
            if(!buildQueryCube(query))
            {
               if(_cube.hasEventListener(CubeEvent.QUERY_PROGRESS))
               {
                  newProgress = queryCubeColIndex * resultRowCount + queryCubeRowIndex;
                  if(newProgress - _queryProgress > queryProgressEventThreashold)
                  {
                     _queryProgress = newProgress;
                     dispatchCubeProgress(_queryProgress,_queryTotal,"Second Pass - Processing cell : " + _queryProgress + " of " + _queryTotal);
                  }
               }
               return false;
            }
         }
         actionFunction = buildQueryResultAction;
         prepareToGenerateResult();
         return false;
      }
      
      private function prepareForNewQuery(query:IOLAPQuery) : Boolean
      {
         queryCubeBuilder = null;
         prepareResult(query);
         validRows = validColumns = null;
         _queryProgress = 0;
         if(Boolean(rowPositions.length))
         {
            validRowPositions = true;
            queryRowCount = resultRowCount = rowPositions.length;
         }
         else
         {
            validRowPositions = false;
            resultRowCount = 1;
            queryRowCount = 0;
         }
         _queryTotal = resultRowCount * colPositions.length;
         dispatchCubeProgress(_queryProgress,_queryTotal);
         newResult.query = query;
         actionFunction = buildQueryTuplesAction;
         validRows = new Array(resultRowCount);
         validColumns = new Array(colPositions.length);
         queryCubeRowIndex = 0;
         queryCubeColIndex = 0;
         queryTuples = new Array(resultRowCount);
         for(var index:int = 0; index < resultRowCount; index++)
         {
            queryTuples[index] = new Array(colPositions.length);
         }
         reachedEnd = false;
         return false;
      }
      
      public function cancelQuery(q:IOLAPQuery) : void
      {
         actionFunction = prepareForNewQuery;
         queryCubeBuilder = null;
         validRows = validColumns = null;
         queryTuples = null;
      }
      
      public function set cube(c:IOLAPCube) : void
      {
         _cube = c as OLAPCube;
      }
      
      private function prepareToGenerateResult() : void
      {
         var member:IOLAPMember = null;
         var slicerPos:IList = null;
         var mems:ArrayCollection = null;
         var mIndex:int = 0;
         if(queryCubeRowIndex == 0 && queryCubeColIndex == 0)
         {
            dispatchCubeProgress(_queryTotal,_queryTotal);
            colAxis.positions = new ArrayCollection(colPositions);
            colPos = colAxis.positions;
            validColumns = new Array(colPos.length);
            rowAxis.positions = new ArrayCollection(rowPositions);
            rowPos = rowAxis.positions;
            validRows = new Array(rowPos.length);
            _queryProgress = 0;
            _queryTotal = resultRowCount * colPositions.length;
            removableSlicerMembers = new ArrayCollection();
            if(Boolean(slicerAxis))
            {
               slicerPos = slicerAxis.positions = new ArrayCollection(slicerPositions);
               mems = slicerPos[0].members;
               for(mIndex = 0; mIndex < mems.length; mIndex++)
               {
                  member = mems.getItemAt(mIndex) as IOLAPMember;
                  removableSlicerMembers.addItem(member);
                  if(member.isMeasure)
                  {
                     measureInSlice = member;
                  }
               }
            }
         }
      }
      
      public function execute(query:IOLAPQuery, result:OLAPResult) : Boolean
      {
         var actionResult:Boolean = false;
         var timeTaken:int = 0;
         newResult = result;
         var startTime:int = getTimer();
         do
         {
            actionResult = actionFunction(query);
            timeTaken = getTimer() - startTime;
         }
         while(!actionResult && timeTaken < 10);
         return actionResult;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function sortData() : void
      {
         var dim:IOLAPDimension = null;
         var newSort:Sort = null;
         var fields:Array = null;
         var level:OLAPLevel = null;
         var hierarchy:OLAPHierarchy = null;
         var field:SortField = null;
         for each(dim in _cube.dimensions)
         {
            for each(hierarchy in dim.hierarchies)
            {
               levels = levels.concat(hierarchy.levels.toArray());
            }
         }
         newSort = new Sort();
         fields = [];
         for each(level in levels)
         {
            field = new SortField(level.dataField);
            fields.push(field);
         }
         newSort.fields = fields;
         _cube.dataProvider.sort = newSort;
         _cube.dataProvider.refresh();
      }
      
      private function addValueToQueryNodeBuilder(value:Object, data:Object) : void
      {
         queryCubeBuilder.addValueToNodeBuilder(value,data);
      }
      
      private function moveToNextRoundQuery() : void
      {
         queryCubeBuilder.moveToNextRound();
      }
      
      private function completeQueryNodeBuilding() : void
      {
         queryCubeBuilder.completeNodeBuilding();
      }
      
      private function initQueryNodeBuilder() : void
      {
         if(!queryCubeBuilder)
         {
            queryCubeBuilder = new QueryCubeBuilder();
            queryCubeBuilder.cube = _cube;
         }
         queryCubeBuilder.initNodeBuilding();
      }
      
      private function buildQueryResultAction(query:IOLAPQuery) : Boolean
      {
         var newProgress:int = 0;
         if(!insertResult())
         {
            if(_cube.hasEventListener(CubeEvent.QUERY_PROGRESS))
            {
               newProgress = queryCubeColIndex * rowPos.length + queryCubeRowIndex;
               if(newProgress - _queryProgress > queryProgressEventThreashold)
               {
                  _queryProgress = newProgress;
                  dispatchCubeProgress(_queryProgress,_queryTotal,"Third Pass - Processing cell : " + _queryProgress + " of " + _queryTotal);
               }
            }
            return false;
         }
         dispatchCubeProgress(_queryTotal,_queryTotal,"Third Pass - Processing cell : " + _queryTotal + " of " + _queryTotal);
         for(var temp:int = validRows.length - 1; temp > -1; temp--)
         {
            if(validRows[temp] == undefined)
            {
               rowPos.removeItemAt(temp);
               newResult.removeRowData(temp);
            }
         }
         for(temp = validColumns.length - 1; temp > -1; temp--)
         {
            if(validColumns[temp] == undefined)
            {
               colPos.removeItemAt(temp);
               newResult.removeColumnData(temp);
            }
         }
         actionFunction = prepareForNewQuery;
         queryCubeBuilder = null;
         validRows = validColumns = null;
         queryTuples = null;
         return true;
      }
      
      private function buildQueryTuplesAction(query:IOLAPQuery) : Boolean
      {
         var newProgress:int = 0;
         if(!buildQueryTuples(query))
         {
            if(_cube.hasEventListener(CubeEvent.QUERY_PROGRESS))
            {
               newProgress = queryCubeColIndex * resultRowCount + queryCubeRowIndex;
               if(newProgress - _queryProgress > queryProgressEventThreashold)
               {
                  _queryProgress = newProgress;
                  dispatchCubeProgress(_queryProgress,_queryTotal,"First Pass - Processing cell : " + _queryProgress + " of " + _queryTotal);
               }
            }
            return false;
         }
         actionFunction = buildQueryCubeAction;
         return false;
      }
      
      private function getNextTuple() : OLAPTuple
      {
         var pos:Array = null;
         var lastIndex:int = 0;
         if(reachedEnd)
         {
            return null;
         }
         var tempTuple:OLAPTuple = queryTuple;
         var axisIndex:int = 0;
         for each(pos in queryAxisPositions)
         {
            tempTuple.addMembers(pos[tupleIndexObject[axisIndex]].members);
            axisIndex++;
         }
         axisIndex--;
         lastIndex = ++tupleIndexObject[axisIndex];
         if(lastIndex >= pos.length)
         {
            while(lastIndex >= pos.length)
            {
               tupleIndexObject[axisIndex] = 0;
               ++tupleIndexObject[axisIndex - 1];
               lastIndex = int(tupleIndexObject[axisIndex - 1]);
               axisIndex--;
               if(axisIndex == -1)
               {
                  reachedEnd = true;
                  break;
               }
               pos = queryAxisPositions[axisIndex];
            }
         }
         return tempTuple;
      }
      
      public function refresh() : void
      {
      }
      
      private function get allNodePropertyName() : String
      {
         return nodeBuilder.allNodePropertyName;
      }
      
      private function get allQueryNodePropertyName() : String
      {
         return queryCubeBuilder.allNodePropertyName;
      }
      
      private function get queryRootNode() : CubeNode
      {
         if(Boolean(queryCubeBuilder))
         {
            return queryCubeBuilder.rootNode;
         }
         return null;
      }
      
      private function readCubeCell(rootNode:CubeNode, mainCube:Boolean, tupleCubeMembers:Array) : *
      {
         var index:IOLAPMember = null;
         var memberName:String = null;
         var measure:OLAPMeasure = null;
         var value:* = rootNode;
         for each(index in tupleCubeMembers)
         {
            if(index.isMeasure)
            {
               memberName = index.name;
            }
            else if(index.isAll)
            {
               memberName = mainCube ? allNodePropertyName : allQueryNodePropertyName;
            }
            else
            {
               memberName = mainCube ? index.name : index.uniqueName;
            }
            if(!Boolean(value.hasOwnProperty(memberName)))
            {
               value = undefined;
               break;
            }
            value = value[memberName];
         }
         if(value != undefined)
         {
            if(value is CubeNode)
            {
               if(mainCube)
               {
                  value = value[allNodePropertyName];
               }
               else
               {
                  value = value[allQueryNodePropertyName];
               }
            }
            if(!(index is OLAPMeasure))
            {
               measure = _cube.findDimension("Measures").defaultMember as OLAPMeasure;
               value = value[measure.name];
            }
         }
         return value;
      }
   }
}

