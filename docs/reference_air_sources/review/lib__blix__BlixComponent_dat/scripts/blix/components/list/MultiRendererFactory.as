package blix.components.list
{
   import blix.IDestructible;
   import blix.components.renderer.IDataRenderer;
   import blix.layout.LayoutEntry;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.ILayoutData;
   import flash.utils.getQualifiedClassName;
   
   public class MultiRendererFactory implements IRendererFactory
   {
      
      private var _entryConstructed:Signal = new Signal();
      
      private var _entryDeconstructed:Signal = new Signal();
      
      private var _entryActivated:Signal = new Signal();
      
      private var _entryDeactivated:Signal = new Signal();
      
      private var rendererDataTypeInfos:Vector.<RendererDataTypeInfo> = new Vector.<RendererDataTypeInfo>();
      
      public function MultiRendererFactory()
      {
         super();
      }
      
      public function addType(param1:Class, param2:Class, param3:Array = null, param4:ILayoutData = null) : void
      {
         var _loc5_:RendererDataTypeInfo = new RendererDataTypeInfo(param1,new RendererFactory(param2,param3,param4));
         _loc5_.factory.getEntryActivated().add(this._entryActivated.dispatch,true);
         _loc5_.factory.getEntryConstructed().add(this._entryConstructed.dispatch,true);
         _loc5_.factory.getEntryDeactivated().add(this._entryDeactivated.dispatch,true);
         _loc5_.factory.getEntryDeconstructed().add(this._entryDeconstructed.dispatch,true);
         this.rendererDataTypeInfos[this.rendererDataTypeInfos.length] = _loc5_;
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
         var _loc2_:RendererDataTypeInfo = this.getRendererDataTypeInfo(param1);
         return _loc2_.factory.createEntry(param1);
      }
      
      public function returnEntry(param1:LayoutEntry) : void
      {
         var _loc2_:* = (param1.element as IDataRenderer).getData();
         var _loc3_:RendererDataTypeInfo = this.getRendererDataTypeInfo(_loc2_);
         _loc3_.factory.returnEntry(param1);
      }
      
      private function getRendererDataTypeInfo(param1:*) : RendererDataTypeInfo
      {
         var _loc2_:RendererDataTypeInfo = null;
         for each(_loc2_ in this.rendererDataTypeInfos)
         {
            if(param1 == null && _loc2_.dataType == null)
            {
               return _loc2_;
            }
            if(param1 is _loc2_.dataType)
            {
               return _loc2_;
            }
         }
         if(param1 == null)
         {
            throw new Error("Could not find the associated renderer for null items. Use MultiRendererFactory#addType, passing null for the typeClass to handle this type.");
         }
         throw new Error("Could not find the associated renderer for data of the type \'" + getQualifiedClassName(param1) + "\'. Use MultiRendererFactory#addType to handle this type.");
      }
      
      public function clearCache() : void
      {
         var _loc1_:RendererDataTypeInfo = null;
         for each(_loc1_ in this.rendererDataTypeInfos)
         {
            _loc1_.factory.clearCache();
         }
      }
      
      public function destroy() : void
      {
         var _loc1_:RendererDataTypeInfo = null;
         for each(_loc1_ in this.rendererDataTypeInfos)
         {
            if(_loc1_.factory is IDestructible)
            {
               (_loc1_.factory as IDestructible).destroy();
            }
         }
         this._entryConstructed.removeAll();
         this._entryDeconstructed.removeAll();
         this._entryActivated.removeAll();
         this._entryDeactivated.removeAll();
      }
   }
}

import blix.components.list.IRendererFactory;

class RendererDataTypeInfo
{
   
   public var dataType:Class;
   
   public var factory:IRendererFactory;
   
   public function RendererDataTypeInfo(param1:Class, param2:IRendererFactory)
   {
      super();
      this.dataType = param1;
      this.factory = param2;
   }
}
