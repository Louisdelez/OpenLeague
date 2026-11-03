package blix.assets.proxy
{
   import blix.IDestructible;
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   
   use namespace flash_proxy;
   
   public dynamic class PropertyProxy extends Proxy implements IDestructible
   {
      
      protected var _target:Object;
      
      private var writeOnlyProperties:Object = {};
      
      private var explicitProperties:Object = new Object();
      
      public function PropertyProxy(param1:Object = null)
      {
         super();
         this.setTarget(param1);
      }
      
      public function getTarget() : Object
      {
         return this._target;
      }
      
      public function setTarget(param1:Object) : void
      {
         var _loc2_:String = null;
         if(this._target == param1)
         {
            return;
         }
         if(this._target != null)
         {
            for(_loc2_ in this.explicitProperties)
            {
               if(!(_loc2_ in this.writeOnlyProperties))
               {
                  this.explicitProperties[_loc2_] = this._target[_loc2_];
               }
            }
         }
         this._target = param1;
         if(this._target != null)
         {
            for(_loc2_ in this.explicitProperties)
            {
               this._target[_loc2_] = this.explicitProperties[_loc2_];
            }
         }
      }
      
      public function setPropertyAsWriteOnly(param1:String) : void
      {
         this.writeOnlyProperties[param1] = true;
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         if(this._target != null)
         {
            return this._target[param1];
         }
         return this.explicitProperties[param1];
      }
      
      override flash_proxy function setProperty(param1:*, param2:*) : void
      {
         if(this._target != null)
         {
            this._target[param1] = param2;
         }
         this.explicitProperties[param1] = param2;
      }
      
      override flash_proxy function deleteProperty(param1:*) : Boolean
      {
         if(param1 in this.explicitProperties)
         {
            delete this.explicitProperties[param1];
            return true;
         }
         return false;
      }
      
      override flash_proxy function callProperty(param1:*, ... rest) : *
      {
         if(this._target == null)
         {
            return null;
         }
         return (this._target[param1] as Function).apply(null,rest);
      }
      
      public function destroy() : void
      {
         this._target = null;
         this.explicitProperties = {};
      }
   }
}

