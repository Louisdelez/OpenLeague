package mx.olap
{
   import flash.utils.Dictionary;
   import mx.collections.IList;
   
   public class QueryCubeBuilder
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      public var rootNode:CubeNode;
      
      private var currentLevel:int;
      
      private var prevLevel:int;
      
      private var nodesToAggregate:Array;
      
      private var _cube:OLAPCube;
      
      private var closingNodesBelow:Array;
      
      private var computeEndMap:Dictionary = new Dictionary(false);
      
      private var measureMap:Object = {};
      
      private var allLevelNames:Array;
      
      private var prevValueAtLevel:Array;
      
      private var closingValues:Array;
      
      private var nodesToClose:Array = [];
      
      private var measureToAggregate:Array;
      
      private var allNodeAtLevel:Array;
      
      private var nextLevel:int;
      
      private var valueToAggregate:Array;
      
      private var measureMembers:IList;
      
      private var computeObjEndMap:Dictionary = new Dictionary(false);
      
      public var allNodePropertyName:String = "(QAll)";
      
      private var dataToAggregate:Array;
      
      private var prevNodeAtLevel:Array;
      
      public function QueryCubeBuilder()
      {
         super();
      }
      
      public function initNodeBuilding() : void
      {
         var measure:OLAPMeasure = null;
         var d:OLAPDimension = null;
         var a:OLAPAttribute = null;
         var h:OLAPHierarchy = null;
         prevNodeAtLevel = [];
         allNodeAtLevel = [];
         prevValueAtLevel = [];
         measureMap = {};
         measureMembers = _cube.findDimension("Measures").members;
         for each(measure in measureMembers)
         {
            computeEndMap[measure] = [];
            computeObjEndMap[measure] = [];
            measureMap[measure.name] = measure;
         }
         nodesToClose = [];
         nodesToAggregate = [];
         dataToAggregate = [];
         measureToAggregate = [];
         valueToAggregate = [];
         allLevelNames = [];
         for each(d in _cube.dimensions)
         {
            if(!d.isMeasure)
            {
               for each(a in d.attributes)
               {
                  allLevelNames.push(a.findMember(a.allMemberName).uniqueName);
               }
               for each(h in d.hierarchies)
               {
                  allLevelNames.push(h.findMember(h.allMemberName).uniqueName);
               }
            }
         }
      }
      
      private function addValueToNode(node:Object, name:String, value:Object, measure:OLAPMeasure) : void
      {
         var aggregator:IOLAPCustomAggregator = null;
         var temp:Object = null;
         var prop:String = null;
         var incr:Boolean = false;
         if(value is Number)
         {
            aggregator = measure.aggregator as IOLAPCustomAggregator;
            if(!node.hasOwnProperty(name))
            {
               node[name] = aggregator.computeBegin(name);
               computeEndMap[measure].push(node);
               aggregator.computeLoop(node[name],name,value);
            }
            else
            {
               aggregator.computeLoop(node[name],name,value);
            }
         }
         else if(!node.hasOwnProperty(name))
         {
            node[name] = temp = new SummaryNode();
            ++node.numCells;
            for(prop in value)
            {
               if(value is SummaryNode)
               {
                  measure = measureMap[prop];
               }
               if(Boolean(measure))
               {
                  aggregator = measure.aggregator as IOLAPCustomAggregator;
                  if(value[prop] is Number)
                  {
                     temp[name] = aggregator.computeBegin(prop);
                     computeEndMap[measure].push(temp);
                     aggregator.computeLoop(temp[name],prop,value[prop]);
                  }
                  else if(temp.hasOwnProperty(prop))
                  {
                     aggregator.computeObjectLoop(temp[prop],value[prop]);
                  }
                  else
                  {
                     temp[prop] = aggregator.computeObjectBegin(value[prop]);
                     computeObjEndMap[measure].push(temp);
                  }
               }
            }
         }
         else
         {
            if(value is SummaryNode && !(node[name] is SummaryNode))
            {
               incr = false;
               if(!node.hasOwnProperty(name))
               {
                  incr = true;
               }
               temp = node[name] = new SummaryNode();
               if(incr)
               {
                  ++node.numCells;
               }
            }
            else
            {
               temp = node[name];
            }
            for(prop in value)
            {
               if(temp.hasOwnProperty(prop))
               {
                  measure = measureMap[prop];
                  aggregator = measure.aggregator as IOLAPCustomAggregator;
                  aggregator.computeObjectLoop(temp[prop],value[prop]);
               }
               else
               {
                  if(temp is SummaryNode)
                  {
                     measure = measureMap[prop];
                  }
                  if(Boolean(measure))
                  {
                     aggregator = measure.aggregator as IOLAPCustomAggregator;
                     if(value[prop] is Number)
                     {
                        temp[prop] = aggregator.computeBegin(prop);
                        aggregator.computeLoop(temp[prop],prop,value[prop]);
                     }
                     else
                     {
                        temp[prop] = aggregator.computeObjectBegin(value[prop]);
                        computeObjEndMap[measure].push(temp);
                     }
                  }
               }
            }
         }
      }
      
      public function moveToNextRound() : void
      {
         currentLevel = 0;
         prevLevel = -1;
         nextLevel = 1;
      }
      
      public function completeNodeBuilding() : void
      {
         var node:CubeNode = null;
         var rootCell:String = null;
         var temp:Array = null;
         var y:Object = null;
         var measure:OLAPMeasure = null;
         var aggregator:IOLAPCustomAggregator = null;
         var x:Object = null;
         var closingValue:Object = null;
         var closingNode:Object = null;
         var index:int = 0;
         var prevNode:Object = null;
         var tempAllNode:Object = null;
         var allPropPresent:Boolean = false;
         var property:String = null;
         rootNode = prevNodeAtLevel[0];
         closingNodesBelow = prevNodeAtLevel.reverse();
         closingValues = prevValueAtLevel.reverse();
         var tempLevel:int = closingNodesBelow.length - 1;
         var closingNodeLength:int = int(closingNodesBelow.length);
         for(var tempIndex:int = 0; tempIndex < closingNodeLength; tempIndex++)
         {
            if(tempLevel >= 1)
            {
               closingValue = closingValues[tempIndex];
               closingNode = closingNodesBelow[tempIndex];
               if(closingNode[closingValue] is CubeNode)
               {
                  if(closingNode[allNodePropertyName] is CubeNode)
                  {
                     index = nodesToClose.indexOf(closingNode);
                     if(index == -1)
                     {
                        nodesToClose.push(closingNode);
                     }
                  }
               }
               tempLevel--;
            }
         }
         for(var aggIndex:int = 0; aggIndex < nodesToAggregate.length; aggIndex++)
         {
            prevNode = nodesToAggregate[aggIndex];
            if(!(prevNode.numCells > 2 && allLevelNames.indexOf(valueToAggregate[aggIndex]) > -1))
            {
               if(prevNode.numCells == 2)
               {
                  if(prevNode.hasOwnProperty(allNodePropertyName))
                  {
                     for(property in prevNode)
                     {
                        if(property != allNodePropertyName)
                        {
                           if(prevNode[allNodePropertyName] != prevNode[property])
                           {
                              prevNode[allNodePropertyName] = prevNode[property];
                           }
                           break;
                        }
                     }
                     continue;
                  }
               }
               if(prevNode[allNodePropertyName] is CubeNode || prevNode[allNodePropertyName] is Number)
               {
                  tempAllNode = prevNode[allNodePropertyName] = new SummaryNode();
               }
               else
               {
                  tempAllNode = prevNode[allNodePropertyName];
               }
               aggregateAllValue(tempAllNode,dataToAggregate[aggIndex],measureToAggregate[aggIndex]);
            }
         }
         nodesToClose.sort(sortCubeNodes);
         for each(node in nodesToClose)
         {
            allPropPresent = allPropertyPresent(node);
            for(property in node)
            {
               if(property != allNodePropertyName)
               {
                  if(!(node.numCells > 2 && allLevelNames.indexOf(property) > -1))
                  {
                     if(allPropPresent && node.numCells == 3)
                     {
                        node[allNodePropertyName] = node[property];
                     }
                     else
                     {
                        accumValuesFromNode(node[allNodePropertyName],node[property]);
                     }
                  }
               }
            }
         }
         for(rootCell in rootNode)
         {
            if(!(rootCell == allNodePropertyName || rootNode.numCells > 2 && allLevelNames.indexOf(rootCell) > -1))
            {
               accumValuesFromNode(rootNode[allNodePropertyName],rootNode[rootCell]);
            }
         }
         for(x in computeEndMap)
         {
            measure = x as OLAPMeasure;
            aggregator = measure.aggregator as IOLAPCustomAggregator;
            temp = computeEndMap[x];
            for each(y in temp)
            {
               y[measure.name] = aggregator.computeEnd(y[measure.name],measure.dataField);
            }
         }
         for(x in computeObjEndMap)
         {
            measure = x as OLAPMeasure;
            aggregator = measure.aggregator as IOLAPCustomAggregator;
            temp = computeObjEndMap[x];
            for each(y in temp)
            {
               y[measure.name] = aggregator.computeObjectEnd(y[measure.name],measure.dataField);
            }
         }
      }
      
      public function addMeasureValueToNode(value:Object, currentData:Object, measureToUpdate:OLAPMeasure) : void
      {
         var prevNode:CubeNode = prevNodeAtLevel[currentLevel - 1];
         var prevValue:Object = prevValueAtLevel[currentLevel - 1];
         if(!prevNode.hasOwnProperty(value))
         {
            prevNode[value] = new SummaryNode();
            ++prevNode.numCells;
         }
         aggregateAllValue(prevNode[value],currentData,measureToUpdate);
         nodesToAggregate.push(prevNode);
         dataToAggregate.push(currentData);
         measureToAggregate.push(measureToUpdate);
         valueToAggregate.push(value);
      }
      
      public function aggregateAllValue(node:Object, value:Object, measure:OLAPMeasure) : void
      {
         var temp:Object = null;
         var measureName:String = measure.name;
         var aggregator:IOLAPCustomAggregator = measure.aggregator as IOLAPCustomAggregator;
         var prop:String = "saved_" + measureName;
         if(!node.hasOwnProperty(measureName))
         {
            temp = node;
            if(Boolean(measure))
            {
               if(temp.hasOwnProperty(measureName))
               {
                  aggregator.computeObjectLoop(temp[measureName],value[prop]);
               }
               else
               {
                  temp[measureName] = aggregator.computeObjectBegin(value[prop]);
                  computeObjEndMap[measure].push(temp);
               }
            }
         }
         else
         {
            temp = node;
            if(temp.hasOwnProperty(measureName))
            {
               aggregator.computeObjectLoop(temp[measureName],value[prop]);
            }
            else if(value[prop] is Number)
            {
               temp[prop] = aggregator.computeBegin(prop);
               aggregator.computeLoop(temp[prop],prop,value[prop]);
            }
            else
            {
               temp[measureName] = aggregator.computeObjectBegin(value[prop]);
               computeObjEndMap[measure].push(temp);
            }
         }
      }
      
      private function allPropertyPresent(node:CubeNode) : Boolean
      {
         var property:String = null;
         for(property in node)
         {
            if(allLevelNames.indexOf(property) > -1)
            {
               return true;
            }
         }
         return false;
      }
      
      private function accumValuesFromNode(target:Object, source:Object) : void
      {
         var property:String = null;
         var value:Object = null;
         var newNode:CubeNode = null;
         var done:Boolean = false;
         var otherProperty:String = null;
         for(property in source)
         {
            if(property != allNodePropertyName)
            {
               if(!(source.numCells > 2 && allLevelNames.indexOf(property) > -1))
               {
                  value = source[property];
                  if(value is CubeNode)
                  {
                     if(target[property] is CubeNode)
                     {
                        newNode = target[property];
                     }
                     else
                     {
                        target[property] = newNode = new CubeNode(value.level);
                        ++target.numCells;
                     }
                     accumValuesFromNode(newNode,value);
                  }
                  else
                  {
                     addValueToNode(target,property,value,null);
                  }
               }
            }
         }
         if(target.numCells == 1)
         {
            var _loc8_:int = 0;
            var _loc9_:* = target;
            for(property in _loc9_)
            {
               target[allNodePropertyName] = target[property];
            }
            ++target.numCells;
         }
         else if(target.numCells == 2 && target.hasOwnProperty(allNodePropertyName))
         {
            for(property in target)
            {
               if(property != allNodePropertyName)
               {
                  if(target[allNodePropertyName] != target[property])
                  {
                     target[allNodePropertyName] = target[property];
                  }
                  break;
               }
            }
         }
         else
         {
            done = false;
            for(property in target)
            {
               if(property != allNodePropertyName)
               {
                  if(target[allNodePropertyName] == target[property])
                  {
                     value = target[property];
                     if(value is CubeNode)
                     {
                        target[allNodePropertyName] = newNode = new CubeNode(value.level);
                        accumValuesFromNode(newNode,value);
                        for(otherProperty in target)
                        {
                           if(!(otherProperty == allNodePropertyName || otherProperty == property))
                           {
                              accumValuesFromNode(newNode,source[otherProperty]);
                           }
                        }
                        done = true;
                     }
                     else
                     {
                        target[allNodePropertyName] = null;
                        addValueToNode(target,allNodePropertyName,value,null);
                        for(otherProperty in target)
                        {
                           if(!(otherProperty == allNodePropertyName || otherProperty == property))
                           {
                              addValueToNode(target,allNodePropertyName,target[otherProperty],null);
                           }
                        }
                        done = true;
                     }
                     break;
                  }
               }
            }
            if(!done)
            {
               property = allNodePropertyName;
               value = source[property];
               if(value is CubeNode)
               {
                  if(target[property] is CubeNode)
                  {
                     newNode = target[property];
                  }
                  else
                  {
                     target[property] = newNode = new CubeNode(value.level);
                     ++target.numCells;
                  }
                  accumValuesFromNode(newNode,value);
               }
               else
               {
                  addValueToNode(target,property,value,null);
               }
            }
         }
      }
      
      public function addValueToNodeBuilder(value:Object, currentData:Object) : void
      {
         var closingValue:Object = null;
         var closingNode:Object = null;
         var tempLevel:int = 0;
         var tempIndex:int = 0;
         var newNode:CubeNode = null;
         var prevLevelNode:Object = null;
         var prevLevelValue:Object = null;
         var prevNode:CubeNode = prevNodeAtLevel[currentLevel];
         var prevValue:Object = prevValueAtLevel[currentLevel];
         if(Boolean(prevValue))
         {
            if(prevValue != value)
            {
               closingNodesBelow = prevNodeAtLevel.splice(nextLevel).reverse();
               closingValues = prevValueAtLevel.splice(nextLevel).reverse();
               tempLevel = currentLevel + closingNodesBelow.length;
               for(tempIndex = 0; tempIndex < closingNodesBelow.length; tempIndex++)
               {
                  closingValue = closingValues[tempIndex];
                  closingNode = closingNodesBelow[tempIndex];
                  if(closingNode[closingValue] is CubeNode)
                  {
                     if(tempLevel != 0)
                     {
                        if(closingNode[allNodePropertyName] is CubeNode)
                        {
                           if(nodesToClose.indexOf(closingNode) == -1)
                           {
                              nodesToClose.push(closingNode);
                           }
                        }
                     }
                  }
                  tempLevel--;
               }
               closingValue = prevValue;
               closingNode = prevNode;
               if(closingNode[closingValue] is CubeNode)
               {
                  if(currentLevel != 0)
                  {
                     if(closingNode[allNodePropertyName] is CubeNode)
                     {
                        if(nodesToClose.indexOf(closingNode) == -1)
                        {
                           nodesToClose.push(closingNode);
                        }
                     }
                  }
               }
            }
         }
         var allNode:CubeNode = allNodeAtLevel[currentLevel];
         if(!prevNode)
         {
            newNode = new CubeNode(currentLevel);
            newNode[allNodePropertyName] = new CubeNode(currentLevel + 1);
            ++newNode.numCells;
            if(currentLevel == 0 && prevNodeAtLevel.length == 0)
            {
               rootNode = newNode;
            }
            prevNodeAtLevel[currentLevel] = newNode;
            if(!allNode)
            {
               if(currentLevel > 0)
               {
                  allNodeAtLevel[currentLevel] = allNode = new CubeNode(currentLevel + 1);
                  allNode[allNodePropertyName] = {};
                  allNodeAtLevel[prevLevel][allNodePropertyName] = allNode;
                  ++allNode.numCells;
               }
               else
               {
                  allNodeAtLevel[currentLevel] = newNode;
               }
            }
            prevNode = newNode;
         }
         else if(!prevNode.hasOwnProperty(value))
         {
            prevNodeAtLevel.splice(nextLevel);
            prevValueAtLevel.splice(nextLevel);
         }
         else if(!prevNodeAtLevel[nextLevel])
         {
            if(prevNode[value] is CubeNode)
            {
               prevNodeAtLevel[nextLevel] = prevNode[value];
            }
         }
         if(currentLevel > 0)
         {
            prevLevelNode = prevNodeAtLevel[prevLevel];
            if(!prevLevelNode.hasOwnProperty(prevValueAtLevel[prevLevel]))
            {
               prevLevelValue = prevValueAtLevel[prevLevel];
               prevLevelNode[prevLevelValue] = newNode;
               ++prevLevelNode.numCells;
            }
         }
         prevValueAtLevel[currentLevel] = value;
         ++prevLevel;
         ++currentLevel;
         ++nextLevel;
      }
      
      public function set cube(c:IOLAPCube) : void
      {
         _cube = c as OLAPCube;
      }
      
      private function sortCubeNodes(p1:CubeNode, p2:CubeNode) : int
      {
         if(p1.level == p2.level)
         {
            return 0;
         }
         if(p1.level < p2.level)
         {
            return 1;
         }
         return -1;
      }
   }
}

