package hr.binaria.asx3m.core
{
   import hr.binaria.asx3m.converters.IConverter;
   import hr.binaria.asx3m.converters.IConverterLookup;
   import hr.binaria.asx3m.mapper.IMapper;
   import system.data.Iterator;
   import system.data.Map;
   import system.data.lists.ArrayList;
   import system.data.maps.HashMap;
   
   public class DefaultConverterLookup implements IConverterLookup
   {
      
      private var mapper:IMapper;
      
      private var converters:ArrayList = new ArrayList();
      
      private var typeToConverterMap:Map = new HashMap();
      
      public function DefaultConverterLookup(param1:IMapper)
      {
         super();
         this.mapper = param1;
      }
      
      public function registerConverter(param1:IConverter, param2:int) : void
      {
         var _loc4_:Class = null;
         if(param2 < 0)
         {
            converters.addAt(converters.lastIndexOf + 1,param1);
         }
         else
         {
            converters.addAt(0,param1);
         }
         var _loc3_:Iterator = this.typeToConverterMap.keyIterator();
         while(_loc3_.hasNext())
         {
            _loc4_ = Class(_loc3_.next());
            if(param1.canConvert(_loc4_))
            {
               _loc3_.remove();
            }
         }
      }
      
      public function lookupConverterForType(param1:Class) : IConverter
      {
         var _loc5_:IConverter = null;
         var _loc2_:IConverter = IConverter(typeToConverterMap.get(param1));
         if(_loc2_ != null)
         {
            return _loc2_;
         }
         var _loc3_:Class = mapper.defaultImplementationOf(param1);
         var _loc4_:Iterator = converters.iterator();
         while(_loc4_.hasNext())
         {
            _loc5_ = IConverter(_loc4_.next());
            if(_loc5_.canConvert(_loc3_))
            {
               typeToConverterMap.put(param1,_loc5_);
               return _loc5_;
            }
         }
         return null;
      }
   }
}

