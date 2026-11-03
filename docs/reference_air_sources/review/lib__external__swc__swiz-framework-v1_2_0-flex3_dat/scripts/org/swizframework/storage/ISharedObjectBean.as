package org.swizframework.storage
{
   public interface ISharedObjectBean
   {
      
      function set localPath(param1:String) : void;
      
      function set name(param1:String) : void;
      
      function get size() : Number;
      
      function clear() : void;
      
      function hasValue(param1:String) : Boolean;
      
      function getValue(param1:String, param2:* = null) : *;
      
      function setValue(param1:String, param2:*) : void;
      
      function getString(param1:String, param2:String = null) : String;
      
      function setString(param1:String, param2:String) : void;
      
      function getBoolean(param1:String, param2:Boolean = false) : Boolean;
      
      function setBoolean(param1:String, param2:Boolean) : void;
      
      function getNumber(param1:String, param2:Number = NaN) : Number;
      
      function setNumber(param1:String, param2:Number) : void;
      
      function getInt(param1:String, param2:int = -1) : int;
      
      function setInt(param1:String, param2:int) : void;
   }
}

