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
      
      private var locationMap:Object;
      
      private var _schemaManager:SchemaManager;
      
      public function SchemaLoader(httpService:HTTPService = null)
      {
         super(httpService);
         this.locationMap = {};
      }
      
      override public function load(url:String) : void
      {
         url = getQualifiedLocation(url);
         this.loadSchema(url);
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
               existing = this.locationMap[location];
               if(existing == null)
               {
                  this.loadSchema(location,schema,importNS,LOAD_IMPORT);
               }
               else
               {
                  schema.addImport(importNS,existing);
               }
            }
         }
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
            existing = this.locationMap[location] as XMLList;
            schemaQName = schemaINCXML.name();
            schemaXML = schema.xml;
            nsSchema = new Namespace(schema.schemaConstants.xsdURI);
            includeQName = schema.schemaConstants.includeQName;
            delete schemaXML[includeQName].(@schemaLocation == location)[0];
            schema.xml = schemaXML;
            if(existing == null)
            {
               this.loadSchema(location,schema,schema.targetNamespace,LOAD_INCLUDE);
            }
            else
            {
               schema.addInclude(existing);
            }
         }
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
               this.locationMap[location] = children;
               this.schemaIncludes(parentSchema,location);
               this.schemaImports(parentSchema,location);
            }
            else
            {
               schema = new Schema(xml);
               this.locationMap[location] = schema;
               ns = token.importNamespace as Namespace;
               parentSchema.addImport(ns,schema);
               this.schemaIncludes(schema,location);
               this.schemaImports(schema,location);
            }
         }
         else
         {
            this.topLevelSchema = new Schema(xml);
            this.locationMap[location] = this.topLevelSchema;
            this.schemaIncludes(this.topLevelSchema,location);
            this.schemaImports(this.topLevelSchema,location);
         }
         if(loadsOutstanding <= 0)
         {
            loadEvent = SchemaLoadEvent.createEvent(this.topLevelSchema,location);
            dispatchEvent(loadEvent);
         }
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
   }
}

