package mx.rpc.xml
{
   import mx.rpc.AsyncToken;
   import mx.rpc.events.ResultEvent;
   import mx.rpc.events.SchemaLoadEvent;
   import mx.rpc.http.HTTPService;
   
   [ExcludeClass]
   [Event(name="schemaLoad",type="mx.rpc.events.SchemaLoadEvent")]
   [Event(name="fault",type="mx.rpc.events.FaultEvent")]
   public class SchemaLoader extends XMLLoader
   {
      
      private static const LOAD_INCLUDE:String = "include";
      
      private static const LOAD_IMPORT:String = "import";
      
      private var topLevelSchema:Schema;
      
      private var _schemaManager:SchemaManager;
      
      private var locationMap:Object;
      
      public function SchemaLoader(httpService:HTTPService = null)
      {
         super(httpService);
         locationMap = {};
      }
      
      override protected function resultHandler(event:ResultEvent) : void
      {
         var parentSchema:Schema = null;
         var nsINC:Array = null;
         var nsSchema:Namespace = null;
         var children:XMLList = null;
         var schema:Schema = null;
         var ns:Namespace = null;
         var loadEvent:SchemaLoadEvent = null;
         super.resultHandler(event);
         var xml:XML = XML(event.result);
         var token:AsyncToken = event.token;
         var location:String = token == null ? null : token.location;
         if(token.parent != null)
         {
            parentSchema = token.parent as Schema;
            if(token.loadType == LOAD_INCLUDE)
            {
               nsINC = xml.namespaceDeclarations();
               for each(nsSchema in nsINC)
               {
                  parentSchema.xml.addNamespace(nsSchema);
               }
               children = xml.children();
               parentSchema.addInclude(children);
               locationMap[location] = children;
               schemaIncludes(parentSchema,location);
               schemaImports(parentSchema,location);
            }
            else
            {
               schema = new Schema(xml);
               locationMap[location] = schema;
               ns = token.importNamespace as Namespace;
               parentSchema.addImport(ns,schema);
               schemaIncludes(schema,location);
               schemaImports(schema,location);
            }
         }
         else
         {
            topLevelSchema = new Schema(xml);
            locationMap[location] = topLevelSchema;
            schemaIncludes(topLevelSchema,location);
            schemaImports(topLevelSchema,location);
         }
         if(loadsOutstanding <= 0)
         {
            loadEvent = SchemaLoadEvent.createEvent(topLevelSchema,location);
            dispatchEvent(loadEvent);
         }
      }
      
      override public function load(url:String) : void
      {
         url = getQualifiedLocation(url);
         loadSchema(url);
      }
      
      private function loadSchema(location:String, parent:Schema = null, ns:Namespace = null, loadType:String = null) : AsyncToken
      {
         var token:AsyncToken = internalLoad(location);
         if(token != null)
         {
            token.parent = parent;
            token.importNamespace = ns;
            token.loadType = loadType;
         }
         return token;
      }
      
      public function schemaIncludes(schema:Schema, parentLocation:String) : void
      {
         var schemaINCXML:XML = null;
         var location:String = null;
         var existing:XMLList = null;
         var schemaQName:QName = null;
         var schemaXML:XML = null;
         var nsSchema:Namespace = null;
         var includeQName:QName = null;
         var schemaINCList:XMLList = schema.xml.elements(schema.schemaConstants.includeQName);
         for each(schemaINCXML in schemaINCList)
         {
            location = schemaINCXML.@schemaLocation;
            location = getQualifiedLocation(location,parentLocation);
            existing = locationMap[location] as XMLList;
            schemaQName = schemaINCXML.name();
            schemaXML = schema.xml;
            nsSchema = new Namespace(schema.schemaConstants.xsdURI);
            includeQName = schema.schemaConstants.includeQName;
            delete schemaXML[includeQName].(@schemaLocation == location)[0];
            schema.xml = schemaXML;
            if(existing == null)
            {
               loadSchema(location,schema,schema.targetNamespace,LOAD_INCLUDE);
            }
            else
            {
               schema.addInclude(existing);
            }
         }
      }
      
      public function schemaImports(schema:Schema, parentLocation:String, schemaManager:SchemaManager = null) : void
      {
         var importNode:XML = null;
         var location:String = null;
         var importURI:String = null;
         var importNS:Namespace = null;
         var nsSchema:Namespace = null;
         var importedSchemas:Array = null;
         var importedSchema:Schema = null;
         var existing:Schema = null;
         var importQName:QName = schema.schemaConstants.importQName;
         var schemaXML:XML = schema.xml;
         var imports:XMLList = schemaXML.elements(importQName);
         for each(importNode in imports)
         {
            location = importNode.attribute("schemaLocation").toString();
            importURI = importNode.attribute("namespace").toString();
            importNS = new Namespace(importURI);
            nsSchema = new Namespace(schema.schemaConstants.xsdURI);
            if(location == "")
            {
               if(schemaManager != null)
               {
                  importedSchemas = schemaManager.getResourcesForURI(importURI);
                  if(importedSchemas != null)
                  {
                     for each(importedSchema in importedSchemas)
                     {
                        schema.addImport(importNS,importedSchema);
                     }
                     delete schemaXML[importQName].(@namespace == importURI)[0];
                     schema.xml = schemaXML;
                  }
               }
            }
            else
            {
               delete schemaXML[importQName].(@namespace == importURI)[0];
               schema.xml = schemaXML;
               location = getQualifiedLocation(location,parentLocation);
               existing = locationMap[location];
               if(existing == null)
               {
                  loadSchema(location,schema,importNS,LOAD_IMPORT);
               }
               else
               {
                  schema.addImport(importNS,existing);
               }
            }
         }
      }
   }
}

