package flash.html.script
{
   [native(construct="native")]
   public class PropertyEnumHelper
   {
      
      private var m_propertyNames:Array;
      
      private var m_enumPropertiesClosure:Function;
      
      private var m_getPropertyClosure:Function;
      
      public function PropertyEnumHelper(enumPropertiesClosure:Function, getPropertyClosure:Function)
      {
         super();
         this.m_propertyNames = null;
         this.m_enumPropertiesClosure = enumPropertiesClosure;
         this.m_getPropertyClosure = getPropertyClosure;
      }
      
      public function nextNameIndex(lastIndex:int) : int
      {
         var nextIndex:int = 0;
         var realNextIndex:int = 0;
         try
         {
            nextIndex = 0;
            if(lastIndex == 0)
            {
               this.m_propertyNames = null;
               this.m_enumPropertiesClosure(function(propertyName:String):void
               {
                  if(m_propertyNames == null)
                  {
                     m_propertyNames = new Array();
                  }
                  m_propertyNames.push(propertyName);
               });
               if(this.m_propertyNames.length > 0)
               {
                  nextIndex = 0 << 1 | 1;
               }
            }
            else
            {
               realNextIndex = (lastIndex >> 1) + 1;
               if(realNextIndex < this.m_propertyNames.length)
               {
                  nextIndex = realNextIndex << 1 | 1;
               }
            }
         }
         catch(exception:*)
         {
            m_propertyNames = null;
            nextIndex = 0;
         }
         return nextIndex;
      }
      
      public function nextName(index:int) : String
      {
         var realIndex:int = index >> 1;
         var result:String = null;
         if(this.m_propertyNames != null && realIndex < this.m_propertyNames.length)
         {
            result = this.m_propertyNames[realIndex];
         }
         return result;
      }
      
      public function nextValue(index:int) : *
      {
         var propertyName:String = null;
         var realIndex:int = index >> 1;
         var result:* = undefined;
         if(this.m_propertyNames != null && realIndex < this.m_propertyNames.length)
         {
            propertyName = this.m_propertyNames[realIndex];
            result = this.m_getPropertyClosure(propertyName);
         }
         return result;
      }
   }
}

