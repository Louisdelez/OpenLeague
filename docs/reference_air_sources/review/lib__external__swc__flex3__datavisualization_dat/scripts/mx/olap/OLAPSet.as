package mx.olap
{
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.resources.ResourceManager;
   
   [ResourceBundle("olap")]
   public class OLAPSet implements IOLAPSet
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var reverseCompare:Boolean = false;
      
      private var _tuples:Array = [];
      
      public function OLAPSet()
      {
         super();
      }
      
      protected function findCommonHierarchy(t1:OLAPTuple, t2:OLAPTuple) : IOLAPHierarchy
      {
         var m1:OLAPMember = null;
         var m2:OLAPMember = null;
         loop0:
         for each(m1 in t1.explicitMembers)
         {
            var _loc7_:int = 0;
            var _loc8_:* = t2.explicitMembers;
            do
            {
               for each(m2 in _loc8_)
               {
               }
               continue loop0;
            }
            while(m1.hierarchy != m2.hierarchy);
            return m1.hierarchy;
         }
         return null;
      }
      
      private function isDuplicate(t1:OLAPTuple, t2:OLAPTuple) : Boolean
      {
         var m1:IList = t1.explicitMembers;
         var m2:IList = t2.explicitMembers;
         for(var index:int = 0; index < m1.length; index++)
         {
            if(m1.getItemAt(index) != m2.getItemAt(index))
            {
               return false;
            }
         }
         return true;
      }
      
      public function addElement(e:IOLAPElement) : void
      {
         var t:OLAPTuple = null;
         var index:int = 0;
         var m:IOLAPMember = null;
         var members:IList = new ArrayCollection();
         if(e is IOLAPDimension)
         {
            members.addItem((e as IOLAPDimension).defaultMember);
         }
         if(e is IOLAPHierarchy)
         {
            members.addItem((e as IOLAPHierarchy).defaultMember);
         }
         if(e is IOLAPLevel)
         {
            members = (e as IOLAPLevel).members;
         }
         if(e is IOLAPMember)
         {
            members.addItem(e);
         }
         if(members.length > 0)
         {
            for(index = 0; index < members.length; index++)
            {
               m = members[index];
               t = new OLAPTuple();
               t.addMember(m);
               _tuples.push(t);
            }
         }
         else
         {
            OLAPTrace.traceMsg("Members were not added for " + e.uniqueName,OLAPTrace.TRACE_LEVEL_1);
         }
      }
      
      public function get tuples() : Array
      {
         return _tuples;
      }
      
      protected function validateCrossJoin(input:IOLAPSet) : void
      {
         var t1:OLAPTuple = null;
         var t2:OLAPTuple = null;
         var hierarchy:IOLAPHierarchy = null;
         var message:String = null;
         var join:OLAPSet = input as OLAPSet;
         loop0:
         for each(t1 in _tuples)
         {
            var _loc9_:int = 0;
            var _loc10_:* = join.tuples;
            do
            {
               for each(t2 in _loc10_)
               {
                  hierarchy = findCommonHierarchy(t1,t2);
               }
               continue loop0;
            }
            while(!Boolean(hierarchy));
            message = ResourceManager.getInstance().getString("olap","crossJoinSameHierarchyError",[hierarchy.uniqueName]);
            throw Error(message);
         }
      }
      
      public function addTuple(tuple:IOLAPTuple) : void
      {
         _tuples.push(tuple);
      }
      
      public function union(secondSet:IOLAPSet) : IOLAPSet
      {
         var input:OLAPSet = secondSet as OLAPSet;
         var newSet:OLAPSet = new OLAPSet();
         var ts1:Array = tuples;
         var ts2:Array = input.tuples;
         var hierarchies:Array = [];
         var t1:IOLAPTuple = ts1[0];
         var m1:IList = t1.explicitMembers;
         var explicitMemberLength:int = int(m1.length);
         for(var mIndex:int = 0; mIndex < explicitMemberLength; mIndex++)
         {
            hierarchies.push(m1.getItemAt(mIndex).hierarchy);
         }
         checkTupleHierarchies(this,explicitMemberLength,hierarchies);
         checkTupleHierarchies(input,explicitMemberLength,hierarchies);
         var newTuples:Array = tuples.concat(input._tuples);
         var arrayIndices:Array = newTuples.sort(sortTuple,Array.RETURNINDEXEDARRAY);
         var end:int = arrayIndices.length - 1;
         var duplicates:Array = [];
         for(var index:int = 0; index < end; index++)
         {
            if(isDuplicate(newTuples[arrayIndices[index]],newTuples[arrayIndices[index + 1]]))
            {
               duplicates.push(arrayIndices[index]);
            }
         }
         duplicates = duplicates.sort(Array.NUMERIC | Array.DESCENDING);
         for each(index in duplicates)
         {
            newTuples.splice(index,1);
         }
         newSet._tuples = newTuples;
         return newSet;
      }
      
      public function hierarchize(post:Boolean = false) : IOLAPSet
      {
         var index:int = 0;
         var newSet:OLAPSet = new OLAPSet();
         reverseCompare = post;
         var arrayIndices:Array = tuples.sort(sortTuple,Array.RETURNINDEXEDARRAY);
         for each(index in arrayIndices)
         {
            newSet.addTuple(_tuples[index]);
         }
         reverseCompare = false;
         return newSet;
      }
      
      public function crossJoin(input:IOLAPSet) : IOLAPSet
      {
         var tuple1:OLAPTuple = null;
         var tuple2:OLAPTuple = null;
         var join:OLAPSet = input as OLAPSet;
         validateCrossJoin(join);
         var newSet:OLAPSet = new OLAPSet();
         var tuple:OLAPTuple = new OLAPTuple();
         for each(tuple1 in _tuples)
         {
            for each(tuple2 in join.tuples)
            {
               tuple.addMembers(tuple1.explicitMembers);
               tuple.addMembers(tuple2.explicitMembers);
               if(tuple.isValid)
               {
                  newSet.addTuple(tuple);
                  tuple = new OLAPTuple();
               }
               else
               {
                  tuple.clear();
               }
            }
         }
         return newSet;
      }
      
      protected function compareMembers(m1:IOLAPMember, m2:IOLAPMember) : int
      {
         var compResult:int = 0;
         if(m1 == m2)
         {
            return 0;
         }
         while(true)
         {
            if(Boolean(m1) && !m2)
            {
               return reverseCompare ? -1 : 1;
            }
            if(!m1 && Boolean(m2))
            {
               return reverseCompare ? 1 : -1;
            }
            if(m1.level.depth < m2.level.depth)
            {
               m2 = m2.parent;
               if(m1 == m2)
               {
                  return reverseCompare ? 1 : -1;
               }
            }
            else if(m1.level.depth > m2.level.depth)
            {
               m1 = m1.parent;
               if(m1 == m2)
               {
                  return reverseCompare ? -1 : 1;
               }
            }
            else
            {
               if(m1.parent == m2.parent)
               {
                  compResult = int(m1.name.localeCompare(m2.name));
                  if(compResult == 0)
                  {
                     return 0;
                  }
                  if(compResult > 0)
                  {
                     return 1;
                  }
                  return -1;
               }
               m1 = m1.parent;
               m2 = m2.parent;
            }
         }
         return 0;
      }
      
      private function checkTupleHierarchies(olapSet:OLAPSet, length:int, hierarchies:Array) : void
      {
         var tuple:OLAPTuple = null;
         var members:IList = null;
         var mIndex:int = 0;
         var hierarchy:IOLAPHierarchy = null;
         var tuples:Array = olapSet.tuples;
         var message:String = ResourceManager.getInstance().getString("olap","unionError");
         loop0:
         for(var index:int = 0; index < tuples.length; )
         {
            tuple = tuples[index];
            members = tuple.explicitMembers;
            if(members.length != length)
            {
               throw Error(message);
            }
            mIndex = 0;
            while(true)
            {
               if(mIndex >= length)
               {
                  index++;
                  continue loop0;
               }
               hierarchy = members.getItemAt(mIndex).hierarchy;
               if(hierarchy != hierarchies[mIndex])
               {
                  break;
               }
               mIndex++;
            }
            throw Error(message);
         }
      }
      
      protected function sortTuple(t1:OLAPTuple, t2:OLAPTuple) : int
      {
         var m1:IOLAPMember = null;
         var m2:IOLAPMember = null;
         var result:int = 0;
         var t1Mems:Array = t1.explicitMembers.toArray();
         var t2Mems:Array = t2.explicitMembers.toArray();
         for(var index:int = 0; index < t1Mems.length; index++)
         {
            m1 = t1Mems[index];
            m2 = t2Mems[index];
            result = compareMembers(m1,m2);
            if(result != 0)
            {
               break;
            }
         }
         return result;
      }
      
      public function addElements(members:IList) : void
      {
         var t:OLAPTuple = null;
         var m:IOLAPMember = null;
         for(var index:int = 0; index < members.length; index++)
         {
            m = members[index];
            t = new OLAPTuple();
            t.addMember(m);
            _tuples.push(t);
         }
      }
   }
}

