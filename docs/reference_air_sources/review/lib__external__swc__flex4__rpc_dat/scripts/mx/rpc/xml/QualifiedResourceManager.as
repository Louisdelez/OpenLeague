package mx.rpc.xml
{
   public class QualifiedResourceManager
   {
      
      protected var resources:Array;
      
      protected var resourcesMap:Object;
      
      public function QualifiedResourceManager()
      {
         super();
      }
      
      public function addResource(ns:Namespace, resource:Object) : void
      {
         if(this.resources == null)
         {
            this.resources = [];
         }
         this.resources.push(resource);
         if(this.resourcesMap == null)
         {
            this.resourcesMap = {};
         }
         var uri:String = ns.uri;
         if(uri == null)
         {
            uri = "";
         }
         var existingResources:Array = this.resourcesMap[uri] as Array;
         if(existingResources == null)
         {
            existingResources = [];
         }
         existingResources.push(resource);
         this.resourcesMap[uri] = existingResources;
      }
      
      public function getResourcesForNamespace(ns:Namespace) : Array
      {
         return this.getResourcesForURI(ns.uri);
      }
      
      public function getResourcesForURI(uri:String) : Array
      {
         if(this.resourcesMap == null)
         {
            return null;
         }
         if(uri == null)
         {
            uri = "";
         }
         return this.resourcesMap[uri];
      }
      
      public function getResources() : Array
      {
         return this.resources;
      }
   }
}

