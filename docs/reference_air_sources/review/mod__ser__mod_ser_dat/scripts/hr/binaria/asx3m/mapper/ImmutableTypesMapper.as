package hr.binaria.asx3m.mapper
{
   import system.data.sets.HashSet;
   
   public class ImmutableTypesMapper extends MapperWrapper
   {
      
      private var immutableTypes:HashSet;
      
      public function ImmutableTypesMapper(param1:IMapper)
      {
         super(param1);
         immutableTypes = new HashSet();
      }
      
      public function addImmutableType(param1:Class) : void
      {
         immutableTypes.add(param1);
      }
      
      override public function isImmutableValueType(param1:Class) : Boolean
      {
         if(immutableTypes.contains(param1))
         {
            return true;
         }
         return super.isImmutableValueType(param1);
      }
   }
}

