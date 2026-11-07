package mx.olap
{
   import flash.utils.Dictionary;
   import mx.collections.IList;
   
   public class CubeNodeBuilder
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      public var rootNode:CubeNode;
      
      private var currentLevel:int;
      
      private var allNodeAtLevel:Array;
      
      private var nextLevel:int;
      
      private var _cube:OLAPCube;
      
      private var closingNodesBelow:Array;
      
      private var prevLevel:int;
      
      private var measureMembers:IList;
      
      private var measureMap:Object = {};
      
      private var computeEndMap:Dictionary = new Dictionary(false);
      
      private var computeObjEndMap:Dictionary = new Dictionary(false);
      
      public var allNodePropertyName:String = "(All)";
      
      public var levelPreviousToMeasuresIndex:int;
      
      private var rootCellValues:Array;
      
      private var prevValueAtLevel:Array;
      
      private var closingValues:Array;
      
      private var prevNodeAtLevel:Array;
      
      private var measuresLength:int;
      
      public function CubeNodeBuilder()
      {
         super();
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
                  addValueToNode(target,property,value,null,null);
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
                        target[allNodePropertyName] = newNode = new CubeNode();
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
                        addValueToNode(target,allNodePropertyName,value,null,null);
                        for(otherProperty in target)
                        {
                           if(!(otherProperty == allNodePropertyName || otherProperty == property))
                           {
                              addValueToNode(target,allNodePropertyName,target[otherProperty],null,null);
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
                  addValueToNode(target,property,value,null,null);
               }
            }
         }
      }
      
      public function initNodeBuilding() : void
      {
         var measure:OLAPMeasure = null;
         prevNodeAtLevel = [];
         allNodeAtLevel = [];
         prevValueAtLevel = [];
         measureMembers = _cube.findDimension("Measures").members;
         measuresLength = measureMembers.length;
         for each(measure in measureMembers)
         {
            computeEndMap[measure] = [];
            computeObjEndMap[measure] = [];
            measureMap[measure.name] = measure;
         }
      }
      
      public function moveToNextRound() : void
      {
         currentLevel = 0;
         prevLevel = -1;
         nextLevel = 1;
      }
      
      private function addValueToNode(node:Object, name:String, value:Object, measure:OLAPMeasure, rowData:Object) : void
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
               node[name] = aggregator.computeBegin(measure.dataField);
               computeEndMap[measure].push(node);
               aggregator.computeLoop(node[name],measure.dataField,rowData);
            }
            else
            {
               aggregator.computeLoop(node[name],measure.dataField,rowData);
            }
         }
         else if(!node.hasOwnProperty(name))
         {
            node[name] = temp = new SummaryNode();
            ++node.numCells;
            for(prop in value)
            {
               measure = measureMap[prop];
               aggregator = measure.aggregator as IOLAPCustomAggregator;
               if(temp.hasOwnProperty(prop))
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
               measure = measureMap[prop];
               aggregator = measure.aggregator as IOLAPCustomAggregator;
               if(temp.hasOwnProperty(prop))
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
      
      public function set cube(c:IOLAPCube) : void
      {
         _cube = c as OLAPCube;
      }
      
      public function completeNodeBuilding() : Boolean
      {
         var temp:Array = null;
         var y:Object = null;
         var measure:OLAPMeasure = null;
         var aggregator:IOLAPCustomAggregator = null;
         var x:Object = null;
         var tempLevel:int = 0;
         var closingNodeLength:int = 0;
         var tempIndex:int = 0;
         var rootCell:String = null;
         var closingValue:Object = null;
         var closingNode:Object = null;
         if(Boolean(prevNodeAtLevel) && Boolean(prevValueAtLevel))
         {
            rootNode = prevNodeAtLevel[0];
            closingNodesBelow = prevNodeAtLevel.reverse();
            closingValues = prevValueAtLevel.reverse();
            tempLevel = closingNodesBelow.length - 1;
            closingNodeLength = int(closingNodesBelow.length);
            for(tempIndex = 0; tempIndex < closingNodeLength; tempIndex++)
            {
               if(tempLevel >= 1)
               {
                  closingValue = closingValues[tempIndex];
                  closingNode = closingNodesBelow[tempIndex];
                  if(closingNode[closingValue] is CubeNode)
                  {
                     if(closingNode[allNodePropertyName] is CubeNode)
                     {
                        if(closingNode.numCells == 2)
                        {
                           closingNode[allNodePropertyName] = closingNode[closingValue];
                        }
                        else
                        {
                           accumValuesFromNode(closingNode[allNodePropertyName],closingNode[closingValue]);
                        }
                     }
                  }
                  tempLevel--;
               }
            }
            prevNodeAtLevel = null;
            prevValueAtLevel = null;
            allNodeAtLevel = null;
            rootCellValues = [];
            for(rootCell in rootNode)
            {
               if(rootCell != allNodePropertyName)
               {
                  rootCellValues.push(rootCell);
               }
            }
            return false;
         }
         if(!Boolean(rootCellValues.length))
         {
            for(x in computeEndMap)
            {
               measure = x as OLAPMeasure;
               aggregator = measure.aggregator as IOLAPCustomAggregator;
               temp = computeEndMap[x];
               for each(y in temp)
               {
                  y["saved_" + measure.name] = y[measure.name];
                  y[measure.name] = aggregator.computeEnd(y[measure.name],measure.dataField);
               }
               delete computeEndMap[x];
            }
            for(x in computeObjEndMap)
            {
               measure = x as OLAPMeasure;
               aggregator = measure.aggregator as IOLAPCustomAggregator;
               temp = computeObjEndMap[x];
               for each(y in temp)
               {
                  y["saved_" + measure.name] = y[measure.name];
                  y[measure.name] = aggregator.computeObjectEnd(y[measure.name],measure.dataField);
               }
               delete computeObjEndMap[x];
            }
            computeEndMap = new Dictionary(false);
            computeObjEndMap = new Dictionary(false);
            optimizeCube();
            return true;
         }
         rootCell = rootCellValues.pop();
         accumValuesFromNode(rootNode[allNodePropertyName],rootNode[rootCell]);
         return false;
      }
      
      private function optimizeCube() : void
      {
         var total:int = 0;
         if(Boolean(rootNode))
         {
            total = findNodeWithOneCell(rootNode);
         }
      }
      
      public function addValueToNodeBuilder(values:Object, currentData:Object) : void
      {
         var value:Object = null;
         var prevNode:CubeNode = null;
         var prevValue:Object = null;
         var closingValue:Object = null;
         var closingNode:Object = null;
         var tempLevel:int = 0;
         var closingNodeLength:int = 0;
         var tempIndex:int = 0;
         var newNode:CubeNode = null;
         var allNode:CubeNode = null;
         var temp:Object = null;
         var mIndex:int = 0;
         var measureMember:OLAPMember = null;
         var newDataValue:Object = null;
         var prevLevelNode:Object = null;
         var prevLevelValue:Object = null;
         for each(value in values)
         {
            prevNode = prevNodeAtLevel[currentLevel];
            prevValue = prevValueAtLevel[currentLevel];
            if(Boolean(prevValue))
            {
               if(prevValue != value)
               {
                  closingNodesBelow = prevNodeAtLevel.splice(nextLevel).reverse();
                  closingValues = prevValueAtLevel.splice(nextLevel).reverse();
                  tempLevel = currentLevel + closingNodesBelow.length;
                  closingNodeLength = int(closingNodesBelow.length);
                  for(tempIndex = 0; tempIndex < closingNodeLength; tempIndex++)
                  {
                     if(tempLevel != 0)
                     {
                        closingValue = closingValues[tempIndex];
                        closingNode = closingNodesBelow[tempIndex];
                        if(closingNode[closingValue] is CubeNode)
                        {
                           if(closingNode[allNodePropertyName] is CubeNode)
                           {
                              if(tempLevel > currentLevel && closingNode.numCells == 2)
                              {
                                 closingNode[allNodePropertyName] = closingNode[closingValue];
                              }
                              else
                              {
                                 accumValuesFromNode(closingNode[allNodePropertyName],closingNode[closingValue]);
                              }
                           }
                        }
                     }
                     tempLevel--;
                  }
                  closingValue = prevValue;
                  closingNode = prevNode;
                  if(currentLevel != 0 && closingNode[closingValue] is CubeNode)
                  {
                     if(closingNode[allNodePropertyName] is CubeNode)
                     {
                        accumValuesFromNode(closingNode[allNodePropertyName],closingNode[closingValue]);
                     }
                  }
               }
            }
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
               allNode = allNodeAtLevel[currentLevel];
               if(!allNode)
               {
                  if(currentLevel > 0)
                  {
                     allNodeAtLevel[currentLevel] = allNode = new CubeNode(currentLevel);
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
            if(currentLevel == levelPreviousToMeasuresIndex)
            {
               if(!prevNode.hasOwnProperty(value))
               {
                  prevNode[value] = new SummaryNode();
                  ++prevNode.numCells;
               }
               if(prevNode[allNodePropertyName] is CubeNode || prevNode[allNodePropertyName] is Number)
               {
                  temp = prevNode[allNodePropertyName] = new SummaryNode();
               }
               else
               {
                  temp = prevNode[allNodePropertyName];
               }
               for(mIndex = 0; mIndex < measuresLength; mIndex++)
               {
                  measureMember = measureMembers.getItemAt(mIndex) as OLAPMember;
                  newDataValue = currentData[measureMember.dataField];
                  if(typeof newDataValue == "xml")
                  {
                     newDataValue = Number(newDataValue.toString());
                  }
                  newDataValue = Number(newDataValue);
                  addValueToNode(prevNode[value],measureMember.name,newDataValue,measureMember as OLAPMeasure,currentData);
                  addValueToNode(temp,measureMember.name,newDataValue,measureMember as OLAPMeasure,currentData);
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
      }
      
      private function findNodeWithOneCell(node:CubeNode) : int
      {
         var x:String = null;
         var cNode:CubeNode = null;
         var total:int = 0;
         if(node.numCells == 2)
         {
            total++;
         }
         for(x in node)
         {
            if(node.numCells == 2)
            {
               if(node[allNodePropertyName] != node[x])
               {
                  delete node[allNodePropertyName];
                  node[allNodePropertyName] = node[x];
               }
            }
            cNode = node[x] as CubeNode;
            if(Boolean(cNode))
            {
               total += findNodeWithOneCell(cNode);
            }
         }
         return total;
      }
   }
}

