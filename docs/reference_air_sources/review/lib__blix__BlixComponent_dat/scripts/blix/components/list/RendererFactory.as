package blix.components.list
{
   import blix.IDestructible;
   import blix.components.renderer.IDataRenderer;
   import blix.factory.ClassFactory;
   import blix.layout.LayoutEntry;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.ILayoutData;
   import flash.utils.Dictionary;
   
   public class RendererFactory implements IRendererFactory, IDestructible
   {
      
      private var _entryConstructed:Signal = new Signal();
      
      private var _entryDeconstructed:Signal = new Signal();
      
      private var _entryActivated:Signal = new Signal();
      
      private var _entryDeactivated:Signal = new Signal();
      
      private var layoutData:ILayoutData;
      
      private var classFactory:ClassFactory;
      
      private var pool:Dictionary;
      
      private var poolCount:uint;
      
      public function RendererFactory(param1:Class, param2:Array = null, param3:ILayoutData = null)
      {
         super();
         this.classFactory = new ClassFactory(param1,param2);
         this.layoutData = param3;
         this.pool = new Dictionary(false);
      }
      
      public function getEntryConstructed() : ISignal
      {
         return this._entryConstructed;
      }
      
      public function getEntryDeconstructed() : ISignal
      {
         return this._entryDeconstructed;
      }
      
      public function getEntryActivated() : ISignal
      {
         return this._entryActivated;
      }
      
      public function getEntryDeactivated() : ISignal
      {
         return this._entryDeactivated;
      }
      
      public function createEntry(param1:*) : LayoutEntry
      {
         var _loc2_:LayoutEntry = null;
         var _loc3_:IDataRenderer = null;
         var _loc4_:Vector.<LayoutEntry> = null;
         var _loc5_:* = undefined;
         if(this.poolCount > 0)
         {
            if(param1 in this.pool)
            {
               _loc5_ = param1;
            }
            else
            {
               var _loc6_:int = 0;
               var _loc7_:* = this.pool;
               for(_loc5_ in _loc7_)
               {
               }
            }
            _loc4_ = this.pool[_loc5_];
            _loc2_ = _loc4_.pop();
            _loc3_ = _loc2_.element as IDataRenderer;
            if(_loc4_.length == 0)
            {
               delete this.pool[_loc5_];
            }
            --this.poolCount;
         }
         else
         {
            _loc3_ = this.classFactory.getInstance();
            _loc2_ = new LayoutEntry(_loc3_,this.layoutData);
            this._entryConstructed.dispatch(_loc2_,param1);
         }
         if(_loc2_ == null)
         {
            throw new Error("The renderer factory has encountered an error. The entry could not be created.");
         }
         this._entryActivated.dispatch(_loc2_,param1);
         if(param1 != _loc3_.getData())
         {
            _loc3_.setData(param1);
         }
         return _loc2_;
      }
      
      public function returnEntry(param1:LayoutEntry) : void
      {
         if(param1 == null)
         {
            throw new Error("Cannot return a null value to the pool.");
         }
         ++this.poolCount;
         var _loc2_:* = IDataRenderer(param1.element).getData();
         var _loc3_:Vector.<LayoutEntry> = this.pool[_loc2_];
         if(_loc3_ == null)
         {
            _loc3_ = new Vector.<LayoutEntry>();
            this.pool[_loc2_] = _loc3_;
         }
         _loc3_.push(param1);
         this._entryDeactivated.dispatch(param1);
      }
      
      public function clearCache() : void
      {
         var _loc1_:Vector.<LayoutEntry> = null;
         var _loc2_:LayoutEntry = null;
         for each(_loc1_ in this.pool)
         {
            for each(_loc2_ in _loc1_)
            {
               this._entryDeactivated.dispatch(_loc2_);
               this._entryDeconstructed.dispatch(_loc2_);
               if(_loc2_.element is IDestructible)
               {
                  IDestructible(_loc2_.element).destroy();
               }
            }
         }
         this.pool = new Dictionary();
         this.poolCount = 0;
      }
      
      public function getPoolCount() : uint
      {
         return this.poolCount;
      }
      
      public function destroy() : void
      {
         this.clearCache();
         this._entryConstructed.removeAll();
         this._entryDeconstructed.removeAll();
         this._entryActivated.removeAll();
         this._entryDeactivated.removeAll();
      }
   }
}

