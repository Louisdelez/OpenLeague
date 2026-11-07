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
      
      public function getResourcesForNamespace(ns:Namespace) : Array
      {
         return getResourcesForURI(ns.uri);
      }
      
      public function getResourcesForURI(uri:String) : Array
      {
         if(resourcesMap == null)
         {
            return null;
         }
         if(uri == null)
         {
            uri = "";
         }
         return resourcesMap[uri];
      }
      
      public function addResource(ns:Namespace, resource:Object) : void
      {
         if(resources == null)
         {
            resources = [];
         }
         resources.push(resource);
         if(resourcesMap == null)
         {
            resourcesMap = {};
         }
         var uri:String = ns.uri;
         if(uri == null)
         {
            uri = "";
         }
         var existingResources:Array = resourcesMap[uri] as Array;
         if(existingResources == null)
         {
            existingResources = [];
         }
         existingResources.push(resource);
         resourcesMap[uri] = existingResources;
      }
      
      public function getResources() : Array
      {
         return resources;
      }
   }
}

