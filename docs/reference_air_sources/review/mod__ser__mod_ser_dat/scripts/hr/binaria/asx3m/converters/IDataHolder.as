package hr.binaria.asx3m.converters
{
   import system.data.Iterator;
   
   public interface IDataHolder
   {
      
      function keys() : Iterator;
      
      function get(param1:Object) : Object;
      
      function put(param1:Object, param2:Object) : void;
   }
}

