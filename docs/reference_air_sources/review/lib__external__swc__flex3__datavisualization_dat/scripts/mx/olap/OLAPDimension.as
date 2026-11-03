package mx.olap
{
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   import mx.collections.ICollectionView;
   import mx.collections.IList;
   import mx.collections.IViewCursor;
   import mx.resources.ResourceManager;
   
   [DefaultProperty("elements")]
   [Exclude(name="dimension",kind="property")]
   public class OLAPDimension extends OLAPElement implements IOLAPDimension
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _isMeasureDimension:Boolean = false;
      
      private var _hierarchies:IList = new ArrayCollection();
      
      private var _cube:IOLAPCube;
      
      private var attributeMap:Dictionary = new Dictionary(true);
      
      private var _hierarchiesMap:Dictionary = new Dictionary(true);
      
      private var _attributes:IList = new ArrayCollection();
      
      public function OLAPDimension(name:String = null, displayName:String = null)
      {
         OLAPTrace.traceMsg("Creating dimension: " + name,OLAPTrace.TRACE_LEVEL_3);
         super(name,displayName);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get dataProvider() : ICollectionView
      {
         return OLAPCube(cube).dataProvider;
      }
      
      public function findHierarchy(name:String) : IOLAPHierarchy
      {
         return _hierarchiesMap[name];
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createHierarchy(name:String) : OLAPHierarchy
      {
         var h:OLAPHierarchy = new OLAPHierarchy(name);
         h.dimension = this;
         _hierarchies.addItem(h);
         _hierarchiesMap[h.name] = h;
         return h;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setAsMeasure(value:Boolean) : void
      {
         _isMeasureDimension = value;
      }
      
      public function get hierarchies() : IList
      {
         return _hierarchies;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addAttribute(name:String, dataField:String) : IOLAPAttribute
      {
         var attrHierarchy:OLAPAttribute = attributeMap[name];
         if(!attrHierarchy)
         {
            attrHierarchy = new OLAPAttribute(name);
            attrHierarchy.dataField = dataField;
            attrHierarchy.dimension = this;
            attributeMap[name] = attrHierarchy;
            _attributes.addItem(attrHierarchy);
         }
         return attrHierarchy;
      }
      
      public function get attributes() : IList
      {
         return _attributes;
      }
      
      public function get isMeasure() : Boolean
      {
         return _isMeasureDimension;
      }
      
      public function set hierarchies(value:IList) : void
      {
         var message:String = null;
         var h:OLAPHierarchy = null;
         if(value.length > 1)
         {
            message = ResourceManager.getInstance().getString("olap","multipleHierarchiesNotSupported",[name]);
            throw Error(message);
         }
         _hierarchies = value;
         for(var hIndex:int = 0; hIndex < value.length; hIndex++)
         {
            h = value.getItemAt(hIndex) as OLAPHierarchy;
            h.dimension = this;
            _hierarchiesMap[h.name] = h;
         }
      }
      
      public function set cube(value:IOLAPCube) : void
      {
         _cube = value;
      }
      
      public function set elements(value:Array) : void
      {
         var element:Object = null;
         var attrs:ArrayCollection = new ArrayCollection();
         var userHierarchies:ArrayCollection = new ArrayCollection();
         for each(element in value)
         {
            if(element is OLAPAttribute)
            {
               attrs.addItem(element);
            }
            else if(element is OLAPHierarchy)
            {
               userHierarchies.addItem(element);
            }
            else
            {
               OLAPTrace.traceMsg("Invalid element specified for dimension elements");
            }
         }
         attributes = attrs;
         hierarchies = userHierarchies;
      }
      
      public function get members() : IList
      {
         var temp:Array = [];
         for(var hIndex:int = 0; hIndex < hierarchies.length; hIndex++)
         {
            temp = temp.concat(hierarchies.getItemAt(hIndex).members.toArray());
         }
         return new ArrayCollection(temp);
      }
      
      public function findAttribute(name:String) : IOLAPAttribute
      {
         return attributeMap[name];
      }
      
      public function set attributes(value:IList) : void
      {
         var attr:OLAPAttribute = null;
         _attributes = value;
         for(var attrIndex:int = 0; attrIndex < value.length; attrIndex++)
         {
            attr = value.getItemAt(attrIndex) as OLAPAttribute;
            attr.dimension = this;
            attributeMap[attr.name] = attr;
         }
      }
      
      public function findMember(name:String) : IOLAPMember
      {
         var member:IOLAPMember = null;
         var h:OLAPHierarchy = null;
         var hIndex:int = 0;
         for(hIndex = 0; hIndex < attributes.length; hIndex++)
         {
            h = attributes.getItemAt(hIndex) as OLAPHierarchy;
            member = h.findMember(name);
            if(Boolean(member))
            {
               break;
            }
         }
         if(!member)
         {
            for(hIndex = 0; hIndex < hierarchies.length; hIndex++)
            {
               h = hierarchies.getItemAt(hIndex) as OLAPHierarchy;
               member = h.findMember(name);
               if(Boolean(member))
               {
                  break;
               }
            }
         }
         return member;
      }
      
      public function get defaultMember() : IOLAPMember
      {
         var message:String = null;
         if(hierarchies.length + attributes.length > 1)
         {
            message = ResourceManager.getInstance().getString("olap","multipleHierarchies");
            throw Error(message);
         }
         return hierarchies[0].defaultMember;
      }
      
      public function get cube() : IOLAPCube
      {
         return _cube;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function refresh() : void
      {
         var temp:Object = null;
         var hIndex:int = 0;
         var h:OLAPHierarchy = null;
         var levels:IList = null;
         var lIndex:int = 0;
         var level:OLAPLevel = null;
         var a:OLAPAttribute = null;
         var currentData:Object = null;
         if(isMeasure)
         {
            return;
         }
         var dataHandlers:Array = [];
         for(hIndex = 0; hIndex < attributes.length; hIndex++)
         {
            temp = attributes.getItemAt(hIndex);
            dataHandlers.push(temp);
         }
         for(hIndex = 0; hIndex < hierarchies.length; hIndex++)
         {
            temp = hierarchies.getItemAt(hIndex);
            temp.refresh();
            dataHandlers.push(temp);
         }
         for(hIndex = 0; hIndex < hierarchies.length; hIndex++)
         {
            h = hierarchies.getItemAt(hIndex) as OLAPHierarchy;
            levels = h.levels;
            for(lIndex = 0; lIndex < levels.length; lIndex++)
            {
               level = levels[lIndex];
               a = findAttribute(level.name) as OLAPAttribute;
               a.userHierarchy = level.hierarchy;
               a.userHierarchyLevel = level;
            }
         }
         for(hIndex = 0; hIndex < attributes.length; hIndex++)
         {
            temp = attributes.getItemAt(hIndex);
            temp.refresh();
         }
         var iterator:IViewCursor = dataProvider.createCursor();
         while(!iterator.afterLast)
         {
            currentData = iterator.current;
            for each(temp in dataHandlers)
            {
               temp.processData(currentData);
            }
            iterator.moveNext();
         }
      }
   }
}

