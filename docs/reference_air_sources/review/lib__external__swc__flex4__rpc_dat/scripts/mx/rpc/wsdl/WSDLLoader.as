package mx.rpc.wsdl
{
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.rpc.AsyncToken;
   import mx.rpc.Fault;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.events.ResultEvent;
   import mx.rpc.events.SchemaLoadEvent;
   import mx.rpc.events.WSDLLoadEvent;
   import mx.rpc.http.HTTPService;
   import mx.rpc.xml.Schema;
   import mx.rpc.xml.SchemaLoader;
   import mx.rpc.xml.SchemaManager;
   import mx.rpc.xml.XMLLoader;
   
   [ExcludeClass]
   [ResourceBundle("rpc")]
   [Event(name="wsdlLoad",type="mx.rpc.events.WSDLLoadEvent")]
   [Event(name="fault",type="mx.rpc.events.FaultEvent")]
   public class WSDLLoader extends XMLLoader
   {
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var schemaLoader:SchemaLoader;
      
      private var topLevelWSDL:WSDL;
      
      private var topLevelLocation:String;
      
      private var locationMap:Object;
      
      public function WSDLLoader(httpService:HTTPService = null)
      {
         super(httpService);
         this.locationMap = {};
         this.schemaLoader = new SchemaLoader(httpService);
         this.schemaLoader.addEventListener(SchemaLoadEvent.LOAD,this.schemaLoadHandler);
      }
      
      override public function load(url:String) : void
      {
         url = getQualifiedLocation(url);
         this.loadWSDL(url);
      }
      
      override protected function faultHandler(event:FaultEvent) : void
      {
         --loadsOutstanding;
         var location:String = event.token == null ? null : event.token.location;
         var detail:String = this.resourceManager.getString("rpc","unableToLoadWSDL",[location]);
         var fault:Fault = new Fault(event.fault.faultCode,event.fault.faultString,detail);
         event = FaultEvent.createEvent(fault,event.token,event.message);
         dispatchEvent(event);
      }
      
      override protected function resultHandler(event:ResultEvent) : void
      {
         var wsdl:WSDL = null;
         var parent:WSDL = null;
         var ns:Namespace = null;
         var name:QName = null;
         var schema:Schema = null;
         super.resultHandler(event);
         var token:AsyncToken = event.token;
         var xml:XML = XML(event.result);
         var location:String = token.location;
         if(token.parent != null)
         {
            parent = token.parent as WSDL;
            ns = token.importNamespace as Namespace;
            name = xml.name();
            if(name == parent.schemaConstants.schemaQName)
            {
               schema = new Schema(xml);
               this.schemaLoader.schemaImports(schema,location,parent.schemaManager);
               parent.addSchema(schema);
               if(this.topLevelWSDL != null)
               {
                  this.topLevelWSDL.addSchema(schema);
                  this.schemaImports(this.topLevelWSDL,location);
               }
            }
            else
            {
               wsdl = new WSDL(xml,Boolean(this.topLevelWSDL) ? this.topLevelWSDL.schemaManager : null);
               parent.addImport(ns,wsdl);
            }
         }
         else
         {
            wsdl = new WSDL(xml);
            this.topLevelWSDL = wsdl;
            this.topLevelLocation = location;
         }
         if(wsdl != null)
         {
            this.locationMap[location] = wsdl;
            this.wsdlImports(wsdl,location);
            this.schemaImports(wsdl,location);
         }
         this.checkLoadsOutstanding();
      }
      
      private function schemaLoadHandler(event:SchemaLoadEvent) : void
      {
         this.checkLoadsOutstanding();
      }
      
      private function checkLoadsOutstanding() : void
      {
         var loadEvent:WSDLLoadEvent = null;
         if(loadsOutstanding == 0 && this.schemaLoader.loadsOutstanding == 0)
         {
            loadEvent = WSDLLoadEvent.createEvent(this.topLevelWSDL,this.topLevelLocation);
            dispatchEvent(loadEvent);
         }
      }
      
      private function loadWSDL(location:String, parent:WSDL = null, ns:Namespace = null) : AsyncToken
      {
         var token:AsyncToken = internalLoad(location);
         if(token != null)
         {
            token.parent = parent;
            token.importNamespace = ns;
         }
         return token;
      }
      
      private function wsdlImports(wsdl:WSDL, parentLocation:String) : void
      {
         var importNode:XML = null;
         var location:String = null;
         var importURI:String = null;
         var importNS:Namespace = null;
         var existing:WSDL = null;
         var importQName:QName = wsdl.wsdlConstants.importQName;
         var imports:XMLList = wsdl.xml.elements(importQName);
         for each(importNode in imports)
         {
            location = importNode.attribute("location").toString();
            importURI = importNode.attribute("namespace").toString();
            importNS = new Namespace(importURI);
            location = getQualifiedLocation(location,parentLocation);
            existing = this.locationMap[location];
            if(existing == null)
            {
               this.loadWSDL(location,wsdl,importNS);
            }
            else
            {
               wsdl.addImport(importNS,existing);
            }
         }
      }
      
      private function schemaImports(wsdl:WSDL, parentLocation:String) : void
      {
         var schema:Schema = null;
         var schemaXML:XML = null;
         var includeSchema:XMLList = null;
         var schemaManager:SchemaManager = wsdl.schemaManager;
         var schemas:Array = schemaManager.currentScope();
         for(var s:int = 0; s < schemas.length; s++)
         {
            schema = schemas[s];
            schemaXML = schema.xml;
            includeSchema = schemaXML.elements(schema.schemaConstants.includeQName);
            if(includeSchema != null && includeSchema.length() > 0)
            {
               this.schemaLoader.schemaIncludes(schema,parentLocation);
            }
            this.schemaLoader.schemaImports(schema,parentLocation,schemaManager);
         }
      }
   }
}

