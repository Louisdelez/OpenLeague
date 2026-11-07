package spark.effects
{
   import flash.utils.Dictionary;
   
   internal class SharedObjectDepot
   {
      
      private var sharedObjectMaps:Dictionary = new Dictionary(true);
      
      private var sharedObjectRefcounts:Dictionary = new Dictionary(true);
      
      public function SharedObjectDepot()
      {
         super();
      }
      
      public function getSharedObject(mapKey:Object, target:Object) : Object
      {
         var sharedObjectMap:Dictionary = null;
         if(mapKey != null)
         {
            sharedObjectMap = Dictionary(this.sharedObjectMaps[mapKey]);
            if(sharedObjectMap != null)
            {
               return sharedObjectMap[target];
            }
         }
         return null;
      }
      
      public function storeSharedObject(mapKey:Object, target:Object, instance:Object) : void
      {
         var sharedObjectMap:Dictionary = null;
         if(mapKey != null)
         {
            sharedObjectMap = this.sharedObjectMaps[mapKey];
            if(!sharedObjectMap)
            {
               sharedObjectMap = new Dictionary();
               this.sharedObjectMaps[mapKey] = sharedObjectMap;
            }
            if(!sharedObjectMap[target])
            {
               if(!this.sharedObjectRefcounts[mapKey])
               {
                  this.sharedObjectRefcounts[mapKey] = 1;
               }
               else
               {
                  this.sharedObjectRefcounts[mapKey] += 1;
               }
            }
            sharedObjectMap[target] = instance;
         }
      }
      
      public function removeSharedObject(mapKey:Object, target:Object) : void
      {
         var sharedObjectMap:Dictionary = null;
         if(mapKey != null)
         {
            sharedObjectMap = this.sharedObjectMaps[mapKey];
            if(!sharedObjectMap)
            {
               return;
            }
            if(Boolean(sharedObjectMap[target]))
            {
               delete sharedObjectMap[target];
               this.sharedObjectRefcounts[mapKey] -= 1;
               if(this.sharedObjectRefcounts[mapKey] <= 0)
               {
                  delete this.sharedObjectMaps[mapKey];
                  delete this.sharedObjectRefcounts[mapKey];
               }
            }
         }
      }
   }
}

