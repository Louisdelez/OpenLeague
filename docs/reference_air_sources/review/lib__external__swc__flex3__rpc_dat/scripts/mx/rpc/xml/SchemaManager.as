package mx.rpc.xml
{
   [ExcludeClass]
   public class SchemaManager extends QualifiedResourceManager
   {
      
      private var schemaStack:Array;
      
      private var _namespaces:Object;
      
      private var _schemaMarshaller:SchemaMarshaller;
      
      private var _schemaConstants:SchemaConstants;
      
      private var namespaceCount:uint = 0;
      
      private var initialScope:Array;
      
      private var _schemaDatatypes:SchemaDatatypes;
      
      public function SchemaManager()
      {
         super();
         initialScope = [];
         schemaStack = [];
      }
      
      public function addNamespaces(map:Object) : void
      {
         var prefix:String = null;
         var ns:Namespace = null;
         for(prefix in map)
         {
            ns = map[prefix] as Namespace;
            namespaces[prefix] = ns;
         }
      }
      
      public function releaseScope() : *
      {
         return schemaStack.pop();
      }
      
      public function marshall(value:*, type:QName = null, restriction:XML = null) : String
      {
         return schemaMarshaller.marshall(value,type,restriction);
      }
      
      public function reset() : void
      {
         namespaceCount = 0;
         schemaStack = [];
         schemaStack.push(initialScope);
      }
      
      public function pushSchemaInScope(schema:Schema) : void
      {
         var newSchemaSet:Array = null;
         if(schema != null)
         {
            newSchemaSet = [schema];
            newSchemaSet["current"] = newSchemaSet[0];
            schemaStack.push(newSchemaSet);
         }
      }
      
      public function pushNamespaceInScope(nsParam:*) : Boolean
      {
         var schema:Schema = null;
         var ns:Namespace = new Namespace(nsParam);
         var schemas:Array = currentScope();
         for(var s:int = 0; s < schemas.length; s++)
         {
            schema = schemas[s];
            if(schema.targetNamespace.uri == ns.uri)
            {
               pushSchemaInScope(schema);
               return true;
            }
         }
         return false;
      }
      
      public function getQNameForAttribute(ncname:String, form:String = null) : QName
      {
         var qname:QName = null;
         if(form == "qualified" || form == null && currentSchema.attributeFormDefault == "qualified")
         {
            qname = new QName(currentSchema.targetNamespace.uri,ncname);
         }
         else
         {
            qname = new QName("",ncname);
         }
         return qname;
      }
      
      public function currentScope() : Array
      {
         var current:Array = schemaStack.pop();
         if(current != null)
         {
            schemaStack.push(current);
         }
         else
         {
            current = [];
         }
         return current;
      }
      
      public function set schemaConstants(value:SchemaConstants) : void
      {
         _schemaConstants = value;
      }
      
      public function addSchema(schema:Schema, toCurrentScope:Boolean = true) : void
      {
         var schemaSet:Array = null;
         addResource(schema.targetNamespace,schema);
         if(toCurrentScope == true)
         {
            schemaSet = schemaStack.pop();
         }
         if(schemaSet == null)
         {
            schemaSet = [];
         }
         schemaSet.push(schema);
         if(!schemaSet.hasOwnProperty("current"))
         {
            schemaSet["current"] = schemaSet[0];
         }
         schemaStack.push(schemaSet);
         if(schemaStack.length == 1)
         {
            initialScope = schemaStack[0] as Array;
         }
      }
      
      public function getOrCreatePrefix(uri:String) : String
      {
         var result:String = null;
         var ns:Namespace = null;
         var nameSpace:Namespace = null;
         var schemaNamespaces:Object = null;
         for each(ns in namespaces)
         {
            if(ns.uri == uri)
            {
               return ns.prefix;
            }
         }
         if(currentSchema != null)
         {
            schemaNamespaces = currentSchema.namespaces;
            for each(ns in schemaNamespaces)
            {
               if(ns.uri == uri)
               {
                  return ns.prefix;
               }
            }
         }
         var prefixString:String = "ns";
         var newPrefix:String = prefixString + namespaceCount;
         if(namespaces[newPrefix] != null)
         {
            ++namespaceCount;
            newPrefix = prefixString + namespaceCount;
            nameSpace = new Namespace(newPrefix,uri);
            namespaces[newPrefix] = nameSpace;
            return newPrefix;
         }
         nameSpace = new Namespace(newPrefix,uri);
         namespaces[newPrefix] = nameSpace;
         return newPrefix;
      }
      
      private function findDefinition(schemas:Array, name:QName, componentTypes:Array) : XML
      {
         var schema:Schema = null;
         var result:Object = null;
         var definition:XML = null;
         for(var s:int = 0; s < schemas.length; s++)
         {
            schema = schemas[s];
            componentTypes.unshift(name);
            result = schema.getNamedDefinition.apply(schema,componentTypes);
            if(result != null)
            {
               definition = result.definition as XML;
               pushSchemaInScope(result.schema);
               return definition;
            }
         }
         return null;
      }
      
      public function unmarshall(value:*, type:QName = null, restriction:XML = null) : *
      {
         return schemaMarshaller.unmarshall(value,type,restriction);
      }
      
      public function set namespaces(value:Object) : void
      {
         _namespaces = value;
      }
      
      public function get schemaDatatypes() : SchemaDatatypes
      {
         if(_schemaDatatypes == null)
         {
            _schemaDatatypes = SchemaDatatypes.getConstants(schemaConstants.xsdURI);
         }
         return _schemaDatatypes;
      }
      
      public function getNamedDefinition(name:QName, ... componentTypes) : XML
      {
         var schemas:Array = currentScope();
         var definition:XML = findDefinition(schemas,name,componentTypes);
         if(definition == null && schemas != initialScope)
         {
            definition = findDefinition(initialScope,name,componentTypes);
         }
         return definition;
      }
      
      public function get namespaces() : Object
      {
         if(_namespaces == null)
         {
            _namespaces = {};
         }
         return _namespaces;
      }
      
      public function getQNameForElement(ncname:String, form:String = null) : QName
      {
         var qname:QName = null;
         if(form == "qualified" || (form == null || form == "") && currentSchema.elementFormDefault == "qualified")
         {
            qname = new QName(currentSchema.targetNamespace.uri,ncname);
         }
         else
         {
            qname = new QName("",ncname);
         }
         return qname;
      }
      
      public function get currentSchema() : Schema
      {
         var schema:Schema = null;
         var schemaSet:Array = currentScope();
         if(schemaSet.hasOwnProperty("current"))
         {
            schema = schemaSet["current"];
         }
         return schema;
      }
      
      public function get schemaMarshaller() : SchemaMarshaller
      {
         if(_schemaMarshaller == null)
         {
            _schemaMarshaller = new SchemaMarshaller(schemaConstants,schemaDatatypes);
         }
         return _schemaMarshaller;
      }
      
      public function get schemaConstants() : SchemaConstants
      {
         if(_schemaConstants == null)
         {
            _schemaConstants = SchemaConstants.getConstants();
         }
         return _schemaConstants;
      }
      
      public function getQNameForPrefixedName(prefixedName:String, parent:XML = null, qualifyToTargetNamespace:Boolean = false) : QName
      {
         var qname:QName = null;
         var prefix:String = null;
         var localName:String = null;
         var ns:Namespace = null;
         var localNamespaces:Array = null;
         var localNS:Namespace = null;
         var parentNS:Namespace = null;
         var prefixIndex:int = prefixedName.indexOf(":");
         if(prefixIndex > 0)
         {
            prefix = prefixedName.substr(0,prefixIndex);
            localName = prefixedName.substr(prefixIndex + 1);
         }
         else
         {
            localName = prefixedName;
         }
         if(prefix == null && qualifyToTargetNamespace == true)
         {
            ns = currentSchema.targetNamespace;
         }
         if(prefix == null)
         {
            prefix = "";
         }
         if(ns == null)
         {
            if(parent != null)
            {
               localNamespaces = parent.inScopeNamespaces();
               for each(localNS in localNamespaces)
               {
                  if(localNS.prefix == prefix)
                  {
                     ns = localNS;
                     break;
                  }
               }
            }
         }
         if(ns == null)
         {
            ns = namespaces[prefix];
         }
         if(ns == null)
         {
            ns = currentSchema.namespaces[prefix];
         }
         if(ns == null)
         {
            parentNS = parent != null ? parent.namespace() : null;
            if(parentNS != null && parentNS.prefix == "")
            {
               ns = parentNS;
            }
            else
            {
               ns = currentSchema.targetNamespace;
            }
         }
         if(ns != null)
         {
            qname = new QName(ns.uri,localName);
         }
         else
         {
            qname = new QName("",localName);
         }
         return qname;
      }
   }
}

