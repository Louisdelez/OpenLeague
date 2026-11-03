package mx.rpc.xml
{
   [ExcludeClass]
   public class Schema
   {
      
      public var attributeFormDefault:String = "unqualified";
      
      public var blockDefault:String;
      
      public var elementFormDefault:String = "unqualified";
      
      public var finalDefault:String;
      
      private var importsManager:QualifiedResourceManager;
      
      private var _namespaces:Object;
      
      private var _schemaConstants:SchemaConstants;
      
      private var _schemaDatatypes:SchemaDatatypes;
      
      private var _targetNamespace:Namespace;
      
      private var _xml:XML;
      
      public function Schema(xml:XML = null)
      {
         super();
         this.xml = xml;
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
      
      public function get targetNamespace() : Namespace
      {
         return this._targetNamespace;
      }
      
      public function set targetNamespace(tns:Namespace) : void
      {
         this._targetNamespace = tns;
      }
      
      public function get schemaConstants() : SchemaConstants
      {
         if(this._schemaConstants == null)
         {
            this._schemaConstants = SchemaConstants.getConstants(this._xml);
         }
         return this._schemaConstants;
      }
      
      public function get schemaDatatypes() : SchemaDatatypes
      {
         if(this._schemaDatatypes == null)
         {
            this._schemaDatatypes = SchemaDatatypes.getConstants(this.schemaConstants.xsdURI);
         }
         return this._schemaDatatypes;
      }
      
      public function get xml() : XML
      {
         return this._xml;
      }
      
      public function set xml(value:XML) : void
      {
         var tns:String = null;
         var nsArray:Array = null;
         var ns:Namespace = null;
         this._xml = value;
         if(this._xml != null)
         {
            tns = this._xml.@targetNamespace.toString();
            this._targetNamespace = new Namespace(tns);
            this.attributeFormDefault = this._xml.@attributeFormDefault.toString();
            if(this.attributeFormDefault == "")
            {
               this.attributeFormDefault = "unqualified";
            }
            this.blockDefault = this._xml.@blockDefault.toString();
            this.elementFormDefault = this._xml.@elementFormDefault.toString();
            if(this.elementFormDefault == "")
            {
               this.elementFormDefault = "unqualified";
            }
            this.finalDefault = this._xml.@finalDefault.toString();
            this.namespaces = {};
            nsArray = this._xml.inScopeNamespaces();
            for each(ns in nsArray)
            {
               this.namespaces[ns.prefix] = ns;
            }
            this._schemaConstants = SchemaConstants.getConstants(this._xml);
            this._schemaDatatypes = SchemaDatatypes.getConstants(this._schemaConstants.xsdURI);
         }
         else
         {
            this._schemaConstants = null;
            this._schemaDatatypes = null;
         }
      }
      
      public function addImport(targetNamespace:Namespace, schema:Schema) : void
      {
         if(this.importsManager == null)
         {
            this.importsManager = new QualifiedResourceManager();
         }
         this.importsManager.addResource(targetNamespace,schema);
      }
      
      public function addInclude(fragment:XMLList) : void
      {
         this.xml.appendChild(fragment);
      }
      
      public function getNamedDefinition(definitionName:QName, ... componentTypes) : Object
      {
         var s:uint;
         var imports:Array = null;
         var schema:Schema = null;
         var currentTargetNamespace:Namespace = null;
         var schemaXML:XML = null;
         var constants:SchemaConstants = null;
         var t:uint = 0;
         var componentType:QName = null;
         var localComponentType:QName = null;
         var definition:XML = null;
         var uri:String = definitionName.uri;
         var schemas:Array = [this];
         if(this.importsManager != null)
         {
            imports = this.importsManager.getResourcesForURI(uri);
            if(imports != null)
            {
               schemas = schemas.concat(imports);
            }
         }
         loop0:
         for(s = 0; s < schemas.length; )
         {
            schema = schemas[s] as Schema;
            currentTargetNamespace = schema.targetNamespace;
            schemaXML = schema.xml;
            constants = schema.schemaConstants;
            t = 0;
            while(true)
            {
               if(t >= componentTypes.length)
               {
                  s++;
                  continue loop0;
               }
               componentType = componentTypes[t] as QName;
               if(schema.elementFormDefault == "qualified" && componentType == this.schemaConstants.elementTypeQName)
               {
                  if(uri != null && uri != "")
                  {
                     if(currentTargetNamespace == null || currentTargetNamespace.uri != uri)
                     {
                        continue;
                     }
                  }
               }
               if(schema.attributeFormDefault == "qualified" && componentType == this.schemaConstants.attributeQName)
               {
                  if(uri != null && uri != "")
                  {
                     if(currentTargetNamespace == null || currentTargetNamespace.uri != uri)
                     {
                        continue;
                     }
                  }
               }
               if(!(componentType != this.schemaConstants.elementTypeQName && componentType != this.schemaConstants.attributeQName && currentTargetNamespace.uri != definitionName.uri))
               {
                  localComponentType = new QName(constants.xsdURI,componentType.localName);
                  definition = schemaXML[localComponentType].(@name == definitionName.localName)[0];
                  if(definition != null)
                  {
                     break;
                  }
               }
               t++;
            }
            return {
               "definition":definition,
               "schema":schema
            };
         }
         return null;
      }
   }
}

