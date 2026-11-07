package blix.ds
{
   import blix.signals.Signal;
   import blix.util.ObjectUtils;
   import flash.events.NetStatusEvent;
   import flash.net.ObjectEncoding;
   import flash.net.SharedObject;
   import flash.net.SharedObjectFlushStatus;
   import flash.net.registerClassAlias;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class AbstractPersistentData
   {
      
      [ArrayElementType("flash.net.SharedObject")]
      private static var sharedObjects:Object = new Object();
      
      protected var _saveSuccess:Signal = new Signal();
      
      protected var _saveFail:Signal = new Signal();
      
      private var _cookieName:String;
      
      public function AbstractPersistentData(param1:String, param2:Boolean = false)
      {
         super();
         var _loc3_:String = getQualifiedClassName(this);
         if(Class(getDefinitionByName(_loc3_)) == AbstractPersistentData)
         {
            throw new Error("AbstractPersistentData must be extended");
         }
         if(!param1)
         {
            throw new ArgumentError("Argument cookieName is required.");
         }
         this._cookieName = param1;
         if(param2)
         {
            this.fetch();
         }
      }
      
      public function getSaveFail() : Signal
      {
         return this._saveFail;
      }
      
      public function getSaveSuccess() : Signal
      {
         return this._saveSuccess;
      }
      
      public function getCookieName() : String
      {
         return this._cookieName;
      }
      
      protected function getSo() : SharedObject
      {
         if(sharedObjects[this._cookieName] != null)
         {
            return sharedObjects[this._cookieName];
         }
         var _loc1_:SharedObject = SharedObject.getLocal(this._cookieName);
         _loc1_.objectEncoding = ObjectEncoding.AMF3;
         sharedObjects[this._cookieName] = _loc1_;
         return _loc1_;
      }
      
      public function fetch() : void
      {
         var sO:SharedObject;
         var className:String = getQualifiedClassName(this);
         var classNameParts:Array = className.split("::");
         var classAliasName:String = classNameParts.pop() + "Alias";
         registerClassAlias(classAliasName,Class(getDefinitionByName(className)));
         sO = this.getSo();
         if(Boolean(sO.data.data))
         {
            try
            {
               ObjectUtils.mergeObjects(this,sO.data.data);
            }
            catch(error:Error)
            {
               clear();
            }
         }
      }
      
      public function clear() : void
      {
         this.getSo().clear();
      }
      
      public function save() : void
      {
         var sO:SharedObject;
         var flushStatus:String;
         this.clear();
         sO = this.getSo();
         sO.data.data = this;
         flushStatus = null;
         try
         {
            flushStatus = sO.flush(sO.size);
         }
         catch(error:Error)
         {
            _saveFail.dispatch();
         }
         if(flushStatus != null)
         {
            switch(flushStatus)
            {
               case SharedObjectFlushStatus.PENDING:
                  sO.addEventListener(NetStatusEvent.NET_STATUS,this.onFlushStatus);
                  break;
               case SharedObjectFlushStatus.FLUSHED:
                  this._saveSuccess.dispatch();
            }
         }
      }
      
      private function onFlushStatus(param1:NetStatusEvent) : void
      {
         this.getSo().removeEventListener(NetStatusEvent.NET_STATUS,this.onFlushStatus);
         switch(param1.info.code)
         {
            case "SharedObject.Flush.Success":
               this._saveSuccess.dispatch();
               break;
            case "SharedObject.Flush.Failed":
               this._saveFail.dispatch();
         }
      }
   }
}

