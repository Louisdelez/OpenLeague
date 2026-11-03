package spark.collections
{
   import mx.collections.IList;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.utils.OnDemandEventDispatcher;
   
   [ExcludeClass]
   public class OnDemandDataProvider extends OnDemandEventDispatcher implements IList
   {
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      public function OnDemandDataProvider()
      {
         super();
      }
      
      public function get length() : int
      {
         var message:String = this.resourceManager.getString("collections","lengthError");
         throw new Error(message);
      }
      
      public function addItem(item:Object) : void
      {
         var message:String = this.resourceManager.getString("collections","addItemError");
         throw new Error(message);
      }
      
      public function addItemAt(item:Object, index:int) : void
      {
         var message:String = this.resourceManager.getString("collections","addItemAtError");
         throw new Error(message);
      }
      
      public function getItemAt(index:int, prefetch:int = 0) : Object
      {
         var message:String = this.resourceManager.getString("collections","getItemAtError");
         throw new Error(message);
      }
      
      public function getItemIndex(item:Object) : int
      {
         var message:String = this.resourceManager.getString("collections","getItemIndexError");
         throw new Error(message);
      }
      
      public function itemUpdated(item:Object, property:Object = null, oldValue:Object = null, newValue:Object = null) : void
      {
         var message:String = this.resourceManager.getString("collections","itemUpdatedError");
         throw new Error(message);
      }
      
      public function removeAll() : void
      {
         var message:String = this.resourceManager.getString("collections","removeAllError");
         throw new Error(message);
      }
      
      public function removeItemAt(index:int) : Object
      {
         var message:String = this.resourceManager.getString("collections","removeItemAtError");
         throw new Error(message);
      }
      
      public function setItemAt(item:Object, index:int) : Object
      {
         var message:String = this.resourceManager.getString("collections","setItemAtError");
         throw new Error(message);
      }
      
      public function toArray() : Array
      {
         var message:String = this.resourceManager.getString("collections","toArrayError");
         throw new Error(message);
      }
   }
}

