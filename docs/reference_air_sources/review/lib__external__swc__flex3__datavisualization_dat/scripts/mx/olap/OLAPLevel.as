package mx.olap
{
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.resources.ResourceManager;
   
   [ResourceBundle("olap")]
   public class OLAPLevel extends OLAPElement implements IOLAPLevel
   {
      
      private static var tempMember:OLAPMember;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _allMemberName:String = "(All)";
      
      private var _attributeName:String;
      
      private var _membersMapOnName:Dictionary = new Dictionary(true);
      
      private var _attribute:OLAPAttribute;
      
      private var orderedMembers:ArrayCollection = new ArrayCollection();
      
      private var _hierarchy:IOLAPHierarchy;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var levelAllMember:IOLAPMember;
      
      private var _membersMapOnUName:Dictionary = new Dictionary(true);
      
      public function OLAPLevel(name:String = null, displayName:String = null)
      {
         OLAPTrace.traceMsg("Created Level: " + name,OLAPTrace.TRACE_LEVEL_3);
         super(name,displayName);
      }
      
      public function findMember(name:String) : IList
      {
         return _membersMapOnName[name];
      }
      
      override public function get uniqueName() : String
      {
         return String("[" + hierarchy.dimension.name + "].[" + hierarchy.name + "].[" + name + "]");
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createMember(parent:IOLAPMember, name:String) : IOLAPMember
      {
         var member:OLAPMember = null;
         if(Boolean(tempMember))
         {
            member = tempMember;
            member.name = name;
         }
         else
         {
            member = new OLAPMember(name);
         }
         member.parent = parent;
         member.level = this;
         member.dimension = dimension;
         if(!_membersMapOnUName[member.uniqueName])
         {
            tempMember = null;
            if(Boolean(attribute) && attribute.displayNameFunction != null)
            {
               member.displayName = attribute.displayNameFunction(name);
            }
            _membersMapOnUName[member.uniqueName] = member;
            if(Boolean(_membersMapOnName[member.name]))
            {
               _membersMapOnName[member.name].addItem(member);
            }
            else
            {
               _membersMapOnName[member.name] = new ArrayCollection();
               _membersMapOnName[member.name].addItem(member);
            }
            orderedMembers.addItem(member);
            if(Boolean(parent))
            {
               OLAPMember(parent).addChild(member);
            }
         }
         else
         {
            tempMember = member;
            member = _membersMapOnUName[member.uniqueName];
         }
         return member;
      }
      
      public function get depth() : int
      {
         return OLAPHierarchy(hierarchy).allLevels.getItemIndex(this);
      }
      
      override public function get name() : String
      {
         if(Boolean(_attribute))
         {
            return _attribute.name;
         }
         return super.name;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeMember(m:IOLAPMember) : void
      {
         var list:IList = null;
         var index:int = 0;
         if(Boolean(m))
         {
            delete _membersMapOnUName[m.uniqueName];
            list = _membersMapOnName[m.name];
            index = int(list.getItemIndex(m));
            if(index > -1)
            {
               list.removeItemAt(index);
            }
         }
      }
      
      public function set attributeName(value:String) : void
      {
         _attributeName = value;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get dataCompareFunction() : Function
      {
         if(Boolean(_attribute))
         {
            return _attribute.dataCompareFunction;
         }
         return null;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function refresh() : void
      {
         var message:String = null;
         if(!findMember(_allMemberName))
         {
            levelAllMember = createMember(null,_allMemberName);
         }
         if(Boolean(_attributeName))
         {
            _attribute = OLAPDimension(dimension).findAttribute(_attributeName) as OLAPAttribute;
            if(!_attribute)
            {
               message = ResourceManager.getInstance().getString("olap","invalidAttributeName",[_attributeName]);
               throw Error(message);
            }
         }
         else if(OLAPHierarchy(hierarchy).allLevel != this)
         {
            message = ResourceManager.getInstance().getString("olap","noAttributeForLevel",[hierarchy.name]);
            throw Error(message);
         }
      }
      
      public function get attributeName() : String
      {
         return _attributeName;
      }
      
      public function get members() : IList
      {
         if(hierarchy.allMemberName == name)
         {
            return getMembers();
         }
         return getMembers(false);
      }
      
      override public function set name(value:String) : void
      {
         OLAPTrace.traceMsg("Attempt to set the name of a level. Name of a level is defined by the associated attribute",OLAPTrace.TRACE_LEVEL_1);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get dataFunction() : Function
      {
         if(Boolean(_attribute))
         {
            return _attribute.dataFunction;
         }
         return null;
      }
      
      public function get child() : IOLAPLevel
      {
         var levels:IList = OLAPHierarchy(hierarchy).allLevels;
         var index:int = int(levels.getItemIndex(this));
         if(index < levels.length - 1)
         {
            return levels.getItemAt(index + 1) as IOLAPLevel;
         }
         return null;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeMemberByName(name:String) : void
      {
         var list:IList = null;
         var m:IOLAPMember = _membersMapOnUName[name];
         if(Boolean(m))
         {
            removeMember(m);
         }
         else
         {
            list = _membersMapOnName[name];
            if(list.length == 1)
            {
               removeMember(list.getItemAt(0) as IOLAPMember);
            }
         }
      }
      
      public function set hierarchy(h:IOLAPHierarchy) : void
      {
         _hierarchy = h;
      }
      
      public function get attribute() : OLAPAttribute
      {
         return _attribute;
      }
      
      public function get dataField() : String
      {
         if(Boolean(_attribute))
         {
            return _attribute.dataField;
         }
         return null;
      }
      
      public function get parent() : IOLAPLevel
      {
         var levels:IList = OLAPHierarchy(hierarchy).allLevels;
         var index:int = int(levels.getItemIndex(this));
         if(index >= 1)
         {
            return levels.getItemAt(index - 1) as IOLAPLevel;
         }
         return null;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getMembers(includeAll:Boolean = true) : ArrayCollection
      {
         if(includeAll)
         {
            return orderedMembers;
         }
         var tempArray:Array = orderedMembers.source.slice(0);
         var temp:ArrayCollection = new ArrayCollection(tempArray);
         var tempIndex:int = int(temp.getItemIndex(levelAllMember));
         if(tempIndex > -1)
         {
            temp.removeItemAt(tempIndex);
         }
         return temp;
      }
      
      public function get hierarchy() : IOLAPHierarchy
      {
         return _hierarchy;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addMember(m:OLAPMember) : Boolean
      {
         m.level = this;
         var member:Object = _membersMapOnUName[m.uniqueName];
         if(Boolean(member))
         {
            member = _membersMapOnName[m.name];
            if(Boolean(member))
            {
               return false;
            }
         }
         _membersMapOnUName[m.uniqueName] = m;
         if(Boolean(_membersMapOnName[m.name]))
         {
            _membersMapOnName[m.name].addItem(m);
         }
         else
         {
            _membersMapOnName[m.name] = new ArrayCollection();
            _membersMapOnName[m.name].addItem(m);
         }
         orderedMembers.addItem(m);
         return true;
      }
   }
}

