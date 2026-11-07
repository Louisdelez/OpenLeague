package spark.components.supportClasses
{
   import flash.display.DisplayObject;
   import flash.events.EventDispatcher;
   import mx.resources.ResourceManager;
   import spark.events.DisplayLayerObjectExistenceEvent;
   
   public class DisplayLayer extends EventDispatcher
   {
      
      private var _depth:Vector.<Number>;
      
      private var _objects:Vector.<DisplayObject>;
      
      public function DisplayLayer()
      {
         super();
      }
      
      public function get numDisplayObjects() : int
      {
         return Boolean(this._objects) ? int(this._objects.length) : 0;
      }
      
      public function getDisplayObjectAt(index:int) : DisplayObject
      {
         if(!this._objects || index < 0 || index >= this._objects.length)
         {
            throw new RangeError(ResourceManager.getInstance().getString("components","indexOutOfRange",[index]));
         }
         return this._objects[index];
      }
      
      public function getDisplayObjectDepth(displayObject:DisplayObject) : Number
      {
         var index:int = this._objects.indexOf(displayObject);
         if(index == -1)
         {
            throw new RangeError(ResourceManager.getInstance().getString("components","objectNotFoundInDisplayLayer",[displayObject]));
         }
         return this._depth[index];
      }
      
      public function addDisplayObject(displayObject:DisplayObject, depth:Number = 10000) : DisplayObject
      {
         var count:int = 0;
         var index:int = 0;
         if(!this._depth)
         {
            this._depth = new Vector.<Number>();
            this._objects = new Vector.<DisplayObject>();
         }
         else
         {
            for(count = int(this._depth.length); index < count; )
            {
               if(depth < this._depth[index])
               {
                  break;
               }
               index++;
            }
         }
         this._depth.splice(index,0,depth);
         this._objects.splice(index,0,displayObject);
         dispatchEvent(new DisplayLayerObjectExistenceEvent(DisplayLayerObjectExistenceEvent.OBJECT_ADD,false,false,displayObject,index));
         return displayObject;
      }
      
      public function removeDisplayObject(displayObject:DisplayObject) : DisplayObject
      {
         var index:int = this._objects.indexOf(displayObject);
         if(index == -1)
         {
            throw new RangeError(ResourceManager.getInstance().getString("components","objectNotFoundInDisplayLayer",[displayObject]));
         }
         dispatchEvent(new DisplayLayerObjectExistenceEvent(DisplayLayerObjectExistenceEvent.OBJECT_REMOVE,false,false,displayObject,index));
         this._depth.splice(index,1);
         this._objects.splice(index,1);
         return displayObject;
      }
   }
}

