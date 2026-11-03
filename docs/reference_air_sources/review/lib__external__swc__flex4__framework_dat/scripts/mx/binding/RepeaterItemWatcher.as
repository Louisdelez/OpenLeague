package mx.binding
{
   import mx.collections.CursorBookmark;
   import mx.collections.ICollectionView;
   import mx.collections.IViewCursor;
   import mx.core.mx_internal;
   import mx.events.CollectionEvent;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class RepeaterItemWatcher extends Watcher
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var dataProviderWatcher:PropertyWatcher;
      
      private var clones:Array;
      
      private var original:Boolean = true;
      
      public function RepeaterItemWatcher(dataProviderWatcher:PropertyWatcher)
      {
         super();
         this.dataProviderWatcher = dataProviderWatcher;
      }
      
      override public function updateParent(parent:Object) : void
      {
         var dataProvider:ICollectionView = null;
         if(Boolean(this.dataProviderWatcher))
         {
            dataProvider = ICollectionView(this.dataProviderWatcher.value);
            if(dataProvider != null)
            {
               dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.changedHandler,false);
            }
         }
         this.dataProviderWatcher = PropertyWatcher(parent);
         dataProvider = ICollectionView(this.dataProviderWatcher.value);
         if(Boolean(dataProvider))
         {
            if(this.original)
            {
               dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.changedHandler,false,0,true);
               this.updateClones(dataProvider);
            }
            else
            {
               wrapUpdate(function():void
               {
                  var iterator:IViewCursor = dataProvider.createCursor();
                  iterator.seek(CursorBookmark.FIRST,cloneIndex);
                  value = iterator.current;
                  updateChildren();
               });
            }
         }
      }
      
      private function changedHandler(collectionEvent:CollectionEvent) : void
      {
         var dataProvider:ICollectionView = ICollectionView(this.dataProviderWatcher.value);
         if(Boolean(dataProvider))
         {
            this.updateClones(dataProvider);
         }
      }
      
      override protected function shallowClone() : Watcher
      {
         return new RepeaterItemWatcher(this.dataProviderWatcher);
      }
      
      private function updateClones(dataProvider:ICollectionView) : void
      {
         var clone:RepeaterItemWatcher = null;
         if(Boolean(this.clones))
         {
            this.clones = this.clones.splice(0,dataProvider.length);
         }
         else
         {
            this.clones = [];
         }
         for(var i:int = 0; i < dataProvider.length; i++)
         {
            clone = RepeaterItemWatcher(this.clones[i]);
            if(!clone)
            {
               clone = RepeaterItemWatcher(deepClone(i));
               clone.original = false;
               this.clones[i] = clone;
            }
            clone.updateParent(this.dataProviderWatcher);
         }
      }
   }
}

