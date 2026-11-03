package org.swizframework.storage
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.SharedObject;
   import org.swizframework.utils.logging.SwizLogger;
   
   public class SharedObjectBean extends EventDispatcher implements ISharedObjectBean
   {
      
      protected var logger:SwizLogger = SwizLogger.getLogger(this);
      
      private var so:SharedObject;
      
      private var _path:String = "/";
      
      private var _name:String = "swizSharedObject";
      
      public function SharedObjectBean()
      {
         super();
      }
      
      public function set localPath(path:String) : void
      {
         this._path = path;
         this.invalidate();
      }
      
      public function set name(name:String) : void
      {
         this._name = name;
         this.invalidate();
      }
      
      public function get size() : Number
      {
         if(this.so != null)
         {
            return this.so.size;
         }
         return NaN;
      }
      
      protected function invalidate() : void
      {
         this.so = SharedObject.getLocal(this._name,this._path);
      }
      
      public function clear() : void
      {
         this.so.clear();
      }
      
      public function hasValue(name:String) : Boolean
      {
         return this.so.data[name] != undefined;
      }
      
      public function getValue(name:String, initValue:* = null) : *
      {
         var o:Object = this.so.data;
         if(o[name] == null && initValue != null)
         {
            o[name] = initValue;
            this.so.flush();
         }
         return o[name];
      }
      
      public function setValue(name:String, value:*) : void
      {
         var o:Object = this.so.data;
         o[name] = value;
         this.so.flush();
      }
      
      public function getString(name:String, initValue:String = null) : String
      {
         var o:Object = this.so.data;
         if(o[name] == null && initValue != null)
         {
            o[name] = initValue;
            this.so.flush();
         }
         return o[name];
      }
      
      public function setString(name:String, value:String) : void
      {
         var o:Object = this.so.data;
         o[name] = value;
         this.so.flush();
      }
      
      public function getBoolean(name:String, initValue:Boolean = false) : Boolean
      {
         var o:Object = this.so.data;
         if(o[name] == null)
         {
            o[name] = initValue;
            this.so.flush();
         }
         return o[name];
      }
      
      public function setBoolean(name:String, value:Boolean) : void
      {
         var o:Object = this.so.data;
         o[name] = value;
         this.so.flush();
      }
      
      public function getNumber(name:String, initValue:Number = NaN) : Number
      {
         var o:Object = this.so.data;
         if(o[name] == null)
         {
            o[name] = initValue;
            this.so.flush();
         }
         return o[name];
      }
      
      public function setNumber(name:String, value:Number) : void
      {
         var o:Object = this.so.data;
         o[name] = value;
         this.so.flush();
      }
      
      public function getInt(name:String, initValue:int = -1) : int
      {
         var o:Object = this.so.data;
         if(o[name] == null)
         {
            o[name] = initValue;
            this.so.flush();
         }
         return o[name];
      }
      
      public function setInt(name:String, value:int) : void
      {
         var o:Object = this.so.data;
         o[name] = value;
         this.so.flush();
         dispatchEvent(new Event("intChange"));
      }
   }
}

