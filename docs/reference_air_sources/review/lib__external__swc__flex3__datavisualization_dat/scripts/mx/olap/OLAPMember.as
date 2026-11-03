package mx.olap
{
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   
   public class OLAPMember extends OLAPElement implements IOLAPMember
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _level:IOLAPLevel;
      
      private var _parent:IOLAPMember;
      
      private var _childrenMap:Dictionary = new Dictionary(true);
      
      private var _children:IList = new ArrayCollection();
      
      private var _all:Boolean = false;
      
      private var _dataField:String;
      
      public function OLAPMember(name:String = null, displayName:String = null)
      {
         OLAPTrace.traceMsg("Creating member: " + name,OLAPTrace.TRACE_LEVEL_3);
         super(name,displayName);
      }
      
      public function get hierarchy() : IOLAPHierarchy
      {
         return level.hierarchy;
      }
      
      public function set level(level:IOLAPLevel) : void
      {
         _level = level;
      }
      
      override public function get uniqueName() : String
      {
         var list:Array = [];
         list.push(this);
         var parent:IOLAPMember = this.parent;
         if(hierarchy is OLAPAttribute)
         {
            list.push(hierarchy);
         }
         else
         {
            while(Boolean(parent) && Boolean(parent.parent))
            {
               list.push(parent);
               parent = parent.parent;
            }
            list.push(hierarchy.levels.getItemAt(0));
            list.push(hierarchy);
         }
         list.push(dimension);
         var uName:String = "";
         for(var index:int = list.length - 1; index > -1; index--)
         {
            uName += "[" + list[index].name + "].";
         }
         return uName.substring(0,uName.length - 1);
      }
      
      public function get isMeasure() : Boolean
      {
         return false;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setIsAll(value:Boolean) : void
      {
         _all = value;
      }
      
      public function get level() : IOLAPLevel
      {
         return _level;
      }
      
      public function findChildMember(name:String) : IOLAPMember
      {
         return _childrenMap[name];
      }
      
      public function set dataField(field:String) : void
      {
         _dataField = field;
      }
      
      public function set parent(p:IOLAPMember) : void
      {
         _parent = p;
      }
      
      public function get parent() : IOLAPMember
      {
         return _parent;
      }
      
      override public function get dimension() : IOLAPDimension
      {
         if(Boolean(level) && Boolean(level.hierarchy))
         {
            return level.hierarchy.dimension;
         }
         return null;
      }
      
      public function get isAll() : Boolean
      {
         return _all;
      }
      
      public function get dataField() : String
      {
         return _dataField;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addChild(m:IOLAPMember) : void
      {
         _children.addItem(m);
         _childrenMap[m.name] = m;
      }
      
      public function get children() : IList
      {
         return _children;
      }
   }
}

