package mx.olap
{
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   
   [Exclude(name="elements",kind="property")]
   [Exclude(name="levels",kind="property")]
   public class OLAPAttribute extends OLAPHierarchy implements IOLAPAttribute
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      protected var _dataFunction:Function;
      
      private var uniqueMembers:IList = new ArrayCollection();
      
      private var uniqueChildrenMap:Dictionary = new Dictionary(true);
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var userDataFunction:Boolean = false;
      
      public var dataCompareFunction:Function;
      
      private var singleLevel:OLAPLevel;
      
      public var displayNameFunction:Function;
      
      private var _userHierarchyLevel:OLAPLevel;
      
      private var _userHierarchy:IOLAPHierarchy;
      
      private var _dataField:String;
      
      public function OLAPAttribute(name:String = null, displayName:String = null)
      {
         _dataFunction = internalDataFunction;
         dataCompareFunction = internalDataCompareFunction;
         super(name,displayName);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createLevel(name:String) : OLAPLevel
      {
         var l:OLAPAttributeLevel = new OLAPAttributeLevel(name);
         l.hierarchy = this;
         l.dimension = dimension;
         l.attributeName = name;
         _levels.addItem(l);
         _levelMap[name] = l;
         return l;
      }
      
      public function set dataFunction(value:Function) : void
      {
         if(value != null)
         {
            _dataFunction = value;
            userDataFunction = true;
         }
         else
         {
            _dataFunction = internalDataFunction;
            userDataFunction = false;
         }
      }
      
      override public function get children() : IList
      {
         return uniqueMembers;
      }
      
      override public function findLevel(name:String) : IOLAPLevel
      {
         return null;
      }
      
      private function internalDataFunction(rowData:Object, dataField:String) : Object
      {
         return rowData[dataField];
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set userHierarchy(value:IOLAPHierarchy) : void
      {
         _userHierarchy = value;
      }
      
      override public function get members() : IList
      {
         var temp:ArrayCollection = new ArrayCollection(uniqueMembers.toArray());
         temp.addItemAt(super.findMember(allMemberName),0);
         return temp;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function refresh() : void
      {
         uniqueChildrenMap = new Dictionary(true);
         uniqueMembers = new ArrayCollection();
         if(!super.findLevel(name))
         {
            createAllLevelIfRequired();
            singleLevel = createLevel(name);
            OLAPLevel(allLevel).refresh();
            singleLevel.refresh();
            if(Boolean(userHierarchyLevel))
            {
               if(userHierarchyLevel.depth == 1)
               {
                  OLAPAttributeLevel(allLevel).userLevel = OLAPHierarchy(userHierarchy).allLevel;
               }
               OLAPAttributeLevel(singleLevel).userLevel = userHierarchyLevel;
            }
         }
      }
      
      private function internalDataCompareFunction(data1:Object, data2:Object) : int
      {
         var value1:Object = internalDataFunction(data1,dataField);
         var value2:Object = internalDataFunction(data2,dataField);
         if(value1 < value2)
         {
            return -1;
         }
         if(value1 > value2)
         {
            return 1;
         }
         return 0;
      }
      
      override public function set levels(value:IList) : void
      {
      }
      
      override public function get hasAll() : Boolean
      {
         return true;
      }
      
      public function get dataFunction() : Function
      {
         return _dataFunction;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get userHierarchy() : IOLAPHierarchy
      {
         return _userHierarchy;
      }
      
      public function set dataField(value:String) : void
      {
         _dataField = value;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get allLevels() : IList
      {
         return new ArrayCollection([allLevel,singleLevel]);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set userHierarchyLevel(value:OLAPLevel) : void
      {
         _userHierarchyLevel = value;
      }
      
      public function get dataField() : String
      {
         return _dataField;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function processData(data:Object) : void
      {
         var m:IOLAPMember = null;
         var name:String = dataFunction(data,dataField);
         if(!uniqueChildrenMap[name])
         {
            m = singleLevel.createMember(allMember,name);
            if(displayNameFunction != null)
            {
               OLAPMember(m).displayName = displayNameFunction(name);
            }
            uniqueChildrenMap[m.name] = m;
            uniqueMembers.addItem(m);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get userHierarchyLevel() : OLAPLevel
      {
         return _userHierarchyLevel;
      }
      
      override protected function createAllLevelIfRequired() : void
      {
         var level:OLAPLevel = null;
         var index:int = 0;
         if(hasAll)
         {
            level = _levelMap[allLevelName];
            if(!level)
            {
               level = new OLAPAttributeLevel(allLevelName);
               level.hierarchy = this;
               level.dimension = dimension;
               level.attributeName = name;
               allLevel = level;
               allMember = level.createMember(null,allMemberName) as OLAPMember;
               allMember.setIsAll(true);
            }
         }
         else
         {
            allLevel = null;
            allMember = null;
            level = _levelMap[allLevelName];
            if(Boolean(level))
            {
               index = int(_levels.getItemIndex(level));
               if(index > -1)
               {
                  _levels.removeItemAt(index);
               }
               delete _levelMap[allLevelName];
            }
         }
      }
   }
}

