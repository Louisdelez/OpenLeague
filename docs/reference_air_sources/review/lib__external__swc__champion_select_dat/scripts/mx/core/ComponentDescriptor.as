package mx.core
{
   public class ComponentDescriptor
   {
      
      public var events:Object;
      
      public var document:Object;
      
      public var type:Class;
      
      public var propertiesFactory:Function;
      
      private var _properties:Object;
      
      public var id:String;
      
      public function ComponentDescriptor(descriptorProperties:Object)
      {
         var p:String = null;
         super();
         for(p in descriptorProperties)
         {
            this[p] = descriptorProperties[p];
         }
      }
      
      public function toString() : String
      {
         return "ComponentDescriptor_" + id;
      }
      
      public function invalidateProperties() : void
      {
         _properties = null;
      }
      
      public function get properties() : Object
      {
         var cd:Array = null;
         var n:int = 0;
         var i:int = 0;
         if(Boolean(_properties))
         {
            return _properties;
         }
         if(propertiesFactory != null)
         {
            _properties = propertiesFactory.call(document);
         }
         if(Boolean(_properties))
         {
            cd = _properties.childDescriptors;
            if(Boolean(cd))
            {
               n = int(cd.length);
               for(i = 0; i < n; i++)
               {
                  cd[i].document = document;
               }
            }
         }
         else
         {
            _properties = {};
         }
         return _properties;
      }
   }
}

