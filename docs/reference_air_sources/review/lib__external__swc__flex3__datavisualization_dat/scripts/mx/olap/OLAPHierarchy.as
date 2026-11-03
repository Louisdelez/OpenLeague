package mx.olap
{
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import mx.collections.ArrayCollection;
   import mx.collections.ICollectionView;
   import mx.collections.IList;
   import mx.collections.IViewCursor;
   
   [DefaultProperty("elements")]
   public class OLAPHierarchy extends OLAPElement implements IOLAPHierarchy
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      protected var _levels:IList = new ArrayCollection();
      
      protected var _levelMap:Dictionary = new Dictionary(true);
      
      private var _dataProvider:ICollectionView;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var allMember:OLAPMember;
      
      private var allMembersCache:ArrayCollection;
      
      private var _hasAll:Boolean = true;
      
      private var _allMemberName:String = "(All)";
      
      private var _allLevel:IOLAPLevel;
      
      protected var _allLevelName:String = "(All)";
      
      protected var _allLevels:IList;
      
      public function OLAPHierarchy(name:String = null, displayName:String = null)
      {
         OLAPTrace.traceMsg("Creating hierarchy: " + name,OLAPTrace.TRACE_LEVEL_3);
         super(name,displayName);
      }
      
      override public function get name() : String
      {
         var n:String = super.name;
         if(!n)
         {
            return dimension.name;
         }
         return n;
      }
      
      public function set allMemberName(value:String) : void
      {
         var level:OLAPLevel = null;
         if(Boolean(value) && _allMemberName != value)
         {
            level = _levelMap[allLevelName];
            if(Boolean(level))
            {
               level.removeMemberByName(_allMemberName);
               _allMemberName = value;
               allMember = level.createMember(null,allMemberName) as OLAPMember;
               allMember.setIsAll(true);
            }
            else
            {
               _allMemberName = value;
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get allLevelName() : String
      {
         return _allLevelName;
      }
      
      public function get members() : IList
      {
         var levelIndex:int = 0;
         var level:OLAPLevel = null;
         var temp:Array = [];
         if(hasAll)
         {
            if(!allMembersCache)
            {
               temp.push(allMember);
               temp = temp.concat(getMembersRecursively(allMember));
               allMembersCache = new ArrayCollection(temp);
            }
            return allMembersCache;
         }
         for(levelIndex = 0; levelIndex < levels.length; levelIndex++)
         {
            level = levels.getItemAt(levelIndex) as OLAPLevel;
            temp = temp.concat(level.getMembers(false).source);
         }
         return new ArrayCollection(temp);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set allLevelName(value:String) : void
      {
         _allLevelName = value;
      }
      
      public function get hasAll() : Boolean
      {
         return _hasAll;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function processData(data:Object) : void
      {
         var parent:IOLAPMember = null;
         var level:OLAPLevel = null;
         var value:String = null;
         if(Boolean(allLevel))
         {
            parent = allLevel.members.getItemAt(0) as IOLAPMember;
         }
         for(var levelIndex:int = 0; levelIndex < levels.length; levelIndex++)
         {
            level = levels.getItemAt(levelIndex) as OLAPLevel;
            value = level.dataFunction(data,level.dataField);
            parent = level.createMember(parent,value);
         }
      }
      
      public function findMember(name:String) : IOLAPMember
      {
         var defLevel:IOLAPLevel = null;
         var list:IList = null;
         if(Boolean(allLevel))
         {
            if(name == allMemberName)
            {
               return allMember;
            }
            return allMember.findChildMember(name);
         }
         if(Boolean(levels.length))
         {
            defLevel = levels[0];
            list = defLevel.findMember(name);
            if(Boolean(list) && list.length == 1)
            {
               return list.getItemAt(0) as IOLAPMember;
            }
         }
         return null;
      }
      
      protected function createAllLevelIfRequired() : void
      {
         var level:OLAPLevel = null;
         var index:int = 0;
         if(hasAll)
         {
            level = _levelMap[allLevelName];
            if(!level)
            {
               level = new OLAPLevel(name);
               level.hierarchy = this;
               level.dimension = dimension;
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
      
      public function get defaultMember() : IOLAPMember
      {
         if(hasAll)
         {
            return allMember;
         }
         return levels.length >= 1 ? levels[0].members[0] : null;
      }
      
      public function findLevel(name:String) : IOLAPLevel
      {
         if(name == allLevelName)
         {
            return null;
         }
         return _levelMap[name];
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set allLevel(l:IOLAPLevel) : void
      {
         _allLevel = l;
      }
      
      public function set hasAll(value:Boolean) : void
      {
         if(_hasAll != value)
         {
            _allLevels = null;
         }
         _hasAll = value;
      }
      
      public function get dataProvider() : ICollectionView
      {
         if(Boolean(_dataProvider))
         {
            return _dataProvider;
         }
         return OLAPDimension(dimension).dataProvider;
      }
      
      public function get allMemberName() : String
      {
         return _allMemberName;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function refresh() : void
      {
         var level:OLAPLevel = null;
         _allLevels = null;
         allMembersCache = null;
         createAllLevelIfRequired();
         if(Boolean(allLevel))
         {
            OLAPLevel(allLevel).refresh();
         }
         for each(level in _levels)
         {
            level.dimension = dimension;
            level.refresh();
         }
      }
      
      private function getMembersRecursively(m:IOLAPMember) : Array
      {
         var member:IOLAPMember = null;
         var members:Array = null;
         var temp:Array = [];
         var children:IList = m.children;
         for(var index:int = 0; index < children.length; index++)
         {
            member = children.getItemAt(index) as IOLAPMember;
            temp.push(member);
            if(Boolean(member.children.length))
            {
               members = getMembersRecursively(member);
               temp = temp.concat(members);
            }
         }
         return temp;
      }
      
      public function set levels(value:IList) : void
      {
         var level:OLAPLevel = null;
         _levels = value;
         _levelMap = new Dictionary(true);
         for(var levelIndex:int = 0; levelIndex < levels.length; levelIndex++)
         {
            level = levels.getItemAt(levelIndex) as OLAPLevel;
            level.hierarchy = this;
            _levelMap[level.attributeName] = level;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get allLevel() : IOLAPLevel
      {
         return _allLevel;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createLevel(name:String) : OLAPLevel
      {
         var l:OLAPLevel = new OLAPLevel(name);
         l.hierarchy = this;
         l.dimension = dimension;
         _levels.addItem(l);
         _levelMap[name] = l;
         return l;
      }
      
      public function set elements(value:Array) : void
      {
         levels = new ArrayCollection(value);
      }
      
      public function get levels() : IList
      {
         return _levels;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get allLevels() : IList
      {
         if(!_allLevels)
         {
            _allLevels = new ArrayCollection(_levels.toArray());
            _allLevels.addItemAt(allLevel,0);
         }
         return _allLevels;
      }
      
      public function set dataProvider(value:ICollectionView) : void
      {
         _dataProvider = value;
      }
      
      private function makeMembers() : Boolean
      {
         var currentData:Object = null;
         var iterator:IViewCursor = dataProvider.createCursor();
         var startTime:int = getTimer();
         while(!iterator.afterLast)
         {
            currentData = iterator.current;
            processData(currentData);
            iterator.moveNext();
         }
         var endTime:int = getTimer();
         return true;
      }
      
      public function get children() : IList
      {
         var temp:IOLAPMember = null;
         var retValue:IList = null;
         if(Boolean(allLevel))
         {
            temp = allLevel.members.getItemAt(0) as IOLAPMember;
            return temp.children;
         }
         return null;
      }
   }
}

