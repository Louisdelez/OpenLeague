package mx.rpc.xml
{
   [ExcludeClass]
   public class SchemaManager extends QualifiedResourceManager
   {
      
      private var namespaceCount:uint = 0;
      
      private var schemaStack:Array;
      
      private var initialScope:Array;
      
      private var _namespaces:Object;
      
      private var _schemaMarshaller:SchemaMarshaller;
      
      private var _schemaConstants:SchemaConstants;
      
      private var _schemaDatatypes:SchemaDatatypes;
      
      public function SchemaManager()
      {
         super();
         this.initialScope = [];
         this.schemaStack = [];
      }
      
      public function get namespaces() : Object
      {
         if(this._namespaces == null)
         {
            this._namespaces = {};
         }
         return this._namespaces;
      }
      
      public function set namespaces(value:Object) : void
      {
         this._namespaces = value;
      }
      
      public function get schemaConstants() : SchemaConstants
      {
         if(this._schemaConstants == null)
         {
            this._schemaConstants = SchemaConstants.getConstants();
         }
         return this._schemaConstants;
      }
      
      public function set schemaConstants(value:SchemaConstants) : void
      {
         this._schemaConstants = value;
      }
      
      public function get schemaMarshaller() : SchemaMarshaller
      {
         if(this._schemaMarshaller == null)
         {
            this._schemaMarshaller = new SchemaMarshaller(this.schemaConstants,this.schemaDatatypes);
         }
         return this._schemaMarshaller;
      }
      
      public function get schemaDatatypes() : SchemaDatatypes
      {
         if(this._schemaDatatypes == null)
         {
            this._schemaDatatypes = SchemaDatatypes.getConstants(this.schemaConstants.xsdURI);
         }
         return this._schemaDatatypes;
      }
      
      public function addNamespaces(map:Object) : void
      {
         var prefix:String = null;
         var ns:Namespace = null;
         for(prefix in map)
         {
            ns = map[prefix] as Namespace;
            this.namespaces[prefix] = ns;
         }
      }
      
      public function addSchema(schema:Schema, toCurrentScope:Boolean = true) : void
      {
         var schemaSet:Array = null;
         addResource(schema.targetNamespace,schema);
         if(toCurrentScope == true)
         {
            schemaSet = this.schemaStack.pop();
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
         this.schemaStack.push(schemaSet);
         if(this.schemaStack.length == 1)
         {
            this.initialScope = this.schemaStack[0] as Array;
         }
      }
      
      public function get currentSchema() : Schema
      {
         var schema:Schema = null;
         var schemaSet:Array = this.currentScope();
         if(schemaSet.hasOwnProperty("current"))
         {
            schema = schemaSet["current"];
         }
         return schema;
      }
      
      public function currentScope() : Array
      {
         var current:Array = this.schemaStack.pop();
         if(current != null)
         {
            this.schemaStack.push(current);
         }
         else
         {
            current = [];
         }
         return current;
      }
      
      public function getNamedDefinition(name:QName, ... componentTypes) : XML
      {
         var schemas:Array = this.currentScope();
         var definition:XML = this.findDefinition(schemas,name,componentTypes);
         if(definition == null && schemas != this.initialScope)
         {
            definition = this.findDefinition(this.initialScope,name,componentTypes);
         }
         return definition;
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
               this.pushSchemaInScope(result.schema);
               return definition;
            }
         }
         return null;
      }
      
      public function pushNamespaceInScope(nsParam:*) : Boolean
      {
         var schema:Schema = null;
         var ns:Namespace = new Namespace(nsParam);
         var schemas:Array = this.currentScope();
         for(var s:int = 0; s < schemas.length; s++)
         {
            schema = schemas[s];
            if(schema.targetNamespace.uri == ns.uri)
            {
               this.pushSchemaInScope(schema);
               return true;
            }
         }
         return false;
      }
      
      public function pushSchemaInScope(schema:Schema) : void
      {
         var newSchemaSet:Array = null;
         if(schema != null)
         {
            newSchemaSet = [schema];
            newSchemaSet["current"] = newSchemaSet[0];
            this.schemaStack.push(newSchemaSet);
         }
      }
      
      public function getOrCreatePrefix(uri:String) : String
      {
         var result:String = null;
         var ns:Namespace = null;
         var nameSpace:Namespace = null;
         var schemaNamespaces:Object = null;
         for each(ns in this.namespaces)
         {
            if(ns.uri == uri)
            {
               return ns.prefix;
            }
         }
         if(this.currentSchema != null)
         {
            schemaNamespaces = this.currentSchema.namespaces;
            for each(ns in schemaNamespaces)
            {
               if(ns.uri == uri)
               {
                  return ns.prefix;
               }
            }
         }
         var prefixString:String = "ns";
         var newPrefix:String = prefixString + this.namespaceCount;
         if(this.namespaces[newPrefix] != null)
         {
            ++this.namespaceCount;
            newPrefix = prefixString + this.namespaceCount;
            nameSpace = new Namespace(newPrefix,uri);
            this.namespaces[newPrefix] = nameSpace;
            return newPrefix;
         }
         nameSpace = new Namespace(newPrefix,uri);
         this.namespaces[newPrefix] = nameSpace;
         return newPrefix;
      }
      
      public function getQNameForAttribute(ncname:String, form:String = null) : QName
      {
         var qname:QName = null;
         if(form == "qualified" || form == null && this.currentSchema.attributeFormDefault == "qualified")
         {
            qname = new QName(this.currentSchema.targetNamespace.uri,ncname);
         }
         else
         {
            qname = new QName("",ncname);
         }
         return qname;
      }
      
      public function getQNameForElement(ncname:String, form:String = null) : QName
      {
         var qname:QName = null;
         if(form == "qualified" || (form == null || form == "") && this.currentSchema.elementFormDefault == "qualified")
         {
            qname = new QName(this.currentSchema.targetNamespace.uri,ncname);
         }
         else
         {
            qname = new QName("",ncname);
         }
         return qname;
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
            ns = this.currentSchema.targetNamespace;
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
            ns = this.namespaces[prefix];
         }
         if(ns == null)
         {
            ns = this.currentSchema.namespaces[prefix];
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
               ns = this.currentSchema.targetNamespace;
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
      
      public function marshall(value:*, type:QName = null, restriction:XML = null) : String
      {
         return this.schemaMarshaller.marshall(value,type,restriction);
      }
      
      public function releaseScope() : *
      {
         return this.schemaStack.pop();
      }
      
      public function reset() : void
      {
         this.namespaceCount = 0;
         this.schemaStack = [];
         this.schemaStack.push(this.initialScope);
      }
      
      public function unmarshall(value:*, type:QName = null, restriction:XML = null) : *
      {
         return this.schemaMarshaller.unmarshall(value,type,restriction);
      }
   }
}

