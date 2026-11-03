package blix.util.xml
{
   import blix.util.type.describeType;
   import flash.system.ApplicationDomain;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public final class XMLUtils
   {
      
      public static const PRIMITIVE_TYPES:Array = ["Class","String","Number","uint","int","Boolean","Date"];
      
      public static const IGNORE_TYPES:Array = ["*","Function"];
      
      private static const VECTOR:String = "__AS3__.vec::Vector";
      
      private static var manifestGroups:Array = [];
      
      public function XMLUtils()
      {
         super();
      }
      
      private static function getManifestGroupByUri(param1:String) : ManifestGroup
      {
         var _loc2_:ManifestGroup = null;
         for each(_loc2_ in manifestGroups)
         {
            if(_loc2_.namespace.uri == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private static function getManifestEntryByClassName(param1:String) : ManifestEntry
      {
         var _loc2_:ManifestGroup = null;
         var _loc3_:ManifestEntry = null;
         for each(_loc2_ in manifestGroups)
         {
            _loc3_ = _loc2_.getEntryByClassName(param1);
            if(Boolean(_loc3_))
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public static function addManifestEntry(param1:String, param2:String, param3:Namespace) : void
      {
         var _loc4_:ManifestGroup = getManifestGroupByUri(param3.uri);
         if(!_loc4_)
         {
            _loc4_ = new ManifestGroup(param3);
            manifestGroups[manifestGroups.length] = _loc4_;
         }
         var _loc5_:ManifestEntry = new ManifestEntry(param1,param2);
         _loc4_.addEntry(_loc5_);
      }
      
      public static function parseManifest(param1:XML, param2:Namespace) : void
      {
         var _loc3_:XML = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         for each(_loc3_ in param1.component)
         {
            _loc4_ = String(_loc3_.attribute("class"));
            _loc5_ = _loc4_.lastIndexOf(".");
            if(_loc5_ != -1)
            {
               _loc4_ = _loc4_.substr(0,_loc5_) + "::" + _loc4_.substr(_loc5_ + 1);
            }
            addManifestEntry(String(_loc3_.@id),_loc4_,param2);
         }
      }
      
      public static function unmarshal(param1:XML, param2:ApplicationDomain = null) : *
      {
         if(param2 == null)
         {
            param2 = ApplicationDomain.currentDomain;
         }
         return internalUnmarshal(param1,param2);
      }
      
      private static function internalUnmarshal(param1:XML, param2:ApplicationDomain) : *
      {
         var xmlName:String;
         var alias:String;
         var manifestGroup:ManifestGroup;
         var isVector:Boolean;
         var clazz:Class;
         var object:Object;
         var properties:XMLList;
         var ns:Namespace = null;
         var className:String = null;
         var typeXml:XML = null;
         var childXml:XML = null;
         var manifestEntry:ManifestEntry = null;
         var i:uint = 0;
         var childName:String = null;
         var propertyName:String = null;
         var propertyList:XMLList = null;
         var property:XML = null;
         var arr:Array = null;
         var arrayChild:XML = null;
         var xml:XML = param1;
         var scope:ApplicationDomain = param2;
         ns = xml.namespace();
         if(!ns)
         {
            return null;
         }
         xmlName = xml.name();
         alias = xmlName.substring(xmlName.indexOf("::") + 2);
         manifestGroup = getManifestGroupByUri(ns.uri);
         if(Boolean(manifestGroup))
         {
            manifestEntry = manifestGroup.getEntryByAlias(alias);
            if(Boolean(manifestEntry))
            {
               className = manifestEntry.className;
            }
         }
         if(!className)
         {
            className = xmlName.replace(".*","");
            className = className.replace("*","");
         }
         if(IGNORE_TYPES.indexOf(className) != -1)
         {
            return null;
         }
         if(PRIMITIVE_TYPES.indexOf(className) != -1)
         {
            return stringToVariable(xml.text(),className,scope);
         }
         isVector = className.indexOf(VECTOR) === 0;
         if(isVector)
         {
            if(xml.hasOwnProperty("@type"))
            {
               className += ".<" + String(xml.@type) + ">";
            }
         }
         clazz = getDefinitionByName(className) as Class;
         object = new clazz() as Object;
         typeXml = describeType(object);
         properties = typeXml.factory.children().(name() == "accessor" && @access == "readwrite" || name() == "variable");
         if(object is Array || isVector)
         {
            i = 0;
            for each(childXml in xml.children())
            {
               object[i] = internalUnmarshal(childXml,scope);
               i++;
            }
         }
         else
         {
            for each(childXml in xml.children())
            {
               childName = childXml.name();
               propertyName = childName.substring(childName.lastIndexOf("::") + 2);
               propertyList = properties.(@name == propertyName);
               if(childXml.hasSimpleContent())
               {
                  if(propertyList.length() != 0)
                  {
                     property = propertyList[0];
                     object[propertyName] = stringToVariable(String(childXml.text()),String(property.@type),scope);
                  }
               }
               else if(propertyList.length() > 0 && propertyList[0].@type == "Array")
               {
                  arr = [];
                  for each(arrayChild in childXml.children())
                  {
                     arr.push(internalUnmarshal(arrayChild,scope));
                  }
                  object[propertyName] = arr;
               }
               else
               {
                  object[propertyName] = internalUnmarshal(childXml.children()[0],scope);
               }
            }
         }
         return object;
      }
      
      public static function marshal(param1:*, param2:Boolean = true, param3:Boolean = false) : XML
      {
         return internalMarshal(param1,param2,param3,new Dictionary(true),null);
      }
      
      private static function internalMarshal(param1:*, param2:Boolean, param3:Boolean, param4:Dictionary, param5:XML) : XML
      {
         var manifestEntry:ManifestEntry;
         var xml:XML = null;
         var qualifiedClassName:String = null;
         var classAlias:String = null;
         var ns:Namespace = null;
         var item:* = undefined;
         var childXml:XML = null;
         var propertyXml:XML = null;
         var isVector:Boolean = false;
         var vectorType:String = null;
         var splitIndex:int = 0;
         var prefix:String = null;
         var uri:String = null;
         var packageName:String = null;
         var last:int = 0;
         var typeXml:XML = null;
         var properties:XMLList = null;
         var property:XML = null;
         var childName:String = null;
         var childType:String = null;
         var all:String = null;
         var object:* = param1;
         var useCache:Boolean = param2;
         var ignoreTransient:Boolean = param3;
         var ref:Dictionary = param4;
         var root:XML = param5;
         if(object == null)
         {
            return null;
         }
         xml = <_/>;
         if(object is Class)
         {
            qualifiedClassName = "Class";
         }
         else
         {
            qualifiedClassName = getQualifiedClassName(object);
            isVector = qualifiedClassName.indexOf(VECTOR) === 0;
            if(isVector)
            {
               if(qualifiedClassName.length > VECTOR.length + 2)
               {
                  vectorType = qualifiedClassName.substring(VECTOR.length + 2,qualifiedClassName.length - 1);
                  vectorType = vectorType.replace("::",".");
                  xml.@type = vectorType;
               }
               qualifiedClassName = VECTOR;
            }
         }
         manifestEntry = getManifestEntryByClassName(qualifiedClassName);
         if(Boolean(manifestEntry))
         {
            ns = manifestEntry.parent.namespace;
            classAlias = manifestEntry.alias;
         }
         else
         {
            splitIndex = qualifiedClassName.indexOf("::");
            if(splitIndex == -1)
            {
               prefix = "local";
               uri = "*";
               classAlias = qualifiedClassName;
            }
            else
            {
               classAlias = qualifiedClassName.substring(splitIndex + 2);
               packageName = qualifiedClassName.substring(0,splitIndex);
               last = packageName.lastIndexOf(".");
               prefix = packageName.substring(last + 1);
               uri = packageName + ".*";
            }
            ns = new Namespace(prefix,uri);
         }
         try
         {
            xml.setName(classAlias);
         }
         catch(e:Error)
         {
            return xml;
         }
         if(root === null)
         {
            root = xml;
         }
         root.addNamespace(ns);
         xml.setNamespace(ns);
         if(IGNORE_TYPES.indexOf(qualifiedClassName) != -1)
         {
            return null;
         }
         if(PRIMITIVE_TYPES.indexOf(qualifiedClassName) != -1)
         {
            xml.appendChild(variableToString(object,qualifiedClassName));
            return xml;
         }
         if(Boolean(ref[object]))
         {
            return xml;
         }
         ref[object] = true;
         if(object is Array || isVector)
         {
            for each(item in object)
            {
               if(item != null)
               {
                  childXml = internalMarshal(item,useCache,ignoreTransient,ref,root);
                  xml.appendChild(childXml);
               }
            }
         }
         else
         {
            typeXml = describeType(object);
            properties = typeXml.factory.children().(name() == "accessor" && @access == "readwrite" || name() == "variable");
            for each(property in properties)
            {
               if(!(ignoreTransient && property.metadata.(@name == "Transient").length() > 0))
               {
                  childName = property.@name;
                  childType = property.@type;
                  item = object[childName];
                  propertyXml = new XML("<" + childName + "/>");
                  if(Boolean(ns))
                  {
                     propertyXml.setNamespace(ns);
                  }
                  if(item != null)
                  {
                     childXml = internalMarshal(item,useCache,ignoreTransient,ref,root);
                     if(childXml != null)
                     {
                        if(PRIMITIVE_TYPES.indexOf(childType) != -1)
                        {
                           propertyXml.appendChild(childXml.text());
                        }
                        else
                        {
                           propertyXml.appendChild(childXml);
                        }
                     }
                  }
                  appendChildSorted(xml,propertyXml);
               }
            }
            if(Boolean(typeXml.@isDynamic))
            {
               for(all in object)
               {
                  item = object[all];
                  propertyXml = new XML("<" + all + "/>");
                  if(Boolean(ns))
                  {
                     propertyXml.setNamespace(ns);
                  }
                  childType = getQualifiedClassName(item);
                  childXml = internalMarshal(item,useCache,ignoreTransient,ref,root);
                  propertyXml.appendChild(childXml);
                  appendChildSorted(xml,propertyXml);
               }
            }
         }
         return xml;
      }
      
      public static function appendChildSorted(param1:XML, param2:XML, param3:Function = null) : void
      {
         if(param3 == null)
         {
            param3 = alphabeticalSortCompare;
         }
         var _loc4_:XMLList = param1.children();
         var _loc5_:uint = uint(_loc4_.length());
         var _loc6_:int = findChildInsertionIndex(_loc4_,param2,param3,0,_loc5_);
         if(_loc6_ == _loc5_)
         {
            param1.appendChild(param2);
         }
         else
         {
            param1.insertChildBefore(_loc4_[_loc6_],param2);
         }
      }
      
      public static function alphabeticalSortCompare(param1:XML, param2:XML) : int
      {
         if(param1 == null)
         {
            return -1;
         }
         if(param2 == null)
         {
            return 1;
         }
         var _loc3_:String = String(param1.name()).toLowerCase();
         var _loc4_:String = String(param2.name()).toLowerCase();
         if(_loc3_ == _loc4_)
         {
            return 0;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         return -1;
      }
      
      private static function findChildInsertionIndex(param1:XMLList, param2:XML, param3:Function, param4:uint, param5:uint) : int
      {
         if(param4 == param5)
         {
            return param4;
         }
         var _loc6_:uint = uint(param4 + param5 >> 1);
         var _loc7_:XML = param1[_loc6_];
         if(param3(param2,_loc7_) < 0)
         {
            return findChildInsertionIndex(param1,param2,param3,param4,_loc6_);
         }
         return findChildInsertionIndex(param1,param2,param3,_loc6_ + 1,param5);
      }
      
      private static function variableToString(param1:*, param2:String) : String
      {
         switch(param2)
         {
            case "Number":
            case "String":
            case "Boolean":
            case "int":
            case "uint":
               return String(param1);
            case "Date":
               return (param1 as Date).toString();
            case "Class":
               return getQualifiedClassName(param1);
            default:
               return "";
         }
      }
      
      private static function stringToVariable(param1:String, param2:String, param3:ApplicationDomain) : *
      {
         switch(param2)
         {
            case "String":
               return param1;
            case "Boolean":
               return param1.toLowerCase() == "true" || param1 == "1";
            case "Number":
               return parseFloat(param1);
            case "int":
            case "uint":
               return parseInt(param1);
            case "Date":
               return new Date(param1);
            case "Class":
               return param3.getDefinition(param1) as Class;
            default:
               return null;
         }
      }
   }
}

class ManifestGroup
{
   
   public var namespace:Namespace;
   
   public var entries:Array = [];
   
   public function ManifestGroup(param1:Namespace)
   {
      super();
      this.namespace = param1;
   }
   
   public function addEntry(param1:ManifestEntry) : void
   {
      param1.parent = this;
      this.entries.push(param1);
   }
   
   public function getEntryByAlias(param1:String) : ManifestEntry
   {
      var _loc2_:ManifestEntry = null;
      for each(_loc2_ in this.entries)
      {
         if(_loc2_.alias == param1)
         {
            return _loc2_;
         }
      }
      return null;
   }
   
   public function getEntryByClassName(param1:String) : ManifestEntry
   {
      var _loc2_:ManifestEntry = null;
      for each(_loc2_ in this.entries)
      {
         if(_loc2_.className == param1)
         {
            return _loc2_;
         }
      }
      return null;
   }
}

class ManifestEntry
{
   
   public var alias:String;
   
   public var className:String;
   
   public var parent:ManifestGroup;
   
   public function ManifestEntry(param1:String, param2:String)
   {
      super();
      this.alias = param1;
      this.className = param2;
   }
}
