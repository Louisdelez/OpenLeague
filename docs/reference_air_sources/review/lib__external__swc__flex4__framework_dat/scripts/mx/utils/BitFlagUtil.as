package mx.utils
{
   [ExcludeClass]
   public class BitFlagUtil
   {
      
      public function BitFlagUtil()
      {
         super();
      }
      
      public static function isSet(flags:uint, flagMask:uint) : Boolean
      {
         return flagMask == (flags & flagMask);
      }
      
      public static function update(flags:uint, flagMask:uint, value:Boolean) : uint
      {
         if(value)
         {
            if((flags & flagMask) == flagMask)
            {
               return flags;
            }
            flags |= flagMask;
         }
         else
         {
            if((flags & flagMask) == 0)
            {
               return flags;
            }
            flags &= ~flagMask;
         }
         return flags;
      }
   }
}

