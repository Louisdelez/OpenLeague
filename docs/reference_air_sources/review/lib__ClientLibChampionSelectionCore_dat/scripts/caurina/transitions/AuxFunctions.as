package caurina.transitions
{
   public class AuxFunctions
   {
      
      public function AuxFunctions()
      {
         super();
      }
      
      public static function concatObjects(... args) : Object
      {
         var finalObject:Object = null;
         var currentObject:Object = null;
         var i:int = 0;
         var prop:String = null;
         finalObject = {};
         for(i = 0; i < args.length; i++)
         {
            currentObject = args[i];
            for(prop in currentObject)
            {
               if(currentObject[prop] == null)
               {
                  delete finalObject[prop];
               }
               else
               {
                  finalObject[prop] = currentObject[prop];
               }
            }
         }
         return finalObject;
      }
      
      public static function numberToG(p_num:Number) : Number
      {
         return (p_num & 0xFF00) >> 8;
      }
      
      public static function numberToR(p_num:Number) : Number
      {
         return (p_num & 0xFF0000) >> 16;
      }
      
      public static function isInArray(p_string:String, p_array:Array) : Boolean
      {
         var l:uint = 0;
         var i:uint = 0;
         l = p_array.length;
         for(i = 0; i < l; i++)
         {
            if(p_array[i] == p_string)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function getObjectLength(p_object:Object) : uint
      {
         var totalProperties:uint = 0;
         var pName:String = null;
         totalProperties = 0;
         for(pName in p_object)
         {
            totalProperties++;
         }
         return totalProperties;
      }
      
      public static function numberToB(p_num:Number) : Number
      {
         return p_num & 0xFF;
      }
   }
}

