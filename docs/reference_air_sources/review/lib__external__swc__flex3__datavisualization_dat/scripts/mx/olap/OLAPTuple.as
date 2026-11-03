package mx.olap
{
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   
   public class OLAPTuple implements IOLAPTuple
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _explicitMembers:ArrayCollection = new ArrayCollection();
      
      private var _userMembers:Array = [];
      
      private var cachedMembers:ArrayCollection = new ArrayCollection();
      
      private var cacheValid:Boolean;
      
      private var explicitMembersValid:Boolean = false;
      
      public function OLAPTuple()
      {
         super();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get membersArray() : Array
      {
         var x:IList = members;
         return cachedMembers.source;
      }
      
      public function get explicitMembers() : IList
      {
         if(!explicitMembersValid)
         {
            _explicitMembers.source = _userMembers.slice(0);
            explicitMembersValid = true;
         }
         return _explicitMembers;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeElementsAtEnd(count:int) : void
      {
         explicitMembersValid = false;
         cacheValid = false;
         _userMembers.splice(-1,count);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get userMembers() : Array
      {
         var m:IOLAPMember = null;
         var temp:Array = [];
         for each(m in _userMembers)
         {
            temp.push(m);
            if(!(m.hierarchy is OLAPAttribute))
            {
               m = m.parent;
               while(Boolean(m) && OLAPHierarchy(m.hierarchy).allLevel != m.level)
               {
                  temp.push(m);
                  m = m.parent;
               }
            }
         }
         return temp;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function clear() : void
      {
         cacheValid = false;
         _userMembers.splice(0);
         explicitMembersValid = false;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get members() : IList
      {
         var m:IOLAPMember = null;
         var levelCount:int = 0;
         var index:int = 0;
         var measure:Object = null;
         var mt:IOLAPMember = null;
         var level:OLAPAttributeLevel = null;
         var hierarchy:OLAPHierarchy = null;
         var newMem:IOLAPMember = null;
         if(cacheValid)
         {
            return cachedMembers;
         }
         var temp:Array = [];
         var cube:OLAPCube = (_userMembers[0] as IOLAPMember).level.hierarchy.dimension.cube as OLAPCube;
         var attributeLevels:Array = cube.attributeLevels;
         var userLevels:Dictionary = new Dictionary();
         for each(m in _userMembers)
         {
            userLevels[m.level] = m;
            mt = m;
            while(Boolean(mt.parent) && Boolean(mt.parent.parent))
            {
               mt = mt.parent;
               userLevels[mt.level] = mt;
            }
         }
         levelCount = int(attributeLevels.length);
         for(index = 0; index < levelCount; index++)
         {
            level = attributeLevels[index];
            hierarchy = level.hierarchy as OLAPHierarchy;
            newMem = userLevels[level];
            if(!newMem)
            {
               if(hierarchy is OLAPAttribute)
               {
                  newMem = userLevels[level.userLevel];
               }
            }
            if(Boolean(newMem))
            {
               temp.push(newMem);
               if(level == hierarchy.allLevel)
               {
                  index++;
               }
            }
            else if(level == hierarchy.allLevel)
            {
               if(!userLevels[attributeLevels[index + 1]] && !userLevels[attributeLevels[index + 1].userLevel])
               {
                  temp.push(hierarchy.allMember);
                  index++;
               }
            }
            else if(Boolean(level.levelAllMember))
            {
               temp.push(level.levelAllMember);
            }
            else
            {
               temp.push(hierarchy.defaultMember);
            }
         }
         var measureFound:Boolean = false;
         for each(measure in explicitMembers)
         {
            if(measure is OLAPMeasure)
            {
               measureFound = true;
               temp.push(measure);
               break;
            }
         }
         if(!measureFound)
         {
            temp.push(cube.defaultMeasure);
         }
         cachedMembers.source = temp;
         cacheValid = true;
         return cachedMembers;
      }
      
      public function addMember(element:IOLAPElement) : void
      {
         var dim:IOLAPDimension = null;
         var h:IOLAPHierarchy = null;
         explicitMembersValid = false;
         cacheValid = false;
         if(element is IOLAPDimension)
         {
            dim = element as IOLAPDimension;
            OLAPTrace.traceMsg("Getting default member of dimension:" + dim.name,OLAPTrace.TRACE_LEVEL_3);
            _userMembers.push(dim.defaultMember);
         }
         else if(element is IOLAPHierarchy)
         {
            h = element as IOLAPHierarchy;
            _userMembers.push(h.defaultMember);
            OLAPTrace.traceMsg("Getting default member of hierarchy:" + h.name,OLAPTrace.TRACE_LEVEL_3);
         }
         else if(element is IOLAPMember)
         {
            _userMembers.push(element);
         }
         else if(element is IOLAPLevel)
         {
            OLAPTrace.traceMsg("Error a level is being passed as input to tuple:" + element.name,OLAPTrace.TRACE_LEVEL_1);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function clone() : OLAPTuple
      {
         var newTuple:OLAPTuple = new OLAPTuple();
         newTuple._userMembers = _userMembers.slice(0);
         return newTuple;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeElements(value:IList) : void
      {
         var removeIndex:int = 0;
         explicitMembersValid = false;
         cacheValid = false;
         var length:int = int(value.length);
         for(var index:int = 0; index < length; index++)
         {
            removeIndex = _userMembers.indexOf(value.getItemAt(index));
            if(removeIndex != -1)
            {
               _userMembers.splice(removeIndex,1);
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get isValid() : Boolean
      {
         var member:OLAPMember = null;
         var attrHierarchy:OLAPAttribute = null;
         var memLevel:OLAPLevel = null;
         var nextIndex:int = 0;
         var nextMember:OLAPMember = null;
         var memberLength:int = int(_userMembers.length);
         for(var index:int = 0; index < memberLength; index++)
         {
            member = _userMembers[index];
            attrHierarchy = member.hierarchy as OLAPAttribute;
            if(attrHierarchy)
            {
               memLevel = attrHierarchy.userHierarchyLevel;
               nextIndex = 0;
               while(nextIndex < memberLength)
               {
                  if(nextIndex != index)
                  {
                     nextMember = _userMembers[nextIndex];
                     if(nextMember.level == memLevel)
                     {
                        return false;
                     }
                  }
                  nextIndex++;
               }
            }
         }
         var cube:OLAPCube = (_userMembers[0] as IOLAPMember).dimension.cube as OLAPCube;
         return cube.isTupleValid(this);
      }
      
      public function addMembers(value:IList) : void
      {
         explicitMembersValid = false;
         cacheValid = false;
         var length:int = int(value.length);
         for(var index:int = 0; index < length; index++)
         {
            _userMembers.push(value.getItemAt(index));
         }
      }
   }
}

