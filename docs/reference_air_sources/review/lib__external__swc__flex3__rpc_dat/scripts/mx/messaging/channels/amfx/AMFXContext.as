package mx.messaging.channels.amfx
{
   import mx.logging.ILogger;
   
   [ExcludeClass]
   public class AMFXContext
   {
      
      internal var strings:Array;
      
      internal var traits:Array;
      
      public var log:ILogger;
      
      internal var objects:Array;
      
      public function AMFXContext()
      {
         super();
         reset();
      }
      
      public function addObject(obj:Object) : void
      {
         objects.push(obj);
      }
      
      public function findTraitInfo(traitInfo:Object) : int
      {
         var ti:Object = null;
         var j:uint = 0;
         for(var i:uint = 0; i < traits.length; i++)
         {
            ti = traits[i];
            if(ti.alias == traitInfo.alias && ti.properties.length == traitInfo.properties.length)
            {
               for(j = 0; j < ti.properties.length; )
               {
                  if(ti.properties[i] != traitInfo.properties[j])
                  {
                     break;
                  }
                  j++;
               }
               if(j == traitInfo.properties.length)
               {
                  return i;
               }
            }
         }
         return -1;
      }
      
      public function getTraitInfo(ref:uint) : *
      {
         return traits[ref];
      }
      
      public function getString(ref:uint) : String
      {
         return strings[ref];
      }
      
      public function findString(str:String) : int
      {
         var i:uint = 0;
         var s:String = null;
         if(str != "")
         {
            for(i = 0; i < strings.length; i++)
            {
               s = strings[i];
               if(s == str)
               {
                  return i;
               }
            }
         }
         return -1;
      }
      
      public function reset() : void
      {
         traits = [];
         objects = [];
         strings = [];
      }
      
      public function addString(str:String) : void
      {
         if(str != "")
         {
            strings.push(str);
         }
      }
      
      public function getObject(ref:uint) : *
      {
         return objects[ref];
      }
      
      public function findObject(object:Object) : int
      {
         var o:Object = null;
         for(var i:uint = 0; i < objects.length; i++)
         {
            o = objects[i];
            if(o === object)
            {
               return i;
            }
         }
         return -1;
      }
      
      public function addTraitInfo(traitInfo:Object) : void
      {
         traits.push(traitInfo);
      }
   }
}

