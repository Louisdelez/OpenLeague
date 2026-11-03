package mx.rpc.xml
{
   [ExcludeClass]
   public class Schema
   {
      
      public var elementFormDefault:String = "unqualified";
      
      private var _targetNamespace:Namespace;
      
      private var _schemaDatatypes:SchemaDatatypes;
      
      private var _xml:XML;
      
      private var _namespaces:Object;
      
      private var importsManager:QualifiedResourceManager;
      
      public var attributeFormDefault:String = "unqualified";
      
      public var finalDefault:String;
      
      private var _schemaConstants:SchemaConstants;
      
      public var blockDefault:String;
      
      public function Schema(xml:XML = null)
      {
         super();
         this.xml = xml;
      }
      
      public function set xml(value:XML) : void
      {
         var tns:String = null;
         var nsArray:Array = null;
         var ns:Namespace = null;
         _xml = value;
         if(_xml != null)
         {
            tns = _xml.@targetNamespace.toString();
            _targetNamespace = new Namespace(tns);
            attributeFormDefault = _xml.@attributeFormDefault.toString();
            if(attributeFormDefault == "")
            {
               attributeFormDefault = "unqualified";
            }
            blockDefault = _xml.@blockDefault.toString();
            elementFormDefault = _xml.@elementFormDefault.toString();
            if(elementFormDefault == "")
            {
               elementFormDefault = "unqualified";
            }
            finalDefault = _xml.@finalDefault.toString();
            namespaces = {};
            nsArray = _xml.inScopeNamespaces();
            for each(ns in nsArray)
            {
               namespaces[ns.prefix] = ns;
            }
            _schemaConstants = SchemaConstants.getConstants(_xml);
            _schemaDatatypes = SchemaDatatypes.getConstants(_schemaConstants.xsdURI);
         }
         else
         {
            _schemaConstants = null;
            _schemaDatatypes = null;
         }
      }
      
      public function addInclude(fragment:XMLList) : void
      {
         xml.appendChild(fragment);
      }
      
      public function get targetNamespace() : Namespace
      {
         return _targetNamespace;
      }
      
      public function set targetNamespace(tns:Namespace) : void
      {
         _targetNamespace = tns;
      }
      
      public function get xml() : XML
      {
         return _xml;
      }
      
      public function addImport(targetNamespace:Namespace, schema:Schema) : void
      {
         if(importsManager == null)
         {
            importsManager = new QualifiedResourceManager();
         }
         importsManager.addResource(targetNamespace,schema);
      }
      
      public function get schemaConstants() : SchemaConstants
      {
         if(_schemaConstants == null)
         {
            _schemaConstants = SchemaConstants.getConstants(_xml);
         }
         return _schemaConstants;
      }
      
      public function set namespaces(value:Object) : void
      {
         _namespaces = value;
      }
      
      public function getNamedDefinition(name:QName, ... componentTypes) : Object
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
         var uri:String = name.uri;
         var schemas:Array = [this];
         if(importsManager != null)
         {
            imports = importsManager.getResourcesForURI(uri);
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
               if(schema.elementFormDefault == "qualified" && componentType == schemaConstants.elementTypeQName)
               {
                  if(uri != null && uri != "")
                  {
                     if(currentTargetNamespace == null || currentTargetNamespace.uri != uri)
                     {
                        continue;
                     }
                  }
               }
               if(schema.attributeFormDefault == "qualified" && componentType == schemaConstants.attributeQName)
               {
                  if(uri != null && uri != "")
                  {
                     if(currentTargetNamespace == null || currentTargetNamespace.uri != uri)
                     {
                        continue;
                     }
                  }
               }
               if(!(componentType != schemaConstants.elementTypeQName && componentType != schemaConstants.attributeQName && currentTargetNamespace.uri != name.uri))
               {
                  localComponentType = new QName(constants.xsdURI,componentType.localName);
                  definition = schemaXML[localComponentType].(@name == name.localName)[0];
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
      
      public function get namespaces() : Object
      {
         if(_namespaces == null)
         {
            _namespaces = {};
         }
         return _namespaces;
      }
      
      public function get schemaDatatypes() : SchemaDatatypes
      {
         if(_schemaDatatypes == null)
         {
            _schemaDatatypes = SchemaDatatypes.getConstants(schemaConstants.xsdURI);
         }
         return _schemaDatatypes;
      }
   }
}

