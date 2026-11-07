package blix.util.proxy
{
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   
   use namespace flash_proxy;
   
   public dynamic class SetterProxy extends Proxy
   {
      
      protected var _target:Object;
      
      public function SetterProxy(param1:Object)
      {
         super();
         this._target = param1;
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         if(this._target.hasOwnProperty(param1))
         {
            return this._target[param1];
         }
         var _loc2_:String = String(param1);
         return this._target["get" + _loc2_.substr(0,1).toUpperCase() + _loc2_.substr(1)]();
      }
      
      override flash_proxy function setProperty(param1:*, param2:*) : void
      {
         if(this._target.hasOwnProperty(param1))
         {
            this._target[param1] = param2;
         }
         var _loc3_:String = String(param1);
         this._target["set" + _loc3_.substr(0,1).toUpperCase() + _loc3_.substr(1)](param2);
      }
      
      override flash_proxy function deleteProperty(param1:*) : Boolean
      {
         if(param1 in this._target)
         {
            delete this._target[param1];
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
   }
}

